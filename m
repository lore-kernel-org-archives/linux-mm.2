Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90E06CD6E79
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 09:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07B776B009B; Tue,  9 Jun 2026 05:18:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02CB06B009D; Tue,  9 Jun 2026 05:18:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84946B009E; Tue,  9 Jun 2026 05:18:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D46D96B009B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 05:18:28 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 94966164552
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:28 +0000 (UTC)
X-FDA: 84859823496.22.E734A1F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id DAD2C4000D
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:18:26 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oD0i1VLV;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780996706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCpSWlchkeKZmx6rE2e5R1dkCFGfPuoJVPYULJPYfvM=;
	b=4+Hm6GMeCRjxNw+hJu0Sghi6Z3kFMjJEQ/FgFgNtB/aYbYGb8K5+mGR8eC3iJBJ3wpw+JC
	MKDBen9rNFPzyUvLMVrepc8GhQcX//rz3Tyjme4TkWi0lYAoSCQBFqOElBKQc1fHn3HHMX
	8mRuMIvpRm6nExATgRGXmVB+31YQtHQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oD0i1VLV;
	spf=pass (imf07.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780996706;
	b=xNusrtlAWw4tLysbGrRZYOUjambt6iDMT9IXjRN0KxZCr/DNd9MwFh2a/a8Y+pLuFaqIwW
	F70RI3MKiQUDpWNPH+br1rnOBMk3+G9GgEIL7Fk+zOCx2ZzWYz+8AirJQAQjPKvQxpe8jV
	CIHZkojoSHf/sZq+UYNjw2lKoe9m7mk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 68B1460209;
	Tue,  9 Jun 2026 09:18:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FD851F00898;
	Tue,  9 Jun 2026 09:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780996706;
	bh=nCpSWlchkeKZmx6rE2e5R1dkCFGfPuoJVPYULJPYfvM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=oD0i1VLVMUVflavtGIlneCAHBIS7oQKelrI7EIf9IZaGr78w1OUAnGALkmpo1VHRH
	 cEylbYxSFqqpXSns1cwskw1ram0MrpAkcQ85ltWvmy0kT3VjdIeytA6L4c8piWA0l9
	 NTRIvlMvpvOvQp1AwzCHi/2XxBt8LrBieKaeD2W2AdVwmrlvvv1tf+xRwvRWGJIFRE
	 2hOWw8juBX7NeXfn/F/ZJYozsYWbVdUaGQG+3JGeCTP3/O37LydGenSxj5Mo/VVDfi
	 NStUNpGp9IDGdTvYuuebnglDCbLJ33Xwr0eYbWW2u6pYBN5RV7zoVGkP4pGs5R7vic
	 k7Zu8xI7rcKOw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Tue, 09 Jun 2026 11:17:53 +0200
Subject: [PATCH RFC 08/15] mm/slab: pass alloc_flags through
 slab_post_alloc_hook() chain
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260609-slab_alloc_flags-v1-8-2bf4a4b9b526@kernel.org>
References: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
In-Reply-To: <20260609-slab_alloc_flags-v1-0-2bf4a4b9b526@kernel.org>
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
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: DAD2C4000D
X-Stat-Signature: yfa8gq36m6o1d49woitidna5csztg87h
X-Rspam-User: 
X-HE-Tag: 1780996706-511972
X-HE-Meta: U2FsdGVkX1+1fX5W2yjxbFxuXjYrnazFwPjzd4GTt6GNGcqs6/HpDKH4azqmkUcB9YZDjtbe4vx/AsWNTmix2bmEinrByFLMxr/WUKAddSBT3BZpEb69W/0QQOrAHthLFnPm+Vr/yMnALC6uxDYwRj9TZf3GWe2b1Ig3S/m7S+pKpHAOqn1w6LmjdZ+/NPsfwjvW7n4WgNMbkBTO2Y4UEKcWjuO5KEBUL2DZt0c781Bj9uli74wVMGJoDCFf0KYILDDmvRXcHYTTR5n5+Y/Xn/JqGGlfa4dhsmI/rBEpcDB7eoixSCarxRTbZqr2bVcQu9eaCAg+f2RU7nyjvKDlbUkIFn2MhGMhEOwRQT+YvyDnAi7gSX1w75ucZE4foBOWHqGvHl/aUhhTR8/z9mnDQHR6McDP5InnpYRg7kt4f2Zr8RqRNCJqD5aq6lTsDdbD6LdjldWnIKdojjAhszdgpt22ycL7db6Mits80dv4jaHFEIiZhxPkjoy2oWr+fGLiKAd0YH+7sv9qZuyQlrNo50I4er16QRM0aa6fiUOqJzY5FkTPpMSjAp0yzk4ZMX6XfEqqt/SHknQIAp8TWuL6wJ8kefThvnvXNHGfIETdiynqok5YRGfQI+p3EEJi9NKeSvWftSBpWoKn/3rVrrcQOZOchHpPujyLCHDzOrN2RhGPy0VwvOeJnyo5VKuuIXFBeK102zG9jBCbXHHnrdMYHonUtuXVbLLe22I223QpNzertG/23uzgeCnSOYnzm6KfolSDT8hh1jLycYr52jagnArhQ+XvvYwNYvoDS6f0tVCF3TwoszF+OS0jGTQrAi2QqFFgKx3klfhSQh2JM5uQNnhfF+Geo3bmpC9QemrDy4e6Wvh1RzPS8A0rQQZhS9iB173Fch3z3igJgziG6fk9qgw+yzP6DtVHTtD/MnQ3un0vhFDPk659gfB5oC69oyA+UInJt3/qCChTAQnsG2n
 Ij7Rpcnm
 xYJNmMImc3tXN7kcRVrH8dvVbiXtmOUsVqKHcTc6w9+7DUnGOTH72mHgxngQrIi0oo27zup3mXKB3eJjPN6ZzrX0TChXpElZwuqigWVe1zmVDObXWyB3HkoQtrfNkYqdKGo7cs6DMD04Ywy4pSRFgqmapHKFFPajtUqxuMw0W0Dhh52ZOJCOAbfTZucetzrQnOlFxaZ/h9186LbBm2B28FFW6IueAtsxqPhPN/GBPefJLrZXm8OhZdRBZJuKFrIY4CyjBFXHh/uwHhEi7Zp1Mf2txZ7EOU+hjLQRJ
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
index 3e75182ee144..13517abcad21 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -19,6 +19,7 @@
 /* slab's alloc_flags definitions */
 #define SLAB_ALLOC_DEFAULT	0x00
 #define SLAB_ALLOC_TRYLOCK	0x01
+#define SLAB_ALLOC_NEW_SLAB	0x02 /* a flag for alloc_slab_obj_exts() */
 
 static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
 {
@@ -612,7 +613,7 @@ static inline struct slabobj_ext *slab_obj_ext(struct slab *slab,
 }
 
 int alloc_slab_obj_exts(struct slab *slab, struct kmem_cache *s,
-                        gfp_t gfp, bool new_slab);
+                        gfp_t gfp, unsigned int alloc_flags);
 
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
index 20df6b131f63..034f2cd1c1fd 100644
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
+		        gfp_t gfp, unsigned int alloc_flags)
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
 	bool kasan_init = init;
