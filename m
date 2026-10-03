Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDD19CA5FE3
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 00:32:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B974F6B00B3; Fri,  2 Oct 2026 20:32:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6E666B00B4; Fri,  2 Oct 2026 20:32:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A5CDC6B00BB; Fri,  2 Oct 2026 20:32:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67F496B00B3
	for <linux-mm@kvack.org>; Fri,  2 Oct 2026 20:32:48 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA5C516060C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:32:47 +0000 (UTC)
X-FDA: 85279439574.21.0DA050E
Received: from mta1.migadu.com (out-190.mta1.migadu.com [95.215.58.190])
	by imf17.hostedemail.com (Postfix) with ESMTP id D712F4000B
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 00:32:45 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790987566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tPWxd43pgSFWOwQoMBzZJewbLv7LgM9iM286t4dNXco=;
	b=aB/UL8BAHRPWZm+n2WDDBn35m5iAXd3E/xaRyY6Wx4LyrugXihEA9SgrhFVSsFfVzvQ0p3
	XrqoxnbS/nErYKSEyN5AiSaau1zBQ2mRRo7+wK4pKvJE0cMp3kaAP7lhP+zPy1iHkm4T3G
	8JdD63CUhd3bFRm4Vn0IIILNe0vpLRQ=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.190 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790987566;
	b=wQvcp1NLOZBFpg2eLA0pQkJ4VNcwqgxBpWaOYqQGgFhg7K7MV5wKQ/IV1wJ4N8NHdj0Oyk
	4ZB7Du8y0v9NV8TLgNw85PrTML0SYwZJRMGn74vZr/bN9C2htfvNgiXfs4PwGLoVJS9qO0
	aqP+RLK2tX7EiI/GbA+LUqRYp1g5jJc=
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id a6b9ee29fbbfe81c;
	Sat, 03 Oct 2026 00:32:44 +0000
X-Mizu-Trace-ID: a6b9ee29fbbfe81c
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	david@kernel.org,
	linux-kernel@vger.kernel.org,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v4 08/14] mm, swap: defer xswap shrink to workqueue to avoid lock recursion
Date: Sat,  3 Oct 2026 08:31:30 +0800
Message-ID: <20261003003136.750633-9-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261003003136.750633-1-hebaoquan@kylinos.cn>
References: <20261003003136.750633-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D712F4000B
X-Rspam-User: 
X-Stat-Signature: a11tacc6j9i81u669ohytnrkimgrc8t7
X-HE-Tag: 1790987565-575842
X-HE-Meta: U2FsdGVkX19HcpQG4dSkSL3ZbMAVUYsoZymSnx3gNjouoHBlO+SdT9zKteQT01QhyNd1OpUaq2QmP09w/P/nXQSAeB2st/jdONOSOTKhFwxXyuCdeKSRFeF6h19gc3IE+cAcVKdHgPhgDNqx1KeuXZK1wZX8fObbk6xXVh1IYc1GgdhxyD1BqiCabS+/WdiD5+3n7wUUX4/yD3hKeNKilIXVjvNp6wnVOcgMm1eDzA7YNQse8cfuAuh2COaRAz4NvpaDpjouCw3WZnAZi6Kj3/gKcOkfAWTSeVB8SDDUBjC/lbgALiv+kmqz0gohFHiCaKDLpJygLB6Qf6zE8mMg2K2SMzE93r4ZhxxctY9uGYPa8/x2Cl5XZwSUdGJsgY71GJhlEZLWoeMTkpmJgaVNqZeSlMoD0OKQF65HiZSJjR6tfSDUWLSDff47dSaYLCv84vFHhs9BglqPBvD4yr36atjWhgSldTdsyVNdWgMRsjY8vvOh7Klavift1hnJDhdH+ewInv8HMd52u1uAhJKXPT1dFCOwjfF543qFmFk6tDRJGlhOvV1DN5rZRuxJvaOop6TQTADRodn5/EqqsDvJTQ3nuIot37TQsfYb6xP/k0tje0ffN9f8ME78JhOrs/ubzJ5yBKIGOXbRSAtM8+6yq5FrFuQOz5xBEU4mdEiBN7G/dK+iP2pEOrwyo9BtU6BzZ6RUMfqkzBSp6htd3QbiivGbAK0ESSc0QqGTeBq0+5O6H9tmNv77lpqdnP3XD1FCAHBOLzR4q4Ovm+RRTC78dDmjYIHsLzNUuUqn9SrDn14+rH0xbsVOWM/mW+rBe5xhsPP7aXmiqhQ+UIkcqc/omAPCVpmKBd6R3eI8sBqJi1Sw3ES0uNzxqs5OvDAzWAopiGArZupqa/wfAwdGrUlpubFcN6PeypytehKs2ndw7qIaDKTzHZH3UABW63ftC+KhRCmVvofYRn85At8FEAu
 8+9tT+jn
 w7/xI/wsuabUTV7EgdEPp+J6TQKnqpdBiLVTIZDeUnVVK1jriB7sj32CtkKCXjX8cZUGvkPcgNFFIIB4l3qTBVWl3A16oeoRI8oj3zJAAszMBE6imUGBO+PgytPIEi+xEVAuLHsKIQELS4a+iqxYVMf1B1rdy2SMi2vsq66fgdAGaqHS5RbOMXNR5lptnpVU/MMkS0/7tlnZ4806blpZB2cEhIC2FLq6DXBeJND9BF4oLiFJv0YhdSkS0c6BEodsxikbLHg20qRV5Lih1nYW+mBPb7TQKi+It2Uf02J7ffWTKs24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__free_cluster() called xswap_try_shrink() while holding ci->lock, but
