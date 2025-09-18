Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B609ACAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:20:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6BD28E010E; Thu, 18 Sep 2025 09:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C4A378E0114; Thu, 18 Sep 2025 09:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 90A8B8E010E; Thu, 18 Sep 2025 09:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 78BFA8E0112
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:20:44 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3F71C56ECE
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:44 +0000 (UTC)
X-FDA: 83902430808.17.335FC7A
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf04.hostedemail.com (Postfix) with ESMTP id E2E9240006
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:41 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758201642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=qGPxI8TCkNzrjzOKm4Ci0duCMFCchie4mDLSXcWuiVo=;
	b=45QpGcvGrNnxG6D0pT7DQM4Q0mCzgW0ptn/AOE9yXvU9tHjpAMabC5AXmgSXMZhv2pQQq2
	W3kUQGr8HSzNodgy7djcdsjvfsDNyib33OHbnzyATcnFG1rzccA86Bba2co16lTE8WTI22
	Kb3OqYG8FvpdQ6qFWbs1Rf56mom5A1c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758201642; a=rsa-sha256;
	cv=none;
	b=J3h3LwtU/xABWIYIBPp4zWPmWonLGCClUpuJzNg3gbWb65+4HBJcugQCAAFY5RVwthRtBz
	75hz2CF8jv5OuL/VlmOYLgNN71m3T5ZLT9hiyAYaUOUSEtli3mW3LJeLan8nyOWa9dfGVK
	somUR1CIYTM6E+qUbnWeE6UQkZ4HHWs=
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cSGSx19l6ztTHW;
	Thu, 18 Sep 2025 21:19:45 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id E6D941402EA;
	Thu, 18 Sep 2025 21:20:38 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Sep 2025 21:20:37 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 7/8] mm: cma: add cma_alloc_frozen{_compound}()
Date: Thu, 18 Sep 2025 21:19:59 +0800
Message-ID: <20250918132000.1951232-8-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: E2E9240006
X-Rspamd-Server: rspam05
X-Stat-Signature: i5t15hsyo3n3xuitpo8uiz8dwkarsin9
X-Rspam-User: 
X-HE-Tag: 1758201641-653913
X-HE-Meta: U2FsdGVkX18ERqNGuaIJ1m375Vr/RicRCFri5Z9HGruThXD5aF1T0s1g75d9q8IyJXwIFuFeci6Ap48D9GqtXuj5pKaXtN8Q1/yJIp/Ksmwi/c3Ihxz8r+veSJjNXDqEAzThgH8xPLcm8mYAigqJPd67YR/uDWNaHVy5DhhxxC8htQlH35l1wT8YcXbDoDl7EkjLvYBGBXychFuLgy5ELhi9UM9oHIE1GbI/lPzvPoVmaVgGB88yzSr3vSDSJXi5YDujvX6E6CROftCfacqNDwLYlDxvWn1ibY9VxDANdV6AFWOQVEIfwAvHIdLiUrweEWPaHIv9W8SHv4rhovTvSfCY/GCML+pOXKFAZf/L7G+0Mb1Sz/LAHuWK/83R8z6DXduRw0Gzk1oLbHWioyffcroYb63QspM7KZsqozAmqhCIkkP043dUhtfNsuVWIc7KmD+w/fUqDYi5zSrbqpqXKRGQZdlEbupw9HOVtu5OXDpFpkQHdnPtX9pCN9a3J1h8NV0+81E/fTI3bednUn1XlInZ0uboVgAT+d5gHaGIS9I3vNZJjbg9NH+9Yv4iPJowOqx5lGbY/wPyQWl2jaECS6Mno1psWxhK/lY2Bwjg3bzPf5Af9Mdc3LIOzPUbzYd/CEPqdSNOFMYg41X0vYw0AQRXgpEXiVKruTtc/VvS2oU2OnL9/BXhvvZv3YJHcCXABye8vml9gOCPgTS9qbJooeP87P9vduLT8oyogYqS9FhF2nqu2gOVXh8TbMT8RuwFABixrCiZiFC7gt7OyR9yB0FNZ7NeINeTSZHZqpReJlh/07t1mmFpnAoMVIdmQG4IxqS10sqeoCZ5mygGmVK4WaiZXO7jfkFs+1U77AYmvybLurA3u40fL0SSrF1BIMwbYHUUpaRwttVkiLFTl5/qMQOfqWTLPMJl8YlOHfStNypSDkXypNaqeo//ODXPL0gZ9KBk5GI3HhHUP1fchZU
 ETE7nD0/
 fgAJF4qZE6mvBaC2WpnBD9xGh2oowAZ9jCGOqVeMHNs3KMQY/GsNq1ZmeScdUQjGCX8lLplSKV6dpksY/saooR5o1UYmFk/seru9jAOj7l+IkBqMvceujQK2XXuQAwuk1y4A00pClnTu2p0U6qLGu84RW5SGdI89JMfh9qXyc/j5v1PGArgyZAnynSsIBM5MaknMznYqRxIijER+8/LHmLWgtCbjODN03UNl02xmGCRuk01rUtt4LAM56lv7BFHXZz8CoMCKEF9LKVeOjnMtVm02UBg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce cma_alloc_frozen{_compound}() helper to alloc pages
