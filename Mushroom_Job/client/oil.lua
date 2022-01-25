local spawnedOils = 0
local oilss = {}
local isPickingUp, isProcessing, coords, distance1, distance2, distance3, distance4 = false, false, 0, 0, 0, 0, 0
local playerPed = {}
Citizen.CreateThread(function()
	while true do
		Citizen.Wait(500)
		playerPed = PlayerPedId()

		 coords = GetEntityCoords(PlayerPedId())
		 distance1 = GetDistanceBetweenCoords(coords, Config.CircleZones.OilField.coords, true)
		 distance2 = GetDistanceBetweenCoords(coords, Config.CircleZones.OilProgress1.coords, true)
		 distance3 = GetDistanceBetweenCoords(coords, Config.CircleZones.OilProgress2.coords, true)
		 distance4 = GetDistanceBetweenCoords(coords, Config.CircleZones.SellOil.coords, true)

	end
end)

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1000)

		if distance1 < 30 then
			SpawnOills()

		end
	end
end)



Citizen.CreateThread(function()
	while true do
		Citizen.Wait(1)
		local nearbyObject, nearbyID
		if distance1 < 50 then
			for i=1, #oilss, 1 do
				local cooordsobj = GetEntityCoords(oilss[i])
				if GetDistanceBetweenCoords(coords, cooordsobj, false) < 1 then
					
					nearbyObject, nearbyID = oilss[i], i
				end
				if GetDistanceBetweenCoords(coords, cooordsobj, false) < 30 then
					DrawMarker(0, cooordsobj.x, cooordsobj.y, cooordsobj.z +1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5,0.5, 0, 255, 0, 150, true, false, 2, false, false, false, false)
				end
			end
			if nearbyObject  then
				if not isPickingUp then
					ESX.ShowHelpNotification('Nhấn ~g~[E]~s~ để ~y~khoan dầu')
				end
				if IsControlJustReleased(0, Keys['E']) and not isPickingUp then
					isPickingUp = true
					ESX.TriggerServerCallback('KaidoJob:canPickUp', function(canPickUp)
						if canPickUp then					
							TriggerEvent("mythic_progbar:client:progress", {
							
								name = "unique_action_name",
								duration = 10000,
								label = "Khoan dầu....",
								useWhileDead = false,
								canCancel = true,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
									},
									animation = {
										task = "world_human_const_drill"
									},
								}, function(status)
									if not status then
										isPickingUp = false

										ESX.Game.DeleteObject(nearbyObject)
										table.remove(oilss, nearbyID)
										spawnedOils = spawnedOils - 1
						
										TriggerServerEvent('KaidoJob:PickedUp', 'petrol' , 5)
										local drill = GetClosestObjectOfType(coords, 30.0, GetHashKey("prop_tool_jackham"), false, false, false)
										SetEntityAsMissionEntity(drill, true, true)
										DeleteEntity(drill)						
									end
							end)
						else
							ESX.ShowNotification("Kho đồ của bạn đã đầy")
						end
					end, 'petrol',1)
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

		if distance2 < 10 then
			DrawMarker(27, Config.CircleZones.OilProgress1.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 150, true, true, 2, true, false, false, false)
			if distance2 < 2 then
				if not isProcessing then
					ESX.ShowHelpNotification('Nhấn ~g~[E]~s~ để ~y~lọc dầu thô')
				end
				if IsControlJustReleased(1,  38) then

					ESX.TriggerServerCallback('KaidoJob:CheackingPack', function(ok)
						if ok then 
							isProcessing = true     
							TriggerEvent("mythic_progbar:client:progress", {
								name = "Progress-Mushroom",
								duration = 10000,
								label = "Đóng lọc dầu thô",
								useWhileDead = false,
								canCancel = true,
								controlDisables = {
									disableMovement = false,
									disableCarMovement = false,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									animDict = "missheistdockssetup1clipboard@idle_a",
									anim = "idle_a",
								},
							
								
							}, function(status)

								if not status then
									TriggerServerEvent('KaidoJob:SwapItem', 'petrol', 5, 'petrol_raffin', 1)
								end
							end)     	
							isProcessing = false
						else
							ESX.ShowNotification(_U('NoItem'))
						end            
					end, 'petrol', 5, 'petrol_raffin', 1)
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

		if distance3 < 10 then
			DrawMarker(27, Config.CircleZones.OilProgress2.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 150, true, true, 2, true, false, false, false)
			if distance3 < 2 then
				if not isProcessing then
					ESX.ShowHelpNotification('Nhấn ~g~[E]~s~ để ~y~Chiết xuất xăng')
				end
				if IsControlJustReleased(1,  38) then

					ESX.TriggerServerCallback('KaidoJob:CheackingPack', function(ok)
						if ok then      
							isProcessing = true
							TriggerEvent("mythic_progbar:client:progress", {
								name = "Progress-Mushroom",
								duration = 10000,
								label = "Chiết xuất xăng",
								useWhileDead = false,
								canCancel = true,
								controlDisables = {
									disableMovement = false,
									disableCarMovement = false,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									animDict = "missheistdockssetup1clipboard@idle_a",
									anim = "idle_a",
								},
							
								
							}, function(status)
								isProcessing = false

								if not status then
									TriggerServerEvent('KaidoJob:SwapItem', 'petrol_raffin', 1, 'essence', 5)

								end
							end)     	

						else
							ESX.ShowNotification(_U('NoItem'))
						end            
					end, 'petrol_raffin', 1, 'essence', 5)
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
		if distance4 < 20 then
			local playerPed = PlayerPedId()
			if not isProcessing then

				DrawMarker(27, Config.CircleZones.SellOil.coords, 0.0, 0.0, 0.0, 0, 0.0, 0.0, 1.5, 1.5, 1.5, 255, 255, 255, 100, true, true, 2, true, false, false, false)
			end
			if distance4 < 2 then
				if not isProcessing then
				ESX.ShowHelpNotification('Nhấn ~g~[E]~s~ để bán xăng')
				end
				if IsControlJustReleased(1, 38) then
					ESX.TriggerServerCallback('KaidoJob:CheckSell', function(ok)
						if ok then    
							isProcessing = true
							TriggerEvent("mythic_progbar:client:progress", {
								name = "Progress-Mushroom",
								duration = 10000,
								label = "Bán xăng",
								useWhileDead = false,
								canCancel = true,
								controlDisables = {
									disableMovement = true,
									disableCarMovement = true,
									disableMouse = false,
									disableCombat = true,
								},
								animation = {
									task = 'WORLD_HUMAN_CLIPBOARD'
								},
								
							}, function(status)
								isProcessing = false
								if not status then
									TriggerServerEvent('KaidoJob:Sellpack', 'essence', 10)
									local drill = GetClosestObjectOfType(coords, 30.0, GetHashKey("p_cs_clipboard"), false, false, false)
									SetEntityAsMissionEntity(drill, true, true)
									DeleteEntity(drill)	
								end
							end)     	
							
						else
							ESX.ShowNotification(_U('NoItem'))
						end            
					end, 'essence', 10)
				end		
			end
		else
			Wait(1000)
		end
	end
