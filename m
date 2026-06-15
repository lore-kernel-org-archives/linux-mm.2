Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE501CD98DE
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:55:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52E1F6B00AC; Mon, 15 Jun 2026 07:55:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5054C6B00AE; Mon, 15 Jun 2026 07:55:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 442576B00AF; Mon, 15 Jun 2026 07:55:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 33F126B00AC
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:55:38 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F082E1409DF
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:37 +0000 (UTC)
X-FDA: 84881992314.18.8C6E454
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 322BB40009
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:55:36 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlCJbcSD;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524536;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TmHeBBNOgV6Vcy7g85BVoEti6aJriI10Deolz6kEodg=;
	b=p4IPtCeVCll360amYvU70xg5taS5RRk5LvD4Cs6GavcH9DS8Z1b0nMHKejZi1lo9l5Xq0o
	hpaaHVKlUwM7YlsoYNglljRDB5d7KGFf+mJnWaN2uTQ+4uSqMmgFTDMJ/dFtASBO2FHKgl
	eWwxs92z1mibguUrQcvU/LeSasXpTIE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524536;
	b=v37uYTwTzF9ibPpeJ+HiW1ed2opZF7H3NBLvkaVXegOkuN9lZu5FgNbvuFX+GkvSpKhxGp
	D9g+ktS+sp2+51bx3hfDuZC7wrSkCnqMzO0GXyDXOGSDQyD24VI8E3ZhQqBqnBz12yhpDl
	ZYo1weRvEE52Ld66aDKT7ertFPR3SS4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YlCJbcSD;
	spf=pass (imf11.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 83A9144519;
	Mon, 15 Jun 2026 11:55:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E98651F000E9;
	Mon, 15 Jun 2026 11:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524535;
	bh=TmHeBBNOgV6Vcy7g85BVoEti6aJriI10Deolz6kEodg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=YlCJbcSDFAb9qdWlco/z2waagtuwSG/nVah0iJj1bLnvWa1P8nEtgWBWCA4k6Fe1n
	 j8cF4IPYucE7OErB99YTnsWYsJQ6y7FA/lp4Ok9D0XdwXW5hi9zpaUsTkvnlbOb8G3
	 LlV39x2ACMY8xZCcEm6V2GObSAC6NH/VX6FXKjDeRZ1RVEwhOzrDjYOnsT1MXwtMUZ
	 S1UUNcJHH55Kajn9tZN6SabzvyrGlPgjoQkjTkdXauDOwpXNFoWTQmtLLQnnkFLJfi
	 9OZvmcX6i4ntxQJLql/uDv6fqH99BVX6SnJQivaSZqxvx5HMuo7e91r+lH2AXZAl9d
	 VAtIxMsWZuv5A==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 15 Jun 2026 13:54:46 +0200
Subject: [PATCH v3 13/15] mm/slab: introduce kmalloc_flags()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260615-slab_alloc_flags-v3-13-ce1146d140fb@kernel.org>
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
In-Reply-To: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 322BB40009
X-Stat-Signature: biw7ebw6uhatffjfinh6qa3sbqagjfx5
X-HE-Tag: 1781524536-508294
X-HE-Meta: U2FsdGVkX1+pRtSU/WToREZk4R0rEBWXURGOmqCmRO7dDhPPxKvEr7KK19Dxgem2+XzZ8bucFjWkufjrjDa292qRqLZXdfyJk3JVuiB+b6hs75GZMpGV3lDxhHl89FtsP4t0l2iogNCGXbzEIvD5p/jZxWIVMPQCsmvziVSDlb+s/hMP4NBhMbNRfKL0MfkYQcXrzaA3rp4RYztcDLCjQTGuqwgvqJxlsXggX1BRLV7tC+JA2cc66ouG/6icX6ZYWGzMTTW/TX2FF0LVMM8sFFOT3QLCFpEivkBq4QxIiep2bWcBfrIVPsz0foitlBqnEcvC6usjFO5Q8lCiP2vXolQG6sOBiwjfEVy3cCbAQ6kINs5RBMxHguSGgATR7oyG8wKSQsZ8rEq93rptwZrbhijDYCqRKLptAk8roG2NV+LUJ/hRnC2izmsalwu/y4LHaHz8nQnS4l/aqoukL4CU10YRX9wwoziUryPZCW019VWDz0nP974dy+N+OByFklIKEzk+IikN3i7j2YOoqWMOTIXam7VO69MUcA1ol32MvqKjH4fHNYQNcvQ95zz8BihAfpoLeip3F+4vgQPjBo1P3simtE4XfnFxOMUpgJr38Q56Ha2numh+iz/eC5hUjJlzAyTL094MbnN+5QaypKncTkB/pvYwyjQ/05QHt60KLV5cSxCwJitXbn81AIDFmQdcuJ9RXB6NNAd6nuVkrdCFZJZmveR9EIH3r7Vfv9t12o5XWzuQcQ2O2CP/FfgL+aqPZjJvWAR/2y0SC+R1oCwDk/lN3YlhoB4d59dlTfzIFin+JoBZPBjoqf3Bf4kKyWkfEhRroXneZ4BVFQMrJ8m8jNbe7bPDSTAv96oqJXF/Ck/ZgAsT+8e88CBofjyE49Oo035JoLConNkm9rOBLNkA2b2KvyYeNgDPD2PEgA7hGBz80cBX+qjpXNvYLqTx3Kz8V2cMbq/ayP1n7Kp5qvC
 abnc02pY
 CLMbkrHu5lkWqC1MivSSa3mLumForAr3YFFH/2mGgMFJZOAl7r2l8onqCMTKJM+LD+SZrLEMGABIIHqMlZ7nyuUgXZJc/f0YP8AAEbtTugJkR1u8PzxMsDBlBclV4dIk/yeoQR3i4xzAM5AV6lgHlu87fQwMUQMVpmcpqk1Xu+IkzRw0NC9+jm7hy94yQPB67E29bk0iU+Sais1U/xNoP0HLVcpY512eIPJhZVd46pAi/W4V+SLFHZGRZaDBnVt5kEdDqxhhnuvwdUZUbS7cASNLx2/DV/W+GyxUYqLn4tAgyko97tSdgrHju9/2EHtt9I49rAVURDAV9Gx+CanoFmLFiKXO72nidcna0bjUP7/ah1GKVpZh73jd2tUbUKoVYeF941lh4yECneoMF73gQcirQvg==
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
kmalloc_nolock() context through the SLAB_ALLOC_NOLOCK flag, split out
most of the special _kmalloc_nolock_noprof() implementation to
__kmalloc_nolock_noprof() that takes a slab_alloc_context, and make
_kmalloc_nolock_noprof() a simple tail calling wrapper with the proper
context.

kmalloc_flags() can thus determine whether to call
__kmalloc_nolock_noprof() or __do_kmalloc_node(), based on the
given alloc_flags.

Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-14-7190909db118@kernel.org
Reviewed-by: Hao Li <hao.li@linux.dev>
Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 13 +++++++++++++
 mm/slub.c | 55 +++++++++++++++++++++++++++++++++++++++++++------------
 2 files changed, 56 insertions(+), 12 deletions(-)

diff --git a/mm/slab.h b/mm/slab.h
index d86203131f58..482b8e0fe797 100644
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
 	return !(alloc_flags & SLAB_ALLOC_NOLOCK);
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
index 8769083bec81..383d39a22561 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -5385,19 +5385,14 @@ void *__kmalloc_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t flags)
 }
 EXPORT_SYMBOL(__kmalloc_noprof);
 
