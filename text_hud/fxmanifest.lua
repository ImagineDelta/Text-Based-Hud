fx_version 'cerulean'
game 'gta5'
lua54 'yes'
version '1.0.0'
author 'Imagine Delta'
description 'Text Based Hud'

ui_page {
	'modules/hud/html/index.html',
}

shared_scripts {
    '@es_extended/imports.lua'
}

client_scripts {
	'modules/**/carhud_cl.lua',
	'modules/**/config.lua',
	'modules/**/nameconfig.lua',
	'modules/***/cl.lua',
	'modules/**/configuration.lua',
	'modules/**/client.lua',
	'modules/**/cl_hud.lua',
}

server_scripts {
	'modules/**/sv_hud.lua',
	'modules/**/nameconfig.lua',
	'modules/***/sv.lua',
}

files {
	'modules/hud/html/index.html',
	'modules/hud/html/main.js',
	'modules/streetlabel/html/index.html',
	'modules/streetlabel/html/css/styles.css',
	'modules/streetlabel/html/css/font-face.css',
	'modules/streetlabel/html/fonts/*.woff2',
	'modules/streetlabel/html/fonts/*.woff',
	'modules/streetlabel/html/fonts/*.ttf',
	'modules/streetlabel/html/js/listener.js',
}