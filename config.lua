local QBCore = exports['qb-core']:GetCoreObject()

Config = {}

Config.ShroomField = vector3(3266.64, 5215.32, 19.65) -- Location of shroom field - NOTE: NO SUPPORT OFFERED FOR LOCATION CHANGES

Config.NotifyType = "okok" -- Notification type: 'qb' for qb-core standard notifications, 'okok' for okokNotify notifications

Config.mzskills = "yes" -- Change to "No" to run resource without regard to mz-skills "Drug Manufacturing"
 
--Picking shrooms
Config.ShroomskillChecklow = 1 -- Lowest number of parses of the skill check
Config.ShroomskillCheckhigh = 3 -- Highest number of parses of the skill check
Config.ShroomskillTime = 10 -- Time to complete skill check, the lower - the more difficult. 
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

--MZ-SKILLS
--OUTPUT (amount of final product player gets based on Drug Manufacturing level - with mz-skills)
--Level 0--
Config.Shroomlevel0low = 1
Config.Shroomlevel0high = 3
--Level 1--
Config.Shroomlevel1low = 2
Config.Shroomlevel1high = 4
--Level 2--
Config.Shroomlevel2low = 3
Config.Shroomlevel2high = 5
--Level 3--
Config.Shroomlevel3low = 3
Config.Shroomlevel3high = 7
--Level 4--
Config.Shroomlevel4low = 4
Config.Shroomlevel4high = 8
--Level 5--
Config.Shroomlevel5low = 4
Config.Shroomlevel5high = 10
--Level 6--
Config.Shroomlevel6low = 5
Config.Shroomlevel6high = 11
--Level 7--
Config.Shroomlevel7low = 6
Config.Shroomlevel7high = 12
--Level 8--
Config.Shroomlevel8low = 6
Config.Shroomlevel8high = 14

--OUTPUT (amount of final product player gets based on Drug Manufacturing level - with no mz-skills)
Config.ShroomNoXPlow = 4
Config.ShroomNoXPlow = 8