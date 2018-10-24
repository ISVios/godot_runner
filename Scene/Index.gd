extends Control
#

const NORMAL_SIZE = Vector2(400, 100);
const FILE_OPEN_SIZE = Vector2(600, 400);
#
onready var pop_menu = preload("res://Scene/PopupMenu.tscn").instance();
#
var CON_FILE = str(OS.get_executable_path().get_base_dir()) + "/conf";
var os;
var linux_exit_fix = false; # fix quickclose
var edit = !false; # change conf else edit;
var file_open = false;
var point_edit = null;

#
func _ready():
	
	# get os type
	os = OS.get_name();
	if(os == "x11"):
		
		linux_exit_fix = true;
		OS.center_window();
		
		
		
	
	# jump mouse to Window
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED);
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE);
	
	
	# get path to project
	
	var path_to_project = OS.get_environment("godot_runner_project_path"); # need create bat or sh
	if(path_to_project != ""):
		
		isglobal.project_path = path_to_project.replace("\\", "/");
		isglobal.project_path = path_to_project.replace(" ", "%20");
	
	# setup pop menu
	pop_menu.set_item_disabled(1, true);
	pop_menu.set_item_disabled(2, true);
	add_child(pop_menu);
	pop_menu.connect("index_pressed", self, "pop_menu_select");
	
	
	#load conf
	var conf_file = File.new();
	
	if(conf_file.file_exists(CON_FILE)):
		
		conf_file.open(CON_FILE, File.READ_WRITE);
		
		isglobal.conf = conf_file.get_var();
		
		conf_file.close();
		
		
		for elm_index in isglobal.conf:
			
			var elm = load("res://Scene/Element.tscn").instance();
			
			elm.engine_path = isglobal.conf[elm_index]["path"];
			elm.engine_version = isglobal.conf[elm_index]["ver"];
			
			$ScrollContainer/HBoxContainer.add_child(elm);
			
		
		
	
	
	#print("OS: " + str(os) + " path: [" + str(path_to_project)+"]");
	#print("conf: " + str(isglobal.conf));
	
	
	# correct ui
	$ScrollContainer.show();
	$VBoxContainer.hide();
	
	
#

func _process(delta):
	
	if(Input.is_action_just_pressed("ui_cancel")):
		
		quit();
		
	
#

func _exit_tree():
	
	pop_menu.disconnect("index_pressed", self, "pop_menu_select");
	
#

func _notification(what):
	
	
	if(what == MainLoop.NOTIFICATION_WM_FOCUS_OUT && !linux_exit_fix && !file_open):
		
		quit();
		
	elif(linux_exit_fix):
		
		linux_exit_fix = false;
		
#

func quit():
	
	#save 
	
	if(get_tree().get_nodes_in_group("element").size() == 0): # if element == zero just del file
		
		var dir = Directory.new();
		
		if(dir.file_exists(CON_FILE)):
			
			
			dir.remove(CON_FILE);
			
			
		
	elif(edit):
		
		var file = File.new();
		file.open(CON_FILE, File.WRITE);
		print(isglobal.conf);
		file.store_var(isglobal.conf);
		file.close();
		
		
		
	
	get_tree().quit();
	
#

func _on_ScrollContainer_gui_input(ev):
	
	if(ev is InputEventMouseButton):
		
		if(ev.button_index == 2):
			
			pop_menu.show_modal();
			
		 
	
#

func pop_menu_select(index):
	
	match(index):
		
		
		0:
			
			print("open edit menu");
			
			$ScrollContainer.hide();
			$VBoxContainer.show();
			
		
		3:
			
			quit();
			
		
	
	
#

func edit(point):
	
	pass
	
	
#

func _on_edit_cancel_pressed():
	
	$ScrollContainer.show();
	$VBoxContainer.hide();
	
#

func _on_file_ok_pressed():
	
	
	if(isglobal.conf == null):
		
		isglobal.conf = {};
		
	
	var file = File.new();
	if(file.file_exists($VBoxContainer/HBoxContainer3/LineEdit.text)):
		
		var elm;
		
		if(point_edit != null):
			
			
			elm = point_edit;
			
			
		else:
			
			elm = load("res://Scene/Element.tscn").instance();
			$ScrollContainer/HBoxContainer.add_child(elm);
			
		
		elm.engine_path = $VBoxContainer/HBoxContainer3/LineEdit.text;
		elm.engine_version = $VBoxContainer/HBoxContainer2/LineEdit.text;
		
		
		
		if(point_edit == null):
			#D:/workspace/godot/compiled/Godot_v3.0.6-stable_win64.exe
			var size = str(isglobal.conf.size());
			isglobal.conf[size] = {};
			print(isglobal.conf)
			isglobal.conf[size]["path"] = $VBoxContainer/HBoxContainer3/LineEdit.text;
			isglobal.conf[size]["ver"] = $VBoxContainer/HBoxContainer2/LineEdit.text;
			
		else:
			
			
			var index = 0;
			for index in range($ScrollContainer/HBoxContainer.get_child_count()):
				
				if($ScrollContainer/HBoxContainer.get_children()[index] == point_edit):
					
					break;
					
				
			
			
			isglobal.conf[str(index)] = {};
			isglobal.conf[str(index)]["path"] = $VBoxContainer/HBoxContainer3/LineEdit.text;
			isglobal.conf[str(index)]["ver"] = $VBoxContainer/HBoxContainer2/LineEdit.text;
			
			point_edit = null;
		
		
		$ScrollContainer.show();
		$VBoxContainer.hide();
		
		point_edit = null;
	else:
		
		$AcceptDialog.show_modal();
		
	
	edit = true;
	
#

func _on_file_select_pressed():
	
	file_open = true;
	
	OS.window_size = FILE_OPEN_SIZE;
	OS.center_window();
	$FileDialog.show_modal();
	
#

func _on_FileDialog_hide():
	
	OS.window_size = NORMAL_SIZE;
	OS.center_window();
	file_open = false;


func _on_FileDialog_file_selected(path):
	
	$VBoxContainer/HBoxContainer3/LineEdit.text = path;