-void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, int node)
+static void *__kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags,
+				     int node, const struct slab_alloc_context *ac)
 {
-	size_t orig_size = size;
-	unsigned int alloc_flags = SLAB_ALLOC_NOLOCK;
 	struct kmem_cache *s;
 	bool can_retry = true;
 	void *ret;
-	const struct slab_alloc_context ac = {
-		.caller_addr = _RET_IP_,
-		.orig_size = orig_size,
-		.alloc_flags = alloc_flags,
-	};
 
+	VM_WARN_ON_ONCE(alloc_flags_allow_spinning(ac->alloc_flags));
 	VM_WARN_ON_ONCE(gfp_flags & ~(__GFP_ACCOUNT | __GFP_ZERO |
 			__GFP_NO_OBJ_EXT | __GFP_NOWARN | __GFP_NOMEMALLOC));
 
@@ -5434,7 +5429,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 		 */
 		return NULL;
 
-	ret = alloc_from_pcs(s, gfp_flags, alloc_flags, node);
+	ret = alloc_from_pcs(s, gfp_flags, ac->alloc_flags, node);
 	if (ret)
 		goto success;
 
@@ -5444,7 +5439,7 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 	 * kfence_alloc. Hence call __slab_alloc_node() (at most twice)
 	 * and slab_post_alloc_hook() directly.
 	 */
-	ret = __slab_alloc_node(s, gfp_flags, node, &ac);
+	ret = __slab_alloc_node(s, gfp_flags, node, ac);
 
 	/*
 	 * It's possible we failed due to trylock as we preempted someone with
@@ -5467,11 +5462,23 @@ void *_kmalloc_nolock_noprof(DECL_TOKEN_PARAMS(size, token), gfp_t gfp_flags, in
 
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
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = SLAB_ALLOC_NOLOCK,
+	};
+
+	return __kmalloc_nolock_noprof(PASS_TOKEN_PARAMS(size, token),
+				       gfp_flags, node, &ac);
+}
 EXPORT_SYMBOL_GPL(_kmalloc_nolock_noprof);
 
 void *__kmalloc_node_track_caller_noprof(DECL_KMALLOC_PARAMS(size, b, token), gfp_t flags,
@@ -5525,6 +5532,30 @@ void *__kmalloc_cache_node_noprof(struct kmem_cache *s, gfp_t gfpflags,
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
+	const struct slab_alloc_context ac = {
+		.caller_addr = _RET_IP_,
+		.orig_size = size,
+		.alloc_flags = alloc_flags,
+	};
+
+	if (alloc_flags_allow_spinning(alloc_flags)) {
+		return __do_kmalloc_node(NULL, flags, node,
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


