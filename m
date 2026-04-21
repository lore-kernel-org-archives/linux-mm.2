Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68054F327AA
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 06:17:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265C16B009D; Tue, 21 Apr 2026 02:17:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216506B00A0; Tue, 21 Apr 2026 02:17:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE64F6B009D; Tue, 21 Apr 2026 02:17:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DAA7E6B009B
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 02:17:00 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7A038BD505
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:17:00 +0000 (UTC)
X-FDA: 84681555000.01.B8E698A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5221BC0002
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 06:16:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aF4Q8T/C";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776752218;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/lGOfna53AmjVjA5KTqls5VJJ+NVZa2MK+x/1kEtCJU=;
	b=KifWqHdhHYx3amHxV4xb7ndm7NR11PZ6b7gJ8Ij7tkQbL8eIhUIgXz+NuuwP+gw4B/aaMD
	eQtGvXnMJbOYkWb368nERVduNDq6uXu9p0cfBrcZsSAIPTQZT8tLuXi5Tv10MTbJT4/a65
	DdrY8bDs2SpaXkU9S+rlc0aPgcioR1s=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="aF4Q8T/C";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776752218; a=rsa-sha256;
	cv=none;
	b=sDgy+SSONq4Mp7Md2yti8hPaUNzrQoQ8dslUNuZLvSSAdjQTgIMs80o978RIn87kdoSfTi
	ONWlrgyoAO2/F7M9NaGJbTAcNgWu0FnM46o+b6xpzHsI4qWgDl2C5Xg/8cZNgcm+EImKlw
	5r2MIWufKe66Mg6rplW7UL1z3NM5TSw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1B52A44717;
	Tue, 21 Apr 2026 06:16:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BEE2FC2BCFC;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776752214;
	bh=6i9YAUZYwrRc5SgpD4usGKW1EHQYKdPdq9tqPGDElhg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=aF4Q8T/CgsBWUB3LkN/wKWqimcuH3PbKYijQ6Oazwp/vKnzyEPfV+MX+1qNen+6h9
	 nWCZNt4S+h2S6603XYqpfIfxYwThxLx1SjdR4iWrd+NXKhbkS1dyqsRWW4z1SPRUeO
	 nlC1lrFNZtuHcoba+mRnG78tWmulvJyVVch5uGg/k8DJSLnf80dCGn7s4/wbv9fItG
	 NqnG4uRH9zkObc7aJy8ZX3QYUWAlJSEehJWFs+EWXycnRtw74mlFeyy/yWNNKJCojw
	 jcFDHzcG4Twwk/3bNK38hZFsEABt1b/2MoU5D2PkGCPAftuavDo6jr2e+w1zlLqBgS
	 V2fJ2U6c1CNCg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7220F327AB;
	Tue, 21 Apr 2026 06:16:54 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 21 Apr 2026 14:16:53 +0800
