local QBCore = exports['qb-core']:GetCoreObject()

local ShroomSpawns = {}

local isPickingShroom = false
local withinShroomZone = false 

local spawnedShrooms = 0
local NeededAttempts = 0
local SucceededAttempts = 0
local FailedAttemps = 0

---------------------------
--SHROOMS FIELD FUNCTIONS--
---------------------------

CreateThread(function()
	while true do
		Wait(10)
		local coords = GetEntityCoords(PlayerPedId())
		if GetDistanceBetweenCoords(coords, Config.ShroomField, true) < 50 then
			SpawnShroomSpawns()
            withinShroomZone = true 
			Wait(500)
		else
			withinShroomZone = false 
            Wait(3000)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(ShroomSpawns) do
			DeleteObject(v)
		end
	end
end)

function SpawnObject(model, coords, cb)
	local model = (type(model) == 'number' and model or GetHashKey(model))
	RequestModel(model)
	while not HasModelLoaded(model) do
		Wait(1)
	end
    local obj = CreateObject(model, coords.x, coords.y, coords.z, false, false, true)
    SetModelAsNoLongerNeeded(model)
    PlaceObjectOnGroundProperly(obj)
    FreezeEntityPosition(obj, true)
    if cb then
        cb(obj)
    end
end

function SpawnShroomSpawns()
	while spawnedShrooms < 15 do
		Wait(1)
		local placementCoords = GenerateShroomCoords()
		SpawnObject('prop_stoneshroom1', placementCoords, function(obj)
			table.insert(ShroomSpawns, obj)
			spawnedShrooms = spawnedShrooms + 1
		end)
	end
end 

function ValidateShroomCoord(mushroomCoord)
	if spawnedShrooms > 0 then
		local validate = true
		for k, v in pairs(ShroomSpawns) do
			if GetDistanceBetweenCoords(mushroomCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end
		if GetDistanceBetweenCoords(mushroomCoord, Config.ShroomField, false) > 50 then
			validate = false
		end
		return validate
	else
		return true
	end
end

function GenerateShroomCoords()
	while true do
		Wait(1)
		local shroomyCoordX, shroomyCoordY
		math.randomseed(GetGameTimer())
		local modX = math.random(-22, 22)
		Wait(100)
		math.randomseed(GetGameTimer())
		local modY = math.random(-22, 22)
		shroomyCoordX = Config.ShroomField.x + modX
		shroomyCoordY = Config.ShroomField.y + modY
		local coordZ = GetCoordZShrooms(shroomyCoordX, shroomyCoordY)
		local coord = vector3(shroomyCoordX, shroomyCoordY, coordZ)
		if ValidateShroomCoord(coord) then
			return coord
		end
	end
end

function GetCoordZShrooms(x, y)
	local groundCheckHeights = { (Config.ShroomRounded - 4), (Config.ShroomRounded - 3), (Config.ShroomRounded - 2), (Config.ShroomRounded - 1), Config.ShroomRounded, (Config.ShroomRounded + 1), (Config.ShroomRounded + 2), (Config.ShroomRounded + 3), (Config.ShroomRounded + 4), (Config.ShroomRounded + 5), (Config.ShroomRounded + 6) }
	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)
		if foundGround then
			return z
		end
	end
	return Config.ShroomHeight
end

------------------
---PICK SHROOMS---
------------------

exports['qb-target']:AddTargetModel(Config.ShroomProp, {
	options = {
		{
			event = "mz-shrooms:client:harvestMushroom",
			icon = "fas fa-seedling",
			label = "Take Mushroom",
		},
	},
	distance = 2.0
}) 

