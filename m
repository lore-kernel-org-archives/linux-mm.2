Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00D9BC55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 12:25:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B8256B0093; Sat,  1 Aug 2026 08:25:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 567AA6B0095; Sat,  1 Aug 2026 08:25:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42F916B0096; Sat,  1 Aug 2026 08:25:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E7086B0093
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:25:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 911F3A02C6
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:25:51 +0000 (UTC)
X-FDA: 85052622102.26.0B58F85
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 06AEB1A0007
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:25:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=STKiaHXo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785587150;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XK4NNGYugEZGIiWxHOIeQgY29Y5r4aVTlZbmh3ehY5s=;
	b=bHugMuRoqZODuR0ant2boTSWV1a83dDr7z7W/UrnQhM5RMfXYTr4Gky3Q3+/Z8GE4ed63s
	OrKYitzYNEzld4fI936Px5EiOuwlDx9T5qAEa1yFpqBlWeJaffCqCTDO7O+iZf57yxbKBU
	r1d1YvU8MhvPZGsERD3iGXhtUsY2sBU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=STKiaHXo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785587150;
	b=KcoBWY3NGiJvhU/yxBWu1HJzTh4R4NuGVR9O2mCAvs682x2s5PIiDPcELc0nIWi1K3BKDP
	0YKqqdw58eCcKpmxPJCSlaBl+UFev0/KcY1jdcGUCpEyW+Ld0M/4Xt7F8pO3NHgvEOxPvD
	D3rcfdcfJP2Lfj2EsVCGUuzMwqQpQlQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 84B8660AAB;
	Sat,  1 Aug 2026 12:25:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C4581F00ACF;
	Sat,  1 Aug 2026 12:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785587149;
	bh=XK4NNGYugEZGIiWxHOIeQgY29Y5r4aVTlZbmh3ehY5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=STKiaHXorkmOTLe5F4LPzOpkhJL5RD8LndokVEJAWZf32DwZEgmyIFj/SY/DyeynX
	 Q8jxaW+JqAnEsPrShw6rhTfaelziRUvMYPPpgUHRDUYiOM9S83AIcMxpWzlxDMN27w
	 /51FxR2XoqVXNst5pOZrwRjoATMCLrwCexi1fCytp4LgTQQlOfUmDLTQAn9cjpQboQ
	 jP8zKlOYcpJk5gLxtnA72ADcOwlrH7GAIyFTs9eLEcBCPehuRxWZYHrcsjrdJ3aJF2
	 RjO5thrcEiW72ddjav3B/nJ/dz1jM8VfujHYnpbz4l9oByiByxijCNyu4qAbRFD/gy
	 iiubV/2mCYNPA==
