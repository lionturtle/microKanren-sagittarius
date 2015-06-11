(define (merge-domains d1 d2)
  (intersection (lambda (i) i) d1 d2))

(define (domain-store-update-associations k p)
  ;; sets the domain to #f if memberchk fails
  (modified-domains
   (lambda (dom)
     (let loop ((dom dom) (p p))
       (if (null? p)
	   dom
	   (let ((u (caar p)) (v (cdar p)))
	     (let-values (((dom found? found) (trie-lookup/delete dom (var->int u))))
	       (if (and (var? u) (var? v))
		   (if found?
		       (loop (trie-insert/merge dom (var->int v) found merge-domains) (cdr p))
		       (loop dom (cdr p)))
		   ;; this is the case where the var was
		   ;; unified with a ground value
		   (if found?
		       (if (member v found)
			   (loop dom (cdr p))
			   #f))))))))
   k))
;; TODO: This depends on the CDRs of the prefix being fully walked. Does that hold?

(define (normalize-domain-store dom)
  dom)
