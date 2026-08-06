Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7C372C55838
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 05:38:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98B716B0098; Thu,  6 Aug 2026 01:38:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93B3E6B0099; Thu,  6 Aug 2026 01:38:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 82B4A6B009B; Thu,  6 Aug 2026 01:38:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4829D6B0098
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 01:38:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C885B1C119B
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:38:03 +0000 (UTC)
X-FDA: 85069738446.23.F96C227
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2564C20006
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 05:38:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bXlqGWJs;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785994682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=af23gw4jUs0WoJRVOM3yWQbkHWFGYIdrf94WLyXMykc=;
	b=czWlUan/htPE/GXCDexIxRyRGrDSs/vVt79/KsHLu5CwIj0yGWSieFe9TonAeD6ESFnWUh
	3RIfhji90sjHhAKGCEonNW6VHw2QIc36lw+DbaJ/5Ma3/DIkE135kNgWQ8Wn/6r6iakscr
	iDqwjifFillE29JicZuF1Xvq2goCKhc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785994682;
	b=bsdGAKGuGV7XR6P4vMO0Eaev1Am13oTgdZC4uApXMATpeLTKea52np80c/8dxrTCFZSPWN
	v0EKS1FvRj1025HSzq9LRd+E+XyGdGNDfiBMSd/VW3fcMawWWctN1nugRt0zyHVJVJpSXf
	hoZcmGZRaO4p9wvunWTQulgJKlDh7Y0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bXlqGWJs;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7059E401E9;
	Thu,  6 Aug 2026 05:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A6301F000E9;
	Thu,  6 Aug 2026 05:37:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785994681;
	bh=af23gw4jUs0WoJRVOM3yWQbkHWFGYIdrf94WLyXMykc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=bXlqGWJsmnZcjT92Z1E3JBp2bKESEm+IjQH8pwIeZva/ftkngAG4+sJJTvnFm8M7b
	 CreF2G3FOghhynznzVcJrJpCcoQ+bUJDBVCtgXX5dGPz7ek6WHZbZRNZuB7Oi4z3m4
	 RPg9/Te7MA2O6XRltvEz2Lf378wRwv9MclxV56SxTzSBC46WOdr81J+OvClTrv1C7K
	 MMkv1dlA0rz415ZbH1tOA9ss/6Bxya9aWEKcX0/uXZWDY5+M/M7El2hdDvcA/bTGT7
	 pI4Hz0//GlyYrwAZ59NBjeTDBCFVCDud6772fL0AIJMiHKSAxumbfsS3BXHYtkiXU/
	 OIPrtN/RxDrMQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Thu, 06 Aug 2026 05:37:42 +0000
Subject: [PATCH 6.12.y 2/2] mm/slab: prevent unbounded recursion in free
 path with new kmalloc type
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260806-kmalloc-no-objext-for-6-12-y-v1-2-036dfc3273fc@kernel.org>
References: <20260806-kmalloc-no-objext-for-6-12-y-v1-0-036dfc3273fc@kernel.org>
In-Reply-To: <20260806-kmalloc-no-objext-for-6-12-y-v1-0-036dfc3273fc@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, Harry Yoo <harry@kernel.org>, 
 Kees Cook <kees@kernel.org>, Danielle Costantino <dcostantino@meta.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Hao Ge <hao.ge@linux.dev>, 
 Hao Li <hao.li@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 "Liam R . Howlett" <liam@infradead.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2564C20006
