local showPro                 = false       -- don't touch
local spawnedshellfish = 0
local Minewood = {}
local isPickingUp, isProcessing = false, false

local playerPed, coords,distancex1,distancex2, distancex3 = {} , 0, 0, 0, 0

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		playerPed = PlayerPedId()
		coords = GetEntityCoords(playerPed)
		distancex1 = GetDistanceBetweenCoords(coords, Config.CircleZones.woodCut.coords, true)
		distancex2 = GetDistanceBetweenCoords(coords, Config.CircleZones.woodSell.coords, true)
		distancex3 = GetDistanceBetweenCoords(coords, Config.CircleZones.woodField.coords, true)
	end
end)
Citizen.CreateThread(function()
	Citizen.Wait(1000)
	while true do
		Citizen.Wait(1000)
		if distancex3 < 50 then
			Spawnwoods()
		end
	end
end)


Citizen.CreateThread(function()
	Citizen.Wait(1000)
	while true do
		Citizen.Wait(1)
		local nearbyObject, nearbyID
		if distancex3 < 50 then

			for i=1, #Minewood, 1 do
				local coordsobject = GetEntityCoords(Minewood[i])
				if GetDistanceBetweenCoords(coords, coordsobject, false) < 1 then
					nearbyObject, nearbyID = Minewood[i], i
				end
				if GetDistanceBetweenCoords(coords, coordsobject, false) < 20 then
					DrawMarker(0, coordsobject.x, coordsobject.y, coordsobject.z + 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.2, 0.2, 0.2, 0, 255, 0, 150, false, false, 2, false, false, false, false)
				end

			end

			if nearbyObject and IsPedOnFoot(playerPed) then

				if not isPickingUp then
					ESX.ShowHelpNotification("Nhấn [E] để thu hoạch")
				end

				if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
					isPickingUp = true

					ESX.TriggerServerCallback('KaidoJob:canPickUp', function(canPickUp)

						if canPickUp then

							TriggerEvent("mythic_progbar:client:progress", {
								name = "unique_action_name",
								duration = 5000,
								label = "Hái nấm",
								useWhileDead = false,
								canCancel = true,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									task = "WORLD_HUMAN_GARDENER_PLANT"
								},
								
							}, function(status)
								if not status then
									ESX.Game.DeleteObject(nearbyObject)
									table.remove(Minewood, nearbyID)
									spawnedshellfish = spawnedshellfish - 1
									TriggerServerEvent('KaidoJob:PickedUp', 'mushroomun' , 3)
									SetNewWaypoint(Config.CircleZones.woodCut.coords)
								end
							end)						
			

						else
							ESX.ShowNotification(_U('mushroom_inventoryfull'))
						end

						isPickingUp = false

					end, 'mushroomun', 3)
				end

		
			end
		else
			Wait(1000)
		end
	end

end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)

		if(Config.Type ~= -1 and distancex1 < 10) then
			DrawMarker(27, Config.CircleZones.woodCut.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 150, true, true, 2, true, false, false, false)
			if distancex1 < 2 then
				ESX.ShowHelpNotification('Nhấn [E] để đóng gói')

				if IsControlJustReleased(1,  38) then
					ESX.TriggerServerCallback('KaidoJob:CheackingPack', function(ok)
						if ok then      
							TriggerEvent("mythic_progbar:client:progress", {
								name = "Progress-Mushroom",
								duration = 10000,
								label = "Đóng gói nấm",
								useWhileDead = false,
								canCancel = true,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									animDict = "missheistdockssetup1clipboard@idle_a",
									anim = "idle_a",
								},
								prop = {
									model = "prop_paper_bag_small",
								}
							}, function(status)
								if not status then
									TriggerServerEvent('KaidoJob:SwapItem', 'mushroomun', 3, 'omushroom', 3)
									SetNewWaypoint(Config.CircleZones.woodSell.coords)
								end
							end)     	
						else
							ESX.ShowNotification(_U('NoItem'))
						end            
					end, 'mushroomun', 3, 'omushroom', 3)
				end				
			end
		else
			Wait(1000)
		end
	end
end)
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		------------------------------------------------------------------------------------------
		if(Config.Type ~= -1 and distancex2 < 10) then
			DrawMarker(27, Config.CircleZones.woodSell.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, true, true, 2, true, false, false, false)
			if distancex2 < 2 then
				ESX.ShowHelpNotification(_U('EnterSell'))
				if IsControlJustReleased(1,  38)   then
					ESX.TriggerServerCallback('KaidoJob:CheackingPack', function(ok)
						if ok then      
							TriggerEvent("mythic_progbar:client:progress", {
								name = "Progress-Mushroom",
								duration = 10000,
								label = "Bán nấm",
								useWhileDead = false,
								canCancel = true,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									animDict = "missheistdockssetup1clipboard@idle_a",
									anim = "idle_a",
								},
								prop = {
									model = "prop_paper_bag_small",
								}
							}, function(status)
								if not status then
									TriggerServerEvent('KaidoJob:Sellpack', 'omushroom', 3)
								end
							end)     	
							
						else
							ESX.ShowNotification(_U('NoItem'))
						end            
					end, 'omushroom', 3)
				end		
			end
		else
			Wait(1000)
		end
	end
end)



AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(Minewood) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function Spawnwoods()
	while spawnedshellfish < 70 do
		Citizen.Wait(1)
		local woodCoords = GeneratewoodCoords()

		ESX.Game.SpawnLocalObject('prop_stoneshroom1', woodCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(Minewood, obj)
			spawnedshellfish = spawnedshellfish + 1
		end)
	end
end

function ValidatewoodCoord(plantCoord)
	if spawnedshellfish > 0 then
		local validate = true

		for k, v in pairs(Minewood) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 5 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.woodField.coords, false) > 50 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GeneratewoodCoords()
	while true do
		Citizen.Wait(1)

		local woodCoordX, woodCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-30, 30)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-60, 60)

		woodCoordX = Config.CircleZones.woodField.coords.x + modX
		woodCoordY= Config.CircleZones.woodField.coords.y + modY

		local coordZ = GetCoordZ(woodCoordX, woodCoordY)
		local coord = vector3(woodCoordX, woodCoordY, coordZ)

		if ValidatewoodCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height)

		if foundGround then
			return z
		end
	end

	return 43.0
end




