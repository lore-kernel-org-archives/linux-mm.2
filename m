Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B76C9EC99
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:17:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EADC26B00A7; Mon, 12 Jan 2026 10:17:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E73776B00A8; Mon, 12 Jan 2026 10:17:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D222C6B00A9; Mon, 12 Jan 2026 10:17:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B7C536B00A7
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:17:26 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60BE68BC19
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:26 +0000 (UTC)
X-FDA: 84323665692.28.850635A
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2F5DC180006
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:17:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768231044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=3D6Q2UMRMppGYaGqHyGHa2Wmv5A/RsbrdBLVyVB9TuE=;
	b=4EfXr+byrIf9qDeaiEd3jz69gliTgMT42nfVCpesHrD6bdoE+UN1be8LgXwmvo/rpsxziI
	NLPhjOYcAMpiSeI4VtAdHSj9xr5fH1SShr8e35AErBhJOqKla8c6YqkZFKzaK+kFebFRAL
	VScYN3F/rQfF1k7AZPL2kJOde2DiI68=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	spf=pass (imf16.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768231044; a=rsa-sha256;
	cv=none;
	b=suZJazdG4AfCrbSfgGGxXXmfaeXs4ygQwVCX58EsJtMuxUMoT2PvMzenCxRFP/Q8XFndZm
	5uflznisaeEucCOjKLdrhRuf3/ZDtHdseo+BpBV9RwNFBQFrQZuPxwTsk0d8CQsj6pbXXj
	SImQHt/fVdYMJGnIUi6vkX2aIs8aoqY=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 509AB33690;
	Mon, 12 Jan 2026 15:16:58 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 34D493EA65;
	Mon, 12 Jan 2026 15:16:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id CBKTDGoQZWn7FgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Mon, 12 Jan 2026 15:16:58 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Mon, 12 Jan 2026 16:17:02 +0100
Subject: [PATCH RFC v2 08/20] slab: add optimized sheaf refill from partial
 list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260112-sheaves-for-all-v2-8-98225cfb50cf@suse.cz>
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
In-Reply-To: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
To: Harry Yoo <harry.yoo@oracle.com>, Petr Tesarik <ptesarik@suse.com>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Alexei Starovoitov <ast@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev, 
 bpf@vger.kernel.org, kasan-dev@googlegroups.com, 
 Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 2F5DC180006
X-Stat-Signature: e5tpu7xoyqqke6393nixdmy7ha7sznfu
X-HE-Tag: 1768231043-967512
X-HE-Meta: U2FsdGVkX1+BtiwzIxhDdswZazb3tTON0WsCzE1iqcse70ofiEcxNBcPWZRUWI0zklCT9/iXkuYW8fg2cvpYe2O6MvIb/OyrBCP1AhZzzGQAIpn1/AQfU24lSmfVOHQLk4kUlOzIpubuuxTPoowiZIWXvRdFJkYvR4jH1DxHOJ5ISRGbLNNgDT5UvQWkXmeuL4HI3qVje0DSC8XHz2EPDMtxEZ/z+9XbFelccVilto84rcy5EYuwDzRL1RH9dlcEZ1uBjsmIFfCSb7OUsV5yX0dbTimXcnHuNfqpjIw0VaMfPs0j2YpSPOLxoEifMf1HA/Dg0JWjOkXQZK3wfsBaOyNpk9A3bjadSTXXKmCfl1BfIOGBlmxqdUCRxaO4Dr08BvO2/fTIfhls5bV3yM+SEsWqvsqBZq3/k4F+oCbfAxzGanlMKJ9Rd4kjYZ/xO3btWwpCBoxJQmdAax4UkgmfMdA8/5Qrk5s3RzCttGd8Dz87IqWVdAmaiJqrGcvVTrj5lyYfQakrwEv0KRjCtY1ysbaJRZVqqFotCkXMHqS4h5EsvpU4sgvDLO9lYlak6QGyDpOtn/YR7zLPUvdDcGiwg2B2quHZSHhCFVsuOKAf8hBAhG9/xzPghcvlOyEilnThCRaWZ+Tkv3GLDDIPmeToRYDtNmD8sR04AUldHraI56ozUZqxRpAZSDtf2s0pgRRyjmlWx44eq4AtgP4PIuSx6atYgX/ljZ+ieBe8F6RWN3KcIQBsJiO9SpcuVKX282NQgjuwf3tl+1Bfeic+3yGW/CGdHJZehpuB5l54KWNXLqcHeyiOOvtllRWreoSTO8CEjZSltb3EIXGlTC0ORD0dQ0BlVf6IEt8ruknU/sI7VMHtp+o7VmAoL8t4lqmICHXlRi7JEUPkNkFGg8qUi3Vgk6AA3hQqN1T2/apnEoDtg1aF6sH1n/bjUO41rEH47303zjwZE5Dz+YGpKHoYkfD
 KGIVjH6H
 QROLr+eTMrjqbu9dTDjRzww9arf10vlVNevEuzgYhahScYw2OZqoS/X+OTtFuhygmq9rEFkOh9Ur6kPeL0sXGET2PrA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

At this point we have sheaves enabled for all caches, but their refill
is done via __kmem_cache_alloc_bulk() which relies on cpu (partial)
slabs - now a redundant caching layer that we are about to remove.

The refill will thus be done from slabs on the node partial list.
Introduce new functions that can do that in an optimized way as it's
easier than modifying the __kmem_cache_alloc_bulk() call chain.

Extend struct partial_context so it can return a list of slabs from the
partial list with the sum of free objects in them within the requested
min and max.

Introduce get_partial_node_bulk() that removes the slabs from freelist
and returns them in the list.

Introduce get_freelist_nofreeze() which grabs the freelist without
freezing the slab.

Introduce alloc_from_new_slab() which can allocate multiple objects from
a newly allocated slab where we don't need to synchronize with freeing.
In some aspects it's similar to alloc_single_from_new_slab() but assumes
the cache is a non-debug one so it can avoid some actions.

Introduce __refill_objects() that uses the functions above to fill an
array of objects. It has to handle the possibility that the slabs will
contain more objects that were requested, due to concurrent freeing of
objects to those slabs. When no more slabs on partial lists are
available, it will allocate new slabs. It is intended to be only used
in context where spinning is allowed, so add a WARN_ON_ONCE check there.

Finally, switch refill_sheaf() to use __refill_objects(). Sheaves are
only refilled from contexts that allow spinning, or even blocking.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 284 +++++++++++++++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 264 insertions(+), 20 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index f2de44f8bda4..b568801edec2 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -246,6 +246,9 @@ struct partial_context {
 	gfp_t flags;
 	unsigned int orig_size;
 	void *object;
+	unsigned int min_objects;
+	unsigned int max_objects;
+	struct list_head slabs;
 };
 
 static inline bool kmem_cache_debug(struct kmem_cache *s)
@@ -2638,9 +2641,9 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
 	stat(s, SHEAF_FREE);
 }
 
