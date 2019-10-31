--2.1 SELECT
--Task – Select all records from the Employee table.
Select * From Employee;

--Task – Select all records from the Employee table where last name is King.
Select * From Employee
Where LASTNAME = 'King';

--Task – Select all records from the Employee table where first name is Andrew and REPORTSTO is NULL.
Select * From Employee
Where FIRSTNAME = 'Andrew'
And REPORTSTO is null;


--2.2 ORDER BY
--Task – Select all albums in Album table and sort result set in descending order by title.
Select * From Album
Order By title desc;

--Task – Select first name from Customer and sort result set in ascending order by city
Select firstname From Customer
Order By city;


--2.3 INSERT INTO
--Task – Insert two new records into Genre table
Insert Into Genre
Values (26, 'Christian');
Insert Into Genre
Values (27, 'Video Game');

--Task – Insert two new records into Employee table
Insert Into Employee
Values (9, 'Freeman', 'Cliff', 'IT Staff', 6, TO_DATE('1986-10-08 00:00:00', 'yyyy-mm-dd hh24:mi:ss'), TO_DATE('2007-04-29 00:00:00', 'yyyy-mm-dd hh24:mi:ss'), '1234 Something Way', 'Weird City', 'VA', 'USA', '64456', '+1 (736) 561-8490', '+1 (417) 6452-8710', 'cliff@chinookcorp.com');
Insert Into Employee
Values (10, 'Humperdink', 'Prince', 'IT Staff', 6, TO_DATE('1965-01-25 00:00:00', 'yyyy-mm-dd hh24:mi:ss'), TO_DATE('1999-07-01 00:00:00', 'yyyy-mm-dd hh24:mi:ss'), '4567 Haha Blvd', 'Noneya', 'AL', 'USA', '41387', '+1 (555) 984-7697', '+1 (798) 112-9999', 'humperdink@chinookcorp.com');

--Task – Insert two new records into Customer table
Insert Into Customer
Values (60, 'Skywalker', 'Luke', 'Rebel Alliance', 'Far Away Galaxy', 'Tatooine', 'SP', 'USA', '44444', '+1 (899) 444-4444', '+1 (511) 909-9090', 'skywalker@alliance.net', 3);
Insert Into Customer
Values (61, 'Organa', 'Leia', 'Rebel Alliance', 'Far Away Galaxy', 'Alderaan', 'SP', 'USA', '44444', '+1 (899) 444-4444', '+1 (511) 909-9090', 'organa@alliance.net', 3);

--2.4 UPDATE
--Task – Update Aaron Mitchell in Customer table to Robert Walter
Update Customer
Set firstname = 'Robert', lastname = 'Walter'
Where customerid = 32;

--Task – Update name of artist in the Artist table “Creedence Clearwater Revival” to “CCR”
Update Artist
Set name = 'CCR'
Where name = 'Creedence Clearwater Revival';

--2.5 LIKE
--Task – Select all invoices with a billing address like “T%”
Select * From Invoice
Where billingaddress Like 'T%';

--2.6 BETWEEN
--Task – Select all invoices that have a total between 15 and 50
Select * From Invoice
Where total Between 15 And 50;

--Task – Select all employees hired between 1st of June 2003 and 1st of March 2004
Select * From Employee
Where hiredate Between TO_DATE('06/01/2003', 'mm/dd/yyyy') And TO_DATE('03/01/2004', 'mm/dd/yyyy');


--2.7 DELETE
--Task – Delete a record in Customer table where the name is Robert Walter (There may be constraints that rely on this, find out how to resolve them).
Delete From InvoiceLine
Where invoiceid In (Select invoiceid From Invoice
    Where customerid = (Select customerid From Customer
        Where Customer.firstname = 'Robert' And Customer.lastname = 'Walter'));

Delete From Invoice
Where customerid = (Select customerid From Customer
    Where Customer.firstname = 'Robert' And Customer.lastname = 'Walter');

Delete From Customer
Where firstname = 'Robert' And lastname = 'Walter';


--3.1 System Defined Functions
--Task – Create a function that returns the current time.
Select SYSTIMESTAMP From dual;

--Task – create a function that returns the length of a mediatype from the mediatype table
Select vsize(mediatypeid) + vsize(name) From mediatype;


--3.2 System Defined Aggregate Functions
--Task – Create a function that returns the average total of all invoices
Select AVG(total) From Invoice;

