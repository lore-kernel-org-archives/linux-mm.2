Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67ED7CDB479
	for <linux-mm@archiver.kernel.org>; Wed, 24 Jun 2026 10:03:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1C26B008C; Wed, 24 Jun 2026 06:03:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CA3396B0092; Wed, 24 Jun 2026 06:03:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDFF76B0093; Wed, 24 Jun 2026 06:03:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98DF96B008C
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 06:03:45 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 068EA1202DF
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:03:45 +0000 (UTC)
X-FDA: 84914369610.12.5969769
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf30.hostedemail.com (Postfix) with ESMTP id 83AD580006
	for <linux-mm@kvack.org>; Wed, 24 Jun 2026 10:03:41 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xy2TlIvR;
	spf=pass (imf30.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782295423;
	b=bOIJzB8NAkYedUbngntTUXpbMqAyw9UJupT05f9R8PUBHen761qXWzukQqtOZo9tb6xfIX
	kHDZOq1k/Vxd5f7Ee7CAEkWVlNVGXp/iAPtNHJw5Y9UR+vNIvdsXoMmUWM83nPvRM/OsAG
	rRTkOcpyZElIyJUaNyAt/QUouHV/OE8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782295423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=aS99pPWXTDDfg1auEFFHECROqxRgq/RRv3gP/QFN89k=;
	b=JCsA/ywE8KbaJc83j13I2iYBT+Uao5sAwVqOe+crmQp60Xzu+2mVpTyrzO5jYmkuuJcKdv
	G57VusqK8kLO9CbyNLOxaQAHd6vAjJtqNPaxk5ccRBqtbGw6Af6XyF0+xwBierrG3urHrC
	MAfaFehajEqyAao7Bd9up2/gQmaPRCk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Xy2TlIvR;
	spf=pass (imf30.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782295419;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=aS99pPWXTDDfg1auEFFHECROqxRgq/RRv3gP/QFN89k=;
	b=Xy2TlIvRM0cd+70T9/TiKfN2mtKNUgZ6wcpld/ak6PynPFvD7aIySFmW1buWLSYMegz+pN
	by3vtw7wH0sCbPauzW+CSbujFSfd5+GPXuGZAJ1HJkRogRHeBIBM6ivk3Szwhh+Q/PvWYS
	1nMRQrOBY6LC7D/0zBcxVa88UWZXCAs=
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
Subject: [PATCH v3] mm/slub: deduplicate NUMA policy calculation in allocation paths
Date: Wed, 24 Jun 2026 18:00:14 +0800
Message-ID: <20260624100320.430115-1-hao.li@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ix3hsefc8pr3n7988rpy9ds41tj4rn31
X-Rspam-User: 
X-Rspamd-Queue-Id: 83AD580006
X-Rspamd-Server: rspam02
X-HE-Tag: 1782295421-331190
X-HE-Meta: U2FsdGVkX180TPs0dZnkvHS3Bp76J2/wSzXyAldxaPKlMeGRXvNBuzhvuLshLb2jQeVwZw0F+mhRqXiFKsHaXDildrPbM/1/dXvooCLhWMnavk2W8XJl+CNvn2yqRxtpqoxdu/hZ9XRji0tU7aak6vin2qOYP/IODMuZQPYmJy5eDay/kRUX54xOHyruYCb1O2tVNmRoHUxTeFNHMnINozpPd6NdggwUu6rO9MmTCcgCSgxHIEEhzY4Tw3RVxV/jEbSCKiE779RYG+LIWeY24eZ4Jo6AyKRD0tzE9D2zz1WRHcOioQQmTOIJZK/DsbcXkpDLBu5ZDwPiMqitUUWufZG3K4W0eqqhlusbAzXlezV9WX7MSanwRd7X+5gtfb2fXBrp24YDiwL2G+uHAcpreXR1c5BvNM3+J/V4hMeN2VXgZi5snAiU0Xq07n31M0Q4ndbefgnVH/9tCFBKtxCZNcuU7Ih4/DLElA02V84Jk+itFeETV46r/Jy9zrabP1C8TYuD8f8H7pKgT/W5wa/XuMtIbwLMbl3Rv6292EHsGxBKEoWmW2UUB2KWgan89uE4lVcteOEWzG/xqlRD+9FnwIzRGLjjdPSTB88ELeyij6Agpttos+RwD4PHE8my4ENgiJ+lgsUiOsm56SICR+utNNd/z3NxPhcgDq1rpgVzk0UGuzBLr7irvkIYhijQ2n8J0jwCI35UwfWdPf/b+ZIH9Vjy60ZLuemRqPKJ5Ox6EL3qGDXnD2HH4Vfi2T/7MHAI4kdOJvkqhfvV+HbVu5WcoZszMyWuDlNDoEvzH0MsRQ+htbBhnIXzop4uzNtTlCaiZ/0Rv9p9Zn4kg53ncojeYEpGtJ99ULsDjqPRnFHZnnUiQGrAZkmYS8dbK54hXCqazn6uFIIQPgQ8ujpQwxLpmjJDertUme/e4iRWM1V+EXAknL0LHm6Axrj0yMJF5cFYslq2k8wMEPWmkUCOFbK
 bZJPyPQ4
 Sspu66TL3oUGfo0kX8RMXNTmOuBJA4tzQ5q50fsKqzgEuDiXZDsxOUydBrG9ULaz5ce4QlTuyu/Get14RauoBfWuOr9OdGz6tFSPh4VdJkG90sGRwPdSRdS/Dz7sG4nMPUzD8WqEwepF+SBLqgs7dQuqlNuAufvp/R2jWwOAdvgjq5z0MyVVGrQyTNKEnjwOjHs1t
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
  And each retry will also advance the interleave state.

  With this change, the strict NUMA node is resolved once and reused by
  both alloc_from_pcs() and ___slab_alloc() in each retry.

  This is a behavior change, but it better matches the intent of
  selecting one policy node for one allocation attempt.

Signed-off-by: Hao Li <hao.li@linux.dev>
---
Changes in v3:
  * Move apply_strict_numa_policy before retry label to simplify code (Thanks
    Harry)

Changes in v2:
  * Use a better function name apply_strict_numa_policy() (Thanks Harry)
  * Remove almost empty function __slab_alloc_node.
  * Add a local variable, strict_node, so the retry path in
    __kmalloc_nolock_noprof() computes the strict NUMA node from the original
    node parameter instead of a previously resolved node value.
---
 mm/slub.c | 42 +++++++++---------------------------------
 1 file changed, 9 insertions(+), 33 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 62e9cd46916f..ba969ad1db8b 100644
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
 
@@ -5406,20 +5380,22 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 	 * See the comment for the same check in
 	 * alloc_frozen_pages_nolock_noprof()
 	 */
 	if (IS_ENABLED(CONFIG_PREEMPT_RT) && (in_nmi() || in_hardirq()))
 		return NULL;
 
 	/* On UP, spin_trylock() always succeeds even when it is locked */
 	if (!IS_ENABLED(CONFIG_SMP) && in_nmi())
 		return NULL;
 
+	node = apply_strict_numa_policy(node);
+
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;
 	s = kmalloc_slab(size, NULL, gfp_flags, PASS_TOKEN_PARAM(token));
 
 	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
 		/*
 		 * kmalloc_nolock() is not supported on architectures that
 		 * don't implement cmpxchg16b and thus need slab_lock()
 		 * which could be preempted by a nmi.
@@ -5430,24 +5406,24 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 		 */
 		return NULL;
 
 	ret = alloc_from_pcs(s, gfp_flags, ac->alloc_flags, node);
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
+	ret = ___slab_alloc(s, gfp_flags, node, ac);
 
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


