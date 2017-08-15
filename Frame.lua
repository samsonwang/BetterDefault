
--[头像位置大小及施法条修改]--
PlayerFrame:ClearAllPoints()
PlayerFrame:SetPoint("CENTER", UIParent, "CENTER", -10, 10)
PlayerFrame.SetPoint = function() end

PetFrame:ClearAllPoints()
PetFrame:SetPoint("BOTTOMLEFT", PlayerFrame, "TOP", -20, -20)
PetFrame.SetPoint = function() end

TargetFrame:ClearAllPoints()
TargetFrame:SetPoint("CENTER", PlayerFrame, "CENTER", 180, 200)
TargetFrame.SetPoint = function() end

FocusFrame:ClearAllPoints()
FocusFrame:SetPoint("CENTER", PlayerFrame, "CENTER", 250, 200)
FocusFrame.SetPoint = function() end

TargetFrameSpellBar:ClearAllPoints()
TargetFrameSpellBar:SetPoint("BOTTOM", TargetFrame, "TOP")
TargetFrameSpellBar.SetPoint = function() end
TargetFrameSpellBar:SetScale(1.2)

FocusFrameSpellBar:ClearAllPoints()
FocusFrameSpellBar:SetPoint("BOTTOM", FocusFrame, "TOP")
FocusFrameSpellBar.SetPoint = function() end
FocusFrameSpellBar:SetScale(1.2)

PartyMemberFrame1:ClearAllPoints()
PartyMemberFrame1:SetPoint("TOP",PetFrame,"BOTTOM",0,10)
PartyMemberFrame1.SetPoint = function() end


--TargetFrameTextureFrameTexture:Hide()  --材质隐藏
--TargetFrameToTTextureFrameTexture:Hide()
--FocusFrameTextureFrameTexture:Hide()
--FocusFrameToTTextureFrameTexture:Hide()


--目标及焦点头像姓名背景改成职业颜色
local frame = CreateFrame("FRAME") 
frame:RegisterEvent("GROUP_ROSTER_UPDATE") 
frame:RegisterEvent("PLAYER_TARGET_CHANGED") 
frame:RegisterEvent("PLAYER_FOCUS_CHANGED") 
frame:RegisterEvent("UNIT_FACTION") 

local function eventHandler(self, event, ...) 
if UnitIsPlayer("target") then 
c = RAID_CLASS_COLORS[select(2, UnitClass("target"))] 
TargetFrameNameBackground:SetVertexColor(c.r, c.g, c.b) 
end 
if UnitIsPlayer("focus") then 
c = RAID_CLASS_COLORS[select(2, UnitClass("focus"))] 
FocusFrameNameBackground:SetVertexColor(c.r, c.g, c.b) 
end 
end 

frame:SetScript("OnEvent", eventHandler) 

for _, BarTextures in pairs({TargetFrameNameBackground, FocusFrameNameBackground}) do 
BarTextures:SetTexture("Interface\\TargetingFrame\\UI-StatusBar") 
end


--隐藏玩家头像伤害治疗量
PlayerHitIndicator:SetText(nil) 
PlayerHitIndicator.SetText = function() end


--[[
--隐藏pvp图标
PlayerPVPIcon:SetAlpha(0)
TargetFrameTextureFramePVPIcon:SetAlpha(0)
FocusFrameTextureFramePVPIcon:SetAlpha(0)
]]--


--目标及焦点战斗状态指示
local t = CreateFrame("Frame", UIParent) 
t.t = t:CreateTexture() 
t.t:SetTexture("Interface\\CHARACTERFRAME\\UI-StateIcon.blp") 
t.t:SetTexCoord(0.5,1,0,0.49); 
t.t:SetAllPoints(t) 
t:SetWidth(25) 
t:SetHeight(25) 
t:SetPoint("CENTER", TargetFrame, "RIGHT", -20, 0)-----目标位置 
t:Show() 

local function FrameOnUpdate(self) 
           if UnitAffectingCombat("target") then 
                  self:Show() 
           else 
                  self:Hide() 
           end 
end 
local g = CreateFrame("Frame") 
g:SetScript("OnUpdate", function(self) FrameOnUpdate(t) end) 

local f = CreateFrame("Frame", UIParent) 
f.t = f:CreateTexture() 
f.t:SetTexture("Interface\\CHARACTERFRAME\\UI-StateIcon.blp") 
f.t:SetTexCoord(0.5,1,0,0.49); 
f.t:SetAllPoints(f) 
f:SetWidth(25) 
f:SetHeight(25) 
f:SetPoint("CENTER", FocusFrame, "RIGHT", -20, 0)---焦点位置 
f:Show()

local function FrameOnUpdateFocus(self) 
           if UnitAffectingCombat("focus") then 
                  self:Show() 
           else 
                  self:Hide() 
           end 
end 
local g = CreateFrame("Frame") 
g:SetScript("OnUpdate", function(self) FrameOnUpdateFocus(f) end)


--[[
--快速焦点
local modifier = "shift" -- shift, alt or ctrl 
local mouseButton = "1" -- 1 = left, 2 = right, 3 = middle, 4 and 5 = thumb buttons if there are any 

local function SetFocusHotkey(frame) 
   frame:SetAttribute(modifier.."-type"..mouseButton, "focus") 
end 

local function CreateFrame_Hook(type, name, parent, template) 
   if name and template == "SecureUnitButtonTemplate" then 
      SetFocusHotkey(_G[name]) 
   end 
end 

hooksecurefunc("CreateFrame", CreateFrame_Hook) 

local f = CreateFrame("CheckButton", "FocuserButton", UIParent, "SecureActionButtonTemplate") 
f:SetAttribute("type1", "macro") 
f:SetAttribute("macrotext", "/focus mouseover") 
SetOverrideBindingClick(FocuserButton, true, modifier.."-BUTTON"..mouseButton, "FocuserButton") 

local duf = {
   PetFrame, 
   PartyMemberFrame1, 
   PartyMemberFrame2, 
   PartyMemberFrame3, 
   PartyMemberFrame4, 
   PartyMemberFrame1PetFrame, 
   PartyMemberFrame2PetFrame, 
   PartyMemberFrame3PetFrame, 
   PartyMemberFrame4PetFrame, 
   PartyMemberFrame1TargetFrame, 
   PartyMemberFrame2TargetFrame, 
   PartyMemberFrame3TargetFrame, 
   PartyMemberFrame4TargetFrame, 
   TargetFrame, 
   TargetFrameToT, 
   TargetFrameToTTargetFrame, 
   ALUF_TargetFrame, 
} 

for i, frame in pairs(duf) do 
   SetFocusHotkey(frame) 
end
]]


--[[
--血量格式修改
local function HealthBarText(statusFrame, textString, value, valueMin, valueMax) 
   if (value and valueMax > 0) then 
      textString:SetText(HealthBarText_CapDisplayOfNumericValue(value)) 
   end 
end 
hooksecurefunc("TextStatusBar_UpdateTextStringWithValues", HealthBarText) 

function HealthBarText_CapDisplayOfNumericValue(value) 
   local decimal = {"", " W", SECOND_NUMBER_CAP} 
   local count = 1 
   while(value > 10000 and count <3)do 
      value = value / 10000 
      count = count + 1 
   end 
   return format("%.1f" , value).." "..decimal[count] 
end
]]
