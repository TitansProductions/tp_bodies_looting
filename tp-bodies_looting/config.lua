Config = {}

Config.Locale = 'en'

-- -> DISCORD WEBHOOK IS CURRENTLY DISABLED !!!

Config.DISCORD_NAME           = "[MyServerName]"      -- Insert your discord server name, example: [MY SERVER]
Config.DISCORD_IMAGE          = "<discord_image_url>" -- Insert your discord logo image, example: https://i.imgur.com/xxxxxx.png
Config.WEBHOOK                = " "                   -- Insert the channel webhook that you want in order to send logs when player searched a bag.

-- Spawn player bag when dead in seconds.
Config.SpawnPlayerBagWhenDead = 5

-- Removing bag after spawning. Timer is in seconds. Default is 1800 seconds (Equals to 30 Minutes).
Config.RemovingBagAfterSpawnedInSeconds = 1800

-- If you are using any other script which removes player inventory contents on death / respawning such as esx_ambulancejob, 
-- set everything to false in the script config and disable inventory removal.
Config.RemoveWeaponsAfterRPDeath      = true 
Config.RemoveCashAfterRPDeath         = true
Config.RemoveBlackMoneyAfterRPDeath   = true
Config.RemoveItemsAfterRPDeath        = true

-- ###############################################
-- BAGS INVENTORY
-- ###############################################

-- Include money in inventory?
Config.Includemoney = true
-- Include weapons in inventory?
Config.IncludeWeapons = true

Config.Limit = 30000
Config.DefaultWeight = 10
Config.userSpeed = false

Config.localWeight = {
    bread = 50,
    water = 50,
}

-- You can change your custom / replacement weapon names in inventory when displayed.
Config.WeaponLabelNames = {

    ['WEAPON_ADVANCEDRIFLE']  = "AUG",
    ['WEAPON_ASSAULTRIFLE']   = "AK47",
    ['WEAPON_COMPACTRIFLE']   = "AKS-74U",
    ['WEAPON_CARBINERIFLE']   = "M4A1",
    ['WEAPON_SPECIALCARBINE'] = "SCAR",
    ['WEAPON_COMBATPDW']      = "UMP .45",
    ['WEAPON_MICROSMG']       = "UZI",
    ['WEAPON_SMG']            = "MP5",

}

-- Insert blacklisted items which will not be placed / added in the bag.
Config.BlackListedItems = {
    ['diamond'] = true,
}

-- Insert blacklisted weapons which will not be placed / added in the bag.
Config.BlackListedWeapons = {
    ['WEAPON_BOTTLE'] = true,
}

