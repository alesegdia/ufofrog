
local json = require 'libs.dkjson'
local inspect = require 'libs.inspect'

require 'libs.functional'

local index_to_coords = function( index, cols, rows )
	return index % cols, math.floor( index / cols )
end

local _newProvider = function(path, cols, rows)
	local contents,_ = love.filesystem.read(path)
	local json_data = json.decode(contents)

	local provider = {
		framesdata = {},
		cols = cols_,
		rows = rows_
	}

	for nframe, frame_data in ipairs(json_data) do
		provider.framesdata[nframe] = {}
		for primitive_type, primitive_data in pairs(frame_data) do
			provider.framesdata[nframe][primitive_type] = {}
			for _, primitive_instance in pairs(primitive_data) do
				local toins = {
					data = {
						primitive_instance.data.pos[1],
						primitive_instance.data.pos[2],
						primitive_instance.data.size[1],
						primitive_instance.data.size[2],
					},
					name = primitive_instance.name,
				}
				table.insert(provider.framesdata[nframe][primitive_type], toins)
			end
		end
	end

	provider.getBoxesForFrame = function ( self, nframe )
		return self.framesdata[nframe]["box"]
	end

	provider.eachFrameBox = function( self, nframe, fn )
		local data = self:getBoxesForFrame(nframe)
		return map( fn, data )
	end

	return provider
end

return {
	newProvider = _newProvider
}
