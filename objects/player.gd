extends CharacterBody3D


const SPEED = 1.0
const JUMP_VELOCITY = 7
const MOUSE_SENSITIVITY = 0.075
const CAP = 5

const BASE_FOV = 90

var sprint_ready : float = 0

@onready var Rotation_Helper = $RotationHelper
@onready var Camera = $RotationHelper/Camera3D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")*2
var sensitivity_multiplier : Vector2
var direction : Vector3 = Vector3(0, 0, 0)

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	sensitivity_multiplier = Vector2(DisplayServer.window_get_size())/Vector2(852, 480)

func _physics_process(delta):
	var fov_mod : float = 0
	var cap_multi : float = 1
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "forward", "backward")
	direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	
	if direction:
		if Input.is_action_pressed("sprint") and input_dir.y < 0:
				sprint_ready = clampf(sprint_ready+delta, 0, 0.1)
				cap_multi = 1.5
		if not is_on_floor():
			var old_y = velocity.y
			velocity = velocity.move_toward(CAP*0.8*direction*cap_multi, SPEED/4)
			velocity.y = old_y
		else:
			var old_y = velocity.y
			velocity = velocity.move_toward(CAP*direction*cap_multi, SPEED)
			velocity.y = old_y
			
	elif is_on_floor():
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	
	
	if not Input.is_action_pressed("sprint") or input_dir.y >= 0:
		sprint_ready = clampf(sprint_ready-2*delta, 0, 0.1)
	
	fov_mod += sprint_ready*50
	Camera.fov = BASE_FOV+fov_mod
	
	move_and_slide()

func _input(event):
	if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		Rotation_Helper.rotate_x(-deg_to_rad(event.relative.y * MOUSE_SENSITIVITY * sensitivity_multiplier.y))
		self.rotate_y(deg_to_rad(event.relative.x * MOUSE_SENSITIVITY * sensitivity_multiplier.x * -1))

		var camera_rot = Rotation_Helper.rotation_degrees
		camera_rot.x = clamp(camera_rot.x, -70, 70)
		Rotation_Helper.rotation_degrees = camera_rot
