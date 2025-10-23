Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB3C0CCD1BC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 12:00:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7F688E001D; Thu, 23 Oct 2025 07:59:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2EDB8E0019; Thu, 23 Oct 2025 07:59:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 858908E001A; Thu, 23 Oct 2025 07:59:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 5DEE48E001A
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:59:59 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 13AD6BD10B
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:59:59 +0000 (UTC)
X-FDA: 84029235318.12.3811D53
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9E6BE40002
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:59:56 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761220797;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ae/5VH/rhvatdaKcIExd2Rd+hG4BDvx9xaP7VsHzlw8=;
	b=o7y2tACO61lwyTvoY+Fj9tzXbjnnAjcnQ28KV7P+Fr1krtCtlBK57CCsAP70ilr1enKzTk
	pEirE+XNSieKLYX4+PeTjkwmKajcykm8xQOvhX6MMz5qZJYPhy1yEjcBOzrOslZ21ije+M
	WxiW53mGNiPGihLS1hS510DuewdAbMk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761220797; a=rsa-sha256;
	cv=none;
	b=ePN4utujYP7l1WRRi5h23s42qLujGY57U5W3ipROJXcDppery9t1Mpk2UmRqgSGaqngauM
	UDmLGT2pS5uodDdyimS7yXVuVQIQM7RCo6nUGTJ8PdFWzpleInMIpjNQpsoe//7zCsXWfQ
	ZMMLO4CLfGQfE5qkuuALQNIk0HqctrY=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4csl201KggzvX5G;
	Thu, 23 Oct 2025 19:59:20 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 03FAF18048F;
	Thu, 23 Oct 2025 19:59:53 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 19:59:52 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
Date: Thu, 23 Oct 2025 19:59:39 +0800
Message-ID: <20251023115940.3573158-6-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
References: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 9E6BE40002
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: mipn3ygo4x9tjq3yqdma1hwrcc6owewq
X-HE-Tag: 1761220796-146301
X-HE-Meta: U2FsdGVkX1/Lu+VwnBcJNMAAsxwm2MI9I+D202i1optwaQCfuqfbarNbrIsoyelZZ4e/1yBAebjanCOX1+bMGBhbJx7SqVOsXAU+vPZF9/p5k2lbSDSF3Wy55Bwg1/peWkNokA8jLMNC06AC6F66xEnG8mAg9HFcxb34djn3lcRvfovhDc1nwkvWFDeaox2DQgn2vSNqzW7cFGMpNQ8PZtKH0Wa6Ik62Ft41ClPsWKd0mIrfMYlvua03cSmTE8zC435ItrklIgGYJl3sbtrc71SrBIAMbflTepuQR+U23YOgR4CJpF35mKERWH3DyIrZ6uwfuE1giZH8RIRDysa8O7hYi+NsTrroJMfiAjkEe8Abc7KtsY3MbFM2OOW5ZFgtdP+4T4ws5VPJ72tpYR3KAlDx5j4cLSPuScCzKzn/FM1323bmvN6vUnUWhqfv89p/cw82xUFOsl4S+R6KLg220tsWcQG3VyJmt2qG/ITs3v0issMFwaSvGTQwQI4FdIgs9gczji/7TctnOf6SIB89gkC5jPt8KPDFt8xxQva5ZnzwecBjl/qhcVYXey0vyXonmAzf1ApUDhbDzbj4zkAgvgFRjqAkuTO+WAtrFy5KXk4Vxf7GqItxZgcH2p89mADVHNmnorCZW9/ocnaINCK2b/8GwN6T5uGcjdEh8YdX8AJ3WMepZExgl6wkR+WWMrEfhjy5VT1pFZcuqyKJcG0qEvHNXxzvGpm+Clh6PQsnaJRJbRbvLxQI5rlTwm/7Be4u6ENMnvtWxWzef4e1xuXCmqnFeI2RVGmDQ3Lum57LbaTPaGL1eYe5oExiJkL1mt/6krtBIxd6KGw2vz9DhYSLq6as1Jlg21Vf8q3d9gN9a64NvE9TerdZ3WmR89t+M3UPwvwOc2a6duOPBi9x/K2Wcim6I+V49OP76ZaYNN9Ep3wSpsVaC/X8OmVHPBojVDwTG7bszx2kc5pfsVFjxAX
 NjXPXdfQ
 7I+WNu9pOYA1rJTJbsI8ArSQCgHbcCG+/skJCvLIojSt4qsYiyl07ilswHAJDR7h2DYcRhm6b72GkFJwBrxeZZ39j0vP0nhRY93L3BpluB3ow7dgstS7cr3rzkr01Wqq8GW1neXZKOIQpxPH9HBa15XOvpM4+lx4Lmcm4kb+VsNvURvuAUtY6R2cFYx0XgAxqRWDiOs0lR0KYWIw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce cma_alloc_frozen{_compound}() helper to alloc pages without
