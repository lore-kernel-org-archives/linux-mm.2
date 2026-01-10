Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 45ADAD277CE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:21:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C1F976B00AE; Fri,  9 Jan 2026 23:21:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B77A66B00B0; Fri,  9 Jan 2026 23:21:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB7DA6B00B2; Fri,  9 Jan 2026 23:21:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A2CC6B00AE
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:21:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4B7E785957
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:21:36 +0000 (UTC)
X-FDA: 84314755392.07.AC35F0D
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf19.hostedemail.com (Postfix) with ESMTP id BE39E1A0008
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:21:33 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TkTe91OQ;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768018894;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/e6YoIgeAs5fg+kTkNAberewju/icyDdx00P8q7tDhk=;
	b=vnPX7ZIAW+ZPGL+NQgsHx8B11tTdj648L+p7BVuz++FEb+5vSMbFRxKNSrCn2QdJxOWUi3
	SgNW5M9M5/nKRMCNL6AxeF4nK53fwzUMb+MpSnYzJeFsep9Gi13fBFTX+sKusN9nWT22L2
	XlhuZAEE+MO2wgd0mw5FfBAcnObin5I=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=TkTe91OQ;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768018894; a=rsa-sha256;
	cv=none;
	b=3ZMS1BJ0FLvgCi43f+2qzO1a0vLi1tmnhKB5YdAtFQN2cxBLcVZNW+6Q3OSFA0AeuxNtAU
	g10qeFhNeDzcmbJJxMkNbw8HZbqRQJ6DNNnW+XW+KpgtVcKDalA2Z0f8e+3Jq+uU/4UbRd
	zUYAnKI3XdWdFeERP4K9QXguHCQnBLo=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=/e6YoIgeAs5fg+kTkNAberewju/icyDdx00P8q7tDhk=;
	b=TkTe91OQKZNqHM7WqvOYdrChwv7xp41mMdeTreqHpn7RWEV4xlv/+FULzV5xPBkGpLqpzQiuw
	oHsKCnR/4ZaeONh/8B/QR47g/l5HxiMQUK79XsOz2XCfEHg7PYPHaA5AElIydRDH/1m4lpssAOz
	Y/FOidO701NU7cm0likti5o=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dp52n6tlwz1T4GL;
	Sat, 10 Jan 2026 12:17:37 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id DF2B44056B;
	Sat, 10 Jan 2026 12:21:24 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Sat, 10 Jan 2026 12:21:24 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 1/3] mm: page_alloc: optimize pfn_range_valid_contig()
Date: Sat, 10 Jan 2026 12:21:09 +0800
Message-ID: <20260110042111.1541894-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260110042111.1541894-1-wangkefeng.wang@huawei.com>
References: <20260110042111.1541894-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: BE39E1A0008
X-Stat-Signature: 8zwfb8o8nw4hrxcw18yz33ejkmhabeur
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1768018893-705789
X-HE-Meta: U2FsdGVkX1/tOBgLrBmfLSWTWrgV6JyIBjPYabBgBV+OyTg50ZFxcoL1Fkxo10b7wcCz/G5PXU2b0NMInDJOXQIIsLnbIRVQRS9cd/CF85NJ39g4sGlODOLluuHUdPO5mcHczrnMvUx3uGHets70JxAGFcSP3iRc0Tr7D4p7nHRHZVFhnTmCLTtrMwhzQ2aWhPJopy5DKMNqKAKTbN94uQzwE1WVcGcZpymYO03MbZNF0imaX3XPJdfgN+4czgprohQvJlC6takYNgrItgWxP9/aHOMVeKSepJsyNK2I4a1VawCgWANYfk3rYGzo/z1K9M8EXp8u0pE55NJs6tOrTcFrtl7pP8TQ8Xm02I+oMb/RrZqP2QiBTpfTStYDJsTdUEKvybIT6VLVjZ0YrCN0QTl9TKS33rYTHlNXjVyblbYqg7q4x6NiMs+Bd9Wnr+PtvRsI/aZ/rwzY2IJexhz685OFlXfDqtnvxD+fBuM8gGm0zp09ZjfgmMp912hRO3N99gIZryAwGeusLnk36rULua+WWjQI5/obBlFPelRXxAHVqwRck1xzEsrQ0NXw/kOZiKCIHDLN/lI1tOapo04j6RNDlwutQI4rUHOjnc55lGulGqLVBV3iDqaL5zzq0/Q2KXp3nV3a1CX2OIhHsSZaD87epCjTpWp8XjDTApNgCLA5dLGqlXNplYghFMARDdJ26MKF/rGefIss9iMs5WnAZTOKgUPhPOagehf0ZfJhqQok394mNwNiDQ55ZWCiV8MNXv7eBtCEUovrZPvrs53OiaVXw/YcjhyM/qeLDD/mdV7AZXyHMRvb37ldcuedc8CnHnqGL06z87mXXE0fZvS2NBgfksc/MD5grGnlT+YBCbizC5Z4qPq1kXwaDUDl2QRg8kBd0vQOO8zCrgWZXuWqQrFyf/4msimJiiLP56eiJ4uZzHdsyhXeRWTlEmfUsyRD2jKGAkdXRfFhyDnE8zQ
 CM4KgGib
 W80KnKyAI2/4g2cZxug6QcVRXzWrafQWiQAs2Yqi6jsQlLjJqCgmsVSY7h+nHZPIunK1ojk4W8osE8iZAcHZaIrjMUmG7sj92qDAE/+BK3c1wcH8/riSfrq+iRVA5ocmG6NLqsOVo1PSkEtuXNimR9paUV205HzXLjfTR/Hnz/XTV/b/Div28dPcj0ErpUz1/2Xk5Diu6jWrK5My5sudZHo/5KYy1EOjeA23LL7t7lQz4fstmByGwlh9Di4sqa+MW2kuu4qDpUI6BEIrkhBuqhTg/sEx8IGFxAr8Pwd9Aem3Se3xUfrnG955aJ7sqKL78KwdRPliJzt9npcw89QCreeh0Jw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alloc_contig_pages() function spends a significant amount of time
