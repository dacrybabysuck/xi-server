-----------------------------------
-- Area: Sauromugue Champaign (120)
--  HNM: Roc
-----------------------------------
mixins =
{
    require("scripts/mixins/job_special"),
    require("scripts/mixins/rage")
}
require("scripts/globals/titles")
require("scripts/globals/status")
-----------------------------------
local entity = {}

entity.onMobInitialize = function(mob)
    mob:setMobMod(xi.mobMod.DRAW_IN, 1)
end

entity.onMobSpawn = function(mob)
    xi.mix.jobSpecial.config(mob, {
        specials = {
            {id = xi.jsa.BENEDICTION, hpp = 10},
        },
    })
end

entity.onMobDeath = function(mob, player, isKiller)
    player:addTitle(xi.title.ROC_STAR)
end

entity.onMobDespawn = function(mob)
    UpdateNMSpawnPoint(mob:getID())
    mob:setRespawnTime(math.random(75600, 86400)) -- 21 to 24 hours
end

return entity
