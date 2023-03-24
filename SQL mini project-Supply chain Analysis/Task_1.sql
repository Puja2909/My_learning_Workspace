create table Region
(
Region_id int primary key,
Name varchar
);

create table Sales_rep
(
Sales_rep_id int primary key,
Name varchar,
Region_id int,
foreign key(Region_id) references Region(Region_id)
);

create table Accounts
(
Account_id int primary key,
Name varchar,
Website varchar,
Lat float,
Long float,
Primary_poc varchar,
Sales_rep_id int,
foreign key(Sales_rep_id) references Sales_rep(Sales_rep_id)
);

create table Web_events
(
Web_event_id int primary key,
Account_id int,
Occured_at timestamp,
Channel varchar,
foreign key(Account_id) references Accounts(Account_id)
);

create table Orders
(
Orders_id int primary key,
Account_id int,
Occured_at timestamp,
Standard_qty int,
Gloss_qty int,
Poster_qty int,
Total int,
Standard_amt_usd float,
Gloss_amt_usd float,
Poster_amt_usd float,
Total_amt_usd float,
foreign key(Account_id) references Accounts(Account_id)
);