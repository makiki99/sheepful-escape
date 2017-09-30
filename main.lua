local dtstored = 0
local gamestate = 0
function love.run()
--a bit of magic that sets up the main loop
	if love.math then
		love.math.setRandomSeed(os.time())
	end
	if love.load then love.load(arg) end
	if love.timer then love.timer.step() end
	while true do
		if love.event then
			love.event.pump()
			for name, a,b,c,d,e,f in love.event.poll() do
				if name == "quit" then
					if not love.quit or not love.quit() then
						return a
					end
				end
				love.handlers[name](a,b,c,d,e,f)
			end
		end
		if love.timer then
			love.timer.step()
			dtstored = dtstored+love.timer.getDelta()
		end
		local updatecalled = false
		if gamestate.update then
			while dtstored>1/60 do
				gamestate.update()
				dtstored = dtstored - 1/60
				updatecalled = true
			end
		end
		if updatecalled and love.graphics and love.graphics.isActive() then
			love.graphics.origin()
			if gamestate.draw then gamestate.draw() end
			love.graphics.present()
		end
		if love.timer then love.timer.sleep(0.001) end
	end
end

function setGamestate(state)
--[[
Arguments: gamestate object
Returns: nil
This functions sets current gamestate of the game, then, if it exists, it calls
the load() function of it.
Gamestate needs at least an update() or draw() function to be valid.
Gamestate callbacks are: load(), update() and draw().
]]
	gamestate = state
	assert(gamestate.update or gamestate.draw, "The object passed to setGamestate() isn't a gamestate - A valid gamestate requires an update() or draw() function.")
	if gamestate.load then
		gamestate.load()
	end
end

setGamestate({
	update = function(args)
		print("test")
	end
})
