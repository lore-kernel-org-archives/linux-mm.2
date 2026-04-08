Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EFB110F9951
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 15:28:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2E8E56B0005; Wed,  8 Apr 2026 11:28:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 299A86B0089; Wed,  8 Apr 2026 11:28:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1881E6B008A; Wed,  8 Apr 2026 11:28:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 039176B0005
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 11:28:34 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 37332138FB2
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:28:34 +0000 (UTC)
X-FDA: 84635770548.08.802BF13
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf22.hostedemail.com (Postfix) with ESMTP id 92AC5C0009
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 15:28:30 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	spf=pass (imf22.hostedemail.com: domain of hu.shengming@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn;
	dmarc=pass (policy=none) header.from=zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775662112; a=rsa-sha256;
	cv=none;
	b=fl4V5TlIP8zHcDQntJcYzblVVHPFKEGj7mXksl77aHmSzk7Q5Apx4xdnjkDJd+YwEbztlv
	ZO9+qOVbxh1Ws0CzoJSm2VUVlcRlZYOGkOGBQXcJkQ5DHr35ulV/vTxBCSl/GBjha7xUlo
	ht+nuYZlxs8HQpjOhWwEATyt76Dexv8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775662112;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=4r1pkhybbIxxBHSqIaEOBkYaWCgZ+DEnPSOsuIgyTC4=;
	b=g66OphoZ4WE+OFlH6jK/A91Q+hBETECQEPjLYc2VW77KC9r+1CR+IhUZB0vhVYQWcm/RDy
	SK2vVGOdLN4LPon4UHo3neCA2RSE4fnxwQSgBmcQ83g4T38TtC3N8591Zr3fFPK9cMttoK
	r5jmuwyfVWmENTeimLXBJlEK/mpY9ng=
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4frRm31Y6Jz4xQYJ;
	Wed, 08 Apr 2026 23:28:19 +0800 (CST)
Received: from xaxapp04.zte.com.cn ([10.99.98.157])
	by mse-fl2.zte.com.cn with SMTP id 638FSGhE021381;
	Wed, 8 Apr 2026 23:28:16 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp02[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 8 Apr 2026 23:28:18 +0800 (CST)
X-Zmail-TransId: 2afa69d67412d93-95c86
X-Mailer: Zmail v1.0
Message-ID: <2026040823281824773ybHpC3kgUhR9OE1rGTl@zte.com.cn>
Date: Wed, 8 Apr 2026 23:28:18 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <xu.xin16@zte.com.cn>, <yang.tao172@zte.com.cn>,
        <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY0XSBtbS9zbHViOiBkZWZlciBmcmVlbGlzdCBjb25zdHJ1Y3Rpb24gdW50aWwgYWZ0ZXIgYnVsayBhbGxvY2F0aW9uIGZyb20gYSBuZXcgc2xhYg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 638FSGhE021381
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.133 unknown Wed, 08 Apr 2026 23:28:19 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69D67413.001/4frRm31Y6Jz4xQYJ
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 92AC5C0009
X-Stat-Signature: erwpqsrnsw3queo1aik8o163e39ii36f
X-Rspam-User: 
X-HE-Tag: 1775662110-373163
X-HE-Meta: U2FsdGVkX1/r0wNI8otS8iArN8TimZ7uSyO0P/gR4mOgfwU3u6Wh7HmhIqtzvxB+dlQ4xZslGvf9HO4hQuA3aHswNOnKNayggk6QybWNL3EkCdZjy69WFPudo2SYWHOMRCs7eQViKRlw2KJadxmrA0uPywHJ5GRzwCnvA5lTL5oxssIv+xhPByBHJ+LFXUVJ+QPjVPhOthxTLUagggFCFqbv9z4FgG57xhIMPeudD4y31TronI7hQLOxJMhoqABy9hEqJhowN23QWFALXCbPHx13I0WjYideEZaaJ/DQtEcJWUUtMwkTcMW/0qDgMO2F4Xd6FhgxzizM9ZXiELjEN1NGyCuXIhKmQPvXK4Ia/2+v+dt2QVYqHkxLG6BOHRqp2wyIOeHFA0G2WYsxkMMKNVpvFDeJPmpw5gs1L9ZHioEcOqhXYr9HKJMTi/lDixJtHwth4wiScCKs4AAJMzCWeXjwuaNR0amQSevxKmOMd0xLytt0k1o722SVV0a9QXa2jlnfps8FI4TmxnNL/IthKB3qLg/yUvb+pPCImSbUOOk6MV+BDa7r5R+KCmPBNTseuQ87+Tb3LYl6M2m6fgHOFtTHa5DRZUiK6mS1nPf2BTX/KmkDQ6Sw/L+hk+ihUZ3QMjGUL3lzYNzlcL4qi5NPoqAgjae8g32f0H1nTMs6Nm0EPNKxcs32s+aR9sHDORht8xCzQc0g0+V8W7Ng6iXWaxjmHBsiCT6gshZjKAgcYPiK9V2XhGpFeugx1Pl2+TTb4iYBSdlY5My+kfhEek/NCukE4sCa7LrP+j7QwmSGelCyL3jggQf3bZ2VGyQyOEb+YaEfcIellWtM/6F/M8WpJJCA+HQ2UvSJuwNPR41XMzXsyCa/ymakzWIcOlUy5fCtFz1/L2y11FfKe6Gb/jQMRnpUXDhVwhfiLaubNeedv479brPpgLmEKhbh7KFhLwssFzpuYTvQ6EMl8goLnyN
 hk9Pig4P
 +9HzVZbRY9Sx0mmSOm7QMbWTYTnmH2CJpTz8tspqgXr/2vibZOLClh2SxctcuPvGHK6s62lbbLSnQvckwfND+/OID/CLlF/1yRQFhh9rI4hvFBLISYHUbV2C0ia6lAix3x8oivjQlkMhZ4Ie7Wgdur9m8MlCdVpxlDdH8/scndewLs5ng7oxiUC3N/Fs0D0E0zuSIcy6VTOJ6QJyUJspHiK5MVsvu2/ogm94e3Iej0Q0WAPALgtYlag6Gtnxmf6JM7BPfcbW/B8T9ugUYmifnpLzoeFPZke575K0gmsoLYBm9xDw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shengming Hu <hu.shengming@zte.com.cn>

Allocations from a fresh slab can consume all of its objects, and the
freelist built during slab allocation is discarded immediately as a result.

Instead of special-casing the whole-slab bulk refill case, defer freelist
construction until after objects are emitted from a fresh slab.
new_slab() now only allocates the slab and initializes its metadata.
refill_objects() then obtains a fresh slab and lets alloc_from_new_slab()
emit objects directly, building a freelist only for the objects left
unallocated; the same change is applied to alloc_single_from_new_slab().

To keep CONFIG_SLAB_FREELIST_RANDOM=y/n on the same path, introduce a
small iterator abstraction for walking free objects in allocation order.
The iterator is used both for filling the sheaf and for building the
freelist of the remaining objects.

Also mark setup_object() inline. After this optimization, the compiler no
longer consistently inlines this helper in the hot path, which can hurt
performance. Explicitly marking it inline restores the expected code
generation.

This reduces per-object overhead in bulk allocation paths and improves
allocation throughput significantly. In slub_bulk_bench, the time per
object drops by about 35% to 72% with CONFIG_SLAB_FREELIST_RANDOM=n, and
by about 60% to 71% with CONFIG_SLAB_FREELIST_RANDOM=y.

Benchmark results (slub_bulk_bench):

Machine: qemu-system-x86 -m 1024M -smp 8 -enable-kvm -cpu host
Kernel: Linux 7.0.0-rc7-next-20260407
Config: x86_64_defconfig
Cpu: 0
Rounds: 20
Total: 256MB

- CONFIG_SLAB_FREELIST_RANDOM=n -

obj_size=16, batch=256:
before: 4.72 +- 0.03 ns/object
after: 3.06 +- 0.03 ns/object
delta: -35.1%

obj_size=32, batch=128:
before: 6.69 +- 0.04 ns/object
after: 3.51 +- 0.06 ns/object
delta: -47.6%

obj_size=64, batch=64:
before: 10.48 +- 0.06 ns/object
after: 4.23 +- 0.07 ns/object
delta: -59.7%

obj_size=128, batch=32:
before: 18.31 +- 0.12 ns/object
after: 5.67 +- 0.13 ns/object
delta: -69.0%

obj_size=256, batch=32:
before: 21.59 +- 0.13 ns/object
after: 6.05 +- 0.14 ns/object
delta: -72.0%

obj_size=512, batch=32:
before: 19.44 +- 0.14 ns/object
after: 6.23 +- 0.13 ns/object
delta: -67.9%

- CONFIG_SLAB_FREELIST_RANDOM=y -

obj_size=16, batch=256:
before: 8.71 +- 0.31 ns/object
after: 3.44 +- 0.03 ns/object
delta: -60.5%

obj_size=32, batch=128:
before: 11.11 +- 0.12 ns/object
after: 4.00 +- 0.04 ns/object
delta: -64.0%

obj_size=64, batch=64:
before: 15.27 +- 0.32 ns/object
after: 5.10 +- 0.13 ns/object
delta: -66.6%

obj_size=128, batch=32:
before: 21.49 +- 0.23 ns/object
after: 6.93 +- 0.20 ns/object
delta: -67.8%

obj_size=256, batch=32:
before: 26.23 +- 0.42 ns/object
after: 7.42 +- 0.20 ns/object
delta: -71.7%

obj_size=512, batch=32:
before: 26.44 +- 0.35 ns/object
after: 7.62 +- 0.27 ns/object
delta: -71.2%

Link: https://github.com/HSM6236/slub_bulk_test.git
Signed-off-by: Shengming Hu <hu.shengming@zte.com.cn>
---
Changes in v2:
- Handle CONFIG_SLAB_FREELIST_RANDOM=y and add benchmark results.
- Update the QEMU benchmark setup to use -enable-kvm -cpu host so benchmark results better reflect native CPU performance.
- Link to v1: https://lore.kernel.org/all/20260328125538341lvTGRpS62UNdRiAAz2gH3@zte.com.cn/

Changes in v3:
- refactor fresh-slab allocation to use a shared slab_obj_iter
- defer freelist construction until after bulk allocation from a new slab
- build a freelist only for leftover objects when the slab is left partial
- add build_slab_freelist(), prepare_slab_alloc_flags() and next_slab_obj() helpers
- remove obsolete freelist construction helpers now replaced by the iterator-based path, including next_freelist_entry() and shuffle_freelist()
- Link to v2: https://lore.kernel.org/all/202604011257259669oAdDsdnKx6twdafNZsF5@zte.com.cn/

Changes in v4:
- remove slab_obj_iter::cur
- drop prepare_slab_alloc_flags() and restore the original flag handling in new_slab()
- build a freelist only for the objects left unallocated in
  alloc_single_from_new_slab(), alloc_from_new_slab(), and
  early_kmem_cache_node_alloc()
- remove maybe_wipe_obj_freeptr() when allocating objects directly without freelist built
- Link to v3: https://lore.kernel.org/all/202604062150182836ygUiyPoKcxtHjgF7rWXe@zte.com.cn/

---
 mm/slab.h |  10 ++
 mm/slub.c | 278 +++++++++++++++++++++++++++---------------------------
 2 files changed, 149 insertions(+), 139 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index bf2f87acf5e3..ada3f9c3909f 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -91,6 +91,16 @@ struct slab {
 #endif
 };

+struct slab_obj_iter {
+	unsigned long pos;
+	void *start;
+#ifdef CONFIG_SLAB_FREELIST_RANDOM
+	unsigned long freelist_count;
+	unsigned long page_limit;
+	bool random;
+#endif
+};
+
 #define SLAB_MATCH(pg, sl)						\
 	static_assert(offsetof(struct page, pg) == offsetof(struct slab, sl))
 SLAB_MATCH(flags, flags);
diff --git a/mm/slub.c b/mm/slub.c
index 4927407c9699..67ec8b29f862 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2733,7 +2733,7 @@ bool slab_free_freelist_hook(struct kmem_cache *s, void **head, void **tail,
 	return *head != NULL;
 }

-static void *setup_object(struct kmem_cache *s, void *object)
+static inline void *setup_object(struct kmem_cache *s, void *object)
 {
 	setup_object_debug(s, object);
 	object = kasan_init_slab_obj(s, object);
@@ -3329,87 +3329,14 @@ static void __init init_freelist_randomization(void)
 	mutex_unlock(&slab_mutex);
 }

-/* Get the next entry on the pre-computed freelist randomized */
-static void *next_freelist_entry(struct kmem_cache *s,
-				unsigned long *pos, void *start,
-				unsigned long page_limit,
-				unsigned long freelist_count)
-{
-	unsigned int idx;
-
-	/*
-	 * If the target page allocation failed, the number of objects on the
-	 * page might be smaller than the usual size defined by the cache.
-	 */
-	do {
-		idx = s->random_seq[*pos];
-		*pos += 1;
-		if (*pos >= freelist_count)
-			*pos = 0;
-	} while (unlikely(idx >= page_limit));
-
-	return (char *)start + idx;
-}
-
 static DEFINE_PER_CPU(struct rnd_state, slab_rnd_state);

-/* Shuffle the single linked freelist based on a random pre-computed sequence */
-static bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
-			     bool allow_spin)
-{
-	void *start;
-	void *cur;
-	void *next;
-	unsigned long idx, pos, page_limit, freelist_count;
-
-	if (slab->objects < 2 || !s->random_seq)
-		return false;
-
-	freelist_count = oo_objects(s->oo);
-	if (allow_spin) {
-		pos = get_random_u32_below(freelist_count);
-	} else {
-		struct rnd_state *state;
-
-		/*
-		 * An interrupt or NMI handler might interrupt and change
-		 * the state in the middle, but that's safe.
-		 */
-		state = &get_cpu_var(slab_rnd_state);
-		pos = prandom_u32_state(state) % freelist_count;
-		put_cpu_var(slab_rnd_state);
-	}
-
-	page_limit = slab->objects * s->size;
-	start = fixup_red_left(s, slab_address(slab));
-
-	/* First entry is used as the base of the freelist */
-	cur = next_freelist_entry(s, &pos, start, page_limit, freelist_count);
-	cur = setup_object(s, cur);
-	slab->freelist = cur;
-
-	for (idx = 1; idx < slab->objects; idx++) {
-		next = next_freelist_entry(s, &pos, start, page_limit,
-			freelist_count);
-		next = setup_object(s, next);
-		set_freepointer(s, cur, next);
-		cur = next;
-	}
-	set_freepointer(s, cur, NULL);
-
-	return true;
-}
 #else
 static inline int init_cache_random_seq(struct kmem_cache *s)
 {
 	return 0;
 }
 static inline void init_freelist_randomization(void) { }
-static inline bool shuffle_freelist(struct kmem_cache *s, struct slab *slab,
-				    bool allow_spin)
-{
-	return false;
-}
 #endif /* CONFIG_SLAB_FREELIST_RANDOM */

 static __always_inline void account_slab(struct slab *slab, int order,
@@ -3438,15 +3365,14 @@ static __always_inline void unaccount_slab(struct slab *slab, int order,
 			    -(PAGE_SIZE << order));
 }

+/* Allocate and initialize a slab without building its freelist. */
 static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 {
 	bool allow_spin = gfpflags_allow_spinning(flags);
 	struct slab *slab;
 	struct kmem_cache_order_objects oo = s->oo;
 	gfp_t alloc_gfp;
-	void *start, *p, *next;
-	int idx;
-	bool shuffle;
+	void *start;

 	flags &= gfp_allowed_mask;

@@ -3483,6 +3409,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	slab->frozen = 0;

 	slab->slab_cache = s;
+	slab->freelist = NULL;

 	kasan_poison_slab(slab);

@@ -3497,21 +3424,6 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
 	alloc_slab_obj_exts_early(s, slab);
 	account_slab(slab, oo_order(oo), s, flags);

-	shuffle = shuffle_freelist(s, slab, allow_spin);
-
-	if (!shuffle) {
-		start = fixup_red_left(s, start);
-		start = setup_object(s, start);
-		slab->freelist = start;
-		for (idx = 0, p = start; idx < slab->objects - 1; idx++) {
-			next = p + s->size;
-			next = setup_object(s, next);
-			set_freepointer(s, p, next);
-			p = next;
-		}
-		set_freepointer(s, p, NULL);
-	}
-
 	return slab;
 }

@@ -3665,30 +3577,110 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
 	return object;
 }

