------------------------------------------------
-- База данных «Страны и города мира»:
------------------------------------------------
--------------------------------------------------------------------------------
-- 1. Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
--------------------------------------------------------------------------------

USE geodata;

SELECT
    _cities.id AS city_id,
    _cities.title AS city_title,
    _regions.title AS region_title,
    _countries.title AS country_title
FROM
    _cities
        INNER JOIN
    _countries ON _cities.country_id = _countries.id
        INNER JOIN
    _regions ON _cities.region_id = _regions.id
LIMIT 10;

-----------------------------------------------
-- 2. Выбрать все города из Московской области.
-----------------------------------------------

SELECT
    _cities.title AS city_title
FROM
    _cities
        INNER JOIN
    _regions ON _cities.region_id = _regions.id
WHERE
    _regions.title = 'Московская область';
    
    
 -----------------------------------------------
-- 1. Выбрать среднюю зарплату по отделам.
-----------------------------------------------

USE employees;
SELECT
    dept_emp.dept_no,
    departments.dept_name,
    TRUNCATE(AVG(salaries.salary), 2) AS average_salary
FROM
    departments
        LEFT OUTER JOIN
    dept_emp ON dept_emp.dept_no = departments.dept_no
        INNER JOIN
    employees ON dept_emp.emp_no = employees.emp_no
        INNER JOIN
    salaries ON employees.emp_no = salaries.emp_no
WHERE
    dept_emp.to_date >= CURDATE() AND salaries.to_date >= CURDATE()
GROUP BY dept_emp.dept_no;


------------------------------------------------
-- 2. Выбрать максимальную зарплату у сотрудника
------------------------------------------------

SELECT
    salaries.emp_no,
    CONCAT(employees.first_name, ' ', employees.last_name) AS full_name,
    salaries.salary
FROM
    salaries
        INNER JOIN
    employees ON salaries.emp_no = employees.emp_no
        INNER JOIN
    dept_emp ON salaries.emp_no = dept_emp.emp_no
WHERE
    dept_emp.to_date >= CURDATE() AND salaries.to_date >= CURDATE()
ORDER BY salaries.salary DESC
LIMIT 1;

------------------------------------------------------------------
-- 3. Удалить одного сотрудника, у которого максимальная зарплата.
------------------------------------------------------------------

DELETE FROM employees
WHERE
    employees.emp_no = (SELECT
        salaries.emp_no
    FROM
        salaries
    WHERE salaries.to_date >= CURDATE()
    ORDER BY salaries.salary DESC
    LIMIT 1);
    
-------------------------------------------------------
-- 4. Посчитать количество сотрудников во всех отделах.
-------------------------------------------------------

SELECT COUNT(emp_no) FROM dept_emp WHERE dept_emp.to_date >= CURDATE();

----------------------------------------------------------------------------------------------
-- 5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.
----------------------------------------------------------------------------------------------

SELECT
    dept_emp.dept_no,
    departments.dept_name,
    COUNT(dept_emp.emp_no) AS number_of_employees,
    SUM(salaries.salary) AS total_salary
FROM
    departments
        LEFT OUTER JOIN
    dept_emp ON dept_emp.dept_no = departments.dept_no
        INNER JOIN
    salaries ON dept_emp.emp_no = salaries.emp_no
WHERE dept_emp.to_date >= CURDATE() AND salaries.to_date >= CURDATE()
GROUP BY dept_emp.dept_no;

------------------------------------------------
-- Необязательные задания
------------------------------------------------
---------------------------------------------------------------
-- 6. Найти всех сотрудников, у которых средняя зарплата
-- на 20 процентов больше средней выплаты по всем сотрудникам.
---------------------------------------------------------------

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

-------------------------------------------------------------------------------------
-- 7. Найти среднюю зарплату для пяти пользователей с наибольшим количеством выплат.
-------------------------------------------------------------------------------------

SELECT
    salaries.emp_no,
    CONCAT(employees.first_name, ' ', employees.last_name) AS full_name,
    AVG(salary) AS emp_avg_salary,
    COUNT(salary) AS payments_qty
FROM
    employees
        INNER JOIN
    salaries ON salaries.emp_no = employees.emp_no
        INNER JOIN
    dept_emp ON salaries.emp_no = dept_emp.emp_no
WHERE
    dept_emp.to_date >= CURDATE()
GROUP BY emp_no
ORDER BY payments_qty DESC
LIMIT 5;

--------------------------------------------------------------------------------
-- 8. Найти разницу между суммарными выплатами десяти сотрудников с наибольшей
-- средней зарплатой и десяти сотрудников с наименьшей средней зарплатой.
--------------------------------------------------------------------------------

SELECT
    (SELECT
		SUM(avg_salary)
        FROM
            (SELECT
                emp_no, AVG(salary) AS avg_salary
            FROM
                salaries
            GROUP BY emp_no
            ORDER BY avg_salary DESC
            LIMIT 10)
		AS top_salaries)
	-
    (SELECT
        SUM(avg_salary)
        FROM
            (SELECT
                emp_no, AVG(salary) AS avg_salary
            FROM
                salaries
            GROUP BY emp_no
            ORDER BY avg_salary ASC
            LIMIT 10)
		AS bottom_salaries)
	AS salaries_difference;