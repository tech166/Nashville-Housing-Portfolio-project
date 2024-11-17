
/*

--CLEANING DATA IN SQL QUERIES

*/

Select *
from Nashville_Housing

--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

--Standardize Date format

Select SaleDate, CONVERT(Date,SaleDate)
from Nashville_Housing


-------------------------------------------------------------------------------------------------------------------------------------------------------

--Populate property address data

Select propertyaddress
from Nashville_Housing
where  propertyaddress is null

Select *
from Nashville_Housing
--where  propertyaddress is null
order by ParcelID

Select a.ParcelID, a.propertyaddress, b.ParcelID, b.propertyaddress,ISNULL(a.propertyaddress,b.propertyaddress)
from Nashville_Housing a
JOIN Nashville_Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.propertyaddress is null

Update a
SET propertyaddress = ISNULL(a.propertyaddress,b.propertyaddress)
from Nashville_Housing a
JOIN Nashville_Housing b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID] <> b.[UniqueID]
where a.propertyaddress is null



-------------------------------------------------------------------------------------------------------------------------------

--Breaking out Address into Individual colums (Address, city, state)

Select propertyaddress
from Nashville_Housing
--where  propertyaddress is null
--order by ParcelID


SELECT
SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress)-1) as Address
,SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) + 1, LEN(propertyaddress)) as Address

FROM Nashville_Housing

SELECT
    SUBSTRING(propertyaddress, 1, CHARINDEX(',', propertyaddress) - 1) AS Address,
    SUBSTRING(propertyaddress, CHARINDEX(',', propertyaddress) + 1, LEN(propertyaddress) - CHARINDEX(',', propertyaddress) - 1) AS Address   

FROM Nashville_Housing;



ALTER TABLE Nashville_Housing
Add propertySplitaddress Nvarchar(255);

UPDATE Nashville_Housing
SET propertySplitaddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1);

ALTER TABLE Nashville_Housing
Add PropertySplitCity Nvarchar(255);

update Nashville_Housing
SET PropertySplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1, LEN(PropertyAddress))





Select*

from Nashville_Housing

Select OwnerAddress

from Nashville_Housing

Select
PARSENAME(REPLACE(OwnerAddress,',','.') ,3)
,PARSENAME(REPLACE(OwnerAddress,',','.') ,2)
,PARSENAME(REPLACE(OwnerAddress,',','.') ,1)
from Nashville_Housing

ALTER TABLE Nashville_Housing
Add OwnerSplitaddress Nvarchar(255);

UPDATE Nashville_Housing
SET OwnerSplitaddress = PARSENAME(REPLACE(OwnerAddress,',','.') ,3)

ALTER TABLE Nashville_Housing
Add OwnerSplitCity Nvarchar(255);

update Nashville_Housing
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress,',','.') ,2)

ALTER TABLE Nashville_Housing
Add OwnerSplitstate Nvarchar(255);

UPDATE Nashville_Housing
SET OwnerSplitstate = PARSENAME(REPLACE(OwnerAddress,',','.') ,1)


Select *
from Nashville_Housing

---------------------------------------------------------------------------------------------------------------

--Change Y and N to yes and No in "sold as vacant" field

select Distinct(SoldAsVacant), COUNT(SoldAsVacant)
from Nashville_Housing
Group by SoldAsVacant
order by 2


SELECT SoldAsVacant,
       CASE 
           WHEN SoldAsVacant = '1' THEN 'Yes'
           WHEN SoldAsVacant = '0' THEN 'No'
       END AS VacancyStatus
FROM Nashville_Housing;

ALTER TABLE Nashville_Housing

ALTER COLUMN SoldAsVacant BIT;
UPDATE Nashville_Housing
SET SoldAsVacant = CASE 
                       WHEN SoldAsVacant = '1' THEN 1
                       WHEN SoldAsVacant = '0' THEN 0
                   END;



------------------------------------------------------------------------------------------------------------------------

--ROMVE DUPLICATE

WITH RowNumCTE AS(
select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				PropertyAddress,
				Saleprice,
				SaleDate,
				LegalReference
			    ORDER BY 
				UniqueID
			    )row_num

from Nashville_Housing
--order by ParcelID
)
SELECT *
FROM RowNumCTE
Where row_num > 1
--order by PropertyAddress

Select *
from Nashville_Housing



-------------------------------------------------------------------------------------------
--Delete Unused columns


select *
from Nashville_Housing

ALTER TABLE Nashville_Housing
DROP COLUMN OwnerAddress, TaxDistrict, propertyAddress

ALTER TABLE Nashville_Housing
DROP COLUMN SaleDate
  
  