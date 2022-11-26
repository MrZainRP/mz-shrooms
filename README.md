## MZ-SHROOMS - a self-contained, progression based script for the harvesting and processing of mushrooms in qb-core

By Mr_Zain#4139

- A self-contained, customistable resource introducing the shroom drug to qb-core servers with collection, processing and use modifiers included.
- Skill checks and progressbar timings are easily customisable in the config.lua
- Output varies depending on drug manufacturing level of the player (see updated mz-skills for Drug Manufacturing additional skill)
- Configured to function with standard qb-core notifications and oKoKNotify

## DEPENDENCIES

NOTE: You should have each of the dependencies other than qb-lock and mz-skills as part of a conventional qb-core install.

**[mz-skills](https://github.com/MrZainRP/mz-skills)** - to track skill progress. All credit to Kings#4220 for the original qb-skillz now **[B1-skillz](https://github.com/Burn-One-Studios/B1-skillz)**

**[progressbar](https://github.com/qbcore-framework/progressbar)**

**[qb-target](https://github.com/qbcore-framework/qb-target)**

**[ps-ui](https://github.com/Project-Sloth/ps-ui)**

OPTIONAL: (Configured to work with okokNotify as well as base qb-core notifications).

## Installation Instruction

## A. MZ-SKILLS

1. Ensure that mz-skills forms part of your running scripts. If you have downloaded mz-skills before and are running it, please make sure you download the latest version of it. 

2. Run the "skills.sql" sql file and open the database. (This will add a data table to the existing "players" database which will hold the skill value for "Scraping" as well as other jobs)

## B. QB-CORE/SHARED/ITEMS.LUA

3. Add the following items to qb-core/shared/items.lua 

PLEASE NOTE: If you are using other mz- resources you will not need to re-add certain items. Also be sure not to have conflicting items with the same name in your qb-core/items.lua.

```lua
	-- mz-shrooms
   ["gardengloves"] 		 	 	 = {["name"] = "gardengloves",           		["label"] = "Gardening Gloves",	 		["weight"] = 500, 		["type"] = "item", 		["image"] = "gardengloves.png", 		["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "A sturdy set of gardening gloves, used to avoid harm when gardening."},
    ["shroombaggy"] 		 	 	 = {["name"] = "shroombaggy",           		["label"] = "Empty Bag", 				["weight"] = 100,		["type"] = "item", 		["image"] = "shroombaggy.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "A small plastic bag, cheap and easy to store perishables temporarily."},
    ["shroombag"] 		 	 	 	 = {["name"] = "shroombag",           			["label"] = "Bag of Shrooms", 			["weight"] = 160,		["type"] = "item", 		["image"] = "bagofshrooms.png", 		["unique"] = false, 	["useable"] = true, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "A small bag containing hallucinogenic mushrooms."},
    ["shroom"] 		 	 	 	 	 = {["name"] = "shroom",           				["label"] = "Mushroom", 				["weight"] = 40,		["type"] = "item", 		["image"] = "mushroom.png", 			["unique"] = false, 	["useable"] = false, 	["shouldClose"] = false,   ["combinable"] = nil,   ["description"] = "A strange looking mushroom, smells kind of funky?"},

```

## C. IMAGES

4. Add the images which appear in the "images" folder to your inventory images folder. 

If using lj-inventory, add the images to: lj-inventory/html/images/ - if you are using qb-inventory, add the images to qb-inventory/html/images/

## D. ITEMS FOR CRAFTING

5. "fabric" and "plastic" are a part of mz-bins (another free resource) - if your server does not have an alternative way to obtain these items (they are not a part of this resource) then you will need to substitute them out for other materials in order to effectively craft gardening gloves. You could, alternatively, simply sell the gardening gloves at the hardware store for a simple fix. 

## E. FINALISATION

6. If you attend to all of the above steps you will need to restart the server in order for the new added items to be recognised by qb-core. Please restart your server ensuring that mz-shrooms is ensured/starts after qb-core starts (ideally it should just form part of your [qb] folder).

## F. mz-resource

7. [Testing] Changes are now pushed to mz-resources Discord: https://discord.gg/CqNYvE3CkA
