Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 630E4FD0048
	for <linux-mm@archiver.kernel.org>; Sun,  1 Mar 2026 01:25:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD1B56B008A; Sat, 28 Feb 2026 20:25:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C7F126B008C; Sat, 28 Feb 2026 20:25:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7DFD6B0092; Sat, 28 Feb 2026 20:25:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A721A6B008A
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 20:25:37 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4C057160390
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:25:37 +0000 (UTC)
X-FDA: 84495751914.28.7CEAFB1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 93DEC20004
	for <linux-mm@kvack.org>; Sun,  1 Mar 2026 01:25:35 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ui2p/pOk";
	spf=pass (imf03.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772328335;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fm41tni+AfmnAob12FrBKQEWjgicG904t3XtWJJ/viE=;
	b=Q6hwVp1V6DWNTz+hLJeszuEjElSu8uP2Qh0+DIWxEXy7gIfY+B1MwiSuDrAGz2KIJWgGU3
	FQa836y2+FXXRm3IGXrXhHBKuZZwfQrz3gUqbYatVBUsuv/NEaZZ7g4oR0XmKfkElukgmL
	JMQ1i8AI0Z8VXQj68l2N8FZS4xVXRzI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ui2p/pOk";
	spf=pass (imf03.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772328335; a=rsa-sha256;
	cv=none;
	b=IHi02G4Eq+RVqJ2lKw8fuHrnMpBn4GRiNAMwAluoyQR+SHYM/biuC3SPR+ilg+Y+7lptqG
	3dsqGOelr9cWwJIFKq0mY9QBf7CTph0YbBIDTkXLQtsHJwwWHARdbuRC6Zy7ugCKL+dYOb
	2miBHK4qOz9dcZ//Zx1b9+nhgG3nR/U=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B4BA04022A;
	Sun,  1 Mar 2026 01:25:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED820C19421;
	Sun,  1 Mar 2026 01:25:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772328334;
	bh=Q9Okaugaz+aU0hKuYTjGGh7QDKeQjLlPanWsAccytIw=;
	h=From:To:Cc:Subject:Date:From;
	b=ui2p/pOkcfTuuorty0OjyEd6wRdFiDR1P8vsT4Ex/N4fGLh7I2xuMY2j9ez/rka45
	 Jf6kBnTJjIfAdMtv8eINU+kF153ogMcmuKUoletB9iff6ooFxslpDPDB0eH68ChpjL
	 757CqX4X9m6/mctp9CIewriTJKZiPkXtdEiet/niGB8ScYlicU52a8tmj6jsnak/g0
	 vlDmn/3o41zrooyx0XnQ3u0rxtT0UUqdn9E8aH1XZDymk9bGkVGbgQ/uELU/qzIWBc
	 CbtV57pg9HVOvcyP0dJxP0AQki5UP0aRanczetkDEhnXyntu06kvkRpEgPLF9Y2t79
	 fsayBc0JSeQiw==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org,
	harry.yoo@oracle.com
Cc: kernel test robot <oliver.sang@intel.com>,
	Hao Li <hao.li@linux.dev>,
	Vlastimil Babka <vbabka@suse.cz>,
	linux-mm@kvack.org
Subject: FAILED: Patch "mm/slab: avoid allocating slabobj_ext array from its own slab" failed to apply to 6.12-stable tree
Date: Sat, 28 Feb 2026 20:25:32 -0500
Message-ID: <20260301012532.1682677-1-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
X-Patchwork-Hint: ignore
X-stable: review
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 93DEC20004
X-Rspamd-Server: rspam08
X-Stat-Signature: wa4zmhypugmwpfcgqr1hrhmmjmrkeo7t
X-HE-Tag: 1772328335-743357
X-HE-Meta: U2FsdGVkX1+ZQhIEAzDG2fLJeqSfCRYBJ/Ifs68lqJqWzywMBtnvXy7+qeMYMUa2XdDsOTL6QhUzIqXUaBBccgd4XPNSHtLwHEUV/GPO59dT1EfSLtKXQ1AQOgP3aPOWjzhXir98hqUKkKCM3mbbItnFytjfmFoMcaw9Ul+SSa5H9EZ4ioBzB6hYjIu/fuziIVG9ZmMuWRDy8Fbgk4eg2u/sgfia7UXlMSIThkrWUX65TTbKlYknnJKte+0Npoklm3WrTg1J7TeZWAF0/1+bCiFZ03ue9P/5EVV8e6By24GCGXHQIxprJqkElGY2raBvgpTGOpwhsUIJsfNJVEZuXiSr3+i5GU69GeOOZSmcoIjnqzqMOSnd2Vc6ern24suBFODqr0lnay7P9YXz0+T5O9tnnWE+uKzi1WloTwUlt0nq2vUTWGqzWwsGnPUP6zo8KnK5m6YS7793/elUHjF1G4u3nCNAgRjW6SHRZGGexW5PXxKVcNQjFNrkpICyxNCbRRaTXSw24GgljrmRpQ/iJdE0BFBveOBoL7AL2MUVMZrOQjGTwT8b3DtvalQis00pCYocYYTSAjMkO9A1wNhlpSKUOrLMYTlDnklx9qsinzxhBbpj3t0jEtPXxC6sKiR4rKmhF7s0qR3RilMa3gQ+1aYOkHeEt+70KObPDm6g5doeBtaqcKVRjIfvcxZrTd4YMa/CsBxGNv2uNuLHnPktJYSMBJF8jsXx8zrR6uwH1Mgew9XXnvZKxsztvDuR9Clw4MQ0tSAFrUIMHPpi8ToZKUWO57MIsibjCdOItP9XMoB6i3DkcpsxLuZLAKdsheAbS0yWBQ06p3W7zvkbtrMlgmRgNJ8W/ccRzzp62N8IColsw8VhOtkJd6SvLtGjjDODt37TyEgEt/UUNtJlakM6tcZgyw38hGZnhnUjFWB2048wa5RM9qoWs93etIKqs//Iwas7X1X5MYBcH7N4LvY
 5HKgQXTj
 +V5BzmPd7mFhbffayPJzPbwlqSobbANbTWahpOjwcgUxGFPu3kzI+gPLz7ERpTQx2QO18bx1cER9T1KTbEVYNqfcGjT/s22HM13q8BK5vtbxfmvqrDYJDLqadFDXU3K9dYntJ2fadg1czXEtPqYWybD35k8BBF+1oTqFTS1LJh45K26AbiBzf0WEcTD7xGj4pEV+117y1d2x43Fq8c0Zv7P50m1qQPd/QTFVWzEaFXH7S/NKZk2efO1WjRkPNoWVZAzcvfPKPSkVnEcY2cewntmXZ4KfbXm/coc+P5gfneuo9HRU1bIR4pmIXi4kqcYCD3j2aNrcQJOtdGWWwC/Hd5pLtQprDscxXp0ZYc4jdj1DLzoHhUd8ojuI/X5KCb4nelOKQMSmMdeo40+UrOd8DYz8ffe6YQIFczz/Kd4+G5IFN2OSYOEgtCaMn4w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The patch below does not apply to the 6.12-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Thanks,
Sasha

------------------ original commit in Linus's tree ------------------

From 280ea9c3154b2af7d841f992c9fc79e9d6534e03 Mon Sep 17 00:00:00 2001
From: Harry Yoo <harry.yoo@oracle.com>
Date: Mon, 26 Jan 2026 21:57:14 +0900
Subject: [PATCH] mm/slab: avoid allocating slabobj_ext array from its own slab

When allocating slabobj_ext array in alloc_slab_obj_exts(), the array
can be allocated from the same slab we're allocating the array for.
This led to obj_exts_in_slab() incorrectly returning true [1],
although the array is not allocated from wasted space of the slab.

Vlastimil Babka observed that this problem should be fixed even when
ignoring its incompatibility with obj_exts_in_slab(), because it creates
slabs that are never freed as there is always at least one allocated
object.

To avoid this, use the next kmalloc size or large kmalloc when
the array can be allocated from the same cache we're allocating
the array for.

In case of random kmalloc caches, there are multiple kmalloc caches
for the same size and the cache is selected based on the caller address.
Because it is fragile to ensure the same caller address is passed to
kmalloc_slab(), kmalloc_noprof(), and kmalloc_node_noprof(), bump the
size to (s->object_size + 1) when the sizes are equal, instead of
directly comparing the kmem_cache pointers.

Note that this doesn't happen when memory allocation profiling is
disabled, as when the allocation of the array is triggered by memory
cgroup (KMALLOC_CGROUP), the array is allocated from KMALLOC_NORMAL.

Reported-by: kernel test robot <oliver.sang@intel.com>
Closes: https://lore.kernel.org/oe-lkp/202601231457.f7b31e09-lkp@intel.com [1]
Cc: stable@vger.kernel.org
Fixes: 4b8736964640 ("mm/slab: add allocation accounting into slab allocation and free paths")
Signed-off-by: Harry Yoo <harry.yoo@oracle.com>
Link: https://patch.msgid.link/20260126125714.88008-1-harry.yoo@oracle.com
Reviewed-by: Hao Li <hao.li@linux.dev>
Signed-off-by: Vlastimil Babka <vbabka@suse.cz>
---
 mm/slub.c | 60 ++++++++++++++++++++++++++++++++++++++++++++++++-------
 1 file changed, 53 insertions(+), 7 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index afc3e511ff395..65b6d07ef20e6 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2092,6 +2092,49 @@ static inline void init_slab_obj_exts(struct slab *slab)
 	slab->obj_exts = 0;
 }
 
+/*
+ * Calculate the allocation size for slabobj_ext array.
+ *
+ * When memory allocation profiling is enabled, the obj_exts array
+ * could be allocated from the same slab cache it's being allocated for.
+ * This would prevent the slab from ever being freed because it would
+ * always contain at least one allocated object (its own obj_exts array).
+ *
+ * To avoid this, increase the allocation size when we detect the array
+ * may come from the same cache, forcing it to use a different cache.
+ */
+static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
+					 struct slab *slab, gfp_t gfp)
+{
+	size_t sz = sizeof(struct slabobj_ext) * slab->objects;
+	struct kmem_cache *obj_exts_cache;
+
+	/*
+	 * slabobj_ext array for KMALLOC_CGROUP allocations
+	 * are served from KMALLOC_NORMAL caches.
+	 */
+	if (!mem_alloc_profiling_enabled())
+		return sz;
+
+	if (sz > KMALLOC_MAX_CACHE_SIZE)
+		return sz;
+
+	if (!is_kmalloc_normal(s))
+		return sz;
+
+	obj_exts_cache = kmalloc_slab(sz, NULL, gfp, 0);
+	/*
+	 * We can't simply compare s with obj_exts_cache, because random kmalloc
+	 * caches have multiple caches per size, selected by caller address.
+	 * Since caller address may differ between kmalloc_slab() and actual
+	 * allocation, bump size when sizes are equal.
+	 */
+	if (s->object_size == obj_exts_cache->object_size)
+		return obj_exts_cache->object_size + 1;
+
+	return sz;
+}
+
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		        gfp_t gfp, bool new_slab)
 {
@@ -2100,26 +2143,26 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	unsigned long new_exts;
 	unsigned long old_exts;
 	struct slabobj_ext *vec;
+	size_t sz;
 
 	gfp &= ~OBJCGS_CLEAR_MASK;
 	/* Prevent recursive extension vector allocation */
 	gfp |= __GFP_NO_OBJ_EXT;
 
+	sz = obj_exts_alloc_size(s, slab, gfp);
+
 	/*
 	 * Note that allow_spin may be false during early boot and its
 	 * restricted GFP_BOOT_MASK. Due to kmalloc_nolock() only supporting
 	 * architectures with cmpxchg16b, early obj_exts will be missing for
 	 * very early allocations on those.
 	 */
-	if (unlikely(!allow_spin)) {
-		size_t sz = objects * sizeof(struct slabobj_ext);
-
+	if (unlikely(!allow_spin))
 		vec = kmalloc_nolock(sz, __GFP_ZERO | __GFP_NO_OBJ_EXT,
 				     slab_nid(slab));
-	} else {
-		vec = kcalloc_node(objects, sizeof(struct slabobj_ext), gfp,
-				   slab_nid(slab));
-	}
+	else
+		vec = kmalloc_node(sz, gfp | __GFP_ZERO, slab_nid(slab));
+
 	if (!vec) {
 		/*
 		 * Try to mark vectors which failed to allocate.
@@ -2133,6 +2176,9 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 		return -ENOMEM;
 	}
 
+	VM_WARN_ON_ONCE(virt_to_slab(vec) != NULL &&
+			virt_to_slab(vec)->slab_cache == s);
+
 	new_exts = (unsigned long)vec;
 	if (unlikely(!allow_spin))
 		new_exts |= OBJEXTS_NOSPIN_ALLOC;
-- 
2.51.0





