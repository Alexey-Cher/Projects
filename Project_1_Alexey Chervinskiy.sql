--------------------Creating of Database and Tables--------------------
CREATE DATABASE Airbnb

--List Of Tables:
--1.Apartment_Owners
--2.Region
--3.Apartments
--4.Customers
--5.Orders
--6.Payments
--------------------Apartment_Owners--------------------
USE Airbnb

CREATE TABLE Apartment_Owners
(OwnersID       INT IDENTITY (1,1),
First_Name      VARCHAR(25) NOT NULL,
Last_Name       VARCHAR(25) NOT NULL, 
Birth_Date      Date,
Join_date       DateTime,
Email           VARCHAR(50),
Phone           VARCHAR(25),
Address_of_Host VARCHAR(50),
City            VARCHAR(15),
Country         VARCHAR(15),
PostalCode      NVARCHAR(10),

CONSTRAINT OwnersID_pk PRIMARY KEY(OwnersID),
CONSTRAINT Email_ck CHECK(Email LIKE '%@%'),
CONSTRAINT Phone_uk UNIQUE(Phone),
CONSTRAINT Address_of_Host_un UNIQUE(Address_of_Host))

--------------------Region--------------------
CREATE TABLE Region
(RegionID INT IDENTITY(1,1) CONSTRAINT RegionID_pk PRIMARY KEY(RegionID),
City      VARCHAR(25) NOT NULL,
Country   VARCHAR(25) NOT NULL)

--------------------Apartments--------------------

CREATE TABLE Apartments
(ApartmentID       INT IDENTITY(1,1),
RegionID           INT,
OwnersID           INT,
Address_of_Apart   VARCHAR(50),
Type_of_Apartments VARCHAR(25),
Number_of_rooms    INT,
Wifi               VARCHAR(3),
Kitchen            VARCHAR(25),
Air_conditioning   VARCHAR(3),
Swimming_pool      VARCHAR(3),
Beds               INT,
Bedrooms           INT,
Bathrooms          INT,
Photo              IMAGE,

CONSTRAINT ApartmentID_pk PRIMARY KEY(ApartmentID),
CONSTRAINT OwnersID_fk FOREIGN KEY (OwnersID) REFERENCES Apartment_Owners(OwnersID),
CONSTRAINT RegionID_fk FOREIGN KEY (RegionID) REFERENCES Region(RegionID),
CONSTRAINT Address_of_Apart_uk UNIQUE(Address_of_Apart))

--------------------Orders--------------------
CREATE TABLE Orders
(OrderID         INT IDENTITY(1,1),
ApartmentID      INT,
CustomerID       INT,
Number_of_guests INT,
From_date        Date,
To_date          Date,
Number_of_days   INT,
Price_per_day    MONEY,
Discount         INT,
Pay_metod        VARCHAR(25) NOT NULL,

CONSTRAINT OrderID_pk PRIMARY KEY(OrderID),
CONSTRAINT ApartmentID_fk FOREIGN KEY (ApartmentID) REFERENCES Apartments(ApartmentID),
CONSTRAINT Number_of_guests_ck CHECK(Number_of_guests > 0), 
CONSTRAINT From_date_ck CHECK(datediff(dd,From_date,To_date)>1),
CONSTRAINT Price_per_day_ck CHECK(Price_per_day > 0))

--------------------Customers--------------------
CREATE TABLE Customers
(CustomerID			INT IDENTITY(1,1), 
OrderID				INT,
First_Name			VARCHAR(25) NOT NULL,
Last_Name			VARCHAR(25) NOT NULL,
Birth_Date			Date,
Join_date			DateTime,
Email				VARCHAR(50),
Phone			    VARCHAR(25),
Address_of_Customer VARCHAR(50),
City				VARCHAR(25),
Country				VARCHAR(25),
PostalCode			INT,

CONSTRAINT CustomerID_pk PRIMARY KEY(CustomerID),
CONSTRAINT OrderID_fk FOREIGN KEY(OrderID) REFERENCES Orders(OrderID),
CONSTRAINT ck_Email CHECK(Email LIKE '%@%'),
CONSTRAINT Address_uk UNIQUE(Address_of_Customer))

