Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1FA5C61DC7
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 09:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 08E526B00A9; Thu, 27 Aug 2026 05:46:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03F9F6B00AA; Thu, 27 Aug 2026 05:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBF626B00AB; Thu, 27 Aug 2026 05:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D07126B00A9
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 05:46:24 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4CE0112038E
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:24 +0000 (UTC)
X-FDA: 85146569088.28.9237A6F
Received: from mta1.migadu.com (out-156.mta1.migadu.com [95.215.58.156])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1A2AE160002
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 09:46:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.156 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787823982;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CLLpO28ObAS4iRuR19iGUfqzNV6PkiQagyZ9nEevnZ8=;
	b=0CRBRW4n0+GlCesx360Z0VQrKDp8jes+xSM8Jqz/hvIGAjbKXLaUb+i7r6NmsK8MU1LWhS
	kJ+0sbMPmneuz6U+a6fSL8o7Ag2pcVuTfhGa/guTAUWAmT4HNEK+iDiunpMKLUw4sfQhX3
	EN3P2FqLQHiTEiQ3TijI4dhN/hP68NY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787823982;
	b=8np58D/LciXoJX8yjtp0Hh4XNpU2xdYMJsgVGRVRpJI5khlRb3Bl3iq/umb/NkiuNe2s4B
	ExExXyWZSZy4iKQz1d1Fvjn/Pr/B8VevwhxKPuWfVrJmYEqrMumTDjBolcEot8z1iqiiNT
	2T7TnhpMh+loTHPP4L3o+VL59i3CsNo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of baoquan.he@linux.dev designates 95.215.58.156 as permitted sender) smtp.mailfrom=baoquan.he@linux.dev
X-Envelope-To: linux-mm@kvack.org
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id e19cfcc88f543739;
	Thu, 27 Aug 2026 09:46:19 +0000
X-Mizu-Trace-ID: e19cfcc88f543739
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
Subject: [PATCH 11/16] mm, swap: add adjustable runtime ceiling (nr_clusters) for xswap
Date: Thu, 27 Aug 2026 17:45:01 +0800
Message-ID: <20260827094509.1016740-12-hebaoquan@kylinos.cn>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
References: <20260827094509.1016740-1-hebaoquan@kylinos.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1A2AE160002
X-Stat-Signature: rqgik4ywfc5u1su4i6pgmxdcnw4hf8hm
X-HE-Tag: 1787823981-920767
X-HE-Meta: U2FsdGVkX1/yHGvhwqq+djaeKXxrMIPWN0Uqj6rWshcUWI9tZ/htmqUgBpIDZL44MrL8lJU0bi+HETF6nXQMAYkTxS2ohxPqf+vKKNNT/iPaHopuGvlCWPlM185PI59lCf+ekzVYu9NF1TwdJW5HazlLvvWTTEsTP3odL3LQmy9cU4VQ5DxeT7TFJJY0ko+VkkxFBeFjKxitsL8+2TufPEvu6pOZEOM6bDZZytAlIwxKqMp0XLxhOv4egyF7MzpBMKS14k5NRLbwE3Kdfae1IOrNP4zOpHcBD6eKsuhFmTs4JXlys7U1BNz0Ot74XXkNf9seI/HUl6cfOD6nUb4WqHOcPLfbJxmgGMNzUOd2VRQDmVIikSFIRXQJSN/R4R//b9t+gzS74To/3uHBGeoBpgEwjA8D9ieblFEUYLNs3mVmcDH14Z6GFelpgO8cntNzSk2oGmB41BHK2KmBKyE2ROLKDG03kXpcKbLM5h3t3I5L58fZd4Lh4vcTWRRr4EXFhUcettXLidWq2saYWAJHJ0NFsf9/dai/BdB6rFzkHWrLULIaIGA7QqM+bH2pyO3kX7XuOeodn6QQBFZHjf4cx3x5ouaPgc5lmCaq5qfRI9tHsE0AnGaoPTAk59Td7gjBr7RtLPYWojfyVnV2eyPCRqWTQyRDGRJGtDS+QrxExzplv5lrFmYGBHGJwDU/8aSZcNeg3ckaC+zt+rgWWln4EhyduqDW7WZq2R1w+IPaL+/LuMmfgpZj10hpa6wJR/Gf7R4eBCA1/ULcSb/PvwWceZteU0H0Fanjn+PnE4kl3mxZKdjS6F7txzffsf7zg2e1RNJoZZS/nQD1j1XlhW6LXrXiYsiHDoAKpry+S5M2Pa+peoNmEaiblJ/UGfyGzlrTT5NaUaj2F+QN747HoLzlmIEOJKFjGmQC8OtEEijPyvs416M98TsXiLPF+CW5OPHjRSlhr+j0m8IM4JGeE7s
 CZx7fF4a
 r3SQAXzrJAIC6rXV3AHQH9ez1xLGrlYIzx8RSYAhhNV5achkUCAui6eXmbHIrtdI0JzWH8cCZ4cE6x9xGrILKOj1kP5CQPUeuZGskFAqrcu62UjBNngiWRA1Y/AIjnC5VdlsWzHdpaqOp1yuDyCMrjVgbVH7/uJwP2fCatINJ0eCrUTpWsUQLE/ZAoIX7bBgTf3sqrw4r88Ub5sxeUpf2+QS8Qn0oCZDidbF8Zy+U9EX3vQl2oVTeQF17DNoAZlBBiiiLxipwkM3twlQIUATOhELlmX1dAI6sdmQRxlGBH79a3f3myd/vJSPx/ejpzFJ8XPVqZISfNuDolOvaMANzPYjRqc7hAyDU4fT42+ppsoC1zDts8SfSK2zGlA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Split the xswap cluster limit into two fields:
- nr_clusters_max: immutable hard limit set at device creation
- nr_clusters: current growth ceiling, adjustable at runtime (<= nr_clusters_max)

The grow path already uses nr_clusters as the ceiling. Shrink now also
respects it: when nr_clusters drops below nr_clusters_mapped, shrinking
fires on free until the mapped count reaches the ceiling.  When
nr_clusters == nr_clusters_max (default), shrink is effectively
disabled - all growth and no shrink.

At creation, nr_clusters starts at nr_clusters_max (full size).

Signed-off-by: Baoquan He <hebaoquan@kylinos.cn>
---
 include/linux/swap.h |  3 ++-
 mm/swapfile.c        | 29 +++++++++++++++++++++--------
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/include/linux/swap.h b/include/linux/swap.h
index fea0005b9f51..c55af4a95ef7 100644
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
index 5235c6d07ab2..b2c3bb21f082 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -3235,6 +3235,7 @@ static void free_swap_cluster_info(struct swap_info_struct *si)
 			xswap_unmap_clusters(si, 0, si->nr_clusters_mapped);
 		free_vm_area(si->cluster_vm);
 		si->cluster_vm = NULL;
+		si->nr_clusters_max = 0;
 		si->nr_clusters = 0;
 		si->nr_clusters_mapped = 0;
 		return;
@@ -4005,16 +4006,27 @@ static void xswap_trim_free_tail(struct swap_info_struct *si, unsigned long idx)
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
@@ -4023,7 +4035,7 @@ static void xswap_try_shrink(struct swap_info_struct *si)
 	 * leave a partial run off the free list if it proved too short to unmap.
 	 */
 	spin_lock(&si->lock);
-	for (i = start_idx; i < si->nr_clusters_mapped; i++) {
+	for (i = start_idx; i < nr_mapped; i++) {
 		ci = &si->cluster_info[i];
 		if (ci->flags != CLUSTER_FLAG_FREE)
 			break;
@@ -4042,7 +4054,7 @@ static void xswap_try_shrink(struct swap_info_struct *si)
 	spin_unlock(&si->lock);
 
 	xswap_unmap_clusters(si, start_idx, nr_unmap);
-	si->nr_free_tail -= nr_unmap;
+	WRITE_ONCE(si->nr_free_tail, nr_tail - nr_unmap);
 }
 #endif /* CONFIG_XSWAP */
 
@@ -4066,6 +4078,7 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 
 		cluster_info = vm->addr;
 		si->cluster_vm = vm;
+		si->nr_clusters_max = nr_clusters;
 		si->nr_clusters = nr_clusters;
 		si->cluster_info = cluster_info;
 
@@ -4103,6 +4116,8 @@ static int setup_swap_clusters_info(struct swap_info_struct *si,
 			}
 		}
 
+		/* All mapped clusters except cluster 0 are free at the tail */
+		si->nr_free_tail = si->nr_clusters_mapped - 1;
 		return 0;
 
 err_unmap:
@@ -4595,7 +4610,6 @@ void __folio_throttle_swaprate(struct folio *folio, gfp_t gfp)
 static int __init swapfile_init(void)
 {
 	swapfile_maximum_size = arch_max_swapfile_size();
-
 	/*
 	 * Once a cluster is freed, it's swap table content is read
 	 * only, and all swap cache readers (swap_cache_*) verifies
@@ -4605,7 +4619,6 @@ static int __init swapfile_init(void)
 		swap_table_cachep = kmem_cache_create("swap_table",
 				    sizeof(struct swap_table),
 				    0, SLAB_PANIC | SLAB_TYPESAFE_BY_RCU, NULL);
-
 #ifdef CONFIG_MIGRATION
 	if (swapfile_maximum_size >= (1UL << SWP_MIG_TOTAL_BITS))
 		swap_migration_ad_supported = true;
-- 
2.54.0