incrementing their refcount, then convert hugetlb cma to use the
cma_alloc_frozen_compound() and cma_release_frozen() and remove the
unused cma_{alloc,free}_folio(), also move the cma_validate_zones()
into mm/internal.h since no outside user.

The set_pages_refcounted() is only called to set non-compound pages
after above changes, so remove the process about PageHead.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/cma.h | 26 ++++++------------------
 mm/cma.c            | 48 +++++++++++++++++++++++++--------------------
 mm/hugetlb_cma.c    | 24 +++++++++++++----------
 mm/internal.h       | 12 +++++-------
 4 files changed, 52 insertions(+), 58 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index e5745d2aec55..e2a690f7e77e 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -51,29 +51,15 @@ extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int
 			      bool no_warn);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
+struct page *cma_alloc_frozen(struct cma *cma, unsigned long count,
+		unsigned int align, bool no_warn);
+struct page *cma_alloc_frozen_compound(struct cma *cma, unsigned int order);
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
index 7f050cf24383..1aa1d821fbe9 100644
--- a/mm/cma.c
+++ b/mm/cma.c
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
@@ -904,7 +904,6 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 	trace_cma_alloc_finish(name, page ? page_to_pfn(page) : 0,
 			       page, count, align, ret);
 	if (page) {
-		set_pages_refcounted(page, count);
 		count_vm_event(CMA_ALLOC_SUCCESS);
 		cma_sysfs_account_success_pages(cma, count);
 	} else {
@@ -915,6 +914,21 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
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
@@ -927,24 +941,18 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
  */
 struct page *cma_alloc(struct cma *cma, unsigned long count,
 		       unsigned int align, bool no_warn)
-{
-	return __cma_alloc(cma, count, align, GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
-}
-
-struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
 {
 	struct page *page;
 
-	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
-		return NULL;
-
-	page = __cma_alloc(cma, 1 << order, order, gfp);
+	page = cma_alloc_frozen(cma, count, align, no_warn);
+	if (page)
+		set_pages_refcounted(page, count);
 
-	return page ? page_folio(page) : NULL;
+	return page;
 }
 
 static bool __cma_release(struct cma *cma, const struct page *pages,
-			  unsigned long count, bool compound)
+			  unsigned long count, bool frozen)
 {
 	unsigned long pfn, end;
 	int r;
@@ -974,8 +982,8 @@ static bool __cma_release(struct cma *cma, const struct page *pages,
 		return false;
 	}
 
-	if (compound)
-		__free_pages((struct page *)pages, compound_order(pages));
+	if (frozen)
+		free_contig_frozen_range(pfn, count);
 	else
 		free_contig_range(pfn, count);
 
@@ -1002,12 +1010,10 @@ bool cma_release(struct cma *cma, const struct page *pages,
 	return __cma_release(cma, pages, count, false);
 }
 
-bool cma_free_folio(struct cma *cma, const struct folio *folio)
+bool cma_release_frozen(struct cma *cma, const struct page *pages,
+		unsigned long count)
 {
-	if (WARN_ON(!folio_test_large(folio)))
-		return false;
-
-	return __cma_release(cma, &folio->page, folio_nr_pages(folio), true);
+	return __cma_release(cma, pages, count, true);
 }
 
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index e8e4dc7182d5..0a57d3776c8d 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -20,35 +20,39 @@ static unsigned long hugetlb_cma_size __initdata;
 
 void hugetlb_cma_free_folio(struct folio *folio)
 {
-	int nid = folio_nid(folio);
+	folio_ref_dec(folio);
 
-	WARN_ON_ONCE(!cma_free_folio(hugetlb_cma[nid], folio));
+	WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[folio_nid(folio)],
+					 &folio->page, folio_nr_pages(folio)));
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
index ec1e47a9044f..dd22b1d8ff90 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -515,13 +515,6 @@ static inline void set_page_refcounted(struct page *page)
 
 static inline void set_pages_refcounted(struct page *page, unsigned long nr_pages)
 {
-	unsigned long pfn = page_to_pfn(page);
-
-	if (PageHead(page)) {
-		set_page_refcounted(page);
-		return;
-	}
-
 	for (; nr_pages--; pfn++)
 		set_page_refcounted(pfn_to_page(pfn));
 }
@@ -952,9 +945,14 @@ void init_cma_reserved_pageblock(struct page *page);
 struct cma;
 
 #ifdef CONFIG_CMA
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


