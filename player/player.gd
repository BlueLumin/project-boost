extends RigidBody3D
class_name Player

@export_range(750.0, 3000.0) var thurst: float = 1000.0 ## How much vertical force to apply when moving.
@export var torque_thrust: float = 100.0 ## The torque thrust to apply when rotating.

@onready var explosion_audio: AudioStreamPlayer = $ExplosionAudio
@onready var success_audio: AudioStreamPlayer = $SuccessAudio
@onready var rocket_audio: AudioStreamPlayer3D = $RocketAudio
@onready var booster_particles: GPUParticles3D = $BoosterParticles
@onready var right_booster_particles: GPUParticles3D = $RightBoosterParticles
@onready var left_booster_particles: GPUParticles3D = $LeftBoosterParticles
@onready var explosion_particles: GPUParticles3D = $ExplosionParticles
@onready var success_particles: GPUParticles3D = $SuccessParticles

var is_transitioning: bool = false


func _process(delta: float) -> void:
	if Input.is_action_pressed("boost"):
		apply_central_force(basis.y * delta * thurst)
		booster_particles.emitting = true
		if rocket_audio.playing == false:
			rocket_audio.play()
	else:
		rocket_audio.stop()
		booster_particles.emitting = false
	
	if Input.is_action_pressed("rotate_left"):
		apply_torque(Vector3(0.0, 0.0, torque_thrust * delta))
		right_booster_particles.emitting = true
	else:
		right_booster_particles.emitting = false
	
	if Input.is_action_pressed("rotate_right"):
		apply_torque(Vector3(0.0, 0.0, -torque_thrust * delta))
		left_booster_particles.emitting = true
	else:
		left_booster_particles.emitting = false
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func crash_sequence() -> void:
	print("Crashed.")
	explosion_audio.play()
	explosion_particles.emitting = true
	set_process(false)
	is_transitioning = true
	stop_effects()
	
	var tween = create_tween()
	tween.tween_interval(2.5)
	tween.tween_callback(get_tree().reload_current_scene)


func complete_level(next_level_file: String) -> void:
	print("Level complete.")
	success_audio.play()
	success_particles.emitting = true
	set_process(false)
	is_transitioning = true
	stop_effects()
	
	var tween = create_tween()
	tween.tween_interval(1.5)
	tween.tween_callback(
		get_tree().change_scene_to_file.bind(next_level_file)
	)


func stop_effects() -> void:
	rocket_audio.stop()
	booster_particles.emitting = false
	right_booster_particles.emitting = false
	left_booster_particles.emitting = false
	


func _on_body_entered(body: Node) -> void:
	if is_transitioning:
		return
	
	if body.is_in_group("Goal"):
		complete_level(body.file_path)
	
	if body.is_in_group("Hazard"):
		crash_sequence()
