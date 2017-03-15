set Crop;
set Scenario;

param Yield{ Crop };
param PlantingCost{ Crop };
param SellingPrice{ Crop, Scenario };
param PurchasePrice{ i in Crop, j in Scenario } := 1.4 * SellingPrice[ i,j ];
param MinimumRequirement{ Crop };
param Quota{ Crop } default Infinity;
param SellingPriceAfterQuota{ Crop } default 0;
param TotalAcres;
param Multiplier{ Scenario };
param PriceChange{ Scenario };

var AcresPlanted{ Crop } >= 0;
var TBought{ Crop, Scenario } >= 0;
var TSold{ Crop, Scenario } >= 0;
var TSoldAboveQuota{ Crop, Scenario } >= 0;

minimize TotalCost:(1/3)* 
sum{ j in Scenario } 
	( sum{ i in Crop } 
		( AcresPlanted[ i ] * PlantingCost[ i ] 
		+ TBought[ i, j ] * PurchasePrice[ i,j ] 
		- ( TSold[ i, j ] - TSoldAboveQuota[ i, j ] ) * (SellingPrice[ i,j ]) 
		- TSoldAboveQuota[ i, j ] * SellingPriceAfterQuota[ i ] ) );

subject to
	MinReq{ i in Crop, j in Scenario }: 
	AcresPlanted[ i ] * Yield[ i ] * Multiplier[ j ]
	+ TBought[ i, j ] - TSold[ i, j ] >= MinimumRequirement[ i ];
	
	Acres: 
	sum{ i in Crop } AcresPlanted[ i ] <= TotalAcres;
	
	
	Q{ i in Crop, j in Scenario }: 
	TSoldAboveQuota[ i, j ] >= TSold[ i, j ] - Quota[ i ];
