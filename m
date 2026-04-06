Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0802DF46C79
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 19:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E02C6B0005; Mon,  6 Apr 2026 15:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5910F6B0088; Mon,  6 Apr 2026 15:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4A7356B0089; Mon,  6 Apr 2026 15:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 381866B0005
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 15:50:33 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A38E1591AC
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:50:32 +0000 (UTC)
X-FDA: 84629173104.22.BCA417E
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf24.hostedemail.com (Postfix) with ESMTP id B500F18000E
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 19:50:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G8mputUh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775505031;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=wMDWBaqqGgQCGE92Rrt36vAM/h6N+zhFrP9Xojab0ng=;
	b=JCIc90A+YFZVmYc69fpKrbR2oTAQZH5LRLrbIMaB0eEgkDGstPdXX9HNZ3QOFi22ksIKT6
	rbjXXBrQTns7SeMpnK+vg3XJxyRLxcXtFcOloIoAvE7TAZhmQI/LSEaf0Hpivcs3FPPYBQ
	RunSqEUu6TmFvMVJWSYFcgz2Fftbafs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775505031; a=rsa-sha256;
	cv=none;
	b=5dRA4cPEnLpdjNUdrmVN7skt5cXBPnlSH9Q227IfbcLjYIOX3YQFw+hyDBDbR1imEWJrs7
	D/eKWUoFHwkG+F0T15gHC80LkamQg3l7Hkj1dowWzw7txZwGVdieDa5zMhm6OOflBi5xkx
	zTcPFveE7g+0g432HXap6aZUrCRHZYI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=G8mputUh;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf24.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775505028;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=wMDWBaqqGgQCGE92Rrt36vAM/h6N+zhFrP9Xojab0ng=;
	b=G8mputUhX/4ysML4eTqXDXWE2xQtxaez6DRCvP3EvQWF0kYmsCPjkFldTGEaL7J9r65O9d
	Cxh6tzeHQ3PtUrlb10N73Kw0S1p2m8lyB8OdMyYYrB1RN9Rx8O4mwx+knKJhuYLPh7Wsgs
	ZhR0+YPYoooIYZKgaJhzrNKOMFCwjcI=
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
Subject: [PATCH v4] mm/vmpressure: skip socket pressure for costly order reclaim
Date: Mon,  6 Apr 2026 12:50:14 -0700
Message-ID: <20260406195014.112521-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: B500F18000E
X-Stat-Signature: iogpwka98cc1i48zg139y1aaamc4yj1u
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775505030-843069
X-HE-Meta: U2FsdGVkX1/CtOkwRNvzgTe6Q8j6Z4cvZngO8ZCRmEg+r6PtXVpu+axYBM0FNOEYP8E5zdCwNPcOTXEoJO77V8mKPkOOzai8Pbxxw9zZ77DfelHgCrm2Ip09dqMiJmW+tRLPWMyj4UGd2MRS3k3X/e5FR7k2ad12A1AkNRyqKxfDa/3GNLxTB1S+YSsLy/wwogMtpgbRxfn8Z7FjRqZuhH23xDy7uCrMEz6/XEscWqEJETWinerV1KeUOE0eJ98441sxCLmBMNdeuswS+nvjoXC6dQeHhLu4esngusaADQdFe827W1O+JBX1iUmwYAcOqsewqtQI8aRHGssDeMIVp9MaJ0JH2lWUNh0vFR9IOjIKE7qY8D67kIz2I0WAoKv0h3mesMxH2hc3uN/jrn3xFnS7U0zTQoZyE819CVp/540OUz74wkYkc5xIwSX4eqbhV6cHIzqNrSgBuM4O6H157R3EfJcdx2pTsx2aQomITZxeC3WMWEoDRXcElm8VOMTY+Z2G4C5LE++7i68g+wZWEwh+nIyJHPbmG3nIo1lVTuuR1/XAXI4Okx8hywQrsD3PLjiLXEwIUzJHEuvQd41mIEykRxcAGm6pxjIdNCTK1szUvrBqU2HUA3ohzEJsGm+fG6mTSZ/XVVSEIqd08/G9a6+xB4hZsZinpSa9XAeBHo4VQkxcXDlnqWXusAJmJDLK4msZWLJkP8s/hUECT44y/Ct68aJ0d+yy+5vLJ7iWKfBug9keynKRlILHcRUHnRIiubT6b0Ac5RLFiFRewLwZv+q7jrIvL5TOI5ToMSRcafCLE73whgb1tC4YUQUmvtaiAaoKhIfETlvyvV8tnjVYdDkw+AwIVB/mezqQSaVqY65gr718KwQ8CIOGmTfzBmMbjHTwLNrUlHzWoiNa2swrM72JWUXyMbPoEEIwMaGcwcyvjId1vux3rLf5dvlvI7GI7yC7YvMtZhOuyT+phVw
 AeAi+O04
 lYM8bYrFD+lc3JbZJ6gVzd2K6FctAb2+d3+vwy08JZ6vT/oTGmIV/Vk+I/k08GuxLcNVJ3aUhvkd0J3t2MirTudN9HK0E4ITlc8wQe5BV9CfZN0Z2tsScpvOjgdRA/caRqAcCn20YQKnghT9jVSW+3Ez7AmaGG4FFei0WLAFbR1xbwpX7tdqXu4FWlce/Jq5Ev9q1tN7FhoEYIE3vsPDvREH/7bUB5kY+mGyCnNsUL5V/ZQkGfkCWUp+KLqo1UeermCcd2lSG/CKDDicu1Nycg0P+3s6pfyeiv5scYqp+RIH9lnTSrkJZx4PVra+/8deQGkLGOzW7GUbmlHzE/mXU5wuEnw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When reclaim is triggered by high order allocations on a fragmented system,
