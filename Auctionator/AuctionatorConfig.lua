
local addonName, addonTable = ...; 
local zc = addonTable.zc;

-----------------------------------------

function Atr_LoadOptionsSubPanel (f, name, title, subtitle)

	f.name		= name
	f.parent	= "Auctionator";
	f.cancel	= Atr_Options_Cancel;

	local frameName = f:GetName();
	
	f.okay   = _G[frameName.."_Save"];

	if (title    == nil) then title = name; end
	if (subtitle == nil) then subtitle = ""; end
	
	_G[frameName.."_ATitle"]:SetText (title);
	_G[frameName.."_BTitle"]:SetText (subtitle);
	
	InterfaceOptions_AddCategory (f);

end


-----------------------------------------

function Atr_Options_Cancel ()

	Atr_InitOptionsPanels();

end


-----------------------------------------

function Atr_InitOptionsPanels()

	if (AUCTIONATOR_SAVEDVARS == nil) then
		Atr_ResetSavedVars();
	end

	Atr_SetupBasicOptionsFrame();
	Atr_SetupTooltipsOptionsFrame();
	Atr_SetupUCConfigFrame();
	Atr_SetupStackingFrame();
	Atr_SetupOptionsFrame();
	Atr_SetupScanningConfigFrame();

end

-----------------------------------------

function Atr_SetupOptionsFrame()

	local expText = "<html><body>"
					.."<p>"..ZT("The latest information on Auctionator can be found at").." auctionator-addon.com.".."</p>"
					.."<p><br/>"
					.."|cffaaaaaa"..string.format (ZT("German translation courtesy of %s"),  "|rCkaotik").."<br/>"
					.."|cffaaaaaa"..string.format (ZT("Russian translation courtesy of %s"), "|rStingerSoft").."<br/>"
					.."|cffaaaaaa"..string.format (ZT("Swedish translation courtesy of %s"), "|rHellManiac").."<br/>"
					.."|cffaaaaaa"..string.format (ZT("French translation courtesy of %s"),  "|rKiskewl").."<br/>"
					.."|cffaaaaaa"..string.format (ZT("Spanish translation courtesy of %s"),  "|rElfindor").."<br/>"
					.."</p>"
					.."</body></html>"
					;

	AuctionatorDescriptionHTML:SetText (expText);
	AuctionatorDescriptionHTML:SetSpacing (3);

	AuctionatorVersionText:SetText (ZT("Version")..": "..AuctionatorVersion);

end


-----------------------------------------

function Atr_SetDurationOptionRB(name)

	Atr_RB_S:SetChecked (zc.StringEndsWith (name, "S"));
	Atr_RB_M:SetChecked (zc.StringEndsWith (name, "M"));
	Atr_RB_L:SetChecked (zc.StringEndsWith (name, "L"));

end

-----------------------------------------

function Atr_BasicOptionsFrame_Save()

	local origValues = zc.msg_str (AUCTIONATOR_ENABLE_ALT, AUCTIONATOR_OPEN_ALL_BAGS, AUCTIONATOR_SHOW_ST_PRICE, AUCTIONATOR_DEFTAB, AUCTIONATOR_DEF_DURATION);

	AUCTIONATOR_ENABLE_ALT		= zc.BoolToNum(AuctionatorOption_Enable_Alt_CB:GetChecked ());
	AUCTIONATOR_OPEN_ALL_BAGS	= zc.BoolToNum(AuctionatorOption_Open_All_Bags_CB:GetChecked ());
	AUCTIONATOR_SHOW_ST_PRICE	= zc.BoolToNum(AuctionatorOption_Show_StartingPrice_CB:GetChecked ());

	AUCTIONATOR_DEFTAB			= UIDropDownMenu_GetSelectedValue(AuctionatorOption_Deftab);

	AUCTIONATOR_DEF_DURATION = "N";

	if (AuctionatorOption_Def_Duration_CB:GetChecked()) then
		if (Atr_RB_S:GetChecked())	then	AUCTIONATOR_DEF_DURATION = "S"; end;
		if (Atr_RB_M:GetChecked())	then	AUCTIONATOR_DEF_DURATION = "M"; end;
		if (Atr_RB_L:GetChecked())	then	AUCTIONATOR_DEF_DURATION = "L"; end;
	end

	local newValues = zc.msg_str (AUCTIONATOR_ENABLE_ALT, AUCTIONATOR_OPEN_ALL_BAGS, AUCTIONATOR_SHOW_ST_PRICE, AUCTIONATOR_DEFTAB, AUCTIONATOR_DEF_DURATION);

	if (origValues ~= newValues) then
		zc.msg_atr (ZT ("basic options saved"));
	end
	
	Atr_ShowHide_StartingPrice();
