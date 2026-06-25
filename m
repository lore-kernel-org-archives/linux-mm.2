Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9E49CDE00B
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 23:00:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7520E6B00C9; Thu, 25 Jun 2026 19:00:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 701ED6B00CA; Thu, 25 Jun 2026 19:00:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6195D6B00CB; Thu, 25 Jun 2026 19:00:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B6D06B00C9
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 19:00:50 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B3DD31A02E7
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:00:49 +0000 (UTC)
X-FDA: 84919956618.23.C83B32D
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf28.hostedemail.com (Postfix) with ESMTP id BF1A0C000D
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 23:00:47 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kB3qgnNt;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782428448;
	b=Z6fhjDMyPhMh9idI/q+ennRHVW+XMiCDyCljaujfBWcWmMCWuFYM1pSU3PlAlHJRrtMh7S
	4dYeW6ku7U6K6WV3r39+YYD+Y/sBh86YDGHEjgkmhMtBDv7HSMvRcM6bqfkzeeZJapS5vG
	JhT2XrTXIg4K7Te3I2pbY7YV4M3bGjA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782428448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=iSrJIAU09eBQcjYrRC3cg8qPz+F7E6jQYiiILJlqlJY=;
	b=q1mdWYPcdlSrO89Y/pDLDAugfDPcwwMuKVlVAXiFh7aKe9adTVjs1dX43dMnpWwV2mEJaR
	jdZmZhSg6Ro/Y+Kf2gOcYyTw4JudlYfv+4KZpnFyerGKoYAiD7Qg2HORDjHY3Qs3xZuAhn
	JX2QIcSouA+PsLt169TLlw72fYoGk8k=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kB3qgnNt;
	spf=pass (imf28.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782428445;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=iSrJIAU09eBQcjYrRC3cg8qPz+F7E6jQYiiILJlqlJY=;
	b=kB3qgnNtCX9Cx6mPlmGhgJllN1K0o9EQg4C7HLba6cbeCke4szBFR6kp3qJMOT6KV5RIYv
	0E5UutdCVxGQBzR2q8/ctuDkHp/YGTgbmduVXNcN3j9SZZGjuVw2b64gkdqvAdRxcV3lxx
	/+B6gpODzkU5opnUzI8/4VxEcwhjQy8=
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Vlastimil Babka <vbabka@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Harry Yoo <harry@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Usama Arif <usama.arif@linux.dev>,
	Meta kernel team <kernel-team@meta.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Danielle Costantino <dcostantino@meta.com>
Subject: [PATCH] mm/slub: serve slabobj_ext array from a strictly larger kmalloc cache
Date: Thu, 25 Jun 2026 16:00:29 -0700
Message-ID: <20260625230029.703750-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BF1A0C000D
X-Stat-Signature: y764ambafibyogzrcsiuf1b6kbtfuf8p
X-HE-Tag: 1782428447-214727
X-HE-Meta: U2FsdGVkX18Dn092KHw5jGqvjJlq0skDRMPKNYK7zF9HV8nxHuV10w3ZOAkYOJo719t150G9o3vXX3JmCIN9MvdXDPnYcR9vC10hnsQNLlx0d7rQI+4UeF0iwpOOSIl2TTFOcg154RTnHkA99Z5btK/SRKqf0zVaPTiVraenqd1xyhckBD4306+/hiDzpZVhl4rpIy3RIZIRdp1oe/VZHDRNCMZaIPPCTbCsBzeonWzvjvggJ0VR+oOP2NKsCxrc7yNJsehN3uqtjvgYedbIH4pvNqmnIwenhCXMVi/uD92K/Oa6F8VTdsCWg8JnaW5GU64fym2WqeR9Zs7c0Q9gFAgQqufGx1PuHV7ro6xkwFibQCBDBgXW5zmvUwj88j5zrshm12IwumRmbaO1oDkFXqzTQZISDiuAwfOGF83ZANh/NXyQw95NgZnUtKxxifXoYsqDYqhNXkmhgal3olUXo2Hf1hKpaZ3exe5ynv1fM45XZONpnxDkyRzPcsZex2axKD1SpMTYVfVt76QRsps8lhzhQkpa6EYN0rcZZIqTtWM34SMl67IcFBlGaHGQUY3j28dEsT4tzZG6Cn2M97BSR34JWO6Umu87x1YKptazN6MYDQQES7jMUXtI4oKlEtkWKpYvIpzbSJD7+76PEbBZF1DsLhb/lkJx5F4VXWbuAWspzCkkJFAlT7CocbbuGcpI1eOR8gzg6W+vPZc1nBdCS0VUcgYqBAQTSi3iccGJNr1I5UoKuVJiVsesq80SkuLDS0f8UnPthLNzsI1WVKQ1zj7DhUuiKZHYsABIYOFjxn7Onvfme04RjBTEsT9GnYs8XLgPjUDqwIRq4zExluwfafJQzqYXIuv7kFdtADacE2ErY7Niir9fj4Ul/YOvrF+6nBBKomsEjI3k54HmNdGDijnvX3hLY7hB3GNpesgktmoX0FEQurOy2eko9r5zKw4xrCQbFOpA0o5wb02wqSw
 uWoZM8tD
 g35abOfuz85ZZg9xBb39Yhvhj0yzqkUFXql38XTC9hSRq7Q5IibEj1sbMSEHlw+Wo4oGdMArIIQGLmY+bsRze0LMs0/YlzPBmRlzfukaINS06rHpZQujDxYyUm5XX5/7klK0NOBjdNZAsdQqqAC4PujjI/qmZDAmeoF8v58fAQNJReiZRZXvyWs/UNma+sj4Aa65tsj0Xr0h+c9s+eSrXPN9e+Lf03U/0tx96dnbQR+ioDLWr3cN7KJSITi4jIfq+qlihlKWiC6OQJEclfoL6zRzs65IKyGMVFEkVXmR7grz71/5rj6oaKpeuFYc2Ja/AglvayzKCe0yLbnG0Kw73CVWA9S03QEU8kfem
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A production host in the Meta fleet (6.16 kernel, memory allocation
profiling enabled) panicked with a kernel stack overflow while a kernel
driver was freeing a resource:

  BUG: TASK stack guard page was hit
  Oops: stack guard page
  RIP: 0010:kfree+0x8/0x5d0
  Call Trace:
   __free_slab+0x66/0xc0
   kfree+0x3f0/0x5d0
   ... ( ~125x __free_slab <-> kfree ) ...
   <kernel driver freeing a resource>
   do_syscall_64

The crash dump shows a 125-deep __free_slab<->kfree recursion that
overflowed the 16 KiB kernel stack.

What happened: a KMALLOC_NORMAL slab's obj_exts array (used by allocation
profiling / memcg accounting) is itself kmalloc()'d from a KMALLOC_NORMAL
cache, so the "slab holds another slab's obj_exts array" relation can form
cycles.  With sizeof(struct slabobj_ext) == 16 and the host's geometry:

  - kmalloc-512 has 64 objects/slab -> array is 64*16 == 1024 bytes,
    served from kmalloc-1k;
  - kmalloc-1k  has 32 objects/slab -> array is 32*16 ==  512 bytes,
    served from kmalloc-512.

