Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BA45F34C5E
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:04:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DB9B6B008A; Mon, 13 Apr 2026 11:04:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B38F6B0092; Mon, 13 Apr 2026 11:04:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F0BA46B0093; Mon, 13 Apr 2026 11:04:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E00696B008A
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:04:31 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7B9011B6FA2
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:04:31 +0000 (UTC)
X-FDA: 84653853942.30.C6A5DBD
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 016D1C0008
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:04:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf10.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776092669; a=rsa-sha256;
	cv=none;
	b=itmoLzZgj+ZHCxZsdyCm/nAvOo3kJMffBgQiYR6mDkv/nedBixBV3a2PBdvEdIVuzRe5eP
	Wnbb6U4USm4dnK+/UFTXK2apALSFwEBVBCJcjhSLIWZ4UZMU+I8p9EXFKToRXkBvKz1s0a
	aO6ACzNDkSg19ATJ4CnI/rp3kePoI6I=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf10.hostedemail.com: domain of hu.shengming@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=hu.shengming@zte.com.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776092669;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references; bh=aGT96zNMCtmmY2A6+hyayzQz+EwMrdHqEe6mrYjSAAU=;
	b=Sf+fSDG7O52cGaVAoXN2iwrEOR22Uc6QM3rdq0U83vuq4bb03YPBeTkdW3Kg5QkDftk+HQ
	KfWlPK3CgSCBpTBVXaAED2xtXrx+N4CtmJM+2FHF5G6GLjHe8zIxkXN5GFYr4s+qtp6rSz
	Den+mX0RU1noIgKMJSgBHwcD31TktBs=
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4fvW081W8nz5B0rc;
	Mon, 13 Apr 2026 23:04:24 +0800 (CST)