end


-----------------------------------------

function Atr_SetupBasicOptionsFrame()

	Atr_BasicOptionsFrame_BTitle:SetText (string.format (ZT("Basic Options for %s"), "|cffffff55"..UnitName("player")));

	AuctionatorOption_Enable_Alt_CB:SetChecked			(zc.NumToBool(AUCTIONATOR_ENABLE_ALT));
	AuctionatorOption_Open_All_Bags_CB:SetChecked		(zc.NumToBool(AUCTIONATOR_OPEN_ALL_BAGS));
	AuctionatorOption_Show_StartingPrice_CB:SetChecked	(zc.NumToBool(AUCTIONATOR_SHOW_ST_PRICE));

	UIDropDownMenu_Initialize		(AuctionatorOption_Deftab, AuctionatorOption_Deftab_Initialize);
	UIDropDownMenu_SetSelectedValue	(AuctionatorOption_Deftab, AUCTIONATOR_DEFTAB);

	AuctionatorOption_Def_Duration_CB:SetChecked (AUCTIONATOR_DEF_DURATION == "S" or AUCTIONATOR_DEF_DURATION == "M" or AUCTIONATOR_DEF_DURATION == "L");

	Atr_SetDurationOptionRB (AUCTIONATOR_DEF_DURATION);

end

-----------------------------------------

function Atr_SetupTooltipsOptionsFrame ()

	ATR_tipsVendorOpt_CB:SetChecked		(zc.NumToBool(AUCTIONATOR_V_TIPS));
	ATR_tipsAuctionOpt_CB:SetChecked	(zc.NumToBool(AUCTIONATOR_A_TIPS));
	ATR_tipsDisenchantOpt_CB:SetChecked	(zc.NumToBool(AUCTIONATOR_D_TIPS));

	UIDropDownMenu_Initialize(Atr_tipsShiftDD, Atr_tipsShiftDD_Initialize);
	UIDropDownMenu_SetSelectedValue(Atr_tipsShiftDD, AUCTIONATOR_SHIFT_TIPS);
	
	UIDropDownMenu_Initialize(Atr_deDetailsDD, Atr_deDetailsDD_Initialize);
	UIDropDownMenu_SetSelectedValue(Atr_deDetailsDD, AUCTIONATOR_DE_DETAILS_TIPS);
end


-----------------------------------------

function Atr_TooltipsOptionsFrame_Save()

	local origValues = zc.msg_str (AUCTIONATOR_V_TIPS, AUCTIONATOR_A_TIPS, AUCTIONATOR_D_TIPS, AUCTIONATOR_SHIFT_TIPS, AUCTIONATOR_DE_DETAILS_TIPS);

	AUCTIONATOR_V_TIPS		= zc.BoolToNum(ATR_tipsVendorOpt_CB:GetChecked ());
	AUCTIONATOR_A_TIPS		= zc.BoolToNum(ATR_tipsAuctionOpt_CB:GetChecked ());
	AUCTIONATOR_D_TIPS		= zc.BoolToNum(ATR_tipsDisenchantOpt_CB:GetChecked ());

	AUCTIONATOR_SHIFT_TIPS		= UIDropDownMenu_GetSelectedValue(Atr_tipsShiftDD);
	AUCTIONATOR_DE_DETAILS_TIPS	= UIDropDownMenu_GetSelectedValue(Atr_deDetailsDD);

	local newValues = zc.msg_str (AUCTIONATOR_V_TIPS, AUCTIONATOR_A_TIPS, AUCTIONATOR_D_TIPS, AUCTIONATOR_SHIFT_TIPS, AUCTIONATOR_DE_DETAILS_TIPS);

	if (origValues ~= newValues) then
		zc.msg_atr (ZT("tooltip configuration saved"));
	end


