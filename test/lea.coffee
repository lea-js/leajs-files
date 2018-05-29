{test, prepare, Promise, getTestID} = require "snapy"
try
  Lea = require "leajs-server/src/lea"
catch
  Lea = require "leajs-server"
http = require "http"
{writeFile, unlink} = require "fs-extra"

require "../src/plugin"

port = => 8081 + getTestID()

request = (path = "/") =>
  filter: "headers,statusCode,-headers.date,-headers.last-modified,body"
  stream: "":"body"
  promise: new Promise (resolve, reject) =>
    http.get Object.assign({hostname: "localhost", port: port(), agent: false}, {path: path}), resolve
    .on "error", reject
  plain: true

prepare (state, cleanUp) =>
  lea = await Lea
    config: Object.assign (state or {}), {
      listen:
        port:port()
      disablePlugins: ["leajs-files"]
      plugins: ["./src/plugin"]
      }
  cleanUp => lea.close()
  return state.files

test {files:{"/":"./test/file1"}}, (snap, files, cleanUp) =>
  # file1
  filename = files["/"]
  await writeFile filename, "file1"
  cleanUp => unlink filename
  snap request("/")

test {files:{"/":"./test/file2"}}, (snap, files, cleanUp) =>
  # 404 error
  snap request("/")