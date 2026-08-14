Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6327C5CFC1
	for <linux-mm@archiver.kernel.org>; Fri, 14 Aug 2026 07:20:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B116A6B02EF; Fri, 14 Aug 2026 03:20:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA3A26B02F0; Fri, 14 Aug 2026 03:20:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B22E6B02F1; Fri, 14 Aug 2026 03:20:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 674AF6B02EF
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 03:20:02 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6E388035E
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:20:00 +0000 (UTC)
X-FDA: 85099025760.03.54C66CA
Received: from mta0.migadu.com (out-133.mta0.migadu.com [91.218.175.133])
	by imf04.hostedemail.com (Postfix) with ESMTP id 91B9A40004
	for <linux-mm@kvack.org>; Fri, 14 Aug 2026 07:19:58 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cGre6VNr;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.133 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786691999;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Q/ebTZtZlPHyV5ZVFzuqrC1xwMs/FIhVtVpj15zvEaY=;
	b=VyYNihXZ4Wm+61I6uCqAmfYAAbryEy1K3cnc4/lra2fQYI7wMdNHHR7jPRVpEBm1EFkww4
	BGZfTLjC3twuNr/d/bBTQw44ZHnaDBeJWOzOT8+/0sskfFOdbl4HaCKWl3+8KjOLKawAnT
	XdCnah7I6YXGV2Cs9kinoTn4SgjxYr0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cGre6VNr;
	spf=pass (imf04.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.133 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786691999;
	b=DpAb1yjyubuC+KLlxvUTt3eq0KLG9OemPvHo25tc2TOUOsfEMrcDMD0T4zmRYCU+fi/3PJ
	GMY5imiWjmt5vvR3+EmFkpgpGC+7rklxeqKjUC6kJzk0golppBSkX2kdtMFmUU0D/pCyiZ
	1uYeMuS39OVeG8r/6oSsNoHQhNVv5LY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=Yim1rnFlhKn0JrfDkSX23QrIkjgmN+sXncpkYFXeayE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786691997; v=1; x=1787296797;
 b=cGre6VNrH3EKTPuAViJDGJ2RFDgNo2p9aSNsAVysdI/I2Wq7zaGCseGXpOQD3a9JKE133ViD
 IqvdJBAGce/r7WCl2UeGTwsv5/6SDAvAVoEQ9NoXEt9Qkke6FIbqfn0msxRAamI92R5s/qY6wgK
 sayjLLr4KyRJoIDbdj0cTWgU=
X-Envelope-To: linux-mm@kvack.org
Received: from fedora (117.129.78.49)
	by smtp.migadu.com with ESMTPS id 6e94c7a62b05b88a;
	Fri, 14 Aug 2026 07:19:46 +0000
X-Migadu-Flow: FLOW_OUT
From: Hao Li <hao.li@linux.dev>
To: vbabka@kernel.org,
	harry@kernel.org
Cc: akpm@linux-foundation.org,
	cl@gentwo.org,
	rientjes@google.com,
	roman.gushchin@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Hao Li <hao.li@linux.dev>
Subject: [PATCH] mm/slub: unify slub stat definitions to simplify metric additions
Date: Fri, 14 Aug 2026 15:17:02 +0800
Message-ID: <20260814071848.46922-1-hao.li@linux.dev>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 91B9A40004
X-Stat-Signature: 9w3kbdrwmhzid3yw9whrcmud4j4jshhn
X-Rspam-User: 
X-HE-Tag: 1786691998-56064
X-HE-Meta: U2FsdGVkX1+MbBdcYElafB5eait3Jl9I+izSGKh/EDIbROcmGzCOJCNuFqbUh53UyNX0pu/kA7SmbvUQScFb2cQ2C13RXy3Qj36n/cmBVUw2asdk0yXL/v/c+jXgU2FQnOhOpZKVTrN7lTRNkKVzftmlyGoy3njw4Obp2H5Sf8jZVWNPlnHZ6c2PJxxaE+waNA9861/I81dOOti4H45SCnELtGPM0sHAGzYXkF9UugtfTOKbv7H3pXWrhGJgXOYPEzWhlWVH0MByZSg34U5j42m0Bgpy9sBAed/grkl47X2/nZPt/khz8BgmuCY3XwdRvMVNNZiqBcN4RXtcv1FyPpVp+US0Xq7h2A0Q3nPqC0DPHUafXHrMRVP/33buIePDVmr3nnlGZZupCynGu4dWSYbQnL7QKteZryt+ImShlKabhkxMzPg+XUdJ6esDkicMD2Wuav4gFgsme/ws5SnIY8Jmd9xKGRnYLvo+ZYzBXQvPTXrzPZiZkLwSqxTLA8AaH3zPEIHmGoA9o7vZD8Jm9WsBBgbyRixlORHuI6QGhL1QdsaE1iGb1pVEfSx3pAK0TLJnTGMLpqC62jRb13hIRhTlEoTSG7QoI3mdQGIu3dfpyoQChvpGi2KsSfB4KdXT9z6DtMWhnX6R7N+1g9GlHtvj2UswFit5rM3DtBdovwqjw0rs9TN0bo1uzCfkW4pjQ7ehuibNkwvz2u9vRogN85Zc03hVXUjMtMng8cWJ1OJ91L/l1B89yXzxMpbWTv4bt7479NTxciBgtnT6Eq6ipT/JfchvXJcwDU8yV7OmhKvb632IXFN88JqZOXZji7cMYH1vHLHQn+KBtL1l/XWsRZBvIVKNto1TzZWvh/nwzNYPD3YNbKmGXAXKm9Ar+GwxU9dd5/0IiJ3bIF9fgnJ4V+oluOOEZvZeFISjwvkVa4C6tkNvFVI2wojRM9iR/J31HOM+N2ssYs9c4wlE9cb
 LfNy+w8o
 624cz/cIrlvkJVRhnEd1cYZPiaOmXDGBXhNcnRCeeWhA6RbgnWN1oCgmk2Z4YZmg2Ag3OuhPYnI4JwWyrjj/UA2gu/ZhxY6F8IW2HK9v43Nqb/WAKzVL2ZPSbJDrZUKqHPotSHHDaEGNy4j9bb3GLLK5qZqEQnkRvUCqQIKuD16mT7/O1ziRMV1UZa2KC8XqEbyauayjhJ+1j2Qvt3+ZCSHUUSYclaM0Fs9ud
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Currently, adding a new slub stat requires modifying three separate
locations: stat_item, STAT_ATTR, and slab_attrs. This is inconvenient,
especially when temporarily adding metrics for debugging during
development.

This patch borrows the approach from SCHED_FEAT by introducing an ITEM_EXP
X-macro, which is then temporarily defined as different operations at the
three locations (stat_item, STAT_ATTR, and slab_attrs) to perform distinct
macro expansions.

Going forward, adding a new metric only requires adding a single line:
ITEM_EXP(XXX, xxx)

Signed-off-by: Hao Li <hao.li@linux.dev>
---
 mm/slub.c | 144 ++++++++++++++++++++++++------------------------------
 1 file changed, 65 insertions(+), 79 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index b0cd0572e2f2..8dd25032fba4 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -359,33 +359,64 @@ enum add_mode {
 	ADD_TO_TAIL,
 };
 
+#define STAT_ITEMS							\
+	/* Allocation from percpu sheaves */				\
+	ITEM_EXP(ALLOC_FASTPATH, alloc_fastpath)			\
+	/* Allocation from partial or new slab */			\
+	ITEM_EXP(ALLOC_SLOWPATH, alloc_slowpath)			\
+	/* Free to rcu_free sheaf */					\
+	ITEM_EXP(FREE_RCU_SHEAF, free_rcu_sheaf)			\
+	/* Failed to free to a rcu_free sheaf */			\
+	ITEM_EXP(FREE_RCU_SHEAF_FAIL, free_rcu_sheaf_fail)		\
+	/* Free to percpu sheaves */					\
+	ITEM_EXP(FREE_FASTPATH, free_fastpath)				\
+	/* Free to a slab */						\
+	ITEM_EXP(FREE_SLOWPATH, free_slowpath)				\
+	/* Freeing moves slab to partial list */			\
+	ITEM_EXP(FREE_ADD_PARTIAL, free_add_partial)			\
+	/* Freeing removes last object */				\
+	ITEM_EXP(FREE_REMOVE_PARTIAL, free_remove_partial)		\
+	/* New slab acquired from page allocator */			\
+	ITEM_EXP(ALLOC_SLAB, alloc_slab)				\
+	/* Requested node different from cpu sheaf */			\
+	ITEM_EXP(ALLOC_NODE_MISMATCH, alloc_node_mismatch)		\
+	/* Slab freed to the page allocator */				\
+	ITEM_EXP(FREE_SLAB, free_slab)					\
+	/* Number of times fallback was necessary */			\
+	ITEM_EXP(ORDER_FALLBACK, order_fallback)			\
+	/* Failures of slab freelist update */				\
+	ITEM_EXP(CMPXCHG_DOUBLE_FAIL, cmpxchg_double_fail)		\
+	/* Objects flushed from a sheaf */				\
+	ITEM_EXP(SHEAF_FLUSH, sheaf_flush)				\
+	/* Objects refilled to a sheaf */				\
+	ITEM_EXP(SHEAF_REFILL, sheaf_refill)				\
+	/* Allocation of an empty sheaf including oversized ones */	\
+	ITEM_EXP(SHEAF_ALLOC, sheaf_alloc)				\
+	/* Freeing of an empty sheaf including oversized ones */	\
+	ITEM_EXP(SHEAF_FREE, sheaf_free)				\
+	/* Got full sheaf from barn */					\
+	ITEM_EXP(BARN_GET, barn_get)					\
+	/* Failed to get full sheaf from barn */			\
+	ITEM_EXP(BARN_GET_FAIL, barn_get_fail)				\
+	/* Put full sheaf to barn */					\
+	ITEM_EXP(BARN_PUT, barn_put)					\
+	/* Failed to put full sheaf to barn */				\
+	ITEM_EXP(BARN_PUT_FAIL, barn_put_fail)				\
+	/* Sheaf prefill grabbed the spare sheaf */			\
+	ITEM_EXP(SHEAF_PREFILL_FAST, sheaf_prefill_fast)		\
+	/* Sheaf prefill found no spare sheaf */			\
+	ITEM_EXP(SHEAF_PREFILL_SLOW, sheaf_prefill_slow)		\
+	/* Allocation of oversize sheaf for prefill */			\
+	ITEM_EXP(SHEAF_PREFILL_OVERSIZE, sheaf_prefill_oversize)	\
+	/* Sheaf return reattached spare sheaf */			\
+	ITEM_EXP(SHEAF_RETURN_FAST, sheaf_return_fast)			\
+	/* Sheaf return could not reattach spare */			\
+	ITEM_EXP(SHEAF_RETURN_SLOW, sheaf_return_slow)
+
 enum stat_item {
-	ALLOC_FASTPATH,		/* Allocation from percpu sheaves */
-	ALLOC_SLOWPATH,		/* Allocation from partial or new slab */
-	FREE_RCU_SHEAF,		/* Free to rcu_free sheaf */
-	FREE_RCU_SHEAF_FAIL,	/* Failed to free to a rcu_free sheaf */
-	FREE_FASTPATH,		/* Free to percpu sheaves */
-	FREE_SLOWPATH,		/* Free to a slab */
-	FREE_ADD_PARTIAL,	/* Freeing moves slab to partial list */
-	FREE_REMOVE_PARTIAL,	/* Freeing removes last object */
-	ALLOC_SLAB,		/* New slab acquired from page allocator */
-	ALLOC_NODE_MISMATCH,	/* Requested node different from cpu sheaf */
-	FREE_SLAB,		/* Slab freed to the page allocator */
-	ORDER_FALLBACK,		/* Number of times fallback was necessary */
-	CMPXCHG_DOUBLE_FAIL,	/* Failures of slab freelist update */
-	SHEAF_FLUSH,		/* Objects flushed from a sheaf */
-	SHEAF_REFILL,		/* Objects refilled to a sheaf */
-	SHEAF_ALLOC,		/* Allocation of an empty sheaf including oversized ones */
-	SHEAF_FREE,		/* Freeing of an empty sheaf including oversized ones */
-	BARN_GET,		/* Got full sheaf from barn */
-	BARN_GET_FAIL,		/* Failed to get full sheaf from barn */
-	BARN_PUT,		/* Put full sheaf to barn */
-	BARN_PUT_FAIL,		/* Failed to put full sheaf to barn */
-	SHEAF_PREFILL_FAST,	/* Sheaf prefill grabbed the spare sheaf */
-	SHEAF_PREFILL_SLOW,	/* Sheaf prefill found no spare sheaf */
-	SHEAF_PREFILL_OVERSIZE,	/* Allocation of oversize sheaf for prefill */
-	SHEAF_RETURN_FAST,	/* Sheaf return reattached spare sheaf */
-	SHEAF_RETURN_SLOW,	/* Sheaf return could not reattach spare */
+#define ITEM_EXP(name, unused) name,
+	STAT_ITEMS
+#undef ITEM_EXP
 	NR_SLUB_STAT_ITEMS
 };
 
@@ -9512,34 +9543,12 @@ static ssize_t text##_store(struct kmem_cache *s,		\
 	clear_stat(s, si);					\
 	return length;						\
 }								\
