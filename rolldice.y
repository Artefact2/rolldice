/* Author: Romain "Artefact2" Dal Maso <artefact2@gmail.com> */

/* This program is free software. It comes without any warranty, to the
 * extent permitted by applicable law. You can redistribute it and/or
 * modify it under the terms of the Do What The Fuck You Want To Public
 * License, Version 2, as published by Sam Hocevar. See
 * http://sam.zoy.org/wtfpl/COPYING for more details. */

%{
	#include <stdio.h>
	#include <stdlib.h>
	#include <stdbool.h>
	#include <math.h>
	#include "rolldice.h"

	rolls_t* rolls(int, int);
	void drop(rolls_t*, bool high, int count);
	void reroll(rolls_t*, bool recursive, int val);
	void drop_and_reroll(rolls_t*, bool high, int count);
%}

%union {
	int i;
	rolls_t* r;
}

%token <i> INTEGER
%token DIE DROPHIGH DROPLOW REROLL REROLLREC REROLLHIGH REROLLLOW
%token PLUS MINUS TIMES DIVIDEUP DIVIDEDOWN
%token OPENPAREN CLOSEPAREN ENDLINE

%left PLUS MINUS
%left TIMES DIVIDEUP DIVIDEDOWN
%left DIE

%type <i> expr evaledrolls
%type <r> rolls

%%

result:
| result expr ENDLINE { printf("Result: %d\n", $2); }
;
	 
expr: INTEGER
| evaledrolls
| OPENPAREN expr CLOSEPAREN { $$ = $2; }
| expr PLUS expr { $$ = $1 + $3; }
| expr MINUS expr { $$ = $1 - $3; }
| expr TIMES expr { $$ = $1 * $3; }
| expr DIVIDEUP expr { $$ = (int)ceil((double)$1 / (double)$3); }
| expr DIVIDEDOWN expr { $$ = (int)floor((double)$1 / (double)$3); }
;

rolls: expr DIE expr { $$ = rolls($3, $1); }
| DIE expr { $$ = rolls($2, 1); }
| rolls DROPHIGH expr { drop($1, true, $3); }
| rolls DROPLOW expr { drop($1, false, $3); }
| rolls REROLL expr { reroll($1, false, $3); }
| rolls REROLLREC expr { reroll($1, true, $3); }
| rolls REROLLHIGH expr { drop_and_reroll($1, true, $3); }
| rolls REROLLLOW expr { drop_and_reroll($1, false, $3); }
;

evaledrolls: rolls { $$ = evalrolls($1); }
;

%%

rolls_t* rolls(int sides, int count) {
	if(sides < 0 || count < 0) yyerror("not rolling negative dice");
	
	int roll;
	char* pool = malloc(sizeof(rolls_t) + count * sizeof(int));
	rolls_t* r = (rolls_t*)pool;
	r->n = count;
	r->s = sides;
	r->rolls = (int*)(pool + sizeof(rolls_t));
        
	printf("Rolling %dd%d:", count, sides);

	for(int i = 0; i < count; ++i) {
		roll = 1 + (rand() % sides);
		r->rolls[i] = roll;
		printf(" %d", roll);
	}

	printf("\n");
	return r;
}

void drop(rolls_t* r, bool high, int count) {
	if(count < 0) yyerror("not dropping negative amount of dice");
	if(r->n == 0) return;

	printf("Dropping %d %s\n", count, high ? "highest" : "lowest");

	int eidx, i;

	while((count--) > 0) {
		eidx = -1;
		
		for(i = 0; i < r->n; ++i) {
			if(eidx == -1) {
				if(r->rolls[i] > 0) eidx = i;
				continue;
			}
			
			if(r->rolls[i] == 0) {
				continue;
			}
			
			if(high ? (r->rolls[i] <= r->rolls[eidx]) : (r->rolls[i] >= r->rolls[eidx])) continue;
			eidx = i;
		}

		if(eidx == -1) break;
		
		r->rolls[eidx] = 0;
	}
}

void reroll(rolls_t* r, bool recursive, int val) {
	printf("Rerolling %ds %s\n", val, recursive ? "recursively" : "once");

	int rerolled, i;

	do {
		rerolled = 0;
		for(i = 0; i < r->n; ++i) {
			if(r->rolls[i] == val) {
				r->rolls[i] = 1 + (rand() % r->s);
				printf("Rerolled a %d\n", r->rolls[i]);
			}
		}
	} while(recursive && rerolled > 0);
}

void drop_and_reroll(rolls_t* r, bool high, int count) {
	if(count < 0) yyerror("not dropping negative amount of dice");
	if(r->n == 0) return;

	printf("Rerolling %d %s\n", count, high ? "highest" : "lowest");

	int eidx, i;

	while((count--) > 0) {
		eidx = -1;
		
		for(i = 0; i < r->n; ++i) {
			if(eidx == -1) {
				if(r->rolls[i] > 0) eidx = i;
				continue;
			}
			
			if(r->rolls[i] < 0) {
				continue;
			}
			
			if(high ? (r->rolls[i] <= r->rolls[eidx]) : (r->rolls[i] >= r->rolls[eidx])) continue;
			eidx = i;
		}

		if(eidx == -1) break;
		
		r->rolls[eidx] = -(1 + (rand() % r->s));
		printf("Rerolled a %d\n", -(r->rolls[eidx]));
	}

	for(i = 0; i < r->n; ++i) {
		if(r->rolls[i] < 0) {
			r->rolls[i] = -(r->rolls[i]);
		}
	}
}

int evalrolls(rolls_t* r) {
	int sum = 0;
	for(int i = 0; i < r->n; ++i) {
		sum += r->rolls[i];
	}

	free(r);
	return sum;
}

int main(void) {
	int seed;
	FILE* f;
	f = fopen("/dev/urandom", "rb");
	fread(&seed, sizeof(int), 1, f);
	fclose(f);	
	srand(seed);

	yyparse();
	return 0;
}

int yyerror(char* s) {
	fprintf(stderr, "Error: %s\n", s);
	exit(1);
}
