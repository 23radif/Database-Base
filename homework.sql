--1. Реализовать практические задания на примере других таблиц и запросов.
--Уточнение: Создать транзакцию на основе триггера из предыдущего ДЗ.
--После каждой операции транзакции поставить явно блокировку.
--После первой операции - блокировку на чтение, после второй - на запись.
--Исполняя команды по шагам, из другой сессии пробовать операции чтения и записи для блокированных таблиц. 
--В ДЗ приложить скрипт транзакции с блокировками.

START TRANSACTION;
BEGIN;
	use employees;
	SET @emp_no_bonus = 9;
	
	LOCK TABLES employees WRITE; --Тут было READ, получается WRITE для обоих случаев?
	INSERT INTO employees VALUES (@emp_no_bonus, '1985-04-31', 'Nikolay', 'Zheltuhin', 'F', CURDATE());
	
	LOCK TABLES salaries WRITE;
	INSERT INTO salaries (emp_no, salary, from_date, to_date)
		VALUES (@emp_no_bonus, 100, CURDATE(), '2019-04-31');
COMMIT;

UNLOCK TABLES;


--2. Подумать, какие операции являются транзакционными, и написать несколько примеров с транзакционными запросами.
--Уточнение: Придумать и реализовать две транзакции для БД сотрудников.
--В первой транзакции должно быть задействовано, как минимум, две таблицы, во второй - три таблицы.

START TRANSACTION;
BEGIN;
	use employees;
	SET @emp_no_emp = 10;
	
	INSERT INTO employees VALUES (@emp_no_emp, '1985-04-31', 'Evgen', 'Maslov', 'F', CURDATE());
	
	INSERT INTO titles (emp_no, title, from_date, to_date)
		VALUES (@emp_no_emp, 'Engineer', CURDATE(), '9999-01-01');
COMMIT;

START TRANSACTION;
BEGIN;
	use employees;
	SET @emp_no_dept = 11;
	
	INSERT INTO employees VALUES (@emp_no_dept, '1985-03-31', 'Evgeniya', 'Maslova', 'F', CURDATE());
		
	INSERT INTO dept_manager (dept_no, emp_no, from_date, to_date)
		VALUES ('d001', @emp_no_dept, CURDATE(), '9999-01-01');
		
	INSERT INTO salaries (emp_no, salary, from_date, to_date)
		VALUES (@emp_no_dept, 100000, CURDATE(), '2019-04-31');
COMMIT;


-- 3. Проанализировать несколько запросов с помощью EXPLAIN.
-- Уточнение: 
-- Первый запрос
SELECT COUNT(emp_no) FROM dept_emp WHERE dept_emp.to_date >= CURDATE();

-- Второй запрос
SELECT
salaries.emp_no,
CONCAT(employees.first_name, ' ', employees.last_name) AS full_name,
AVG(salary) AS emp_avg_salary
FROM
salaries
INNER JOIN
employees ON salaries.emp_no = employees.emp_no
INNER JOIN
dept_emp ON salaries.emp_no = dept_emp.emp_no
WHERE
dept_emp.to_date >= CURDATE()
GROUP BY emp_no
HAVING emp_avg_salary > 1.2 * (SELECT AVG(salary) FROM employees.salaries);

-- По каждой строке вывода EXPLAIN дать пояснения насколько эта часть запроса оптимальна и почему.
-- Определить способы улучшения (если необходимы и возможны).
-- Для визуального анализа используйте графическое представление в Workbench.

--1.
ALTER TABLE dept_emp ADD INDEX (to_date); --индексирование данного столбца позволяет значительно ускорить запрос, так как при выборке к нему происходит обращение

--2.
ALTER TABLE employees ADD INDEX (emp_no); --индексирование данного столбца так же ускоряет запрос, но возможно ещё что-то можно применить для оптимизации, 
--так как сохраняется высокая нагрузка, возможно позже гляну, сейчас нужно отойти...