without incrementing their refcount, and convert hugetlb cma
to use cma_alloc_frozen_compound, also move cma_validate_zones()
into mm/internal.h since no outside user.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/cma.h | 25 +++++----------------
 mm/cma.c            | 55 +++++++++++++++++++++++++++++----------------
 mm/hugetlb_cma.c    | 22 ++++++++++--------
 mm/internal.h       |  6 +++++
 4 files changed, 60 insertions(+), 48 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index e5745d2aec55..4981c151ef84 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -51,29 +51,14 @@ extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int
 			      bool no_warn);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
+struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
+		unsigned int align, bool no_warn);
+bool cma_release_frozen(struct cma *cma, const struct page *pages,
+		unsigned long count);
+
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
 extern bool cma_intersects(struct cma *cma, unsigned long start, unsigned long end);
 
 extern void cma_reserve_pages_on_error(struct cma *cma);
 
-#ifdef CONFIG_CMA
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp);
-bool cma_free_folio(struct cma *cma, const struct folio *folio);
-bool cma_validate_zones(struct cma *cma);
-#else
-static inline struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
-{
-	return NULL;
-}
-
-static inline bool cma_free_folio(struct cma *cma, const struct folio *folio)
-{
-	return false;
-}
-static inline bool cma_validate_zones(struct cma *cma)
-{
-	return false;
-}
-#endif
-
 #endif
diff --git a/mm/cma.c b/mm/cma.c
index 2af8c5bc58dd..aa237eab49bf 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -836,7 +836,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 		spin_unlock_irq(&cma->lock);
 
 		mutex_lock(&cma->alloc_mutex);
-		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
+		ret = alloc_contig_range_frozen(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
 		mutex_unlock(&cma->alloc_mutex);
 		if (!ret)
 			break;
@@ -856,8 +856,8 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 	return ret;
 }
 
-static struct page *__cma_alloc(struct cma *cma, unsigned long count,
-		       unsigned int align, gfp_t gfp)
+static struct page *__cma_alloc_frozen(struct cma *cma,
+		unsigned long count, unsigned int align, gfp_t gfp)
 {
 	struct page *page = NULL;
 	int ret = -ENOMEM, r;
@@ -914,6 +914,21 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 	return page;
 }
 
+struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
+		unsigned int align, bool no_warn)
+{
+	gfp_t gfp = GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0);
+
+	return __cma_alloc_frozen(cma, count, align, gfp);
+}
+
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order)
+{
+	gfp_t gfp = GFP_KERNEL | __GFP_COMP | __GFP_NOWARN;
+
+	return __cma_alloc_frozen(cma, 1 << order, order, gfp);
+}
+
 /**
  * cma_alloc() - allocate pages from contiguous area
  * @cma:   Contiguous memory region for which the allocation is performed.
@@ -927,23 +942,23 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 struct page *cma_alloc(struct cma *cma, unsigned long count,
 		       unsigned int align, bool no_warn)
 {
-	return __cma_alloc(cma, count, align, GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
-}
-
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
-{
+	unsigned long pfn;
 	struct page *page;
 
-	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
+	page = cma_alloc_frozen(cma, count, align, no_warn);
+	if (!page)
 		return NULL;
 
-	page = __cma_alloc(cma, 1 << order, order, gfp);
+	pfn = page_to_pfn(page);
 
-	return page ? page_folio(page) : NULL;
+	for (; count--; pfn++)
+		set_page_refcounted(pfn_to_page(pfn));
+
+	return page;
 }
 
 static bool __cma_release(struct cma *cma, const struct page *pages,
-			  unsigned long count)
+			  unsigned long count, bool frozen)
 {
 	unsigned long pfn, end;
 	int r;
@@ -966,7 +981,11 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
 	if (r == cma->nranges)
 		return false;
 
-	free_contig_range(pfn, count);
+	if (frozen)
+		free_contig_range_frozen(pfn, count);
+	else
+		free_contig_range(pfn, count);
+
 	cma_clear_bitmap(cma, cmr, pfn, count);
 	cma_sysfs_account_release_pages(cma, count);
 	trace_cma_release(cma->name, pfn, pages, count);
@@ -987,15 +1006,13 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
 bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
-	return __cma_release(cma, pages, count);
+	return __cma_release(cma, pages, count, false);
 }
 
-bool cma_free_folio(struct cma *cma, const struct folio *folio)
+bool cma_release_frozen(struct cma *cma, const struct page *pages,
+		unsigned long count)
 {
-	if (WARN_ON(!folio_test_large(folio)))
-		return false;
-
-	return __cma_release(cma, &folio->page, folio_nr_pages(folio));
+	return __cma_release(cma, pages, count, true);
 }
 
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index e8e4dc7182d5..fc41f3b949f8 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -22,33 +22,37 @@ void hugetlb_cma_free_folio(struct folio *folio)
 {
 	int nid = folio_nid(folio);
 
-	WARN_ON_ONCE(!cma_free_folio(hugetlb_cma[nid], folio));
+	WARN_ON_ONCE(!cma_release(hugetlb_cma[nid], &folio->page,
+				  folio_nr_pages(folio)));
 }
 
-
 struct folio *hugetlb_cma_alloc_folio(int order, gfp_t gfp_mask,
 				      int nid, nodemask_t *nodemask)
 {
 	int node;
-	struct folio *folio = NULL;
+	struct folio *folio;
+	struct page *page = NULL;
 
 	if (hugetlb_cma[nid])
-		folio = cma_alloc_folio(hugetlb_cma[nid], order, gfp_mask);
+		page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
 
-	if (!folio && !(gfp_mask & __GFP_THISNODE)) {
+	if (!page && !(gfp_mask & __GFP_THISNODE)) {
 		for_each_node_mask(node, *nodemask) {
 			if (node == nid || !hugetlb_cma[node])
 				continue;
 
-			folio = cma_alloc_folio(hugetlb_cma[node], order, gfp_mask);
-			if (folio)
+			page = cma_alloc_frozen_compound(hugetlb_cma[nid], order);
+			if (page)
 				break;
 		}
 	}
 
-	if (folio)
-		folio_set_hugetlb_cma(folio);
+	if (!page)
+		return NULL;
 
+	set_page_refcounted(page);
+	folio = page_folio(page);
+	folio_set_hugetlb_cma(folio);
 	return folio;
 }
 
diff --git a/mm/internal.h b/mm/internal.h
index 1561fc2ff5b8..ffcfde60059e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -936,9 +936,15 @@ void init_cma_reserved_pageblock(struct page *page);
 struct cma;
 
 #ifdef CONFIG_CMA
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
+bool cma_validate_zones(struct cma *cma);
 void *cma_reserve_early(struct cma *cma, unsigned long size);
 void init_cma_pageblock(struct page *page);
 #else
+static inline bool cma_validate_zones(struct cma *cma)
+{
+	return false;
+}
 static inline void *cma_reserve_early(struct cma *cma, unsigned long size)
 {
 	return NULL;
-- 
2.27.0


