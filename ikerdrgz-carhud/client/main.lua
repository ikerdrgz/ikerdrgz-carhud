local showing_hud = false
local seatbelt_enabled = false
local speedMultiplier = 3.6 -- 2.236936 // MPH |||||| 3.6 // KMH
local no_authorized_seatbelt = { 8, 16, 15, 13 }
local no_authorized_ui = { 13 }

-------------------------
------ Main Thread ------
-------------------------

CreateThread(function()
    while true do 
        local ms = 1500
        local ped = PlayerPedId()

        if IsPedInAnyVehicle(ped) then
            showing_hud = true
        else
            showing_hud = false
            if seatbelt_enabled then seatbelt_enabled = false; end
        end

        if IsPauseMenuActive() or IsScreenFadedOut() then
            showing_hud = false
        end

        for k,v in pairs(no_authorized_ui) do
            if GetVehicleClass(GetVehiclePedIsUsing(ped)) == v then
                showing_hud = false
            end
        end

        if showing_hud then ms = 100;
            local vehicle = GetVehiclePedIsUsing(ped)
            local vehicleClass = GetVehicleClass(vehicle)
            local fuel = GetVehicleFuelLevel(vehicle)
            local speed = math.floor(GetEntitySpeed(vehicle) * speedMultiplier)

            if not permitted_seatbelt(vehicleClass) then
                seatbelt_enabled = true
            end

            SendNUIMessage({
                show = true, 
                speed = speed,
                fuel = fuel,
                seatbelt = fuel < 25 and true or seatbelt_enabled
            })
        else
            SendNUIMessage({ show = false })
            showing_hud = false
        end

        Wait(ms)
    end
end)

---------------------
----- Functions -----
---------------------

function permitted_seatbelt(vehicle_class)
    for _, value in pairs(no_authorized_seatbelt) do
        if vehicle_class == value then
            return false
        end
    end

    return true
end

---------------------
------ Commands -----
---------------------

RegisterCommand('+toggleSeatbelt', function()
    if not IsPedInAnyVehicle(PlayerPedId()) then return end

    local playerPed = PlayerPedId()
    local vehicle = GetVehiclePedIsUsing(playerPed)
    local vehicleClass = GetVehicleClass(vehicle)

    if permitted_seatbelt(vehicleClass) and not is_busy then
        seatbelt_enabled = not seatbelt_enabled

        if seatbelt_enabled then
            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'seatbelt-buckle', 0.4)
        else
            TriggerServerEvent('InteractSound_SV:PlayOnSource', 'seatbelt-unbuckle', 0.4)
        end
    end
end)

RegisterKeyMapping('+toggleSeatbelt', 'Toggle Seatbelt', 'keyboard', 'X')
