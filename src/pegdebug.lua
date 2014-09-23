--
-- PegDebug -- A debugger for LPeg expressions and processing
-- Copyright 2014 Paul Kulchenko
--

local pegdebug = {
  _NAME = "pegdebug",
  _VERSION = 0.40,
  _COPYRIGHT = "Paul Kulchenko",
  _DESCRIPTION = "Debugger for LPeg expressions and processing",
}

function pegdebug.trace(grammar, opts)
  opts = opts or {}
  local serpent = opts.serializer
    or pcall(require, "serpent") and require("serpent").line
    or pcall(require, "mobdebug") and require("mobdebug").line
    or nil
  local function line(s) return (string.format("%q", s):gsub("\\\n", "\\n")) end
  local function pretty(...)
    if serpent then return serpent({...}, {comment = false}):sub(2,-2) end
    local res = {}
    for i = 1, select('#', ...) do
      local v = select(i, ...)
      local tv = type(v)
      res[i] = tv == 'number' and v or tv == 'string' and line(v) or tostring(v)
    end
    return table.concat(res, ", ")
  end
  local level = 0
  local start = {}
  local print = print
  if type(opts.out) == 'table' then
    print = function(...) table.insert(opts.out, table.concat({...}, "\t")) end
  end
  for k, p in pairs(grammar) do
    local enter = lpeg.Cmt(lpeg.P(true), function(s, p, ...)
        start[level] = p
        if opts['+'] ~= false then
          print((" "):rep(level).."+", k, p, line(s:sub(p,p)))
        end
        level = level + 1
        return true
      end)
    local leave = lpeg.Cmt(lpeg.P(true), function(s, p, ...)
        level = level - 1
        if opts['-'] ~= false then
          print((" "):rep(level).."-", k, p)
        end
        return true
      end) * (lpeg.P(1) - lpeg.P(1))
    local eq = lpeg.Cmt(lpeg.P(true), function(s, p, ...)
        level = level - 1
        if opts['='] ~= false then
          print((" "):rep(level).."=", k, start[level]..'-'..(p-1), line(s:sub(start[level],p-1)))
        end
        return true
      end)
    if k ~= 1 and (not opts.only or opts.only[k]) then
      if opts['/'] ~= false
      and (type(opts['/']) ~= 'table' or opts['/'][k] ~= false) then
        -- lpeg.Cp() is needed to only get captures (and not the whole match)
        p = lpeg.Cp() * p / function(pos, ...)
            print((" "):rep(level).."/", k, pos, select('#', ...), pretty(...))
            return ...
          end
      end    
      grammar[k] = enter * p * eq + leave
    end
  end
  return grammar
end

return pegdebug
