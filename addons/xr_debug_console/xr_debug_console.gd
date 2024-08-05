@tool
extends EditorPlugin

const DEBUG_KONSOLE = "DK"

func _enter_tree() -> void:
	# Initialization of the plugin goes here.
	add_custom_type("DebugLabel3D", "Label3D", preload("DebugLabel3D.gd"), preload("DebugLabel3D.svg"))
	add_autoload_singleton(DEBUG_KONSOLE, "res://addons/xr_debug_console/debug_konsole.gd")

func _exit_tree() -> void:
	# Clean-up of the plugin goes here.
	remove_custom_type("DebugLabel3D")
	remove_autoload_singleton(DEBUG_KONSOLE)
