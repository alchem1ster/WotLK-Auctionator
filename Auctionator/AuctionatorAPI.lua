

-----------------------------------------

local origGetSellValue		= GetSellValue;
local origGetAuctionBuyout	= GetAuctionBuyout;

-----------------------------------------

function GetSellValue (item)		-- Tekkub's API
	
	return Atr_GetSellValue(item);
end

-----------------------------------------

function GetAuctionBuyout (item)		-- Tekkub's API
	
	return Atr_GetAuctionBuyout(item);
end

-----------------------------------------

function Atr_GetSellValue (item)		-- Just like Tekkub's API but for when you want to be sure you're calling Auctionator's version of it

	local sellval = select (11, GetItemInfo(item));

	if (sellval ~= nil) then
		return sellval;
	end
	
	if (origGetSellValue) then
		return origGetSellValue(item);
	end
	
	return 0;
end


-----------------------------------------

function Atr_GetAuctionBuyout (item)  -- Just like Tekkub's API but for when you want to be sure you're calling Auctionator's version of it

	local sellval;
	
	if (type(item) == "string") then
		sellval = Atr_GetAuctionPrice(item);
	end
	
	if (sellval == nil) then
		local name = GetItemInfo(item);
		if (name) then
			sellval = Atr_GetAuctionPrice(name);
		end
	end
	
	if (sellval) then
		return sellval;
	end

	if (origGetAuctionBuyout) then
		return origGetAuctionBuyout(item);
	end
	
	return nil;
end

-----------------------------------------

function Atr_GetDisenchantValue (item)

	local itemName, itemLink, itemRarity, itemLevel, _, itemType = GetItemInfo (item);

	if (itemLink) then
		return Atr_CalcDisenchantPrice (itemType, itemRarity, itemLevel);
	end
	
	return nil;
end