end)

AddEventHandler('onResourceStop', function(resource)
	if resource == GetCurrentResourceName() then
		for k, v in pairs(oilss) do
			ESX.Game.DeleteObject(v)
		end
	end
end)

function SpawnOills()
	while spawnedOils < 15 do
		Citizen.Wait(0)
		local oilCoords = GenerateOilCoords()

		ESX.Game.SpawnLocalObject('prop_mp_icon_shad_sm', oilCoords, function(obj)
			PlaceObjectOnGroundProperly(obj)
			FreezeEntityPosition(obj, true)

			table.insert(oilss, obj)
			spawnedOils = spawnedOils + 1
		end)
	end
end

function ValidateOilCoord(plantCoord)
	if spawnedOils > 0 then
		local validate = true

		for k, v in pairs(oilss) do
			if GetDistanceBetweenCoords(plantCoord, GetEntityCoords(v), true) < 20 then
				validate = false
			end
		end

		if GetDistanceBetweenCoords(plantCoord, Config.CircleZones.OilField.coords, false) > 30 then
			validate = false
		end

		return validate
	else
		return true
	end
end

function GenerateOilCoords()
	while true do
		Citizen.Wait(1)

		local oilCoordX, oilCoordY

		math.randomseed(GetGameTimer())
		local modX = math.random(-70, 70)

		Citizen.Wait(100)

		math.randomseed(GetGameTimer())
		local modY = math.random(-70, 70)

		oilCoordX = Config.CircleZones.OilField.coords.x + modX
		oilCoordY = Config.CircleZones.OilField.coords.y + modY

		local coordZ = GetCoordZ(oilCoordX, oilCoordY)
		local coord = vector3(oilCoordX, oilCoordY, coordZ)

		if ValidateOilCoord(coord) then
			return coord
		end
	end
end

function GetCoordZ(x, y)
	local groundCheckHeights = { 40.0, 41.0, 42.0, 43.0, 44.0, 45.0, 46.0, 47.0, 48.0, 49.0, 50.0 }

	for i, height in ipairs(groundCheckHeights) do
		local foundGround, z = GetGroundZFor_3dCoord(x, y, height - 7)

		if foundGround then
			return z
		end
	end

	return 43.0
end