-static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
-				   size_t size, void **p);
-
+static unsigned int
+__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
+		 unsigned int max);
 
 static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 			 gfp_t gfp)
@@ -2651,8 +2654,8 @@ static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 	if (!to_fill)
 		return 0;
 
-	filled = __kmem_cache_alloc_bulk(s, gfp, to_fill,
-					 &sheaf->objects[sheaf->size]);
+	filled = __refill_objects(s, &sheaf->objects[sheaf->size], gfp,
+			to_fill, to_fill);
 
 	sheaf->size += filled;
 
@@ -3510,6 +3513,63 @@ static inline void put_cpu_partial(struct kmem_cache *s, struct slab *slab,
 #endif
 static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags);
 
+static bool get_partial_node_bulk(struct kmem_cache *s,
+				  struct kmem_cache_node *n,
+				  struct partial_context *pc)
+{
+	struct slab *slab, *slab2;
+	unsigned int total_free = 0;
+	unsigned long flags;
+
+	/* Racy check to avoid taking the lock unnecessarily. */
+	if (!n || data_race(!n->nr_partial))
+		return false;
+
+	INIT_LIST_HEAD(&pc->slabs);
+
+	spin_lock_irqsave(&n->list_lock, flags);
+
+	list_for_each_entry_safe(slab, slab2, &n->partial, slab_list) {
+		struct freelist_counters flc;
+		unsigned int slab_free;
+
+		if (!pfmemalloc_match(slab, pc->flags))
+			continue;
+
+		/*
+		 * determine the number of free objects in the slab racily
+		 *
+		 * due to atomic updates done by a racing free we should not
+		 * read an inconsistent value here, but do a sanity check anyway
+		 *
+		 * slab_free is a lower bound due to subsequent concurrent
+		 * freeing, the caller might get more objects than requested and
+		 * must deal with it
+		 */
+		flc.counters = data_race(READ_ONCE(slab->counters));
+		slab_free = flc.objects - flc.inuse;
+
+		if (unlikely(slab_free > oo_objects(s->oo)))
+			continue;
+
+		/* we have already min and this would get us over the max */
+		if (total_free >= pc->min_objects
+		    && total_free + slab_free > pc->max_objects)
+			break;
+
+		remove_partial(n, slab);
+
+		list_add(&slab->slab_list, &pc->slabs);
+
+		total_free += slab_free;
+		if (total_free >= pc->max_objects)
+			break;
+	}
+
+	spin_unlock_irqrestore(&n->list_lock, flags);
+	return total_free > 0;
+}
+
 /*
  * Try to allocate a partial slab from a specific node.
  */