From: Harry Yoo <harry@kernel.org>
To: Danielle Costantino <dcostantino@meta.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Hao Ge <hao.ge@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Kees Cook <kees@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: [7.1.y 3/3] mm/slab: prevent unbounded recursion in free path with new kmalloc type
Date: Sat,  1 Aug 2026 12:25:33 +0000
Message-ID: <20260801122533.319272-4-harry@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260801122533.319272-1-harry@kernel.org>
References: <20260801122533.319272-1-harry@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 06AEB1A0007
X-Rspam-User: 
X-Stat-Signature: tbynksjrhcupbwy4qyp9b3r77kirfij8
X-HE-Tag: 1785587149-199371
X-HE-Meta: U2FsdGVkX1/j4Qgv6ko3QssgHZ9mcW/0cVzJqs768cq+FPhl1ryQXKMKwbYa51lNMhmLau0LkpiuvIYFTg5xadZFiTmbJDn7sQIVEdWBS5iG9PbhI7uXqDLplcMMc9Bpj8v2e/rZlqOrgs0cuCdTZSODcqA7QiwTyAgP7tSbsLTLSK6LMraUli1+7qDqtzOZrr24W3WCEENI8lKtILU3iBjuO9ggZ/qgujrfH4Dc48hP/oztMw61nskyd0p20FmLQD58D7N7EjXGodaRFMImIbgSmYdsaQ3msu1nhMuT/RbiP8RBgFlOEUhTYaL4cw1RtktSUwj4RoWgkumSnznRlJqWtqCC08Sx+1RU+rIp9w5j7Ymai7zxqP9eAYDTvACz71BIu3ki3PZ/UHIwXNvN1ZkstrfaENdDuzxi0oAzRWis3UG1qGtLSrK5Zamhue1PXn3CYUOkKRFH5wVapRNUBRAP7BexOXM9Z/fq+KlrQ5hP6HH4QtspvzT/Mfx1azf6TnfgXmMnB7rXb0XdMUkTXPSUZ3BqB2PR6K6mlG9QI3FRNVBOF4DgbOO9JslIK3qeF8CNSIf4axm6xHkXzvkARtxV4DIteGhult3U/5p8E/PgRbgPo82XMFZTNLPjv6Lun8XvVoteUSVgzi53EAsKNxbba+xHKZhuY5eO3Orko64YHkqCuK3uqClt2pBWMZu3Vrw4e+XtWWQ+sY6erVWqytYeKMNscoxm3qSxUwIIGq4rKVMnGs6b0jf4ViT5vvRi6YC1YBpJ5DtL5Y7r1rqmgKDWJn6FyA/kmvpolEuGW2Z7nPOa7qWSdXOs/cF+hhhXyD26LK8W3R5RXJZyoC1kDlKlMMQ8qPZBZHiLN1+KFAykYYqpEFHtppcHWea51lJmNHnxm3cYsk9x5YOD4qU6fjvFZ/6wCw5KBgwJ5RjG2FtF1//Q/Wrw46n6jzN/F2gfXrSN59S6YWWrBM2QxY2
 SFKiWGgC
 a1xGIiUrBiSL1BgY1g4jbOTNUbIbRg1emNCAxfCx7/quj8CXtA3pm2TwujYoNA4mw2XToEof+c4PUPE+ltY3czbGNawqsEz0FKLKAyBaKfeHZppu99KC+CyH/+oiKIpQYkuoefmrHqbaTtRC/ULPPR5D11IlFFdrdJwZ2Nd9t9/7RlEa/RcrF19VIjY6UCOXDRHdaKT1C9J1x/cGBwvZucJFPsed1K2r5+g3LBCjocR8FspSmRW1wKhtmVhMqd+TOrp9gyAN1eKUtJJMaG/77J+3HIlhuaKu2qyW05NrB/taWL3GSEGeZXyKryEpSUtNk5Mddyg+9YWzz5D+GncngNAYEeJzYwEqip9LKAOOAjqV06LFYRN5Ro0Jes7lmGgFAVtzFSZ/ldM/3TozdMGatjH/MAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Harry Yoo (Oracle)" <harry@kernel.org>

commit d9e6a7623938968e3752b67e37eaff097e559a54 upstream.

Commit 280ea9c3154b ("mm/slab: avoid allocating slabobj_ext array from
its own slab") avoided recursive allocation of obj_exts from kmalloc
caches of the same size, by bumping the obj_exts array's allocation
size whenever the array size equals the size of the object being
allocated.

However, as reported by Danielle Costantino and Shakeel Butt,
even slabs from kmalloc caches of different sizes can form a cycle
by allocating obj_exts arrays from each other [1]:

  What happened: a KMALLOC_NORMAL slab's obj_exts array (used by
  allocation profiling / memcg accounting) is itself kmalloc()'d from a
  KMALLOC_NORMAL cache, so the "slab holds another slab's obj_exts array"
  relation can form cycles. With sizeof(struct slabobj_ext) == 16 and
  the host's geometry:

  - kmalloc-512 has 64 objects/slab -> array is 64*16 == 1024 bytes,
    served from kmalloc-1k;
  - kmalloc-1k  has 32 objects/slab -> array is 32*16 ==  512 bytes,
    served from kmalloc-512.

  A kmalloc-512 slab and a kmalloc-1k slab therefore hold each other's
  obj_exts array.  Discarding one frees the other's array, which empties
  and discards that slab, which frees the first's array, and so on:
  __free_slab() -> free_slab_obj_exts() -> kfree() -> discard_slab() ->
  __free_slab() recurses along the cycle until the stack is exhausted.

