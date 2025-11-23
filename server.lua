local QBCore = exports['qb-core']:GetCoreObject()

-- Fonction pour générer un ID unique
local function GenerateBackpackID()
    return 'backpack_' .. math.random(100000, 999999) .. '_' .. os.time()
end

-- Créer la table dans la base de données (à exécuter une seule fois)
MySQL.ready(function()
    MySQL.Async.execute([[
        CREATE TABLE IF NOT EXISTS backpack_storage (
            id VARCHAR(50) PRIMARY KEY,
            items LONGTEXT DEFAULT '[]',
            created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
            last_opened TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
        )
    ]])
end)

-- Event pour créer le sac
QBCore.Functions.CreateUseableItem('backpack_small', function(source, item)
    CreateBackpack(source, 'backpack_small', item)
end)

QBCore.Functions.CreateUseableItem('backpack_medium', function(source, item)
    CreateBackpack(source, 'backpack_medium', item)
end)

QBCore.Functions.CreateUseableItem('backpack_large', function(source, item)
    CreateBackpack(source, 'backpack_large', item)
end)

-- Fonction principale de création
function CreateBackpack(source, backpackType, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local config = Config.GetBackpackConfig(backpackType)
    if not config then return end

    -- Déclencher l'animation côté client
    TriggerClientEvent('backpack:client:createBackpack', src, backpackType)
end

-- Event appelé après la progressbar
RegisterNetEvent('backpack:server:finishCreate', function(backpackType)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local config = Config.GetBackpackConfig(backpackType)
    if not config then return end

    -- Retirer le sac de base
    if not Player.Functions.RemoveItem(backpackType, 1) then
        TriggerClientEvent('QBCore:Notify', src, Config.Messages.errorCreating, 'error')
        return
    end

    -- Générer un ID unique
    local backpackID = GenerateBackpackID()

    -- Créer l'entrée dans la base de données
    MySQL.Async.execute('INSERT INTO backpack_storage (id, items) VALUES (@id, @items)', {
        ['@id'] = backpackID,
        ['@items'] = json.encode({})
    })

    -- Créer le metadata pour le sac
    local info = {
        backpack_id = backpackID,
        slots = config.slots,
        weight = config.weight,
        label = config.label
    }

    -- Donner le nouveau sac avec ID unique
    Player.Functions.AddItem(backpackType .. '_equipped', 1, false, info)

    TriggerClientEvent('QBCore:Notify', src, Config.Messages.backpackCreated, 'success')
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[backpackType .. '_equipped'], 'add')

    -- Déclencher la mise à jour de l'apparence
    TriggerClientEvent('backpack:client:updateAppearance', src)
end)

-- Event pour ouvrir le sac
QBCore.Functions.CreateUseableItem('backpack_small_equipped', function(source, item)
    OpenBackpack(source, item)
end)

QBCore.Functions.CreateUseableItem('backpack_medium_equipped', function(source, item)
    OpenBackpack(source, item)
end)

QBCore.Functions.CreateUseableItem('backpack_large_equipped', function(source, item)
    OpenBackpack(source, item)
end)

-- Fonction pour ouvrir le sac
function OpenBackpack(source, item)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then return end

    local metadata = item.info
    if not metadata or not metadata.backpack_id then
        TriggerClientEvent('QBCore:Notify', src, Config.Messages.invalidBackpack, 'error')
        return
    end

    local backpackID = metadata.backpack_id
    local slots = metadata.slots or 10
    local weight = metadata.weight or 50000

    -- Charger les items depuis la base de données
    MySQL.Async.fetchAll('SELECT items FROM backpack_storage WHERE id = @id', {
        ['@id'] = backpackID
    }, function(result)
        if result[1] then
            -- Enregistrer le stash temporaire
            local stashData = {
                label = metadata.label or 'Sac à Dos',
                slots = slots,
                weight = weight,
                owner = false -- Permet à n'importe qui d'ouvrir
            }

            -- Créer ou mettre à jour le stash
            TriggerClientEvent('backpack:client:openStash', src, backpackID, stashData)
        else
            TriggerClientEvent('QBCore:Notify', src, Config.Messages.errorOpening, 'error')
        end
    end)
end

-- Event pour sauvegarder le contenu du sac (appelé automatiquement par ox_inventory)
RegisterNetEvent('backpack:server:saveBackpack', function(backpackID, items)
    MySQL.Async.execute('UPDATE backpack_storage SET items = @items WHERE id = @id', {
        ['@id'] = backpackID,
        ['@items'] = json.encode(items)
    })
end)

-- Event pour supprimer un sac (optionnel - si tu veux permettre la destruction)
RegisterNetEvent('backpack:server:deleteBackpack', function(backpackID)
    MySQL.Async.execute('DELETE FROM backpack_storage WHERE id = @id', {
        ['@id'] = backpackID
    })
end)

-- Callback pour vérifier si le joueur a un sac équipé
QBCore.Functions.CreateCallback('backpack:server:hasBackpack', function(source, cb)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)

    if not Player then
        cb(false, nil)
        return
    end

    -- Vérifier tous les types de sacs équipés
    local backpackTypes = Config.GetEquippedBackpackTypes()

    for _, backpackType in ipairs(backpackTypes) do
        local item = Player.Functions.GetItemByName(backpackType)
        if item then
            -- Déterminer le type de base
            local baseType = Config.GetBaseType(backpackType)
            cb(true, baseType)
            return
        end
    end

    cb(false, nil)
end)