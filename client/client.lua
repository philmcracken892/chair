
local RSGCore = exports['rsg-core']:GetCoreObject()


local CHECK_RADIUS = 2.0
local CHAIR_PROPS = {
    {
        label = "Folding Chair",
        model = `p_chairfolding02x`,
        offset = vector3(0.0, -0.1, 0.5)
    },
    {
        label = "Crate Chair",
        model = `p_chair_crate02x`,
        offset = vector3(0.0, -0.2, 0.5)
    },
    {
        label = "Comfort Chair",
        model = `p_chair_cs05x`,
        offset = vector3(0.0, -0.1, 0.5)
    },
    {
        label = "Wooden Chair",
        model = `p_chair_10x`,
        offset = vector3(0.0, -0.1, 0.5)
    },
    {
        label = "Rocking Chair",
        model = `p_chairrocking02x`,
        offset = vector3(0.0, -0.2, 0.6)
    },
    {
        label = "Toilet Chair",
        model = `p_toiletchair01x`,
        offset = vector3(0.0, -0.1, 0.5)
    }
}

-- Variables
local deployedChair = nil
local deployedOwner = nil
local isSitting = false
local currentChairData = nil


local function ShowChairMenu()
    local chairOptions = {}
    
    for i, chair in ipairs(CHAIR_PROPS) do
        table.insert(chairOptions, {
            title = chair.label,
            description = "Place a " .. chair.label,
            icon = 'fas fa-chair',
            onSelect = function()
                TriggerEvent('rsg-chairs:client:placeChair', i)
            end
        })
    end

    lib.registerContext({
        id = 'chair_selection_menu',
        title = 'Select Chair Style',
        options = chairOptions
    })
    
    lib.showContext('chair_selection_menu')
end


local function RegisterChairTargeting()
    local models = {}
    for _, chair in ipairs(CHAIR_PROPS) do
        table.insert(models, chair.model)
    end

    exports['ox_target']:addModel(models, {
        {
            name = 'sit_on_chair',
            event = 'rsg-chairs:client:sitOnChair',
            icon = "fas fa-chair",
            label = "Sit",
            distance = 2.0,
            canInteract = function(entity)
                return not isSitting
            end
        },
        {
            name = 'pickup_chair',
            event = 'rsg-chairs:client:pickupChair',
            icon = "fas fa-hand",
            label = "Pick Up Chair",
            distance = 2.0,
            canInteract = function(entity)
                return not isSitting
            end
        }
    })
end


RegisterNetEvent('rsg-chairs:client:placeChair', function(chairIndex)
    if deployedChair then
        lib.notify({
            title = "Chair Already Placed",
            description = "You already have a chair placed.",
            type = 'error'
        })
        return
    end

    local chairData = CHAIR_PROPS[chairIndex]
    if not chairData then return end

    local coords = GetEntityCoords(PlayerPedId())
    local heading = GetEntityHeading(PlayerPedId())
    local forward = GetEntityForwardVector(PlayerPedId())
    
    
    local offsetDistance = 1.0
    local x = coords.x + forward.x * offsetDistance
    local y = coords.y + forward.y * offsetDistance
    local z = coords.z

    
    RequestModel(chairData.model)
    while not HasModelLoaded(chairData.model) do
        Wait(100)
    end

    
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
    Wait(2000)

    
    local chairObject = CreateObject(chairData.model, x, y, z, true, false, false)
    PlaceObjectOnGroundProperly(chairObject)
    SetEntityHeading(chairObject, heading)
    FreezeEntityPosition(chairObject, true)
    
    deployedChair = chairObject
    currentChairData = chairData
    deployedOwner = GetPlayerServerId(PlayerId())
    
    Wait(500)
    ClearPedTasks(PlayerPedId())
end)


RegisterNetEvent('rsg-chairs:client:pickupChair', function()
    if not deployedChair then
        lib.notify({
            title = "No Chair!",
            description = "There's no chair to pick up.",
            type = 'error'
        })
        return
    end

    if isSitting then
        lib.notify({
            title = "Cannot Pick Up",
            description = "You can't pick up the chair while sitting on it.",
            type = 'error'
        })
        return
    end

    local ped = PlayerPedId()
    
    LocalPlayer.state:set('inv_busy', true, true)
    TaskStartScenarioInPlace(PlayerPedId(), GetHashKey('WORLD_HUMAN_CROUCH_INSPECT'), -1, true, false, false, false)
    Wait(2000)

    if deployedChair then
        DeleteObject(deployedChair)
        deployedChair = nil
        currentChairData = nil
        TriggerServerEvent('rsg-chairs:server:returnChair')
        deployedOwner = nil
    end

    ClearPedTasks(ped)
    LocalPlayer.state:set('inv_busy', false, true)

    lib.notify({
        title = 'Chair Picked Up',
        description = 'You have retrieved your chair.',
        type = 'success'
    })
end)


AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() ~= resourceName then return end
    
    if deployedChair then
        DeleteObject(deployedChair)
    end
end)


CreateThread(function()
    RegisterChairTargeting()
end)


RegisterNetEvent('rsg-chairs:client:openChairMenu', function()
    ShowChairMenu()
end)