@@ -4436,6 +4496,33 @@ static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
 	return old.freelist;
 }
 
+/*
+ * Get the slab's freelist and do not freeze it.
+ *
+ * Assumes the slab is isolated from node partial list and not frozen.
+ *
+ * Assumes this is performed only for caches without debugging so we
+ * don't need to worry about adding the slab to the full list
+ */
+static inline void *get_freelist_nofreeze(struct kmem_cache *s, struct slab *slab)
+{
+	struct freelist_counters old, new;
+
+	do {
+		old.freelist = slab->freelist;
+		old.counters = slab->counters;
+
+		new.freelist = NULL;
+		new.counters = old.counters;
+		VM_BUG_ON(new.frozen);
+
+		new.inuse = old.objects;
+
+	} while (!slab_update_freelist(s, slab, &old, &new, "get_freelist_nofreeze"));
+
+	return old.freelist;
+}
+
 /*
  * Freeze the partial slab and return the pointer to the freelist.
  */
@@ -4459,6 +4546,64 @@ static inline void *freeze_slab(struct kmem_cache *s, struct slab *slab)
 	return old.freelist;
 }
 
+/*
+ * If the object has been wiped upon free, make sure it's fully initialized by
+ * zeroing out freelist pointer.
+ *
+ * Note that we also wipe custom freelist pointers.
+ */
+static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
+						   void *obj)
+{
+	if (unlikely(slab_want_init_on_free(s)) && obj &&
+	    !freeptr_outside_object(s))
+		memset((void *)((char *)kasan_reset_tag(obj) + s->offset),
+			0, sizeof(void *));
+}
+
+static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
+		void **p, unsigned int count, bool allow_spin)
+{
+	unsigned int allocated = 0;
+	struct kmem_cache_node *n;
+	unsigned long flags;
+	void *object;
+
+	if (!allow_spin && (slab->objects - slab->inuse) > count) {
+
+		n = get_node(s, slab_nid(slab));
+
+		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
+			/* Unlucky, discard newly allocated slab */
+			defer_deactivate_slab(slab, NULL);
+			return 0;
+		}
+	}
+
+	object = slab->freelist;
+	while (object && allocated < count) {
+		p[allocated] = object;
+		object = get_freepointer(s, object);
+		maybe_wipe_obj_freeptr(s, p[allocated]);
+
+		slab->inuse++;
+		allocated++;
+	}
+	slab->freelist = object;
+
+	if (slab->freelist) {
+
+		if (allow_spin) {
+			n = get_node(s, slab_nid(slab));
+			spin_lock_irqsave(&n->list_lock, flags);
+		}
+		add_partial(n, slab, DEACTIVATE_TO_HEAD);
+		spin_unlock_irqrestore(&n->list_lock, flags);
+	}
+
+	return allocated;
+}
+
 /*
  * Slow path. The lockless freelist is empty or we need to perform
  * debugging duties.
@@ -4901,21 +5046,6 @@ static __always_inline void *__slab_alloc_node(struct kmem_cache *s,
 	return object;
 }
 
-/*
- * If the object has been wiped upon free, make sure it's fully initialized by
- * zeroing out freelist pointer.
- *
- * Note that we also wipe custom freelist pointers.
- */
-static __always_inline void maybe_wipe_obj_freeptr(struct kmem_cache *s,
-						   void *obj)
-{
-	if (unlikely(slab_want_init_on_free(s)) && obj &&
-	    !freeptr_outside_object(s))
-		memset((void *)((char *)kasan_reset_tag(obj) + s->offset),
-			0, sizeof(void *));
-}
-
 static __fastpath_inline
 struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
 {
@@ -5376,6 +5506,9 @@ static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
 	return ret;
 }
 