-SLAB_ATTR(text);						\
+SLAB_ATTR(text);
+
+#define ITEM_EXP(name, text) STAT_ATTR(name, text)
+STAT_ITEMS
+#undef ITEM_EXP
 
-STAT_ATTR(ALLOC_FASTPATH, alloc_fastpath);
-STAT_ATTR(ALLOC_SLOWPATH, alloc_slowpath);
-STAT_ATTR(FREE_RCU_SHEAF, free_rcu_sheaf);
-STAT_ATTR(FREE_RCU_SHEAF_FAIL, free_rcu_sheaf_fail);
-STAT_ATTR(FREE_FASTPATH, free_fastpath);
-STAT_ATTR(FREE_SLOWPATH, free_slowpath);
-STAT_ATTR(FREE_ADD_PARTIAL, free_add_partial);
-STAT_ATTR(FREE_REMOVE_PARTIAL, free_remove_partial);
-STAT_ATTR(ALLOC_SLAB, alloc_slab);
-STAT_ATTR(ALLOC_NODE_MISMATCH, alloc_node_mismatch);
-STAT_ATTR(FREE_SLAB, free_slab);
-STAT_ATTR(ORDER_FALLBACK, order_fallback);
-STAT_ATTR(CMPXCHG_DOUBLE_FAIL, cmpxchg_double_fail);
-STAT_ATTR(SHEAF_FLUSH, sheaf_flush);
-STAT_ATTR(SHEAF_REFILL, sheaf_refill);
-STAT_ATTR(SHEAF_ALLOC, sheaf_alloc);
-STAT_ATTR(SHEAF_FREE, sheaf_free);
-STAT_ATTR(BARN_GET, barn_get);
-STAT_ATTR(BARN_GET_FAIL, barn_get_fail);
-STAT_ATTR(BARN_PUT, barn_put);
-STAT_ATTR(BARN_PUT_FAIL, barn_put_fail);
-STAT_ATTR(SHEAF_PREFILL_FAST, sheaf_prefill_fast);
-STAT_ATTR(SHEAF_PREFILL_SLOW, sheaf_prefill_slow);
-STAT_ATTR(SHEAF_PREFILL_OVERSIZE, sheaf_prefill_oversize);
-STAT_ATTR(SHEAF_RETURN_FAST, sheaf_return_fast);
-STAT_ATTR(SHEAF_RETURN_SLOW, sheaf_return_slow);
 #endif	/* CONFIG_SLUB_STATS */
 
 #ifdef CONFIG_KFENCE
