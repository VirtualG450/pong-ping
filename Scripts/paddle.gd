extends StaticBody2D

@onready var paddle_texture : TextureRect = $TextureRect
var texture_y := 0.0
var screen_y := 0.0
var speed := 300.0
# Animations
var tween1 : Tween
var time1 := 0.1

# Loading

func _ready():
	_get_references()

func _get_references() -> void:
	texture_y = paddle_texture.size.y * 0.5
	screen_y = get_viewport_rect().size.y

# Movement (Player)

func _process(delta):
	_check_input(delta)

func _check_input(delta:float) -> void:
	var axis := Input.get_axis("player_1_up","player_1_down")
	if axis:
		global_position.y += axis * speed * delta
		global_position.y = clampf(global_position.y, texture_y, screen_y - texture_y)

# Hit effect

func impact() -> void:
	if tween1:
		tween1.kill()
	tween1 = create_tween()
	tween1.tween_property(self,"modulate", Color(3,3,3,3), time1)
	tween1.tween_property(self,"modulate", Color(1,1,1,1), time1)