end


-----------------------------------------

function AuctionatorOption_Deftab_Initialize(self)

	local info = UIDropDownMenu_CreateInfo();
	
	Atr_AddMenuPick (self, info, ZT("None"),	0, AuctionatorOption_Deftab_OnClick);
	Atr_AddMenuPick (self, info, ZT("Sell"),	1, AuctionatorOption_Deftab_OnClick);
	Atr_AddMenuPick (self, info, ZT("Buy"),		2, AuctionatorOption_Deftab_OnClick);
	Atr_AddMenuPick (self, info, ZT("More"),	3, AuctionatorOption_Deftab_OnClick);

end

-----------------------------------------

function AuctionatorOption_Deftab_OnClick(self)

zc.md (self.owner, self.value);

	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
end

-----------------------------------------

function Atr_tipsShiftDD_Initialize(self)

	local info = UIDropDownMenu_CreateInfo();
	
	Atr_AddMenuPick (self, info, ZT("stack price"),		1, Atr_tipsShiftDD_OnClick);
	Atr_AddMenuPick (self, info, ZT("per item price"),	2, Atr_tipsShiftDD_OnClick);

end

-----------------------------------------

function Atr_tipsShiftDD_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
end

-----------------------------------------

function Atr_deDetailsDD_Initialize(self)

	local info = UIDropDownMenu_CreateInfo();
	
	Atr_AddMenuPick (self, info, ZT("when SHIFT is held down"),	1, Atr_deDetailsDD_OnClick);
	Atr_AddMenuPick (self, info, ZT("when CONTROL is held down"),	2, Atr_deDetailsDD_OnClick);
	Atr_AddMenuPick (self, info, ZT("when ALT is held down"),		3, Atr_deDetailsDD_OnClick);
	Atr_AddMenuPick (self, info, ZT("never"),						4, Atr_deDetailsDD_OnClick);
	Atr_AddMenuPick (self, info, ZT("always"),					5, Atr_deDetailsDD_OnClick);

end

-----------------------------------------

function Atr_deDetailsDD_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
end

-----------------------------------------

function Atr_Option_OnClick (self)

	if (zc.StringContains (self:GetName(), "Open_BUY") and self:GetChecked()) then
		AuctionatorOption_Open_SELL_CB:SetChecked (false);
	end

	if (zc.StringContains (self:GetName(), "Open_SELL") and self:GetChecked()) then
		AuctionatorOption_Open_BUY_CB:SetChecked (false);
	end

end


-----------------------------------------

local kThresh = {}

kThresh[1] = { amt=5000000,		text=ZT("over %d gold"),		v=500	};
kThresh[2] = { amt=1000000,		text=ZT("over %d gold"),		v=100	};
kThresh[3] = { amt=200000,		text=ZT("over %d gold"),		v=20	};
kThresh[4] = { amt=50000,		text=ZT("over %d gold"),		v=5		};
kThresh[5] = { amt=10000,		text=ZT("over 1 gold"),			v=1		};
kThresh[6] = { amt=2000,		text=ZT("over %d silver"),		v=20	};
kThresh[7] = { amt=500,			text=ZT("over %d silver"),		v=5		};
                 
-----------------------------------------

function Atr_SetupUCConfigFrame()

	for i = 1, #kThresh do

		local amt		= kThresh[i].amt;
		local linetext	= string.format (kThresh[i].text, kThresh[i].v);

		_G["UC_"..amt.."_RangeText"]:SetText (linetext);

		MoneyInputFrame_SetCopper (_G["UC_"..amt.."_MoneyInput"], AUCTIONATOR_SAVEDVARS["_"..amt]);
	end

	Atr_Starting_Discount:SetText (AUCTIONATOR_SAVEDVARS.STARTING_DISCOUNT);

