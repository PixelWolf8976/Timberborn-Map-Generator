extends Node3D


@onready var camera: Camera3D = $Camera3D

@export var speed: float = 5.0
@export var sensitivity: float = 0.0025


func _process(delta: float) -> void:
	var movement: Vector2 = Input.get_vector("Left", "Right", "Forward", "Backward")
	
	movement = movement.rotated(-rotation.y).normalized() * speed * delta
	
	var verticality: float = Input.get_axis("Down", "Up") * speed * delta
	
	position += Vector3(movement.x, verticality, movement.y)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		var mouse_movement = event.relative
		
		rotate_y(-mouse_movement.x * sensitivity)
		camera.rotate_x(-mouse_movement.y * sensitivity)
		camera.rotation_degrees.x = clamp(camera.rotation_degrees.x, -90, 90)