With memory allocation profiling, this allows unbounded recursion
in the free path and led to a stack overflow on a production host in
the Meta fleet [1]:

  BUG: TASK stack guard page was hit
  Oops: stack guard page
  RIP: 0010:kfree+0x8/0x5d0
  Call Trace:
   __free_slab+0x66/0xc0
   kfree+0x3f0/0x5d0
   ... ( ~125x __free_slab <-> kfree ) ...
   <kernel driver freeing a resource>
   do_syscall_64

It is proposed [1] to resolve this issue by always serving the obj_exts
array allocation from kmalloc caches (or large kmalloc) of sizes larger
than the object size. However, as pointed out by Vlastimil Babka [2],
this can waste an excessive amount of memory as slabs from large
kmalloc sizes (e.g. kmalloc-8k) generally need obj_exts arrays much
smaller than the object size.

Therefore, rather than bumping the size, let us take a different
approach; disallow formation of cycles between kmalloc types when
allocating obj_exts arrays. Currently, all obj_exts arrays are served
from normal kmalloc caches. Cycles cannot be created if obj_exts arrays
of normal kmalloc caches are served from a special kmalloc type that can
never have obj_exts arrays.

To achieve this, create a new kmalloc type called KMALLOC_NO_OBJ_EXT.
KMALLOC_NO_OBJ_EXT caches are created with SLAB_NO_OBJ_EXT flag when
either 1) memory allocation profiling is not permanently disabled,
or 2) kmalloc types with a priority higher than KMALLOC_CGROUP are
aliased with KMALLOC_NORMAL.

Sheaf bootstrapping for KMALLOC_NO_OBJ_EXT caches now must be deferred
because allocation of a barn can trigger obj_exts array allocation of
normal kmalloc caches when the KMALLOC_NO_OBJ_EXT cache for that size
is not ready yet. For simplicity, perform bootstrapping of sheaves for
all kmalloc caches later.

Introduce a new slab alloc flag, SLAB_ALLOC_NO_OBJ_EXT, to prevent
allocation of obj_exts arrays, and let kmalloc_slab() override the type
to KMALLOC_NO_OBJ_EXT when specified. Note that kmalloc_type() remains
unchanged because kmalloc_flags() bypasses the kmalloc fastpath.

Do not pass SLAB_ALLOC_NO_RECURSE to kmalloc_flags() in
alloc_slab_obj_exts() and instead use SLAB_ALLOC_NO_OBJ_EXT only when
the objects are allocated from normal kmalloc caches. While this
prevents unbounded recursive allocation of obj_exts, it allows
KMALLOC_NO_OBJ_EXT caches to have sheaves.

Since sheaf allocations specify SLAB_ALLOC_NO_RECURSE that prevents
allocation of both sheaves and obj_exts arrays, the recursion depth
is bounded.

obj_exts arrays for non-kmalloc-normal caches can now have a valid tag.
Do not call mark_obj_codetag_empty() when freeing an obj_exts array to
avoid false warnings. KMALLOC_NO_OBJ_EXT don't need this as they never
allocate those arrays.

