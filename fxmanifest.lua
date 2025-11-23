fx_version 'cerulean'
game 'gta5'

author 'Ton Nom'
description 'Système de Sac à Dos pour QBCore'
version '1.0.0'

shared_scripts {
    '@qb-core/shared/locale.lua',
    'config.lua'
}

client_scripts {
    'client.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server.lua'
}

dependencies {
    'qb-core',
    'oxmysql'
}

lua54 'yes'