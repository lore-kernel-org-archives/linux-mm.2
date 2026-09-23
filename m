Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EA7EEC9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 21:33:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B0A756B00A1; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AE1F26B00A4; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A9226B00A5; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5952B6B00A2
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 17:32:47 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BEBE8C0129
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:46 +0000 (UTC)
X-FDA: 85246326732.15.D945792
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C24951A0004
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 21:32:44 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E8NxxRmK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790199164;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XLT6rcitkEt0bhRj6dmLwO7jPae4xTn40m6tjQsGjWg=;
	b=ZKpEOJD45k9m8gHJCFT85rKSAW8OX+vTYcbd2hM83/6irLBspZyKI36iWZmQt9E3q9nfcN
	ndKVOOn5zL4/2WgbbQoDh+4Pnaxn13i3XL23Cd3WPSMqBjkDKZHRcXT6iSQiryAofO/n+n
	n054tsgJ5ybQxXYH67ypBveey1jYWxo=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E8NxxRmK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of devnull+kasong.tencent.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+kasong.tencent.com@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790199164;
	b=tpgXMCD5wnaz3ZOjYXK1ZbkrmzennxPhdrxrmkUYhDDJ3wp+Mr3KoV4e8iHK6JYkmVW8IY
	rBBQh4CipnvsZbhkEDcCyD0egAgM2Kt+RzNNJ5cVHGrInIKXkCCMSwx3GltFDQArGp6av1
	2vjK2kQzoQKmZAp2qqykl/eMJdQW18g=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4F28343F25;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1DDCBC2BCF7;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1790199163;
	bh=F7Ybs+UnoH15Z+C6t0pZPct+6mxob0eiqLWChRfhCk8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=E8NxxRmKYmu7XXWNo5GkQfRwnZr05kwfJwhDk6ICROdKJTTRUx0aq/zY1Ur3M33Aj
	 RfxsqVIzpNEi/gyiBTs+uL9XZ+cb2X6VxiyRFjAvq6WwsoahcLVC+SYg/Is04vKD72
	 C3KyF9f5u3KIe3m5l5MY9ar/oBu7wpbXE5cBbh+faoKvQ66v9GK2+C92Q/UnfTpmrR
	 HKc3BTuwsXfSPx24vzJr42OK9et1N60ZDoJ8rFH1NI77JkaEAB462i9HTbGLCE1SEw
	 pCSevPNuzp/lSfy8gz+l2L6YP7VVK/+QONeL23ckUKPxqpX7kOY6OFehhl0vdtmD4i
	 3gcDTKex0a3SA==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06A41C98313;
	Wed, 23 Sep 2026 21:32:43 +0000 (UTC)
From: Kairui Song via B4 Relay <devnull+kasong.tencent.com@kernel.org>
Date: Wed, 23 Sep 2026 23:32:35 +0200
Subject: [PATCH v6 04/17] mm/huge_memory: split the routine for splitting
 anon and file folio
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260923-swap-thp-cleanup-v6-4-ba1b4ba72c6f@tencent.com>
References: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
In-Reply-To: <20260923-swap-thp-cleanup-v6-0-ba1b4ba72c6f@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1790199160; l=8306;
 i=kasong@tencent.com; s=kasong-sign-tencent; h=from:subject:message-id;
 bh=dOJyL8IG9RVvH6KLP68TxljYyrB1bKWLEdWsFRfNmxo=;
 b=M5xVhC3qKALj78ArBjYIYb/7GECUSEhvM2BPhegOukcy2eV+2StCN8BjY4OIycRYa4ItGPY1C
 75w9fK8MwOFAKDjyfn4uG6sblpHqJY2BNdBOxncZG5PF5ogNfvHri6P
X-Developer-Key: i=kasong@tencent.com; a=ed25519;
 pk=kCdoBuwrYph+KrkJnrr7Sm1pwwhGDdZKcKrqiK8Y1mI=
X-Endpoint-Received: by B4 Relay for kasong@tencent.com/kasong-sign-tencent
 with auth_id=562
