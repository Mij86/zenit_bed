local bed = {
    vector4(-469.8389, -284.2215, 35.8351, 24.8688),
    --vector4(-469.8389, -284.2215, 35.8351, 24.8688), 
    --vector4(-469.8389, -284.2215, 35.8351, 24.8688),
}

local inbed = false

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        local playerPed = PlayerPedId()
        local playerPos = GetEntityCoords(playerPed)
        local nearestBett = nil
        local nearestDist = math.huge

        for _, bett in pairs(bed) do
            local dist = #(playerPos - vector3(bett.x, bett.y, bett.z))
            if dist < nearestDist then
                nearestBett = bett
                nearestDist = dist
            end
        end

        if nearestBett and nearestDist < 2.0 and not inbed then
            if IsControlJustReleased(0, 38) then 
                TriggerEvent('legEvent', nearestBett)
                inbed = true
            end
        end

        if inbed and IsControlJustReleased(0, 73) then 
            ClearPedTasks(playerPed)
            inbed = false
        end
    end
end)

RegisterNetEvent('legEvent')
AddEventHandler('legEvent', function(bett)
    local playerPed = PlayerPedId()
    SetEntityCoords(playerPed, bett.x, bett.y, bett.z - 0.95)
    SetEntityHeading(playerPed, bett.w)

    local dict = "amb@world_human_sunbathe@male@back@base"
    local anim = "base"

    RequestAnimDict(dict)
    while not HasAnimDictLoaded(dict) do
        Citizen.Wait(100)
    end

    TaskPlayAnim(playerPed, dict, anim, 8.0, -8, -1, 1, 0, false, false, false)
end)