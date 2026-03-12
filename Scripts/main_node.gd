extends Node2D

@onready var points_1 : Label = %Points1
@onready var points_2 : Label = %Points2

var scoreboard :Array[int] = [0, 0]

func _ready():
	points_1.text = str( 0 )
	points_2.text = str( 0 )

func point_scored(on_left_side:bool):
	if on_left_side:
		scoreboard[1] += 1
	else:
		scoreboard[0] += 1
	_update_counters()

func _update_counters() -> void:
	points_1.text = str( scoreboard[0] )
	points_2.text = str( scoreboard[1] )

func _on_retry_pressed():
	get_tree().reload_current_scene()
