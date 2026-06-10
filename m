Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABA36CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:41:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 190E66B00A0; Wed, 10 Jun 2026 11:41:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 168A86B00A1; Wed, 10 Jun 2026 11:41:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D0D6B00A2; Wed, 10 Jun 2026 11:41:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E815C6B00A0
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:41:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AE08C120174
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:41:28 +0000 (UTC)
X-FDA: 84864417456.06.F3F690E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 115C9140011
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:41:26 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YA/FpnZ3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106087;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juad9rX/foUAjjPYMZvwAvk66V1HKvFw/K6ogMlaJhU=;
	b=NTrfBL+lgGi4PeK3LaRZgRxae7RvCyClcOMbfbwT/9ZzdtdLrqE6+Tpq6lyRg93jyXtHUJ
	bnSaHG0ULJYnwvkvmqZvvNcujBAZS6CvgWFhC77BSXk/u7aqqjgRmyX7qYdBwRFHYIt+jT
	ehI2mN5HJF/AVero10UHDA6vfm1reoI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="YA/FpnZ3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106087;
	b=y3OfL+hA4Nbv+6acl6VSFx4wBW4gfSPyS2u7UA25arIuH/uLpGGXjhu5J0xh6q5Qfl6HfB
	KqYhQZPai769vAA5SlCFadAOJPqN+RgtWLP70rs5vIJOO0qYUpl1E7lp8bPr4wdzTjvjZZ
	lGdDrJKLf8d9bzyhjkTQxJ7FbgoPwxg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 974E260172;
	Wed, 10 Jun 2026 15:41:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FDB51F00898;
	Wed, 10 Jun 2026 15:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106086;
	bh=juad9rX/foUAjjPYMZvwAvk66V1HKvFw/K6ogMlaJhU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YA/FpnZ3mUpUTGEGYRvpkVmfBjU4ZELooQ30K6ELNN4d5DtfbdhqDJAfsL4A+bODf
	 1ErYACrQxdgfGmqez7t9Bz3cvvBeNR3SH2OK3Z4dqsNyO+6kny4OvnOsa1LsrlLw43
	 VbzB9p07okvL40yNP3SbEDbUImMqShn15xvO6QRnAcF25CSUonScXdHjIV4pfW+58/
	 6yq9n9JlXPdxv2bACjqfmQMPibxSxYswdvEfaGvjswnd/8FX7mE1EXCa5U6tp//oAu
	 hB1ntx3r2W0sSs0bXLXR7jP2dDLm95JjDnJ3/ar2nlAfPz0KMtO84YePq4HODuY+Gw
	 KDinCj/KTi8VQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:11 +0200
