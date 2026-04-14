extends CharacterBody3D


@export var speed := -4.0
@export var is_early:bool = 0
@onready var warning_label := get_node("../WarningLabel")
var is_locked_on_player: bool = 0


func _ready() -> void:
	var player_detector := get_node("Area3D/CollisionShape3D")
	if is_early:
		player_detector.shape.size = Vector3(26, 26, 1)
	else:
		player_detector.shape.size = Vector3(18, 18, 1)


func _physics_process(delta: float) -> void:
	if is_on_floor():
		is_locked_on_player = 0
		
	
	if is_locked_on_player:
		velocity.x = speed
		velocity.y = speed - 4.2
	
	move_and_slide()


func _on_area_3d_body_entered(body: Node3D) -> void:
	if body.is_in_group("players"):
		warning_label.text = "[b]Meteor!!![/b]"
		is_locked_on_player = 1


func _on_warning_timer_timeout() -> void:
	warning_label.text = ""
