/*==============================+
|Zachary Pataky                 |
|sample.pl                      |
|Created: 10 February 2021      |
|Last Modified: 11 February 2021|
+==============================*/

%%% - Indicates a correction in the line.

:- discontiguous(has/2).
:- discontiguous(playing/2).

happy(tom):- watching(tom, bills), has(tom, supplies). %%%
happy(mary) :- can_pay(mary, bills).
happy(mary) :- \+ (owes_for(mary, bills)).
happy(dave) :- weather(sunny), temperature(hot).
happy(anne) :- happy(dave), \+ (happy(tom)), happy(mary). 
happy(anne) :- \+ (happy(dave)), happy(tom), \+ (happy(mary)). %%%
happy(anne) :- \+ (happy(dave)), happy(tom), happy(mary).
happy(steve) :- competing(steve, jim, tennis).
happy(steve) :- competing(steve, sue, golf).
happy(steve) :- competing(steve, Anyone, baseball).
happy(carol) :- watching(carol, sabres), has(carol, supplies). %%%
has(X, supplies):- has(X, pop), has(X, pretzels).
has(X, supplies):- has(X, pop), has(X, chips).
watching(tom, bills):- is_on(toms_tv), playing(bills, football). 
watching(carol, sabres):- is_on(carols_tv), playing(sabres, hockey). 
can_pay(X, Y) :- has(X, money), owes_for(X, Y).
competing(X, Y, Sport) :- playing(X, Sport), playing(Y, Sport), opponents(X, Y). %%%
playing(steve, baseball). %%%
playing(bob, baseball).
opponents(steve, bob). %%%
playing(jim, tennis).
playing(sue, golf).
is_on(toms_tv). %%%
is_on(carols_tv). %%%
playing(bills, football).
has(tom, pop).
has(mary, money).
weather(sunny). %%%
temperature(mild).
has(tom, pretzels).
playing(sabres, hockey).
has(carol, chips).
has(carol, pop).
owes_for(dave, dinner).