Received: from xaxapp01.zte.com.cn ([10.88.99.176])
	by mse-fl1.zte.com.cn with SMTP id 63DF4Er0068597;
	Mon, 13 Apr 2026 23:04:14 +0800 (+08)
	(envelope-from hu.shengming@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Mon, 13 Apr 2026 23:04:17 +0800 (CST)
X-Zmail-TransId: 2af969dd05f1b57-a4d56
X-Mailer: Zmail v1.0
Message-ID: <20260413230417835rnfiEWduEx44lc3u4uR9_@zte.com.cn>
Date: Mon, 13 Apr 2026 23:04:17 +0800 (CST)
Mime-Version: 1.0
From: <hu.shengming@zte.com.cn>
To: <vbabka@kernel.org>, <harry@kernel.org>, <akpm@linux-foundation.org>
Cc: <hao.li@linux.dev>, <cl@gentwo.org>, <rientjes@google.com>,
        <roman.gushchin@linux.dev>, <linux-mm@kvack.org>,
        <linux-kernel@vger.kernel.org>, <zhang.run@zte.com.cn>,
        <xu.xin16@zte.com.cn>, <yang.tao172@zte.com.cn>,
        <yang.yang29@zte.com.cn>
Subject: =?UTF-8?B?W1BBVENIIHY2XSBtbS9zbHViOiBkZWZlciBmcmVlbGlzdCBjb25zdHJ1Y3Rpb24gdW50aWwgYWZ0ZXIgYnVsayBhbGxvY2F0aW9uIGZyb20gYSBuZXcgc2xhYg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 63DF4Er0068597
X-TLS: YES
X-SPF-DOMAIN: zte.com.cn
X-ENVELOPE-SENDER: hu.shengming@zte.com.cn
X-SPF: None
X-SOURCE-IP: 10.5.228.132 unknown Mon, 13 Apr 2026 23:04:24 +0800
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 69DD05F8.000/4fvW081W8nz5B0rc
X-Stat-Signature: a9q8c7oc59qz85ond4abtsw73oottm6i
X-Rspamd-Queue-Id: 016D1C0008
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1776092667-262165
X-HE-Meta: U2FsdGVkX1/dWModFee7EO2sd05tmq+3hJbp48Cjs2kJFwnByl2vMGrdgiILDdEgBfciDOZfZrlYRjN4B8HpjhhbaM2JkDO92LX9IzlBUVWyzG2vvhorJHcF3bmEelgaMoyRa3aqYLqnk7nzSYvuNeTzTWTGWeJFbjALDRAFg4r25wBc9IHks5g7B8TZXjyYvpvv+7bzmwhWRMeO+UzvJxqBNexbu573iHK7YgmhPJjmEprUOiTGON5HpMG8rWuQ4J+LT69fyLCjbcfavEGKhMsaNl5Tmdmm8YI3wsmMcNH1jn64iFn0pvvhPNJApqfbH7/NYJnectoCA6jUvtIU1V7Oj+oEck/WoJAb7UtCbafrzywjA/o2ghkRXoe3ggDOAoclnzACBAuEarU6yIP8tDVN0J20EvdKYSY8aXpl+N4W+XE2IZxkpZw3sP0OtrUBJWlpNfcW0wF7hr9nKnM2yrTyU1Vg6YBNwpsUulPwKYDHh7ZVzEi4cMH4Yx/8Ywd92u1doEIduqXI02jFW2VytJoB194QS9lVv7uk/avsNDZgeaPo0266Hff685N8TbPspNp/22Rmd1iJkoH3hm3t12Xp+/kw1Dh4DWkXCphM7x4gRpg9G09LpdACuXLPe4MZnB7FddLpEgNGj3hR2KNKpbOcoG9QU4KVmhpn0j1EzfxkYZeJ7jEm3Q4yOa/MaAIeHIVO5bYF7JhIYI/HK1UNfxIVItDUDauw8Af0mQAo+v0xfjzQTieWgvZ4rtvlqWK2mRIBUkJ6eqovWSkUFjlBV3ppZAhK67o9XbNme3OL+OR7dbjR6668WjsjcqxFuIs/MIN62ITgnmwZbNG7px2uk0lgw55qy4imtxKMXq/o/UV/PHVNSNDc72j9L60GxIuF26FZsyjbHEld/JUPxMSvdjGXNFOHjThXwP/CbnJUMYDr8n4/iUHRAJWSd65ox6I/j9X3puVyM6EsbkuPQXj
 ag1AjzVr
 Lq1CuNmsFsR6rFcJXCsMs6QKUJknL5m2jQ9ljRbEjYyilLWs16mE+jgz0y5sAnh0LyjFOUs40AKeKls6wqpSia31uerm0JZhs8krsUgt+oz85/fWJQIQqMUZYeKeGaG8EXY3ZGX2O9OwyU3SlHjoOHZlr4NEw0BR+SrwJMGzvN5A0I2uN19E6i6QUvQGcHDTp+m72eoSpqsWobeNH726foDKm9OIRLtjwMYfXkC8sAslSEkv3sWZSaFUObJCT4IWi/y9RT1Bmy0YzyJDnC14VTC9ETIv0UhrEtYoYFmEQk1wdw1Q=
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

This reduces per-object overhead when allocating from a fresh slab.
The most direct benefit is in the paths that allocate objects first and
only build a freelist for the remainder afterward: bulk allocation from
a new slab in refill_objects(), single-object allocation from a new slab
in ___slab_alloc(), and the corresponding early-boot paths that now use
the same deferred-freelist scheme. Since refill_objects() is also used to
refill sheaves, the optimization is not limited to the small set of
kmem_cache_alloc_bulk()/kmem_cache_free_bulk() users; regular allocation
workloads may benefit as well when they refill from a fresh slab.

In slub_bulk_bench, the time per object drops by about 32% to 70% with
CONFIG_SLAB_FREELIST_RANDOM=n, and by about 50% to 67% with
CONFIG_SLAB_FREELIST_RANDOM=y. This benchmark is intended to isolate the
cost removed by this change: each iteration allocates exactly
slab->objects from a fresh slab. That makes it a near best-case scenario
for deferred freelist construction, because the old path still built a
full freelist even when no objects remained, while the new path avoids
that work. Realistic workloads may see smaller end-to-end gains depending
on how often allocations reach this fresh-slab refill path.

Benchmark results (slub_bulk_bench):
Machine: qemu-system-x86 -m 1024M -smp 8 -enable-kvm -cpu host
Kernel: Linux 7.0.0-rc7-next-20260407
Config: x86_64_defconfig
Cpu: 0
Rounds: 20
Total: 256MB

- CONFIG_SLAB_FREELIST_RANDOM=n -

obj_size=16, batch=256:
before: 4.91 +- 0.07 ns/object
after: 3.29 +- 0.03 ns/object
delta: -32.8%

obj_size=32, batch=128:
before: 6.96 +- 0.07 ns/object
after: 3.73 +- 0.05 ns/object
delta: -46.4%

obj_size=64, batch=64:
before: 10.77 +- 0.12 ns/object
after: 4.65 +- 0.06 ns/object
delta: -56.8%

obj_size=128, batch=32:
before: 19.04 +- 0.22 ns/object
after: 6.30 +- 0.07 ns/object
delta: -66.9%

obj_size=256, batch=32:
before: 22.20 +- 0.26 ns/object
after: 6.68 +- 0.06 ns/object
delta: -69.9%

obj_size=512, batch=32:
before: 20.03 +- 0.62 ns/object
after: 6.83 +- 0.09 ns/object
delta: -65.9%

- CONFIG_SLAB_FREELIST_RANDOM=y -

obj_size=16, batch=256:
before: 8.72 +- 0.06 ns/object
after: 4.31 +- 0.05 ns/object
delta: -50.5%

obj_size=32, batch=128:
before: 11.29 +- 0.13 ns/object
after: 4.93 +- 0.05 ns/object
delta: -56.3%

obj_size=64, batch=64:
before: 15.36 +- 0.24 ns/object
after: 5.95 +- 0.10 ns/object
delta: -61.3%

obj_size=128, batch=32:
before: 21.75 +- 0.26 ns/object
after: 8.10 +- 0.14 ns/object
delta: -62.8%

obj_size=256, batch=32:
before: 26.62 +- 0.26 ns/object
after: 8.58 +- 0.22 ns/object
delta: -67.8%

obj_size=512, batch=32:
before: 26.88 +- 0.36 ns/object
after: 8.81 +- 0.11 ns/object
delta: -67.2%

Link: https://github.com/HSM6236/slub_bulk_test.git
Suggested-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Harry Yoo (Oracle) <harry@kernel.org>
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
- new_slab() no longer builds the freelist. Instead, the freelist is constructed only for the objects left unallocated in
  alloc_single_from_new_slab(), alloc_from_new_slab(), and early_kmem_cache_node_alloc().
- remove maybe_wipe_obj_freeptr() when allocating objects directly without freelist built
- Link to v3: https://lore.kernel.org/all/202604062150182836ygUiyPoKcxtHjgF7rWXe@zte.com.cn/

Changes in v5:
- Call build_slab_freelist() unconditionally, and remove the redundant "slab->freelist = NULL" initialization in allocate_slab().
- Check the return value of alloc_from_new_slab() to prevent a potential use-after-free bug.
- Refine the commit message with more precise test coverage descriptions.
- Link to v4: https://lore.kernel.org/all/2026040823281824773ybHpC3kgUhR9OE1rGTl@zte.com.cn/

Changes in v6:
- Move inc_slabs_node() back under n->list_lock in alloc_single_from_new_slab()
  to avoid races with slab validation for debug caches.
- Link to v5: https://lore.kernel.org/all/20260409204352095kKWVYKtZImN59ybO6iRNj@zte.com.cn/

---
 mm/slab.h |  10 ++
 mm/slub.c | 283 +++++++++++++++++++++++++++---------------------------
 2 files changed, 151 insertions(+), 142 deletions(-)

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
index 4927407c9699..e20c24a3d8c2 100644
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

@@ -3497,21 +3423,6 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags, int node)
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

