AtrPane = {};
AtrPane.__index = AtrPane;

ATR_SHOW_CURRENT	= 1;
ATR_SHOW_HISTORY	= 2;
ATR_SHOW_HINTS		= 3;

function AtrPane.create ()

	local pane = {};
	setmetatable (pane,AtrPane);

	pane.fullStackSize	= 0;

	pane.totalItems		= 0;		-- total in bags for this item

	pane.UINeedsUpdate	= false;
	pane.showWhich		= ATR_SHOW_CURRENT;
	
	pane.activeSearch	= nil;
	pane.sortedHist		= nil;
	pane.hints			= nil;
	
	pane.hlistScrollOffset	= 0;
	
	pane:ClearSearch();
	
	return pane;
end


-----------------------------------------

function AtrPane:DoSearch (searchText, exact, rescanThreshold, callback)

	self.currIndex			= nil;
	self.histIndex			= nil;
	self.hintsIndex			= nil;
	
	self.sortedHist			= nil;
	self.hints				= nil;
	
	self.SS_hilite_itemName	= searchText;		-- by name for search summary
	
	Atr_ClearBuyState();

	self.activeScan = Atr_FindScan (nil);
	
	Atr_ClearAll();		-- it's fast, might as well just do it now for cleaner UE
	
	self.UINeedsUpdate = false;		-- will be set when scan finishes
			
	self.activeSearch = Atr_NewSearch (searchText, exact, rescanThreshold, callback);
	
	if (exact) then
		self.activeScan = self.activeSearch:GetFirstScan();
	end
	
	local cacheHit = false;
	
	if (searchText ~= "") then
		if (self.activeScan.whenScanned == 0) then		-- check whenScanned so we don't rescan cache hits
			self.activeSearch:Start();
		else
			self.UINeedsUpdate = true;
			cacheHit = true;
		end
	end
	
	return cacheHit;
end

-----------------------------------------

function AtrPane:ClearSearch ()
	self:DoSearch ("", true);
end

-----------------------------------------

function AtrPane:GetProcessingState ()
	
	if (self.activeSearch) then
		return self.activeSearch.processing_state;
	end
	
	return KM_NULL_STATE;
end

-----------------------------------------

function AtrPane:IsScanEmpty ()
	
	return (self.activeScan == nil or self.activeScan:IsNil());
	
end

-----------------------------------------

function AtrPane:ShowCurrent ()
	
	return self.showWhich == ATR_SHOW_CURRENT;
	
end

-----------------------------------------

function AtrPane:ShowHistory ()
	
	return self.showWhich == ATR_SHOW_HISTORY;
	
end

-----------------------------------------

function AtrPane:ShowHints ()
	
	return self.showWhich == ATR_SHOW_HINTS;
	
end

-----------------------------------------

function AtrPane:SetToShowCurrent ()
	
	self.showWhich = ATR_SHOW_CURRENT;
	
end

-----------------------------------------

function AtrPane:SetToShowHistory ()
	
	self.showWhich = ATR_SHOW_HISTORY;
	
end

-----------------------------------------

function AtrPane:SetToShowHints ()
	
	self.showWhich = ATR_SHOW_HINTS;
	
end


