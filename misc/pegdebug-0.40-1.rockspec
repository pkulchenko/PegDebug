package = "PegDebug"
version = "0.40-1"

source = {
   url = "git://github.com/pkulchenko/PegDebug.git",
   tag = "0.40"
}

description = {
   summary = "PegDebug is a trace debugger for LPeg rules and captures.",
   detailed = "PegDebug is a trace debugger for LPeg rules and captures.",
   homepage = "http://github.com/pkulchenko/PegDebug",
   license = "MIT/X11",
}

dependencies = {
   "lua >= 5.1",
}

build = {
   type = "builtin",
   install = {
      lua = { pegdebug = "src/pegdebug.lua" }
   },
}
