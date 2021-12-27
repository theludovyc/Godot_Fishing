extends Area2D

var Flotteur = preload("res://Scene/Flotteur.tscn")

onready var line = $Line2D
onready var audio = $AudioStreamPlayer

var isFishing := false

var isWaitingFish := false

var flotteur:Flotteur

var isMouliner := false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		if !flotteur:
			flotteur = Flotteur.instance()
			flotteur.position = position
			get_parent().add_child(flotteur)
			flotteur.lancer(500)
		else:
			if flotteur.isInWater() and !flotteur.isCatch():
				if flotteur.canCatch():
					print("doCatch")
					flotteur.doCatch()
				else:
					print("doMove")
					flotteur.doMove()
				
	if flotteur:
		line.set_point_position(1, to_local(flotteur.global_position))
		
		if flotteur.isInWater():
			if Input.is_action_pressed("ui_accept"):
				if !isMouliner:
					isMouliner = true
					audio.play()
				flotteur.position.y += 100 * delta
				
			if isMouliner and Input.is_action_just_released("ui_accept"):
				isMouliner = false
				audio.stop()


func _on_Area2D_area_entered(area:Area2D):
	if area.name == "Flotteur":
		area.kill_me()
		isMouliner = false
		audio.stop()
		line.set_point_position(1, Vector2.ZERO)
		flotteur = null
	pass # Replace with function body.
