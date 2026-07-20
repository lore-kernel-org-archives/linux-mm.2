Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51713C4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:16:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7AAD16B009B; Mon, 20 Jul 2026 10:16:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7821D6B009D; Mon, 20 Jul 2026 10:16:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FCDF6B009E; Mon, 20 Jul 2026 10:16:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 26BB36B009B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:16:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A7A5E1601C1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:46 +0000 (UTC)
X-FDA: 85009356012.24.790E758
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id D8FBB40010
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:16:44 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mKBvlIPO;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557005;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDoguJb49gTUoNmifS0Dpu7IJ68YU71Jp33Sr8F+9ZU=;
	b=WK39l2gBSPTxdc+q0PdVEqlewwrUtkMvY5KKkaS6sq88VIdj8yFttvLCfZJvjRw6pr2JY2
	3T5t0Kw4fcfrgAd79YZHkBq4slPAcNuYg08C1SmGi/UUdEtLtibaXFvauS08VC/bcr9qHC
	pzUoDqc2W0HsHB9/o2k04t32DTLiePs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mKBvlIPO;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557005;
	b=QUO7ZxJLTmBUf0a4opONcMziyZUUPcUWOjtXHWsCSdf/NAbFf2qBzwgcK8ntmKNiaZS0bv
	KP24xenC3UtVXZumbIplu29ToM6xsbybzPWVDgjs89FDlOYjtyVygX0jrhRzlfy1NPnlnL
	/bYglqIOWNoD7/46+gAiU6Nj34ysjkg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 39EDE40962;
	Mon, 20 Jul 2026 14:16:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E6201F000E9;
	Mon, 20 Jul 2026 14:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557004;
	bh=YDoguJb49gTUoNmifS0Dpu7IJ68YU71Jp33Sr8F+9ZU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=mKBvlIPOQY+qIh+hV6wOGqLgdCnncDf+1ZqyMqL7VLG29XazRyXy9O2L3v0/1Ikxe
	 AmixbS8Xm5vjAA+YYYmFXhEs543gug+5xNAJ5jqvomohb2KBwc6+QcwrSbflnDyX1r
	 R4W7Rjttqwh7FzussL6Ki+DLHguSUHLc004b1xhy0xrKAofamYhxWprBFUjR6fXVwu
	 EbwQxwdmOfqlZKfaXE16iGhggLQ9xq4NQUuENVqTWHf+GUbi+a+XByueXonX8mN5Vi
	 L2shYE+Xu9oRlL/g27C7MibLRb1d+9I1HL/dC3FPMchISHTJ9j28ANhlrZ4DDDJXt4
	 XS6cR7SCY+Mow==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:19 +0200
Subject: [PATCH v2 05/13] mm/slab: make slab_obj_ext() determine object
 index
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-5-2fa7c6f60dbe@kernel.org>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspam-User: 
X-Rspamd-Queue-Id: D8FBB40010
X-Rspamd-Server: rspam01
X-Stat-Signature: suocd59zp7u74yarr37ham8hg87pb7tw
X-HE-Tag: 1784557004-637749
X-HE-Meta: U2FsdGVkX19IFKVR9JbG1coQq5sY7ThatU4hDiRYmpY5yOuwCyHRMvJI+73DiuzQCHyMqovyPpYaQLRl6XRpm9EfZ1/IwRhk8FngaOUQNG50C+z0SUlnLqMrQqfl96icbl3Pr8dLeYLgHdDQTt5rf9/Rk69hv5occ6wi8qjeAZfJBgUvApawqnIrXUs1/WWlricot+lsfmkNxivHyI7LCLqeH6Ok27U/kG6Cyf1QsKFsNRYU0NPeBaFGTf7xLCy+wVN5WKZjfr3ArLsJZ7U5XtQrDav0U0txUt93f435Pd2xPQ7ALrHEPy+iVJo/UNpg/YWhGp0gy3OIP4DBdHHBElUaH6kbTi+GQQT2lR76lw6U/yGxbXrtgnY+COlLNsAeSrFsUR4WxCe/49ttLTs8q7c3sxi7xr7wbduXly/CylasVyqrWq2nzbJGtTLMiNNz1HM5DXzHYeiGTPytWIXAqfkP0DOxe8oHIPGWEI0xvA/q5eCCoohr87rtQR7mvxn0i+0wcV5zSRb4LU9CSJeMDF1wl5XG53ajGOhu9ULToFokDVQ+Q/QX8cfStE79XFaNm3ZnakhGaJJ1gf6b1tProKjp29j1ZnKHq+XN5FzUPdAnT9z22+1VYQDsOZcWNxVpfjscSTGCAzfaETjT+Hj1XtM8RMsvg6nh7/NUnRqFkUgKr+Rr6Hd3fpU4X7s1EPMboKFyi6HqTpr5ZGKRInSt7JIxLdEwMFba+sQf5CwUx5fjE888EZzek7jAYculVyg/3JUZBeR1SVyEyHxoeCR14PLPXwbFSvHbVJcBm+Mwo/IwmHbFo44iakTbJ176s/brY5MaopVazGZGvCLsfjSkUr2p8Iaf2nu7vnKHbhfmiqOZiramtSrUdMcv8RznRMDB6tkyq7LOTzSUZtwQLLcYp6lCkgd3pLdt1uity0ZVv8/yLsS76mNz1ILyE2/teS2h7mSuxfU4NT2eeHmSBYq
 dGraJePy
 6hkNq2pWV/eX/hNHFV8FQnKjFAYo/0rHitTCO5v6HaQDvFlrcYK9n+Az6+eGbPT1kxPc+H6HuII/lZQeu8PLC043QjzSeRxf3ZF54UGvka7oRTOM1A4Lugti6/slbxCWi6HqQMp6KM3rTAyEL9o+0rpuYldZujAxYgN9YEieENmSLUEQNEx7SaJeXP4/RfGfsJ26yBtmpXCDlIrGEifTSKyHYdciU4A6YG+8iY19ELh3Jwm6Z1waTBd7LGLgIvpRSaW4ukUkBpCSr5AckuUGIImcgtwz+xV3GBK7LG/i1LidSicDci6tclFMcOO6iJH+48L00
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

