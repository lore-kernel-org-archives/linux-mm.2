Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45FFDCCFA07
	for <linux-mm@archiver.kernel.org>; Wed,  5 Nov 2025 09:05:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A12C88E0006; Wed,  5 Nov 2025 04:05:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8258E0002; Wed,  5 Nov 2025 04:05:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 88B088E0006; Wed,  5 Nov 2025 04:05:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 702078E0002
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 04:05:47 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 38D4B140255
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:47 +0000 (UTC)
X-FDA: 84075970734.14.D1BF712
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0F014140010
	for <linux-mm@kvack.org>; Wed,  5 Nov 2025 09:05:44 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fX1xBGgc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b5AM0cOz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fX1xBGgc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b5AM0cOz;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762333545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U6xgVA63NMfAYlm/Ncmyru9bsRe/qhoJxymi9ppBFWA=;
	b=FbebHJkuWEsUq82PpUJMpF1A7pbDDSbMAT3q91A/m9AxYMVGWTxyL9GGy9bfdbTDZBpvnz
	fqM/S9RV6myrcs+6UCZJ6LuwFQ+eMFYEThA+b+siXiKZe5Lbj5I3VvjODrm5icp772Aaus
	D4HfES2qFtiz9aiAIs7nEcPgrqurk7o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fX1xBGgc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b5AM0cOz;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=fX1xBGgc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=b5AM0cOz;
	spf=pass (imf26.hostedemail.com: domain of vbabka@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=vbabka@suse.cz;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762333545; a=rsa-sha256;
	cv=none;
	b=Y9PlLOErHPF90zEkX6ZPYyEP7wHqweUfq66gBjlrsQeV9Wy2t2DAbS2qj+d/+ikzS3dj7t
	bTY6ejbUsEuAe+FUxWsMpj+zMzXEnhcHBx8blmTj4OlT3lUYkk9r3jgQBzZ3yZPYbtT/Sp
	JTwYQ3tmmdXghje2hQMQlY6xJJf+7AI=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E1B7B1F44F;
	Wed,  5 Nov 2025 09:05:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762333530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U6xgVA63NMfAYlm/Ncmyru9bsRe/qhoJxymi9ppBFWA=;
	b=fX1xBGgcBbiqWyp7F1iDA8x0QzU7Es1mskmw47qG5hThFXO3CACHPS837YOGUG7xO4/5nC
	LxNUyyefQ2sujY72BvfZdd071yRWcEHDeBsWhGzGImuBGTpEexAgmOAuEbkx8qu65xOHRe
	ytJXJ2GLQjdlLctUy2p3oQNz4AE+2UI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762333530;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U6xgVA63NMfAYlm/Ncmyru9bsRe/qhoJxymi9ppBFWA=;
	b=b5AM0cOzSGn+5vl58QHyJfWunrPu/Wgn2uf4dxrSG3zomEKfzRiZgL/rK8GixsOtOyo8Ef
	uX5jqyir2Fj9QSCw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1762333530; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U6xgVA63NMfAYlm/Ncmyru9bsRe/qhoJxymi9ppBFWA=;
	b=fX1xBGgcBbiqWyp7F1iDA8x0QzU7Es1mskmw47qG5hThFXO3CACHPS837YOGUG7xO4/5nC
	LxNUyyefQ2sujY72BvfZdd071yRWcEHDeBsWhGzGImuBGTpEexAgmOAuEbkx8qu65xOHRe
	ytJXJ2GLQjdlLctUy2p3oQNz4AE+2UI=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1762333530;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U6xgVA63NMfAYlm/Ncmyru9bsRe/qhoJxymi9ppBFWA=;
	b=b5AM0cOzSGn+5vl58QHyJfWunrPu/Wgn2uf4dxrSG3zomEKfzRiZgL/rK8GixsOtOyo8Ef
	uX5jqyir2Fj9QSCw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C7B6313C01;
	Wed,  5 Nov 2025 09:05:30 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ABZ9MFoTC2lSBAAAD6G6ig
	(envelope-from <vbabka@suse.cz>); Wed, 05 Nov 2025 09:05:30 +0000
From: Vlastimil Babka <vbabka@suse.cz>
Date: Wed, 05 Nov 2025 10:05:32 +0100
Subject: [PATCH 4/5] slub: remove CONFIG_SLUB_TINY specific code paths
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20251105-sheaves-cleanups-v1-4-b8218e1ac7ef@suse.cz>
References: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
In-Reply-To: <20251105-sheaves-cleanups-v1-0-b8218e1ac7ef@suse.cz>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry.yoo@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, bpf@vger.kernel.org, 
 kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@suse.cz>
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 0F014140010
X-Stat-Signature: ydiynrxu1hm974ktspd9xo7o59wx14gd
X-Rspam-User: 
X-HE-Tag: 1762333544-652556
X-HE-Meta: U2FsdGVkX190AAhAEimjop/YqkxG6K7vgkFvLOd0jvDH1ZlWVgRcu9Xm6WlsaI3u5BbPu0cd1po0chWSPiK40RoJVIBaK3/3i+o0QAnr8fZoJC9z5LUcZ9Yi5AnWhXVYKt0vwWfsXeuNQ+4K36YE1hFkLMAOhkt+9ztQIQs3ejhWw22DL1KtXZO3tYxUpjAYj98oMlEIZV3QQYRJRnEgx6htTelNyXARxO2NEVoomO8HPwGiHY1mw03oC+T7xIgX5N7dmVbytqjyua5Vl4nVNUC2M9fsUPFnAOr5kPc5zRRq2Bc/lc897UjPG8F9Ka39A1+s4tzJl8h3sZn2jeQd3a/bnP0WAip7nBTKWPXBcTq0SQBCFBinseF5gqk7XKKvnL+wVcgmUClmbdlrASVj/IMMgQ+DXpJwq7x9cCCNZnv1r5ME0WTgAE573psFbCOmq+ZVElLP2DRoieHNwDMbOWSsqBQKqut3d3hX3Eyo1YdGF9WLqc+bA3Kno4/ZEvU90wlPamzGXoVVFvl9ZU424yNDSc+N0Frkt3bWrfbyqmTwnM40MDEoHeUskNqacz+nBn4StB2k8x4w7Za72h13O0eFGY1JfA57qDOyxr5M4zV6nInjrAW6t2TNiV3nfX/jGURyT0JgEEVN5dVhppnp65zuhk7ZVqXERdh+jZwtMxsZqTSlO4Liw6p/sF74YqdBZWb9DlvSgOTgJvKyqk+8palhU8tPo6YxiDqufIHSP9UKXztGPA4KU5wSrvpOcBO6LxMaPRVN5F6x+0yxn0Wfk1Me8lKUOX9y90MmiS+pi5x/tgrWRzD/Sxvyk/u3O9ZgEu+5siPQnmUe+D6heS5TYdFFFEAov9G0e7D6PlmXwDc7mMvlNkpAtD3ijdi8ZwIy+HKIqEn0h3YKwYmY022QlxV2oxa9GHbiCJXqnOIbJL+4Qsi/npkQ8CEUBPpUAjiYcQyU9H71T5zt+53oHv6
 4+2Ta50q
 lQRwriam3sd2F52pfp5WanEn36+9/Nq8Scq1Fg6Pbctd+d3dPGnjx4bdPI9G7RNcxKZmBQLATEmYGmrBckKnjMNsk678C8Ee8Ix4/1zHK2NAw9dm2g9kRJmPMGNMbsbECNr8Um6jq7oxkNLPoxOrX+PqErO3npdbykK5ljow1QFATm14E2MEcfXlXJ/9IfcTwVHCcPOhe5g0BFipBUvEMlKbk2LgxVbVMp2JX7Pe0whkAo04MaN9e8W4rwtlyu9T9+I1AlBZVpQifRxRM4bpdCoyjki6uYK/us+r61Mwn206Q7DTcHZArlgY79rbqkE1sRW9k1lEjEdW8mNY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_SLUB_TINY minimizes the SLUB's memory overhead in multiple ways,
mainly by avoiding percpu caching of slabs and objects. It also reduces
code size by replacing some code paths with simplified ones through
ifdefs, but the benefits of that are smaller and would complicate the
upcoming changes.

Thus remove these code paths and associated ifdefs and simplify the code
base.

Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slab.h |   2 --
 mm/slub.c | 107 +++-----------------------------------------------------------
 2 files changed, 4 insertions(+), 105 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 078daecc7cf5..f7b8df56727d 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -236,10 +236,8 @@ struct kmem_cache_order_objects {
  * Slab cache management.
  */
 struct kmem_cache {
-#ifndef CONFIG_SLUB_TINY
 	struct kmem_cache_cpu __percpu *cpu_slab;
 	struct lock_class_key lock_key;
-#endif
 	struct slub_percpu_sheaves __percpu *cpu_sheaves;
 	/* Used for retrieving partial slabs, etc. */
 	slab_flags_t flags;
diff --git a/mm/slub.c b/mm/slub.c
index bb744e8044f0..a7c6d79154f8 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -410,7 +410,6 @@ enum stat_item {
 	NR_SLUB_STAT_ITEMS
 };
 
-#ifndef CONFIG_SLUB_TINY
 /*
  * When changing the layout, make sure freelist and tid are still compatible
  * with this_cpu_cmpxchg_double() alignment requirements.
@@ -432,7 +431,6 @@ struct kmem_cache_cpu {
 	unsigned int stat[NR_SLUB_STAT_ITEMS];
 #endif
 };
-#endif /* CONFIG_SLUB_TINY */
 
 static inline void stat(const struct kmem_cache *s, enum stat_item si)
 {
@@ -597,12 +595,10 @@ static inline void *get_freepointer(struct kmem_cache *s, void *object)
 	return freelist_ptr_decode(s, p, ptr_addr);
 }
 
-#ifndef CONFIG_SLUB_TINY
 static void prefetch_freepointer(const struct kmem_cache *s, void *object)
 {
 	prefetchw(object + s->offset);
 }
-#endif
 
 /*
  * When running under KMSAN, get_freepointer_safe() may return an uninitialized
@@ -714,10 +710,12 @@ static inline unsigned int slub_get_cpu_partial(struct kmem_cache *s)
 	return s->cpu_partial_slabs;
 }
 #else
+#ifdef SLAB_SUPPORTS_SYSFS
 static inline void
 slub_set_cpu_partial(struct kmem_cache *s, unsigned int nr_objects)
 {
 }
+#endif
 
 static inline unsigned int slub_get_cpu_partial(struct kmem_cache *s)
 {
@@ -2026,13 +2024,11 @@ static inline void inc_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
 static inline void dec_slabs_node(struct kmem_cache *s, int node,
 							int objects) {}
-#ifndef CONFIG_SLUB_TINY
 static bool freelist_corrupted(struct kmem_cache *s, struct slab *slab,
 			       void **freelist, void *nextfree)
 {
 	return false;
 }
-#endif
 #endif /* CONFIG_SLUB_DEBUG */
 
 #ifdef CONFIG_SLAB_OBJ_EXT
@@ -3623,8 +3619,6 @@ static struct slab *get_partial(struct kmem_cache *s, int node,
 	return get_any_partial(s, pc);
 }
 
-#ifndef CONFIG_SLUB_TINY
-
 #ifdef CONFIG_PREEMPTION
 /*
  * Calculate the next globally unique transaction for disambiguation
@@ -4024,12 +4018,6 @@ static bool has_cpu_slab(int cpu, struct kmem_cache *s)
 	return c->slab || slub_percpu_partial(c);
 }
 
-#else /* CONFIG_SLUB_TINY */
-static inline void __flush_cpu_slab(struct kmem_cache *s, int cpu) { }
-static inline bool has_cpu_slab(int cpu, struct kmem_cache *s) { return false; }
-static inline void flush_this_cpu_slab(struct kmem_cache *s) { }
-#endif /* CONFIG_SLUB_TINY */
-
 static bool has_pcs_used(int cpu, struct kmem_cache *s)
 {
 	struct slub_percpu_sheaves *pcs;
@@ -4370,7 +4358,6 @@ static inline bool pfmemalloc_match(struct slab *slab, gfp_t gfpflags)
 	return true;
 }
 
-#ifndef CONFIG_SLUB_TINY
 static inline bool
 __update_cpu_freelist_fast(struct kmem_cache *s,
 			   void *freelist_old, void *freelist_new,
@@ -4634,7 +4621,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	pc.orig_size = orig_size;
 	slab = get_partial(s, node, &pc);
 	if (slab) {
-		if (kmem_cache_debug(s)) {
+		if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
 			freelist = pc.object;
 			/*
 			 * For debug caches here we had to go through
@@ -4672,7 +4659,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	stat(s, ALLOC_SLAB);
 
-	if (kmem_cache_debug(s)) {
+	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
 		freelist = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
 
 		if (unlikely(!freelist)) {
@@ -4884,32 +4871,6 @@ static __always_inline void *__slab_alloc_node(struct kmem_cache *s,
 
 	return object;
 }
-#else /* CONFIG_SLUB_TINY */
-static void *__slab_alloc_node(struct kmem_cache *s,
-		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
-{
-	struct partial_context pc;
-	struct slab *slab;
-	void *object;
-
-	pc.flags = gfpflags;
-	pc.orig_size = orig_size;
-	slab = get_partial(s, node, &pc);
-
-	if (slab)
-		return pc.object;
-
-	slab = new_slab(s, gfpflags, node);
-	if (unlikely(!slab)) {
-		slab_out_of_memory(s, gfpflags, node);
-		return NULL;
-	}
-
-	object = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
-
-	return object;
-}
-#endif /* CONFIG_SLUB_TINY */
 
 /*
  * If the object has been wiped upon free, make sure it's fully initialized by
@@ -5760,9 +5721,7 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t gfp_flags, int node)
 	 * it did local_lock_irqsave(&s->cpu_slab->lock, flags).
 	 * In this case fast path with __update_cpu_freelist_fast() is not safe.
 	 */
-#ifndef CONFIG_SLUB_TINY
 	if (!in_nmi() || !local_lock_is_locked(&s->cpu_slab->lock))
-#endif
 		ret = __slab_alloc_node(s, alloc_gfp, node, _RET_IP_, size);
 
 	if (PTR_ERR(ret) == -EBUSY) {
@@ -6553,14 +6512,10 @@ static void free_deferred_objects(struct irq_work *work)
 	llist_for_each_safe(pos, t, llnode) {
 		struct slab *slab = container_of(pos, struct slab, llnode);
 
-#ifdef CONFIG_SLUB_TINY
-		free_slab(slab->slab_cache, slab);
-#else
 		if (slab->frozen)
 			deactivate_slab(slab->slab_cache, slab, slab->flush_freelist);
 		else
 			free_slab(slab->slab_cache, slab);
-#endif
 	}
 }
 
@@ -6596,7 +6551,6 @@ void defer_free_barrier(void)
 		irq_work_sync(&per_cpu_ptr(&defer_free_objects, cpu)->work);
 }
 
-#ifndef CONFIG_SLUB_TINY
 /*
  * Fastpath with forced inlining to produce a kfree and kmem_cache_free that
  * can perform fastpath freeing without additional function calls.
@@ -6689,14 +6643,6 @@ static __always_inline void do_slab_free(struct kmem_cache *s,
 	}
 	stat_add(s, FREE_FASTPATH, cnt);
 }
-#else /* CONFIG_SLUB_TINY */
-static void do_slab_free(struct kmem_cache *s,
-				struct slab *slab, void *head, void *tail,
-				int cnt, unsigned long addr)
-{
-	__slab_free(s, slab, head, tail, cnt, addr);
-}
-#endif /* CONFIG_SLUB_TINY */
 
 static __fastpath_inline
 void slab_free(struct kmem_cache *s, struct slab *slab, void *object,
@@ -6974,11 +6920,7 @@ void kfree_nolock(const void *object)
 	 * since kasan quarantine takes locks and not supported from NMI.
 	 */
 	kasan_slab_free(s, x, false, false, /* skip quarantine */true);
-#ifndef CONFIG_SLUB_TINY
 	do_slab_free(s, slab, x, x, 0, _RET_IP_);
-#else
-	defer_free(s, x);
-#endif
 }
 EXPORT_SYMBOL_GPL(kfree_nolock);
 
@@ -7428,7 +7370,6 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 }
 EXPORT_SYMBOL(kmem_cache_free_bulk);
 
-#ifndef CONFIG_SLUB_TINY
 static inline
 int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 			    void **p)
@@ -7493,35 +7434,6 @@ int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags, size_t size,
 	return 0;
 
 }
-#else /* CONFIG_SLUB_TINY */
-static int __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
-				   size_t size, void **p)
-{
-	int i;
-
-	for (i = 0; i < size; i++) {
-		void *object = kfence_alloc(s, s->object_size, flags);
-
-		if (unlikely(object)) {
-			p[i] = object;
-			continue;
-		}
-
-		p[i] = __slab_alloc_node(s, flags, NUMA_NO_NODE,
-					 _RET_IP_, s->object_size);
-		if (unlikely(!p[i]))
-			goto error;
-
-		maybe_wipe_obj_freeptr(s, p[i]);
-	}
-
-	return i;
-
-error:
-	__kmem_cache_free_bulk(s, i, p);
-	return 0;
-}
-#endif /* CONFIG_SLUB_TINY */
 
 /* Note that interrupts must be enabled when calling this function. */
 int kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags, size_t size,
@@ -7740,7 +7652,6 @@ init_kmem_cache_node(struct kmem_cache_node *n, struct node_barn *barn)
 		barn_init(barn);
 }
 
-#ifndef CONFIG_SLUB_TINY
 static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
 {
 	BUILD_BUG_ON(PERCPU_DYNAMIC_EARLY_SIZE <
@@ -7761,12 +7672,6 @@ static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
 
 	return 1;
 }
-#else
-static inline int alloc_kmem_cache_cpus(struct kmem_cache *s)
-{
-	return 1;
-}
-#endif /* CONFIG_SLUB_TINY */
 
 static int init_percpu_sheaves(struct kmem_cache *s)
 {
@@ -7856,13 +7761,11 @@ void __kmem_cache_release(struct kmem_cache *s)
 	cache_random_seq_destroy(s);
 	if (s->cpu_sheaves)
 		pcs_destroy(s);
-#ifndef CONFIG_SLUB_TINY
 #ifdef CONFIG_PREEMPT_RT
 	if (s->cpu_slab)
 		lockdep_unregister_key(&s->lock_key);
 #endif
 	free_percpu(s->cpu_slab);
-#endif
 	free_kmem_cache_nodes(s);
 }
 
@@ -8605,10 +8508,8 @@ void __init kmem_cache_init(void)
 
 void __init kmem_cache_init_late(void)
 {
-#ifndef CONFIG_SLUB_TINY
 	flushwq = alloc_workqueue("slub_flushwq", WQ_MEM_RECLAIM, 0);
 	WARN_ON(!flushwq);
-#endif
 }
 
 struct kmem_cache *

-- 
2.51.1


