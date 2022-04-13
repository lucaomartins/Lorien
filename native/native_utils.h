#ifndef LORIEN_UTILS_H
#define LORIEN_UTILS_H

#include <Godot.hpp>
#include <Reference.hpp>

namespace godot {

class NativeUtils : public Reference {
    GODOT_CLASS(NativeUtils, Reference)

public:
    static void _register_methods();

    NativeUtils();
    ~NativeUtils();
    void _init();

    void say_hello();
    Rect2 calculate_rect(Vector2 start_pos, Vector2 end_pos);
};



} // namespace godot

#endif // LORIEN_UTILS_H