All callers perform the same obj_to_index() calculation to pass the
index. Simplify by passing object pointer instead and determining the
index by slab_obj_ext().

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/memcontrol.c | 12 +++---------
 mm/slab.h       | 19 +++++++++++--------
 mm/slub.c       | 22 +++++++---------------
 3 files changed, 21 insertions(+), 32 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6dc4888a90f3..4e427286a88a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2865,15 +2865,13 @@ struct mem_cgroup *mem_cgroup_from_obj_slab(struct slab *slab, void *p)
 	 */
 	unsigned long obj_exts;
 	struct slabobj_ext *obj_ext;
-	unsigned int off;
 
 	obj_exts = slab_obj_exts(slab);
 	if (!obj_exts)
 		return NULL;
 
 	get_slab_obj_exts(obj_exts);
-	off = obj_to_index(slab->slab_cache, slab, p);
-	obj_ext = slab_obj_ext(slab, obj_exts, off);
+	obj_ext = slab_obj_ext(slab->slab_cache, slab, obj_exts, p);
 	if (obj_ext->objcg) {
 		struct obj_cgroup *objcg = obj_ext->objcg;
 
@@ -3541,7 +3539,6 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	size_t obj_size = obj_full_size(s);
 	struct obj_cgroup *objcg;
 	struct slab *slab;
-	unsigned long off;
 	size_t i;
 
 	/*
@@ -3616,8 +3613,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 
 		obj_exts = slab_obj_exts(slab);
 		get_slab_obj_exts(obj_exts);
-		off = obj_to_index(s, slab, p[i]);
-		obj_ext = slab_obj_ext(slab, obj_exts, off);
+		obj_ext = slab_obj_ext(s, slab, obj_exts, p[i]);
 		obj_cgroup_get(objcg);
 		obj_ext->objcg = objcg;
 		put_slab_obj_exts(obj_exts);
@@ -3635,10 +3631,8 @@ void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 		struct obj_cgroup *objcg;
 		struct slabobj_ext *obj_ext;
 		struct obj_stock_pcp *stock;
-		unsigned int off;
 
-		off = obj_to_index(s, slab, p[i]);
-		obj_ext = slab_obj_ext(slab, obj_exts, off);
+		obj_ext = slab_obj_ext(s, slab, obj_exts, p[i]);
 		objcg = obj_ext->objcg;
 		if (!objcg)
 			continue;
diff --git a/mm/slab.h b/mm/slab.h
index 7bd361447c54..64cec02b5016 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -579,7 +579,7 @@ struct slabobj_ext {
  * obj_exts = slab_obj_exts(slab);
  * if (obj_exts) {
  *         get_slab_obj_exts(obj_exts);
- *         obj_ext = slab_obj_ext(slab, obj_exts, obj_to_index(s, slab, obj));
+ *         obj_ext = slab_obj_ext(s, slab, obj_exts, obj);
  *         // do something with obj_ext
  *         put_slab_obj_exts(obj_exts);
  * }
@@ -639,21 +639,24 @@ static inline unsigned int slab_get_stride(struct slab *slab)
 /*
  * slab_obj_ext - get the pointer to the slab object extension metadata
  * associated with an object in a slab.
+ * @s: cache that the slab blongs to
  * @slab: a pointer to the slab struct
  * @obj_exts: a pointer to the object extension vector
- * @index: an index of the object
+ * @obj: a pointer to the object
  *
  * Returns a pointer to the object extension associated with the object.
  * Must be called within a section covered by get/put_slab_obj_exts().
  */
-static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
-					       unsigned long obj_exts,
-					       unsigned int index)
+static inline struct slabobj_ext *
+slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
+	     const void *obj)
 {
 	struct slabobj_ext *obj_ext;
+	unsigned int index;
 
 	VM_WARN_ON_ONCE(obj_exts != slab_obj_exts(slab));
 
+	index = obj_to_index(s, slab, obj);
 	obj_ext = (struct slabobj_ext *)(obj_exts +
 					 slab_get_stride(slab) * index);
 	return kasan_reset_tag(obj_ext);
@@ -669,9 +672,9 @@ static inline unsigned long slab_obj_exts(struct slab *slab)
 	return 0;
 }
 
