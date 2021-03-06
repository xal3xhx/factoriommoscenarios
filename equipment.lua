local function ticks_from_minutes(minutes)
	return minutes * 60 * 60
end

local function give_player_fighting_equipment(player)
	if (player.force.technologies["military"].researched) then
		player.insert { name = "submachine-gun", count = 1 }
	else
		player.insert { name = "pistol", count = 1 }
	end

	if (player.force.technologies["uranium-ammo"].researched) then
		player.insert { name = "uranium-rounds-magazine", count = 10 }
	else
		if (player.force.technologies["military-2"].researched) then
			player.insert { name = "piercing-rounds-magazine", count = 10 }
		else
			player.insert { name = "firearm-magazine", count = 10 }
		end
	end
end

local function give_player_tools(player)
	if (player.force.technologies["steel-processing"].researched) then
        player.insert { name = "steel-axe", count = 2 }
    else
        player.insert { name = "iron-axe", count = 5 }
    end
end

local function teleport(player)
	player.teleport(player.surface.find_non_colliding_position("player", player.position, 0, 1))
end
-- Give player starting items.
-- @param event on_player_joined event
function player_joined(event)
	local player = game.players[event.player_index]

	give_player_fighting_equipment(player)

	if game.tick < ticks_from_minutes(10) then
		player.insert { name = "burner-mining-drill", count = 2 }
		player.insert { name = "stone-furnace", count = 2 }
	end
	
	give_player_tools(player)
	teleport(player)

end

-- Give player weapons after they respawn.
-- @param event on_player_respawned event
function player_respawned(event)
	local player = game.players[event.player_index]

	give_player_fighting_equipment(player)
	teleport(player)
end

Event.register(defines.events.on_player_created, player_joined)
Event.register(defines.events.on_player_respawned, player_respawned)