end


-----------------------------------------

function Atr_UCConfigFrame_Save()

	local origValues	= AUCTIONATOR_SAVEDVARS.STARTING_DISCOUNT;

	AUCTIONATOR_SAVEDVARS.STARTING_DISCOUNT = Atr_Starting_Discount:GetNumber ();

	local newValues		= AUCTIONATOR_SAVEDVARS.STARTING_DISCOUNT;

	for i = 1, #kThresh do
		local amt = kThresh[i].amt;
	
		origValues = origValues + AUCTIONATOR_SAVEDVARS["_"..amt];
		
		AUCTIONATOR_SAVEDVARS["_"..amt]	= MoneyInputFrame_GetCopper(_G["UC_"..amt.."_MoneyInput"]);
		
		newValues = newValues + AUCTIONATOR_SAVEDVARS["_"..amt];
	end

	if (origValues ~= newValues) then
		zc.msg_atr (ZT("undercutting configuration saved"));
	end


end

-----------------------------------------

local function plistEntry (key, txt, num, size)

	return { sortkey=key, text=txt, numstacks=num, stacksize=size }

end

-----------------------------------------

local function plistSort (x, y)

	return x.sortkey < y.sortkey;

end

-----------------------------------------

local kStackList_LinesToDisplay = 12;
local gStackList_SelectedIndex = 0;
local gStackList_plist;


kStackList_categories = {};

kStackList_categories[ATR_SK_GLYPHS]		= { txt=ZT("Glyphs")			}
kStackList_categories[ATR_SK_GEMS_CUT]		= { txt=ZT("Gems - Cut")		}
kStackList_categories[ATR_SK_GEMS_UNCUT]	= { txt=ZT("Gems - Uncut")		}
kStackList_categories[ATR_SK_ITEM_ENH]		= { txt=ZT("Item Enhancements")	}
kStackList_categories[ATR_SK_POT_ELIX]		= { txt=ZT("Potions and Elixirs")	}
kStackList_categories[ATR_SK_FLASKS]		= { txt=ZT("Flasks")	}
kStackList_categories[ATR_SK_HERBS]			= { txt=ZT("Herbs")	}

-----------------------------------------

function Atr_SetupStackingFrame ()

	if (_G["Atr_StackList1"] == nil) then
		local line, n;

		for n = 1, kStackList_LinesToDisplay do
			local y = -5 - ((n-1)*16);
			line = CreateFrame("BUTTON", "Atr_StackList"..n, Atr_Stacking_List, "Atr_StackingEntryTemplate");
			line:SetPoint("TOP", 0, y);
		end
	end
	
	Atr_StackingList_Display();

end

-----------------------------------------

