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
@onready var ball_hitbox : CollisionShape2D = $BallHitbox
# Behaviour
const accel := 30.0
var speed := 0.0
var dir := Vector2.ZERO
# Animations
var tween1 : Tween = null
const time1 := 0.5
# Timing
const time2:= 0.1

# Loading

func _ready():
	start_ball()

func start_ball() -> void:
	scale = Vector2.ZERO
	global_position = get_viewport_rect().get_center()
	speed = max(180, speed - 180)
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
	_check_collider_type(collision.get_collider(), collision)

## Executes specific instructions for collisions.
func _check_collider_type(collider:StaticBody2D, collision:KinematicCollision2D) -> void:
	# Normal bounce
	if collider == walls:
		dir = dir.bounce(collision.get_normal())
		ball_wall_hit.play()
	
	# Speed + Bounce to left
	elif collider == paddle_1:
		speed += accel
		dir.x = -absf(dir.x)
		dir.y = collider.global_position.direction_to(global_position).y
		collider.impact()
		ball_paddle_hit.play()
		# Disable collision with paddle for time2 seconds to prevent trapping the ball.
		set_collision_mask_value(2,false)
		await get_tree().create_timer(time2).timeout
		set_collision_mask_value(2,true)
	
	# Speed + Bounce to right
	elif collider == cpu_paddle:
		speed += accel
		dir.x = absf(dir.x)
		dir.y = collider.global_position.direction_to(global_position).y
		collider.impact()
		ball_paddle_hit.play()
		# Disable collision with paddle for time2 seconds to prevent trapping the ball.
		set_collision_mask_value(2,false)
		print(get_collision_mask_value(2))
		await get_tree().create_timer(time2).timeout
		set_collision_mask_value(2,true)
		print(get_collision_mask_value(2))
	
	# Player scored point
	elif collider == left_score:
		start_ball()
		main_node.point_scored(true)
		ball_scored.play()
	# CPU scored points
	elif collider == right_score:
		start_ball()
		main_node.point_scored(false)
		ball_scored.play()
	# Clamp speed.
	speed = clampf(speed, 0, 660)
