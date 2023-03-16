ESX = nil
blips = {}
local Started = false
local WaitingEnter = false
local OnSpotWork = false
local Route = false
local seat = 0
local quantity = math.random(1,5)
local NewPassagers = {}
local OnBusPassagers = {}
local countPassagers = 0
local bus = nil


Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj)
            ESX = obj
        end)
        Citizen.Wait(10)
    end
end)

Citizen.CreateThread(function()
    while true do
        local Wait = 1000
        local PlayerCoords = GetEntityCoords(PlayerPedId(), false)
        local Distance = #(vector3(PlayerCoords) - vector3(459.4, -602.02, 28.5))
        if Distance < 2 and not Started then
            Wait = 1
            DrawMarker(2, 459.4, -602.02, 28.5, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.2, 1, 21, 25, 255,true, true, false, 2, nil, nil, false)
            if IsControlJustPressed(0, 38) then -- E 
                ShowUi(true, "main")
            end
        end
        Citizen.Wait(Wait)
    end
end)



-- Functions -->

function ShowUi(bool, name)
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = name,
        status = bool
    })

end

-- Functions <--
-- callbacks -->

RegisterNUICallback("callbacks", function(data)
    if data.action == "close" then
        ShowUi(false, "main")
    elseif data.action == "start" then
        Started = true
        ShowUi(false, "main")
        TriggerEvent('RevelFixLight:StartJob', source)
        Wait(100)
        TriggerEvent('RevelFixLight:SpawnContainers')
    end
end)



RegisterNetEvent('RevelFixLight:StartJob')
AddEventHandler('RevelFixLight:StartJob', function()
    local car = "bus"


    RequestModel(car)
    while not HasModelLoaded(car) do
        Citizen.Wait(10)
    end

    local veh = CreateVehicle(car, 469.52, -607.25, 28.5,174.69, true, false)
    SetModelAsNoLongerNeeded(car)
    SetVehicleNumberPlateText(veh, "REVEL")
    bus = veh

    WaitingEnting = true

    Citizen.CreateThread(function()
        while WaitingEnting and not OnSpotWork do
            Citizen.Wait(1)
            DrawMarker(2, GetEntityCoords(veh).x, GetEntityCoords(veh).y, GetEntityCoords(veh).z + 3, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 1.0, 1.0, 0.5, 1, 21, 25, 255,
                true, true, false, 2, nil, nil, false)
            if IsPedInAnyVehicle(PlayerPedId(), false) then
                WaitingEnting = false
                if IsPedSittingInVehicle(PlayerPedId(), veh) then
                   IsOnCar = true
                   local count = 0

                   goStation(1, veh)
                   
                    while IsOnCar do
                        Citizen.Wait(1)
                        DisableControlAction(0,75,true) 
                        DisableControlAction(27,75,true) 
                    end
                else
                    WaitingEnting = true
                end
            end
        end

    end)
end)

function create_peds(station, peds)
    local stations = {}

    for i=1, #peds, 1 do
        RequestModel(GetHashKey(peds[i].coords.model))
        while (not HasModelLoaded(GetHashKey(peds[i].coords.model))) do
            Citizen.Wait(1)
        end

        local created_passanger = CreatePed(4, 
            peds[i].coords.model, 
            peds[i].coords.x, 
            peds[i].coords.y, 
            peds[i].coords.z, 
            0.0, 
            false, 
            false
        );

        Wait(500)
        SetEntityHeading(created_passanger, peds[i].coords.heading)
        FreezeEntityPosition(created_passanger, true)
        SetBlockingOfNonTemporaryEvents(created_passanger, true)
        SetEntityInvincible(created_passanger, true)
        table.insert(NewPassagers, created_passanger)
    end
end

function addRoute(k ,coords)
    Route = true
    blips[k] = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blips[k], 1)
    SetBlipRoute(blips[k], true)

    print('added blip ', k)
    Route = false
end

function goStation(station, veh)
    local count_station = 0
    GoingLocal = true

    for k, v in pairs(Config.Stations) do
        count_station = count_station + 1
        if k == station and GoingLocal then
            addRoute(k, v.get_npc)
            Wait(1000)
            create_peds(k, v.Peds)
            Citizen.CreateThread(function()
                while GoingLocal do
                    Citizen.Wait(1)
                    DrawMarker(2, v.get_npc.x, v.get_npc.y, v.get_npc.z, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.2,
                        1, 21, 25, 255, true, true, false, 2, nil, nil, false)
                    if #(vector3(GetEntityCoords(PlayerPedId())) - vector3(v.get_npc.x, v.get_npc.y, v.get_npc.z)) < 3 then
                        local next_station = math.ceil(k + 1)

                        print('Count total: ' .. count_station, 'next station: ' .. next_station)

                        if next_station > count_station then
                            GoingLocal = false
                            print('dont exist')
                            break
                        else
                                

                            for i = 1, #NewPassagers, 1 do
                                    Citizen.Wait(1500)
                                    FreezeEntityPosition(NewPassagers[i], false)
                                    seat = seat + 1
                                    countPassagers = countPassagers + 1
                                    TaskEnterVehicle(NewPassagers[i], veh, 1.0, seat, 1, 0)
                                    table.insert(OnBusPassagers, NewPassagers[i])
                            end
                            GoingLocal = false

                              if not GoingLocal then 
                                for i = 1, #NewPassagers, 1 do
                                table.remove(NewPassagers)
                                end
                              end

                            RemoveBlip(blips[k])
                            goStation(next_station, veh)
                            break
                        end
                        print('removed blip ', k)
                    end
                end
            end)
        end
    end
