/*

Cleaning Data in SQL Queries

*/

select * from portfolioproject.housingdata;

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format. Exact times aren't used, so we removed the hour/minute/second column

select SaleDate, CAST(SaleDate AS DATE) 
FROM portfolioproject.housingdata;

ALTER TABLE housingdata MODIFY COLUMN SaleDate DATE;







--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data


select *
FROM portfolioproject.housingdata
WHERE PropertyAddress = '' or PropertyAddress IS NULL
Order by ParcelID;

-- parcelIDs and Property Addresses have pairs. For the missing property addresses, we can self join and update the missing data with an existing
-- parcelID PropertyAddress pair that already exists in the table.
select a.parcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress,  IF(a.PropertyAddress = '', b.PropertyAddress, a.PropertyAddress)
FROM portfolioproject.housingdata a
join portfolioproject.housingdata b
on a.ParcelID = b.ParcelID
and a.UniqueID  <> b.UniqueID
WHERE a.PropertyAddress = '' or a.PropertyAddress IS NULL;

UPDATE portfolioproject.housingdata a
JOIN portfolioproject.housingdata b
  ON a.ParcelID = b.ParcelID
  AND a.UniqueID <> b.UniqueID
SET a.PropertyAddress = IF(a.PropertyAddress = '', b.PropertyAddress, a.PropertyAddress)
WHERE a.PropertyAddress = '' OR a.PropertyAddress IS NULL;

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


 
-- substring(column, starting position, length)
SELECT 
substring(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1 ) as Address,
substring(PropertyAddress, LOCATE(',', PropertyAddress) + 1  ) as City
FROM portfolioproject.housingdata;

-- creating a column for just the address-------------------------------------
ALTER TABLE portfolioproject.housingdata 
ADD PropertySplitAddress VARCHAR(255);

UPDATE portfolioproject.housingdata 
SET PropertySplitAddress = substring(PropertyAddress, 1, LOCATE(',', PropertyAddress) -1 );
-------------------------------------------------------------------------------

-- Creating a column for just the property city
ALTER TABLE housingdata 
ADD PropertySplitCity VARCHAR(255);

UPDATE portfolioproject.housingdata 
SET PropertySplitCity = substring(PropertyAddress, LOCATE(',', PropertyAddress) + 1  );



-- Owner Address


select 
SUBSTRING_INDEX(OwnerAddress, ',', 1) AS Address,
SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1) AS City,
SUBSTRING_INDEX(OwnerAddress, ',', -1) AS State
FROM portfolioproject.housingdata;
 
-- owner address
ALTER TABLE portfolioproject.housingdata 
ADD OwnerSplitAddress VARCHAR(255);

-- Creating a column for just the city
ALTER TABLE housingdata 
ADD OwnerSplitCity VARCHAR(255);

-- Creating a column for just the state
ALTER TABLE housingdata 
ADD OwnerSplitState VARCHAR(255);


UPDATE portfolioproject.housingdata 
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, ',', 1);


UPDATE portfolioproject.housingdata 
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, ',', 2), ',', -1);



UPDATE portfolioproject.housingdata 
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, ',', -1);




--------------------------------------------------------------------------------------------------------------------------

-- Change Y and N to Yes and No in "Sold as Vacant" field

Select DISTINCT SoldasVacant, count(SoldasVacant)
from portfolioproject.housingdata
group by SoldAsVacant
order by 2;

Select SoldAsVacant,
Case When SoldasVacant = 'Y' then 'Yes'
	When SoldasVacant = 'N' then 'No'
    Else SoldasVacant
	End as SoldAsVacantConverted
from portfolioproject.housingdata;

UPDATE portfolioproject.housingdata
SET SoldasVacant  = Case When SoldasVacant = 'Y' then 'Yes'
	When SoldasVacant = 'N' then 'No'
    Else SoldasVacant
	End;

-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE as(
select *,
	ROW_NUMBER() OVER (
    PARTITION BY ParcelID,
    PropertyAddress,
    SalePrice,
    SaleDate,
    LegalReference
    ORDER BY UniqueID) as row_num
    from portfolioproject.housingdata
   
    )
DELETE h FROM portfolioproject.housingdata h
JOIN RowNumCTE r ON h.UniqueID = r.UniqueID
WHERE r.row_num > 1;
   

    

---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns


ALTER TABLE PortfolioProject.housingdata
DROP COLUMN OwnerAddress,
DROP COLUMN TaxDistrict,
DROP COLUMN PropertyAddress;



select *
FROM portfolioproject.housingdata;
