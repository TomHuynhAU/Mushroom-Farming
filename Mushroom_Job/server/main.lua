
ESX = nil
local playersProcessingStones = {}

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('KaidoJob:PickedUp')
AddEventHandler('KaidoJob:PickedUp', function(item, amount)
	local xPlayer = ESX.GetPlayerFromId(source)	
	if xPlayer.canCarryItem(item, amount) then
		xPlayer.addInventoryItem(item, amount)
	end
end)


RegisterServerEvent('KaidoJob:SwapItem')
AddEventHandler('KaidoJob:SwapItem', function(item, mount, item2, mount2)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.canSwapItem(item, mount, item2, mount2)then
		xPlayer.removeInventoryItem(item, mount)
		xPlayer.addInventoryItem(item2, mount2)
	end
end)

RegisterServerEvent('KaidoJob:Sellpack')
AddEventHandler('KaidoJob:Sellpack', function(item, amount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)
	if xItem.count > amount then
		xPlayer.removeInventoryItem(item, amount)
		xPlayer.addMoney(Config.Price[item] * amount)
	end
end)


ESX.RegisterServerCallback('KaidoJob:CheackingPack', function(source, cb, item, mount, item2, mount2)
	local xPlayer = ESX.GetPlayerFromId(source)
	if xPlayer.canSwapItem(item, mount, item2, mount2)then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('KaidoJob:CheckSell', function(source, cb, item, mount)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)
 
	if xItem.count >= mount then
		cb(true)
	else
		cb(false)
	end
end)

ESX.RegisterServerCallback('KaidoJob:canPickUp', function(source, cb, item, count)
	local xPlayer = ESX.GetPlayerFromId(source)
	local xItem = xPlayer.getInventoryItem(item)

	if xPlayer.canCarryItem(item, count) then
		cb(true)
	else
		cb(false)
	end
end)



function CancelProcessing(playerID)
	if playersProcessingStones[playerID] then
		ESX.ClearTimeout(playersProcessingStones[playerID])
		playersProcessingStones[playerID] = nil
	end
end

RegisterServerEvent('KaidoJob:cancelProcessing')
AddEventHandler('KaidoJob:cancelProcessing', function()
	CancelProcessing(source)
end)

AddEventHandler('esx:playerDropped', function(playerID, reason)
	CancelProcessing(playerID)
end)

RegisterServerEvent('esx:onPlayerDeath')
AddEventHandler('esx:onPlayerDeath', function(data)
	CancelProcessing(source)
end)

