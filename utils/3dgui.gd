extends SubViewport

var toggled : bool = false
var timeout : float

var coin_amount : int = 0
var spawned_coins : int = 0

var coin_timer : float = 0.0

var coin_sfx = []
const COIN_CAP : int = 100

@onready var Animator: AnimationPlayer = $AnimationPlayer
func _ready():
	randomize()
	
	_coins_set(PlayerData.get_coins())
	Main.coin_animation.connect(_coin_animation)
	for i in range(14):
		coin_sfx.append(load("res://assets/sfx/coin/"+"coin"+str(i+1)+".wav"))
		
func _process(delta):
	if Input.is_action_just_pressed("toggle_hud") and timeout != -1.0:
		toggle()
	
	if timeout != -1.0:
		timeout = clampf(timeout-delta, 0, timeout)
	if toggled and timeout != -1.0 and timeout <= 0:
		conceal()
	
	if coin_amount >= 1:
		$GPUParticles3D.emit_particle(Transform3D(Vector3(1, 0, 0), Vector3(0, 1, 0), Vector3(0, 0, 1), Vector3(0, 0, 0)), Vector3(0,0,0), Color(255, 255, 255, 255), Color(255, 255, 255, 255), 0)
		coin_amount -= 1
		spawned_coins += 1
		$SFX.play()
	
	if spawned_coins >= 1:
		
		if coin_timer >= 0.98:
			add_to_coin_text(1)
			spawned_coins -= 1
			if not spawned_coins:
				timeout = 2.0
				_coins_set(PlayerData.get_coins())
		else:
			coin_timer += delta
	else:
		coin_timer = 0.0
		

func toggle():
	
	
	if not toggled:
		reveal()
	else:
		conceal()

func reveal(do_timeout: bool = true):
	toggled = true
	Animator.play("reveal")
	if do_timeout:
		timeout = 5.0
	else:
		timeout = -1.0

func conceal():
	toggled = false
	Animator.play_backwards("reveal")

func add_to_coin_text(amount: int):
	var coin_count = int($CoinStuff/CoinCount.text)
	$CoinStuff/CoinCount.text = str(coin_count+amount)
	return coin_count+amount

func _coins_set(new_value: int):
	$CoinStuff/CoinCount.text = str(new_value)

func _coin_animation(amount: int):
	if not toggled:
		reveal(false)
	else:
		timeout = -1.0
	$SFX.stream = coin_sfx[randi_range(0,13)]
	coin_amount = clampi(coin_amount+amount, 0, COIN_CAP)
	add_to_coin_text(amount-coin_amount)
	
	
