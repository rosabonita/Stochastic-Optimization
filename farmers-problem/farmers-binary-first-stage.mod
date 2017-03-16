set Crop;
set Scenario;
set Fields;

param Yield{Crop};
param PlantingCost{Crop};
param SellingPrice{Crop};
param MinReq{Crop};
param Quota{Crop} default Infinity;
param SellingPriceAfterQuota{Crop} default 0;

param FieldAcres{Fields};

param Multiplier{Scenario};

param PurchasePrice{i in Crop} := 1.4*SellingPrice[i];

var FieldPlanted{Crop,Fields} binary;
var Bought{Crop,Scenario}>=0;
var Sold{Crop, Scenario} >=0;
var SoldAboveQuota{Crop,Scenario} >=0;

minimize TotalCost: 
	(1/3)* (sum{j in Scenario}(sum{i in Crop}(sum{k in Fields}(FieldPlanted[i,k]*FieldAcres[k]*PlantingCost[i])
	+ Bought[ i,j ] * PurchasePrice[ i ] 
	-( Sold[ i,j ] - SoldAboveQuota[ i,j ] ) * SellingPrice[ i ] 
	- SoldAboveQuota[ i,j ] * SellingPriceAfterQuota[ i ]))) ;



subject to FieldCapacity{k in Fields}:
	sum{i in Crop}FieldPlanted[i,k] = 1;
	
	
subject to Quotas{i in Crop, j in Scenario}:
	SoldAboveQuota[i,j]>=Sold[i,j] - Quota[i];
	
subject to MinimumRequirements{i in Crop, j in Scenario}:
	sum{k in Fields}FieldPlanted[i,k]*FieldAcres[k]*Yield[i]*Multiplier[j]
	+ Bought[i,j] - Sold[i,j] - SoldAboveQuota[i,j] >= MinReq[i]; 
		
