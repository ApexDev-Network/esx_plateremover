-- Made by B1G (Carlos V.), edited by Inferno (Christopher M.)
local LastVehicle = nil
local LicencePlate = {}
LicencePlate.Index = false
LicencePlate.Number = false

-- Command to remove plate
RegisterCommand("quitarmatricula", function()
    -- Check if the player has plates stored
    if not LicencePlate.Index and not LicencePlate.Number then
        -- Client's ped
        local PlayerPed = PlayerPedId()
        -- Client's coords
        local Coords = GetEntityCoords(PlayerPed)
        -- Closest vehicle
        local Vehicle = GetClosestVehicle(Coords.x, Coords.y, Coords.z, 3.5, 0, 70)
        -- Client's coords
        local VehicleCoords = GetEntityCoords(Vehicle)
        -- Distance between client's ped and closest vehicle
        local Distance = Vdist(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, Coords.x, Coords.y, Coords.z)
        -- If within range and Ped is in a vehicle
        if Distance < 3.5 and not IsPedInAnyVehicle(PlayerPed, false) then
            --Saves the last vehicle
			LastVehicle = Vehicle
			-- Notification and animation
            Animation()
			SendNUIMessage({type = "ui",display = true,time = 6000,text = "Quitando matricula..."}) --PROGRESSBAR
			StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
            -- Wait 6 seconds
            Citizen.Wait(6000)
            -- Store plate index
            LicencePlate.Index = GetVehicleNumberPlateTextIndex(Vehicle)
            -- Store plate number
            LicencePlate.Number = GetVehicleNumberPlateText(Vehicle)
            -- Set the plate to nothing
            SetVehicleNumberPlateText(Vehicle, " ")
        else
            -- Notification
			-- exports["mythic_notify"]:SendAlert("error", "No vehicle nearby.") Mythic_Notification
			TriggerEvent('esx:showNotification', '~r~ No hay un vehiculo cerca.')
        end
    else
        -- Notification
		-- exports["mythic_notify"]:SendAlert("error", "You already have a licence plate on you.") Mythic_Notification
		TriggerEvent('esx:showNotification', '~r~ No tienes matrícula.')
    end
end)

-- Command to put plate back
RegisterCommand("ponermatricula", function()
    -- Check if the player has plates stored
    if LicencePlate.Index and LicencePlate.Number then
        -- Client's ped
        local PlayerPed = PlayerPedId()
        -- Client's coords
        local Coords = GetEntityCoords(PlayerPed)
        -- Closest vehicle
        local Vehicle = GetClosestVehicle(Coords.x, Coords.y, Coords.z, 3.5, 0, 70)
        -- Client's coords
        local VehicleCoords = GetEntityCoords(Vehicle)
        -- Distance between client's ped and closest vehicle
        local Distance = Vdist(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, Coords.x, Coords.y, Coords.z)
        -- If within range and Ped is in a vehicle
        if ( (Distance < 3.5) and not IsPedInAnyVehicle(PlayerPed, false) ) then
		if (Vehicle == LastVehicle) then
			--Cleans variable
				LastVehicle = nil
				-- Notification and animation
				Animation()
				SendNUIMessage({type = "ui",display = true,time = 6000,text = "Colocando matrícula..."}) --PROGRESSBAR
				StopAnimTask(PlayerPedId(), "mini@repair", "fixing_a_player", 1.0)
			-- Wait 6 seconds
			Citizen.Wait(6000)
			-- Set plate index to stored index
			SetVehicleNumberPlateTextIndex(Vehicle, LicencePlate.Index)
			-- Set plate number to stored number
			SetVehicleNumberPlateText(Vehicle, LicencePlate.Number)
			-- Reset stored values
			LicencePlate.Index = false
			LicencePlate.Number = false
		else
			-- Notification
			-- exports["mythic_notify"]:SendAlert("error", "This plate does not belong here")
			TriggerEvent('esx:showNotification', '~r~ Esta matricula no pertenece aquí')
		end
        else
            -- Notification
			-- exports["mythic_notify"]:SendAlert("error", "No vehicle nearby.") Mythic_Notification
			TriggerEvent('esx:showNotification', '~r~ No hay un vehiculo cerca.')
        end
    else
        -- Notification
		-- exports["mythic_notify"]:SendAlert("error", "You already have a licence plate on you.") Mythic_Notification
		TriggerEvent('esx:showNotification', '~r~ No tienes matrícula.')
    end
end)

--ANIMATION
function Animation()
    local pid = PlayerPedId()
    RequestAnimDict("mini")
    RequestAnimDict("mini@repair")
    while (not HasAnimDictLoaded("mini@repair")) do 
		Citizen.Wait(10) 
	end
    TaskPlayAnim(pid,"mini@repair","fixing_a_player",1.0,-1.0, 5000, 0, 1, true, true, true)
end
