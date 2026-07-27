Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C26C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 12:55:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 30FBB6B00F5; Mon, 27 Jul 2026 08:54:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E7506B00F6; Mon, 27 Jul 2026 08:54:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1136A6B00F7; Mon, 27 Jul 2026 08:54:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D05A86B00F5
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 08:54:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EF660A1864
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:52 +0000 (UTC)
X-FDA: 85034551224.08.19ED8A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3680A20008
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 12:54:51 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GlOc/Hti";
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785156891;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y993pIXua00WBWAIL/1Z7lFYMSFYvoH9IeLbXJAbVr8=;
	b=JP5dIIDEeaROJywHBP4HW+eEIwVmKljWze8X/GR2vM6HQp3jYMjPYjbt/5IOAn3ibVliBr
	oPt37J+A1ZD2SinQLlYkQp/5Z6QOl5Uvz7LnbiBERjSyjsmI10Xy+ktUYbLqAw9sW+agnk
	sKOXeamnvP3pj1vj1ggA1PdRIYuEW9Q=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="GlOc/Hti";
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785156891;
	b=CxQGXVVMGXVsi6x64MiCQ/PNGgbkqrDEk8NxDZqdE4yy4cnu7aW4/TTBG/t+1aY0YLP4ux
	BPXnAAbtJQlMfmHt7pVZIIThHPsFJTTGB7KcgZhimDGS1kyp9v3k3bMnZZ0tEd07AnQtkg
	bSGGJ2Eb9L7FEnCAfvHiNnwxVw8Qh8c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8417842DF0;
	Mon, 27 Jul 2026 12:54:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C6121F00A3D;
	Mon, 27 Jul 2026 12:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785156890;
	bh=Y993pIXua00WBWAIL/1Z7lFYMSFYvoH9IeLbXJAbVr8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=GlOc/Hti45wALWjtn6Haho+Objyxbrbt7jQkQI52f6WDWE6mQNDdVTCUx5xmIUySB
	 IW9jvpBKPbL0IutvEOSTvfsIVLqUZjVPKPsPpYsqDse4sWKwjGAGgCAv+IRf/98wO6
	 zZaFHX6HIs/YfteHIuMALmr0a+gc3U9q3q/4HKE5ir/6uXQ1rZ2+7CSOwq2tFvzNHU
	 xX9glvhA3CwgJ86x7y7y4hZdK1qGqh4MLaxWsKoWJ6ddhsOW3tNuwBvWcCkoGLL62Z
	 IX3czJRwF/un2vwPqYI8nw8sla4BzQHPFwqUytbZRDxwPhfRruQYiX/eIf8+qcgkau
	 dwkPBfdDKgL6A==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 27 Jul 2026 14:54:07 +0200
Subject: [PATCH v3 13/13] mm/slab, kfence, memcg: completely remove obj_ext
 for kfence objects
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260727-b4-objext_split-v3-13-c29ef0f1f257@kernel.org>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
In-Reply-To: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 3680A20008
X-Rspam-User: 
X-Stat-Signature: frg47yx1o6ip9hih54pxwbo78yjf8q4r
X-Rspamd-Server: rspam04
X-HE-Tag: 1785156891-858338
X-HE-Meta: U2FsdGVkX18/ULqPi+j+1HjVVpFnptpATxSuYc7mm5T9bIU8dGhR6EOlteaqvPm/HLC2IzGbmaYX0hCcpCrTFX57MTBM/D+LSPj6b/uO2H53+qHpBRsjWLAPCUThtEnZJH2wpInLyXcSwGUgIpTMDX05pRvmTYZODkNQV7Gi9udUFoWA8Mb2COZ1hOsVbj7SFnwdYjbYV4nZjN9OiJ1bHZiEda3HmVugGa8YSn9WKZFaqIqBhm9wiWxDHD3n6ZEcih1DooN9dwG2GpxC0L0wyNaQvaz6wtTaFv4rh92jSdix9VW8TQvQBpe+zyTb85VIfCuEC14Zgy5pPbO7W+FTo30cXvH+Ppvc8PlM3gimm7+2tIYeEEPRAJyAYeWsMQId13TKo/X7RGOQXUObFI1idO5i+4C7yavT7fiSidBrB7VB13LFTX8Ye9+yHn8PADu4u/93BZ8JRZdULk4YlCFKmdQqv9votk6JKM3FyPi/ZS6gR4Eh/b5O/hW7YBvQsCfIhxnmmsVi6yWGogfgEXkCBopNvM1ExRNRaCf4gY7D73ChzAQlE9cy+QvM7+rr8kUrBI6NUVEqWLViOserv1nScGkp2gchEVc23yBZjEQ3qcKCP+r412cCSKp1RXKdZgirg3b8j8xSd+0MEvvTG10FdsGcrbNVY5MwDwvYniwIZSgaDGJ0sYmIjUphxo4Hd79pB+B1nCk7REj0FqlBwiOBjPzJ5XsrBbEQern22fJDQX1lmDjHe3UPF08L7b3sJrobxaTs4h/OKJOeTm3f5R6itf/jKRBcR3enMw1uO6J1SqbfilEpwImKbd9NuD30Gd/yAm7WDIP7VfPqKDUE9H2Nzu8+JUOLd4yMuMSNTH1nL+k5KmF1hMoghXF48itk/siQWR9yu85ErTkiSOv6jfPUTNAlkWfuEpvZ7OoD7q/XqACXefDc3wVBzBP05w0mcaDUKeXze8BgFtmrVBXDLQD
 5NzqmIY0
 h55fA1A04+5nsRSfeWlmz1tjnLdu+ABj0obi7ba5aQtNJuyl+tR6iGQCwK4l1zetXhI0SCfUFvjspgg7+x8QQmHoEzCF4l+QPixbk7wuVMFai/DVLUiKij8+N+yZcf36lBoICm4KlDKnVqcRVBhoUJX1Yq6Z94XG/wZMtz2ymtmyVcGyf8+fR9ljreUnQg0TJLI5+VfbmA/WdcO6MptQFjBEEbsA03jUnwTNu2R88wGGL5UN/jM9RUUQ3LendfC/hl0sLSDxQaWFY51Rx0osdrdxx9WEDEJTonf397Yo167UW7i0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

