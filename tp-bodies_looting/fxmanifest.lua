fx_version 'adamant'
game 'gta5'

author 'Nosmakos'
description 'Titans Productions TP Bodies Looting'
version '2.1.0'

ui_page 'html/index.html'

shared_script '@es_extended/imports.lua'

client_scripts {
    '@es_extended/locale.lua',
	'locales/en.lua',
    'config.lua',
    'client/tp-client_main.lua',
    'client/tp-client_inventory.lua'
}

server_scripts {
	'@es_extended/locale.lua',
	'locales/en.lua',
    'config.lua',
    'server/tp-server_main.lua',
    'server/tp-server_inventory.lua',
    'server/tp-server_discordrequest.lua',
    'server/tp-server_deathstatus.lua',
}


files {
	'html/index.html',
	'html/js/script.js',
	'html/css/*.css',
	'html/font/Prototype.ttf',
    'html/img/background.jpg',
}

dependency 'es_extended'