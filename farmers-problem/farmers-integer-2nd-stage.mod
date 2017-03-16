set Crop;
set Crop2;
set Scenario;

param Yield{ Crop };
param PlantingCost{ Crop };
param SellingPrice{ Crop };
param PurchasePrice{ i in Crop } := 1.4 * SellingPrice[ i ];
param MinReq{ Crop };
param Quota{ Crop } default Infinity;
param SellingPriceAfterQuota{ Crop } default 0;
param TotalAcres;
param Multiplier{ Scenario };


var AcresPlanted{ Crop } >= 0;
var TBought{ Crop, Scenario } >= 0, integer;
var TSold{ Crop, Scenario } >= 0, integer;
var TSoldAboveQuota{ Crop, Scenario } >= 0, integer;
var n{Crop2,Scenario}, >= 0, integer;
var m{Crop2,Scenario}, >= 0, integer;


minimize TotalCost: 
	(1/3)*(sum{ j in Scenario } 
	( 
		sum{ i in Crop } ( AcresPlanted[ i ] * PlantingCost[ i ] 
		+ TBought[ i, j ]  * PurchasePrice[ i ] 
		- ( TSold[ i, j ] - TSoldAboveQuota[ i, j ] ) * SellingPrice[ i ] 
		- TSoldAboveQuota[ i, j ] * SellingPriceAfterQuota[ i ] 
	) 
	));

subject to
	MinReqs{ i in Crop, j in Scenario }: 
	AcresPlanted[ i ] * Yield[ i ] * Multiplier[ j ] + TBought[ i, j ] - TSold[ i, j ] >= MinReq[ i ];

subject to
	Acres: 
	sum{ i in Crop } AcresPlanted[ i ] <= TotalAcres;
	
subject to
	Q{ i in Crop, j in Scenario }: 
	TSoldAboveQuota[ i, j ] >= TSold[ i, j ] - Quota[ i ];

subject to
	SecondStage{i in Crop2, j in Scenario}:
	TSold[i,j] = 100*n[i,j];
subject to
	SecondStageBought{i in Crop2, j in Scenario}:
	TBought[i,j] = 100*m[i,j];