--------------------Payments--------------------
CREATE TABLE Payments
(PaymentID    INT IDENTITY(1,1),
OrderID       INT,
CustomerID    INT,
Amount        Money,
Date_of_pay   DATE,
Price_per_day Money,
Discount      INT,
Pay_metod     VARCHAR(25) NOT NULL,

CONSTRAINT PaymentID_pk PRIMARY KEY(PaymentID),
CONSTRAINT fk_OrderID FOREIGN KEY (OrderID) REFERENCES Orders(OrderID),
CONSTRAINT CustomerID_fk FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
CONSTRAINT Amount_ck CHECK(Amount > 0))

----------------------------------------------Insert the demo data------------------------------------------------------------
USE Airbnb

--1.Apartment_Owners
SET IDENTITY_INSERT Apartment_Owners ON
insert into Apartment_Owners (OwnersID, First_name, Last_name, Birth_Date, Join_date, email, Phone, Address_of_Host, City, Country, PostalCode)
values 
(1, 'Benedick', 'Joscelyne', '5/16/2020', '8/10/2020', 'bjoscelyne0@wikipedia.org', '164-582-2621', '8466 Onsgard Park', 'Khuzhir', 'Russia', null),
(2, 'Purcell', 'Driutti', '5/17/2020', '12/21/2020', 'pdriutti1@bigcartel.com', '124-778-6746', '438 Nancy Trail', 'Warin Chamrap', 'Thailand', null),
(3, 'Babb', 'Maxweell', '9/16/2020', '8/21/2020', 'bmaxweell2@sfgate.com', '256-791-2573', '4318 8th Alley', 'Fanyang', 'China', null),
(4, 'Isacco', 'Graves', '6/11/2020', '10/25/2020', 'igraves3@businessinsider.com', '888-434-8462', '0 Longview Hill', 'Barentu', 'Eritrea', null),
(5, 'Devlin', 'Purvis', '12/10/2020', '7/7/2020', 'dpurvis4@163.com', '177-217-3871', '35602 Glacier Hill Parkway', 'Šenkovec', 'Croatia', null),
(6, 'Lari', 'Levee', '11/17/2020', '3/5/2020', 'llevee5@npr.org', '313-453-5974', '608 Merrick Avenue', 'Dumbéa', 'New Caledonia', null),
(7, 'Hill', 'Danet', '10/20/2020', '8/8/2020', 'hdanet6@weebly.com', '923-570-7445', '47581 Waxwing Park', 'Vidual', 'Portugal', null),
(8, 'Eimile', 'Omrod', '5/7/2020', '10/16/2020', 'eomrod7@theguardian.com', '696-226-3632', '446 Sachtjen Plaza', 'Tanjungbatu', 'Indonesia', null),
(9, 'Tommy', 'Maguire', '9/27/2020', '1/28/2020', 'tmaguire8@jiathis.com', '307-104-6947', '935 Amoth Park', 'Smara', 'Western Sahara', null),
(10, 'Paige', 'Dunckley', '11/23/2020', '11/18/2020', 'pdunckley@print.com', Null, '03 Farmco Lane', 'Ermelo', 'Portugal', null)
SET IDENTITY_INSERT Apartment_Owners OFF

--2.Region
SET IDENTITY_INSERT Region ON
insert into Region (RegionID , City, Country) values 
(1, 'Chiquimulilla', 'Guatemala'),
(2, 'Lelekovice', 'Czech Republic'),
(3, 'Suchań', 'Poland'),
(4, 'Nagcarlan', 'Philippines'),
(5, 'Jambubol', 'Indonesia'),
(6, 'Panxi', 'China'),
(7, 'Bakuriani', 'Georgia'),
(8, 'Poputnaya', 'Russia'),
(9, 'Jiguan', 'China'),
(10, 'Ćuprija', 'Serbia')
SET IDENTITY_INSERT Region OFF

