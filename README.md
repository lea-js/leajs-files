# leajs-files

Plugin of [leajs](https://github.com/lea-js/leajs-server).

Serves files.

## leajs.config

```js
module.exports = {

  // …

  // Lookup to translate a url into a filepath
  // $item ([Object, String]) Folder options, can be used as a shortcut for folders.$item.file
  // $item.file (String) Filepath, absolute or relative to CWD
  files: {}, // Object

  // …

}
```

## License
Copyright (c) 2018 Paul Pflugradt
Licensed under the MIT license.
