Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22498C43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 02:44:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4E0F6B00C7; Mon, 29 Jun 2026 22:44:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D25136B00C8; Mon, 29 Jun 2026 22:44:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C14086B00C9; Mon, 29 Jun 2026 22:44:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8BD946B00C7
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 22:44:07 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 132C0167AA7
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:44:07 +0000 (UTC)
X-FDA: 84935034534.09.7DD5879
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5D95120002
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 02:44:05 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JOg43IoH;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782787445;
	b=pO390YQjKdtwgPQLTlqOg1Q87rW39uM7+goLWwBOFtfrmifiosJhiK/DrLVsIcTNksjCUK
	RjCWefzBG+LTfMhRJMuJ1lCRhp8OxsZG+pmR+cJbj8q3UKkTORNj47HfaS8Q8mSALPScpT
	KxAh1LHm7FTyiIgz+y8Y7gfYMBSVCew=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782787445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=przQJnpstYbr3eVo4htMKq85wkvryQTqcf4xu3NpvDY=;
	b=ynv1gr2ge7ELaJsZzGnqi0vrWmAhQauiZidaLPhChp+AZYskCAuUZAYZo3wMX6BbGZgdgU
	SkvC657scT/oxEtU0Gvibg1ygSwjf5iFrVcswzJKaJS84RvoSMzb4ujF3TcO8S3adUP0PY
	FtlgdsY6iXL6boZxLuwp+nIG2wcrnCw=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JOg43IoH;
	spf=pass (imf31.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782787443;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=przQJnpstYbr3eVo4htMKq85wkvryQTqcf4xu3NpvDY=;
	b=JOg43IoH/WE5Oo93MNa7XuGTzkdCdWIfByQQECpkoeup9Vvtuzez//jZzxPlCLNseepAwL
	gQAUnp0FhKuIW1XBMoYMn6Ioe1EdJFBpxOqS8A/oE1S5CYsvxPv/Xp/EYX0Zdny3E02UDw
	aqHK+MCn95+QgNTaeLnn+b3NzgpNlxs=
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
	Danielle Costantino <dcostantino@meta.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/slub: serve slabobj_ext array from a strictly larger kmalloc cache
Date: Mon, 29 Jun 2026 19:43:57 -0700
Message-ID: <20260630024357.3591304-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5D95120002
X-Stat-Signature: 87aepgtz3nwom7yddmjpprhj9mngiy94
X-HE-Tag: 1782787445-311976
X-HE-Meta: U2FsdGVkX18NOwQCClZz2Ah0Rnu0OIU72Ugfm+SPDbaSJKD079gIP0Ny0pT8KsnQd1nf+b//MbEoMzGTH538gHduzQ2v2StK2+vbJ5arAQX4T6/176JoVVElS5jCouo4TW9xDpp65xzNHwZpWx7LAiY5FWcjOtcwvf4l1ZN6TR9yokx/gf6NGjJ2r3uyaZmuxyuFrX9Q2kYmM49OOPf2Rb2x9CFBkSSfAyqFzg5CtBMQOjMZDgUSjq3OFCq1SaamHODAbTXAWpzX3B+vH5eGL3i9xUL0aQAMprnZT6tOoMN7QECy7mnC7PiK9Se81uMtGs6gzzDfyevccEjkU0mUDkUVQjvJFM60KvcICegfEGPHXAbnuVCWlMcNWv98Q2rU/G60s1onlsKJneaB3UuuObLqYsZeOK+HGsLsLTdf4MgY67yHSJdoMRyKOF/tT61hNM8GIZcfwmj1pIBfocKJZxEUJMb+QrJiCvDNTxXImowQ8Hk82Kzxjmudx4iNb2vHr03D4TQmvV+Q45fSEiBnZ9VirPdOtF9mdEPOrDgq0H5Zo6lok/q1af2CToQIx8wg6YDzPv8QI3QwfuBputkGle6glxP+FBmbpzh2ZW/rzcxvl5+/Hj73trOHCDVh6t/yBoLO8/Npy0MbCUtXdTPkdTkn9mZkg4WdKr8hUcM1hO+Zz2K2GOw+9GqcZ3H8a1iKqcPoTAVuwt7VZSCW5Bv0RSeS6p3L5l8WM63e68ZLW+DzvH+fVlV7Ec13xukFUY809cgmTMwRgykSLsXPUhiql5KKePa7JlrhKvlPefnFX6F/XC4TRO42Y0U4xI7RQ+BeUdUakgfnhrM+aLQ2QnzdAB+ryclshlUETx4+ekWXIVYGGKLUW8/DbGkP6HCOjAJUGB3pdHI12zHIElO2FJdphaCy5j4Dyq22VnLHGmut0yPQHPhEVJzq+EmyUwTfOQKYQgpyPU/gqeQdAJAQtJM
 w/bGT30B
 DpY8WYTc27Oqha9fD9FB6AQChISxpUfjZ0rPx5fvaiMaLAPQmqduroDvAW4Gleo65vcysg9oVKcvVxfFqE9CMAh/wtC0zno8tkCvt91PbYHVOgV11BBLzHkJ8KHCgniN1aaqwGgxqw55ETl9KimWFddSUz4o5njuZbAfBrNIBawrd1lLR58FuaIpKcDXxjZktucg6MXvzQaXS48kJLaj85R3DQ+ZS7xopgRptVnyKwR9AZhZ5WA8biPI49P9coqEljZ5xuJdg164X4pQ922RnXTXvDtEV46Obk6uwn4xbSlT/89bYGdKcDjCQ0TS0Vmg5vniBwzsLgN7wvjo=
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
Reported-by: Danielle Costantino <dcostantino@meta.com>
Cc: stable@vger.kernel.org
Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
---
Changes in v2:
- Drop the now-stale comment above the object_size comparison (Harry Yoo).
- Add a comment above the !is_kmalloc_normal() check explaining that the
  size is bumped only when the object itself comes from KMALLOC_NORMAL,
  i.e. via memory allocation profiling or memcg on SLUB_TINY (Harry Yoo).
- Add Cc: stable; v6.12 and v6.18 are affected (Harry Yoo).
- Restore the Reported-by tag.
No functional change from v1 (comments and tags only).

v1: https://lore.kernel.org/all/20260625230029.703750-1-shakeel.butt@linux.dev/

 mm/slub.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 9ec774dc7009..0c30d689820a 100644
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
@@ -2143,18 +2142,19 @@ static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
 	if (sz > KMALLOC_MAX_CACHE_SIZE)
 		return sz;
 
+	/*
+	 * Only bump the size when the object (not the obj_exts array) is
+	 * allocated from KMALLOC_NORMAL, either by memory allocation profiling
+	 * or memcg on SLUB_TINY with __GFP_RECLAIMABLE|__GFP_ACCOUNT.
+	 * Otherwise, obj_exts allocations cannot form a cycle between
+	 * kmalloc caches.
+	 */
 	if (!is_kmalloc_normal(s))
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
+	if (obj_exts_cache->object_size <= s->object_size)
+		return s->object_size + 1;
 
 	return sz;
 }
-- 
2.53.0-Meta


