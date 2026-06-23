Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1FC5CD98F2
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:10:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 669A76B0088; Tue, 23 Jun 2026 07:10:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61B066B008A; Tue, 23 Jun 2026 07:10:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50B996B008C; Tue, 23 Jun 2026 07:10:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1C5066B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:10:29 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8BFBB167036
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:10:28 +0000 (UTC)
X-FDA: 84910908936.30.4B0AD60
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf07.hostedemail.com (Postfix) with ESMTP id B28A74000B
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:10:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pvm/qeeh";
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782213027;
	b=tAed91HWKSC2DNLBfCVZ+4UnZV4l/jVJXIX2OD6FpS4DHxyjiYqASsWpbjW+6/EIiuBEIm
	EkpvAM7TRdjaY2NfT1CthLJp1ZAW3gNfFzijkeGx5Czg/8CCAc9+75qULkI0umYw3l4CLf
	l6459kAF1DA+Iu/2+0ptBUfbDifcaak=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782213027;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4TelfNcx112YhtG4lws+QMCYDAukoHOzJwVmO7r3NhQ=;
	b=E0mXJwrN5BIsWl36aWMUNEftsfwo9w8K+gK1MT7ZpPtxbcL0/npWJAo73vpWh4+r5AA7v8
	SohXVzcP4WmdROM241rx9VcMS0unRfDnsf8kzD2ecfoYMRPuqrRFLydzlzw9oKdqePBAng
	xOQq3b1qx9BkFGN76klUb1nWn2DaWAs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="pvm/qeeh";
	spf=pass (imf07.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782213024;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=4TelfNcx112YhtG4lws+QMCYDAukoHOzJwVmO7r3NhQ=;
	b=pvm/qeeh8SrMvxM5m3i3xr3tYv2tf+oYIc8dZxcod1hHU7jqDfDPR1ai/11uy4vdTzruvV
	LssZUEqXBBCP18Esze55LywfBQ3XA30ufv7+/aDpmBoaBAZkG+TqM+nAgJGkfcASNTFwdN
	g+1fdGfAJUAjnMlFBiiu4xpEdQihOTs=
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org
Cc: akpm@linux-foundation.org,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH v2] mm/slub: deduplicate NUMA policy calculation in allocation paths
Date: Tue, 23 Jun 2026 19:04:02 +0800
Message-ID: <20260623110952.411041-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B28A74000B
X-Rspam-User: 
X-Stat-Signature: nfcpuo5j9hneb6f6kojd18pngadf6yf6
X-HE-Tag: 1782213026-907245
X-HE-Meta: U2FsdGVkX1+uv8CMy1kv3xCGIQmaDCVoW4hEGZg6dbGIkkI9FNsMq9Xf6en04nNxzXHy/LyM0YkhR+SKpO1r1DVViEJ4u2TPLoyW6I4nzQduWgoGYcASMn/p3Z9T7UB4gMd/pBUUYsmlJ4UNRcDx7HeQbAZSzXZReT8n30SE/BDoYM7I2taL1JXxXcSfykZ5On5pIzFwT8+FbFpmnqE5YFw0GT2zjvrLHxGZBa93T/RHYZhvXGCQFxUo2aOhGxBFBW7P/h2b8k2yothCDAAGZdwXYTV4jOonxdpuZpDrMUqrdMKmxrVO7/45iKDu4hXv2UN9k/xDdpT9ksvKepjo0yGncD9S2P9S3J+lJOHNmeUXyUMvCmWLyk5sgEOOMuD8X4BsIwIyWU81dIL8F59BW/ihTpgqOG0rBO8Z+Fanqm+t27CG4H9R7C7aUTBy9kjYPfzGnkCzuApySvLdbBE4Hd+nzvO+6hUvrLBUvDVXHcOpM0ASzgekQYXFpLAQSvGO6owcP7fQ5msejoxGu+TQ6cB4RUia09FNsMPUZEeKquVT2iy4mz01wQ3wmdFWVgSXIjlo8iVtEan+kI0C+E4DsHueIveQ2W0msFc2eyis30Ckcz5CBIUdv+UNWBLyDvMyKO4bHSfIyJ8IPN9e/NqCX1cCNay3NtIGZhQTg2v0/9GAM7Cv3PDjkbmMuynr/PCaHuNiqmHmebsNjCopbUIkb1moA+HTM5lwsV5YwrkjQ+uFOADxitRujYrHcMkovqrJ/6I0Vq/rezcSe45ETmEUK//NTUvgyly8BqEIx9Ta1Fj08hlv5YQewsUbXOZmXmtJN6NB2vfpSqQKYAX2kcDex70Lpjw1jSmLnPSktl5loxm/Az51fkV6MzYujWpA4fEHajaFeqsud000eo64p4PUkg0DXYUH0Me80j6WldmwbloBmbKzTvk5ik8ByVw3W+dwcobk4psXOPK0Fduc3ff
 Ugvej/MG
 r0KsAndx8UO+dvnFf7tLHqJ3VvK3YeszQ1xje4C2ePZBOUHJeo6Eq0PQC4sLcVKmPbLaFOT53iu+ampAfvfCSS62Am4UsKiJ7r+FaCGvYGOJRs6A89AglJYK+kyDGvzOPO7FMjYwej+sIIq0bMi95NWyfEmgs2bt+cr0m0RrMyXBBhp8pSONyuciNXZsLYmdjOZet
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, alloc_from_pcs() and __slab_alloc_node() both calculate the
NUMA policy independently. Since they are called consecutively in paths
like __kmalloc_nolock_noprof() and slab_alloc_node(), this leads to
redundant code snippets.

