Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A57BDCD4F4A
	for <linux-mm@archiver.kernel.org>; Sun, 17 May 2026 15:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 898206B009E; Sun, 17 May 2026 11:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 849646B0099; Sun, 17 May 2026 11:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 53AAB6B00A1; Sun, 17 May 2026 11:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 343316B00A0
	for <linux-mm@kvack.org>; Sun, 17 May 2026 11:39:55 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C5A7712061C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:54 +0000 (UTC)
X-FDA: 84777322308.24.8251815
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C91A31A000C
	for <linux-mm@kvack.org>; Sun, 17 May 2026 15:39:52 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i4d9ocNS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779032393;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZ8AUYZf35Ka5WNGIccOBIjgqY4KNWIMopULZViMxVI=;
	b=GuwZcZnIJUFKSB1mLHE/rOkLzWrX8+nG56piPcBPkPONAEZ0qg+tKvAeyMeuodgDMFMTzM
	0HxjyRFgbETpHT15bSKomPXNLZmdXbCIxpnaN4d1vvR8TrN1QMJJimosrcrTD9lbosBiG1
	TCTGXBV6shTGafovLhgTP8FWV+uDqS8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779032393; a=rsa-sha256;
	cv=none;
	b=ci2y7lTaH/0tPcO+vGYit8mJWzCJxyBOGevsLIiXaeWxkh6OGdY13i7uF4D9hreFJoGarq
	QQGt0E2ebJJKG0E1qizajjh3EUssj08jRRiM+7kvTJLKXI0gnxXjiQ+EyJ8Mg4OsJ+8PXb
	evaZH1gx8rrj4r2/KYXc3pVeuYds2do=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=i4d9ocNS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 6EE66445FB;
	Sun, 17 May 2026 15:39:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B0B2C2BCB8;
	Sun, 17 May 2026 15:39:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779032389;
	bh=ufU1ySsOqiRZPnCHz7wte/G4BO/nmQmUUaeDl7sofnQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=i4d9ocNSV+J2qEOZBzsNaaBcr1rrZV78Pzms/udoUFzqNM/dHWNtoGEKRooDbhjKn
	 9bdwZ26RQ6qDr5Nfgaao/o4aM/0/X68HzhqcUqWgbAg2SOCotz84w/+hdHu1smTq2N
	 LCA3xMEqd4iLsqQdMwQzsR0C5gQFei1Eu9qGGM5p+/tWUYmazvVmGV9c1OGK2mChyv
	 5rsohQR+L/aKNQAOeIcYoVdvu3eJRfBFe5bFdOUUmmW/TB0XKrIUeBD9/wViZ7r0W3
	 rLBNA88zt17t4LKVSfSrNSxwLZRwcGod906+px5oErBZbs3yl/ItfAvoE4NLdno70X
	 NMlKjCKxj5xHQ==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3ED5CCD4F4B;
	Sun, 17 May 2026 15:39:49 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Sun, 17 May 2026 23:39:48 +0800
