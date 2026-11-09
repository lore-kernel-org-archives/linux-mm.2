Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09BE0606A330
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 05:57:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=Jq8yPNCy
Received: by kanga.kvack.org (Postfix)
	id 1BE7E6B05D5; Mon,  9 Nov 2026 00:57:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 196786B05D6; Mon,  9 Nov 2026 00:57:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 084DF6B05D7; Mon,  9 Nov 2026 00:57:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C22BA6B05D5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 00:57:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 51BCBA8220
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:57:20 +0000 (UTC)
X-FDA: 85414523040.30.CAB5550
Received: from mta0.migadu.com (out-207.mta0.migadu.com [91.218.175.207])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6007040004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 05:57:18 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jq8yPNCy;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.207 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794203838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Myy7ul3AvP3tdJyr+M6PtPyJqNDehW9ebn/02colSno=;
	b=NkcF6sOaI1ps1Gy86KbV/KUpqppzd2mmWwZVVmzkmBLcH/BNPM2Ptp+DriMxRn8lCeUjGV
	4T0HSj5Ji+hVove9Te0yu/2JA3A+DrdH8KEgmRslWtpJPVjBJQ3zaGdqN8pYtl7lbXwaTB
	XTZ4GebEc1GqoO3lsCW3S+60xK7GZUM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794203838;
	b=PfOzK4QelPKPZzIkEstVgPxRmUsy0hj4TrOjpCIPT/xfLcIQIX64tFB1M7gPQaPbfjS0DJ
	K51XGxTynp+uxGXyy5AjLxV8Zktv7NES9XNPzLYl1Q2cIigdJsEg4GMXRzMIVGfriFHQzp
	spLPbDA6v9MiOqjl0P3PPTnQR31LSVQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jq8yPNCy;
	spf=pass (imf12.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.207 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=NXzukIsRrbzL3pazqaEP52lmihgAGa/IMXLWPmgjRRM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794203837; v=1; x=1794808637;
 b=Jq8yPNCyZ8a+NfENfHH8VZvHdd0RgWhX71rgyLp02oYsIpJrrlgQW+2uC1kaCuk0lLYKPHe4
 tltIA/7T8IFQlyGnNNGArJ9m8SvrHD2ne0OVHo1rIspcwwsFndmJtedqitDmG2puVMqcOvsK0TT
 ZsZw7E7pTgsjaHxxNTdI5BYI=
X-Envelope-To: linux-mm@kvack.org
Received: by mta10.migadu.com with ESMTPS id 1ed13d738c14ae9d;
	Mon, 09 Nov 2026 05:57:16 +0000
X-Mizu-Trace-ID: 1ed13d738c14ae9d
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	nphamcs@gmail.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	corbet@lwn.net,
	hannes@cmpxchg.org,
	chengming.zhou@linux.dev,
	kunwu.chan@gmail.com,
	klarasmodin@gmail.com,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [PATCH v5 15/19] mm, swap: make xswap cluster_info accesses RCU-safe
Date: Mon,  9 Nov 2026 13:54:51 +0800
Message-ID: <20261109055455.536925-16-baoquan.he@linux.dev>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261109055455.536925-1-baoquan.he@linux.dev>
References: <20261109055455.536925-1-baoquan.he@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 6007040004
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: qjf94go6mw69jyfkcmsanxzotz8t1sgt
X-Rspam-User: 
X-HE-Tag: 1794203838-491415
X-HE-Meta: U2FsdGVkX1+nKiNkFeL1C28oQ6P7olS4VESO/jm83qAr96mo5ssWuGPffIQzYQ8JhzFxXAsIMii+wGYoTOtPd9JHUp1mPKF2BZUzpp3cmvbizlO27jwNwbPo3Xc/bfZ6W/c/9eTvoc3CFgHnmWBrH3yHoKdDg8wVBQpoRsNXHy4pOhHc/TW1ah6Wjn6eMGG6b8gR8i2WaYYReidvyKKKG9tOan5H90GIuxQDRF8x65jn7wpA17vt5M78sc3yZGeBXhjkMMsv+dJBJfNoZztwJYEIhjrjt5INH8RsBcP4S4cDEk0dYDUq4Jg+t973hQGKmXcxZfPQ5sUvtjcX04aQ5DBLb0hmZKN+s9z9fGd87MHZS0v3lAoyNUyKe504hu7jUzjxFE+jqGzK6HCTuXkm7qYy/BkTkCKJ8jaCY8aJ2Et5FvMHO/QwnA/zO+HztvOMfYMKSLArrEVD9azL9qMPjvIrGkHyaTGUC96gL2cIIMuz6NgoEQmd96E8kL/547qCdkUYD+/Ny/nncvu2Z/3sZlDi04kjVywM8WysLb9sZeYOk3VKK0rmHj86od2Xet4pK7a0la3iPS1f/hwAHNJrwQ6Ul5ZDyiq7jtGw31H8ewyk7TTZXeh85u41Kb4m8a8O7lKig16Ur4VkPJgxt9Byvvn1779IA2aKOAmrd7rNHTNOt2qLY5HzVQWFwZKFhVFjZNrjJmJRcEak0HNw4j/s1qrDVLtS4kRKWWQRDud+oa7iUSyRyW97Wpc4C4Deb0VuPAAJpCxhaiN1mx7Lc5pfo+2wkzLpqmZNFDJ+IOBugz0WCLeul3k0XDoWbz7HZoBOKSv/M8n6PIYR0bJM5saX/Dtl0aEaHc+TWYnDQFEwf86iW1uhz3H0z9WZhhHhQMXf7G8S7/MqsgoMLZuLyAW1BLGYD6Wxrg4ebHStLgyRkONKdXUa4Ghkt/px3bnnQuIBg/rzg8tvTlayiSCuxva
 JdnL27gU
 2fdqmvQyN3p7xznJPeh4xkplt0yTXf7QuvJyyK1GPPIpX5Iekq/hbHYdGMmKVTTrUGAbhViKYB/oUmAIj7+mRf1jP6HiBZDrUb5dQKdBG9aajQg75m8RVf9RhyK51KxIJXSfseQ/sur/7uz912Vm0zaZxi6+CtKxrNDhcXARIXWjK7Gh0AHwc6mDb6JrDG5IkKTT0mRacIM8QHnRzaPGg8EgqfVIvYAZl1woKGL7WtP0ZZQ1JOIvTbxSqGUAX6SGHPL2TY+EyrB1odJbXDSMuwVSRe6k/f0dODAf30ueOd60U9BYGO8xbtQ3zT/RPkO5NNJF4wvzhi/b0CaaidTtqmVH/Jb8t+3paP0z6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Baoquan He <hebaoquan@kylinos.cn>

An xswap cluster_info page can be unmapped at runtime.  The shrink path
that does this is added by a later patch; this patch establishes the
contract it relies on.  The allocation and reclaim paths drop ci->lock
to reclaim swap cache, then take it again; in that window the cluster
can be freed and its cluster_info page can go away.  Cover the whole
read/drop/reacquire window with RCU, so the cluster pointer stays valid
until the lock is taken again.

Also take RCU in swap_alloc_fast() and the hibernation slot allocation
path, which read cluster_info through a cached offset without holding
ci->lock.  A cached offset can outlive a shrink that did not see it, so
swap_alloc_fast() now loads nr_clusters_mapped with smp_load_acquire()
and fails the fast path when the offset is beyond it.

On the writer side, xswap_unmap_clusters() publishes the smaller range
with smp_store_release() before the memory goes away, invalidates the
per-cpu cluster cache, and waits one RCU grace period.  A reader that
already loaded a cached offset is then either seen by the cache flush or
waited out before the PTEs are cleared.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 82 +++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 73 insertions(+), 9 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 2624233b4fc2..bc30ab42203c 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1239,6 +1239,9 @@ static unsigned long alloc_swap_scan_cluster(struct swap_info_struct *si,
 	lockdep_assert_held(&ci->lock);
 	VM_WARN_ON(!cluster_is_usable(ci, order));
 
+	/* ci is used without ci->lock; an xswap unmap waits for this. */
+	rcu_read_lock();
+
 	if (end < nr_pages || ci->count + nr_pages > SWAPFILE_CLUSTER)
 		goto out;
 
@@ -1267,6 +1270,7 @@ static unsigned long alloc_swap_scan_cluster(struct swap_info_struct *si,
 out:
 	relocate_cluster(si, ci);
 	swap_cluster_unlock(ci);
+	rcu_read_unlock();
 	if (si->flags & SWP_SOLIDSTATE) {
 		this_cpu_write(percpu_swap_cluster.offset[order], next);
 		this_cpu_write(percpu_swap_cluster.si[order], si);
@@ -1310,6 +1314,9 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 		to_scan = swap_usage_in_pages(si) / SWAPFILE_CLUSTER;
 
 	while ((ci = isolate_lock_cluster(si, &si->full_clusters))) {
+		/* As in alloc_swap_scan_cluster(). */
+		rcu_read_lock();
+
 		offset = cluster_offset(si, ci);
 		end = min(si->max, offset + SWAPFILE_CLUSTER);
 		to_scan--;
@@ -1334,6 +1341,7 @@ static void swap_reclaim_full_clusters(struct swap_info_struct *si, bool force)
 			relocate_cluster(si, ci);
 
 		swap_cluster_unlock(ci);
+		rcu_read_unlock();
 		if (to_scan <= 0)
 			break;
 
@@ -1664,11 +1672,36 @@ static bool swap_alloc_fast(struct folio *folio)
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
+#ifdef CONFIG_XSWAP
+	if (si->flags & SWP_XSWAP) {
+		/*
+		 * The cached offset can outlive a shrink that did not see
+		 * it, and the cluster_info page it indexes may be unmapped.
+		 * Fail the fast path; the slow path picks a live cluster.
+		 */
+		unsigned long mapped;
+
+		/* Pairs with the release store in xswap_unmap_clusters(). */
+		mapped = smp_load_acquire(&si->nr_clusters_mapped);
+
+		if (offset / SWAPFILE_CLUSTER >= mapped) {
+			put_swap_device(si);
+			rcu_read_unlock();
+			return false;
+		}
+	}
+#endif
 
 	ci = swap_cluster_lock(si, offset);
 	if (cluster_is_usable(ci, order)) {
@@ -1680,6 +1713,7 @@ static bool swap_alloc_fast(struct folio *folio)
 	}
 
 	put_swap_device(si);
+	rcu_read_unlock();
 	return folio_test_swapcache(folio);
 }
 
@@ -2472,8 +2506,11 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
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
@@ -2483,6 +2520,7 @@ swp_entry_t swap_alloc_hibernation_slot(int type)
 		else
 			swap_cluster_unlock(ci);
 	}
+	rcu_read_unlock();
 	if (!offset)
 		offset = cluster_alloc_swap_entry(si, NULL);
 	local_unlock(&percpu_swap_cluster.lock);
@@ -3445,7 +3483,13 @@ static void wait_for_allocation(struct swap_info_struct *si)
 
 #ifdef CONFIG_XSWAP
 	if (si->flags & SWP_XSWAP) {
-		/* Pairs with the smp_store_release() in xswap_map_clusters(). */
+		/*
+		 * Pairs with the smp_store_release() in xswap_map_clusters().
+		 * A grow may publish after this read, but no slot comes from
+		 * those clusters once WRITEOK is clear.  Cached clusters are
+		 * inside the range; try_to_unuse()'s rescan catches any slot
+		 * taken after the walk.
+		 */
 		end = min(end, smp_load_acquire(&si->nr_clusters_mapped) *
 			  SWAPFILE_CLUSTER);
 	}
@@ -3527,9 +3571,9 @@ static void flush_percpu_swap_cluster(struct swap_info_struct *si)
 	for_each_possible_cpu(cpu) {
 		pcp_si = per_cpu_ptr(percpu_swap_cluster.si, cpu);
 		/*
-		 * Invalidate the percpu swap cluster cache, si->users
-		 * is dead, so no new user will point to it, just flush
-		 * any existing user.
+		 * Invalidate the per-cpu swap cluster cache.  Any reader that
+		 * has already loaded an entry is waited out by the caller's
+		 * synchronize_rcu().
 		 */
 		for (i = 0; i < SWAP_NR_ORDERS; i++)
 			cmpxchg(&pcp_si[i], si, NULL);
@@ -4289,12 +4333,33 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 
 	mutex_lock(&si->xswap_lock);
 
+	/*
+	 * Publish the smaller range before its memory goes away.  Readers
+	 * that use nr_clusters_mapped without xswap_lock pair with this
+	 * store using smp_load_acquire().
+	 */
+	smp_store_release(&si->nr_clusters_mapped, start_idx);
+
 	if (vm_start >= vm_end) {
-		WRITE_ONCE(si->nr_clusters_mapped, start_idx);
+		/*
+		 * The clusters sit inside one page that the preceding
+		 * cluster shares, so there is nothing to unmap.  The page
+		 * goes away with that cluster; publishing the smaller
+		 * cluster count is still correct.
+		 */
 		mutex_unlock(&si->xswap_lock);
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
 	npages = (vm_end - vm_start) >> PAGE_SHIFT;
 
 	if (npages <= totalram_pages()) {
@@ -4306,7 +4371,7 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 		if (pages) {
 			xswap_unmap_range(si, vm_start, vm_end, pages, npages);
 			kvfree(pages);
-			goto out_store;
+			goto out_unlock;
 		}
 	}
 
@@ -4325,8 +4390,7 @@ static void xswap_unmap_clusters(struct swap_info_struct *si,
 			xswap_unmap_range(si, bstart, bend, batch_pages,
 					  ARRAY_SIZE(batch_pages));
 	}
-out_store:
-	WRITE_ONCE(si->nr_clusters_mapped, start_idx);
+out_unlock:
 	mutex_unlock(&si->xswap_lock);
 }
 
-- 
2.54.0