Introduce a helper function to resolve the NUMA policy once, eliminating
the duplicated code and reducing execution overhead.

Also remove __slab_alloc_node() function because it is almost empty.
The callers of __slab_alloc_node now call ___slab_alloc() directly.

Additional notes:

  Previously, when slab_strict_numa was enabled, alloc_from_pcs() and
  __slab_alloc_node() could each resolve the task mempolicy, so
  MPOL_INTERLEAVE or MPOL_WEIGHTED_INTERLEAVE could advance the
  interleave state twice for a single object allocation attempt.

  With this change, the strict NUMA node is resolved once and reused by
  both alloc_from_pcs() and ___slab_alloc().

  This is a behavior change, but it better matches the intent of
  selecting one policy node for one allocation attempt.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
Changes in v2:
  * Use a better function name apply_strict_numa_policy() (Thanks Harry)
  * Remove almost empty function __slab_alloc_node.
  * Add a local variable, strict_node, so the retry path in
    __kmalloc_nolock_noprof() computes the strict NUMA node from the original
    node parameter instead of a previously resolved node value.
---
 mm/slub.c | 45 +++++++++++----------------------------------
 1 file changed, 11 insertions(+), 34 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 62e9cd46916f..fd58bd6abd5e 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4516,49 +4516,43 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	/* This could cause an endless loop. Fail instead. */
 	return NULL;
 
 success:
 	if (kmem_cache_debug_flags(s, SLAB_STORE_USER))
 		set_track(s, object, TRACK_ALLOC, ac->caller_addr, gfpflags);
 
 	return object;
 }
 
