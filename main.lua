#!/bin/lua

local ipv4_format = "^%d+%.%d+%.%d+%.%d+$"
local ipv6_format = "^%x+:%x+:%x+:%x+:%x+:%x+:%x+:%x+$"

---Splits up a IPv4 or IPv6 address into sections.
---Note: assumes that the given address is in a correct IPv4 or IPv6 format
---@param address string
---@return table
local function splitAddress(address)
	local sections = {}

	if address:match(ipv4_format) then
		-- Standard ipv4 address
		for section in address:gmatch("%d+") do
			table.insert(sections, tonumber(section))
		end

	elseif address:match(ipv6_format) then
		-- Standard ipv6 address
		for section in address:gmatch("%x+") do
			table.insert(sections, tonumber(section, 16))
		end

	else
		-- Shortened ipv6 address
		-- 1. Add the sections before the double colon
		local before_colons_count = 0
		for section in address:match("(.*)::"):gmatch("%x+") do
			table.insert(sections, tonumber(section, 16))
			before_colons_count = before_colons_count + 1
		end

		local after_colons = {}
		for part in address:match("::(.*)"):gmatch("%x+") do
			table.insert(after_colons, tonumber(part, 16))
		end

		-- 2. Fill in with zeros that the double colon omits
		for _=1, 8-(before_colons_count + #after_colons) do
			table.insert(sections, 0)
		end

		-- 3. Add in the sections after the double colon
		for _, section in ipairs(after_colons) do
			table.insert(sections, section)
		end
	end

	return sections
end

---Counts the number of address between `address1` and `address2`
---Note: assumes that both are addressess are in a correct IPv4 or IPv6 format
---@param address1 string lower address
---@param address2 string higher address
---@return number
local function countAddressesBetween(address1, address2)
	local sections1 = splitAddress(address1)
	local sections2 = splitAddress(address2)

	local section_size
	if address1:match(ipv4_format) then
		section_size = 256
	else
		section_size = 65535
	end

	local count = 0
	local multiplier = 1
	for i=#sections1, 1, -1 do
		count = count + (sections2[i] - sections1[i]) * multiplier
		multiplier = multiplier * section_size
	end
	return count
end

-- Tests:
-- assert(countAddressesBetween("10.0.0.0", "10.0.0.50") == 50)
-- assert(countAddressesBetween("10.0.0.0", "10.0.1.0") == 256)
-- assert(countAddressesBetween("20.0.0.10", "20.0.1.0") == 246)
-- assert(countAddressesBetween("20.1.0.23", "21.1.0.24") == 16777217)
-- assert(countAddressesBetween("20:0:0:0:0:0:0:0", "20:0:0:0:0:0:0:32") == 50)
-- assert(countAddressesBetween("20::", "20:0:0:0:0:0:0:32") == 50)
-- assert(countAddressesBetween("20::", "20::32") == 50)
-- assert(countAddressesBetween("20:0:0:0:0:0:0:0", "20:0:0:0:0:0:1:0") == 65535)
-- assert(countAddressesBetween("20:0:0:0:0:0:0:10", "20:0:0:0:0:0:1:0") == 65519)

local address1, address2 = ...
if not (address1 and address2) then
	print("Usage: ./main.lua <address> <address>")
	os.exit(1)
end

print(countAddressesBetween(address1, address2))
