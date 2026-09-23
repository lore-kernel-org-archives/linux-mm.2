Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BB16C98304
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 15:45:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E283A6B009F; Wed, 23 Sep 2026 11:45:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B5A6B00A0; Wed, 23 Sep 2026 11:45:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C52F26B00A1; Wed, 23 Sep 2026 11:45:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 963FB6B009F
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 11:45:34 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1C40A4026A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:34 +0000 (UTC)
X-FDA: 85245451788.20.4ECC12D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 159DD100009
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 15:45:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UbAbL/u0";
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790178332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cf8h14QuICV9AFXO/du43rKQzztTKxLUCWiq2pXLLBo=;
	b=tskxbEFPjK4laGiov+nmF4YHme2r/ERluYK7s+g+avMqllljk0JrXKc1fKzdo3sPF1tH3L
	iC5S878EHvp+FCPAHe8dMN+Tuf+beL82PnRWLCoCovlHjzCdVyjwof4hf4q+SLg+G1FW49
	IOkHcg/vaLo1XA+ZmsWIMxCxyeYXtdM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="UbAbL/u0";
	spf=pass (imf05.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790178332;
	b=wMaI6W/SnjpKgjzXksvNmpbSDHm6n+q0KbMWvrErllFAEdZyfoG8kavH2hXqbQbQqb6+ZV
	QidsZjqW6EcbivHIm9idmRjYvPz/sLn3W1LoVjphian5g0eZnT4kFhhuFZ7qESUymkVSwN
	sQkHXSL6yDEsFLPlIm0FzwzDSFNjvU4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8302560142;
	Wed, 23 Sep 2026 15:45:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2055D1F00893;
	Wed, 23 Sep 2026 15:45:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790178331;
	bh=cf8h14QuICV9AFXO/du43rKQzztTKxLUCWiq2pXLLBo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UbAbL/u0JvZsUlgMBthQ9AwH/tO5dqygUtU92S1O4NBxtmdXFyrl3cRipSBmjz6Ye
	 zDtjhRBPD1uZguo51h9n7WpVJVIuqZp5XCWn+6ORbau3BmWymNXUSqSQL4QhipCEBF
	 fSxKkUWh/1Z0tkoC10Mq7lBPNpx3V8pHY+HobR4m1qA2xulcoYXSqox91RmMBCcHGC
	 3Mk1i4JtKXzx1n4krOIJ0pILM0tegZ3ms3ZSARbUtJ29EUR7DIu9WTo1/8rvHWruA0
	 X8nvOsDQNsy3tLWbAnLUOxZQmdM9wocYFlvq5NDOYSJ0O3vOWsQtEuycARKu0gJP/v
	 pdKQxOunPuyLg==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 23 Sep 2026 17:45:10 +0200
Subject: [PATCH RFC 5/8] mm, slab: convert CONFIG_SLUB_TINY checks to
 kmem_cache_debug()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-slub_tiny_rework-v1-5-a0e66d536eb5@kernel.org>
References: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
In-Reply-To: <20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Geert Uytterhoeven <geert@linux-m68k.org>, Conor Dooley <conor@kernel.org>, 
 Damien Le Moal <damien.lemoal@opensource.wdc.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 159DD100009
X-Stat-Signature: s4b6wfq8gn6cz9ytqnfh98xitbri8hcy
X-Rspam-User: 
X-HE-Tag: 1790178331-153523
X-HE-Meta: U2FsdGVkX1/lqWyQ1tsY27cDFxD1o/pwayDjbx+AVd0KLW+jDJGLzIthzBRcyocsA6Vi/NjCv3JeH519WMgzynhUxQCViGO87PY1Pk2pwsObtsDqP1SXMAq16fIJsgV2WMpezOLIOHAkadneyMbDZhLeUOkWnXKtHLgpj21kHomczvtseGu3ZCIjN2WOJRtBYCld4ciXWRZ1Ppbb+yH71xsDF73H8KU2RTfT5mE9th8M1FtqyBbRR4XbINvuq56SNGBzk/1usqUc+Lxhz8LJZc5325T8FRCeX/8FFXYmIUO7+u0U5p1oh5NKtWfSHxl+MyPkAsBsPH187W9Af2TEJSOWLx9SxDHdh4Owt9t4P2EmttctQQnT0JJT7+daiaYQzkr0qIus7q9ABfOJbgyexJ5D9QSodQVtGyXjzP0e/C28BRi7TfE9ALz6Jzff+eRJnnu+sTUOv+aIUwZ3ZZBSLuWBQqVextBYk8zJiwR+/Rin/bgUBJflPr2P9GqTF7V1Oq9TWsIl1PwVFiySN9PHlTTLq2zREiqfvZbUs3WfybG50r0LKAcyoS8qElPnl0XnH4ovfwfkbET1QLOtVvFlYAjBuQOjJUCROyMB22IF5lQDgXCtj+TlMAxMV/926EmPFfUQcreXthLCPcS9OYMMwlGiqz36yZL6UHzUfTli5MEw4CCbmwn2Mb+4+vQdWjMdaHuZCtUM3421q/l5KmMdlNlpFvBjavFqwXI5YeffPrwPVmDIZBtV9pmZMwYDzobY45pbTYTgWprixB0+QYDyDMcqvQtyTV2Xdr4ykHMNHdoLqDdj+wKMrPSgt9P82oyOAhsRsqeJfvaO8bblRXDGCslGgrj+xT+0koRvoV89npX8VfIr29vG3z9LI/l+mqwTyiXLk/NtLSnAyQ08pDa84JaW943KzPdweSqVMEgOEfb04vwQjROu14H3YYjgaEdAg9lyVsyeJ1K0UJQzBz0
 H5VUNqW8
 8w9+RXVVCE2nLUjAfRUy1T35vvafCDLiZF8d4EKYy4TtAtO/rJDOhbsTHJSdAMjZGtnNQiTUPhEJJYyDSyXFKOzNbEuj4Z7DC0WL5FfbdNWJtKy6p33aGnriNZz7/SGY9FEp4ia9tnNn1ssNg6Lb2iZ+TvEWZFW2hb7TbkyO+Q2w0IFCbINrcFH8zDTsz5DRWFZ2nvFQjXFYfA6Tik2iP5mUgW4sXzlcnWlkilTZFngw2X0xuMrOZMinAzPdYd6XxEdLfxq4jT/wQ3i1OXACmjYG4DNEtCYmYOroko7NVym3XTVw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
index 00d49ac0d93f..23017a5d10d1 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -520,26 +520,20 @@ struct slabinfo {
 
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
index 2c8477033700..c6a0422e055d 100644
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
@@ -1040,11 +1034,7 @@ static inline void *restore_red_left(struct kmem_cache *s, void *p)
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
@@ -2017,6 +2007,9 @@ slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name)
 	slab_flags_t block_flags;
 	slab_flags_t slub_debug_local = slub_debug;
 
+	if (slab_tiny_enabled)
+		flags |= SLAB_DEBUG_NOOP;
+
 	if (flags & SLAB_NO_USER_FLAGS)
 		return flags;
 
@@ -2087,6 +2080,9 @@ static inline void remove_full(struct kmem_cache *s, struct kmem_cache_node *n,
 					struct slab *slab) {}
 slab_flags_t kmem_cache_flags(slab_flags_t flags, const char *name)
 {
+	if (slab_tiny_enabled)
+		flags |= SLAB_DEBUG_NOOP;
+
 	return flags;
 }
 #define slub_debug 0
@@ -3942,7 +3938,7 @@ static void *get_from_partial_node(struct kmem_cache *s,
 		if (!pfmemalloc_match(slab, gfp_flags))
 			continue;
 
-		if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+		if (kmem_cache_debug(s)) {
 			object = alloc_single_from_partial(s, n, slab,
 							ac->orig_size);
 			if (object)
@@ -4556,7 +4552,7 @@ static unsigned int alloc_from_new_slab(struct kmem_cache *s, struct slab *slab,
 
 /*
  * Slow path. We failed to allocate via percpu sheaves or they are not available
- * due to bootstrap or debugging enabled or SLUB_TINY.
+ * due to bootstrap or debugging enabled.
  *
  * We try to allocate from partial slab lists and fall back to allocating a new
  * slab.
@@ -4610,7 +4606,7 @@ static void *___slab_alloc(struct kmem_cache *s, gfp_t gfpflags, int node,
 
 	stat(s, ALLOC_SLAB);
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+	if (kmem_cache_debug(s)) {
 		object = alloc_single_from_new_slab(s, slab, ac);
 
 		if (likely(object))
@@ -5764,7 +5760,7 @@ static void __slab_free(struct kmem_cache *s, struct slab *slab,
 	unsigned long flags;
 	bool on_node_partial;
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+	if (kmem_cache_debug(s)) {
 		free_to_partial_list(s, slab, head, tail, cnt, addr);
 		return;
 	}
@@ -7471,7 +7467,7 @@ static bool __kmem_cache_alloc_bulk(struct kmem_cache *s, gfp_t flags,
 {
 	int i;
 
-	if (IS_ENABLED(CONFIG_SLUB_TINY) || kmem_cache_debug(s)) {
+	if (kmem_cache_debug(s)) {
 		const struct slab_alloc_context ac = {
 			.caller_addr = _RET_IP_,
 			.orig_size = s->object_size,
@@ -7772,7 +7768,7 @@ static int init_percpu_sheaves(struct kmem_cache *s)
 		 * cache.
 		 *
 		 * We keep bootstrap_sheaf for kmem_cache and kmem_cache_node,
-		 * caches with debug enabled, and all caches with SLUB_TINY.
+		 * and caches with debugging enabled.
 		 * For kmalloc caches it's used temporarily during the initial
 		 * bootstrap.
 		 */
@@ -8588,7 +8584,7 @@ static void __init bootstrap_cache_sheaves(struct kmem_cache *s)
 
 	capacity = calculate_sheaf_capacity(s, &empty_args);
 
-	/* capacity can be 0 due to debugging or SLUB_TINY */
+	/* capacity can be 0 due to debugging */
 	if (!capacity)
 		return;
 
@@ -8654,8 +8650,10 @@ void __init kmem_cache_init(void)
 
 	slab_obj_ext_has_codetag_init();
 
-	if (slab_tiny_enabled)
+	if (slab_tiny_enabled) {
 		slab_max_order = 1;
+		static_branch_enable(&slub_debug_enabled);
+	}
 
 	if (slab_max_order_param <= MAX_PAGE_ORDER)
 		slab_max_order = slab_max_order_param;

-- 
2.55.0


