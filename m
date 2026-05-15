Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 712F9CD4851
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 09:54:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A6286B00A7; Fri, 15 May 2026 05:54:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BB5E6B00A8; Fri, 15 May 2026 05:54:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55F526B00A5; Fri, 15 May 2026 05:54:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E34C06B00A3
	for <linux-mm@kvack.org>; Fri, 15 May 2026 05:54:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A3D4040416
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:25 +0000 (UTC)
X-FDA: 84769194090.27.4895598
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id BE0C520005
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:54:23 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=insYHJe0;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778838863;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uZ8AUYZf35Ka5WNGIccOBIjgqY4KNWIMopULZViMxVI=;
	b=oiEy4JrTlfhCM2MOlrzaS8H8S4euRy7CeuGQ7N0Tln1wYRu4L5hpm/jaaPBjgCeCUvjOF5
	gEYlxh1ml2PEO5rmTmWhnWzKiVWja3Qc8jTDvutFQmptGuGD4CS2z1fuTch7jsEvkBtfp3
	e4FtLmv8P/K6ta9UwZuCtbTPZ4LcoXI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=insYHJe0;
	spf=pass (imf03.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778838863; a=rsa-sha256;
	cv=none;
	b=ZbBY7daZ1M40HZyNrgmJds2uLMcwa5Qkp7gFN5+QwnpAETngCdkZhLK3EkUbuNj2ub2Nxs
	LVCtKN9BpNFfgehdH4W0CyAQsQRURG1nlMN/skd9k/CWT0fGnOCzODCR1P7dmI4WDU3xmK
	+IIRFPkeZk/2v1BmqFWwTI1Hoixn2uc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B06276133A;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7494BC4AF16;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778838862;
	bh=ufU1ySsOqiRZPnCHz7wte/G4BO/nmQmUUaeDl7sofnQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=insYHJe0sTupUf3T5af3Jic9gKSF+xtIIpQZWKF6Q5I/E/HDA/q8fwCCsgUozJEOD
	 yW/mQ0OjZ2ZAetyn2ak0HDsRVy/EGo/ajYej9AvVdvPV+9aLkyvxCJh/ZuDQFNW5Km
	 /v7vh4Ng6huWDM4Ph5aH/HFBgOMKxq5SD38j5i2LEe/mFTs0qm0PNSa9SmOKtLJ24t
	 rDa4W3Yz14F9JWUhxl5kYOGZXJAPf9ExbLCsLLZ5ECR38cUyGXMsfWwWO4kCZUNlC2
	 QquqOGG7S5DM08nnpXuGH9mxcKrwXJZbq7t4cmA0NBaVLaLKtn1yUR8nXj5HejYAz/
	 Po4qSv4PfPOjg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C5DCD4F25;
	Fri, 15 May 2026 09:54:22 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 15 May 2026 17:54:22 +0800
Subject: [PATCH v4 09/12] mm, swap: consolidate cluster allocation helpers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260515-swap-table-p4-v4-9-f1b49e845a8d@tencent.com>
References: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com>
In-Reply-To: <20260515-swap-table-p4-v4-0-f1b49e845a8d@tencent.com>
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
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Kairui Song <kasong@tencent.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 Yosry Ahmed <yosry@kernel.org>, Qi Zheng <qi.zheng@linux.dev>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778838859; l=7205;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=c3oYSj0Wv0VB37K97Td0A16y0BTkJDC6ZCRW5Z0N+vc=;
 b=GFERMLXa99LMvoYKGyKWZYWNPWKn1HAj+dK/PicwD0r6Yuwz3/s41JmuNamexA8IE/Wg4fn+L
 Qsglc5TDEe5AcYhYxh9C5btBfr+dTSM/dJ98KUIAadgx6HC6RaDFYYV
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BE0C520005
X-Rspam-User: 
X-Stat-Signature: p7zkt955xybyrgkhen18m377xs69nyha
X-HE-Tag: 1778838863-663101
X-HE-Meta: U2FsdGVkX1+5x4yZov+nhIhY+zUA7QWTZRkgkZoOV9Hd0fDCeJK+6SZjEHD36LhbSgSkoIFDusaJIHfJgux9aImhpBx7OWdr6hGoRcmT26Eo0dEf+zOLea9/Sdp3/xwCPwCiezFrDmhxtBPvMs4/OX37bkbTWUOUpQUDkqKokxy5QSorAiNxniRUGJEpoCV46zEBEasW3eqDG2E0oc0aEHybExFV24WJvKjKYHRPzi/K0AVYUhQWkQGxApzaM+Hsw9+MSR4Bn9EAXmTLomVmKZhRW6Svuv8XZbKoB9Wn3RDmb2bUfUyWlMlMVdvQP67Xw+sz7bUHOZKawGdST6gX9pnbEPbcH0n3cAd9CuoCJ/gtJbZ7xihKSjTEabqphSRHkUbPA7pJsZU4PRK1fKe9yd63vIL8O2NITwNwlRhr6Igf04vrc1XJp/TY6S+pAV0JpU/zttl+A3lhoXE2H0LtO8ANYFmEowurYqNrByjUwBsEalTzWNFi+SMOXUiBWdjYJHuqlW54cIg3ZGdW4WNbsUxcbSXhHta4WDrmSEEZmII3ojzAKzu8zOAwYVadRLyU3dNj+3IDQIafj1J0wfIMAX6CXVkSvuz1Z+IzV5ACkSpjQBY9ZRMHHtwFR+2XUhvImUOqiEBek35XSU5ZawAiGIz3gLLj6XhMrEAwz/0aftH1GEd9D35Rucqw0ojhbf/blzmL4+MsUVZgLQ1R9FtCRcE5XL+x8jw56NembOmJwQTLIuzlYDjv7G/IiVYOOjoIC8cB+valXHRjWuKMfam0hsdo0C1ZWso0Gndi1n/Gygo+Cl0I3SkqMgUj8FzldGai1iFvBr7mzuQ8GldQPd9nNwOVs6gVuuHwmxhfe1oVazXo8PdryD7fSSK5Ttk972W+ges62GNn+9rNznmXb3/cr0mFyNSUKgR9T+vxXNXIrqKq9FKNp/oXg5u4JR9fcwMZrmFV4O2qIFrJeucK9e8
 IN1K2YLV
 eubsJVwdGZH+/HjpN+blD7cGF3t59s3dhyS88jhBt9tkKGp4G28YY86Sxcp6v7X+nWWzqxh2QFTaCBpuDZM5A3sl4P3ug111WRAd5pPl5n9kGQ4xI1Tqc68UF1zGv9omiI1fBJWOUGTHZygvl1Y2ypmY5pLVxN0SqgkUrTXPOD46E9C0kx5usA8RPqYWKhTt4i1mmK1GtP+pwZ8SnYYZGtY/skbGLNuFSb+9XT0V1Itu1KeRfvIGROCjJSBxchoneMndzs2Mlu3kw1d+yZpCEGZETkFpEWjw3YrqBE34KCwMuEP8epTcexbh+71tQdEx3vCFJvsHEw81RjSNIDeWGGjtfbH++88IKqpcpWu8EDFYRhwbrR12LtJXCnymvQoP9E/N8QmS1VNWG8Ew=
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



