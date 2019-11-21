
library(grid)
image1 <- function() {
    grid.rect()
    grid.text("same", 1/3, 2/3)
}
image2 <- function() {
    grid.rect()
    grid.text(c("same", "different"), 1:2/3, 2:1/3)
}
## Generate control image
png("control-image.png", width=300, height=300, res=300)
image1()
dev.off()
## Generate test image
png("test-image.png", width=300, height=300, res=300)
image2()
dev.off()
library(magick)
controlImage <- image_read("control-image.png")
testImage <- image_read("test-image.png")
diffImage <- image_compare(controlImage, testImage, metric="AE")
image_write(diffImage, "diff-image.png")
library(png)
control <- readPNG("control-image.png")
test <- readPNG("test-image.png")
diff <- readPNG("diff-image.png")
png("demo.png", width=1000, height=300, res=300)
grid.newpage()
grid.raster(control, x=0, just="left", width=unit(300, "native"))
grid.raster(test, width=unit(300, "native"))
grid.raster(diff, x=1, just="right", width=unit(300, "native"))
dev.off()

                                                  
