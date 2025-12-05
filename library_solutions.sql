SELECT * FROM books;

SELECT * FROM members;

SELECT * FROM branch;

SELECT * FROM employees;

SELECT * FROM issued_status;

SELECT * FROM return_status;


-- TASKS

-- CRUD OPERATIONS

/* Task 1. Create a New Book Record 
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
*/

INSERT INTO books (isbn, book_title, category, rental_price, status, author, publisher)
VALUES
('978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.');


	-- Task 2: Update an Existing Member's Address

	/*
	FOR member_id C103 UPADTE ADDRESS AS '125 Oak St'
	*/

UPDATE members
SET member_address = '125 Oak St'
WHERE member_id = 'C103';

-- Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id = 'IS121';

-- Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'.

SELECT issued_book_name FROM issued_status
WHERE issued_emp_id = 'E101';

-- Task 5: List Members Who Have Issued More Than One Book 
-- Objective: Use GROUP BY to find members who have issued more than one book.

SELECT issued_member_id, COUNT(*) AS no_of_books
FROM issued_status
GROUP BY 1
HAVING no_of_books > 1 ;


-- CTAS (Create Table As Select)
/* Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results - 
each book and total book_issued_cnt*/


SELECT * FROM books;
SELECT * FROM issued_status;

CREATE TABLE book_issued_cnt AS 
SELECT bo.isbn, bo.book_title, COUNT(*) AS total_books_issued FROM books AS bo
	LEFT JOIN issued_status AS iss
	ON bo.isbn = iss.issued_book_isbn
GROUP BY 1,2;

SELECT * FROM book_issued_cnt;

-- Task 7. Retrieve All Books in a Specific Category:

SELECT * FROM books 
WHERE category = 'Classic';

-- Task 8: Find Total Rental Income by Category:

-- BOOKS, ISSUED STATUS

SELECT bo.category, SUM(bo.rental_price) AS total_rental_inc, COUNT(*) AS no_of_times
FROM books AS bo
	JOIN issued_status AS iss
	ON bo.isbn = iss.issued_book_isbn
GROUP BY 1;

-- TASK 9 List Members Who Registered in the Last 180 Days:

SELECT * FROM members
WHERE reg_date >= CURDATE() - INTERVAL 600 DAY;

-- TASK 10 - List Employees with Their Branch Manager's Name and their branch details:

SELECT * FROM employees;
SELECT * FROM branch;

SELECT emp.emp_id, 
		emp.emp_name, 
        br.manager_id, 
        emp2.emp_name AS manager_name, 
        br.branch_address, 
        br.contact_no
FROM employees AS emp
	JOIN branch AS br
    ON emp.branch_id = br.branch_id
    JOIN employees AS emp2
    ON br.manager_id = emp2.emp_id;
    
-- Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE expensive_books
SELECT * FROM books
WHERE rental_price > 7;

SELECT * FROM expensive_books;


-- Task 12. Retrieve the List of Books Not Yet Returned


SELECT * FROM issued_status;
SELECT * FROM return_status;

SELECT * FROM issued_status AS i
	LEFT JOIN return_status AS r
    ON i.issued_id = r.issued_id
WHERE r.issued_id IS NULL;


/* Task 13: Identify Members with Overdue Books
Write a query to identify members who have overdue books (assume a 30-day return period). 
Display the member's_id, member's name, book title, issue date, and days overdue.
*/

-- issued_status == members == books == returned status
-- filter books that are retured
-- if due is more than 30 days

SELECT ist.issued_member_id, m.member_name, b.book_title, ist.issued_date, rst.return_date,
	DATEDIFF(CURDATE(), ist.issued_date) AS due_days
FROM issued_status AS ist 
	JOIN members AS m
    ON m.member_id = ist.issued_member_id
    JOIN books AS b
    ON b.isbn = ist.issued_book_isbn
    LEFT JOIN return_status AS rst
    ON rst.issued_id = ist.issued_id
WHERE rst.return_date IS NULL
	AND DATEDIFF(CURDATE(), ist.issued_date) > 610
ORDER BY 1;

/*Task 14: Update Book Status on Return
Write a query to update the status of books in the books table to "Yes" 
when they are returned (based on entries in the return_status table).
*/

DELIMITER $$

