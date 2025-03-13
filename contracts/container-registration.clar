;; Container Registration Contract
;; Records details of shipping containers

;; Data variables
(define-data-var container-counter uint u0)
(define-data-var container-type-counter uint u0)
(define-data-var owner-counter uint u0)

;; Data maps
(define-map containers
{ id: uint }
{
  container-number: (string-ascii 11),
  container-type-id: uint,
  owner-id: uint,
  manufactured-date: uint,
  last-inspection-date: uint,
  capacity-weight: uint,
  capacity-volume: uint,
  status: (string-ascii 16),
  active: bool
}
)

(define-map container-types
{ id: uint }
{
  name: (string-ascii 32),
  size: (string-ascii 16),
  type: (string-ascii 16),
  description: (string-ascii 128),
  active: bool
}
)

(define-map container-owners
{ id: uint }
{
  name: (string-ascii 64),
  address: principal,
  registration-number: (string-ascii 32),
  contact-info: (string-ascii 128),
  active: bool
}
)

(define-map container-contents
{ container-id: uint }
{
  description: (string-ascii 128),
  hazardous: bool,
  weight: uint,
  value: uint,
  origin-country: (string-ascii 32),
  destination-country: (string-ascii 32),
  shipping-date: uint
}
)

(define-map registrars
{ address: principal }
{ active: bool }
)

;; Initialize contract
(define-public (initialize)
(begin
  (map-set registrars { address: tx-sender } { active: true })
  (ok true)
)
)

;; Check if address is registrar
(define-read-only (is-registrar (address principal))
(default-to false (get active (map-get? registrars { address: address })))
)

;; Add a registrar
(define-public (add-registrar (address principal))
(begin
  ;; Only registrars can add registrars
  (asserts! (is-registrar tx-sender) (err u403))

  (map-set registrars
    { address: address }
    { active: true }
  )

  (ok true)
)
)

;; Register a container type
(define-public (register-container-type
  (name (string-ascii 32))
  (size (string-ascii 16))
  (type (string-ascii 16))
  (description (string-ascii 128)))
(let ((new-id (+ (var-get container-type-counter) u1)))
  ;; Only registrars can register container types
  (asserts! (is-registrar tx-sender) (err u403))

  ;; Update counter
  (var-set container-type-counter new-id)

  ;; Store container type data
  (map-set container-types
    { id: new-id }
    {
      name: name,
      size: size,
      type: type,
      description: description,
      active: true
    }
  )

  (ok new-id)
)
)

;; Register a container owner
(define-public (register-owner
  (name (string-ascii 64))
  (registration-number (string-ascii 32))
  (contact-info (string-ascii 128)))
(let ((new-id (+ (var-get owner-counter) u1)))
  ;; Only registrars can register owners
  (asserts! (is-registrar tx-sender) (err u403))

  ;; Update counter
  (var-set owner-counter new-id)

  ;; Store owner data
  (map-set container-owners
    { id: new-id }
    {
      name: name,
      address: tx-sender,
      registration-number: registration-number,
      contact-info: contact-info,
      active: true
    }
  )

  (ok new-id)
)
)

;; Register a container
(define-public (register-container
  (container-number (string-ascii 11))
  (container-type-id uint)
  (owner-id uint)
  (manufactured-date uint)
  (capacity-weight uint)
  (capacity-volume uint))
(let ((new-id (+ (var-get container-counter) u1)))
  ;; Only registrars can register containers
  (asserts! (is-registrar tx-sender) (err u403))

  ;; Container type and owner must exist
  (asserts! (and
              (is-some (map-get? container-types { id: container-type-id }))
              (is-some (map-get? container-owners { id: owner-id })))
            (err u404))

  ;; Container type and owner must be active
  (asserts! (and
              (get active (unwrap-panic (map-get? container-types { id: container-type-id })))
              (get active (unwrap-panic (map-get? container-owners { id: owner-id }))))
            (err u400))

  ;; Update counter
  (var-set container-counter new-id)

  ;; Store container data
  (map-set containers
    { id: new-id }
    {
      container-number: container-number,
      container-type-id: container-type-id,
      owner-id: owner-id,
      manufactured-date: manufactured-date,
      last-inspection-date: block-height,
      capacity-weight: capacity-weight,
      capacity-volume: capacity-volume,
      status: "available",
      active: true
    }
  )

  (ok new-id)
)
)

