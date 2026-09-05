extends Node3D


const BASIC_BLOCK: PackedScene = preload("res://Scenes/basic_block.tscn")


func _ready() -> void:
	var data: Dictionary = load_json("res://Worlds/15x15_world.json")
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
	var singletons: Dictionary = json_data["Singletons"]
	var map_size: Vector2i
	if true:
		var json_map_size: Dictionary = singletons["MapSize"]["Size"]
		map_size = Vector2i(json_map_size["X"], json_map_size["Y"])
	gen_dirt(singletons["TerrainMap"]["Voxels"]["Array"], map_size)


func gen_dirt(string: String, size: Vector2i) -> void:
	string = string.replace(" ", "")
	string = "1".repeat(size.x * size.y) + string
	var layer_size: int = size.x * size.y
	var layer_count: int = string.length() / layer_size
	var size_3d: Vector3i = Vector3i(size.x, size.y, layer_count)
	var current_index: int = 0
	
	for x in size_3d.z:
		for y in size_3d.x:
			for z in size_3d.y:
				if string[current_index] == "1":
					var block_inst: Block = BASIC_BLOCK.instantiate()
					block_inst.position = Vector3(y, x, z)
					call_deferred("assign_block", block_inst, "Dirt")
					add_child(block_inst)
				
				current_index += 1


func assign_block(block: Block, type: String):
	block.set_material("Dirt")