-static void *__slab_alloc_node(struct kmem_cache *s, gfp_t gfpflags, int node,
-			       const struct slab_alloc_context *ac)
+static __always_inline int apply_strict_numa_policy(int node)
 {
-	void *object;
-
 #ifdef CONFIG_NUMA
 	if (static_branch_unlikely(&strict_numa) &&
 			node == NUMA_NO_NODE) {
 
 		struct mempolicy *mpol = current->mempolicy;
 
 		if (mpol) {
 			/*
 			 * Special BIND rule support. If the local node
 			 * is in permitted set then do not redirect
 			 * to a particular node.
 			 * Otherwise we apply the memory policy to get
 			 * the node we need to allocate on.
 			 */
 			if (mpol->mode != MPOL_BIND ||
 					!node_isset(numa_mem_id(), mpol->nodes))
 				node = mempolicy_slab_node();
 		}
 	}
 #endif
-
-	object = ___slab_alloc(s, gfpflags, node, ac);
-
-	return object;
+	return node;
 }
 
 static __fastpath_inline
 struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
 {
 	flags &= gfp_allowed_mask;
 
 	might_alloc(flags);
 
 	if (unlikely(should_failslab(s, flags)))
@@ -4749,42 +4743,20 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 	return pcs;
 }
 
 static __fastpath_inline
 void *alloc_from_pcs(struct kmem_cache *s, gfp_t gfp, unsigned int alloc_flags, int node)
 {
 	struct slub_percpu_sheaves *pcs;
 	bool node_requested;
 	void *object;
 
-#ifdef CONFIG_NUMA
-	if (static_branch_unlikely(&strict_numa) &&
-			 node == NUMA_NO_NODE) {
-
-		struct mempolicy *mpol = current->mempolicy;
-
-		if (mpol) {
-			/*
-			 * Special BIND rule support. If the local node
-			 * is in permitted set then do not redirect
-			 * to a particular node.
-			 * Otherwise we apply the memory policy to get
-			 * the node we need to allocate on.
-			 */
-			if (mpol->mode != MPOL_BIND ||
-					!node_isset(numa_mem_id(), mpol->nodes))
-
-				node = mempolicy_slab_node();
-		}
-	}
-#endif
-
 	node_requested = IS_ENABLED(CONFIG_NUMA) && node != NUMA_NO_NODE;
 
 	/*
 	 * We assume the percpu sheaves contain only local objects although it's
 	 * not completely guaranteed, so we verify later.
 	 */
 	if (unlikely(node_requested && node != numa_mem_id())) {
 		stat(s, ALLOC_NODE_MISMATCH);
 		return NULL;
 	}
@@ -4920,24 +4892,26 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s,
 	void *object;
 
 	s = slab_pre_alloc_hook(s, gfpflags);
 	if (unlikely(!s))
 		return NULL;
 
 	object = kfence_alloc(s, ac->orig_size, gfpflags);
 	if (unlikely(object))
 		goto out;
 
+	node = apply_strict_numa_policy(node);
+
 	object = alloc_from_pcs(s, gfpflags, ac->alloc_flags, node);
 
 	if (unlikely(!object))
-		object = __slab_alloc_node(s, gfpflags, node, ac);
+		object = ___slab_alloc(s, gfpflags, node, ac);
 
 	maybe_wipe_obj_freeptr(s, object);
 
 out:
 	/*
 	 * In case this fails due to memcg_slab_post_alloc_hook(),
 	 * object is set to NULL
 	 */
 	slab_post_alloc_hook(s, gfpflags, 1, &object, ac);
 
@@ -5385,20 +5359,21 @@ void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
 				 PASS_TOKEN_PARAM(token), &ac);
 }
 EXPORT_SYMBOL(__kmalloc_noprof);
 
 static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags,
 				     int node, const struct slab_alloc_context *ac)
 {
 	struct kmem_cache *s;
 	bool can_retry = true;
 	void *ret;
+	int strict_node;
 
 	VM_WARN_ON_ONCE(alloc_flags_allow_spinning(ac->alloc_flags));
 	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
 				      __GFP_NOWARN | __GFP_NOMEMALLOC));
 
 	gfp_flags |= __GFP_NOWARN | __GFP_NOMEMALLOC;
 
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;
 
@@ -5423,31 +5398,33 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 		 * kmalloc_nolock() is not supported on architectures that
 		 * don't implement cmpxchg16b and thus need slab_lock()
 		 * which could be preempted by a nmi.
 		 * But debug caches don't use that and only rely on
 		 * kmem_cache_node->list_lock, so kmalloc_nolock() can attempt
 		 * to allocate from debug caches by
 		 * spin_trylock_irqsave(&n->list_lock, ...)
 		 */
 		return NULL;
 
-	ret = alloc_from_pcs(s, gfp_flags, ac->alloc_flags, node);
+	strict_node = apply_strict_numa_policy(node);
+
+	ret = alloc_from_pcs(s, gfp_flags, ac->alloc_flags, strict_node);
 	if (ret)
 		goto success;
 
 	/*
 	 * Do not call slab_alloc_node(), since trylock mode isn't
 	 * compatible with slab_pre_alloc_hook/should_failslab and
-	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
+	 * kfence_alloc. Hence call ___slab_alloc() (at most twice)
 	 * and slab_post_alloc_hook() directly.
 	 */
-	ret = __slab_alloc_node(s, gfp_flags, node, ac);
+	ret = ___slab_alloc(s, gfp_flags, strict_node, ac);
 
 	/*
 	 * It's possible we failed due to trylock as we preempted someone with
 	 * the sheaves locked, and the list_lock is also held by another cpu.
 	 * But it should be rare that multiple kmalloc buckets would have
 	 * sheaves locked, so try a larger one.
 	 */
 	if (!ret && can_retry) {
 		/* pick the next kmalloc bucket */
 		size = s->object_size + 1;
-- 
2.54.0