Subject: [PATCH v2 09/16] mm/slab: pass alloc_flags through
 slab_post_alloc_hook() chain
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-9-7190909db118@kernel.org>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: 9eodzcce971tftgz9x5xx4bhdgsmm8py
X-Rspamd-Queue-Id: 115C9140011
X-HE-Tag: 1781106086-778444
X-HE-Meta: U2FsdGVkX1/LouYl/jNkJ6qTRyMbB+Je7ngKLViy6mvPWtWPd0yOIUtgySWfGC+0fKEbQtfL+cKOq68zmCrKI6ZpObi3Qqmkqa/+GoPyrlHNGBdH9ngctdgeUtXS8/mvfVKLbXGuEqrm+SQt6WPhulCRR8iRac29wQXhYCkrBLEs+vqcENN7TiCeaMoufWIEISXZY/c2cWRjY3vrhZN+MWeYKYlkJ28cRzgyg5QjYdvL7kXWvvxgCdQsGlgrjwceVZ1qpnzqD8G4Q8Ia9Z2PulBSjXJuDU/ur2RT3kO5ud0iYWmnfkdvR7gtNfCyzTzu0E+p3kigQ74ck1ZnJLR5bUlViUBRZIjTQTtUpIdqO83pdx4QNxxKo3G2hUgNFAhroWrX2IqtOISxdS5zRVOAJMq2c0PC575X0KQEa2d+roblL2CjiweJ27zIJyMT1vigFAECX9LNwWATzpYgGhH2D1x9RbEhtlyf0nDWl+7OqTbjMO0yC/Ruft8q/ZrzSMbVlQPIIHTU3EUhCHfew7Zz79CFJ3xDDV1CJYDUKFp9HvnAEWVRJx74noLuz5ih1yBtk0/HDu4aQTuZZ4vbtiN9IpRNAuOoZZjSS6vD5huNASLT7AK4WkTje2Xa7qZYUw3vk8fVvpbPRlQ7/rr80gV17alMmsYXZ8VtQ3ZbIDResIvpgL7SxAvvJW2tEZC5zxYuVmBrg/7XHVJRvIzcfV9TdzXiWe4aIPkHdd9Us8T0PTtEMCBrYeByw+O0hg6PK8Fh8rSYXLS6BTYa5MkQKelH4tBp4rDMQA/mRgBh58LrOLKHampvUmgbQzqCslHdsumBi9ZfoynFgrkhBrjxT1sggkHjBBZd2pGEs3nLjiY+PwLQYTwz9Lr7+zgeU3/12QIWDQO2+TWRTTrIHRy/c4Q8vist3/lbhfrLiQaNLnbYKn5KzFNKXO6jugEFvMB5zZF0EE8ZAqzF5c7vWkYLtei
 LY4ypwbW
 Wepzl8VcSfR30Z9UyWYodKLoyZFiJnxacQgYAIa0OlVedvg+xzeVwFpu2jq6AxzqRiP4BqQOt99y2Am+/itvMdclfIGGzJf7lyprp4dZhWzA9Mm2b11osfdawUGxuD2g7flPHBGm+u8FjMpx8p+o6WVVgO+RurEZqnOVa4lyEtnfsqMQty6bK8tuAgSL5V/encZ6blawiq35cEUkM9vO4FWNYz1ILYtAkHB+FsUveNHRwth6EK2Kdf4ku0l9eOOi6u+ox2phaWvCddBTXaFzu8qKxyO2z625fwlLD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert the whole following call stack to pass either slab_alloc_context
(thus including alloc_flags) or just alloc_flags as necessary:

slab_post_alloc_hook()
  alloc_tagging_slab_alloc_hook()
    __alloc_tagging_slab_alloc_hook()
      prepare_slab_obj_exts_hook()
        alloc_slab_obj_exts()
  memcg_slab_post_alloc_hook()
    __memcg_slab_post_alloc_hook()
      alloc_slab_obj_exts()

Converting all these at once avoids unnecessary churn and is mostly
mechanical.

This ultimately allows to decide if spinning is allowed using
alloc_flags in alloc_slab_obj_exts(), as well as slab_post_alloc_hook().
Aside from alloc_from_pcs_bulk() (to be handled next) there is nothing
else in slab itself relying on gfpflags_allow_spinning() which can
be false even if not called from kmalloc_nolock().

A followup change will also use the alloc_flags availability in the call
stack above to remove the __GFP_NO_OBJ_EXT flag.

For alloc_slab_obj_exts(), also replace the suboptimal "bool new_slab"
parameter with a SLAB_ALLOC_NEW_SLAB flag with identical functionality.

To further reduce the number of parameters of slab_post_alloc_hook(),
also make 'struct list_lru *lru' (which is NULL for most callers) a new
field of slab_alloc_context.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/memcontrol.c |  5 +--
 mm/slab.h       |  6 ++--
 mm/slub.c       | 94 +++++++++++++++++++++++++++++++++------------------------
 3 files changed, 62 insertions(+), 43 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c03d4787d466..29390ba13baa 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -3424,7 +3424,8 @@ static inline size_t obj_full_size(struct kmem_cache *s)
 }
 
 bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
