local showIds = false

Citizen.CreateThread(function()
    while true do 
        Citizen.Wait(0)

        if showIds == true then 
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed)
            local nearbyPlayers = GetPlayersInArea(playerCoords, config.radius)
    
            for _, player in ipairs(nearbyPlayers) do
                local targetPed = GetPlayerPed(player)

                if playerPed == targetPed and config.excludeSelf then 
                    
                else
                    local targetCoords = GetEntityCoords(targetPed)
                    local playerID = GetPlayerServerId(player)
                    
                    DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.0, "ID: " .. playerID)
                end
            end
        end
    end
end)

RegisterCommand("showids", function(source, args, rawCommand)
    showIds = true
    Citizen.Wait(config.duration * 1000)
    showIds = false
end, false)

TriggerEvent('chat:addSuggestion', '/showids', 'Will show player IDs for ' .. config.duration .. ' seconds')

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = World3dToScreen2d(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())

    if onScreen then
        SetTextScale(config.scale, config.scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(118, 212, 118, 215)
        SetTextEntry("STRING")
        SetTextCentre(1)
        SetTextDropshadow(2, 0, 0, 0, 0)
        AddTextComponentString(text)
        DrawText(_x, _y)
    end
end

function GetPlayersInArea(coords, radius)
    local players = {}

    for _, player in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(targetPed)

        local distance = GetDistanceBetweenCoords(targetCoords, coords, true)

        if distance <= radius then
            table.insert(players, player)
        end
    end

    return players
end
