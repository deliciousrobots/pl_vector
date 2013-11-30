%% pl_vector.pl
%% vector predicates for swi-prolog

vector_length(Vector, Length) :-
        functor(Vector, vector, Length).

vector_at(Vector, Index, Value) :-
        number(Index),
        !,
        Arg is Index + 1,
        arg(Arg, Vector, Value).

vector_at(Vector, Index, Value) :-
        arg(Arg, Vector, Value),
        Index is Arg - 1.

vector_each_aux(Vector, CurrIndex, Length, Pred) :-
        vector_at(Vector, CurrIndex, Value),
        call(Pred, Value),
        NewIndex is CurrIndex + 1,
        ( NewIndex < Length ->
          vector_each_aux(Vector, NewIndex, Length, Pred)
        ; true ).

vector_each(Vector, Pred) :-
        functor(Vector, _, Length),
        ( Length > 0 ->
          vector_each_aux(Vector, 0, Length, Pred)
        ; true ).

vector_list(Vector, List) :-
        Vector =.. [vector|List].

:- begin_tests(vector).

test(vector_at) :-
        vector_length(V, 3),
        vector_at(V, 1, hello),
        vector_at(V, 0, ok),
        vector_at(V, 2, world),
        V = vector(ok,hello,world).

test(vector_at) :-
        vector_list(V, [1,2,2,3,4]),
        findall(Index, vector_at(V, Index, 2), Indexes),
        Indexes = [1,2].

test(vector_length) :-
        vector_length(V, 3),
        V = vector(_,_,_).

test(vector_each) :-
        vector_length(V, 5),
        vector_each(V, =(hello)),
        V = vector(hello, hello, hello, hello, hello).

:- end_tests(vector).
        