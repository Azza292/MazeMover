# Path - An object which is used to direct `ACTORS` across the board and store `ITEMS`.

extends Node2D

var connections
var moveable
var item
# Index Relative to the playing board
var index

var properties = PropertyManager.new()
var traversal = TraversalInfo.new()

var _target_pos
var _start_pos
var _t

# Travel time in seconds
const _TRAVEL_TIME = 0.6
# Target Threshold in Pixels
const _TARGET_THRESHOLD = 2

signal target_reached

func _ready():
	_target_pos = position
	_start_pos = position
	pass
	
func init(index, connections, moveable, item=null):
	self.index = index
	self.connections = connections
	self.moveable = moveable
	self.item = item
	
func _process(delta):
	
	if _target_pos != position:
		_move_toward_target(delta)
		
func _move_toward_target(delta):
	#var vel = (_target_pos - position).normalized() * _SPEED * delta
	
	_t += delta / _TRAVEL_TIME
	var next_pos = _start_pos.linear_interpolate(_target_pos, _t)

	if (_target_pos - position).length() > _TARGET_THRESHOLD:
		position = next_pos
	else:
		position = _target_pos
		emit_signal("target_reached")

func set_target(target, is_instant=false):
	
	if is_instant:
		position = target
		_target_pos = position
	else:
		_start_pos = position
		_target_pos = target
		_t = 0

func update_index(index):
	self.index = index

func collect_item():
	
	var temp_item = item
	item = null
	return temp_item

class TraversalInfo:
	"""Used for traversing the board / path finding."""
	var parent
	var h_cost
	var g_cost
	
	func _init():
		self.g_cost = 0
		self.h_cost = 0

	

class PropertyManager:
	var _properties = []
	
	func set(key, value):
		
		var success = false
		for p in _properties:
			if p.has(key):
				success = true
				p = value
		
		if !success:
			_properties.append({key : value})
			
	func get(key):
		for p in _properties:
			if p.has(key):
				return p[key]
				
	func remove(key):
		for p in _properties:
			if p.has(key):
				_properties.erase(p)
			
	func has(key):
		for p in _properties:
			if p.has(key):
				return true
		return false
		