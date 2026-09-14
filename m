Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 818EFC88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:16:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 143CA6B0098; Mon, 14 Sep 2026 13:15:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D50C6B009D; Mon, 14 Sep 2026 13:15:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4F846B009F; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id A02296B0098
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:15:58 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69DE0C0201
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:57 +0000 (UTC)
X-FDA: 85213020354.01.3F8D1E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 57237C000F
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:15:55 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rAgQrPY9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789406155;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GgEfTTEblLoVF9jxjjlBdj5fhWRNdKAnoA7tzKKLiUg=;
	b=LyERMDvgbtUtmn789fB3sTSHqWKo3weFj+BX/E7ZimaspW1zwWR3LgUy/FsQesGUAZ1y2z
	E5g6+OoRs0cxtyuZPJHZA0D1vn0wHqAD0R4RMyS6JM+qDWxYwGspy3DoZYurHMYXh6lOGd
	q9EPEzMael19E/FIhkA2vzQh1vdB/PI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789406155;
	b=CeVqqjMEeQa1ZBBW1q2ugxBABGrjR1Nu3cJZnhfkYtZ/IYxfr4o0LHwQk4S96H+WdE0mzc
	pDPLYrXUl87cBhI32PAppUPgilLSJjsFqUkiA6QwYQTO71I84bT+9tWbcnQSJfEUoW1WFK
	5BEJfCsg7ZAmLY+TRD8+OpVtU0uIZh0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rAgQrPY9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EFFD643E5B;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D11A2C2BCF6;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1789406153;
	bh=vpyZblKSFZcYpGwTTPPtcEZT8s+XgHlHmn55xd/8CW4=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=rAgQrPY9b7KzVDsWwJI4ziWol4HParHPS4y9vwdSCihm1kMza2Zl9ulLDliunnAjg
	 8nDKGTKeBFZaYQDyh4xInTnjDu5X2iYyphBWr3rpyxAQLVgjCrPQw1JVYm5fvv90S/
	 92re7LYTFw9N4tGcxsruC6VwY2x6M9sO90/cAJOS27yyLeqtUhSUSVUQberZ2sp05C
	 SE/iQu759p6JaQT1bH1F5GxNlauyR7jZZ7JHmSNUhfOFznt4vUrdNlfnucsd804CDC
	 jMj8fTYHt1xj6beJCA8BrVXuPgMbw4woThrDggRQtIKc77rzEC8TwXkuJEXiFbBmHi
	 zGDi0zKhYOtDA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BB0C6C88E79;
	Mon, 14 Sep 2026 17:15:53 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Tue, 15 Sep 2026 01:14:45 +0800
Subject: [PATCH v5 04/17] mm/huge_memory: split the routine for splitting
 anon and file folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-swap-thp-cleanup-v5-4-39878b37dfb0@tencent.com>
