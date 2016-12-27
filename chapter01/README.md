# Chapter 01 Building Abstraction with Procedures

## Exercise 1.1
> Below is a sequence of expressions. What is the result printed by the interpreter in response to each expression? Assume that the sequence is to be evaluated in the order in which it is presented.

1. 10
2. 12
3. 8
4. 3
5. 6
6. a
7. b
8. 19
9. #f
10. 4
11. 16
12. 6
13. 16

## Exercise 1.2
```scheme
(/ (+ 5 4 (- 2 (- 3 (+ 6 (/ 4 5))))) (* 3 (- 6 2) (- 2 7)))
```

## Exercise 1.3
(define (sum-of-larger-squares a b c)
  (cond ((and (> a c) (> b c)) (+ (* a a) (* b b)))
        ((and (> a b) (> c b)) (+ (* a a) (* c c)))
        (else (+ (* b b) (* c c)))))

## Exercise 1.4
> Observe that our model of evaluation allows for combinations whose operators are compound expression. Use this observation to describe the behavior of the following procedure:
```scheme
(define (a-plus-abs a b)
  ((if (> b 0) + -) a b))
```

The procedure first determine if b is greater than 0. If so, use + operator, use - otherwise. So the result will be a plus the sum of a and the absolute value of b.

## Exercise 1.5
> Ben Bitdiddle has invented a test to determine whether the interpreter he is faced with is using applicative-order evaluation or normal-order evaluation. He defines the following two procedures:
```scheme
(define (p) (p))
(define (test x y)
  (if (= x 0) 0 y))
```
> Then he evaluates the expression
```scheme
(test 0 (p))
```
> What behavior will Ben observe with an interpreter that uses applicative-order evaluation? What behavior will he observe with an interpreter that uses normal-order evalutation? Explain your answer. (Assume that the evaluation rule for the special form *if* is the same whether the interpreter is using normal or applicative order: The predicate expression is evaluated first, and the result determines whether to evaluate the consequent or the alternative expression.)

By applicative-order evaluation, the interpreter will first evaluate the arguments x y to 0 and (p). However, (p) is infinitely expand to itself, so the process will never terminates.
By normal-order evaluation, the interpreter will first exapnd the expression into `(if (= 0 0) 0 (p))`, and since `(= x 0)` is evaluted to *#t*(true), so (p) is never evaluated, and the expression will give result 0.

## Exercise 1.6
> Alyssa P. Hacker doesn't see why *if* needs to be provided as a special form. "Why can't I just define it as an ordinary procedure in terms of *cond*?" she asks. Alyssa's friend Eva Lu Ator claims this can indeed be done, and she defines a new version of *if*:
```scheme
(define (new-if predicate then-clause else-clause)
  (cond (predicate then-clause)
        (else else-clause)))
```
> Eva demonstrate the prorgram for Alyssa:
```scheme
(new-if (= 2 3) 0 5)
5
(new-if (= 1 1) 0 5)
0
```
> Delighted, Alyssa uses *new-if* to rewrite the square-root program:
```scheme
(define (sqrt-iter guess x)
  (new-if (good-enough? guess x)
          guess
          (sqrt-iter (improve guess x) x)))
```
> What happens when Alyssa attempts to use this to compute square roots? Explain.

Because *new-if* is defined as a procedure, so when passing a expression like `(sqrt-iter (improve guess x) x)` the *new-if* is expanded into 
```scheme
(new-if (good-enough? guess x) guess (sqrt-iter (improve guess x) x))
```
and the second argument will be expand first in applicative-order interpreter, so it will infinitely expand itself and make the maximum recursion depth exceeded

## Exercise 1.7
> The *good-enough?* test used in computing square roots will not be very effective for finding the square roots of very small numbers. Also, in real computers, arithmetic operations are almost always performed with limited precision. This makes our test inadequate for very large numbers. Explain these statements, with exmaples showing how the test fails for small and large numbers. An alternative strategy for implementing *good-enough?* is to watch how *guess* changes from one iteration to the next and to stop when the change is a very small fraction of the guess. Design a square-root procedure that uses this kind of end test. Does this work better for small and large numbers?

