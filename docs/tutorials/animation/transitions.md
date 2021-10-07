!!! warning "Under construction"
	This page is under construction - information may be incomplete or missing.

Up until now, changes have been applied instantly to our UI. Let's learn how we
can smooth out these changes over time to create transitional animations.

??? abstract "Required code"

	```Lua linenums="1"
	local ReplicatedStorage = game:GetService("ReplicatedStorage")
	local Players = game:GetService("Players")
	local Fusion = require(ReplicatedStorage.Fusion)
	local New = Fusion.New
	local Children = Fusion.Children
	local OnEvent = Fusion.OnEvent
	local State = Fusion.State
	local Computed = Fusion.Computed

	local position = State(UDim2.fromScale(.2, .5))

	local gui = New "ScreenGui" {
		Parent = Players.LocalPlayer.PlayerGui,

		Name = "ExampleGui",
		ResetOnSpawn = false,
		ZIndexBehavior = "Sibling",

		[Children] = New "TextButton" {
			Name = "MovingButton",

			Position = position,
			Size = UDim2.fromOffset(100, 100),
			AnchorPoint = Vector2.new(.5, .5),

			Text = "Click to move!",

			[OnEvent "Activated"] = function()
				-- toggle between the left and right position
				if position:get().X.Scale < .5 then
					position:set(UDim2.fromScale(.8, .5)
				else
					position:set(UDim2.fromScale(.2, .5))
				end
			end
		}
	}
	```

-----

# Introducing Followers

In the example code above, we're creating a button with a changing position.
When you click the button, it toggles between the left and right of the screen:

![Demonstrating the button moving from left to right and back again.](MovingButton.png)

Because Fusion updates our state objects instantly, the button appears to
'teleport' to it's goal position. However, it's often desirable to smooth out
changes in our state objects, for example to smooth `position`'s movement.

To achieve this, Fusion introduces 'follower' state objects. When you give them
some 'goal' state object to follow, they'll smoothly move over time whenever the
goal changes value:

![A graph plotting the values of two state objects over time. One of them, the 'goal state', jumps up in value instantly. The other - the 'follower state' - smoothly increases in response.](FollowerGraph.png)

Fusion provides two slightly different follower state objects, so you can dial
in exactly the kind of motion you want. There's `Tween`, which
uses a TweenInfo to tween towards the goal, and `Spring`, which uses a physical
simulation for more realistic and responsive motion.

-----

# Tweens

To use tweens, we first need to import them:

```Lua linenums="1"

```

!!! todo
	Add finished code