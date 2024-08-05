extends Node

#fixed konsole
@export var fixed_konsole : Node3D
@export var fixed_konsole_x_offset : float = -0.5
@export var fixed_konsole_y_offset : float = 0.0
@export var fixed_konsole_z_offset : float = -2
# fixed debug label style
@export var fixed_font_size : int = 8
@export var fixed_outline_size : int = 0
@export var fixed_modulate : Color = Color("black")
@export var fixed_outline_modulate : Color = Color("white")

@export var autoclean : int = 10

#float konsole
@export var float_konsole : Node3D
@export var float_konsole_x_offset : float = 0.5
@export var float_konsole_y_offset : float = 0
@export var float_konsole_z_offset : float = -1.5
# float debug label style
@export var float_font_size : int = 16
@export var float_outline_size : int = 3
@export var float_modulate : Color = Color("white")
@export var float_outline_modulate : Color = Color("black")

@export var float_default_duration : int = 10

var current_camera : XRCamera3D


func _process(_delta: float) -> void:
	if is_instance_valid(fixed_konsole):
		fixed_konsole.global_rotation.z = 0
		fixed_konsole.global_rotation.x = 0
	if is_instance_valid(current_camera):
		var pos = current_camera.global_position.y + fixed_konsole_y_offset
		fixed_konsole.global_position.y = pos


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


func print_fixed(msg, camera):
	if current_camera != camera:
		current_camera = camera
		setup_konsoles()
	print("k$: %s" % msg)
	add_label(msg, true)


func print_float(msg, camera, delay = float_default_duration):
	if current_camera != camera:
		current_camera = camera
		setup_konsoles()
	print("k$f: %s" % msg)
	add_label(msg, false, delay)


func move_up_all_children(konsole_parent, v_size = 0.05):
	for node in konsole_parent.get_children():
		node.position.y += v_size


func add_label(msg, fixed, delay = float_default_duration):
	var debug_label = DebugLabel3D.new()
	debug_label.msg = msg
	debug_label.fixed = fixed
	debug_label.delay = delay
	if fixed :
		move_up_all_children(fixed_konsole)
		if fixed_konsole.get_children().size() > autoclean:
			clean_one_in_fixed_konsole()
		fixed_konsole.add_child(debug_label)
	else:
		move_up_all_children(float_konsole)
		float_konsole.add_child(debug_label)

	debug_label.global_position = fixed_konsole.global_position
	if !fixed:
		debug_label.position.x += float_konsole_x_offset - fixed_konsole_x_offset
		debug_label.position.z += float_konsole_z_offset - fixed_konsole_z_offset
		debug_label.global_position.y = float_konsole.global_position.y + float_konsole_y_offset

	debug_label.connect("autodestroy_label", on_label_autodestroy)


func clean_one_in_fixed_konsole() -> void:
	if is_instance_valid(fixed_konsole):
		var node = fixed_konsole.get_children()[0]
		node.disconnect("autodestroy_label", on_label_autodestroy)
		node.queue_free()


func clean_all_in_fixed_konsole() -> void:
	if is_instance_valid(fixed_konsole):
		for node in fixed_konsole.get_children():
			node.disconnect("autodestroy_label", on_label_autodestroy)
			node.queue_free()


func on_label_autodestroy(debug_label):
	debug_label.disconnect("autodestroy_label", on_label_autodestroy)
	debug_label.queue_free()