Subject: [PATCH v5 09/12] mm, swap: consolidate cluster allocation helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260517-swap-table-p4-v5-9-88ae43e064c7@tencent.com>
References: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
In-Reply-To: <20260517-swap-table-p4-v5-0-88ae43e064c7@tencent.com>
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
 Usama Arif <usama.arif@linux.dev>, linux-kernel@vger.kernel.org, 
 cgroups@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779032386; l=7205;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=c3oYSj0Wv0VB37K97Td0A16y0BTkJDC6ZCRW5Z0N+vc=;
 b=zqRQIF0gJ1NS70Y3n4NafR8BRy6VcNbWVCBT3V3wQlQir61v4EF1nqvCQihtd/BI6Arz34fXN
 /X7F3BMdUmBCuMh2dNHAb2GzYmlMa2rgpiG/Xai0f4fA0JlMYKPDPis
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C91A31A000C
X-Stat-Signature: 7584rruoojpbjac7iym9gwojfoqbqzyp
X-Rspam-User: 
X-HE-Tag: 1779032392-281131
X-HE-Meta: U2FsdGVkX18cQAHVRog18oXBVk9Rr7SHaN/BtLBgZPieJnW9kRxAjrgvMdTN5gqgm2QPV/77CpjNc1qH5oNW7vmmyNFYhgYhBtqF43n07cnuhRtRrXIZ3QhjVnzko6EaD+PmcTci1SrK/uyy1JFYo+q3HL+0bsv44VEIE02olvTt6NVEdG0rAQAST6tlvvhW0uUI1BEfR0UouIzUKFa+w27BHIBFayOEia/KLT1mhLd8fUng66pWdjmXk1FDGzZEr8uxY8RXrBLM+XwJdoyKQcBdpsRBE2RrDKy51C2hu18QrFJacZ7/4oBfmOjQuCxAVZvgfmUqfRIwO3NlTH0EHTsNyeVzUCZ0uIqlAduEGKo1kqwvHMVE0XzHnIwRLjGHmMMvMV/zvLAdqf6pUcuvNVKbPE+SPamfS0FbhmRt08vNy/t2r2WCSK+vTYTBi6QysU3RscxgZFf4PhlK8t6HNv6ox1JfoRoo2DE4ZMvOxL1of8hIstP9t6OvzpaTMNpcugGhK08URoNUDc70ba6VQ7U2MwIc2E4cZxPh/Gblpc1B0kl4C1WXlaXruAqDCEsSKF2tzk/VWlC3g3CTLxqj+pedWKRjxdkU0G9nDZ3cgAOe2amJ0QQRcEL6cGyECCHG/7Ma6HSVKcZbZD3CV8eHVk9EZ+BA+kew6f6MCaVjxs+E36+TfEK6+EeuU0036jQopUI3V7iQs48ehBihz3rnVYXGAuG37w3OSQLSkN3JLVb1ev6MUW5J7SofDVmnQGf48BNuS1KGuYQ8evJOdqbMMAh46ARhLLlsEFgq7U/zSoSdpDjP08KtGGCiYSDReBwuPU8SPC4+YjOGbuqQ06LT+u3Gr9fHMyBvt5jSHliV1MCs+tkcKP4OkbrbLAfD6Oqdy0TcYY56ggH9oSPR7xk44J69BdTtDi/pLdXlH/pF2rqmLuAAad3LE2M+uWf3/1hhFE0TKCLeP+LPdYGEP0U
 VAGKIY74
 Qd/Wo0khS+AikxA+j3N0P+2LH2JDol8ybvv1EJlALoX7q0noiQGo3t7CbJzjEj7y2KWTrk3IFQ9oRxUzmB78Bk+ZWSIzxfwEvAKR0MXzGw8QodnKJfnU1UZ6wq//mK+QhkBaH7WrXcIVBCx3XTIYzGQa0CrDCaRQtHu7Y2Gtce34bqetFXfBTI1ANhJ0QnUc97OgwtR0M0a9EHy5W8NLP4it0elLJTnJrmHvf+bvJODBVty1Qd/ANtE0xXjtYuv2raFpNJbmSypJv2Do0F5nSOb1gEo2AgSZA6CSEFsWiTSV43NwI8MroOE0+nrYgY3sgxcRX3iolbuuHk4cltpn6kHXSBtCM899ddDCza/jZOq1RwAEI7mnSsC5XYRP5d2L8eo5Xb/rfC3B/G90=
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

Acked-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/swapfile.c | 110 ++++++++++++++++++++++++++--------------------------------
 1 file changed, 49 insertions(+), 61 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index c9c80ba9252b..7740ba99f87e 100644
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
@@ -3054,7 +3042,7 @@ static void free_swap_cluster_info(struct swap_cluster_info *cluster_info,
 		ci = cluster_info + i;
 		/* Cluster with bad marks count will have a remaining table */
 		spin_lock(&ci->lock);
-		if (rcu_dereference_protected(ci->table, true)) {
+		if (cluster_table_is_alloced(ci)) {
 			swap_cluster_assert_empty(ci, 0, SWAPFILE_CLUSTER, true);
 			swap_cluster_free_table(ci);
 		}

-- 
2.54.0



