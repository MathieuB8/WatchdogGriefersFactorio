require("silo-script")
local version = 1

script.on_event(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  player.insert{name="iron-plate", count=8}
  player.insert{name="pistol", count=1}
  player.insert{name="firearm-magazine", count=10}
  player.insert{name="burner-mining-drill", count = 1}
  player.insert{name="stone-furnace", count = 1}
  player.force.chart(player.surface, {{player.position.x - 200, player.position.y - 200}, {player.position.x + 200, player.position.y + 200}})
  if (#game.players <= 1) then
    game.show_message_dialog{text = {"msg-intro"}}
  else
    player.print({"msg-intro"})
  end
  silo_script.gui_init(player)
end)

script.on_event(defines.events.on_player_respawned, function(event)
  local player = game.players[event.player_index]
  player.insert{name="pistol", count=1}
  player.insert{name="firearm-magazine", count=10}
end)

script.on_event(defines.events.on_gui_click, function(event)
  silo_script.on_gui_click(event)
end)

script.on_init(function()
  global.version = version
  silo_script.init()
end)

script.on_event(defines.events.on_rocket_launched, function(event)
  silo_script.on_rocket_launched(event)
end)

script.on_configuration_changed(function(event)
  if global.version ~= version then
    global.version = version
  end
  silo_script.on_configuration_changed(event)
end)

silo_script.add_remote_interface()




--Watchdog v1 :  Will write in the file logs.txt all the suspicious activities, in %appdata%/Factorio/script-output/logs.txt

script.on_event(defines.events.on_player_deconstructed_area, function(event)
	local var=event.player_index .." is deleting ".. event.item.."\n"
	game.write_file("logs.txt",var,true,0)
end)
script.on_event(defines.events.on_marked_for_deconstruction, function(event)
	local var=event.player_index .." is deleting ".. event.entity.name.."\n"
	game.write_file("logs.txt",var,true,0)
end)



script.on_event(defines.events.on_player_joined_game, function(event)
	game.write_file("logs.txt","\n======\n",true,0)
	for k, v in pairs(game.players) do
		local var=v.index .. "||<><><>||" .. v.name.. "\n"
		game.write_file("logs.txt",var,true,0)
	end
	game.write_file("logs.txt","======\n",true,0)
 end)


script.on_event(defines.events.on_player_mined_item, function(event)
	local var=event.player_index .." picked ".. event.item_stack.name.."\n"
	game.write_file("logs.txt",var,true,0)
end)

script.on_event(defines.events.on_picked_up_item, function(event)
	local var=event.player_index .." picked ".. event.item_stack.name.."\n"
	game.write_file("logs.txt",var,true,0)
end)

script.on_event(defines.events.on_player_rotated_entity, function(event)
	local var=event.player_index .." rotated ".. event.entity.name.."\n"
	game.write_file("logs.txt",var,true,0)
end)


script.on_event(defines.events.on_entity_died, function(event)
	local var=event.entity.name .." died due to ".. event.cause.name .. " by force " .. event.force.name.."\n"
	game.write_file("logs.txt",var,true,0)
end)

