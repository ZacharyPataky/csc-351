/*===========================+
|Zachary Pataky              |
|people.pl                   |
|Created: 10 February 2021   |
|Last Modified: 16 March 2021|
+===========================*/

:- discontiguous(citizen_of/2).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Sample Definitions
% Rule: Head :- Body.
% Fact: Head.
% Predicate: Follows the Head; father(david, peter).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*====+
|RULES|
+====*/

% X is a citizen of Y if X has a parent who is a citizen of country Y.
citizen_of(X, Y) :- parent_of(A, X), citizen_of(A, Y).

% X is a sibling of Y if X and Y share the same mother and father; X cannot be Y.
sibling_of(X, Y) :- mother(A, X), mother(A, Y), father(B, X), father(B, Y),
                    X \== Y.

% X is a sister of Y if X is a sibling of Y (above) and X is female.
sister_of(X, Y) :- sibling_of(X, Y), female(X).

% X is a brother of Y if X is a sibling of Y (above) and X is male.
brother_of(X, Y) :- sibling_of(X, Y), male(X).

% X is an aunt of Y if X is a sister of the parent of Y.
aunt_of(X, Y) :- parent_of(A, Y), sister_of(X, A).

% X is an uncle of Y if X is a brother of the parent Y.
uncle_of(X, Y) :- parent_of(A, Y), brother_of(X, A).

% X is the parent of Y if X is a father or mother of Y.
parent_of(X, Y) :- father(X, Y); mother(X, Y). % Added

% This returns a series of fathers with their respective children.
allFathers :- father(X, Y), write(X), write(' is the father of '),
              write(Y), nl, fail.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*=========+
|PREDICATES|
+=========*/

father(david, peter).
father(peter, harold).
father(peter, helen).
father(peter, sherry).
father(harold, christopher).

mother(maude, peter).
mother(martha, harold).
mother(martha, helen).
mother(martha, sherry).
mother(helen, arnold).
mother(sherry, sonya).

male(david).
male(peter).
male(harold).
male(christopher).
male(arnold).

female(maude).
female(martha).
female(helen).
female(sherry).
female(sonya).

citizen_of(peter, unitedstates).
citizen_of(maude, canada).
