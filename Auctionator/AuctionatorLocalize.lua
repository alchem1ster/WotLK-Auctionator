
local addonName, addonTable = ...; 
local zc = addonTable.zc;


-----------------------------------------

AtrL = {};

-----------------------------------------

function Atr_PickLocalizationTable (locale)

	local f = _G["AtrBuildLTable_"..locale];
	if (type (f) == "function") then
		f();
--		DEFAULT_CHAT_FRAME:AddMessage (locale.." found");
	else
		AtrBuildLTable_enUS();
--		DEFAULT_CHAT_FRAME:AddMessage (locale.." not found");
	end

end

-----------------------------------------

Atr_PickLocalizationTable (GetLocale());
--Atr_PickLocalizationTable ("esES");

-----------------------------------------

function ZT (s)

	if (s == nil or s == "") then
		return s;
	end
	
	if (AtrL) then
		local s1 = AtrL[s];
		if (s1 and s1 ~= "" and not zc.StringStartsWith ("XXXXX")) then		
			return s1;
		end
	end
		
	return s;
end


-----------------------------------------

function zc.IsEnglishLocale()

	return (GetLocale() == "enUS" or GetLocale() == "enGB");

end

-----------------------------------------

local testt = {};
local Atr_excludes = { Cancel=1, Okay=1, Done=1, Close=1 }

-----------------------------------------

local function Atr_LocalizeChildText (frame)

	local child;
	local subregions = { frame:GetRegions() };
	for _, child in ipairs(subregions) do

		if  (type (child.GetText) == "function") then
			local ftext = child:GetText();
			local fname = tostring(child:GetName());
			
			if (ftext and ftext ~= "" and not Atr_excludes[ftext] and not zc.StringStartsWith (fname, "AuctionatorEntry")) then
				testt[ftext] = 1;
				child:SetText (ZT(ftext));
			end
		end
	end
	
	local kids = { frame:GetChildren() };
	for _, child in ipairs(kids) do
		
		if  (type (child.GetText) == "function") then
			local ftext = child:GetText();
			local fname = tostring(child:GetName());
			
			if (ftext and ftext ~= "" and not Atr_excludes[ftext] and not zc.StringStartsWith (fname, "AuctionatorEntry")) then
				testt[ftext] = 1;
				
				if (child:GetObjectType() == "Button") then
					local oldwid = math.floor(child:GetWidth());
					child:SetText (ZT(ftext));
					local newwid = math.floor(child:GetTextWidth()) + 15;
					if (newwid > oldwid) then
						child:SetWidth (newwid+20);
					end
				else
					child:SetText (ZT(ftext));
				end
			end
		end
			
		if (child:GetObjectType() ~= "Button") then
			Atr_LocalizeChildText (child);
		end
	end			

end

-----------------------------------------

function Atr_LocalizeFrames ()

	local frame = EnumerateFrames()
	while frame do
		local fname		= frame:GetName();
		local pname		= (frame:GetParent() and frame:GetParent():GetName() or nil);
		
		local isAuctionatorFrame = (zc.StringStartsWith (fname, "Atr") or zc.StringStartsWith (fname, "Auctionator")) and zc.StringSame (pname, "UIParent");
		if (fname == "Atr_Main_Panel") then
			isAuctionatorFrame = true;
		end
		
		if ( isAuctionatorFrame ) then
			Atr_LocalizeChildText (frame);
		end
		
		frame = EnumerateFrames(frame)
	end

--	zc.PrintKeysSorted (testt);

end

-----------------------------------------

local kUncutGems = {
	36924, 		-- sky sapphire
	36925, 		-- majestic zircon

	36918, 		-- scarlet ruby
	36919, 		-- cardinal ruby

	36933, 		-- forest emerald
	36934, 		-- eye of zul

	36930, 		-- monarch topaz
	36931, 		-- ametrine

	36927, 		-- twilight opal
	36928, 		-- dreadstone

	36921, 		-- autumns glow
	36922, 		-- kings amber

	41334, 		-- earthsiege diamond
	41266, 		-- skyflare diamond

	42225 		-- dragon's eye
	}

-----------------------------------------

function Atr_IsCutGem (itemLink)

	if (not Atr_IsGem (itemLink)) then
		return false;
	end
	
	local itemID = zc.ItemIDfromLink (itemLink);

	for n = 1, #kUncutGems do
		if (itemID == tostring (kUncutGems[n])) then
			return false;
		end
	end
	
	return true;
end

-----------------------------------------


function Atr_IsGlyph				(itemLink)		return (Atr_IsClass (itemLink, 5));		end
function Atr_IsGem					(itemLink)		return (Atr_IsClass (itemLink, 10));	end
function Atr_IsItemEnhancement		(itemLink)		return (Atr_IsClass (itemLink, 4, 6));	end
function Atr_IsPotion				(itemLink)		return (Atr_IsClass (itemLink, 4, 2));	end
function Atr_IsElixir				(itemLink)		return (Atr_IsClass (itemLink, 4, 3));	end
function Atr_IsFlask				(itemLink)		return (Atr_IsClass (itemLink, 4, 4));	end
function Atr_IsHerb					(itemLink)		return (Atr_IsClass (itemLink, 6, 6));	end

-----------------------------------------

-----------------------------------------
-- if Blizz introduces new auction classes this might need to change

function Atr_IsWeaponType				(itemType)		return (Atr_ItemType2AuctionClass (itemType) == 1);		end
function Atr_IsArmorType				(itemType)		return (Atr_ItemType2AuctionClass (itemType) == 2);		end

-----------------------------------------

function Atr_IsClass (itemLink, class, subclass)

	if (itemLink == nil) then
		return false;
	end

	local _, _, _, _, _, itemType, itemSubType = GetItemInfo (itemLink);

	local itemClass = Atr_ItemType2AuctionClass (itemType);
	local itemSubClass;
	
	if (itemClass == class) then
	
		if (subclass == nil) then
			return true;
		end
	
		itemSubClass = Atr_SubType2AuctionSubclass (itemClass, itemSubType)

		if (subclass == itemSubClass) then
			return true;
		end
	end
		
	return false;
end

-----------------------------------------

local gItemClasses;
local gItemSubClasses;

-----------------------------------------

function Atr_GetAuctionClasses()

	if (gItemClasses == nil) then
		gItemClasses = { GetAuctionItemClasses() };
	end
	
	return gItemClasses;
end

-----------------------------------------

function Atr_GetAuctionSubclasses (auctionClass)

	if (gItemSubClasses == nil) then
		gItemSubClasses = {};
	end
	
	if (gItemSubClasses[auctionClass] == nil) then
		gItemSubClasses[auctionClass] = { GetAuctionItemSubClasses(auctionClass) };
	end
	
	return gItemSubClasses[auctionClass];
end

-----------------------------------------

function Atr_ItemType2AuctionClass(itemType)

	local itemClasses = Atr_GetAuctionClasses();
		
	if #itemClasses > 0 then
	local itemClass;
		for x, itemClass in pairs(itemClasses) do
			if (zc.StringSame (itemClass, itemType)) then
				return x;
			end
		end
	end

	return 0;
end


-----------------------------------------

function Atr_SubType2AuctionSubclass(auctionClass, itemSubtype)

	local subclasses = Atr_GetAuctionSubclasses (auctionClass);

	if #subclasses > 0 then
	local itemSubClass;
		for x, itemSubClass in pairs(subclasses) do
			if (zc.StringSame (itemSubClass, itemSubtype)) then
				return x;
			end
		end
	end

	return 0;
end


