Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2338BE9A04A
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 03:30:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E364B6B0088; Tue, 17 Feb 2026 22:30:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DE3A86B0089; Tue, 17 Feb 2026 22:30:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB8076B008A; Tue, 17 Feb 2026 22:30:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B22F06B0088
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 22:30:12 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D70AD589BD
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:30:11 +0000 (UTC)
X-FDA: 84456149022.17.71D460A
Received: from out-187.mta1.migadu.com (out-187.mta1.migadu.com [95.215.58.187])
	by imf05.hostedemail.com (Postfix) with ESMTP id 925C310000D
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:30:09 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jrq0gOsK;
	spf=pass (imf05.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771385410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=L5t+e5t3oxdKISWupQuCST4KoCBelUuwuQ5Pkuo3xyo=;
	b=Txixd7CZYbbqzK8e0RsuJeFmQ/84GNXpGY6U+rjkwRBPesmk55CFL1djy8U7lkbiITVFRN
	NSmJ1SMWFZKW0G7srpjtC8nLykijqdZu2/Vvosj5c5L+qZxGYYdx4UIT+kXEDuUoyn4mMS
	80zorLFFSe7r7KlpOVlsDCHDDy+0GS4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jrq0gOsK;
	spf=pass (imf05.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.187 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771385410; a=rsa-sha256;
	cv=none;
	b=bZfvSN+9Ychq9wHGQS52s/j8MnPzeDA7SElJwhlFy5kJQeSUUbU9C88pGOot8lCch56V/I
	3vZgSyO/aGvqdhFYExYuc1MCU1DJ4aMyO+3cWXyjdAnWrxr+1McQ6Qy0u22vUCwo5otKdw
	wgWTB8BI2dkrbyKsFVqphiWsNTRIdNw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771385405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=L5t+e5t3oxdKISWupQuCST4KoCBelUuwuQ5Pkuo3xyo=;
	b=Jrq0gOsKzBS10vHv78f67TIrGtYc/D/fIJukaMnm1jVGTFetp1VDZhY/b5fMdYzqFCCJ/m
	wno7Bf4SkuMbmqRKRuQtTLxJFOKz1cYL6jGGqwLNNtcEdjpTsWOiIlVkk/a8OPOUhL1rw8
	8dIYrFMf2I2yos0dX2/qI0XmXD6Oyyk=
From: "JP Kobryn (Meta)" <jp.kobryn@linux.dev>
To: linux-mm@kvack.org,
	mst@redhat.com,
	mhocko@suse.com,
	vbabka@suse.cz
Cc: apopple@nvidia.com,
	akpm@linux-foundation.org,
	axelrasmussen@google.com,
	byungchul@sk.com,
	cgroups@vger.kernel.org,
	david@kernel.org,
	eperezma@redhat.com,
	gourry@gourry.net,
	jasowang@redhat.com,
	hannes@cmpxchg.org,
	joshua.hahnjy@gmail.com,
	Liam.Howlett@oracle.com,
	linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com,
	matthew.brost@intel.com,
	rppt@kernel.org,
	muchun.song@linux.dev,
	zhengqi.arch@bytedance.com,
	rakie.kim@sk.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	surenb@google.com,
	virtualization@lists.linux.dev,
	weixugc@google.com,
	xuanzhuo@linux.alibaba.com,
	ying.huang@linux.alibaba.com,
	yuanchu@google.com,
	ziy@nvidia.com,
	kernel-team@meta.com
Subject: [PATCH v2] mm: move pgscan and pgsteal to node stats
Date: Tue, 17 Feb 2026 19:29:41 -0800
Message-ID: <20260218032941.225439-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 925C310000D
X-Stat-Signature: y7ysmdasz14sqtxigwbrkpb67hmr185o
X-HE-Tag: 1771385409-3860
X-HE-Meta: U2FsdGVkX18cNyN7JDp9HnomGLPPq5/lpxqH1vUOrrdnZMwLRQh9xiQvtgM3IGkKylneA6GOJI4s+E00sZfjvTOD4IwtA6DgaWnnah345T47Mr19NR/lX7b4gisIRUrJpWVPfTiv/2YgCfYmPE+iR5Ie4CPNQ4eCqXpYKiJT7ytAXGk6WONplGWRRLu6SZr/RlsziHjU6ma9WEWaUZRU7kZjm/K3MOWcXAvifJmtMGFuimICGdV67ToTuB5Cf8xUAw6EkXudc4zOri6jVBy4+kPulnEVN0SPM7Vzhoc+8iLLRUKB56IrVbJVZh0z3ZXpPQURXTaLN9dcnBMLOZBpkCbISF+howwn2HNqRqMcrBeMM+3kNc2clCMQZXOKKGnNFtqGMUmwnLwBPASWYGSCnbVkyAvNNA95h1qCograQ9q+bujuu0He8UrUbkVNsPgqKM8FlQjj3B4AQr83xeaVqAOysiDt6DQ7HYXiM+S4AHNH+aXxVcwPoIKnUycUlFMwpwBYklkiSCFj6+uqI9wYJzEWpT85FbzLYD4e5ng4loi3edgkwYs64MfKQ5WmlSq3XCOMHePKsJB+OEyuErqUe7+ug1IxyjpHEeV15MdLjc1qQy/zwo8VVEV+lfWqktqj2BATxn63ccMbw7/c192KprbcCGMFB68ukqeo1lSm3WQqYhVaschG6PMesCjgHMETtJzOF976UtAoFm8TOdbZB+MM/cqnJm/sUNSXF0pfNsR0kaJxeDHr9ouuUuVxtiKAdq7jRa1YoeRlZGP4y6lfrxP1pG5TtWGSjK4mJqCFq4hFAwiUSVwcgyNs8NeFWguKaSRVZy4nJ1dFdX6YmJUnwZXPSjtR9fJC2QYaywfCY6ukWNYgJz3DutxBZYwxDmbkLGS96snKnZBd8sJPnQqVfUcEcIhgtZilEWzyDFrPnFEQwyhyOl9hXYbkqAwV8IB2HEEPpt0fzM2pyYR0UcJ
 dKpJoozP
 6fW9PMHydIQs91FJv9z2wilh7oE8ejmcyRp9lsj0hTultWEeTDVTT6HwbR368/zGQ/kvtHmQFa0PrUmPf9tNTLouuUyP+TRyijE3hhroRP8sJcs0y0LoZprhOqM3wa4QeLJCELcuSU4G9dR/dfz8JcRA2HDQRY61WGI9QQetQrl92Jgr8R25DKlMo34VlweDnCkW/slMXDn3rxSda/ZgA7+hqQ8kPtATLYQzkah+j9y7ttRGeYezhVQ3Y+UzSlrSLp4EF8aInz/Dkbf40Fjx5/GhX/JilBRNf/0UJg2NMVsKNZ7Neo39tb/Lvw/W39nH+GfP7xJsZmgcJEspd/yX++RRu7o9LFsaunO5BXlPQLzSJlSQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: JP Kobryn <jp.kobryn@linux.dev>

There are situations where reclaim kicks in on a system with free memory.
One possible cause is a NUMA imbalance scenario where one or more nodes are
under pressure. It would help if we could easily identify such nodes.

Move the pgscan and pgsteal counters from vm_event_item to node_stat_item
to provide per-node reclaim visibility. With these counters as node stats,
the values are now displayed in the per-node section of /proc/zoneinfo,
which allows for quick identification of the affected nodes.

/proc/vmstat continues to report the same counters, aggregated across all
nodes. But the ordering of these items within the readout changes as they
move from the vm events section to the node stats section.

Memcg accounting of these counters is preserved. The relocated counters
remain visible in memory.stat alongside the existing aggregate pgscan and
pgsteal counters.

However, this change affects how the global counters are accumulated.
Previously, the global event count update was gated on !cgroup_reclaim(),
excluding memcg-based reclaim from /proc/vmstat. Now that
mod_lruvec_state() is being used to update the counters, the global
counters will include all reclaim. This is consistent with how pgdemote
counters are already tracked.

Finally, the virtio_balloon driver is updated to use
global_node_page_state() to fetch the counters, as they are no longer
accessible through the vm_events array.

Signed-off-by: JP Kobryn <jp.kobryn@linux.dev>
Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
---
 drivers/virtio/virtio_balloon.c |  8 ++---
 include/linux/mmzone.h          | 12 ++++++++
 include/linux/vm_event_item.h   | 12 --------
 mm/memcontrol.c                 | 52 +++++++++++++++++++++++----------
 mm/vmscan.c                     | 32 ++++++++------------
 mm/vmstat.c                     | 24 +++++++--------
 6 files changed, 76 insertions(+), 64 deletions(-)

diff --git a/drivers/virtio/virtio_balloon.c b/drivers/virtio/virtio_balloon.c
index 4e549abe59ff..ab945532ceef 100644
--- a/drivers/virtio/virtio_balloon.c
+++ b/drivers/virtio/virtio_balloon.c
@@ -369,13 +369,13 @@ static inline unsigned int update_balloon_vm_stats(struct virtio_balloon *vb)
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_ALLOC_STALL, stall);
 
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_ASYNC_SCAN,
-		    pages_to_bytes(events[PGSCAN_KSWAPD]));
+		    pages_to_bytes(global_node_page_state(PGSCAN_KSWAPD)));
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_DIRECT_SCAN,
-		    pages_to_bytes(events[PGSCAN_DIRECT]));
+		    pages_to_bytes(global_node_page_state(PGSCAN_DIRECT)));
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_ASYNC_RECLAIM,
-		    pages_to_bytes(events[PGSTEAL_KSWAPD]));
+		    pages_to_bytes(global_node_page_state(PGSTEAL_KSWAPD)));
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_DIRECT_RECLAIM,
-		    pages_to_bytes(events[PGSTEAL_DIRECT]));
+		    pages_to_bytes(global_node_page_state(PGSTEAL_DIRECT)));
 
 #ifdef CONFIG_HUGETLB_PAGE
 	update_stat(vb, idx++, VIRTIO_BALLOON_S_HTLB_PGALLOC,
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 3e51190a55e4..1aa9c7aec889 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -255,6 +255,18 @@ enum node_stat_item {
 	PGDEMOTE_DIRECT,
 	PGDEMOTE_KHUGEPAGED,
 	PGDEMOTE_PROACTIVE,
+	PGSTEAL_KSWAPD,
+	PGSTEAL_DIRECT,
+	PGSTEAL_KHUGEPAGED,
+	PGSTEAL_PROACTIVE,
+	PGSTEAL_ANON,
+	PGSTEAL_FILE,
+	PGSCAN_KSWAPD,
+	PGSCAN_DIRECT,
+	PGSCAN_KHUGEPAGED,
+	PGSCAN_PROACTIVE,
+	PGSCAN_ANON,
+	PGSCAN_FILE,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 22a139f82d75..1fa3b3ad0ff9 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -40,19 +40,7 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PGLAZYFREED,
 		PGREFILL,
 		PGREUSE,
-		PGSTEAL_KSWAPD,
-		PGSTEAL_DIRECT,
-		PGSTEAL_KHUGEPAGED,
-		PGSTEAL_PROACTIVE,
-		PGSCAN_KSWAPD,
-		PGSCAN_DIRECT,
-		PGSCAN_KHUGEPAGED,
-		PGSCAN_PROACTIVE,
 		PGSCAN_DIRECT_THROTTLE,
-		PGSCAN_ANON,
-		PGSCAN_FILE,
-		PGSTEAL_ANON,
-		PGSTEAL_FILE,
 #ifdef CONFIG_NUMA
 		PGSCAN_ZONE_RECLAIM_SUCCESS,
 		PGSCAN_ZONE_RECLAIM_FAILED,
diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 007413a53b45..e89e77457701 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -328,6 +328,18 @@ static const unsigned int memcg_node_stat_items[] = {
 	PGDEMOTE_DIRECT,
 	PGDEMOTE_KHUGEPAGED,
 	PGDEMOTE_PROACTIVE,
+	PGSTEAL_KSWAPD,
+	PGSTEAL_DIRECT,
+	PGSTEAL_KHUGEPAGED,
+	PGSTEAL_PROACTIVE,
+	PGSTEAL_ANON,
+	PGSTEAL_FILE,
+	PGSCAN_KSWAPD,
+	PGSCAN_DIRECT,
+	PGSCAN_KHUGEPAGED,
+	PGSCAN_PROACTIVE,
+	PGSCAN_ANON,
+	PGSCAN_FILE,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
@@ -441,14 +453,6 @@ static const unsigned int memcg_vm_event_stat[] = {
 #endif
 	PSWPIN,
 	PSWPOUT,
-	PGSCAN_KSWAPD,
-	PGSCAN_DIRECT,
-	PGSCAN_KHUGEPAGED,
-	PGSCAN_PROACTIVE,
-	PGSTEAL_KSWAPD,
-	PGSTEAL_DIRECT,
-	PGSTEAL_KHUGEPAGED,
-	PGSTEAL_PROACTIVE,
 	PGFAULT,
 	PGMAJFAULT,
 	PGREFILL,
@@ -1382,6 +1386,14 @@ static const struct memory_stat memory_stats[] = {
 	{ "pgdemote_direct",		PGDEMOTE_DIRECT		},
 	{ "pgdemote_khugepaged",	PGDEMOTE_KHUGEPAGED	},
 	{ "pgdemote_proactive",		PGDEMOTE_PROACTIVE	},
+	{ "pgsteal_kswapd",		PGSTEAL_KSWAPD		},
+	{ "pgsteal_direct",		PGSTEAL_DIRECT		},
+	{ "pgsteal_khugepaged",		PGSTEAL_KHUGEPAGED	},
+	{ "pgsteal_proactive",		PGSTEAL_PROACTIVE	},
+	{ "pgscan_kswapd",		PGSCAN_KSWAPD		},
+	{ "pgscan_direct",		PGSCAN_DIRECT		},
+	{ "pgscan_khugepaged",		PGSCAN_KHUGEPAGED	},
+	{ "pgscan_proactive",		PGSCAN_PROACTIVE	},
 #ifdef CONFIG_NUMA_BALANCING
 	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
 #endif
@@ -1425,6 +1437,14 @@ static int memcg_page_state_output_unit(int item)
 	case PGDEMOTE_DIRECT:
 	case PGDEMOTE_KHUGEPAGED:
 	case PGDEMOTE_PROACTIVE:
+	case PGSTEAL_KSWAPD:
+	case PGSTEAL_DIRECT:
+	case PGSTEAL_KHUGEPAGED:
+	case PGSTEAL_PROACTIVE:
+	case PGSCAN_KSWAPD:
+	case PGSCAN_DIRECT:
+	case PGSCAN_KHUGEPAGED:
+	case PGSCAN_PROACTIVE:
 #ifdef CONFIG_NUMA_BALANCING
 	case PGPROMOTE_SUCCESS:
 #endif
@@ -1496,15 +1516,15 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 
 	/* Accumulated memory events */
 	seq_buf_printf(s, "pgscan %lu\n",
-		       memcg_events(memcg, PGSCAN_KSWAPD) +
-		       memcg_events(memcg, PGSCAN_DIRECT) +
-		       memcg_events(memcg, PGSCAN_PROACTIVE) +
-		       memcg_events(memcg, PGSCAN_KHUGEPAGED));
+		       memcg_page_state(memcg, PGSCAN_KSWAPD) +
+		       memcg_page_state(memcg, PGSCAN_DIRECT) +
+		       memcg_page_state(memcg, PGSCAN_PROACTIVE) +
+		       memcg_page_state(memcg, PGSCAN_KHUGEPAGED));
 	seq_buf_printf(s, "pgsteal %lu\n",
-		       memcg_events(memcg, PGSTEAL_KSWAPD) +
-		       memcg_events(memcg, PGSTEAL_DIRECT) +
-		       memcg_events(memcg, PGSTEAL_PROACTIVE) +
-		       memcg_events(memcg, PGSTEAL_KHUGEPAGED));
+		       memcg_page_state(memcg, PGSTEAL_KSWAPD) +
+		       memcg_page_state(memcg, PGSTEAL_DIRECT) +
+		       memcg_page_state(memcg, PGSTEAL_PROACTIVE) +
+		       memcg_page_state(memcg, PGSTEAL_KHUGEPAGED));
 
 	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
 #ifdef CONFIG_MEMCG_V1
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 44e4fcd6463c..dd6d87340941 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -1984,7 +1984,7 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 	unsigned long nr_taken;
 	struct reclaim_stat stat;
 	bool file = is_file_lru(lru);
-	enum vm_event_item item;
+	enum node_stat_item item;
 	struct pglist_data *pgdat = lruvec_pgdat(lruvec);
 	bool stalled = false;
 
@@ -2010,10 +2010,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
 	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
-	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, nr_scanned);
-	count_memcg_events(lruvec_memcg(lruvec), item, nr_scanned);
-	__count_vm_events(PGSCAN_ANON + file, nr_scanned);
+	mod_lruvec_state(lruvec, item, nr_scanned);
+	mod_lruvec_state(lruvec, PGSCAN_ANON + file, nr_scanned);
 
 	spin_unlock_irq(&lruvec->lru_lock);
 
@@ -2030,10 +2028,8 @@ static unsigned long shrink_inactive_list(unsigned long nr_to_scan,
 					stat.nr_demoted);
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, -nr_taken);
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
-	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, nr_reclaimed);
-	count_memcg_events(lruvec_memcg(lruvec), item, nr_reclaimed);
-	__count_vm_events(PGSTEAL_ANON + file, nr_reclaimed);
+	mod_lruvec_state(lruvec, item, nr_reclaimed);
+	mod_lruvec_state(lruvec, PGSTEAL_ANON + file, nr_reclaimed);
 
 	lru_note_cost_unlock_irq(lruvec, file, stat.nr_pageout,
 					nr_scanned - nr_reclaimed);
