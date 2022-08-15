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
--     LCARS Wall Panel | Server     --
---------------------------------------

if not istable(INTERFACE) then Star_Trek:LoadAllModules() return end
local SELF = INTERFACE

SELF.BaseInterface = "base"

local buttons = {
	[1] = {
		Name = "Display Data",
	},
	[2] = {
		Name = "Forcefields",
		Disabled = true,
	},
	[3] = {
		Name = "Communicator",
		Disabled = true,
	},
	[12] = {
		Name = "Close",
		Color = Star_Trek.LCARS.ColorRed,
	},
}

function SELF:Open(ent)
	local keyValues = ent.LCARSKeyData

	local scale = keyValues["lcars_scale"] or 15
	local width = keyValues["lcars_width"]
	local height = keyValues["lcars_height"] or 35
	local title = keyValues["lcars_title"] or "Select Mode"
	title = string.Replace(title, "@", " ")

	local w = 16
	local h = height
	local x = -width / 2 + w / 2 + 0.5
	local success, window = Star_Trek.LCARS:CreateWindow(
		"button_list",
		Vector(x, 0, 0),
		Angle(),
		scale,
		w * scale,
		h * scale,
		function(windowData, interfaceData, ply, buttonId)
			if buttonId == 12 then
				ent:EmitSound("star_trek.lcars_close")
				interfaceData:Close()

				return
			end
		end,
		buttons,
		title,
		"MODE",
		true
	)
	if not success then
		return false, window
	end

	local w2 = width - w - 1
	local success2, mainWindow = Star_Trek.LCARS:CreateWindow(
		"log_entry",
		Vector((width - w2) / 2, 0, 0),
		Angle(),
		scale,
		(w2 - 1) * scale,
		h * scale,
		function(windowData, interfaceData, ply, buttonId)
		end,
		true,
		Color(255, 255, 255)
	)
	if not success2 then
		return false, mainWindow
	end

	return true, {window, mainWindow}, Vector(0, 0.5, 0.6)
end

-- Wrap for use in Map.
function Star_Trek.LCARS:OpenWallpanelMenu()
	Star_Trek.LCARS:OpenInterface(TRIGGER_PLAYER, CALLER, "wallpanel")
end