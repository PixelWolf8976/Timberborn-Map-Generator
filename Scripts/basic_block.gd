class_name Block
extends Node3D


@onready var mesh3d: MeshInstance3D = $Mesh

const DIRT = preload("res://Assets/dirt.tres")
const WATER = preload("res://Assets/water.tres")


func set_material(type: String):
	if type == "Dirt":
		mesh3d.mesh.material = DIRT
	elif type == "Water":
		mesh3d.mesh.material = WATER
