Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC4A2C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 06:04:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B46666B00A0; Fri, 10 Jul 2026 02:04:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1D906B00A2; Fri, 10 Jul 2026 02:04:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5B3D6B00A3; Fri, 10 Jul 2026 02:04:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7762F6B00A0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 02:04:13 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0CACAA037D
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:04:13 +0000 (UTC)
X-FDA: 84971826786.25.E4A38A4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 52B0740005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 06:04:11 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fT57zmgf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783663451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eMLyBdKJj8PTw/k2Sp4I+K2ZWmHSyqFaw91vK+jNOXU=;
	b=LNruGOYs48tXLQTyYpP8nSmXjfrqjF1jYVimxHQrq4k3xhwQjTh+pJXcfbH5NEk9Xq4zv2
	9tfFv+LIz1EluRExTk4dP3goc2p4BTTruWWIfgDnG5crKmwYTmZ7Fh5/6WTZBaHVU2GTc5
	zr7Sress8HooCbQCt64IvesSLyz70B0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fT57zmgf;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783663451;
	b=GkN0KvaC65nYRVvzIDOeZD/heWTM1ZNyI4gGKZHiB0LVqk2ja1sx/O8qVDpXlv9+ptpwEa
	az8zzY+6+FRlOTYi5nJkG4/Oug0gYZn+mveRLEY4/sy4ib7vu00PkuK7bHvOje2hA0SePk
	S5+0g0tPJ4WTEjmYr8+EY3kRR5b3u6M=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9D3EE436F5;
	Fri, 10 Jul 2026 06:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74BE21F00A3A;
	Fri, 10 Jul 2026 06:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783663450;
	bh=eMLyBdKJj8PTw/k2Sp4I+K2ZWmHSyqFaw91vK+jNOXU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=fT57zmgfZnEVpfeoK1GUE/D/WfVmfW9dJuny1CLe9mCwQVbEPLEh0msnjMlKmmHLd
	 QUTxajID5MsNM1foKSqH2ZCnO3qNMHvGPKDHrsJMhjFpVc3alkjgGElaYIg4n0Ekq4
	 Yh/5Bt21rHVjaUSjnwAFsiLWbAXOjI2zC+qQbWHiMu+RiB1MOTPz209S++nmElIS0U
	 MrXhIbfA1oYzf4iBcI35Ar3XyKdk3WE0Wmv8UiHi+7/Okownxa/xd5aYKZizzmEY7Q
	 e9oH1mI7mS0rWYDxy+/fASu8tnFe8t60tb/JmA9GcRYFesirI6LxEYc8gK0aIGsmPV
	 8IRSOLq6zFGSw==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Fri, 10 Jul 2026 15:03:34 +0900
Subject: [PATCH slab/for-next-fixes v2 3/3] mm/slab: prevent unbounded
 recursion in free path with new kmalloc type
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260710-kmalloc-no-objext-v2-3-2709afb6a030@kernel.org>
References: <20260710-kmalloc-no-objext-v2-0-2709afb6a030@kernel.org>
In-Reply-To: <20260710-kmalloc-no-objext-v2-0-2709afb6a030@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>, 
 Kees Cook <kees@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Danielle Constantino <dcostantino@meta.com>, 
 "Liam R. Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "Harry Yoo (Oracle)" <harry@kernel.org>
