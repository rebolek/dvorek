dvorek
======

Various Rebol scripts

## AFUNC

Assert function - create function with boundary checking. See [this blog](http://blog.iluminat.cz/post/dependent-types-and-value-assertion) for more informations.

### Example

  fac: afunc [
      "Factorize number"
      n [integer! >= 0 < 21] "Number to factorize"
  ][
      if zero? n [return 1]
      n * fac n - 1
  ]

## COMBINE

Reduces and joins a block of values.

## COMPARE

Block comparison dialect.

### Example

  a: [1 2 3 4 5 6 7 8 9]
  b: [2 4 6]
  c: [10 20 30]
  d: [5 10 15]
  
  >> compare a d [some b > one d] 
  == true
  
  >> compare a b [some a = some b]
  == true
  
  >> compare a c [every a < every c]
  == true
  
  >> compare a c [no a > every c]
  == true
  
  >> compare a d [one a = one d]
  == true

## FILTER

Block filtering dialect.

### Example

  >> filter serie [iterate [x: x + 1] 10 ] [[x > 2] [x < 5]]
  == [3 4]
  
  >> filter etc [3 6 9] 100 [x > 250] 
  == [252 255 258 261 264 267 270 273 276 279 282 285 288 291 294 297 300]
  
  >> filter serie [1 .. 10] [[x > 5][zero? x // 2]] 
  == [6 8 10]

## SERIE

Numerical series creation dialect.

### Example

  >> serie [1 2 3 4 5]
  == [1 2 3 4 5]
  
  >> serie [1 .. 5]    
  == [1 2 3 4 5]
  
  >> serie [etc 1 2 3 x 5]
  == [1 2 3 4 5]
  
  >> serie [cycle [1 2 3] 5]   
  == [1 2 3 1 2]
  
  >> serie [iterate [x: x + 1] 5]
  == [1 2 3 4 5]
  
  >> serie [etc 2 4 8 .. 40]
  == [2 4 8 16 32]
  
  >> serie [iterate [x: x + 3 * 2] from 10 5]
  == [10 26 58 122 250]
