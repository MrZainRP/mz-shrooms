
local QBCore = exports['qb-core']:GetCoreObject()

local ItemList = {
    ["fabric"] = "fabric",
    ["plastic"] = "plastic",
    ["shroom"] = "shroom",
}

--------------------------------
--COLLECTING SHROOMS FUNCTIONS--
--------------------------------

RegisterNetEvent("mz-shrooms:server:addShroom",function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantum = 0
    local amount = math.random(1, 100)
    if amount < 11 then
        quantum = 2
        if Config.NotifyType == 'qb' then
            TriggerClientEvent('QBCore:Notify', src, "Nice! This mushroom has two heads!", "success", 3500)
        elseif Config.NotifyType == "okok" then
            TriggerClientEvent('okokNotify:Alert', source, "DUAL SHROOMS", "Nice! This mushroom has two heads!", 3500, 'success')
        end
    else
        quantum = 1
    end
    Wait(3000)
    Player.Functions.AddItem('shroom', quantum)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["shroom"], "add", quantum)
end)

RegisterNetEvent("mz-shrooms:server:removeGlovesSuccess", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local tear = math.random(1, 100)
    if tear <= Config.GloveTearSuccessChance then
        Player.Functions.RemoveItem('gardengloves', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["gardengloves"], "remove", 1)
        if Config.NotifyType == 'qb' then
            TriggerClientEvent('QBCore:Notify', src, "Darn, your gloves tore!", "success", 3500)
        elseif Config.NotifyType == "okok" then
            TriggerClientEvent('okokNotify:Alert', source, "TORN GLOVES", "Darn, your gloves tore!", 3500, 'success')
        end
    end
end)

RegisterNetEvent("mz-shrooms:server:removeGlovesFail", function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local tear = math.random(1, 100)
    if tear <= Config.GloveTearFailChance then
        Player.Functions.RemoveItem('gardengloves', 1)
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["gardengloves"], "remove", 1)
        if Config.NotifyType == 'qb' then
            TriggerClientEvent('QBCore:Notify', src, "A slip of the hand and your gloves tear...", "error", 3500)
        elseif Config.NotifyType == "okok" then
            TriggerClientEvent('okokNotify:Alert', source, "TORN GLOVES", "A slip of the hand and your gloves tear...", 3500, 'error')
        end
    elseif tear > Config.GloveTearFailChance then 
        if Config.NotifyType == 'qb' then
            TriggerClientEvent('QBCore:Notify', src, "You need to be careful, this fabric won't hold...", "error", 3500)
        elseif Config.NotifyType == "okok" then
            TriggerClientEvent('okokNotify:Alert', source, "GARDENING GLOVES", "You need to be careful, this fabric won't hold...", 3500, 'error')
        end
    end
end)

---------------
--MAKE GLOVES--
---------------

RegisterServerEvent('mz-shrooms:server:MakeGloves')
AddEventHandler('mz-shrooms:server:MakeGloves', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local fabric = Player.Functions.GetItemByName('fabric')
    if Player.PlayerData.items ~= nil then 
        if fabric ~= nil then 
            if fabric.amount >= 5 then 
                Player.Functions.RemoveItem("fabric", 5)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['fabric'], "remove", 5)
                TriggerClientEvent("mz-shrooms:client:MakeGlovesMinigame", src)
            else
                if Config.NotifyType == 'qb' then
                    TriggerClientEvent('QBCore:Notify', src, "You need five (5) pieces of fabric...", 'error')
                elseif Config.NotifyType == "okok" then
                    TriggerClientEvent('okokNotify:Alert', source, "NEED FABRIC", "You need five (5) pieces of fabric...", 3500, 'error')
                end
            end
        end
    end
end)

RegisterServerEvent('mz-shrooms:server:GetGloves')
AddEventHandler('mz-shrooms:server:GetGloves', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("gardengloves", 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['gardengloves'], "add", 1)
end)

-------------------
--MAKE SHROOM BAG--
-------------------

RegisterServerEvent('mz-shrooms:server:MakeShroomBags')
AddEventHandler('mz-shrooms:server:MakeShroomBags', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local plastic = Player.Functions.GetItemByName('plastic')
    if Player.PlayerData.items ~= nil then 
        if plastic ~= nil then 
            if plastic.amount >= 2 then 
                Player.Functions.RemoveItem("plastic", 2)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['plastic'], "remove", 2)
                TriggerClientEvent("mz-shrooms:client:MakeShroomBagsMinigame", src)
            else
                if Config.NotifyType == 'qb' then
                    TriggerClientEvent('QBCore:Notify', src, "You need 2 pieces of plastic to make a bag.", 'error')
                elseif Config.NotifyType == "okok" then
                    TriggerClientEvent('okokNotify:Alert', source, "NEED PLASTIC", "You need 2 pieces of plastic to make a bag.", 3500, 'error')
                end
            end
        end
    end
end)

RegisterServerEvent('mz-shrooms:server:GetShroomBaggy')
AddEventHandler('mz-shrooms:server:GetShroomBaggy', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(source)
    Player.Functions.AddItem("shroombaggy", 1)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['shroombaggy'], "add", 1)
