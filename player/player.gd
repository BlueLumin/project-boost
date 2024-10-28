extends RigidBody3D
class_name Player

@export_range(750.0, 3000.0) var thurst: float = 1000.0 ## How much vertical force to apply when moving.
@export var torque_thrust: float = 100.0 ## The torque thrust to apply when rotating.


func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thurst)
	
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
	
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))


func crash_sequence() -> void:
	get_tree().call_deferred("reload_current_scene")


func _on_body_entered(body: Node) -> void:
	if body.is_in_group("Goal"):
		print("You Win!")
	
	if body.is_in_group("Hazard"):
		crash_sequence()
