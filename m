Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F146C5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:50:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14F826B027A; Thu, 13 Aug 2026 06:50:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1004F6B027B; Thu, 13 Aug 2026 06:50:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0165E6B027C; Thu, 13 Aug 2026 06:50:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D2D9C6B027A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:50:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6D273160596
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:15 +0000 (UTC)
X-FDA: 85095926790.13.AFDDB24
Received: from mta0.migadu.com (out-80.mta0.migadu.com [91.218.175.80])
	by imf07.hostedemail.com (Postfix) with ESMTP id D04C640006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:11 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.80 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618213;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=+mQ1KO1YN+fFwBZ7LGiDxqOu4uxBXYgvnGIYhY/qFUo=;
	b=qptiwd/96JKXLpSmnoYdAJVIIrz5eNp5tjJFJDiA7CC0LQgGrQiyMTQjCBR03qN+tK9tYG
	uX373YJS8hyyrSdKJK5ctA8AbWyUW3tbLFDzU4POQUKSSfcXx7wO5/a914tPtLfVQht/+P
	o3cI6B2vZUwb6XpbuXcKoAoUKZv1tOc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618213;
	b=r/IZmAY8u/E/ckWN0F8DAFysutOlq4qbd6ZeMI749Khxu/rX0/NYiG+bJvyRcVPm0Ib+Ab
	cc0la7zHvoGOr5+cY3ZnFgqJGBcJ/19k0ieqPVO6T2v2oBFB6p4yGANVTWvbHAtIHSd77R
	BcA9BcQQcHwalpzthph1FpCAP8UXbzA=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf07.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.80 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id a32477fdded2b97d;
	Thu, 13 Aug 2026 10:50:07 +0000
X-Migadu-Flow: FLOW_OUT
From: Baoquan He <hebaoquan@kylinos.cn>
To: linux-mm@kvack.org
Cc: chrisl@kernel.org,
	nphamcs@gmail.com,
	kasong@tencent.com,
	baohua@kernel.org,
	youngjun.park@lge.com,
	hannes@cmpxchg.org,
	yosry@kernel.org,
	shikemeng@huaweicloud.com,
	chengming.zhou@linux.dev,
	baoquan.he@linux.dev,
	linux-kernel@vger.kernel.org,
	Baoquan He <hebaoquan@kylinos.cn>
Subject: [RFC v3 08/15] mm, swap: add xswap_try_shrink and shrink trigger on cluster free
Date: Thu, 13 Aug 2026 18:48:47 +0800
Message-ID: <20260813104857.3450386-9-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: euu1th7dwhw6pr1rqjhyai64rs1jwms7
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D04C640006
X-HE-Tag: 1786618211-610532
X-HE-Meta: U2FsdGVkX19EftwobHi6iiOnNLe7L8Fyk49n8a9GuvgXO546blA08bvYnQQDSkotoFCORsFb9wez/pFVz75gba6XLzbai9DYNFwlk+zdL7rBEDbfzkroJd07/NgSFQ44cT9R8hvwMHZmwKFUAp2ByTnOz45yzpap4VX9N5Kj0qTYq7iffhRLhTP1YaeylnrJ39ysQYemfIxTKXmHsPW9P/4BW/zPAvLNz1hO2Y30qErlW5qY26niv5injphXeUX7qRsQPRjioNjqFko4gfKekCkp5j2XbCwTjH8k2Yr0QE6XWBM4K8DiVb2TmweJQqRMxP5U1bsEumv1KVfGgSpDLJptQYUQfMZlMkkrPudraGWwxyWiqtW5MPOrRHLz2TG74w+720eQaXZicIeDjUUn2Jvd09p2c9yP0ZDANml/gbWHITCvTm00sxpa72KuMtO6zllW2znHBx/grlxN77wRGCWfujmMJo0Tllj+tYNyh9IIGjytbpDEdSZJ7pfrYJg5qerQI7gvWS7tMtRtWjPx7IUaIyzm2dztEqOjuQEURWO9qmxtgsDuGxze44b0EFA5W/K9rN0VKN6OL6dh9Qzww+XJDyzY+yi6YaCSgxWkuJH1IXYojID6iTEGwLXQfivI5nKnCqwUM5PzFHy+b2jK3CsRw3OQ5hIgQsBoXp0xUXEFoLcED7l5QtU55jvcXVWGARhBAJHz2/notl/0gWQtr7vX4fYfnjpRAnZFHaELviM2AKppy/23SUwYXT9zfUcVpV1B1LNeBNlbrKtc0HKCDLZ+fG2W3YtgPOsm1r6VGSHh/DTgkdfvUHjzuXAxuRIMQK4XvrXShVnlN8iGeTFjgqmrADY95nbk65Go7PBZchoCy5qfJTwLOY1nciu/xv2FSepdlji1CEO92vrZE7WAyE6pZmqk7Swo3dvhICcTq5hpLAnKdoiDeMEPoN6jxc34FncCbLPNGMImwG2IGd7
 qDbuakJE
 UvqsyhTSkbFF3SlDv4JpYQdYWq4cVGydHbUh9MPgr6MrQw5sfF+HJM78jFUcweJayHA8fmRcLO5Y8UTNu065wdQGhsQ52ba4OhNMkMGbsxw3LcMOXrE6n39yulK8kYpyDiy+YdLOpaz6gj6Uz+yOcmJASjRyN26fjC1tJoePaljthXPL587xrYDRK5Ay6rf7lOL+HrTBNO1Hh3NE3JdLSHi14gR145WKfc6aFBs35qa+T07MM3fW1OUKXY0N8Yzqc+nu9c+ggVHwf+sYZhOgtSo3KeMamQqOx+0RgdMGA51VkFbtJrEAyqR3/F7miuGUdBR61mzAMVcRe6+Zb1p50DRIFX2o8vTDLFlXeghRJfyX45X6mYIw55D+8RMJ6vxpSq4g/FCEkZv8BkE4Itat+QC2gT3AClzckpQL380tmFzph5ot6sUOYX4csoKvAgnMGyG+qqiiLoKW44kcfNFGFBb90NWIRUOQT40+iFCtTcMezxevAE6FK0hersAgph+1zdd+X
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add xswap_try_shrink() — the shrink logic that scans backwards from
the tail to find contiguous free clusters, then unmaps full pages
when >= XSWAP_GROW_CLUSTERS free clusters accumulate.

