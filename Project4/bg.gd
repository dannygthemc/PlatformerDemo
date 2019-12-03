extends Sprite

onready var player = get_node("../Player")
var _xpos = 0

func _ready():
	set_process(true)
func _process(delta):
	