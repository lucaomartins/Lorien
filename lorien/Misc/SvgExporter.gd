class_name SvgExporter
extends Reference

# TODOs
# - Stroke width / pressue data

# -------------------------------------------------------------------------------------------------
const EDGE_MARGIN := 0.025

# -------------------------------------------------------------------------------------------------
func export_svg(strokes: Array, background: Color, path: String) -> void:
	# Open file
	var file := File.new()
	var err := file.open(path, File.WRITE)
	if err != OK:
		printerr("Failed to open file for writing")
		return
	
	# Clac dimensions
	var max_dim := BrushStroke.MIN_VECTOR2
	var min_dim := BrushStroke.MAX_VECTOR2
	for stroke in strokes:
		min_dim.x = min(min_dim.x, stroke.top_left_pos.x)
		min_dim.y = min(min_dim.y, stroke.top_left_pos.y)
		max_dim.x = max(max_dim.x, stroke.bottom_right_pos.x)
		max_dim.y = max(max_dim.y, stroke.bottom_right_pos.y)
	var size := max_dim - min_dim
	var margin_size := size * EDGE_MARGIN
	size += margin_size*2.0
	var origin := min_dim - margin_size
	
	# Write svg to file
	_render_start(file, origin, size)
	_render_rect(file, origin, size, background)
	for stroke in strokes:
		_render_polyline(file, stroke)
	_render_end(file)
	
	# Flush and close the file
	file.flush()
	file.close()
	print("Exported svg to %s" % path)

# -------------------------------------------------------------------------------------------------
func _render_start(file: File, origin: Vector2, size: Vector2) -> void:
	var params := [origin.x, origin.y, size.x, size.y]
	var svg := "<svg version=\"1.1\" xmlns=\"http://www.w3.org/2000/svg\" viewBox=\"%.1f %.1f %.1f %.1f\">\n" % params
	file.store_string(svg)

# -------------------------------------------------------------------------------------------------
func _render_end(file: File) -> void:
	file.store_string("</svg>") 

# -------------------------------------------------------------------------------------------------
func _render_rect(file: File, origin: Vector2, size: Vector2, color: Color) -> void:
	var params := [origin.x, origin.y, size.x, size.y, color.to_html(false)]
	var rect := "<rect x=\"%.1f\" y=\"%.1f\" width=\"%.1f\" height=\"%.1f\" fill=\"#%s\" />\n" % params
	file.store_string(rect)

# -------------------------------------------------------------------------------------------------
func _render_polyline(file: File, stroke: BrushStroke) -> void:
	file.store_string("<polyline points=\"")
	var idx := 0
	var point_count := stroke.points.size()
	for point in stroke.points:
		if idx < point_count-1:
			file.store_string("%.1f %.1f," % [point.x, point.y])
		else:
			file.store_string("%.1f %.1f" % [point.x, point.y])
		idx += 1
	file.store_string("\" style=\"fill:none;stroke:#%s;stroke-width:2\"/>\n" % stroke.color.to_html(false))
