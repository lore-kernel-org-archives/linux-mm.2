Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A49D0D6AB10
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 23:26:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D860A6B0088; Thu,  2 Apr 2026 19:26:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37986B0089; Thu,  2 Apr 2026 19:26:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C4CA16B008A; Thu,  2 Apr 2026 19:26:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B31916B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 19:26:13 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 496B01A016F
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:26:13 +0000 (UTC)
X-FDA: 84615201426.15.0DD6356
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id 67FD340013
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 23:26:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vv/7uy3k";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775172371; a=rsa-sha256;
	cv=none;
	b=XvXkjv6f6vDMMWPPdA7Nxa3wHCFs5433xXEuf9b9cTWrkTJyEi7iNr+48E2EHcTAuttp0n
	XzeOY8Koc2983EVu7fEXajKJWZ/bTGFLBglRVoXhWz4su/J9RPxYCWwOpUvcMjvx+ecQb7
	zPiymFDTLUeIwYk5kWRsUDp01X2lU08=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="vv/7uy3k";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775172371;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=PuVAdsykZc8clK+Md88hs1j0p3benQlW+1IQ1dRgBhc=;
	b=gnGCZBqwpW7BxRnu5W2hBahUrosXOXYMvbEEDQgxVghqGkHMD+kJgJRGIsWz505V5eWGjx
	TxvuPhhc0fLQeWt+s1Uzt/j+/V9lNg4bRVAEO5HZfB8ovwnU0TMYRpCcRHw5goQgqnY7Sd
	Ax3rMvygj4tr1ixqXQkD5fWnv55G2cA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775172365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=PuVAdsykZc8clK+Md88hs1j0p3benQlW+1IQ1dRgBhc=;
	b=vv/7uy3kyRdedWT090Pplu5hGSsiStzXs+T/L5f/qJSRCuzglxLBqIglaTUAqe+G5jJHKY
	ZkMbd7GfykSqPsKz3oY76u8K9kEuvusEecPmL1JnsP+M1yo2SWTZT6ag7tn8v6KR11pJP0
	Z9BoQFvSjsd8o5BFjg/OnfydsI2hsLE=
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: linux-mm@kvack.org,
	willy@infradead.org,
	hannes@cmpxchg.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	Liam.Howlett@oracle.com,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	riel@surriel.com,
	kuba@kernel.org,
	edumazet@google.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v2] mm/vmpressure: skip socket pressure for costly order reclaim