within the pfn_range_valid_contig() function.

- set_max_huge_pages                                      
   - 99.98% alloc_pool_huge_folio                         
        only_alloc_fresh_hugetlb_folio.isra.0             
      - alloc_contig_frozen_pages_noprof                  
         - 87.00% pfn_range_valid_contig                  
              pfn_to_online_page                          
         - 12.91% alloc_contig_frozen_range_noprof        
              4.51% replace_free_hugepage_folios          
            - 4.02% prep_new_page                         
                 prep_compound_page                       
            - 2.98% undo_isolate_page_range               
               - 2.79% unset_migratetype_isolate          
                  - 2.75% __move_freepages_block_isolate  
                       2.71% __move_freepages_block       
            - 0.98% start_isolate_page_range              
                 0.66% set_migratetype_isolate            

To optimize this process, implement a new helper page_is_unmovable(),
which reuses the logic from has_unmovable_pages(). This function avoids
unnecessary iterations for compound pages, such as THP, and non-compound
high-order buddy pages, which significantly improving the efficiency of
contiguous memory allocation.

A simple test on machine with 114G free memory, allocate 120 * 1G
HugeTLB folios(104 successfully returned),

  time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

Before: 0m3.605s
After:  0m0.602s

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/page-isolation.h |   2 +
 mm/page_alloc.c                |  25 ++---
 mm/page_isolation.c            | 187 +++++++++++++++++----------------
 3 files changed, 109 insertions(+), 105 deletions(-)

diff --git a/include/linux/page-isolation.h b/include/linux/page-isolation.h
index 3e2f960e166c..6f8638c9904f 100644
--- a/include/linux/page-isolation.h
+++ b/include/linux/page-isolation.h
@@ -67,4 +67,6 @@ void undo_isolate_page_range(unsigned long start_pfn, unsigned long end_pfn);
 
 int test_pages_isolated(unsigned long start_pfn, unsigned long end_pfn,
 			enum pb_isolate_mode mode);
