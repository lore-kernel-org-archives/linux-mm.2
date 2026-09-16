Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65CB9C88E77
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 10:20:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E4A76B009F; Wed, 16 Sep 2026 06:20:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BDBC6B00A0; Wed, 16 Sep 2026 06:20:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 585216B00A1; Wed, 16 Sep 2026 06:20:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 304D36B009F
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 06:20:50 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D0D1B120692
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:20:49 +0000 (UTC)
X-FDA: 85219231818.17.839D748
Received: from mta0.migadu.com (out-19.mta0.migadu.com [91.218.175.19])
	by imf25.hostedemail.com (Postfix) with ESMTP id D8E56A000C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 10:20:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.19 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789554048;
	b=oQCWg5SdiJYfSkFUgbuQc7nm3Ur9BUdz5+gdu00gnFjkJEfPq5np222Ti1Ve6lrJKULl5X
	JJoBujrF6vNa+BI3Gq7viFYNvOH9hneLV+HdXhc266YhqGzN+KHncfofkTf8cgeI2XidTU
	kw0YNDda16+63oH+r9IRKlViWIA+FNQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.19 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789554048;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QuYFihUz2yzwuY4gcC19sjFKuqYKXH4Otpu3Tw4JasA=;
	b=q6qjxYKIgYyX/MN2ePBKZCxD9W+QwE4wDAJRxj5bEF7W+7WoQaIRmitLymYWl1/RyfQRy5
	An8yYT1rluxnenJLW+Pzn1uC40/sDb7orUEoekwhIBNM/aDBYWQDSPpo6IwH+9xWg0D64p
	NwPJqnsDHPQ4ils3lFvxlXp9J3ZCqCk=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 237cca9ece2c04ea;
	Wed, 16 Sep 2026 10:20:46 +0000
X-Mizu-Trace-ID: 237cca9ece2c04ea
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
	kunwu.chan@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v3 07/14] mm, swap: add xswap_try_shrink and shrink trigger on cluster free
Date: Wed, 16 Sep 2026 18:19:14 +0800
Message-ID: <20260916101929.149106-8-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260916101929.149106-1-hebaoquan@kylinos.cn>
References: <20260916101929.149106-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D8E56A000C
X-Stat-Signature: asi3o7eg7xasqf67hwo5pnxwhy9anb85
X-HE-Tag: 1789554047-87118
X-HE-Meta: U2FsdGVkX1/u1RNoPk0ooJFJA/NNRQgjScnYn4PLN9Fu4HuqwYjqwNXb8uBhSMBU4DtDX2CqlYSlmlsYO9oHGa4wI7W9jmix22jHyRZuyBA+GcuAS9pm1d/7zOQzh8SS3xouux0dsWva5GSTzrMElAciP54wkBC3h9uWCjSHPGobkdpLb9T+yB3dvB69mkVsPf2iYyXdTuATY9sW+0pkBZXZX/hIjKEglD7CTmfqhSIP+XwTlPZ+c0lAewgX+27gR3HZ/C+SlWFe9PrlknZNdIFOzXTV1i0JvNO9MI8cGFKgUR1ouXIDrhUtzfJoTK4R3VKBrjEW7BesbgNcO+V/pXKSt48x+anQhtBSfOTKtRR9iXRd6UorNI1B2KlUw4P/SgR5F/aFkSfzH9dh9O/etPKPM1zGVBBjM9ARGV57+a+7yWW87VyLCdL8QZ1OgtNbDnjFGvwZQ00phH+RW1Gjk7heJH8R9PrBfuviRu1YWhw62Zdsrpy4rnk5hIbNUymyERQAdNrx3P3UB0hDovgmY/xD2MZqwkta63HXL9+amktFjrnTQIBE7FdJ0vPe6yKIHPeZOp2ZvOQ9fTq+29KPolc3M8/5WVCbXAL2Q5zvp+dvKgq+JEi6xBRYCDeYauLU831fJrL8xKeOAseRmh/u4U5EgantRijTv44K8Oz9nNUEcREyelIu33MgbE0u+gY/hEarlikTdMNj+K+4TG9kqckJSziz0QZHTmUTTzzEXa4HTZYV9LecRB+R9G22FSAFXIWaq2T8MGlpfb3QqKW0Kc+tT13Mpq1GSPOhFGtF0Le3TCpP2GbtuxGkZHsD0Gwosw9AS9dUvWcTLJLtimXJ3fz64BnpxTGMg9Sw6h1KevschIGewtXIsIv7om6U7qZ4gxPzZJs28QxZ+YojKnhCNPsFeBSJgHST1H5jCthvmF9yyi4Y5BmuSUsFUPBg6OERgJ6hA9TftJpVB/yploy
 0b9ak2yT
 zfGRCFuc0X4XLwbDylkYjEJKN/L+1dDJ3Au5ajyU7yc77Zdb0q1w0jWDzz9++z6o6GC3Fe8yAjMG39VPIlSfq+bKZOmVFWGGUL2wO4k0y9ymqssbbSsAGhakOhGXYDTHZZpyHBVwFl9faNxBkc0mOoHrRNJpOVUFNONWcFeBL1w9GOh/aoRYsbkvbqaE/DAO8URv0Q3SOQze/KhlsmR+k99WV0gpV6f682100QUV84gXHDx4BVvK3k82cJi7s59SxiYuvpfsyiWtwU+NCvaeG/xVGs6XIj2Cd65Jt4d9aDcwRm5A0jzW97xOepK4biK/pRQ7IfPhlDsSroCkpiTggr+oIdQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add xswap_try_shrink() to unmap the free clusters at the tail of the