Date: Thu,  2 Apr 2026 16:25:11 -0700
Message-ID: <20260402232511.17246-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: xwj4bedhe3ys45j5bt38g9idkjc6u57k
X-Rspamd-Queue-Id: 67FD340013
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775172371-495224
X-HE-Meta: U2FsdGVkX1+ueevlhZA4ZSZlX1u06sDYZDJ8oArnbDiLKSj80l2hMtkG5StSBhkDxnmTxKcYKjtgFI73vlmdj+EeW31SMIykd3udFffxsKMOF9aEqyp+FQnm1dQlDmMXBSEh7lXePfDYjx//fDArPHbD/Ow3u9oEv4xpPTmJj3AQiQ1mtSrUbXXyYwqbIhOHyfwLUjF9Glzn0pEiyxE3ys9pJlsLrpGyDRwSKe8qKqvEwR+dW3Xp6966HePiij9bUAM2l7HPgEgSbDdVmt9Mnz3C0+QAh5A866UNumjlW7Qeb5zd6mwXfkC8YyDQYiR2hMzdO7cveOP0vQn/2fJJnBdUuiQzphKUawO9WQ4+qe+qZY8KeNS1M2YQXoANpsBIP/Pt4cDeZOxeiDgNLz9IXAocm+v89lAcNEru6gcjb5HfJayS6GZAtCcbMviLIxG3gsh1LDIpssbZpJ0kRXzKlwjTXIR23tkt1dfscoL1DYyeKl5zI2p6PtbGvYMXdI6N1vT0IgCv0FD/9ock7OGx90L+Kc76+77hbwgTPKCWBk2wA5xLp6vZNiqAA7sUurVhemEpjlrKdXIpdfOkK2yktgbmWLyk5kE8vjCV3RbaPWGre246HYnQjmI9u2yal+PAaElqClZqsI47YhjzgUZXjbEiywTLHlD5woPtN30g6bxhfoMXyVto3nkFlFmaMWZXxp0P3pql5KaLle5Y8Zx1aLtBqml8izSIKLZ+XvkhYmJ4MvLGvxNVVS8zJ9NHnl/2g8crKyAnoJfrafz8EG1OAj1g2LEETECHJJnKxzNo4QOAe5j6yT7LhFk3kF72HzS9yJRH+0OanSPB46cSbf74bvzaV//Y305S8mtgQifp3BqCKydLe5sDJY/7yUbtr4skVgpLZuyQ5I9eYv4bb7vApANOfwtJkSG3X9RnAKB/B4ast6jJPGIs/3klPJK4Hg0EhRkv5uXRBPRW98MIE8C
 mNXUyPt5
 NWzeFchBIiTpULnDyFN2/ci2dDH1LNG5QoHqfgxpcZAS4VweeGuP/xdQ6Ze4/w9ZPc6Jm9kA2gnZuEOP3ZYsfhtqdQYBvGrqyCnM4VgWQHMXzg7qTrw1LLWqaZ4MPBS47/mKyBnnm266QvrG9F8zNhUjDQrH3FTn2UZMR85WA/eUMR5a3XUay6KIv857PHVvwBSj62RMcXksQMoxP5HpjfqLdO/sJv498QSf7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When kswapd reclaims at high order due to fragmentation, vmpressure() can
report poor reclaim efficiency even though the system has plenty of free
memory. This is because kswapd scans many pages but finds little to reclaim
- the pages are actively in use and don't need to be freed. The resulting
scan:reclaim ratio triggers socket pressure, throttling TCP throughput
unnecessarily.

Net allocations do not exceed order 3 (PAGE_ALLOC_COSTLY_ORDER), so high
order reclaim difficulty should not trigger socket pressure. The kernel
already treats this order as the boundary where reclaim is no longer
expected to succeed and compaction may take over.

Make vmpressure() order-aware through an additional parameter sourced from
scan_control at existing call sites. Socket pressure is now only asserted
when order <= PAGE_ALLOC_COSTLY_ORDER.

Memcg reclaim is unaffected since try_to_free_mem_cgroup_pages() always
uses order 0, which passes the filter unconditionally. Similarly,
vmpressure_prio() now passes order 0 internally when calling vmpressure(),
ensuring critical pressure from low reclaim priority is not suppressed by
the order filter.

Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
---
v2
 - dropped extern specifier from vmpressure decl
 - added comment to explain rationale of adjusted conditional

v1: https://lore.kernel.org/all/20260401203752.643259-1-jp.kobryn@linux.dev/

 include/linux/vmpressure.h |  9 +++++----
 mm/vmpressure.c            | 15 ++++++++++++---
 mm/vmscan.c                |  8 ++++----
 3 files changed, 21 insertions(+), 11 deletions(-)

diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
index 6a2f51ebbfd35..faecd55224017 100644
--- a/include/linux/vmpressure.h
+++ b/include/linux/vmpressure.h
@@ -30,8 +30,8 @@ struct vmpressure {
 struct mem_cgroup;
 
 #ifdef CONFIG_MEMCG
-extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
-		       unsigned long scanned, unsigned long reclaimed);
+void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
+		unsigned long scanned, unsigned long reclaimed);
 extern void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio);
 
 extern void vmpressure_init(struct vmpressure *vmpr);
@@ -44,8 +44,9 @@ extern int vmpressure_register_event(struct mem_cgroup *memcg,
 extern void vmpressure_unregister_event(struct mem_cgroup *memcg,
 					struct eventfd_ctx *eventfd);
 #else
-static inline void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
-			      unsigned long scanned, unsigned long reclaimed) {}
+static inline void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg,
+			      bool tree, unsigned long scanned,
+			      unsigned long reclaimed) {}
 static inline void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg,
 				   int prio) {}
 #endif /* CONFIG_MEMCG */