Subject: [PATCH v3 09/12] mm, swap: consolidate cluster allocation helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260421-swap-table-p4-v3-9-2f23759a76bc@tencent.com>
References: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
In-Reply-To: <20260421-swap-table-p4-v3-0-2f23759a76bc@tencent.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Barry Song <baohua@kernel.org>, 
 Hugh Dickins <hughd@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Baoquan He <bhe@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Youngjun Park <youngjun.park@lge.com>, 
 Chengming Zhou <chengming.zhou@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 Qi Zheng <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Yosry Ahmed <yosry@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Michal Hocko <mhocko@suse.com>, Michal Hocko <mhocko@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Axel Rasmussen <axelrasmussen@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1776752211; l=7165;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=B+TeE8JVn80xKMjcMTb6N8fSNYHExA8Vz1o7UX2umm0=;
 b=gFNJDYUx2Qi1b6tclNArTC3/ZBh+XOnQIKjENIqfaDW3MxZTmBC+CWRd0K0isOUmj/RKSAGRs
 etswOk+N4jYAJJFmaGGHHDVi6RaLrS5YYbacYwojhQ++Rsr81T/aLOF
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 5221BC0002
X-Stat-Signature: m4agr5t1w7bo9pgj6q8pd8b9oy9ixtes
X-HE-Tag: 1776752218-308586
X-HE-Meta: U2FsdGVkX19+XY834+E3wHYQc56l473nAIvCWYfg21Kn+FC3xEV5pxzQxqlP3npsSn7OfOzv2EqSVFZ8FD8MUttT39stvsNJHlwK/tQMRPCCEi6b/JLiHxKlL0GAv2c0pD6jvNp2DIA8ZB9mBLKuqKI3C7zxljxR3q0BQQ4grEQJJ6Xb7gIB+DWAg/S4k0KmmkAJXTWpyCQ+UmZENi2RWV4wYPIZuCu755O1GozU3zQ7ByYFGEq2+gbboTv+l7zES/YcrGAfxTjWQC0cTrF3y7xlV21qdukM5j5veh0Xew5olWFqNqyq+eEdIWcN25PpeeV/kIHezTV5EvYpJwhrru7FapunYu2JIz7FzpjY1e9pppTcNI/3pmv98JCxGKrQ6MAuErHQrOVkSpSLZGzlsoQLAJC6mJn7dXChYTHKEPPpqH1bShAb4bduRdy5LtNypWkRJIsZcoILxUyOELun9Oy4WyyLi9DXtuDUhdO5FNp9eYoQ6Q32g/9PugY6YS+lV6wGXt/0JgmjHwItnmsTqPTZ1ieSAGje3Z3sYSFIR1nxj4vZiDOgcSCU7PWzy/3S5fsxfVx6BM08dQifagwXzKv1KxMhErpLznDU+K4k3UWquU1oH6iSZeRtlm0Phv2zsEdYe4wjJYBBZd1NsdPxjlA6QS6js/yPRHBDW6L3t+tYHfufmfK8jAModk8c3xksI0K9iQkfxdj5PNpdsAbfDteKvnwswiwg3j4fdRCQGRlZ9LSLe+WrkzRiijQDUlDUzfSk9GtIBnPE3Cq63lB8pcusv/ExswMfMJMWkUoTt86qSdHPjQEI+fMfhXZh3Q36JifUOTWzZlblw7+5jYyH8erHHVn8PPcr/9Kjax7Ey6sYl4nmGosH2Bb2xAgQ40JDvwxi5XTUICSZ8vjZKw+Fn02kTihIZOtkieDVLg9vLMvIUlwBxzf0KeobZachep2K97CuErNeejI1L5b0mTq
 2FpsdDOl
 ZePqgdilBWOMls51InD3+KELJIvwzL0zDgjl4zGmVd7HZOOeA5fTVAm+mzyzZzhjTovmYHVBAz91JPO6xO77vPo9lHuYgfEkhrSsDyUdjaYmHO08ZmR2gmOPqA8NzJ9rHZkkgWluTKIx7S8+FsbYXNPgluNiscu9uX1F7DNIGsbnqW/sB8dDG+iKtTNqtcZsqWKxB7ADWqAuKWiC6GCscW4XLAxLKhRiR17Bi/XULB2BzXVzg8FAROyBAgD3deH1L6dvXVpgbQfqNgSekM/YwVpga1z2dY4AZAeWn/XXbJllsMsWWlXYPjVCyPK9Ph71SddzlkKVXR5Y61csgOBdoOXWcC14ir4QDxBciZ6cpTWloE1LSMOH6A4gt/Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

Swap cluster table management is spread across several narrow
helpers. As a result, the allocation and fallback sequences are
open-coded in multiple places.

A few more per-cluster tables will be added soon, so avoid
duplicating these sequences per table type. Fold the existing
pairs into cluster-oriented helpers, and rename for consistency.

