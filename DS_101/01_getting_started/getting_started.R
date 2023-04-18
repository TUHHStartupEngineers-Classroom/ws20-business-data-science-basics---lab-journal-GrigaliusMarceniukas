
2 * 3   
## 6

4 - 1   
## 3

6 / (4 - 1)   
## 22 * 3   
## 6

4 - 1   
## 3

6 / (4 - 1)   
## 2

#⁠ Step by step
2 * 1000 * 5
#⁠#⁠ 10000
10000 / 0.25
#⁠#⁠ 40000
sqrt(40000)
#⁠#⁠ 200

#⁠ Or as an one-liner
sqrt((2 * 1000 * 5) / 0.25)
#⁠#⁠ 200

Q <- 200
q <- 100
q
Q
## 200

die <- 1:6
die
## 1 2 3 4 5 6


D <- 1000
K <- 5
h <- 0.25
sqrt(2 * D * K / h)
#⁠#⁠ 200

D <- 4000
sqrt(2 * D * K / h)
#⁠#⁠ 400

mean(1:6)
## 3.5

die <- 1:6
mean(die)
## 3.5

round(mean(die))
## 4

round(3.1415)
## 3

round(3.1415, digits = 2)
## 3.14

sample(die, size = 1)
## 3

dice <- sample(die, size = 2, replace = TRUE)
dice
## 3 4

sum(dice)
## 7

roll <- function() {
  die <- 1:6
  dice <- sample(die, size = 2, replace = TRUE)
  sum(dice)
}


roll()
## 6

roll2 <- function() {
  dice <- sample(faces, size = 2, replace = TRUE)
  sum(dice)
}

roll2()
## Error in sample(faces, size = 2, replace = TRUE) : 
##   object 'faces' not found

roll2 <- function(faces) {
  dice <- sample(faces, size = 2, replace = TRUE)
  sum(dice)
}

roll2(faces = 1:6)
## 7

roll2(faces = 1:10)
## 13

roll2 <- function(faces = 1:6) {
  dice <- sample(faces, size = 2, replace = TRUE)
  sum(dice)
}

roll2()
## 9

roll2 <- function(faces = 1:6, number_of_dice = 2) {
  dice <- sample(x = faces, size = number_of_dice, replace = TRUE)
  sum(dice)
}
roll2()
#⁠#⁠ 10

#⁠ Four Tetrahedron shaped dice (Four faces)
roll2(faces = 1:4, number_of_dice = 4)
#⁠#⁠ 11

calc_EOQ <- function(D = 1000) {
  K <- 5
  h <- 0.25
  Q <- sqrt(2*D*K/h)
  Q
}

calc_EOQ()
#⁠#⁠ 200

calc_EOQ(D = 4000)
#⁠#⁠ 400


roll3 <- function(faces = 1:6, number_of_dice = 1) {
  dice <- sample(x = faces, size = number_of_dice, 
                 replace = TRUE, 
                 prob = c(0.1, 0.1, 0.1, 0.1, 0.1, 0.5))
  sum(dice)
}

# You can run the function 100 times, store the results and plot a histogram to varify your function
results <- replicate(100, roll3(), TRUE)
hist(results)