local VendorTrash = {}
local frame = CreateFrame("Frame")

frame:RegisterEvent("MERCHANT_SHOW")

frame:SetScript("OnEvent", function(self, event, ...)
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

  f.btn:SetScript("OnClick", sell_greys)
end)

function convert_currency(amount)
  local GOLD_MULT = 10000
  local SILVER_MULT = 100

  local gold = math.floor(amount/GOLD_MULT)
  local remainder = amount % GOLD_MULT
  local silver = math.floor(remainder/SILVER_MULT)
  local copper = remainder % SILVER_MULT
  
  local currency_string = copper .. "c"
  if (silver ~= 0) then
    currency_string = silver .. "s " .. currency_string
  end
  if (gold ~= 0) then
    currency_string = gold .. "g " .. currency_string
  end
  
  return currency_string
end

function vtprint(message)
  DEFAULT_CHAT_FRAME:AddMessage(message)
end

function sell_greys()
  local total_earned = 0
  for bag = 0,4 do
    slots = C_Container.GetContainerNumSlots(bag)
    for slot = 1,slots do
      local item = C_Container.GetContainerItemInfo(bag, slot)
      if item ~= nil and item.quality == 0 then
        local _,_,_,_,_,_,_,_,_,_,sellPrice = GetItemInfo(2211)
        local converted_price = convert_currency(sellPrice)
        C_Container.UseContainerItem(bag,slot)
        vtprint("Sold " .. item.hyperlink .. "x" .. item.stackCount .. " at " .. converted_price .. " each")
        total_earned = total_earned + (item.stackCount*sellPrice)
      end
    end -- end slots
  end
  if total_earned > 0 then
    vtprint("Sold " .. convert_currency(total_earned) .. " worth of junk!")
  else
    vtprint("Nothing to sell.")
  end
end