+bool page_is_unmovable(struct zone *zone, struct page *page,
+			enum pb_isolate_mode mode, unsigned long *step);
 #endif
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index d8d5379c44dc..813c5f57883f 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7157,18 +7157,20 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 				   unsigned long nr_pages, bool skip_hugetlb,
 				   bool *skipped_hugetlb)
 {
-	unsigned long i, end_pfn = start_pfn + nr_pages;
+	unsigned long end_pfn = start_pfn + nr_pages;
 	struct page *page;
 
-	for (i = start_pfn; i < end_pfn; i++) {
-		page = pfn_to_online_page(i);
+	while (start_pfn < end_pfn) {
+		unsigned long step = 1;
+
+		page = pfn_to_online_page(start_pfn);
 		if (!page)
 			return false;
 
 		if (page_zone(page) != z)
 			return false;
 
-		if (PageReserved(page))
+		if (page_is_unmovable(z, page, PB_ISOLATE_MODE_OTHER, &step))
 			return false;
 
 		/*
@@ -7183,9 +7185,6 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 		if (PageHuge(page)) {
 			unsigned int order;
 
-			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
-				return false;
-
 			if (skip_hugetlb) {
 				*skipped_hugetlb = true;
 				return false;
@@ -7196,17 +7195,9 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 			if ((order >= MAX_FOLIO_ORDER) ||
 			    (nr_pages <= (1 << order)))
 				return false;
-
-			/*
-			 * Reaching this point means we've encounted a huge page
-			 * smaller than nr_pages, skip all pfn's for that page.
-			 *
-			 * We can't get here from a tail-PageHuge, as it implies
-			 * we started a scan in the middle of a hugepage larger
-			 * than nr_pages - which the prior check filters for.
-			 */
-			i += (1 << order) - 1;
 		}
+
+		start_pfn += step;
 	}
 	return true;
 }
diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index b5924eff4f8b..c48ff5c00244 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -15,6 +15,100 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/page_isolation.h>
 
+bool page_is_unmovable(struct zone *zone, struct page *page,
+		enum pb_isolate_mode mode, unsigned long *step)
+{
+	/*
+	 * Both, bootmem allocations and memory holes are marked
+	 * PG_reserved and are unmovable. We can even have unmovable
+	 * allocations inside ZONE_MOVABLE, for example when
+	 * specifying "movablecore".
+	 */
+	if (PageReserved(page))
+		return true;
+
+	/*
+	 * If the zone is movable and we have ruled out all reserved
+	 * pages then it should be reasonably safe to assume the rest
+	 * is movable.
+	 */
+	if (zone_idx(zone) == ZONE_MOVABLE)
+		return false;
+
+	/*
+	 * Hugepages are not in LRU lists, but they're movable.
+	 * THPs are on the LRU, but need to be counted as #small pages.
+	 * We need not scan over tail pages because we don't
+	 * handle each tail page individually in migration.
+	 */
+	if (PageHuge(page) || PageCompound(page)) {
+		struct folio *folio = page_folio(page);
+
+		if (folio_test_hugetlb(folio)) {
+			struct hstate *h;
+
+			if (!IS_ENABLED(CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION))
+				return true;
+
+			/*
+			 * The huge page may be freed so can not
+			 * use folio_hstate() directly.
+			 */
+			h = size_to_hstate(folio_size(folio));
+			if (h && !hugepage_migration_supported(h))
+				return true;
+
+		} else if (!folio_test_lru(folio)) {
+			return true;
+		}
+
+		*step = folio_nr_pages(folio) - folio_page_idx(folio, page);
+		return false;
+	}
+
+	/*
+	 * We can't use page_count without pin a page
+	 * because another CPU can free compound page.
+	 * This check already skips compound tails of THP
+	 * because their page->_refcount is zero at all time.
+	 */
+	if (!page_ref_count(page)) {
+		if (PageBuddy(page))
+			*step = (1 << buddy_order(page));
+		return false;
+	}
+
+	/*
+	 * The HWPoisoned page may be not in buddy system, and
+	 * page_count() is not 0.
+	 */
+	if ((mode == PB_ISOLATE_MODE_MEM_OFFLINE) && PageHWPoison(page))
+		return false;
+
+	/*
+	 * We treat all PageOffline() pages as movable when offlining
+	 * to give drivers a chance to decrement their reference count
+	 * in MEM_GOING_OFFLINE in order to indicate that these pages
+	 * can be offlined as there are no direct references anymore.
+	 * For actually unmovable PageOffline() where the driver does
+	 * not support this, we will fail later when trying to actually
+	 * move these pages that still have a reference count > 0.
+	 * (false negatives in this function only)
+	 */
+	if ((mode == PB_ISOLATE_MODE_MEM_OFFLINE) && PageOffline(page))
+		return false;
+
+	if (PageLRU(page) || page_has_movable_ops(page))
+		return false;
+
+	/*
+	 * If there are RECLAIMABLE pages, we need to check
+	 * it.  But now, memory offline itself doesn't call
+	 * shrink_node_slabs() and it still to be fixed.
+	 */
+	return true;
+}
+
 /*
  * This function checks whether the range [start_pfn, end_pfn) includes
  * unmovable pages or not. The range must fall into a single pageblock and
@@ -35,7 +129,6 @@ static struct page *has_unmovable_pages(unsigned long start_pfn, unsigned long e
 {
 	struct page *page = pfn_to_page(start_pfn);
 	struct zone *zone = page_zone(page);
-	unsigned long pfn;
 
 	VM_BUG_ON(pageblock_start_pfn(start_pfn) !=
 		  pageblock_start_pfn(end_pfn - 1));
@@ -52,96 +145,14 @@ static struct page *has_unmovable_pages(unsigned long start_pfn, unsigned long e
 		return page;
 	}
 
-	for (pfn = start_pfn; pfn < end_pfn; pfn++) {
-		page = pfn_to_page(pfn);
+	while (start_pfn < end_pfn) {
+		unsigned long step = 1;
 
-		/*
-		 * Both, bootmem allocations and memory holes are marked
-		 * PG_reserved and are unmovable. We can even have unmovable
-		 * allocations inside ZONE_MOVABLE, for example when
-		 * specifying "movablecore".
-		 */
-		if (PageReserved(page))
+		page = pfn_to_page(start_pfn);
+		if (page_is_unmovable(zone, page, mode, &step))
 			return page;
 
