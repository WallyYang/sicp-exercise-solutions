(define (sqrt-iter prev-guess curr-guess x)
  (if (good-enough? prev-guess curr-guess)
      curr-guess
      (sqrt-iter curr-guess (improve curr-guess x) x)))

(define (good-enough? prev-guess curr-guess)
  (< (abs (- prev-guess curr-guess)) (/ curr-guess 1000000)))

(define (improve guess x)
  (average guess (/ x guess)))

(define (average x y)
  (/ (+ x y) 2))

(define (sqrt x)
  (sqrt-iter x 1.0 x))