X-Rspam-User: 
X-Stat-Signature: ebamo6uii1s3558m8o8t4e66iag3z5yh
X-HE-Tag: 1785994682-859678
X-HE-Meta: U2FsdGVkX18HRICpBN1WMrI7UPfbnhLqaA56PqofpksD1lvk9TRFQVxwGJHmm3+HGWGbZ/0Lmkd0U2HQMs92G9FHACD14KL7QG/5Fn4EmeuO8lu2SKIoY8gUG7lmixnEsJ4QaPLnCpX8JzOlaW/4mf/zKIc8EDr86KTCV9x7/gY2ZWhcOYxLHEBk1tHTbrz5d0AurRVOBrMo2clenRBUAOpyoSUrNL53GZ7HLDgtXnGmQttKE2lp66hQsbhnDv/aNEGkUrCmnKYYvAVTY9kn4hz+Nvzjg/W4NHeVhOaneCOVl6CVpyd0vZcBYl//jWZlydQu9qO42oqMWeQcz/hO39WuSzNQEkD7oSyjO0mYWd/KF3/1gU6NgSAf41WEgyk/hZ1OB8L82FFDN1Na2s6OV/07BS8ywR4H/TFnf/vkFAigRbvby2BJZy5EavsLAvP5tipxmkcVPOpHCKs7bYCnG6qCgR++8E8NsuBbclXjWiaYsfdbdffLDy2CMJIWM1v5oaugG384N6sdjQGsU8pKbhHmaUB9h7QsOtEWqKv9WEBahxIFJ87YOLliLkaIyue0kwbSMwgkJAxfdYRyt0zmfOF7e6YEL2DYiE97gzoaSIe+Ne6RgYvzD5R/v1LGTjK/PSnvd1Fci3KNlClI0CNCs+ko5qpDGBfBYeW84ZLNljSYfvkp/m8aBqhDLjd3BwxwXXgjNZV8ueMwnm8D9kBxGEbT/Vr+JCRmciKq4lMbm8Jpggv3ljY3MANfQweLJiuyRytjwJbuB0Ndp9CLqmUCJm72q1JjFy7Y/V/8oonkBBC9xB2gqfhwsnw6MJoD6/fmL2di5q0IiLUTYu3fpmC7DzS9uTs5hfL13X0ms6EBgiiOw8Jxds63BIzDvt19i+OvbgOiTDPZBrMSRfpENQl1gDxQmGz4f+6CrLrEVaqv3dWYQih/7E5YzXraCQMr8q0IGfRU99tNYI97F0t7VKx
 RFBoyhBy
 N4Kj/3y76dLdS/UQD3dTAzwpR+koiXZm+AJ/1QSgB6GqqO+xcFb73gEMmIDueqkQrue4hNbr0X9MWlh2jeJStnbi766rRm+N6bGog83N+RLtObXMQfvlZ+hBTcW3j2oX6NvCQVOTvOjmveHbOmPxCG6NBjOzXAfRDtlh//o4FTD9boQEZky5urD8aYkky+OqFURYBrTpbtRbtFljlUgyE/1SF7fGYgEXErhS1N5kXKdC1xsXNncAwHNRD7HJ0rSbMMG8Fc8l3aRpPHgKschpiDyyPQWK0Hw6O9fZ9f0iixLDA6ZpCUTaD+WSLRWy4F9Hy2oP8IHthifpKzBOxdwOeqJBN6rnoTCC+eo8tMN2hj3ZUOQn+7ZrH6h188UTIwHnCSCWsyQ/0YI/8hffRW1dKPk1hDWeKHlcURsZp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
   kmalloc caches in 6.12.

 - Use __GFP_NO_OBJ_EXT instead of SLAB_ALLOC_NO_OBJ_EXT
   since slab's internal alloc_flags do not exist in 6.12.

 - Deferring sheaf bootstrapping for kmalloc caches is not applied
   as 6.12 doesn't have sheaves.

 - Adjust the comment for SLAB_NO_OBJ_EXT, like in the commit
   982e31382d9a ("mm/slab: decouple SLAB_NO_SHEAVES from
   SLAB_NO_OBJ_EXT"). The rest of that commit is a no-op in 6.12 as
   sheaves are not supported. Thus only adjust the comment.

 - Resolve conflicts due to missing kmalloc_nolock() support in 6.12.

 - Mark need_kmalloc_no_objext() __always_inline to make sure
   the compiler does not generate a out-of-line function that could
   access mem_profiling_support (which is marked __init) ]
