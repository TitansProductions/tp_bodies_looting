Keys = {
	["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
	["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
	["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
	["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
	["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
	["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
	["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
	["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
	["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

local deathBoxes          = {-711724000} 
local isPlayerDead        = false
local objectInventoryData = {}

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(playerData, isNew) 
	ESX.PlayerLoaded = true
	ESX.PlayerData = playerData

    Wait(2000)
    ESX.TriggerServerCallback('tp-bodies_looting:fetchObjectsData', function(data)
        objectInventoryData = data
    end)

end)

AddEventHandler('playerSpawned', function()
    isPlayerDead = false
end)

AddEventHandler('disc-death:onPlayerRevive', function(data)
    isPlayerDead = false
end)


AddEventHandler('esx:onPlayerDeath', function(data)
    isPlayerDead = true

    local playerPed  = GetPlayerPed(-1)
    local weaponList = ESX.GetWeaponList()

    Wait(1000 * Config.SpawnPlayerBagWhenDead)
    
    local coords      = GetEntityCoords(PlayerPedId())
    local randomLootObject = deathBoxes[math.random(#deathBoxes)]

    if isPlayerDead then
        TriggerServerEvent("tp-bodies_looting:onNewDeathLootObjectSpawn", coords, randomLootObject)
    end

end)

RegisterNetEvent("tp-bodies_looting:onSpawnBagInventoryClear")
AddEventHandler("tp-bodies_looting:onSpawnBagInventoryClear", function()
    RemoveItemsAfterDeath()
end)


function RemoveItemsAfterDeath()

    ESX.TriggerServerCallback('tp-bodies_looting:removeItemsAfterRPDeath', function()
        ESX.SetPlayerData('loadout', {})
    end)

end


RegisterNetEvent("tp-bodies_looting:onNewDeathLootObjectInfo")
AddEventHandler("tp-bodies_looting:onNewDeathLootObjectInfo", function(object, entityCoords, data)

    local newCoords = round(entityCoords.x, 1) .. round(entityCoords.y, 1)
    
    objectInventoryData[newCoords] = data
end)


RegisterNetEvent("tp-bodies_looting:onDeathLootObjectRemoval")
AddEventHandler("tp-bodies_looting:onDeathLootObjectRemoval", function(entityCoords)

    closeBagUIOnRemoval(entityCoords)

    objectInventoryData[entityCoords] = nil

end)



Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        local pedCoords = GetEntityCoords(PlayerPedId())
        local objectId = GetClosestObjectOfType(pedCoords, 1.5, GetHashKey("prop_cs_heist_bag_02"), false)
		local entityCoords = GetEntityCoords(objectId)
        local newCoords = round(entityCoords.x, 1) .. round(entityCoords.y, 1)
		local sleep = true

        if not isPlayerDead then
            if DoesEntityExist(objectId) then
            
                sleep = false
    

                DrawText3Ds(entityCoords.x,entityCoords.y,entityCoords.z + 0.5, _U("search_bag"))

    
                if IsControlJustReleased(0, 38)  then
    
                    RequestAnimDict('random@domestic')
                    while not HasAnimDictLoaded('random@domestic') do
                        Wait(100)
                        RequestAnimDict('random@domestic')
                    end
    
                    TaskPlayAnim(PlayerPedId(), "random@domestic", "pickup_low", 8.0, -8, 1500, 2, 0, 0, 0, 0)
    
                    Wait(1500)
    
                    if objectInventoryData[newCoords] then

                        ESX.TriggerServerCallback("tp-bodies_looting:getOtherInventory",function(data)
                            TriggerEvent('tp-bodies_looting:openBasedUI', data, newCoords)
                        end, newCoords)
                    end
                end
            end
        end

		if sleep then
			Citizen.Wait(1500)
		end
    end
end)


function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end

function DrawText3Ds(x,y,z, text)
    local onScreen,_x,_y=World3dToScreen2d(x,y,z)
    local px,py,pz=table.unpack(GetGameplayCamCoords())
    
    SetTextScale(0.35, 0.35)
    SetTextFont(4)
    SetTextProportional(1)
    SetTextColour(255, 255, 255, 215)
    SetTextEntry("STRING")
    SetTextCentre(1)
    AddTextComponentString(text)
    DrawText(_x,_y)
    local factor = (string.len(text)) / 370
    DrawRect(_x,_y+0.0125, 0.005+ factor, 0.03, 0, 0, 0, 100)
end
