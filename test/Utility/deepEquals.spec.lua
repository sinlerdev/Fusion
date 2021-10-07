local Package = game:GetService("ReplicatedStorage").Fusion
local deepEquals = require(Package.Utility.pureEquals)

return function()
	it("should return true for equal values", function()
		expect(deepEquals(2, 2)).to.equal(true)
	end)

	it("should return false for unequal values", function()
		expect(deepEquals(2, 4)).to.equal(false)
	end)

	it("should return true for referentially equal tables", function()
		local x = {}
		expect(deepEquals(x, x)).to.equal(true)
	end)

	it("should return true for empty tables", function()
		local x = {}
		local y = {}
		expect(deepEquals(x, y)).to.equal(true)
	end)

	it("should return true for deeply equal arrays", function()
		local x = {1, 2, 3, 4, 5, 6}
		local y = {1, 2, 3, 4, 5, 6}
		expect(deepEquals(x, y)).to.equal(true)
	end)

	it("should return true for deeply equal tables", function()
		local x = {foo = 2, bar = "shoe"}
		local y = {foo = 2, bar = "shoe"}
		expect(deepEquals(x, y)).to.equal(true)
	end)

	it("should return false for deeply unequal arrays", function()
		local x = {1, 2, 3, 4, 5, 6}
		local y = {1, 2, 3, 4, 6, 5}
		expect(deepEquals(x, y)).to.equal(false)
	end)

	it("should return false for deeply unequal tables", function()
		local x = {foo = 2, bar = "shoe"}
		local y = {foo = true, bar = "blue"}
		expect(deepEquals(x, y)).to.equal(false)
	end)

	it("should return false for arrays of different length", function()
		local x = {1, 2, 3, 4, 5, 6}
		local y = {1, 2, 3, 4, 5}
		expect(deepEquals(x, y)).to.equal(false)
	end)

	it("should return false if x has keys not present in y", function()
		local x = {foo = true, bar = true}
		local y = {foo = true}
		expect(deepEquals(x, y)).to.equal(false)
	end)

	it("should return false if y has keys not present in x", function()
		local x = {foo = true}
		local y = {foo = true, bar = true}
		expect(deepEquals(x, y)).to.equal(false)
	end)

	it("should return true for deeply equal nested tables", function()
		local x = {foo = {bar = true, baz = 2}}
		local y = {foo = {bar = true, baz = 2}}
		expect(deepEquals(x, y)).to.equal(true)
	end)

	it("should return false for deeply unequal nested tables", function()
		local x = {foo = {bar = true, baz = 2}}
		local y = {foo = {bar = true, baz = "shoe"}}
		expect(deepEquals(x, y)).to.equal(false)
	end)

	it("should return true for deeply equal nested tables with cycles", function()
		local x = {foo = {bar = true, baz = 2}}
		local y = {foo = {bar = true, baz = 2}}

		x.bar = x
		y.bar = y
		expect(deepEquals(x, y)).to.equal(true)
	end)

	it("should return false for deeply unequal nested tables with cycles", function()
		local x = {foo = {bar = true, baz = 2}}
		local y = {foo = {bar = true, baz = "shoe"}}

		x.bar = x
		y.bar = y
		expect(deepEquals(x, y)).to.equal(false)
	end)
end