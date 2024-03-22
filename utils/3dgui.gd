extends SubViewport

var toggled : bool = false
var timeout : float

const COIN_CAP : int = 100
#
## Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("toggle_hud"):
		toggle()
	
	timeout -= delta
	if toggled and timeout <= 0:
		conceal()

@onready var Animator: AnimationPlayer = $AnimationPlayer

func toggle():
	
	
	if not toggled:
		reveal()
	else:
		conceal()

func reveal():
	toggled = true
	Animator.play("reveal")
	timeout = 5.0

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
	var play_amount = clampi(amount, 0, COIN_CAP)
	add_to_coin_text(amount-play_amount)
	
	
