extends CharacterBody2D
# References
@onready var main_node : Node2D = $".."
@onready var walls : StaticBody2D = %Walls
@onready var paddle_1 : StaticBody2D = $"../Paddle1"
@onready var cpu_paddle : StaticBody2D = $"../CpuPaddle"
@onready var left_score : StaticBody2D = %LeftScore
@onready var right_score : StaticBody2D = %RightScore
@onready var ball_wall_hit : AudioStreamPlayer2D = $BallWallHit
@onready var ball_paddle_hit : AudioStreamPlayer2D = $BallPaddleHit
@onready var ball_scored : AudioStreamPlayer = $BallScored
# Ball settings
var accel := 20.0
var speed := 150.0
var dir := Vector2.ZERO
# Start animation
var tween1 : Tween = null
var time1 := 0.5

# Loading

func _ready():
	start_ball()

func start_ball() -> void:
	scale = Vector2.ZERO
	global_position = get_viewport_rect().get_center()
	speed = 150.0
	dir.x = [-1, 1].pick_random()
	dir.y = randf_range(-1, 1)
	dir = dir.normalized()
	set_physics_process(false)
	if tween1:
		tween1.kill()
	tween1 = create_tween()
	tween1.tween_property(self,"scale", Vector2(1,1), time1)
	tween1.tween_callback(set_physics_process.bind(true))

# Main loop

func _physics_process(delta):
	var collision := move_and_collide(dir * speed * delta)
	if not collision:
		return
	var collider : StaticBody2D = collision.get_collider()
	# Walls = bounce
	if collider == walls:
		dir = dir.bounce(collision.get_normal())
		ball_wall_hit.play()
	# Paddles = bounce + speed up
	elif collider == paddle_1 or collider == cpu_paddle:
		speed += accel
		# Flip the ball x direction and bounce using the y angle from the paddle
		dir.x = -dir.x
		dir.y = collider.global_position.direction_to(global_position).y
		collider.impact()
		ball_paddle_hit.play()
	# Score = Restart position and signal point
	elif collider == left_score:
		start_ball()
		main_node.point_scored(true)
		ball_scored.play()
	elif collider == right_score:
		start_ball()
		main_node.point_scored(false)
		ball_scored.play()


#
