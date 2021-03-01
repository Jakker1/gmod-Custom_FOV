-- Custom FOV by Jäkker ^w^ --
--============<3============--

-- Create a console var for the custom fov --
if CLIENT then
	CreateClientConVar("cfov", 0)
end

-- Create the Set FOV tab in the menu options --
hook.Add( "AddToolMenuCategories", "menu_SetFOV", function()
	spawnmenu.AddToolMenuOption("Utilities", "Custom FOV", "Set FOV", "Set FOV", "", "", function(panel)
		panel:NumSlider( "FOV", "cfov", 85, 180, 0)
		panel:Help( "Set 0 to disable" )
	end)
end)

-- Calculate the new fov for the player --
local function CalcNewFOV(ply, pos, ang, fov)
	local newfov  = GetConVarNumber("cfov") - 100
	local val_fov = ply:GetFOV()

	local val_fov = val_fov + newfov -- final fov value

	-- table 'view' modified
	local cfov_view = {
			origin = pos,
			angles = ang,
			fov = val_fov,
			drawviewer = false
		}

	-- default view table when in third person 
	if ply:InVehicle() then
		if ply:GetVehicle():GetThirdPersonMode() then
			return view
		else
			return cfov_view
		end
	else
	    return cfov_view
	end
end

-- == ConVar 'cfov' CallBack == --
-- Everytime the player changes his fov this function will be called --
cvars.AddChangeCallback("cfov", function()
	if GetConVarNumber("cfov") ~= 0 then
		hook.Add("CalcView", "SetNewFOV", CalcNewFOV)
	else
		hook.Remove("CalcView", "SetNewFOV")
	end
end)