+/* Return the next free object in allocation order. */
+static inline void *next_slab_obj(struct kmem_cache *s,
+				  struct slab_obj_iter *iter)
+{
+#ifdef CONFIG_SLAB_FREELIST_RANDOM
+	if (iter->random) {
+		unsigned long idx;
+
+		/*
+		 * If the target page allocation failed, the number of objects on the
+		 * page might be smaller than the usual size defined by the cache.
+		 */
+		do {
+			idx = s->random_seq[iter->pos];
+			iter->pos++;
+			if (iter->pos >= iter->freelist_count)
+				iter->pos = 0;
+		} while (unlikely(idx >= iter->page_limit));
+
+		return setup_object(s, (char *)iter->start + idx);
+	}
+#endif
+	return setup_object(s, (char *)iter->start + iter->pos++ * s->size);
+}
+
+/* Build a freelist from the objects not yet allocated from a fresh slab. */
+static inline void build_slab_freelist(struct kmem_cache *s, struct slab *slab,
+				       struct slab_obj_iter *iter)
+{
+	unsigned int nr = slab->objects - slab->inuse;
+	unsigned int i;
+	void *cur, *next;
+
+	if (!nr) {
+		slab->freelist = NULL;
+		return;
+	}
+
+	cur = next_slab_obj(s, iter);
+	slab->freelist = cur;
+
+	for (i = 1; i < nr; i++) {
+		next = next_slab_obj(s, iter);
+		set_freepointer(s, cur, next);
+		cur = next;
+	}
+
+	set_freepointer(s, cur, NULL);
+}
+
+/* Initialize an iterator over free objects in allocation order. */
+static inline void init_slab_obj_iter(struct kmem_cache *s, struct slab *slab,
+				      struct slab_obj_iter *iter,
+				      bool allow_spin)
+{
+	iter->pos = 0;
+	iter->start = fixup_red_left(s, slab_address(slab));
+
+#ifdef CONFIG_SLAB_FREELIST_RANDOM
+	iter->random = (slab->objects >= 2 && s->random_seq);
+	if (!iter->random)
+		return;
+
+	iter->freelist_count = oo_objects(s->oo);
+	iter->page_limit = slab->objects * s->size;
+
+	if (allow_spin) {
+		iter->pos = get_random_u32_below(iter->freelist_count);
+	} else {
+		struct rnd_state *state;
+
+		/*
+		 * An interrupt or NMI handler might interrupt and change
+		 * the state in the middle, but that's safe.
+		 */
+		state = &get_cpu_var(slab_rnd_state);
+		iter->pos = prandom_u32_state(state) % iter->freelist_count;
+		put_cpu_var(slab_rnd_state);
+	}
+#endif
+}
+
 /*
  * Called only for kmem_cache_debug() caches to allocate from a freshly
  * allocated slab. Allocate a single object instead of whole freelist
  * and put the slab to the partial (or full) list.
  */
 static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
