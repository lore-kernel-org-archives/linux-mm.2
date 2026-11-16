Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E07606A881
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 06:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OxQZ8ymP
Received: by kanga.kvack.org (Postfix)
	id 33C496B05C0; Mon, 16 Nov 2026 01:47:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2ED8C6B05C1; Mon, 16 Nov 2026 01:47:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22AE16B05C2; Mon, 16 Nov 2026 01:47:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 004C16B05C0
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 01:47:46 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 82D8A1A08D2
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:46 +0000 (UTC)
X-FDA: 85440051732.16.70E0783
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id CC079120006
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:47:44 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OxQZ8ymP;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794811665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A0jsr7g2iSKz4FF1WHoUtFHP+lNGXLioda8TcNBixqg=;
	b=YNm/UCl1CCtFKk09G/GCDm0f41WrwMdXP2g4ZS5cRTi1qvxdPfzsgOoufjZ5qScs4/jHOO
	M6vtK9XVSDPtX4A29Bb+pn/P3bIxsnbL6NvXkA+D3T5ofJ3s5e6bcI9J17ALS6GF+scDct
	6BMv8UDvK2aVmicDpzQJrDcJBgLJi5c=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794811665;
	b=QDzXPlZ9PFIuzIt3665aZcG7TFNsbbfb52mKhUSPBDANJ8Fua0IBmK+pnSgKhKwOs0gJ2R
	H0jKWJVOxCbJQmwsn063PxVHk8bBiJNZX9V6n2ByCJCi9GCpmxVX7wB55ElSLQug0Z/5Nl
	mLp7YOf/pl/A03XYdgZAR0slWc9hDHc=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OxQZ8ymP;
	spf=pass (imf29.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3A91740D75;
	Mon, 16 Nov 2026 06:47:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA44E1F000C4;
	Mon, 16 Nov 2026 06:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794811664;
	bh=A0jsr7g2iSKz4FF1WHoUtFHP+lNGXLioda8TcNBixqg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=OxQZ8ymPPuHVIDSG4ZXqY7UoU8UbImdtL+5nrdFyLMXXb0ccGHWVyFEixEJxsCCC4
	 ORoxmUJYTXthFH/IWchiclTXNAIU5vzLCfN1ZKZpeNzYBD6KEonGBlW+V9E0lWQ8kY
	 KUbdMQO4k9+ru7fNwsbaxpileXUF1aw920l0R3p1CfDcP1jwOECHpRg7zM8ohXvxGw
	 uPFPy1qiC8Jv/GSqIFW8Fh1TiPfPbuw/9lJtyz0FAq6aVQcZ73Msych8G+24k4KEB/
	 RxphZbEEUVq6ZIRDTvdfbEztPduP2oVRNnGR/3/c0fkGT8k3KBguqNSiLs0Km5VB1t
	 MZeLGGp9Y7rjw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 16 Nov 2026 07:47:15 +0100
Subject: [PATCH v4 07/10] mm, slab: convert CONFIG_SLUB_TINY checks to
 kmem_cache_debug()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261116-slub_tiny_rework-v4-7-227a4b3636a5@kernel.org>
References: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
In-Reply-To: <20261116-slub_tiny_rework-v4-0-227a4b3636a5@kernel.org>
To: Harry Yoo <harry@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: bsokgtcy68o1mks8bwnccmb3yuzgaf51
X-Rspamd-Queue-Id: CC079120006
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794811664-244362
X-HE-Meta: U2FsdGVkX1/AYfIX2udjFX+dn/cA58ySPSIZWcAVROvMDI2JQdxBKzgBNFwk+9ST75YnP+HNELQHvpFKgXNvvdtIBHNTYKRcd4oOPQMEGzFUxQui0YbeacASgQuNl88Vq6sIGmnlvbjB00+tcBZZQba9wTuyb2KK2i68grstW0A4A+Zw5121lA73xWcJHKirIO2nrb4ogXSnyURLBksLrDn2UC6Wz576V3sVLZl/BHtyygyXGYnqyxBxJ2N54Toj0ST1bLp+gJore2RtgXhj/FSdUwORAbyC3SO50quvO4V9ro8LGOiSP5jk4bhm1vvQ1eygx48AG38snwXLA/G2BjPvd5t/UUEUnvoPatUyWcm65JXy/Y1MuSwfsmyK1cu8tn1X2aZqtn37xShYISXjQGY7ZjijiFjntopZPr1LaoEf0KqrJ9p3x4LiGBaSrfMavbNujWu5UEPclob0Lm8YEbx0kZ09nNOdqHoGlo3BqLLr4QmTUYeID1JKWWOYYHAWOPkUSjHnvBVJmjLD+vev05os48KDnxbxusAK3QiZJkkW/D8dHXf/zonFD1kJNzYB/7gfFhYu+cr+FE/xN0Hh+PgurDtVHZYvMmmNax+BQRWptYj6I3+U7neQ9SVIutCKyPHKZYHbxXC112MeygEGGNb/KHwIa8tA8NkfhG8t3nVq16iqyNtLiBj/a8G1JtsM5B3n3H3A4lqJr2i1GiGtfLbB5hyl37ZhmjF1LpBAjzKul4J39O0tt/ejk8yQ3ss7pR0AJgAflmA483yJx92Vt+RvX63nmfqMad8rrSDFaJDulJXMt7n0MUOtc8cJigJ910MkFQqjEePTDZgZKGQmNLLrws8eti6sk6v+sQGClWgti1BgoTvXfrNtFNU04eY3Y2lbHIQOxCZDiJpmWUgz0OEAPovZEqt/AOp9zqUknokX1yZ96p4Yt2L77fHxUOzHkFT7cZ+PHchbJ1WmhT4
 AFIJJjlR
 NEW+O/3zE1IFn9UZCgFqAvisAhbtqJalTVUr+cwZWzmdp8YsImaTmkIyhtPjpIfO1ZOjPuheiE1buF194v8LCicExpUsW8NJy7+qYyr3d2XzhIUq8Cum+LIJK4E/YLeiEChpvixzmRVsIAN9LG23YU6Y4DKZWb07QIQ0mBPVYBCZ8sYfONTmCxGloU41dIYd7CHVDoMgTmG4NLu77NP1nXgJxdm4dBOz2u1+3trdhQquFEMWtcELlJpf1dZabCrOz4Vnnvg96jGlgROc413JG6HBevqHpyJF5uV1L8mLuNAIYRiq99rjEc6tjOvmE50/QZ0jHbKZ7N/KYSMT1opWBoXEDb08XosiRMSXacfIr8GL0pXMRGP/Qh/RU4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CONFIG_SLUB_TINY shares several slowpaths with debugging as both of them
avoid percpu caching of objects. With the goal of replacing the config
with a boot-time decision, extend this sharing by hooking
slab_tiny_enabled into kmem_cache_debug() check itself.

This is made possible by the new SLAB_DEBUG_NOOP debug flag. Make
slub_debug_enabled static key always available (not just with
CONFIG_SLUB_DEBUG enabled) and have slab_tiny_enabled add
SLAB_DEBUG_NOOP to all caches in kmem_cache_flags(). Do this also in the
CONFIG_SLUB_DEBUG variant, which is currently exclusive with
CONFIG_SLUB_TINY, but that will be lifted later.

Remove the various IS_ENABLED(CONFIG_SLUB_TINY) checks that
complement kmem_cache_debug() checks as they are no longer necessary.

While removing/adjusting the CONFIG_SLUB_DEBUG #ifdefs, also convert
CONFIG_SLUB_DEBUG_ON to *_STATIC_KEY_MAYBE().

Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 18 ++++++------------
 mm/slub.c | 38 ++++++++++++++++++--------------------
 2 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 835d977634ec..7ea057fda751 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -506,26 +506,20 @@ struct slabinfo {
 
 void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo);
 
-#ifdef CONFIG_SLUB_DEBUG
-#ifdef CONFIG_SLUB_DEBUG_ON
-DECLARE_STATIC_KEY_TRUE(slub_debug_enabled);
-#else
-DECLARE_STATIC_KEY_FALSE(slub_debug_enabled);
-#endif
-extern void print_tracking(struct kmem_cache *s, void *object);
-long validate_slab_cache(struct kmem_cache *s);
+DECLARE_STATIC_KEY_MAYBE(CONFIG_SLUB_DEBUG_ON, slub_debug_enabled);
+
 static inline bool __slub_debug_enabled(void)
 {
 	return static_branch_unlikely(&slub_debug_enabled);
 }
+
+#ifdef CONFIG_SLUB_DEBUG
+extern void print_tracking(struct kmem_cache *s, void *object);
+long validate_slab_cache(struct kmem_cache *s);
 #else
 static inline void print_tracking(struct kmem_cache *s, void *object)
 {
 }
-static inline bool __slub_debug_enabled(void)
-{
-	return false;
-}
 #endif
 
 /*
diff --git a/mm/slub.c b/mm/slub.c
index 9bd16e04ea24..ac9dcb4682fb 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -202,13 +202,7 @@ enum slab_flags {
 #define __fastpath_inline
 #endif
 
-#ifdef CONFIG_SLUB_DEBUG
-#ifdef CONFIG_SLUB_DEBUG_ON
-DEFINE_STATIC_KEY_TRUE(slub_debug_enabled);
-#else
-DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
-#endif
-#endif		/* CONFIG_SLUB_DEBUG */
+DEFINE_STATIC_KEY_MAYBE(CONFIG_SLUB_DEBUG_ON, slub_debug_enabled);
 
 #ifdef CONFIG_NUMA
 static DEFINE_STATIC_KEY_FALSE(strict_numa);
@@ -1041,11 +1035,7 @@ static inline void *restore_red_left(struct kmem_cache *s, void *p)
 /*
  * Debug settings:
  */
-#if defined(CONFIG_SLUB_DEBUG_ON)
-static slab_flags_t slub_debug = DEBUG_DEFAULT_FLAGS;
-#else
-static slab_flags_t slub_debug;
-#endif
+static slab_flags_t slub_debug = IS_ENABLED(CONFIG_SLUB_DEBUG_ON) ? DEBUG_DEFAULT_FLAGS : 0;
 
 static const char *slub_debug_string __ro_after_init;
 static int disable_higher_order_debug;
@@ -2032,6 +2022,9 @@ slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name)
 	slab_flags_t block_flags;
 	slab_flags_t slub_debug_local = slub_debug;
 