function Atr_StackingList_Display()

	gStackList_plist = {};

	local plist = gStackList_plist;
	local text, spinfo;
	local sortkey, info;
	local n = 1;
	
	for sortkey, info in pairs (kStackList_categories) do
		info.overrideFound = false;
	end

	if (AUCTIONATOR_STACKING_PREFS == nil) then
		Atr_StackingPrefs_Init();
	end

	for text, spinfo in pairs (AUCTIONATOR_STACKING_PREFS) do

		-- skip over any that were set automatically rather than explicitly by the user
		-- and mark the built-in categories

		if (spinfo.numstacks ~= 0) then
			local sortkey = text;
			
			if (kStackList_categories[text]) then
				kStackList_categories[text].overrideFound = true;
				text = kStackList_categories[text].txt;
			end

			plist[n] = plistEntry (sortkey, text, spinfo.numstacks, spinfo.stacksize);
			n = n + 1;
		end
	end
	
	for sortkey, info in pairs (kStackList_categories) do
		if (not info.overrideFound) then
			plist[n] = plistEntry (sortkey, info.txt, -2, 0);			
			n = n + 1;
		end
	end
	
	table.sort (plist, plistSort)
	
	local totalRows = #plist;

	local line;							-- 1 through NN of our window to scroll
	local dataOffset;					-- an index into our data calculated from the scroll offset

	FauxScrollFrame_Update (Atr_Stacking_ScrollFrame, totalRows, kStackList_LinesToDisplay, 16);

	for line = 1,kStackList_LinesToDisplay do

		dataOffset = line + FauxScrollFrame_GetOffset (Atr_Stacking_ScrollFrame);

		local lineEntry = _G["Atr_StackList"..line];

		lineEntry:SetID (dataOffset);

		if (dataOffset <= totalRows and plist[dataOffset]) then

			local lineEntry_text = _G["Atr_StackList"..line.."_text"];
			local lineEntry_info = _G["Atr_StackList"..line.."_info"];

			local pdata = plist[dataOffset];
			
			local colorText = ((pdata.text == pdata.sortkey) and "" or "|cffffff88");
			
			lineEntry_text:SetText (colorText..pdata.text);

			local numstacks = plist[dataOffset].numstacks;
			local stacksize = plist[dataOffset].stacksize;
			local info = "???";
			
			if     (numstacks == -2) then	info = "|cff777777"..ZT("default behavior");														
			elseif (numstacks == -1) then	info = string.format (ZT("max. stacks of %d"), stacksize);		
			elseif (stacksize == 0)  then	info = "1 "..ZT("stack");	
			elseif (numstacks == 0)  then	info = ZT("stacks of").." "..stacksize;	
			elseif (numstacks > 0)   then	info = numstacks.." "..ZT("stacks of").." "..stacksize;	
			end
				
			lineEntry_info:SetText (info);
			
			if (gStackList_SelectedIndex == dataOffset) then
				lineEntry:SetButtonState ("PUSHED", true);
			else
				lineEntry:SetButtonState ("NORMAL", false);
			end
			
			lineEntry:Show();
		else
			lineEntry:Hide();
		end
	end

	zc.EnableDisable (Atr_StackingOptionsFrame_Edit, gStackList_SelectedIndex > 0);

end

-----------------------------------------

function Atr_StackingEntry_OnClick(self)

	gStackList_SelectedIndex = self:GetID();

	Atr_StackingList_Display();
end

-----------------------------------------

function Atr_StackingEntry_OnDoubleClick(self)

	Atr_StackingEntry_OnClick(self);
	Atr_StackingList_Edit_OnClick();
end

-----------------------------------------

function Atr_Memorize_Show (isNew)

	local numStacks = -1;
	local stackSize = 1;

	zc.ShowHide (Atr_Mem_itemName_static,	not isNew);
	zc.ShowHide (Atr_Mem_EB_itemName,		    isNew);
	zc.ShowHide (Atr_Mem_Forget,		   	not isNew);

	Atr_MemorizeFrame["isCategory"] = false;
	
	if (not isNew) then
		local x		= gStackList_SelectedIndex;
		local plist	= gStackList_plist;
		
		Atr_Mem_itemName_static:SetText (plist[x].text);
		
		stackSize = plist[x].stacksize
		numStacks = plist[x].numstacks

		local isCategory = (plist[x].sortkey ~= plist[x].text);

		Atr_MemorizeFrame["isCategory"] = isCategory;
		
		if (isCategory and numStacks == -2) then
			numStacks = -1;
			stackSize = 1;
		end
		
		zc.SetTextIf (Atr_Mem_itemName_text, isCategory, ZT("Category"), ZT("Item Name"));
		zc.SetTextIf (Atr_Mem_Forget,		 isCategory, ZT("Reset to Default"), ZT("Forget this Item"));
	end
		
	Atr_Mem_EB_stackSize:SetText (stackSize);

	UIDropDownMenu_Initialize		(Atr_Mem_DD_numStacks, Atr_SONumStacks_Initialize);
	UIDropDownMenu_SetSelectedValue	(Atr_Mem_DD_numStacks, numStacks);

	Atr_Mem_EB_itemName:SetText ("");
	
	ShowInterfaceOptionsMask();

	Atr_MemorizeFrame:Show();

end

-----------------------------------------

