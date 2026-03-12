extends StaticBody2D

# References
@onready var paddle_texture : TextureRect = $TextureRect
@onready var ball : CharacterBody2D = $"../Ball"
var texture_y := 0.0
var screen_y := 0.0
# Movement settings
var speed := 300.0
var target_y := 0.0
var deviation := 0.0
# Animations
var tween1 : Tween
var time1 := 0.1

# Loading

func _ready():
	_get_references()

func _get_references() -> void:
	texture_y = paddle_texture.size.y * 0.5
	screen_y = get_viewport_rect().size.y

# Movement (Auto)

func _process(delta):
	_auto_movement(delta)

func _auto_movement(delta:float) -> void:
	# Update target position with small deviation
	target_y = ball.global_position.y - global_position.y + deviation
	# Move towards target y direction
	if abs(target_y) > speed * delta:
		# Speed * (-1 or 1)
		global_position.y += speed * delta * (target_y / abs(target_y))
	else:
		global_position.y += target_y
	# Limit position to screen
	global_position.y = clampf(global_position.y, texture_y, screen_y - texture_y)

# Hit effect

func impact() -> void:
	if tween1:
		tween1.kill()
	tween1 = create_tween()
	tween1.tween_property(self,"modulate", Color(3,3,3,3), time1)
	tween1.tween_property(self,"modulate", Color(1,1,1,1), time1)
	# Randomize debiation each hit
	deviation = randf_range(-texture_y, texture_y)