Reported-by: Danielle Costantino <dcostantino@meta.com>
Reported-by: Shakeel Butt <shakeel.butt@linux.dev>
Closes: https://lore.kernel.org/linux-mm/20260625230029.703750-1-shakeel.butt@linux.dev [1]
Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mm/c5c4208d-a6f0-413e-bad9-49be12f12d55@kernel.org [2]
Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Link: https://patch.msgid.link/20260713-kmalloc-no-objext-v3-4-47c7bd138de7@kernel.org
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
[harry@kernel.org: Backport notes:
 - Fix a minor conflict due to missing partitioned
   kmalloc caches in 7.1.

 - Use __GFP_NO_OBJ_EXT instead of SLAB_ALLOC_NO_OBJ_EXT
   since slab's internal alloc_flags do not exist in 7.1.

 - Since there is no way to distinguish between no obj_exts vs.
   no recursion in 7.1 due to lack of SLAB_ALLOC_* flags, sheaves for
   normal kmalloc caches are allocated from kmalloc-no-objext-* unlike
   upstream.

   Also, allocations from kmalloc-no-objext cannot allocate sheaves and
   may observe slightly higher contention. Only 7.1 has this problem as
   kmalloc caches don't have sheaves in LTS kernels.

 - Apply the __GFP_NO_OBJ_EXT flag to the !allow_spin path in
   alloc_slab_obj_exts(). ]
Signed-off-by: Harry Yoo <harry@kernel.org>
---
 include/linux/slab.h |  6 +++
 mm/slab.h            | 28 +++++++++++++-
 mm/slab_common.c     | 13 +++++++
 mm/slub.c            | 87 +++++++++++++++-----------------------------
 4 files changed, 75 insertions(+), 59 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index fda7e24a762b..739f474c5d92 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -642,6 +642,9 @@ enum kmalloc_cache_type {
 #endif
 #ifndef CONFIG_MEMCG
 	KMALLOC_CGROUP = KMALLOC_NORMAL,
+#endif
+#ifndef CONFIG_SLAB_OBJ_EXT
+	KMALLOC_NO_OBJ_EXT = KMALLOC_NORMAL,
 #endif
 	KMALLOC_RANDOM_START = KMALLOC_NORMAL,
 	KMALLOC_RANDOM_END = KMALLOC_RANDOM_START + RANDOM_KMALLOC_CACHES_NR,
@@ -655,6 +658,9 @@ enum kmalloc_cache_type {
 #endif
 #ifdef CONFIG_MEMCG
 	KMALLOC_CGROUP,
+#endif
+#ifdef CONFIG_SLAB_OBJ_EXT
+	KMALLOC_NO_OBJ_EXT,
 #endif
 	NR_KMALLOC_TYPES
 };
diff --git a/mm/slab.h b/mm/slab.h
index bf2f87acf5e3..50414bd2b919 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -365,9 +365,13 @@ static inline struct kmem_cache *
 kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, unsigned long caller)
 {
 	unsigned int index;
+	enum kmalloc_cache_type type = kmalloc_type(flags, caller);
+
+	if (flags & __GFP_NO_OBJ_EXT)
+		type = KMALLOC_NO_OBJ_EXT;
 
 	if (!b)
-		b = &kmalloc_caches[kmalloc_type(flags, caller)];
+		b = &kmalloc_caches[type];
 	if (size <= 192)
 		index = kmalloc_size_index[size_index_elem(size)];
 	else
@@ -402,7 +406,8 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
 {
 	if (!is_kmalloc_cache(s))
 		return false;
-	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
+
+	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT|SLAB_NO_OBJ_EXT));
 }
 
 bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
@@ -505,6 +510,25 @@ static inline void metadata_access_disable(void)
 	kasan_enable_current();
 }
 
