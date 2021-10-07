local function pair(pairings, a, b)
	pairings[a] = b
	pairings[b] = a
end

local function unpair(pairings, a, b)
	pairings[a] = nil
	pairings[b] = nil
end

local function pairable(pairings, a, b)
	return pairings[a] == nil or pairings[b] == nil or pairings[a] == b
end

local function next2(a, b, i, j)
	local nexti = next(a, i)
	local nextj = next(b, j)
	if i == nil and j == nil then
		if nexti == nil or nextj == nil then
			return nil, nil
		else
			return nexti, nextj
		end
	elseif nextj ~= nil then
		return i, nextj
	elseif nexti ~= nil then -- loop back to the beginning
		return nexti, next(b)
	else
		return nil, nil
	end
end


local function iCopy(a)
	local A = {}
	for i, v in next, a do
		A[i] = true
	end
	return A
end

local pureEquals
local pureEqualsTable

-- we can improve the efficiency substantially
function pureEqualsTable(pairings, unpairedA, unpairedB, a, b, i, j, func, ...)
	local nexti, nextj = next2(a, b, i, j)

	if nexti == nil or nextj == nil then
		if next(unpairedA) or next(unpairedB) then
			return false
		end
		-- passed the pairity check, now resume previous routine
		if not func then
			return true
		end
		return func(pairings, ...)
	end

	if unpairedA[nexti] and unpairedB[nextj] then
		--assume pairing
		unpairedA[nexti] = nil
		unpairedB[nextj] = nil

		local success = pureEquals(pairings,
			nexti, nextj,
			pureEquals, a[nexti], b[nextj],
			pureEqualsTable, unpairedA, unpairedB, a, b, nexti, nextj, -- should skip to the following i
			func, ...)

		--unpair cause we're done testing
		unpairedA[nexti] = true
		unpairedB[nextj] = true

		if success then
			return true
		end
	end

	--these were not pairable, so now we're going to continue on to the next potential i j pair
	return pureEqualsTable(pairings, unpairedA, unpairedB, a, b, nexti, nextj, func, ...)
end

function pureEquals(pairings, a, b, func, ...)
	-- if a and b are already paired, then yah, they're paired
	if pairings[a] == b then
		if not func then
			return true
		end
		return func(pairings, ...) -- resume
	elseif pairings[a] ~= nil or pairings[b] ~= nil then
		-- if a or b is already paired, then definite failure
		return false
	end

	local typeA = type(a)
	local typeB = type(b)
	if typeA ~= "table" or typeB ~= "table" then
		if a ~= b then
			return false
		end
		if not func then -- definite success
			return true
		end
		return func(pairings, ...) -- resume
	end

	-- at this point a and b are tables, and not paired to each other

	--presume pairity
	pair(pairings, a, b)

	-- now try to match each element in the table to each other element
	local success = pureEqualsTable(pairings,
		iCopy(a), iCopy(b), a, b, nil, nil,
		func, ...)

	-- undo everything
	unpair(pairings, a, b)
	return success
end


-- local x = {}
-- local y = {}
-- local u = {}
-- local v = {}
-- local a = {}
-- local b = {}
-- x[1] = {[a] = true, [v] = true}
-- x[2] = {a, b}
-- x[a] = true
-- y[1] = {[u] = true, [b] = true}
-- y[2] = {u, v}
-- y[u] = true

-- print(pureEquals({}, x, y))

return function(a, b)
	return pureEquals({}, a, b)
end