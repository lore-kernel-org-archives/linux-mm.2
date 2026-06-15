Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98242CD98DE
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:55:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0C06A6B009B; Mon, 15 Jun 2026 07:55:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 072726B009D; Mon, 15 Jun 2026 07:55:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF1C86B009E; Mon, 15 Jun 2026 07:55:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E181B6B009B
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:55:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id A6F181A0A20
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:10 +0000 (UTC)
X-FDA: 84881991180.08.8ADCA75
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id EA0A5100007
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AWC46ogu;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KsQDkH3NB7HMKXjyEodAbkV9bHFoqveFAU9ferOkqko=;
	b=IEhT/sEBONVPgLzH5TIjEt76tZymfxuD6+uuOPO44CrtSqYLx1cMWqHqlvXeykkNQxbEFv
	YRaWDny966GpGzdQryNthWzUydIrNevNAwz258Z8tTAfHlOEoURmrcDAKoKkJk+k7yHUIw
	IfV28no0/JOjojtBxmHFFSqC8uiUtmc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AWC46ogu;
	spf=pass (imf14.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524509;
	b=BjMmUyW5L9cwReovmUU8k212779K26ysyO7rGN5b9ekRsPvJcK1lJ/wXs4FogwjBKyqWk7
	oOwwUKszTuucvqoRv1qU4Rpta3oUm6LKzhczGRWT3nx3O1A3tGBGcGrWIN5H/npeC684nx
	zA4awKLzcHmdRXlmqh5pZr2BY45NtFs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 327384004A;
	Mon, 15 Jun 2026 11:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 985AC1F000E9;
	Mon, 15 Jun 2026 11:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524508;
	bh=KsQDkH3NB7HMKXjyEodAbkV9bHFoqveFAU9ferOkqko=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=AWC46ogu0sYJ/Rr7SWenD+Jg+OOXx0c6mLS2CDXgfEIr8g3KbNy6gcXh5Ku1FkLjd
	 rxY037pOgmf6k9WiSYcPfWopQf6SEBcES52i0ROrfcEUCp0HGXJnlcEgMcyp7jXs/2
	 8L+v9q9p7FMIx8ts1KJOe77SQezoNySATrCwoIVE4X5moiLl5DDbWI0i/i0NuBAWcW
	 YLmX4m6/BuXw5xFNUu6NjlmFVT4BLCamUu2EXKR2lY59/GYr8Vm+ZsBlKk6IiSeV7q
	 zAyz7k8tk3jpRyFRDsTpVqq/uoVpimEUSBS3VscwvaTYsXO/2jg4a0Oou1CbY7JeyE
	 5LPoY/V5e4B4Q==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:39 +0200
Subject: [PATCH v3 06/15] mm/slab: add alloc_flags to slab_alloc_context
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-6-ce1146d140fb@kernel.org>
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: EA0A5100007
X-Stat-Signature: m5m5ukzx5jd15sqfuqcp36c3t8nqnds4
X-Rspam-User: 
X-HE-Tag: 1781524508-686121
X-HE-Meta: U2FsdGVkX1+fJBrm9iJ08ZpQmZpOoygsuugHkm4o0EMETjuv5WiHGJHoZSKSRbS5LAbv1jnMMEkqxBgFuIq5om0qKuobzPryhjDa/lYcEcwOpQj2NgbQdWgbOknW/Z/YZd4nditf2caUpf9/iBi04fp+zhX9JeLdndDULYqQsDYd0sKIGuSfzfnSK2WYALsG1WzDc2IHgDv8K6nkhdqG3ZI78lBJVoJ0BkC4kpdSm5T2D/eFEw3GfvrKEuj1nXwwrcn8urdD9ckcKmtu8yn0SNhyFFIoogXhugTBftSd3KCjCqrYoTYWE5rNLjWDGmqHDd022KrfNv7cY6uWqDdVvhapJJwalxBpuw1tMm/SQnOg7Hjv6PQfP3PbVTSeog4x9jl3jzVgYHeYPXJuP1DZJ20ttWYp08T3AoxL9u00kaKIUi6V+jw9UoEIRU6wmIA3vqfRPXD6hOlRf7A3vW8RmxTqy0WmXNyj0BKQKJZdL3zBPQHWqepHWxe4j4OKIRJuDXPG6NqQQsGQEe2rY0QbGh6ANyWed3uBNWnTreRQAZl+8gjL1TffIm/jOn/XLAyZDCsbJ5qifMNKETf6gDrzpkgcCM9GnG/CIIkqhX7wHv7kHj8CBlVaTIIvLaaFtdaL5OCwa5VdiTa85BxkPLLAluOPVFyVDmBNnLo8bNwdiZypdNksmmE/jZ9nZFUp9mL+/Qjv3tftD45RXCZGKeiKOCpEi6FmJTIIUxDk0tOxRiRlW9lEHe3ytkohf4VhYlXpsBReBFk0prBcyqBz6j5ogX2eP+xARo3hMzLPYqJxV4vFpvPdbg9i6SBCHPCOW6zUFVX6nhZBVnksihSECBuQtCTthv9ui/BYK2zxuewxMLdPCQD8NfvCaqEPVey5UvUa4Sygl9MabYmWslc23H3nZXmMhYnfhbtUeZ1WQeATCwl0NwRZxttewnyZ7vN1mrHu03wg3XSWGe1ulKIP6dx
 PMtVNWaN
 LRtHctZBpSqPQXDkucIQfnstNJkSXaHL+HF/dw06Wus62bf66xFnUiBuLqzU4JL4U5cAehEcM7tjHJ5XPnpMVyYHRbh9YJ1fKipD8ZeCWPOBIjQIcH4IrbU0Lkjl5jErc+/9Fk8hlHNpL/7LudJ5RV5WmI+ny2J7xauL7u4v/AO4AnaFttMeQq7tFU3ENVUT7a5mijUI8bcOmTo2tTj2uw1CAMRz8S6KyVnqLwbkoe5zrvGSr+lq9+UK861zZweVM0zzxejet3JLyiEaacMB4TEz8d0aycnuBguWQvtm01toSBbsJTVjxB5szbaM7mVP8d2YGpCyHEyPXVwG9Oa6dDnHfMLJ4Q38YbvhmdL83snAzrq0WXKEv1UTiXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add alloc_flags as a new field to the slab_alloc_context helper struct,
so we can pass it to more functions in the slab implementation without
adding another function parameter.

Start checking them via alloc_flags_allow_spinning() in
alloc_single_from_new_slab() (where we can drop the allow_spin
parameter), ___slab_alloc(), get_from_partial_node() and
get_from_any_partial(). This further reduces false-positive
spinning-not-allowed from allocations that are not kmalloc_nolock() but
lack __GFP_RECLAIM flags.

_kmalloc_nolock_noprof() initializes ac.alloc_flags using its flags that
are SLAB_ALLOC_NOLOCK. slab_alloc_node() and __kmem_cache_alloc_bulk()
are not reachable from kmalloc_nolock() and all their callers expect
spinning to be allowed, so they can use SLAB_ALLOC_DEFAULT. This is
temporary as the scope of slab_alloc_context will further move to the
callers, making the alloc_flags usage more obvious.

Also change how trynode_flags are constructed in ___slab_alloc() to
achieve the same "do not upgrade to GFP_NOWAIT" by using masking instead
of checking allow_spin. We need to do that because we now determine
allow_spin from alloc_flags, and would otherwise start to upgrade e.g.
kmalloc() allocations without __GFP_KSWAPD_RECLAIM (that however do
allow spinning) to GFP_NOWAIT, thus including __GFP_KSWAPD_RECLAIM.

During the masking keep also existing __GFP_NOMEMALLOC (pointed out by
Sashiko) and __GFP_ACCOUNT. Previously the hardcoded GFP_NOWAIT would
eliminate them, but it's not a big problem that would need a separate
fix.

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-6-7190909db118@kernel.org
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 28 +++++++++++++++-------------
 1 file changed, 15 insertions(+), 13 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 6f6c15d796e1..3a34907b881b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -217,6 +217,7 @@ static DEFINE_STATIC_KEY_FALSE(strict_numa);
 struct slab_alloc_context {
 	unsigned long caller_addr;
 	size_t orig_size;
+	unsigned int alloc_flags;
 };
 
 /* Structure holding parameters for get_partial_node_bulk() */
@@ -3687,9 +3688,9 @@ static inline void init_slab_obj_iter(struct kmem_cache *s, struct slab *slab,
  * and put the slab to the partial (or full) list.
  */
 static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
-					const struct slab_alloc_context *ac,
-					bool allow_spin)
+					const struct slab_alloc_context *ac)
 {
+	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
 	struct kmem_cache_node *n;
 	struct slab_obj_iter iter;
 	bool needs_add_partial;
@@ -3835,7 +3836,7 @@ static void *get_from_partial_node(struct kmem_cache *s,
 	if (!n || !n->nr_partial)
 		return NULL;
 
-	if (gfpflags_allow_spinning(gfp_flags))
+	if (alloc_flags_allow_spinning(ac->alloc_flags))
 		spin_lock_irqsave(&n->list_lock, flags);
 	else if (!spin_trylock_irqsave(&n->list_lock, flags))
 		return NULL;
@@ -3891,7 +3892,7 @@ static void *get_from_any_partial(struct kmem_cache *s, gfp_t gfp_flags,
 	struct zone *zone;
 	enum zone_type highest_zoneidx = gfp_zone(gfp_flags);
 	unsigned int cpuset_mems_cookie;
-	bool allow_spin = gfpflags_allow_spinning(gfp_flags);
+	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
 
 	/*
 	 * The defrag ratio allows a configuration of the tradeoffs between
@@ -4449,7 +4450,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 			   const struct slab_alloc_context *ac)
 {
-	bool allow_spin = gfpflags_allow_spinning(gfpflags);
+	bool allow_spin = alloc_flags_allow_spinning(ac->alloc_flags);
 	gfp_t trynode_flags;
 	void *object;
 	struct slab *slab;
@@ -4466,18 +4467,15 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	 * 1) try to get a partial slab from target node only by having
 	 *    __GFP_THISNODE in trynode_flags for get_from_partial()
 	 * 2) if 1) failed, try to allocate a new slab from target node with
-	 *    GPF_NOWAIT | __GFP_THISNODE opportunistically
+	 *    (at most) GFP_NOWAIT | __GFP_THISNODE opportunistically
 	 * 3) if 2) failed, retry with original gfpflags which will allow
 	 *    get_from_partial() try partial lists of other nodes before
 	 *    potentially allocating new page from other nodes
 	 */
 	if (unlikely(node != NUMA_NO_NODE && !(gfpflags & __GFP_THISNODE)
 		     && try_thisnode)) {
-		if (unlikely(!allow_spin))
-			/* Do not upgrade gfp to NOWAIT from more restrictive mode */
-			trynode_flags = gfpflags | __GFP_THISNODE;
-		else
-			trynode_flags = GFP_NOWAIT | __GFP_THISNODE;
+		trynode_flags &= GFP_NOWAIT | __GFP_NOMEMALLOC | __GFP_ACCOUNT;
+		trynode_flags |= __GFP_NOWARN | __GFP_THISNODE;
 	}
 
 	object = get_from_partial(s, node, trynode_flags, ac);
@@ -4499,7 +4497,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	stat(s, ALLOC_SLAB);
 
 	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
-		object = alloc_single_from_new_slab(s, slab, ac, allow_spin);
+		object = alloc_single_from_new_slab(s, slab, ac);
 
 		if (likely(object))
 			goto success;
@@ -4918,6 +4916,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
 static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list_lru *lru,
 		gfp_t gfpflags, int node, unsigned long addr, size_t orig_size)
 {
+	const unsigned int alloc_flags = SLAB_ALLOC_DEFAULT;
 	void *object;
 
 	s = slab_pre_alloc_hook(s, gfpflags);
@@ -4928,12 +4927,13 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	if (unlikely(object))
 		goto out;
 
-	object = alloc_from_pcs(s, gfpflags, SLAB_ALLOC_DEFAULT, node);
+	object = alloc_from_pcs(s, gfpflags, alloc_flags, node);
 
 	if (unlikely(!object)) {
 		const struct slab_alloc_context ac = {
 			.caller_addr = addr,
 			.orig_size = orig_size,
+			.alloc_flags = alloc_flags,
 		};
 		object = __slab_alloc_node(s, gfpflags, node, &ac);
 	}
@@ -5366,6 +5366,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	const struct slab_alloc_context ac = {
 		.caller_addr = _RET_IP_,
 		.orig_size = orig_size,
+		.alloc_flags = alloc_flags,
 	};
 
 	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
@@ -7254,6 +7255,7 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
 		const struct slab_alloc_context ac = {
 			.caller_addr = _RET_IP_,
 			.orig_size = s->object_size,
+			.alloc_flags = SLAB_ALLOC_DEFAULT,
 		};
 		for (i = 0; i < size; i++) {
 

-- 
2.54.0