end)

---------------
--BAG SHROOMS--
---------------

RegisterServerEvent('mz-shrooms:server:BagShrooms')
AddEventHandler('mz-shrooms:server:BagShrooms', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local shroom = Player.Functions.GetItemByName('shroom')
    if Player.PlayerData.items ~= nil then 
        if shroom ~= nil then 
            if shroom.amount >= 5 then 
                Player.Functions.RemoveItem("shroom", 5)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['shroom'], "remove", 5)
                Player.Functions.RemoveItem("shroombaggy", 1)
                TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['shroombaggy'], "remove", 1)
                TriggerClientEvent("mz-shrooms:client:BagShroomsMinigame", src)
            else
                if Config.NotifyType == 'qb' then
                    TriggerClientEvent('QBCore:Notify', src, "You need five (5) shrooms and a bag.", 'error')
                elseif Config.NotifyType == "okok" then
                    TriggerClientEvent('okokNotify:Alert', source, "BAG IT UP", "You need five (5) shrooms and a bag.", 3500, 'error')
                end
            end
        end
    end
end)

--OUTPUT--
--LEVEL 0

RegisterServerEvent('mz-shrooms:server:receiveShrooms')
AddEventHandler('mz-shrooms:server:receiveShrooms', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(Config.Shroomlevel0low, Config.Shroomlevel0high)
    Player.Functions.AddItem("shroombag", quantity, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['shroombag'], "add", quantity)
end)

--LEVEL 1

RegisterServerEvent('mz-shrooms:server:receiveShroomslevel1')
AddEventHandler('mz-shrooms:server:receiveShroomslevel1', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(Config.Shroomlevel1low, Config.Shroomlevel1high)
    Player.Functions.AddItem("shroombag", quantity, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['shroombag'], "add", quantity)
end)

--LEVEL 2

RegisterServerEvent('mz-shrooms:server:receiveShroomslevel2')
AddEventHandler('mz-shrooms:server:receiveShroomslevel2', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(Config.Shroomlevel2low, Config.Shroomlevel2high)
    Player.Functions.AddItem("shroombag", quantity, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['shroombag'], "add", quantity)
end)

--LEVEL 3

RegisterServerEvent('mz-shrooms:server:receiveShroomslevel3')
AddEventHandler('mz-shrooms:server:receiveShroomslevel3', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(Config.Shroomlevel3low, Config.Shroomlevel3high)
    Player.Functions.AddItem("shroombag", quantity, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['shroombag'], "add", quantity)
end)

--LEVEL 4

RegisterServerEvent('mz-shrooms:server:receiveShroomslevel4')
AddEventHandler('mz-shrooms:server:receiveShroomslevel4', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(Config.Shroomlevel4low, Config.Shroomlevel4high)
    Player.Functions.AddItem("shroombag", quantity, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['shroombag'], "add", quantity)
end)

--LEVEL 5

RegisterServerEvent('mz-shrooms:server:receiveShroomslevel5')
AddEventHandler('mz-shrooms:server:receiveShroomslevel5', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(Config.Shroomlevel5low, Config.Shroomlevel5high)
    Player.Functions.AddItem("shroombag", quantity, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['shroombag'], "add", quantity)
end)

--LEVEL 6

RegisterServerEvent('mz-shrooms:server:receiveShroomslevel6')
AddEventHandler('mz-shrooms:server:receiveShroomslevel6', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(Config.Shroomlevel6low, Config.Shroomlevel6high)
    Player.Functions.AddItem("shroombag", quantity, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['shroombag'], "add", quantity)
end)

--LEVEL 7

RegisterServerEvent('mz-shrooms:server:receiveShroomslevel7')
AddEventHandler('mz-shrooms:server:receiveShroomslevel7', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(Config.Shroomlevel7low, Config.Shroomlevel7high)
    Player.Functions.AddItem("shroombag", quantity, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['shroombag'], "add", quantity)
end)

--LEVEL 8

RegisterServerEvent('mz-shrooms:server:receiveShroomslevel8')
AddEventHandler('mz-shrooms:server:receiveShroomslevel8', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(Config.Shroomlevel8low, Config.Shroomlevel8high)
    Player.Functions.AddItem("shroombag", quantity, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['shroombag'], "add", quantity)
end)

--MZ-SKILLS DISABLED

RegisterServerEvent('mz-shrooms:server:receiveShroomsNoXP')
AddEventHandler('mz-shrooms:server:receiveShroomsNoXP', function()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local quantity = math.random(Config.ShroomNoXPlow, Config.ShroomNoXPhigh)
    Player.Functions.AddItem("shroombag", quantity, false)
    TriggerClientEvent('inventory:client:ItemBox', source, QBCore.Shared.Items['shroombag'], "add", quantity)
end)

-------------------
--DRUG PROPERTIES--
-------------------

QBCore.Functions.CreateUseableItem("shroombag", function(source, _)
    TriggerClientEvent("mz-shrooms:client:Shrooms", source)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveItem('shroombag', 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["shroombag"], "remove", 1)
end)