-				  gfp_t flags, size_t size, void **p)
+				  gfp_t flags, unsigned int slab_alloc_flags,
+				  size_t size, void **p)
 {
 	size_t obj_size = obj_full_size(s);
 	struct obj_cgroup *objcg;
@@ -3472,7 +3473,7 @@ bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		slab = virt_to_slab(p[i]);
 
 		if (!slab_obj_exts(slab) &&
-		    alloc_slab_obj_exts(slab, s, flags, false)) {
+		    alloc_slab_obj_exts(slab, s, flags, slab_alloc_flags)) {
 			continue;
 		}
 
diff --git a/mm/slab.h b/mm/slab.h
index 96f65b625600..4db6d8aa0ee3 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -19,6 +19,7 @@
 /* slab's alloc_flags definitions */
 #define SLAB_ALLOC_DEFAULT	0x00 /* no flags */
 #define SLAB_ALLOC_TRYLOCK	0x01 /* a kmalloc_nolock() allocation */
+#define SLAB_ALLOC_NEW_SLAB	0x02 /* a flag for alloc_slab_obj_exts() */
 
 static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
 {
@@ -612,7 +613,7 @@ static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
 }
 
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
-                        gfp_t gfp, bool new_slab);
+			gfp_t gfp, unsigned int alloc_flags);
 
 #else /* CONFIG_SLAB_OBJ_EXT */
 
@@ -642,7 +643,8 @@ static inline enum node_stat_item cache_vmstat_idx(struct kmem_cache *s)
 
 #ifdef CONFIG_MEMCG
 bool __memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
-				  gfp_t flags, size_t size, void **p);
+				  gfp_t flags, unsigned int slab_alloc_flags,
+				  size_t size, void **p);
 void __memcg_slab_free_hook(struct kmem_cache *s, struct slab *slab,
 			    void **p, int objects, unsigned long obj_exts);
 #endif
diff --git a/mm/slub.c b/mm/slub.c
index 8f6ca3d5fdfa..e634137b67fa 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -218,6 +218,7 @@ struct slab_alloc_context {
 	unsigned long caller_addr;
 	unsigned long orig_size;
 	unsigned int alloc_flags;
+	struct list_lru *lru;
 };
 
 /* Structure holding parameters for get_partial_node_bulk() */
