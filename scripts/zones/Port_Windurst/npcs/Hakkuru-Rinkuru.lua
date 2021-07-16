-----------------------------------
-- Area: Port Windurst
--  NPC: Hakkuru-Rinkuru
-- Involved In Quest: Making Amends
-- Starts and Ends Quest: Wonder Wands
-- !pos -111 -4 101 240
-----------------------------------
local ID = require("scripts/zones/Port_Windurst/IDs")
require("scripts/globals/settings")
require("scripts/globals/titles")
require("scripts/globals/keyitems")
require("scripts/globals/missions")
require("scripts/globals/quests")
-----------------------------------
local entity = {}

entity.onTrade = function(player, npc, trade)

    if player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.MAKING_AMENDS) == QUEST_ACCEPTED then
        if trade:hasItemQty(937, 1) and trade:getItemCount() == 1 then
            player:startEvent(277, 1500)
        else
            player:startEvent(275, 0, 937)
        end
    elseif player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.WONDER_WANDS) == QUEST_ACCEPTED then
        if trade:hasItemQty(17091, 1) and trade:hasItemQty(17061, 1) and trade:hasItemQty(17053, 1) and trade:getItemCount() == 3 then --Check that all 3 items have been traded, one each
            player:setCharVar("SecondRewardVar", 1)
            player:startEvent(265, 0, 17091, 17061, 17053) --Completion of quest cutscene for Wondering Wands
        else
            player:startEvent(260, 0, 17091, 17061, 17053) --Remind player which items are needed ifquest is accepted and items are not traded
        end
    end

end

entity.onTrigger = function(player, npc)

    local MakingAmends = player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.MAKING_AMENDS)
    local MakingAmens = player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.MAKING_AMENS) --Second quest in series
    local WonderWands = player:getQuestStatus(xi.quest.log_id.WINDURST, xi.quest.id.windurst.WONDER_WANDS) --Third and final quest in series
    local needToZone = player:needToZone()
    local pFame = player:getFameLevel(WINDURST)

        -- ~[ Windurst Mission 6-1 Full Moon Fountain ]~
    if (player:getCurrentMission(WINDURST) == xi.mission.id.windurst.FULL_MOON_FOUNTAIN and player:getMissionStatus(player:getNation()) == 0) then
        player:startEvent(456, 0, 248)
    elseif (player:getCurrentMission(WINDURST) == xi.mission.id.windurst.FULL_MOON_FOUNTAIN and player:getMissionStatus(player:getNation()) == 3) then
        player:startEvent(457)
    elseif (player:getCurrentMission(WINDURST) == xi.mission.id.windurst.TO_EACH_HIS_OWN_RIGHT and player:getMissionStatus(player:getNation()) == 2) then
        player:startEvent(147)
-- Begin Making Amends Section
    elseif (MakingAmends == QUEST_AVAILABLE and pFame >= 2) then
            player:startEvent(274, 0, 937) -- MAKING AMENDS + ANIMAL GLUE: Quest Start
    elseif (MakingAmends == QUEST_ACCEPTED) then
            player:startEvent(275, 0, 937) -- MAKING AMENDS + ANIMAL GLUE: Quest Objective Reminder
    elseif (MakingAmends == QUEST_COMPLETED and needToZone == true) then
            player:startEvent(278) -- MAKING AMENDS: After Quest
--End Making Amends Section; Begin Wonder Wands Section
    elseif (MakingAmends == QUEST_COMPLETED and MakingAmens == QUEST_COMPLETED and WonderWands == QUEST_AVAILABLE and pFame >= 5 and needToZone == false) then
            player:startEvent(259) --Starts Wonder Wands
    elseif (WonderWands == QUEST_ACCEPTED) then
            player:startEvent(260) --Reminder for Wonder Wands
    elseif (WonderWands == QUEST_COMPLETED) then
        if (player:getCharVar("SecondRewardVar") == 1) then
            player:startEvent(267) --Initiates second reward ifWonder Wands has been completed.
        end
    end
