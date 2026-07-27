Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DCF84C531D0
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:06:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6B206B00A2; Mon, 27 Jul 2026 10:06:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E423D6B00A3; Mon, 27 Jul 2026 10:06:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D587C6B00A4; Mon, 27 Jul 2026 10:06:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A7BD76B00A2
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:06:19 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 420B0A0C77
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:06:19 +0000 (UTC)
X-FDA: 85034731278.07.C8D5F79
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf07.hostedemail.com (Postfix) with ESMTP id 91E9840003
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:06:17 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YSf0wg8G;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785161177;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tqDbK6CJSBnLZepItoJSDUUPFnDsTd1FSpaExW/0GVI=;
	b=tQQD3vTWf/EpZtzaJkDKPiKU0/k17TmJpjvfSjsaUtn5UWVbMQzeDSnAsGv5rONAT6h6vh
	kaWti6CKLUngb6mkM6fe+tpXgkbWz3GCppA+MFpIVPie/f2pK3G3FPZebqrTxBQYQjPst7
	AwNypbrC10k4v6UdEsUNYMbuwynlpkw=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=YSf0wg8G;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785161177;
	b=EVPe4ytYE9MTH96vyQmo+wSHsEUD2BjqmNHM5gHB646lMiOO5R6bO6vfV5DhHUp+yyp8mK
	Ma4ig+k4H0lrvNNC/4D/pXzgziuKXFnz20UkbsRCVcLR+IHHIBS7KBf1ABRsc0MuBtx1vX
	OCHk0vuTfqcG3UTzlf7Icy7JppZF4YM=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785161175;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tqDbK6CJSBnLZepItoJSDUUPFnDsTd1FSpaExW/0GVI=;
	b=YSf0wg8Gtp5CY2uIcW9MJ6XrW9NGsNQAvtLiBumu44EX15gPO6sSnQlRQ1zLHJA0VHrjG8
	XJHq+gKGOS/VqFfQcTxX9B58ahpZAcy79FRu04YY6CaCuPY9s2qrVnygshD0KXyr09Fgua
	sK1b/nPtIl28xXXyTbJh0hq3K7+V63w=
From: Baoquan He <baoquan.he@linux.dev>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	chrisl@kernel.org,
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
Subject: [RFC PATCH 07/11] mm, swap: add nr_free_tail for O(1) xswap shrink detection
Date: Mon, 27 Jul 2026 22:04:58 +0800
Message-ID: <20260727140503.1060918-6-baoquan.he@linux.dev>
In-Reply-To: <20260727140503.1060918-1-baoquan.he@linux.dev>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 91E9840003
X-Stat-Signature: jxcjqic9o4s7ts4cw8obymt9147xqehr
X-HE-Tag: 1785161177-662418
X-HE-Meta: U2FsdGVkX19+++19SNXzjvoxSmEGqmXBT00X1HXgce8bMJ8/MI6JTrWqFacpuwdgPggf4mLHfZre7IFZaUQGrTPcrtQuDGK//4hFbVyykB9c37XLv0QxCXOnSMDBs06wQa5r3uOa7ONa3BUNAEjVXZVq2TcsV4VXj0ikDcXIOCeG/ylzs1VZf413cWWEA0N/MRghbBP0ULBFAFlA5mNhtSkZ0VnxsCZKduN36EppQT8AcEuLkpsguS/ktgbwPGBXZ89CK1PQxNJ+tPqcVIf/tlmSqJR/EPnOQGoLe+pXpOPr82bPxu7zkjHZVZzOXqvw5PDprtBP4sVH5wSsurul9NvE0Oq+hdu/fl+JNBCNrvgJw+O9+zThSEF+sSgUT8B/Z4OxUg7QipJ1zHKfbg0Qx0FIifYL2bXBJrHrApF6FhkZ2Ml5GF0wQ5X2vZcmtSBw+SGGH6uF3HWs73hmXAWOOLZtjL27GxzHE30yxmyi/FnQPPKxUdVBCuNeZujStAie1TnmWht44nWPnEbyXkSA+0UuVd7zdItsekuB4ebg6U9RfsQGEDeZg+LDv3fBYxrd7m3LcMp9Npt4zepJwoWGb3zhgAvFOYu2YYKrVMWWOtbJFjNA6slZhZMihmyMf1hSHSB1hYfC6c1+6k69XceJmFfVnxeO6C41dJUdSTdGlDDiAE/WBhU312QzP38xhK0k1Z8/ZHZCdOZ/pQy0uORo0uMJP2Fosgx69lu/39+MpesGV9/zlVj+E10Ea+OYvl49vVW8mSOQHol/2yWfVbk17fQ1N3FxFRnHttiKrRr9eup5XIkj7/Q6yKVP28hpB0cKJ1vcIkLWZXiyptBvmM/+7BpEgKJp3BuwiPonj/Ug2e70/dQC9oTzWAstF7MmsUxOeBE1ds4opdyr48Fk4HMqy2wLKfEd8oINGRzlLzTCI5uZI4UAEXl6fiMWNZEemZbklOSjv0eA3EIJj9O68M2
 tT482Zq2
 jngtru/Bg7dPM1OUraQUA3tC7hGYzCyrtFfCkWtv2O/SKNDMxIwa09MguF14AKtgziNHzeSQvMvn5g3D/K/MXIrD6hx4tNNHVPWBJdEG3tU4viiX2tlOBeMIqlPIKy0yiAkMIYcGp1eyvt2ljVgbmN0s3xeWG7cceP+Gp3N8+Do6ZMwA5X+SGKvJCDsQf+NOqQ69Cn0VOCk3fnyOVAmTPVaDK8JkOyJ3ibmYIVcDcFE/UAd8I1UVLAhQ9+4NQRWSIkoiJnm0nrx4vdNISIvTlub8Ev56v/WgmCSX1PJMuVBjg93QuWhw6c8MnW8cRFV2Zj5djvmD40Ed/TEcMDUQTHwufFw==
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
index 5f6b14d30758..c54c921378ab 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -252,6 +252,7 @@ struct swap_info_struct {
 	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for xswap dynamic cluster_info */
 	unsigned long		nr_clusters;	/* total cluster count for xswap */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
+	unsigned long		nr_free_tail;	/* contiguous free clusters at tail */
 #endif
 	struct list_head free_clusters; /* free clusters list */
 	struct list_head full_clusters; /* full clusters list */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 7613ce231d70..1eb44f818b40 100644
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
@@ -3856,37 +3865,115 @@ static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data)
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


