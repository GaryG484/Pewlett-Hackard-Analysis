--Deliverable 1
--Create the two basic tables
CREATE TABLE employees (
     emp_no INT NOT NULL,
     birth_date DATE NOT NULL,
     first_name VARCHAR(40) NOT NULL,
     last_name VARCHAR(40) NOT NULL,
     gender VARCHAR(10) NOT NULL,
     hire_date DATE NOT NULL,
     PRIMARY KEY (emp_no)
);

CREATE TABLE titles (
emp_no INT NOT NULL,
	title VARCHAR(20) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no)
);

--DROP TABLE emp_info
SELECT emp_no, first_name, last_name
INTO emp_info
FROM employees
WHERE (birth_date BETWEEN '1952-01-01' AND '1955-12-31');

--DROP TABLE title_info
SELECT title, from_date, to_date, emp_no
INTO title_info
FROM titles;


-- Joining emp_info and title_info tables
SELECT emp_info.emp_no,
     emp_info.first_name,
     emp_info.last_name,
	 title_info.title,
	 title_info.from_date,
	 title_info.to_date
INTO retirement_titles
FROM emp_info
INNER JOIN title_info
ON emp_info.emp_no = title_info.emp_no
ORDER BY emp_info.emp_no;

--DROP TABLE unique_titles
-- Use Dictinct with Orderby to remove duplicate rows
-- (x) is the column that dups are removed from, the rest are the columns that are imported
SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
title

INTO unique_titles
FROM retirement_titles
ORDER BY emp_no, to_date DESC;

-- Get number of titles from the unique titles table, 
-- group the table by title, then sort the count column
--in descending order
SELECT COUNT(ut.title), ut.title
INTO retiring_titles
FROM unique_titles as ut
GROUP BY ut.title
ORDER BY count DESC;

--DROP TABLE dept_employees
--Deliverable 2
CREATE TABLE dept_employees (
emp_no INT NOT NULL,
	dept_no VARCHAR(4) NOT NULL,
    from_date DATE NOT NULL,
    to_date DATE NOT NULL,
FOREIGN KEY (emp_no) REFERENCES employees (emp_no),
    PRIMARY KEY (emp_no, dept_no)
);

DROP TABLE emp_and_dep_emp
--joining employees and department employees table
SELECT employees.emp_no,
     employees.first_name,
     employees.last_name,
	 employees.birth_date,
	 dept_employees.from_date,
	 dept_employees.to_date
INTO emp_and_dep_emp
FROM employees
INNER JOIN dept_employees
ON employees.emp_no = dept_employees.emp_no
ORDER BY employees.emp_no
;

SELECT emp_and_dep_emp.emp_no,
     emp_and_dep_emp.first_name,
     emp_and_dep_emp.last_name,
	 emp_and_dep_emp.birth_date,
	emp_and_dep_emp.from_date,
	 emp_and_dep_emp.to_date,
	 titles.title
INTO emp_and_dep_emp_and_title
FROM emp_and_dep_emp
INNER JOIN titles
ON emp_and_dep_emp.emp_no = titles.emp_no
ORDER BY emp_and_dep_emp.emp_no
;

DROP TABLE emp_and_dep_emp_and_title_clean
SELECT emp_and_dep_emp_and_title.emp_no,
     emp_and_dep_emp_and_title.first_name,
     emp_and_dep_emp_and_title.last_name,
	 emp_and_dep_emp_and_title.birth_date,
	emp_and_dep_emp_and_title.from_date,
	 emp_and_dep_emp_and_title.to_date,
	 emp_and_dep_emp_and_title.title
INTO emp_and_dep_emp_and_title_clean
FROM emp_and_dep_emp_and_title
WHERE (birth_date BETWEEN '1965-01-01' AND '1965-12-31')
AND (to_date BETWEEN '9999-01-01' AND '9999-01-01');
;

SELECT DISTINCT ON (emp_no) emp_no,
first_name,
last_name,
birth_date,
from_date,
to_date,
title

INTO mentorship_eligibility
FROM emp_and_dep_emp_and_title_clean
ORDER BY emp_no;

