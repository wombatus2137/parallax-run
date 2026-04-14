extends Node3D


@export var camera_speed := 6.0
@onready var camera := get_node("Camera3D")
@onready var danger_location = get_node("Path3D/PathFollow3D")
@onready var danger_location2 = get_node("Path3D2/PathFollow3D")
var next_danger_location: Node
@onready var dangers: Array[PackedScene] = [
	preload("res://game/meteor.tscn"),
	preload("res://game/player_switcher.tscn"),
	preload("res://game/meteor.tscn"),
	preload("res://game/meteor.tscn"),
]
var next_danger_index: int
var next_danger_instance: Node
@onready var player := get_node("Player")
@onready var player2 := get_node("Player2")


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	while danger_location.progress < 2950 and danger_location2.progress < 2950:
		if randi_range(0, 1):
			next_danger_location = danger_location
			print(danger_location.position)
		else:
			next_danger_location = danger_location2
			print(danger_location2.position)
		next_danger_location.progress += randf_range(2, 20)
		next_danger_index = randi_range(0, dangers.size() - 1)
		next_danger_instance = dangers[next_danger_index].instantiate()
		add_child(next_danger_instance)
		next_danger_instance.position = next_danger_location.position
		if next_danger_index == 2 or next_danger_index == 3:
			next_danger_instance.position.y = next_danger_location.position.y + 8
			if next_danger_index == 3:
				next_danger_instance.is_early = next_danger_index - 2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	camera.position.x += camera_speed * delta


func switch_players() -> void:
	var old_position = player.position
	player.position = player2.position
	player2.position = old_position
