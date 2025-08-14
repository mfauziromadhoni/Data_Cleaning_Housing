SELECT * FROM housing;

--Fill NULL values automatically in propertyaddress column
SELECT
	a.parcelid,
	a.propertyaddress,
	b.parcelid,
	b.propertyaddress,
	COALESCE(a.propertyaddress, b.propertyaddress) AS filled_address
FROM housing a
JOIN housing b
ON 
	a.parcelid = b.parcelid
	AND
	a.uniqueid <> b.uniqueid
WHERE a.propertyaddress IS NULL;

UPDATE housing a
SET propertyaddress = COALESCE(a.propertyaddress, b.propertyaddress)
FROM housing b
WHERE 
	a.parcelid = b.parcelid
	AND
	a.uniqueid <> b.uniqueid
	AND
	a.propertyaddress IS NULL;

--Verify
SELECT
	propertyaddress
FROM housing
WHERE propertyaddress IS NULL;
-----------------------------------------------------------------------------

--Break out propertyaddress into individual column (Adress, City)
SELECT
	propertyaddress
FROM housing
LIMIT 5;

--Add new column based on propertyaddress column into (address, city)
ALTER TABLE housing ADD COLUMN property_split_address VARCHAR(60);
ALTER TABLE housing ADD COLUMN property_split_city VARCHAR(60);

--Fill property_split_address column before ','
UPDATE housing
SET property_split_address = SUBSTRING(propertyaddress FROM 1 FOR POSITION(',' IN propertyaddress) -1);

--Fill property_split_city after ','
UPDATE housing
SET property_split_city = TRIM(SUBSTRING(propertyaddress FROM POSITION(',' IN propertyaddress) +1));

--Verify
SELECT 
	property_split_address,
	 property_split_city
FROM housing
LIMIT 5;
-------------------------------------------------------------------------------------------------------

--Break out owneraddress into individual column (Adress, City, State)
ALTER TABLE housing ADD COLUMN owner_split_address VARCHAR(60);
ALTER TABLE housing ADD COLUMN owner_split_city VARCHAR(60);
ALTER TABLE housing ADD COLUMN owner_split_state VARCHAR(10);

--Fill owner_split... by delimiter ','
UPDATE housing
SET 
	owner_split_address = TRIM(SPLIT_PART(owneraddress, ',', 1)),
	owner_split_city = TRIM(SPLIT_PART(owneraddress, ',', 2)),
	owner_split_state = TRIM(SPLIT_PART(owneraddress,',', 3));

--Verify
SELECT
	owner_split_address,
	owner_split_city,
	owner_split_state
FROM housing
LIMIT 5;
---------------------------------------------------------------------------

--Change 'Y' and 'N' in soldasvacant column into 'Yes' and 'No'
SELECT 
	DISTINCT soldasvacant,
	COUNT(soldasvacant) AS count_categories
FROM housing
GROUP BY 1;

SELECT 
	soldasvacant,
	CASE
		WHEN soldasvacant = 'Y' THEN 'Yes'
		WHEN soldasvacant = 'N' THEN 'No'
		ELSE soldasvacant
	END
FROM housing;

UPDATE housing
SET soldasvacant =
	CASE
		WHEN soldasvacant = 'Y' THEN 'Yes'
		WHEN soldasvacant = 'N' THEN 'No'
		ELSE soldasvacant
	END;
-----------------------------------------------------------------

--Remove Duplicates
WITH row_num_cte AS
(
	SELECT
		ctid,
		ROW_NUMBER() OVER( 
		PARTITION BY
			parcelid,
			propertyaddress,
	        saleprice,
	        saledate,
	        legalreference
		ORDER BY uniqueid
		) AS row_num
	FROM housing
)
DELETE FROM housing
USING row_num_cte
WHERE 
	housing.ctid = row_num_cte.ctid
	AND
	row_num_cte.row_num > 1;
---------------------------------------------------------------------

--Delete Unused Columns
ALTER TABLE housing
DROP COLUMN owneraddress,
DROP COLUMN taxdistrict,
DROP COLUMN propertyaddress,
DROP COLUMN saledate;
----------------------------------------------------------------------

--Finally
SELECT * FROM housing;

