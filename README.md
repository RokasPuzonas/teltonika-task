# Teltonika back-end task

Implement a function that receives two IPv4 addresses and returns the number of
addresses between them (including the first one, excluding the last one).

All inputs must be valid IPv4 addresses in the form of strings. The last
address must be greater than the first one.

## Usage

```shell
$ ./main.lua <address> <address>
```

## Examples

* “10.0.0.0” “10.0.0.50” => 50
* “10.0.0.0” “10.0.1.0” => 256
* “20.0.0.10” “20.0.1.0” => 246

## Rules

* The solution must work as a linux terminal program. IP addresses must be
	provided as arguments for the program.
* The program can be written in any language, but using Lua is a plus.
* Provide instruction on how to compile/run the program.
* Linux or external modules/libraries/functions should not be used.

## Extra

The program could also receive a IPv6 addresses for comparison. Provided types
could be differentiated by an extra argument.