@@ -3665,30 +3576,109 @@ static void *alloc_single_from_partial(struct kmem_cache *s,
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
+	build_slab_freelist(s, slab, &iter);
+
 	if (!alloc_debug_processing(s, slab, object, orig_size)) {
 		/*
 		 * It's not really expected that this would fail on a
@@ -3696,20 +3686,32 @@ static void *alloc_single_from_new_slab(struct kmem_cache *s, struct slab *slab,
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
+	/*
+	 * Debug caches require nr_slabs updates under n->list_lock so validation
+	 * cannot race with slab (de)allocations and observe inconsistent state.
+	 */
+	inc_slabs_node(s, slab_nid(slab), slab->objects);
 	spin_unlock_irqrestore(&n->list_lock, flags);

 	return object;
@@ -4349,9 +4351,10 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
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
@@ -4359,33 +4362,30 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 	 */
 	needs_add_partial = (slab->objects > count);

-	if (!allow_spin && needs_add_partial) {
+	/* Target inuse count after allocating from this new slab. */
+	target_inuse = needs_add_partial ? count : slab->objects;

-		n = get_node(s, slab_nid(slab));
+	init_slab_obj_iter(s, slab, &iter, allow_spin);

-		if (!spin_trylock_irqsave(&n->list_lock, flags)) {
-			/* Unlucky, discard newly allocated slab */
-			free_new_slab_nolock(s, slab);
-			return 0;
-		}
-	}
-
-	object = slab->freelist;
-	while (object && allocated < count) {
-		p[allocated] = object;
-		object = get_freepointer(s, object);
-		maybe_wipe_obj_freeptr(s, p[allocated]);
-
-		slab->inuse++;
+	while (allocated < target_inuse) {
+		p[allocated] = next_slab_obj(s, &iter);
 		allocated++;
 	}
-	slab->freelist = object;
+	slab->inuse = target_inuse;
+	build_slab_freelist(s, slab, &iter);

 	if (needs_add_partial) {
-
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
@@ -4456,15 +4456,13 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 	stat(s, ALLOC_SLAB);

 	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
-		object = alloc_single_from_new_slab(s, slab, orig_size, gfpflags);
+		object = alloc_single_from_new_slab(s, slab, orig_size, allow_spin);

 		if (likely(object))
 			goto success;
 	} else {
-		alloc_from_new_slab(s, slab, &object, 1, allow_spin);
-
 		/* we don't need to check SLAB_STORE_USER here */
-		if (likely(object))
+		if (alloc_from_new_slab(s, slab, &object, 1, allow_spin))
 			return object;
 	}

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

@@ -7596,14 +7591,18 @@ static void early_kmem_cache_node_alloc(int node)
 		pr_err("SLUB: Allocating a useless per node structure in order to be able to continue\n");
 	}

-	n = slab->freelist;
+	init_slab_obj_iter(kmem_cache_node, slab, &iter, true);
+
+	n = next_slab_obj(kmem_cache_node, &iter);
 	BUG_ON(!n);
+
+	slab->inuse = 1;
+	build_slab_freelist(kmem_cache_node, slab, &iter);
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

