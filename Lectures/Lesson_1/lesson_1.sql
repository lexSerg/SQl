SELECT * FROM `june-2020`.students;
SELECT name FROM `june-2020`.students;
SELECT * FROM `june-2020`.students WHERE name LIKE 'O%';
SELECT * FROM `june-2020`.students WHERE name LIKE '%m%';
SELECT * FROM `june-2020`.students WHERE name LIKE '__m%';
SELECT * FROM `june-2020`.students WHERE length(name) = 5;
SELECT * FROM `june-2020`.students WHERE name like 'o%';
SELECT * FROM `june-2020`.students WHERE name like 'o%' order by age;
SELECT * FROM `june-2020`.students order by age;
SELECT * FROM `june-2020`.students order by age DESC;
SELECT * FROM `june-2020`.students WHERE gender = 'male' order by age;
SELECT * FROM `june-2020`.students order by name DESC;
SELECT * FROM `june-2020`.students order by name;
SELECT * FROM `june-2020`.students order by age limit 1; -- самый младший ;
SELECT * FROM `june-2020`.students limit 3 offset 6; -- пагинация
SELECT * FROM `june-2020`.students limit 3 offset 9;
SELECT * FROM `june-2020`.students where age > 18 and name like '%i%';
SELECT * FROM `june-2020`.students where age > 30 or name like '%i%';
SELECT * FROM `june-2020`.students where age between 20 and 30;
SELECT MAX(age) FROM `june-2020`.students;
SELECT min(age) FROM `june-2020`.students;
SELECT avg(age) FROM `june-2020`.students;
SELECT avg(rating) FROM `june-2020`.ratings;
SELECT count(name) FROM `june-2020`.students;
SELECT count(rating) FROM `june-2020`.ratings WHERE rating > 4;
SELECT avg(rating), count(id) FROM `june-2020`.ratings WHERE student_id = 5;
SELECT avg(rating) as RATE, count(id) as COUNT FROM `june-2020`.ratings WHERE student_id = 5; -- ALIAS
SELECT sum(age) FROM `june-2020`.students;
UPDATE `june-2020`.students SET name = 'JASON STATEM' WHERE name = 'weniamin';--  Не работает в безопасном режиме
SELECT * FROM `june-2020`.students where name between 'huanitos' and 'mary' ;
SELECT *, concat(id, ' ', name, ' ', age, ' ', gender) as person FROM `june-2020`.students;
select `june-2020`.students.name, `june-2020`.ratings.rating from `june-2020`.ratings inner join `june-2020`.students on `june-2020`.ratings.id = `june-2020`.students.id;
