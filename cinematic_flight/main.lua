--[[******************************************************************************************
                                H2-MOD SERVER SCRIPTS                                  ******
********************************************************************************************
**
** - COMPONENT   : CINEMATIC FLIGHT TRAVEL [REVISION 1]
** - Description : Spawn camera; then link player view to that; then fly it around 
** - AUTHOR      : Hosseinpourziyaie                                and then have fun :)
** - EXTRA NOTES : Base Code From My IW6X Cinematic Script;
**                               justed port and modified it to work with mw2cr sp
** - INITIAL R   : 5 January 2021    | PORTED ON 10 September 2021 FOR H2-MOD
** 
** 
** [NOTE] ******************************************************************************
**
** [NOTE] As of this revision Bezier Flight not available. Its just simple Linear fly
**         Its possible tho to have camera rotate with start_ang, finish_ang parameters 
**
** [WARNING] PLEASE DONT USE THIS SCRIPT FOR COMMERCIAL PURPOSES WITHOUT AUTHOR'S PERMISSION 
** 
** [Copyright © Hosseinpourziyaie 2020] <hosseinpourziyaie@gmail.com>
** 
****************************************************************************************--]]

function player_angles_lock_to_camera(target, source)
	target:setplayerangles(source.angles)
end

function camera_movement(camera, s_origin, f_origin, s_angles, f_angles, length)	
	camera.origin = s_origin
	camera.angles = s_angles
		
	camera:moveto( f_origin, length )
	
	if s_angles ~= f_angles then
        camera:rotateto( f_angles, length, 0, 0 )
    end	
end

function travel_start(player)
	--if tablelength(global_travel_paths) == 0 then return end -- commented out due to tablelength func failure in h2-mod. not sure why. its not end of the world tho; map flight path existance been checked once before

	local camera = game:spawn("script_model", player.origin)
	camera:setmodel("tag_origin")
	--camera:enablelinkto() -- seems quite un-necessary :|
	
	local AnglesLockInterval = game:oninterval(function() player_angles_lock_to_camera(player, camera) end, 20)

	--player:linkto(camera) -- idk what this is for :|
	player:playerlinktodelta(camera, "tag_origin")
	player:freezecontrols( true )

	local total_length = 0;
	for _, data in ipairs(global_travel_paths) do	
	  if data.start_ang and data.finish_ang then
	    local setup_moveto = game:ontimeout(function() camera_movement(camera, data.start_pos, data.finish_pos, data.start_ang, data.finish_ang, data.fly_length) end, total_length * 1000)
      else
	    local setup_moveto = game:ontimeout(function() camera_movement(camera, data.start_pos, data.finish_pos, data.cam_angles, data.cam_angles, data.fly_length) end, total_length * 1000)
	  end
  	  
	  total_length = total_length + data.fly_length
	end

	local travel_dispose = game:ontimeout(function () player:unlink(); camera:delete(); AnglesLockInterval:clear(); travel_dispose(player); end, total_length * 1000);
end

function travel_dispose(player)
	--game:setdvar("cg_draw2d",1)
	--player:giveweapon("iw6_knifeonly_mp") -- seriously?
	 
	--player:visionsetnaked( game:getdvar("mapname"), 3.0 ); -- nah Im ok!
	
	travel_start(player) -- repeat same routes forever :)
end

function travel_initialize(player)
	player:takeallweapons()
	--game:setdvar("cg_draw2d",0)

	--player:visionsetnaked( "mpOutro", 2.0 ); -- closest alternative I found for it in function_tables was "visionsetnakedforplayer" that didnt work; maybe mpOutro vision been removed from cod games and Im not aware of?
	
	travel_start(player)
end