-		/*
-		 * If the zone is movable and we have ruled out all reserved
-		 * pages then it should be reasonably safe to assume the rest
-		 * is movable.
-		 */
-		if (zone_idx(zone) == ZONE_MOVABLE)
-			continue;
-
-		/*
-		 * Hugepages are not in LRU lists, but they're movable.
-		 * THPs are on the LRU, but need to be counted as #small pages.
-		 * We need not scan over tail pages because we don't
-		 * handle each tail page individually in migration.
-		 */
-		if (PageHuge(page) || PageTransCompound(page)) {
-			struct folio *folio = page_folio(page);
-			unsigned int skip_pages;
-
-			if (PageHuge(page)) {
-				struct hstate *h;
-
-				/*
-				 * The huge page may be freed so can not
-				 * use folio_hstate() directly.
-				 */
-				h = size_to_hstate(folio_size(folio));
-				if (h && !hugepage_migration_supported(h))
-					return page;
-			} else if (!folio_test_lru(folio)) {
-				return page;
-			}
-
-			skip_pages = folio_nr_pages(folio) - folio_page_idx(folio, page);
-			pfn += skip_pages - 1;
-			continue;
-		}
-
-		/*
-		 * We can't use page_count without pin a page
-		 * because another CPU can free compound page.
-		 * This check already skips compound tails of THP
-		 * because their page->_refcount is zero at all time.
-		 */
-		if (!page_ref_count(page)) {
-			if (PageBuddy(page))
-				pfn += (1 << buddy_order(page)) - 1;
-			continue;
-		}
-
-		/*
-		 * The HWPoisoned page may be not in buddy system, and
-		 * page_count() is not 0.
-		 */
-		if ((mode == PB_ISOLATE_MODE_MEM_OFFLINE) && PageHWPoison(page))
-			continue;
-
-		/*
-		 * We treat all PageOffline() pages as movable when offlining
-		 * to give drivers a chance to decrement their reference count
-		 * in MEM_GOING_OFFLINE in order to indicate that these pages
-		 * can be offlined as there are no direct references anymore.
-		 * For actually unmovable PageOffline() where the driver does
-		 * not support this, we will fail later when trying to actually
-		 * move these pages that still have a reference count > 0.
-		 * (false negatives in this function only)
-		 */
-		if ((mode == PB_ISOLATE_MODE_MEM_OFFLINE) && PageOffline(page))
-			continue;
-
-		if (PageLRU(page) || page_has_movable_ops(page))
-			continue;
-
-		/*
-		 * If there are RECLAIMABLE pages, we need to check
-		 * it.  But now, memory offline itself doesn't call
-		 * shrink_node_slabs() and it still to be fixed.
-		 */
-		return page;
+		start_pfn += step;
 	}
 	return NULL;
 }
-- 
2.27.0