vmpressure() can report poor reclaim efficiency even though the system has
plenty of free memory. This is because many pages are scanned, but few are
found to actually reclaim - the pages are actively in use and don't need to
be freed. The resulting scan:reclaim ratio causes vmpressure() to assert
socket pressure, throttling TCP throughput unnecessarily.

Costly order allocations (above PAGE_ALLOC_COSTLY_ORDER) rely heavily on
compaction to succeed, so poor reclaim efficiency at these orders does not
necessarily indicate memory pressure. The kernel already treats this order
as the boundary where reclaim is no longer expected to succeed and
compaction may take over.

Make vmpressure() order-aware through an additional parameter sourced from
scan_control at existing call sites. Socket pressure is now only asserted
when order <= PAGE_ALLOC_COSTLY_ORDER.

Memcg reclaim is unaffected since try_to_free_mem_cgroup_pages() always
uses order 0, which passes the filter unconditionally. Similarly,
vmpressure_prio() now passes order 0 internally when calling vmpressure(),
ensuring critical pressure from low reclaim priority is not suppressed by
the order filter.

The patch was motivated by a case of impacted net throughput in production.
On one affected host, the memory state at the time showed ~15GB available,
zero cgroup pressure, and the following buddyinfo state:

Order FreePages
0:    133,970
1:    29,230
2:    17,351
3:    18,984
7+:   0

Using bpf, it was found that 94% of vmpressure calls on this host were from
order-7 kswapd reclaim.

TCP minimum recv window is rcv_ssthresh:19712.

Before patch:
723 out of 3,843 (19%) TCP connections stuck at minimum recv window

After live-patching and ~30min elapsed:
0 out of 3,470 TCP connections stuck at minimum recv window

Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
Reviewed-by: Rik van Riel <riel@surriel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
v4
 - update changelog to include prod data

v3: https://lore.kernel.org/linux-mm/20260406174425.61692-1-jp.kobryn@linux.dev/
 - update changelog to justify patch beyond just networking
 - update changelog to expand scope of vmpressure beyond kswapd

v2: https://lore.kernel.org/linux-mm/20260402232511.17246-1-jp.kobryn@linux.dev/
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


