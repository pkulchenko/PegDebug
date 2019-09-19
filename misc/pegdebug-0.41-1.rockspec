package = "PegDebug"
version = "0.41-1"

source = {
   url = "git://github.com/pkulchenko/PegDebug.git",
   tag = "0.41",
}

description = {
   summary = "PegDebug is a trace debugger for LPeg rules and captures.",
   detailed = "PegDebug is a trace debugger for LPeg rules and captures.",
   homepage = "http://github.com/pkulchenko/PegDebug",
   maintainer = "Paul Kulchenko <paul@kulchenko.com>",
   license = "MIT/X11",
}

dependencies = {
   "lua >= 5.1",
   "lpeg",
}

build = {
   type = "builtin",
   modules = {
      ["pegdebug"] = "src/pegdebug.lua",
   },
}
