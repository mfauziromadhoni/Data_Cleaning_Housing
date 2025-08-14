CREATE TABLE housing(
UniqueID VARCHAR(10),
ParcelID VARCHAR(25),
LandUse VARCHAR(60),
PropertyAddress VARCHAR(65),
SaleDate DATE,
SalePrice VARCHAR(15),
LegalReference VARCHAR(25),
SoldAsVacant VARCHAR(7),
OwnerName VARCHAR(70),
OwnerAddress VARCHAR(60),
Acreage VARCHAR(10),
TaxDistrict VARCHAR(35),
LandValue VARCHAR(10),
BuildingValue VARCHAR(20),
TotalValue VARCHAR(15),
YearBuilt VARCHAR(15),
Bedrooms VARCHAR(8),
FullBath VARCHAR(8),
HalfBath VARCHAR(8)
);

SELECT * FROM housing;