References: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
In-Reply-To: <20260915-swap-thp-cleanup-v5-0-39878b37dfb0@tencent.com>
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
 Yeoreum Yun <yeoreum.yun@arm.com>, 
 "Kiryl Shutsemau (Meta)" <kas@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <kasong@tencent.com>, 
 Kairui Song <ryncsn@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789406149; l=8306;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=EZ5MURXDy479u0ESyArci3PKv7DgHL+vK2nAXaF0YN0=;
 b=tmEOzcYQh7BUs4kNys1LPKuPqL2RLWN/VVlqB9tO5zhyrCaqRHF2zHgg4zGrvgAmTcyCOEIGq
 tb2lzyWLRULAc3kv5MEDS63Tvld8dkvaB8nAD3GVLaK0KWKzqFfEAcK
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 57237C000F
X-Stat-Signature: kciku3jq6himhqam7tfcyukrmrjpq8oa
X-HE-Tag: 1789406155-658931
X-HE-Meta: U2FsdGVkX1+iqIy7cxhTC60uT2qK5C4YqWP9L/9+cuc6+F58VLrX03WWt3uNwlV24xjhmimCmdGWgkpqjcyJyBW/IagCz2x+XVArM7b3lhAA5Q1lfAfH4MwbWdfYDG0iPx2EhG7Pru5nTFE+Vitp6e+p5+Lm5SAEOEZYXCuDgM1HjFVFmjKxOMu05bH5vIpnkCoEEyl7qOFOpZwJ1vp0vXdcZvOwEw0B/PwoNNji3MvduDS21v5Kw5IJBcYLkhWecvNGqGnZzJv0MdnIcgjPY2kjITPNWQmB8bvEtC+YZsRMyuVL6kNJv3lE/NbTOFNlzoODzh8EZ+SD3DpOlsdmj4zLoZLcUyK1jtdwU77crL8uOQGgGriTCS7BREuhDGeCtbH2RjofMhT2zzDpPQYKHa3yfyZrFxFT2JpW57c1WxjMWOlWW3hDlVELFnPCqkv/sGTWvF8VwYptNBdIRovSd+lk9QJMZa8+vZRrZug9S0vhyX+EwVXO5Cc4KhMqH0LaiEG5BTbTl037RmXTM58jsEMiP1RJ7bA6r3LKkjdEns4HqGOs8ngbrULYcob4XaeKxqLO7g02N3aTJmJjX3jHw7nmDiv+BTa+9nUvPIQlaZgR+nRef7PNmaNSo/e2a73B0ccF7agluzgrJDC/pGiZtWDk7svDpt1j/IJIG1U21ynCNXzNxWX328JtOJBw657/4Twbf/M63jkjw6/mLQdhGPywv6m/sTQqy5nz0DGiIasH+Qgmo+0zZpYGJkvvdLXuKQE/enHsJMQ3noYNvLBKv5Pg6AEBMQBKBhZ2WoaL+P5nGSZjjSauDT5G1Ibd4SX3CpXqcPZZ1BJjiDumCvWQLzcDwP2aHVC5RkLrjIoDNkJrb6x02NE2UZAU59zkhNppjgaCYtj2tCsCD07lMPlWd8qCFLQkGEMepsb8kHs8V20UtjsFhFivHY803oaL5VNAwETvfElCg4NEeSroHLl
 24AMDPY3
 PoXiV1tS2HVZlE6hPT5mG1IOrMqasAm0tQHeDyvFdtE2l5nz2QB4PkMvO3z3DMsDVdTVSbCwOFJl+aLKSmgaCVQGTggUh2lqfjgabHyB9KF//e8iQr7Wqm1uu4NQETQDNXVJJGxzSi//L5Avy5l5ST9XT3relxjk9Ohw2xiI0ZKMRxcBxs2e8vWwGfbptQO3uXp9ZkRqMDskResHLOEp7npGLJ+k9AvDbxwiUO/kpV7FLH2Caiy6etJEOUG02QSr4wVzLsSXecj3l7/lcaxlejvrAKw5A9IHsBwgLTIoUC3PCY4Dqccdb0Ckxe4jgUBPezkAAKnJYAiJhQ0RGW4j3vISvtBo/WJmD2loqdmaSgkbKms2llut4vukUCVtVg9pArqNYnLAEApkXFE5BR9RU19eEI8jiWekuXjJ7EO17gJ4ThMXqZKYWwsVaxUTDC20jNODOEnMht9E7tw+Yoe0F8Q33T7GpJFBe8kubio6muBu6GtEP9fKL1KhNXQ/0iezbsMhhUG6kK9PBk3ue7sNu2dyAVdyiMgf71FhRLmDcjbj+fV9Xlw71U82ZDNKVPZT72YDXgUUdFsaaZ5UdZaLFebYTHA==
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
few now-redundant checks.

The zone_device_private_split_cb() calls are only kept in the anon
variant, as device private folios can only back anonymous memory, and
add a VM_WARN_ON_ONCE_FOLIO() at the entry of the file variant.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Yeoreum Yun <yeoreum.yun@arm.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 mm/huge_memory.c | 124 ++++++++++++++++++++++++++++++++++---------------------
 1 file changed, 78 insertions(+), 46 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index d9f0a3a9c9a4..517259c1c26f 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4008,11 +4008,9 @@ static void folio_reset_partially_mapped(struct folio *folio)
 		      MTHP_STAT_NR_ANON_PARTIALLY_MAPPED, -1);
 }
 