shrinking unmaps the backing pages and the subsequent unlock faults on
the unmapped address. Run the shrink via schedule_work() instead, so no
cluster lock is held. The work is only scheduled for xswap devices and
is cancelled on swapoff.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |   1 +
 mm/swapfile.c        | 129 ++++++++++++++++++++++++++++++++-----------
 2 files changed, 97 insertions(+), 33 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 382a578140b5..12cdc00f78f9 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -246,6 +246,7 @@ struct swap_info_struct {
 	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for cluster_info */
 	unsigned long		nr_clusters_max;/* total clusters in the xswap address space */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+	struct work_struct	xswap_shrink_work; /* deferred shrink trigger */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
 #endif
 	struct list_head free_clusters; /* free clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7c062e772f5b..49703731ffd5 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -727,7 +727,9 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
 #ifdef CONFIG_XSWAP
-	xswap_try_shrink(si);
+	/* Only xswap devices, and not while the device is being torn down. */
+	if ((si->flags & SWP_XSWAP) && (si->flags & SWP_WRITEOK))
+		schedule_work(&si->xswap_shrink_work);
 #endif
 }
 
@@ -3334,6 +3336,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 	if (si->flags & SWP_XSWAP) {
 		unsigned long nr_mapped;
 
+		cancel_work_sync(&si->xswap_shrink_work);
 		/*
 		 * Cluster 0 keeps the bad header slot, so it never empties
 		 * and __free_cluster() never frees its table.
@@ -3452,6 +3455,11 @@ SYSCALL_DEFINE1(swapoff, const char __user *, specialfile)
 	spin_unlock(&p->lock);
 	spin_unlock(&swap_lock);
 
+#ifdef CONFIG_XSWAP
+	if (p->flags & SWP_XSWAP)
+		cancel_work_sync(&p->xswap_shrink_work);
+#endif
+
 	wait_for_allocation(p);
 
 	set_current_oom_origin();
@@ -4074,8 +4082,9 @@ static void xswap_unmap_range(struct swap_info_struct *si,
 		__free_page(pages[i]);
 }
 
-static void xswap_unmap_clusters(struct swap_info_struct *si,
-				 unsigned long start_idx, unsigned long nr)
+/* Caller must hold si->xswap_lock.  Cannot fail. */
+static void xswap_unmap_clusters_locked(struct swap_info_struct *si,
+					unsigned long start_idx, unsigned long nr)
 {
 	unsigned long start_addr = (unsigned long)si->cluster_info +
 				   (size_t)start_idx * sizeof(struct swap_cluster_info);
@@ -4087,11 +4096,9 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 	unsigned int noreclaim_flags;
 	unsigned long npages, idx;
 
-	mutex_lock(&si->xswap_lock);
-
 	if (vm_start >= vm_end) {
 		WRITE_ONCE(si->nr_clusters_mapped, start_idx);
-		goto out_unlock;
+		return;
 	}
 
 	/*
@@ -4113,7 +4120,7 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 		xswap_unmap_range(si, vm_start, vm_end, pages, npages);
 		kvfree(pages);
 		WRITE_ONCE(si->nr_clusters_mapped, start_idx);
-		goto out_unlock;
+		return;
 	}
 
 	/* No memory for the array: unmap in bounded batches instead. */
@@ -4133,7 +4140,13 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 	}
 
 	WRITE_ONCE(si->nr_clusters_mapped, start_idx);
-out_unlock:
+}
+
+static void xswap_unmap_clusters(struct swap_info_struct *si,
+				 unsigned long start_idx, unsigned long nr)
+{
+	mutex_lock(&si->xswap_lock);
+	xswap_unmap_clusters_locked(si, start_idx, nr);
 	mutex_unlock(&si->xswap_lock);
 }
 
@@ -4157,6 +4170,16 @@ static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data)
 #define XSWAP_SHRINK_SLACK	XSWAP_GROW_CLUSTERS
 #define XSWAP_SHRINK_MIN	(XSWAP_GROW_CLUSTERS * 8)
 