X-Mailer: b4 0.14.3
X-Rspamd-Queue-Id: 52B0740005
X-Stat-Signature: paongn1uhphmtyzenzqkwsbcz4c96wh5
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783663451-114951
X-HE-Meta: U2FsdGVkX1/D5KvzgHBBLlEfC5cauL9hVGbr6joh/PlECYrEdD40oiz90COrGki5gfmuC0BfpcRnzhufWxcoP8WSgETJjOIsRZt+bpCMLlccviu8H4mt/MomvdZPmGTQ58GqNj5PBT0+91g6kkK0ud1TUYMZTZu6aprdOdOx/lBAcle/ZkirLXTIa2qbQq0Q3haGA2FIbA4S+EGCsUuqbs2FHcB6osO07is7AJXiYJ9lIv9HleXfQqbNmVt823vzbVwuVQmQC/wpl7a9I8i+u5eVfiC6Og4BWJ7yyPxjLP1DF11YnrH1vj07yIrKEcec1V9qE9PX3ppBZePAAtyduw/Ew0MtBADrvDYjwCF2j8NS3dqtovHUlpjA+dxeezo9tHb+5zRQzJZXRCyEzS2n1MYcorlXru+3buF7TAh1YHA6v0X83efYx5oqiQhdyB4iGwyt38xsz627adGOvy3ibXPCEXCNzcvvSZ+BxxLmlTX+4oKDX2M4ncN6Q6m3JqgWQopHApWW3GaA2ndoIIOEOT4NP4+fqIou7Tk46JQqap+8HKp9Uana/IKlm5A2R4Ds4sGknek3gNdiHn+cNz3ONB2tgvIsnI4p7LmyXXVPUVthjPDw8bLkm7GitwGQqPrfhcEajrSNzMLooPiIHZf4Hn0co96dhgk8ht47xn7QRkYipCd5htXvneR4CNvQDofd8Tlf9qwoSIXdYGy+FAcpRjX0549Q6p0cU+ZbmlC/XvHykHiJZRK+0kkg5s+9r3hquHvOIIEwhSmtPgkDaRA3HS2D5seqiwQpOkqJIRpjZS7bM2rTl0vVxAplFvy3nJvfwMtknPdssqsLJSTXCdk64ff7nWJb+9fLX6y/m0ip3Y0L0N5je2jq4s0wVsAI2W0ReftWbA9/JP+bAVhF8xjz5wD7OO6BU/zGt4onYQxyIotANqsp2sShvddAIlpj1JmW4HSgmn0UzBGYvKaThi1
 LL3e95+5
 Sjd4GP4iHlsp6pTBnokw213+CT/vJmY8xp7B8XyJxaJmlPMijpRNA6EqY7ujAojUHmY0IFaspE0euybiW72igNxtgjv1pCVSNJKV238n8O+F50hvtqLh3+o88NPwIrQnL7rdx5F/3/vmuyoOx+u5SIlIP0VJUSDmfH2Tjv8m+tW0IhjPuE0BXhChw3U3wIS1LeaScfXXa0W2E6zNhw5EPtFJbOeET73O1tLKjx2tjAyo169XDNbnjV6UG8xA/m+/eI4fgBX2UD4Mfu6fHKmvLsBRNONri19Gzlbm10MZxjHAo/1yivZzBN5pOsg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
KMALLOC_NO_OBJ_EXT caches are created when CONFIG_SLAB_OBJ_EXT is
enabled, and they have SLAB_NO_OBJ_EXT flag to prevent allocation
of obj_exts arrays. They remain unused until allocation of obj_exts
arrays for normal kmalloc caches happens.

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
---
 include/linux/slab.h |  3 ++
 mm/slab.h            | 15 +++++++--
 mm/slab_common.c     | 18 ++++++++++-
 mm/slub.c            | 90 +++++++++++++++++++---------------------------------
 4 files changed, 64 insertions(+), 62 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 08d7b6c9c4d6..0c1d13773523 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -721,6 +721,9 @@ enum kmalloc_cache_type {
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
index 281a65233795..7bce162699b7 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -22,6 +22,7 @@
 #define SLAB_ALLOC_NOLOCK	0x01 /* a kmalloc_nolock() allocation */
 #define SLAB_ALLOC_NEW_SLAB	0x02 /* a flag for alloc_slab_obj_exts() */
 #define SLAB_ALLOC_NO_RECURSE	0x04 /* prevent kmalloc() recursion */
+#define SLAB_ALLOC_NO_OBJ_EXT	0x08 /* prevent obj_exts array allocation */
 
 static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
 {
@@ -386,12 +387,19 @@ static inline unsigned int size_index_elem(unsigned int bytes)
  * KMALLOC_MAX_CACHE_SIZE and the caller must check that.
  */
 static inline struct kmem_cache *
-kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token_t token)
+kmalloc_slab(size_t size, kmem_buckets *b, gfp_t flags, kmalloc_token_t token,
+	     unsigned int alloc_flags)
 {
 	unsigned int index;
+	enum kmalloc_cache_type type = kmalloc_type(flags, token);
+
+#ifdef CONFIG_SLAB_OBJ_EXT
+	if (alloc_flags & SLAB_ALLOC_NO_OBJ_EXT)
+		type = KMALLOC_NO_OBJ_EXT;
+#endif
 
 	if (!b)
-		b = &kmalloc_caches[kmalloc_type(flags, token)];
+		b = &kmalloc_caches[type];
 	if (size <= 192)
 		index = kmalloc_size_index[size_index_elem(size)];
 	else
@@ -426,7 +434,8 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
 {
 	if (!is_kmalloc_cache(s))
 		return false;
-	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
+
+	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT|SLAB_NO_OBJ_EXT));
 }
 
 bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj);
