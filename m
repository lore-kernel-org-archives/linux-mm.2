Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68B8DC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:17:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B07C26B00A6; Mon, 20 Jul 2026 10:17:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADE086B00A7; Mon, 20 Jul 2026 10:17:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9805E6B00A9; Mon, 20 Jul 2026 10:17:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6357A6B00A6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:17:08 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E7FCE401D1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:17:07 +0000 (UTC)
X-FDA: 85009356894.07.BE0F36E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4E98D40004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:17:06 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JVDub6Es;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PKtmpQd7DPgnVftxCtGlnwK8PF1qRuxFiLgmmihblnM=;
	b=3CSKTo65pEDiYF6Szeylt05iMj0hJxoB92axxPaIeQuN4hbO7jHjaA60uGW12PlCnxwNzf
	xU10NPKaQ15ft8cA/l2/QOHtKCe8dJDXZkL9JSm1w2J8QJizTDnJuheFOWOZTk2jiYwCGN
	wFmN4hBQbgBgDkzvg20kmWXedF2RESs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557026;
	b=pT0wr4TGUeLcE0p3IN7MEcLGVawlpPIapTQ38jvG2kHwfnLaGhYEZrDm3MJCrDnzxK7Hn0
	lWAgHIFQAfSJvHYvAwbYdkCwfuC0xOQ1VrNDZxO5NFhxEoVxAym9WABhoK/2aUO6LgTnsg
	fLWSrnYu5a6llsuneI+8l8f9l0oqtJw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JVDub6Es;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D8E58601DE;
	Mon, 20 Jul 2026 14:17:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED0321F00A3D;
	Mon, 20 Jul 2026 14:17:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557025;
	bh=PKtmpQd7DPgnVftxCtGlnwK8PF1qRuxFiLgmmihblnM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JVDub6Es2QCeoRpdWlUpFhxs0iL6jDyZ7azuzPC5ljaXBYgFmorxwg8bg+KYnHvaD
	 7wxnO3abCFcoqdu1Jzt+bsn/FlqNOHn7D0WC/G2tkoh5SrKuc5H+oiwWm/15sgxMEL
	 YjQe1TAJIF1xUG1YSv1RILv6Xzt/IQHkrcQGNXagTrxmfV6jI/loPXhRqfu7Y+aUT5
	 rDtx8bh51AFLM154oR+vbCr/nDSGnbvYAylExFkv2bJGdj7ukhuLYTUKrjF6iK9jfp
	 Vhz69cZzCUHrW52DXwgTLSQBOU+5eBMMDvUCvcmqYxzbmTgQ7iyG5aj9BQvdR/sELg
	 +t1fDBs++G6iw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:26 +0200
Subject: [PATCH v2 12/13] mm/slab: add cache_ and slab_needs_objcg()
 helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-12-2fa7c6f60dbe@kernel.org>
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 4E98D40004
X-Stat-Signature: zrbkg4oa6tcnaos4jmc86946tcjz14ip
X-Rspam-User: 
X-HE-Tag: 1784557026-104201
X-HE-Meta: U2FsdGVkX18ojyFuP3W+wT24LqO5E8TMak9KI7znnmRs65PxGlnDoTWAqM4YiolRxlxQigIYAWc58vMNfwgedH9nJyHBX3dgGFO67cT62PDcldX7AQIaLvnV90jZFo2h8nK3ygTXl50AdMSS6jfwVu+QZKHcDgRbJdWsGsZM7zSKkyPVizRYoF5NR/6r0YxF3AFxhFO6FfvrgxI39HjEJNZMCQ4vK0illSOqbj8Ytq+CIpv/LD80SFUE2w8ETzcrIzpZxst6swzowM4orfmREP1SByPwynTVcUJEUYbUjR+yX/dQftHMxenv9UxKWvba1TbLceNZWzq1ii0U5bOyFIgqaSuU1w/wMcb4y78odP9gtjzod9PwsC9OzWGWB8lGrvT6a7hhdwHz/+RrvP/Ea+ZHW+NHS9rIZ2bzs1pT4wJ4NDliztNPGKAEacbcOhMSnWkNUU8botq+g5pnPEoczK/P62zQr4mQBbmLo18XO0qZu8JM5ts7AnBbTj/lGspqj2yq0pQdAaSZGCAljtkJltissIz71P912RXVFvObKY5iJue0rTsi0f96BiiXyQ9imRb2ctg/PqYYHFCwkJXu40pZXFrW1t19NZejYhwDfJ1K7j7Ik7Z/twyq500CI7dizKeCy1JvFNPXVC1in/UQyWGFmOJQFfAnq3kJVQKh+vGCJpxy5tZjqyrB78aRV9DvDMBMm9hGgV8PCesyy47SHypeRDpGTOcb2RjL4PSKgffpymWwxHwGMFYt42sVAUVJA3C4OPhH4BHbmQWWv8etyhoU1yUxS7cb1Xw8sBWSEezqhLMLLgwIegQQG/CqtLn0BT3Xc3rp7HWGK03J5t0W3AdchrucRLIgnxFITaYXY7TsxJcdo80VuyxfvHE4cpP5qRi0A3N7Ax66v5pjg8xX2sO3brf8V3rFjriVGoyVibfxYxIioxcZShCIf/la0ODJs04J9TaDCYEHpCYDxsy
 vLs9CkBp
 /X64AVka2gbUncWowJgED4Y+JYArv7W8js3gRjVuef9fIsy+x6GI6kNFzOOda6ahwZhDZyWi5DMHM7woozfKHIgI2/1p34bTfJWHra48+OycgeJDLoChD4ThL24zmTe/4ChbMY6jeZsOr0W38bE3mnGFGb1ggwYvJLgTGWN8rTaIcWi4WM9eoh/W8n9uAWVvIVktgIJ3YCdPzKTGoseicOi3tpU/VoIM5JxfhZdap4UbJnB9hAWvIcVcWD5UgyPjy/UC2Wje7mAoYoi0BaUePfKXypr3tqCJDjeSQ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Slabs of some caches never need the objcg part of struct slabobj_ext.