+/*
+ * Return true if KMALLOC_NORMAL caches may need obj_exts arrays.
+ *
+ * Memory allocation profiling requires obj_exts for all caches.
+ * Memcg usually doesn't need them for normal kmalloc caches, but kmalloc types
+ * with a priority higher than KMALLOC_CGROUP can be aliased with KMALLOC_NORMAL.
+ */
+static inline bool need_kmalloc_no_objext(void)
+{
+	if (!mem_alloc_profiling_permanently_disabled())
+		return true;
+
+	if (!mem_cgroup_kmem_disabled() &&
+			(KMALLOC_NORMAL == KMALLOC_RECLAIM))
+		return true;
+
+	return false;
+}
+
 #ifdef CONFIG_SLAB_OBJ_EXT
 
 /*
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 8b661fff5eed..214374233fb8 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -843,6 +843,12 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 #define KMALLOC_RANDOM_NAME(N, sz)
 #endif
 
+#ifdef CONFIG_SLAB_OBJ_EXT
+#define KMALLOC_NO_OBJ_EXT_NAME(sz) .name[KMALLOC_NO_OBJ_EXT] = "kmalloc-no-objext-" #sz,
+#else
+#define KMALLOC_NO_OBJ_EXT_NAME(sz)
+#endif
+
 #define INIT_KMALLOC_INFO(__size, __short_size)			\
 {								\
 	.name[KMALLOC_NORMAL]  = "kmalloc-" #__short_size,	\
@@ -850,6 +856,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 	KMALLOC_CGROUP_NAME(__short_size)			\
 	KMALLOC_DMA_NAME(__short_size)				\
 	KMALLOC_RANDOM_NAME(RANDOM_KMALLOC_CACHES_NR, __short_size)	\
+	KMALLOC_NO_OBJ_EXT_NAME(__short_size)			\
 	.size = __size,						\
 }
 
@@ -957,6 +964,12 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 			return;
 		}
 		flags |= SLAB_ACCOUNT;
+	} else if (IS_ENABLED(CONFIG_SLAB_OBJ_EXT) && type == KMALLOC_NO_OBJ_EXT) {
+		if (!need_kmalloc_no_objext()) {
+			kmalloc_caches[type][idx] = kmalloc_caches[KMALLOC_NORMAL][idx];
+			return;
+		}
+		flags |= SLAB_NO_OBJ_EXT | SLAB_NO_MERGE;
 	} else if (IS_ENABLED(CONFIG_ZONE_DMA) && (type == KMALLOC_DMA)) {
 		flags |= SLAB_CACHE_DMA;
 	}
diff --git a/mm/slub.c b/mm/slub.c
index 33e64f21ecc1..d83c3622ccde 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2106,42 +2106,6 @@ static inline void init_slab_obj_exts(struct slab *slab)
 	slab->obj_exts = 0;
 }
 
-/*
- * Calculate the allocation size for slabobj_ext array.
- *
- * When memory allocation profiling is enabled, the obj_exts array
- * could be allocated from the same slab cache it's being allocated for.
- * This would prevent the slab from ever being freed because it would
- * always contain at least one allocated object (its own obj_exts array).
- *
- * To avoid this, increase the allocation size when we detect the array
- * may come from the same cache, forcing it to use a different cache.
- */
-static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
-					 struct slab *slab, gfp_t gfp)
-{
-	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
-	struct kmem_cache *obj_exts_cache;
-
-	if (sz > KMALLOC_MAX_CACHE_SIZE)
-		return sz;
-
-	if (!is_kmalloc_normal(s))
-		return sz;
-
-	obj_exts_cache = kmalloc_slab(sz, NULL, gfp, 0);
-	/*
-	 * We can't simply compare s with obj_exts_cache, because random kmalloc
-	 * caches have multiple caches per size, selected by caller address.
-	 * Since caller address may differ between kmalloc_slab() and actual
-	 * allocation, bump size when sizes are equal.
-	 */
-	if (s->object_size == obj_exts_cache->object_size)
-		return obj_exts_cache->object_size + 1;
-
-	return sz;
-}
-
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		        gfp_t gfp, bool new_slab)
 {
@@ -2150,13 +2114,17 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	unsigned long new_exts;
 	unsigned long old_exts;
 	struct slabobj_ext *vec;
-	size_t sz;
+	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
-	/* Prevent recursive extension vector allocation */
-	gfp |= __GFP_NO_OBJ_EXT;
 
-	sz = obj_exts_alloc_size(s, slab, gfp);
+	/*
+	 * In most cases, obj_exts arrays are allocated from normal kmalloc.
+	 * However, normal kmalloc caches must allocate them from
+	 * KMALLOC_NO_OBJ_EXT caches to prevent recursion.
+	 */
+	if (is_kmalloc_normal(s))
+		gfp |= __GFP_NO_OBJ_EXT;
 
 	/*
 	 * Note that allow_spin may be false during early boot and its
@@ -2165,10 +2133,11 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	 * very early allocations on those.
 	 */
 	if (unlikely(!allow_spin))
-		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
+		vec = kmalloc_nolock(sz, __GFP_ZERO | (gfp & __GFP_NO_OBJ_EXT),
 				     slab_nid(slab));
 	else
-		vec = kmalloc_node(sz, gfp | __GFP_ZERO, slab_nid(slab));
+		vec = kmalloc_node(sz, gfp | __GFP_ZERO,
+				   slab_nid(slab));
 
 	if (!vec) {
 		/*
@@ -2183,8 +2152,21 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		return -ENOMEM;
 	}
 
-	VM_WARN_ON_ONCE(virt_to_slab(vec) != NULL &&
-			virt_to_slab(vec)->slab_cache == s);
+	if (IS_ENABLED(CONFIG_DEBUG_VM)) {
+		struct kmem_cache *exts_cache;
+		struct slab *exts_slab;
+
+		exts_slab = virt_to_slab(vec);
+		if (exts_slab) {
+			/*
+			 * The vector must be allocated from either normal or
+			 * KMALLOC_NO_OBJ_EXT kmalloc caches to avoid cycles.
+			 */
+			exts_cache = exts_slab->slab_cache;
+			WARN_ON_ONCE(!is_kmalloc_normal(exts_cache) &&
+					!(exts_cache->flags & SLAB_NO_OBJ_EXT));
+		}
+	}
 
 	new_exts = (unsigned long)vec;
 #ifdef CONFIG_MEMCG
