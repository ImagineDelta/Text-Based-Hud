QBCore = nil
ESX = nil
local count = 0
local clock
local hours = 0
local minutes = 0
local ms = 0
local loaded = false
local bank = 0
local cash = 0
local Player
-- Check Framework
if Config.Framework == 'QBCore' then
	RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
		QBCore = exports['qb-core']:GetCoreObject()
		loaded = true
		TriggerServerEvent('dvn:sv:getPlayerCount')
		TriggerServerEvent('dvn:sv:getServerTime')
	end)
elseif Config.Framework == 'ESX' then
	RegisterNetEvent('esx:playerLoaded', function()
		ESX = exports["es_extended"]:getSharedObject()
		loaded = true
		TriggerServerEvent('dvn:sv:getPlayerCount')
		TriggerServerEvent('dvn:sv:getServerTime')
	end)
else
	AddEventHandler('playerSpawned', function()
		loaded = true
		TriggerServerEvent('dvn:sv:getPlayerCount')
		TriggerServerEvent('dvn:sv:playerLoaded')
	end)
end

RegisterNetEvent('dvn-servername:cl:getPlayerCount', function(players)
	count = players
end)

RegisterNetEvent('dvn-servername:cl:updateTime', function(h, m, s)
	hours = h
	minutes = m
	ms = s * 1000
end)

Citizen.CreateThread(function()
	while true do
		Wait(2500)
		if loaded then
			if Config.Framework == 'QBCore' then
				Player = QBCore.Functions.GetPlayerData()
				cash = Player.money['cash']
				bank = Player.money['bank']
			else
				Player = ESX.GetPlayerData()
				cash = Player.accounts[3].money
				bank = Player.accounts[2].money
			end
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		Wait(1)
		if loaded then
			DrawTxt(Config.Text1 .. " - ", Config.Offset.x, Config.Offset.y, Config.Color.r, Config.Color.g, Config.Color.b)
			DrawTxt(Config.Text2, Config.Offset2.x, Config.Offset2.y, Config.Color2.r, Config.Color2.g, Config.Color2.b)
			if Config.Time then
				-- Parse to string
				clock = string.format("%02d:%02d", hours, minutes)
				DrawTxt(" - " .. tostring(count) .. "/" .. Config.PlayerCount .. " - " .. clock, Config.Offset3.x, Config.Offset3.y, Config.Color.r, Config.Color.g, Config.Color.b)
			else
				DrawTxt(" - " .. tostring(count) .. "/" .. Config.PlayerCount, Config.Offset3.x, Config.Offset3.y, Config.Color.r, Config.Color.g, Config.Color.b)
			end
			if Config.MoneyHud == true then
				DrawCenteredMoney(cash, bank, 0.945, 0.035, 0.03)
			end		
		end
	end
end)

Citizen.CreateThread(function()
	while true do
		if ms ~= 0 then
			Wait(60000 - ms)
			minutes = minutes + 1
			if minutes >= 60 then
				minutes = 0
				hours = hours + 1
			end
			if hours >= 24 then
				hours = 0
			end
			ms = 0
		else
			Wait(60000)
			minutes = minutes + 1
			if minutes >= 60 then
				minutes = 0
				hours = hours + 1
			end
			if hours >= 24 then
				hours = 0
			end
		end
	end
end)

function DrawTxt(text, x, y, r, g, b)
	SetTextColour(r, g, b,180)
	SetTextFont(4)
	SetTextScale(0, 0.5)
	SetTextWrap(0.0, 1.0)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end

			
function GetTextWidth(text, scale)
	BeginTextCommandGetWidth("STRING")
	AddTextComponentString(text)
	SetTextFont(4)
	SetTextScale(0, scale)
	return EndTextCommandGetWidth(true)
end

function FormatNumber(number)
	local formatted = tostring(number)
	while true do  
		formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k == 0) then
			break
		end
	end
	return formatted
end

function DrawCenteredMoney(cash, bank, baseX, baseY, spacing, scale)
	local cashText = '$' .. FormatNumber(cash)
	local bankText = '$' .. FormatNumber(bank)

	local cashWidth = GetTextWidth(cashText, 0.6)
	local bankWidth = GetTextWidth(bankText, 0.55)

	local maxWidth = math.max(cashWidth, bankWidth)

	local cashX = baseX + (maxWidth - cashWidth) / 2
	local bankX = baseX + (maxWidth - bankWidth) / 2

	DrawMoney(cashText, cashX, baseY, 116, 221, 149, 0.6, baseX + maxWidth)
	DrawMoney(bankText, bankX, baseY + spacing, 255, 255, 255, 0.55, baseX + maxWidth)
end

function DrawMoney(text, x, y, r, g, b, scale, wrapX)
	SetTextColour(r, g, b,180)
	SetTextFont(4)
	SetTextScale(0, scale)
	SetTextWrap(0.0, wrapX)
	SetTextOutline()
	SetTextEntry("STRING")
	AddTextComponentString(text)
	DrawText(x, y)
end