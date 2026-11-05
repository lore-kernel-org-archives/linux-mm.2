Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1460606A334
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 08:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Zw363AHc
Received: by kanga.kvack.org (Postfix)
	id 56EC36B05BA; Thu,  5 Nov 2026 03:44:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545676B05BB; Thu,  5 Nov 2026 03:44:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434986B05BC; Thu,  5 Nov 2026 03:44:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 107EA6B05BA
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 03:44:24 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A591E1C439A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:23 +0000 (UTC)
X-FDA: 85400428806.20.CE8AE76
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 105461A000A
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 08:44:21 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zw363AHc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793868262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tsjt9E/SOoMFBDvFXKXQOgR8qFXU1RBSyugeCKhoESM=;
	b=J/kNuQipGQe5O+ln/Ennir+fmLVZbocDGbiG/C3JFis8pB0xWgf1iGC1ady1C5+c/mYrB4
	lkCzIdFEmCWoq9i/6Flaf3HQoytUpaierfzv5/mq1Ppdv50NEyaXQBR3xZQeD8WTcqBoK2
	IamxGrD+3HYHgy/dA5pIiEndH22dKrY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793868262;
	b=Psa11iuTeJp2+JQeMAgZJhsqthp6ri1ba1XtMDPK3NUNbklTCGp1KR2MXaxxTJFXyQaVOa
	Fxq5+KQBmL5mcbdlqhMKtRPyni3S16YDVGmZeEu2/jAe4NNPW2/F1t3Kv5FN5w/+kiyYb8
	o51qBB2oveXpR/eFYn20J3CsN7r1oAM=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zw363AHc;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A06D260F35;
	Thu,  5 Nov 2026 08:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 232C21F000C1;
	Thu,  5 Nov 2026 08:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793868261;
	bh=tsjt9E/SOoMFBDvFXKXQOgR8qFXU1RBSyugeCKhoESM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Zw363AHc5TWxygFfbv4jUxUJ97nAmW7/xe8zRcVQK9OirLTd2Fd7XAS9RO9M5ijyU
	 XTwzxfc3twRyIosjmZMETrpZq4EWZBjV2GeFb8VGudackgE7I6Xp93au1anf5bByt7
	 YyDl1oNBJwzjMKhfTWeF8ferHyfg3jfKuKI22FTgULUT3WsThJKa+Xj5eut+lW5wB8
	 tOGBQu5V5orRlls5jiYgZ33bQ3ykBAh9AB2qd4KAM8vfdXtlkpIaXmRDB7BzI9STlI
	 oE0HrMg4q4GnGtGbdYNdtFzLxRl9iyx8VBemEKD27pYoFYflM2zgJ+UM8o/fFj3i/P
	 LSQJ9vNYpBUVA==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Thu, 05 Nov 2026 09:43:56 +0100
Subject: [PATCH v3 07/10] mm, slab: convert CONFIG_SLUB_TINY checks to
 kmem_cache_debug()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261105-slub_tiny_rework-v3-7-0484ce59eabb@kernel.org>
