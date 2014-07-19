/*-----------------------------------------------------------*/
/* Создайте предикат, дополняющий все строки,                 */
/* хранящиеся в файле, символом "*" до самой длинной строки. */
/*-----------------------------------------------------------*/

max_string_length([], _) :- !, fail.
max_string_length([String], MaxLength) :- string_length(String, MaxLength).
max_string_length([String|Tail], MaxLength) :- 
						max_string_length(Tail, SubMaxLength),
						string_length(String, Length),
						SubMaxLength > Length, !, MaxLength = SubMaxLength.
max_string_length([String|Tail], MaxLength) :- 
						max_string_length(Tail, SubMaxLength),
						string_length(String, Length),
						MaxLength = Length.


complete(String, MaxLength, String) :- string_length(String, MaxLength), !.	% если длина строки равна наибольшей длине
																				% то не дополняем строку
complete(String, MaxLength, CompletedString) :- concat(String, '*', S),				% добавляем сивол * в конец строки,
												complete(S, MaxLength, T),				% рекурсивно вызываем функцию добавления 
												CompletedString = T, !.				% символа * к строке


complete_strings([], MaxLength, []).
complete_strings([String|Tail], MaxLength, [CompletedString|CompletedTail]) :- 
												complete(String, MaxLength, CompletedString),
												complete_strings(Tail, MaxLength, CompletedTail).


write_strings(Strings) :- 
							max_string_length(Strings, MaxLength), 
							complete_strings(Strings, MaxLength, L),
							write(L).


file_max_string_length(Input, 0):- at_end_of_stream(Input).
file_max_string_length(Input, MaxLength) :- readln(Input, String), 
											file_max_string_length(Input, CurrentMaxLength),
											max_string_length(String, CurrentMaxLength, MaxLength).


read_file_name(FileName, L) :-  open(FileName, read, Input), 
								read_until_stop(Input, L).

read_until_stop(File, [L|Lines]) :-
    read_line_to_codes(File, Codes), 
    Codes \= end_of_file, !,
    atom_codes(L, Codes),
    read_until_stop(File, Lines).
read_until_stop(_, []).

write_to_file(L) :- open('output.txt', write, Output),
					write_completed(L, Output),
					close(Output).

write_completed([], _) :- !.
write_completed([Head|Tail], Output) :- write(Output, Head), nl(Output),
										write_completed(Tail, Output).

complete_strings_in_file(FileName) :-  read_file_name(FileName, L),
							max_string_length(L, MaxLength), 
							complete_strings(L, MaxLength, Strings),
							write_to_file(Strings).