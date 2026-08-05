Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A67CC55822
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 07:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AD8FB6B00B2; Wed,  5 Aug 2026 03:55:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB03E6B00B4; Wed,  5 Aug 2026 03:55:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C5146B00B5; Wed,  5 Aug 2026 03:55:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6CD1E6B00B2
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 03:55:23 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7FDFD1C0358
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:55:22 +0000 (UTC)
X-FDA: 85066455684.15.20D92E8
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf15.hostedemail.com (Postfix) with ESMTP id A20C4A0006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:55:20 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PlSv69tq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785916520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U88ICcPSN2njwbDn4B5fxEExcCgx6VDyaCcBrToBcqI=;
	b=fxV7rephWiIpWONnHu2EC4PCaYwaC+17OP0fJ5yUTrg44u8AWCXY10a1cMqoRvWqTHqpa5
	mHgVZ7B1o7fiZ3aXTNHGz+j6T/rPZ9A0LCd0VW9mFXLBnzQK2bG8VDJP9MlZ2SHVT7Ejfu
	bJpxHZO2w8NdRNRqzkBa1DkZhCwLVNI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PlSv69tq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785916520;
	b=oPUTLU7IfNCzSVeXnCtakfwzueqANBNxwLHPTImpqfqWFcXqadjrhHFoMq82NY7w+DWHFv
	0/iDy9wM765KQAUIgKMRcpIsUzL/MsX/L2xZ80OXMdQTxIG8QeWPVco7Y8OyhISNND391+
	wWqE5IyYqtnr6p3G+V88HOmZNsFbg5Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785916519;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=U88ICcPSN2njwbDn4B5fxEExcCgx6VDyaCcBrToBcqI=;
	b=PlSv69tqP76D2gH+DzpHn9NJAtmrWNmjrsjXO2gTTvQO8sSuDIk1Uv3fYkWE4mxeIfCDix
	ecWzoHmDJlrdX+zGS+47GIEeOxLMRuEWuV6UrA0qYE/sezgXnuhjRSlZ142pLut59SZ9+u
	EkiXDQpBJeKa0PfL3qo/aaNaCzKbiHI=
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
Subject: [RFC PATCH v2 08/10] mm, swap: add adjustable runtime ceiling (nr_clusters) for xswap
Date: Wed,  5 Aug 2026 15:53:31 +0800
Message-ID: <20260805075336.3579395-9-baoquan.he@linux.dev>
In-Reply-To: <20260805075336.3579395-1-baoquan.he@linux.dev>
References: <20260805075336.3579395-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A20C4A0006
X-Stat-Signature: mnzzq1axdztox5ztz3w46i5uhanpomc9
X-Rspam-User: 
X-HE-Tag: 1785916520-902672
X-HE-Meta: U2FsdGVkX1/QjZkkKzSXHPYq/gGnYIeISBfe1SKm1iL8Pvbk2WZTf2bOfF4f1mQ2zvlVdDjPSVK7czL0WoE9a/pT/oh9ucfleJyjpTQZtkkb1I/mHNFxmC9Pv/zAfUZBm5e8QHBPgk+g5ZQdFLdHBpVoWpERIDHhPob6FZPQxtbHqUgUHHftLuLEcFwyp9b9Rl8JdW78KjkSDFZAdE5jG9OBRoTmdYKx79ApafKFxKKmir9zGoMknqIe+qseyv+qGaEhbrC71SSTQV2bCR6NQdkUwmwCcSucmaVMYDXgsBEoBlobh5ooUu6CNgM8zS34Qsl4L/WmPClwT+KFPyJzrG888UeeizahRwAONWEYJ8a8GvtNp7PSmDHat/zEVaSFo4yPxjX333wJwAU3wZXxeS1+l6/RPDy11z+5lR46oo/jlN3Jk+jO9Y346uEiMInrV/mOY9KdhuuRmDJUY+nJLcjXz5sQQ/gZD9Y1CwS07Km+k93BWMliEFPkzc5FdtjN9JOXRlJZ90Fv17mxSTf0cLEhB2uxF4j7qIXnbhjx/jYU/tgOcisxTHNnyvZkaMVh28ff7261zZYB/Td6cdXIX6oTJtWJ3l3rB826MdmsppOvbqHUcgCjfzx0gkGCmq0QaHgh3YvsLWY8S/9E2jWGET+DmZsvnPWpWc8nKLiRSZTy3gbhATeWSQkglmBduUqevPBstNNZtE82uMcYrUft0p+LgTsDiUnSuHbbMNAoj+/RpWl3YfQ7MYXYmSaOnH8QCgc1WYR0FFu7h8dhsOxfqYB4WspnDcfyUo43cBKzCeV2ElwhmW9hCCV3C5sUAHpdkmFUKvv4b6CUK7Qoe52fnTHg6rroFfq7eUHl5cDWwjzD3Db9JsrzXGmQxBzwC4ecfftIAmI+zz6BY47JRDQLJuXWK9T/ywXmjJWHkMpyzf5skSAFjP8B0ZaZ2nwzlNCmE43gAIYzZ2nb3mJxf2y
 2Cxq8y6r
 aDMdgUXrubAUHOONoJDt5Pq8wdRp9Kj38TU1j2bM2AnYnoDKtZjZ+s1uC7nCAziR70Qf4GE+khMHcTGkHhkX3x2aqy9rzZSIGLtpflEcPjei4kmzoDcfFyPA9hwm1RQdmfXD/cEHTe9hPoYxQbEMe32rMLC1FgWE3l3bt23qve33rO/nzDdu4CuCp7fR8Ft92BUb9VXJo/8v4hNatJMI0PyEuSEuVRgtGt8xAVG3BEQwdNG1k4JzMIGsZEwET4KQbCR0PNLQPzZMvxbBhxA9RPaayCkB82wRuzn4uIurcXJVmgqJuIAS378bJtv1bdFVjqQbL4uAtiPFcFfvu636pgMfjnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Split the xswap cluster limit into two fields:
