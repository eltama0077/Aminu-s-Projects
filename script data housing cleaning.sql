SELECT * FROM portfolio.nashville_hd;
alter table nashville_hd rename column ï»¿UniqueID to UniqueID; 
-- Date standardization
SELECT SaleDate, str_to_date(saledate, '%M %d, %Y') as Saleconverteddate FROM portfolio.nashville_hd;
alter table nashville_hd add Saleconverteddate datetime;
SET SQL_SAFE_UPDATES =0;
update nashville_hd set Saleconverteddate = str_to_date(saledate, '%M %d, %Y') ;
SET SQL_SAFE_UPDATES =1;
select ParcelID, SaleDate, convert(saleconverteddate,date) from nashville_hd;
alter table nashville_hd modify Saleconverteddate date;
select saledate, saleconverteddate  from nashville_hd;

-- where address is null
select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ifnull(a.PropertyAddress, b.PropertyAddress)
 from nashville_hd a
join nashville_hd b
on a.ParcelID = b.ParcelID
and a.UniqueID != B.UniqueID
where a.PropertyAddress is null;
select substr(propertyaddress,1, char(',', PropertyAddress)) as address from nashville_hd
where PropertyAddress is null
