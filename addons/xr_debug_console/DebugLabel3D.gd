extends Label3D
class_name DebugLabel3D

signal autodestroy_label

# value in seconds to dissolve label
@export var delay : float = 10
@export var fixed : bool = true
@export var msg : String = "~"

var timer = Timer
var counter = 0


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = msg
	update_styles()
	if !fixed:
		timer = Timer.new()
		add_child(timer)
		timer.wait_time= delay
		timer.start(timer.wait_time)
		add_to_group("float_debug_labels")
	else:
		add_to_group("fixed_debug_labels")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if !fixed:
		counter += delta
		var value = remap(counter, 0, delay, 1, 0)
		modulate.a = value
		outline_modulate.a = value
		position.y += delta * DK.float_labels_velocity


func update_styles() -> void:
	if fixed:
		setup_fixed_style()
	else:
		setup_float_style()
	billboard = BaseMaterial3D.BillboardMode.BILLBOARD_FIXED_Y
	no_depth_test = true
	render_priority = 100
	outline_render_priority = 99


func setup_fixed_style():
	font_size = DK.fixed_font_size
	outline_size = DK.fixed_outline_size
	modulate = DK.fixed_modulate


func setup_float_style():
	font_size = DK.float_font_size
	outline_size = DK.float_outline_size
	modulate = DK.float_modulate


func _on_timer_timeout() -> void:
	autodestroy_label.emit(self)
