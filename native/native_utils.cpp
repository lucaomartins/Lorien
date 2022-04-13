#include "native_utils.h"

using namespace godot;

void NativeUtils::_register_methods() {
	register_method("say_hello", &NativeUtils::say_hello);
	register_method("calculate_rect", &NativeUtils::calculate_rect);

}

NativeUtils::NativeUtils() {

}

NativeUtils::~NativeUtils() {
	// add your cleanup here
}

void NativeUtils::_init() {

}

void NativeUtils::say_hello() {
    Godot::print("Hello from GDNative!");
}

Rect2 NativeUtils::calculate_rect(Vector2 start_pos, Vector2 end_pos) {
	Rect2 area(start_pos, end_pos - start_pos);
	if (end_pos.x < start_pos.x && end_pos.y < start_pos.y) {
		area.position = end_pos;
		area.size = start_pos - area.position;
	} else if (end_pos.x < start_pos.x && end_pos.y > start_pos.y) {
		area.position = Vector2(end_pos.x, start_pos.y);
		area.size = Vector2(start_pos.x, end_pos.y) - area.position;
	} else if (end_pos.x > start_pos.x && end_pos.y < start_pos.y) {
		area.position = Vector2(start_pos.x, end_pos.y);
		area.size = Vector2(end_pos.x, start_pos.y) - area.position;
	}

	return area;
}