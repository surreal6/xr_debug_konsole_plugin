extends Node

#fixed konsole
@export var fixed_konsole : Node3D
# this offset is relative to camera position
@export var fixed_konsole_x_offset : float = -0.5
@export var fixed_konsole_y_offset : float = 0.0
@export var fixed_konsole_z_offset : float = -2
# fixed debug label style
@export var fixed_font_size : int = 8
@export var fixed_outline_size : int = 0
@export var fixed_modulate : Color = Color("black")
@export var fixed_outline_modulate : Color = Color("white")

@export var autoclean : int = 3

#float konsole
@export var float_konsole : Node3D
# this offset is relative to fixed konsole position
@export var float_label_x_offset : float = 0.5
@export var float_label_y_offset : float = 0.0
@export var float_label_z_offset : float = 0.2
# float debug label style
@export var float_font_size : int = 16
@export var float_outline_size : int = 3
@export var float_modulate : Color = Color("white")
@export var float_outline_modulate : Color = Color("black")

@export var float_default_duration : int = 10

@export var float_labels_velocity : float = 0.5

@export var current_camera : Camera3D: set = set_current_camera

var last_float_label : DebugLabel3D


func _process(_delta: float) -> void:
	if is_instance_valid(fixed_konsole):
		fixed_konsole.global_rotation.z = 0
		fixed_konsole.global_rotation.x = 0
	if is_instance_valid(current_camera):
		var pos = current_camera.global_position.y + fixed_konsole_y_offset
		fixed_konsole.global_position.y = pos


func set_current_camera(camera) -> void:
	current_camera = camera
	setup_konsoles()


func setup_konsoles():
	clean_one_in_fixed_konsole()
	fixed_konsole = Node3D.new()
	float_konsole = Node3D.new()
	fixed_konsole.position = Vector3(
		fixed_konsole_x_offset, 
		fixed_konsole_y_offset, 
		fixed_konsole_z_offset
		)
	current_camera.add_child(fixed_konsole)
	current_camera.get_parent().add_child(float_konsole)


func print_fixed(msg):
	if is_instance_valid(current_camera):
		add_label(msg, true)
	else:
		print("k$: ERROR, invalid camera")
	print("k$: %s" % msg)


func print_float(msg, delay = float_default_duration):
	if is_instance_valid(current_camera):
		add_label(msg, false, delay)
	else:
		print("k$: ERROR, invalid camera")
	print("k$f: %s" % msg)


func move_up_all_children(fixed, v_size = 0.05):
	var labels
	if fixed:
		labels = get_tree().get_nodes_in_group("fixed_debug_labels")
	else:
		labels = get_tree().get_nodes_in_group("float_debug_labels")
	for node in labels:
		node.position.y += v_size


func get_label_height(debug_label : DebugLabel3D):
	var size
	if debug_label.fixed:
		size = debug_label.pixel_size * fixed_font_size
	else:
		size = debug_label.pixel_size * float_font_size
	return size + size * 0.25


func add_label(msg, fixed, delay = float_default_duration):
	var debug_label = DebugLabel3D.new()
	debug_label.msg = msg
	debug_label.fixed = fixed
	debug_label.delay = delay
	var label_height = get_label_height(debug_label)
	if fixed :
		move_up_all_children(true, label_height)
		if fixed_konsole.get_children().size() > autoclean + 1:
			clean_one_in_fixed_konsole()
	fixed_konsole.add_child(debug_label)
	#reposition floating labels
	if !fixed:
		debug_label.position.x += float_label_x_offset
		debug_label.position.z += float_label_z_offset
		# instead of move up other float labels, 
		# calculate a lower position to spawn if needed
		var y_position = debug_label.position.y + float_label_y_offset
		if is_instance_valid(last_float_label):
			y_position = min(last_float_label.position.y - get_label_height(debug_label), float_label_y_offset)
		last_float_label = debug_label
		debug_label.global_position.y = y_position
		debug_label.reparent(float_konsole)
	debug_label.connect("autodestroy_label", on_label_autodestroy)


func clean_one_in_fixed_konsole() -> void:
	if is_instance_valid(fixed_konsole):
		var labels = get_tree().get_nodes_in_group("fixed_debug_labels")
		var node = labels[0]
		node.disconnect("autodestroy_label", on_label_autodestroy)
		node.queue_free()


func clean_all_in_fixed_konsole() -> void:
	if is_instance_valid(fixed_konsole):
		var labels = get_tree().get_nodes_in_group("fixed_debug_labels")
		for node in labels:
			node.disconnect("autodestroy_label", on_label_autodestroy)
			node.queue_free()


func on_label_autodestroy(debug_label):
	debug_label.disconnect("autodestroy_label", on_label_autodestroy)
	debug_label.queue_free()