+static void xswap_shrink_work_fn(struct work_struct *work)
+{
+	struct swap_info_struct *si = container_of(work,
+			struct swap_info_struct, xswap_shrink_work);
+
+	if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
+		return;
+	xswap_try_shrink(si);
+}
+
 /*
  * Try to shrink the cluster_info tail: unmap contiguous free clusters
  * at the end of the mapped range.
@@ -4164,14 +4187,20 @@ static int xswap_mapped_end(pte_t *pte, unsigned long addr, void *data)
 static void xswap_try_shrink(struct swap_info_struct *si)
 {
 	struct swap_cluster_info *ci;
-	unsigned long nr_mapped, last, keep, idx;
+	unsigned long nr_mapped, nr_tail, keep, nr_unmap, start_idx, i;
 
 	if (!(si->flags & SWP_XSWAP))
 		return;
 
+	mutex_lock(&si->xswap_lock);
+
+	/* A swapoff raced us and is about to walk this mapping. */
+	if (!(READ_ONCE(si->flags) & SWP_WRITEOK))
+		goto out_unlock;
+
 	nr_mapped = READ_ONCE(si->nr_clusters_mapped);
-	if (nr_mapped <= 1) /* keep cluster 0 */
-		return;
+	if (nr_mapped <= 1)	/* keep cluster 0 */
+		goto out_unlock;
 
 	/*
 	 * Reclaim on our own, but only once the mapped range is at most
@@ -4181,40 +4210,73 @@ static void xswap_try_shrink(struct swap_info_struct *si)
 	 */
 	if (swap_usage_in_pages(si) * 100 >
 	    nr_mapped * SWAPFILE_CLUSTER * XSWAP_SHRINK_WHEN)
-		return;
+		goto out_unlock;
 
-	/* Find the last non-free cluster from the tail */
-	last = nr_mapped;
-	while (last > 1) {
-		idx = last - 1;
-		ci = &si->cluster_info[idx];
-		if (ci->count || ci->flags != CLUSTER_FLAG_FREE)
+	/*
+	 * Count the free clusters at the tail of the mapped range.  Scanned,
+	 * not tracked: the count must be exact to size the unmap, and an
+	 * incremental count falls behind on out-of-order frees.
+	 */
+	nr_tail = 0;
+	while (nr_mapped - nr_tail > 1) {
+		ci = &si->cluster_info[nr_mapped - nr_tail - 1];
+		if (READ_ONCE(ci->count) ||
+		    READ_ONCE(ci->flags) != CLUSTER_FLAG_FREE)
 			break;
-		last = idx;
+		nr_tail++;
 	}
-
-	if (last == nr_mapped)
-		return; /* nothing to shrink */
-
-	/* Below `last` has to stay mapped: the free ones in between are
-	 * not part of the tail, and unmapping them orphans what is above.
-	 */
-	if (nr_mapped - last < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
-		return;
+	if (nr_tail < XSWAP_SHRINK_SLACK + XSWAP_SHRINK_MIN)
+		goto out_unlock;
 
 	/*
 	 * Stop at SHRINK_UNTIL rather than at the end of the tail, or the
-	 * range comes out full enough for the grow to be woken.
+	 * range comes out full enough for the grow to be woken.  Below the
+	 * tail everything stays mapped, and one chunk of tail with it.
 	 */
 	keep = DIV_ROUND_UP(swap_usage_in_pages(si) * 100,
 			    XSWAP_SHRINK_UNTIL * SWAPFILE_CLUSTER);
-	if (keep < last + XSWAP_SHRINK_SLACK)
-		keep = last + XSWAP_SHRINK_SLACK;
+	if (keep < nr_mapped - nr_tail + XSWAP_SHRINK_SLACK)
+		keep = nr_mapped - nr_tail + XSWAP_SHRINK_SLACK;
 
 	if (nr_mapped < keep + XSWAP_SHRINK_MIN)
-		return;
+		goto out_unlock;
+
+	nr_unmap = rounddown(nr_mapped - keep, XSWAP_GROW_CLUSTERS);
+	if (!nr_unmap)
+		goto out_unlock;
+	start_idx = nr_mapped - nr_unmap;
+
+	/*
+	 * Only shrink a run that reaches the mapped end; otherwise
+	 * truncating nr_clusters_mapped would orphan the active tail.
+	 */
+	spin_lock(&si->lock);
+	for (i = start_idx; i < nr_mapped; i++) {
+		ci = &si->cluster_info[i];
+		if (READ_ONCE(ci->flags) != CLUSTER_FLAG_FREE)
+			break;
+		if (!spin_trylock(&ci->lock)) {
+			spin_unlock(&si->lock);
+			goto out_unlock;
+		}
+		spin_unlock(&ci->lock);
+	}
+	if (i != nr_mapped) {
+		spin_unlock(&si->lock);
+		goto out_unlock;
+	}
+
+	for (i = start_idx; i < nr_mapped; i++) {
+		ci = &si->cluster_info[i];
+		list_del_init(&ci->list);
+		WRITE_ONCE(ci->flags, CLUSTER_FLAG_NONE);
+	}
+	spin_unlock(&si->lock);
 
-	xswap_unmap_clusters(si, keep, nr_mapped - keep);
+	xswap_unmap_clusters_locked(si, start_idx, nr_unmap);
+
+out_unlock:
+	mutex_unlock(&si->xswap_lock);
 }
 #endif /* CONFIG_XSWAP */
 
@@ -4278,6 +4340,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 			}
 		}
 
+		INIT_WORK(&si->xswap_shrink_work, xswap_shrink_work_fn);
 		return 0;
 
 err_unmap:
-- 
2.54.0


