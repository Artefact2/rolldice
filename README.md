Synopsis
========

rolldice, a very simple interpreter for rolling dice.

A toy project that uses GNU flex and GNU bison, released under the
WTFPLv2.

Usage
=====

* `rolldice` (interactive REPL mode)
* `rolldice < rolls.txt` (batch mode)

Syntax
======

Rolling dice:

* `dY` to roll one Y-sided die
* `XdY` to roll X Y-sided die and add the result

Rolling modifiers (multiple can be specified in any order after the roll):

* `hZ` drop Z highest results
* `lZ` drop Z lowest results
* `rZ` reroll all Z once
* `rrZ` reroll all Z recursively
* `rhZ` reroll Z highest results
* `rlZ` reroll Z lowest results

Simple math operators are also supported:

* `+` for addition.
* `-` for substraction.
* `*` for multiplication.
* `/` for integer division (rounds up).
* `\` for integer division (rounds down).
* `(…)` for forcing precedence.

Nested operations are also supported:

* `(d4)d4` will roll a d4, then roll the rolled amount of d4s.
* `(d6)d(d12)`, etc.

Examples
========

* `d6` roll a six-sided die.
* `2d10` roll two ten-sided die and add the result.
* `d20+7` roll a d20 and add 7 to the result.
* `4d6l1` roll 4d6 and drop the lowest die.
* `3d6r1` roll 3d6 and reroll ones.
* `5d6rl2` roll 5d6 and reroll the two lowest dice.
* `4d6l1r1` roll 4d6, drop the lowest result, reroll ones
* `4d6r1l1` roll 4d6, reroll ones, drop the lowest result

* `(2d8+3)/2` roll 2d8+3, divide the result by 2, round up
* `(4d4+1)\2` roll 4d4+1, divide the result by 2, round down

Todo/Ideas
==========

* Critical hit/fumble
* Advantage/disadvantage
* User functions/macros
* Comparison operators, control logic
