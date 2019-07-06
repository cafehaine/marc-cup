local striter = require('striter')

local m = {}

local function strip(str)
	return str:match('^%s*(.-)%s*$')
end

local function parse_title(iter)
	local output = {type="title"}
	local level = 0
	local char = iter:next()
	while char ~= nil and char == "#" do
		level = level + 1
		char = iter:next()
	end
	output.level = level
	local body = ""
	while char ~= nil and not char:match('[\r\n]') do
		body = body .. char
		char = iter:next()
	end
	-- strip out spaces
	output.body = strip(body)
	return output
end

local function parse_code_block(iter)
	local output = {type="code"}
	error("NOT IMPLEMENTED")
end

local function parse_inline_code(iter)
	local output = {type="inline_code"}
	local body = ""
	local char = iter:next()
	while char ~= nil and char ~= '`' do
		if char == '\\' and iter:peek() == '`' then
			iter:next()
			body = body .. '`'
		else
			body = body .. char
		end
		char = iter:next()
	end
	if char == nil then
		error("EOF while parsing inline code.")
	end
	output.body = body
	return output

end

local function parse_link(iter)
	local output = {type="link"}
	local description = ""
	local char = iter:next()
	while char ~= nil and char ~= "]" do
		description = description .. char
		char = iter:next()
	end
	if char == nil then
		error("EOF while parsing link description.")
	end
	char = iter:next()
	if char ~= "(" then
		error("Invalid character while trying to find opening square bracket for url.")
	end
	local url = ""
	char = iter:next()
	while char ~= nil and char ~= ")" do
		url = url .. char
		char = iter:next()
	end
	if char == nil then
		error("EOF while parsing link url")
	end
	output.description = strip(description)
	output.url = strip(url)
	return output
end

local function parse_paragraph(iter)
	local output = {type="text"}
	local data = {}
	output.data = data
	local data_stack = {data}
	local data_index = 1
	local text = ""
	while iter:peek() ~= nil and not iter:peek(4):match('^\r?\n\r?\n') do
		local char = iter:next()
		-- parse inline code
		if char == '`' then
			data[#data+1] = text
			data[#data+1] = parse_inline_code(iter)
			text = ""
		-- parse link
		elseif char == '[' then
			data[#data+1] = text
			data[#data+1] = parse_link(iter)
			text = ""
		-- go up one level of emphasis
		elseif char == '{' then
			data[#data+1] = text
			data_stack[data_index] = data
			data_index = data_index + 1
			local parent_data = data
			data = {type="emphasis"}
			parent_data[#parent_data+1] = data
			text = ""
		-- go down one level of emphasis
		elseif char == '}' then
			data[#data+1] = text
			data_index = data_index - 1
			if data_index == 0 then
				error("Too many closing brackets for this paragraph.")
			end
			data = data_stack[data_index]
			text = ""
		-- add text to paragraph
		else
			text = text .. char
		end
	end
	if data_index ~= 1 then
		error("Not enough closing brackets for this paragraph.")
	end
	data[#data+1] = text
	return output
end

local function compress_spaces(tree)
	-- TODO
	return tree
end

function m.to_tree(data)
	iter, err = striter.new(data)
	if iter == nil then
		error(err)
	end
	local output = {}
	local char = iter:peek()
	while char ~= nil do
		-- parse titles
		if char == "#" then
			output[#output+1] = parse_title(iter)
		-- parse code blocks
		elseif iter:peek(3) == "```" then
			output[#output+1] = parse_code_block(iter)
		-- ignore spaces between paragraphs
		elseif char:match("%s") then
			iter:next()
		-- parse paragraphs
		else
			output[#output+1] = parse_paragraph(iter)
		end
		char = iter:peek()
	end
	-- compress spaces
	return compress_spaces(output)
end

return m
