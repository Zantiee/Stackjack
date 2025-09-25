;; Stackjack - Enhanced Lottery Contract

;; Data storage
(define-map tickets uint principal)
(define-data-var ticket-count uint u0)
(define-data-var ticket-price uint u1000000) ;; 1 STX in microSTX
(define-data-var prize-pool uint u0)
(define-data-var lottery-active bool true)
(define-data-var contract-owner principal tx-sender)
(define-data-var min-tickets-for-draw uint u2)

;; Error constants
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-LOTTERY-INACTIVE (err u101))
(define-constant ERR-INSUFFICIENT-TICKETS (err u102))
(define-constant ERR-NO-WINNER-FOUND (err u103))
(define-constant ERR-TRANSFER-FAILED (err u104))
(define-constant ERR-LOTTERY-ALREADY-ACTIVE (err u105))
(define-constant ERR-INVALID-BLOCK-INFO (err u106))
(define-constant ERR-ZERO-TICKETS (err u107))

;; Private functions
(define-private (is-owner)
  (is-eq tx-sender (var-get contract-owner)))

;; Generate pseudo-random number using block-height and stacks-block-height
(define-private (generate-random-number (max-value uint))
  (let ((random-seed (+ stacks-block-height stacks-block-height (var-get ticket-count))))
    (mod random-seed max-value)))

;; Public functions
(define-public (buy-ticket)
  (begin
    ;; Check if lottery is active
    (asserts! (var-get lottery-active) ERR-LOTTERY-INACTIVE)
    
    ;; Transfer STX from buyer to contract
    (try! (stx-transfer? (var-get ticket-price) tx-sender (as-contract tx-sender)))
    
    ;; Add to prize pool
    (var-set prize-pool (+ (var-get prize-pool) (var-get ticket-price)))
    
    ;; Increment ticket count and assign ticket
    (var-set ticket-count (+ (var-get ticket-count) u1))
    (map-set tickets (var-get ticket-count) tx-sender)
    
    (ok "Ticket purchased")))

(define-public (draw)
  (begin
    ;; Access control - only owner can draw
    (asserts! (is-owner) ERR-NOT-AUTHORIZED)
    
    ;; Security checks
    (asserts! (var-get lottery-active) ERR-LOTTERY-INACTIVE)
    (asserts! (> (var-get ticket-count) u0) ERR-ZERO-TICKETS)
    (asserts! (>= (var-get ticket-count) (var-get min-tickets-for-draw)) ERR-INSUFFICIENT-TICKETS)
    
    ;; Generate random winner ticket number (1 to ticket-count)
    (let ((winner-ticket (+ (generate-random-number (var-get ticket-count)) u1)))
      
      ;; Get winner address
      (let ((winner-address (unwrap! (map-get? tickets winner-ticket) ERR-NO-WINNER-FOUND)))
        
        ;; Calculate prize (90% of pool, 10% house edge)
        (let ((prize-amount (/ (* (var-get prize-pool) u90) u100)))
          
          ;; Transfer prize to winner
          (try! (as-contract (stx-transfer? prize-amount tx-sender winner-address)))
          
          ;; End current lottery
          (var-set lottery-active false)
          
          (ok winner-address))))))

;; Admin functions (owner only)
(define-public (start-new-round)
  (begin
    (asserts! (is-owner) ERR-NOT-AUTHORIZED)
    (asserts! (not (var-get lottery-active)) ERR-LOTTERY-ALREADY-ACTIVE)
    
    ;; Reset lottery state
    (var-set lottery-active true)
    (var-set ticket-count u0)
    (var-set prize-pool u0)
    
    (ok "New lottery round started")))

(define-public (set-ticket-price (new-price uint))
  (begin
    (asserts! (is-owner) ERR-NOT-AUTHORIZED)
    (asserts! (not (var-get lottery-active)) ERR-LOTTERY-ALREADY-ACTIVE) ;; Can only change when inactive
    (var-set ticket-price new-price)
    (ok "Ticket price updated")))

(define-public (set-min-tickets (new-min uint))
  (begin
    (asserts! (is-owner) ERR-NOT-AUTHORIZED)
    (var-set min-tickets-for-draw new-min)
    (ok "Minimum tickets updated")))

(define-public (transfer-ownership (new-owner principal))
  (begin
    (asserts! (is-owner) ERR-NOT-AUTHORIZED)
    (var-set contract-owner new-owner)
    (ok "Ownership transferred")))

(define-public (emergency-stop)
  (begin
    (asserts! (is-owner) ERR-NOT-AUTHORIZED)
    (var-set lottery-active false)
    (ok "Lottery stopped")))

;; Read-only functions
(define-read-only (get-lottery-info)
  {
    ticket-count: (var-get ticket-count),
    ticket-price: (var-get ticket-price),
    prize-pool: (var-get prize-pool),
    lottery-active: (var-get lottery-active),
    min-tickets: (var-get min-tickets-for-draw),
    owner: (var-get contract-owner)
  })

(define-read-only (get-ticket-owner (ticket-id uint))
  (map-get? tickets ticket-id))

(define-read-only (get-current-prize-pool)
  (var-get prize-pool))

(define-read-only (get-ticket-price)
  (var-get ticket-price))

(define-read-only (is-lottery-active)
  (var-get lottery-active))

(define-read-only (get-owner)
  (var-get contract-owner))