(ns my-proj-clj.core
  (:require [clojure2d.core :as c2d]
            [fastmath.core :as m]))

(def h (/ 2550 4))
(def w (/ 3300 4))
(def stroke-weight 4)
(def x-offset 0)
(def y-offset 0)

(def my-canvas (c2d/canvas h w))

(def window (c2d/show-window my-canvas "Hello World!"))

(defn horizontal-line [c y] (c2d/line c 0 y w y))

(defn dot [c [x y]] (c2d/ellipse c x y stroke-weight stroke-weight))

(defn away-from-hor [y] (mod (/ y spacer) 10))

;; The ranges are a little off-by-one-y on this, but I can't be bothered:
(defn -main [spacer squares-per-line]
  (let [lines (range 0 (+ h spacer) (* squares-per-line spacer))

        away-from-hor (fn [y] (mod (quot y spacer) 10))

        ten-degrees-right
        (fn [x1 y2] (let [y1 (- y2 (* spacer (away-from-hor y2)))]
                      (- x1 (quot (- y2 y1) 10))))

        calc-point
        (fn ([x y] (if (some #(= % y) lines) [x y]
                      [(ten-degrees-right x y), y])))

        points (for [y (range 0 (+ spacer h) spacer)
                     x (range 0 (+ spacer w) spacer)]
                 (calc-point x y))]

    (c2d/with-canvas [c my-canvas]
      (c2d/set-background c 255 255 255)
      (c2d/set-color c 0 0 0)
      (doseq [l lines] (horizontal-line c l))
      (doseq [p points] (dot c p)))
    (c2d/save my-canvas "helloworld.jpg")))

(-main 16 10)