diff --git a/mm/slab_common.c b/mm/slab_common.c
index b6426d7ceec9..7f262134d0f2 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -783,11 +783,15 @@ u8 kmalloc_size_index[24] __ro_after_init = {
 size_t kmalloc_size_roundup(size_t size)
 {
 	if (size && size <= KMALLOC_MAX_CACHE_SIZE) {
+		struct kmem_cache *s;
+
 		/*
 		 * The flags don't matter since size_index is common to all.
 		 * Neither does the caller for just getting ->object_size.
 		 */
-		return kmalloc_slab(size, NULL, GFP_KERNEL, __kmalloc_token(0))->object_size;
+		s = kmalloc_slab(size, NULL, GFP_KERNEL, __kmalloc_token(0),
+				 SLAB_ALLOC_DEFAULT);
+		return s->object_size;
 	}
 
 	/* Above the smaller buckets, size is a multiple of page size. */
@@ -843,6 +847,12 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 #define KMALLOC_PARTITION_NAME(N, sz)
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
@@ -850,6 +860,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 	KMALLOC_CGROUP_NAME(__short_size)			\
 	KMALLOC_DMA_NAME(__short_size)				\
 	KMALLOC_PARTITION_NAME(KMALLOC_PARTITION_CACHES_NR, __short_size)	\
+	KMALLOC_NO_OBJ_EXT_NAME(__short_size)			\
 	.size = __size,						\
 }
 
@@ -966,6 +977,11 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 		flags |= SLAB_NO_MERGE;
 #endif
 
+#ifdef CONFIG_SLAB_OBJ_EXT
+	if (type == KMALLOC_NO_OBJ_EXT)
+		flags |= SLAB_NO_OBJ_EXT | SLAB_NO_MERGE;
+#endif
+
 	/*
 	 * If CONFIG_MEMCG is enabled, disable cache merging for
 	 * KMALLOC_NORMAL caches.
diff --git a/mm/slub.c b/mm/slub.c
index abe748b7dddb..0337e60db5ac 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2123,42 +2123,6 @@ static inline void init_slab_obj_exts(struct slab *slab)
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
-	obj_exts_cache = kmalloc_slab(sz, NULL, gfp, __kmalloc_token(0));
-	/*
-	 * We can't simply compare s with obj_exts_cache, because partitioned kmalloc
-	 * caches have multiple caches per size, selected by caller address or type.
-	 * Since caller address or type may differ between kmalloc_slab() and actual
-	 * allocation, bump size when sizes are equal.
-	 */
-	if (s->object_size == obj_exts_cache->object_size)
-		return obj_exts_cache->object_size + 1;
-
-	return sz;
-}
-
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 			gfp_t gfp, unsigned int alloc_flags)
 {
@@ -2168,14 +2132,18 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	unsigned long new_exts;
 	unsigned long old_exts;
 	struct slabobj_ext *vec;
-	size_t sz;
+	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
-	/* Prevent recursive extension vector allocation */
-	alloc_flags |= SLAB_ALLOC_NO_RECURSE;
-	alloc_flags &= ~SLAB_ALLOC_NEW_SLAB;
+	/*
+	 * In most cases, obj_exts arrays are allocated from normal kmalloc.
+	 * However, normal kmalloc caches must allocate them from
+	 * KMALLOC_NO_OBJ_EXT caches to prevent recursion.
+	 */
+	if (is_kmalloc_normal(s))
+		alloc_flags |= SLAB_ALLOC_NO_OBJ_EXT;
 
-	sz = obj_exts_alloc_size(s, slab, gfp);
+	alloc_flags &= ~SLAB_ALLOC_NEW_SLAB;
 
 	/* This will use kmalloc_nolock() if alloc_flags say so */
 	vec = kmalloc_flags(sz, gfp | __GFP_ZERO, alloc_flags, slab_nid(slab));
@@ -2193,8 +2161,21 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
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
@@ -2217,7 +2198,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		 * assign slabobj_exts in parallel. In this case the existing
 		 * objcg vector should be reused.
 		 */
-		mark_obj_codetag_empty(vec);
 		if (unlikely(!allow_spin))
 			kfree_nolock(vec);
 		else
@@ -2253,14 +2233,6 @@ static inline void free_slab_obj_exts(struct slab *slab, bool allow_spin)
 		return;
 	}
 
