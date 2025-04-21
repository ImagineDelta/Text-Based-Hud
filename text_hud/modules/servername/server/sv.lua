local players = 0
local time
local hours
local minutes
local seconds

print('\x1b[31mDVN-SERVERNAME \x1b[37m-\x1b[32m Started successfully!')

RegisterNetEvent('dvn:sv:getPlayerCount', function()
    players = players + 1
    TriggerClientEvent('dvn-servername:cl:getPlayerCount', -1, players)
end)

RegisterNetEvent('dvn:sv:getServerTime', function()
    hours = os.date("%H")
    minutes = os.date("%M")
    seconds = os.date("%S")
    TriggerClientEvent('dvn-servername:cl:updateTime', -1, tonumber(hours), tonumber(minutes),tonumber(minutes))
end)

AddEventHandler('playerDropped', function()
    players = players - 1
    TriggerClientEvent('dvn-servername:cl:getPlayerCount', -1, players)
end)