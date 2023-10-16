Framework = Config.Framework == "esx" and exports["es_extended"]:getSharedObject() 
                or exports['qb-core']:GetCoreObject()

local PlayerData = {}
local isJobStarted
local pedCoord = Config.Ped.coord
local doesCarSpawned = false
local userLevel = 1
local packageStorageCoord = Config.PackageStorageCoord
local loggedIn = false
local packageDelivered = 0
local userExp = 0
local packageLimit = 1
local experienceOnDelivery = 0
local moneyOnDelivery = 0
local packageInCar = 0
local uiLoaded = false
local fullName

CreateThread(function()
    CreatePedOnCoord(Config.Ped.hash, pedCoord.x, pedCoord.y, pedCoord.z - 1, pedCoord.w)
    createBlip(pedCoord.x, pedCoord.y, pedCoord.z, Config.Ped.Blip.sprite, Config.Ped.Blip.color, Config.Ped.Blip.blipName)

    while true do

        if table_size(PlayerData) > 0 then
            loggedIn = true
        end

        if Config.Framework == "esx" and loggedIn then
            PlayerData = Framework.GetPlayerData()
            fullName = PlayerData.firstName.." "..PlayerData.lastName
        elseif Config.Framework == "qbcore" and loggedIn then
            PlayerData = Framework.Functions.GetPlayerData()
            fullName = PlayerData.charinfo.firstname.." "..PlayerData.charinfo.lastname
        end

        ped = PlayerPedId()
        playerPosition = GetEntityCoords(ped)

        if car then
            carPos = GetEntityCoords(car)
            carDistance = GetDistanceBetweenCoords(playerPosition, carPlate.x, carPlate.y, carPlate.z, true)
        end

        if doesCarSpawned and car then
            isPlayerInCar = IsPedInAnyVehicle(ped, car)
        end
        
        Wait(1000)
    end
end)

local allAreasIsBusy = false

CreateThread(function()
    local sleep = 1000
    while true do
        local pedDistance = GetDistanceBetweenCoords(playerPosition, pedCoord.x, pedCoord.y, pedCoord.z, true)
        carPlate = GetWorldPositionOfEntityBone(car, (GetEntityBoneIndexByName(car, Config.carInteractPart)))

        if pedDistance < 2 then
            sleep = 1
    
            if not doesCarSpawned then
                if allAreasIsBusy then
                    drawText3D(Config.Texts.car_spawn_areas_notclear)

                    Wait(2000)

                    allAreasIsBusy = false
                else
                    drawText3D('~INPUT_CONTEXT~ '..Config.Texts.cargojob_menu..'')
                end
            else
                drawText3D('~INPUT_CONTEXT~ '..Config.Texts.deliver_car..'') 
            end

            if IsControlJustReleased(0, 38) then
                if doesCarSpawned then
                    TriggerServerEvent("hy_cargojob:server:finishJob", packageDelivered, experienceOnDelivery, moneyOnDelivery)
                    drawText3D(""..Config.Texts.delivery_complete.." "..packageDelivered*experienceOnDelivery.." "..Config.Texts.delivery_complete2.." "..packageDelivered*moneyOnDelivery.." "..Config.Texts.delivery_complete3.."")
                    endJob()
                    Wait(4000)
                elseif not doesCarSpawned and not uiOpen then
                    uiOpen = true
                    SetNuiFocus(1,1)    
                    triggerServerCallback('hy_cargojob:getPlayerData', function(data)
                        userLevel = math.floor(data.data.experience / 100)
                        userExp = data.data.experience
        
                        SendNUIMessage({
                            action = "openUi",
                            userLevel = userLevel,
                            userExp = userExp,
                            config = Config,
                            fullname = fullName,
                            profilePhoto = data.avatar
                        })
                    end)
                    
                end

                RemoveBlip(cargoDropBlip) -- buda çalışıyor
            end 
        else
            sleep = 1000
        end

        Wait(sleep) 
    end
end)

