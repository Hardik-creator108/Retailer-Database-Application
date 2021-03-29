
USE HardikProject;
GO

SELECT * FROM Retailer.Inventory;
GO


SELECT * FROM Retailer.Supplier;
GO

SELECT * FROM Retailer.Customer;
GO

SELECT * FROM Retailer.Orders;
GO

SELECT * FROM Retailer.Payment;
GO

SELECT * FROM Retailer.Shipment;
GO

SELECT CustomerId, FirstDaySales.SalesCount, FirstDaySales.Tag
FROM Retailer.Orders
     OUTER APPLY Retailer.Customers_ReturnOrderCountSetSimple
	           (CustomerId, OrdersDate) as FirstDaySales
WHERE FirstDaySales.SalesCount > 0;
GO

SELECT CustomerId, Retailer.Customers_ReturnOrderCount(CustomerId, OrdersDate) AS ALLORDERS
FROM Retailer.Orders;
GO

EXEC  Profit.MonthlyProfitReportByMonth @Month=4;
GO

SELECT * FROM Retailer.Summary;
GO

SELECT * FROM Retailer.Inventory WHERE Quantity < 20;
GO


