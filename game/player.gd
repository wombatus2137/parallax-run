extends CharacterBody3D


@export var speed := 6.0
@export var jump_velocity := 5.0
@export var jump_input: StringName = "jump"
@export var crouch_input: StringName = "crouch"
@onready var mob_collision_shape := get_node("Area3D/CollisionShape3D")
@onready var switch_timer := get_node("SwitchTimer")
@onready var warning_label := get_node("../WarningLabel")
signal game_over


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed(jump_input) and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_pressed(crouch_input) and is_on_floor():
		mob_collision_shape.shape.height = 0.3
		mob_collision_shape.position.y = -0.15
	
	if Input.is_action_just_released(crouch_input) and is_on_floor():
		mob_collision_shape.shape.height = 0.7
		mob_collision_shape.position.y = 0
	
	velocity.x = speed
	velocity.z = 0
	
	if name == "Player":
		#Camera moves only by first player
		var camera := get_node("../Camera3D")
		camera.position.x += speed * delta
	
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("danger"):
		print("ded")
		game_over.emit()
	elif body.is_in_group("player_switchers"):
		warning_label.text = "[b]PLAYER SWITCH!!![/b]"
		switch_timer.start()


func _on_switch_timer_timeout() -> void:
	if name == "Player":
		var seccond_player := get_node("../Player2")
		var old_position = position
		position = seccond_player.position
		seccond_player.position = old_position
		warning_label.text = ""
