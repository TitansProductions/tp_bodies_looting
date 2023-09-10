local objectData = {}

AddEventHandler('onResourceStop', function(resourceName)
	if (GetCurrentResourceName() ~= resourceName) then
	  return
	end

	for k, v in pairs(objectData) do
		if v then
			DeleteEntity(v.entity)
			objectData[k] = nil
		end
		
    end

end)

RegisterServerEvent("tp-bodies_looting:onNewDeathLootObjectSpawn")
AddEventHandler("tp-bodies_looting:onNewDeathLootObjectSpawn", function(entityCoords, object)

	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer  then

		local newCoords = vector3(entityCoords.x, entityCoords.y, entityCoords.z - 0.05)

		local object = CreateObjectNoOffset(GetHashKey("prop_cs_heist_bag_02"), newCoords.x, newCoords.y, newCoords.z, true, false)
		FreezeEntityPosition(object, true)

		local data = {entity = object, inventory = xPlayer.inventory, money = xPlayer.getMoney(), black_money = xPlayer.getAccount('black_money').money, weapons = xPlayer.loadout}
	

		TriggerClientEvent('tp-bodies_looting:onNewDeathLootObjectInfo', -1, object, newCoords, data)

		objectData[round(entityCoords.x, 1) .. round(entityCoords.y, 1)] = data

		TriggerClientEvent("tp-bodies_looting:onSpawnBagInventoryClear", source)

		-- Removing Bag after spawned from config.
		Citizen.Wait(1000 * Config.RemovingBagAfterSpawnedInSeconds)

		local fixedEntityCoords = round(entityCoords.x, 1) .. round(entityCoords.y, 1)

		DeleteEntity(object)
		objectData[fixedEntityCoords] = nil
		 
		TriggerClientEvent("tp-bodies_looting:onDeathLootObjectRemoval", -1, fixedEntityCoords)

	end 
end)


RegisterServerEvent("tp-bodies_looting:onDeathLootObjectRemoval")
AddEventHandler("tp-bodies_looting:onDeathLootObjectRemoval", function(entityCoords, entity)
	
	DeleteEntity(entity)
	objectData[entityCoords] = nil

end)

RegisterServerEvent("tp-bodies_looting:tradePlayerItem")
AddEventHandler("tp-bodies_looting:tradePlayerItem", function(coords, type, itemName, itemCount, clickedItemCount)
		local _source = source

		local targetXPlayer = ESX.GetPlayerFromId(_source)

		if type == "item_standard" then

			local targetItem = targetXPlayer.getInventoryItem(itemName)

			if itemCount > 0 and clickedItemCount >= itemCount then

				targetXPlayer.addInventoryItem(itemName, itemCount)

                local inventory = objectData[coords].inventory

                for key, value in pairs(inventory) do
                    if value.name == itemName then
                        value.count = value.count - itemCount
                    end
                end

			else
                TriggerClientEvent('esx:showNotification', _source, "~r~You cannot get more than the available amount.")
			end

		elseif type == "item_money" then
			if itemCount > 0 and clickedItemCount >= itemCount then

				targetXPlayer.addMoney(itemCount)

                objectData[coords].money = objectData[coords].money - itemCount
            else
                TriggerClientEvent('esx:showNotification', _source, "~r~You cannot get more than the available amount.")

            end
		elseif type == "item_black_money" then
			if itemCount > 0 and clickedItemCount >= itemCount then

				targetXPlayer.addAccountMoney("black_money", itemCount)

                objectData[coords].black_money = objectData[coords].black_money - itemCount
            else
                TriggerClientEvent('esx:showNotification', _source, "~r~You cannot get more than the available amount.")
            end
		elseif type == "item_weapon" then
			if not targetXPlayer.hasWeapon(itemName) then

				targetXPlayer.addWeapon(itemName, itemCount)

                local inventory = objectData[coords].weapons

                for key, value in pairs(inventory) do
                    if value.name == itemName then
                        value.label = "NOT_AVAILABLE"
                    end
                end
			else
                TriggerClientEvent('esx:showNotification', _source, "~r~You already carrying this weapon.")
            end
		end
	end
)

ESX.RegisterServerCallback("tp-bodies_looting:getOtherInventory", function(source, cb, coords)

	if objectData[coords] and objectData[coords].entity ~= nil then
		cb(objectData[coords])
	else

		local data = {entity = 0, inventory = nil, money = 0, black_money = 0, weapons = nil}
		cb(data)
	end

end)

ESX.RegisterServerCallback("tp-bodies_looting:fetchObjectsData", function(source, cb, coords)
	cb(objectData)
end)



function round(number, decimals)
    local power = 10^decimals
    return math.floor(number * power) / power
end
