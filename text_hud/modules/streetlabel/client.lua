-- Variables
local directions = {
  N = 360, 0,
  NE = 315,
  E = 270,
  SE = 225,
  S = 180,
  SW = 135,
  W = 90,
  NW = 45,
}

local veh = 0

Citizen.CreateThread(function()
  while true do
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped, false)

    local coords = GetEntityCoords(ped)
    local zone = GetNameOfZone(coords.x, coords.y, coords.z)

    local var1, var2 = GetStreetNameAtCoord(coords.x, coords.y, coords.z, Citizen.ResultAsInteger(), Citizen.ResultAsInteger())
    local hash1 = GetStreetNameFromHashKey(var1)
    local hash2 = GetStreetNameFromHashKey(var2)
    local heading = GetEntityHeading(PlayerPedId())

    for k, v in pairs(directions) do
      if math.abs(heading - v) < 22.5 then
        heading = k
        if heading == 1 then heading = 'N' end
        break
      end
    end

    local street2
    if hash2 == '' then
      street2 = GetLabelText(zone)
    else
      street2 = hash2..' / '..GetLabelText(zone)
    end

    local configColor
    if config.color then
      configColor = 'rgb('..config.color.r..', '..config.color.g..', '..config.color.b..')'
    else
      configColor = 'rgb(255, 255, 255)'
    end

    if config.position.x == nil or config.position.x == '' then config.position.x = 17.55 end
    if config.position.y == nil or config.position.y == '' then config.position.y = 3 end

    -- Main logic: Show HUD only when NOT in vehicle if vehicleCheck is true
    if config.vehicleCheck == false then
      SendNUIMessage({
        type = 'open',
        active = true,
        color = configColor,
        direction = heading,
        posX = config.position.x,
        posY = config.position.y,
        street = hash1,
        zone = street2
      })
    else
      if veh == 0 then -- not in vehicle
        SendNUIMessage({
          type = 'open',
          active = true,
          color = configColor,
          direction = heading,
          posX = config.position.x,
          posY = config.position.y,
          street = hash1,
          zone = street2
        })
      else
        SendNUIMessage({
          type = 'open',
          active = false
        })
      end
    end

    Citizen.Wait(50) -- Half-second update rate
  end
end)
