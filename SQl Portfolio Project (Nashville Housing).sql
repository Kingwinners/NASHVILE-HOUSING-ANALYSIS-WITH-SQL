
--cleaning data in sql queries

--standadized date format

select saledateconverted,convert(date,SaleDate)
from dbo.NashvilleHousing

update NashvilleHousing
set SaleDate = convert(date,SaleDate)

alter table NashvilleHousing
add Saledateconverted date;

update NashvilleHousing
set saledateconverted = convert(date,SaleDate)

--populate property address

select *
from dbo.NashvilleHousing
--where PropertyAddress is null
order by ParcelID


select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL (a.PropertyAddress,b.PropertyAddress)
from dbo.NashvilleHousing a
 JOIN dbo.NashvilleHousing b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID] <> b.[UniqueID]
 where a.PropertyAddress is null

 update a
 set PropertyAddress = ISNULL (a.PropertyAddress,b.PropertyAddress)
 from dbo.NashvilleHousing a
 JOIN dbo.NashvilleHousing b
 on a.ParcelID = b.ParcelID
 AND a.[UniqueID] <> b.[UniqueID]

 --Breaking out address into individual columns (address ,city, state)

 select PropertyAddress
from dbo.NashvilleHousing
--where PropertyAddress is null
--order by ParcelID

select
SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress)) as Address
from dbo.NashvilleHousing 

alter table NashvilleHousing
add PropertysplitAddress varchar(255)

update NashvilleHousing
set propertysplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',',PropertyAddress) -1) 

alter table NashvilleHousing
add propertysplitcity varchar(255)

update NashvilleHousing
set propertysplitcity =  SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))

select * from dbo.NashvilleHousing

--lets use somethimg aside SUBSTRING

select OwnerAddress
from dbo.NashvilleHousing

SELECT 
PARSENAME(replace(OwnerAddress,',','.'), 3)
,PARSENAME(replace(OwnerAddress,',','.'), 2)
,PARSENAME(replace(OwnerAddress,',','.'), 1)
from dbo.NashvilleHousing



alter table NashvilleHousing
add OwnersplitAddress varchar(255)

update NashvilleHousing
set OwnersplitAddress = PARSENAME(replace(OwnerAddress,',','.'), 3)

alter table NashvilleHousing
add Ownersplitcity varchar(255)

update NashvilleHousing
set Ownersplitcity =  PARSENAME(replace(OwnerAddress,',','.'), 2)

alter table NashvilleHousing
add Ownersplitstate varchar(255)

update NashvilleHousing
set Ownersplitstate = PARSENAME(replace(OwnerAddress,',','.'), 1) 


select * from dbo.NashvilleHousing



--change y and n to yes and no in the soldasvacant field

Select DISTINCT(SoldAsVacant),count(SoldAsVacant)
from dbo.NashvilleHousing
group by SoldAsVacant
order by 2

select SoldAsVacant
,CASE when SoldAsVacant = 'Y' then 'Yes'
     When SoldAsVacant = 'N' then 'No'
	 ELSE SoldAsVacant
	 END
	 FROM dbo.NashvilleHousing

update NashvilleHousing
set SoldAsVacant = CASE when SoldAsVacant = 'Y' then 'Yes'
     When SoldAsVacant = 'N' then 'No'
	 ELSE SoldAsVacant
	 END

---REMOVING DUPLICATES
with row_numCTE AS(
SELECT  *,
ROW_NUMBER()OVER(
PARTITION BY ParcelID,
PropertyAddress,
SalePrice,
SaleDate,
LegalReference
order by UniqueID
)
row_num
  
FROM dbo.NashvilleHousing
)
select *
FROM row_numCTE
where row_num > 1
order by PropertyAddress


--deleting unused column

select * from dbo.NashvilleHousing

alter table dbo.NashvilleHousing
drop column OwnerAddress,TaxDistrict,PropertyAddress

alter table dbo.NashvilleHousing
drop column SaleDate
