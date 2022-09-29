local interiors = { }
local selectedInterior = { }
local createdInterior = { }
local creatingInterior = false;

RegisterNetEvent("Z-Interiors:UpdateInteriors", function(newInteriors)
    interiors = newInteriors
end)

RegisterNetEvent("Z-Interiors:UpdateInteriorOptions", function(interiorId, interiorOptions)
    createInterior(interiorId, interiorOptions)
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1)
        for _, interior in ipairs(interiors) do
            local playerPos = GetEntityCoords(GetPlayerPed(-1))
            if (GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, interior.entrance.x, interior.entrance.y, interior.entrance.z) < 15) then
                DrawMarker(1, interior.entrance.x, interior.entrance.y, interior.entrance.z - 1, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.0, 1.0, 1.0, 255, 128, 0, 155, false, false, 2, nil, nil, false)
                if (GetDistanceBetweenCoords(playerPos.x, playerPos.y, playerPos.z, interior.entrance.x, interior.entrance.y, interior.entrance.z) < 1) then
                    showHelpPrompt(("Press ~INPUT_CONTEXT~  to enter %s"):format(interior.name))
                end
            end
        end
    end
end)

RegisterCommand('createinterior', function(source, args)
    local interiorId = tonumber(args[1])
    if not creatingInterior and interiorId ~= null then
        TriggerServerEvent("Z-Interiors:GetInteriorOptions", interiorId)
    else
        if interiorId == null then
            showAlert("Please provide an interior ID [1-99].")
        else
            showAlert("You are already creating an interior.")
        end
    end
end, false)

RegisterCommand('setentrance', function(source, args)
    local playerPed = PlayerPedId()
    if creatingInterior and selectedInterior ~= null then
        createdInterior.entrance = GetEntityCoords(PlayerPedId())
        SetEntityCoords(playerPed, selectedInterior.x, selectedInterior.y, selectedInterior.z , false, false, false, true)
        SetEntityHeading(playerPed, selectedInterior.heading)
        showSubtitle('Walk towards the exit and type ~y~/setexit~s~ to set the exit.', 60000)
    else
        showAlert("You aren't creating an interior.")
    end
end, false)

RegisterCommand('setexit', function(source, args)
    if creatingInterior then
        createdInterior.exit = GetEntityCoords(GetPlayerPed(source))
        showSubtitle('Type ~y~/setname [name]~s~ to set the name of the interior.', 60000)
    else
        showAlert("You aren't creating an interior.")
    end
end, false)

RegisterCommand('setname', function(source, args)
    if creatingInterior then
        createdInterior.name = tostring(args[1])
        showSubtitle('Type ~y~/finishinterior~s~ finalise the interior.', 60000)
    else
        showAlert("You aren't creating an interior.")
    end
end, false)

RegisterCommand('finishinterior', function(source, args)
    if creatingInterior then
        if createdInterior.entrance ~= null then
            TriggerEvent("Z-Interiors:UpdateInteriors", { 
                createdInterior
            })
            SetEntityCoords(PlayerPedId(), createdInterior.entrance.x, createdInterior.entrance.y, createdInterior.entrance.z , false, false, false, true)
            creatingInterior = false
        end
    else
        showAlert("You aren't creating an interior.")
    end
end, false)

function createInterior(interiorId, interiorOptions)
    if interiorOptions ~= null then
        for _, interior in pairs(interiorOptions) do
            if interior.id == interiorId then 
                creatingInterior = true
                selectedInterior = interior
                showSubtitle('Walk towards the entrance and type ~y~/setentrance~s~ to set the entrance.', 60000)
                do return end
            end
        end
        showAlert("There aren't any existing interiors with this ID.")
    end
end

function showSubtitle(message, duration)
    BeginTextCommandPrint("STRING")
    AddTextComponentString(message)
    EndTextCommandPrint(duration, true)
end

function showHelpPrompt(message)
    SetTextComponentFormat("STRING")
    AddTextComponentString(message)
    DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function showAlert(message, duration)
    AddTextEntry("CH_ALERT", message)
    BeginTextCommandDisplayHelp("CH_ALERT")
    EndTextCommandDisplayHelp(0, false, beep, duration)
end

