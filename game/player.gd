extends CharacterBody3D


@export var speed: float
@export var jump_velocity: float
@export var jump_input: StringName = "jump"


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed(jump_input) and is_on_floor():
		velocity.y = jump_velocity

	# Get the input direction and handle the movement/deceleration.
	const MOVE_FOREWARD := Vector2(1,0)
	var direction := (transform.basis * Vector3(1, 0, 0)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	#Camera moves only by first player
	if name == "Player":
		var camera := get_node("../Camera3D")
		camera.position.x += speed * delta
	
	move_and_slide()
