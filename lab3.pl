/* База данных */
translation('catRus', 'catEng').
translation('dogRus', 'dogEng').
translation('birdRus', 'birdEng').

/* Перевод с одного языка на другой */
translate(X) :- translation(X,Y), print(Y).
translate(X) :- translation(Y,X), print(Y).

/* Вывод всего словаря */
dictionary :- translation(X,Y), print('Rus: '),  print(X), print(', Eng:'), print(Y).