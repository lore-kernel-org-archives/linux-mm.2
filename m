Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC090CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:42:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 27A4B6B00AE; Wed, 10 Jun 2026 11:42:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2527E6B00B0; Wed, 10 Jun 2026 11:42:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 18F4D6B00B1; Wed, 10 Jun 2026 11:42:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 03E576B00AE
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:42:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B94E4A0192
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:42:05 +0000 (UTC)
X-FDA: 84864419010.01.0A27E13
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 0C801140005
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:42:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JDGT057Y;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106124;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5z1rZN9sqWsWaxKpHBc5tulXDwFk9WStgfZajrZ0EDI=;
	b=N7vjxhQiPkneAXcDpk4Vz0AywcbZLe0oPfsTw7dRIAx9I5JBFBn6qgg1uzb4QtleyyjJ6z
	eJbupllN0srlKyeRTV21ARsb+wGx71qBojnwPlC8nRcTr8CZMsthHtCfWTpjQaJzDr+xgS
	xqpcVBDA9Xk24VeWdgghEjiBbMSprRs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JDGT057Y;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106124;
	b=H1a/OXieKdObQs2hUb4iUKVPJWGTzNdPvQvNOIveQpo2ffaDzeO1tpWckriI9d1WU6qFO4
	xo6OtuJiDpiSKor0lRKKSvk1v7f4yIcUWBbEkg5Q1joZGX8ZN63eXS+08mliCsPKLoYx/n
	GkIx2VieTZbriIVSiuvlLzbjhKQoiTQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 54DBA4048E;
	Wed, 10 Jun 2026 15:42:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C7771F00893;
	Wed, 10 Jun 2026 15:41:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106123;
	bh=5z1rZN9sqWsWaxKpHBc5tulXDwFk9WStgfZajrZ0EDI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JDGT057YotqaJUSdir5KmN+Jl5ptw2nNXgLoxRjoGKKMDlQ9glv9FolEVJS50/ldy
	 rESgVlL3FtpMk2/8euhOLgExEvxrwX2ZgfYX5w5nkMlkoMBqWcJGIXw8UuXWnM9m+z
	 lEGE2JVClQdV4QwnlXSZPyTAgorq9fhTsh1h3yDSFElmKEuAGqiLtKdXPaetwinquY
	 BAJ6JWi2lxvZEzopFmdi4g6BKfwLS3AuTrtKrfqaPYXp6ivxGadt4ANl9K5V8oxM1W
	 aLi0kVocb1hst4K9iGWp6ZfIWUvBLDH/m2eaB/hDtrab2HQ6QGOGWhHomO09LoQkea
	 uTtz6wpYW9Tzw==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:16 +0200