CREATE PROCEDURE add_return_records(
	IN p_return_id VARCHAR(10),
    IN p_issued_id VARCHAR(10),
    IN p_book_quality VARCHAR(10)
)
BEGIN
	DECLARE v_isbn VARCHAR(50);
	DECLARE v_book_name VARCHAR(80);
     -- 1) Insert a new return record
	INSERT INTO return_status (return_id, issued_id, return_date, book_quality)
    VALUES (p_return_id, p_issued_id, CURDATE(), p_book_quality);
	 -- 2) Get the book's ISBN and name from issued_status
    SELECT 
        issued_book_isbn,
        issued_book_name
    INTO 
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;
	-- 3) Mark the book as available again
	UPDATE books
    SET status = 'Yes'
    WHERE isbn = v_isbn;
    -- 4) Show a message to the caller
SELECT CONCAT('Thank you for returning the book: ', v_book_name) AS message;
END $$
DELIMITER ;

ALTER TABLE return_status
ADD COLUMN book_quality VARCHAR(10);

CALL add_return_records('RS138', 'IS135', 'Good');

/*
Task 15: Branch Performance Report
Create a query that generates a performance report for each branch, 
showing the number of books issued, the number of books returned, 
and the total revenue generated from book rentals.
*/

-- branch = employees = issued = return = books

CREATE TABLE branch_report
AS
SELECT 
b.branch_id AS branch_id,
b.branch_address AS branch_address, 
COUNT(DISTINCT ist.issued_id) AS no_of_books_issued, 
COUNT(DISTINCT rst.return_id) AS no_of_books_returned, 
COALESCE(SUM(bk.rental_price),0) AS total_revenue
FROM branch AS b
	LEFT JOIN employees AS e
    ON b.branch_id = e.branch_id
    LEFT JOIN issued_status AS ist
	ON ist.issued_emp_id = e.emp_id
    LEFT JOIN return_status AS rst
    ON rst.issued_id = ist.issued_id
    LEFT JOIN books AS bk
    ON bk.isbn = ist.issued_book_isbn
GROUP BY b.branch_id, b.branch_address;

SELECT * FROM branch_report;


/*Task 16: CTAS: Create a Table of Active Members
Use the CREATE TABLE AS (CTAS) statement to 
create a new table active_members containing members 
who have issued at least one book in the last 2 months.
*/

DROP TABLE IF EXISTS active_members;
CREATE TABLE active_members
AS
SELECT *
FROM members AS m
	JOIN issued_status AS ist
	ON ist.issued_member_id = m.member_id
	WHERE ist.issued_date > CURDATE() - INTERVAL 20 MONTH;
    
SELECT * FROM active_members;


/*
Task 17: Find Employees with the Most Book Issues Processed
Write a query to find the top 3 employees who have processed the most book issues. 
Display the employee name, number of books processed, and their branch.
*/

-- employees = books = issued

SELECT 
emp.emp_name AS emp_name,
b.*,
COUNT(ist.issued_id) AS no_of_books_proccessed
FROM employees AS emp
	LEFT JOIN issued_status AS ist
    ON ist.issued_emp_id = emp.emp_id
    JOIN branch AS b
    ON b.branch_id = emp.branch_id
GROUP BY 1,2
ORDER BY 3 DESC
LIMIT 3;

/*
Task 18: Stored Procedure Objective: Create a stored procedure to manage the status of books in a library system. 
Description: Write a stored procedure that updates the status of a book in the library based on its issuance. 
The procedure should function as follows: The stored procedure should take the book_id as an input parameter. 
The procedure should first check if the book is available (status = 'yes'). 
If the book is available, it should be issued, and the status in the books table should be updated to 'no'. 
If the book is not available (status = 'no'), the procedure should return an error message indicating that 
the book is currently not available.
*/

DELIMITER $$

CREATE PROCEDURE issue_book(
	IN p_book_isbn VARCHAR(40)
)
BEGIN
	DECLARE v_status VARCHAR(5);
	-- 1) Check book availability
    SELECT status
    INTO v_status
    FROM books
    WHERE isbn = p_book_isbn;
	-- 2) If book is available → issue it
    IF v_status = 'Yes' THEN
        UPDATE books
        SET status = 'No'
        WHERE isbn = p_book_isbn;
	 SELECT CONCAT('Book ', p_book_isbn, ' has been successfully issued.') AS message;
     -- 3) If book is NOT available → return an error message
    ELSE
        SELECT CONCAT('Book ', p_book_isbn, ' is currently not available.') AS message;
    END IF;
END$$

DELIMITER ;

-- Check status before issuing
SELECT * FROM books WHERE isbn = '978-0-307-58837-1';

-- Try issuing
CALL issue_book('978-0-307-58837-1');

-- Check status again
SELECT * FROM books WHERE isbn = '978-0-307-58837-1';