--Task – Create a function that returns the most expensive track
Select MAX(unitprice) From Track;


--3.3 User Defined Scalar Functions
--Task – Create a function that returns the average price of invoiceline items in the invoiceline table
Create Or Replace Function avgPrice Return Number Is
avg_cost Number(4,2);
Begin
    Select Avg(Invoiceline.unitprice)
    Into avg_cost
    From Invoiceline;
    Return avg_cost;
End;
/
Select avgPrice From dual; --returns $1.04


--3.4 User Defined Table Valued Functions
--Task – Create a function that returns all employees who are born after 1968.
Create Or Replace Function findEmployees Return Cursor Is
my_cursor SYS_REFCURSOR;
Begin
    Open my_cursor For 
    Select * From Employee
    Where birthdate > DATE '1968/12/31';
    Return my_cursor;
End;
/

--4.1 Basic Stored Procedure
--Task – Create a stored procedure that selects the first and last names of all the employees.
Create Or Replace Procedure firstLast(name_cursor OUT SYS_REFCURSOR) Is
Begin
    Open name_cursor For
    Select firstname, lastname From employee;
End;    
/

Variable fl_cursor refcursor;
Execute firstLast(:fl_cursor);
Print fl_cursor;


--4.2 Stored Procedure Input Parameters
--Task – Create a stored procedure that updates the personal information of an employee.
Create Or Replace Procedure firstLast(n_lastname varchar2, n_firstname varchar2, n_title varchar2, n_reportsto number, n_birthdate date, n_hiredate date, n_address varchar2, n_city varchar2, n_state varchar2, n_country varchar2, n_postalcode varchar2, n_phone varchar2, n_fax varchar2, n_email varchar2) Is
Begin
    UPDATE employee SET lastname = n_lastname, firstname = n_firstname, title = n_title, reportsto = n_reportsto, birthdate = n_birthdate, hiredate = n_hiredate, address = n_address, city = n_city, state = n_state, country = n_country, postalcode = n_postalcode, phone = n_phone, fax = n_fax, email = n_email;
End;    
/

--Task – Create a stored procedure that returns the managers of an employee.
Create Or Replace Procedure managers(fname IN varchar2, lname IN varchar2, name_cursor OUT SYS_REFCURSOR) Is
Begin
    Open name_cursor For
    Select firstname, lastname From employee;
End;    
/


--4.3 Stored Procedure Output Parameters
--Task – Create a stored procedure that returns the name and company of a customer.
Create Or Replace Procedure nameComp(name_cursor OUT SYS_REFCURSOR) Is
Begin
    Open name_cursor For
    Select firstname, lastname, company From customer;
End;
/
Variable fl_cursor refcursor;
Execute nameComp(:fl_cursor);
Print fl_cursor;


--6.1 AFTER/FOR
--Task - Create an after insert trigger on the employee table fired after a new record is inserted into the table.
Create Or Replace Trigger afterNewRecord
After Insert On employee
Begin
    Print('new record inserted');
End;    
/

--Task – Create an after update trigger on the album table that fires after a row is inserted in the table
--Task – Create an after delete trigger on the customer table that fires after a row is deleted from the table.
--Task – Create a trigger that restricts the deletion of any invoice that is priced over 50 dollars.


--7.1 INNER
--Task – Create an inner join that joins customers and orders and specifies the name of the customer and the invoiceId.
Select Customer.firstname, Customer.lastname, Invoice.invoiceid
From Customer Inner Join Invoice
On Customer.customerid = Invoice.customerid;

--7.2 OUTER
--Task – Create an outer join that joins the customer and invoice table, specifying the CustomerId, firstname, lastname, invoiceId, and total.
Select Customer.customerid, Customer.firstname, Customer.lastname, Invoice.invoiceid, Invoice.total
From Customer Full Outer Join Invoice
On Customer.customerid = Invoice.customerid;

--7.3 RIGHT
--Task – Create a right join that joins album and artist specifying artist name and title.
Select Album.title, Artist.name
From Album Right Join Artist
On Album.artistid = Artist.artistid;

--7.4 CROSS
--Task – Create a cross join that joins album and artist and sorts by artist name in ascending order.
Select * From Album, Artist
Order by Artist.name Asc;

--7.5 SELF
--Task – Perform a self-join on the employee table, joining on the reportsto column.
Select * From Employee e1 Join Employee e2
On e2.employeeid = e1.reportsto;

commit;