function setup_travel_paths(map)
	---------------          MAP ESTATE : The loose ends song; I cant get it out of my mind!           ---------------  
    if map == "estate" then
	global_travel_paths[1] = {}
	global_travel_paths[1]["start_pos"] = vector:new(1192.40, 652.800, 446.80)
	global_travel_paths[1]["start_ang"] = vector:new(0009.40, -153.60, 000.00)
	global_travel_paths[1]["finish_pos"] = vector:new(864.20, 954.200, 157.80)
	global_travel_paths[1]["finish_ang"] = vector:new(-7.400, -124.40, 0.0000)
	global_travel_paths[1]["fly_length"] = 14
	
	global_travel_paths[2] = {}
	global_travel_paths[2]["start_pos"] = vector:new(0394.10, 0464.80, 81.30)
	global_travel_paths[2]["start_ang"] = vector:new(0014.30, -118.90, 0.000)
	global_travel_paths[2]["finish_pos"] = vector:new(315.70, 0300.40, 60.80)
	global_travel_paths[2]["finish_ang"] = vector:new(24.300, -124.00, 0.000)
	global_travel_paths[2]["fly_length"] = 18
	
	global_travel_paths[3] = {}
	global_travel_paths[3]["start_pos"] = vector:new(32.00, -3525.40, -138.00)
	global_travel_paths[3]["start_ang"] = vector:new(01.40, 124.50, 0.00)
	global_travel_paths[3]["finish_pos"] = vector:new(-781.40, -3141.30, -87.20)
	global_travel_paths[3]["finish_ang"] = vector:new(3.60, 40.90, 0.00)
	global_travel_paths[3]["fly_length"] = 16
	
	return true
	
	---------------      GULAG : I really hate gulag in verdansk. hope circle never shifts there!      ---------------
	
	--[[elseif map == "gulag" then
	global_travel_paths[1] = {}
	global_travel_paths[1]["start_pos"]  = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[1]["finish_pos"] = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[1]["cam_angles"] = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[1]["fly_length"] = 0

	global_travel_paths[2] = {}
	global_travel_paths[2]["start_pos"]  = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[2]["finish_pos"] = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[2]["cam_angles"] = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[2]["fly_length"] = 0
	
	global_travel_paths[3] = {}
	global_travel_paths[3]["start_pos"]  = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[3]["finish_pos"] = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[3]["cam_angles"] = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[3]["fly_length"] = 0
	
	return false--]]
		
	---------------  MUSEUM : cod mobile did what ppl wanted out of cod yet premium cod releases are failing for years!  ---------------
	elseif map == "ending" then 	
	global_travel_paths[1] = {}
	global_travel_paths[1]["start_pos"] = vector:new(-15236.50, 24656.60, -16282.90)
	global_travel_paths[1]["start_ang"] = vector:new(-6.60, 104.20, 0.00)
	global_travel_paths[1]["finish_pos"] = vector:new(-15356.00, 24590.80, -16326.50)
	global_travel_paths[1]["finish_ang"] = vector:new(-17.70, 50.80, 0.00)
	global_travel_paths[1]["fly_length"] = 14
	
	global_travel_paths[2] = {}
	global_travel_paths[2]["start_pos"] = vector:new(-16209.00, 24073.60, -16231.50)
	global_travel_paths[2]["start_ang"] = vector:new(4.80, 138.90, 0.0)
	global_travel_paths[2]["finish_pos"] = vector:new(-16420.80, 24082.10, -16326.20)
	global_travel_paths[2]["finish_ang"] = vector:new(-19.40, 54.60, 0.0)
	global_travel_paths[2]["fly_length"] = 18
	
	global_travel_paths[3] = {}
	global_travel_paths[3]["start_pos"] = vector:new(-14118.00, 24605.50, -16252.00)
	global_travel_paths[3]["start_ang"] = vector:new(000000.20, -37.1000, 0.00)
	global_travel_paths[3]["finish_pos"] = vector:new(-14109.80, 24173.60, -16250.80)
	global_travel_paths[3]["finish_ang"] = vector:new(000002.30, 44.8000, 0.00)
	global_travel_paths[3]["fly_length"] = 14
		
	return true
	
	---------------  RUST : Remember my first time playing mw2 online was on plusmaster back in 2015!  ---------------
	--[[elseif map == "af_chases" then 	
	global_travel_paths[1] = {}
	global_travel_paths[1]["start_pos"]  = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[1]["finish_pos"] = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[1]["cam_angles"] = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[1]["fly_length"] = 0

	global_travel_paths[2] = {}
	global_travel_paths[2]["start_pos"]  = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[2]["finish_pos"] = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[2]["cam_angles"] = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[2]["fly_length"] = 0
	
	global_travel_paths[3] = {}
	global_travel_paths[3]["start_pos"]  = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[3]["finish_pos"] = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[3]["cam_angles"] = vector:new(00.00, 00.00, 00.00)
	global_travel_paths[3]["fly_length"] = 0
		
	return true--]]
	
    else
      print("[ WARNING ] no travel script for map " .. map .. " found. skipping Cinematic Travel plugin load")
	  
	  return false
    end
