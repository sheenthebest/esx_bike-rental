local Keys = {
  ["ESC"] = 322, ["F1"] = 288, ["F2"] = 289, ["F3"] = 170, ["F5"] = 166, ["F6"] = 167, ["F7"] = 168, ["F8"] = 169, ["F9"] = 56, ["F10"] = 57,
  ["~"] = 243, ["1"] = 157, ["2"] = 158, ["3"] = 160, ["4"] = 164, ["5"] = 165, ["6"] = 159, ["7"] = 161, ["8"] = 162, ["9"] = 163, ["-"] = 84, ["="] = 83, ["BACKSPACE"] = 177,
  ["TAB"] = 37, ["Q"] = 44, ["W"] = 32, ["E"] = 38, ["R"] = 45, ["T"] = 245, ["Y"] = 246, ["U"] = 303, ["P"] = 199, ["["] = 39, ["]"] = 40, ["ENTER"] = 18,
  ["CAPS"] = 137, ["A"] = 34, ["S"] = 8, ["D"] = 9, ["F"] = 23, ["G"] = 47, ["H"] = 74, ["K"] = 311, ["L"] = 182,
  ["LEFTSHIFT"] = 21, ["Z"] = 20, ["X"] = 73, ["C"] = 26, ["V"] = 0, ["B"] = 29, ["N"] = 249, ["M"] = 244, [","] = 82, ["."] = 81,
  ["LEFTCTRL"] = 36, ["LEFTALT"] = 19, ["SPACE"] = 22, ["RIGHTCTRL"] = 70,
  ["HOME"] = 213, ["PAGEUP"] = 10, ["PAGEDOWN"] = 11, ["DELETE"] = 178,
  ["LEFT"] = 174, ["RIGHT"] = 175, ["TOP"] = 27, ["DOWN"] = 173,
  ["NENTER"] = 201, ["N4"] = 108, ["N5"] = 60, ["N6"] = 107, ["N+"] = 96, ["N-"] = 97, ["N7"] = 117, ["N8"] = 61, ["N9"] = 118
}

ESX          = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

local havebike = false

Citizen.CreateThread(function()

  for _, info in pairs(Config.BlipZones) do
    info.blip = AddBlipForCoord(info.x, info.y, info.z)
    SetBlipSprite(info.blip, info.id)
    SetBlipDisplay(info.blip, 4)
    SetBlipScale(info.blip, 1.0)
    SetBlipColour(info.blip, info.colour)
    SetBlipAsShortRange(info.blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(info.title)
    EndTextCommandSetBlipName(info.blip)
  end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
        for k in pairs(Config.Zones) do
		
            DrawMarker(27, Config.Zones[k].x, Config.Zones[k].y, Config.Zones[k].z, 0, 0, 0, 0, 0, 0, 2.001, 2.0001, 0.501, 0, 255, 255, 100, 0, 0, 0, 0)
        end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
	
        for k in pairs(Config.Zones) do
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, Config.Zones[k].x, Config.Zones[k].y, Config.Zones[k].z)
            if dist <= 1.40 then
				if havebike == false then
					AddTextEntry("FREE_BIKE", _U('press_e'))
					DisplayHelpTextThisFrame("FREE_BIKE",false )
					if IsControlJustPressed(0,51) and IsPedOnFoot(PlayerPedId()) then
						Citizen.Wait(100)  
						OpenKoloMenu()
					end 
				elseif havebike == true then
					AddTextEntry("FREE_BIKE", _U('storebike')) 
					DisplayHelpTextThisFrame("FREE_BIKE",false )
					if IsControlJustPressed(0,51) then
						if IsPedOnAnyBike(PlayerPedId()) then
							Citizen.Wait(100)  
							TriggerEvent('esx:deleteVehicle')
							TriggerEvent("chatMessage", "[Bikes]", {255,255,0}, _U('bikemessage'))
							havebike = false
						else
							TriggerEvent("chatMessage", "[Bikes]", {255,255,0}, _U('notabike'))
						end
					end 		
				end
			elseif dist < 13.80 then
				ESX.UI.Menu.CloseAll()
            end
        end
    end
end)


function OpenKoloMenu()
	
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
	'default', GetCurrentResourceName(), 'VehicleMenu',
	{
		title    = _U('biketitle'),
		align    = 'bottom-right',
		elements = {
			{label = _U('bike'), value = 'kolo'},
			{label = _U('bike2'), value = 'kolo2'},
			{label = _U('bike3'), value = 'kolo3'}, 
			
		},
	},
	
	
	function(data, menu)

	if data.current.value == 'kolo' then
		TriggerEvent('esx:spawnVehicle', "tribike2")
		TriggerServerEvent("esx:lowmoney", 89) -- number = price
		ESX.UI.Menu.CloseAll()
		havebike = true	
	end
	
	if data.current.value == 'kolo2' then
		TriggerEvent('esx:spawnVehicle', "scorcher")
		TriggerServerEvent("esx:lowmoney", 99) -- number = price
		ESX.UI.Menu.CloseAll()
		havebike = true	
	end
	
	if data.current.value == 'kolo3' then
		TriggerEvent('esx:spawnVehicle', "cruiser")
		TriggerServerEvent("esx:lowmoney", 129) -- number = price
		ESX.UI.Menu.CloseAll()
		havebike = true	
	end
	

    end,
	function(data, menu)
		menu.close()
		end
	)
end
