----
---- This is a sample CR to show and where to put your own custom cr's
---- Keep in mind this CR will not load at all unless you change the 
---- following 3 strings:
---- 'mySample' this needs to be changed to the name of your cr file or something simular - DO NOT USE 'DarkNCR'
---- 'Class' this needs to be changed to the Class you want to use this file - Follow the comments
---- 'Spec'  this needs to be changed to the Spec you want to use this file - Follow the comments
---- Lastly DO NOT FORGET to add your newly named file to the DarkN-CR.xml file - please use the section
---- at the bottom to avoid loading errors.
----
local myCR 		= 'mySample'									-- Change this to something Unique
local myClass 	= 'Mage'									-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Fire'									-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]	-- Do not change unless you know what your doing
local config 	= DarkNCR.menuConfig[Sidnum]
NeP.Interface.buildGUI(config)
local exeOnLoad = function()
	DarkNCR.Splash()
end


--------------- END of do not change area ----------------
--
--	Notes:
--
---------- This Starts the Area of your Rotaion ----------
local Survival = {
	-- Put skills or items here that are used to keep you alive!  Example: {'skillid'}, or {'#itemid'},


	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
	{'#5512', 'player.health <= UI(Healthstone)'}, 														-- Health stone
	{'#109223', 'player.health < 40'}, 											-- Healing Tonic
}

local Cooldowns = {
	--Put items you want used on CD below:     Example: {'skillid'},  
	
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#trinket1', 'UI(trink1)'},
	{'#trinket2', 'UI(trink2)'},
}

local Interrupts = {
	
	-- Place skills that interrupt casts below:		Example: {'skillid'},
	
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
	
}

local Keybinds = {

	{'pause', 'keybind(alt)'},													-- Pause
	
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