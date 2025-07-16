;; quality-monitor-verification.clar

;; This contract allows a designated quality monitor to update the quality score
;; of a given contract.  It ensures that only the monitor can make these updates
;; and that the provided inputs are valid.

(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-INVALID-INPUT (err u101))
(define-constant ERR-CONTRACT-ALREADY-INITIALIZED (err u102))

(define-data-var quality-monitor principal CONTRACT-OWNER)
(define-data-var contract-quality-score (optional uint) none)

;; Public functions

;; Allows the contract owner to set the quality monitor.
(define-public (set-quality-monitor (monitor principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (ok (var-set quality-monitor monitor))))

;; Allows the quality monitor to update the quality score.
(define-public (update-quality-score (score uint) (successful-checks uint) (total-checks uint))
  (begin
    (asserts! (is-eq tx-sender (var-get quality-monitor)) ERR-NOT-AUTHORIZED)
    (asserts! (<= successful-checks total-checks) ERR-INVALID-INPUT)
    (ok (var-set contract-quality-score (some score)))))

;; Read-only functions

;; Returns the current quality monitor.
(define-read-only (get-quality-monitor)
  (ok (var-get quality-monitor)))

;; Returns the current quality score.
(define-read-only (get-quality-score)
  (ok (var-get contract-quality-score)))
