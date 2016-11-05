rolldice: rolldice.tab.c lex.yy.c
	clang -o $@ --std=c11 -Wall -Wextra -pedantic rolldice.tab.c lex.yy.c -lfl -lm

rolldice.tab.c rolldice.tab.h: rolldice.y
	bison -d $<

lex.yy.c: rolldice.l
	flex $<