Wire the trigger in __free_cluster(): after a cluster is released to
the free list, call xswap_try_shrink() to attempt tail shrinking.
Also update the XSWAP_GROW_CLUSTERS comment to reflect both grow
and shrink semantics.

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 mm/swapfile.c | 48 ++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 44 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 324d873b5f01..a3ba3496ed18 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -53,11 +53,13 @@
 
 #ifdef CONFIG_XSWAP
 /*
- * xswap: dynamically grow the cluster_info array via a VM_SPARSE area.
+ * xswap: dynamically grow and shrink the cluster_info array via a
+ * VM_SPARSE area.
  *
- * XSWAP_GROW_CLUSTERS is the number of clusters to map in one grow
- * operation.  It is set to the number of cluster_info structs that
- * fit in a single page (at least 16), so that the vmalloc page table
+ * XSWAP_GROW_CLUSTERS is the number of clusters to map/unmap in one
+ * grow/shrink operation.  It is set to the number of cluster_info
+ * structs that fit in a single page (at least 16), so that the vmalloc
+ * page table
  * overhead is proportional to the number of clusters mapped.
  */
 #define XSWAP_GROW_CLUSTERS \
@@ -69,6 +71,7 @@ static int xswap_map_clusters(struct swap_info_struct *si,
 static void xswap_unmap_clusters(struct swap_info_struct *si,
 				 unsigned long start_idx, unsigned long nr);
 static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data);
+static void xswap_try_shrink(struct swap_info_struct *si);
 
 #ifdef CONFIG_SYSFS
 static int xswap_create(int percent);
@@ -697,6 +700,9 @@ static void __free_cluster(struct swap_info_struct *si, struct swap_cluster_info
 	swap_cluster_free_table(ci);
 	move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 	ci->order = 0;
+#ifdef CONFIG_XSWAP
+	xswap_try_shrink(si);
+#endif
 }
 
 /*
@@ -3866,6 +3872,40 @@ static int xswap_check_mapped(pte_t *pte, unsigned long addr, void *data)
 {
 	return 1;
 }
+
+/*
+ * Try to shrink the cluster_info tail: unmap contiguous free clusters
+ * at the end of the mapped range.
+ */
+static void xswap_try_shrink(struct swap_info_struct *si)
+{
+	struct swap_cluster_info *ci;
+	unsigned long last, idx;
+
+	if (!(si->flags & SWP_XSWAP))
+		return;
+	if (READ_ONCE(si->nr_clusters_mapped) <= 1) /* keep cluster 0 */
+		return;
+
+	/* Find the last non-free cluster from the tail */
+	last = READ_ONCE(si->nr_clusters_mapped);
+	while (last > 1) {
+		idx = last - 1;
+		ci = &si->cluster_info[idx];
+		if (ci->count || ci->flags != CLUSTER_FLAG_FREE)
+			break;
+		last = idx;
+	}
+
+	if (last == si->nr_clusters_mapped)
+		return; /* nothing to shrink */
+
+	/* Only unmap if we can free at least one full page of clusters */
+	if (si->nr_clusters_mapped - last < XSWAP_GROW_CLUSTERS)
+		return;
+
+	xswap_unmap_clusters(si, last, si->nr_clusters_mapped - last);
+}
 #endif /* CONFIG_XSWAP */
 
 static int setup_swap_clusters_info(struct swap_info_struct *si,
-- 
2.54.0


