-----------------------------------
-- xi.effect.SIGNET
--   Signet is a a beneficial Status Effect that allows the acquisition of Conquest Points and Crystals
--   from defeated enemies that grant Experience Points.

--   Increased Healing HP
--   No TP loss while resting
--   Bonus experience earned in smaller parties
--   Increased defense and evasion against attacks from your auto-attack target when even match or lower
-----------------------------------
require("scripts/globals/status")
-----------------------------------
local effect_object = {}

effect_object.onEffectGain = function(target, effect)
    target:addLatent(xi.latent.SIGNET_BONUS, 0, xi.mod.DEF, 15)
    target:addLatent(xi.latent.SIGNET_BONUS, 0, xi.mod.EVA, 15)

    local power = getPower(target)

    target:setCharVar("SIGNET_REGEN_BONUS", power[1]);
    target:setCharVar("SIGNET_REFRESH_BONUS", power[2]);

    target:addMod(xi.mod.REGEN, power[1])
    target:addMod(xi.mod.REFRESH, power[2])

end

effect_object.onEffectTick = function(target, effect)
end

effect_object.onEffectLose = function(target, effect)
    target:delLatent(xi.latent.SIGNET_BONUS, 0, xi.mod.DEF, 15)
    target:delLatent(xi.latent.SIGNET_BONUS, 0, xi.mod.EVA, 15)

    local regen_power = target:getCharVar("SIGNET_REGEN_BONUS");
    local refresh_power = target:getCharVar("SIGNET_REFRESH_BONUS");

    target:delMod(xi.mod.REGEN, regen_power)
    target:delMod(xi.mod.REFRESH, refresh_power)

end

function getPower(target)

    local player_rank = target:getRank(target:getNation())
    local regen_power = 0
    local refresh_power = 0

    if player_rank == 10 then
        regen_power = 5
        refresh_power = 5
    elseif player_rank >= 8 then
        regen_power = 4
        refresh_power = 4
    elseif player_rank >= 6 then
        regen_power = 3
        refresh_power = 3
    elseif player_rank >= 3 then
        regen_power = 2
        refresh_power = 2
    elseif player_rank == 2 then
        regen_power = 1
        refresh_power = 1
    end

    return {regen_power, refresh_power}

end

return effect_object
