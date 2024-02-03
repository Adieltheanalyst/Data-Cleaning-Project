--Select everything

SELECT *
FROM [Projectprtfolio2].[dbo].[Nashvilehousing]


--standardize date format

 SELECT SaledateConverted as Saledate2,CONVERT(date,SaleDate)
FROM [Projectprtfolio2].[dbo].[Nashvilehousing]


UPDATE Nashvilehousing
SET SaleDate= CONVERT(date,SaleDate)

ALTER TABLE Nashvilehousing
Add SaledateConverted Date;

UPDATE Nashvilehousing
SET SaledateConverted= CONVERT(date,SaleDate)

--populate Property Address data

 SELECT *
 FROM [Projectprtfolio2].[dbo].[Nashvilehousing]
 --WHERE PropertyAddress is Null
 Order by ParcelID


 
 SELECT a.ParcelID,
        a.PropertyAddress,
		b.ParcelID,b.PropertyAddress ,
		ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM [Projectprtfolio2].[dbo].[Nashvilehousing] a
 JOIN [Projectprtfolio2].[dbo].[Nashvilehousing] b
     ON a.ParcelID =b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL

UPDATE a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
 FROM [Projectprtfolio2].[dbo].[Nashvilehousing] a
 JOIN [Projectprtfolio2].[dbo].[Nashvilehousing] b
     ON a.ParcelID =b.ParcelID
	 AND a.[UniqueID ] <> b.[UniqueID ]
WHERE a.PropertyAddress is NULL


--Breaking out Address into INDIVIDUAL columns (Address,city,state)
 

  SELECT *
 FROM [Projectprtfolio2].[dbo].[Nashvilehousing]
 --WHERE PropertyAddress is Null
 Order by ParcelID
--WHERE PropertyAddress is Null
 --Order by ParcelID

SELECT 
      SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) AS Address,
      SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress)) AS Address
 FROM [Projectprtfolio2].[dbo].[Nashvilehousing]

ALTER TABLE Nashvilehousing
Add PropertysplitAddress NVARCHAR(255)

UPDATE Nashvilehousing
SET PropertysplitAddress= SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) 

ALTER TABLE Nashvilehousing
Add Propertysplitcity NVARCHAR(255);

UPDATE Nashvilehousing
SET Propertysplitcity = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress) +1 , LEN(PropertyAddress))

SELECT *
 FROM [Projectprtfolio2].[dbo].[Nashvilehousing]

 SELECT 
      PARSENAME(REPLACE(OwnerAddress,',','.') , 3),
	  PARSENAME(REPLACE(OwnerAddress,',','.') , 2),
	  PARSENAME(REPLACE(OwnerAddress,',','.') , 1)
 FROM [Projectprtfolio2].[dbo].[Nashvilehousing]


ALTER TABLE Nashvilehousing
Add OwnersplitAddress NVARCHAR(255)

UPDATE Nashvilehousing
SET OwnersplitAddress= PARSENAME(REPLACE(OwnerAddress,',','.') , 3)

ALTER TABLE Nashvilehousing
Add Ownersplitcity NVARCHAR(255);

UPDATE Nashvilehousing
SET Ownersplitcity = PARSENAME(REPLACE(OwnerAddress,',','.') , 2)

ALTER TABLE Nashvilehousing
Add OwnersplitState NVARCHAR(255)

UPDATE Nashvilehousing
SET OwnersplitState= PARSENAME(REPLACE(OwnerAddress,',','.') , 1)


SELECT *
 FROM [Projectprtfolio2].[dbo].[Nashvilehousing]

-- Change Y and N to YES and NO in 'Sold as vacant' Field

SELECT DISTINCT(SoldAsVacant),COUNT(SoldAsVacant)
 FROM [Projectprtfolio2].[dbo].[Nashvilehousing]
 GROUP BY SoldAsVacant
 ORDER BY 2


 SELECT SoldAsVacant
 , CASE When SoldAsVacant = 'Y' THEN 'YES'
        WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END
 FROM [Projectprtfolio2].[dbo].[Nashvilehousing]

 UPDATE Nashvilehousing
 SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'YES'
        WHEN SoldAsVacant = 'N' THEN 'NO'
		ELSE SoldAsVacant
		END



--REMOVE DUPLICATES
WITH RowNumCTE AS (
SELECT *,
     ROW_NUMBER()OVER(
	 PARTITION BY ParcelID,
	              PropertyAddress,
				  SalePrice,
				  SaleDate,
				  LegalReference
				  ORDER BY 
				          UniqueID
	             )row_num

FROM [Projectprtfolio2].[dbo].[Nashvilehousing]
--ORDER BY ParcelID
)
SELECT *
FROM RowNumCTE
WHERE row_num > 1
--ORDER BY PropertyAddress

SELECT *
 FROM [Projectprtfolio2].[dbo].[Nashvilehousing]

 --DELETE Unused Columns

 SELECT *
 FROM [Projectprtfolio2].[dbo].[Nashvilehousing]

 ALTER TABLE [Projectprtfolio2].[dbo].[Nashvilehousing]
 DROP COLUMN OwnerAddress, TaxDistrict,PropertyAddress

  ALTER TABLE [Projectprtfolio2].[dbo].[Nashvilehousing]
 DROP COLUMN SaleDate