module.exports =
  files: 
    type: Object
    default: {}
    desc: "Lookup to translate a url into a filepath"
  files$_item: 
    types: [Object,String]
    desc: "File options, can be used as a shortcut for files.$item.file"
  files$_item$file: 
    type: String
    desc: "Filepath, absolute or relative to CWD"