-- library management system

-- CREATING BRANCH TABLE

DROP TABLE IF EXISTS branch;
CREATE TABLE branch
(
	branch_id VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(40),	
    contact_no VARCHAR(10)
);

ALTER TABLE branch MODIFY contact_no VARCHAR(15);

-- CREATING EMPLOYEES TABLE

DROP TABLE IF EXISTS employees;
CREATE TABLE employees
(
	emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(40),
    position_name VARCHAR(20),
    salary INT,
    branch_id VARCHAR(10),
    CONSTRAINT fk_employees_branch FOREIGN KEY (branch_id) REFERENCES branch(branch_id)
);


-- CREATE BOOKS TABLE

DROP TABLE IF EXISTS books;
CREATE TABLE books
(
	isbn VARCHAR(40) PRIMARY KEY,
	book_title VARCHAR(75),
    category VARCHAR(20),
    rental_price FLOAT(10),
    status	VARCHAR(5),
    author	VARCHAR(40),
    publisher VARCHAR(55)
);

-- CREATING MEMBERS TABLE

DROP TABLE IF EXISTS members;
CREATE TABLE members
(
	member_id VARCHAR(10) PRIMARY KEY,	
    member_name	VARCHAR(55),
    member_address VARCHAR(100),
    reg_date DATE
);


-- CREATING BOOKS ISSUED STATUS

DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status
(
	issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(10),
    issued_book_name VARCHAR(75),
    issued_date	DATE,
    issued_book_isbn VARCHAR(40),
    issued_emp_id VARCHAR(10),
    CONSTRAINT fk_issued_member_id FOREIGN KEY (issued_member_id) REFERENCES members(member_id),
    CONSTRAINT fk_issued_book_isbn FOREIGN KEY (issued_book_isbn) REFERENCES books(isbn),
    CONSTRAINT fk_issued_emp_id FOREIGN KEY (issued_emp_id) REFERENCES employees(emp_id)
); 


-- CREATING RETURN STATUS TABLE

DROP TABLE IF EXISTS return_status;
CREATE TABLE return_status
(
	return_id VARCHAR(10) PRIMARY KEY, 
    issued_id VARCHAR(10),
    return_book_name VARCHAR(75),
    return_date	DATE,
    return_book_isbn VARCHAR(40),
    CONSTRAINT fk_return_book_isbn FOREIGN KEY (return_book_isbn) REFERENCES books(isbn)
);

ALTER TABLE return_status
DROP FOREIGN KEY fk_return_book_isbn;

ALTER TABLE return_status
ADD CONSTRAINT fk_return_issued
FOREIGN KEY (issued_id) REFERENCES issued_status(issued_id);