fx_version 'cerulean'
game 'rdr3'
rdr3_warning 'I acknowledge that this is a prerelease build of RedM, and I am aware my resources *will* become incompatible once RedM ships.'

description 'RSG-Chairs - Chair Placement System'
version '1.0.0'

shared_scripts {
    '@rsg-core/shared/locale.lua',
    'shared/*.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    '@rsg-core/client/wrapper.lua',
    'client/*.lua'
}

server_scripts {
    '@rsg-core/server/wrapper.lua',
    'server/*.lua'
}

dependencies {
    'rsg-core',
    'ox_lib',
    'ox_target'
}

lua54 'yes'