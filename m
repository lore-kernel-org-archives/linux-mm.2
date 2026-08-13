Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D62FAC5CFDB
	for <linux-mm@archiver.kernel.org>; Thu, 13 Aug 2026 10:50:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F8A6B0280; Thu, 13 Aug 2026 06:50:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF91E6B0286; Thu, 13 Aug 2026 06:50:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0F966B0287; Thu, 13 Aug 2026 06:50:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AEFA06B0280
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 06:50:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4829516058A
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:36 +0000 (UTC)
X-FDA: 85095927672.20.59A0BDF
Received: from mta1.migadu.com (out-161.mta1.migadu.com [95.215.58.161])
	by imf19.hostedemail.com (Postfix) with ESMTP id 532D71A0006
	for <linux-mm@kvack.org>; Thu, 13 Aug 2026 10:50:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.161 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786618234;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xhdDr4k5paFrhRgCr5wcHkSlu005YNQzt4wDRmo5lcs=;
	b=4xF5UJ8oJuM4yXxrx/1M9/TRQhO1v8kD/NfWfUiUZXLkc9Z6qSw9/lywXhNF5nz2x6XRk5
	IlA8DRyT4dt8fOk0NqvH4yiIju0Xlvgt5V/qorar7wLBV9vGrB/ENrB+ukfTxtm/dhCAQD
	SizytNw9QBY0sIKTBYvQzEBLlPAJi94=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786618234;
	b=iK4K7Z5pkQlRTjx8xTj+lhNXgcdRCxl8/KEKk0/tZ+HhahTE5p4kS31CvrB2DhViLUiwR+
	vq4zm+NOygI4PGoiFET8B9ZG+lkewlQKT0fkVd+kEgjeR+0iDCx5fRrlDVzeYym/NCD+9H
	vUIzS3kVT2gM2rgs4PzckkTpo2WLsLU=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf19.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.161 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (3.112.29.171)
	by mta11.migadu.com with ESMTPS id 1d13f0639beaa5c8;
	Thu, 13 Aug 2026 10:50:33 +0000
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
Subject: [RFC v3 11/15] mm, swap: add adjustable runtime ceiling (nr_clusters) for xswap
Date: Thu, 13 Aug 2026 18:48:50 +0800
Message-ID: <20260813104857.3450386-12-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
References: <20260813104857.3450386-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: 4ik35ozjmah9djji8d5ie3dzmzpnsidp
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 532D71A0006
X-HE-Tag: 1786618234-503493
X-HE-Meta: U2FsdGVkX1+z/VHzr3PPuJ2LHMUchgyi+czEeI34t4wY3tESzKYQQQLuaVx/TfYohAfJPUQKzoilSHtBEJwDCV0C1XiE+EJ4bG/NWR/uPpg4V/2QeRXimrpP/pOgQJwi4YP8lg7tpfoclD/dV+DRajGbmS+2xTrEFBX81VORrMrKPsxA1EiGCCFRq8oeGgB9zJCPCMjVe4ENptg5svxdF61Hahdu0iCQZ4SZ9NgF3/77nyvXMhNZGRLWvX4fKXxoHf52C/SMxhpAXC0L1F0RJTyp9v+4TDYbvu4DVeHVfPIMO9xhGjIMauFd2uDfvIhO0iAcu134ucIVxfWsj+uP83soFY9wQ53VmjIJJqZRGM18PKKZrfrq1sfBOMS7OOcBTrqEedCL6rfLZKj35x9P2mPfmp2CFFzPxKOD8gfn9cvT79EyiMHDX8u2JDOzC/G9vfZLOX+yD+lQmnHBO27OLXobUP5N1gYZ2yaT3iMjvYh4GfgozFU72CnNL0/bEhtCO518Yj5yBPKM20crobvpSD6KL9mAqdsv5TgUWtcdP9P//jsF4dks3UnbpBF7grKHDZNvp57zWMRb+pW8skCRriHdA4Svx5hi85oA8hfDx8RYUf9/9bQOc/qxZOQEVS03S3zDn8cWb+T59qWGbxlwOO/ZFUyETP+djG2YJYJE7jrgKQ8/HV/qF5x6sDAnzo6MOeKbP8X5qg/p7hZ3FnaESWDatpGo/0fsFRbYt3fOJXohtTFc5Qx060QOgAbv2rvCIMMCg/B1IlyUjaBw0JceDNiRmuwgcAYbwmOfGgfKQAKNqcjohFT5E2CgL46qLPxi/EJqLizW9n0UueRf8oYEWbfpHQwts4A2m8sffQXBWevUH0QUaD7WuZiA5/9/vq2qb1nhX01g9ExTTEjm28Fm4G3d301Qkea6N711gDvnj5pZoc0XELz4s4aBi4SRCivRJNEsNGt2DkXzqpDuf9M
 npB3qQS+
 +Nu3laqx15OKGerIKl2YlXVJN3w8rPP5Yh0t1gGmyAAjJ9qvzI9hrQEa5tZvoVeFfiaQbiS51GCIjygu4fqfDnZAyIMH1bTxOJkYDvNr0oHrGh6I1bTmopkwMyljwrOU0q4Vs4GtTR6FZPFt/GFngicq5smSWOqYeXD5R1HkdPigWt/5r/Za0WG01bYlAk5iGhwWkxph+XCL4oSqSDXjMhh+Pr1/Zm6zUOhuuoi23OXAYVLna1ha8NS5LBCfq9dWPpKEG2FZB0W8ZA4IKpnqoejHh3EBMvDYAse8jSBZ/gJzI6lbiGQWBqOv5rKsL5XgkI3GINHzdrp9rqmrZuvvKW1p7UJjcYPvlQI9YKc3M1tLXNXgBPQnryqR84Wzsy202w2FrQkJzBvQ6Qv5CjSpXlDO3liFFbyzKtBZHzq4gvizG39QLDUQralfBKbpdZIMOJZFQT76yDdpm7EzEcUhuX12WbFbPGBMi0ZlappGnNgaSoTzMXrYrqZqZWhFWlEclM9TI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Split the xswap cluster limit into two fields:
- nr_clusters_max: immutable hard limit set at device creation
- nr_clusters: current growth ceiling, adjustable at runtime (≤ nr_clusters_max)

The grow path already uses nr_clusters as the ceiling. Shrink now also
respects it: when nr_clusters drops below nr_clusters_mapped, shrinking
fires on free until the mapped count reaches the ceiling.  When
nr_clusters == nr_clusters_max (default), shrink is effectively
disabled — all growth and no shrink.

At creation, nr_clusters starts at nr_clusters_max (full size).

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  3 ++-
 mm/swapfile.c        | 29 +++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index e8e6ac5680ff..93d7771f2427 100644
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
index fa76b8c9bd2d..be56114a6691 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3228,6 +3228,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
 		free_vm_area(si->cluster_vm);
 		si->cluster_vm = NULL;
+		si->nr_clusters_max = 0;
 		si->nr_clusters = 0;
 		si->nr_clusters_mapped = 0;
 		return;
@@ -3998,16 +3999,27 @@ static void xswap_trim_free_tail(struct swap_info_struct *si, unsigned long idx)
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
 
 	/*
 	 * Verify the tail clusters are still free before unmapping.  Count the
@@ -4016,7 +4028,7 @@ static void xswap_try_shrink(struct swap_info_struct *si)
 	 * leave a partial run off the free list if it proved too short to unmap.
 	 */
 	spin_lock(&si->lock);
-	for (i = start_idx; i < si->nr_clusters_mapped; i++) {
+	for (i = start_idx; i < nr_mapped; i++) {
 		ci = &si->cluster_info[i];
 		if (ci->flags != CLUSTER_FLAG_FREE)
 			break;
@@ -4035,7 +4047,7 @@ static void xswap_try_shrink(struct swap_info_struct *si)
 	spin_unlock(&si->lock);
 
 	xswap_unmap_clusters(si, start_idx, nr_unmap);
-	si->nr_free_tail -= nr_unmap;
+	WRITE_ONCE(si->nr_free_tail, nr_tail - nr_unmap);
 }
 #endif /* CONFIG_XSWAP */
 
@@ -4059,6 +4071,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 
 		cluster_info = vm->addr;
 		si->cluster_vm = vm;
+		si->nr_clusters_max = nr_clusters;
 		si->nr_clusters = nr_clusters;
 		si->cluster_info = cluster_info;
 
@@ -4093,6 +4106,8 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 			}
 		}
 
+		/* All mapped clusters except cluster 0 are free at the tail */
+		si->nr_free_tail = si->nr_clusters_mapped - 1;
 		mutex_init(&si->xswap_lock);
 		return 0;
 
@@ -4586,7 +4601,6 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 static int __init swapfile_init(void)
 {
 	swapfile_maximum_size = arch_max_swapfile_size();
-
 	/*
 	 * Once a cluster is freed, it's swap table content is read
 	 * only, and all swap cache readers (swap_cache_*) verifies
@@ -4596,7 +4610,6 @@ static int __init swapfile_init(void)
 		swap_table_cachep = kmem_cache_create("swap_table",
 				    sizeof(struct swap_table),
 				    0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);
-
 #ifdef CONFIG_MIGRATION
 	if (swapfile_maximum_size >= (1UL << SWP_MIG_TOTAL_BITS))
 		swap_migration_ad_supported = true;
-- 
2.54.0