@@ -4599,15 +4607,15 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 		p[i] = kasan_slab_alloc(s, p[i], init_flags, kasan_init);
 		if (p[i] && init && (!kasan_init ||
 				     !kasan_has_integrated_init()))
-			memset(p[i], 0, orig_size);
-		if (gfpflags_allow_spinning(flags))
+			memset(p[i], 0, ac->orig_size);
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
@@ -4902,6 +4910,12 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
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
@@ -4913,14 +4927,8 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 
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
 
@@ -4929,7 +4937,7 @@ static __fastpath_inline void *slab_alloc_node(struct kmem_cache *s, struct list
 	 * In case this fails due to memcg_slab_post_alloc_hook(),
 	 * object is set to NULL
 	 */
-	slab_post_alloc_hook(s, lru, gfpflags, 1, &object, orig_size);
+	slab_post_alloc_hook(s, gfpflags, 1, &object, &ac);
 
 	return object;
 }
@@ -5224,6 +5232,10 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 				   struct slab_sheaf *sheaf)
 {
 	void *ret = NULL;
+	struct slab_alloc_context ac = {
+		.orig_size = s->object_size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
 
 	if (sheaf->size == 0)
 		goto out;
@@ -5234,7 +5246,7 @@ kmem_cache_alloc_from_sheaf_noprof(struct kmem_cache *s, gfp_t gfp,
 		ret = sheaf->objects[--sheaf->size];
 
 	/* add __GFP_NOFAIL to force successful memcg charging */
-	slab_post_alloc_hook(s, NULL, gfp | __GFP_NOFAIL, 1, &ret, s->object_size);
+	slab_post_alloc_hook(s, gfp | __GFP_NOFAIL, 1, &ret, &ac);
 out:
 	trace_kmem_cache_alloc(_RET_IP_, ret, s, gfp, NUMA_NO_NODE);
 
@@ -5421,7 +5433,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 
 success:
 	maybe_wipe_obj_freeptr(s, ret);
-	slab_post_alloc_hook(s, NULL, alloc_gfp, 1, &ret, orig_size);
+	slab_post_alloc_hook(s, alloc_gfp, 1, &ret, &ac);
 
 	ret = kasan_kmalloc(s, ret, orig_size, alloc_gfp);
 	return ret;
@@ -7287,6 +7299,10 @@ bool kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags,
 {
 	unsigned int i = 0;
 	void *kfence_obj;
+	struct slab_alloc_context ac = {
+		.orig_size = s->object_size,
+		.alloc_flags = SLAB_ALLOC_DEFAULT,
+	};
 
 	if (!size)
 		return false;
@@ -7337,7 +7353,7 @@ bool kmem_cache_alloc_bulk_noprof(struct kmem_cache *s, gfp_t flags,
 
 out:
 	/* memcg and kmem_cache debug support and memory initialization */
-	return likely(slab_post_alloc_hook(s, NULL, flags, size, p, s->object_size));
+	return likely(slab_post_alloc_hook(s, flags, size, p, &ac));
 }
 EXPORT_SYMBOL(kmem_cache_alloc_bulk_noprof);
 

-- 
2.54.0


