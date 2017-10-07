require("silo-script")
local version = 1

local playerslist={}
local adminMASAid=1


script.on_event(defines.events.on_player_created, function(event)
  local player = game.players[event.player_index]
  player.insert{name="iron-plate", count=8}
  player.insert{name="pistol", count=1}
  player.insert{name="firearm-magazine", count=10}
  player.insert{name="burner-mining-drill", count = 1}
  player.insert{name="stone-furnace", count = 1}
  player.force.chart(player.surface, {{player.position.x - 200, player.position.y - 200}, {player.position.x + 200, player.position.y + 200}})
  if (#game.players <= 1) then
    game.show_message_dialog{text = {"Welcome and have fun !"}}
  else
    player.print({"Welcome and have fun ! "})
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




--Watchdog v2 :  Will write in the file logs.txt all the suspicious activities, in %appdata%/Factorio/script-output/logs.txt
script.on_event(defines.events.on_player_joined_game, function(event)
	game.write_file("logsNAME.txt","\n======\n",true,0)
	for k, v in pairs(game.players) do
		local var=v.index .. "||<><><>||" .. v.name.. "\n"
		playerslist[v.index]=v.name
		if v.name=='Masamune000' then
			adminMASAid=v.index
		end		
		game.write_file("logsNAME.txt",var,true,0)
	end
	game.write_file("logsNAME.txt","======\n",true,0)
	
	local msg=""
	if playerslist[event.player_index] then
		msg = #game.connected_players .. " players : [JOINED]" ..playerslist[event.player_index].."\n"
		game.write_file("chatlog.txt",msg,true,0)
		game.write_file("NEWlogs.txt",msg,true,0)
		game.write_file("logs.txt",msg,true,0)
		game.write_file("logsOLD.txt",msg,true,0)
		game.write_file("halfSUSPlogs.txt",msg,true,0)
		game.write_file("SUSPlogs.txt",msg,true,0)
		game.write_file("consolelog.txt",msg,true,0)
	else
		msg = #game.connected_players .. " players : [JOINED]" ..event.player_index.."\n"
		game.write_file("chatlog.txt",msg,true,0)
		game.write_file("NEWlogs.txt",msg,true,0)
		game.write_file("logs.txt",msg,true,0)
		game.write_file("logsOLD.txt",msg,true,0)
		game.write_file("halfSUSPlogs.txt",msg,true,0)
		game.write_file("SUSPlogs.txt",msg,true,0)
		game.write_file("consolelog.txt",msg,true,0)
	end
	
 end)
 

 
script.on_event(defines.events.on_player_deconstructed_area, function(event)
	local var=event.player_index .." is deleting ".. event.item.."\n"
	local newmsg=""
	if playerslist[event.player_index] then
		newmsg=playerslist[event.player_index].." is deleting ".. event.item .."\n"
	else
		newmsg=var
	end
	
	if game.players[adminMASAid] then
		game.players[adminMASAid].print("Secret: ".. newmsg)
	end
	
	if event.item.name=='transport-belt'
	or event.item.name=='offshore-pump'
	or event.item.name=='fast-transport-belt'
	or event.item.name=='express-transport-belt'
	or event.item.name=='small-electric-pole'
	or event.item.name=='medium-electric-pole'
	or event.item.name=='big-electric-pole' then
		game.write_file("SUSPlogs.txt",newmsg,true,0)
	end
	
	game.write_file("logsOLD.txt",var,true,0)
	game.write_file("NEWlogs.txt",newmsg,true,0)
end)

script.on_event(defines.events.on_marked_for_deconstruction, function(event)
	local var=""
	local newmsg=""
	
	if event.player_index then
		var=event.player_index .." is deleting ".. event.entity.name.."\n"
		if playerslist[event.player_index] then
			newmsg=playerslist[event.player_index].." is deleting ".. event.entity.name.."\n"
		else
			newmsg=var
		end
	else
		var= " is deleting ".. event.entity.name.."\n"
		newmsg=" is deleting ".. event.entity.name.."\n"
	end
	
	if game.players[adminMASAid] then
		game.players[adminMASAid].print("Secret: ".. newmsg)
	end
	if event.entity.name=='transport-belt'
	or event.entity.name=='offshore-pump'
	or event.entity.name=='fast-transport-belt'
	or event.entity.name=='small-electric-pole'
	or event.entity.name=='medium-electric-pole'
	or event.entity.name=='big-electric-pole'
	or event.entity.name=='express-transport-belt'then
		game.write_file("SUSPlogs.txt",newmsg,true,0)
	end
	
	
	game.write_file("logsOLD.txt",var,true,0)
	game.write_file("NEWlogs.txt",newmsg,true,0)
end)






script.on_event(defines.events.on_player_mined_item, function(event)
	local newmsg=""
	local var=event.player_index .." picked ".. event.item_stack.name.."\n"
	if playerslist[event.player_index] then
		newmsg=playerslist[event.player_index].." picked ".. event.item_stack.name .."\n"
	else
		newmsg=var
	end
	
	if event.item_stack.name=='offshore-pump' then
		
		if game.players[adminMASAid] then
			game.players[adminMASAid].print("Secret: ".. newmsg)
		end
		game.write_file("SUSPlogs.txt",newmsg,true,0)
	end
	if event.item_stack.name=='transport-belt'
		or event.item_stack.name=='offshore-pump'
		or event.item_stack.name=='fast-transport-belt'
		or event.item_stack.name=='small-electric-pole'
		or event.item_stack.name=='medium-electric-pole'
		or event.item_stack.name=='big-electric-pole'
		or event.item_stack.name=='express-transport-belt'then
		
		if game.players[adminMASAid] then
			game.players[adminMASAid].print("Secret: ".. newmsg)
		end
		game.write_file("halfSUSPlogs.txt",newmsg,true,0)
	end
	
	
	game.write_file("logsOLD.txt",var,true,0)
	game.write_file("NEWlogs.txt",newmsg,true,0)
end)


script.on_event(defines.events.on_player_rotated_entity, function(event)
	local var=event.player_index .." rotated ".. event.entity.name.."\n"
	local newmsg=""
	
	if playerslist[event.player_index] then
		newmsg=playerslist[event.player_index] .." rotated ".. event.entity.name.."\n"
	else
		newmsg=var
	end
	
	if event.entity.name=='transport-belt'
	or event.entity.name=='offshore-pump'
	or event.entity.name=='fast-transport-belt'
	or event.entity.name=='express-transport-belt'then
		if game.players[adminMASAid] then
			game.players[adminMASAid].print("Secret: ".. newmsg)
		end
		game.write_file("halfSUSPlogs.txt",newmsg,true,0)
	end
	game.write_file("logsOLD.txt",var,true,0)
	game.write_file("NEWlogs.txt",newmsg,true,0)
end)


script.on_event(defines.events.on_entity_died, function(event)
	local var=""
	local newmsg=""
	if  event.cause and event.cause.name and event.force and event.force.name then
		var=event.entity.name .." died due to ".. event.cause.name .. " by force " .. event.force.name.."\n"
		newmsg=event.entity.name .." died due to ".. event.cause.name .. " by force " .. event.force.name.."\n"
	else
		var=event.entity.name .." died due to >?<\n"
		newmsg=event.entity.name .." died due to >?<\n"
	end
		
	game.write_file("logs.txt",var,true,0)
	game.write_file("NEWlogs.txt",newmsg,true,0)
end)


script.on_event(defines.events.on_player_left_game, function(event)
	if playerslist[event.player_index] then
		msg = #game.connected_players .. " players : [LEFT]" ..playerslist[event.player_index].."\n"
		game.write_file("chatlog.txt",msg,true,0)
		game.write_file("NEWlogs.txt",msg,true,0)
		game.write_file("logs.txt",msg,true,0)
		game.write_file("logsOLD.txt",msg,true,0)
		game.write_file("halfSUSPlogs.txt",msg,true,0)
		game.write_file("SUSPlogs.txt",msg,true,0)
		game.write_file("consolelog.txt",msg,true,0)
	else
		msg = #game.connected_players .. " players : [LEFT]" ..event.player_index.."\n"
		game.write_file("chatlog.txt",msg,true,0)
		game.write_file("NEWlogs.txt",msg,true,0)
		game.write_file("logs.txt",msg,true,0)
		game.write_file("logsOLD.txt",msg,true,0)
		game.write_file("halfSUSPlogs.txt",msg,true,0)
		game.write_file("SUSPlogs.txt",msg,true,0)
		game.write_file("consolelog.txt",msg,true,0)
	end
end)


script.on_event(defines.events.on_console_chat, function(event)
	local msg=""
	if event.player_index then
		if playerslist[event.player_index] then
			msg=playerslist[event.player_index] .. ">>" .. event.message.."\n"
		else
			msg=event.player_index .. ">>" .. event.message.."\n"
		end
	else
		msg=">>" .. event.message.."\n"
	end
	game.write_file("chatlog.txt",msg,true,0)
	game.write_file("NEWlogs.txt",msg,true,0)
	game.write_file("logs.txt",msg,true,0)
	game.write_file("logsOLD.txt",msg,true,0)
	game.write_file("halfSUSPlogs.txt",msg,true,0)
	game.write_file("SUSPlogs.txt",msg,true,0)
	game.write_file("consolelog.txt",msg,true,0)
end)

script.on_event(defines.events.on_console_command, function(event)
	local msg=""
	if event.player_index then
		if playerslist[event.player_index] then
			if event.parameters then
				msg=playerslist[event.player_index] .. " did the command : " .. event.command.." ".. event.parameters.. "\n"
			else
				msg=playerslist[event.player_index] .. " did the command : " .. event.command.."\n"
			end
		else
		
			if event.parameters then
				msg=event.player_index .. " did the command : " .. event.command.." ".. event.parameters.. "\n"
			else
				msg=event.player_index .. " did the command : " .. event.command.."\n"
			end
		end
	else
		if event.parameters then
			msg=event.command.." ".. event.parameters.. "\n"
		else
			msg=event.command.."\n"
		end
	end
	game.write_file("consolelog.txt",msg,true,0)
end)