-static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int new_order,
-					     struct page *split_at, struct xa_state *xas,
-					     struct address_space *mapping, bool do_lru,
-					     struct list_head *list, enum split_type split_type,
-					     pgoff_t end, int *nr_shmem_dropped)
+static int __folio_freeze_split_anon(struct folio *folio,
+		unsigned int new_order, struct page *split_at, bool do_lru,
+		struct list_head *list, enum split_type split_type)
 {
 	struct folio *end_folio = folio_next(folio);
 	struct swap_cluster_info *ci = NULL;
@@ -4020,8 +4018,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	struct lruvec *lruvec;
 	int ret = 0;
 
-	VM_WARN_ON_ONCE(!mapping && end);
-
 	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
 		return -EAGAIN;
 
@@ -4036,24 +4032,75 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	 */
 	folio_reset_partially_mapped(folio);
 
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
+	 * Unfreeze the after-split folios and put them back to the right
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
+static int __folio_freeze_split_file(struct folio *folio,
+		unsigned int new_order, struct page *split_at,
+		struct xa_state *xas, struct address_space *mapping,
+		bool do_lru, struct list_head *list,
+		enum split_type split_type, pgoff_t end, int *nr_shmem_dropped)
+{
+	struct folio *end_folio = folio_next(folio);
+	struct folio *new_folio, *next;
+	struct lruvec *lruvec;
+	int ret;
+
+	/* Currently device private folios can only back anonymous memory. */
+	VM_WARN_ON_ONCE_FOLIO(folio_is_device_private(folio), folio);
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
-						NR_SHMEM_THPS, -nr);
-			} else {
-				lruvec_stat_mod_folio(folio,
-						NR_FILE_THPS, -nr);
-			}
+		if (folio_test_swapbacked(folio)) {
+			lruvec_stat_mod_folio(folio,
+					NR_SHMEM_THPS, -nr);
+		} else {
+			lruvec_stat_mod_folio(folio,
+					NR_FILE_THPS, -nr);
 		}
 	}
 
-	if (folio_test_swapcache(folio))
-		ci = swap_cluster_get_and_lock(folio);
-
 	/* lock lru list/PageCompound, ref frozen by page_ref_freeze */
 	if (do_lru)
 		lruvec = folio_lruvec_lock(folio);
@@ -4063,7 +4110,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
-	 * list. @folio should be kept frozon until page cache
+	 * list. @folio should be kept frozen until page cache
 	 * entries are updated with all the other after-split folios
 	 * to prevent others seeing stale page cache entries.
 	 * As a result, new_folio starts from the next folio of
@@ -4073,29 +4120,15 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
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
@@ -4114,7 +4147,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		folio_put_refs(new_folio, nr_pages);
 	}
 
-	zone_device_private_split_cb(folio, NULL);
 	/*
 	 * Unfreeze @folio only after all page cache entries, which
 	 * used to point to it, have been updated with new folios.
@@ -4126,9 +4158,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	if (do_lru)
 		lruvec_unlock(lruvec);
 
-	if (ci)
-		swap_cluster_unlock(ci);
-
 	return ret;
 }
 
@@ -4270,7 +4299,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
 	/* block interrupt reentry in xa_lock and spinlock */
 	local_irq_disable();
-	if (mapping) {
+	if (is_anon) {
+		ret = __folio_freeze_split_anon(folio, new_order, split_at,
+						true, list, split_type);
+	} else {
 		/*
 		 * Check if the folio is present in page cache.
 		 * We assume all tail are present too, if folio is there.
@@ -4281,10 +4313,11 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 			ret = -EAGAIN;
 			goto fail;
 		}
+		ret = __folio_freeze_split_file(folio, new_order, split_at, &xas, mapping,
+						true, list, split_type, end,
+						&nr_shmem_dropped);
 	}
 
-	ret = __folio_freeze_and_split_unmapped(folio, new_order, split_at, &xas, mapping,
-						true, list, split_type, end, &nr_shmem_dropped);
 fail:
 	if (mapping)
 		xas_unlock(&xas);
@@ -4384,9 +4417,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
 		return -EAGAIN;
 
 	local_irq_disable();
-	ret = __folio_freeze_and_split_unmapped(folio, new_order, &folio->page, NULL,
-						NULL, false, NULL, SPLIT_TYPE_UNIFORM,
-						0, NULL);
+	ret = __folio_freeze_split_anon(folio, new_order, &folio->page,
+					false, NULL, SPLIT_TYPE_UNIFORM);
 	local_irq_enable();
 	return ret;
 }

-- 
2.55.0