Signed-off-by: Harry Yoo <harry@kernel.org>
---
 include/linux/slab.h |  8 +++++++-
 mm/slab.h            | 28 ++++++++++++++++++++++++++--
 mm/slab_common.c     | 13 +++++++++++++
 mm/slub.c            | 34 +++++++++++++++++++++++-----------
 4 files changed, 69 insertions(+), 14 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 773843a71960..28eba6cbb767 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -206,7 +206,7 @@ enum _slab_flag_bits {
 #endif
 #define SLAB_TEMPORARY		SLAB_RECLAIM_ACCOUNT	/* Objects are short-lived */
 
-/* Slab created using create_boot_cache */
+/* Slab caches without obj_exts array */
 #ifdef CONFIG_SLAB_OBJ_EXT
 #define SLAB_NO_OBJ_EXT		__SLAB_FLAG_BIT(_SLAB_NO_OBJ_EXT)
 #else
@@ -578,6 +578,9 @@ enum kmalloc_cache_type {
 #endif
 #ifndef CONFIG_MEMCG
 	KMALLOC_CGROUP = KMALLOC_NORMAL,
+#endif
+#ifndef CONFIG_SLAB_OBJ_EXT
+	KMALLOC_NO_OBJ_EXT = KMALLOC_NORMAL,
 #endif
 	KMALLOC_RANDOM_START = KMALLOC_NORMAL,
 	KMALLOC_RANDOM_END = KMALLOC_RANDOM_START + RANDOM_KMALLOC_CACHES_NR,
@@ -591,6 +594,9 @@ enum kmalloc_cache_type {
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
index b65d2462b3fd..34a3d65b4ef5 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -413,9 +413,13 @@ static inline struct kmem_cache *
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
@@ -454,7 +458,8 @@ static inline bool is_kmalloc_normal(struct kmem_cache *s)
 {
 	if (!is_kmalloc_cache(s))
 		return false;
-	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT));
+
+	return !(s->flags & (SLAB_CACHE_DMA|SLAB_ACCOUNT|SLAB_RECLAIM_ACCOUNT|SLAB_NO_OBJ_EXT));
 }
 
 /* Legal flag mask for kmem_cache_create(), for various configurations */
@@ -557,6 +562,25 @@ bool slab_in_kunit_test(void);
 static inline bool slab_in_kunit_test(void) { return false; }
 #endif
 
+/*
+ * Return true if KMALLOC_NORMAL caches may need obj_exts arrays.
+ *
+ * Memory allocation profiling requires obj_exts for all caches.
+ * Memcg usually doesn't need them for normal kmalloc caches, but kmalloc types
+ * with a priority higher than KMALLOC_CGROUP can be aliased with KMALLOC_NORMAL.
+ */
+static __always_inline inline bool need_kmalloc_no_objext(void)
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
index 477fa471da18..4cc96c3ea18e 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -793,6 +793,12 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
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
@@ -800,6 +806,7 @@ EXPORT_SYMBOL(kmalloc_size_roundup);
 	KMALLOC_CGROUP_NAME(__short_size)			\
 	KMALLOC_DMA_NAME(__short_size)				\
 	KMALLOC_RANDOM_NAME(RANDOM_KMALLOC_CACHES_NR, __short_size)	\
+	KMALLOC_NO_OBJ_EXT_NAME(__short_size)			\
 	.size = __size,						\
 }
 
@@ -907,6 +914,12 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
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
index cf678f461725..b61225c3503b 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -1997,8 +1997,13 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	struct slabobj_ext *vec;
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
-	/* Prevent recursive extension vector allocation */
-	gfp |= __GFP_NO_OBJ_EXT;
+	/*
+	 * In most cases, obj_exts arrays are allocated from normal kmalloc.
+	 * However, normal kmalloc caches must allocate them from
+	 * KMALLOC_NO_OBJ_EXT caches to prevent recursion.
+	 */
+	if (is_kmalloc_normal(s))
+		gfp |= __GFP_NO_OBJ_EXT;
 	vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
 			   slab_nid(slab));
 	if (!vec) {
@@ -2014,6 +2019,22 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		return -ENOMEM;
 	}
 
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
+
 	new_exts = (unsigned long)vec;
 #ifdef CONFIG_MEMCG
 	new_exts |= MEMCG_DATA_OBJEXTS;
@@ -2034,7 +2055,6 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		 * assign slabobj_exts in parallel. In this case the existing
 		 * objcg vector should be reused.
 		 */
-		mark_objexts_empty(vec);
 		kfree(vec);
 		return 0;
 	} else if (cmpxchg(&slab->obj_exts, old_exts, new_exts) != old_exts) {
@@ -2061,14 +2081,6 @@ static inline void free_slab_obj_exts(struct slab *slab)
 		return;
 	}
 
-	/*
-	 * obj_exts was created with __GFP_NO_OBJ_EXT flag, therefore its
-	 * corresponding extension will be NULL. alloc_tag_sub() will throw a
-	 * warning if slab has extensions but the extension of an object is
-	 * NULL, therefore replace NULL with CODETAG_EMPTY to indicate that
-	 * the extension for obj_exts is expected to be NULL.
-	 */
-	mark_objexts_empty(obj_exts);
 	kfree(obj_exts);
 	slab->obj_exts = 0;
 }

-- 
2.53.0


