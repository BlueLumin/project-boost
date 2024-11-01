extends RigidBody3D
class_name Player

@export_range(750.0, 3000.0) var thurst: float = 1000.0 ## How much vertical force to apply when moving.
@export var torque_thrust: float = 100.0 ## The torque thrust to apply when rotating.

var is_transitioning: bool = false


func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thurst)
	
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
	
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))


func crash_sequence() -> void:
	print("Crashed.")
	set_process(false)
	is_transitioning = true
	
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(get_tree().reload_current_scene)


func complete_level(next_level_file: String) -> void:
	print("Level complete.")
	set_process(false)
	is_transitioning = true
	
	var tween = create_tween()
	tween.tween_interval(1.0)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)
	)


func _on_body_entered(body: Node) -> void:
	if is_transitioning:
		return
	
	if body.is_in_group("Goal"):
		complete_level(body.file_path)
	
	if body.is_in_group("Hazard"):
		crash_sequence()