function Atr_StackingList_Edit_OnClick()

	Atr_Memorize_Show(false);

end

-----------------------------------------

function Atr_StackingList_New_OnClick()

	Atr_Memorize_Show(true);

end

-----------------------------------------

function Atr_Memorize_Save()

	local x		= gStackList_SelectedIndex;
	local plist	= gStackList_plist;

	local key = Atr_Mem_EB_itemName:GetText();
	if (key == nil or key == "") then
		key = plist[x].sortkey;
	end
	
	if (key and key ~= "") then
		Atr_Set_StackingPrefs_numstacks (key, UIDropDownMenu_GetSelectedValue (Atr_Mem_DD_numStacks));
		Atr_Set_StackingPrefs_stacksize (key, Atr_Mem_EB_stackSize:GetNumber ());
	end

	Atr_StackingList_Display();
	
end

-----------------------------------------

function Atr_Memorize_Forget()

	local x		= gStackList_SelectedIndex;
	local plist	= gStackList_plist;
	local key	= plist[x].sortkey;

	if (key) then
		Atr_Clear_StackingPrefs (key);
	end

	if (not Atr_MemorizeFrame["isCategory"]) then
		gStackList_SelectedIndex = 0;
	end

	Atr_StackingList_Display();

end


-----------------------------------------

function Atr_SONumStacks_OnLoad(self)

	UIDropDownMenu_Initialize		(self, Atr_SONumStacks_Initialize);
	UIDropDownMenu_SetSelectedValue	(self, -1);
	UIDropDownMenu_JustifyText		(self, "CENTER");
	UIDropDownMenu_SetWidth			(self, 150);

end

-----------------------------------------

function Atr_SONumStacks_Initialize(self)

	local info = UIDropDownMenu_CreateInfo();

	Atr_AddMenuPick (self, info, ZT("As many as possible"),		-1,  Atr_SONumStacks_OnClick)
	Atr_AddMenuPick (self, info, "1",								 1,  Atr_SONumStacks_OnClick)
	Atr_AddMenuPick (self, info, "2",								 2,  Atr_SONumStacks_OnClick)
	Atr_AddMenuPick (self, info, "3",								 3,  Atr_SONumStacks_OnClick)
	Atr_AddMenuPick (self, info, "4",								 4,  Atr_SONumStacks_OnClick)
	Atr_AddMenuPick (self, info, "5",								 5,  Atr_SONumStacks_OnClick)
	Atr_AddMenuPick (self, info, "10",							10,  Atr_SONumStacks_OnClick)
                                            
end

-----------------------------------------

function Atr_SONumStacks_OnClick(self)

	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
	Atr_Mem_stacksOf_text:SetText (ZT ((self.value == 1) and "stack of" or "stacks of"));
end



-----------------------------------------

function Atr_ShowOptionTooltip (elem)

	local name = elem:GetName();
	local text;

	if (zc.StringContains (name, "Enable_Alt")) then
		text = ZT("If this option is checked, holding the Alt key down while clicking an item in your bags will switch to the Auctionator panel, place the item in the Auction Item area, and start the scan.");
	end

	if (zc.StringContains (name, "Deftab")) then
		text = ZT("Select the Auctionator panel to be displayed first whenever you open the Auction House window.");
	end

	if (zc.StringContains (name, "Open_BUY")) then
		text = ZT("If this option is checked, the Auctionator BUY panel will display first whenever you open the Auction House window.");
	end

	if (zc.StringContains (name, "Open_All_Bags")) then
		text = ZT("If this option is checked, ALL your bags will be opened when you first open the Auctionator panel.");
	end

	if (zc.StringContains (name, "Def_Duration")) then
		text = ZT("If this option is checked, every time you initiate a new auction the auction duration will be reset to the default duration you've selected.");
	end

	if (text) then
		local titleFrame = _G[name.."_CB_Text"] or _G[name.."_Text"];
		
		local titleText = titleFrame and titleFrame:GetText() or "???";
		
		GameTooltip:SetOwner(elem, "ANCHOR_LEFT");
		GameTooltip:SetText(titleText, 0.9, 1.0, 1.0);
		GameTooltip:AddLine(text, 0.5, 0.5, 1.0, 1);
		GameTooltip:Show();
	end
	
