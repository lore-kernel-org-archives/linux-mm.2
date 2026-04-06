Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94A3BF46C69
	for <linux-mm@archiver.kernel.org>; Mon,  6 Apr 2026 17:45:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C9E6C6B009D; Mon,  6 Apr 2026 13:44:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4FE26B0121; Mon,  6 Apr 2026 13:44:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B659F6B0122; Mon,  6 Apr 2026 13:44:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A55DE6B009D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 13:44:59 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 53939B9B6E
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:44:59 +0000 (UTC)
X-FDA: 84628856718.09.3A43216
Received: from out-174.mta0.migadu.com (out-174.mta0.migadu.com [91.218.175.174])
	by imf30.hostedemail.com (Postfix) with ESMTP id A09968000D
	for <linux-mm@kvack.org>; Mon,  6 Apr 2026 17:44:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="u3/ukihQ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775497497; a=rsa-sha256;
	cv=none;
	b=Kn/V7d8QLjhPhpUdDcrI+82MJLEYZDwgbPMbeNxbEkrSF+MUszPxZw/X8+XbLLZEVWv13l
	XfjlsQQHxkk5yL+ppxbWxJf8hJCQr8O2MwdMr6V5V72JerEFpMqxFg77d7hvOAUDGQq9bt
	kGCnroC/wtyo4KACVGqyTGOo+Zt1ZCk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="u3/ukihQ";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.174 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775497497;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=022vD/1uMVP73wcKiwL93mQm1sGe9ppeD6WWcWTLEBU=;
	b=IvbCSTkIeZviXUVt6Zwi2gjhAIl5Gl3o0zqa3h0ijpyrxb56wA0ThEhLzRLPFL3bi+A0eZ
	fojaVtBX50+lQnda6gpnfgZcA+G8FFhEsbxmHKJXuV1Fw+g0lhDfp8t0lqxEWtX25dKqp0
	lxv5TPhXzYmOStLwGNXFWrBX3ECbIGA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775497495;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=022vD/1uMVP73wcKiwL93mQm1sGe9ppeD6WWcWTLEBU=;
	b=u3/ukihQytY3s/lfRiVofAIUO66FPh6QhpjC5wetAAzqTa0hvrwLtUGywW35g4J17IFZti
	tWJvIrzTLsDkllALlGlwWuDZmBkYIJGMUqH16qLy2e70+/n2fKemaeSU/khIvwLKtr63lf
	V20wf0vNBn/QAn4ACk/OAS7FTmnQnB8=
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
Subject: [PATCH v3] mm/vmpressure: skip socket pressure for costly order reclaim
Date: Mon,  6 Apr 2026 10:44:25 -0700
Message-ID: <20260406174425.61692-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: nnx9t5o8pd6ur1azh9pq1yxhrj9utddi
X-Rspamd-Queue-Id: A09968000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1775497497-83833
X-HE-Meta: U2FsdGVkX1+sS1CcImLyUhP9bEx23LL1y7IiTocmq5xxUeviRvrduG6ji3GBNnNwkEEMQjviUJnC9XoFAN+/tKt6nXuK5/FxoYt1DzklVAihu8KxTyy55cldDqlkWZWfwJOuf2YA8XFTfVXdT93V64hYh09wFEzLYKqBNH77ByUfsv7vAPuoOjlpelwAxSaEgiVKFWWtpux/ECGyBPtljW6zyE1825sxJReSqx2zDfbglhd4aNl5KontW+yX7LDruXxtMZNPP7ziJIU0f/FxpCzc15QslfcfGgcInzRY8t8wgL20q0kyNMLln0pJGYOW4iA8pjsRBl1ozS9I2kKVsLIGPFI9ERG8AnREgQjRk8dxZkOrGT8Buy29f3HAgGbQurrxK0ouq7YrQyz3DwJvY+bNOasd5LfEc649BIPiWwmturcYLgWJ5HMDfmsu7EEKXxyFqvkd9BW8vZ6ggHCa0RqDAOXtiLg+8FYchVTc7IY3jDrkQ2z6oXLZYW3e+jR7zxXKb5z8c1nCSFzfbN7zhIrkLWOfA4QIL1bGizZ7vC9vlaf9dcc+v3zYfvRbl/OFi9HYXoeZcniENYOIXMYeax1y2mg06Vy6GfHBbdUPSrUEoUk/Iy/DkQcqzY2ruxnK/l9usmLph0CVbUacDJpb95mCSYffmkHUgEkktY1GQE/dfQuyXcl2yDpsl5Sc0saKrLy94NZZIFa3/uiTyrnlGbazpIYXqjLIy1ZZA8vxwPQmNZrhR1IPVOQqLyUksHcrzH3D2I1Xgy2LGKI+sjRlOCIIOnsCfttrZRPniJzk3nownpRISu3ef/kZVpzZcgR9hxOsJEam9NiLVdcgjKn8/+3+zS4QGYE+8rED/54Gk0WfTyAVHQi5RXYhldrsjiX4lIOjoO0eXh1qbDna5aFFA0zwZqigrOszJ4bUvVP3/0Zc1d9UAonNLtjF096h3MEuh3291m076V16JGhCu+Q
 YuzUrnFI
 YScBH/B71r4Qc2QTDgMMtXGY7ZpaA8v429SIPfbbWkkALKtJfFbcy1As2Pok1BNfipRWC/aSbFU/qPKovNWghymVl2QK67FROlyE7fsi1Vr45bi5Yyn9d3Gjamn0ZZTWR0J1CHhThNPne4E6w2g9Koqt1+b6vxq9iGlLNci+qCV+4dA/Es0QNriX3NnIKZ04QYKfi/nQML+feSAO2jL8H1KI7nnWPEIZSN7WgIvstrdnsfCs9vu6d9oEOT4olZ2lMd8yfAr6hfHFk/AWUQuYz5zGLRRVnvuOfmG3Kw/5qjJ3KtPgWL05/9SMn7lCA9s5opUgZs0Ep5O5C0b61JGuDA6/Ywg==
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

Signed-off-by: JP Kobryn (Meta) <jp.kobryn@linux.dev>
Reviewed-by: Rik van Riel <riel@surriel.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
Acked-by: Jakub Kicinski <kuba@kernel.org>
---
v3
 - update changelog to justify patch beyond just networking
 - update changelog to expand scope of vmpressure beyond kswapd

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


