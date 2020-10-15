local VendorTrash = {}

function init()
  VendorTrash:Initialize()
  vtprint("VendorTrash v0.10 initialized")
end

-- Initialize the addon
function VendorTrash:Initialize()
  local f = CreateFrame("FRAME", nil, MerchantFrame, "BackdropTemplate")
  f:SetWidth(110)
  f:SetHeight(30)
  f:SetBackdrop({
        bgfile = "Interface\DialogFrame\UI-DialogBox-Background",
        edgefile  = "Interface\DialogFrame\UI-DialogBox-Border",
        tile = true, tileSize = 32, edgeSize = 32,
        insets = {left = 11, right = 12, top = 12, bottom = 11}
  })
  f:SetBackdropColor(0,0,0,1)
  f:SetPoint("TOPLEFT", MerchantFrame, "TOPLEFT", 60, -25)

  f.btn = CreateFrame("BUTTON", nil, f, "UIPanelButtonTemplate")
  f.btn:SetWidth(100)
  f.btn:SetHeight(22)
  f.btn:SetPoint("CENTER",f,"CENTER")
  f.btn:SetText("Sell Greys")
  f.btn:SetAlpha(1)

  f.btn:SetScript("OnClick", sell_greys)
end

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
    slots = GetContainerNumSlots(bag)
    for slot = 1,slots do
      local _, quantity, _, quality, _, _, link, _, _, iid = GetContainerItemInfo(bag, slot)
      if iid ~= nil and quality == 0 then
        local _,_,_,_,_,_,_,_,_,_,sell_price = GetItemInfo(link)
        UseContainerItem(bag,slot)
        vtprint("Sold " .. link .. "x" .. quantity .. " at " .. convert_currency(sell_price) .. " each")
        total_earned = total_earned + (quantity*sell_price)
      end
    end -- end slots
  end
  if total_earned > 0 then
    vtprint("Sold " .. convert_currency(total_earned) .. " worth of junk!")
  else
    vtprint("Nothing to sell.")
  end
end

VendorTrash.frame = frame
