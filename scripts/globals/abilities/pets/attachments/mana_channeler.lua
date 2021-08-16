-----------------------------------
-- Attachment: Mana Channeler
-----------------------------------
require("scripts/globals/status")
-----------------------------------
local attachment_object = {}

attachment_object.onEquip = function(pet)
    pet:addMod(xi.mod.MATT, 10)
    pet:addMod(xi.mod.AUTO_MAGIC_DELAY, -3)
end

attachment_object.onUnequip = function(pet)
    pet:delMod(xi.mod.MATT, 10)
    pet:delMod(xi.mod.AUTO_MAGIC_DELAY, -3)
end

attachment_object.onManeuverGain = function(pet, maneuvers)
    if maneuvers == 1 then
        pet:addMod(xi.mod.MATT, 20)
        pet:addMod(xi.mod.AUTO_MAGIC_DELAY, -6)
    elseif maneuvers == 2 then
        pet:addMod(xi.mod.MATT, 30)
        pet:addMod(xi.mod.AUTO_MAGIC_DELAY, -9)
    elseif maneuvers == 3 then
        pet:addMod(xi.mod.MATT, 40)
        pet:addMod(xi.mod.AUTO_MAGIC_DELAY, -12)
    end
end

attachment_object.onManeuverLose = function(pet, maneuvers)
    if maneuvers == 1 then
        pet:delMod(xi.mod.MATT, 20)
        pet:delMod(xi.mod.AUTO_MAGIC_DELAY, -6)
    elseif maneuvers == 2 then
        pet:delMod(xi.mod.MATT, 30)
        pet:delMod(xi.mod.AUTO_MAGIC_DELAY, -9)
    elseif maneuvers == 3 then
        pet:delMod(xi.mod.MATT, 40)
        pet:delMod(xi.mod.AUTO_MAGIC_DELAY, -12)
    end
end

return attachment_object