-static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
-					       unsigned long obj_exts,
-					       unsigned int index)
+static inline struct slabobj_ext *
+slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
+	     const void *obj)
 {
 	return NULL;
 }
diff --git a/mm/slub.c b/mm/slub.c
index 8c1031989e41..aa99d7eb6a4d 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2070,11 +2070,10 @@ static inline void mark_obj_codetag_empty(const void *obj)
 	obj_slab = virt_to_slab(obj);
 	slab_exts = slab_obj_exts(obj_slab);
 	if (slab_exts) {
+		struct slabobj_ext *ext;
+
 		get_slab_obj_exts(slab_exts);
-		unsigned int offs = obj_to_index(obj_slab->slab_cache,
-						 obj_slab, obj);
-		struct slabobj_ext *ext = slab_obj_ext(obj_slab,
-						       slab_exts, offs);
+		ext = slab_obj_ext(obj_slab->slab_cache, obj_slab, slab_exts, obj);
 
 		if (is_kfence_address(obj)) {
 			put_slab_obj_exts(slab_exts);
@@ -2368,10 +2367,8 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	 * check should be added before alloc_tag_add().
 	 */
 	if (obj_exts) {
-		unsigned int obj_idx = obj_to_index(s, slab, object);
-
 		get_slab_obj_exts(obj_exts);
-		obj_ext = slab_obj_ext(slab, obj_exts, obj_idx);
+		obj_ext = slab_obj_ext(s, slab, obj_exts, object);
 		alloc_tag_add(&obj_ext->ref, current->alloc_tag, s->size);
 		put_slab_obj_exts(obj_exts);
 	} else {
@@ -2392,7 +2389,6 @@ static noinline void
 __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 			       int objects)
 {
-	int i;
 	unsigned long obj_exts;
 
 	/* slab->obj_exts might not be NULL if it was created for MEMCG accounting. */
@@ -2404,13 +2400,11 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
 		return;
 
 	get_slab_obj_exts(obj_exts);
-	for (i = 0; i < objects; i++) {
-		unsigned int off = obj_to_index(s, slab, p[i]);
-
+	for (int i = 0; i < objects; i++) {
 		if (is_kfence_address(p[i]))
 			continue;
 
-		alloc_tag_sub(&slab_obj_ext(slab, obj_exts, off)->ref, s->size);
+		alloc_tag_sub(&slab_obj_ext(s, slab, obj_exts, p[i])->ref, s->size);
 	}
 	put_slab_obj_exts(obj_exts);
 }
@@ -2495,7 +2489,6 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 	struct kmem_cache *s;
 	struct page *page;
 	struct slab *slab;
-	unsigned long off;
 
 	page = virt_to_page(p);
 	if (PageLargeKmalloc(page)) {
@@ -2535,8 +2528,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 	obj_exts = slab_obj_exts(slab);
 	if (obj_exts) {
 		get_slab_obj_exts(obj_exts);
-		off = obj_to_index(s, slab, p);
-		obj_ext = slab_obj_ext(slab, obj_exts, off);
+		obj_ext = slab_obj_ext(s, slab, obj_exts, p);
 		if (unlikely(obj_ext->objcg)) {
 			put_slab_obj_exts(obj_exts);
 			return true;

-- 
2.55.0