end

-----------------------------------------

function Atr_SetupScanningConfigFrame ()

	UIDropDownMenu_Initialize(Atr_scanLevelDD, Atr_scanLevelDD_Initialize);
	UIDropDownMenu_SetSelectedValue(Atr_scanLevelDD, AUCTIONATOR_SCAN_MINLEVEL);
end

-----------------------------------------

function Atr_ScanningOptionsFrame_Save()

	local origValues = zc.msg_str (AUCTIONATOR_SCAN_MINLEVEL);

	AUCTIONATOR_SCAN_MINLEVEL = UIDropDownMenu_GetSelectedValue(Atr_scanLevelDD);

	local newValues = zc.msg_str (AUCTIONATOR_SCAN_MINLEVEL);

	if (origValues ~= newValues) then
		zc.msg_atr (ZT("scanning options saved"));
	end
	
end

-----------------------------------------

function Atr_scanLevelDD_Initialize(self)

	local info = UIDropDownMenu_CreateInfo();
	
	Atr_AddMenuPick (self, info, "|cffa335ee"..ZT("Epic").."|r",			5, Atr_scanLevelDD_OnClick);
	Atr_AddMenuPick (self, info, "|cff0070dd"..ZT("Rare").."|r",			4, Atr_scanLevelDD_OnClick);
	Atr_AddMenuPick (self, info, "|cff1eff00"..ZT("Uncommon").."|r",		3, Atr_scanLevelDD_OnClick);
	Atr_AddMenuPick (self, info, "|cffffffff"..ZT("Common").."|r",		2, Atr_scanLevelDD_OnClick);
	Atr_AddMenuPick (self, info, "|cff9d9d9d"..ZT("Poor (all)").."|r",	1, Atr_scanLevelDD_OnClick);

end

-----------------------------------------

function Atr_scanLevelDD_OnClick(self)
	UIDropDownMenu_SetSelectedValue(self.owner, self.value);
end

-----------------------------------------

function Atr_scanLevelDD_showTip(self)

	GameTooltip:SetOwner(self, "ANCHOR_LEFT");
	GameTooltip:SetText(ZT("Minimum Quality Level"), 0.9, 1.0, 1.0);
	GameTooltip:AddLine(ZT("Only include items in the scanning database that are this level or higher"), 0.5, 0.5, 1.0, 1);
	GameTooltip:Show();
end



-----------------------------------------

function Atr_MakeOptionsFrameOpaque ()

	local bd = { bgFile="Interface/RAIDFRAME/UI-RaidFrame-GroupBg",
				 edgeFile="Interface/DialogFrame/UI-DialogBox-Border", 
				 tile=false, edgeSize=32,
				 insets={left=11,right=11,top=10,bottom=10}
				};
	
	local list_bd = { 
					bgFile="Interface/CharacterFrame/UI-Party-Background",
					tile=true,
					insets={left=5,right=5,top=5,bottom=5}
					}

	InterfaceOptionsFrame:SetBackdrop ( bd );
	InterfaceOptionsFrameAddOns:SetBackdrop ( list_bd );
	InterfaceOptionsFrameCategories:SetBackdrop ( list_bd );
end

-----------------------------------------

local gInterfaceOptionsMask;

-----------------------------------------

function ShowInterfaceOptionsMask()

	if (gInterfaceOptionsMask == nil) then
		gInterfaceOptionsMask = CreateFrame ("Frame", "Atr_Mask_StdOptions", _G["InterfaceOptionsFrame"], "Atr_Mask_StdOptionsTempl");
		gInterfaceOptionsMask:SetFrameLevel (129);
	end
	
	gInterfaceOptionsMask:Show();
	
end

-----------------------------------------

function HideInterfaceOptionsMask()
	if (gInterfaceOptionsMask) then
		gInterfaceOptionsMask:Hide();
	end
end


