extends CharacterBody3D


@export var speed := 6.0
@export var jump_velocity := 5.0
@export var jump_input: StringName = "jump"
@export var crouch_input: StringName = "crouch"
@onready var player2_material := preload("res://assets/player2_material_3d.tres")
@onready var mesh_instance := get_node("MeshInstance3D")
@onready var collision_shape := get_node("CollisionShape3D")
@onready var mob_collision_shape := get_node("Area3D/CollisionShape3D")
@onready var main_node := get_node("..")


func _ready() -> void:
	if name == "Player2":
		get_node("MeshInstance3D").set_surface_override_material(0, player2_material)


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# Handle jump.
	if Input.is_action_just_pressed(jump_input) and is_on_floor():
		velocity.y = jump_velocity
	
	if Input.is_action_just_pressed(crouch_input):
		mob_collision_shape.shape.height = 0.3
		#mob_collision_shape.position.y -= 0.15
		mesh_instance.mesh.height = 0.4
		collision_shape.shape.height = 0.4
		position.y -= 0.2
	
	if Input.is_action_just_released(crouch_input):
		mob_collision_shape.shape.height = 0.7
		mob_collision_shape.position.y += 0.15
		mesh_instance.mesh.height = 0.7
		collision_shape.shape.height = 0.7
		position.y += 0.2
	
	velocity.x = speed
	velocity.z = 0
	
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("danger"):
		main_node.game_over()
	elif body.is_in_group("player_switchers"):
		main_node.switch_players()