@@ -9602,32 +9611,9 @@ static const struct attribute *const slab_attrs[] = {
 	&remote_node_defrag_ratio_attr.attr,
 #endif
 #ifdef CONFIG_SLUB_STATS
-	&alloc_fastpath_attr.attr,
-	&alloc_slowpath_attr.attr,
-	&free_rcu_sheaf_attr.attr,
-	&free_rcu_sheaf_fail_attr.attr,
-	&free_fastpath_attr.attr,
-	&free_slowpath_attr.attr,
-	&free_add_partial_attr.attr,
-	&free_remove_partial_attr.attr,
-	&alloc_slab_attr.attr,
-	&alloc_node_mismatch_attr.attr,
-	&free_slab_attr.attr,
-	&order_fallback_attr.attr,
-	&cmpxchg_double_fail_attr.attr,
-	&sheaf_flush_attr.attr,
-	&sheaf_refill_attr.attr,
-	&sheaf_alloc_attr.attr,
-	&sheaf_free_attr.attr,
-	&barn_get_attr.attr,
-	&barn_get_fail_attr.attr,
-	&barn_put_attr.attr,
-	&barn_put_fail_attr.attr,
-	&sheaf_prefill_fast_attr.attr,
-	&sheaf_prefill_slow_attr.attr,
-	&sheaf_prefill_oversize_attr.attr,
-	&sheaf_return_fast_attr.attr,
-	&sheaf_return_slow_attr.attr,
+#define ITEM_EXP(unused, text) &text##_attr.attr,
+	STAT_ITEMS
+#undef ITEM_EXP
 #endif
 #ifdef CONFIG_FAILSLAB
 	&failslab_attr.attr,
-- 
2.54.0


