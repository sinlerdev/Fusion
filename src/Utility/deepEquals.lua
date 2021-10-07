--[[
	Returns true if the two objects are equal, first by referential equality,
	and for tables, deep equality.
--]]

local function deepEquals_impl(a, b, seen)
	if a == b then
		return true
	elseif type(a) ~= "table" or type(b) ~= "table" then
		return false
	end

	-- we know `a` and `b` are tables which are not referentially equal
	-- time to do a deep check

	if seen[a] == nil then
		seen[a] = {}
	end

	if seen[b] == nil then
		seen[b] = {}
	end

	-- if we've seen `a` and `b` before, don't descend into them, because it's a
	-- cycle
	if seen[a][b] then
		return true
	end

	seen[a][b] = true
	seen[b][a] = true

	for key, valueA in pairs(a) do
		local valueB = b[key]
		if not deepEquals_impl(valueA, valueB, seen) then
			return false
		end
	end

	for key, valueB in pairs(b) do
		local valueA = a[key]
		if not deepEquals_impl(valueA, valueB, seen) then
			return false
		end
	end

	return true
end

local function deepEquals(a, b)
	return deepEquals_impl(a, b, {})
end

return deepEquals