No functional change, only a few sanity checks are slightly adjusted.

Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 110 ++++++++++++++++++++++++++--------------------------------
 1 file changed, 49 insertions(+), 61 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 8d3d22c463f3..2d16aa89a4fd 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -411,20 +411,7 @@ static inline unsigned int cluster_offset(struct swap_info_struct *si,
 	return cluster_index(si, ci) * SWAPFILE_CLUSTER;
 }
 
-static struct swap_table *swap_table_alloc(gfp_t gfp)
-{
-	struct folio *folio;
-
-	if (!SWP_TABLE_USE_PAGE)
-		return kmem_cache_zalloc(swap_table_cachep, gfp);
-
-	folio = folio_alloc(gfp | __GFP_ZERO, 0);
-	if (folio)
-		return folio_address(folio);
-	return NULL;
-}
-
-static void swap_table_free_folio_rcu_cb(struct rcu_head *head)
+static void swap_cluster_free_table_folio_rcu_cb(struct rcu_head *head)
 {
 	struct folio *folio;
 
@@ -432,15 +419,46 @@ static void swap_table_free_folio_rcu_cb(struct rcu_head *head)
 	folio_put(folio);
 }
 
-static void swap_table_free(struct swap_table *table)
+static void swap_cluster_free_table(struct swap_cluster_info *ci)
 {
+	struct swap_table *table;
+
+	table = (struct swap_table *)rcu_dereference_protected(ci->table, true);
+	if (!table)
+		return;
+
+	rcu_assign_pointer(ci->table, NULL);
 	if (!SWP_TABLE_USE_PAGE) {
 		kmem_cache_free(swap_table_cachep, table);
 		return;
 	}
 
 	call_rcu(&(folio_page(virt_to_folio(table), 0)->rcu_head),
-		 swap_table_free_folio_rcu_cb);
+		 swap_cluster_free_table_folio_rcu_cb);
+}
+
+static int swap_cluster_alloc_table(struct swap_cluster_info *ci, gfp_t gfp)
+{
+	struct swap_table *table = NULL;
+	struct folio *folio;
+
+	/* The cluster must be empty and not on any list during allocation. */
+	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
+	if (rcu_access_pointer(ci->table))
+		return 0;
+
+	if (SWP_TABLE_USE_PAGE) {
+		folio = folio_alloc(gfp | __GFP_ZERO, 0);
+		if (folio)
+			table = folio_address(folio);
+	} else {
+		table = kmem_cache_zalloc(swap_table_cachep, gfp);
+	}
+	if (!table)
+		return -ENOMEM;
+
+	rcu_assign_pointer(ci->table, table);
+	return 0;
 }
 
 /*
@@ -471,27 +489,15 @@ static void swap_cluster_assert_empty(struct swap_cluster_info *ci,
 	WARN_ON_ONCE(nr == SWAPFILE_CLUSTER && ci->extend_table);
 }
 
-static void swap_cluster_free_table(struct swap_cluster_info *ci)
-{
-	struct swap_table *table;
-
-	/* Only empty cluster's table is allow to be freed  */
-	lockdep_assert_held(&ci->lock);
-	table = (void *)rcu_dereference_protected(ci->table, true);
-	rcu_assign_pointer(ci->table, NULL);
-
-	swap_table_free(table);
-}
-
 /*
  * Allocate swap table for one cluster. Attempt an atomic allocation first,
  * then fallback to sleeping allocation.
  */
 static struct swap_cluster_info *