mapped range. It only reclaims when the range is at most half in use,
leaving one chunk of slack for the next allocation.

Call it from __free_cluster() after a cluster is released.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 100 +++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 94 insertions(+), 6 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 17e482059d32..2a03b13c0ed2 100644
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
 
 static int xswap_create(int prio);
 
@@ -696,6 +698,9 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
+#ifdef CONFIG_XSWAP
+	xswap_try_shrink(si);
+#endif
 }
 
 /*
@@ -1063,6 +1068,9 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 	lockdep_assert_held(&ci->lock);
 	VM_WARN_ON(!cluster_is_usable(ci, order));
 
+	/* ci is used without ci->lock; an xswap unmap waits for this. */
+	rcu_read_lock();
+
 	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
 		goto out;
 
@@ -1091,6 +1099,7 @@ static unsigned int alloc_swap_scan_cluster(struct swap_info_struct *si,
 out:
 	relocate_cluster(si, ci);
 	swap_cluster_unlock(ci);
+	rcu_read_unlock();
 	if (si->flags & SWP_SOLIDSTATE) {
 		this_cpu_write(percpu_swap_cluster.offset[order], next);
 		this_cpu_write(percpu_swap_cluster.si[order], si);
@@ -1134,6 +1143,9 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		to_scan = swap_usage_in_pages(si) / SWAPFILE_CLUSTER;
 
 	while ((ci = isolate_lock_cluster(si, &si->full_clusters))) {
+		/* As in alloc_swap_scan_cluster(). */
+		rcu_read_lock();
+
 		offset = cluster_offset(si, ci);
 		end = min(si->max, offset + SWAPFILE_CLUSTER);
 		to_scan--;
@@ -1158,6 +1170,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 			relocate_cluster(si, ci);
 
 		swap_cluster_unlock(ci);
+		rcu_read_unlock();
 		if (to_scan <= 0)
 			break;
 
@@ -1506,11 +1519,17 @@ static bool swap_alloc_fast(struct folio *folio)
 	/*
 	 * Once allocated, swap_info_struct will never be completely freed,
 	 * so checking it's liveness by get_swap_device_info is enough.
+	 *
+	 * The cached offset indexes si->cluster_info, which xswap can
+	 * unmap; cover both the read and the use with RCU.
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
@@ -1522,6 +1541,7 @@ static bool swap_alloc_fast(struct folio *folio)
 	}
 
 	put_swap_device(si);
+	rcu_read_unlock();
 	return folio_test_swapcache(folio);
 }
 
@@ -2312,8 +2332,11 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 	/*
 	 * Try the local cluster first if it matches the device. If
 	 * not, try grab a new cluster and override local cluster.
+	 *
+	 * Same RCU requirement as swap_alloc_fast().
 	 */
 	local_lock(&percpu_swap_cluster.lock);
+	rcu_read_lock();
 	pcp_si = this_cpu_read(percpu_swap_cluster.si[0]);
 	pcp_offset = this_cpu_read(percpu_swap_cluster.offset[0]);
 	if (pcp_si == si && pcp_offset) {
@@ -2323,6 +2346,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 		else
 			swap_cluster_unlock(ci);
 	}
+	rcu_read_unlock();
 	if (!offset)
 		offset = cluster_alloc_swap_entry(si, NULL);
 	local_unlock(&percpu_swap_cluster.lock);
@@ -3981,6 +4005,15 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
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
@@ -3999,6 +4032,61 @@ static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data)
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
+	if (swap_usage_in_pages(si) * 2 > nr_mapped * SWAPFILE_CLUSTER)
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


