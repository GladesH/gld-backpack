Config = {}

-- ============================================
-- CONFIGURATION GÉNÉRALE
-- ============================================

-- Durées des animations de création (en millisecondes)
Config.CreationTimes = {
    small = 3000,   -- 3 secondes pour petit sac
    medium = 5000,  -- 5 secondes pour sac moyen
    large = 7000    -- 7 secondes pour grand sac
}

-- Animation utilisée pour la création du sac
Config.CreationAnim = {
    dict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@',
    anim = 'machinic_loop_mechandplayer'
}

-- ============================================
-- CONFIGURATION DES SACS À DOS
-- ============================================

Config.Backpacks = {
    ['backpack_small'] = {
        label = 'Petit Sac à Dos',

        -- Capacité du sac
        slots = 10,
        weight = 50000, -- 50kg

        -- Configuration des vêtements (apparence visuelle)
        clothing = {
            male = {
                bags_1 = 3,  -- ID du sac dans qb-clothing pour homme
                bags_2 = 0   -- Texture/variante
            },
            female = {
                bags_1 = 3,  -- ID du sac dans qb-clothing pour femme
                bags_2 = 0   -- Texture/variante
            }
        }
    },

    ['backpack_medium'] = {
        label = 'Sac à Dos Moyen',

        -- Capacité du sac
        slots = 20,
        weight = 100000, -- 100kg

        -- Configuration des vêtements
        clothing = {
            male = {
                bags_1 = 2,
                bags_2 = 0
            },
            female = {
                bags_1 = 2,
                bags_2 = 0
            }
        }
    },

    ['backpack_large'] = {
        label = 'Grand Sac à Dos',

        -- Capacité du sac
        slots = 30,
        weight = 150000, -- 150kg

        -- Configuration des vêtements
        clothing = {
            male = {
                bags_1 = 4,
                bags_2 = 0
            },
            female = {
                bags_1 = 4,
                bags_2 = 0
            }
        }
    }
}

-- ============================================
-- MESSAGES DE NOTIFICATION
-- ============================================

Config.Messages = {
    -- Messages de succès
    alreadyCreating = 'Vous êtes déjà en train de créer un sac !',
    creationCancelled = 'Création annulée',
    backpackCreated = 'Sac à dos créé avec succès !',
    backpackEquipped = 'Sac à dos équipé sur votre dos',
    backpackRemoved = 'Sac à dos retiré',

    -- Messages d'erreur
    invalidBackpack = 'Sac invalide',
    errorCreating = 'Erreur lors de la création du sac',
    errorOpening = 'Erreur lors de l\'ouverture du sac'
}

-- ============================================
-- FONCTIONS UTILITAIRES
-- ============================================

-- Obtenir la configuration d'un sac par son type
function Config.GetBackpackConfig(backpackType)
    return Config.Backpacks[backpackType]
end

-- Obtenir tous les types de sacs équipés
function Config.GetEquippedBackpackTypes()
    local types = {}
    for backpackType, _ in pairs(Config.Backpacks) do
        table.insert(types, backpackType .. '_equipped')
    end
    return types
end

-- Obtenir le type de base à partir du type équipé
function Config.GetBaseType(equippedType)
    return equippedType:gsub('_equipped', '')
end