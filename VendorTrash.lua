local addonName, ns = ...
local events = {}
local db

local function SellJunk()
  local total_earned = 0
  local db = VendorTrashDB

  for bag = 0,4 do
    slots = C_Container.GetContainerNumSlots(bag)
    for slot = 1,slots do
      local item = C_Container.GetContainerItemInfo(bag, slot)
      if item ~= nil and item.quality == 0 and not item.hasNoValue then
        local _,_,_,_,_,_,_,_,_,_,sellPrice = C_Item.GetItemInfo(item.itemID)
        local converted_price = C_CurrencyInfo.GetCoinTextureString(sellPrice)
        C_Container.UseContainerItem(bag,slot)
        total_earned = total_earned + (item.stackCount*sellPrice)

        if db.printSoldItems then
          print("Sold " .. item.hyperlink .. "x" .. item.stackCount .. " at " .. converted_price .. " each")
        end
      end
    end -- end slots
  end

  if db.printTotal then
    if total_earned > 0 then
      print("Sold " .. C_CurrencyInfo.GetCoinTextureString(total_earned) .. " worth of junk!")
    else
      print("Nothing to sell.")
    end
  end
end

function events:ADDON_LOADED(loadedAddon)
  if loadedAddon ~= addonName then return end

  if not VendorTrashDB then
    VendorTrashDB = {}
  end

  for key, value in pairs(ns.defaults) do
    if VendorTrashDB[key] == nil then
      VendorTrashDB[key] = value
    end
  end

  self:UnregisterEvent("ADDON_LOADED")
end

function events:MERCHANT_SHOW()
  local db = VendorTrashDB
  local f = CreateFrame("FRAME", nil, MerchantFrame)
  f:SetWidth(110)
  f:SetHeight(30)
  f:SetPoint("TOPRIGHT", MerchantFrame, "TOPRIGHT", 0, -20)

  f.btn = CreateFrame("BUTTON", nil, f, "UIPanelButtonTemplate")
  f.btn:SetWidth(100)
  f.btn:SetHeight(22)
  f.btn:SetPoint("CENTER",f,"CENTER")
  f.btn:SetText("Sell Greys")
  f.btn:SetAlpha(1)

  f.btn:SetScript("OnClick", SellJunk)

  if db.autoSellJunk then
    SellJunk()
  end
end

local frame = CreateFrame("Frame")

frame:SetScript("OnEvent", function(self, event, ...)
  local handler = events[event]
  if handler then
    handler(self, ...)
  end
end)

for event in pairs(events) do
  frame:RegisterEvent(event)
end

