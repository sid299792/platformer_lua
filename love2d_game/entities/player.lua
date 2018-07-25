local Class = require 'libs.hump.class'
local Entity = require 'entities.Entity'

local player = Class{
    __include = Entity
}

function player:init(world,x,y)
    self.img = love.graphics.newImage('/assets/player.png')

    Entity.init(self,world,x,y,self.img:getWidth(),self.img:getHeight())

    self.xVelocity = 0
    self.yVelocity = 0
    self.acc = 100
    self.maxSpeed = 100
    self.friction = 20
    self.gravity = 80
    self.isJumping = false
    self.onGround = false
    self.hasReachedMax = false
    self.jumpSpeed = -110
    self.world:add(self, x,y,self.img:getWidth(),self.img:getHeight())
end

function player:collisionFilter(other)
    local x,y,w,h = self.world:getRect(other)
    local playerBottom = self.y + self.h
    local otherBottom = y + h
    if playerBottom <= y then
        return 'slide'
    end
end

function player:update(dt)
    local prevX,prevY = self.x,self.y

    self.xVelocity = self.xVelocity * (1-math.min(dt*self.friction,1))
    self.yVelocity = self.yVelocity + self.gravity * dt

    if love.keyboard.isDown('a') and self.xVelocity > -self.maxSpeed then
        self.xVelocity = self.xVelocity - self.acc
    elseif love.keyboard.isDown('d') and self.xVelocity < self.maxSpeed then
        self.xVelocity = self.xVelocity + self.acc
    end

    if love.keyboard.isDown('w') then
        if self.onGround then
            self.yVelocity = self.yVelocity + self.jumpSpeed
            self.onGround = false
        end
    end

    local goalX = self.x + self.xVelocity * dt
    local goalY = self.y + self.yVelocity 

    self.x,self.y,collisions,len = self.world:move(self,goalX,goalY)

    for i,col in ipairs(collisions) do 
        if col.touch.y > goalY then
            self.hasReachedMax = true
            self.onGround = false
        elseif col.normal.y < 0 then
            self.hasReachedMax = false
            self.onGround = true
        end
    end
end

function player:draw()
    love.graphics.draw(self.img,self.x,self.y)
end

return player