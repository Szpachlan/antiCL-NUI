fx_version 'cerulean'
game 'gta5'

client_script 'client.lua'
shared_script 'configs/shared_config.lua'
server_scripts {
    'configs/server_config.lua',
    'server.lua'
}

ui_page 'html/index.html'
files {
    'html/index.html',
    'html/main.js',
    'fonts/casper/*.ttf',
    'fonts/casper/*.woff',
    'fonts/casper/*.woff2'
}