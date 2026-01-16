Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B8BAC982C4
	for <linux-mm@archiver.kernel.org>; Fri, 16 Jan 2026 14:41:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B9E16B009B; Fri, 16 Jan 2026 09:41:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37AD96B009D; Fri, 16 Jan 2026 09:41:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 232706B009E; Fri, 16 Jan 2026 09:41:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 06D8D6B009B
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 09:41:11 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7AB7156364
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:10 +0000 (UTC)
X-FDA: 84338089500.23.D3C6204
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf21.hostedemail.com (Postfix) with ESMTP id 378BC1C000D
	for <linux-mm@kvack.org>; Fri, 16 Jan 2026 14:41:07 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PE4BP1iG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="fXJtY/n4";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PE4BP1iG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="fXJtY/n4";
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768574468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q+c2vtfBgSpXigJtY75bYtfi3Y2UxCcBVZpVZiGZCPE=;
	b=UldODnADj3wY41L1GIFShDV++mS3v9ndf8eHDpPSDnlhnR2q+MUwgGjoERp35VPi5E0EPc
	qIiUO5kv+zCCWklUNV93v/BYufNGZFuXJbgf1otckwEdIzUu5RIz7QDt5eRyYbqoLpYC48
	huo8jznTl7FJq+i5VxKBzhEcL9wrJNY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PE4BP1iG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="fXJtY/n4";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=PE4BP1iG;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="fXJtY/n4";
	spf=pass (imf21.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768574468; a=rsa-sha256;
	cv=none;
	b=A0R8i0HCGT8uXck8CZgM/rgVj4OeaHhGEWW1xMHV/2HtiZC1E1Bgs7FbB1KuGAOkM4/p8l
	a3TGi8PNADTuFzMV4/rfDiEIXq0U0No6bysSk2m99SA5riyDo1R+jJDNmY/Qvd9+XX+5ca
	XDd4B1dpFoaotn+dvqVHiBW58y3m6Nc=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 9A869337BB;
	Fri, 16 Jan 2026 14:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q+c2vtfBgSpXigJtY75bYtfi3Y2UxCcBVZpVZiGZCPE=;
	b=PE4BP1iG3RtG1R1Yn+VXwvPc0sF7C0fkWf7fLKDKhsmP3ZInuaDEgrTnqB9yXCmZahTXSL
	B7g6uqNvgfNuAXeAmkwOFUYSVMhDBvvL36Jz6ERnQ5dvOH5ufxzen+mOQNf2h/exBjluTL
	8/XwYVLfVHT1OM0P+BQqm/e6V7e29E0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q+c2vtfBgSpXigJtY75bYtfi3Y2UxCcBVZpVZiGZCPE=;
	b=fXJtY/n4XXuZQI5+Bhueck4B43HJXJMHMh5gH0HcD1jmdwp72I6hn0X+zGMsQ1OpKgbQwt
	UIplDVO4W8QY3qCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1768574437; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q+c2vtfBgSpXigJtY75bYtfi3Y2UxCcBVZpVZiGZCPE=;
	b=PE4BP1iG3RtG1R1Yn+VXwvPc0sF7C0fkWf7fLKDKhsmP3ZInuaDEgrTnqB9yXCmZahTXSL
	B7g6uqNvgfNuAXeAmkwOFUYSVMhDBvvL36Jz6ERnQ5dvOH5ufxzen+mOQNf2h/exBjluTL
	8/XwYVLfVHT1OM0P+BQqm/e6V7e29E0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1768574437;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q+c2vtfBgSpXigJtY75bYtfi3Y2UxCcBVZpVZiGZCPE=;
	b=fXJtY/n4XXuZQI5+Bhueck4B43HJXJMHMh5gH0HcD1jmdwp72I6hn0X+zGMsQ1OpKgbQwt
	UIplDVO4W8QY3qCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7B0003EA66;
	Fri, 16 Jan 2026 14:40:37 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id yG6/HeVNamnydgAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Fri, 16 Jan 2026 14:40:37 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Fri, 16 Jan 2026 15:40:29 +0100
Subject: [PATCH v3 09/21] slab: add optimized sheaf refill from partial
 list
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260116-sheaves-for-all-v3-9-5595cb000772@suse.cz>
References: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
In-Reply-To: <20260116-sheaves-for-all-v3-0-5595cb000772@suse.cz>
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
X-Rspamd-Queue-Id: 378BC1C000D
X-Stat-Signature: ay13qmmspz7keuxuewkdhj9cmecjr6ug
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768574467-100953
X-HE-Meta: U2FsdGVkX19EsHMSltb++WSuelhVAlBtWAvLf4v6LTu2woI3DciU0IMfH5mpbzH8gRxJ0T7fID5s0jgiM/gxnSgIa1X46RkO2OVBrL2EAr+gECdu+SQi6FttoZWkKh1kwwVGbQpIFInhR1bBT9l3LBhU/btoEs786UEWVL492iH58gfQzves5aW7FI9jLCfdkoy3QBaEplLSl7D06mVxZBadMNqrUslh9+Whs/Jhe0GRMEOSMhCPmMW4KrvtPQNPyqu8DF7imSVrZwmuUleHf3Qz2P8RHcKAU3JdWzb09HW2i1q7TbrzMv2rNOT1QG9UNEmDeReCVqHOP+WChhybzGUf075UcD2dZJE58qedQU3djbs52SWlYElbcZi+dWDf7TDAfKGU/AYJKeq80X6vkJsLeSYlnjk8Co5AvjmYVA+mARylBGEzJJCEE04oo8DRhFJO8Vni91lvLlnSb6Zug+qbofjsKsWTKUNWwPte69PREL+7nkNWyrSF8asYevm+hZ4pp4xFmQdQWWC62IMA/i4kwnmUpjOmJFKCQgzRxvd+dz/Fc9XWbGms0o3gMtxoovgJ4K2NnmpEmEy7KWbNLtuDkSCA5VV0Aju0jOo1TBIj70CVBiPw4i+Su9WVGOKzUvxquWAM1PlDHZBF5luS1LWwS4rj708qTikSq0TYa9NwNL7zylL/FqbbZi9qR7CUOYm0Rb8DDbzcwcsy5dh2HHr6gh+gP13qj0vJW9+MgjN4NewumYgU6o130NuWv2vno/mZtT/vJyjgpKaYQIyjyzdivwaaxL5/0RSFl0ey7zMG5Du8SZPyVP+zPw936AuPQkXf9mrwEl5NeUspBiNj3B6fZfHljlpp1AWlHPq6eOkLGEcl5o/aC1F1O0yEzMicb5xNRA9HohjQ7wlkHRhM54mE2TipBWH2aeUj0OryeUdq0iiq33ahbs3wE1qOwDyDuI8JR0scescLYbGxp90
 s0e1PD7E
 2fMgOhFOS/jkfZvrP0j146BE5zAAD0PZeOZTRV++WnhoSmDxiyYtO3keGotT46Y5Kvt0XHbKo1M3ddFBZs0bIZv3ibz43EeX5Ce6N39/xqKuAyfMLBQh1MxUQew1RZFUs7cmruYFYdqflbcgPhJ/wXjmCC8gTfKtl1USLurPi0FMrb+/0vybPJney64Xb/ZsVOwcbdceVlZ21bz+sjVIupUBlO92DgD2gTT7pvZ7h7CbLbzAOJ13ZSSQ95w==
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
index 9bea8a65e510..dce80463f92c 100644
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
@@ -2650,9 +2653,9 @@ static void free_empty_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf)
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
@@ -2663,8 +2666,8 @@ static int refill_sheaf(struct kmem_cache *s, struct slab_sheaf *sheaf,
 	if (!to_fill)
 		return 0;
 
-	filled = __kmem_cache_alloc_bulk(s, gfp, to_fill,
-					 &sheaf->objects[sheaf->size]);
+	filled = __refill_objects(s, &sheaf->objects[sheaf->size], gfp,
+			to_fill, to_fill);
 
 	sheaf->size += filled;
 
@@ -3522,6 +3525,63 @@ static inline void put_cpu_partial(struct kmem_cache *s, struct slab *slab,
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
@@ -4448,6 +4508,33 @@ static inline void *get_freelist(struct kmem_cache *s, struct slab *slab)
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
+		VM_WARN_ON_ONCE(new.frozen);
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
@@ -4471,6 +4558,65 @@ static inline void *freeze_slab(struct kmem_cache *s, struct slab *slab)
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
+	inc_slabs_node(s, slab_nid(slab), slab->objects);
+	return allocated;
+}
+
 /*
  * Slow path. The lockless freelist is empty or we need to perform
  * debugging duties.
@@ -4913,21 +5059,6 @@ static __always_inline void *__slab_alloc_node(struct kmem_cache *s,
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
@@ -5388,6 +5519,9 @@ static int __prefill_sheaf_pfmemalloc(struct kmem_cache *s,
 	return ret;
 }
 
+static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
+				   size_t size, void **p);
+
 /*
  * returns a sheaf that has at least the requested size
  * when prefilling is needed, do so with given gfp flags
@@ -7463,6 +7597,116 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
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
+		 * Freelist had more objects than we can accommodate, we need to
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


