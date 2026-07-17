Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28C40C44507
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 06:31:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 562DB6B0005; Fri, 17 Jul 2026 02:31:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53BEF6B0093; Fri, 17 Jul 2026 02:31:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 452266B0095; Fri, 17 Jul 2026 02:31:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 11F906B0093
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 02:31:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7699840467
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 06:31:28 +0000 (UTC)
X-FDA: 84997297056.05.FCE90E1
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf16.hostedemail.com (Postfix) with ESMTP id 3464E180002
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 06:31:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iAvO9NTL;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784269887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dtmAsjOZRbEJt8owf9zTbDLUylJSS4K6ysbF5XED/rI=;
	b=Rkh1N4cS1kzgU8iBVWBlcV5TUspfTW8j1Kdj8wkDHiT/JALi8YtC2qzbR3vLgCiN4cdF1K
	01UFNoUdIr6ygsv0gw/cjlKryEgfK7xBIG0mq0FI/ZX8tqOULZxLm/YxXfUPSPczcgTbfL
	BLjYQmJfBaZ22pInysNiYmG+zs+lrWc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iAvO9NTL;
	spf=pass (imf16.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784269887;
	b=qDJSJPYKt3IqUMMELAcxeCih2wBkJO9CuR34nL7sVWGyMkKQ7hZUXKtfOpKqoAinnM1cub
	YRN11TQpR32kHyiiSC18wIoub/narbeL+k/y61aC5Prv1dzXxInrSJ5jXKo8wyWYKkG0BN
	gZApM22c/x042HqdO2QAb7TVOTmAZIQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784269881;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=dtmAsjOZRbEJt8owf9zTbDLUylJSS4K6ysbF5XED/rI=;
	b=iAvO9NTLFOK4wGbutvHypW4H3LqgyMz7jH7ChYnLbA1a/WW3fuZGVu8gEBVzvQ/eEJ84MB
	MSCnUKkJxgUdDk1nIXK1SgnSg9+8ULO2/U3LtacoMyIdP9RbvNPJfbhl/aXdjrrHSK71Bg
	CxTdNRpZVLcyW4kVejoPPvf7RBpjkrk=
From: Ye Liu <ye.liu@linux.dev>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	"Rafael J. Wysocki" <rafael@kernel.org>,
	Danilo Krummrich <dakr@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	driver-core@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org
Subject: [PATCH] mm/thp: expose deferred split folio memory usage in meminfo
Date: Fri, 17 Jul 2026 14:30:22 +0800
Message-ID: <20260717063025.168436-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 3464E180002
X-Stat-Signature: mg63xptuqwddx37iw8rf7ngfnrxhxm9r
X-HE-Tag: 1784269885-513332
X-HE-Meta: U2FsdGVkX1+qCVYMl43+4q7OLHg9D+69VIHE30o3VcMK8VzYZLGbJPffqsG5Hy+SIpjbtkDkyxKiLjOrBvtZ88+wWu/7FRZxIAWxBuNvJLBUoWzPxbWxJbcLJrUUUp5q+LtdB1P1/of4hKPXYE1R6hKKuGxYHmFSA/xW4acBxXmdm3ZWk0hgD+Yl2pUDpwHSsvxtX9fcnrasEL5hJq9saFX4aquusS+/KQpkK/mExuyK7FJ4JJajAt5hrUXIwx2+H9N1tKDISpgIDCqyUpFXRccDLd2C0CT+hEv5NYHvFNHlzJZWZQAElMwfuilUGNMpM7rbzxGH2XvXK3UzhLsT0nK8L5QLUKCDv06fdtMPZ//l8GulVh+0h213RQpto/XcBJScxaKiGPm8AEAKj7Gam4HOoM1AEGqhFEhorWtpysEWYuQ30qqgEq/oUDNQ7JovRLe5wVBk/VR++xsVZRCk11busCAcegGXO69U2gU6LvXvmR0wRmmH3+VdXF/ZlHtLSUyiy54P0M1A7ekkdms+LTVw78OfgTAfGGhE7fX4sASmwZEEeA7EFYNoBMlv+nFqWUlpET+ZJi2Ah6A4/uvMg9+VVqkFWY+5/R04g1kpm7n9+ccAY5S5KKoir7AD30IxnqR/29PNUq1Ng26Kqz+7VbMlrVpFVzy75JGeYTbFVEgGWjxKyEufyni1jsHHmG3m6unbroZN7qR0KmJTbx6GfoPgKlf+VVlwiMovp2huRyPSRH0JtgSpJLQihpjnn/gKy+jifPNuEFKlO7c1/aobvzGK+iLMBhGW8wKZ2nEFfx9p8VzY5cQIwfFgellS5B4Nx0evg7CXzQxDaCJyyUjTz6kcGaPw8cyc98KgXrpI3yloXP9bYFXBFI6fsq6vbCPe10RhzssGfMH71kgiUFHHNvuZcNLTeZ/OYtUlJ6mpRzCmotznXQuFa8ZSN7j+JrKKN1ufkoO9stnE055avyI
 1+NRw95G
 jgJjEvGD2ETnshCl/RqX2r7+oQg4q4HQSUAgLbz0kFzqWSVRYRbipz8hkdxb4/dSqb7B35aUF/DlXxmu9Qg0o4BRcSCOI+QYVd9uyFOL7GR1znzUX3ElDJBHt5yTs9LrkXspGpR+D8wJy1CmsijVb1pXjLi4TNqcHYGptEdwM5TdyTd2WDjn5wPhII0Km5aIQwFWl8wrsB5B8tXE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

Folios on the deferred split list hold physical memory that is
invisible in meminfo. When a THP becomes partially mapped, the
unmapped pages are removed from AnonPages but remain physically
allocated until the shrinker splits the folio. This creates a
memory accounting gap where used memory cannot be attributed to
any meminfo field.

Add NR_DEFERRED_SPLIT_PAGES to track the total memory consumed by
folios currently on the deferred_split_lru, updated via
mod_node_page_state() at all enqueue/dequeue points. The new field
DeferredSplitPages is visible in /proc/meminfo, /proc/vmstat, and
per-node /sys/devices/system/node/node*/meminfo.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
 drivers/base/node.c    |  4 +++-
 fs/proc/meminfo.c      |  2 ++
 include/linux/mmzone.h |  1 +
 mm/huge_memory.c       | 24 +++++++++++++++++++++---
 mm/vmstat.c            |  1 +
 5 files changed, 28 insertions(+), 4 deletions(-)

diff --git a/drivers/base/node.c b/drivers/base/node.c
index 3da91929ad4e..69463438300e 100644
--- a/drivers/base/node.c
+++ b/drivers/base/node.c
@@ -519,6 +519,7 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     "Node %d ShmemPmdMapped: %8lu kB\n"
 			     "Node %d FileHugePages:  %8lu kB\n"
 			     "Node %d FilePmdMapped:  %8lu kB\n"
+			     "Node %d DeferredSplitPages: %8lu kB\n"
 #endif
 #ifdef CONFIG_UNACCEPTED_MEMORY
 			     "Node %d Unaccepted:     %8lu kB\n"
@@ -553,7 +554,8 @@ static ssize_t node_read_meminfo(struct device *dev,
 			     nid, K(node_page_state(pgdat, NR_SHMEM_THPS)),
 			     nid, K(node_page_state(pgdat, NR_SHMEM_PMDMAPPED)),
 			     nid, K(node_page_state(pgdat, NR_FILE_THPS)),
-			     nid, K(node_page_state(pgdat, NR_FILE_PMDMAPPED))
+			     nid, K(node_page_state(pgdat, NR_FILE_PMDMAPPED)),
+			     nid, K(node_page_state(pgdat, NR_DEFERRED_SPLIT_PAGES))
 #endif
 #ifdef CONFIG_UNACCEPTED_MEMORY
 			     ,
diff --git a/fs/proc/meminfo.c b/fs/proc/meminfo.c
index b2813ff13cb2..76dbf51ad1e0 100644
--- a/fs/proc/meminfo.c
+++ b/fs/proc/meminfo.c
@@ -149,6 +149,8 @@ static int meminfo_proc_show(struct seq_file *m, void *v)
 		    global_node_page_state(NR_FILE_THPS));
 	show_val_kb(m, "FilePmdMapped:  ",
 		    global_node_page_state(NR_FILE_PMDMAPPED));
+	show_val_kb(m, "DeferredSplitPages: ",
+		    global_node_page_state(NR_DEFERRED_SPLIT_PAGES));
 #endif
 
 #ifdef CONFIG_CMA
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 0507193b3ae3..1e75adb73d00 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -267,6 +267,7 @@ enum node_stat_item {
 	NR_FILE_THPS,
 	NR_FILE_PMDMAPPED,
 	NR_ANON_THPS,
+	NR_DEFERRED_SPLIT_PAGES, /* THP/mTHP pages pending deferred split */
 	NR_VMSCAN_WRITE,
 	NR_VMSCAN_IMMEDIATE,	/* Prioritise for reclaim when writeback ends */
 	NR_DIRTIED,		/* page dirtyings since bootup */
diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index c642bec967fa..1094b844675c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -77,6 +77,14 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 					 struct shrink_control *sc);
 static bool split_underused_thp = true;
 
+#define deferred_split_pages_add(folio) \
+	mod_node_page_state(NODE_DATA(folio_nid(folio)), \
+			    NR_DEFERRED_SPLIT_PAGES, folio_nr_pages(folio))
+
+#define deferred_split_pages_del(folio) \
+	mod_node_page_state(NODE_DATA(folio_nid(folio)), \
+			    NR_DEFERRED_SPLIT_PAGES, -folio_nr_pages(folio))
+
 static atomic_t huge_zero_refcount;
 struct folio *huge_zero_folio __read_mostly;
 unsigned long huge_zero_pfn __read_mostly = ~0UL;
@@ -3913,8 +3921,10 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		struct lruvec *lruvec;
 
 		if (dequeue_deferred) {
-			__list_lru_del(&deferred_split_lru, lru,
-				       &folio->_deferred_list, folio_nid(folio));
+			if (__list_lru_del(&deferred_split_lru, lru,
+					  &folio->_deferred_list, folio_nid(folio)) &&
+			    folio_test_partially_mapped(folio))
+				deferred_split_pages_del(folio);
 			if (folio_test_partially_mapped(folio)) {
 				folio_clear_partially_mapped(folio);
 				mod_mthp_stat(old_order,
@@ -4415,6 +4425,7 @@ bool __folio_unqueue_deferred_split(struct folio *folio)
 	lru = list_lru_lock_irqsave(&deferred_split_lru, nid, &memcg, &flags);
 	if (__list_lru_del(&deferred_split_lru, lru, &folio->_deferred_list, nid)) {
 		if (folio_test_partially_mapped(folio)) {
+			deferred_split_pages_del(folio);
 			folio_clear_partially_mapped(folio);
 			mod_mthp_stat(folio_order(folio),
 				      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
@@ -4473,6 +4484,8 @@ void deferred_split_folio(struct folio *folio, bool partially_mapped)
 		VM_WARN_ON_FOLIO(folio_test_partially_mapped(folio), folio);
 	}
 	__list_lru_add(&deferred_split_lru, lru, &folio->_deferred_list, nid, memcg);
+	if (partially_mapped)
+		deferred_split_pages_add(folio);
 	list_lru_unlock_irqrestore(lru, &flags);
 	rcu_read_unlock();
 }
@@ -4524,8 +4537,11 @@ static enum lru_status deferred_split_isolate(struct list_head *item,
 {
 	struct folio *folio = container_of(item, struct folio, _deferred_list);
 	struct list_head *freeable = cb_arg;
+	bool partially_mapped = folio_test_partially_mapped(folio);
 
 	if (folio_try_get(folio)) {
+		if (partially_mapped)
+			deferred_split_pages_del(folio);
 		list_lru_isolate_move(lru, item, freeable);
 		return LRU_REMOVED;
 	}
@@ -4535,7 +4551,8 @@ static enum lru_status deferred_split_isolate(struct list_head *item,
 	 * isolate: folio_unqueue_deferred_split() checks list_empty()
 	 * locklessly, so once removed the folio can be freed any time.
 	 */
-	if (folio_test_partially_mapped(folio)) {
+	if (partially_mapped) {
+		deferred_split_pages_del(folio);
 		folio_clear_partially_mapped(folio);
 		mod_mthp_stat(folio_order(folio),
 			      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
@@ -4596,6 +4613,7 @@ static unsigned long deferred_split_scan(struct shrinker *shrink,
 					 &folio->_deferred_list,
 					 folio_nid(folio),
 					 folio_memcg(folio));
+			deferred_split_pages_add(folio);
 			rcu_read_unlock();
 		}
 		folio_put(folio);
diff --git a/mm/vmstat.c b/mm/vmstat.c
index 3b5cb1031f72..ba71cc3e4c30 100644
--- a/mm/vmstat.c
+++ b/mm/vmstat.c
@@ -1248,6 +1248,7 @@ const char * const vmstat_text[] = {
 	[I(NR_FILE_THPS)]			= "nr_file_hugepages",
 	[I(NR_FILE_PMDMAPPED)]			= "nr_file_pmdmapped",
 	[I(NR_ANON_THPS)]			= "nr_anon_transparent_hugepages",
+	[I(NR_DEFERRED_SPLIT_PAGES)]		= "nr_deferred_split_pages",
 	[I(NR_VMSCAN_WRITE)]			= "nr_vmscan_write",
 	[I(NR_VMSCAN_IMMEDIATE)]		= "nr_vmscan_immediate_reclaim",
 	[I(NR_DIRTIED)]				= "nr_dirtied",
-- 
2.43.0


