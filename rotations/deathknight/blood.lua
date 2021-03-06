local myCR 		= 'DNCR'							-- Change this to something Unique
local myClass 	= 'DeathKnight'						-- Change to your Class Name DO NOT USE SPACES - This is Case Sensitive, see specid_lib.lua for proper class and spec usage
local mySpec 	= 'Blood'							-- Change this to the spec your using DO NOT ABREVIEATE OR USE SPACES
----------	Do not change unless you know what your doing ----------
local mKey 		=  myCR ..mySpec ..myClass			-- Do not change unless you know what your doing
local Sidnum 	= DarkNCR.classSpecNum[myClass..mySpec]
local config 	= DarkNCR.menuConfig[Sidnum]

local E = DarkNCR.dynEval
local F = function(key) return NeP.Interface.fetchKey(mKey, key) end

local exeOnLoad = function()
	DarkNCR.Splash()
	NeP.Interface:AddToggle({
		key = 'saveDS',
		icon = 'Interface\\Icons\\spell_deathknight_butcher2.png',
		name = 'Save a Death Strike',
		text = 'Saving Runic.'
	})
	NeP.Interface:AddToggle({
		key = 'dpstest', 
		icon = 'Interface\\Icons\\inv_misc_pocketwatch_01', 
		name = 'DPS Test', 
		text = 'Stop combat after 5 minutes in order to do a controlled DPS test'
	})
	NeP.Interface:AddToggle({
		key = 'myat', 
		icon = 'Interface\\Icons\\ability_hunter_snipershot', 
		name = 'Auto Target', 
		text = 'Automatically target the nearest enemy when target dies or does not exist'
	})
end
----------	END of do not change area ----------
----- try my own range check----
local myRcheck = function ()
	local myRange = 0
	local myunit = 'target'
	if UnitExists(myunit) and UnitIsVisible(myunit) then
		myRange = IsSpellInRange('75',unit)
	end
	if myRange==1 then
		return true
	end
end

---------- This Starts the Area of your Rotaion ----------
local dpsCheck ={
	-- DPS Timmer
	{ '/stopcasting\n/stopattack\n/cleartarget\n/stopattack\n/cleartarget\n/petpassive', { 'player.time >= 300', 'toggle(dps)test' }},
}

local Survival = {
	{'Lifeblood'},
	{'Berserking'},
	{'Blood Fury'},
	{'#5512', 'player.health <= UI(Healthstone)'}, 																					-- Health stone
	{'#109223','player.health <= 50'},																		-- Healing Tonic
}

local Cooldowns = {
	{'49028'}, 																								-- Dancing RuneWeapon
	{'55233', 'player.health <= 50'}, 																		-- Vampiric Blood
	{'#trinket1', 'UI(trink1)'},
	{'#trinket2', 'UI(trink2)'},   
}

local Interrupts = {
	-- Place skills that interrupt casts below:		Example: {'skillid'},
	{'47528'},																								-- Mind Freeze
	{'221562'},																								-- Asphyxiate
}

local AoE = {

}

local ST = {
	{dpsCheck},
	--- my auto target
	{ '/targetenemy [noexists]', { 'toggle(myat)', '!target.exists' } },
	{ '/targetenemy [dead]', { 'toggle(myat)', 'target.exists', 'target.dead' } },

	
	{ '50842', '!target.debuff(55078)', 'target'},															-- BloodBoil
	{ '195182', 'player.buff(195181).count <= 6', 'target'},												-- Marrowrend w Bone Shield
	{ '195182', 'player.buff(195181).duration <= 3', 'target'},												-- Marrowrend
	{ '49998', {'player.buff(55233)','!toggle(saveDS)'}, 'target'},											-- Death Strike w Vampiric Blood
	{ '50842', 'player.spell(50842).charges >= 1', 'target'},												-- BloodBoil
	{ '43265', 'player.buff(81141)', 'target.ground' },														-- DnD
	{ '49998', {'player.health <= 90','!toggle(saveDS)'}, 'target'},											-- Death Strike
    { '206930',{'player.buff(195181).count > 6', 'player.runes > 2'}, 'target'},							-- Heart Strike
    { '49998', {'player.energy >= 75','!toggle(saveDS)'}, 'target'},											-- Death Strike
}

local Keybinds = {
	{'pause', 'keybind(alt)'},																				-- Pause
	{'43265', 'keybind(lcontrol)', 'target.ground' },														-- DnD
	{'108199', 'keybind(lshift)'}																			-- GGrasp
}

local outCombat = {
	{Keybinds},
}

NeP.CR:Add(Sidnum, '[|cff'..DarkNCR.Interface.addonColor ..myCR..'|r]'  ..mySpec.. ' '..myClass, 
	{-- In-Combat
		--{dpsCheck},
		{Keybinds},
		{Survival, 'player.health < 100'},
		{Interrupts, 'target.interruptAt(15)'},
		{Cooldowns, 'toggle(cooldowns)'},
		--{AoE, {'player.area(8).enemies >= 3','toggle(AoE)'}},
		{ST}
	}, outCombat, exeOnLoad)