-					int orig_size, gfp_t gfpflags)
+					int orig_size, bool allow_spin)
 {
-	bool allow_spin = gfpflags_allow_spinning(gfpflags);
-	int nid = slab_nid(slab);
-	struct kmem_cache_node *n = get_node(s, nid);
+	struct kmem_cache_node *n;
+	struct slab_obj_iter iter;
+	bool needs_add_partial;
 	unsigned long flags;
 	void *object;

-	if (!allow_spin && !spin_trylock_irqsave(&n->list_lock, flags)) {
-		/* Unlucky, discard newly allocated slab. */
-		free_new_slab_nolock(s, slab);
-		return NULL;
-	}
-
-	object = slab->freelist;
-	slab->freelist = get_freepointer(s, object);
+	init_slab_obj_iter(s, slab, &iter, allow_spin);
+	object = next_slab_obj(s, &iter);
 	slab->inuse = 1;

+	needs_add_partial = (slab->objects > 1);
+	if (needs_add_partial)
+		build_slab_freelist(s, slab, &iter);
+
 	if (!alloc_debug_processing(s, slab, object, orig_size)) {
 		/*
 		 * It's not really expected that this would fail on a
@@ -3696,22 +3688,30 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
 		 * corruption in theory could cause that.
 		 * Leak memory of allocated slab.
 		 */
-		if (!allow_spin)
-			spin_unlock_irqrestore(&n->list_lock, flags);
 		return NULL;
 	}

-	if (allow_spin)
+	n = get_node(s, slab_nid(slab));
+	if (allow_spin) {
 		spin_lock_irqsave(&n->list_lock, flags);
+	} else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
+		/*
+		 * Unlucky, discard newly allocated slab.
+		 * The slab is not fully free, but it's fine as
+		 * objects are not allocated to users.
+		 */
+		free_new_slab_nolock(s, slab);
+		return NULL;
+	}

