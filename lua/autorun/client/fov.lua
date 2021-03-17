-- Custom FOV by Jäkker --
-- ==================== --

-- Create a console var for the custom fov --
if CLIENT then
	CreateClientConVar("cfov", 0)
end

-- Create the Set FOV tab in the menu options --
hook.Add( "AddToolMenuCategories", "menu_SetFOV", function()
	spawnmenu.AddToolMenuOption("Utilities", "Custom FOV", "Set FOV", "Set FOV", "", "", function(panel)
		panel:NumSlider( "FOV", "cfov", 85, 175, 0)
		panel:Help( "Set 0 to disable" )
	end)
end)

-- Calculate the new fov for the player --
local function CalcNewFOV(ply)
	local newfov  = GetConVarNumber("cfov") - 100
	local val_fov = ply:GetFOV()

	local val_fov = val_fov + newfov -- final fov value

	-- table 'view' modified 
	local cfov_view = {fov = val_fov}
	return cfov_view
end


-- == ConVar 'cfov' CallBack == --
-- Everytime the player changes his fov this function will be called --
cvars.AddChangeCallback("cfov", function()
	if GetConVarNumber("cfov") ~= 0 then
		hook.Add("CalcView", "SetNewFOV", function(ply)
			if ply:InVehicle() then
				if ply:GetVehicle():GetThirdPersonMode() then
					return end
			end
	    	return CalcNewFOV(ply)
		end)
	else
		hook.Remove("CalcView", "SetNewFOV")
	end
end)

-- Add command 'setfov' to the console --
concommand.Add( "setfov", function( ply, cmd, args, argStr )
	GetConVar("cfov"):SetInt( argStr )
end)