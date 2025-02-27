local module = {}

local function onlevel_create_impostorlake()
	if feelingslib.feeling_check(feelingslib.FEELING_ID.RUSHING_WATER) then
		local x, y = 22.5, 88.5--80.5
		local w, h = 40, 12
		spawn_impostor_lake(
			AABB:new(
				x-(w/2),
				y+(h/2),
				x+(w/2),
				y-(h/2)
			),
			LAYER.FRONT, ENT_TYPE.LIQUID_IMPOSTOR_LAKE, 1.0
		)
	end
end

local function onlevel_removeborderfloor()
	if (
		state.theme == THEME.NEO_BABYLON
		-- or state.theme == THEME.OLMEC -- Lava touching the void ends up in a crash
	) then
		local xmin, _, xmax, ymax = get_bounds()
		for yi = ymax-0.5, (ymax-0.5)-2, -1 do
			for xi = xmin+0.5, xmax-0.5, 1 do
				local blocks = get_entities_at(0, MASK.FLOOR, xi, yi, LAYER.FRONT, 0.3)
				kill_entity(blocks[1])
			end
		end
	end
end

local function onlevel_replace_border_textures()
	if (
		state.theme == THEME.EGGPLANT_WORLD
		or state.theme == THEME.VOLCANA
	) then
		
		local texture_def = get_texture_definition(TEXTURE.DATA_TEXTURES_BORDER_MAIN_0)
		if state.theme == THEME.EGGPLANT_WORLD then
			texture_def.texture_path = "res/worm_border.png"
		elseif state.theme == THEME.VOLCANA then
			texture_def.texture_path = "res/hell_border.png"
		end
		local boneder_texture = define_texture(texture_def)

		local bonebordere = get_entities_by_type(ENT_TYPE.FLOOR_BORDERTILE) -- get all entities of these types
		for _, boneborder_uid in pairs(bonebordere) do 
			get_entity(boneborder_uid):set_texture(boneder_texture)

			local boneborderdecoratione = entity_get_items_by(boneborder_uid, ENT_TYPE.DECORATION_BORDER, 0)
			for _, boneborderdecoration_uid in pairs(boneborderdecoratione) do
				get_entity(boneborderdecoration_uid):set_texture(boneder_texture)
			end
		end
	end
end

local function onlevel_remove_cursedpot()
	local cursedpot_uids = get_entities_by_type(ENT_TYPE.ITEM_CURSEDPOT)
	if #cursedpot_uids > 0 and options.hd_og_cursepot_enable == false then
		local xmin, ymin, _, _ = get_bounds()
		local void_x = xmin - 3.5
		local void_y = ymin
		spawn_entity(ENT_TYPE.FLOOR_BORDERTILE, void_x, void_y, LAYER.FRONT, 0, 0)
		for _, cursedpot_uid in ipairs(cursedpot_uids) do
			move_entity(cursedpot_uid, void_x, void_y+1, 0, 0)
		end
	end
end

local function onlevel_remove_mounts()
	local mounts = get_entities_by_type({
		ENT_TYPE.MOUNT_TURKEY
		-- ENT_TYPE.MOUNT_ROCKDOG,
		-- ENT_TYPE.MOUNT_AXOLOTL,
		-- ENT_TYPE.MOUNT_MECH
	})
	-- Avoid removing mounts players are riding or holding
	-- avoid = {}
	-- for i = 1, #players, 1 do
		-- holdingmount = get_entity(players[1].uid):as_movable().holding_uid
		-- mount = get_entity(players[1].uid):topmost()
		-- -- message(tostring(mount.uid))
		-- if (
			-- mount ~= players[1].uid and
			-- (
				-- mount:as_container().type.id == ENT_TYPE.MOUNT_TURKEY or
				-- mount:as_container().type.id == ENT_TYPE.MOUNT_ROCKDOG or
				-- mount:as_container().type.id == ENT_TYPE.MOUNT_AXOLOTL
			-- )
		-- ) then
			-- table.insert(avoid, mount)
		-- end
		-- if (
			-- holdingmount ~= -1 and
			-- (
				-- holdingmount:as_container().type.id == ENT_TYPE.MOUNT_TURKEY or
				-- holdingmount:as_container().type.id == ENT_TYPE.MOUNT_ROCKDOG or
				-- holdingmount:as_container().type.id == ENT_TYPE.MOUNT_AXOLOTL
			-- )
		-- ) then
			-- table.insert(avoid, holdingmount)
		-- end
	-- end
	if state.theme == THEME.DWELLING and (state.level == 2 or state.level == 3) then
		for t, mount in ipairs(mounts) do
			-- stop_remove = false
			-- for _, avoidmount in ipairs(avoid) do
				-- if mount == avoidmount then stop_remove = true end
			-- end
			local mov = get_entity(mount)
			if test_flag(mov.flags, ENT_FLAG.SHOP_ITEM) == false then --and stop_remove == false then
				move_entity(mount, 0, 0, 0, 0)
			end
		end
	end
end

local function onlevel_remove_boulderstatue()
	if state.theme == THEME.ICE_CAVES then
		local boulderbackgrounds = get_entities_by_type(ENT_TYPE.BG_BOULDER_STATUE)
		if #boulderbackgrounds > 0 then
			kill_entity(boulderbackgrounds[1])
		end
	end
