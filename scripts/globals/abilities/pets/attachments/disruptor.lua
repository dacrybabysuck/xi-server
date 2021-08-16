-----------------------------------
-- Attachment: Disruptor
-----------------------------------
require("scripts/globals/automaton")
require("scripts/globals/status")
-----------------------------------
local attachment_object = {}

attachment_object.onEquip = function(pet)
    pet:addListener("AUTOMATON_ATTACHMENT_CHECK", "ATTACHMENT_DISRUPTOR", function(automaton, target)
        local master = automaton:getMaster()
        if master and master:countEffect(xi.effect.DARK_MANEUVER) > 0 and automaton:getLocalVar("dispel") < VanadielTime() and target:hasStatusEffectByFlag(xi.effectFlag.DISPELABLE) and (automaton:checkDistance(target) - target:getModelSize()) < 7 then
            automaton:useMobAbility(xi.automaton.abilities.DISRUPTOR)
        end
    end)
end

attachment_object.onUnequip = function(pet)
end

attachment_object.onManeuverGain = function(pet, maneuvers)
end

attachment_object.onManeuverLose = function(pet, maneuvers)
end

return attachment_object