X-Original-From: Kairui Song <kasong@tencent.com>
Reply-To: kasong@tencent.com
X-Stat-Signature: 3hru8fxqpp6oq6ra8z7ei5ttrqrapx1d
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C24951A0004
X-HE-Tag: 1790199164-188848
X-HE-Meta: U2FsdGVkX18oXfNl08oxbEqukY3ToKzNP7YZGfxg9m2EVpihACj2ZPDrOa4sY39XbV0gQSgm6VK61FqQnQTxHq8xGe/0DVSaF6iUIBrLUT9dUCTnmWZjsyDVzuipVRad4xXRHhc1tc5hJU4nJB+THnoNzC4UhXjH3L99Ivau4vUh9D3OXVxuMQh/lzIdVhvXzr0rNgUmjRCaQbnoCyZrOrNvpWhMVFdzrw6Ze+lddneFpyTTRbixn1RnLfMv6h2eaYrF2x2olECf/BGJr7UiP71+GaDKXgltsb5bJPB3FOJx6efXhOhuVIp3MX+kPSOPlKTpax/fspdRs4cv/N27rWokIkWA3xM9/TYwdgRKfpdzd3TzFthTbdH5g1W9WeDkJj1qcBlVVstTScI8DeT6P3jWlV7h/SrLmgJ7B8LJuI5lYe89gfG9DE04duk2zVJH4yJACKqsGEaeJbSHdE+9ELyp0fW1ZTlZux+qLmKHISsqGM85+g5sV1aYK78uHoTJ4Dfx53PIceI7Z0U8cByjMh/1jGCiWy8yMAGKgUeU2E9CNhJ+36YRqGyA13OjVH1Ay82WRmo/WVrV8Zzx+sZDcVy1R2U7ct1GwnepKyJJDia+LpZbsTmBYYgc5hZhDa1XSiSNTc5MLSv+bxcbD/FIilNgFj2xZ4WCBhpKSRuh0XyZaTAX1vXgLHRlJeOdmXq3ozdzt7XuJhUFZozLv1kK7VAe5FUS+SVyYgSunjU4qjJZfxo9T9nOnhJowUVYuSZtBajCaQNTyy7+l33xOMnv22LsbzavNz5wfYW/cHMw4a/OL+Srx9yGjt4mmI98vpU5rFEdesb7CbE7BHEKzRYJShgtN+mwZ/aMHOTx0qwChzaTUupDug20drUT369B8h/sCCX9ggAjRsOSIEc9MplYBh89dcSAV1KH4O2ILzyniBD13lGWWnCk8HqTfEqwnE8/W208y2DjS/lhbTKmw/B
 qNQ0fgZR
 pcf4UKV4trXLWPZsh7RmqJP55QrwWLUQD/jFDS3Fz+svYQl706KR03iFCVdq+Ee6wpZy0YcpdAx5leCrqgBol6wUqZ4DUdL1ChOBzY4gx1KWWWOt2z6sXsJzhBpjCXk2VP11ggOzjRLsobnz8pEv5fIM6w+U4PjkQ42Exqp6sx9pD/v4Yon9InMnRRdJQtwpiqpRg7torRL9NmZva7w5Ra0PuvA8BhqGBl5aOx5X0RDwIRCINPPyhkOlV6hSPt2SJkGrmjC5dBXEYOswFJDFvBA3xO2psMduZ5lp9WSqcETNPG92kxQmGefgq5AgDbProV0+8FE0D8dFqvZR1Osq9q0uo6wxnEnbRGUhWdGNL+UKlOYk2He42SdkkPhFVkorBDPS+OFlEbcJz/+A6PmKwxRcKKpoJgnOeEnJjsd030o/O/KPGRwbqRBiMkKb6B678bf9O7EAQ268dlehiOLccE/1IIozKPdH8xACfn2pAEdD+WFLxCujrrxMODSdy5QfHpkyj/DgvEOvJ3H2WmuM5y73QZbo+1oWypZ7PRqNohSS+fZTiusvKT38N/xR4KYnlV4kq66EgtmDPcGKHTp16LhcIPw==
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
index a475278e1e67..1efd858892c1 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -4007,11 +4007,9 @@ static void folio_reset_partially_mapped(struct folio *folio)
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
@@ -4019,8 +4017,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	struct lruvec *lruvec;
 	int ret = 0;
 
-	VM_WARN_ON_ONCE(!mapping && end);
-
 	if (!folio_ref_freeze(folio, folio_cache_ref_count(folio) + 1))
 		return -EAGAIN;
 
@@ -4035,24 +4031,75 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
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
@@ -4062,7 +4109,7 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 
 	/*
 	 * Unfreeze after-split folios and put them back to the right
-	 * list. @folio should be kept frozon until page cache
+	 * list. @folio should be kept frozen until page cache
 	 * entries are updated with all the other after-split folios
 	 * to prevent others seeing stale page cache entries.
 	 * As a result, new_folio starts from the next folio of
@@ -4072,29 +4119,15 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
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
@@ -4113,7 +4146,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 		folio_put_refs(new_folio, nr_pages);
 	}
 
-	zone_device_private_split_cb(folio, NULL);
 	/*
 	 * Unfreeze @folio only after all page cache entries, which
 	 * used to point to it, have been updated with new folios.
@@ -4125,9 +4157,6 @@ static int __folio_freeze_and_split_unmapped(struct folio *folio, unsigned int n
 	if (do_lru)
 		lruvec_unlock(lruvec);
 
-	if (ci)
-		swap_cluster_unlock(ci);
-
 	return ret;
 }
 
@@ -4269,7 +4298,10 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
 
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
@@ -4280,10 +4312,11 @@ static int __folio_split(struct folio *folio, unsigned int new_order,
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
@@ -4383,9 +4416,8 @@ int folio_split_unmapped(struct folio *folio, unsigned int new_order)
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



