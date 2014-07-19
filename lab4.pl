/* Предметная область – база данных продажи автомобилей. Каждый автомобиль может 
быть описана структурой: марка автомобиля, страна фирмы-изготовителя, список 
фирм-продавцов. Фирма-продавец может быть описана структурой: название фирмы, 
страна, список имеющихся моделей. Модель может быть описана структурой: 
наименование модели, цена, список имеющихся расцветок.
Описать следующие правила:
a) поиск марки автомобиля, которую продает больше всего фирм;
b) поиск числа стран, в которых продаются автомобили заданной марки;
c) поиск всех фирм, продающих автомобили заданной марки;
d) поиск всех моделей автомобилей, цена которых ниже заданной;
e) поиск всех фирм, которые продают автомобили заданной модели. */

% автомобили
car('VAZ', 'Russia', 'red', 'Best cars').
car('VAZ', 'Russia', 'yellow', 'Best cars').
car('VAZ', 'Russia', 'red', 'Smith Auto').
car('VAZ', 'Russia', 'yellow', 'Smith Auto').
car('GAZ', 'Ukraine', 'green', 'Autohit').
car('GAZ', 'Ukraine', 'purple', 'Autohit').
car('GAZ', 'Ukraine', 'yellow', 'Autohit').
car('Moskvich 1/43', 'blue', 'Kazakhstan', 'Autohit').
car('Moskvich 1/43', 'blue', 'Kazakhstan', 'Cars-cars-cars').
car('Lada', 'Russia', 'red', 'Smith Auto').
car('Lada', 'Russia', 'red', 'Cars-cars-cars').
car('Lada', 'Russia', 'red', 'Best cars').
car('Lada', 'Russia', 'yellow', 'Smith Auto').
car('Lada', 'Russia', 'yellow', 'Cars-cars-cars').
car('Lada', 'Russia', 'yellow', 'Best cars').
car('Lada', 'Russia', 'green', 'Smith Auto').
car('Lada', 'Russia', 'green', 'Cars-cars-cars').
car('Lada', 'Russia', 'green', 'Best cars').
car('Kamaz', 'Kazakhstan', 'purple', 'Car salers').

model('VAZ', 1000).
model('GAZ', 800).
model('Moskvich 1/43', 1200).
model('Lada', 1300).
model('Kamaz', 2000).

color('VAZ', 'yellow').
color('VAZ', 'red').
color('GAZ', 'green').
color('GAZ', 'purple').
color('GAZ', 'yellow').
color('Moskvich 1/43','blue').
color('Lada','red').
color('Lada','yellow').
color('Lada','green').
color('Kamaz','purple').

saler('Best cars', 'Russia').
saler('Smith Auto', 'Canada').
saler('Autohit', 'Ukraine').
saler('Cars-cars-cars', 'Russia').
saler('Car salers', 'Irland').

country('Russia').
country('Canada').
country('Ukraine').
country('Irland').
country('Kazakhstan').

/* a) поиск марки автомобиля, которую продает больше всего фирм; */

number_of_salers(Model, Number) :- 
							findall(Saler, sales_for(Model, Saler), L), 
							length(L, Number1), Number is Number1 - 1.

find_max(Model) :- model(Model,_),
					is_max(Model).

is_max(Model) :- 
					model(Model1,_),
					number_of_salers(Model, N1),
					number_of_salers(Model1, N2),
					N2 > N1, !, fail.
is_max(_).

max_salers_for(Model) :- 
						model(Model,_),
						find_max(Model).
max_salers_for(_).

/* b) поиск числа стран, в которых продаются автомобили заданной марки; */
country_sale(Country, Model) :-
							car(Model, _, _, Saler), 
							saler(Saler, Country), !.
country_for(Model, Country) :- 
				country(Country),
				country_sale(Country, Model).
country_for(_,_).

number_of_countries(Model, Number) :- 
							findall(Country, country_for(Model, Country), L), 
							length(L, Number1), Number is Number1 - 1.

/* c) поиск всех фирм, продающих автомобили заданной марки */
sale_model(Saler, Model) :- car(Model, _, _, Saler), !.
sales_for(Model, Saler) :-  
				saler(Saler, _),
				sale_model(Saler, Model).
sales_for(_,_).

/* d) поиск всех моделей автомобилей, цена которых ниже заданной; */
model_price(Model, Price) :- model(Model, Price), !.
cars_less_than(MaxPrice, Model) :- 
				model(_, Price),
				Price < MaxPrice,
				model_price(Model, Price).
cars_less_than(_,_).