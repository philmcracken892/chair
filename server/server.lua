local RSGCore = exports['rsg-core']:GetCoreObject()


RSGCore.Functions.CreateUseableItem("chair", function(source, item)
    local Player = RSGCore.Functions.GetPlayer(source)
    if not Player then return end
    
    
    TriggerClientEvent('rsg-chairs:client:openChairMenu', source)
	Player.Functions.RemoveItem("chair", 1)
end)


RegisterNetEvent('rsg-chairs:server:returnChair', function()
    local src = source
    local Player = RSGCore.Functions.GetPlayer(src)
    if not Player then return end

    Player.Functions.AddItem("chair", 1)
    TriggerClientEvent('inventory:client:ItemBox', src, RSGCore.Shared.Items["chair"], "add")
end)





