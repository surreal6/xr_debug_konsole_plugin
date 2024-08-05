extends Node3D

var counter = 0

func _on_timer_timeout() -> void:
	if counter == 7:
		DK.clean_all_in_fixed_konsole()
		DK.print_fixed("You can clean the fixed console with:", $XROrigin3D/XRCamera3D)
		DK.print_fixed("    DK.clean_all_in_fixed_konsole()", $XROrigin3D/XRCamera3D)
	if counter > 7:
		if counter %2 == 0:
			DK.print_fixed("Use DK.print_fixed(msg, camera) to print this", $XROrigin3D/XRCamera3D)
		else:
			DK.print_float("Use DK.print_float(msg, camera) to print this", $XROrigin3D/XRCamera3D)
	else:
		if counter % 2 == 0:
			DK.print_fixed("this is a fixed debug message", $XROrigin3D/XRCamera3D)
		else:
			DK.print_float("this is a floating debug message", $XROrigin3D/XRCamera3D)
	counter += 1

func _on_timer_2_timeout() -> void:
	DK.print_float("another floating debug message", $XROrigin3D/XRCamera3D, 5)