@@ -2155,9 +2156,9 @@ static inline size_t obj_exts_alloc_size(struct kmem_cache *s,
 }
 
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
-		        gfp_t gfp, bool new_slab)
+			gfp_t gfp, unsigned int alloc_flags)
 {
-	bool allow_spin = gfpflags_allow_spinning(gfp);
+	const bool allow_spin = alloc_flags_allow_spinning(alloc_flags);
 	unsigned int objects = objs_per_slab(s, slab);
 	unsigned long new_exts;
 	unsigned long old_exts;
@@ -2206,7 +2207,7 @@ int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
 	old_exts = READ_ONCE(slab->obj_exts);
 	handle_failed_objexts_alloc(old_exts, vec, objects);
 
-	if (new_slab) {
+	if (alloc_flags & SLAB_ALLOC_NEW_SLAB) {
 		/*
 		 * If the slab is brand new and nobody can yet access its
 		 * obj_exts, no synchronization is required and obj_exts can
@@ -2331,7 +2332,7 @@ static inline void init_slab_obj_exts(struct slab *slab)
 }
 
 static int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
-			       gfp_t gfp, bool new_slab)
+			       gfp_t gfp, unsigned int alloc_flags)
 {
 	return 0;
 }
@@ -2351,10 +2352,10 @@ static inline void alloc_slab_obj_exts_early(struct kmem_cache *s,
 
 static inline unsigned long
 prepare_slab_obj_exts_hook(struct kmem_cache *s, struct slab *slab,
-			   gfp_t flags, void *p)
+			   gfp_t flags, unsigned int alloc_flags, void *p)
 {
 	if (!slab_obj_exts(slab) &&
-	    alloc_slab_obj_exts(slab, s, flags, false)) {
+	    alloc_slab_obj_exts(slab, s, flags, alloc_flags)) {
 		pr_warn_once("%s, %s: Failed to create slab extension vector!\n",
 			     __func__, s->name);
 		return 0;
@@ -2366,7 +2367,8 @@ prepare_slab_obj_exts_hook(struct kmem_cache *s, struct slab *slab,
 
 /* Should be called only if mem_alloc_profiling_enabled() */
 static noinline void
-__alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
+__alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
+				unsigned int alloc_flags)
 {
 	unsigned long obj_exts;
 	struct slabobj_ext *obj_ext;
@@ -2382,7 +2384,7 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 		return;
 
 	slab = virt_to_slab(object);
-	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, object);
+	obj_exts = prepare_slab_obj_exts_hook(s, slab, flags, alloc_flags, object);
 	/*
 	 * Currently obj_exts is used only for allocation profiling.
 	 * If other users appear then mem_alloc_profiling_enabled()
@@ -2401,10 +2403,11 @@ __alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
 }
 
 static inline void
-alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
+alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
+			      unsigned int alloc_flags)
 {
 	if (mem_alloc_profiling_enabled())
-		__alloc_tagging_slab_alloc_hook(s, object, flags);
+		__alloc_tagging_slab_alloc_hook(s, object, flags, alloc_flags);
 }
 
 /* Should be called only if mem_alloc_profiling_enabled() */
@@ -2443,7 +2446,8 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 #else /* CONFIG_MEM_ALLOC_PROFILING */
 
 static inline void
-alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags)
+alloc_tagging_slab_alloc_hook(struct kmem_cache *s, void *object, gfp_t flags,
+			      unsigned int alloc_flags)
 {
 }
 
@@ -2461,8 +2465,9 @@ alloc_tagging_slab_free_hook(struct kmem_cache *s, struct slab *slab, void **p,
 static void memcg_alloc_abort_single(struct kmem_cache *s, void *object);
 
 static __fastpath_inline
-bool memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
-				gfp_t flags, size_t size, void **p)
+bool memcg_slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags,
+				size_t size, void **p,
+				struct slab_alloc_context *ac)
 {
 	if (likely(!memcg_kmem_online()))
 		return true;
@@ -2470,7 +2475,8 @@ bool memcg_slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	if (likely(!(flags & __GFP_ACCOUNT) && !(s->flags & SLAB_ACCOUNT)))
 		return true;
 
-	if (likely(__memcg_slab_post_alloc_hook(s, lru, flags, size, p)))
+	if (likely(__memcg_slab_post_alloc_hook(s, ac->lru, flags,
+						ac->alloc_flags, size, p)))
 		return true;
 
 	if (likely(size == 1)) {
@@ -2558,14 +2564,15 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 		put_slab_obj_exts(obj_exts);
 	}
 
-	return __memcg_slab_post_alloc_hook(s, NULL, flags, 1, &p);
+	return __memcg_slab_post_alloc_hook(s, NULL, flags, SLAB_ALLOC_DEFAULT,
+					    1, &p);
 }
 
 #else /* CONFIG_MEMCG */
 static inline bool memcg_slab_post_alloc_hook(struct kmem_cache *s,
-					      struct list_lru *lru,
-					      gfp_t flags, size_t size,
-					      void **p)
+					      gfp_t flags,
+					      size_t size, void **p,
+					      struct slab_alloc_context *ac)
 {
 	return true;
 }
@@ -3352,12 +3359,14 @@ static inline void init_freelist_randomization(void) { }
 #endif /* CONFIG_SLAB_FREELIST_RANDOM */
 
 static __always_inline void account_slab(struct slab *slab, int order,
-					 struct kmem_cache *s, gfp_t gfp)
+					 struct kmem_cache *s, gfp_t gfp,
+					 unsigned int alloc_flags)
 {
 	if (memcg_kmem_online() &&
 			(s->flags & SLAB_ACCOUNT) &&
 			!slab_obj_exts(slab))
-		alloc_slab_obj_exts(slab, s, gfp, true);
+		alloc_slab_obj_exts(slab, s, gfp,
+				    alloc_flags | SLAB_ALLOC_NEW_SLAB);
 
 	mod_node_page_state(slab_pgdat(slab), cache_vmstat_idx(s),
 			    PAGE_SIZE << order);
@@ -3434,7 +3443,7 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
 	 * to prevent the array from being overwritten.
 	 */
 	alloc_slab_obj_exts_early(s, slab);
-	account_slab(slab, oo_order(oo), s, flags);
+	account_slab(slab, oo_order(oo), s, flags, alloc_flags);
 
 	return slab;
 }
@@ -4568,9 +4577,8 @@ struct kmem_cache *slab_pre_alloc_hook(struct kmem_cache *s, gfp_t flags)
 }
 
 static __fastpath_inline
-bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
-			  gfp_t flags, size_t size, void **p,
-			  unsigned int orig_size)
+bool slab_post_alloc_hook(struct kmem_cache *s, gfp_t flags, size_t size,
+			  void **p, struct slab_alloc_context *ac)
 {
 	bool init = slab_want_init_on_alloc(flags, s);
 	unsigned int zero_size = s->object_size;
@@ -4590,7 +4598,7 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	 * orig_size if we track it.
 	 */
 	if (slub_debug_orig_size(s))
-		zero_size = orig_size;
+		zero_size = ac->orig_size;
 
 	/*
 	 * When slab_debug is enabled, avoid memory initialization integrated
@@ -4616,14 +4624,14 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 				     !kasan_has_integrated_init())
 				 && !is_kfence_address(p[i]))
 			memset(p[i], 0, zero_size);
-		if (gfpflags_allow_spinning(flags))
+		if (alloc_flags_allow_spinning(ac->alloc_flags))
 			kmemleak_alloc_recursive(p[i], s->object_size, 1,
 						 s->flags, init_flags);
 		kmsan_slab_alloc(s, p[i], init_flags);
-		alloc_tagging_slab_alloc_hook(s, p[i], flags);
+		alloc_tagging_slab_alloc_hook(s, p[i], flags, ac->alloc_flags);
 	}
 
-	return memcg_slab_post_alloc_hook(s, lru, flags, size, p);
+	return memcg_slab_post_alloc_hook(s, flags, size, p, ac);
 }
 
 /*
@@ -4918,6 +4926,12 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 {
 	const unsigned int alloc_flags = SLAB_ALLOC_DEFAULT;
 	void *object;
+	struct slab_alloc_context ac = {
+		.caller_addr = addr,
+		.orig_size = orig_size,
+		.alloc_flags = alloc_flags,
+		.lru = lru,
+	};
 
 	s = slab_pre_alloc_hook(s, gfpflags);
 	if (unlikely(!s))
@@ -4929,14 +4943,8 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 
 	object = alloc_from_pcs(s, gfpflags, alloc_flags, node);
 
-	if (unlikely(!object)) {
-		struct slab_alloc_context ac = {
-			.caller_addr = addr,
-			.orig_size = orig_size,
-			.alloc_flags = alloc_flags,
-		};
+	if (!object)
 		object = __slab_alloc_node(s, gfpflags, node, &ac);
-	}
 
 	maybe_wipe_obj_freeptr(s, object);
 
@@ -4945,7 +4953,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	 * In case this fails due to memcg_slab_post_alloc_hook(),
 	 * object is set to NULL
 	 */
-	slab_post_alloc_hook(s, lru, gfpflags, 1, &object, orig_size);
+	slab_post_alloc_hook(s, gfpflags, 1, &object, &ac);
 
 	return object;
 }
@@ -5240,6 +5248,10 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 				   struct slab_sheaf *sheaf)
 {
 	void *ret = NULL;
+	struct slab_alloc_context ac = {
+		.orig_size = s->object_size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
 
 	if (sheaf->size == 0)
 		goto out;
@@ -5250,7 +5262,7 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 		ret = sheaf->objects[--sheaf->size];
 
 	/* add __GFP_NOFAIL to force successful memcg charging */
-	slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, s->object_size);
+	slab_post_alloc_hook(s, gfp | __GFP_NOFAIL, 1, &ret, &ac);
 out:
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfp, NUMA_NO_NODE);
 
@@ -5437,7 +5449,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 
 success:
 	maybe_wipe_obj_freeptr(s, ret);
-	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret, orig_size);
+	slab_post_alloc_hook(s, alloc_gfp, 1, &ret, &ac);
 
 	ret = kasan_kmalloc(s, ret, orig_size, alloc_gfp);
 	return ret;
@@ -7303,6 +7315,10 @@ bool kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags,
 {
 	unsigned int i = 0;
 	void *kfence_obj;
+	struct slab_alloc_context ac = {
+		.orig_size = s->object_size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
 
 	if (!size)
 		return false;
@@ -7353,7 +7369,7 @@ bool kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags,
 
 out:
 	/* memcg and kmem_cache debug support and memory initialization */
-	return likely(slab_post_alloc_hook(s, NULL, flags, size, p, s->object_size));
+	return likely(slab_post_alloc_hook(s, flags, size, p, &ac));
 }
 EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
 

-- 
2.54.0


