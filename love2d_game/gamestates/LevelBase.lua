local bump = require 'libs.bump.bump'
local gameState = require 'libs.hump.gamestate'
local Class = require 'libs.hump.class'
local sti = require 'libs.sti.sti'
local Entities = require 'entities.Entities'
local camera = require 'libs.camera'

local LevelBase = Class{
    __includes = gameState,
    init = function(self,mapFile)
        self.map = sti(mapFile,{'bump'})
        self.world = bump.newWorld(32)
        self.map:resize(love.graphics.getWidth(),love.graphics.getHeight())
        self.map:bump_init(self.world)

        Entities:enter()
    end;
    Entities = Entities;
    camera = camera
}

function LevelBase:keypressed(key)
    if gameState.current() ~= pause and key == 'p' then
        gameState.push(pause)
    end
end

function LevelBase:positionCamera(player,camera)
    local mapWidth = self.map.width * self.map.tilewidth
    local halfScreen = love.graphics.getWidth() / 2
    if player.x < (mapWidth - halfScreen) then
        boundX = math.max(0,player.x - halfScreen)
    else
        boundX = math.min(player.x - halfScreen, mapWidth - love.graphics.getWidth())
    end
    
    camera:setPosition(boundX,0)
end

return LevelBase