local QBCore = exports['qb-core']:GetCoreObject()

Config = {}

Config.ShroomField = vector3(3266.64, 5215.32, 19.65) -- Location of shroom field - NO SUPPORT FOR LOCATION CHANGES

Config.NotifyType = "okok" -- Notification type: 'qb' for qb-core standard notifications, 'okok' for okokNotify notifications

--Picking shrooms
Config.ShroomskillCheck = math.random(1, 2) -- Number of parses of the skill check
Config.ShroomskillTime = math.random(10, 12) -- Time to complete skill check, the lower - the more difficult. I would not go below 10.
--Making gloves
Config.MakeGlovesSkillCheck = math.random(3, 5) -- Number of parses of the skill check
Config.MakeGlovesProgressbar = math.random(7, 12) -- Time it takes (in seconds) to craft gardening gloves.
--Making shroom bag
Config.MakeShroomBagsSkillcheck = math.random(2, 4) -- Number of parses of the skill check
Config.MakeBagTime = math.random(2, 4) -- Time it takes (in seconds) to craft drug bag.
--Making shroom bag
Config.BagShroomsSkillcheck = math.random(3, 5) -- Number of parses of the skill check
Config.BagShroomsTime = math.random(4, 8) -- Time it takes (in seconds) to craft drug bag.

--Glove tear (removes gloves from player)
Config.GloveTearFailChance = 15 -- percentage chance to remove gloves from player upon player failing skill check (set to 0 to disable)
Config.GloveTearSuccessChance = 2 --percentage chance to remove gloves from player even if player is successful at skill check (set to 0 to disable)

--Shroom output (amount of final product player gets based on Drug Manufacturing level - with mz-skills)
Config.Shroomlevel0 = math.random(1, 3)
Config.Shroomlevel1 = math.random(2, 4)
Config.Shroomlevel2 = math.random(3, 5)
Config.Shroomlevel3 = math.random(3, 7)
Config.Shroomlevel4 = math.random(4, 8)
Config.Shroomlevel5 = math.random(4, 10)
Config.Shroomlevel6 = math.random(5, 11)
Config.Shroomlevel7 = math.random(6, 12)
Config.Shroomlevel8 = math.random(6, 14)

