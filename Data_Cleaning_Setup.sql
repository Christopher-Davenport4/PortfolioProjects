-- select * from data_cleaning



DROP TABLE IF EXISTS portfolioproject.housingdata;
CREATE TABLE `portfolioproject`.`housingdata` (`UniqueID` int, `ParcelID` text, `LandUse` text, `PropertyAddress` text, `SaleDate` datetime, `SalePrice` int, `LegalReference` text, `SoldAsVacant` text, `OwnerName` text, `OwnerAddress` text, `Acreage` double, `TaxDistrict` text, `LandValue` int, `BuildingValue` int, `TotalValue` int, `YearBuilt` int, `Bedrooms` int, `FullBath` int, `HalfBath` int);

SET GLOBAL local_infile = 1;

LOAD DATA LOCAL INFILE 'C:/Users/ChrisDave00/Downloads/Nashville_Housing_Data.csv'
INTO TABLE portfolioproject.housingdata 
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n'
IGNORE 1 ROWS;

select * from portfolioproject.housingdata;