# 🎒 GLD-BACKPACK

 

> Système de sac à dos avancé pour QBCore avec stockage persistant et apparence visuelle

 

## 📋 Description

 

QB-Backpack est un script complet de gestion de sacs à dos pour FiveM utilisant le framework QBCore. Il permet aux joueurs de créer, équiper et utiliser des sacs à dos avec un stockage persistant en base de données. Chaque sac dispose d'une apparence visuelle qui s'affiche automatiquement sur le dos du joueur.

 

### ✨ Fonctionnalités principales

 

- ✅ **3 types de sacs** : Petit, Moyen et Grand avec capacités différentes

- ✅ **Apparence visuelle** : Le sac apparaît automatiquement sur le dos du joueur

- ✅ **Système intelligent** : L'apparence est liée à la possession du sac dans l'inventaire

- ✅ **Stockage persistant** : Contenu sauvegardé en base de données avec ID unique

- ✅ **Animation de création** : Progressbar avec animation pour créer le sac

- ✅ **Support homme/femme** : Apparence adaptée au genre du personnage

- ✅ **Configuration centralisée** : Fichier config.lua pour personnalisation facile

- ✅ **Compatible ox_inventory** : Support natif pour ox_inventory/origen_inventory

 

## 📦 Prérequis

 

- [QBCore Framework](https://github.com/qbcore-framework)

- [oxmysql](https://github.com/overextended/oxmysql)

- ox_inventory ou qb-inventory (ou compatible)

- qb-clothing ou système de vêtements compatible

 

## 🚀 Installation

 

### 1. Téléchargement

 

```bash

cd resources

git clone https://github.com/VotreNom/qb-backpack.git

```

 

### 2. Configuration du manifest

 

Assurez-vous que votre `server.cfg` contient :

 

```cfg

ensure qb-core

ensure oxmysql

ensure qb-backpack

```

 

### 3. Base de données

 

La table `backpack_storage` sera créée automatiquement au démarrage du script. Aucune action manuelle n'est requise.

 

### 4. Ajout des items dans QBCore

 

Ajoutez ces items dans `qb-core/shared/items.lua` :

 

```lua

-- Sacs de base (non équipés)

['backpack_small'] = {

    ['name'] = 'backpack_small',

    ['label'] = 'Petit Sac à Dos',

    ['weight'] = 1000,

    ['type'] = 'item',

    ['image'] = 'backpack_small.png',

    ['unique'] = false,

    ['useable'] = true,

    ['shouldClose'] = true,

    ['combinable'] = nil,

    ['description'] = 'Un petit sac à dos. Clic droit pour le préparer.'

},

 

['backpack_medium'] = {

    ['name'] = 'backpack_medium',

    ['label'] = 'Sac à Dos Moyen',

    ['weight'] = 2000,

    ['type'] = 'item',

    ['image'] = 'backpack_medium.png',

    ['unique'] = false,

    ['useable'] = true,

    ['shouldClose'] = true,

    ['combinable'] = nil,

    ['description'] = 'Un sac à dos de taille moyenne. Clic droit pour le préparer.'

},

 

['backpack_large'] = {

    ['name'] = 'backpack_large',

    ['label'] = 'Grand Sac à Dos',

    ['weight'] = 3000,

    ['type'] = 'item',

    ['image'] = 'backpack_large.png',

    ['unique'] = false,

    ['useable'] = true,

    ['shouldClose'] = true,

    ['combinable'] = nil,

    ['description'] = 'Un grand sac à dos. Clic droit pour le préparer.'

},

 

-- Sacs équipés (avec ID unique)

['backpack_small_equipped'] = {

    ['name'] = 'backpack_small_equipped',

    ['label'] = 'Petit Sac à Dos (Équipé)',

    ['weight'] = 1000,

    ['type'] = 'item',

    ['image'] = 'backpack_small.png',

    ['unique'] = true,

    ['useable'] = true,

    ['shouldClose'] = true,

    ['combinable'] = nil,

    ['description'] = 'Un petit sac à dos équipé. Capacité: 10 slots, 50kg'

},

 

['backpack_medium_equipped'] = {

    ['name'] = 'backpack_medium_equipped',

    ['label'] = 'Sac à Dos Moyen (Équipé)',

    ['weight'] = 2000,

    ['type'] = 'item',

    ['image'] = 'backpack_medium.png',

    ['unique'] = true,

    ['useable'] = true,

    ['shouldClose'] = true,

    ['combinable'] = nil,

    ['description'] = 'Un sac à dos moyen équipé. Capacité: 20 slots, 100kg'

},

 

['backpack_large_equipped'] = {

    ['name'] = 'backpack_large_equipped',

    ['label'] = 'Grand Sac à Dos (Équipé)',

    ['weight'] = 3000,

    ['type'] = 'item',

    ['image'] = 'backpack_large.png',

    ['unique'] = true,

    ['useable'] = true,

    ['shouldClose'] = true,

    ['combinable'] = nil,

    ['description'] = 'Un grand sac à dos équipé. Capacité: 30 slots, 150kg'

},

```

 

### 5. Images des items

 

Ajoutez les images de sacs dans votre dossier d'inventaire :

- `backpack_small.png`

- `backpack_medium.png`

- `backpack_large.png`

 

Chemin habituel : `qb-inventory/html/images/` ou `ox_inventory/web/images/`

 

## ⚙️ Configuration

 

Toute la configuration se trouve dans `config.lua` :

 

### Durées d'animation

 

```lua

Config.CreationTimes = {

    small = 3000,   -- 3 secondes pour petit sac

    medium = 5000,  -- 5 secondes pour sac moyen

    large = 7000    -- 7 secondes pour grand sac

}

```

 

### Capacités des sacs

 

```lua

Config.Backpacks = {

    ['backpack_small'] = {

        label = 'Petit Sac à Dos',

        slots = 10,      -- Nombre d'emplacements

        weight = 50000,  -- Poids maximum (50kg)

        clothing = {

            male = {

                bags_1 = 3,  -- ID du modèle de sac

                bags_2 = 0   -- Texture/variante

            },

            female = {

                bags_1 = 3,

                bags_2 = 0

            }

        }

    },

    -- ... autres sacs

}

```

 

### Messages personnalisables

 

```lua

Config.Messages = {

    alreadyCreating = 'Vous êtes déjà en train de créer un sac !',

    backpackCreated = 'Sac à dos créé avec succès !',

    -- ... autres messages

}

```

 

## 🎮 Utilisation

 

### Pour les joueurs

 

1. **Obtenir un sac** : Achetez ou trouvez un item `backpack_small`, `backpack_medium` ou `backpack_large`

 

2. **Préparer le sac** :

   - Ouvrez votre inventaire

   - Clic droit sur le sac de base

   - Une animation de 3-7 secondes se lance

   - Vous obtenez un sac équipé avec un ID unique

 

3. **Porter le sac** :

   - Le sac apparaît automatiquement sur votre dos dès que vous le possédez

   - Si vous déposez le sac, il disparaît de votre dos

   - Si vous récupérez le sac, il réapparaît automatiquement

 

4. **Ouvrir le stockage** :

   - Clic droit sur le sac équipé

   - Accédez à votre espace de stockage personnel

   - Le contenu est sauvegardé en base de données

 

5. **Donner/échanger le sac** :

   - Vous pouvez donner votre sac à un autre joueur

   - Le contenu du sac est conservé

   - L'apparence s'adapte automatiquement

 

### Pour les administrateurs

 

Donner un sac à un joueur :

 

```lua

-- Donner un sac de base

/give [id] backpack_small 1

 

-- Ou directement un sac équipé (pour tests)

/give [id] backpack_small_equipped 1

```

 

## 🔧 Compatibilité inventaire

 

### ox_inventory / origen_inventory (par défaut)

 

Le script est configuré par défaut pour ox_inventory. Aucune modification nécessaire.

 

### qb-inventory

 

Si vous utilisez qb-inventory, modifiez `client.lua` ligne 51-66 :

 

```lua

-- Décommenter cette section

TriggerServerEvent('inventory:server:OpenInventory', 'stash', backpackID)

TriggerEvent('inventory:client:SetCurrentStash', backpackID)

 

-- Commenter la section ox_inventory

--[[

TriggerServerEvent('inventory:server:OpenInventory', 'stash', backpackID, {

    maxweight = stashData.weight,

    slots = stashData.slots,

})

TriggerEvent('inventory:client:SetCurrentStash', backpackID)

]]--

```

 

## 🎨 Personnalisation de l'apparence

 

Les IDs de vêtements dépendent de votre serveur et de vos ressources de vêtements. Pour trouver les bons IDs :

 

1. Utilisez un script de vêtements (qb-clothing, etc.)

2. Testez différentes valeurs pour `bags_1` dans `config.lua`

3. Le composant `5` correspond aux sacs dans GTA V

 

Exemple de valeurs courantes :

- `bags_1 = 0` : Pas de sac

- `bags_1 = 1-5` : Différents modèles de sacs

 

## 🔄 Comment ça fonctionne

 

### Système d'apparence intelligente

 

```

Joueur possède sac équipé → Sac visible sur le dos

         ↓

Joueur dépose le sac → Sac retiré automatiquement

         ↓

Joueur récupère le sac → Sac affiché automatiquement

```

 

Le script vérifie l'inventaire du joueur toutes les secondes et ajuste l'apparence en conséquence.

 

### Stockage persistant

 

Chaque sac équipé possède un ID unique (ex: `backpack_123456_1234567890`). Le contenu est stocké dans la table `backpack_storage` avec cet ID, permettant :

- Transfert entre joueurs avec conservation du contenu

- Sauvegarde permanente même après redémarrage

- Possibilité d'avoir plusieurs sacs différents

 

## 📊 Structure de la base de données

 

```sql

CREATE TABLE IF NOT EXISTS backpack_storage (

    id VARCHAR(50) PRIMARY KEY,

    items LONGTEXT DEFAULT '[]',

    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    last_opened TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP

)

```

 

## ❓ FAQ

 

### Le sac n'apparaît pas sur mon dos ?

 

Vérifiez :

1. Que vous possédez bien un sac **équipé** (avec `_equipped` dans le nom)

2. Les valeurs `bags_1` et `bags_2` dans `config.lua` correspondent à votre serveur

3. Que vous n'avez pas d'autre script qui modifie le composant `5` (sacs)

 

### Le contenu de mon sac a disparu ?

 

Le contenu est stocké en base de données. Si vous avez perdu le sac équipé (item), le contenu existe toujours en BDD mais est inaccessible. Un admin peut vous redonner le sac avec le bon ID.

 

### Puis-je avoir plusieurs sacs ?

 

Oui, vous pouvez avoir plusieurs sacs équipés, mais **un seul apparaîtra visuellement** sur votre dos (le premier trouvé dans l'inventaire). Chaque sac a son propre stockage indépendant.

 

### Comment changer les capacités ?

 

Modifiez `config.lua` :

```lua

Config.Backpacks = {

    ['backpack_small'] = {

        slots = 20,      -- Augmenter le nombre de slots

        weight = 100000, -- Augmenter le poids max

        -- ...

    }

}

```

 

### Compatible avec esx ?

 

Non, ce script est conçu spécifiquement pour QBCore. Une adaptation pour ESX nécessiterait de modifier les fonctions de base.

 

## 🐛 Support

 

Pour signaler un bug ou demander de l'aide :

- Ouvrez une [Issue sur GitHub](https://github.com/VotreNom/qb-backpack/issues)

- Rejoignez notre Discord : [Lien Discord]

 

## 📝 Changelog

 

### Version 1.0.0

- ✅ Système de création de sacs avec animation

- ✅ Apparence visuelle liée à l'inventaire

- ✅ Stockage persistant en base de données

- ✅ Support ox_inventory

- ✅ Configuration centralisée

- ✅ Support homme/femme

- ✅ 3 types de sacs (small, medium, large)

 

## 🤝 Contribution

 

Les contributions sont les bienvenues ! N'hésitez pas à :

1. Fork le projet

2. Créer une branche (`git checkout -b feature/AmazingFeature`)

3. Commit vos changements (`git commit -m 'Add some AmazingFeature'`)

4. Push vers la branche (`git push origin feature/AmazingFeature`)

5. Ouvrir une Pull Request

 

## 📜 Licence

 

Ce projet est sous licence MIT. Voir le fichier `LICENSE` pour plus de détails.

 

## 👏 Crédits

 

- Développé pour QBCore Framework

- Utilise oxmysql pour la base de données

- Compatible avec ox_inventory

 

---

 

**⭐ Si ce script vous plaît, n'hésitez pas à mettre une étoile sur GitHub !**
