local showIds = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if showIds == true then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed, false)
            local nearbyPlayers = GetPlayersInArea(playerCoords, Config.radius)

            for _, player in ipairs(nearbyPlayers) do
                local targetPed = GetPlayerPed(player)

                if playerPed == targetPed and Config.excludeSelf then

                else
                    local targetCoords = GetEntityCoords(targetPed, false)
                    local playerID = GetPlayerServerId(player)

                    DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.0, "ID: " .. playerID)
                end
            end
        end
    end
end)

RegisterCommand("showids", function(source, args, rawCommand)
    showIds = true
    Citizen.Wait(Config.duration * 1000)
    showIds = false
end, false)

TriggerEvent('chat:addSuggestion', '/showids', 'Will show player IDs for ' .. Config.duration .. ' seconds')

function DrawText3D(x, y, z, text)
    local onScreen, _x, _y = GetScreenCoordFromWorldCoord(x, y, z)
    local px, py, pz = table.unpack(GetGameplayCamCoord())

    if onScreen then
        SetTextScale(Config.scale, Config.scale)
        SetTextFont(4)
        SetTextProportional(true)
        SetTextColour(118, 212, 118, 215)
        BeginTextCommandDisplayText("STRING")
        SetTextCentre(true)
        SetTextDropshadow(2, 0, 0, 0, 0)
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

function GetPlayersInArea(coords, radius)
    local players = {}

    for _, player in ipairs(GetActivePlayers()) do
        local targetPed = GetPlayerPed(player)
        local targetCoords = GetEntityCoords(targetPed, false)

        local distance = #(targetCoords - coords)

        if distance <= radius then
            table.insert(players, player)
        end
    end

    return players
end
