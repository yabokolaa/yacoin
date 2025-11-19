;; yacoin.clar
;; A simple fungible token-style contract for the Yacoin project.

(define-constant token-name "Yacoin")
(define-constant token-symbol "YAC")
(define-constant token-decimals u6)

(define-constant ERR-UNAUTHORIZED (err u100))
(define-constant ERR-INSUFFICIENT-BALANCE (err u101))

;; Total supply of all minted tokens
(define-data-var total-supply uint u0)

;; Ledger of account balances
(define-map balances
  { owner: principal }
  { balance: uint })

;; ---- Read-only helpers ----

(define-read-only (get-name)
  (ok token-name))

(define-read-only (get-symbol)
  (ok token-symbol))

(define-read-only (get-decimals)
  (ok token-decimals))

(define-read-only (get-total-supply)
  (ok (var-get total-supply)))

(define-read-only (get-balance-of (who principal))
  (match (map-get? balances { owner: who })
    entry (ok (get balance entry))
    (ok u0)))

;; Internal helper returning (response uint uint)
(define-read-only (get-balance (who principal))
  (get-balance-of who))

;; ---- Public entrypoints ----

;; Transfer tokens from `sender` to `recipient`.
;; The tx-sender must match `sender`.
(define-public (transfer (amount uint) (sender principal) (recipient principal))
  (begin
    (if (not (is-eq sender tx-sender))
        ERR-UNAUTHORIZED
        (let (
              (sender-balance (unwrap-panic (get-balance sender)))
              (recipient-balance (unwrap-panic (get-balance recipient)))
             )
          (if (< sender-balance amount)
              ERR-INSUFFICIENT-BALANCE
              (begin
                (map-set balances { owner: sender } { balance: (- sender-balance amount) })
                (map-set balances { owner: recipient } { balance: (+ recipient-balance amount) })
                (ok true)))))))

;; Mint new tokens to `recipient`.
;; NOTE: This example allows anyone to mint; in a real deployment you would
;; restrict this to a fixed admin principal or the contract itself.
(define-public (mint (amount uint) (recipient principal))
  (begin
    (var-set total-supply (+ (var-get total-supply) amount))
    (let ((current-balance (unwrap-panic (get-balance recipient))))
      (map-set balances { owner: recipient } { balance: (+ current-balance amount) })
      (ok true))))
