local showIds = false

local function getPlayersInArea(coords, radius)
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

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)

        if showIds == true then
            local playerPed = PlayerPedId()
            local playerCoords = GetEntityCoords(playerPed, false)
            local nearbyPlayers = getPlayersInArea(playerCoords, Config.radius)

            for _, player in ipairs(nearbyPlayers) do
                local targetPed = GetPlayerPed(player)

                if not playerPed == targetPed and not Config.excludeSelf then
                    local targetCoords = GetEntityCoords(targetPed, false)
                    local playerID = GetPlayerServerId(player)

                    exports['FS-Lib']:DrawText3D(targetCoords.x, targetCoords.y, targetCoords.z + 1.0, "ID: " .. playerID)
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
