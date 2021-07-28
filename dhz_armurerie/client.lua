ESX = nil

Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(100)
	end
end)

Citizen.CreateThread(function()
	for i=1, #PointArmurerie, 1 do
		local blip = AddBlipForCoord(PointArmurerie[i])

		SetBlipSprite(blip, 110)
		SetBlipScale (blip, 0.75)
		SetBlipColour(blip, 3)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName('STRING')
		AddTextComponentSubstringPlayerName('Armurerie')
		EndTextCommandSetBlipName(blip)
	end
end)

Citizen.CreateThread(function()
    local hash = GetHashKey("s_m_y_ammucity_01")
    while not HasModelLoaded(hash) do
    RequestModel(hash)
    Wait(20)
	end
	for k,v in pairs(ConfigArmurerie.ThePedFortnite) do
	ped = CreatePed("PED_TYPE_CIVMALE", "s_m_y_ammucity_01", v.x, v.y, v.z, v.a, false, true)
	SetBlockingOfNonTemporaryEvents(ped, true)
	FreezeEntityPosition(ped, true)
    SetEntityInvincible(ped, true)
	end
end)

PointArmurerie = {
    vector3(-3171.70, 1087.66, 19.83),
    vector3(252.3, -50.0, 69.9),
    vector3(2567.6, 294.3, 108.7),
    vector3(22.0, -1107.2, 29.8),
    vector3(-330.2, 6083.8, 31.4),
    vector3(1693.4, 3759.5, 34.7),
    vector3(-662.1, -935.3, 21.8)
}
ppa = false

RMenu.Add('dhz_armu', 'main', RageUI.CreateMenu("Ammunation", "Armurerie"))
RMenu.Add('dhz_armu', 'armurerie', RageUI.CreateSubMenu(RMenu:Get('dhz_armu', 'main'), "Armurerie", "Voici nos armes blanche."))
RMenu.Add('dhz_armu', 'armes', RageUI.CreateSubMenu(RMenu:Get('dhz_armu', 'main'), "Armurerie", "Voici nos armes à feu."))
RMenu.Add('dhz_armu', 'acess', RageUI.CreateSubMenu(RMenu:Get('dhz_armu', 'main'), "Armurerie", "Voici nos accessoires."))
RMenu.Add('dhz_armu', 'ppa', RageUI.CreateSubMenu(RMenu:Get('dhz_armu', 'main'), "Armurerie", "Confirmation"))
RMenu:Get('dhz_armu', 'main').EnableMouse = false
RMenu:Get('dhz_armu', 'main').Closed = function()
    dhzarmurerie = false
end

local dhzarmurerie = false

function DhzOpenMenuAmmu()
    if dhzarmurerie then
        dhzarmurerie = false
    else
        dhzarmurerie = true
        RageUI.Visible(RMenu:Get('dhz_armu', 'main'), true)

        Citizen.CreateThread(function()
			while dhzarmurerie do
				Wait(0)
                RageUI.IsVisible(RMenu:Get('dhz_armu', 'main'), true, true, true, function()
                    if ppa then
                        RageUI.Separator('Liste des armes')
                    else 
                        RageUI.ButtonWithStyle("Acheter le P.P.A", nil, {RightLabel = "~g~50,000$"},true, function()
                        end, RMenu:Get('dhz_armu', 'ppa'))    
                    end
        
                    RageUI.ButtonWithStyle("Armes blanche", nil, {RightLabel = "→"},true, function()
                    end, RMenu:Get('dhz_armu', 'armurerie'))
        
                    ESX.TriggerServerCallback('dhz_Attjelooklalicensezebi:Attjelooklalicensezebi', function(cb)            
                        if cb then
                            ppa = true 
                        else 
                            ppa = false   
                        end
                    end)
        
                    if ppa then 
                        RageUI.ButtonWithStyle("Armes à feu", nil, { RightLabel = "→" }, true, function(Hovered, Active, Selected)     
                            if (Selected) then
                            end
                        end, RMenu:Get('dhz_armu', 'armes')) 
                    else 
                        RageUI.ButtonWithStyle("Armes à feu", nil, { RightBadge = RageUI.BadgeStyle.Lock }, false, function(Hovered, Active, Selected)     
                            if (Selected) then
                            end
                        end) 
                    end
        
                    RageUI.ButtonWithStyle("Accessoires", nil, {RightLabel = "→"},true, function()
                    end, RMenu:Get('dhz_armu', 'acess')) 
                end, function()
                end)
        
                RageUI.IsVisible(RMenu:Get('dhz_armu', 'ppa'), true, true, true, function()
        
                        RageUI.ButtonWithStyle("Confirmer", nil, { }, true, function(Hovered, Active, Selected)
                            if Selected then
                                local prix = 50000
                                TriggerServerEvent('dhz_armurerie:addppa', 'weapon')
                                RageUI.GoBack()
                            end
                        end)
        
                        RageUI.ButtonWithStyle("~r~Annuler", nil, { }, true, function(Hovered, Active, Selected)
                            if Selected then
                                RageUI.GoBack()
                            end
                        end)
        
                end, function()
                end)
        
                RageUI.IsVisible(RMenu:Get('dhz_armu', 'armurerie'), true, true, true, function()
        
                    for k, v in pairs(ConfigArmurerie.TypeDarme.Blanche) do
                        RageUI.ButtonWithStyle(v.Nom, nil, {RightLabel = "~g~"..v.Prix.."$"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent('armurerie:giveWeapon', v)
                            end
                        end)
                    end
        
                end, function()
                end)
        
                RageUI.IsVisible(RMenu:Get('dhz_armu', 'armes'), true, true, true, function()
        
                    for k, v in pairs(ConfigArmurerie.TypeDarme.Armes) do
                        RageUI.ButtonWithStyle(v.Nom, nil, {RightLabel = "~g~"..v.Prix.."$"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent('armurerie:giveWeapon', v)
                            end
                        end)
                    end
        
                end, function()
                end)
        
                RageUI.IsVisible(RMenu:Get('dhz_armu', 'acess'), true, true, true, function()
        
                    for k, v in pairs(ConfigArmurerie.TypeDarme.Items) do
                        RageUI.ButtonWithStyle(v.Nom, nil, {RightLabel = "~g~"..v.Prix.."$"}, true, function(Hovered, Active, Selected)
                            if Selected then
                                TriggerServerEvent('item:acheter', v)
                            end
                        end)
                    end
                    
                end, function()
                end)
			end	
		end)			
	end				
end

Citizen.CreateThread(function()
	while true do
		Citizen.Wait(0)
        for i=1, #PointArmurerie, 1 do
           local playercoord = GetEntityCoords(PlayerPedId())
            local distance = #(PointArmurerie[i] - playercoord);
        
            if distance <= 1.5 then
				RageUI.Text({
					message = "Appuyez sur [~b~E~w~] pour ouvrir l'armurerie",
					time_display = 1
				})
                if IsControlJustPressed(0, 38) then
                    if dhzarmurerie == false then
                        DhzOpenMenuAmmu()
                    end    
                end
            end
        end
	end
end)


