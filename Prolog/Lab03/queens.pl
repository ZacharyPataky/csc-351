/*===========================+
|Zachary Pataky              |
|queens.pl                   |
|Created: 22 February 2021   |
|Last Modified: 04 March 2021|
+===========================*/

queens(N, Queen_places) :- range(1, N, N_list),
			               my_permutation(N_list, Queen_places),
			               safe(Queen_places),
			               print_board(Queen_places, N).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*===========================================================================+
|Assists in printing the board by outputting the contents of each row        |
|    sequentially.  When a row is finished, the next row is analyzed.        |
|Contains helper-functors that determine the condition of each coordinate.   |
|    Each coordinate either has a Queen or nothing, so they determine whether|
|    to output "|Q" or "|".  There are additional cases to account for the   |
|    beginning and end of each row for the opening/closing "|".              |
+===========================================================================*/

% The number of Queens is also the number of size of each boars' length/width.
print_board(Qplace, Qnum):- nl, print_boardHelper(Qplace, Qnum).

% Writes the contents of each row, concluding with ('|').
print_boardHelper([Qpos|Rows], Qnum):- writeBars(Qnum), nl,
                                       writeChar(Qpos, Qnum, 0), write('|'), nl,
                                       print_boardHelper(Rows, Qnum).
print_boardHelper([], Qnum):- writeBars(Qnum).


% Condition for Empty-Space before Queen.
writeChar(Qpos, Space, Pos):- Qpos > 1, Pos =:= 0, QposLeft is Qpos - 1,
                              SpaceLeft is Space - 1, write('| '),
                              writeChar(QposLeft, SpaceLeft, Pos).
% Condition for Queen-Space.
writeChar(Qpos, Space, Pos):- Qpos =:= 1, Pos < 1, Space > 0,
                              SpaceLeft is Space - 1, write('|Q'),
                              writeCharHelper(SpaceLeft, 1).

% Condition for Empty-Space after Queen.
writeCharHelper(Space, Pos):- Pos > 0, Space > 0, SpaceLeft is Space - 1,
                              write('| '), writeCharHelper(SpaceLeft, Pos).
writeCharHelper(0, 1).

% Writes the horizontal bars ("--") that distinguish rows.
writeBars(Pos):- write('--'), Pos > 0, PosLeft is Pos - 1, writeBars(PosLeft).
writeBars(0).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

my_permutation(Xs, [Z|Zs]) :- myselect(Z, Xs, Ys), my_permutation(Ys, Zs).
my_permutation([], []).

myselect(X, [X|Xs], Xs).
myselect(X, [Y|Ys], [Y|Zs]) :- myselect(X, Ys, Zs).

range(M, N, [M|Ns]) :- M < N, M1 is M + 1, range(M1, N, Ns).
range(N, N, [N]).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

/*========================================================================+
|Iterates through [Qrow], ensuring that each row's Queen is safe.  Does so|
|    by determining if Queens lower in the board cannot be attacked by the|
|    current Queen.                                                       |
+========================================================================*/

safe([Qrow|Qrows]) :- \+ (attacked(Qrow, Qrows)), safe(Qrows).
safe([]).

/*==========================================================================+
|Determines whether Queens can attack other Queens lower in the board.      |
|[Diff] is used to check the lower-diagonal coordinates. It's equal to the  |
|    difference between the current row and the row that hosts the [Queen]. |
|Studies all lower rows since looking upward is redunant from previous runs.|
+==========================================================================*/

attacked(Qrow, Qrows) :- attackedHelper(Qrow, 1, Qrows).
attackedHelper(Qrow, Diff, [bRow|bRows]) :- (Qrow =:= bRow + Diff ;
                                            Qrow =:= bRow - Diff).
attackedHelper(Qrow, Diff, [bRow|bRows]) :- NewDiff = Diff + 1,
                                            attackedHelper(Qrow, NewDiff, bRows).