RegisterNetEvent('mz-shrooms:client:harvestMushroom', function()
	local playerPed = PlayerPedId()
	local coords = GetEntityCoords(playerPed)
	local nearbyObject, nearbyID
	for i=1, #ShroomSpawns, 1 do
		if GetDistanceBetweenCoords(coords, GetEntityCoords(ShroomSpawns[i]), false) < 1.2 then
			nearbyObject, nearbyID = ShroomSpawns[i], i
		end
	end
    if withinShroomZone then 
        if Config.UseGloves == true then
        if QBCore.Functions.HasItem("gardengloves") then
            if isPickingShroom == false then 
                if nearbyObject and IsPedOnFoot(playerPed) then
                    isPickingShroom = true
                    PrepareAnimShroom()
                    PickShroomMiniGame()
                    ClearPedTasks(playerPed)
                    Wait(4000)
                    DeleteObject(nearbyObject) 
                    table.remove(ShroomSpawns, nearbyID)
                    isPickingShroom = false
                    spawnedShrooms = spawnedShrooms - 1
                else
                    if Config.NotifyType == 'qb' then
                        QBCore.Functions.Notify('This mushroom cannot be picked?', "error", 3500)
                    elseif Config.NotifyType == "okok" then
                        exports['okokNotify']:Alert("CAN'T PICK", "This mushroom cannot be picked?", 3500, "error")
                    end 
                end
            elseif isPickingShroom == true then 
                if Config.NotifyType == 'qb' then
                    QBCore.Functions.Notify('You are already doing something...', "error", 3500)
                elseif Config.NotifyType == "okok" then
                    exports['okokNotify']:Alert("CAN'T PICK", "You are already doing something...", 3500, "error")
                end
            end 
        else
            local requiredItems = {
                [1] = {name = QBCore.Shared.Items["gardengloves"]["name"], image = QBCore.Shared.Items["gardengloves"]["image"]},
            }  
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('These mushrooms look poisonous, better use gloves.', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("NEED GLOVES", "These mushrooms look poisonous, better use gloves.", 3500, "error")
            end   
            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            Wait(3000)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
        end
    else
        if not Config.UseGloves then
            if withinShroomZone then
                    if isPickingShroom == false then 
                        if nearbyObject and IsPedOnFoot(playerPed) then
                            isPickingShroom = true
                            PrepareAnimShroom()
                            PickShroomMiniGame()
                            ClearPedTasks(playerPed)
                            Wait(4000)
                            DeleteObject(nearbyObject) 
                            table.remove(ShroomSpawns, nearbyID)
                            isPickingShroom = false
                            spawnedShrooms = spawnedShrooms - 1
                        else
                            if Config.NotifyType == 'qb' then
                                QBCore.Functions.Notify('This mushroom cannot be picked?', "error", 3500)
                            elseif Config.NotifyType == "okok" then
                                exports['okokNotify']:Alert("CAN'T PICK", "This mushroom cannot be picked?", 3500, "error")
                            end 
                        end
                    elseif isPickingShroom == true then 
                        if Config.NotifyType == 'qb' then
                            QBCore.Functions.Notify('You are already doing something...', "error", 3500)
                        elseif Config.NotifyType == "okok" then
                            exports['okokNotify']:Alert("CAN'T PICK", "You are already doing something...", 3500, "error")
                        end
                    end 
                end
            end
        end
    else 
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('These cannot be harvested...', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("WRONG SHROOMS", "These cannot be harvested...", 3500, "error")
        end  
     end
end)
    

function PrepareAnimShroom()
    local ped = PlayerPedId()
    TaskStartScenarioInPlace(ped, "WORLD_HUMAN_GARDENER_PLANT", 0, true)
    PreparingAnimCheckShroom()
end

function PreparingAnimCheckShroom()
    shroompicking = true
    Citizen.CreateThread(function()
        while true do
            local ped = PlayerPedId()
            if shroompicking then
				Wait(1)
            else
                ClearPedTasksImmediately(ped)
                break
            end
            Citizen.Wait(200)
        end
    end)
end

function  PickShroomMiniGame()
if Config.skillcheck == true then
    if Config.SkillUse == 'ps-ui' then
    exports['ps-ui']:Circle(function(success)
        if success then
            TriggerServerEvent('mz-shrooms:server:addShroom')
            Wait(500)
            if Config.UseGloves then
            TriggerServerEvent('mz-shrooms:server:removeGlovesSuccess')
         else
            if Config.UseGloves then
            TriggerServerEvent('mz-shrooms:server:removeGlovesFail')
                end
            end
        end
    end, Config.ShroomskillCheck, Config.ShroomskillTime)
end
if Config.skillcheck == true then
    if Config.SkillUse == 'skillbar' then
        local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
        Skillbar.Start({
            duration = Config.SkillbarDuration, -- how long the skillbar runs for
            pos = Config.SkillbarPos, -- how far to the right the static box is
            width = Config.SkillbarWidth, -- how wide the static box is
        }, function()
            TriggerServerEvent('mz-shrooms:server:addShroom')
            Wait(500)
            if Config.UseGloves then
            TriggerServerEvent('mz-shrooms:server:removeGlovesSuccess')
            end
        end, function()
            if Config.UseGloves then
            TriggerServerEvent('mz-shrooms:server:removeGlovesFail')
            end
        end)
    end
    else 
        TriggerServerEvent('mz-shrooms:server:addShroom')
        Wait(500)
        if Config.UseGloves then
        TriggerServerEvent('mz-shrooms:server:removeGlovesSuccess')
            end
        end
    end
    end


    

----------------
--MAKES GLOVES--
----------------

CreateThread(function()
    exports['qb-target']:AddBoxZone("makegardengloves", vector3(716.25, -963.26, 30.4), 1.8, 1, {
        name = "makegardengloves",
        heading = 90,
        debugPoly = false,
        minZ = 27.0,
        maxZ = 31.0,
        }, {
            options = { 
            {
                type = "client",
                icon = 'fas fa-sun',
                event = "mz-shrooms:client:MakeGloves",
                label = 'Stitch gloves',
                canInteract = function() -- This will check if you can interact with it, this won't show up if it returns false, this is OPTIONAL
                    if Config.UseGloves == false then return false end -- This will return false if the entity interacted with is a player and otherwise returns true
                    return true
                  end,
            },
        },
        distance = 1.5,
     })
end)

RegisterNetEvent('mz-shrooms:client:MakeGloves', function()
    if QBCore.Functions.HasItem("fabric") then
        TriggerServerEvent("mz-shrooms:server:MakeGloves")
    else
        local requiredItems = {
            [1] = {name = QBCore.Shared.Items["fabric"]["name"], image = QBCore.Shared.Items["fabric"]["image"]}, 
        }  
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You need some fabric to make the gloves.', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("NEED FABRIC", "You need some fabric to make the gloves.", 3500, "error")
        end   
        TriggerEvent('inventory:client:requiredItems', requiredItems, true)
        Wait(3000)
        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    end
end)

RegisterNetEvent('mz-shrooms:client:MakeGlovesMinigame', function(source)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    if Config.skillcheck then 
        MakeGlovesMinigame(source)
    elseif not Config.skillcheck then
        MakeGlovesProcess() 
    else
        print("You have not properly configued 'Config.skillcheck', please check mz-shrooms/config.lua")
    end
end)

function MakeGlovesMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(Config.MakeGlovesLow, Config.MakeGlovesHigh)
    end
    local maxwidth = 30
    local maxduration = 3000
    Skillbar.Start({
        duration = math.random(1600, 2100),
        pos = math.random(15, 30),
        width = math.random(11, 15),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            MakeGlovesProcess()
            Wait(500)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You stitch up the gloves.', "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("STITCHING GLOVES", "You stitch up the gloves.", 3500, "success")
            end   
            Wait(500)
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(1600, 2100),
                pos = math.random(10, 30),
                width = math.random(11, 12),
            })
        end
    end, function()
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You slip and tear the gloves. This fabric is ruined...', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("FABRIC RUINED", "You slip and tear the gloves. This fabric is ruined...", 3500, "error")
        end
        Wait(500) 
        FailedAttemps = 0
        SucceededAttempts = 0
        NeededAttempts = 0
        craftprocesscheck = false
        ClearPedTasks(PlayerPedId())
    end)
end

function MakeGlovesProcess()
    local makeglovestime = math.random(Config.MakeGlovesBarLow, Config.MakeGlovesBarHigh)
    QBCore.Functions.Progressbar("grind_coke", "Stitching fabric together...", (makeglovestime * 1000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("mz-shrooms:server:GetGloves")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Process Cancelled', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("TASK STOPPED", "Process Cancelled", 3500, "error")
        end 
    end)
end


-----------------------
--MAKE SHROOM BAGGIES--
-----------------------

CreateThread(function()
    exports['qb-target']:AddBoxZone("makeshroombags", vector3(712.24, -970.79, 30.4), 1.6, 0.7, {
        name = "makeshroombags",
        heading = 0,
        debugPoly = false,
        minZ = 27.0,
        maxZ = 31.0,
        }, {
            options = { 
            {
                type = "client",
                event = "mz-shrooms:client:MakeShroomBags",
                icon = 'fas fa-sun',
                label = 'Make Empty Plastic Bag'
            },
        },
        distance = 1.5,
     })
end)

RegisterNetEvent('mz-shrooms:client:MakeShroomBags', function()
    if QBCore.Functions.HasItem("plastic") then
        TriggerServerEvent("mz-shrooms:server:MakeShroomBags")
    else
        local requiredItems = {
            [1] = {name = QBCore.Shared.Items["plastic"]["name"], image = QBCore.Shared.Items["plastic"]["image"]},
       }  
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You need 2 plastic to iron out a baggy', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("NEED PLASTIC", "You need 2 plastic to iron out a baggy", 3500, "error")
        end   
        TriggerEvent('inventory:client:requiredItems', requiredItems, true)
        Wait(3000)
        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    end
end)

RegisterNetEvent('mz-shrooms:client:MakeShroomBagsMinigame', function(source)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    if Config.skillcheck then
        MakeShroomBagsMinigame(source)
    elseif not Config.skillcheck then
        MakeShroomBagsProcess()
    else
        print("You have not configued 'Config.skillcheck', please check mz-shrooms/config.lua")
    end
end)

function MakeShroomBagsMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(Config.MakeShroomBagsLow, Config.MakeShroomBagsHigh)
    end
    local maxwidth = 30
    local maxduration = 3000
    Skillbar.Start({
        duration = math.random(1400, 1500),
        pos = math.random(15, 30),
        width = math.random(11, 15),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            MakeShroomBagsProcess()
            Wait(500)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You cut the plastic to size and seal it.', "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("MAKING BAG", "You cut the plastic to size and seal it.", 3500, "success")
            end   
            Wait(500)
            if Config.mzskills then 
                local BetterXP = math.random(Config.drugXPlow, Config.drugXPhigh)
                local multiplier = math.random(1, 4)
                if multiplier > 3 then
                    skillup = BetterXP
                else
                    skillup = Config.drugXPlow
                end
                exports["mz-skills"]:UpdateSkill("Drug Manufacture", skillup)
            end 
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(1200, 1500),
                pos = math.random(10, 30),
                width = math.random(11, 12),
            })
        end
    end, function()
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You slip and the plastic is ruined.', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("PLASTIC RUINED", "You slip and the plastic is ruined.", 3500, "error")
        end
        Wait(500)
        FailedAttemps = 0
        SucceededAttempts = 0
        NeededAttempts = 0
        craftprocesscheck = false
        ClearPedTasks(PlayerPedId())
    end)
end

function MakeShroomBagsProcess()
    local makebagtime = math.random(Config.MakeBagTimeLow, Config.MakeBagTimeHigh)
    QBCore.Functions.Progressbar("grind_coke", "Sealing bag...", (makebagtime * 1000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        TriggerServerEvent("mz-shrooms:server:GetShroomBaggy")
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Process Cancelled', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("TASK STOPPED", "Process Cancelled", 3500, "error")
        end 
    end)
end

---------------
--BAG SHROOMS--
---------------

CreateThread(function()
    exports['qb-target']:AddBoxZone("GetShroomBag", vector3(710.69, -969.48, 30.4), 2.2, 1, {
        name = "GetShroomBag",
        heading = 0,
        debugPoly = false,
        minZ = 27.0,
        maxZ = 31.0,
        }, {
            options = { 
            {
                type = "client",
                event = "mz-shrooms:client:BagShrooms",
                icon = 'fas fa-pills',
                label = 'Fill Shroom Bag'
            },
        },
        distance = 1.5,
     })
end)

RegisterNetEvent('mz-shrooms:client:BagShrooms', function()
    if QBCore.Functions.HasItem("shroom") then
        if QBCore.Functions.HasItem("shroombaggy") then
            TriggerServerEvent("mz-shrooms:server:BagShrooms")
        else
            local requiredItems = {
                [1] = {name = QBCore.Shared.Items["shroombaggy"]["name"], image = QBCore.Shared.Items["shroombaggy"]["image"]},
            }  
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify("You need "..Config.ShroomsNeeded.." shrooms and a bag.", "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("BAG IT UP", "You need "..Config.ShroomsNeeded.." shrooms and a bag.", 3500, "error")
            end   
            TriggerEvent('inventory:client:requiredItems', requiredItems, true)
            Wait(3000)
            TriggerEvent('inventory:client:requiredItems', requiredItems, false)
        end
    else
        local requiredItems = {
            [1] = {name = QBCore.Shared.Items["shroom"]["name"], image = QBCore.Shared.Items["shroom"]["image"]},
        }  
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify("You need "..Config.ShroomsNeeded.." shrooms and a bag.", "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("BAG IT UP", "You need "..Config.ShroomsNeeded.." shrooms and a bag.", 3500, "error")
        end   
        TriggerEvent('inventory:client:requiredItems', requiredItems, true)
        Wait(3000)
        TriggerEvent('inventory:client:requiredItems', requiredItems, false)
    end
end)

RegisterNetEvent('mz-shrooms:client:BagShroomsMinigame', function(source)
    TriggerEvent('animations:client:EmoteCommandStart', {"mechanic"})
    if Config.skillcheck then
        BagShroomsMinigame(source)
    elseif not Config.skillcheck then
        BagShroomsProcess()
    else
        print("You have not configued 'Config.skillcheck', please check mz-shrooms/config.lua")
    end
end)

function BagShroomsMinigame(source)
    local Skillbar = exports['qb-skillbar']:GetSkillbarObject()
    if NeededAttempts == 0 then
        NeededAttempts = math.random(Config.BagShroomsLow, Config.BagShroomsHigh)
    end
    local maxwidth = 30
    local maxduration = 3000
    Skillbar.Start({
        duration = math.random(1400, 1500),
        pos = math.random(15, 30),
        width = math.random(11, 15),
    }, function()
        if SucceededAttempts + 1 >= NeededAttempts then
            BagShroomsProcess()
            Wait(500)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('You weigh out the correct product and bag it up.', "success", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("BAGGING SHROOMS", "You weigh out the correct product and bag it up.", 3500, "success")
            end   
            Wait(500)
            if Config.mzskills then 
                local BetterXP = math.random(Config.drugXPlow, Config.drugXPhigh)
                local multiplier = math.random(1, 4)
                if multiplier > 3 then
                    skillup = BetterXP
                else
                    skillup = Config.drugXPlow
                end
                exports["mz-skills"]:UpdateSkill("Drug Manufacture", skillup)
            end 
            FailedAttemps = 0
            SucceededAttempts = 0
            NeededAttempts = 0
        else    
            SucceededAttempts = SucceededAttempts + 1
            Skillbar.Repeat({
                duration = math.random(1200, 1500),
                pos = math.random(10, 30),
                width = math.random(11, 12),
            })
        end
    end, function()
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('You tear the bag and drop the mushrooms...', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("PRODUCT RUINED!", "You tear the bag and drop the mushrooms...", 3500, "error")
        end
        Wait(500)
        if Config.mzskills then 
            local deteriorate = -Config.drugXPloss
            exports["mz-skills"]:UpdateSkill("Drug Manufacture", deteriorate)
            if Config.NotifyType == 'qb' then
                QBCore.Functions.Notify('-'..Config.drugXPloss..'XP to Drug Manufacture', "error", 3500)
            elseif Config.NotifyType == "okok" then
                exports['okokNotify']:Alert("SKILLS", '-'..Config.drugXPloss..'XP to Drug Manufacture', 3500, "error")
            end
        end
        FailedAttemps = 0
        SucceededAttempts = 0
        NeededAttempts = 0
        craftprocesscheck = false
        ClearPedTasks(PlayerPedId())
    end)
end

function BagShroomsProcess()
    local bagshroomstime = math.random(Config.BagShroomsTimeLow, Config.BagShroomsTimeHigh)
    QBCore.Functions.Progressbar("grind_coke", "Bagging up product...", (bagshroomstime * 1000), false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Done
        if Config.mzskills then 
            local lvl8 = false
            local lvl7 = false
            local lvl6 = false
            local lvl5 = false
            local lvl4 = false
            local lvl3 = false
            local lvl2 = false
            local lvl1 = false
            exports["mz-skills"]:CheckSkill("Drug Manufacture", 12800, function(hasskill)
                if hasskill then lvl8 = true end
            end)
            exports["mz-skills"]:CheckSkill("Drug Manufacture", 6400, function(hasskill)
                if hasskill then lvl7 = true end
            end)
            exports["mz-skills"]:CheckSkill("Drug Manufacture", 3200, function(hasskill)
                if hasskill then lvl6 = true end
            end)
            exports["mz-skills"]:CheckSkill("Drug Manufacture", 1600, function(hasskill)
                if hasskill then lvl5 = true end
            end)
            exports["mz-skills"]:CheckSkill("Drug Manufacture", 800, function(hasskill)
                if hasskill then lvl4 = true end
            end)
            exports["mz-skills"]:CheckSkill("Drug Manufacture", 400, function(hasskill)
                if hasskill then lvl3 = true end
            end)
            exports["mz-skills"]:CheckSkill("Drug Manufacture", 200, function(hasskill)
                if hasskill then lvl2 = true end
            end)
            exports["mz-skills"]:CheckSkill("Drug Manufacture", 100, function(hasskill)
                if hasskill then lvl1 = true end
            end)
            if lvl8 == true then
                TriggerServerEvent('mz-shrooms:server:receiveShroomslevel8')
            elseif lvl7 == true then 
                TriggerServerEvent('mz-shrooms:server:receiveShroomslevel7')
            elseif lvl6 == true then 
                TriggerServerEvent('mz-shrooms:server:receiveShroomslevel6')
            elseif lvl5 == true then 
                TriggerServerEvent('mz-shrooms:server:receiveShroomslevel5')
            elseif lvl4 == true then 
                TriggerServerEvent('mz-shrooms:server:receiveShroomslevel4')
            elseif lvl3 == true then 
                TriggerServerEvent('mz-shrooms:server:receiveShroomslevel3')
            elseif lvl2 == true then 
                TriggerServerEvent('mz-shrooms:server:receiveShroomslevel2')
            elseif lvl1 == true then 
                TriggerServerEvent('mz-shrooms:server:receiveShroomslevel1')
            else
                TriggerServerEvent('mz-shrooms:server:receiveShrooms')
            end
        elseif not Config.mzskills then 
            TriggerServerEvent('mz-shrooms:server:receiveShroomsNoXP')
        else 
            print("You have not configured 'Config.mzskills' properly, please refer to config.lua")
        end 
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        ClearPedTasks(PlayerPedId())
        craftcheck = false
    end, function() -- Cancel
        ClearPedTasks(PlayerPedId())
        if Config.NotifyType == 'qb' then
            QBCore.Functions.Notify('Process Cancelled', "error", 3500)
        elseif Config.NotifyType == "okok" then
            exports['okokNotify']:Alert("TASK STOPPED", "Process Cancelled", 3500, "error")
        end 
    end)
end

-------------------
--DRUG PROPERTIES--
-------------------

RegisterNetEvent('mz-shrooms:client:Shrooms', function()
    QBCore.Functions.Progressbar("use_ecstasy", "Eating shrooms...", 3000, false, true, {
        disableMovement = false,
        disableCarMovement = false,
		disableMouse = false,
		disableCombat = true,
    }, {
		animDict = "mp_suicide",
		anim = "pill",
		flags = 49,
    }, {}, {}, function() -- Done
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        ShroomEffect()
    end, function() -- Cancel
        StopAnimTask(PlayerPedId(), "mp_suicide", "pill", 1.0)
        QBCore.Functions.Notify("Failed", "error")
    end)
end)

function ShroomEffect()
    local startStamina = 15
    SetFlash(0, 0, 500, 7000, 500)
    while startStamina > 0 do
		local drugeffect = math.random(1, 100)
        Wait(1000)
        startStamina = startStamina - 1
        RestorePlayerStamina(PlayerId(), 1.0)
        if drugeffect < 61 then
            SetFlash(0, 0, 500, 7000, 500)
            ShakeGameplayCam('SMALL_EXPLOSION_SHAKE', 0.18)
		elseif drugeffect > 60 and drugeffect < 81 then 
			AlienEffect()
        end
    end
    if IsPedRunning(PlayerPedId()) then
        SetPedToRagdoll(PlayerPedId(), math.random(1000, 3000), math.random(1000, 3000), 3, 0, 0, 0)
    end
end

function AlienEffect()
    StartScreenEffect("DrugsMichaelAliensFightIn", 3.0, 0)
    Wait(math.random(5000, 8000))
    StartScreenEffect("DrugsMichaelAliensFight", 3.0, 0)
    Wait(math.random(5000, 8000))
    StartScreenEffect("DrugsMichaelAliensFightOut", 3.0, 0)
    StopScreenEffect("DrugsMichaelAliensFightIn")
    StopScreenEffect("DrugsMichaelAliensFight")
    StopScreenEffect("DrugsMichaelAliensFightOut")
end