diff --git a/mm/vmpressure.c b/mm/vmpressure.c
index 3fbb86996c4d2..f053554e58264 100644
--- a/mm/vmpressure.c
+++ b/mm/vmpressure.c
@@ -218,6 +218,7 @@ static void vmpressure_work_fn(struct work_struct *work)
 /**
  * vmpressure() - Account memory pressure through scanned/reclaimed ratio
  * @gfp:	reclaimer's gfp mask
+ * @order:	allocation order being reclaimed for
  * @memcg:	cgroup memory controller handle
  * @tree:	legacy subtree mode
  * @scanned:	number of pages scanned
@@ -236,7 +237,7 @@ static void vmpressure_work_fn(struct work_struct *work)
  *
  * This function does not return any value.
  */
-void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
+void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg, bool tree,
 		unsigned long scanned, unsigned long reclaimed)
 {
 	struct vmpressure *vmpr;
@@ -307,7 +308,15 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 
 		level = vmpressure_calc_level(scanned, reclaimed);
 
-		if (level > VMPRESSURE_LOW) {
+		/*
+		 * Once we go above COSTLY_ORDER, reclaim relies heavily on
+		 * compaction to make progress. Reclaim efficiency was never a
+		 * great proxy for pressure to begin with, but it's outright
+		 * misleading with these high orders. Don't throttle sockets
+		 * because somebody is attempting something crazy like an order-7
+		 * and predictably struggling.
+		 */
+		if (level > VMPRESSURE_LOW && order <= PAGE_ALLOC_COSTLY_ORDER) {
 			/*
 			 * Let the socket buffer allocator know that
 			 * we are having trouble reclaiming LRU pages.
@@ -348,7 +357,7 @@ void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio)
 	 * to the vmpressure() basically means that we signal 'critical'
 	 * level.
 	 */
-	vmpressure(gfp, memcg, true, vmpressure_win, 0);
+	vmpressure(gfp, 0, memcg, true, vmpressure_win, 0);
 }
 
 #define MAX_VMPRESSURE_ARGS_LEN	(strlen("critical") + strlen("hierarchy") + 2)
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5a8c8fcccbfc9..1342323a0b41f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -5071,8 +5071,8 @@ static int shrink_one(struct lruvec *lruvec, struct scan_control *sc)
 	shrink_slab(sc->gfp_mask, pgdat->node_id, memcg, sc->priority);
 
 	if (!sc->proactive)
-		vmpressure(sc->gfp_mask, memcg, false, sc->nr_scanned - scanned,
-			   sc->nr_reclaimed - reclaimed);
+		vmpressure(sc->gfp_mask, sc->order, memcg, false,
+			   sc->nr_scanned - scanned, sc->nr_reclaimed - reclaimed);
 
 	flush_reclaim_state(sc);
 
@@ -6175,7 +6175,7 @@ static void shrink_node_memcgs(pg_data_t *pgdat, struct scan_control *sc)
 
 		/* Record the group's reclaim efficiency */
 		if (!sc->proactive)
-			vmpressure(sc->gfp_mask, memcg, false,
+			vmpressure(sc->gfp_mask, sc->order, memcg, false,
 				   sc->nr_scanned - scanned,
 				   sc->nr_reclaimed - reclaimed);
 
@@ -6220,7 +6220,7 @@ static void shrink_node(pg_data_t *pgdat, struct scan_control *sc)
 
 	/* Record the subtree's reclaim efficiency */
 	if (!sc->proactive)
-		vmpressure(sc->gfp_mask, sc->target_mem_cgroup, true,
+		vmpressure(sc->gfp_mask, sc->order, sc->target_mem_cgroup, true,
 			   sc->nr_scanned - nr_scanned, nr_node_reclaimed);
 
 	if (nr_node_reclaimed)
-- 
2.52.0


