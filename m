Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 05416C531F4
	for <linux-mm@archiver.kernel.org>; Thu, 19 Feb 2026 23:59:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3992D6B00A2; Thu, 19 Feb 2026 18:59:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3710E6B00A3; Thu, 19 Feb 2026 18:59:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A7BE6B00A4; Thu, 19 Feb 2026 18:59:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 1836A6B00A2
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 18:59:19 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B49CD1B5FD0
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:59:18 +0000 (UTC)
X-FDA: 84462875196.15.4FA7F63
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf04.hostedemail.com (Postfix) with ESMTP id D9C1D4000A
	for <linux-mm@kvack.org>; Thu, 19 Feb 2026 23:59:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fJbH6x/3";
	spf=pass (imf04.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771545557;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hbP57otIJy2E+y2KoxAXNaiSU96HA+1LQ4TFOW0uoFE=;
	b=crALihpIeJz2op8UYwW/7zMKptHDMN95lLHr35fzW/waGbYaR/Qb+7OensszKgtboPQy/E
	35UZv622kn1cWhEhQQ8hB/FVy2B0UODoTWDE5d3F/M+QS61XuiFcSZHRshKkZCOjEv1KKj
	vhqGmLBqmTMf7FdhKuPOMpGGn80vdEE=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="fJbH6x/3";
	spf=pass (imf04.hostedemail.com: domain of jp.kobryn@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=jp.kobryn@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771545557; a=rsa-sha256;
	cv=none;
	b=Bf4s8qyQUY1vYJdQMeU2puUPDPa35X5mTTHWBj5ooTOB39gbldMysZ/AfAry7QS6vMlVk/
	PYkNj56bL/MbmdCR000lYzfWrS5YKoTze4kDK8AhM8moVddVuMK8ER54/pmHUhJp5p8cFx
	JrxM42AWoSXN5FuyoD7Ijks1j9J7zPE=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1771545553;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=hbP57otIJy2E+y2KoxAXNaiSU96HA+1LQ4TFOW0uoFE=;
	b=fJbH6x/3/muOKYSrlxWWMrH56oixLTgf52Tfq2ZlQgBJ7xknv9l5cZhOIXQwtOk86bLiru
	8IbI/adplsn/0azSv1Rk4ulQheg4kmxwUOE+mzwZeNTYWKZOO6eCNJ49IR1b/v4DdusRaV
	QWE2/JN6Gyhyu2R50oOTjCqDnsR9Z/8=
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
Subject: [PATCH v5] mm: move pgscan, pgsteal, pgrefill to node stats
Date: Thu, 19 Feb 2026 15:58:46 -0800
Message-ID: <20260219235846.161910-1-jp.kobryn@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: d1awrzjqe7iqgx6eb6o9rr8hqezzrq3z
X-Rspam-User: 
X-Rspamd-Queue-Id: D9C1D4000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1771545556-93547
X-HE-Meta: U2FsdGVkX1/ZTbcDgLeTx+bMPLHzj9Cjl/IhJYbLO1mml+3AbwclfXuk8ZSJnvGLsE+kyIV7M/Dhpa6OGP26qvjMPtHvVYfkZu8nd0YJXxmvYmtIdW2vEzvxQjcmJqrpG6sMpswAyTLkMR9odqh6ew1Ovb/fZVkcfLQgq4Bq7H10cFsLaUdazlCcuahn1WRdpjSYv1wf3bZHrurLXlVkRpla3HBDl+f0bKwPbCBc+q49onZSm9hditQN/tKxDxNaN140vm24ddbXboWbB+doJxHZSGigFiEjDkdJ5GoAWT1dtSswbQPjrFtAnfl/7MMjBFnBKD8FFPz77OklqfFwNzhMopR9NWl+qALiASLlT8Ja7joUMeo0UVOp+ISSVFYoTo7EdzyOaSLXOfA/xx8rm8Q0CwqKUGdDJ3tcayJbfd1JizWOJl6PNGfl+4p2nX+aZhHvAm5cfRR8XI6zX0JptVdsUONqud5ov1vz+Qt5VVUCOVRuIKb353c7C/UxnwFxDMiTPPwc/9t+LgI2kOFz/US2SZKO5okBkfi710X0Tp+rW9VEnRgb6BvlM0kSW0SEanCPdbtG6uoAlUWxuv0v7SvvNuJmzu0u9EYw0EoL7i6S0y8QBg/MYmtKG3CGgchovgk5D4yW2lytr5TbmqK36tBGoGC8DwkQCfM5h//ioA1xO4RFMCmMj7Fw4byuP5KvigWnQHxmYNE125xWYHFtGBbt/AiunvX2/24gkAlLz7okkTtzaa6ha6QBwP5cN5kxGgJhlTIy5MXkNckun4rVYsLCYzzRjMN7N+zrxHx59eyrnu8uyQT+2NY3lG/t8J9DI2lV7wXysB9JdeQLbVjh6X5zKacVGoHkLwPG014as4cNAgSHf2lSxZPEUrLH47neakadVmXRCNwfo7QKPGmLT7Lzd6SAxlYzbrwTF4wySmPpBjZM5RPdD1alMvSDnLLeIdcaWG12rpEEPh1p9/J
 bB41Qj+D
 ZDuY+
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
v5:
	- rebase onto mm/mm-new

v4: https://lore.kernel.org/linux-mm/20260219171124.19053-1-jp.kobryn@linux.dev/
	- remove unused memcg var from scan_folios()

v3: https://lore.kernel.org/linux-mm/20260218222652.108411-1-jp.kobryn@linux.dev/
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
 mm/vmscan.c                     | 39 ++++++++---------------
 mm/vmstat.c                     | 26 +++++++--------
 6 files changed, 82 insertions(+), 73 deletions(-)

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
index 6fb9c999347b..0d834c47706f 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -331,6 +331,19 @@ static const unsigned int memcg_node_stat_items[] = {
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
@@ -444,17 +457,8 @@ static const unsigned int memcg_vm_event_stat[] = {
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
@@ -1401,6 +1405,15 @@ static const struct memory_stat memory_stats[] = {
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
@@ -1444,6 +1457,15 @@ static int memcg_page_state_output_unit(int item)
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
@@ -1562,15 +1584,15 @@ static void memcg_stat_format(struct mem_cgroup *memcg, struct seq_buf *s)
 
 	/* Accumulated memory events */
 	memcg_seq_buf_print_stat(s, NULL, "pgscan", ' ',
-				 memcg_events(memcg, PGSCAN_KSWAPD) +
-				 memcg_events(memcg, PGSCAN_DIRECT) +
-				 memcg_events(memcg, PGSCAN_PROACTIVE) +
-				 memcg_events(memcg, PGSCAN_KHUGEPAGED));
+				 memcg_page_state(memcg, PGSCAN_KSWAPD) +
+				 memcg_page_state(memcg, PGSCAN_DIRECT) +
+				 memcg_page_state(memcg, PGSCAN_PROACTIVE) +
+				 memcg_page_state(memcg, PGSCAN_KHUGEPAGED));
 	memcg_seq_buf_print_stat(s, NULL, "pgsteal", ' ',
-				 memcg_events(memcg, PGSTEAL_KSWAPD) +
-				 memcg_events(memcg, PGSTEAL_DIRECT) +
-				 memcg_events(memcg, PGSTEAL_PROACTIVE) +
-				 memcg_events(memcg, PGSTEAL_KHUGEPAGED));
+				 memcg_page_state(memcg, PGSTEAL_KSWAPD) +
+				 memcg_page_state(memcg, PGSTEAL_DIRECT) +
+				 memcg_page_state(memcg, PGSTEAL_PROACTIVE) +
+				 memcg_page_state(memcg, PGSTEAL_KHUGEPAGED));
 
 	for (i = 0; i < ARRAY_SIZE(memcg_vm_event_stat); i++) {
 #ifdef CONFIG_MEMCG_V1
diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5fa6e6bd6540..c3dc7c7befac 100644
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
 
@@ -4537,7 +4531,7 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 {
 	int i;
 	int gen;
-	enum vm_event_item item;
+	enum node_stat_item item;
 	int sorted = 0;
 	int scanned = 0;
 	int isolated = 0;
@@ -4545,7 +4539,6 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	int scan_batch = min(nr_to_scan, MAX_LRU_BATCH);
 	int remaining = scan_batch;
 	struct lru_gen_folio *lrugen = &lruvec->lrugen;
-	struct mem_cgroup *memcg = lruvec_memcg(lruvec);
 
 	VM_WARN_ON_ONCE(!list_empty(list));
 
@@ -4596,13 +4589,9 @@ static int scan_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
@@ -4705,7 +4694,7 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
 	LIST_HEAD(clean);
 	struct folio *folio;
 	struct folio *next;
-	enum vm_event_item item;
+	enum node_stat_item item;
 	struct reclaim_stat stat;
 	struct lru_gen_mm_walk *walk;
 	bool skip_retry = false;
@@ -4769,10 +4758,8 @@ static int evict_folios(unsigned long nr_to_scan, struct lruvec *lruvec,
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
index 86b14b0f77b5..44bbb7752f11 100644
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


