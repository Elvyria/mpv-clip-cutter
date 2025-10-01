local mp = require('mp')
local utils = require('mp.utils')

local markStart = { title = 'Start Cut', time = 0 }
local markEnd   = { title = 'End Cut',   time = 0 }

local function insert_chapter(ch)
	local chapters = mp.get_property_native("chapter-list")

	local existing = nil

	for i, value in ipairs(chapters) do
		if value.title == ch.title then
			existing = i
			break
		end
	end

	if existing == nil then
		table.insert(chapters, ch)
	else
		chapters[existing].time = ch.time
	end

	mp.set_property_native("chapter-list", chapters)
end

local function remove_chapter(ch)
	local chapters = mp.get_property_native("chapter-list")

	for i, value in ipairs(chapters) do
		if value.title == ch.title then
			table.remove(chapters, i)
			mp.set_property_native("chapter-list", chapters)
			return
		end
	end
end

local function mark(ch)
	local time = mp.get_property_number('time-pos')

	if ch.time == time then
		ch.time = 0
		remove_chapter(ch)
	end

	ch.time = time
	insert_chapter(ch)
end


local function exists(path)
   local ok, _, code = os.rename(path, path)
   if code == 13 then
	   return true
   end
   return ok
end

local function output(name, ext)
	local name = name .. '.cut-'
	local ext = '.' .. ext

	for i = 1, 64, 1 do
		if not exists(name .. i ..  ext) then
			return name .. i .. ext
		end
	end
end

local function cut()
	if (markStart.time == markEnd.time) then
		print('✂  Nothing to cut.')
	end

	local input = mp.get_property('path')
	local name = mp.get_property('filename/no-ext')
	local ext = input:match('^.*%.(.+)')
	local output = output(name, ext)

	local cmd = { 'ffmpeg' }

	if markStart.time then
		table.insert(cmd, '-ss')
		table.insert(cmd, markStart.time)
	end

	table.insert(cmd, '-i')
	table.insert(cmd, input)

	if markEnd.time ~= 0 then
		table.insert(cmd, '-to')
		table.insert(cmd, markEnd.time)
	end

	table.insert(cmd, '-c')
	table.insert(cmd, 'copy')

	table.insert(cmd, output)

	print('✂  Cutting...  ')
	print('✂  ', output)
	utils.subprocess_detached({ args = cmd })
end

mp.add_key_binding('Ctrl+c', 'cut', cut)
mp.add_key_binding('c', 'cut_start', function () mark(markStart) end)
mp.add_key_binding('C', 'cut_end',   function () mark(markEnd)   end)
