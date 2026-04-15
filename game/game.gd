extends Node3D


@export var camera_speed := 6.0
@onready var camera := get_node("Camera3D")
@onready var danger_location = get_node("Path3D/PathFollow3D")
@onready var danger_location2 = get_node("Path3D2/PathFollow3D")
var next_danger_location: Node
@onready var dangers: Array[PackedScene] = [
	preload("res://game/player_switcher.tscn"),
	preload("res://game/pit.tscn"),
	preload("res://game/meteor.tscn"),
	preload("res://game/meteor.tscn"),
]
var next_danger_index: int
var next_danger_instance: Node
@onready var ground_near := get_node("GroundNear")
@onready var ground_far := get_node("GroundFar")
@onready var player := get_node("Player")
@onready var player2 := get_node("Player2")
var is_game_over: bool


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while danger_location.progress < 2950 and danger_location2.progress < 2950:
		if randi_range(0, 1):
			next_danger_location = danger_location
		else:
			next_danger_location = danger_location2
		next_danger_location.progress += randf_range(3, 10)
		next_danger_index = randi_range(0, dangers.size() - 1)
		if next_danger_index == 0:
			if not randi_range(0, 5) == 0:
				next_danger_index += randi_range(1, 3)
		next_danger_instance = dangers[next_danger_index].instantiate()
		add_child(next_danger_instance)
		next_danger_instance.position = next_danger_location.position
		if next_danger_index == 2 or next_danger_index == 3:
			next_danger_instance.position.y = next_danger_location.position.y + 8
			if next_danger_index == 3:
				next_danger_instance.is_early = next_danger_index - 2
	
	for i in range(1, 150):
		var new_ground_near = ground_near.duplicate()
		add_child(new_ground_near)
		new_ground_near.position.x = 20 * i
		var new_ground_far = ground_far.duplicate()
		add_child(new_ground_far)
		new_ground_far.position.x = 20 * i


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera.position.x += camera_speed * delta
	
	if is_game_over == true:
		if Input.is_action_pressed("jump"):
			get_tree().reload_current_scene()


func switch_players() -> void:
	var old_position = player.position
	player.position = player2.position
	player2.position = old_position


func player_hit() -> void:
	var lives := get_node("Lives")
	var lives_count := int(lives.text.trim_prefix("Lives: "))
	lives_count -= 1
	lives.text = "Lives: " + str(lives_count)
	if lives_count == 0:
		var score = get_node("GameOver/Score")
		score.text = "Score: " + str(int(player.position.x))
		player.set_physics_process(0)
		player2.set_physics_process(0)
		get_node("GameOverTimer").start()
		get_node("GameOver").visible = 1


func _on_game_over_timer_timeout() -> void:
	is_game_over = true
