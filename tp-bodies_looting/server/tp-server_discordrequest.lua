
RegisterNetEvent("tp-bodies_looting:sendToDiscord")
AddEventHandler("tp-bodies_looting:sendToDiscord", function(foundItemsText, foundWeaponsText, foundCurrency)

	if foundWeaponText == nil or foundWeaponText == "" or foundWeaponText == " " then
		sendToDiscord(Config.WEBHOOK, GetPlayerName(source), "**The referred player searched a bag which contains the following:** \n\n**Cash:** ".. foundCurrency .. "\n\n**Items:**\n\n".. foundItemsText .. "\n\nPlease, keep in mind, if the player has some of the referred items, each item will be given only if there is enough space.")
	else
		sendToDiscord(Config.WEBHOOK, GetPlayerName(source), "**The referred player searched a bag which contains the following:** \n\n**Cash:** ".. foundCurrency .. "\n\n**Items:**\n\n".. foundItemsText .. "\n**Weapons:**\n" .. foundWeaponsText .. "\n\nPlease, keep in mind, if the player has some of the referred items, each item will be given only if there is enough space.")
	end
end)

-- METHOD FOR SENDING MESSAGES ON CHANNELS
function sendToDiscord(webhook, name, message, color)
	local connect = {
		  {
			  ["color"] = color,
			  ["title"] = "**".. name .."**",
			  ["description"] = message,
			  ["footer"] = {
			  ["text"] = "© " .. Config.DISCORD_NAME .. " - Support Team",
		  },
	  }
  }
  PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({username = Config.DISCORD_NAME, embeds = connect, avatar_url = Config.DISCORD_IMAGE}), { ['Content-Type'] = 'application/json' })
end