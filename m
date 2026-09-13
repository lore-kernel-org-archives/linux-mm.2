Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CCB7C88E56
	for <linux-mm@archiver.kernel.org>; Sun, 13 Sep 2026 07:51:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4C2D6B00A0; Sun, 13 Sep 2026 03:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D26D66B00A1; Sun, 13 Sep 2026 03:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C664B6B00A2; Sun, 13 Sep 2026 03:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92ED96B00A0
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 03:51:01 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id EBD8FA5396
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:51:00 +0000 (UTC)
X-FDA: 85207967880.20.9CA6F6A
Received: from mta0.migadu.com (out-108.mta0.migadu.com [91.218.175.108])
	by imf23.hostedemail.com (Postfix) with ESMTP id 126C914000D
	for <linux-mm@kvack.org>; Sun, 13 Sep 2026 07:50:58 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.108 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789285859;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7NJHMzVz8hF4fjO0N/43ThQ0lzKe7RoK+PWgRvxrYvE=;
	b=ef746yzqM7wQYhuCYhZWMOr8ODXqcbV+1iVEeNNJA9lWTnqjIkC7vd/g25V0uZ6nVAFaxp
	eJThNqiFRajnzjquTyPZSFtCCp7Rx8huR1KphP6MuhDoVbl/hXkfYRdYC8LPPx8ZHSNQ09
	MatD4bxbzci01PfYs3h6rOUn1aUwh94=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789285859;
	b=yOXRlKmvNGvHTXOomBI3dcgid1tF2ywsD084pf2qHuP9yPSHOeVsKYLoomW3PPvJtgz4v7
	qkJtHlW2VAmdNG7JeZCeeCjKgfEaejK78GKlOeqREp8x6vOvskMTC2iXhFQiDaY410sWWV
	0TFnZ5hjqetXsLJkhFVkj4Y6nTy9cAw=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.108 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 0729ec5625f55186;
	Sun, 13 Sep 2026 07:50:57 +0000
X-Mizu-Trace-ID: 0729ec5625f55186
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v2 07/12] mm, swap: add xswap_try_shrink and shrink trigger on cluster free
Date: Sun, 13 Sep 2026 15:50:09 +0800
Message-ID: <20260913075014.1732524-8-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
References: <20260913075014.1732524-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 126C914000D
X-Stat-Signature: b1zoyiaxqh1q13fwi77ykwfghxya53up
X-Rspam-User: 
X-HE-Tag: 1789285858-174138
X-HE-Meta: U2FsdGVkX1+eKwLeeOvHwp8s1esNQy7QI3kgMQD2kcanmXwomf1WS7U1yqzEx0DJz0SZet+P4qCI96qv9fnoZ6AJMtmNUkbx02gSyUP2WZF/o5Hw+D7BrsvMiYxIjGIp7hPOOiI5P2SeOcP8u2o1qNaP21yxsmpmGji8fp3NMsXE4Mcun5i6C3G8lFUJSp6rdAcgbafwgsm+MI8KGOJv0F8l3S/3kk9+n1/6x6ibHG/5BYrPQmEIvCihv/L2eH59bWmZbLpREnSya5SyhFrnPIBGkMz49rR6GeW5Cx41N3uYfcsHQiroal/Wp74B5V7svRDxQonxcrQuyFYfD88/QnGTLaE3eHgTRUCX2ZdOdXu4Pfu8GN9efyVqe5DwwkeSEhRb6fqUZRNvj4J4c8EruqWrprcEI9glOkVaWwoOJ/aHlQCO3jc9gDDK4KGZD6GC2XWZ5G6IDb72/tnxuGG6xbmdkNTBIc2Mq6mmvGX48SXI1qqqI6pbVlGP7SQVXFmNu7CddVI2RAhtL2BErCOlomTTpfdONxsYD1XgDn6Yk50i5mQGV0EYkYAESzaxOv/N9hW9GbrjeykWOZCIg2kTgGYpW/ZUcFwfLrZeLxNAJes/sPSCE0BgHXjW2oAPY1pdiJ8A4rilZWveDFneEj4ESueTX34ZyieMpqu/ADI7/LJ7nj91PDC2IqK/xFpvAlrMGKfAJlxBSpQAMxnCU1rfVV5FZnD0Yjxu8NFzXYLSjJTwdk3afuE4pR4g9QpDAFtH0OmTFT8Sm7hL2MGhbBsX9FDxmdgHHA6US2gWJa+4IXS1gdAzexuNnWIsOa80pzhGADuW18wq8OY6P19L+tucoPaDxIgEecqT5jZb/P4np494ALYdsPqoLScSvFL1B5EYWCLprAnUkKVR068tQHssZtCFUJsEFzOkfA6jPejZLAetz+1NTpnteR4DpWsORgFx4alfz41/yUhCPOnr1gS
 /depm0pk
 Ug7p5yDduw4/dpXeswGQFXTnsNWraiwCVLH4Ea6ynuyzAAD2D5ZXm+djpk1rGOoKpDP8U2J7Lb+ByB6FI+hjtzTrRH4CroJfVxT80X0T6cnO9te4c4JHfDHqovIG0ILYPKJELqR49QqBXAG4qDP7VUm8RcRGUZjh1fuOfg2Fyas3j36Fv7bi/1mbFjA+XVl8ZtNW6AIShDwDCh2qMRmz3Cpx0Whqa/uLz404s7BQJBCIa9z8P/uqnihIJtQDkTMo2TE6Oy5EfACgqtexaskmFHVQVGA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add xswap_try_shrink(). It scans backwards from the end of the mapped
