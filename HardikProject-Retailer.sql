CREATE DATABASE HardikProject;
GO


USE HardikProject;
GO


CREATE SCHEMA Retailer;
GO

DROP TABLE Retailer.Supplier;
GO


CREATE TABLE Retailer.Supplier
(
  SupplierId INT NOT NULL CONSTRAINT PKSupplier PRIMARY KEY (SupplierId) IDENTITY(1,1) ,
  SupplierName VARCHAR(50) NOT NULL,
  SupplierAddress VARCHAR(200) NOT NULL,
  ContactNumber varchar(10) NOT NULL
);
GO

DROP TABLE Retailer.Inventory;
GO

CREATE TABLE Retailer.Inventory
(
   StockId INT NOT NULL CONSTRAINT PKInventory PRIMARY KEY (StockId) IDENTITY(1,1),
   StockName VARCHAR(200) NOT NULL,
   Quantity INT NOT NULL,
   SupplierId INT NOT NULL CONSTRAINT FKInventory_Ref_Supplier REFERENCES Retailer.Supplier (SupplierId),
   MinimumQuantity INT NOT NULL,
   SellingPrice DECIMAL (6,2) NOT NULL,
   PurchasePrice DECIMAL (6,2) NOT NULL
);
GO


DROP TABLE Retailer.Customer;
GO

CREATE TABLE Retailer.Customer
(
  CustomerId INT NOT NULL CONSTRAINT PKCustomer PRIMARY KEY (CustomerId) IDENTITY(1,1),
  CustomerName VARCHAR(50) NOT NULL,
  CustomerAddress VARCHAR(200) NOT NULL,
  EmailId VARCHAR(50) NOT NULL,
  ContactNumber DECIMAL(10,0) NOT NULL
);
GO




CREATE TABLE Retailer.Payment
(
  PaymentId INT NOT NULL CONSTRAINT PKPayment PRIMARY KEY (PaymentId) IDENTITY(1,1),
  PaymentStatus VARCHAR(25) NOT NULL
);
GO

DROP TABLE Retailer.Orders;
GO

CREATE TABLE Retailer.Orders
(
   OrdersId INT NOT NULL CONSTRAINT PKOrders PRIMARY KEY (OrdersId) IDENTITY(1,1),
   StockId INT NOT NULL CONSTRAINT FKOrders_Ref_Inventory REFERENCES Retailer.Inventory (StockId),
   PaymentId INT NOT NULL CONSTRAINT FKOrders_Ref_Payment REFERENCES Retailer.Payment (PaymentId),
   CustomerId INT NOT NULL CONSTRAINT FKOrders_Ref_Customer REFERENCES Retailer.Customer (CustomerId),
   OrdersQuantity INT NOT NULL,
   CheckoutPirce DECIMAL (6,2) NOT NULL,
   OrdersDate DATE NOT NULL
);
GO

ALTER TABLE Retailer.Orders
   DROP COLUMN CheckoutPirce;
GO

ALTER TABLE Retailer.Orders
    ADD CheckoutPrice DECIMAL (6,2) NOT NULL;
GO


DROP TABLE Retailer.Shipment;
GO

CREATE TABLE Retailer.Shipment
(
  ShipmentId INT NOT NULL CONSTRAINT PKShipment PRIMARY KEY (ShipmentId) IDENTITY(1,1),
  OrdersId INT NOT NULL CONSTRAINT FKShipment_Ref_Orders REFERENCES Retailer.Orders (OrdersId),
  TrackingId INT NOT NULL UNIQUE ,
  ShipmentDate DATE NOT NULL,
  ExpectedDeliveryDate DATE NOT NULL
);
GO

CREATE SCHEMA Profit;
GO

CREATE PROCEDURE Profit.MonthlyProfitReportByMonth
(
	@Month INT
)
AS
	SELECT Orders.OrdersQuantity, Orders.CheckoutPrice,
		  SUM((SellingPrice - PurchasePrice) * OrdersQuantity) AS ProfitMargin
	FROM Retailer.Inventory JOIN Retailer.Orders ON Inventory.StockId = Orders.StockId
	     
	where DATEPART(MONTH, OrdersDate) = @Month
	GROUP BY Inventory.PurchasePrice,Orders.OrdersQuantity,
		   Orders.CheckoutPrice,Inventory.SellingPrice,
		   Orders.OrdersDate;
GO


EXEC  Profit.MonthlyProfitReportByMonth @Month=4;
GO


CREATE INDEX IDX_Inventory_Quantity ON Retailer.Inventory (Quantity)
	WHERE Quantity < 20;
GO

CREATE FUNCTION Retailer.Customers_ReturnOrderCountSetSimple
(
   @CustomerId int,
   @OrdersDate date null
)
RETURNS TABLE
AS
RETURN ( SELECT COUNT(*) AS SalesCount,
                 CASE WHEN MAX(PaymentId) IS NOT NULL   
				            THEN 1 ELSE 0 END AS Tag
		 FROM Retailer.Orders
		 WHERE CustomerId = @CustomerId
		 AND   (OrdersDate = @OrdersDate
		               OR @OrdersDate IS NULL));
GO


SELECT CustomerId, FirstDaySales.SalesCount, FirstDaySales.Tag
FROM Retailer.Orders
     OUTER APPLY Retailer.Customers_ReturnOrderCountSetSimple
	           (CustomerId, OrdersDate) as FirstDaySales
WHERE FirstDaySales.SalesCount > 0;
GO

CREATE FUNCTION Retailer.Customers_ReturnOrderCount
(
  @CustomerId int,
  @OrdersDate date = null
)
RETURNS INT
WITH RETURNS NULL ON NULL INPUT,
SCHEMABINDING
AS
   BEGIN DECLARE @OutputValue int

   SELECT @OutputValue = COUNT(*)
   FROM Retailer.Orders
   WHERE CustomerId = @CustomerId
      AND (OrdersDate = @OrdersDate OR @OrdersDate IS NULL);

	   RETURN @OutputValue
 END;
GO


SELECT CustomerId, Retailer.Customers_ReturnOrderCount(CustomerId, OrdersDate) AS ALLORDERS
FROM Retailer.Orders;
GO

CREATE VIEW Retailer.Summary
AS
SELECT Payment.PaymentId, Payment.PaymentStatus, Customer.CustomerId, 
       CASE WHEN PaymentStatus = 0 THEN 'Defaulter'
	        else 'Regular' END AS RegularCustomer
FROM Retailer.Payment
    JOIN Retailer.Orders
	       on Orders.PaymentId = Payment.PaymentId
		      JOIN Retailer.Customer
			 on Customer.CustomerId = Orders.CustomerId;
	go	    

	select * from Retailer.Summary;
	GO



