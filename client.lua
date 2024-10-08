ESX = exports["es_extended"]:getSharedObject()

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
  ESX.PlayerData = xPlayer
end)
RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)
RegisterNetEvent('esx:setJob2')
AddEventHandler('esx:setJob2', function(job2)
	ESX.PlayerData.job2 = job2
end)

RegisterNetEvent('Ise_Logs2')
AddEventHandler('Ise_Logs2', function(Color, Title, Description)
	TriggerServerEvent('Ise_Logs2', Color, Title, Description)
end)

RegisterNetEvent('azLogs')
AddEventHandler('azLogs', function(webhook, Color, Title, Description)
	TriggerServerEvent('azLogs', webhook, Color, Title, Description)
end)

local enableDelgun = false
local enableBlips = false
local enableName = false
local enableNoclip = false 
local PlayerData = {}
local reportlist = {}
local gamerTags = {}
local pBlips = {}
local Items = {}     
local Armes = {}   
local ArgentSale = {} 
local ArgentCash = {}
local ArgentBank = {}
local allItemsServer = {}
local allJobsServer = {}
local allGradeForJobSelected = {}
local filterArray = { "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M", "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z" }
local filter = 1
local index = 1 
local Admin = {showcoords = false}

local Action = {
    give = {"Heal", "Armor", 'Cash money','Bank money','Dirt money'}, giveIndex = 1,
    veh = {'Spawn','Réparer','Retourner','Custom Max','Changer plaque'}, vehicleIndex = 1,
    wipe = {'Complet (MortRP)','Inventaire','Armes'}, wipeIndex = 1,
    tp = {'Marker','Sur Joueur','Sur moi', 'Parking Central', 'Comissariat', "Hôpital"}, tpIndex = 1,
    sanction = {'Kick','Ban'}, punishmentIndex = 1,
    givejoueur = {'Items','Armes', "Heal"}, givePlayerIndex = 1,
    tpjoueur = {'Sur lui','Sur vous'}, tpPlayerIndex = 1,
}

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(200)

		if enableName then
			local pCoords = GetEntityCoords(GetPlayerPed(-1), false)
			for _, v in pairs(GetActivePlayers()) do
				local otherPed = GetPlayerPed(v)
                local job = ESX.PlayerData.job.name
                local job2 = ESX.PlayerData.job2.name

				if otherPed ~= pPed then
					if #(pCoords - GetEntityCoords(otherPed, false)) < 250.0 then
						gamerTags[v] = CreateFakeMpGamerTag(otherPed, (" ["..GetPlayerServerId(v).."] "..GetPlayerName(v).." \nHeal : "..GetEntityHealth(otherPed).." Armor : "..GetPedArmour(otherPed).."  \nJobs : "..job.." / "..job2), false, false, '', 0)
						SetMpGamerTagVisibility(gamerTags[v], 4, 1)
					else
						RemoveMpGamerTag(gamerTags[v])
						gamerTags[v] = nil
					end
				end
			end
		else
			for _, v in pairs(GetActivePlayers()) do
				RemoveMpGamerTag(gamerTags[v])
			end
		end
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(500)
        if enableBlips then
            local players = GetActivePlayers()
            for k,v in pairs(players) do
                local ped = GetPlayerPed(v)
                local blip = AddBlipForEntity(ped)
                table.insert(pBlips, blip)
                SetBlipScale(blip, 1.5)
                if IsPedOnAnyBike(ped) then
                    SetBlipSprite(blip, 226)
                elseif IsPedInAnyHeli(ped) then
                    SetBlipSprite(blip, 422)
                elseif IsPedInAnyPlane(ped) then
                    SetBlipSprite(blip, 307)
                elseif IsPedInAnyVehicle(ped, false) then
                    SetBlipSprite(blip, 523)
                else
                    SetBlipSprite(blip, 1)
                end

                if IsPedInAnyPoliceVehicle(ped) then
                    SetBlipSprite(blip, 56)
                    SetBlipColour(blip, 3)
                end
                SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
			end
		else
			for k,v in pairs(pBlips) do
                RemoveBlip(v)
            end
        end
    end
end)

Citizen.CreateThread(function()
    while true do
    	if Admin.showcoords then
            x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
            roundx=tonumber(string.format("%.2f",x))
            roundy=tonumber(string.format("%.2f",y))
            roundz=tonumber(string.format("%.2f",z))
            DrawTxt("~r~X:~s~ "..roundx,0.05,0.00)
            DrawTxt("     ~r~Y:~s~ "..roundy,0.11,0.00)
            DrawTxt("        ~r~Z:~s~ "..roundz,0.17,0.00)
            DrawTxt("             ~r~Angle:~s~ "..GetEntityHeading(PlayerPedId()),0.21,0.00)
        end
    	Citizen.Wait(0)
    end
end)
--==--==--==----==--==--==----==--==--==----==--==--==----==--==--==----==--==--==--

local function starts(String, Start)
    return string.sub(String, 1, string.len(Start)) == Start
end

function DrawPlayerInfo(target)
	drawTarget = target
	drawInfo = true
end

function StopDrawPlayerInfo()
	drawInfo = false
	drawTarget = 0
end

Citizen.CreateThread( function()
	while true do
		Citizen.Wait(0)
		if drawInfo then
			local text = {}
			-- cheat checks
			local targetPed = GetPlayerPed(drawTarget)
			
			table.insert(text,"[E] pour arrêter de spec.")
			
			for i,theText in pairs(text) do
				SetTextFont(0)
				SetTextProportional(1)
				SetTextScale(0.0, 0.30)
				SetTextDropshadow(0, 0, 0, 0, 255)
				SetTextEdge(1, 0, 0, 0, 255)
				SetTextDropShadow()
				SetTextOutline()
				SetTextEntry("STRING")
				AddTextComponentString(theText)
				EndTextCommandDisplayText(0.3, 0.7+(i/30))
			end
			
			if IsControlJustPressed(0,103) then
				local targetPed = PlayerPedId()
				local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
	
				RequestCollisionAtCoord(targetx,targety,targetz)
				NetworkSetInSpectatorMode(false, targetPed)
	
				StopDrawPlayerInfo()
				
			end
			
		end
	end
end)

local function getPlayerInv(player)
    
    Items = {}
    Armes = {}
    ArgentSale = {}
    ArgentCash = {}
    ArgentBank = {}

    ESX.TriggerServerCallback('adminmenu:getOtherPlayerData', function(data)

        for i=1, #data.accounts, 1 do
            if data.accounts[i].name == 'bank' and data.accounts[i].money > 0 then
                table.insert(ArgentBank, {
                    label    = ESX.Math.Round(data.accounts[i].money),
                    value    = 'bank',
                    itemType = 'item_bank',
                    amount   = data.accounts[i].money
                })

                break
            end
        end


        for i=1, #data.accounts, 1 do
            if data.accounts[i].name == 'money' and data.accounts[i].money > 0 then
                table.insert(ArgentCash, {
                    label    = ESX.Math.Round(data.accounts[i].money),
                    value    = 'money',
                    itemType = 'item_cash',
                    amount   = data.accounts[i].money
                })

                break
            end
        end

        for i=1, #data.accounts, 1 do
            if data.accounts[i].name == 'black_money' and data.accounts[i].money > 0 then
                table.insert(ArgentSale, {
                    label    = ESX.Math.Round(data.accounts[i].money),
                    value    = 'black_money',
                    itemType = 'item_account',
                    amount   = data.accounts[i].money
                })

                break
            end
        end

        for i=1, #data.weapons, 1 do
            table.insert(Armes, {
                label    = ESX.GetWeaponLabel(data.weapons[i].name),
                value    = data.weapons[i].name,
                right    = data.weapons[i].ammo,
                itemType = 'item_weapon',
                amount   = data.weapons[i].ammo
            })
        end

        for i=1, #data.inventory, 1 do
            if data.inventory[i].count > 0 then
                table.insert(Items, {
                    label    = data.inventory[i].label,
                    right    = data.inventory[i].count,
                    value    = data.inventory[i].name,
                    itemType = 'item_standard',
                    amount   = data.inventory[i].count
                })
            end
        end
    end, GetPlayerServerId(player))
end