Introduce helpers to query this for a cache or a slab.

Introduce SLAB_MAY_ACCOUNT flag that is currently only internal and only
is_kmalloc_normal() caches don't have the flag.

For named caches we currently can't derive SLAB_MAY_ACCOUNT from
SLAB_ACCOUNT because some caches might be created without SLAB_ACCOUNT
and then used both with and without __GFP_ACCOUNT concurrently,
allocating obj_ext arrays on demand. So just add the SLAB_MAY_ACCOUNT
to all kmem caches, unless kmem accounting is disabled.

This can be improved later by finding out all caches used with
__GFP_ACCOUNT, adding the SLAB_MAY_ACCOUNT flag to them explicitly and
then ignoring __GFP_ACCOUNT for all other caches (with possible
warning).

To make the evaluation of slab_needs_objcg() faster in the allocation
and free fast paths, add a obj_exts_needs_objcg flag into slab itself.
This optimization is only available on 64bit architectures where free
bits are available for the flag.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 include/linux/slab.h |  3 +++
 mm/kfence/core.c     |  3 +++
 mm/slab.h            | 31 +++++++++++++++++++++++++++++--
 mm/slab_common.c     | 25 ++++++++++++++++++++-----
 mm/slub.c            |  6 +++++-
 5 files changed, 60 insertions(+), 8 deletions(-)

diff --git a/include/linux/slab.h b/include/linux/slab.h
index 3a14df50766a..f9132902c5a6 100644
--- a/include/linux/slab.h
+++ b/include/linux/slab.h
@@ -45,6 +45,7 @@ enum _slab_flag_bits {
 #endif
 #ifdef CONFIG_MEMCG
 	_SLAB_ACCOUNT,
+	_SLAB_MAY_ACCOUNT,
 #endif
 #ifdef CONFIG_KASAN_GENERIC
 	_SLAB_KASAN,
@@ -204,8 +205,10 @@ enum _slab_flag_bits {
  */
 #ifdef CONFIG_MEMCG
 # define SLAB_ACCOUNT		__SLAB_FLAG_BIT(_SLAB_ACCOUNT)
+# define SLAB_MAY_ACCOUNT	__SLAB_FLAG_BIT(_SLAB_MAY_ACCOUNT)
 #else
 # define SLAB_ACCOUNT		__SLAB_FLAG_UNUSED
+# define SLAB_MAY_ACCOUNT	__SLAB_FLAG_UNUSED
 #endif
 
 #ifdef CONFIG_KASAN_GENERIC
diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 05b5482c8150..897ecf2594fb 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -640,6 +640,9 @@ static unsigned long kfence_init_pool(void)
 		struct slab *slab = page_slab(page);
 		slab->obj_exts = (unsigned long)&kfence_metadata_init[i / 2 - 1].obj_exts |
 				 MEMCG_DATA_OBJEXTS;
+#ifdef CONFIG_64BIT
+		slab->obj_exts_needs_objcg = 1;
+#endif
 #endif
 	}
 
diff --git a/mm/slab.h b/mm/slab.h
index c5f37a46434e..65b44902c06e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -81,10 +81,11 @@ struct freelist_counters {
 #ifdef CONFIG_64BIT
 					/*
 					 * Some optimizations use free bits in 'counters' field
-					 * to save memory. If these free bits are not available,
-					 * such optimizations are disabled.
+					 * to save memory or CPU. If these free bits are not
+					 * available, such optimizations are disabled.
 					 */
 					unsigned obj_exts_in_object:1;
+					unsigned obj_exts_needs_objcg:1;
 #endif
 				};
 			};
