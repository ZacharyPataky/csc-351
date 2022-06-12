/*===========================+
|Zachary Pataky              |
|concord.pl                  |
|Created: 16 March 2021      |
|Last Modified: 01 April 2021|
+===========================*/

:- dynamic(line_number/1).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

concord :- print('Enter the file name: '),
	   read(Filename),
           see(Filename),
	   reset_all,
	   repeat,
	   read_in(Text),
	   process(Text),
	   peek_code(-1),
	   seen,
	   my_word_list(The_words),
	   print_the_words(The_words).

reset_all :- set_line_number,
             remove_appears,
             remove_my_word_list,
             asserta(my_word_list([])).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set_line_number :- line_number(X), retract(line_number(X)), set_line_number.
set_line_number :- asserta(line_number(0)).

remove_appears :- retract(appears(_, _, _)), remove_appears.
remove_appears.

remove_my_word_list :- retract(my_word_list(_)), remove_my_word_list.
remove_my_word_list.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*===========================================================================+
|Iterates through each word in a given line.  A new rule is asserted for each|
|    word using the word itself, the word's line number, and the instances of|
|    the word in the line.  If a recorded word is encountered, then the old  |
|    rule is replaced with an incremented [Count]-value.                     |
+===========================================================================*/

process([]).
process([Word|Line]) :- processHelper(Word), process(Line).

% Processes existing words.
processHelper(Word) :- line_number(LineNum),
                       retract(appears(Word, LineNum, Count)), !, 
                       NewCount is Count + 1, 
                       NewRule =.. [appears, Word, LineNum, NewCount],
                       assertz(NewRule).

% Processes new words and adds them to an alphabetized list of words.
processHelper(Word) :- line_number(LineNum),
                       WordRule =.. [appears, Word, LineNum, 1],
                       assertz(WordRule), insertWord(Word).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*=========================================================================+
|Accepts new words from predicate [processHelper(Word)] and adds them to an|
|     alphabetized list of words                                           |
+=========================================================================*/

% Inserts a new word into [my_word_list].
insertWord(Word) :- retract(my_word_list(OldList)),
                    insertWordHelper(Word, OldList, NewList),
                    asserta(my_word_list(NewList)).

% Inserts the word into the appropriate spot in [my_word_list].  Operates similar
%     to Insertion Sort.
insertWordHelper(Word, [], [Word]) :- !.
insertWordHelper(Word, [Word|Rest], [Word|Rest]) :- !.
insertWordHelper(Word, [First|Rest], [Word, First|Rest]) :- aless(Word, First),
                                                            !.
insertWordHelper(Word, [First|Rest], [First|Rester]) :- insertWordHelper(Word,
                                                        Rest, Rester).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*=========================================================================+
|Prints each word with the line numbers in which the specific word resides.|
+=========================================================================*/


% Prints each word and calls the appropriate helper functions for assistance.
print_the_words([]).
print_the_words([Word|Lines]) :- nl, write(Word), write(' '),
                                 print_the_wordsHelperLines(Word),
                                 print_the_words(Lines).

% Prints each word's line number(s).
print_the_wordsHelperLines(Word) :- retract(appears(Word, Line, Count)), !,
                                    write(Line),
                                    print_the_wordsHelperCount(Count),
                                    print_the_wordsHelperLinesHelper(Word).
print_the_wordsHelperLinesHelper(Word) :- retract(appears(Word, Line, Count)), !,
                                          write(', '), write(Line),
                                          print_the_wordsHelperCount(Count),
                                          print_the_wordsHelperLinesHelper(Word).
print_the_wordsHelperLinesHelper(Word).

% Prints the instance count of each word on a line.
print_the_wordsHelperCount(1).
print_the_wordsHelperCount(Count) :- write('('), write(Count), write(')').

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* code included from clocksin and mellish page 58 */
aless(X, Y) :- name(X, L), name(Y, M), alessx(L, M).
alessx([], [_|_]).
alessx([X|_], [Y|_]) :- X < Y.
alessx([P|Q], [R|S]) :- P = R, alessx(Q, S).
/* end include */

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* read in a sentence */
/* ignore punctuation */
read_in(X) :- peek_code(C),
              punct_char(C),
       	      get0(_),
              read_in(X).

/* at the end of line ? */
read_in([]) :- peek_code(10),
               get0(_),
               retract(line_number(X)), 
               X1 is X + 1, 
               asserta(line_number(X1)), 
               !.

/* not punctuation or end of line */
read_in([W|Ws]) :- read_token(W),
	           read_in(Ws), !.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/* punctuation characters */
punct_char(33).	/* ! */
punct_char(34).	/* " */
punct_char(40).	/* ( */
punct_char(41).	/* ) */
punct_char(44).	/* , */
punct_char(46).	/* . */
punct_char(58).	/* : */
punct_char(59).	/* ; */
punct_char(63).	/* ? */
