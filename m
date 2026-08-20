Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F6ACC5DF8C
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 18:55:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 667B66B009D; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63F036B00A1; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4DF526B00A3; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0BFB96B009D
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 14:55:32 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 85502A02AD
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:31 +0000 (UTC)
X-FDA: 85122551262.01.26C556C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 7DBD7A0009
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 18:55:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CGJyb5WY;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787252129;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1s3VW8yTsr4TVl56ZGEELFaY8ZfEaJA3oze+bTvepo=;
	b=nJLlNtFW7BpakElF3ah4j44cHZ/hfuxhKdhOmnbWKaZVjayPsDs2/rs2IdhjAW9KPzgSp3
	lUhf6MPopHT6ukSl1T5TIf8p6TcsrEkA0p8lAM6bEEXYgtsJZRyU3vl7m24WwtOEAh2NPh
	8Af+GDPT90lcYaZ4ZStDBbmAoOkfAzc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787252129;
	b=1syRyoqDu2/P//UvirOiwzgXdbLZBYTWXyOn18f1HhpMLDxGq5yXmOEcd+CSu1LjUHjMU0
	xTBo3LlKrbUgnHuMknL3xUrwwxA0VuH/QoORyDY/qMDtGDK6RHn1DpjTCDjyJwtdk8Xa5q
	2m6hRSi2YtrtodZ+q1PHMmKhOEVOsmI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CGJyb5WY;
	spf=pass (imf15.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 43E70434A0;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2558FC2BCB3;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1787252128;
	bh=FkFUYML3XV8JWw54qlKPTW7rYb5oxaI1kamvWQ5J08k=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=CGJyb5WYKnCtVa35pHxSENz8Ru4Hg9/k692pyNSdfN2ZQy35kn0v6wp5yL7W/IDsG
	 DSS1LfswD8QJhjFBjdRvX/LbT7074PjCfVgei+Xhj7PuDKORfcJNU4XvTqW8FrgK6l
	 LvxcfmyKpfl47r3O69j7GOtIkeVi2Yfu6finAFg1NqzwB98Ub/jVyD+zxcU6BQKdnQ
	 trZwS/On8nap7NRhwZbxSBVuVUpOCs4tv+IRqdBw5LbVVuuXGJgHZJSRZGLaTJvrpd
	 dry7gPIspg4QyDwtP22IdxLswRzO0VNE63LjM5SFz2EoURzpZhH6a+QztVVXgQ+1lG
	 oRftG+fZG3o0Q==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02660C5DF86;
	Thu, 20 Aug 2026 18:55:28 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Fri, 21 Aug 2026 02:55:17 +0800
Subject: [PATCH v3 04/18] mm/huge_memory: split the routine for splitting
 anon and file folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260821-swap-thp-cleanup-v3-4-9b43f5163238@tencent.com>
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1787252124; l=8202;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=o2S8TMWLz7STFa+m4GqxK4/Q0Rl6U6CqX2p2Zm1CMpA=;
 b=xYaGlOBj3wxj41dOviDUwCe9+7Rj1ObGbtXvFQkivEXB2Eo96MWrvqMwPvybdECYC+Y9fhSQ1
 9o/34Ox2HyGBY7UrUy5EH8vhB2ihH57x0pG+VXdmZo9wk6ROen9XsRi
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Stat-Signature: 5t6ah6s9q4cauop1xznry8388ymbkgoh
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 7DBD7A0009
X-HE-Tag: 1787252129-145061
X-HE-Meta: U2FsdGVkX1/Dmhkhpzm11t1XwfiZDelcmXRo+dJIBVRVBFlzbzZup4yk7m3wT2zP6+H5rsDO0rVZqvdF4DXT5SeyEU7ODsF/If3mfeiDrmiLlwQ0d7Dc5mrzNgpgGg/EFye/o6PxXBHMBYvqlrEiTg05IEirQGNdbAcFbWuYgD+L4ndZf+DDWz2tRi/ggtLVTy5aWTCmdTID28r81l36LgeME42GiIibNR5g3/+w3YuQrFpbOQ8zn4go0C7sBmArIDPiOWWL51eC6HeR/AFVvXKe7kzs3/5pidr613J+Mw0D1SzZrTNq884m+TOXTICWWux2SiX51fTwIRc1GoXvkkkyAIWRi8XF6lX6xDr1SA01hR1+Ox1Ykk/AXeExkV4FHD1HcMAV2gzBFTOgXUWWbBiEBWXowdEy4JkRSfyE9C6JTLRwhLIRqIGtFqwHqqq91G4tAXCSVKJuzBxZdbESlzBkhFUpGmxG2vtUMV07klLtlisjohxHbNitWwqlh5wCUSx00m0x2n+HBUSIUrJm13j3Jpbmu3CI0bl3YhcGofRRDUda/g/JHcvRvTX6OJ0EF/gXrHbsM1WjbLFfTBI408JDwpS2766XTI3TtCQoTFNTzMoQDD375kCp0xZR8U0uHPIRidF2HiPJbAaAGJ1hOI2f1FwX51IapsQjYeYn35O75F5tijs39rBLhKv47NrvUMfPiwkI/6Wn9qmqSt9z7hjYkX/s3CdeYCYEani9TnzyHuz0nRPPPoEE0QnePEnm5w0ct2s0/oinDu/xq/kU+Pps94IZksKf+1sS8QLKAAJ5jjhKFlKx/GUNJgJ6NXEiOqH2g2F1KdX+CQuQihzA112Dnpon/g88mN5H8T6kWAw3HZ9jkMZyJjUVGPIiNDdRE1yoQ5dXEAelxcww3o6786Hewrsy8bieTX92Cby6zgoXMbuxYe2rSIew4xgzfp/ePS1iyBmbivlrJ5Hwjpd
 04k2gbwx
 idTG40O0NTk5qbwRRQZ3B6XdkkKaaY/MKaYiTwp416MqLUJx01grkSpWwc4VvgkgZCW+66jdikVv2PYSSUOsafSL132F9hafxYRonF8kPKUhKlDqXBAVv86cwI0/IXrULwtHBFZFS6W8cfN+zjlj21Zqi8BGY/bNm466C+yCrLvWT2AHENNcZ+8XCq91aRnuHbr7xJUbCjb5+uXU+22+XhK+TdTTQR33dgaCRHO0vIvKr7A5pXRBsmB/W2GjUEZPov6TiJcLDVrxwXHpKJgNTh8FxycACAvdaWqi1wwkQObIsoJnCxX7XfMAe0UD2G+3zqnBbWB43rtuVJzL6hdU4PSve1PKYFzwv60CSvcDpz6n6IWZXCNYupxhtzIBixlT4xHsWZTILpcsFY+nz2qUkXC7NK9GjD8YjDzfe6cJmrrptO2mTfkS6mfQcOdLTQrs0HvIn/G/YQJXuEnqkX5U6k/o4JYXHtCPHcfStVY1I1RPDUFMZxyWspuKt8GzVMR6zNxXmDBK8pgohp73Wk/0HqimDOQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

No functional change intended. Before adding more logic, split
__folio_freeze_and_split_unmapped() into an anon and a file variant so
each path can evolve independently. The two paths shared little beyond
the folio freeze call, the LRU locking, and the unfreeze skeleton, but
differed in all other per-folio bookkeeping and routines.

While splitting, some cleanups become easy to apply, and helped drop a
few now-redundant checks. Also introduce a folio iteration helper to
avoid a common pitfall of iterating post-split sub-folios: a sub folio
might get freed mid-iteration as pointed out by Zi [1].

Link: https://lore.kernel.org/linux-mm/DKJSFCLP967N.YBR4DNK1NM2N@nvidia.com/ [1]
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 119 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 75 insertions(+), 44 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 7fb603ac500f..c3fd6757c14c 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -3933,11 +3933,9 @@ static unsigned int folio_cache_ref_count(const struct folio *folio)
 	return folio_nr_pages(folio);
 }
 
