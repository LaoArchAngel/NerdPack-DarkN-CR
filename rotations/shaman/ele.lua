local myCR 		= 'DNCR'									-- Change this to something Unique
local myClass 	= 'Shaman'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Elemental'									-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR ..mySpec ..myClass					-- Do not change unless you know what your doing
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]	-- Do not change unless you know what your doing
local config 	= DarkNCR.menuConfig[Sidnum]
local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface.buildGUI(config)
	DarkNCR.ClassSetting(mKey)
end


local healthstn = function() 
	return E('player.health <= ' .. F('Healthstone')) 
end
--------------- END of do not change area ----------------
--
--	Notes:
--
---------- This Starts the Area of your Rotaion ----------
local Survival = {
	-- Put skills or items here that are used to keep you alive!  Example: {'skillid'}, or {'#itemid'},

 	{ 'Earth Elemental', 'player.health <= 55' },
  	{ 'Astral Shift', 'player.health <= 75' },
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', healthstn}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{ 'Healing Surge', 'player.health < 70' },
}

local Cooldowns = {
	--Put items you want used on CD below:     Example: {'skillid'},  

  	{ 'Elemental Mastery', 'toggle(cooldowns)' },
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', (function() return F('trink1') end)},
	{'#trinket2', (function() return F('trink2') end)},
}

local Interrupts = {
		-- Place skills that interrupt casts below:		Example: {'skillid'},
	{ 'Wind Shear'},
}

local Buffs = {
	--Put buffs that are applied out of combat below:     Example: {'skillid'}, 

}

local Pet = {
	--Put skills in here that apply to your pet needs, while out of combat! 

}

local Pet_inCombat = {
	-- Place your pets combat rotation here if it has one! 	Example: {'skillID'},

}

local AoE = {
	-- AoE Rotation goes here.
	
}

local ST = {
	-- Single target Rotation goes here
	{ 'Totem Mastery', 'player.totem.duration < 10' },
  	{ 'Flame Shock', 'target.debuff(Flame Shock).duration <= 3' },
  	{ 'Earth Shock', { 'player.maelstorm > 92', '!toggle(AoE)' } },

  	{ 'Lava Burst', 'player.buff(Lava Surge)' },
  	{ 'Lava Burst' },
  
  	{ 'Flame Shock', { 'target.debuff(Flame Shock).duration < 10.5', 'player.maelstorm >= 20' } },
 
  	{ 'Earthquake Totem', 'toggle(AoE)', 'ground' },
  	{ 'Earth Shock', { 'player.maelstorm > 86', '!toggle(AoE)' } },

  	{ 'Chain Lightning', 'toggle(AoE)' },
  	{ 'Lightning Bolt', '!toggle(AoE)' },

}

local Keybinds = {
	{ 'Bloodlust', 'keybind(ralt)' },
  	{ 'Fire Elemental',  'keybind(rcontrol)' },
  	{ 'Ascendance', { 'keybind(rshift)', '!player.buff(Ascendance)' } },
	{'pause', 'keybind(lalt)'},													-- Pause
	
}

local outCombat = {
	{Keybinds},
	{Buffs},
	{Pet}
}

NeP.CR:Add(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		{Keybinds},
		{Interrupts, 'target.interruptAt(15)'},
		{Survival, 'player.health < 100'},
		{Cooldowns, 'toggle(cooldowns)'},
		{Pet_inCombat},
		{AoE, {'player.area(8).enemies >= 3','toggle(AoE)'}},
		{ST}
	}, outCombat, exeOnLoad)