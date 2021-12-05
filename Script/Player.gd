extends Sprite

var Flotteur = preload("res://Scene/Flotteur.tscn")

onready var line = $Line2D

var isFishing := false

var isWaitingFish := false

var flotteur:Flotteur

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if flotteur:
		line.set_point_position(1, to_local(flotteur.global_position))
	
	if Input.is_action_just_pressed("ui_accept"):
		if !flotteur:
			flotteur = Flotteur.instance()
			flotteur.position = position
			get_parent().add_child(flotteur)
			flotteur.lancer(500)
		else:
			if flotteur.canCatch():
				print("hello")
			else:
				flotteur.reset()
				
	if flotteur and Input.is_action_pressed("ui_accept"):
		if flotteur.isInWater():
				flotteur.position.y += 50 * delta
