# 1. +Вибрати усіх клієнтів, чиє ім'я має менше ніж 6 символів.
select * from client where length(FirstName) < 6;
#
# 2. +Вибрати львівські відділення банку.+
select * from department where DepartmentCity like  'lviv';
#
# 3. +Вибрати клієнтів з вищою освітою та посортувати по прізвищу.
select * from client where Education like 'high' order by LastName;
#
# 4. +Виконати сортування у зворотньому порядку над таблицею Заявка і вивести 5 останніх елементів.
select * from application order by idApplication desc limit 5 offset 10;
#
#
#
# 5. +Вивести усіх клієнтів, чиє прізвище закінчується на OV чи OVA.
select  * from client where LastName like '%iva' or LastName like '%iv';
#
# 6. +Вивести клієнтів банку, які обслуговуються київськими відділеннями.
select * from client where Department_idDepartment in (2, 5);
#
# 7. +Вивести імена клієнтів та їхні номера телефону, погрупувавши їх за іменами.
select  FirstName, Passport from client order by FirstName;
# 8. +Вивести дані про клієнтів, які мають кредит більше ніж на 5000 тисяч гривень.
select * from client c join application a on c.idClient = a.Client_idClient where sum > 5000;
# 9. +Порахувати кількість клієнтів усіх відділень та лише львівських відділень.
select count(idClient) ClientCount, DepartmentCity from client c
    join department d on c.Department_idDepartment = d.idDepartment
    group by DepartmentCity;
select count(idClient) ClientCount, DepartmentCity Department from client c
    join department d on c.Department_idDepartment = d.idDepartment
      where DepartmentCity like 'Lviv';
#
#
# 10. Знайти кредити, які мають найбільшу суму для кожного клієнта окремо.
select  max(Sum), idClient, FirstName, LastName from client c
    join application a on c.idClient = a.Client_idClient
    group by Client_idClient;
#
# 11. Визначити кількість заявок на крдеит для кожного клієнта.
select count(CreditState), idClient, FirstName, LastName from client c
    join application a on c.idClient = a.Client_idClient
    group by Client_idClient;
# 12. Визначити найбільший та найменший кредити.
# in two
select idClient, FirstName, LastName, min(Sum) from client c
    join application a on c.idClient = a.Client_idClient
    union
    select idClient, FirstName, LastName, max(sum)from client c
    join application a on c.idClient = a.Client_idClient ;
# together
select idClient, FirstName, LastName, max(sum), min(Sum) from client c
    join application a on c.idClient = a.Client_idClient ;
#
# 13. Порахувати кількість кредитів для клієнтів,які мають вищу освіту.
select  count(Sum), Education from client c
    join application a on c.idClient = a.Client_idClient
    group by Education;
#
# 14. Вивести дані про клієнта, в якого середня сума кредитів найвища.
# variant 1
select  *, avg(Sum) MaxAvgSum from client
    join application a on client.idClient = a.Client_idClient
    group by  Client_idClient
    order by avg(Sum)
    desc limit 1;
# variant 2
select *, avg(a.Sum) MaxAvgCredit
from client c
join application a
on c.idClient = a.Client_idClient
group by a.Client_idClient
having avg(a.Sum) = (
  select max(avg_sum)
    from (
    select avg(Sum) as avg_sum
    from bank.application
    group by Client_idClient) as AvgCred);
# 15. Вивести відділення, яке видало в кредити найбільше грошей
select Department_idDepartment,DepartmentCity, SUM(Sum) from client
    join application a on client.idClient = a.Client_idClient
    join department d on client.Department_idDepartment = d.idDepartment
    group by Department_idDepartment
order by SUM(Sum) desc
limit 1;
#
# 16. Вивести відділення, яке видало найбільший кредит.
select Department_idDepartment,DepartmentCity, Max(Sum) from client
    join application a on client.idClient = a.Client_idClient
    join department d on client.Department_idDepartment = d.idDepartment
    group by Department_idDepartment
order by SUM(Sum) desc
limit 1;
#
# 17. Усім клієнтам, які мають вищу освіту, встановити усі їхні кредити у розмірі 6000 грн.
update application a
    join client c on c.idClient = a.Client_idClient
    set Sum = 6000
    where Education = 'high';


