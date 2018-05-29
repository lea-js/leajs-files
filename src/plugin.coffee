
module.exports = ({init}) => init.hookIn ({
  config:{files, index}
  cache: {save}
  fs:{stat,createReadStream},
  util: {isString},
  path: {resolve}, 
  respond,
  position}) =>
  save.file = perm: true
  save.stats = 
    perm: false
    serialize: (val) => size: val.size, mtime: val.mtime
    deserialize: (val) => size: val.size, mtime: new Date(val.mtime)

  mime = require "mime"
  getFile = (req, filename) =>
    stats = await stat filename
    if stats.isDirectory()
      filename = resolve filename, index
      stats = await stat filename
    req.stats = stats
    req.file = filename
    req.dependencies ?= []
    req.dependencies.push filename unless ~req.dependencies.indexOf(filename)
    type = mime.getType(filename)
    if type
      req.head.contentType = type
      req.encode = ~type.indexOf("text") or ~type.indexOf("application")

  
  for k,v of files
    if isString(v)
      files[k] = file: resolve(v)
    else
      v.file = resolve(v.file)

  if Object.keys(files).length > 0
    respond.hookIn (req) =>
      if not req.body? and not req.file? and (o = files[req.url])?
        Object.assign req, o

  respond.hookIn position.init, (req) =>
    req.getFile = getFile.bind(null,req)

  respond.hookIn position.during+1, (req) =>
    if not req.body? and not req.stats? and (filename = req.file)?
      req.getFile(filename)
      .catch (e) =>
        notfound = ['ENOENT', 'ENAMETOOLONG', 'ENOTDIR']
        unless ~notfound.indexOf(e.code)
          throw 500
        else
          throw 404

  respond.hookIn position.after, (req) =>
    if not req.body? and (file = req.file)? and (stats = req.stats)? 
      req.body = createReadStream file

module.exports.configSchema = require("./configSchema")
