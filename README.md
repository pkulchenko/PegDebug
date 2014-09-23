# Project Description

PegDebug is a trace debugger for LPeg rules and captures.

## Features

PegDebug allows to trace the processing of LPeg rules and to visualize how
patterns are explored and matched as well as when captures are made.

PegDebug is based on a [prototype by Patrick Donnelly](http://lua-users.org/lists/lua-l/2009-10/msg00774.html),
which has been improved to provide formatted output, handle folding captures,
and report captures (with some [limitations](#limitations)).

## Usage

```lua
local grammar = require('pegdebug').trace(lpegGrammar, traceOptions)
lpeg.match(lpeg.P(grammar),"subject string")
```

## Example

The following example demonstrates the usage of PegDebug with default options:

```lua
local lpeg = require('lpeg')
local grammar = require('pegdebug').trace({ "List";
  NonNumber = lpeg.R('az');
  Number = lpeg.R"09"^1 / tonumber;
  List = lpeg.V("NonNumber") + lpeg.V("Number") * ("," * lpeg.V("Number"))^0;
})
print(lpeg.match(lpeg.P(grammar),"10,30,43"))
```

This will generate the following output:

```
+	List	1	"1"
 +	NonNumber	1	"1"
 -	NonNumber	1
 +	Number	1	"1"
 =	Number	1-2	"10"
 +	Number	4	"3"
 =	Number	4-5	"30"
 +	Number	7	"4"
 =	Number	7-8	"43"
=	List	1-8	"10,30,43"
/	Number	1	1	10
/	Number	4	1	30
/	Number	7	1	43
/	List	1	3	10, 30, 43
10	30	43
```

As you can see, the output shows all the patterns that LPeg explored ('+'),
matched ('='), and failed to match ('-'). The output includes the name
of the pattern, the range of positions and the content (in case of a match).
The output also includes all captures when they are produced.

## Options

* `out` (table) -- provide a table to store results instead of `printing` them;
* `only` (table) -- provide a table to specify which rules to include in the output;
* `serializer` (function) -- provide an alternative mechanism to serialize captured values;
* `'/'`, `'+'`, `'-'`, `'='` (boolean) -- disable handling of specific events;
for example, `['/'] = false` will disable showing captures in the output.

## Installation

Make `src/pegdebug.lua` available to your script.

## Limitations

PegDebug may return incorrect captures when folding captures are used;
for example, the following fragment will return `10`, instead of expected `83`:

```lua
local lpeg = require('lpeg')
local grammar = require('pegdebug').trace({ "Sum";
  NonNumber = lpeg.R('az');
  Number = lpeg.R"09"^1 / tonumber;
  List = lpeg.V("NonNumber") + lpeg.V("Number") * ("," * lpeg.V("Number"))^0;
  Sum = lpeg.Cf(lpeg.V("List"),
    function(acc, newvalue) return newvalue and acc + newvalue end);
})
print(lpeg.match(lpeg.P(grammar),"10,30,43"))
```

This is because the function capture used to report captures returns only one
capture, which breaks the folding capture (which expects a list of captures).

You may disable capture reporting by using `{['/'] = false}` or disable
capture reporting specifically for the rules that generate captures used
in folding: using `{['/'] = {List = false}}` will 'fix' this example.

## Author

Paul Kulchenko (paul@kulchenko.com)

## License

See LICENSE file
