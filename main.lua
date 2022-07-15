#!/bin/lua

local ipv4_format = "^(%d+)%.(%d+)%.(%d+)%.(%d+)$"

local function splitAddress(address)
	local num1, num2, num3, num4 = address:match(ipv4_format)
	return {
		tonumber(num1),
		tonumber(num2),
		tonumber(num3),
		tonumber(num4)
	}
end

local function countAddressesBetween(address1, address2)
	local parts1 = splitAddress(address1)
	local parts2 = splitAddress(address2)

	local count = 0
	local multiplier = 1
	for i=4, 1, -1 do
		count = count + (parts2[i] - parts1[i]) * multiplier
		multiplier = multiplier * 256
	end
	return count
end

-- Tests:
-- assert(countAddressesBetween("10.0.0.0", "10.0.0.50") == 50)
-- assert(countAddressesBetween("10.0.0.0", "10.0.1.0") == 256)
-- assert(countAddressesBetween("20.0.0.10", "20.0.1.0") == 246)
-- assert(countAddressesBetween("20.1.0.23", "21.1.0.24") == 16777217)

local address1, address2 = ...
if not (address1 and address2) then
	print("Usage: ./main.lua <adress> <adress>")
	os.exit(1)
end

print(countAddressesBetween(address1, address2))
