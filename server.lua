local interiorOptions = {
    apartmentHighEnd1 = {
        id = 1,
        x = -777.78,
        y = 317.2,
        z = 176.8,
        heading = 269.93
    }
}
local playersCreatingInteriors = { }
local selectedInterior = { }
local createdInterior = { }

RegisterCommand('createinterior', function(source, args)
    local interiorId = tonumber(args[1])
    if not isPlayerCreatingInterior(source) and interiorId ~= null then
        for _, interior in pairs(interiorOptions) do -- Issue here?
            if interior.id == interiorId then 
                table.insert(playersCreatingInteriors, GetPlayerIdentifiers(source)[1])
                selectedInterior = interior
                showSubtitleForPlayer(source, 'Walk towards the entrance and type ~y~/setentrance~s~ to set the entrance.', 60000)
                do return end
            end
        end
        showAlertForPlayer(source, "There aren't any existing interiors with this ID.")
    else
        if interiorId == null then
            showAlertForPlayer(source, "Please provide an interior ID [1-99].")
        else
            showAlertForPlayer(source, "You are already creating an interior.")
        end
    end
end, false)

RegisterCommand('setentrance', function(source, args)
    local playerPed = GetPlayerPed(source)
    if isPlayerCreatingInterior(source) and selectedInterior ~= null then
        createdInterior.entrance = GetEntityCoords(GetPlayerPed(source))
        SetEntityCoords(playerPed, selectedInterior.x, selectedInterior.y, selectedInterior.z , false, false, false, true)
        SetEntityHeading(playerPed, selectedInterior.heading)
        showSubtitleForPlayer(source, 'Walk towards the exit and type ~y~/setexit~s~ to set the exit.', 60000)
    else
        showAlertForPlayer(source, "You aren't creating an interior.")
    end
end, false)

RegisterCommand('setexit', function(source, args)
    if isPlayerCreatingInterior(source) then
        createdInterior.exit = GetEntityCoords(GetPlayerPed(source))
        showSubtitleForPlayer(source, 'Type ~y~/setname [name]~s~ to set the name of the interior.', 60000)
    else
        showAlertForPlayer(source, "You aren't creating an interior.")
    end
end, false)

RegisterCommand('setname', function(source, args)
    if isPlayerCreatingInterior(source) then
        createdInterior.name = tostring(args[1])
        showSubtitleForPlayer(source, 'Type ~y~/finishinterior~s~ finalise the interior.', 60000)
    else
        showAlertForPlayer(source, "You aren't creating an interior.")
    end
end, false)

RegisterCommand('finishinterior', function(source, args)
    if isPlayerCreatingInterior(source) then
        TriggerClientEvent("Z-Interiors:UpdateInteriors", -1, { 
            createdInterior
        })
        setPlayerNotCreatingInterior(source)
    else
        showAlertForPlayer(source, "You aren't creating an interior.")
    end
end, false)

function showSubtitleForPlayer(player, message, duration)
    TriggerClientEvent("Z-Interiors:ShowSubtitle", 
        player, 
        message,
        duration
    )
end

function showAlertForPlayer(player, message, duration)
    TriggerClientEvent("Z-Interiors:ShowAlert", 
        player, 
        message,
        duration
    )
end

function isPlayerCreatingInterior(player)
    for _, value in ipairs(playersCreatingInteriors) do
        if value == GetPlayerIdentifiers(player)[1] then
            return true
        end
    end
    return false
end


function setPlayerNotCreatingInterior(player)
    for index, value in ipairs(playersCreatingInteriors) do
        if value == GetPlayerIdentifiers(player)[1] then
            table.remove(playersCreatingInteriors, index)
        end
    end
end