--3.Apartments
SET IDENTITY_INSERT Apartments ON
insert into Apartments (ApartmentID, RegionID, OwnersID, Address_of_Apart, Type_of_Apartments, Number_of_rooms, Wifi, Kitchen, Air_conditioning, Swimming_pool, Beds, Bedrooms, Photo)
values 
(1, null, null, '25160 Coleman Junction', '3XL', 8, 'Yes', 'Yes', 'Yes', 'No', 2, 1, null),
(2, null, null, '3 Bobwhite Point', 'XS', 5, 'Yes', 'Yes', 'Yes', 'No', 4, 2, null),
(3, null, null, '1251 Macpherson Terrace', 'XS', 10, 'Yes', 'Yes', 'Yes', 'No', 1, 1, null),
(4, null, null, '57 Crescent Oaks Hill', 'XS', 7, 'Yes', 'Yes', 'Yes', 'No', 4, 1, null),
(5, null, null, '062 Stoughton Parkway', '2XL', 7, 'Yes', 'Yes', 'Yes', 'No', 4, 2, null),
(6, null, null, '7442 Bultman Trail', 'XS', 3, 'Yes', 'Yes', 'Yes', 'No', 2, 1, null),
(7, null, null, '42 Arizona Crossing', '3XL', 3, 'Yes', 'Yes', 'Yes', 'No', 1, 1, null),
(8, null, null, '8 Karstens Drive', 'XS', 10, 'Yes', 'Yes', 'Yes', 'No', 4, 1, null),
(9, null, null, '7260 Glendale Street', '2XL', 1, 'Yes', 'Yes', 'Yes', 'No', 3, 2, null),
(10, null, null, '541 Lakewood Gardens Junction', 'L', 3, 'Yes', 'Yes', 'Yes', 'No', 2, 2, null)
SET IDENTITY_INSERT Apartments OFF

--4.Orders
SET IDENTITY_INSERT Orders ON
insert into Orders (OrderID, ApartmentID , CustomerID, Number_of_guests, From_date, To_date, Number_of_days, Price_per_day, Discount, Pay_metod) 
values 
(1, null, null, 7, '2021-03-27 14:43:31', '2021-04-27 00:22:00', 7, '$3.90', 14, 'diners-club-international'),
(2, null, null, 6, '2021-06-14 05:57:31', '2021-11-11 03:44:55', 1, '$1.55', 25, 'visa-electron'),
(3, null, null, 6, '2021-03-14 00:57:37', '2021-04-30 20:21:17', 11, '$5.51', 13, 'switch'),
(4, null, null, 4, '2021-10-10 05:20:16', '2021-11-30 20:20:31', 5, '$9.21', 22, 'mastercard'),
(5, null, null, 1, '2021-01-16 17:10:22', '2021-01-23 17:23:25', 6, '$0.49', 22, 'jcb'),
(6, null, null, 7, '2021-02-26 03:19:19', '2021-03-04 02:49:58', 4, '$0.64', 8, 'jcb'),
(7, null, null, 7, '2021-10-10 05:20:16', '2021-11-11 03:44:55', 7, '$4.66', 7, 'china-unionpay'),
(8, null, null, 4, '2021-05-05 14:54:01', '2021-06-21 15:51:22', 6, '$2.02', 18, 'maestro'),
(9, null, null, 7, '2021-02-23 14:45:05', '2021-04-24 22:15:56', 10, '$2.00', 24, 'jcb'),
(10, null, null, 3, '2020-09-25 19:01:11', '2021-05-25 15:44:00', 10, '$0.86', 23, 'mastercard')
SET IDENTITY_INSERT Orders OFF

