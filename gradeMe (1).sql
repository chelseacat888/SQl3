/* 
Module 7 Chapter 5 Exercises
Chelsea Smith
ITSE 2309

*/


--1



USE ap_DB;

SELECT VendorID, SUM(PaymentTotal) AS paymentSum
FROM dbo.Invoices
GROUP BY VendorID;

--2


SELECT VendorName, SUM(PaymentTotal) AS paymentSum
FROM dbo.Invoices INNER JOIN dbo.Vendors
	ON dbo.Invoices.VendorID = dbo.Vendors.VendorID
GROUP BY VendorName
ORDER BY paymentSum;




--3
USE ap_DB;

SELECT VendorName, COUNT(InvoiceTotal) AS invoiceCount, SUM(InvoiceTotal) AS invoiceSum
FROM dbo.Invoices INNER JOIN dbo.Vendors
	ON dbo.Invoices.VendorID = dbo.Vendors.VendorID
GROUP BY VendorName
ORDER BY invoiceCount DESC;


--4

USE ap_DB;

SELECT AccountDescription,COUNT(*) AS lineItemCount, SUM(InvoiceLineItemAmount) AS lineItemSum
FROM dbo.InvoiceLineItems INNER JOIN dbo.GLAccounts
	ON dbo.InvoiceLineItems.AccountNo = dbo.GLAccounts.AccountNo
GROUP BY AccountDescription HAVING COUNT(*) >1
ORDER BY lineItemCount DESC;



--5

USE ap_DB;


SELECT AccountDescription, COUNT(AccountNo) AS Cash
FROM dbo.GLAccounts
GROUP BY AccountDescription HAVING COUNT(AccountNo) > 1;


--6

USE ap_DB;

SELECT	AccountDescription,
		COUNT(*) AS lineItemCount, 
		SUM(InvoiceLineItemAmount) AS lineItemSum
/*
FROM dbo.InvoiceLineItems INNER JOIN dbo.GLAccounts
	ON dbo.InvoiceLineItems.AccountNo = dbo.GLAccounts.AccountNo
 INNER JOIN dbo.Invoices ON dbo.Invoices.InvoiceID = dbo.InvoiceLineItems.InvoiceID

 OK, start with the highest table: in this case, that's invoices.
 Now, go down left to right.
 invoices --> invoiceLineItems --> GLAccounts
*/ 
FROM invoices AS i INNER JOIN invoiceLineItems AS l
	ON i.invoiceID=l.invoiceID
	INNER JOIN GLAccounts AS g
		ON l.accountNo=g.accountNo
WHERE invoiceTotal > 1000
	GROUP BY AccountDescription -- you forgot HAVING COUNT(*)>1
ORDER BY lineItemCount DESC;
/*
	If you have "A join B join C", then "C join B join A" will work,
	but not "A join C join B"  Just work from top down.
*/


--7

USE ap_DB;

SELECT VendorName, AccountDescription, SUM(InvoiceLineItemAmount) AS lineItemSum, COUNT(*) AS lineItemCount
FROM dbo.InvoiceLineItems INNER JOIN dbo.GLAccounts
	ON dbo.InvoiceLineItems.AccountNo = dbo.GLAccounts.AccountNo
 INNER JOIN dbo.Invoices ON dbo.Invoices.InvoiceID = dbo.InvoiceLineItems.InvoiceID 
 INNER JOIN dbo.Vendors ON dbo.Vendors.VendorID  = dbo.Invoices.VendorID
 GROUP BY VendorName, AccountDescription;



 --8
 SELECT VendorName, --COUNT(*) AS lineItemCount2
					COUNT(DISTINCT accountNo) AS lineItemCount2
 FROM dbo.InvoiceLineItems INNER JOIN dbo.Invoices
	ON dbo.InvoiceLineItems.InvoiceID = dbo.Invoices.InvoiceID
   INNER JOIN dbo.Vendors ON dbo.Vendors.VendorID = dbo.Invoices.VendorID
GROUP BY VendorName HAVING --COUNT(*) > 1;
							COUNT(DISTINCT accountNo)>1;