@@ -584,6 +585,32 @@ static inline bool slab_obj_ext_has_codetag(void)
 }
 #endif
 
+#ifdef CONFIG_MEMCG
+static inline bool cache_needs_objcg(struct kmem_cache *cache)
+{
+	return (cache->flags & SLAB_MAY_ACCOUNT);
+}
+
+static inline bool slab_needs_objcg(struct slab *slab)
+{
+#ifdef CONFIG_64BIT
+	return slab->obj_exts_needs_objcg;
+#else
+	return cache_needs_objcg(slab->slab_cache);
+#endif
+}
+#else
+static inline bool cache_needs_objcg(struct kmem_cache *cache)
+{
+	return false;
+}
+
+static inline bool slab_needs_objcg(struct slab *slab)
+{
+	return false;
+}
+#endif
+
 static inline size_t cache_obj_ext_size(struct kmem_cache *s)
 {
 	size_t sz = 0;
diff --git a/mm/slab_common.c b/mm/slab_common.c
index 03ecac12cd86..4e983e250338 100644
--- a/mm/slab_common.c
+++ b/mm/slab_common.c
@@ -52,7 +52,7 @@ struct kmem_cache *kmem_cache;
 		SLAB_OBJ_EXT_IN_OBJ)
 
 #define SLAB_MERGE_SAME (SLAB_RECLAIM_ACCOUNT | SLAB_CACHE_DMA | \
-			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT)
+			 SLAB_CACHE_DMA32 | SLAB_ACCOUNT | SLAB_MAY_ACCOUNT)
 
 /*
  * Merge control. If this is set then no merging of slab caches will occur.
@@ -359,6 +359,13 @@ struct kmem_cache *__kmem_cache_create_args(const char *name,
 		goto out_unlock;
 	}
 
+	/*
+	 * For now we assume any cache can be used with __GFP_ACCOUNT and thus
+	 * may need to store objcg pointers for objects
+	 */
+	if (!mem_cgroup_kmem_disabled())
+		flags |= SLAB_MAY_ACCOUNT;
+
 	/* Fail closed on bad usersize of useroffset values. */
 	if (!IS_ENABLED(CONFIG_HARDENED_USERCOPY) ||
 	    WARN_ON(!args->usersize && args->useroffset) ||
@@ -984,11 +991,19 @@ new_kmalloc_cache(int idx, enum kmalloc_cache_type type)
 #endif
 
 	/*
-	 * If CONFIG_MEMCG is enabled, disable cache merging for
-	 * KMALLOC_NORMAL caches.
+	 * If memcg_kmem is enabled and this is a KMALLOC_NORMAL cache and  not
+	 * aliased with any other type, make sure it's never merged with any other
+	 * cache.
+	 *
+	 * In other cases the kmalloc cache may end up being used for a
+	 * __GFP_ACCOUNT allocation so mark it as such
 	 */
-	if (IS_ENABLED(CONFIG_MEMCG) && (type == KMALLOC_NORMAL))
-		flags |= SLAB_NO_MERGE;
+	if (!mem_cgroup_kmem_disabled()) {
+		if (type == KMALLOC_NORMAL && KMALLOC_RECLAIM != KMALLOC_NORMAL)
+			flags |= SLAB_NO_MERGE;
+		else
+			flags |= SLAB_MAY_ACCOUNT;
+	}
 
 	if (minalign > ARCH_KMALLOC_MINALIGN) {
 		aligned_size = ALIGN(aligned_size, minalign);
diff --git a/mm/slub.c b/mm/slub.c
index d78d3e50c877..30435e2509ea 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -2557,7 +2557,7 @@ bool memcg_slab_post_charge(void *p, gfp_t flags)
 	 * of slab_obj_exts being allocated from the same slab and thus the slab
 	 * becoming effectively unfreeable.
 	 */
-	if (is_kmalloc_normal(s))
+	if (!cache_needs_objcg(s))
 		return true;
 
 	/* Ignore already charged objects. */
@@ -3435,6 +3435,10 @@ static struct slab *allocate_slab(struct kmem_cache *s, gfp_t flags,
 
 	slab->objects = oo_objects(oo);
 
+#ifdef CONFIG_64BIT
+	if (cache_needs_objcg(s))
+		slab->obj_exts_needs_objcg = 1;
+#endif
 	slab->slab_cache = s;
 
 	kasan_poison_slab(slab);

-- 
2.55.0