@@ -4542,7 +4538,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 {
 	int i;
 	int gen;
-	enum vm_event_item item;
+	enum node_stat_item item;
 	int sorted = 0;
 	int scanned = 0;
 	int isolated = 0;
@@ -4601,13 +4597,11 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	}
 
 	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
-	if (!cgroup_reclaim(sc)) {
-		__count_vm_events(item, isolated);
+	if (!cgroup_reclaim(sc))
 		__count_vm_events(PGREFILL, sorted);
-	}
-	count_memcg_events(memcg, item, isolated);
+	mod_lruvec_state(lruvec, item, isolated);
 	count_memcg_events(memcg, PGREFILL, sorted);
-	__count_vm_events(PGSCAN_ANON + type, isolated);
+	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
@@ -4692,7 +4686,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	LIST_HEAD(clean);
 	struct folio *folio;
 	struct folio *next;
-	enum vm_event_item item;
+	enum node_stat_item item;
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
 	bool skip_retry = false;
@@ -4756,10 +4750,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 					stat.nr_demoted);
 
 	item = PGSTEAL_KSWAPD + reclaimer_offset(sc);
-	if (!cgroup_reclaim(sc))
-		__count_vm_events(item, reclaimed);
-	count_memcg_events(memcg, item, reclaimed);
-	__count_vm_events(PGSTEAL_ANON + type, reclaimed);
+	mod_lruvec_state(lruvec, item, reclaimed);
+	mod_lruvec_state(lruvec, PGSTEAL_ANON + type, reclaimed);
 
 	spin_unlock_irq(&lruvec->lru_lock);
 
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 99270713e0c1..d952c1e763e6 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1276,6 +1276,18 @@ const char * const vmstat_text[] = {
 	[I(PGDEMOTE_DIRECT)]			= "pgdemote_direct",
 	[I(PGDEMOTE_KHUGEPAGED)]		= "pgdemote_khugepaged",
 	[I(PGDEMOTE_PROACTIVE)]			= "pgdemote_proactive",
+	[I(PGSTEAL_KSWAPD)]			= "pgsteal_kswapd",
+	[I(PGSTEAL_DIRECT)]			= "pgsteal_direct",
+	[I(PGSTEAL_KHUGEPAGED)]			= "pgsteal_khugepaged",
+	[I(PGSTEAL_PROACTIVE)]			= "pgsteal_proactive",
+	[I(PGSTEAL_ANON)]			= "pgsteal_anon",
+	[I(PGSTEAL_FILE)]			= "pgsteal_file",
+	[I(PGSCAN_KSWAPD)]			= "pgscan_kswapd",
+	[I(PGSCAN_DIRECT)]			= "pgscan_direct",
+	[I(PGSCAN_KHUGEPAGED)]			= "pgscan_khugepaged",
+	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
+	[I(PGSCAN_ANON)]			= "pgscan_anon",
+	[I(PGSCAN_FILE)]			= "pgscan_file",
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
 #endif
@@ -1320,19 +1332,7 @@ const char * const vmstat_text[] = {
 
 	[I(PGREFILL)]				= "pgrefill",
 	[I(PGREUSE)]				= "pgreuse",
-	[I(PGSTEAL_KSWAPD)]			= "pgsteal_kswapd",
-	[I(PGSTEAL_DIRECT)]			= "pgsteal_direct",
-	[I(PGSTEAL_KHUGEPAGED)]			= "pgsteal_khugepaged",
-	[I(PGSTEAL_PROACTIVE)]			= "pgsteal_proactive",
-	[I(PGSCAN_KSWAPD)]			= "pgscan_kswapd",
-	[I(PGSCAN_DIRECT)]			= "pgscan_direct",
-	[I(PGSCAN_KHUGEPAGED)]			= "pgscan_khugepaged",
-	[I(PGSCAN_PROACTIVE)]			= "pgscan_proactive",
 	[I(PGSCAN_DIRECT_THROTTLE)]		= "pgscan_direct_throttle",
-	[I(PGSCAN_ANON)]			= "pgscan_anon",
-	[I(PGSCAN_FILE)]			= "pgscan_file",
-	[I(PGSTEAL_ANON)]			= "pgsteal_anon",
-	[I(PGSTEAL_FILE)]			= "pgsteal_file",
 
 #ifdef CONFIG_NUMA
 	[I(PGSCAN_ZONE_RECLAIM_SUCCESS)]	= "zone_reclaim_success",
-- 
2.47.3