When evaluate `(sqrt 0.000001)`, the interpreter generates 3.1260655525445276e-2 which is greatly different from the real answer. When evaluate `(sqrt 10000000000000)`, the interpreter never stops because *good-enough* will never become true due to float number representation in computers. 
[New Implementation](https://github.com/wallyyang/sicp-exercise-solutions/blob/master/chapter01/ex01_07.scm)

## [Exercise 1.8](http://github.com/wallyyang/sicp-exercise-solutions/blob/master/chapter01/ex01_08.scm)

## Exercise 1.9
> Each of the following two procedures defines
> a method for adding two positive integers in terms of the
> procedures *inc*, which increments its argument by 1, and
> *dec*, which decrements its argument by 1.
```scheme
(define (+ a b)
  (if (= a 0) b (inc (+ (dec a) b))))
(define (+ a b)
  (if (= a 0) b (+ (dec a) (inc b))))
```
> Using the substitution model, illustrate the process generated by each
> procedure in evaluating (+ 4 5). Are these processes iterative or recursive?

Process A:
```scheme
(+ 4 5)
(if (= 4 0) 5 (inc (+ (dec 4) 5)))
(if (= 4 0)
    5 (inc (+ 3 5)))
(if (= 4 0)
    5 (inc (if (= 3 0) 5 (inc (+ (dec 3) 5)))))
(if (= 4 0)
    5 (inc (if (= 3 0) 5 (inc (+ 2 5)))))
(if (= 4 0)
    5 (inc (if (= 3 0) 5 (inc (if (= 2 0) 5 (inc (+ (dec 2) 5)))))))
(if (= 4 0)
    5 (inc (if (= 3 0) 5 (inc (if (= 2 0) 5 (inc (+ 1 5)))))))
(if (= 4 0)
    5 (inc (if (= 3 0)
               5 (inc (if (= 2 0)
                          5 (inc (if (= 1 0) 5 (inc (+ (dec 1) 5)))))))))
(if (= 4 0)
    5 (inc (if (= 3 0)
               5 (inc (if (= 2 0) 5 (inc (if (= 1 0) 5 (inc (+ 0 5)))))))))
(if (= 4 0)
    5 (inc (if (= 3 0)
               5 (inc (if (= 2 0)
                          5 (inc (if (= 1 0)
                                     5 (inc (if (= 0 0)
                                                5 (inc (+ (dec 0) 5)))))))))))
(if (= 4 0)
    5 (inc (if (= 3 0)
               5 (inc (if (= 2 0)
                          5 (inc (if (= 1 0)
                                     5 (inc (if #t 5 (inc (+ (dec 0) 5)))))))))))
(if (= 4 0)
    5 (inc (if (= 3 0)
               5 (inc (if (= 2 0)
                          5 (inc (if (= 1 0) 5 (inc 5))))))))
(if (= 4 0) 5 (inc (if (= 3 0) 5 (inc (if (= 2 0) 5 (inc (if #f 5 6)))))))
(if (= 4 0) 5 (inc (if (= 3 0) 5 (inc (if (= 2 0) 5 (inc 6))))))
(if (= 4 0) 5 (inc (if (= 3 0) 5 (inc (if #f 5 7)))))
(if (= 4 0) 5 (inc (if (= 3 0) 5 (inc 7))))
(if (= 4 0) 5 (inc (if #f 5 8)))
(if (= 4 0) 5 (inc 8))
(if #f 5 9)
9
```
recursive, since the process does not save its states;

Process B:
```scheme
(+ 4 5)
(if (= 4 0) 5 (+ (dec 4) (inc 5)))
(if (= 4 0) 5 (+ 3 6))
(if (= 4 0) 5 (if (= 3 0) 6 (+ (dec 3) (inc 6))))
(if (= 4 0) 5 (if (= 3 0) 6 (+ 2 7)))
(if (= 4 0) 5 (if (= 3 0) 6 (if (= 2 0) 7 (+ (dec 2) (inc 7)))))
(if (= 4 0) 5 (if (= 3 0) 6 (if (= 2 0) 7 (+ 1 8))))
(if (= 4 0) 5 (if (= 3 0) 6 (if (= 2 0) 8 (+ (dec 1) (inc 8)))))
(if (= 4 0) 5 (if (= 3 0) 6 (if (= 2 0) 8 (+ 0 9))))
(if (= 4 0) 5 (if (= 3 0) 6 (if #f 8 9)))
(if (= 4 0) 5 (if (= 3 0) 6 9))
(if (= 4 0) 5 (if #f 6 9))
(if (= 4 0) 5 9)
(if #f 5 9)
9
```
iterative, since every call to the procedure pass the
states of the process

## Exercise 1.10
> The following procedure computes a math-
> ematical function called Ackermann's function
```scheme
(define (A x y)
  (cond ((= y 0) 0)
        ((= x 0) (* 2 y))
        ((= y 1) 2)
        (else (A (- x 1) (A x (- y 1))))))
```
> What are the values of the following expressions?
```scheme
(A 1 10)
(A 2 4)
(A 3 3)
```
> Consider the following procedures, where A is the procedure defined above:
```scheme
(define (f n) (A 0 n))
(define (g n) (A 1 n))
(define (h n) (A 2 n))
(define (k n) (* 5 n n))
```
> Give Consice mathematical definition for the functions computed by the procedure *f*, *g*, and *h* for positive integer values of n. For example, (k n) computes *5n^2*

1. 
    1. 1024
    2. 65536
    3. 65536
2. 
    1. f(n) = 2 * n
    2. g(n) = 2 ^ n
    3. h(n) = 2 ^ (2 ^ n)
    4. k(n) = 5 * n ^ 2

## Exercise 1.11
* [Recursive process](./ex01_11a.scm)
* [iterative process](./ex01_11b.scm)

## [Exercise 1.12](./ex01_12.scm)

## [Exercise 1.13](http://www.billthelizard.com/2009/12/sicp-exercise-113-fibonacci-and-golden.html)
