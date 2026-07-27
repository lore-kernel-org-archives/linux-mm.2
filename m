Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C7DEEC531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:06:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD54A6B00A3; Mon, 27 Jul 2026 10:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B855C6B00A5; Mon, 27 Jul 2026 10:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A24796B00A6; Mon, 27 Jul 2026 10:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FB116B00A3
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:06:26 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id EFF53160633
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:06:25 +0000 (UTC)
X-FDA: 85034731530.13.4E27037
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf08.hostedemail.com (Postfix) with ESMTP id 22A71160015
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:06:24 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gkZsCbbh;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785161184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oxtDwo2XbQLdDmbqumJHdChHtx0+DF2f0jLUx043Jv0=;
	b=ZFoBiJlP2QVrXxxZl0g0VA/vP8cnv1bHMS/shEIbLKRPdps2EKniKAk82/Vsud/yn2PFDt
	GoJoHsNgoWRV/GMlQ8t6eNNkz+ESoG+PRYL7SNfKWn1m87CZeJ0ni84r/uUiAfzyjrbBPl
	2ZatQiqdrJfEXF9+HDfjA3x86/ETRwc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=gkZsCbbh;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785161184;
	b=mnSz9bUpg3oNUmRi9Bmk4ajSXl9OhLow2okc4k7anicJSFb42xYrs0bxmuBHxJvFSNSICL
	zbyOuo0bEHrQSEDygkLYVcm5mssQrSmw3SBBnuVhZlexUWxuyngOllkzqlpUsXmsuSz9DJ
	/4FgMF19jwz1K5h//9yROex7hGhsCYY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785161182;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:  content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oxtDwo2XbQLdDmbqumJHdChHtx0+DF2f0jLUx043Jv0=;
	b=gkZsCbbhYUaG86wgmXarnyjnNPo35Vw+FkPYTH06JZfOC+lVQGwMELiF2dnhaFtgv5fkNQ
	VyBdk6I3uhtHl05qhuqgU6brbqlY+ts5C3pTB6o77cecD7hwtZHBT47wph7h9mpj6w4CB3
	PXxOetjCoke5Ko7DJxMtOkLI5daKbcM=
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
Subject: [RFC PATCH 08/11] mm, swap: add adjustable runtime ceiling (nr_clusters) for xswap
Date: Mon, 27 Jul 2026 22:04:59 +0800
Message-ID: <20260727140503.1060918-7-baoquan.he@linux.dev>
In-Reply-To: <20260727140503.1060918-1-baoquan.he@linux.dev>
References: <20260727135029.1059441-1-baoquan.he@linux.dev>
 <20260727140503.1060918-1-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 22A71160015
