extends Node3D

var counter = 0

func _ready() -> void:
	DK.set_current_camera($XROrigin3D/XRCamera3D)

func _on_timer_timeout() -> void:
	if counter == 7:
		DK.clean_all_in_fixed_konsole()
		DK.print_fixed("You can clean the fixed console with:")
		DK.print_fixed("    DK.clean_all_in_fixed_konsole()")
	if counter > 7:
		if counter %2 == 0:
			DK.print_fixed("Use DK.print_fixed(msg, camera) to print this %s" % counter)
		else:
			DK.print_float("Use DK.print_float(msg, camera) to print this %s" % counter)
	else:
		if counter % 2 == 0:
			DK.print_fixed("this is a fixed debug message %s" % counter)
		else:
			DK.print_float("this is a floating debug message %s" % counter)
	counter += 1


func _on_timer_2_timeout() -> void:
	DK.print_float("one")
	DK.print_float("two")
	DK.print_float("three")
	DK.print_float("four")
