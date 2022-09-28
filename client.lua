local interiors = {}

RegisterNetEvent("Z-Interiors:UpdateInteriors", function(newInteriors)
    interiors = newInteriors
    print("New interior: " .. interiors[1].name)
end)

RegisterNetEvent("Z-Interiors:ShowSubtitle", function(message, duration)
    showSubtitle(message, duration)
end)

RegisterNetEvent("Z-Interiors:ShowAlert", function(message, duration)
    showAlert(message, duration)
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