+static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
+				   size_t size, void **p);
+
 /*
  * returns a sheaf that has at least the requested size
  * when prefilling is needed, do so with given gfp flags
@@ -7461,6 +7594,117 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 }
 EXPORT_SYMBOL(kmem_cache_free_bulk);
 
+static unsigned int
+__refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,
+		 unsigned int max)
+{
+	struct slab *slab, *slab2;
+	struct partial_context pc;
+	unsigned int refilled = 0;
+	unsigned long flags;
+	void *object;
+	int node;
+
+	pc.flags = gfp;
+	pc.min_objects = min;
+	pc.max_objects = max;
+
+	node = numa_mem_id();
+
+	if (WARN_ON_ONCE(!gfpflags_allow_spinning(gfp)))
+		return 0;
+
+	/* TODO: consider also other nodes? */
+	if (!get_partial_node_bulk(s, get_node(s, node), &pc))
+		goto new_slab;
+
+	list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
+
+		list_del(&slab->slab_list);
+
+		object = get_freelist_nofreeze(s, slab);
+
+		while (object && refilled < max) {
+			p[refilled] = object;
+			object = get_freepointer(s, object);
+			maybe_wipe_obj_freeptr(s, p[refilled]);
+
+			refilled++;
+		}
+
+		/*
+		 * Freelist had more objects than we can accomodate, we need to
+		 * free them back. We can treat it like a detached freelist, just
+		 * need to find the tail object.
+		 */
+		if (unlikely(object)) {
+			void *head = object;
+			void *tail;
+			int cnt = 0;
+
+			do {
+				tail = object;
+				cnt++;
+				object = get_freepointer(s, object);
+			} while (object);
+			do_slab_free(s, slab, head, tail, cnt, _RET_IP_);
+		}
+
+		if (refilled >= max)
+			break;
+	}
+
+	if (unlikely(!list_empty(&pc.slabs))) {
+		struct kmem_cache_node *n = get_node(s, node);
+
+		spin_lock_irqsave(&n->list_lock, flags);
+
+		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
+
+			if (unlikely(!slab->inuse && n->nr_partial >= s->min_partial))
+				continue;
+
+			list_del(&slab->slab_list);
+			add_partial(n, slab, DEACTIVATE_TO_HEAD);
+		}
+
+		spin_unlock_irqrestore(&n->list_lock, flags);
+
+		/* any slabs left are completely free and for discard */
+		list_for_each_entry_safe(slab, slab2, &pc.slabs, slab_list) {
+
+			list_del(&slab->slab_list);
+			discard_slab(s, slab);
+		}
+	}
+
+
+	if (likely(refilled >= min))
+		goto out;
+
+new_slab:
+
+	slab = new_slab(s, pc.flags, node);
+	if (!slab)
+		goto out;
+
+	stat(s, ALLOC_SLAB);
+	inc_slabs_node(s, slab_nid(slab), slab->objects);
+
+	/*
+	 * TODO: possible optimization - if we know we will consume the whole
+	 * slab we might skip creating the freelist?
+	 */
+	refilled += alloc_from_new_slab(s, slab, p + refilled, max - refilled,
+					/* allow_spin = */ true);
+
+	if (refilled < min)
+		goto new_slab;
+out:
+
+	return refilled;
+}
+
 static inline
 int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 			    void **p)

-- 
2.52.0