We have already disabled memory allocation profiling for objects
allocated for KFENCE to avoid complexity. KFENCE allocations are rare
and there can be only CONFIG_KFENCE_NUM_OBJECTS (default to 255)
outstanding ones at any time, so they are among noise in the profiling
stats.

For the same reasons, we can stop memcg_kmem accounting of kfence
objects as their memory usage will be negligible wrt any practical
memcg limits.

This allows us simplifying the code and getting rid of
is_kfence_address() checks in various places, including slab_obj_ext()'s
usage of obj_to_index(). Instead we rely on the fact that slab_obj_exts()
will now always return 0 for a kfence object's fake slab, which makes
those places unreachable.

All we need to do to keep this assumption valid is not to allocate
obj_exts for kfence objects, so the checks need to guard
alloc_slab_obj_exts() where necessary.

Suggested-by: Harry Yoo <harry@kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/kfence/core.c   | 15 ---------------
 mm/kfence/kfence.h |  3 ---
 mm/memcontrol.c    | 12 +++++++-----
 mm/slab.h          |  6 +++++-
 mm/slub.c          | 31 ++++++++++++++++---------------
 5 files changed, 28 insertions(+), 39 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 897ecf2594fb..90925c646c4c 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -636,14 +636,6 @@ static unsigned long kfence_init_pool(void)
 
 		page = pfn_to_page(start_pfn + i);
 		__SetPageSlab(page);
-#ifdef CONFIG_MEMCG
-		struct slab *slab = page_slab(page);
-		slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
-				 MEMCG_DATA_OBJEXTS;
-#ifdef CONFIG_64BIT
-		slab->obj_exts_needs_objcg = 1;
-#endif
-#endif
 	}
 
 	/*
@@ -707,10 +699,6 @@ static unsigned long kfence_init_pool(void)
 			continue;
 
 		page = pfn_to_page(start_pfn + i);
-#ifdef CONFIG_MEMCG
-		struct slab *slab = page_slab(page);
-		slab->obj_exts = 0;
-#endif
 		__ClearPageSlab(page);
 	}
 
@@ -1251,9 +1239,6 @@ void __kfence_free(void *addr)
 {
 	struct kfence_metadata *meta = addr_to_metadata((unsigned long)addr);
 
-#ifdef CONFIG_MEMCG
-	KFENCE_WARN_ON(slab_obj_ext_objcg(&meta->obj_exts));
-#endif
 	/*
 	 * If the objects of the cache are SLAB_TYPESAFE_BY_RCU, defer freeing
 	 * the object, as the object page may be recycled for other-typed
diff --git a/mm/kfence/kfence.h b/mm/kfence/kfence.h
index 1f618f9b0d12..e6b4bf349ff7 100644
--- a/mm/kfence/kfence.h
+++ b/mm/kfence/kfence.h
@@ -102,9 +102,6 @@ struct kfence_metadata {
 	struct kfence_track free_track __guarded_by(&lock);
 	/* For updating alloc_covered on frees. */
 	u32 alloc_stack_hash __guarded_by(&lock);