-static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
-					     struct page *split_at, struct xa_state *xas,
-					     struct address_space *mapping, bool do_lru,
-					     struct list_head *list, enum split_type split_type,
-					     pgoff_t end, int *nr_shmem_dropped)
+static int __folio_freeze_split_unmapped_anon(struct folio *folio, unsigned int new_order,
+					      struct page *split_at, bool do_lru,
+					      struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct swap_cluster_info *ci = NULL;
@@ -3948,7 +3946,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	bool dequeue_deferred;
 	int ret = 0;
 
-	VM_WARN_ON_ONCE(!mapping && end);
 	/*
 	 * If this folio can be on the deferred split queue, lock out
 	 * the shrinker before freezing the ref. If the shrinker sees
@@ -3956,7 +3953,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	 * lock and must clean up the LRU state - the same dequeue we
 	 * will do below as part of the split.
 	 */
-	dequeue_deferred = folio_test_anon(folio) && old_order > 1;
+	dequeue_deferred = old_order > 1;
 	if (dequeue_deferred) {
 		struct mem_cgroup *memcg;
 
@@ -3986,24 +3983,72 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		rcu_read_unlock();
 	}
 
-	if (mapping) {
+	if (folio_test_swapcache(folio))
+		ci = swap_cluster_get_and_lock(folio);
+
+	if (do_lru)
+		lruvec = folio_lruvec_lock(folio);
+
+	ret = __split_unmapped_folio(folio, new_order, split_at, NULL,
+				     NULL, split_type);
+
+	/*
+	 * Unfreeze the post-split folios and put them back to the right
+	 * place. Keep the head @folio frozen until the end: sub entries
+	 * in swap cache must be updated first, so a concurrent
+	 * swap_cache_get_folio() cannot return the head folio for a sub
+	 * entry (folio_try_get() will fail on the head @folio until unfreeze).
+	 */
+	for (new_folio = folio_next(folio); new_folio != end_folio;
+	     new_folio = next) {
+		next = folio_next(new_folio);
+		zone_device_private_split_cb(folio, new_folio);
+		folio_ref_unfreeze(new_folio,
+				   folio_cache_ref_count(new_folio) + 1);
+		if (do_lru)
+			lru_add_split_folio(folio, new_folio, lruvec, list);
+		if (ci)
+			__swap_cache_replace_folio(ci, folio, new_folio);
+	}
+
+	zone_device_private_split_cb(folio, NULL);
+	folio_ref_unfreeze(folio, folio_cache_ref_count(folio) + 1);
+
+	if (do_lru)
+		lruvec_unlock(lruvec);
+	if (ci)
+		swap_cluster_unlock(ci);
+
+	return ret;
+}
+
+static int __folio_freeze_split_unmapped_file(struct folio *folio, unsigned int new_order,
+					      struct page *split_at, struct xa_state *xas,
+					      struct address_space *mapping, bool do_lru,
+					      struct list_head *list, enum split_type split_type,
+					      pgoff_t end, int *nr_shmem_dropped)
+{
+	struct folio *end_folio = folio_next(folio);
+	struct folio *new_folio, *next;
+	struct lruvec *lruvec;
+	int ret;
+
+	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
+		return -EAGAIN;
+
+	if (folio_test_pmd_mappable(folio) &&
+	    new_order < HPAGE_PMD_ORDER) {
 		int nr = folio_nr_pages(folio);
 
-		if (folio_test_pmd_mappable(folio) &&
-		    new_order < HPAGE_PMD_ORDER) {
-			if (folio_test_swapbacked(folio)) {
-				lruvec_stat_mod_folio(folio,
-						      NR_SHMEM_THPS, -nr);
-			} else {
-				lruvec_stat_mod_folio(folio,
-						      NR_FILE_THPS, -nr);
-			}
+		if (folio_test_swapbacked(folio)) {
+			lruvec_stat_mod_folio(folio,
+					      NR_SHMEM_THPS, -nr);
+		} else {
+			lruvec_stat_mod_folio(folio,
+					      NR_FILE_THPS, -nr);
 		}
 	}
 
-	if (folio_test_swapcache(folio))
-		ci = swap_cluster_get_and_lock(folio);
-
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
@@ -4013,7 +4058,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
-	 * list. @folio should be kept frozon until page cache
+	 * list. @folio should be kept frozen until page cache
 	 * entries are updated with all the other after-split folios
 	 * to prevent others seeing stale page cache entries.
 	 * As a result, new_folio starts from the next folio of
@@ -4023,29 +4068,15 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	     new_folio = next) {
 		unsigned long nr_pages = folio_nr_pages(new_folio);
 
+		/* compute next before the folio can be freed below */
 		next = folio_next(new_folio);
 
-		zone_device_private_split_cb(folio, new_folio);
-
 		folio_ref_unfreeze(new_folio,
 				   folio_cache_ref_count(new_folio) + 1);
 
 		if (do_lru)
 			lru_add_split_folio(folio, new_folio, lruvec, list);
 
-		/*
-		 * Anonymous folio with swap cache.
-		 * NOTE: shmem in swap cache is not supported yet.
-		 */
-		if (ci) {
-			__swap_cache_replace_folio(ci, folio, new_folio);
-			continue;
-		}
-
-		/* Anonymous folio without swap cache */
-		if (!mapping)
-			continue;
-
 		/* Add the new folio to the page cache. */
 		if (new_folio->index < end) {
 			__xa_store(&mapping->i_pages, new_folio->index,
@@ -4064,7 +4095,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		folio_put_refs(new_folio, nr_pages);
 	}
 
-	zone_device_private_split_cb(folio, NULL);
 	/*
 	 * Unfreeze @folio only after all page cache entries, which
 	 * used to point to it, have been updated with new folios.
@@ -4075,8 +4105,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 
 	if (do_lru)
 		lruvec_unlock(lruvec);
-	if (ci)
-		swap_cluster_unlock(ci);
 
 	return ret;
 }
@@ -4230,10 +4258,14 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			ret = -EAGAIN;
 			goto fail;
 		}
+		ret = __folio_freeze_split_unmapped_file(folio, new_order, split_at, &xas, mapping,
+							 true, list, split_type, end,
+							 &nr_shmem_dropped);
+	} else {
+		ret = __folio_freeze_split_unmapped_anon(folio, new_order, split_at, true,
+							 list, split_type);
 	}
 
-	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at, &xas, mapping,
-						true, list, split_type, end, &nr_shmem_dropped);
 fail:
 	if (mapping)
 		xas_unlock(&xas);
@@ -4333,9 +4365,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 		return -EAGAIN;
 
 	local_irq_disable();
-	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
-						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
-						0, NULL);
+	ret = __folio_freeze_split_unmapped_anon(folio, new_order, &folio->page,
+						 false, NULL, SPLIT_TYPE_UNIFORM);
 	local_irq_enable();
 	return ret;
 }

-- 
2.55.0