range and counts the contiguous free clusters at the tail. It then
unmaps one or more chunks of that tail, in units of XSWAP_GROW_CLUSTERS.

The function only reclaims when the mapped range is at most half in use.
Growth is demand driven. Reclaiming on a smaller dip would only map the
same clusters again, and every unmap costs an RCU grace period. So it
leaves one chunk of free tail mapped as slack for the next allocation,
and waits until several chunks can go before it unmaps anything.

Wire the trigger in __free_cluster(). After a cluster is released to
the free list, call xswap_try_shrink() to attempt the tail shrink.

Also update the XSWAP_GROW_CLUSTERS comment. The constant is now used
for shrink as well as grow.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 95 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 89 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index f603f8c4b599..abe3d0ee5aba 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -54,12 +54,13 @@
 
 #ifdef CONFIG_XSWAP
 /*
- * xswap: dynamically grow the cluster_info array via a VM_SPARSE area.
+ * xswap: dynamically grow and shrink the cluster_info array via a
+ * VM_SPARSE area.
  *
- * XSWAP_GROW_CLUSTERS is the number of clusters to map in one grow
- * operation.  It is set to the number of cluster_info structs that
- * fit in a single page (at least 16), so that the vmalloc page table
- * overhead is proportional to the number of clusters mapped.
+ * XSWAP_GROW_CLUSTERS is the number of clusters to map/unmap in one
+ * grow/shrink operation: the number of cluster_info structs that fit in
+ * a single page (at least 16), so that the vmalloc page table overhead
+ * is proportional to the number of clusters mapped.
  */
 #define XSWAP_GROW_CLUSTERS \
 	max_t(unsigned long, PAGE_SIZE / sizeof(struct swap_cluster_info), 16)
@@ -69,6 +70,7 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr);
 static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data);
+static void xswap_try_shrink(struct swap_info_struct *si);
 
 #ifdef CONFIG_SYSFS
 static int xswap_create(int prio);
@@ -694,6 +696,9 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
+#ifdef CONFIG_XSWAP
+	xswap_try_shrink(si);
+#endif
 }
 
 /*
@@ -1514,11 +1519,19 @@ static bool swap_alloc_fast(struct folio *folio)
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
 	 * so checking it's liveness by get_swap_device_info is enough.
+	 *
+	 * The cached cluster points into si->cluster_info, which xswap
+	 * maps and unmaps at runtime.  The RCU section has to cover both
+	 * reading the cached offset and dereferencing it, so that an
+	 * unmap can wait for the readers already in flight.
 	 */
+	rcu_read_lock();
 	si = this_cpu_read(percpu_swap_cluster.si[order]);
 	offset = this_cpu_read(percpu_swap_cluster.offset[order]);
