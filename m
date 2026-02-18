Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AC76E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 22:27:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 31A4D6B0088; Wed, 18 Feb 2026 17:27:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C8666B0089; Wed, 18 Feb 2026 17:27:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AA7D6B008A; Wed, 18 Feb 2026 17:27:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 030EC6B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 17:27:35 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 84FE88B2B0
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 22:27:35 +0000 (UTC)
X-FDA: 84459015270.30.C3AECCF
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf26.hostedemail.com (Postfix) with ESMTP id 96442140008
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 22:27:33 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cGxyD7+G;
	spf=pass (imf26.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771453654;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=oJLTd5Sdpnbw7nSrLAnO/vhHOXQJT1NDMcH7owI6z5I=;
	b=As0wp3UdyXW/XcANESg/aEfCHvxkDFsmU2D2bmiLSpW1brcx0dzZNfW5x6l+qln4hyymFM
	hPXRd985q93S/QP2pR+uF/0w8IVf8zOc8VYq1J4yHc0YaXNeCQMPanW1qV96R/xvnw6yYQ
	Wxl9W7UYLvGj2cBWYiRLrYv5rvImVn4=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=cGxyD7+G;
	spf=pass (imf26.hostedemail.com: domain of jp.kobryn@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771453654; a=rsa-sha256;
	cv=none;
	b=nHIoB8GgGUWY/e8h9CU/VBjH/Q3gIg8VK4d6U8awBCzh+82gba0RTjxGkBG31mt7Aki10n
	b40s+nzxDc9b2LbXwn7Rh6U2C62rJlwhV/L7QE90AEA7RNaPOQ1bB2BxjFmoChmEkQO0/g
	906C7vkNdKr/8SaSJlri+T1Mw9BV++c=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771453650;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=oJLTd5Sdpnbw7nSrLAnO/vhHOXQJT1NDMcH7owI6z5I=;
	b=cGxyD7+Gcv3uNNt966i4t1UhAyLT/uItuwrZKCCTe8m2120a/s7ltNHE0JprBKLJEFBdKQ
	2LnvP24darLeMy2wQ+5//jKjmqhuUaAb0YGGnrLD1EELqKFC/xQzvgkx8KPJYNr1E77znQ
	A92jFNvL9dn3N0drouC12r8s+zBm5ek=
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
Subject: [PATCH v3] mm: move pgscan, pgsteal, pgrefill to node stats
Date: Wed, 18 Feb 2026 14:26:52 -0800
Message-ID: <20260218222652.108411-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 96442140008
X-Stat-Signature: quhx5fu5g6sz3f1tydtzmzbj6yw4jf1p
X-HE-Tag: 1771453653-554680
X-HE-Meta: U2FsdGVkX18u06gsTs9HuilQmv9LCvDOGVfFpGsgHXUVD/OyvdexIHl2jZ7AB3ZXClHIzy3VLooGIeJi9yla4rfEpunvlDIAmY0+RgyYem354eZ46aMSHEbAHvs7ajnFyOUEpy+oA+EzT2SeiCgea57XPilneEcyJnzt1mtcs5xG1XwVgH73392cYtp6RvIFCBN+m95kqmILXc7QMiQT5Pvyv/FY3qcnQndhA4QQmnDgs9EaiEStjsjiHszA/jUibGbAWpNjXruBydj9cFcsW+UKDEhKUPMKFZ7hWbGHp1wu7E/u9mFXbB32Y3cE7ubSPuAv1EUr/EzzTYUrQB+ILWJ1Wcw9D8uKDJNenyUvw9k2Q9OTyy/ZAU7jbS5CQg/Vn84h3RFZwzgNPSueE1KKV+0/ZKmxDJqIyF9Y4AsKqrjtp5Ubrno1TIi9nI7nnfywoIWvK03+5QbLSNiS5MwlJng2X0osiIu6XW6WR86c1nqPw+z6XVkFqznMAE4oQELObuj1qiBrD+14ABBUUfUfCfL5cCAgFTYSbZXtF4o09kjUEIERhXD8eaAvo4wC4vIO/oX8Xo78+fBjBRuJALVYn299dAn/xi0cDLsw8sKS1l2WEo2DqHkxU1lKuad0a4A/H9Gu6J990YLowoW3Q9fY2xXJNzNDcQt0AqXdx9yNSunWCJjodfQrr9BRIxkXQhpl+zETTV8zR3JJg9/IHvgxUGT+COR8q78xUgJewT19U84M7/IojZd/QB3h6QeoEcAeeXy2olgnbtTXY8RrW0RrRlCmc/aXrDl74CWN8bkFTIbwekoPIOFE36JyyrZ70ZeK7ktEQUlmEVvmJkK0ASxkbU4YlhhVJeGnkn33YtTbKKocn1anR4nglsUqZJdFovAgp+TwUTfCoSHRLiUgvXYMoB8uybC+cWmZe2tnuRHyWQwkDwvecOBHwNJ50YuB6qTdDNxzm6E8a92AkN2BYTA
 plRtyQrx
 is7qwkBfWgewT/LvCYRuk1kNlT48rB7+d/yvFz15hHUXVqdu1x59cT+BM8NR0JwFbT2QEGOWBP/z3+8AoCol09to35NjTWGmCWOUOMPmPdR2BXBW2oS0F+UEV3lHz8g+rcO9vJn7Hi+UVhXYzH6wO5FGHoHZ5YxujRodU0K7AzILwO3a3sqe4aVkZzhh9/bRCsFuipixuPm6w402q+t8/hMPWS2HLxxt/lU79GsnFARYO0QSWe2XzW/acR1gKcz4CS7s6RITY80hPbKFh68woMb/kBNNFKfJFi2XIxheyXelfdFGlYc+Rvx0Ld+D/GL53i7AfLjb8dmkPStE3FPxcD4fM/dX5G3XHuSExDRgbpWfdXr1FM3YliaNcXfzC3MA3DowRN1MqmMsMqNv+IQoARkMv8Q==
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

Move the pgscan, pgsteal, and pgrefill counters from vm_event_item to
node_stat_item to provide per-node reclaim visibility. With these counters
as node stats, the values are now displayed in the per-node section of
/proc/zoneinfo, which allows for quick identification of the affected
nodes.

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
Acked-by: Michael S. Tsirkin <mst@redhat.com>
---
v3:
	- additionally move PGREFILL to node stats

v2: https://lore.kernel.org/linux-mm/20260218032941.225439-1-jp.kobryn@linux.dev/
	- update commit message
	- add entries to memory_stats array
	- add switch cases in memcg_page_state_output_unit()

v1: https://lore.kernel.org/linux-mm/20260212045109.255391-3-inwardvessel@gmail.com/

 drivers/virtio/virtio_balloon.c |  8 ++---
 include/linux/mmzone.h          | 13 ++++++++
 include/linux/vm_event_item.h   | 13 --------
 mm/memcontrol.c                 | 56 +++++++++++++++++++++++----------
 mm/vmscan.c                     | 38 ++++++++--------------
 mm/vmstat.c                     | 26 +++++++--------
 6 files changed, 82 insertions(+), 72 deletions(-)

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
index 3e51190a55e4..546bca95ca40 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -255,6 +255,19 @@ enum node_stat_item {
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
+	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
diff --git a/include/linux/vm_event_item.h b/include/linux/vm_event_item.h
index 22a139f82d75..03fe95f5a020 100644
--- a/include/linux/vm_event_item.h
+++ b/include/linux/vm_event_item.h
@@ -38,21 +38,8 @@ enum vm_event_item { PGPGIN, PGPGOUT, PSWPIN, PSWPOUT,
 		PGFREE, PGACTIVATE, PGDEACTIVATE, PGLAZYFREE,
 		PGFAULT, PGMAJFAULT,
 		PGLAZYFREED,
-		PGREFILL,
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
index 007413a53b45..a2e6d6ada823 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -328,6 +328,19 @@ static const unsigned int memcg_node_stat_items[] = {
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
+	PGREFILL,
 #ifdef CONFIG_HUGETLB_PAGE
 	NR_HUGETLB,
 #endif
@@ -441,17 +454,8 @@ static const unsigned int memcg_vm_event_stat[] = {
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
-	PGREFILL,
 	PGACTIVATE,
 	PGDEACTIVATE,
 	PGLAZYFREE,
@@ -1382,6 +1386,15 @@ static const struct memory_stat memory_stats[] = {
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
+	{ "pgrefill",			PGREFILL		},
 #ifdef CONFIG_NUMA_BALANCING
 	{ "pgpromote_success",		PGPROMOTE_SUCCESS	},
 #endif
@@ -1425,6 +1438,15 @@ static int memcg_page_state_output_unit(int item)
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
+	case PGREFILL:
 #ifdef CONFIG_NUMA_BALANCING
 	case PGPROMOTE_SUCCESS:
 #endif
@@ -1496,15 +1518,15 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 
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
index 44e4fcd6463c..11df7daac318 100644
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
@@ -2120,9 +2116,7 @@ static void shrink_active_list(unsigned long nr_to_scan,
 
 	__mod_node_page_state(pgdat, NR_ISOLATED_ANON + file, nr_taken);
 
-	if (!cgroup_reclaim(sc))
-		__count_vm_events(PGREFILL, nr_scanned);
-	count_memcg_events(lruvec_memcg(lruvec), PGREFILL, nr_scanned);
+	mod_lruvec_state(lruvec, PGREFILL, nr_scanned);
 
 	spin_unlock_irq(&lruvec->lru_lock);
 
@@ -4542,7 +4536,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 {
 	int i;
 	int gen;
-	enum vm_event_item item;
+	enum node_stat_item item;
 	int sorted = 0;
 	int scanned = 0;
 	int isolated = 0;
@@ -4601,13 +4595,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	}
 
 	item = PGSCAN_KSWAPD + reclaimer_offset(sc);
-	if (!cgroup_reclaim(sc)) {
-		__count_vm_events(item, isolated);
-		__count_vm_events(PGREFILL, sorted);
-	}
-	count_memcg_events(memcg, item, isolated);
-	count_memcg_events(memcg, PGREFILL, sorted);
-	__count_vm_events(PGSCAN_ANON + type, isolated);
+	mod_lruvec_state(lruvec, item, isolated);
+	mod_lruvec_state(lruvec, PGREFILL, sorted);
+	mod_lruvec_state(lruvec, PGSCAN_ANON + type, isolated);
 	trace_mm_vmscan_lru_isolate(sc->reclaim_idx, sc->order, scan_batch,
 				scanned, skipped, isolated,
 				type ? LRU_INACTIVE_FILE : LRU_INACTIVE_ANON);
@@ -4692,7 +4682,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	LIST_HEAD(clean);
 	struct folio *folio;
 	struct folio *next;
-	enum vm_event_item item;
+	enum node_stat_item item;
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
 	bool skip_retry = false;
@@ -4756,10 +4746,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
index 99270713e0c1..d5e6ba683211 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1276,6 +1276,19 @@ const char * const vmstat_text[] = {
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
+	[I(PGREFILL)]				= "pgrefill",
 #ifdef CONFIG_HUGETLB_PAGE
 	[I(NR_HUGETLB)]				= "nr_hugetlb",
 #endif
@@ -1318,21 +1331,8 @@ const char * const vmstat_text[] = {
 	[I(PGMAJFAULT)]				= "pgmajfault",
 	[I(PGLAZYFREED)]			= "pglazyfreed",
 
-	[I(PGREFILL)]				= "pgrefill",
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


