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

	if not Config.EnableBlips then return end
	
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
        for k in pairs(Config.MarkerZones) do
            DrawMarker(Config.TypeMarker, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z, 0, 0, 0, 0, 0, 0, Config.MarkerScale[k].x, Config.MarkerScale[k].y, Config.MarkerScale[k].z, Config.MarkerColor[k].r, Config.MarkerColor[k].g, Config.MarkerColor[k].b, 100, 0, 0, 0, 0)	
		end
    end
end)


Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
	
        for k in pairs(Config.MarkerZones) do
        	local ped = PlayerPedId()
            local pedcoords = GetEntityCoords(ped, false)
            local distance = Vdist(pedcoords.x, pedcoords.y, pedcoords.z, Config.MarkerZones[k].x, Config.MarkerZones[k].y, Config.MarkerZones[k].z)
            if distance <= 1.40 then
				if havebike == false then

					helptext(_U('press_e'))
					
					if IsControlJustPressed(0, Keys['E']) and IsPedOnFoot(ped) then
						OpenBikesMenu()
					end 
				elseif havebike == true then

					helptext(_U('storebike'))

					if IsControlJustPressed(0, Keys['E']) and IsPedOnAnyBike(ped) then

						TriggerEvent('esx:deleteVehicle')
					
						if Config.EnableEffects then
							ESX.ShowNotification(_U('bikemessage'))
						else
							TriggerEvent("chatMessage", _U('bikes'), {255,255,0}, _U('bikemessage'))
						end
						havebike = false
					else
						if Config.EnableEffects then
							ESX.ShowNotification(_U('notabike'))
						else
							TriggerEvent("chatMessage", _U('bikes'), {255,255,0}, _U('notabike'))
						end
					end 		
				end
			elseif distance < 1.45 then
				ESX.UI.Menu.CloseAll()
            end
        end
    end
end)



function OpenBikesMenu()
	
	local elements = {}
	
	if Config.EnablePrice == false then
		table.insert(elements, {label = _U('bikefree'), value = 'bike'}) 
		table.insert(elements, {label = _U('bike2free'), value = 'bike2'}) 
		table.insert(elements, {label = _U('bike3free'), value = 'bike3'}) 
		table.insert(elements, {label = _U('bike4free'), value = 'bike4'}) 
	end
	
	if Config.EnablePrice == true then
		table.insert(elements, {label = _U('bike'), value = 'bike'}) 
		table.insert(elements, {label = _U('bike2'), value = 'bike2'}) 
		table.insert(elements, {label = _U('bike3'), value = 'bike3'}) 
		table.insert(elements, {label = _U('bike4'), value = 'bike4'}) 
	end
	
	
	ESX.UI.Menu.CloseAll()

	ESX.UI.Menu.Open(
    'default', GetCurrentResourceName(), 'client',
    {
		title    = _U('biketitle'),
		align    = 'bottom-right',
		elements = elements,
    },
	
	
	function(data, menu)

	if data.current.value == 'bike' then
		if Config.EnablePrice then
			TriggerServerEvent("esx:bike:lowmoney", Config.PriceTriBike) 
			TriggerEvent("chatMessage", _U('bikes'), {255,0,255}, _U('bike_pay', Config.PriceTriBike))
		end
		
		if Config.EnableEffects then
			spawn_effect("tribike2")
		else
			TriggerEvent('esx:spawnVehicle', "tribike2")
		end
	end
	
	if data.current.value == 'bike2' then
		if Config.EnablePrice then
			TriggerServerEvent("esx:bike:lowmoney", Config.PriceScorcher) 
			TriggerEvent("chatMessage", _U('bikes'), {255,0,255}, _U('bike_pay', Config.PriceScorcher))
		end
		
		if Config.EnableEffects then
			spawn_effect("scorcher")
		else
			TriggerEvent('esx:spawnVehicle', "scorcher")
		end
		
	end
	
	if data.current.value == 'bike3' then
		if Config.EnablePrice then
			TriggerServerEvent("esx:bike:lowmoney", Config.PriceCruiser) 
			TriggerEvent("chatMessage", _U('bikes'), {255,0,255}, _U('bike_pay', Config.PriceCruiser))
		end
		
		if Config.EnableEffects then
			spawn_effect("cruiser")
		else
			TriggerEvent('esx:spawnVehicle', "cruiser")
		end
	end
	
	if data.current.value == 'bike4' then
		if Config.EnablePrice then
			TriggerServerEvent("esx:bike:lowmoney", Config.PriceBmx) 
			TriggerEvent("chatMessage", _U('bikes'), {255,0,255}, _U('bike_pay', Config.PriceBmx))
		end
		
		if Config.EnableEffects then
			spawn_effect("bmx")
		else
			TriggerEvent('esx:spawnVehicle', "bmx")
		end
	end

	ESX.UI.Menu.CloseAll()
	havebike = true	
	

    end,
	function(data, menu)
		menu.close()
		end
	)
end


function helptext(text)
	SetTextComponentFormat('STRING')
	AddTextComponentString(text)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end

function spawn_effect(somecar) 
	DoScreenFadeOut(1000)
	Citizen.Wait(1000)
	TriggerEvent('esx:spawnVehicle', somecar)
	DoScreenFadeIn(3000) 
end