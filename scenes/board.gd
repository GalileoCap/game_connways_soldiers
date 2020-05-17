extends Node2D

var data

var record
var columns
var rows

var previous= 'a'
var selected
var moves
var n

#******************************************************************************
#Utilities:

func _process(_delta):
	if not selected == null:
		$lines.show()
		$lines.position= selected.position
	else:
		$lines.hide()

func save_board():
	print('IMPLEMENT SAVE BOARD')

func style(which):
	for child in get_children():
		child.style(which)
	data.style= which
	data.save_data()

func set_rc():
	if record == 0:
		columns= 1
		rows= 3
	elif record == 1:
		columns= 3
		rows= 4
	elif record == 2:
		columns= 5
		rows= 5
	else:
		columns= 8
		rows= 10
	
	rearrange()

func win():
	record+= 1
	data['record']+= 1
	data['moves']= moves
	data.save_data()

	set_rc()

#******************************************************************************
#Code:

func _input(event):
	if event is InputEventMouseButton and event.is_pressed():
		for child in get_children():
			if not child == $lines:
				if 'square' in child.name and child.get_rect().has_point(child.to_local(event.position)):
					if selected == null:
						for i in get_children():
							if not i == $lines and child.column == i.column and child.row == i.row and not child == i:
								print('SELECTED ', i.name)
								selected= i
					elif child.column == selected.column and child.row == selected.row and not child == selected:
						print('UNSELECT ', selected.name)
						selected= null
					else:
						var move= true
						for i in get_children():
							if not i == $lines and child.column == i.column and child.row == i.row and not child == i:
								move= false
	
						var d_c= abs(child.column - selected.column)
						var d_r= abs(child.row - selected.row)
						if move and ((d_c == 2 and d_r == 0) or (d_c == 0 and d_r == 2)):
							for i in get_children():
								if not i == $lines and i.column == selected.column+(child.column - selected.column)/2 and i.row == selected.row+(child.row-selected.row)/2 and not i == selected and not 'square' in i.name:
									print('MOVE ', selected.name)
									remove_child(i)
									
									selected.position= child.position
									selected.column= child.column
									selected.row= child.row
									moves+= 1
									
									if selected.row == 1:
										win()
									
									selected= null
									
									return
						else:
							for i in get_children():
								if not i == $lines and child.column == i.column and child.row == i.row and not child == i:
									print('SELECTED ', i.name)
									selected= i

func _start(d, r, f):
	record= r
	selected= null
	n= 0
	data= d
	
	if f:
		data.first= false
		data.save_data()
		get_node('../ui').rules()
	
	set_rc()

func instance_square(column, row):
	if record+1 < row:
		add_child(load('res://scenes/soldier.tscn').instance())
		var this_soldier= get_node('soldier')
		this_soldier.name= 'soldier_'+str(n)
		this_soldier.column= column
		this_soldier.row= row
		this_soldier.style(data.style)

	add_child(load('res://scenes/square.tscn').instance())
	var this_square= get_node('square')
	this_square.name= 'square_'+str(n)
	this_square.column= column
	this_square.row= row
	this_square.style(data.style)
	n+= 1

func rearrange(which= null, change= 0):
	moves= 0
	n= 0
	for i in get_children():
		if not i == $lines:
			remove_child(i)

	if not which == null and ((which == 'rows' and record+3 <= (rows+change)) or (which == 'columns' and 1 <= (columns+change))):
		print('CHANGE %s by %s' % [which, change])
		self[which]+= change

	for i in range(columns):
		for j in range(rows):
			instance_square(i+1, j+1)
	
	var height= get_node('../ui/controls').margin_top
	var base= get_viewport().size.x
	var d_h= height / rows
	var d_b= base / columns
	
	$lines.points= [Vector2(-d_b/2, -d_h/2), Vector2(d_b/2, -d_h/2), Vector2(d_b/2, d_h/2), Vector2(-d_b/2, d_h/2), Vector2(-d_b/2, -d_h/2-5)]
	
	for child in get_children():
		if not child == $lines:
			child.position= Vector2((2*child.column-1)*base/(2*columns), (2*child.row-1)*height/(2*rows))
			var org_size= child.get_texture().get_size().x
			var scale= Vector2(d_b/org_size, d_h/org_size)
			child.set_scale(scale)

	selected= null