--5.Customers
SET IDENTITY_INSERT Customers ON
insert into Customers (CustomerID, OrderID, First_Name, Last_Name, Birth_Date, Join_date, Email, Phone, Address_of_Customer, City, Country, PostalCode)
values 
(1, NULL, 'Frédérique', 'Ahearne', '4/5/1998', '9/16/2021', 'rahearne0@infoseek.co.jp', '130-715-4955', '0 Village Green Street', 'Alebtong', 'Uganda', null),
(2, NULL, 'Börje', 'Tolliday', '9/25/1984', '8/11/2021', 'ctolliday1@sfgate.com', '697-551-9469', '90033 Brickson Park Avenue', 'Bošnjaci', 'Croatia', null),
(3, NULL, 'Håkan', 'Juggins', '9/2/1988', '6/4/2021', 'cjuggins2@berkeley.edu', '956-382-4526', '45 Declaration Hill', 'Bayuwan', 'Indonesia', null),
(4, NULL, 'Kallisté', 'Letford', '9/24/1987', '12/6/2021', 'dletford3@admin.ch', '545-930-2161', '72569 Hayes Court', 'Płoniawy-Bramura', 'Poland', null),
(5, NULL, 'Eloïse', 'Balle', '3/21/1986', '2/6/2021', 'fballe4@harvard.edu', '916-532-1079', '97922 Moose Park', 'Lhari', 'China', null),
(6, NULL, 'Maïly', 'Abotson', '1/20/1993', '10/17/2021', 'aabotson5@joomla.org', '919-826-8086', '04 Montana Drive', 'Jaguaribe', 'Brazil', null),
(7, NULL, 'Maëly', 'Piddle', '10/10/1984', '9/19/2021', 'vpiddle6@livejournal.com', '852-956-0043', '0 American Ash Terrace', 'Telgawah', 'Indonesia', null),
(8, NULL, 'Styrbjörn', 'Peachman', '10/19/2001', '4/22/2021', 'speachman7@netvibes.com', '336-711-9218', '2436 Fordem Plaza', 'Guanay', 'Bolivia', null),
(9, NULL, 'Célestine', 'Guillart', '1/22/1980', '9/27/2021', 'oguillart8@cbslocal.com', '884-833-7985', '005 Lukken Center', 'Celso Ramos', 'Brazil', null),
(10, NULL, 'Marie-josée', 'Canaan', '4/6/2001', '1/1/2022', 'jcanaan9@prlog.org', '367-615-3841', '2 Vera Crossing', 'Coruripe', 'Brazil', null)
SET IDENTITY_INSERT Customers OFF

--6.Payments
SET IDENTITY_INSERT Payments ON
insert into Payments (PaymentID, OrderID, CustomerID, Amount, Date_of_pay, Price_per_day, Discount, Pay_metod)
values (1, NULL, NULL, '$158', '6/29/2020', '$5.72', 1, 'mastercard'),
(2, NULL, NULL, '$168', '3/29/2020', '$6.64', 3, 'jcb'),
(3, NULL, NULL, '$127', '6/11/2020', '$3.83', 9, 'americanexpress'),
(4, NULL, NULL, '$172', '10/14/2020', '$8.37', 1, 'jcb'),
(5, NULL, NULL, '$190', '3/9/2020', '$6.38', 8, 'china-unionpay'),
(6, NULL, NULL, '$115', '3/28/2020', '$2.28', 6, 'jcb'),
(7, NULL, NULL, '$157', '5/7/2020', '$5.70', 9, 'jcb'),
(8, NULL, NULL, '$180', '8/7/2020', '$5.52', 2, 'jcb'),
(9, NULL, NULL, '$169', '11/4/2020', '$0.63', 3, 'visa-electron'),
(10, NULL, NULL, '$149', '11/4/2020', '$1.86', 2, 'china-unionpay')
SET IDENTITY_INSERT Payments OFF