CreateThread(function()
    packTaken = false
    missionStarted = false
    packageInCar = 0
    sendNotif = false
    local sleep = 1000
    --local blipCreated = false
    local isAnimationPlaying = false
    
    while true do
        ------ VEHICLE SPAWNED, START LOADING ------
        if doesCarSpawned then

            while car == nil do
                Wait(0)
            end 
            
            if not missionStarted and packageInCar ~= packageLimit then
                SetVehicleDoorsLocked(car, 2) 

                if not packTaken then

                    local storageDist = GetDistanceBetweenCoords(playerPosition, Config.PackageStorageCoord.x, Config.PackageStorageCoord.y, Config.PackageStorageCoord.z, true)

                    if GetVehiclePedIsTryingToEnter(ped) == car and IsPedTryingToEnterALockedVehicle(ped) then
                        drawText3D(Config.Texts.delivery_not_started)

                        Wait(2000)
                    end

                    if storageDist < 1.5 then

                        sleep = 1
                        
                        if not isPlayerInCar then
                            drawText3D(Config.Texts.take_package_from_start)

                            if IsControlJustReleased(0, 38) then
                                LoadModel("prop_cs_cardbox_01")
                                obj = CreateObject('prop_cs_cardbox_01', playerPosition, true, false, false)
                                AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, 57005), 0.08, 0.12, -0.30, -20.0, 75.0, -15.0, true, true, false, true, 1, true)
                                SetModelAsNoLongerNeeded("prop_cs_cardbox_01")
                                LoadAnimDict("anim@heists@box_carry@")
                                TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 3.0, 1.0, -1, 49, 0, false, false, false)
                                packTaken = true
                            end
                        elseif isPlayerInCar then
                            drawText3D(Config.Texts.take_package_deliver)
                        end
                    elseif storageDist < 20 then
                        sleep = 1

                        DrawMarker(2, Config.PackageStorageCoord, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.75, 0.75, 0.75, 0, 255, 0, 100, false, true, 2, false, false, false, false)
                    else
                        sleep = 1000
                    end
                elseif packTaken then
                    if carDistance < 20 and carDistance > 5 then
                        sleep = 1
                        DrawMarker(2, carPos.x, carPos.y, carPos.z + 3, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.75, 0.75, 0.75, 0, 255, 0, 100, true, true, 2, false, false, false, false)
                    elseif carDistance < 12 then
                        sleep = 1
                        DrawMarker(27, carPlate, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 1.4, 1.4, 1.4, 0, 255, 0, 100, false, true, 2, false, false, false, false)

                        if carDistance < 2 then
                            if not isPlayerInCar then 
                                
                                drawText3D(Config.Texts.put_package_to_car)
                                if IsControlJustReleased(0, 38) then 
                                    DeleteEntity(obj)
                                    SetModelAsNoLongerNeeded(obj)
                                    ClearPedTasks(ped)
                                    packageInCar = packageInCar + 1
                                    packTaken = false
                                end
                            else
                                drawText3D(Config.Texts.put_package)
                            end
                        end
                    else
                        sleep = 1000 
                    end 
                end
            elseif not missionStarted and packageInCar == packageLimit then
                packTaken = false
                missionStarted =  true
                if not sendNotif then
                    SetVehicleDoorsLocked(car, 1)
                    drawText3D(Config.Texts.deliver_started)
                    sendNotif = true
                end
            end
        else
            sleep = 1000 
        end
        
        Wait(sleep)
    end
end)

CreateThread(function()
    isWaypointSet = false
    deliveryStarted = false
    local orderDistance 
    local sleep = 1000
    blipCreated = false
    sendNotif2 = false
    isMissionFailed = false
    while true do
        if doesCarSpawned then
            local vehicleHealth = GetVehicleEngineHealth(car)
            if vehicleHealth <= 0 or not DoesEntityExist(car) or not IsVehicleDriveable(car, false) then
                isMissionFailed = true
                if isMissionFailed and doesCarSpawned then
                    drawText3D(Config.Texts.vehicle_not_working)
                    Wait(Config.timeBeforeCarDelete)
                    endJob()
                end
            end
        end
        if missionStarted then
            if not isWaypointSet then
                route = getRandomRoute()
            end

            if packageInCar ~= 0 then
                deliveryStarted = true
            end

            if deliveryStarted and not blipCreated then
                blipCreated = true
                cargoDropBlip = createBlip(route.x, route.y, route.z, 1, 1, Config.Texts.deliverBlipName)
            end

            orderDistance = GetDistanceBetweenCoords(playerPosition, route.x, route.y, route.z, true)
            
            if orderDistance < 20 and orderDistance > 5 and not packTaken and isPlayerInCar and deliveryStarted then 
                sleep = 1
                drawText3D(Config.Texts.take_package_from_car)
            elseif not inCar and carDistance < 20 and orderDistance < 20 and not packTaken then
                sleep = 1

                if packageInCar ~= 0 then
                    DrawMarker(27, carPlate, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 1.4, 1.4, 1.4, 0, 255, 0, 100, false, true, 2, false, false, false, false)
                end

                if carDistance < 2 then
                    if packageInCar > 0 and not isPlayerInCar then
                        drawText3D(Config.Texts.take_package_from_car2)
                                        
                        if IsControlJustReleased(0, 38) then
                            LoadModel("prop_cs_cardbox_01")
                            obj = CreateObject('prop_cs_cardbox_01', playerPosition, true, false, false)
                            AttachEntityToEntity(obj, ped, GetPedBoneIndex(ped, 57005), 0.08, 0.12, -0.30, -20.0, 75.0, -15.0, true, true, false, true, 1, true)
                            LoadAnimDict("anim@heists@box_carry@")
                            TaskPlayAnim(ped, "anim@heists@box_carry@", "idle", 3.0, 1.0, -1, 49, 0, false, false, false)
                            packTaken = true
                            packageInCar = packageInCar - 1
                        end
                    end
                end
            elseif not isPlayerInCar and packTaken then
                sleep = 1
                DrawMarker(2, route, 0.0, 0.0, 0.0, 180.0, 0.0, 0.0, 0.75, 0.75, 0.75, 0, 255, 0, 100, false, true, 2, false, false, false, false)
                if orderDistance < 2 and not isPlayerInCar then
                    drawText3D(""..Config.Texts.deliver_package.."~INPUT_CONTEXT~")

                    if IsControlJustReleased(0, 38) then
                        DeleteEntity(obj)
                        SetModelAsNoLongerNeeded(obj)
                        ClearPedTasks(ped)
                        packTaken = false
                        packageDelivered = packageDelivered + 1
                        if packageInCar == 0 then
                            RemoveBlip(cargoDropBlip)
                            packTaken = false
                            deliveryStarted = false                           
                        elseif packageInCar > 0  then
                            packTaken = false
                            route = getRandomRoute()

                            RemoveBlip(cargoDropBlip)

                            Wait(10)

                            cargoDropBlip = createBlip(route.x, route.y, route.z, 1, 1, Config.deliverBlipName)

                            drawText3D(Config.Texts.new_delivery_point) 
                        end
                        if not deliveryStarted and not sendNotif2 then
                            sendNotif2 = true
                            drawText3D(Config.Texts.delivery_done) 
                            setWaypoint(pedCoord.x, pedCoord.y, pedCoord.z)
                        end
                    end
                else
                    drawText3D(Config.Texts.go_to_delivery_point) 
                end
            else
                sleep = 1000
            end
        end
        Wait(sleep)    
    end
end)