function GetCloseVehi()
    local player = GetPlayerPed(-1)
    local vehicle = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)
    local vCoords = GetEntityCoords(vehicle)
    DrawMarker(2, vCoords.x, vCoords.y, vCoords.z + 1.3, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.5, 0.5, 0.5, 255, 255, 255, 170, 0, 1, 2, 0, nil, nil, 0)
end

function SpectatePlayer(targetPed,target,name)
    local playerPed = PlayerPedId() -- yourself
	enable = true
	if targetPed == playerPed then enable = false end

    if(enable)then
        
        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
        TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nEst entrain de spectate "..name)
        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(true, targetPed)
		DrawPlayerInfo(target)
        RageUI.Popup({message = "~g~Mode spectateur en cours"})
    else

        local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
        TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nN'est plus entrain de spectate "..name)
        RequestCollisionAtCoord(targetx,targety,targetz)
        NetworkSetInSpectatorMode(false, targetPed)
		StopDrawPlayerInfo()
        RageUI.Popup({message = "~b~Mode spectateur arrêtée"})
    end
end

function getPosition()
    local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
    return x,y,z
    end
    function getCamDirection()
        local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
        local pitch = GetGameplayCamRelativePitch()
        local x = -math.sin(heading*math.pi/180.0)
        local y = math.cos(heading*math.pi/180.0)
        local z = math.sin(pitch*math.pi/180.0)
        local len = math.sqrt(x*x+y*y+z*z)
        if len ~= 0 then
        x = x/len
        y = y/len
        z = z/len
    end
    return x,y,z
end


function KeyBoardText(TextEntry, ExampleText, MaxStringLength)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry .. ':')
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "", ExampleText, "", "", "", MaxStringLength)
    blockinput = true

    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do
        Citizen.Wait(0)
    end

    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500)
        blockinput = false
        return result
    else
        Citizen.Wait(500)
        blockinput = false
        return nil
    end
end

function admin_tp_marker()
    local playerPed = GetPlayerPed(-1)
    local WaypointHandle = GetFirstBlipInfoId(8)
        if DoesBlipExist(WaypointHandle) then
            local coord = Citizen.InvokeNative(0xFA7C7F0AADF25D09, WaypointHandle, Citizen.ResultAsVector())
            SetEntityCoordsNoOffset(playerPed, coord.x, coord.y, -199.5, false, false, false, true)
            RageUI.Popup({message = "~g~Réussis"})              
        else
        RageUI.Popup({message = "Aucun marqueur"})              
    end
end

local voituregive = {}

