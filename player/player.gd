extends Node3D
class_name Player


func _process(delta: float) -> void:
	if Input.is_action_pressed("spacebar"):
		position.y += delta
	
	if Input.is_action_pressed("left"):
		rotate_z(delta)
	
	if Input.is_action_pressed("right"):
		rotate_z(-delta)