References: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
In-Reply-To: <20261105-slub_tiny_rework-v3-0-0484ce59eabb@kernel.org>
To: Harry Yoo <harry@kernel.org>, Andrey Ryabinin <ryabinin.a.a@gmail.com>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <dlemoal@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Alexander Potapenko <glider@google.com>, 
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>, 
 Vincenzo Frascino <vincenzo.frascino@arm.com>, kasan-dev@googlegroups.com, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Stat-Signature: gn5irqjjyrdux4cdta73si6wzac7oys6
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 105461A000A
X-HE-Tag: 1793868261-292070
X-HE-Meta: U2FsdGVkX1+ujm6g1rNi6dTBqezfonPjesOJmQndA8AURMLIrr+80/GMXCZucDp06p29Y4wh6RSnwtl42cf2R7SRcsHWIJJZS0m2CENvyKbi9FYWWM2IQbwXDNs9TzkWpgmEiAN+YfP4tFg+cxtZGqbb9QhoBCmB3JbrFVoTS37DcHEuHX8mjRVqcoXLjqXe8xOvl12wU944v4bbkkO35XdaYqQph1ktXHYXxGYVRcbcK/bIPx1tki4BPVIdj2bT6NbT/g4ddwMOF848bUDYzfocioFd88R+qJupFZ+2GU3aWswfNnD81qvM0V6eQuytlMJm9rk6Z5lolZJ/MAlcO5hI9hKSEyWB0+k7zrRYY/QZFPrX/uoryIh1Jn0Rc9cSezRfo7H776bH2JKFLyqLLt6+yv5+20cNzBY6Roy6pgqPRFYN+7g0UL4l33XwXAWew8CcsDEYpypiifc6TaV9kU+mXRS0HvoLuIntd+XWTwbrJxL847xoDwfn4BXvsJA40oKn7cWBKhB62olftSFswzTx77YRrUhdcINAz4ONjj/BrUei3FUYo21ZKCwwUBfq+cYTaG6tX0TPiB7+N6xa94pJtUuW352wfTdSVtBqUox8gkb5f6IILcSXBrB6L4G8GNMkYYv0n71GvnXuqbpxNpSlSxD5PtQ/7tIvAoJm9XViXS1m5odnhHV56lt8O33UBO2vIsySiJoGE4VR8y8msRrShNlY5+hyVXCiEF8edS51HjvIrDvqPMO/PitZZmNU2wj8dqhy2P4/RNEo/SdBcxJ10vw3O2pj5c7g7F3iJjLwS1HhSdXBL41ZswjsPqMnn5o1LcHWUhrGaXpBjk4dcWnhddtEWrfPS8hbtowxGRldvnBKJo0C78vicNPB5M5h+Ag1lV+RdFYWEt+UMTh5i04c5qxcFZwDAb4bbiD7fov7ZZyoh0e2xTTV7dCBh35MiPFJsl/kSkNXs+CtpGD
 ZEKchVNX
 19whB3BCzRzMKaOBIlqPTHvYt2hhUQbZ+zLWLIQBn6GAZxkN9zaalsQhp8LhmfNYXa4NI0uCwfqqa4e9fQhWEZiTTiI2hs6zZ7Vt0wxdCLTydyqWlfUDpN5cIWVgz0W46XtaVVHlHGwULMiB3gJNjMi5xSPAz3Jdwfo/HSa5u7ME4H6lhmwoRGZLaB6uf2kPw3lVUAbmi/zTBdoSAXBnnBdxhj62bWXJ0aV97mqRTtFdDgNxrLih6ubC0Z6zLJw9Ku3yAv9sDsX9jbiL7x/FHbTUOouUPcjzgoqWfJn6lhWknyTd3NaLnyrlMVvwhcGERq85bpCx6JsQHWtB+nw1ub4XNBKpJ5iiw5YE69RmvnPWpQj5t2GoXxrlzdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

CONFIG_SLUB_TINY shares several slowpaths with debugging as both of them
avoid percpu caching of objects. With the goal of replacing the config
with a boot-time decision, extend this sharing by hooking
slab_tiny_enabled into kmem_cache_debug() check itself.

This is made possible by the new SLAB_DEBUG_NOOP debug flag. Make
slub_debug_enabled static key always available (not just with
CONFIG_SLUB_DEBUG enabled) and have slab_tiny_enabled add
SLAB_DEBUG_NOOP to all caches in kmem_cache_flags(). Do this also in the
CONFIG_SLUB_DEBUG variant, which is currently exclusive with
CONFIG_SLUB_TINY, but that will be lifted later.

Remove the various IS_ENABLED(CONFIG_SLUB_TINY) checks that
complement kmem_cache_debug() checks as they are no longer necessary.

