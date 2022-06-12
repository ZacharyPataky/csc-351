/*===========================+
|Zachary Pataky              |
|fib3.pl                     |
|Created: 18 February 2021   |
|Last Modified: 18 March 2021|
+===========================*/

:- dynamic(fib/2).

% This rule outputs the user's inputted fibonacci number by building upon all the
%     fibonacci values before it.  For instance, it gets the third fibonacci
%      number by summing the first and second fibonacci numbers.  It then 
%      creates a new fact for this fibonacci number.
fib(X, Y) :- X1 is X - 1, X2 is X - 2, fib(X1, Y1), fib(X2, Y2),
             Y is Y1 + Y2, asserta(fib(X, Y)).

% These rules reads in the fibonacci numbers from file [fibData].  They then
%      create new rules in [fib3.pl] from this read data by asserting consecutive
%      words/values.  For instance, the first two lines (one word/value on each)
%      will be asserted to create the rule that represents those lines.  These
%      rules are then used to help [fib/2] determine fibonacci values.
readit :- see(fibData), readitHelper, seen.
readitHelper :- read(X), read(Y), X \== end_of_file, Y \== end_of_file,
                asserta(fib(X, Y)), readitHelper.
readitHelper.

% These rules retract the rules from [fib3.pl] and store them back into
%      [fibData].  It does so by taking the [X] and [Y] values from each rule
%      writing them seperately and consecutively with a period following each
%      value. 
saveit :- tell(fibData), saveitHelper, told.
saveitHelper :- retract(fib(X, Y)), write(X), write('.'), nl, write(Y),
                write('.'), nl, saveitHelper.
saveitHelper.