end

--[[function cleartriggers() -- I found it somewhere but it appears to not be working at all!
    local spawners = game:getspawnerteamarray("axis")

    local ents = game:getentarray()
    for i = 1, #ents do
        if ((ents[i].classname ~= nil and ents[i].classname:match("trigger")) or (type(ents[i].team == "string") and ents[i] ~= player and table.find(spawners, ents[i]) == nil)) then
            ents[i]:delete()
        end
    end
end--]]
---------------                        MAIN INITIALIZE                       ---------------
--game:setdvar("sv_cheats",1) -- it may be required for setting cg_draw2d. not sure tho as dvars cheat-protected values might be modified in h2-mod

global_travel_paths = {}          -- create the matrix

if setup_travel_paths(game:getdvar("mapname")) then
    --cleartriggers() -- makes the actual mission basically stop
    game:ontimeout(function() travel_initialize(player) end, 5000)
end 

---------------   [DEVELOPER TOOL]THIS PART IS FOR RECORDING FLIGHT PATHZ    ---------------
--[[function append_log(data)
    local f = io.open("cinematic_dev_" .. game:getdvar("mapname") .. ".log", "a"); -- why it cant be ("%s/developer_logs/%s.log"):format(scriptdir(), game:getdvar("mapname"))?
    f:write(data);
    f:flush();
    f:close();
end

player:notifyonplayercommand("save_start_cam", "+activate")
player:onnotify("save_start_cam", function()
    append_log("	global_travel_paths[i][\"start_pos\"] = vector:new(" .. player.origin.x .. ", " .. player.origin.y .. ", " .. player.origin.z .. ")\n	global_travel_paths[i][\"start_ang\"] = vector:new(" .. player:getplayerangles().x .. ", " .. player:getplayerangles().y .. ", " .. player:getplayerangles().z .. ")\n")
    game:iprintlnbold("start_pos saved -> " .. player.origin.x .. "," .. player.origin.y .. "," .. player.origin.z .. " (" .. player:getplayerangles().x .. ", " .. player:getplayerangles().y .. ", " .. player:getplayerangles().z .. ")" )
    print(string.format("start_pos saved -> %f, %f, %f (%f, %f, %f)", player.origin.x, player.origin.y, player.origin.z, player:getplayerangles().x, player:getplayerangles().y, player:getplayerangles().z)--[[, string.format("vector:new(%f, %f, %f)", player.angles.x, player.angles.y, player.angles.z)]])
end)

player:notifyonplayercommand("save_finish_cam", "+melee_zoom")
player:onnotify("save_finish_cam", function()
    append_log("	global_travel_paths[i][\"finish_pos\"] = vector:new(" .. player.origin.x .. ", " .. player.origin.y .. ", " .. player.origin.z .. ")\n	global_travel_paths[i][\"finish_ang\"] = vector:new(" .. player:getplayerangles().x .. ", " .. player:getplayerangles().y .. ", " .. player:getplayerangles().z .. ")\n")
    game:iprintlnbold("finish_pos saved -> " .. player.origin.x .. "," .. player.origin.y .. "," .. player.origin.z .. " (" .. player:getplayerangles().x .. ", " .. player:getplayerangles().y .. ", " .. player:getplayerangles().z .. ")" )
	print(string.format("finish_pos saved -> %f, %f, %f (%f, %f, %f)", player.origin.x, player.origin.y, player.origin.z, player:getplayerangles().x, player:getplayerangles().y, player:getplayerangles().z)--[[, string.format("vector:new(%f, %f, %f)", player.angles.x, player.angles.y, player.angles.z)]])
end)--]]

---------------                        EXTRA UTILITIES                       ---------------

function tablelength(T) -- https://stackoverflow.com/questions/2705793/how-to-get-number-of-entries-in-a-lua-table
  local count = 0
  for _ in pairs(T) do count = count + 1 end
  return count
end