-- End Wonder Wands Section
end

entity.onEventUpdate = function(player, csid, option)
end

entity.onEventFinish = function(player, csid, option)

    if (csid == 147) then
        player:setMissionStatus(player:getNation(), 3)
    elseif (csid == 274 and option == 1) then
            player:addQuest(xi.quest.log_id.WINDURST, xi.quest.id.windurst.MAKING_AMENDS)
    elseif (csid == 277) then
            player:addGil(xi.settings.GIL_RATE*1500)
            player:completeQuest(xi.quest.log_id.WINDURST, xi.quest.id.windurst.MAKING_AMENDS)
            player:addFame(WINDURST, 75)
            player:addTitle(xi.title.QUICK_FIXER)
            player:needToZone(true)
            player:tradeComplete()
    elseif (csid == 259 and option == 1) then
            player:addQuest(xi.quest.log_id.WINDURST, xi.quest.id.windurst.WONDER_WANDS)
    elseif (csid == 267) then
        local rand = math.random(3) --Setup random variable to determine which 2 items are returned upon quest completion
        if (rand == 1) then
            if (player:getFreeSlotsCount() == 1) then
                player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 17061)
            elseif (player:getFreeSlotsCount() == 0) then
                player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 17091)
                player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 17061)
            else
                player:addItem(17091, 1)
                player:addItem(17061, 1) --Returns the Oak Staff and the Mythril Rod
                player:messageSpecial(ID.text.ITEM_OBTAINED, 17091)
                player:messageSpecial(ID.text.ITEM_OBTAINED, 17061)
                player:setCharVar("SecondRewardVar", 0)
            end
        elseif (rand == 2) then
            if (player:getFreeSlotsCount() == 1) then
                player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 17053)
            elseif (player:getFreeSlotsCount() == 0) then
                player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 17091)
                player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 17053)
            else
                player:addItem(17091, 1)
                player:addItem(17053, 1) --Returns the Oak Staff and the Rose Wand
                player:messageSpecial(ID.text.ITEM_OBTAINED, 17091)
                player:messageSpecial(ID.text.ITEM_OBTAINED, 17053)
                player:setCharVar("SecondRewardVar", 0)
            end
        elseif (rand == 3) then
            if (player:getFreeSlotsCount() == 1) then
                player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 17053)
            elseif (player:getFreeSlotsCount() == 0) then
                player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 17061)
                player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 17053)
            else
                player:addItem(17061, 1)
                player:addItem(17053, 1) --Returns the Rose Wand and the Mythril Rod
                player:messageSpecial(ID.text.ITEM_OBTAINED, 17061)
                player:messageSpecial(ID.text.ITEM_OBTAINED, 17053)
                player:setCharVar("SecondRewardVar", 0)
            end
        end
    elseif (csid == 265) then
        if (player:getFreeSlotsCount() == 0) then
            player:messageSpecial(ID.text.ITEM_CANNOT_BE_OBTAINED, 12750) -- New Moon Armlets
        else
            player:tradeComplete()
            player:addGil(xi.settings.GIL_RATE*4800)
            player:messageSpecial(ID.text.GIL_OBTAINED, 4800)
            player:addItem(12750) -- New Moon Armlets
            player:messageSpecial(ID.text.ITEM_OBTAINED, 12750) -- New Moon Armlets
            player:addFame(WINDURST, 150)
            player:addTitle(xi.title.DOCTOR_SHANTOTTOS_GUINEA_PIG)
            player:completeQuest(xi.quest.log_id.WINDURST, xi.quest.id.windurst.WONDER_WANDS)
        end
        -- ~[ Windurst Mission 6-1 Full Moon Fountain ]~
    elseif (csid == 456) then
            player:setMissionStatus(player:getNation(), 1)
            player:addKeyItem(xi.ki.SOUTHWESTERN_STAR_CHARM)
            player:messageSpecial(ID.text.KEYITEM_OBTAINED, xi.ki.SOUTHWESTERN_STAR_CHARM)
    end

end

return entity
