ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


RegisterServerEvent("esx:lowmoney")
AddEventHandler("esx:lowmoney", function(money)
    local _source = source	
	local xPlayer = ESX.GetPlayerFromId(_source)
	xPlayer.removeMoney(money)
end)


TriggerEvent('es:addCommand', 'savexyz', function(source, args, user)
	TriggerClientEvent("xyz:clientsaver", source);
end)

-- credits BadKai_PandaMay / DUFX :)
RegisterServerEvent("xyz:saver");
AddEventHandler("xyz:saver", function(PlayerName, x, y, z)
	file = io.open('resources\\esx_bike-rental\\xyz\\'..PlayerName..".txt", "a");
	if file then
		file:write("{['x'] = " .. x .. ", ['y'] = " .. y .. ", ['z'] =  " .. z .. "}, \n");
	else
		print('Error[xyz]');	
	end
	file:close();
end)