function give_vehi(veh)
    local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
    
    Citizen.Wait(10)
    ESX.Game.SpawnVehicle(veh, {x = plyCoords.x+2 ,y = plyCoords.y, z = plyCoords.z+2}, 313.4216, function (vehicle)
            local plate = exports.esx_vehicleshop:GeneratePlate()
            table.insert(voituregive, vehicle)		
            print(plate)
            local vehicleProps = ESX.Game.GetVehicleProperties(voituregive[#voituregive])
            vehicleProps.plate = plate
            SetVehicleNumberPlateText(voituregive[#voituregive] , plate)
			TriggerServerEvent('shop:vehicule', vehicleProps, plate)
		
	end)
end

function GiveCash()
    local amount = KeyBoardText("Somme", "", 8)

    if amount ~= nil then
        amount = tonumber(amount)
        
        if type(amount) == 'number' then
            TriggerServerEvent('azAdmin:GiveCash', amount)
            TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nGive de "..amount.." en cash effectué.")
        end
    end
end


function GiveBanque()
    local amount = KeyBoardText("Somme", "", 8)

    if amount ~= nil then
        amount = tonumber(amount)
        
        if type(amount) == 'number' then
            TriggerServerEvent('azAdmin:GiveBanque', amount)
            TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nGive de "..amount.." en banque effectué.")
        end
    end
end

function FullVehicleBoost()
	if IsPedInAnyVehicle(PlayerPedId(), false) then
		local vehicle = GetVehiclePedIsIn(PlayerPedId(), true)
		SetVehicleModKit(vehicle, 0)
		SetVehicleMod(vehicle, 14, 0, true)
		SetVehicleNumberPlateTextIndex(vehicle, 5)
		ToggleVehicleMod(vehicle, 18, true)
		SetVehicleColours(vehicle, 0, 0)
		SetVehicleCustomPrimaryColour(vehicle, 0, 0, 0)
		SetVehicleModColor_2(vehicle, 5, 0)
		SetVehicleExtraColours(vehicle, 111, 111)
		SetVehicleWindowTint(vehicle, 2)
		ToggleVehicleMod(vehicle, 22, true)
		SetVehicleMod(vehicle, 23, 11, false)
		SetVehicleMod(vehicle, 24, 11, false)
		SetVehicleWheelType(vehicle, 12) 
		SetVehicleWindowTint(vehicle, 3)
		ToggleVehicleMod(vehicle, 20, true)
		SetVehicleTyreSmokeColor(vehicle, 0, 0, 0)
		LowerConvertibleRoof(vehicle, true)
		SetVehicleIsStolen(vehicle, false)
		SetVehicleIsWanted(vehicle, false)
		SetVehicleHasBeenOwnedByPlayer(vehicle, true)
		SetVehicleNeedsToBeHotwired(vehicle, false)
		SetCanResprayVehicle(vehicle, true)
		SetPlayersLastVehicle(vehicle)
		SetVehicleFixed(vehicle)
		SetVehicleDeformationFixed(vehicle)
		SetVehicleTyresCanBurst(vehicle, false)
		SetVehicleWheelsCanBreak(vehicle, false)
		SetVehicleCanBeTargetted(vehicle, false)
		SetVehicleExplodesOnHighExplosionDamage(vehicle, false)
		SetVehicleHasStrongAxles(vehicle, true)
		SetVehicleDirtLevel(vehicle, 0)
		SetVehicleCanBeVisiblyDamaged(vehicle, false)
		IsVehicleDriveable(vehicle, true)
		SetVehicleEngineOn(vehicle, true, true)
		SetVehicleStrong(vehicle, true)
		RollDownWindow(vehicle, 0)
		RollDownWindow(vehicle, 1)
		SetVehicleNeonLightEnabled(vehicle, 0, true)
		SetVehicleNeonLightEnabled(vehicle, 1, true)
		SetVehicleNeonLightEnabled(vehicle, 2, true)
		SetVehicleNeonLightEnabled(vehicle, 3, true)
		SetVehicleNeonLightsColour(vehicle, 0, 0, 255)
		SetPedCanBeDraggedOut(PlayerPedId(), false)
		SetPedStayInVehicleWhenJacked(PlayerPedId(), true)
		SetPedRagdollOnCollision(PlayerPedId(), false)
		ResetPedVisibleDamage(PlayerPedId())
		ClearPedDecorations(PlayerPedId())
		SetIgnoreLowPriorityShockingEvents(PlayerPedId(), true)
		for i = 0,14 do
			SetVehicleExtra(veh, i, 0)
		end
		SetVehicleModKit(veh, 0)
		for i = 0,49 do
			local custom = GetNumVehicleMods(veh, i)
			for j = 1,custom do
				SetVehicleMod(veh, i, math.random(1,j), 1)
			end
		end
	end
end

function DrawTxt(text,r,z)
    SetTextColour(Config.ColorCoords_R, Config.ColorCoords_G, Config.ColorCoords_B, Config.ColorCoords_A)
    SetTextFont(0)
    SetTextProportional(1)
    SetTextScale(0.0,0.5)
    SetTextDropshadow(1,0,0,0,255)
    SetTextEdge(1,0,0,0,255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextEntry("STRING")
    AddTextComponentString(text)
    DrawText(r,z)
 end

function GiveND()
    local amount = KeyBoardText("Somme", "", 8)

    if amount ~= nil then
        amount = tonumber(amount)
        
        if type(amount) == 'number' then
            TriggerServerEvent('azAdmin:GiveND', amount)
            TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nGive de "..amount.." en argent sale effectué.")
        end
    end
end

local ServersIdSession = {}

Citizen.CreateThread(function()
    while true do
        Wait(500)
        for k,v in pairs(GetActivePlayers()) do
            local found = false
            for _,j in pairs(ServersIdSession) do
                if GetPlayerServerId(v) == j then
                    found = true
                end
            end
            if not found then
                table.insert(ServersIdSession, GetPlayerServerId(v))
            end
        end
    end
end)

function admin_mode_fantome()
    invisible = not invisible
    local ped = GetPlayerPed(-1)
    if invisible then 
        SetEntityVisible(ped, false, false)
        RageUI.Popup({message = "~g~Actif"})   
        TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA activé le mode fantome")
      else
        SetEntityVisible(ped, true, false)
        RageUI.Popup({message = "~r~Inactif"})   
        TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA désactivé le mode fantome")
    end
end


function admin_vehicle_flip()
    local player = GetPlayerPed(-1)
    posdepmenu = GetEntityCoords(player)
    carTargetDep = GetClosestVehicle(posdepmenu['x'], posdepmenu['y'], posdepmenu['z'], 10.0,0,70)
    if carTargetDep ~= nil then
    platecarTargetDep = GetVehicleNumberPlateText(carTargetDep)
    end
    local playerCoords = GetEntityCoords(GetPlayerPed(-1))
    playerCoords = playerCoords + vector3(0, 2, 0)
    SetEntityCoords(carTargetDep, playerCoords)
    RageUI.Popup({message = "~g~Réussis"})   
end


RegisterNetEvent("msg:envoyer")
AddEventHandler("msg:envoyer", function(msg)
	PlaySoundFrontend(-1, "CHARACTER_SELECT", "HUD_FRONTEND_DEFAULT_SOUNDSET", 1)
	local head = RegisterPedheadshot(PlayerPedId())
	while not IsPedheadshotReady(head) or not IsPedheadshotValid(head) do
		Wait(1)
	end
	headshot = GetPedheadshotTxdString(head)
	ESX.ShowAdvancedNotification('Message du Staff', '~r~Informations', '~r~Raison ~w~: ' ..msg, headshot, 3)
end)

function DrawPlayerInfo(target)
    drawTarget = target
    drawInfo = true
end

function StopDrawPlayerInfo()
    drawInfo = false
    drawTarget = 0
end

Citizen.CreateThread( function()
    while true do
        Citizen.Wait(0)
        if drawInfo then
            local text = {}
            -- cheat checks
            local targetPed = GetPlayerPed(drawTarget)
            
            table.insert(text,"E pour stop spectate")
            
            for i,theText in pairs(text) do
                SetTextFont(0)
                SetTextProportional(1)
                SetTextScale(0.0, 0.30)
                SetTextDropshadow(0, 0, 0, 0, 255)
                SetTextEdge(1, 0, 0, 0, 255)
                SetTextDropShadow()
                SetTextOutline()
                SetTextEntry("STRING")
                AddTextComponentString(theText)
                EndTextCommandDisplayText(0.3, 0.7+(i/30))
            end
            
            if IsControlJustPressed(0,103) then
                local targetPed = PlayerPedId()
                local targetx,targety,targetz = table.unpack(GetEntityCoords(targetPed, false))
    
                RequestCollisionAtCoord(targetx,targety,targetz)
                NetworkSetInSpectatorMode(false, targetPed)
    
                StopDrawPlayerInfo()
                
            end
            
        end
    end
end)

RegisterCommand("spect", function(source, args, rawCommand) 
    ESX.TriggerServerCallback('azAdmin:getUsergroup', function(group)
        playergroup = group
        if playergroup == 'superadmin' or playergroup == 'owner' then
            idnum = tonumber(args[1])
            local playerId = GetPlayerFromServerId(idnum)
            SpectatePlayer(GetPlayerPed(playerId),playerId,GetPlayerName(playerId))
        else
            RageUI.Popup({message = "Vous n'avez pas accès à cette commande"})  
        end
    end)
end)

-----------------------------------------

local WarnTable = {[1] = "1",[2] = "2",[3] = "3"}
WarntableNumero = {"1","2","3"}
WarnBuilder = {warnnumero = 1}
WarnData = nil
WarnIndex = 0
colorVar = "~o~"

function getDangerosityNameByInt(dangerosity)
    if WarnTable[dangerosity] ~= nil then
        return WarnTable[dangerosity]
    else
        return dangerosity
    end
end

RegisterNetEvent("warn:Get")
AddEventHandler("warn:Get", function(result)
    local found = 0
    for k,v in pairs(result) do
        found = found + 1
    end
    if found > 0 then WarnData = result end
end)

function notNilString(str)
    if str == nil then
        return ""
    else
        return str
    end
end

function OpenAdministrationMenu()

	local main = RageUI.CreateMenu(Config.MenuName, Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
	local perso = RageUI.CreateSubMenu(main, "Actions Perso", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
	local veh = RageUI.CreateSubMenu(main, "Actions Véhicules", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
	local joueurs = RageUI.CreateSubMenu(main, "Liste des joueurs", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
	local options = RageUI.CreateSubMenu(joueurs, "Actions sur joueur", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
    local warn = RageUI.CreateSubMenu(main, "Warn", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
    local warnadd = RageUI.CreateSubMenu(warn, "Warn", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
    local warninfos = RageUI.CreateSubMenu(warn, "Warn", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
    local warncheckup = RageUI.CreateSubMenu(warn, "Warn", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
    local reportliste = RageUI.CreateSubMenu(main, "Report", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
    local reportgestion = RageUI.CreateSubMenu(reportliste, "Report", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
    local fouille = RageUI.CreateSubMenu(options, "Fouille", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
    local fouilleMenuSub = RageUI.CreateSubMenu(options, "Fouille_", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
    local subitem = RageUI.CreateSubMenu(options, "Items", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
    local setjobMenu = RageUI.CreateSubMenu(options, "SetJob", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
    local setjobMenuSub = RageUI.CreateSubMenu(setjobMenu, "Set-Job", Config.SubName, Config.MenuPositionX, Config.MenuPositionY)
    ------------------------------------------------------------------------------------
    main:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    perso:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    veh:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    joueurs:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    options:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    warn:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    warnadd:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    warninfos:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    reportliste:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    reportgestion:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    fouille:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    subitem:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    warncheckup:SetRectangleBanner(Config.ColorMenuR, Config.ColorMenuG, Config.ColorMenuB, Config.ColorMenuA)
    ------------------------------------------------------------------------------------
	RageUI.Visible(main, not RageUI.Visible(main))
	while main do
		Citizen.Wait(0)
			RageUI.IsVisible(main, true, true, true, function()
                for k,v in pairs(Config.Gestionsoi) do
                    if playergroup == v then
                        RageUI.ButtonWithStyle("Gestion de soi", nil, {RightLabel = "→→"},true, function() end, perso)
                    end
                end

                for k,v in pairs(Config.Gestionsoi) do
                    if playergroup == v then
                        RageUI.ButtonWithStyle("Gestions des véhicules", nil, {RightLabel = "→→"},true, function() end, veh)
                    end
                end

                for k,v in pairs(Config.Gestionsoi) do
                    if playergroup == v then
                        RageUI.ButtonWithStyle("Gestions des joueurs ( ~o~"..GetNumberOfPlayers().."~s~ )", nil, { RightLabel = "→→" },true, function()
						end, joueurs)
                    end
                end

                for k,v in pairs(Config.Gestionsoi) do
                    if playergroup == v then
                        RageUI.ButtonWithStyle("Gestions des reports ( ~o~"..#reportlist.."~s~ )", nil, { RightLabel = "→→" },true, function(_,_,s)
						end, reportliste)
                    end
                end

                for k,v in pairs(Config.Gestionsoi) do
                    if playergroup == v then
                        RageUI.ButtonWithStyle("Gestions des warns", nil, { RightLabel = "→→" },true, function()
						end, warn)
                    end
                end
            end, function() end)


                      RageUI.IsVisible(perso, true, true, true, function()

                        RageUI.List('Téléportation', Action.tp, Action.listi, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)
                            if (Selected) then 
                                if Index == 1 then
                                admin_tp_marker()
                            elseif Index == 2 then
                                local IdSelected = KeyBoardText("ID?", "", 8)
                                if IdSelected ~= nil then
                                    IdSelected = tonumber(IdSelected)
                                    if type(IdSelected) == 'number' then
                                SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(IdSelected))))
                                RageUI.Popup({message = '~b~Vous venez de vous Téléporter à~s~ '.. GetPlayerName(GetPlayerFromServerId(IdSelected)) ..''})  
                            else
                                RageUI.Popup({message = "ID Invalide"})  

                                    end
                                end
                            elseif Index == 3 then
                                local IdSelected = KeyBoardText("ID?", "", 8)
                                if IdSelected ~= nil then
                                    IdSelected = tonumber(IdSelected)
                                    if type(IdSelected) == 'number' then
                                ExecuteCommand("bring "..IdSelected)
                                RageUI.Popup({message = '~b~Vous venez de Téléporter ~s~ '.. GetPlayerName(GetPlayerFromServerId(IdSelected)) ..' ~b~à vous~s~ !'}) 
                                    else
                                        RageUI.Popup({message = "ID Invalide"}) 
                                    end
                                end   
                            elseif Index == 4 then
                            local ped = GetPlayerPed(-1)            
                            SetEntityCoords(ped, Config.TeleportOptions.Parking.position.x, Config.TeleportOptions.Parking.position.y, Config.TeleportOptions.Parking.position.z, false, false, false, false)
                            elseif Index == 5 then
                            local ped = GetPlayerPed(-1)              
                            SetEntityCoords(ped, Config.TeleportOptions.Comissariat.position.x, Config.TeleportOptions.Comissariat.position.y, Config.TeleportOptions.Comissariat.position.z, false, false, false, false) 
                            elseif Index == 6 then
                            local ped = GetPlayerPed(-1)              
                            SetEntityCoords(ped, Config.TeleportOptions.Hopital.position.x, Config.TeleportOptions.Hopital.position.y, Config.TeleportOptions.Hopital.position.z, false, false, false, false)
                                end
                            end
                        Action.tpIndex = Index;              
                        end)

                        RageUI.ButtonWithStyle("NoClip", nil, {RightLabel = ""}, true, function(Hovered, Active, Selected)
                            if Selected then
                                enableNoclip = not enableNoclip
                                news_no_clip()
                            end
                        end)

                        RageUI.ButtonWithStyle("Give véhicule (avec clé)", nil, {}, true, function(_, _, Selected)
                            if Selected then
                
                                local ped = GetPlayerPed(tgt)
                                local ModelName = KeyBoardText("Véhicule", "", 100)
                
                                if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
                                    RequestModel(ModelName)
                                    while not HasModelLoaded(ModelName) do
                                        Citizen.Wait(0)
                                    end
                                        --local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(GetPlayerPed(-1)), GetEntityHeading(GetPlayerPed(-1)), true, true)
                                        --TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                                        give_vehi(ModelName)
                                        Wait(50)
                                else
                                    ShowNotification("Erreur !")
                                end
                            end
                            end)

                    RageUI.Checkbox("Delgun", nil, delguncheck,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            delguncheck = Checked
                            if Checked then
                                RageUI.Popup({message = "~g~Delgun Actif"}) 
                                enableDelgun = true 
                                giveDelgun()
                                TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nDelgun Actif")
                            else
                                RageUI.Popup({message = "~r~Delgun Inactif"}) 
                                enableDelgun = false 
                                removeDelgun()
                                TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nDelgun Inactif")
                            end
                        end
                    end)

                    RageUI.Checkbox("Afficher/Cacher coordonnées", description, afficherco,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            afficherco = Checked
                            if Checked then
                                Admin.showcoords = true
                            else
                                Admin.showcoords = false
                            end
                        end
                    end)

                    RageUI.Checkbox("Afficher les Noms", description, affichername,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            affichername = Checked
                            if Checked then
                                enableName = true
                                TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nNoms Actif")
                            else
                                enableName = false
                                TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nNoms Inactif")
                            end
                        end
                    end)

                    RageUI.Checkbox("Afficher les Blips", description, afficherblips,{},function(Hovered,Ative,Selected,Checked)
                        if Selected then
                            afficherblips = Checked
                            if Checked then
                                enableBlips = true
                                TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nBlips Actif")
                            else
                                enableBlips = false
                                TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nBlips Inactif")
                            end
                        end
                    end)

                    RageUI.Checkbox("GodMod",nil, checkbox2,{},function(Hovered,Active,Selected,Checked)
                        if Selected then
                            checkbox2 = Checked
                            if Checked then
                                Checked = true
                                local ped = GetPlayerPed(-1)
                                SetEntityInvincible(ped, true)
                                RageUI.Popup({message = "~g~Actif"}) 
                                TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA activé le godmod")
                            else
                                local ped = GetPlayerPed(-1)
                                SetEntityInvincible(ped, false)
                                RageUI.Popup({message = "~r~Inactif"}) 
                                TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA désactivé le godmod")
                            end
                        end
                    end)

                    RageUI.Checkbox("Invisible",nil, checkbox3,{},function(Hovered,Active,Selected,Checked)
                        if Selected then
                            checkbox3 = Checked
                            if Checked then
                                Checked = true
                                admin_mode_fantome()
                            else
                                admin_mode_fantome()
                            end
                        end
                    end)
                    

                    RageUI.List('Give', Action.give, Action.giveIndex, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)
                        if (Selected) then 
                            if Index == 1 then
                            SetEntityHealth(GetPlayerPed(-1), 200)
                            TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nHeal effectué")
                        elseif Index == 2 then
                            SetPedArmour(GetPlayerPed(-1), 200)
                            TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nGive armure effectué")
                        elseif Index == 3 then
                            GiveCash()
                        elseif Index == 4 then
                            GiveBanque()
                        elseif Index == 5 then
                            GiveND()
                            end
                        end
                        Action.giveIndex = Index;              
                        end)

                        end, function()
                        end)

                        RageUI.IsVisible(veh, true, true, true, function()

                            RageUI.Separator("~r~Le plus proche")
                            

                            RageUI.ButtonWithStyle("Supprimer le véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                                if (Active) then
                                    GetCloseVehi()
                                end
                                if (Selected) then
                                    Citizen.CreateThread(function()
                                        local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)
                                        NetworkRequestControlOfEntity(veh)
                                        while not NetworkHasControlOfEntity(veh) do
                                            Wait(1)
                                        end
                                        DeleteEntity(veh)
                                        RageUI.Popup({message = "~g~Véhicule supprimé",sound = {audio_name = "BASE_JUMP_PASSED",audio_ref = "HUD_AWARDS",}})
                                    end)
                                end
                            end)
                            
                            RageUI.ButtonWithStyle("Réparer le véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                                if (Active) then
                                    GetCloseVehi()
                                end
                                if (Selected) then
                                    local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)
                                    NetworkRequestControlOfEntity(veh)
                                    while not NetworkHasControlOfEntity(veh) do
                                        Wait(1)
                                    end
                                    SetVehicleFixed(veh)
                                    SetVehicleDeformationFixed(veh)
                                    SetVehicleDirtLevel(veh, 0.0)
                                    SetVehicleEngineHealth(veh, 1000.0)
                                    RageUI.Popup({message = "~g~Véhicule réparé",sound = {audio_name = "BASE_JUMP_PASSED",audio_ref = "HUD_AWARDS",}})
                                end
                            end)
            
                            RageUI.ButtonWithStyle("Custom au max", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                                if (Active) then
                                    GetCloseVehi()
                                end
                                if (Selected) then
                                   -- local veh = GetClosestVehicle(GetEntityCoords(GetPlayerPed(-1)), nil)
                                    local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)
                                    NetworkRequestControlOfEntity(veh)
                                    while not NetworkHasControlOfEntity(veh) do
                                        Wait(1)
                                    end
                                    ESX.Game.SetVehicleProperties(veh, {
                                        modEngine = 3,
                                        modBrakes = 3,
                                        modTransmission = 3,
                                        modSuspension = 3,
                                        modTurbo = true
                                    })
                                RageUI.Popup({message = "~g~Véhicule amélioré",sound = {audio_name = "BASE_JUMP_PASSED",audio_ref = "HUD_AWARDS",}})
                                TriggerEvent('Ise_Logs2', 15158332, "Amélioration", "Nom : "..GetPlayerName(PlayerId())..".\na améliorer au max le véhicule le plus proche")
                                end
                            end)

                            RageUI.ButtonWithStyle("Tp dans véhicule", nil, { RightLabel = "→→" }, true, function(Hovered, Active, Selected)
                                if (Active) then
                                    GetCloseVehi()
                                end
                                if (Selected) then
                                    local veh = GetClosestVehicle(GetEntityCoords(PlayerPedId()), 15.0, 0, 70)
                                    NetworkRequestControlOfEntity(veh)
                                    while not NetworkHasControlOfEntity(veh) do
                                        Wait(1)
                                    end

                                    SetPedIntoVehicle(PlayerPedId(), veh, -1)

                                    RageUI.Popup({message = "~g~Téléportation efféctué",sound = {audio_name = "BASE_JUMP_PASSED",audio_ref = "HUD_AWARDS",}})
                                end
                            end)

                            RageUI.Separator("~r~Dans véhicule")

                            RageUI.List('Self options ', Action.veh, Action.liste, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)
                                if (Selected) then 
                                    if Index == 1 then
                                        local ped = GetPlayerPed(tgt)
                                        local ModelName = KeyBoardText("Véhicule", "", 100)
                                        if ModelName and IsModelValid(ModelName) and IsModelAVehicle(ModelName) then
                                        RequestModel(ModelName)
                                        while not HasModelLoaded(ModelName) do
                                        Citizen.Wait(0)
                                    end
                                    local veh = CreateVehicle(GetHashKey(ModelName), GetEntityCoords(GetPlayerPed(-1)), GetEntityHeading(GetPlayerPed(-1)), true, true)
                                        TaskWarpPedIntoVehicle(GetPlayerPed(-1), veh, -1)
                                        Wait(50)
                                    else
                                     --   RageUI.Popup("~r~Vehicule invalide !")
                                    end
                                    elseif Index == 2 then
                                    if IsPedInAnyVehicle(GetPlayerPed(-1), false) then
                                        vehicle = GetVehiclePedIsIn(GetPlayerPed(-1), false)
                                        if DoesEntityExist(vehicle) then
                                        SetVehicleFixed(vehicle)
                                        SetVehicleDeformationFixed(vehicle)
                                        TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA réparé sa voiture")
                                        end
                                    end
                                    elseif Index == 3 then
                                        admin_vehicle_flip()
                                    elseif Index == 4 then
                                        FullVehicleBoost()
                                        TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA custom au max sa voiture")
                                    elseif Index == 5 then
                                        if IsPedSittingInAnyVehicle(GetPlayerPed(-1)) then
                                            local plaqueVehicule = KeyBoardText("Plaque", "", 8)
                                            SetVehicleNumberPlateText(GetVehiclePedIsIn(GetPlayerPed(-1), false) , plaqueVehicule)
                                            RageUI.Popup({message = "La plaque du véhicule est désormais : ~g~"..plaqueVehicule}) 
                                            TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nA changé la plaque de sa voiture par "..plaqueVehicule)
                                        else
                                            RageUI.Popup({message = "~r~Erreur\n~s~Vous n'êtes pas dans un véhicule !"})
                                        end
                                        end
                                    end
                                    Action.vehicleIndex = Index;              
                                    end)

                            end, function()
                            end)


			        RageUI.IsVisible(joueurs, true, true, true, function()

                        for k,v in ipairs(ServersIdSession) do

                            if GetPlayerName(GetPlayerFromServerId(v)) == "**Invalid**" then 
                                table.remove(ServersIdSession, k) 
                            end

                            RageUI.ButtonWithStyle(GetPlayerName(GetPlayerFromServerId(v)), nil, {RightLabel = "[~r~"..v.."~s~] →"}, true, function(Hovered, Active, Selected)
                                if (Selected) then
                                    IdSelected = v
                                end
                            end, options)

                        end
        
                end, function()
                end)
            

                RageUI.IsVisible(options, true, true, true, function()

                RageUI.Separator("~r~Joueur ~s~: ~o~"..GetPlayerName(GetPlayerFromServerId(IdSelected)) .. "~s~ | ~r~ID ~s~: ~o~"..IdSelected)

                for k,v in ipairs(ServersIdSession) do

                    if GetPlayerName(GetPlayerFromServerId(v)) == "**Invalid**" then 
                        table.remove(ServersIdSession, k) 
                    end
                end

                RageUI.ButtonWithStyle("Envoyer un message", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        local msg = KeyBoardText("Raison", "", 100)

                        if msg ~= nil then
                            msg = tostring(msg)
                    
                            if type(msg) == 'string' then
                                TriggerServerEvent("msg:Message", IdSelected, msg)
                            end
                        end
                        RageUI.Popup({message = "Vous venez d'envoyer le message à ~b~" .. GetPlayerName(GetPlayerFromServerId(IdSelected))})
                    end
                end)

                RageUI.ButtonWithStyle("Ouvrir l'inventaire", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        getPlayerInv(GetPlayerFromServerId(IdSelected))
                    end
                end, fouille)

                RageUI.ButtonWithStyle("Blacklist", nil, {RightLabel = nil}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                        local msg = KeyBoardText("Raison", "", 100)

                        if msg ~= nil then
                            msg = tostring(msg)
                    
                            if type(msg) == 'string' then
                                TriggerServerEvent("msg:Message", IdSelected, msg)
                            end
                        end
                        blacklist(IdSelected)

                        RageUI.Popup({message = "Vous venez de blacklist ~b~" .. GetPlayerName(GetPlayerFromServerId(IdSelected))})
                        
                    end
                end)

                RageUI.ButtonWithStyle("Spectate", nil, {}, true, function(Hovered, Active, Selected)
                    if (Selected) then
                    local playerId = GetPlayerFromServerId(IdSelected)
                        SpectatePlayer(GetPlayerPed(playerId),playerId,GetPlayerName(playerId))
                    end
                end)

                RageUI.ButtonWithStyle("SetJob", nil, {}, true, function(Hovered, Active, Selected)
                end, setjobMenu)
            
                RageUI.Checkbox("Freeze / Defreeze", description, Frigo,{},function(Hovered,Ative,Selected,Checked)
                    if Selected then
                        Frigo = Checked
                        if Checked then
                            RageUI.Popup({message = "~r~Joueur Freeze ("..GetPlayerName(GetPlayerFromServerId(IdSelected))..")"})
                            ExecuteCommand("freeze "..IdSelected)
                            TriggerEvent('Ise_Logs2', 15158332, "Freeze", "Nom : "..GetPlayerName(PlayerId())..".\na freeze ".. GetPlayerName(GetPlayerFromServerId(IdSelected)))

                        else
                            RageUI.Popup({message = "~g~Joueur Defreeze ("..GetPlayerName(GetPlayerFromServerId(IdSelected))..")"})
                            ExecuteCommand("unfreeze "..IdSelected)
                            TriggerEvent('Ise_Logs2', 15158332, "Freeze", "Nom : "..GetPlayerName(PlayerId())..".\na Unfreeze ".. GetPlayerName(GetPlayerFromServerId(IdSelected)))
                        end
                    end
                end)

                RageUI.List('Téléporter : ', Action.tpjoueur, Action.tpPlayerIndex, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)
                    if (Selected) then 
                        if Index == 1 then
                        SetEntityCoords(PlayerPedId(), GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(IdSelected))))
                        RageUI.Popup({message = '~b~Vous venez de vous Téléporter à~s~ '.. GetPlayerName(GetPlayerFromServerId(IdSelected)) ..''})
                         --   TriggerEvent('Ise_Logs2', 3447003, "STAFF", "Nom : "..GetPlayerName(PlayerId())..".\nC'est téléporté sur "..GetPlayerName(GetPlayerFromServerId(IdSelected)))
                    elseif Index == 2 then
                        ExecuteCommand("bring "..IdSelected)
                        RageUI.Popup({message = '~b~Vous venez de Téléporter ~s~ '.. GetPlayerName(GetPlayerFromServerId(IdSelected)) ..' ~b~à vous~s~ !'})
                    end
                end
                    Action.tpPlayerIndex = Index;              
                end)

                RageUI.List('Wipe : ', Action.wipe, Action.wipeIndex, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)
                    if (Selected) then 
                        if Index == 1 then
                        TriggerServerEvent('whipezebi', IdSelected)
                    elseif Index == 2 then
                        ExecuteCommand("clearinventory "..IdSelected)
                        RageUI.Popup({message = "Vous venez d'enlever tout les items de ~b~".. GetPlayerName(GetPlayerFromServerId(IdSelected)) .."~s~ !"})
                        TriggerEvent('Ise_Logs2', 15158332, "Suppresion", "Nom : "..GetPlayerName(PlayerId())..".\na supprimer les items de "..GetPlayerName(GetPlayerFromServerId(IdSelected)))
                    elseif Index == 3 then
                        ExecuteCommand("clearloadout "..IdSelected)
                        RageUI.Popup({message = "Vous venez de enlever toutes les armes de ~b~".. GetPlayerName(GetPlayerFromServerId(IdSelected)) .."~s~ !"})
                        TriggerEvent('Ise_Logs2', 15158332, "Suppresion", "Nom : "..GetPlayerName(PlayerId())..".\na supprimer les armes de "..GetPlayerName(GetPlayerFromServerId(IdSelected)))
                    end
                end
                    Action.wipeIndex = Index;              
                end)

                RageUI.List('Give : ', Action.givejoueur, Action.givePlayerIndex, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)
                    if (Selected) then 
                        if Index == 1 then
                        RageUI.Visible(subitem, not RageUI.Visible(subitem))	
                    elseif Index == 2 then
                        local weapon = KeyBoardText("WEAPON_...", "", 100)
                        local ammo = KeyBoardText("Munitions", "", 100)
                        if weapon and ammo then
                            ExecuteCommand("giveweapon "..IdSelected.. " " ..weapon.. " " ..ammo)
                            RageUI.Popup({message = "Vous venez de donner ~g~"..weapon.. " avec " .. ammo .. " munitions ~w~à " .. GetPlayerName(GetPlayerFromServerId(IdSelected))})
                            TriggerEvent('Ise_Logs2', 15158332, "Give Weapon", "Nom : "..GetPlayerName(PlayerId())..".\na donner "..weapon.." avec ".. ammo .." munitions à ".. GetPlayerName(GetPlayerFromServerId(IdSelected)))

                        else
                            RageUI.CloseAll()	
                        end
                    elseif Index == 3 then
                        ExecuteCommand("heal "..IdSelected)
                        TriggerEvent('Ise_Logs2', 15158332, "Give Heal", "Nom : "..GetPlayerName(PlayerId())..".\na heal "..GetPlayerName(GetPlayerFromServerId(IdSelected)))
                    end
                    end
                    Action.givePlayerIndex = Index;              
                    end)

                RageUI.List('Sanctions : ', Action.sanction, Action.punishmentIndex, nil, {RightLabel = ""}, true, function(Hovered, Active, Selected, Index)
                    if (Selected) then 
                        if Index == 1 then
                        local raison = KeyBoardText("Raison du kick", "", 100)
                        TriggerServerEvent('azAdmin:kickjoueur', IdSelected, raison)
                        TriggerEvent('Ise_Logs2', 15158332, "Warn", "Nom : "..GetPlayerName(PlayerId())..".\nà mis un warn à "..WarnBuilder.firstname.." "..WarnBuilder.lastname.." Pour " ..WarnBuilder.reason)
                    elseif Index == 2 then
                        local quelid = KeyBoardText("ID", "", 100)
                        local day = KeyBoardText("Jours", "", 100)
                        local raison = KeyBoardText("Raison du ban", "", 100)
                        if quelid and day and raison then
                            ExecuteCommand("sqlban "..quelid.. " " ..day.. " " ..raison)
                            ERageUI.Popup({message = "Vous venez de ban l\'ID :"..quelid.. " " ..day.. " pour la raison suivante : " ..raison})
                            TriggerEvent('Ise_Logs2', 15158332, "Ban", "Nom : "..GetPlayerName(PlayerId())..".\na ban ".. GetPlayerName(GetPlayerFromServerId(quelid)))
                        else
                            RageUI.CloseAll()	
                        end
                    end
                end
                    Action.punishmentIndex = Index;              
                end)

            
            end, function() 
            end)

                RageUI.IsVisible(subitem, true, true, true, function()

                RageUI.List("Filtre:", filterArray, filter, nil, {}, true, function(_, _, _, i)
                    filter = i
                end)


                RageUI.Separator("↓ ~g~Items disponibles ~s~↓")
                for id, itemInfos in pairs(allItemsServer) do
                    if starts(itemInfos.label:lower(), filterArray[filter]:lower()) then
                        RageUI.ButtonWithStyle("~b~→~s~ " .. itemInfos.label, nil, { RightLabel = "~b~Donner ~s~→→" }, true, function(_, _, s)
                            if s then
                                local qty = KeyBoardText("Quantité", "", 20)
                                if qty ~= nil then
                                    ESX.ShowNotification("~y~Give de l'item...")
                                    TriggerServerEvent("azAdmin:giveItem", IdSelected, itemInfos.name, qty)
                                    TriggerEvent('Ise_Logs2', 15158332, "Give Items", "Nom : "..GetPlayerName(PlayerId())..".\na donner "..itemInfos.name.." x "..qty.." à ".. GetPlayerName(GetPlayerFromServerId(IdSelected)))

                                end
                            end
                        end)
                    end
                end
            
        end, function()
        end)

        RageUI.IsVisible(setjobMenu, true, true, true, function()


            RageUI.Separator("↓ ~g~Jobs disponibles ~s~↓")

        for k,v in pairs(allJobsServer) do


            RageUI.ButtonWithStyle(v.LabelSociety, nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                   nameSo = v.NameSociety
                   LabelSo = v.LabelSociety
                   ESX.TriggerServerCallback('azAdmin:getAllGrade', function(allGrade)
                    allGradeForJobSelected = allGrade
                   end, v.NameSociety)
                end
            end, setjobMenuSub)

        end


        
        end, function()
        end)

        RageUI.IsVisible(setjobMenuSub, true, true, true, function()


            RageUI.Separator("~y~Job sélectionner : "..LabelSo)

        for k,v in pairs(allGradeForJobSelected) do


            RageUI.ButtonWithStyle(v.gradeLabel, nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                   ESX.ShowNotification("~g~Setjob effectuer !")
                   ExecuteCommand("setjob "..IdSelected.." "..nameSo.." "..v.gradeJob)
                end
            end)

        end


        
        end, function()
        end)

        RageUI.IsVisible(warn, true, true, true, function()

            RageUI.ButtonWithStyle("Consulter la base de données", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
                if Selected then
                WarnData = nil
                TriggerServerEvent("warn:Get")
                end
            end, warninfos)

            RageUI.ButtonWithStyle("Ajouter à la base de données", nil, {RightLabel = "→"}, true, function(Hovered, Active, Selected)
            end, warnadd)

        end, function()
        end)

        RageUI.IsVisible(warnadd, true, true, true, function()

            RageUI.ButtonWithStyle("Prénom : ~s~"..notNilString(WarnBuilder.firstname), "~r~Prénom : ~s~"..notNilString(WarnBuilder.firstname), { RightLabel = "→" }, true, function(_,_,s)
                if s then
                    WarnBuilder.firstname = KeyBoardText("Prénom", "", 10)
                end
            end)
    
            RageUI.ButtonWithStyle("Nom : ~s~"..notNilString(WarnBuilder.lastname), "~r~Nom : ~s~"..notNilString(WarnBuilder.lastname), { RightLabel = "→" }, true, function(_,_,s)
                if s then
                    WarnBuilder.lastname = KeyBoardText("Nom", "", 10)
                end
            end)

            RageUI.ButtonWithStyle("Steam : ~s~"..notNilString(WarnBuilder.steam), "~r~Nom : ~s~"..notNilString(WarnBuilder.steam), { RightLabel = "→" }, true, function(_,_,s)
                if s then
                    WarnBuilder.steam = KeyBoardText("Nom", "", 10)
                end
            end)
    
            RageUI.List("Warn N°", WarntableNumero, WarnBuilder.warnnumero, "~r~Avertissement N° : ~s~"..notNilString(WarnBuilder.warnnumero), {}, true, function(Hovered, Active, Selected, Index)
                WarnBuilder.warnnumero = Index
            end)

            RageUI.ButtonWithStyle("Motif :", "~r~Motif : ~s~"..notNilString(WarnBuilder.reason), { RightLabel = "→" }, true, function(_,_,s)
                if s then
                    WarnBuilder.reason = KeyBoardText("Raison", "", 100)
                end
            end)
    
            RageUI.ButtonWithStyle("~g~Sauvegarder et envoyer", "~r~Motif : ~s~"..notNilString(WarnBuilder.reason), { RightLabel = "→→" }, WarnBuilder.firstname ~= nil and WarnBuilder.lastname ~= nil and WarnBuilder.reason ~= nil, function(_,_,s)
                if s then
                    TriggerEvent('Ise_Logs2', 15158332, "Warn", "Nom : "..GetPlayerName(PlayerId())..".\nà mis un warn à "..WarnBuilder.firstname.." "..WarnBuilder.lastname.." Pour " ..WarnBuilder.reason)
                    RageUI.GoBack()
                    TriggerServerEvent("warn:Add", WarnBuilder)
                    WarnBuilder = {warnnumero = 1}
                    RageUI.Popup({message = "Warn ajouté à la base de données..."})
                end
            end)

        end, function()
        end)
    
        RageUI.IsVisible(warninfos, true, true, true, function()
          
        if WarnData == nil then
            RageUI.Separator("~r~Aucun Warn")
        else

            for index,adr in pairs(WarnData) do
                RageUI.ButtonWithStyle("[~o~Warn N°"..adr.warnnumero.."~s~] ~s~"..adr.firstname.." "..adr.lastname, nil, { RightLabel = "~o~Consulter ~s~→→" }, true, function(_,_,s)
                    if s then
                        WarnIndex = index
                    end
                end, warncheckup)
            end
            
        end

        end, function()
        end)

        RageUI.IsVisible(warncheckup, true, true, true, function()

            RageUI.Separator("~b~Par Staff : ~s~"..WarnData[WarnIndex].author)
            RageUI.Separator("~b~Le : ~s~"..WarnData[WarnIndex].date)
            RageUI.Separator("↓ ~o~Informations ~s~↓")

            RageUI.ButtonWithStyle("~o~Prénom/Nom : ~s~"..WarnData[WarnIndex].firstname.." "..WarnData[WarnIndex].lastname, nil, {}, true, function()end)
            RageUI.ButtonWithStyle("~r~Steam: ~s~"..WarnData[WarnIndex].steam, nil, {}, true, function()end)
            RageUI.ButtonWithStyle("~r~Raison: ~s~"..WarnData[WarnIndex].reason, nil, {}, true, function()end)
            RageUI.ButtonWithStyle("~r~Warn N°: ~s~"..getDangerosityNameByInt(WarnData[WarnIndex].warnnumero), nil, {}, true, function()end)
    
                RageUI.Separator("↓ ~o~Actions ~s~↓")

                RageUI.ButtonWithStyle("~o~Modifier le warn", "Soon in VIP >> patreon.com/space-dev", {RightBadge = RageUI.BadgeStyle.Lock}, true, function(_,_,s)
                end)

                if playergroup == "superadmin" or playergroup == "owner" then 
                RageUI.ButtonWithStyle("~r~Supprimer le warn", nil, {RightLabel = "→→"}, true, function(_,_,s)
                    if s then
                        RageUI.GoBack()
                        TriggerServerEvent("warn:Delete", WarnIndex)
                        RageUI.Popup({message = "Warn retiré de la base de données..."})
                        TriggerEvent('Ise_Logs2', 15158332, "Warn", "Nom : "..GetPlayerName(PlayerId())..".\nà supprimer le warn de "..WarnData[WarnIndex].firstname.." "..WarnData[WarnIndex].lastname)
                        
                    end
                end)
            else
                RageUI.ButtonWithStyle("~r~Supprimer le warn", "Superadmin Uniquement", {RightBadge = RageUI.BadgeStyle.Lock}, false, function(_,_,s)
                end)
            end
    
        end, function()    
        end)

        RageUI.IsVisible(reportliste, true, true, true, function()
			
            if #reportlist >= 1 then
                RageUI.Separator("↓ Nouveaux Report ↓")

                for k,v in pairs(reportlist) do
                    RageUI.ButtonWithStyle(k.." - Report de [~o~"..v.nomDuMec.."~s~] | Id : [~p~"..v.srcDuMec.."~s~]", nil, {RightLabel = "→→"},true , function(_,_,s)
                        if s then
                            nom = v.nomDuMec
                            nbreport = k
                            id = v.srcDuMec
                            raison = v.raisonDuReport
                        end
                    end, reportgestion)
                end
            else
                RageUI.Separator("~o~Aucun Report~s~")
            end
      
     end, function()
      end)
      
            RageUI.IsVisible(reportgestion, true, true, true, function()

                RageUI.Separator("Report numéro : ~o~"..nbreport)
                RageUI.Separator("Auteur : ~o~"..nom.."~s~ [~o~"..id.."~s~]")
                RageUI.Separator("Raison du report : ~o~"..raison)

            RageUI.ButtonWithStyle("Se téléporter", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    ExecuteCommand("goto "..id)
                end
            end)

            RageUI.ButtonWithStyle("Se téléporter en noclip", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    ExecuteCommand("goto "..id)
                    news_no_clip()
                end
            end)

            RageUI.ButtonWithStyle("Le téléporter", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    ExecuteCommand("bring "..id)
                end
            end)

            RageUI.ButtonWithStyle("Spectate", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    ExecuteCommand("spect "..id)
                end
            end)

            RageUI.Checkbox("Freeze / Defreeze", description, Frigo,{},function(Hovered,Ative,Selected,Checked)
                if Selected then
                    Frigo = Checked
                    if Checked then
                        ExecuteCommand("freeze "..id)
                        RageUI.Popup({message = "~r~Joueur Freeze"})
                        TriggerEvent('Ise_Logs2', 15158332, "Freeze", "Nom : "..GetPlayerName(PlayerId())..".\na freeze ".. GetPlayerName(GetPlayerFromServerId(id)))
                    else
                        ExecuteCommand("unfreeze "..id)
                        RageUI.Popup({message = "~g~Joueur Defreeze"})
                        TriggerEvent('Ise_Logs2', 15158332, "Freeze", "Nom : "..GetPlayerName(PlayerId())..".\na Unfreeze ".. GetPlayerName(GetPlayerFromServerId(id)))
                    end
                end
            end)

            RageUI.ButtonWithStyle("~r~Supprimer le report", nil, {}, true, function(Hovered, Active, Selected)
                if (Selected) then
                    TriggerServerEvent('azAdmin:closeReport', nom, raison)
                    RageUI.CloseAll()
                end
            end)
      

            end, function()
            end)

            RageUI.IsVisible(fouille, true, false, true, function()


                RageUI.Separator("~r~Inventaire de "..GetPlayerName(GetPlayerFromServerId(IdSelected)))
                local closestPlayer, closestDistance = ESX.Game.GetClosestPlayer()

                RageUI.Separator("↓ ~g~Money ~s~↓")

                for k,v  in pairs(ArgentBank) do
                    RageUI.ButtonWithStyle("Bank's money :", nil, {RightLabel = v.label.."$"}, true, function(_, _, s)
                    end, fouilleMenuSub)
                end
    
                for k,v  in pairs(ArgentCash) do
                    RageUI.ButtonWithStyle("Cash :", nil, {RightLabel = v.label.."$"}, true, function(_, _, s)
                    end)
                end
    
                for k,v  in pairs(ArgentSale) do
                    RageUI.ButtonWithStyle("Black money :", nil, {RightLabel = v.label.."$"}, true, function(_, _, s)
                    end)
                end
                
                RageUI.Separator("↓ ~r~Items ~s~↓")
                if #Items == 0 then
                    RageUI.Separator("No items")
                end

                for k, v in pairs(Items) do
                    RageUI.ButtonWithStyle(v.label.. " [~r~"..v.right.. "~s~]", nil, {RightLabel = "Delete"}, true, function(_, _, s)
                        if s then
                            ESX.TriggerServerCallback('azAdmin:deleteItem', function()
                                ESX.ShowNotification("Item deleted")
                                RageUI.GoBack()
                            end, v.value, 1)
                        end
                    end)
                end
                
                RageUI.Separator("↓ ~o~Weapons ~s~↓")

                if #Armes == 0 then
                    RageUI.Separator("No weapons")
                end

                for k,v  in pairs(Armes) do
                    RageUI.ButtonWithStyle(v.label.. " [~r~"..v.right.. "~s~] balles", nil, {}, true, function(_, _, s)
                    end)
                end
                end, function() 
            end)

        if not RageUI.Visible(main) and not RageUI.Visible(perso) and not RageUI.Visible(veh) and not RageUI.Visible(joueurs) and not RageUI.Visible(options) and not RageUI.Visible(ped) and not RageUI.Visible(warn) and not RageUI.Visible(warnadd) and not RageUI.Visible(warninfos) and not RageUI.Visible(reportliste) and not RageUI.Visible(reportgestion) and not RageUI.Visible(fouille) and not RageUI.Visible(subitem) and not RageUI.Visible(setjobMenu) and not RageUI.Visible(setjobMenuSub) and not RageUI.Visible(warncheckup) then
            main = RMenu:DeleteType(main, true)
        end
    end
end

function tcheckmoisa()
    ESX.TriggerServerCallback('azAdmin:getAllReport', function(info)
        reportlist = info
    end)

    ESX.TriggerServerCallback('azAdmin:getAllItems', function(allItems)
        allItemsServer = allItems
    end)

    ESX.TriggerServerCallback('azAdmin:getAllJobs', function(allJobs)
        allJobsServer = allJobs
    end)
end

function giveWeapon(hashKey) -- give weapon
    
end

function weaponComponent(weaponHash, component) -- give component
    GiveWeaponComponentToPed(GetPlayerPed(), GetHashKey(weaponHash), GetHashKey(component))
end

function giveDelgun() -- give delgun to ped
    delgun = "weapon_snspistol_mk2"
    GiveWeaponToPed(GetPlayerPed(), GetHashKey(delgun), 250, false, false)
    weaponComponent(delgun, "COMPONENT_SNS_PISTOL_MK2_CAMO_IND_01_SLIDE")
    weaponComponent(delgun, "COMPONENT_AT_PI_SUPP_02")
    weaponComponent(delgun, "COMPONENT_SNSPISTOL_MK2_CLIP_02")
    weaponComponent(delgun, "COMPONENT_AT_PI_RAIL_02")
    weaponComponent(delgun, "COMPONENT_AT_PI_FLSH_03")
    SetPedInfiniteAmmo(GetPlayerPed(), true, delgun)
    SetCurrentPedWeapon(GetPlayerPed(), GetHashKey(delgun), true)
end

function removeDelgun() -- remove delgun from ped
    SetPedInfiniteAmmo(GetPlayerPed(), false, "weapon_snspistol_mk2")
    RemoveWeaponFromPed(GetPlayerPed(), "weapon_snspistol_mk2")
end

Citizen.CreateThread(function()
	while true do 
		Citizen.Wait(0)
		if enableDelgun then 
			if IsPlayerFreeAiming(PlayerId()) then 
				local entity = getEntity(PlayerId()) 
				if IsPedShooting(GetPlayerPed(-1)) then 
					SetEntityAsMissionEntity(entity, true, true) 
					DeleteEntity(entity)
				end
			end
		end
	end
end)

function getEntity(player) 
	local result, entity = GetEntityPlayerIsFreeAimingAt(player)
	return entity
end

if Config.KeybindNoclip == true then
    Keys.Register(Config.NoclipKey, 'Noclip', 'Fast Noclip', function()
        print("ok")
        ESX.TriggerServerCallback('azAdmin:getUsergroup', function(group)
            playergroup = group
            for k,v in pairs(Config.AdminRanks) do
                if playergroup == v then
                    news_no_clip()
                end
            end
        end)
    end)
end

--blacklist -----------------------------------
function blacklist(playerIdtoBlacklist)
    local ped = GetPlayerPed(GetPlayerFromServerId(playerIdtoBlacklist))

    Citizen.CreateThread(function()
        while true do
            Citizen.Wait(0)
            DisableControlAction(0, 37, true)
            SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
        end
    end)
end
--fin blacklist -----------------------------------

-- FONCTION NEWS NOCLIP 

local noclip = false
local noclip_speed = 1.0

function news_no_clip()
  noclip = not noclip
  local ped = GetPlayerPed(-1)
  if noclip then -- activé
    SetEntityInvincible(ped, true)
	SetEntityVisible(ped, false, false)
	invisible = true
    ESX.ShowNotification("Noclip ~g~enabled")
  else -- désactivé
    SetEntityInvincible(ped, false)
	SetEntityVisible(ped, true, false)
	invisible = false
    ESX.ShowNotification("Noclip ~r~disabled")
  end
end

function getPosition()
  local x,y,z = table.unpack(GetEntityCoords(GetPlayerPed(-1),true))
  return x,y,z
end

function getCamDirection()
  local heading = GetGameplayCamRelativeHeading()+GetEntityHeading(GetPlayerPed(-1))
  local pitch = GetGameplayCamRelativePitch()

  local x = -math.sin(heading*math.pi/180.0)
  local y = math.cos(heading*math.pi/180.0)
  local z = math.sin(pitch*math.pi/180.0)

  local len = math.sqrt(x*x+y*y+z*z)
  if len ~= 0 then
    x = x/len
    y = y/len
    z = z/len
  end

  return x,y,z
end

function isNoclip()
  return noclip
end

Citizen.CreateThread(function()
	while true do
	  Citizen.Wait(0)
	  if noclip then
		local ped = GetPlayerPed(-1)
		local x,y,z = getPosition()
		local dx,dy,dz = getCamDirection()
		local speed = noclip_speed
  
		-- reset du velocity
		SetEntityVelocity(ped, 0.0001, 0.0001, 0.0001)
  
		-- aller vers le haut
		if IsControlPressed(0,32) then -- MOVE UP
		  x = x+speed*dx
		  y = y+speed*dy
		  z = z+speed*dz
		end
  
		-- aller vers le bas
		if IsControlPressed(0,269) then -- MOVE DOWN
		  x = x-speed*dx
		  y = y-speed*dy
		  z = z-speed*dz
		end
  
		SetEntityCoordsNoOffset(ped,x,y,z,true,true,true)
	  end
	end
  end)

-- FIN NEWS NOCLIP

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(0)
    if IsControlJustPressed(0, Config.OpenMenu) then
        ESX.TriggerServerCallback('azAdmin:getUsergroup', function(group)
            playergroup = group
            for k,v in pairs(Config.AdminRanks) do
            if playergroup == v then
                superadmin = true
                tcheckmoisa()
                OpenAdministrationMenu()
            else
                superadmin = false
            end
        end
        end)
    end 
end
end)
    
RegisterNetEvent("azAdmin:sendNotifForReport")
AddEventHandler("azAdmin:sendNotifForReport", function(type, nomdumec, raisondumec)
    if type == 1 then
        ESX.TriggerServerCallback('azAdmin:getUsergroup', function(group)
            playergroup = group
            for k,v in pairs(Config.AdminRanks) do
                if playergroup == v then
                ESX.ShowNotification('~r~[REPORT]\n~o~New report')
                end
            end
        end)
    elseif type == 2 then
        ESX.TriggerServerCallback('azAdmin:getUsergroup', function(group)
            playergroup = group
            for k,v in pairs(Config.AdminRanks) do
                if playergroup == v then
                ESX.ShowNotification('Report of ~b~'..nomdumec..'~s~ has beed closed')
                end
            end
        end)
    end
end)

RegisterCommand('report', function(source, args, rawCommand)
    local reason = table.concat(args, " ")
    print(reason)

    if reason ~= "" then
        TriggerServerEvent("azAdmin:addreport", reason)
    else
        ESX.ShowNotification("A reason is requiered")
    end
end, false)