# 18. Усіх клієнтів київських відділень пересилити до Києва.
update client c
    join department d on d.idDepartment = c.Department_idDepartment
    set City = 'Kiev'
    where DepartmentCity like 'Kyiv';
#
# 19. Видалити усі кредити, які є повернені.
set sql_safe_updates = 0;
delete  from application where CreditState = 'returned';

#
# 20. Видалити кредити клієнтів, в яких друга літера прізвища є голосною.


select idClient from client c
    join application a on c.idClient = a.Client_idClient
    where regexp_like(c.LastName, '^.(e|u|i|o|a])') group by LastName;

# !!!Не работает
delete  from application where Client_idClient in (select idClient from client c
    join application a on c.idClient = a.Client_idClient
    where regexp_like(c.LastName, '^.(e|u|i|o|a])') group by LastName);


#
# Знайти львівські відділення, які видали кредитів на загальну суму більше ніж 5000
select * from (select Department_idDepartment, DepartmentCity, sum(Sum) maxSum from application a
    join client c on a.Client_idClient = c.idClient
    join department d on c.Department_idDepartment = d.idDepartment
    where DepartmentCity like 'Lviv'
    group by Department_idDepartment) AS LvivDep where maxSum > 5000;
#
# Знайти клієнтів, які повністю погасили кредити на суму більше ніж 5000
select idClient, FirstName, LastName, Education, Passport,
       City, Age, Department_idDepartment
    from client c
    join application a on c.idClient = a.Client_idClient
    where CreditState like 'returned'
    and Sum > 5000
    order by idClient;
#
# /* Знайти максимальний неповернений кредит.*/
#
select idApplication, max(Sum) credit, Currency, Client_idClient, CreditState from (select idApplication, Sum, Currency, Client_idClient, CreditState
    from client c
    join application a on c.idClient = a.Client_idClient
    where CreditState like 'Not returned') AS Credits;
#
# /*Знайти клієнта, сума кредиту якого найменша*/
select * from client
    join application a on client.idClient = a.Client_idClient
    order by Sum limit 1;
#
# /*Знайти кредити, сума яких більша за середнє значення усіх кредитів*/
select * from application
where Sum > (select AVG(Sum) TotallBal from application a);

#
# /*Знайти клієнтів, які є з того самого міста, що і клієнт, який взяв найбільшу кількість кредитів*/
# выборка по наибольшей сумме кредитов
# С искомым клиентов включительно
select idClient, FirstName, LastName, Education, Passport, City, Age, Department_idDepartment
    from client join (select sum(sum) TotalSum, Client_idClient, City currentCity
    from client c
    join application a on c.idClient = a.Client_idClient
    group by Client_idClient
    order by TotalSum desc
    limit 1) AS MaxClient where City like currentCity;
# Без искомого клиента
select idClient, FirstName, LastName, Education, Passport, City, Age, Department_idDepartment
    from client join (select sum(sum) TotalSum, Client_idClient currentClient, City currentCity
    from client c
    join application a on c.idClient = a.Client_idClient
    group by Client_idClient
    order by TotalSum desc
    limit 1) AS MaxClient where City like currentCity and idClient not like currentClient;

# выборка по наибольшему количеству взятых кредитов
# С искомым клиентов включительно
select  idClient, FirstName, LastName, Education, Passport, City, Age, Department_idDepartment
    from client join (select count(Client_idClient) clientCount, City ClientCity
    from application a
    join client c on a.Client_idClient = c.idClient
    group by Client_idClient
    order by clientCount desc
    limit 1) AS currentCity where City like  ClientCity;
# Без искомого клиента
select  idClient, FirstName, LastName, Education, Passport, City, Age, Department_idDepartment
    from client join (select count(Client_idClient) clientCount,
        City ClientCity, Client_idClient currentClient
    from application a
    join client c on a.Client_idClient = c.idClient
    group by Client_idClient
    order by clientCount desc
    limit 1) AS currentCity where City like  ClientCity and idClient not like currentClient;
#
# #місто чувака який набрав найбільше кредитів
select ClientCity from (select count(Client_idClient) clientCount, City ClientCity from application a
    join client c on a.Client_idClient = c.idClient
    group by Client_idClient
    order by clientCount desc
    limit 1) AS maxCredit;

#
#
# set sql_safe_updates = 0;
# set sql_safe_updates = 1;