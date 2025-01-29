-- Shared Configuration (rsg-chairs/shared/config.lua)
Config = {}

Config.ChairModels = {
    ['basic_chair'] = `p_chairfolding02x`,
    ['crate_chair'] = `p_chair_crate02x`,
    ['comfy_chair'] = `p_chair_cs05x`,
    ['wooden_chair'] = `p_chair_10x`,
    ['rocking_chair'] = `p_chairrocking02x`,
    ['fancy_chair'] = `p_windsorchair03x`
}

-- Add this to your items.lua in RSG-Core shared folder:
["chair"] = {
    ["name"] = "chair",
    ["label"] = "Folding Chair",
    ["weight"] = 2.0,
    ["type"] = "item",
    ["image"] = "chair.png",
    ["unique"] = false,
    ["useable"] = true,
    ["shouldClose"] = true,
    ["combinable"] = nil,
    ["description"] = "A portable folding chair"
},