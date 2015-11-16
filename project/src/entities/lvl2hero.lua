
local anim8 = require 'libs.anim8.anim8'
local Class = require 'libs.hump.class'
local inspect = require 'libs.inspect'

local helper_anim8 = require 'src.helpers.anim8'
local helper_boxedit = require 'src.helpers.boxedit'

require 'src.helpers.proxy'

local MAX_BOOST = 5
local BOOST_DEC_FACTOR = 1
local BOOST_INC_FACTOR = 10

local Lvl2Hero = Class {
}

function Lvl2Hero:init(world)

	self.world = world

	-- animation loading
	local g = helper_anim8.newGrid(Image.lvl2hero, 2, 3)
	local dtn = 1

	local drtn = 0.5
	self.swim_anim = anim8.newAnimation( g(2,1, 1,1, 2,2, 1,1), {drtn, drtn, drtn, drtn} )
	self.stand_anim = anim8.newAnimation( g(1,1), {1} )

	self.boost = 0

	self.lastpress = "z"

	self.pos = { x = 0, y = 0 }
	self.speed = { x = 75, y = 50 }
end

function Lvl2Hero:draw()
	self.swim_anim:draw(Image.lvl2hero, self.pos.x, self.pos.y)
end

function Lvl2Hero:update(dt)

	local zpress = love.keyboard.isDown("z")
	local xpress = love.keyboard.isDown("x")

	if zpress and self.lastpress == "x" or xpress and self.lastpress == "z" then
		self.boost = self.boost + dt * BOOST_INC_FACTOR
	else
		self.boost = self.boost - dt * BOOST_DEC_FACTOR
	end
	if self.boost > MAX_BOOST then self.boost = MAX_BOOST end
	if self.boost <= 0 then self.boost = 0 end

	if zpress then self.lastpress = "z" end
	if xpress then self.lastpress = "x" end

	print(self.boost)

	local newanim
	if self.boost == 0 then newanim = self.stand_anim
	else newanim = self.swim_anim end

	print(newanim)

	if newanim ~= self.anim then
		print("tick!")
		newanim.timer = 0
	end

	self.anim = newanim

	local up, down, left, right
	up = love.keyboard.isDown("up")
	down = love.keyboard.isDown("down")
	left = love.keyboard.isDown("left")
	right = love.keyboard.isDown("right")

	local dx, dy
	dx = 0
	dy = 0

	if up then dy = -1 end
	if down then dy = 1 end
	if up and down then dy = 0 end

	if left then dx = -1 end
	if right then dx = 1 end
	if left and right then dx = 0 end

	self.pos.x = self.pos.x + dx * self.boost * self.speed.x * dt
	self.pos.y = self.pos.y + dy * self.boost * self.speed.y * dt

	self.anim:update(dt * self.boost)

end

return Lvl2Hero