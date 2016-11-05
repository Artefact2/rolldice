/* Author: Romain "Artefact2" Dal Maso <artefact2@gmail.com> */

/* This program is free software. It comes without any warranty, to the
 * extent permitted by applicable law. You can redistribute it and/or
 * modify it under the terms of the Do What The Fuck You Want To Public
 * License, Version 2, as published by Sam Hocevar. See
 * http://sam.zoy.org/wtfpl/COPYING for more details. */

%{
	#include "rolldice.h"
	#include "rolldice.tab.h"
%}

%%

[0-9]+ { yylval.i = strtol(yytext, NULL, 10); return INTEGER; }
"d" { return DIE; }
"h" { return DROPHIGH; }
"l" { return DROPLOW; }
"r" { return REROLL; }
"rr" { return REROLLREC; }
"rh" { return REROLLHIGH; }
"rl" { return REROLLLOW; }
"+" { return PLUS; }
"-" { return MINUS; }
"*" { return TIMES; }
"/" { return DIVIDEUP; }
"\\" { return DIVIDEDOWN; }
"(" { return OPENPAREN; }
")" { return CLOSEPAREN; }
\n { return ENDLINE; }
\s { }

%%

