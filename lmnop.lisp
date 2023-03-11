(ql:quickload "vecto")

(defvar w 2550)
(defvar h 3300)
(defvar font-path "/System/Library/Fonts/Supplemental/Verdana.ttf")
(defvar stroke-weight 2)
(defvar x-offset 0)
(defvar y-offset 0)

(defun draw-horizontal-line (l)
  (vecto:move-to 0 l)
  (vecto:line-to w l)
  (vecto:fill-and-stroke))

;; vertical line
;; (vecto:move-to (/ w 2) 0)
;; (vecto:line-to (/ w 2) h)
;; (vecto:fill-and-stroke)

(defun draw-coords (p)
  (destructuring-bind (x y) p
    (vecto:set-font (vecto:get-font font-path) 12)
    (vecto:draw-centered-string (+ x 38) (+ y 10) (format nil "(~a, ~a)" x y))))

(defun draw-dot (p)
  (destructuring-bind (x y) p
    (vecto:centered-circle-path x y stroke-weight)
    (vecto:fill-and-stroke)))

(defun away-from-hor (y spacer) (mod (/ y spacer) 10))

(defun ten-degrees-right (x1 y2 spacer)
  (let ((y1 (- y2 (* spacer (away-from-hor y2 spacer)))))
    (+ x1 (/ (- y2 y1) 10))))

(defun calc-point (x y spacer lines)
    (if (member y lines) (list x y)
        (list (ten-degrees-right x y spacer) y)))

(defun draw (spacer squares-per-line)
  (let* ((lines (loop for y from 0 to h by (* spacer squares-per-line) collecting y))
         (points (loop for y from y-offset to h by spacer
                       appending (loop for x from x-offset to w by spacer
                                       collecting (calc-point x y spacer lines)))))
    (vecto:with-canvas (:width w :height h)
      ;; draw lines
      (vecto:set-rgb-stroke 0.5 0.5 0.5)
      (vecto:set-line-width stroke-weight)
      (mapc #'draw-horizontal-line lines)
      ;; draw dots
      (vecto:set-rgb-stroke 0 0 0)
      (mapc #'draw-dot points)
      ;; draw coords
      ;; (mapc draw-coords points)
      (print (length lines))
      (vecto:save-png (format nil "~a.png" (length lines))))))

(loop for i from 16 to 30
      do (draw i 10))









;; (let* ((w 2550) ;; 5100
;;        (h 3300) ;; 6600
;;        (font-path "/System/Library/Fonts/Supplemental/Verdana.ttf")
;;        (spacer 16)
;;        (stroke-weight 2)
;;        (x-offset 0)
;;        (y-offset 0)
;;        (squares-per-line 10)
;;
;;        (lines (loop for y from 0 to h by (* spacer squares-per-line) collecting y))
;;
;;        (ten-degrees-right (lambda (x1 y2)
;;          (let ((away-from-hor (lambda (y) (mod (/ y spacer) 10)))
;;                (y1 (- y2 (* spacer (funcall away-from-hor y)))))
;;            (+ x1 (/ (- y2 y1) 10)))))
;;
;;        (calc-point (lambda (p) (destructuring-bind (x y) p
;;          (if (member y lines) (list x y)
;;              (list (funcall ten-degrees-right x y) y)))))
;;
;;        (points- (loop for y from y-offset to h by spacer
;;                       appending (loop for x from x-offset to w by spacer
;;                                       collecting (list x y))))
;;        (points (mapcar calc-point points-))
;;
;;        (draw-coords (lambda (p) (destructuring-bind (x y) p
;;          (vecto:set-font (vecto:get-font font-path) 12)
;;          (vecto:draw-centered-string (+ x 38) (+ y 10)
;;                                      (format nil "(~a, ~a)" x y)))))
;;
;;        (draw-dot (lambda (p) (destructuring-bind (x y) p
;;          (vecto:centered-circle-path x y stroke-weight)
;;          (vecto:fill-and-stroke)))))
;;
;;   (vecto:with-canvas (:width w :height h)
;;     ;; draw lines
;;     ;; (vecto:set-dash-pattern #(10) 5)
;;     (vecto:set-rgb-stroke 0.5 0.5 0.5)
;;     (vecto:set-line-width stroke-weight)
;;     (mapc draw-horizontal-line lines)
;;
;;     ;; vertical line
;;     ;; (vecto:move-to (/ w 2) 0)
;;     ;; (vecto:line-to (/ w 2) h)
;;     ;; (vecto:fill-and-stroke)
;;
;;     ; draw dots
;;     (vecto:set-rgb-stroke 0 0 0)
;;     (mapc draw-dot points)
;;
;;     ;; draw coords
;;     ;; (mapc draw-coords points)
;;
;;     (print (length lines))
;;
;;     (vecto:save-png (format nil "~a.png" (length lines)))))