;; Update container status
(define-public (update-container-status (container-id uint) (status (string-ascii 16)))
(let ((container (map-get? containers { id: container-id })))
  ;; Only registrars can update container status
  (asserts! (is-registrar tx-sender) (err u403))

  ;; Container must exist
  (asserts! (is-some container) (err u404))

  ;; Status must be valid
  (asserts! (or
              (is-eq status "available")
              (is-eq status "in-transit")
              (is-eq status "loading")
              (is-eq status "unloading")
              (is-eq status "maintenance")
              (is-eq status "out-of-service"))
            (err u400))

  ;; Store updated container
  (map-set containers
    { id: container-id }
    (merge (unwrap-panic container) { status: status })
  )

  (ok true)
)
)

;; Transfer container ownership
(define-public (transfer-ownership (container-id uint) (new-owner-id uint))
(let ((container (map-get? containers { id: container-id })))
  ;; Only registrars can transfer ownership
  (asserts! (is-registrar tx-sender) (err u403))

  ;; Container must exist
  (asserts! (is-some container) (err u404))

  ;; New owner must exist and be active
  (asserts! (and
              (is-some (map-get? container-owners { id: new-owner-id }))
              (get active (unwrap-panic (map-get? container-owners { id: new-owner-id }))))
            (err u404))

  ;; Store updated container
  (map-set containers
    { id: container-id }
    (merge (unwrap-panic container) { owner-id: new-owner-id })
  )

  (ok true)
)
)

;; Record container contents
(define-public (record-contents
  (container-id uint)
  (description (string-ascii 128))
  (hazardous bool)
  (weight uint)
  (value uint)
  (origin-country (string-ascii 32))
  (destination-country (string-ascii 32)))
(let ((container (map-get? containers { id: container-id })))
  ;; Only registrars can record contents
  (asserts! (is-registrar tx-sender) (err u403))

  ;; Container must exist
  (asserts! (is-some container) (err u404))

  ;; Weight must not exceed capacity
  (asserts! (<= weight (get capacity-weight (unwrap-panic container))) (err u400))

  ;; Store contents data
  (map-set container-contents
    { container-id: container-id }
    {
      description: description,
      hazardous: hazardous,
      weight: weight,
      value: value,
      origin-country: origin-country,
      destination-country: destination-country,
      shipping-date: block-height
    }
  )

  (ok true)
)
)

;; Update container inspection date
(define-public (update-inspection-date (container-id uint))
(let ((container (map-get? containers { id: container-id })))
  ;; Only registrars can update inspection date
  (asserts! (is-registrar tx-sender) (err u403))

  ;; Container must exist
  (asserts! (is-some container) (err u404))

  ;; Store updated container
  (map-set containers
    { id: container-id }
    (merge (unwrap-panic container) { last-inspection-date: block-height })
  )

  (ok true)
)
)

;; Get container details
(define-read-only (get-container (container-id uint))
(map-get? containers { id: container-id })
)

;; Get container type details
(define-read-only (get-container-type (container-type-id uint))
(map-get? container-types { id: container-type-id })
)

;; Get owner details
(define-read-only (get-owner (owner-id uint))
(map-get? container-owners { id: owner-id })
)

;; Get container contents
(define-read-only (get-contents (container-id uint))
(map-get? container-contents { container-id: container-id })
)

;; Check if container is active
(define-read-only (is-container-active (container-id uint))
(let ((container (map-get? containers { id: container-id })))
  (and
    (is-some container)
    (get active (unwrap-panic container))
  )
)
)

;; Check if container is available
(define-read-only (is-container-available (container-id uint))
(let ((container (map-get? containers { id: container-id })))
  (and
    (is-some container)
    (get active (unwrap-panic container))
    (is-eq (get status (unwrap-panic container)) "available")
  )
)
)
