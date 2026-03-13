extends StaticBody2D

@onready var paddle_texture : TextureRect = $TextureRect
var texture_y := 0.0
var screen_y := 0.0
# Settings
var speed := 300.0
# Animations
var tween1 : Tween
var time1 := 0.1
# Switch to mouse input
var time2 := 2.0
var elapsed1 := 0.0

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
	## Keyboard input with W and S
	var axis := Input.get_axis("player_1_up","player_1_down")
	if axis:
		global_position.y += axis * speed * delta
		global_position.y = clampf(global_position.y, texture_y, screen_y - texture_y)
		elapsed1 = 0
		return
	
	# Only switch to mouse input after no keyboard detected for time2 seconds.
	if elapsed1 < time2:
		elapsed1 += delta
		return
	## Mouse input with mouse's position.
	# Prepare value
	var target_y : float = get_global_mouse_position().y - global_position.y
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
