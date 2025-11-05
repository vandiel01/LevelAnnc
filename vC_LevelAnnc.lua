local vC_AppName, vC_App = ...
-------------------------------------------------------
-- Events Registered
-------------------------------------------------------
local vC_RegisterEvents = CreateFrame("Frame")
	vC_RegisterEvents:RegisterEvent("ADDON_LOADED")
	vC_RegisterEvents:SetScript("OnEvent", function(s, e, ...)
	if ( e == "ADDON_LOADED" ) then
		local vC_ListOfEvents = {
			"PLAYER_LOGIN",
			"PLAYER_ENTERING_WORLD",
			"PLAYER_LEVEL_UP",											-- Did Player Level Up?
			"UNIT_AURA",												-- Only for Legion Remix
		}
		for i = 1, #vC_ListOfEvents do
			vC_RegisterEvents:RegisterEvent(vC_ListOfEvents[i])
		end
	end
	if ( e == "PLAYER_LOGIN" ) then
		DEFAULT_CHAT_FRAME:AddMessage("Loaded: "..vC_AppTitle)			-- Display Title with Version in Chat
	end

	-- Player Aura Update	
	if ( e == "PLAYER_ENTERING_WORLD" ) then
		vC_AuraChange_LegionRemix()
	end
	if ( e == "UNIT_AURA" ) then
		vC_AuraChange_LegionRemix()
	end
	-- Player Levelled?
	if ( e == "PLAYER_LEVEL_UP" ) then
		C_Timer.After(.75, function() SendChatMessage("<-- Level "..UnitLevel("player"),"GUILD") end)
	end
end)
-------------------------------------------------------
-- SEE the Infinite Power, Rather than Mousing Over Buff
-------------------------------------------------------
function vC_AuraChange_LegionRemix()
	if ( vC_tIBP_TipF == nil ) then
		local playerClass, englishClass = UnitClass("player")
			rPerc, gPerc, bPerc, argbHex = GetClassColor(englishClass)
		local vC_tIBP_TipF = CreateFrame("Frame", "vC_tIBP_TipF", BuffFrame, "BackdropTemplate")
			vC_tIBP_TipF:ClearAllPoints()
			vC_tIBP_TipF:SetSize(130, 130)
			vC_tIBP_TipF:SetPoint("RIGHT", BuffFrame, "LEFT", -25, 10)
			local vC_tIBP_Tip = vC_tIBP_TipF:CreateFontString("vC_tIBP_Tip", "ARTWORK", "SystemFont_Shadow_Med3_Outline")
				vC_tIBP_Tip:SetPoint("LEFT", vC_tIBP_TipF)
				vC_tIBP_Tip:SetJustifyH("LEFT")
				vC_tIBP_Tip:SetTextColor(rPerc, gPerc, bPerc, .90)
	end
	for i = 1, 30 do
		local aura = C_UnitAuras.GetBuffDataByIndex("player", i, "HELPFUL")
		if not aura then break end
		if ( aura.name == "Infinite Power" ) then
			if ( vC_tIPB == nil ) then
				local vC_tIPB = CreateFrame("GameTooltip", "vC_tIPB", nil, "GameTooltipTemplate")
					vC_tIPB:SetOwner(UIParent, "ANCHOR_NONE")
			end
			vC_tIPB:ClearLines()
			vC_tIPB:SetUnitBuff("player", i)
			for b = 2, vC_tIPB:NumLines() do
				local s = _G["vC_tIPBTextLeft" .. b]:GetText():gsub("experience gain", "XP Gain")
				vC_tIBP_Tip:SetText(s)
			end
			break
		end
	end
end