Subject: [PATCH v2 14/16] mm/slab: introduce kmalloc_flags()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-14-7190909db118@kernel.org>
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0C801140005
X-Stat-Signature: s96taiahuncifi6osyosz6mo78tjdhw9
X-Rspam-User: 
X-HE-Tag: 1781106123-192611
X-HE-Meta: U2FsdGVkX1888lTz+EHJez52bZUIwEiGskg23W2q8Gz/UE42+VtsNd2om51rnJQOGFlqohnkw3iaZoZ/mJ7SDNrlcENBOZAvyjOXlWG6n/HtJgY9iJPne34T5vU54TV2AoH4MwxrMw/7v04EZWLSraWwuiD2QsHOfp90Y1vg5MInV5X0Ach4GRUv88WuWNOih/pBqFj/DuYc7a7Ox9N/CJRVirVPKEQ73YEaPdOz5H+B6OJUG4wHjKN359pWVv4a0sCp5t3hCPEOQb2T+iHJLHbakMdMYh2ka9a/MQ7hxkzE28hN3rlT+UuiD6w+SrzMDQUaPcZs0UPGWnTFfs+kv5FGeSxMuGtf9Ivq8td8kbeCbmcB6pPa8L4spH6R8NcQSoB4oaarpqQoTFDwbqp24fSYVCNiKKaI9kUZwzE0Ledggbx7ZF22QRc7yCNsiDP35ttzXKWal3s/8856eru7J7QRtr10WHPmjRl9wJ6KWzktIKv1/7w0C265mlHxiVkX+1hP/HdbmVZZlTkHD+ZTafEGc7EpYNXYZcTcr19tl79Cr+tWb3v45J+95Fg5bL0twhhHaHNPiL3/ySEEpkNuiR4H9FnVOC5jZY8C6TSqXPtJc+Y8VB72VAnIngZZNkrqk9r182v9R8xwLjYuj6fo4nukiDTMdC2yMEEO61W0QMg4koduHwainh7/pmZ5LQ8IltNuSWtWonXaqc+JIMDp1/HY11uRbLhiyxX0tjtmZrKNxfJoqdgpXUyGzl+9NktFPYDklqMgMf4EQsk/zXtzHaeSnghjh2lQjBYtAmBVCV6L7wFTPdzHDBxJVVV4fk+RmmEVzgcByTp++ytF3JMuDFPfeuCmsghl7avkyQhiDFXQHeGAaVv0u4VDOxdP5Yq9iYmzNBHkiLbB/u/a2096+b2dZbDHPEx/ANuaPJez6Ejm+GNSk+Xr6Bjftm3y/5bu8czUMjROnbSmAHVZQOY
 8wWGdvFM
 PyXu9tP0qhmSK42cxjBlXleY7D6Kl9v69IiZD6J5clO3CEtAUcB9hKMTxAi8YHUDxkd2ggljwj5W6NacBxnY2ZRm3afTaUvn5yVmGdv8i3P2YPR6RAKloBtU8fFk2Gg8lxv0fUlpCsummoS/nhsz/9JwuSmtKDPp1aS8ParTesN8LcqmYVJ6bPnNgqgTmQ12mzGFOsN3ZyQKyUJ2WXkVGGMbC98BdHEDZh9sGAd3X0/+twEtaXoKknbzzs3TCih/8/jHAG+dxisxx2E+C+HZx5jwRdzC7rY064mcddRr8a4aUFWQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

With alloc_flags usage in slab, we can replace __GFP_NO_OBJ_EXT with an
alloc flag that prevents kmalloc recursion. For that we need a version
of kmalloc() that takes alloc_flags and use it in places that perform
these potentially recursive kmalloc allocations (of sheaves or obj_ext
arrays).

Add this function, named kmalloc_flags(). Right now it's only useful for
these nested allocations, so it doesn't need to optimize build-time
constant sizes like kmalloc() or kmalloc_buckets.

Since we need it to support both normal and non-spinning
kmalloc_nolock() context through the SLAB_ALLOC_TRYLOCK flag, split out
most of the special _kmalloc_nolock_noprof() implementation to
__kmalloc_nolock_noprof() that takes a slab_alloc_context, and make
_kmalloc_nolock_noprof() a simple tail calling wrapper with the proper
context.

kmalloc_flags() can thus determine whether to call
__kmalloc_nolock_noprof() or __do_kmalloc_node(), based on the
given alloc_flags.

Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 13 +++++++++++++
 mm/slub.c | 56 +++++++++++++++++++++++++++++++++++++++++++-------------
 2 files changed, 56 insertions(+), 13 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index 4db6d8aa0ee3..45bfcfb35a9c 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -11,6 +11,7 @@
 #include <linux/memcontrol.h>
 #include <linux/kfence.h>
 #include <linux/kasan.h>
