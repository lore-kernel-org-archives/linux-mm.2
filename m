Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65F39C9EC8D
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:10:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 345E96B0093; Mon, 12 Jan 2026 10:10:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C2436B0095; Mon, 12 Jan 2026 10:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11E7C6B0096; Mon, 12 Jan 2026 10:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EB4186B0093
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:10:30 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B9AE91A046D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:10:30 +0000 (UTC)
X-FDA: 84323648220.02.7AAE142
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf30.hostedemail.com (Postfix) with ESMTP id 91A2080017
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:10:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="DtZ/mSWW";
	spf=pass (imf30.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768230628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K1eQfP+FijUo9LrgTDqPVWvFcZh/E9/+owYfxKf+08s=;
	b=Meq+iLOjUKsEnScxrhfazr0MsuKRsaTOA56Jbt20KO3eAZtR/E9R5ZmySsTZvTc+LyME2D
	QwAzWON4D8X2rnTV8ZoU45vcKgKFBe0GGNvZd566ubDSMWurkrd2cTYLvHtli88eVP7utj
	QeRZhFkN5xTZg7yL0OX9RaydIaDUm9w=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="DtZ/mSWW";
	spf=pass (imf30.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768230628; a=rsa-sha256;
	cv=none;
	b=eJnHm3URKqv9U65+lMJYJeIfwBeSAKk+i3vIqK7pZgfiN1qyLg7AMv3KFcTKmsoukSjvGH
	IRlxlRbIeuTokqjD5mFpcH/LNT5bxV6qaegV+XSkwBCPv3uHAdHy62TPLxatFP1qR203kS
	bHmDoq8RagAeCcjjNCdUJBGkJM9hTqM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=K1eQfP+FijUo9LrgTDqPVWvFcZh/E9/+owYfxKf+08s=;
	b=DtZ/mSWWmk+QcG6yEeSvwld1rUvUIzL3mdE+u0S40P+4YCofEPPSlPi/l5nQmLrZo6Obc0wJY
	mckM4narb5qJ9Uvxka93AC8WzEXMQ08tlx0JoQnZXFIvTDbFDxdSLjTbDCbUqyGUmqvSrhrwj+8
	QXPMxgezeGHPMD8LrYTfFuk=
Received: from mail.maildlp.com (unknown [172.19.163.200])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dqbMC0hqQzmV70;
	Mon, 12 Jan 2026 23:07:03 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 41CE44055B;
	Mon, 12 Jan 2026 23:10:22 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 23:10:21 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 1/5] mm: page_isolation: introduce page_is_unmovable()
Date: Mon, 12 Jan 2026 23:09:50 +0800
Message-ID: <20260112150954.1802953-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 91A2080017
X-Stat-Signature: zay7ht477s7dns3h97i9o3erwnc4nyte
X-HE-Tag: 1768230627-183954
X-HE-Meta: U2FsdGVkX18w7PjjOGuwkG+2nn8TMu+iCzUdBRM8ey2vqyh6hNg8acs4WAf2iY7BbP+iiJzNR8SwwdfBVYYZBclB63rSVE9/4lZTDPonWGmlx1MtVxX8Ps5RaU318ofwTu/DaHvBrT/wazq16ks/xjbcK/O4ZaXj9888WZ0gXhqP/vDG+1BXOhGbvz5puw6VitMaPD9L2AcM27iGTvjzk9Maww8QOZIhOzoHv8zCnsaTc2Csnl4/knKDUf96h+7CvcG/IhhtCHBIifPVqXAp07W68sdbZS74cN5OzEXq5DQIlDCOiWNwDhMZIgD3zJHoyPPJ92nkVPN2RG4n2jVFuIuuuUmBgGRRDVc27OHb5QTEimrrb9l34QmlK3UgByKMoGVrELfVUd+nNTgmB5AnrIjAaUhblCrZA/0as3KNHuWt/mpgtchme3M2D2RPmMPt6wqJYzUDQ1vXee2FLa2QQW2AvZW8u9XrwM7gcfxgftfCJt/rNKA1sq745ZySBS2B+wzHEaLBd8aeNy0GVDYzdlcuzeJT6A9/nkfVIVBVrHpqf+MdLKfxzyEZjes2KrnWpoYXc8C8nxHxJvxQTpMNawnW/JjG9TluqPzELjDSrgnlHVhl2knT5/cRnFzx9V11qGklVgv6G+3aYyeyMb9/DW0aHLHcQfnCOPExG4L6PLTh7vQ5ZBFI+JcLbt1StlV0t/kXj1y++IYoKNNMenpskEnYsXOnX0nJgaWGngbTt65k7LWx3+HzLEDIa3saTK0hpreRzeF/qzt+Qr/ZHOTCu215IebluXVb6e2JCxlrGouNB4bzKjXoIuu8SYfLg6u4lUZmYiTUS4uvTon3UX2UkGJcHGuRhw0gMLVZcpLmq6TIigFHTav9uFPht2quPn1EBLO1Q1F63saZg+tcjysOw46/VJsqm9GTEmS5rGtKyYJUdRnBYBF4NjtSbYAdnOlOKOVpLsDdLIjXcSVsLx4
 biAyMAkh
 LUtIpkG6SMkNePQdhaH6TlNPtescvGxG8is6Qta4IyJOE/LKJNMzb08vL/sv9BUBv3YGE3qAYI3fVJ32yU8Qj2hfyneR/nRUjdbnhqGNh5Q8UpNwtgi9+Dj/RxDdKUHotCVS7+if0f1etrkVLh0s5gWkBdsvofDWlKsX6ZYOIK4/XYDFwvhaYC1RYjeiW5eFg52j4GM9S6YYUH9VZA2xFagiw+7cBgxVP92wWa1X2RviNBWHjMzOgkMsHTBFL2bzn4eTDkdwNmpWdxO3Jo8ktmuqC3/9PBvMOboC+ZVRI9/VUPc5MNS6FwbKWiFcHAvL4PShqZUF9M529DvD2Z7d19k1Bdw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Factor out the check if a page is unmovable into a new helper,
and will be reused in the following patch.

No functional change intended, the minor changes are as follows,
1) Avoid unnecessary calls by checking CONFIG_ARCH_ENABLE_HUGEPAGE_MIGRATION
2) Directly call PageCompound since PageTransCompound may be dropped
3) Using folio_test_hugetlb()

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/page-isolation.h |   2 +
 mm/page_isolation.c            | 187 +++++++++++++++++----------------
 2 files changed, 101 insertions(+), 88 deletions(-)

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