-	/*
-	 * obj_exts was created with SLAB_ALLOC_NO_RECURSE flag, therefore its
-	 * corresponding extension will be NULL. alloc_tag_sub() will throw a
-	 * warning if slab has extensions but the extension of an object is
-	 * NULL, therefore replace NULL with CODETAG_EMPTY to indicate that
-	 * the extension for obj_exts is expected to be NULL.
-	 */
-	mark_obj_codetag_empty(obj_exts);
 	if (allow_spin)
 		kfree(obj_exts);
 	else
@@ -5356,7 +5328,7 @@ void *__do_kmalloc_node(kmem_buckets *b, gfp_t flags, int node,
 	if (unlikely(!size))
 		return ZERO_SIZE_PTR;
 
-	s = kmalloc_slab(size, b, flags, token);
+	s = kmalloc_slab(size, b, flags, token, ac->alloc_flags);
 
 	ret = slab_alloc_node(s, flags, node, ac);
 	ret = kasan_kmalloc(s, ret, size, flags);
@@ -5419,7 +5391,9 @@ static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_f
 retry:
 	if (unlikely(size > KMALLOC_MAX_CACHE_SIZE))
 		return NULL;
-	s = kmalloc_slab(size, NULL, gfp_flags, PASS_TOKEN_PARAM(token));
+
+	s = kmalloc_slab(size, NULL, gfp_flags, PASS_TOKEN_PARAM(token),
+			 ac->alloc_flags);
 
 	if (!(s->flags & __CMPXCHG_DOUBLE) && !kmem_cache_debug(s))
 		/*
@@ -7979,10 +7953,10 @@ static int calculate_sizes(struct kmem_cache_args *args, struct kmem_cache *s)
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
@@ -8548,7 +8522,7 @@ static void __init bootstrap_kmalloc_sheaves(void)
 {
 	enum kmalloc_cache_type type;
 
-	for (type = KMALLOC_NORMAL; type <= KMALLOC_PARTITION_END; type++) {
+	for (type = KMALLOC_NORMAL; type < NR_KMALLOC_TYPES; type++) {
 		for (int idx = 0; idx < KMALLOC_SHIFT_HIGH + 1; idx++) {
 			struct kmem_cache *s = kmalloc_caches[type][idx];
 

-- 
2.53.0


