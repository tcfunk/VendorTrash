local addonName, ns = ...

if not VendorTrashDB then
  VendorTrashDB = {}
end

local function RegisterSettings()
  
  local db = VendorTrashDB
  local category, layout = Settings.RegisterVerticalLayoutCategory(addonName)
  ns.categoryID = category:GetID()

  do
    local setting = Settings.RegisterAddOnSetting(category,
      "printSoldItems", "printSoldItems", db, type(true),
      "Print Items Sold", true)
    Settings.CreateCheckbox(category, setting,
      "Print a hyperlink for each junk item sold to merchant")
  end

  do
    local setting = Settings.RegisterAddOnSetting(category,
      "printTotal", "printTotal", db, type(true),
      "Print Total Sold", true)
    Settings.CreateCheckbox(category, setting,
      "Print the total currency received after selling junk.")
  end

  do
    local setting = Settings.RegisterAddOnSetting(category,
      "autoSellJunk", "autoSellJunk", db, type(true),
      "Auto-Sell junk", true)
    Settings.CreateCheckbox(category, setting,
      "Automatically sell grey quality items when visiting a vendor.")
  end

  Settings.RegisterAddOnCategory(category)
end

EventUtil.ContinueOnAddOnLoaded(addonName, RegisterSettings)