-	if (slab->inuse == slab->objects)
-		add_full(s, n, slab);
-	else
+	if (needs_add_partial)
 		add_partial(n, slab, ADD_TO_HEAD);
+	else
+		add_full(s, n, slab);

-	inc_slabs_node(s, nid, slab->objects);
 	spin_unlock_irqrestore(&n->list_lock, flags);

+	inc_slabs_node(s, slab_nid(slab), slab->objects);
 	return object;
 }

@@ -4349,9 +4349,10 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 {
 	unsigned int allocated = 0;
 	struct kmem_cache_node *n;
+	struct slab_obj_iter iter;
 	bool needs_add_partial;
 	unsigned long flags;
-	void *object;
+	unsigned int target_inuse;

 	/*
 	 * Are we going to put the slab on the partial list?
@@ -4359,33 +4360,30 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 	 */
 	needs_add_partial = (slab->objects > count);

-	if (!allow_spin && needs_add_partial) {
-
-		n = get_node(s, slab_nid(slab));
-
-		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
-			/* Unlucky, discard newly allocated slab */
-			free_new_slab_nolock(s, slab);
-			return 0;
-		}
-	}
+	/* Target inuse count after allocating from this new slab. */
+	target_inuse = needs_add_partial ? count : slab->objects;

-	object = slab->freelist;
-	while (object && allocated < count) {
-		p[allocated] = object;
-		object = get_freepointer(s, object);
-		maybe_wipe_obj_freeptr(s, p[allocated]);
+	init_slab_obj_iter(s, slab, &iter, allow_spin);

-		slab->inuse++;
+	while (allocated < target_inuse) {
+		p[allocated] = next_slab_obj(s, &iter);
 		allocated++;
 	}
-	slab->freelist = object;
+	slab->inuse = target_inuse;

 	if (needs_add_partial) {
-
+		build_slab_freelist(s, slab, &iter);
+		n = get_node(s, slab_nid(slab));
 		if (allow_spin) {
-			n = get_node(s, slab_nid(slab));
 			spin_lock_irqsave(&n->list_lock, flags);
+		} else if (!spin_trylock_irqsave(&n->list_lock, flags)) {
+			/*
+			 * Unlucky, discard newly allocated slab.
+			 * The slab is not fully free, but it's fine as
+			 * objects are not allocated to users.
+			 */
+			free_new_slab_nolock(s, slab);
+			return 0;
 		}
 		add_partial(n, slab, ADD_TO_HEAD);
 		spin_unlock_irqrestore(&n->list_lock, flags);
@@ -4456,7 +4454,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	stat(s, ALLOC_SLAB);

 	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
-		object = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
+		object = alloc_single_from_new_slab(s, slab, orig_size, allow_spin);

 		if (likely(object))
 			goto success;
@@ -7251,10 +7249,6 @@ refill_objects(struct kmem_cache *s, void **p, gfp_t gfp, unsigned int min,

 	stat(s, ALLOC_SLAB);

-	/*
-	 * TODO: possible optimization - if we know we will consume the whole
-	 * slab we might skip creating the freelist?
-	 */
 	refilled += alloc_from_new_slab(s, slab, p + refilled, max - refilled,
 					/* allow_spin = */ true);

@@ -7585,6 +7579,7 @@ static void early_kmem_cache_node_alloc(int node)
 {
 	struct slab *slab;
 	struct kmem_cache_node *n;
+	struct slab_obj_iter iter;

 	BUG_ON(kmem_cache_node->size < sizeof(struct kmem_cache_node));

@@ -7596,14 +7591,19 @@ static void early_kmem_cache_node_alloc(int node)
 		pr_err("SLUB: Allocating a useless per node structure in order to be able to continue\n");
 	}

-	n = slab->freelist;
+	init_slab_obj_iter(kmem_cache_node, slab, &iter, true);
+
+	n = next_slab_obj(kmem_cache_node, &iter);
 	BUG_ON(!n);
+
+	slab->inuse = 1;
+	if (slab->objects > 1)
+		build_slab_freelist(kmem_cache_node, slab, &iter);
+
 #ifdef CONFIG_SLUB_DEBUG
 	init_object(kmem_cache_node, n, SLUB_RED_ACTIVE);
 #endif
 	n = kasan_slab_alloc(kmem_cache_node, n, GFP_KERNEL, false);
-	slab->freelist = get_freepointer(kmem_cache_node, n);
-	slab->inuse = 1;
 	kmem_cache_node->per_node[node].node = n;
 	init_kmem_cache_node(n);
 	inc_slabs_node(kmem_cache_node, node, slab->objects);
-- 
2.25.1

