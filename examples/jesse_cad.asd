! Stolen for convenience.
let sqrt =
  fun a : real =>
    cut x
      left  (x < 0 \/ x * x < a)
      right (x > 0 /\ x * x > a)
;;

! STOLEN!
! Compute the intersection of two shapes.
let intersection =
  fun shape_1 : real -> real -> prop * prop =>
  fun shape_2 : real -> real -> prop * prop =>
  fun x : real =>
  fun y : real =>
  ((shape_1 x y)#0 /\ (shape_2 x y)#0,
   (shape_1 x y)#1 \/ (shape_2 x y)#1)
;;

! STOLEN!
let translate =
  fun trans_x : real =>
  fun trans_y : real =>
  fun shape : real -> real -> prop * prop =>
  fun x : real =>
  fun y : real =>
    shape (x - trans_x) (y - trans_y)
;;

! STOLEN
let complement =
  fun shape : real -> real -> prop * prop =>
  fun x : real =>
  fun y : real =>
  ((shape x y)#1, (shape x y)#0)
;;

! Implement line with an interior in the direction of the normal.
let line =
      fun nx : real =>
      fun ny : real =>
      fun x  : real =>
      fun y  : real =>
      (nx * x + ny * y > 0, nx * x + ny * y < 0)
  ;;

! Sloped line
let sloped_line =
      fun m : real =>
      line -1 (1/m)
  ;;

!! Create a slope m line through the origin.
!let line =
!      fun m : real =>
!      fun x : real =>
!      fun y : real =>
!      (y - m * x < 0, y - m * x > 0)
!  ;;
!
!!! pass in a single parameter
!!let nowline =
!!    fun my_line : real -> real -> prop * prop  =>
!!    fun x : real =>
!!    fun y : real =>
!!    (my_line x y 1)
!!;;
!
!
!! Create a unit slope line through the origin.
!let unitline =
!      fun x : real =>
!      fun y : real =>
!      (y - x < 0, y - x > 0)
!  ;;
!
!! Another version
!! Maybe use this and then have generic single-coordinate scaling
!let unit_line = line 1

! Bad vertical line
let vertical_line =
    fun x : real =>
    fun y : real =>
    (x<0,x>0)
    ;;

! Better vertical line?
! NOTE DOESNT WORK RN
!let vertical_line =
!    fun x : real =>
!    flip_interior (line 1 x 0)
!    ;;


! Create a unit triangle centered at the origin
let triangle =
    let top_right = translate 0 1 (sloped_line -3) in
    let top_left = translate 0 1 (complement(sloped_line 3)) in
    let bottom = translate 0 (-(sqrt 3) / 6) (line 0 1) in
    intersection (intersection top_right top_left) bottom
    ;;  ! intersection take more params

! Create a unit square centered at the origin
let square =
  let left_side = translate (1/2) 0 vertical_line in
  let right_side = translate (-1/2) 0 (complement vertical_line) in
  let top = translate 0 (1/2) (complement (line 0 1)) in
  let bottom = translate 0 (-1/2) (line 0 1) in
  let vertical_strip = intersection left_side right_side in
  let horizontal_strip = intersection top bottom in
  intersection horizontal_strip vertical_strip
  ;;

! Dot product
let dot =
    fun x1 : real =>
    fun y1 : real =>
    fun x2 : real =>
    fun y2 : real =>
    x1 * x2 + y1 * y2
    ;;

! broken Implementation of reflection of a shape across a line
! The line is specified by a point on the line and a normal
! https://stackoverflow.com/questions/3306838/algorithm-for-reflecting-a-point-across-a-line
!let reflect =
!    fun px : real =>
!    fun py : real =>
!    fun nx : real =>
!    fun ny : real =>
!    fun shape : real -> real -> prop * prop =>
!    fun x : real =>
!    fun y : real =>
!    let c = (dot (px - x) (py - y) nx ny) / (dot nx ny nx ny) in
!    let plx = px + c * nx in
!    let ply = py + c * ny in
!    shape (2 * plx - x) (2 * ply - y)
!    ;;


! Implementation of reflection of a shape across a line
! The line is ax + bx + c = 0
! https://drive.google.com/file/d/0By83v5TWkGjvb2tuekNSUFo3cFE/view
let reflect =
    fun a : real =>
    fun b : real =>
    fun c : real =>
    fun shape : real -> real -> prop * prop =>
    fun x : real =>
    fun y : real =>
    shape ((x * (a*a - b*b) - 2*b*(a*y+c))/(a*a+b*b))    ((y*(b*b-a*a) - 2*a*(b*x+c))/(a*a+b*b))
    ;;


! Idea: maybe a reflect in/reflect out for reflection to move to interior. Might also include a minimal glide reflection.
! Idea: Use the roots of unity for common fixed rotations.
! how do I make proper function with variables? ANS "in"
! ideas for visualization software?
! e.g. if it compiles into ocaml then we can use some ocaml visualization library?
! use disp and make ocaml to it!

! bad/broken example
! # sqrt 8 < 2 * sqrt 2 ;;
! - : prop = True
! # 2 * sqrt 2 < sqrt 8 ;;
! - : prop = False


! CAD related real ram stuff
! # 0.e-19;;
! - : real = 0.e-37