@@ -2207,7 +2189,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		 * assign slabobj_exts in parallel. In this case the existing
 		 * objcg vector should be reused.
 		 */
-		mark_obj_codetag_empty(vec);
 		if (unlikely(!allow_spin))
 			kfree_nolock(vec);
 		else
@@ -2243,14 +2224,6 @@ static inline void free_slab_obj_exts(struct slab *slab, bool allow_spin)
 		return;
 	}
 
-	/*
-	 * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
-	 * corresponding extension will be NULL. alloc_tag_sub() will throw a
-	 * warning if slab has extensions but the extension of an object is
-	 * NULL, therefore replace NULL with CODETAG_EMPTY to indicate that
-	 * the extension for obj_exts is expected to be NULL.
-	 */
-	mark_obj_codetag_empty(obj_exts);
 	if (allow_spin)
 		kfree(obj_exts);
 	else
@@ -7906,10 +7879,10 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
 		s->allocflags |= __GFP_RECLAIMABLE;
 
 	/*
-	 * For KMALLOC_NORMAL caches we enable sheaves later by
-	 * bootstrap_kmalloc_sheaves() to avoid recursion
+	 * For kmalloc caches we enable sheaves later by
+	 * bootstrap_kmalloc_sheaves() to avoid recursion.
 	 */
-	if (!is_kmalloc_normal(s))
+	if (!is_kmalloc_cache(s))
 		s->sheaf_capacity = calculate_sheaf_capacity(s, args);
 
 	/*
@@ -8475,7 +8448,7 @@ static void __init bootstrap_kmalloc_sheaves(void)
 {
 	enum kmalloc_cache_type type;
 
-	for (type = KMALLOC_NORMAL; type <= KMALLOC_RANDOM_END; type++) {
+	for (type = KMALLOC_NORMAL; type < NR_KMALLOC_TYPES; type++) {
 		for (int idx = 0; idx < KMALLOC_SHIFT_HIGH + 1; idx++) {
 			struct kmem_cache *s = kmalloc_caches[type][idx];
 
-- 
2.53.0


