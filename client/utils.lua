function CreatePedOnCoord(pedHash, x, y, z, w)
    
    local pedHashKey = GetHashKey(pedHash)

    RequestModel(pedHashKey)
    while not HasModelLoaded(pedHashKey) do
        Wait(0)
    end

    local ped = CreatePed(0, pedHashKey, x, y, z, w, false, true)

    SetBlockingOfNonTemporaryEvents(ped, true)
    SetPedDiesWhenInjured(ped, false)
    SetPedCanPlayAmbientAnims(ped, true)
    SetPedCanRagdollFromPlayerImpact(ped, false)
    SetEntityInvincible(ped, true)
    FreezeEntityPosition(ped, true)
end

function drawText3D(text)
    SetTextFont(0)
	BeginTextCommandDisplayHelp('STRING')
	AddTextComponentSubstringPlayerName(text)
	EndTextCommandDisplayHelp(0, false, true, -1)
end

function createBlip(x, y, z, sprite, color, text)
    local blip = AddBlipForCoord(x, y, z)
    SetBlipSprite(blip, sprite)
    SetBlipDisplay(blip, 6)
    SetBlipScale(blip, 1.0)
    SetBlipColour(blip, color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(text)
    EndTextCommandSetBlipName(blip)

    return blip
end

function setWaypoint(x,y,z)
    ClearGpsMultiRoute()
    StartGpsMultiRoute(6, true, true)
    AddPointToGpsMultiRoute(x, y, z)
    SetGpsMultiRouteRender(true)
end

function getRandomRoute()
    local route = Config.Routes[math.random(1, #Config.Routes)]

    setWaypoint(route.x, route.y, route.z)

    isWaypointSet = true

    return route
end

function table_size(tbl)
	local size = 0

	for k, v in pairs(tbl) do
		size = size + 1
	end

	return size
end

function triggerServerCallback(...)
	if Config.Framework == "qb" then
		Framework.Functions.TriggerCallback(...)
	else
		Framework.TriggerServerCallback(...)
	end
end

function LoadAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        RequestAnimDict(dict)
        Wait(10)
    end
end

function LoadModel(model)
	while not HasModelLoaded(GetHashKey(model)) do
		RequestModel(GetHashKey(model))
		Wait(10)
	end
end