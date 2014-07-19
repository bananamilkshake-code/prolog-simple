/*--------------------------------------------------------------------*/
/* Разработайте экспертную систему по идентификация садовых растений  */
/* (огурцы, томаты, лук, яблоня, вишня, смородина, крыжовник и т.д.). */
/*--------------------------------------------------------------------*/

/* Описания растений */
plant('cucumber') :- positive('green'),
				positive('neutral'),
				it_is('vegetable'), !.
plant('tomato') :- positive('red'),
				positive('neutral'),
				it_is('vegetable'), !.
plant('onion') :- positive('white'),
				positive('bitter'),
				it_is('vegetable'), !.
plant('apple') :- positive('green'),
				positive('red'),
				positive('yellow'),
				positive('sweet'),
				positive('acid'),				
				it_is('fruit').
plant('cherry') :- positive('red'),
				positive('sweet'),
				it_is('berry').
plant('currant') :- positive('black'),
				positive('sweet'),				
				it_is('berry').
plant('gooseberry') :- positive('green'),
				positive('sweet'),
				positive('acidic'),
				it_is('berry').
plant('lemon') :- positive('yellow'),
				positive('acidic'),
				it_is('fruit').
it_is('fruit') :- positive('tree').
it_is('berry') :- positive('ground').
it_is('vegetable') :- positive('ground').


/*--------------------------------------------------------*/

/* Работа с динамической базой данных */
positive(X) :- xpositive(X), !.
positive(X) :- xnegative(X), !, fail.
positive(X) :- ask(X,'y').

negative(X) :- xnegative(X), !.
negative(X) :- xpositive(X), !, fail.
negative(X) :- ask(X,'n').

ask(X, R) :- 
			write(X), write('? : '), 
			read(Reply), 
			write(Reply), nl,
			remember(X,Reply), R = Reply.

/* Проверка присутствия фактов в динамической БД*/
xpositive(X) :- yes(X).
xpositive(X) :- maybe(X).

xnegative(X) :- no(X).
xnegative(X) :- maybe(X).

/* Запоминаем факт в динамической БД */
remember(X,'y') :- asserta(yes(X)).
remember(X,'n') :- asserta(no(X)).
remember(X,'q') :- asserta(maybe(X)).


/* Очищаем память от фактов БД */
delete_all :- retract(yes(_)), delete_all.
delete_all :- retract(no(_)), delete_all.
delete_all :- retract(maybe(_)), delete_all.
delete_all.

/* Программа */
run :- 
		delete_all,
		write('Answer questions (y - positive, n - negative, q - do not know)'), nl,
		plant(X),
		write('This plant is: '), write(X), nl,
		write('End program? (y/n)'), readln(Z),
		write(Z), nl,
		Z='y', !, run.