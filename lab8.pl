/*----------------------------------------------------------------------*/
/* Создать базу данных с расписанием движения поездов: номер поезда,    */
/* пункт назначения, время отправления, время в пути, стоимость билета. */
/* Найти номер и время отправления самого скорого поезда до Москвы.     */
/*----------------------------------------------------------------------*/

% train(Number, ArrivalPoint, StartTime, RoadTime, TicketCost).

/* Открытие базы данных*/
start :- 							% если файл базы данных существует,
	exists_file('trains.db'), !,	% загружаемся из него
	consult('trains.db').
start :-
	openwrite(F, 'trains.db'),
	closefile(F).

/*Запись информации в базу данны*/
stop :-
	tell('trains.db'), listing, told,
	retractall(_).

/* Добавление новой записи */
add(Number, ArrivalPoint, StartTime, RoadTime, TicketCost) :-
	assertz(train(Number, ArrivalPoint, StartTime, RoadTime, TicketCost)).

/* Отображение всех записей в БД */
list_trains :- 
	train(Number, ArrivalPoint, StartTime, RoadTime, TicketCost),
	write(Number), write(' '), write(ArrivalPoint),write(' '), write(StartTime),write(' '), write(RoadTime),write(' '), write(TicketCost), nl,fail.
list_trains.
list :- write('Number | Arrival point | Start time | Road time | Ticket cost'), nl, list_trains.

/* Нахождение номеров и времени отправления поездов, */
/* идущих за минимально время из Москвы              */
find_fast(Number, Time, RoadTime) :- train(Number, 'Moskow', Time, RoadTime, _).

/* Поиск минимального значения из предикатов */
ismin(Time) :- train(_,'Moskow',_, OtherTime,_), OtherTime > Time, !, fail.
ismin(_).

/* Нахождение минимального времени движения поезда */
fast_time(Time) :- train(_,'Moskow',_, Time,_), 
				   ismin(Time).

find(Number, StartTime) :- 	fast_time(RoadTime), 
							find_fast(Number, StartTime, RoadTime), !.