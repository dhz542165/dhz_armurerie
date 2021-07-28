ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--------------------------------------------------

function Attjelooklalicensezebi(source, type, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
	local identifier = xPlayer.identifier

	MySQL.Async.fetchAll('SELECT COUNT(*) as count FROM user_licenses WHERE type = @type AND owner = @owner', {
		['@type']  = type,
		['@owner'] = identifier
	}, function(result)
		if tonumber(result[1].count) > 0 then
			cb(true)
		else
			cb(false)
		end

	end)
end

ESX.RegisterServerCallback('dhz_Attjelooklalicensezebi:Attjelooklalicensezebi', function(source, cb, type)
    Attjelooklalicensezebi(source, 'weapon', cb)
end)


----------------------------------------------------

RegisterServerEvent('dhz_armurerie:addppa')
AddEventHandler('dhz_armurerie:addppa', function(weapon)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getMoney()

	if playerMoney >= 50000 then
    MySQL.Async.execute('INSERT INTO user_licenses (type, owner) VALUES (@type, @owner)', {
        ['@type'] = weapon,
        ['@owner'] = xPlayer.identifier
    })
	xPlayer.removeMoney(50000)
	TriggerClientEvent('esx:showNotification', source, "~g~Achat réussis !")
	else
		TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez !")
	end
end)

-------------------------------------------------------

RegisterServerEvent('armurerie:giveWeapon')
AddEventHandler('armurerie:giveWeapon', function(item)
    local xPlayer = ESX.GetPlayerFromId(source)
    local playerMoney = xPlayer.getMoney()
    if playerMoney >= (item.Prix) then
        if not xPlayer.hasWeapon(item.Valeur) then
        xPlayer.addWeapon(item.Valeur, 100)
        xPlayer.removeMoney(item.Prix)
        else
            TriggerClientEvent('esx:showNotification', source, '~r~Vous avez déjà cette arme')
        end

    else
		TriggerClientEvent('esx:showNotification', source, 'Vous ne pouvez pas acheter ~g~1x ' .. item.Nom .. '~s~' .. ' il vous manque ' .. '~r~' .. item.Prix - playerMoney .. '$')
    end
end)

RegisterNetEvent('item:acheter')
AddEventHandler('item:acheter', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
	local playerMoney = xPlayer.getMoney()

	if playerMoney >= (item.Prix) then
		xPlayer.addInventoryItem(item.Valeur, 1)
		xPlayer.removeMoney(item.Prix)
	else
		TriggerClientEvent('esx:showNotification', source, "~r~Vous n'avez pas assez !")
	end
end)