- nr_clusters_max: immutable hard limit set at swapon from swap header
- nr_clusters: current growth ceiling, adjustable at runtime (≤ nr_clusters_max)

The grow path already uses nr_clusters as the ceiling. Shrink now also
respects it: when nr_clusters drops below nr_clusters_mapped, shrinking
fires on free until the mapped count reaches the ceiling.  When
nr_clusters == nr_clusters_max (default), shrink is effectively
disabled — all growth and no shrink.

At swapon, nr_clusters starts at nr_clusters_max (full size).

Signed-off-by: Baoquan He <baoquan.he@linux.dev>
---
 include/linux/swap.h |  3 ++-
 mm/swapfile.c        | 31 ++++++++++++++++++++++---------
 2 files changed, 24 insertions(+), 10 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index 72b28116ed0f..1159153459a1 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -250,7 +250,8 @@ struct swap_info_struct {
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 #ifdef CONFIG_XSWAP
 	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for xswap dynamic cluster_info */
-	unsigned long		nr_clusters;	/* total cluster count for xswap */
+	unsigned long		nr_clusters_max;/* upper limit from swap header */
+	unsigned long		nr_clusters;	/* current growth ceiling (≤ nr_clusters_max) */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
 	unsigned long		nr_free_tail;	/* contiguous free clusters at tail */
 	struct mutex		xswap_lock;	/* serialize map/unmap operations */
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3f536495b8cf..3037f428f217 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -72,6 +72,7 @@ static void xswap_trim_free_tail(struct swap_info_struct *si, unsigned long idx)
 static void xswap_update_free_tail(struct swap_info_struct *si,
 				    unsigned long freed_idx);
 static void xswap_try_shrink(struct swap_info_struct *si);
+
 #endif
 
 static void swap_range_alloc(struct swap_info_struct *si,
@@ -3151,6 +3152,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
 		free_vm_area(si->cluster_vm);
 		si->cluster_vm = NULL;
+		si->nr_clusters_max = 0;
 		si->nr_clusters = 0;
 		si->nr_clusters_mapped = 0;
 		return;
@@ -3972,20 +3974,31 @@ static void xswap_trim_free_tail(struct swap_info_struct *si, unsigned long idx)
  */
 static void xswap_try_shrink(struct swap_info_struct *si)
 {
-	unsigned long start_idx, nr_unmap, i;
+	unsigned long nr_mapped, nr_ceiling, nr_tail, nr_unmap;
+	unsigned long start_idx, i;
 	struct swap_cluster_info *ci;
 
 	if (!(si->flags & SWP_XSWAP))
 		return;
-	if (si->nr_free_tail < XSWAP_GROW_CLUSTERS)
+
+	nr_mapped = READ_ONCE(si->nr_clusters_mapped);
+	nr_ceiling = READ_ONCE(si->nr_clusters);
+	nr_tail = READ_ONCE(si->nr_free_tail);
+
+	if (nr_mapped <= nr_ceiling)
+		return;
+	if (nr_tail < XSWAP_GROW_CLUSTERS)
 		return;
 
-	nr_unmap = round_down(si->nr_free_tail, XSWAP_GROW_CLUSTERS);
-	start_idx = si->nr_clusters_mapped - nr_unmap;
+	nr_unmap = min(round_down(nr_tail, XSWAP_GROW_CLUSTERS),
+		       nr_mapped - nr_ceiling);
+	if (nr_unmap < XSWAP_GROW_CLUSTERS)
+		return;
+	start_idx = nr_mapped - nr_unmap;
 
 	/* Verify the tail clusters are still free before unmapping */
 	spin_lock(&si->lock);
-	for (i = start_idx; i < si->nr_clusters_mapped; i++) {
+	for (i = start_idx; i < nr_mapped; i++) {
 		ci = &si->cluster_info[i];
 		if (ci->flags != CLUSTER_FLAG_FREE) {
 			nr_unmap = i - start_idx;
@@ -4000,7 +4013,7 @@ static void xswap_try_shrink(struct swap_info_struct *si)
 		return;
 
 	xswap_unmap_clusters(si, start_idx, nr_unmap);
-	si->nr_free_tail -= nr_unmap;
+	WRITE_ONCE(si->nr_free_tail, nr_tail - nr_unmap);
 }
 #endif /* CONFIG_XSWAP */
 
@@ -4024,6 +4037,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 
 		cluster_info = vm->addr;
 		si->cluster_vm = vm;
+		si->nr_clusters_max = nr_clusters;
 		si->nr_clusters = nr_clusters;
 		si->cluster_info = cluster_info;
 
@@ -4058,6 +4072,8 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 			}
 		}
 
+		/* All mapped clusters except cluster 0 are free at the tail */
+		si->nr_free_tail = si->nr_clusters_mapped - 1;
 		mutex_init(&si->xswap_lock);
 		return 0;
 
@@ -4469,7 +4485,6 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 static int __init swapfile_init(void)
 {
 	swapfile_maximum_size = arch_max_swapfile_size();
-
 	/*
 	 * Once a cluster is freed, it's swap table content is read
 	 * only, and all swap cache readers (swap_cache_*) verifies
@@ -4479,12 +4494,10 @@ static int __init swapfile_init(void)
 		swap_table_cachep = kmem_cache_create("swap_table",
 				    sizeof(struct swap_table),
 				    0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);
-
 #ifdef CONFIG_MIGRATION
 	if (swapfile_maximum_size >= (1UL << SWP_MIG_TOTAL_BITS))
 		swap_migration_ad_supported = true;
 #endif	/* CONFIG_MIGRATION */
-
 	return 0;
 }
 subsys_initcall(swapfile_init);
-- 
2.54.0


