extends Panel

var engine_path = "unknown";
var engine_version = "unknown";

onready var pop_menu = preload("res://Scene/PopupMenu.tscn").instance();

func _ready():
	
		# setup pop menu
	add_child(pop_menu);
	pop_menu.connect("index_pressed", self, "pop_menu_select");
	
	
#

func _process(delta):
	
	$VBoxContainer/Label.text = engine_version;
	
#

func _exit_tree():
	
	pop_menu.disconnect("index_pressed", self, "pop_menu_select");
	
#


func _on_element_gui_input(ev):
	
	if(ev is InputEventMouseButton):
		
		if(ev.button_index == 2):
			
			pop_menu.show_modal();
			
		elif(ev.button_index == 1 && ev.pressed):
			
			
			if(isglobal.project_path == null):
				
				OS.execute(str(engine_path) , [], false);
			else:
				
				OS.execute(str(engine_path), [ isglobal.project_path, "-e"], false);
				
			 
			get_tree().root.get_node("main").quit();
			
		
	
#

func pop_menu_select(index):
	
	match(index):
		
		0: 
			
			var main = get_tree().root.get_node("main");
			
			get_tree().root.get_node("main/VBoxContainer/HBoxContainer3/LineEdit").text = ""#str(engine_path);
			get_tree().root.get_node("main/VBoxContainer/HBoxContainer2/LineEdit").text = ""#str(engine_version);
			
			main.pop_menu_select(index);
			
		
		1: 
			
			var main = get_tree().root.get_node("main");
			
			get_tree().root.get_node("main/VBoxContainer/HBoxContainer3/LineEdit").text = str(engine_path);
			get_tree().root.get_node("main/VBoxContainer/HBoxContainer2/LineEdit").text = str(engine_version);
			
			main.point_edit = self;
			main.pop_menu_select(0);
			
		
		
		2:
			
			queue_free();
			
		
		3: 
			
			var main = get_tree().root.get_node("main");
			main.pop_menu_select(3);
			
		
	
#

