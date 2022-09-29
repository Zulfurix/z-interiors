local interiorOptions = {
    apartmentHighEnd1 = {
        id = 1,
        x = -777.78,
        y = 317.2,
        z = 176.8,
        heading = 269.93
    }
}

RegisterNetEvent("Z-Interiors:GetInteriorOptions", function(interiorId)
    TriggerClientEvent("Z-Interiors:UpdateInteriorOptions", source, interiorId, interiorOptions)
end)