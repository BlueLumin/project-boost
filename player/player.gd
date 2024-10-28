extends RigidBody3D
class_name Player


func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * 1000.0)
	
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, 100.0 * delta))
	
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -100.0 * delta))


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Goal"):
		print("You Win!")
	
	if body.is_in_group("Hazard"):
		print("You Lose!")