+#include <linux/slab.h>
 
 /*
  * Internal slab definitions
@@ -26,6 +27,18 @@ static inline bool alloc_flags_allow_spinning(const unsigned int alloc_flags)
 	return !(alloc_flags & SLAB_ALLOC_TRYLOCK);
 }
 
+void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
+				  unsigned int alloc_flags, int node)
+				  __assume_kmalloc_alignment __alloc_size(1);
+
+static __always_inline __alloc_size(1) void *_kmalloc_flags_noprof(size_t size,
+		gfp_t flags, unsigned int alloc_flags, int node, kmalloc_token_t token)
+{
+	return __kmalloc_flags_noprof(PASS_TOKEN_PARAMS(size, token), flags, alloc_flags, node);
+}
+#define kmalloc_flags_noprof(...)	_kmalloc_flags_noprof(__VA_ARGS__, __kmalloc_token(__VA_ARGS__))
+#define kmalloc_flags(...)		alloc_hooks(kmalloc_flags_noprof(__VA_ARGS__))
+
 #ifdef CONFIG_64BIT
 # ifdef system_has_cmpxchg128
 # define system_has_freelist_aba()	system_has_cmpxchg128()
diff --git a/mm/slub.c b/mm/slub.c
index 847cad5203b2..cbb38bd01e46 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5386,14 +5386,14 @@ void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
 }
 EXPORT_SYMBOL(__kmalloc_noprof);
 
-void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
+static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags,
+				     int node, struct slab_alloc_context *ac)
 {
-	size_t orig_size = size;
-	unsigned int alloc_flags = SLAB_ALLOC_TRYLOCK;
 	struct kmem_cache *s;
 	bool can_retry = true;
 	void *ret;
 
+	VM_WARN_ON_ONCE(alloc_flags_allow_spinning(ac->alloc_flags));
 	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
 			__GFP_NO_OBJ_EXT | __GFP_NOWARN | __GFP_NOMEMALLOC));
 
@@ -5430,23 +5430,17 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 		 */
 		return NULL;
 
-	ret = alloc_from_pcs(s, gfp_flags, alloc_flags, node);
+	ret = alloc_from_pcs(s, gfp_flags, ac->alloc_flags, node);
 	if (ret)
 		goto success;
 
-	struct slab_alloc_context ac = {
-		.caller_addr = _RET_IP_,
-		.orig_size = orig_size,
-		.alloc_flags = alloc_flags,
-	};
-
 	/*
 	 * Do not call slab_alloc_node(), since trylock mode isn't
 	 * compatible with slab_pre_alloc_hook/should_failslab and
 	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
 	 * and slab_post_alloc_hook() directly.
 	 */
-	ret = __slab_alloc_node(s, gfp_flags, node, &ac);
+	ret = __slab_alloc_node(s, gfp_flags, node, ac);
 
 	/*
 	 * It's possible we failed due to trylock as we preempted someone with
@@ -5469,11 +5463,23 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 
 success:
 	maybe_wipe_obj_freeptr(s, ret);
-	slab_post_alloc_hook(s, gfp_flags, 1, &ret, &ac);
+	slab_post_alloc_hook(s, gfp_flags, 1, &ret, ac);
 
-	ret = kasan_kmalloc(s, ret, orig_size, gfp_flags);
+	ret = kasan_kmalloc(s, ret, ac->orig_size, gfp_flags);
 	return ret;
 }
+
+void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
+{
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_TRYLOCK,
+	};
+
+	return __kmalloc_nolock_noprof(PASS_TOKEN_PARAMS(size, token),
+				       gfp_flags, node, &ac);
+}
 EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);
 
 void *__kmalloc_node_track_caller_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags,
@@ -5527,6 +5533,30 @@ void *__kmalloc_cache_node_noprof(struct kmem_cache *s, gfp_t gfpflags,
 }
 EXPORT_SYMBOL(__kmalloc_cache_node_noprof);
 
+/*
+ * The only version of kmalloc_node() that takes alloc_flags and thus can
+ * determine on its own whether to handle the allocation via kmalloc_nolock() or
+ * normally
+ */
+void *__kmalloc_flags_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags,
+			     unsigned int alloc_flags, int node)
+{
+	struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = alloc_flags,
+	};
+
+	if (alloc_flags_allow_spinning(alloc_flags)) {
+		return __do_kmalloc_node(size, NULL, flags, node,
+				PASS_TOKEN_PARAM(token), &ac);
+	} else {
+		return __kmalloc_nolock_noprof(PASS_TOKEN_PARAMS(size, token),
+					       flags, node, &ac);
+	}
+}
+
+
 static noinline void free_to_partial_list(
 	struct kmem_cache *s, struct slab *slab,
 	void *head, void *tail, int bulk_cnt,

-- 
2.54.0