-	if (!si || !offset || !get_swap_device_info(si))
+	if (!si || !offset || !get_swap_device_info(si)) {
+		rcu_read_unlock();
 		return false;
+	}
 
 	ci = swap_cluster_lock(si, offset);
 	if (cluster_is_usable(ci, order)) {
@@ -1530,6 +1543,7 @@ static bool swap_alloc_fast(struct folio *folio)
 	}
 
 	put_swap_device(si);
+	rcu_read_unlock();
 	return folio_test_swapcache(folio);
 }
 
@@ -2307,8 +2321,12 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	/*
 	 * Try the local cluster first if it matches the device. If
 	 * not, try grab a new cluster and override local cluster.
+	 *
+	 * Same RCU requirement as swap_alloc_fast(): the cached offset
+	 * indexes si->cluster_info, which xswap can unmap.
 	 */
 	local_lock(&percpu_swap_cluster.lock);
+	rcu_read_lock();
 	pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
 	pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
 	if (pcp_si == si && pcp_offset) {
@@ -2318,6 +2336,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 		else
 			swap_cluster_unlock(ci);
 	}
+	rcu_read_unlock();
 	if (!offset)
 		offset = cluster_alloc_swap_entry(si, NULL);
 	local_unlock(&percpu_swap_cluster.lock);
@@ -3888,6 +3907,15 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 		return;
 	}
 
+	/*
+	 * A per-cpu cluster cache can still hold an offset in this range.
+	 * Invalidate those references, then wait out the readers that have
+	 * already loaded one, so that nobody can dereference cluster_info
+	 * past this point.  swapoff() needs the same before it releases.
+	 */
+	flush_percpu_swap_cluster(si);
+	synchronize_rcu();
+
 	vm_area_unmap_pages(si->cluster_vm, vm_start, vm_end);
 	/* vm_area_unmap_pages() clears PTEs but does not free pages. */
 	/* TODO: free backing pages via page table walk or tracking bitmap */
@@ -3905,6 +3933,61 @@ static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data)
 	*mapped_end = addr + PAGE_SIZE;
 	return 0;
 }
+
+/*
+ * Automatic reclaim: leave one chunk of the free tail mapped as slack, so
+ * that the next allocation does not grow the range straight back, and only
+ * unmap once several chunks can go, so the unmap is worth the RCU grace
+ * period it costs.
+ */
+#define XSWAP_SHRINK_SLACK	XSWAP_GROW_CLUSTERS
+#define XSWAP_SHRINK_MIN	(XSWAP_GROW_CLUSTERS * 4)
+
+/*
+ * Try to shrink the cluster_info tail: unmap contiguous free clusters
+ * at the end of the mapped range.
+ */
+static void xswap_try_shrink(struct swap_info_struct *si)
+{
+	struct swap_cluster_info *ci;
+	unsigned long nr_mapped, last, idx;
+
+	if (!(si->flags & SWP_XSWAP))
+		return;
+
+	nr_mapped = READ_ONCE(si->nr_clusters_mapped);
+	if (nr_mapped <= 1) /* keep cluster 0 */
+		return;
+
+	/*
+	 * Reclaim on our own, but only once the mapped range is at most
+	 * half in use: growth is demand driven, so reclaiming on a smaller
+	 * dip would only map the same clusters again, and every unmap costs
+	 * an RCU grace period.
+	 */
+	if (atomic_long_read(&si->inuse_pages) * 2 > nr_mapped * SWAPFILE_CLUSTER)
+		return;
+
+	/* Find the last non-free cluster from the tail */
+	last = nr_mapped;
+	while (last > 1) {
+		idx = last - 1;
+		ci = &si->cluster_info[idx];
+		if (ci->count || ci->flags != CLUSTER_FLAG_FREE)
+			break;
+		last = idx;
+	}
+
+	if (last == nr_mapped)
+		return; /* nothing to shrink */
+
+	if (nr_mapped - last < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
+		return;
+
+	last += XSWAP_SHRINK_SLACK;
+
+	xswap_unmap_clusters(si, last, nr_mapped - last);
+}
 #endif /* CONFIG_XSWAP */
 
 static int setup_swap_clusters_info(struct swap_info_struct *si,
-- 
2.54.0


