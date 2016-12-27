(define (f n)
  (cond ((< n 3) n)
        (else (f-iter 0 1 2 (- n 2)))))

(define (f-iter a b c n)
  (cond ((= n 0) c)
        (else (f-iter b c (+ c (* 2 b) (* 3 a)) (- n 1)))))
