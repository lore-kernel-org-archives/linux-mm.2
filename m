Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 724A510FCADC
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 20:38:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0FEC6B0088; Wed,  1 Apr 2026 16:38:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E79B6B0089; Wed,  1 Apr 2026 16:38:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FDA36B008A; Wed,  1 Apr 2026 16:38:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 836AF6B0088
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 16:38:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3E4D5574ED
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:38:31 +0000 (UTC)
X-FDA: 84611150022.15.1149231
Received: from out-178.mta1.migadu.com (out-178.mta1.migadu.com [95.215.58.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5AB1DC0008
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 20:38:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cAAFQFzx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775075909; a=rsa-sha256;
	cv=none;
	b=F8NJCoV5ioN8qSRcKEnxqlhyxY7zUToycA/1NDlo6hDoinhuiXxGfTZiSVKkzn5WI13xF7
	2+7/0uvyVAQbefY3VzXqalgYDsdhRklUAnmetxhEhDTgnndbohg78v6qi77NwYgNaaiotU
	awsIO+OhFsxNd39EFsqFTk7gUbMjLtE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cAAFQFzx;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf28.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.178 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775075909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=5EzvtS8bTNNJ2G1Yp5aPVQRJHdcyGEAyJce4qgNaWy8=;
	b=PDZcoBwiLWpbb9SkWlRifbZ47R6ngUMriMI/EJlr7ZMDvDP4rYSYIfXBHYsJAxr4CnXTdP
	AsVt56ddOvKhV5TaY+jZILi+BY39TJUmwGda85e4XFS9hZ8ZMTTo7+Ba89CxvJNCj48Mbe
	x8DAhy5VDOkzIJfXuOu0wHm/TZhpGdo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775075907;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=5EzvtS8bTNNJ2G1Yp5aPVQRJHdcyGEAyJce4qgNaWy8=;
	b=cAAFQFzxRkw07FH0D1Kc3EzBJ9vN5rpdRa5iTVdLKwopoe86pKekcn8l3nwGuro6gq6RLS
	8aIkjbXtPQ1uY1UxU+KdbGM8DLHi2aiQhTZMJEt3+SzC3FYDZuXl03OpknLH2xmvqpurET
	tLoxW4fSay7Oa5odiPiOmlKE1NS8Vcg=
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: linux-mm@kvack.org,
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
	hannes@cmpxchg.org,
	riel@surriel.com,
	kuba@kernel.org,
	edumazet@google.com
Cc: netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH] mm/vmpressure: skip socket pressure for costly order reclaim
Date: Wed,  1 Apr 2026 13:37:52 -0700
Message-ID: <20260401203752.643259-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 5AB1DC0008
X-Stat-Signature: e7zu6a4cbepi85q86m8sfuneo1aagmxo
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775075909-991362
X-HE-Meta: U2FsdGVkX1/Ci0ffCKcJUBRZIWSvDPXu0lsUYugazyUPY+9dgIM+thXUI6/Ssrqot6Vj3rKGUh7rfmttUBDAawjLu5CBqKI56/fVcNPMMHI+UqseQRfUyCBxWCfU4Gmg3M9nHc3Fwrguevdy1mCLbCfyGYSIp7VCVNEJ0JP90wtZOc0EgHd75RbrPlJq51Jvzn0EZ5R1Nkdtm3X+KTscogR7x3X6buPpwyN3guQiYOgzIt9Z1aSw7zjMZZNFWNN701citD13/kzFtJU/E/X1xhOJ0/c0iPG3c+fiVfpAJSmCsX3DYl7VfQKm9xoTYes5F3f8TVdpnndNrTFXb0N3sO0RBzfkGymyXblN7ZWUsi/dvO4UGK8P3CL+CjFFUYwfXeaaNk8MMmgrVRcQg5fWARLnXzqzNK5iM7ZqTVd/7CuIwpHbvyMB9riqYocyTi63m1UGP+53v8cJlHKkRHWzIxhMweBDwcKDUZlxVDVWJAPhs64XLEcTmSjNTZonyg5RMClkSalW6aL1TPOYpNeJm+iAAtaPvyX6shFRtqZnHyN2pWDvP3LL+e3t4lysFACde79e644jf8QkYaDKQwjaP0iSzoS0W0Zecbqw1qqfa0dqbFK6Q5LRaDYJfjDr+jH0RTjr9UuUZSpgne8jI1br1qmYk5zGr8ah071YJlNoiDlq1FUZ3J9AT3vy3XPrgtgU+sEVDZJcizPIb42B7Jn2EeapBMdF0u9/gf0FSX+bBOKq7BrHx4PhKDM1mYqmQUGKoaznJCoYm9Zf0ZYYglI1qzbFqOyL3WtvBnG2Vkx6NR/49qwfVgUrMCfkAPDbdU9b0H7EylGoonUuI+z0R78DnLW4jwO1LaPX1mTr08tf6zqzu/0iGWBltCnpyiAaWOyirFHS6y7IxI+/R/LAeMzIbQOCqTWHNXnHblv8tikDIc0zgeR4pYYTD4rjBeTDyLC06eo3r4O0IQsROQHypZh
 4btkPd4u
 IQKyFtUmHoJ87m43RuUbBQvnroQSMrOAqs0pHLNv2WvymUSexgfhuVD8MBjV8Vzed59+WadYZvodJFl3FkiiBZbkivDJLHEj4tBe4T+ohzh1NgRu7Go2FbpBW4UAHdSJI0jJZO1AJXMqqgiyTbZwvzmUoUoA5KcLR2ckkWj90Xa8oaL6qXMzEekTCIyX34er4G7RH
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
 include/linux/vmpressure.h | 9 +++++----
 mm/vmpressure.c            | 7 ++++---
 mm/vmscan.c                | 8 ++++----
 3 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/include/linux/vmpressure.h b/include/linux/vmpressure.h
index 6a2f51ebbfd35..56544e8df2937 100644
--- a/include/linux/vmpressure.h
+++ b/include/linux/vmpressure.h
@@ -30,8 +30,8 @@ struct vmpressure {
 struct mem_cgroup;
 
 #ifdef CONFIG_MEMCG
-extern void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
-		       unsigned long scanned, unsigned long reclaimed);
+extern void vmpressure(gfp_t gfp, int order, struct mem_cgroup *memcg,
+		       bool tree, unsigned long scanned, unsigned long reclaimed);
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
index 3fbb86996c4d2..7f86b9ec83b05 100644
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
@@ -307,7 +308,7 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, bool tree,
 
 		level = vmpressure_calc_level(scanned, reclaimed);
 
-		if (level > VMPRESSURE_LOW) {
+		if (level > VMPRESSURE_LOW && order <= PAGE_ALLOC_COSTLY_ORDER) {
 			/*
 			 * Let the socket buffer allocator know that
 			 * we are having trouble reclaiming LRU pages.
@@ -348,7 +349,7 @@ void vmpressure_prio(gfp_t gfp, struct mem_cgroup *memcg, int prio)
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


