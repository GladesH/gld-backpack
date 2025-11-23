local QBCore = exports['qb-core']:GetCoreObject()
local isCreatingBackpack = false

-- Event pour démarrer la création du sac
RegisterNetEvent('backpack:client:createBackpack', function(backpackType)
    if isCreatingBackpack then
        QBCore.Functions.Notify(Config.Messages.alreadyCreating, 'error')
        return
    end

    isCreatingBackpack = true

    -- Configuration selon le type de sac
    local duration = Config.CreationTimes.medium
    local config = Config.GetBackpackConfig(backpackType)
    local label = 'Création du ' .. string.lower(config.label) .. '...'

    if backpackType == 'backpack_small' then
        duration = Config.CreationTimes.small
    elseif backpackType == 'backpack_large' then
        duration = Config.CreationTimes.large
    end

    -- Animation
    RequestAnimDict(Config.CreationAnim.dict)
    while not HasAnimDictLoaded(Config.CreationAnim.dict) do
        Wait(0)
    end

    local ped = PlayerPedId()
    TaskPlayAnim(ped, Config.CreationAnim.dict, Config.CreationAnim.anim, 8.0, -8.0, -1, 1, 0, false, false, false)

    -- Progress Bar
    QBCore.Functions.Progressbar('create_backpack', label, duration, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {}, {}, {}, function() -- Success
        ClearPedTasks(ped)
        isCreatingBackpack = false
        TriggerServerEvent('backpack:server:finishCreate', backpackType)
    end, function() -- Cancel
        ClearPedTasks(ped)
        isCreatingBackpack = false
        QBCore.Functions.Notify(Config.Messages.creationCancelled, 'error')
    end)
end)

-- Event pour ouvrir le stash du sac
RegisterNetEvent('backpack:client:openStash', function(backpackID, stashData)
    -- Utiliser ox_inventory ou qb-inventory selon ce que tu as

    -- Pour ox_inventory / origen_inventory:
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', backpackID, {
        maxweight = stashData.weight,
        slots = stashData.slots,
    })
    TriggerEvent('inventory:client:SetCurrentStash', backpackID)

    -- Alternative pour qb-inventory (décommenter si tu utilises qb-inventory):
    --[[
    TriggerServerEvent('inventory:server:OpenInventory', 'stash', backpackID)
    TriggerEvent('inventory:client:SetCurrentStash', backpackID)
    ]]--
end)

-- ============================================
-- SYSTÈME DE GESTION DE L'APPARENCE DU SAC
-- ============================================

local currentBackpackType = nil -- Type de sac actuellement porté visuellement

-- Fonction pour vérifier si le joueur a un sac équipé dans son inventaire
local function GetEquippedBackpack()
    local PlayerData = QBCore.Functions.GetPlayerData()
    if not PlayerData or not PlayerData.items then return nil end

    -- Parcourir tous les items du joueur
    for _, item in pairs(PlayerData.items) do
        if item and item.name then
            -- Vérifier si c'est un sac équipé
            if item.name == 'backpack_small_equipped' then
                return 'backpack_small'
            elseif item.name == 'backpack_medium_equipped' then
                return 'backpack_medium'
            elseif item.name == 'backpack_large_equipped' then
                return 'backpack_large'
            end
        end
    end

    return nil
end

-- Fonction pour appliquer l'apparence d'un sac
local function ApplyBackpackClothing(backpackType)
    if not backpackType then return end

    local config = Config.GetBackpackConfig(backpackType)
    if not config then return end

    local ped = PlayerPedId()
    local gender = 'male'

    -- Déterminer le genre du joueur
    if GetEntityModel(ped) == GetHashKey('mp_f_freemode_01') then
        gender = 'female'
    end

    local clothing = config.clothing[gender]
    if not clothing then return end

    -- Appliquer le sac à dos
    SetPedComponentVariation(ped, 5, clothing.bags_1, clothing.bags_2, 0)
    currentBackpackType = backpackType
end

-- Fonction pour retirer l'apparence du sac
local function RemoveBackpackClothing()
    local ped = PlayerPedId()
    -- Composant 5 = sac, 0 = pas de sac
    SetPedComponentVariation(ped, 5, 0, 0, 0)
    currentBackpackType = nil
end

-- Fonction pour mettre à jour l'apparence en fonction de l'inventaire
local function UpdateBackpackAppearance()
    local equippedBackpack = GetEquippedBackpack()

    -- Si le joueur a un sac équipé et qu'il n'est pas encore porté visuellement
    if equippedBackpack and equippedBackpack ~= currentBackpackType then
        ApplyBackpackClothing(equippedBackpack)
    -- Si le joueur n'a plus de sac équipé mais en porte un visuellement
    elseif not equippedBackpack and currentBackpackType then
        RemoveBackpackClothing()
    end
end

-- Thread pour vérifier l'inventaire régulièrement
CreateThread(function()
    while true do
        Wait(1000) -- Vérifier toutes les secondes
        UpdateBackpackAppearance()
    end
end)

-- Event déclenché quand l'inventaire change (QBCore)
RegisterNetEvent('QBCore:Player:SetPlayerData', function(PlayerData)
    Wait(500) -- Petit délai pour laisser l'inventaire se mettre à jour
    UpdateBackpackAppearance()
end)

-- Event pour forcer la mise à jour (appelé après création, achat, etc.)
RegisterNetEvent('backpack:client:updateAppearance', function()
    Wait(500) -- Petit délai pour laisser l'inventaire se mettre à jour
    UpdateBackpackAppearance()
end)