end

-- set_pre_entity_spawn(function(ent_type, x, y, l, overlay)
-- 	-- SORRY NOTHING
-- end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_YAMA_PLATFORM)

-- set_pre_entity_spawn(function(ent_type, x, y, l, overlay)
-- 	-- SORRY NOTHING
-- end, SPAWN_TYPE.ANY, 0, ENT_TYPE.BG_YAMA_BODY)

-- set_post_entity_spawn(function(entity)
--     entity.flags = set_flag(entity.flags, ENT_FLAG.INVISIBLE)
-- 	entity.flags = set_flag(entity.flags, ENT_FLAG.TAKE_NO_DAMAGE) -- Unneeded(?)
-- 	entity.flags = set_flag(entity.flags, ENT_FLAG.PAUSE_AI_AND_PHYSICS)
-- end, SPAWN_TYPE.ANY, 0, ENT_TYPE.MONS_YAMA)
-- # TODO: Relocate MONS_YAMA to a better place. Can't move him to back layer, it triggers the slow music :(
	-- OR: improve hiding him. Could use set_post_entity_spawn.
local function onlevel_hide_yama()
    if state.theme == THEME.EGGPLANT_WORLD then
        -- kill_entity(get_entities_by_type(ENT_TYPE.BG_YAMA_BODY)[1])
        -- for i, yama_floor in ipairs(get_entities_by_type(ENT_TYPE.FLOOR_YAMA_PLATFORM)) do
        -- 	kill_entity(yama_floor)
        -- end

        -- local yama = get_entity(get_entities_by_type(ENT_TYPE.MONS_YAMA)[1])
        -- yama.flags = set_flag(yama.flags, ENT_FLAG.INVISIBLE)
        -- yama.flags = set_flag(yama.flags, ENT_FLAG.TAKE_NO_DAMAGE) -- Unneeded(?)
        -- yama.flags = set_flag(yama.flags, ENT_FLAG.PAUSE_AI_AND_PHYSICS)
        -- move_entity(0, 1000, 0, 0)
    end
end

function module.onlevel_touchups()
	onlevel_remove_cursedpot()
	onlevel_remove_mounts()
	onlevel_hide_yama()
	onlevel_replace_border_textures()
	onlevel_removeborderfloor()
	onlevel_create_impostorlake()
	onlevel_remove_boulderstatue()
end

-- set_post_entity_spawn(function(entity)
-- 	entity.flags = set_flag(entity.flags, ENT_FLAG.DEAD)
-- 	entity:destroy()
-- end, SPAWN_TYPE.LEVEL_GEN_FLOOR_SPREADING, 0)

-- Use junglespear traps for idol trap blocks and other blocks that shouldn't have post-destruction decorations
set_post_entity_spawn(function(_entity)
	local _spikes = entity_get_items_by(_entity.uid, ENT_TYPE.LOGICAL_JUNGLESPEAR_TRAP_TRIGGER, 0)
	for _, _spike in ipairs(_spikes) do
		kill_entity(_spike)
	end
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_JUNGLE_SPEAR_TRAP)

set_pre_entity_spawn(function(ent_type, x, y, l, overlay)
	return spawn_grid_entity(ENT_TYPE.FLOOR_BORDERTILE_METAL, x, y, l)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD)

set_pre_entity_spawn(function(ent_type, x, y, l, overlay)
	return spawn_grid_entity(ENT_TYPE.FLOOR_BORDERTILE_METAL, x, y, l)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD_TOP)

set_post_entity_spawn(function(entity)
	entity:fix_decorations(true, true)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD)

set_post_entity_spawn(function(entity)
	entity:fix_decorations(true, true)
end, SPAWN_TYPE.ANY, 0, ENT_TYPE.FLOOR_HORIZONTAL_FORCEFIELD_TOP)

-- set_pre_tile_code_callback(function(x, y, layer)
	-- if state.theme == THEME.JUNGLE then
		-- if detect_s2market() == true and layer == LAYER.FRONT and y < 88 then
			-- -- spawn(ENT_TYPE., x, y, layer, 0, 0)
			-- return true
		-- end
	-- end
	-- spawn(ENT_TYPE.FLOOR_GENERIC, x, y, layer, 0, 0)
	
	-- return true
-- end, "floor")

-- `set_pre_tile_code_callback` todos:
	-- “floor” -- if state.camp and shortcuts discovered, then
		-- if state.transition, if transition between worm and next level then
			-- replace floor with worm guts
		-- end
		-- if transition from jungle to ice caves then
			-- replace stone with floor_jungle end if transition from ice caves to temple then replace quicksand with stone
		-- end
		-- if state.level and detect_s2market()
			-- if (within the coordinates of where water should be)
				-- replace with water
			-- if (within the coordinates of where border should be)
				-- return false
			-- if (within the coordinates of where void should be)
				-- replace with nothing
			-- end
	-- “border(?)” see if you can change styles from here
		-- if detect_s2market() and `within the coordinates of where water should be` then
			-- replace with water
		-- end

	-- “treasure” if state.theme == THEME.OLMEC (or temple?) then use the hd tilecode chance for treasure when in temple/olmec
	-- “regenerating_wall50%” if state.theme == THEME.EGGPLANTWORLD then use the hd tilecode chance for floor50%(“2”) when in the worm


return module