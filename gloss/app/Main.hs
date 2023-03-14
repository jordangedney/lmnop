module Main where

import Graphics.Gloss
import Graphics.Gloss.Export

w = 2550
h = 3300 -- h = 3300

strokeWeight = 2
xOffset = 0
yOffset = 0

tX x = (x - ((read . show $ w) / 2))
tY y = (y - ((read . show $ h) / 2))
translateXY x y = translate (tX x) (tY y)

drawHorizontalLine y =
  translateXY 0 (read . show $ y)
  $ rectangleSolid (read . show $ w * 2) strokeWeight

drawDot :: (Int, Int) -> Picture
drawDot (x, y) =
  translateXY (read . show $ x) (read . show $ y)
  $ circleSolid strokeWeight

draw spacer squaresPerLine =
  let lines = [0, spacer * squaresPerLine..h]
      awayFromHor y = mod (y `div` spacer) 10

      tenDegreesRight x1 y2 =
        let y1 = y2 - (spacer * (awayFromHor y2))
        in x1 + ((y2 - y1) `div` 10)

      calcPoint x y =
        if y `elem` lines then (x, y)
        else (tenDegreesRight x y, y)

      points = [calcPoint x y | y <- [0,spacer..h],
                                x <- [0,spacer..w]]

  in pictures $ concat [map drawHorizontalLine lines, map drawDot points]

main = do
  exportPictureToPNG (w, h) white "test.png" (draw 16 10)
  -- display window white (draw 16 10)
  -- where window = InWindow "Nice Window" (w, h) (20, 60)
