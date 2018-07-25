local gameState = require 'libs.hump.gamestate'
local Class = require 'libs.hump.class'

local LevelBase = require 'gamestates.LevelBase'

local Player = require 'entities.player'
local camera = require 'libs.camera'

player = nil

local gameLevel1 = Class{
    __includes = LevelBase
}
local gameLevel1 = Class{
    __includes = LevelBase
}

function gameLevel1:init()
    LevelBase.init(self,'assets/levels/level_1.lua')
end

function gameLevel1:enter()
    player = Player(self.world ,400,64)
    LevelBase.Entities:add(player)
end

function gameLevel1:update(dt)
    self.map:update(dt)
    LevelBase.Entities:update(dt)

    LevelBase.positionCamera(self,player,camera)
end

function gameLevel1:draw()
    camera:set()
    self.map:draw(-camera.x,-camera.y)
    LevelBase.Entities:draw()

    camera:unset()
end

function gameLevel1:keypressed(key)
    LevelBase:keypressed(key)
end

return gameLevel1