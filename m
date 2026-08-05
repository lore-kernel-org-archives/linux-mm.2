Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52BF8C55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:55:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 754CF6B00B1; Wed,  5 Aug 2026 03:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72BD06B00B2; Wed,  5 Aug 2026 03:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 642C26B00B3; Wed,  5 Aug 2026 03:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3D1066B00B1
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:55:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CF2DF1A03E6
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:55:13 +0000 (UTC)
X-FDA: 85066455306.21.2BEC060
Received: from out-182.mta0.migadu.com (out-182.mta0.migadu.com [91.218.175.182])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1CB7718000B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:55:11 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lx78EHCd;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QdHk8BKCu5NpvOOk3FzW3mOqj3l0dtnoNHZ0kMxVMyE=;
	b=RR0mJk24kLxbXfdQsvVengxAIy188Suc9BBSUAyS8o9KBIRSynFmavfSoEeyFtgEMnWN1z
	PwrmSF2w23aP5t1yGRD1L7Rgn7WCBdN/gGucHZ5oqKBkQCAJ7XCJJW2zHNcXyPgj1H1krL
	iJ3oRiu54V2GRT/sU6W6blI/ATbDR0s=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916512;
	b=d2CgazBoDwIWCiHw3o7egujVADKljfx6bzIjf3JrWKiTCs9uStcFfRJNa/092tAT5aAjtW
	iXo71GjvFABB6Pn1U98Lrt2aXa/+Rnd0iXmmuyFrn3sKVtdd4kgW8ugZIfaELy3wVlmVsL
	6VhughG47/BcnfupPRFNxMS3SxUoZS8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Lx78EHCd;
	spf=pass (imf16.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.182 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785916510;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=QdHk8BKCu5NpvOOk3FzW3mOqj3l0dtnoNHZ0kMxVMyE=;
	b=Lx78EHCdPBRTQG/pdg90gUbgWcqQGF1jBtSYPeOk3wTe4nmTceDcudcIlIobgcmt+Ry7kx
	l08+xVJ6/nAMcNaJSQ4FKeud6Ym7IKkNj7NSuvaqm+/ufcCqNbR3386ENQDFeIfYpBZBZt
	CokuTCBgeKebSIFE6F/avpEFpWnsLHM=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	david@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <baoquan.he@linux.dev>
Subject: [RFC PATCH v2 07/10] mm, swap: add nr_free_tail for O(1) xswap shrink detection
Date: Wed,  5 Aug 2026 15:53:30 +0800
Message-ID: <20260805075336.3579395-8-baoquan.he@linux.dev>
In-Reply-To: <20260805075336.3579395-1-baoquan.he@linux.dev>
References: <20260805075336.3579395-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 33ncxrtjb4get3ctsbkjkpwza8ij5srs
X-Rspamd-Queue-Id: 1CB7718000B
X-HE-Tag: 1785916511-845252
X-HE-Meta: U2FsdGVkX19hFo2FtUPPjlmbePebgMlBhqDPFKQmH1h79+tj2y8S8JRKCJbG1kxary8BDs7Yri5mM07eVMoV3kmq5XUzHfKGgFYtfkkzIpqVrumRaS3eJln1X9Jskjq/D25nSaZo1twfP2SUgftDu1yPPreTjLEq0jfFIMDzLiRHl8dUmNBOQZR9OqS6xlKerUhGRi12pphjxFM65J/4cw0yW7t8k14p4c6j8gDVASpDgxFi6aM6Fwffd2Tyt41AQRzaIEvJTWa3jt+c55EL/nkVg0yVTfsk2O86c2rrS7WmWKDeGEjXjRnOqL6qg2Ss7kP7f4mCfXUSJAiJXkrncPnSE8wEkB5pfmFcckyLGzxamRKBSMk08ZCzctR9Vs3MsWwvz/i0L2tn5acHFNQBc0A8rSaDrobXbp9ZHYdH7TtdfS7VBpVQhTHdPRK7Q+zYLES5wYLJnm70MWO4MjcxgoDA8+zsOudOESmTTsGHO6KeSMGbMZEU080sLgamjIqguS4uwTUzUtJQsqvOjQIzkmZ5TcMyxrD9+xIuKDrUzUYUpPewKCLtQA+6XfhVHzaa8iDqBDwu/PesDBlTWK8bX+J5rQP6OyvedxHkjnnoaO6YccsyJLMFhvW54r3wJuHEXtx5Ml0z/3/xkhJPNkKdkHXOthWgawWMpJCWxAYrxvBD/ow8ZuG9Y+6zwrm/SWZ0ye+EGeZmZs9VmCav7EXMtEp/Fz55XOWkqbx5HQkW++qnGRTqMxuvPTVMSV8ON1PC6BG1ks6QP0tWQKDyIwWxfdDrwENOA9eRmUhwKSdX+5nF+SfSySQmkvbMwQgy7JpioHAQAekeTgIpbHDGFSyGZ1hfLMmgUSO9HeSQl6PhxYp9D8OmAqAPG7YB/e0lShXWlEK7I8rfihzGnRCIXz7Fp+CorU0qROmVh5rl1K3k+4G6YnQ9+pdTg/fJ3WBnCqWlpFrsNJhzqaneZvHLgIB
 Rvxg4zVk
 aL6hpz7kstWdtnJ+R9hw1OjN0CDfY1wSDbMVLMlYF0fSTFlnStwlQcd7EFMQOfXDdadLsTax9/6SCE6Ao9LRIkA6kVXrjLbpcgICcaK0/0N8MhBokZkPR4Wd4A2y7CU6snl/S9pmdJmPvjIYan8cDwbyPVM7H6mRw4NkxprJcNjZBCyIG8G3d4yhi9qp2CrNbjQykrI5REBfWO6gLzxuvRn7bZZkS9hIS88+NudCrnI/KgIzjegkSN2uslrFZyOFp5QBzxeYJ9WYOvO5+0ft8MCHOARROt01BjH9xGtKviE+Rh/taMb6v+At+pzD66LWVfiNfDNqE+779GMPa9OGa11cY/g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Track contiguous free clusters at the tail of the mapped range in
si->nr_free_tail, maintained across alloc/free/grow paths.  This
eliminates the backwards scan on every shrink check.

Three paths maintain the counter:

1. xswap_update_free_tail(): called on cluster free.  If the freed
   cluster is adjacent to the existing tail boundary, increment and
   extend backwards to include already-free clusters now connected.

2. xswap_trim_free_tail(): called on cluster allocation.  If the
   allocated cluster lies within the tail free region, truncate the
   count to end just before it.

3. Grow path: nr_free_tail += nr_new — all newly mapped clusters
   are immediately free.

xswap_try_shrink() simplifies to a threshold check:
  if nr_free_tail >= XSWAP_GROW_CLUSTERS → unmap

Setup initializes nr_free_tail = nr_clusters_mapped - 1 (all but
cluster 0 are free at the tail).

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |   1 +
 mm/swapfile.c        | 121 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 105 insertions(+), 17 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 536b0e989c48..72b28116ed0f 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -252,6 +252,7 @@ struct swap_info_struct {
 	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for xswap dynamic cluster_info */
 	unsigned long		nr_clusters;	/* total cluster count for xswap */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+	unsigned long		nr_free_tail;	/* contiguous free clusters at tail */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
 #endif
 	struct list_head free_clusters; /* free clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index c43c8746378e..3f536495b8cf 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -68,6 +68,9 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr);
 static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data);
+static void xswap_trim_free_tail(struct swap_info_struct *si, unsigned long idx);
+static void xswap_update_free_tail(struct swap_info_struct *si,
+				    unsigned long freed_idx);
 static void xswap_try_shrink(struct swap_info_struct *si);
 #endif
 
@@ -633,6 +636,7 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
 #ifdef CONFIG_XSWAP
+	xswap_update_free_tail(si, ci - si->cluster_info);
 	xswap_try_shrink(si);
 #endif
 }
@@ -981,6 +985,9 @@ static bool __swap_cluster_alloc_entries(struct swap_info_struct *si,
 	if (cluster_is_empty(ci))
 		ci->order = order;
 	ci->count += nr_pages;
+#ifdef CONFIG_XSWAP
+	xswap_trim_free_tail(si, cluster_index(si, ci));
+#endif
 	swap_range_alloc(si, nr_pages);
 
 	return true;
@@ -1246,6 +1253,8 @@ static unsigned long cluster_alloc_swap_entry(struct swap_info_struct *si,
 				spin_unlock(&ci->lock);
 			}
 			spin_unlock(&si->lock);
+			WRITE_ONCE(si->nr_free_tail,
+				   READ_ONCE(si->nr_free_tail) + nr_new);
 
 			/* Retry allocation from the free list */
 			found = alloc_swap_scan_list(si, &si->free_clusters,
@@ -3883,37 +3892,115 @@ static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data)
 }
 
 /*
- * Try to shrink the cluster_info tail: unmap contiguous free clusters
- * at the end of the mapped range.
+ * Maintain si->nr_free_tail, the number of contiguous free clusters at
+ * the tail of the mapped range.  Called when a cluster at @freed_idx is
+ * freed.  Provides O(1) shrink detection: if nr_free_tail is non-zero,
+ * the tail can be unmapped without scanning cluster_info[].
+ *
+ * Only increments when @freed_idx is the cluster immediately before the
+ * existing tail region.  Then scans backwards for already-free clusters
+ * now connected to the tail, bounded by XSWAP_GROW_CLUSTERS at a time.
  */
-static void xswap_try_shrink(struct swap_info_struct *si)
+static void xswap_update_free_tail(struct swap_info_struct *si,
+				   unsigned long freed_idx)
 {
+	unsigned long nr_mapped, nr_tail, tid, i;
 	struct swap_cluster_info *ci;
-	unsigned long last, idx;
 
 	if (!(si->flags & SWP_XSWAP))
 		return;
-	if (READ_ONCE(si->nr_clusters_mapped) <= 1) /* keep cluster 0 */
+
+	nr_mapped = READ_ONCE(si->nr_clusters_mapped);
+	nr_tail = READ_ONCE(si->nr_free_tail);
+
+	/* Protect against concurrent shrink that races past us */
+	if (nr_tail >= nr_mapped)
 		return;
 
-	/* Find the last non-free cluster from the tail */
-	last = READ_ONCE(si->nr_clusters_mapped);
-	while (last > 1) {
-		idx = last - 1;
-		ci = &si->cluster_info[idx];
-		if (ci->count || ci->flags != CLUSTER_FLAG_FREE)
+	tid = nr_mapped - nr_tail - 1;
+
+	/* Only the cluster immediately before the tail region counts */
+	if (freed_idx != tid)
+		return;
+
+	nr_tail++;
+	WRITE_ONCE(si->nr_free_tail, nr_tail);
+
+	/* Extend: include already-free clusters now connected to the tail */
+	for (i = 1; i < XSWAP_GROW_CLUSTERS; i++) {
+		nr_mapped = READ_ONCE(si->nr_clusters_mapped);
+		nr_tail = READ_ONCE(si->nr_free_tail);
+		if (nr_tail >= nr_mapped - 1)
+			break; /* reached cluster 0 */
+		tid = nr_mapped - nr_tail - 1;
+		ci = &si->cluster_info[tid];
+
+		if (READ_ONCE(ci->count) ||
+		    READ_ONCE(ci->flags) != CLUSTER_FLAG_FREE)
 			break;
-		last = idx;
+		nr_tail++;
+		WRITE_ONCE(si->nr_free_tail, nr_tail);
 	}
+}
+
+/*
+ * Trim si->nr_free_tail when a cluster in the tail region is allocated.
+ * @idx: index of the cluster being allocated.
+ */
+static void xswap_trim_free_tail(struct swap_info_struct *si, unsigned long idx)
+{
+	unsigned long nr_mapped, nr_tail, tail_start;
 
-	if (last == si->nr_clusters_mapped)
-		return; /* nothing to shrink */
+	if (!(si->flags & SWP_XSWAP))
+		return;
+
+	/*
+	 * nr_clusters_mapped and nr_free_tail are read locklessly;
+	 * concurrent updates may cause nr_free_tail to be trimmed
+	 * slightly less than ideally, which is harmless.
+	 */
+	nr_mapped = READ_ONCE(si->nr_clusters_mapped);
+	nr_tail = READ_ONCE(si->nr_free_tail);
+	tail_start = nr_mapped - nr_tail;
+	if (idx >= tail_start)
+		WRITE_ONCE(si->nr_free_tail, nr_mapped - idx - 1);
+}
+
+/*
+ * Try to shrink the cluster_info tail.  Uses si->nr_free_tail which
+ * is maintained incrementally during alloc/free — no scanning needed.
+ */
+static void xswap_try_shrink(struct swap_info_struct *si)
+{
+	unsigned long start_idx, nr_unmap, i;
+	struct swap_cluster_info *ci;
+
+	if (!(si->flags & SWP_XSWAP))
+		return;
+	if (si->nr_free_tail < XSWAP_GROW_CLUSTERS)
+		return;
+
+	nr_unmap = round_down(si->nr_free_tail, XSWAP_GROW_CLUSTERS);
+	start_idx = si->nr_clusters_mapped - nr_unmap;
+
+	/* Verify the tail clusters are still free before unmapping */
+	spin_lock(&si->lock);
+	for (i = start_idx; i < si->nr_clusters_mapped; i++) {
+		ci = &si->cluster_info[i];
+		if (ci->flags != CLUSTER_FLAG_FREE) {
+			nr_unmap = i - start_idx;
+			break;
+		}
+		list_del(&ci->list);
+		ci->flags = CLUSTER_FLAG_NONE;
+	}
+	spin_unlock(&si->lock);
 
-	/* Only unmap if we can free at least one full page of clusters */
-	if (si->nr_clusters_mapped - last < XSWAP_GROW_CLUSTERS)
+	if (nr_unmap < XSWAP_GROW_CLUSTERS)
 		return;
 
-	xswap_unmap_clusters(si, last, si->nr_clusters_mapped - last);
+	xswap_unmap_clusters(si, start_idx, nr_unmap);
+	si->nr_free_tail -= nr_unmap;
 }
 #endif /* CONFIG_XSWAP */
 
-- 
2.54.0


