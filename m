Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5ECCBCD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 16:24:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB22A6B0099; Fri, 15 May 2026 12:24:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C8A016B009B; Fri, 15 May 2026 12:24:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B77C06B009D; Fri, 15 May 2026 12:24:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AC4856B0099
	for <linux-mm@kvack.org>; Fri, 15 May 2026 12:24:55 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6F7271C00B7
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:55 +0000 (UTC)
X-FDA: 84770178150.03.37C68B1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 96BC9180010
	for <linux-mm@kvack.org>; Fri, 15 May 2026 16:24:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jwqc+K5k;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778862293;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yLFxZuifT27rsIKDCrzk5gVXsaETZwwDNUUq8IeaFHw=;
	b=qcQFuyw4k+lKFzHKo54qS+4OyQiR6o5n8ONn7tWaGUI/UCBeSsUdjEteyfDO9IJlmHvXVi
	TqOLU5FDIVJPMCWz/iioxT+iC4wA6ogPqXJrLyZFbhP7tG2v8w7fEKkFSoV6nPZW9Pe0W1
	e3UcoYVnUsyVZ19E+m6kjiiZ4gQXVlY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jwqc+K5k;
	spf=pass (imf24.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778862293; a=rsa-sha256;
	cv=none;
	b=R4Fkv1Qh+kZ5uVdEkyQ2W2Oxb699Y6+kaXDi+RBH520WWpNNBGq/TcHe0cLsL+CiaxSrPE
	nsw9mIub6B1DcTZSQgb8uEE6mDC4+fXk30Ga11iiMTmjqe98eNsUTkigRB/Zl+rRAFqTL5
	dITBpafVN1XbkAMPbbENRN/jGnRmT6M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BD4AB4005B;
	Fri, 15 May 2026 16:24:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5853AC2BCB3;
	Fri, 15 May 2026 16:24:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778862292;
	bh=p4LeJcvkw7gKvzZRYzQC1mqfqJ4paQ5EfhboaJpEGYM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=jwqc+K5knGquBFlk7v1m1bJK4fatuMgjkzh0Mv5oYdtk11w86GoCLWcWY+Ssu/KkC
	 LR3u/wxo+eBipQiZEZZek9LgPSg5OM9KqUzo+tQ1vQSbSSD0n0BenPdarA0WwGbHSZ
	 pT0oZJWcBbq1le8iB4+KsL2QGOwqJd9Rju/GQKTTXOHYH2Vr3HMIQmpCKe2XIdA/Ho
	 6x090sA4Wori7E59MMNTgD5APQ+fhdqt9RQYYdwXYtcZqmQYKVFZDkQC9FPO95aS0H
	 pm5b7tE6rnHNOsfT1nxGPTY3b1RILgESS6RnukGMB0pVWkq90Y+SFpt3wgyZFfCOCv
	 HMlSHLbNmf9iQ==
From: "Harry Yoo (Oracle)" <harry@kernel.org>
Date: Sat, 16 May 2026 01:24:29 +0900
Subject: [PATCH RFC 5/8] mm/slab: rework cache_has_sheaves() to check
 immutable properties only
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260516-sheaves-tuning-v1-5-221aa3e1d829@kernel.org>
References: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
In-Reply-To: <20260516-sheaves-tuning-v1-0-221aa3e1d829@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>
X-Mailer: b4 0.16-dev
X-Stat-Signature: 4q4qx6b6x4c1wst8nqpcofshh6j6up4u
X-Rspamd-Queue-Id: 96BC9180010
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778862293-129717
X-HE-Meta: U2FsdGVkX1+8voqUCx+Y4e5H8zqAixXtTVYZbcM66nmtL7lsUOIJY3pyOQ7I9WdNnlAj/pXJ7HHbJ56CIYdZuT9zOQePYT+3TpdIHmTqlO3loe5ZNqop6d2iVdFHQ0FNynB9hR9T9phE702bhEiKrTxi3QF/i8JMLpLeE66GT4ZiIL6G0ufJc6nm7cSKW9ASUX7nwT52g8jPHWwSfz3/6iqiml+A3eG+CugsULA1Qu4fpIWb2Vx3gGAnINq3mgXPVcniHdxb+ujaPEWPsytl+Q7hdtdirBN9AMDH1yXS7T18P6pHagddvCbe3+v9LhjpB/OLHZP1I78qlqqfefnDTrcEbhi5GqKP/R/So7yDSMkpV55bHccYj9Mvy076q6ZuX9jaVvDs45hdvllIw1exuT6QUsKJ4l4GHRXcEwui5vwzByant3+VZHRDLKH5/odDLD0UA6TwKwkmhu/zobICpT4uA2+gx8YMZQEWP5xQfCwOClihEC4IvMu1vrAlo7lix1Ph/SszenoJx0pTsiSlrS3MNiYPiyu2Ni+wCbrFfbyhnqAtgAkzkjZ/jgIMGNZ7HgVnRLTEGojjHCQyFMxa+0pzWcQWzYHvRD6TAj+pIBRoQKDhXRKEVv+tdtAAerkIoJGXsVknAz0if2/fwl+0tXyKKZWl58gaPIraLAjsTktSmFkx1KKvN1U4YNPG+j6DWDFY4K6PrmStUinx99Ed/noJPovs0GwvvEchjrab6uuRLAxsOIusjmp8P21pmGg4ota1/ZBqYJ1x0UgV42qhRvkRDQu6CfQoznlS4qgnO7QTr7eAUjuzWTTzj5CoH5XZHYPavyzAAt6nIEiKApus6EOMJWqyU/cNzPI+01mB9+0y0M7qsZJksdvXh3FbrKbCg6egAmJHXC4+8bNpR52YfaVtlcBu2xrT1wKjz2065fJ9xZMirnH57FbFdf1UPBogvnvLK5jZOL9EkQggoo9
 pQ8VrkcN
 V/jMpNpe9CMg4GtUD8JcANkkNRXJ5KfSbvnmmo14pkDANoTTFGAegcFb0QyVT6aErV4gMaTPcRKny7gg4dfpvNAkqKFjuEzGe4Cw7pkBptbL4MLVCmOQN8Gb4YoAajqO4BWmcuSmuJjpQgGndkUJ2uB36hjCBFCjV6gCqFQkf9kxQ4j5pborMYdcZ88cH3SPsrsBhP3j/srz1PQl9OyBgCvaR4K5xnzyK0i4IfeBcMkdF+MkdOT+LULQVZ+rHjMfEFr8Gs8o5iaR8OYlkoMZ1AnQa6vrjp3FfQB7S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently the sheaf capacity is determined when a cache is created and
never changes, with normal kmalloc caches as the only exception.
Checking whether s->sheaf_capacity is non-zero is therefore
sufficient for cache_has_sheaves() to work correctly.

However, once s->sheaf_capacity becomes mutable at runtime, both the
name and the implementation become confusing and racy: a cache that
currently has sheaves may have them disabled at runtime, or vice versa.

Except for normal kmalloc caches, what callers of cache_has_sheaves()
actually want to know depends only on properties that do not change:

  1. Whether the cache has certain flags (SLAB_NO_OBJ_EXT,
     SLAB_NOLEAKTRACE, SLAB_DEBUG_FLAGS)
  2. Whether a certain build option is enabled (CONFIG_SLUB_TINY)

Since these never change at runtime, check them directly instead of
going through s->sheaf_capacity. To avoid confusion, rename
cache_has_sheaves() to cache_supports_sheaves().

Normal kmalloc caches need special handling. They don't have sheaves
initially and only get them later via bootstrap_kmalloc_sheaves().
That said, cache_supports_sheaves() can return true while a cache's
percpu sheaves still point at the shared bootstrap_sheaf.

This special handling might sound like it applies only to normal
kmalloc caches, but the same handling is needed when sheaf capacity
can change.

The existing callers of cache_has_sheaves() fall into two categories.

The first category performs operations on the whole cache:
kvfree_rcu barrier, cache destruction, sheaf flushing, and CPU/memory
hot(un)plug. These should not skip caches that support sheaves, no
matter whether they actually have sheaves. If such an operation actually
needs to access percpu sheaves, use the new pcs_has_sheaves() helper
to skip CPUs whose pcs->main points to the bootstrap_sheaf.

The second category allocates from or frees to percpu sheaves directly
(in the slowpath). These should confirm pcs_has_sheaves() returns true
before proceeding.

In addition, init_kmem_cache_nodes() skips barn allocation for normal
kmalloc caches. Their barns are set up later by
bootstrap_kmalloc_sheaves().

Change calculate_sheaf_capacity() to call cache_supports_sheaves()
directly instead of open-coding the same conditions.

Signed-off-by: Harry Yoo (Oracle) <harry@kernel.org>
---
 mm/slab.h        | 36 ++++++++++++++++++++++++
 mm/slab_common.c |  2 +-
 mm/slub.c        | 85 ++++++++++++++++++++++++++++++++------------------------
 3 files changed, 86 insertions(+), 37 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index dfbe73011cb8..907a8207809c 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -481,6 +481,42 @@ static inline bool kmem_cache_debug_flags(struct kmem_cache *s, slab_flags_t fla
 	return false;
 }
 
+static inline bool kmem_cache_debug(struct kmem_cache *s)
+{
+	return kmem_cache_debug_flags(s, SLAB_DEBUG_FLAGS);
+}
+
+/*
+ * Every cache has !NULL s->cpu_sheaves but they may point to the
+ * bootstrap_sheaf temporarily during init, or permanently for the boot caches
+ * and caches with debugging enabled, or all caches with CONFIG_SLUB_TINY. This
+ * helper distinguishes whether cache supports real non-bootstrap sheaves.
+ *
+ * Return false when the cache does not support sheaves.
+ *
+ * When it returns true, the cache may or may not have sheaves.
+ * Callers who access percpu sheaves must verify that they actually have
+ * sheaves enabled.
+ */
+static inline bool cache_supports_sheaves(struct kmem_cache *s)
+{
+	if (IS_ENABLED(CONFIG_SLUB_TINY))
+		return false;
+
+	if (kmem_cache_debug(s))
+		return false;
+	/*
+	 * Bootstrap caches can't have sheaves for now (SLAB_NO_OBJ_EXT).
+	 * SLAB_NOLEAKTRACE caches (e.g., kmemleak's object_cache) must not
+	 * have sheaves to avoid recursion when sheaf allocation triggers
+	 * kmemleak tracking.
+	 */
+	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
+		return false;
+
+	return true;
+}
+
 #if IS_ENABLED(CONFIG_SLUB_DEBUG) && IS_ENABLED(CONFIG_KUNIT)
 bool slab_in_kunit_test(void);
 #else
diff --git a/mm/slab_common.c b/mm/slab_common.c
index d5a70a831a2a..3092c1c3f284 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -2109,7 +2109,7 @@ EXPORT_SYMBOL_GPL(kvfree_rcu_barrier);
  */
 void kvfree_rcu_barrier_on_cache(struct kmem_cache *s)
 {
-	if (cache_has_sheaves(s)) {
+	if (cache_supports_sheaves(s)) {
 		flush_rcu_sheaves_on_cache(s);
 		rcu_barrier();
 	}
diff --git a/mm/slub.c b/mm/slub.c
index fb98d0da5c78..c746c9b48728 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -238,11 +238,6 @@ struct slab_obj_iter {
 #endif
 };
 
-static inline bool kmem_cache_debug(struct kmem_cache *s)
-{
-	return kmem_cache_debug_flags(s, SLAB_DEBUG_FLAGS);
-}
-
 void *fixup_red_left(struct kmem_cache *s, void *p)
 {
 	if (kmem_cache_debug_flags(s, SLAB_RED_ZONE))
@@ -432,6 +427,23 @@ struct slub_percpu_sheaves {
 	struct slab_sheaf *rcu_free; /* for batching kfree_rcu() */
 };
 
+static struct slab_sheaf bootstrap_sheaf = {};
+
+static inline bool pcs_has_sheaves_unlocked(struct slub_percpu_sheaves *pcs)
+{
+	/* Test CONFIG_SLUB_TINY for code elimination purposes */
+	if (IS_ENABLED(CONFIG_SLUB_TINY))
+		return false;
+
+	return unlikely(pcs->main != &bootstrap_sheaf);
+}
+
+static inline bool pcs_has_sheaves(struct slub_percpu_sheaves *pcs)
+{
+	lockdep_assert_held(&pcs->lock);
+	return pcs_has_sheaves_unlocked(pcs);
+}
+
 /*
  * The slab lists for all objects.
  */
@@ -3045,8 +3057,7 @@ static void pcs_destroy(struct kmem_cache *s)
 	if (!s->cpu_sheaves)
 		return;
 
-	/* pcs->main can only point to the bootstrap sheaf, nothing to free */
-	if (!cache_has_sheaves(s))
+	if (!cache_supports_sheaves(s))
 		goto free_pcs;
 
 	for_each_possible_cpu(cpu) {
@@ -3058,6 +3069,9 @@ static void pcs_destroy(struct kmem_cache *s)
 		if (!pcs->main)
 			continue;
 
+		if (!pcs_has_sheaves_unlocked(pcs))
+			continue;
+
 		/*
 		 * We have already passed __kmem_cache_shutdown() so everything
 		 * was flushed and there should be no objects allocated from
@@ -3949,7 +3963,7 @@ static bool has_pcs_used(int cpu, struct kmem_cache *s)
 {
 	struct slub_percpu_sheaves *pcs;
 
-	if (!cache_has_sheaves(s))
+	if (!cache_supports_sheaves(s))
 		return false;
 
 	pcs = per_cpu_ptr(s->cpu_sheaves, cpu);
@@ -3971,7 +3985,7 @@ static void flush_cpu_sheaves(struct work_struct *w)
 
 	s = sfw->s;
 
-	if (cache_has_sheaves(s))
+	if (cache_supports_sheaves(s))
 		pcs_flush_all(s);
 }
 
@@ -4074,7 +4088,7 @@ void flush_all_rcu_sheaves(void)
 	mutex_lock(&slab_mutex);
 
 	list_for_each_entry(s, &slab_caches, list) {
-		if (!cache_has_sheaves(s))
+		if (!cache_supports_sheaves(s))
 			continue;
 		flush_rcu_sheaves_on_cache(s);
 	}
@@ -4109,7 +4123,7 @@ static int slub_cpu_setup(unsigned int cpu)
 		/*
 		 * barn might already exist if a previous callback failed midway
 		 */
-		if (!cache_has_sheaves(s) || get_barn_node(s, nid))
+		if (!cache_supports_sheaves(s) || get_barn_node(s, nid))
 			continue;
 
 		barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, nid);
@@ -4140,7 +4154,7 @@ static int slub_cpu_dead(unsigned int cpu)
 
 	mutex_lock(&slab_mutex);
 	list_for_each_entry(s, &slab_caches, list) {
-		if (cache_has_sheaves(s))
+		if (cache_supports_sheaves(s))
 			__pcs_flush_all_cpu(s, cpu);
 	}
 	mutex_unlock(&slab_mutex);
@@ -4612,8 +4626,8 @@ __pcs_replace_empty_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
-	/* Bootstrap or debug cache, back off */
-	if (unlikely(!cache_has_sheaves(s))) {
+	/* Sheaves are not supported or disabled for this cache */
+	if (unlikely(!pcs_has_sheaves(pcs))) {
 		local_unlock(&s->cpu_sheaves->lock);
 		return NULL;
 	}
@@ -4809,7 +4823,7 @@ unsigned int alloc_from_pcs_bulk(struct kmem_cache *s, gfp_t gfp, size_t size,
 		struct slab_sheaf *full;
 		struct node_barn *barn;
 
-		if (unlikely(!cache_has_sheaves(s))) {
+		if (unlikely(!pcs_has_sheaves(pcs))) {
 			local_unlock(&s->cpu_sheaves->lock);
 			return allocated;
 		}
@@ -5727,8 +5741,8 @@ __pcs_replace_full_main(struct kmem_cache *s, struct slub_percpu_sheaves *pcs,
 restart:
 	lockdep_assert_held(this_cpu_ptr(&s->cpu_sheaves->lock));
 
-	/* Bootstrap or debug cache, back off */
-	if (unlikely(!cache_has_sheaves(s))) {
+	/* Sheaves are not supported or disabled for this cache */
+	if (unlikely(!pcs_has_sheaves(pcs))) {
 		local_unlock(&s->cpu_sheaves->lock);
 		return NULL;
 	}
@@ -5959,8 +5973,8 @@ bool __kfree_rcu_sheaf(struct kmem_cache *s, void *obj)
 		struct slab_sheaf *empty;
 		struct node_barn *barn;
 
-		/* Bootstrap or debug cache, fall back */
-		if (unlikely(!cache_has_sheaves(s))) {
+		/* Sheaves are not supported or disabled for this cache */
+		if (unlikely(!pcs_has_sheaves(pcs))) {
 			local_unlock(&s->cpu_sheaves->lock);
 			goto fail;
 		}
@@ -6138,6 +6152,11 @@ static void free_to_pcs_bulk(struct kmem_cache *s, size_t size, void **p)
 
 	pcs = this_cpu_ptr(s->cpu_sheaves);
 
+	if (unlikely(!pcs_has_sheaves(pcs))) {
+		local_unlock(&s->cpu_sheaves->lock);
+		goto fallback;
+	}
+
 	if (likely(pcs->main->size < pcs->main->capacity))
 		goto do_free;
 
@@ -7131,7 +7150,7 @@ void kmem_cache_free_bulk(struct kmem_cache *s, size_t size, void **p)
 	 * freeing to sheaves is so incompatible with the detached freelist so
 	 * once we go that way, we have to do everything differently
 	 */
-	if (s && cache_has_sheaves(s)) {
+	if (s && cache_supports_sheaves(s)) {
 		free_to_pcs_bulk(s, size, p);
 		return;
 	}
@@ -7600,7 +7619,6 @@ static inline int alloc_kmem_cache_stats(struct kmem_cache *s)
 
 static int init_percpu_sheaves(struct kmem_cache *s)
 {
-	static struct slab_sheaf bootstrap_sheaf = {};
 	int cpu;
 
 	for_each_possible_cpu(cpu) {
@@ -7614,7 +7632,7 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 		 * Bootstrap sheaf has zero size so fast-path allocation fails.
 		 * It has also size == sheaf->capacity, so fast-path free
 		 * fails. In the slow paths we recognize the situation by
-		 * checking s->sheaf_capacity. This allows fast paths to assume
+		 * pcs_has_sheaves(). This allows fast paths to assume
 		 * s->cpu_sheaves and pcs->main always exists and are valid.
 		 * It's also safe to share the single static bootstrap_sheaf
 		 * with zero-sized objects array as it's never modified.
@@ -7631,6 +7649,7 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 
 		if (!pcs->main)
 			return -ENOMEM;
+
 	}
 
 	return 0;
@@ -7740,7 +7759,11 @@ static int init_kmem_cache_nodes(struct kmem_cache *s)
 		s->per_node[node].node = n;
 	}
 
-	if (slab_state == DOWN || !cache_has_sheaves(s))
+	if (slab_state == DOWN || !cache_supports_sheaves(s))
+		return 1;
+
+	/* Enable sheaves later to avoid the chicken and egg problem */
+	if (is_kmalloc_normal(s))
 		return 1;
 
 	for_each_node_mask(node, slab_barn_nodes) {
@@ -7765,17 +7788,7 @@ static unsigned short calculate_sheaf_capacity(struct kmem_cache *s,
 	unsigned short capacity;
 	size_t size;
 
-
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || s->flags & SLAB_DEBUG_FLAGS)
-		return 0;
-
-	/*
-	 * Bootstrap caches can't have sheaves for now (SLAB_NO_OBJ_EXT).
-	 * SLAB_NOLEAKTRACE caches (e.g., kmemleak's object_cache) must not
-	 * have sheaves to avoid recursion when sheaf allocation triggers
-	 * kmemleak tracking.
-	 */
-	if (s->flags & (SLAB_NO_OBJ_EXT | SLAB_NOLEAKTRACE))
+	if (!cache_supports_sheaves(s))
 		return 0;
 
 	/*
@@ -8040,7 +8053,7 @@ int __kmem_cache_shutdown(struct kmem_cache *s)
 	flush_all_cpus_locked(s);
 
 	/* we might have rcu sheaves in flight */
-	if (cache_has_sheaves(s))
+	if (cache_supports_sheaves(s))
 		rcu_barrier();
 
 	for_each_node(node) {
@@ -8361,7 +8374,7 @@ static int slab_mem_going_online_callback(int nid)
 		if (get_node(s, nid))
 			continue;
 
-		if (cache_has_sheaves(s) && !get_barn_node(s, nid)) {
+		if (cache_supports_sheaves(s) && !get_barn_node(s, nid)) {
 
 			barn = kmalloc_node(sizeof(*barn), GFP_KERNEL, nid);
 

-- 
2.43.0