-swap_cluster_alloc_table(struct swap_info_struct *si,
+swap_cluster_populate(struct swap_info_struct *si,
 			 struct swap_cluster_info *ci)
 {
-	struct swap_table *table;
+	int ret;
 
 	/*
 	 * Only cluster isolation from the allocator does table allocation.
@@ -502,14 +508,9 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 		lockdep_assert_held(&si->global_cluster_lock);
 	lockdep_assert_held(&ci->lock);
 
-	/* The cluster must be free and was just isolated from the free list. */
-	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
-
-	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | __GFP_NOWARN);
-	if (table) {
-		rcu_assign_pointer(ci->table, table);
+	if (!swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					  __GFP_NOWARN))
 		return ci;
-	}
 
 	/*
 	 * Try a sleep allocation. Each isolated free cluster may cause
@@ -521,7 +522,8 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 		spin_unlock(&si->global_cluster_lock);
 	local_unlock(&percpu_swap_cluster.lock);
 
-	table = swap_table_alloc(__GFP_HIGH | __GFP_NOMEMALLOC | GFP_KERNEL);
+	ret = swap_cluster_alloc_table(ci, __GFP_HIGH | __GFP_NOMEMALLOC |
+					   GFP_KERNEL);
 
 	/*
 	 * Back to atomic context. We might have migrated to a new CPU with a
@@ -536,20 +538,11 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 		spin_lock(&si->global_cluster_lock);
 	spin_lock(&ci->lock);
 
-	/* Nothing except this helper should touch a dangling empty cluster. */
-	if (WARN_ON_ONCE(cluster_table_is_alloced(ci))) {
-		if (table)
-			swap_table_free(table);
-		return ci;
-	}
-
-	if (!table) {
+	if (ret) {
 		move_cluster(si, ci, &si->free_clusters, CLUSTER_FLAG_FREE);
 		spin_unlock(&ci->lock);
 		return NULL;
 	}
-
-	rcu_assign_pointer(ci->table, table);
 	return ci;
 }
 
@@ -621,12 +614,11 @@ static struct swap_cluster_info *isolate_lock_cluster(
 	}
 	spin_unlock(&si->lock);
 
-	if (found && !cluster_table_is_alloced(found)) {
-		/* Only an empty free cluster's swap table can be freed. */
-		VM_WARN_ON_ONCE(flags != CLUSTER_FLAG_FREE);
+	/* Cluster's table is freed when and only when it's on the free list. */
+	if (found && flags == CLUSTER_FLAG_FREE) {
 		VM_WARN_ON_ONCE(list != &si->free_clusters);
-		VM_WARN_ON_ONCE(!cluster_is_empty(found));
-		return swap_cluster_alloc_table(si, found);
+		VM_WARN_ON_ONCE(cluster_table_is_alloced(found));
+		return swap_cluster_populate(si, found);
 	}
 
 	return found;
@@ -769,7 +761,6 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 	unsigned int ci_off = offset % SWAPFILE_CLUSTER;
 	unsigned long idx = offset / SWAPFILE_CLUSTER;
 	struct swap_cluster_info *ci;
-	struct swap_table *table;
 	int ret = 0;
 
 	/* si->max may got shrunk by swap swap_activate() */
@@ -790,12 +781,9 @@ static int swap_cluster_setup_bad_slot(struct swap_info_struct *si,
 	}
 
 	ci = cluster_info + idx;
-	if (!ci->table) {
-		table = swap_table_alloc(GFP_KERNEL);
-		if (!table)
-			return -ENOMEM;
-		rcu_assign_pointer(ci->table, table);
-	}
+	/* Need to allocate swap table first for initial bad slot marking. */
+	if (!ci->count && swap_cluster_alloc_table(ci, GFP_KERNEL))
+		return -ENOMEM;
 	spin_lock(&ci->lock);
 	/* Check for duplicated bad swap slots. */
 	if (__swap_table_xchg(ci, ci_off, SWP_TB_BAD) != SWP_TB_NULL) {
@@ -2992,7 +2980,7 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 		ci = cluster_info + i;
 		/* Cluster with bad marks count will have a remaining table */
 		spin_lock(&ci->lock);
-		if (rcu_dereference_protected(ci->table, true)) {
+		if (cluster_table_is_alloced(ci)) {
 			swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, true);
 			swap_cluster_free_table(ci);
 		}

-- 
2.53.0