While removing/adjusting the CONFIG_SLUB_DEBUG #ifdefs, also convert
CONFIG_SLUB_DEBUG_ON to *_STATIC_KEY_MAYBE().

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 18 ++++++------------
 mm/slub.c | 38 ++++++++++++++++++--------------------
 2 files changed, 24 insertions(+), 32 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 835d977634ec..7ea057fda751 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -506,26 +506,20 @@ struct slabinfo {
 
 void get_slabinfo(struct kmem_cache *s, struct slabinfo *sinfo);
 
-#ifdef CONFIG_SLUB_DEBUG
-#ifdef CONFIG_SLUB_DEBUG_ON
-DECLARE_STATIC_KEY_TRUE(slub_debug_enabled);
-#else
-DECLARE_STATIC_KEY_FALSE(slub_debug_enabled);
-#endif
-extern void print_tracking(struct kmem_cache *s, void *object);
-long validate_slab_cache(struct kmem_cache *s);
+DECLARE_STATIC_KEY_MAYBE(CONFIG_SLUB_DEBUG_ON, slub_debug_enabled);
+
 static inline bool __slub_debug_enabled(void)
 {
 	return static_branch_unlikely(&slub_debug_enabled);
 }
+
+#ifdef CONFIG_SLUB_DEBUG
+extern void print_tracking(struct kmem_cache *s, void *object);
+long validate_slab_cache(struct kmem_cache *s);
 #else
 static inline void print_tracking(struct kmem_cache *s, void *object)
 {
 }
-static inline bool __slub_debug_enabled(void)
-{
-	return false;
-}
 #endif
 
 /*
diff --git a/mm/slub.c b/mm/slub.c
index be4e1f193295..1b7626645068 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -202,13 +202,7 @@ enum slab_flags {
 #define __fastpath_inline
 #endif
 
-#ifdef CONFIG_SLUB_DEBUG
-#ifdef CONFIG_SLUB_DEBUG_ON
-DEFINE_STATIC_KEY_TRUE(slub_debug_enabled);
-#else
-DEFINE_STATIC_KEY_FALSE(slub_debug_enabled);
-#endif
-#endif		/* CONFIG_SLUB_DEBUG */
+DEFINE_STATIC_KEY_MAYBE(CONFIG_SLUB_DEBUG_ON, slub_debug_enabled);
 
 #ifdef CONFIG_NUMA
 static DEFINE_STATIC_KEY_FALSE(strict_numa);
@@ -1041,11 +1035,7 @@ static inline void *restore_red_left(struct kmem_cache *s, void *p)
 /*
  * Debug settings:
  */
-#if defined(CONFIG_SLUB_DEBUG_ON)
-static slab_flags_t slub_debug = DEBUG_DEFAULT_FLAGS;
-#else
-static slab_flags_t slub_debug;
-#endif
+static slab_flags_t slub_debug = IS_ENABLED(CONFIG_SLUB_DEBUG_ON) ? DEBUG_DEFAULT_FLAGS : 0;
 
 static const char *slub_debug_string __ro_after_init;
 static int disable_higher_order_debug;
@@ -2032,6 +2022,9 @@ slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name)
 	slab_flags_t block_flags;
 	slab_flags_t slub_debug_local = slub_debug;
 
+	if (slab_tiny_enabled)
+		flags |= SLAB_DEBUG_NOOP;
+
 	if (flags & SLAB_NO_USER_FLAGS)
 		return flags;
 
@@ -2104,6 +2097,9 @@ static inline void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
 					struct slab *slab) {}
 slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name)
 {
+	if (slab_tiny_enabled)
+		flags |= SLAB_DEBUG_NOOP;
+
 	return flags;
 }
 #define slub_debug 0
@@ -3964,7 +3960,7 @@ static void *get_from_partial_node(struct kmem_cache *s,
 		if (!pfmemalloc_match(slab, gfp_flags))
 			continue;
 
-		if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+		if (kmem_cache_debug(s)) {
 			object = alloc_single_from_partial(s, n, slab,
 							ac->orig_size);
 			if (object)
@@ -4578,7 +4574,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 
 /*
  * Slow path. We failed to allocate via percpu sheaves or they are not available
- * due to bootstrap or debugging enabled or SLUB_TINY.
+ * due to bootstrap or debugging enabled.
  *
  * We try to allocate from partial slab lists and fall back to allocating a new
  * slab.
@@ -4632,7 +4628,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	stat(s, ALLOC_SLAB);
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+	if (kmem_cache_debug(s)) {
 		object = alloc_single_from_new_slab(s, slab, ac);
 
 		if (likely(object))
@@ -5861,7 +5857,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 	unsigned long flags;
 	bool on_node_partial;
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+	if (kmem_cache_debug(s)) {
 		free_to_partial_list(s, slab, head, tail, cnt, addr);
 		return;
 	}
@@ -7573,7 +7569,7 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
 {
 	int i;
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+	if (kmem_cache_debug(s)) {
 		const struct slab_alloc_context ac = {
 			.caller_addr = _RET_IP_,
 			.orig_size = s->object_size,
@@ -7874,7 +7870,7 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 		 * cache.
 		 *
 		 * We keep bootstrap_sheaf for kmem_cache and kmem_cache_node,
-		 * caches with debug enabled, and all caches with SLUB_TINY.
+		 * and caches with debugging enabled.
 		 * For kmalloc caches it's used temporarily during the initial
 		 * bootstrap.
 		 */
@@ -8691,7 +8687,7 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 
 	capacity = calculate_sheaf_capacity(s, &empty_args);
 
-	/* capacity can be 0 due to debugging or SLUB_TINY */
+	/* capacity can be 0 due to debugging */
 	if (!capacity)
 		return;
 
@@ -8757,8 +8753,10 @@ void __init kmem_cache_init(void)
 
 	slab_obj_ext_has_codetag_init();
 
-	if (slab_tiny_enabled)
+	if (slab_tiny_enabled) {
 		slab_max_order = 1;
+		static_branch_enable(&slub_debug_enabled);
+	}
 
 	if (slab_max_order_param <= MAX_PAGE_ORDER)
 		slab_max_order = slab_max_order_param;

-- 
2.56.0


