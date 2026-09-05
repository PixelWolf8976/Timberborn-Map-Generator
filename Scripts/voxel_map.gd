extends Node3D


const BASIC_BLOCK: PackedScene = preload("res://Scenes/basic_block.tscn")

@onready var dirt: Node3D = $Dirt
@onready var water: Node3D = $Water


func _ready() -> void:
	var data: Dictionary = load_json("res://Worlds/dam_test.json")
	print(data)
	make_map(data)


func load_json(file_path: String):
	# Check if the file exists before trying to open it
	if FileAccess.file_exists(file_path):
		# Open the file in read mode
		var file = FileAccess.open(file_path, FileAccess.READ)
		
		# Read the content as text
		var json_text = file.get_as_text()
		file.close() # Always close the file when done
		
		# Parse the JSON text into a Godot Variant (Dictionary or Array)
		var data = JSON.parse_string(json_text)
		
		if data != null:
			return data
		else:
			print("Failed to parse JSON.")
			return null
	else:
		print("File does not exist: ", file_path)
		return null


func make_map(json_data: Dictionary):
	var singletons: Dictionary = json_data.Singletons
	var map_size: Vector2i
	if true:
		var json_map_size: Dictionary = singletons.MapSize.Size
		map_size = Vector2i(json_map_size.X, json_map_size.Y)
	
	gen_dirt(singletons.TerrainMap.Voxels.Array, map_size)
	
	var water_data: Dictionary = singletons.WaterMapNew
	gen_water(water_data.WaterColumns.Array, Vector3i(map_size.y, map_size.x, water_data.Levels))


func gen_dirt(string: String, size: Vector2i) -> void:
	string = string.replace(" ", "")
	string = "1".repeat(size.x * size.y) + string
	var layer_size: int = size.x * size.y
	var layer_count: int = string.length() / layer_size
	var size_3d: Vector3i = Vector3i(size.y, size.x, layer_count)
	var current_index: int = 0
	
	# Terrain map is a 3d array (x and y is map size, height is 24) of binary, 1 means there is dirt there, 0 means there is not
	# Not stored, but the ground level (height == 0) is always full blocks, so I add a new height layer of true to the bottom of the stack
	
	for x in size_3d.z:
		for y in size_3d.x:
			for z in size_3d.y:
				if string[current_index] == "1":
					var block_inst: Block = BASIC_BLOCK.instantiate()
					block_inst.position = Vector3(y, x, z)
					dirt.add_child(block_inst)
					block_inst.set_material("Dirt")
				
				current_index += 1


func gen_water(string: String, size: Vector3i):
	# Water columns is how the game stores water, it is a 3d array (x and y is from map size, height is "Levels" in "WaterMapNew")
	# 0 means there is no water there, if there is water there, there will be 5 numbers in the format A:B:C:D:E
	# (remember these are buest guesses from expirementation)
	# A - Water height at the end of the movement calculation (actual height)
	# B - Contamination percentage
	# C - UNKNOWN, I've only ever seen this be 0
	# D - Water base height, what height block the water is on top of
	# E - Water height at the beginning of the movement calculation
	
	var string_array: PackedStringArray = string.split(" ", false)
	
	var curr_index: int = 0
	
	
	for layer in size.z:
		for x in size.x:
			for y in size.y:
				var curr_value: String = string_array[curr_index]
				
				if curr_value != "0":
					var split_data: PackedFloat32Array = string_arr_to_float(curr_value.split(":", false))
					
					var a: float = split_data[0]
					var b: float = split_data[1]
					var c: float = split_data[2]
					var d: float = split_data[3]
					var e: float = split_data[4]
					
					# Water starts at zero, but should be 1, so offset
					var z = d + 1
					
					var block_inst: Block = BASIC_BLOCK.instantiate()
					block_inst.position = Vector3(x, z, y)
					block_inst.scale.y = a
					water.add_child(block_inst)
					block_inst.set_material("Water")
				
				curr_index += 1
	
	pass


func string_arr_to_float(input: PackedStringArray) -> PackedFloat32Array:
	var output: PackedFloat32Array = []
	output.resize(input.size())
	for i in range(input.size()):
		output[i] = float(input[i])
	return output
