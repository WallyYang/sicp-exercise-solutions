(define (cbrt-iter prev-guess curr-guess x)
  (if (good-enough? prev-guess curr-guess)
      curr-guess
      (cbrt-iter curr-guess (improve curr-guess x) x)))

(define (good-enough? prev-guess curr-guess)
  (< (abs (- prev-guess curr-guess)) (/ curr-guess 1000000)))

(define (improve guess x)
  (third (/ x (* guess guess)) (* 2 guess)))

(define (third x y)
  (/ (+ x y) 3))

(define (cbrt x)
  (cbrt-iter x 1.0 x))