X-Rspamd-Server: rspam01
X-Stat-Signature: gdjrczybnoabamof1xisqnxb663ouwxu
X-HE-Tag: 1785161184-236809
X-HE-Meta: U2FsdGVkX19uEH9ovZStypMz2NjXsWknbBXr5S8Ae34dxeWEwLLrPZvdu1Ns+KwhrphT3iMXClSA3vLlV+WUWZBI3ufMhwzkZaeEgnI3iqICWVS0KFW4U8NmYFCehua85BNvHGx3k/6d9LWdJsjlQrhSM1Ab567qtmCKhH3mdhJMEp1IsGPTCjF6hTlJ0ceS555V5qdeGsDxNjqNwolEPvNOTe4t6oos1R9efOnosnt0FA+rRKsE4QPjA4sbuqUpNj9rHxIwPFXsOPVZnHIvA2TAc376hdYwABONqBian2sWiSH209HhEwZ8K2thWOMd8sY06z4q63UJh/NKA0h93yerZM9juQxwxvxyQqjMpQCoLrEgD567O9h7ZE0UGjsqmTzFed/j722O+/WkhfkAe122W8VGoJ1CVK2NN0x4jNdQMZFYIqvini9xg0SpHTS5PJgsAKuG3nphssYmgm8BJXXmczo89+fAhUgJLDfrEDqY5bIqnzKxtr07tP/HNOJXsDLWHbvt5GQNzaAl3plJq0S6jeTPXN67TVfE3inFbQp8YMwk3UZuegPz18wSJjsBcNwy62/Gn22O1s09gxUgUD1kZb4zVLt6zicrytt74xcF6hAlUOWpgx3Mm6TUaCaAp1gVJ3L2DqgpP6Pg28ssqKy04DUpgZ6LZTZBq9Sdb5HyDxH+22q8M6fNRV4Oj0TwXnv0iHieB6p7QWTUyHJbjWyBilMbgbPAOdR2wZirWIi3ZODgO4xiI/1P9utx7coFeHoCt1yxnvsRnT+S5yQVzHzRnlc6ZlAth2uvZwYXFeQJr5v9QbjS8gML+UCRUEACRTSmWvIeCFkgu7WtYB5bOGxSRWClW435l4oKhMgK9hw7v+WYgoV1asOlES6LP1UccACSQLZ40bDwC+mM+rGaEAC5A73o82qKDntAOvUgOWJmpHJFJnrwNSA6xj5bztVaHtQL3T5ykxfAaEd42SY
 j/yWHq+q
 +DZ1uY7seaVR0pRKYRd8B8vrCLdl6FiNC9+jyQQdUAcHmFJzhMUqxgxNnc3iHBaIn3XFRj5mcX8OeptSJPxzrJjIecomMzwwFb6il9u4BDB4zTkDuchbpqH161epbM0QgwI0oGxeZOKZhB8YcgTeFybZ7Wv89l5FCx05PCt89pApGWe3zf6V5gk9LYjIKYAZ370OwiB2Y504QqSPU5iuxfhn0G/mAW9lSlQTWtGL0JXFmbSvAetu3O0yVpscnC0t+3SXDNFEobMRBuHf4q1z02pOtKb0kEaYdSLrIO3nN6eJBhZAzXrzwPbIx1mBa7IHQ6+u5B9HDhsjqnixbAxrrrfF74A==
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
 mm/swapfile.c        | 32 +++++++++++++++++++++++---------
 2 files changed, 25 insertions(+), 10 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index c54c921378ab..e4512aeead36 100644
--- a/include/linux/swap.h
+++ b/include/linux/swap.h
@@ -250,7 +250,8 @@ struct swap_info_struct {
 	struct swap_cluster_info *cluster_info; /* cluster info. Only for SSD */
 #ifdef CONFIG_XSWAP
 	struct vm_struct	*cluster_vm;	/* VM_SPARSE area for xswap dynamic cluster_info */
-	unsigned long		nr_clusters;	/* total cluster count for xswap */
+	unsigned long		nr_clusters_max; /* upper limit from swap header */
+	unsigned long		nr_clusters;	/* current growth ceiling (≤ nr_clusters_max) */
 	unsigned long		nr_clusters_mapped; /* currently mapped cluster count */
 	unsigned long		nr_free_tail;	/* contiguous free clusters at tail */
 #endif
diff --git a/mm/swapfile.c b/mm/swapfile.c
index 1eb44f818b40..f57823d6449f 100644
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
@@ -3945,20 +3947,31 @@ static void xswap_trim_free_tail(struct swap_info_struct *si, unsigned long idx)
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
@@ -3973,7 +3986,7 @@ static void xswap_try_shrink(struct swap_info_struct *si)
 		return;
 
 	xswap_unmap_clusters(si, start_idx, nr_unmap);
-	si->nr_free_tail -= nr_unmap;
+	WRITE_ONCE(si->nr_free_tail, nr_tail - nr_unmap);
 }
 #endif /* CONFIG_XSWAP */
 
@@ -3997,6 +4010,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 
 		cluster_info = vm->addr;
 		si->cluster_vm = vm;
+		si->nr_clusters_max = nr_clusters;
 		si->nr_clusters = nr_clusters;
 		si->cluster_info = cluster_info;
 
@@ -4031,6 +4045,9 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 			}
 		}
 
+		/* All mapped clusters except cluster 0 are free at the tail */
+		si->nr_free_tail = si->nr_clusters_mapped - 1;
+
 		return 0;
 
 err_unmap:
@@ -4434,7 +4451,6 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 static int __init swapfile_init(void)
 {
 	swapfile_maximum_size = arch_max_swapfile_size();
-
 	/*
 	 * Once a cluster is freed, it's swap table content is read
 	 * only, and all swap cache readers (swap_cache_*) verifies
@@ -4444,12 +4460,10 @@ static int __init swapfile_init(void)
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


