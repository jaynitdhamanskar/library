# Library Management System

## Project Overview
**Project Title:** Library Management System  
**Database:** `library_db`  
**Technology:** MySQL

This project demonstrates the implementation of a Library Management System using SQL.  
It includes database creation, CRUD operations, analytical queries, CTAS, and stored procedures.  
The goal is to apply core SQL concepts to manage and analyze a real-world library workflow.

<img width="1007" height="523" alt="{4414666D-7FEF-4F5F-936C-057D19705279}" src="https://github.com/user-attachments/assets/7c17ec4f-28f9-4743-81a2-5fa8e78ec597" />

---

## Objectives

- Create and structure a relational database for a library system.
- Perform CRUD operations on books, members, and other library entities.
- Utilize **CTAS (Create Table As Select)** for summary and report generation.
- Execute advanced SQL queries for data insights.
- Use stored procedures to automate book issuing and returning.
- Ensure data integrity using primary and foreign key constraints.

---

## Project Structure

### Database Setup

<img width="906" height="664" alt="{2EEE94D7-EC27-4B53-A09D-08C7E0509E29}" src="https://github.com/user-attachments/assets/d88e938d-c5f4-4eca-8bd8-e8439ceb4cf1" />

- Database named **library_db** created.
- Six main transactional tables designed with keys & constraints:
  - Branch
  - Employees
  - Members
  - Books
  - Issued Status
  - Return Status
- Relationships enforced for:
  - Employee → Branch
  - Member → Issue Transaction
  - Book → Issue & Return

---

### CRUD Operations
Performed end-to-end data handling:
- Added new books and member information
- Viewed detailed datasets using selections and filters
- Updated records (ex: addresses)
- Deleted outdated issue records

Validated full command over data manipulation in SQL

---

### CTAS – Reporting & Summary Table Creation

Generated analytical tables such as:
- **Book Issued Count** – tracks demand of each book
- **Branch Report** – shows books issued, returned & revenue
- **Active Members** – recent usage activity in the library
- **Expensive Books** – books above a rental price threshold

Supports business analysis through SQL-driven insights

---

### Data Analysis & Reporting

Advanced queries written to:
- Identify overdue books & calculate pending days
- List books yet to be returned
- Display revenue category-wise
- Track highly active members
- Find productive employees based on book issues handled
- Provide manager-wise branch details

Demonstrates problem-solving using JOINs, GROUP BY, HAVING, and Date Functions

---

### Stored Procedure Operations

Automated workflows implemented for:

| Procedure | Purpose |
|----------|---------|
| `issue_book` | Checks availability & marks book as issued |
| `add_return_records` | Logs return entry & updates book status to available |

Ensures smooth operational flow similar to real library systems  
Reduces manual work and ensures data consistency

---

## Reports Generated

- Branch performance report (issues, returns, revenue)
- Employee issuance productivity report
- Category-wise rental analysis
- High-demand books overview
- Active members list
- Overdue and pending returns

Shows ability to convert data into meaningful business insights

---

## Conclusion

This project:
- Covers complete SQL lifecycle — design ➝ manipulation ➝ automation ➝ reporting
- Applies real-world library rules using stored procedures
- Provides reliable and analytical insights using SQL queries

Overall, this Library Management System establishes a strong foundation in SQL database management and supports scalable operational use in a real environment.

---

**End of README**  