+	if (slab_tiny_enabled)
+		flags |= SLAB_DEBUG_NOOP;
+
 	if (flags & SLAB_NO_USER_FLAGS)
 		return flags;
 
@@ -2104,6 +2097,9 @@ static inline void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
 					struct slab *slab) {}
 slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name)
 {
+	if (slab_tiny_enabled)
+		flags |= SLAB_DEBUG_NOOP;
+
 	return flags;
 }
 #define slub_debug 0
@@ -3964,7 +3960,7 @@ static void *get_from_partial_node(struct kmem_cache *s,
 		if (!pfmemalloc_match(slab, gfp_flags))
 			continue;
 
-		if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+		if (kmem_cache_debug(s)) {
 			object = alloc_single_from_partial(s, n, slab,
 							ac->orig_size);
 			if (object)
@@ -4578,7 +4574,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 
 /*
  * Slow path. We failed to allocate via percpu sheaves or they are not available
- * due to bootstrap or debugging enabled or SLUB_TINY.
+ * due to bootstrap or debugging enabled.
  *
  * We try to allocate from partial slab lists and fall back to allocating a new
  * slab.
@@ -4632,7 +4628,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	stat(s, ALLOC_SLAB);
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+	if (kmem_cache_debug(s)) {
 		object = alloc_single_from_new_slab(s, slab, ac);
 
 		if (likely(object))
@@ -5861,7 +5857,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 	unsigned long flags;
 	bool on_node_partial;
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+	if (kmem_cache_debug(s)) {
 		free_to_partial_list(s, slab, head, tail, cnt, addr);
 		return;
 	}
@@ -7573,7 +7569,7 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
 {
 	int i;
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+	if (kmem_cache_debug(s)) {
 		const struct slab_alloc_context ac = {
 			.caller_addr = _RET_IP_,
 			.orig_size = s->object_size,
@@ -7874,7 +7870,7 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 		 * cache.
 		 *
 		 * We keep bootstrap_sheaf for kmem_cache and kmem_cache_node,
-		 * caches with debug enabled, and all caches with SLUB_TINY.
+		 * and caches with debugging enabled.
 		 * For kmalloc caches it's used temporarily during the initial
 		 * bootstrap.
 		 */
@@ -8691,7 +8687,7 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 
 	capacity = calculate_sheaf_capacity(s, &empty_args);
 
-	/* capacity can be 0 due to debugging or SLUB_TINY */
+	/* capacity can be 0 due to debugging */
 	if (!capacity)
 		return;
 
@@ -8757,8 +8753,10 @@ void __init kmem_cache_init(void)
 
 	slab_obj_ext_has_codetag_init();
 
-	if (slab_tiny_enabled)
+	if (slab_tiny_enabled) {
 		slab_max_order = 1;
+		static_branch_enable(&slub_debug_enabled);
+	}
 
 	if (slab_max_order_param <= MAX_PAGE_ORDER)
 		slab_max_order = slab_max_order_param;

-- 
2.56.0