AddEventHandler('onResourceStop', function(resourceName)
    if (GetCurrentResourceName() ~= resourceName) then
        return
    end

    DeleteVehicle(car)
    ClearGpsMultiRoute()
    RemoveBlip(cargoDropBlip)
end)

RegisterNUICallback("LOADED", function(_, cb)
	triggerServerCallback("hy_cargojob:getPlayerData", function(playerData)
		cb(
			{
				config = Config,
				data = playerData
			}
		)

		uiLoaded = true
	end)
end)

RegisterNUICallback("CLOSE", function()
	if uiOpen then
		SetNuiFocus(0, 0)

		uiOpen = false
	end
end)

RegisterNUICallback("START", function(data)
    packageLimit = data.pack
    experienceOnDelivery = data.exp
    moneyOnDelivery = data.money
    
    uiOpen = false

    SetNuiFocus(0, 0)

    print("CHAPTER 1", doesCarSpawned)

    if not doesCarSpawned then
        local emptyVectors
        local isBusy

        print("CHAPTER 2", doesCarSpawned)

        for _, emptySpace in pairs(Config.VehicleSpawnCoords) do
            
            isBusy = IsPositionOccupied(emptySpace.x, emptySpace.y, emptySpace.z, 3, false, true, false, false, false, false, false)

            if not isBusy and not doesCarSpawned then
                emptyVectors = emptySpace

                local hash = GetHashKey(data.car)

                RequestModel(hash)

                while not HasModelLoaded(hash) do
                    print("MODEL LOADING")
                    Wait(100)
                end

                car = CreateVehicle(hash, emptyVectors, true, false)   
                ClearAreaOfObjects(emptyVectors, 7, 0) 
                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(car), exports["haso-getkey"]:GetKey())

                print("CAR CREATED")

                doesCarSpawned = true

                break
            end
        end

        print("CHAPTER 3", doesCarSpawned, isBusy)

        if not doesCarSpawned then
            allAreasIsBusy = true
        end
    end
end)


CreateThread(function()
    while true do
        
        if doesCarSpawned then
            SendNUIMessage({
                action = "packageUpdate",
                package = packageInCar,
                show = 1,
            })
        else
            SendNUIMessage({
                action = "packageUpdate",
                show = 0,
            })
        end 

        Wait(2000)
    end
end)

function endJob()
    isJobStarted = false
    packTaken = false
    missionStarted = false
    sendNotif2 = false
    deliveryStarted = false
    sendNotif = false
    doesCarSpawned = false
    userLevel = 0
    packageDelivered = 0
    userExp = 0
    packageLimit = 0
    experienceOnDelivery = 0
    moneyOnDelivery = 0
    packageInCar = 0
    isWaypointSet = false
    blipCreated = false
    isMissionFailed = false
    ClearPedTasks(ped) 
    ClearGpsMultiRoute()
    DeleteEntity(obj)
    SetModelAsNoLongerNeeded(obj)
    DeleteVehicle(car)
    SetVehicleAsNoLongerNeeded(car)
    RemoveBlip(cargoDropBlip)
end 