end



function GoLocal(veh)
    GoingLocal = true
    for i=quantity, #Config.Stations, 1 do
        print('teste')
        RequestModel(GetHashKey(Config.Stations.Peds[i].coords.model))
        while (not HasModelLoaded(GetHashKey(Config.Stations.Peds[i].coords.model))) do
            Citizen.Wait(1)
        end
        local passagers = CreatePed(4, Config.Stations.Peds[i].coords.model, Config.Stations.Peds[i].coords.x, Config.Stations.Peds[i].coords.y, Config.Stations.Peds[i].coords.z, 0.0, false, false)
        Wait(500)
        SetEntityHeading(passagers,Config.Stations.Peds[i].coords.heading)
        FreezeEntityPosition(passagers, true)
        table.insert(NewPassagers, passagers)
        print(Config.Stations.Peds[i].coords.model)
    end

    blip = AddBlipForCoord(308.11, -767.33, 29.3)
    SetBlipSprite(blip, 1)
    SetBlipRoute(blip, true)
    Citizen.CreateThread(function()
        while GoingLocal do
            Citizen.Wait(1)
            DrawMarker(2, 308.11, -767.33, 29.3, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.2, 1, 21, 25, 255, true,true, false, 2, nil, nil, false)
            if #(vector3(GetEntityCoords(PlayerPedId())) - vector3(308.11, -767.33, 29.3)) < 3 then
                RemoveBlip(blip)
                FreezeEntityPosition(veh, true)
                for i = 1, #NewPassagers, 1 do
                FreezeEntityPosition(NewPassagers[i], false)
                Wait(1000) 
                seat = seat+1
                countPassagers = countPassagers+1
                TaskEnterVehicle(NewPassagers[i], veh, 1.0, seat, false, 0)
            end
                onlocal = true
                while onlocal do
                    GoingLocal = false
                    Citizen.Wait(1)
                    print(GetVehicleNumberOfPassengers(veh))
                    print(countPassagers)
                    if GetVehicleNumberOfPassengers(veh) == countPassagers then
                        FreezeEntityPosition(veh, false)
                        NewLocal(veh)
                        onlocal = false
                    end
                end
            end
        end
    end)
end

function NewLocal(veh)
    blip = AddBlipForCoord(113.8, -785.79, 31.4)
    SetBlipSprite(blip, 1)
    SetBlipRoute(blip, true)
    NewLocal = true
    Citizen.CreateThread(function()
        while NewLocal do
            Citizen.Wait(1)
            DrawMarker(2, 113.8, -785.79, 31.4, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.5, 0.5, 0.2, 1, 21, 25, 255, true,true, false, 2, nil, nil, false)
            if #(vector3(GetEntityCoords(PlayerPedId())) - vector3(113.8, -785.79, 31.4)) < 3 then
                RemoveBlip(blip)
                FreezeEntityPosition(veh, true)
                Wait(150)
                for i = 1, #NewPassagers, 1 do
                TaskLeaveVehicle(NewPassagers[i], veh, 0)
                end
                if GetVehicleNumberOfPassengers(veh) == 0 then
                    NewLocal = false 
                    print("job finished, thank you")
                    FreezeEntityPosition(veh, false)
                    for i = 1, #NewPassagers, 1 do
                        TaskWanderStandard(NewPassagers[i],10.0, 10)
                        EnableControlAction(0,75,true) 
                        EnableControlAction(27,75,true) 
                    end
                end
            end
        end
    end)

end




function GoAnim(veh, type)
    if type == "open_container" then
        TurningOffLight = true
        SetEntityCoords(PlayerPedId(), -758.6, -1170.86, 10.63, true, false, false)
        SetEntityHeading(PlayerPedId(), 131.65)
        Wait(800)
        FreezeEntityPosition(PlayerPedId(), true)
        LoadAnim("mp_missheist_countrybank@enter_code")
        TaskPlayAnim(PlayerPedId(), "mp_missheist_countrybank@enter_code", "enter_code_loop", 2.0, 1.0, 5000, 0, 1, 0,
            0, 0)
        Wait(5000)
        ClearPedTasks(PlayerPedId())
        Wait(250)
        FreezeEntityPosition(PlayerPedId(), false)
        GoToCar(veh)
    elseif type == "put_ladder" then
        SetEntityCoords(PlayerPedId(), -754.6, -1169.73, 10.63, true, false, false)
        SetEntityHeading(PlayerPedId(),  31.53)
        Wait(800)
        FreezeEntityPosition(PlayerPedId(), true)
        Wait(250)
        LoadAnim('anim@heists@narcotics@trash')
        TaskPlayAnim(PlayerPedId(), 'anim@heists@narcotics@trash', "throw_a", 3.0, -8, -1, 63, 0, 0, 0, 0)
        Citizen.Wait(900)
        ClearPedTasks(PlayerPedId())
        FreezeEntityPosition(PlayerPedId(), false)
    end
end






function LoadAnim(dict)
    RequestAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
	  	Citizen.Wait(10)
    end
end