-#ifdef CONFIG_MEMCG
-	struct slabobj_ext obj_exts;
-#endif
 };
 
 #define KFENCE_METADATA_SIZE PAGE_ALIGN(sizeof(struct kfence_metadata) * \
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index aace85fb99f9..6b51ddf6dfe0 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3583,13 +3583,15 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 
 		slab = virt_to_slab(p[i]);
 
-		if (IS_ENABLED(CONFIG_DEBUG_VM) && WARN_ON_ONCE(!slab_needs_objcg(slab)))
-			continue;
+		if (!slab_obj_exts(slab)) {
+			if (is_kfence_address(p[i]))
+				continue;
+			if (alloc_slab_obj_exts(slab, s, flags, slab_alloc_flags))
+				continue;
+		}
 
-		if (!slab_obj_exts(slab) &&
-		    alloc_slab_obj_exts(slab, s, flags, slab_alloc_flags)) {
+		if (IS_ENABLED(CONFIG_DEBUG_VM) && WARN_ON_ONCE(!slab_needs_objcg(slab)))
 			continue;
-		}
 
 		/*
 		 * if we fail and size is 1, memcg_alloc_abort_single() will
diff --git a/mm/slab.h b/mm/slab.h
index 44f9b2569e80..04600f57b401 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -730,7 +730,11 @@ slab_obj_ext(struct kmem_cache *s, struct slab *slab, unsigned long obj_exts,
 
 	VM_WARN_ON_ONCE(obj_exts != slab_obj_exts(slab));
 
-	index = obj_to_index(s, slab, obj);
+	/*
+	 * KFENCE objects have NULL obj_exts and thus can't reach this
+	 * and we don't need obj_to_index()
+	 */
+	index = __obj_to_index(s, slab_address(slab), obj);
 
 	if (!obj_exts_in_object(slab))
 		stride = slab_obj_ext_size(slab);
diff --git a/mm/slub.c b/mm/slub.c
index 893a11abcc20..94b744e5ac79 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2064,9 +2064,6 @@ static inline void mark_obj_codetag_empty(const void *obj)
 	struct slab *obj_slab;
 	unsigned long slab_exts;
 
-	if (is_kfence_address(obj))
-		return;
-
 	obj_slab = virt_to_slab(obj);
 	slab_exts = slab_obj_exts(obj_slab);
 	if (slab_exts) {
@@ -2329,11 +2326,15 @@ static inline unsigned long
 prepare_slab_obj_exts_hook(struct kmem_cache *s, struct slab *slab,
 			   gfp_t flags, unsigned int alloc_flags, void *p)
 {
-	if (!slab_obj_exts(slab) &&
-	    alloc_slab_obj_exts(slab, s, flags, alloc_flags)) {
-		pr_warn_once("%s, %s: Failed to create slab extension vector!\n",
-			     __func__, s->name);
-		return 0;
+	if (!slab_obj_exts(slab)) {
+		if (is_kfence_address(p))
+			return 0;
+
+		if (alloc_slab_obj_exts(slab, s, flags, alloc_flags)) {
+			pr_warn_once("%s, %s: Failed to create slab extension vector!\n",
+				     __func__, s->name);
+			return 0;
+		}
 	}
 
 	return slab_obj_exts(slab);
@@ -2358,9 +2359,6 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 	if (alloc_flags & SLAB_ALLOC_NO_RECURSE)
 		return;
 
-	if (is_kfence_address(object))
-		return;
-
 	slab = virt_to_slab(object);
 	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
 	/*
@@ -2380,7 +2378,13 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
 
 		put_slab_obj_exts(obj_exts);
 	} else {
-		alloc_tag_set_inaccurate(current->alloc_tag);
+		/*
+		 * KFENCE allocations are rare and the amount of outstanding
+		 * ones is limited to a small number so it's not worth setting
+		 * tags as inaccurate because of them.
+		 */
+		if (!is_kfence_address(object))
+			alloc_tag_set_inaccurate(current->alloc_tag);
 	}
 }
 
@@ -2411,9 +2415,6 @@ __alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p
 	for (int i = 0; i < objects; i++) {
 		struct slabobj_ext *ext;
 
-		if (is_kfence_address(p[i]))
-			continue;
-
 		ext = slab_obj_ext(s, slab, obj_exts, p[i]);
 		alloc_tag_sub(slab_obj_ext_codetag_ref(slab, ext), s->size);
 	}

-- 
2.55.0