A kmalloc-512 slab and a kmalloc-1k slab therefore hold each other's
obj_exts array.  Discarding one frees the other's array, which empties and
discards that slab, which frees the first's array, and so on:
__free_slab() -> free_slab_obj_exts() -> kfree() -> discard_slab() ->
__free_slab() recurses along the cycle until the stack is exhausted.  The
dump confirms it: the recursion's slabs strictly alternate kmalloc-512
(obj_exts in kmalloc-1k) and kmalloc-1k (obj_exts in kmalloc-512), and
mem_alloc_profiling_key was enabled.

Commit 280ea9c3154b ("mm/slab: avoid allocating slabobj_ext array from
its own slab") is not sufficient: it bumps the allocation size only when
the array would come from the *same* cache (object_size ==).  At the
geometry above neither cache is self-referential (512 != 1024 and
1024 != 512), so the bump never triggers and the kmalloc-512 <-> kmalloc-1k
cross cycle remains.

Fix it structurally by removing cycles of every shape: serve the array
from a cache strictly larger than the one it describes whenever it would
otherwise come from the same or a smaller cache.  Every reference edge
then points from a smaller to a larger cache (here kmalloc-1k's array
moves to kmalloc-2k), so the relation is a DAG and cannot contain a cycle.
No slab can be self- or cross-pinned, the tear-down recursion is bounded
by the number of kmalloc size classes (it terminates at the large-kmalloc
path, which carries no obj_exts), and profiling/accounting coverage is
unchanged - the array is still allocated, only relocated.

Reproduced on next-20260623 at the same geometry: churning
kmalloc-512/kmalloc-1k under vm.mem_profiling and then shrinking leaves
kmalloc-512 with thousands of unreclaimable objects without this patch
(8056) and at baseline with it (847).

Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
Reported-by: Danielle Costantino <dcostantino@meta.com>
---
 mm/slub.c | 26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9ec774dc7009..48e54d340865 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2124,15 +2124,14 @@ static inline void init_slab_obj_exts(struct slab *slab)
 }
 
 /*
- * Calculate the allocation size for slabobj_ext array.
+ * Size of the slabobj_ext array for @slab.
  *
- * When memory allocation profiling is enabled, the obj_exts array
- * could be allocated from the same slab cache it's being allocated for.
- * This would prevent the slab from ever being freed because it would
- * always contain at least one allocated object (its own obj_exts array).
- *
- * To avoid this, increase the allocation size when we detect the array
- * may come from the same cache, forcing it to use a different cache.
+ * The array is itself kmalloc()'d. If it came from the same or a smaller
+ * kmalloc cache than @s, the "slab holds another slab's array" relation could
+ * form a cycle (self, or e.g. kmalloc-512 <-> kmalloc-1k) that pins the slabs
+ * forever and recurses via free_slab_obj_exts() -> kfree() -> discard_slab()
+ * at teardown. Force it into a strictly larger cache to keep that relation a
+ * DAG (acyclic).
  */
 static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
 					 struct slab *slab, gfp_t gfp)
@@ -2147,14 +2146,9 @@ static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
 		return sz;
 
 	obj_exts_cache = kmalloc_slab(sz, NULL, gfp, __kmalloc_token(0));
-	/*
-	 * We can't simply compare s with obj_exts_cache, because partitioned kmalloc
-	 * caches have multiple caches per size, selected by caller address or type.
-	 * Since caller address or type may differ between kmalloc_slab() and actual
-	 * allocation, bump size when sizes are equal.
-	 */
-	if (s->object_size == obj_exts_cache->object_size)
-		return obj_exts_cache->object_size + 1;
+	/* compare object_size, not the cache pointer (partitioned kmalloc caches) */
+	if (obj_exts_cache->object_size <= s->object_size)
+		return s->object_size + 1;
 
 	return sz;
 }
-- 
2.53.0-Meta


