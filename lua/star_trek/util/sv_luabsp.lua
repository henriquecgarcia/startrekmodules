---------------------------------------
---------------------------------------
--         Star Trek Modules         --
--                                   --
--            Created by             --
--       Jan 'Oninoni' Ziegler       --
--                                   --
-- This software can be used freely, --
--    but only distributed by me.    --
--                                   --
--    Copyright © 2022 Jan Ziegler   --
---------------------------------------
---------------------------------------

---------------------------------------
--          LuaBSP |  Server         --
---------------------------------------

function Star_Trek.Util:GetStaticPropsByModel(model, callback)
	local props = {}

	for _, lump_entry in pairs(self.MapData.static_props) do
		for _, entry in pairs(lump_entry.entries) do
			if entry.PropType == model then
				if isfunction(callback) and not callback(entry) then
					continue
				end

				table.insert(props, entry)
			end
		end
	end

	return props
end

function Star_Trek.Util:GetStaticPropsByModelList(modelList, callback)
	local props = {}

	for _, model in pairs(modelList) do
		local modelProps = Star_Trek.Util:GetStaticPropsByModel(model, callback)

		for _, entry in pairs(modelProps) do
			table.insert(props, entry)
		end
	end

	return props
end

function Star_Trek.Util:LoadCurrentMap()
	local mapName = game.GetMap()

	self.MapData = self:LoadMap(mapName)

	self.MapData:LoadStaticProps()

	hook.Run("Star_Trek.Util.MapLoaded")
end

local function loadMap()
	Star_Trek.Util:LoadCurrentMap()
end

hook.Add("Star_Trek.Sections.Loaded", "Star_Trek.Map.Setup", loadMap)