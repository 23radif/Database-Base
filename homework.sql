------------------------------------------------
-- 1. Создать VIEW на основе запросов, которые вы сделали в ДЗ к уроку 3.
------------------------------------------------
--------------------------------------------------------------------------------
-- 1.1.1 Сделать запрос, в котором мы выберем все данные о городе – регион, страна.
--------------------------------------------------------------------------------

USE geodata;

CREATE VIEW view_all_city_data
  AS SELECT
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

  SELECT * FROM view_all_city_data;

-----------------------------------------------
-- 1.1.2. Выбрать все города из Московской области.
-----------------------------------------------

CREATE VIEW view_all_city_in_moscow_region
  AS SELECT
      _cities.title AS city_title
  FROM
      _cities
          INNER JOIN
      _regions ON _cities.region_id = _regions.id
  WHERE
      _regions.title = 'Московская область';

    SELECT * FROM view_all_city_in_moscow_region;
    
 -----------------------------------------------
-- 1.2.1 Выбрать среднюю зарплату по отделам.
-----------------------------------------------

USE employees;

CREATE VIEW view_avg_salary_by_department
  AS SELECT
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
-- 1.2.2. Выбрать максимальную зарплату у сотрудника
------------------------------------------------

CREATE VIEW view_max_employee_salary
  AS SELECT
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
-- 1.2.3. Удалить одного сотрудника, у которого максимальная зарплата.
------------------------------------------------------------------

CREATE VIEW view_remove_employee_max_salary --не работает
  AS DELETE FROM employees
  WHERE
      employees.emp_no = (SELECT
          salaries.emp_no
      FROM
          salaries
      WHERE salaries.to_date >= CURDATE()
      ORDER BY salaries.salary DESC
      LIMIT 1);
    
-------------------------------------------------------
-- 1.2.4. Посчитать количество сотрудников во всех отделах.
-------------------------------------------------------

CREATE VIEW view_count_employees
  AS SELECT COUNT(emp_no) FROM dept_emp WHERE dept_emp.to_date >= CURDATE();

----------------------------------------------------------------------------------------------
-- 1.2.5. Найти количество сотрудников в отделах и посмотреть, сколько всего денег получает отдел.
----------------------------------------------------------------------------------------------

CREATE VIEW view_count_employees_department_salary
  AS SELECT
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
-- 1.2.6. Найти всех сотрудников, у которых средняя зарплата
-- на 20 процентов больше средней выплаты по всем сотрудникам.
---------------------------------------------------------------

CREATE VIEW view_all_employees_salary_20_percent_more
  AS SELECT
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
-- 1.2.7. Найти среднюю зарплату для пяти пользователей с наибольшим количеством выплат.
-------------------------------------------------------------------------------------

CREATE VIEW view_avg_salary_5_employees_max_salary
  AS SELECT
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
-- 1.2.8. Найти разницу между суммарными выплатами десяти сотрудников с наибольшей
-- средней зарплатой и десяти сотрудников с наименьшей средней зарплатой.
--------------------------------------------------------------------------------

CREATE VIEW view_sum_dif_10_max_salary_and_10_min_salary
  AS SELECT
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


----------------------------------------------------------------------------
--2.0 Создать функцию, которая найдет менеджера по имени и фамилии.
----------------------------------------------------------------------------

CREATE FUNCTION func_emp_no (first_n VARCHAR(20), last_n VARCHAR(20))
  RETURNS VARCHAR(10) DETERMINISTIC
  RETURN (
    SELECT employees.emp_no FROM employees
      JOIN salaries ON employees.emp_no = salaries.emp_no
        WHERE employees.first_name = first_n AND employees.last_name = last_n AND salaries.to_date >= CURDATE()
        LIMIT 1
  );

  SELECT func_emp_no ('Bezalel', 'Simmel');


----------------------------------------------------------------------------
--3. Создать триггер, который при добавлении нового сотрудника будет выплачивать ему вступительный бонус,
-- занося запись об этом в таблицу salary.
----------------------------------------------------------------------------

CREATE TRIGGER new_employees_salary_bonus
  AFTER INSERT
  ON employees
  FOR EACH ROW
  INSERT INTO salaries VALUES (NEW.emp_no, 5000, CURDATE(), '9999-01-01');

INSERT INTO employees (emp_no, birth_date, first_name, last_name, gender, hire_date)
  VALUES (3, CURDATE(), 'as', 'as', 'F', CURDATE());

