Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6B0CD5E133
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:49:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1F26B0092; Tue, 16 Dec 2025 06:49:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5896B0093; Tue, 16 Dec 2025 06:49:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 546F06B0095; Tue, 16 Dec 2025 06:49:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3E3656B0092
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:49:41 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id F2E51C05EE
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:49:40 +0000 (UTC)
X-FDA: 84225164520.18.31F62C1
Received: from canpmsgout08.his.huawei.com (canpmsgout08.his.huawei.com [113.46.200.223])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6D1B918000B
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:49:38 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gVoezulu;
	spf=pass (imf06.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765885779;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Lh5c1aYMAsfBvwCNUcCQdwW1ue3ML3hsE2nF2WsOSqE=;
	b=KpCT6riqmDfB4cqn1TGSbBmPju3wlHmW8J+tPxEF3kd2WOuzgIOkw+HdRxHYbESmNQg2u8
	7VX/tIQhXLkn+l1zvZ9R4K0hyASfbHacUp/ZteT/09bWW1x3haNrxX6VaJBdJIHoFeM3Xj
	tRipSc5fTza+GGRRD0UPcl2veTNGV5g=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=gVoezulu;
	spf=pass (imf06.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.223 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765885779; a=rsa-sha256;
	cv=none;
	b=y0jv5dMmzHX2vM6Z/0UMSQ3b1RaaCZaIXebPulTHyOZ0Z0FuIDGPSvCjQDEipjQSCGyDeb
	Zk4OH5i8eagPlFM5f8MsuPaT6v6iPu08B4ovHpicrKvY+Eremj829rHfh1VgFc+9lRGisx
	SQ/0pkw94rHi5R0UkKXFrW/T1Dlnt4Q=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Lh5c1aYMAsfBvwCNUcCQdwW1ue3ML3hsE2nF2WsOSqE=;
	b=gVoezulu5h7U3nZciGJH5SNJkKZNFBmx/FhOr6eQl7ihVk6rLYW/SdsVWhia+KER1yrrnTPGu
	PboPUDBfLIGHn1BwNQZXLX0jO3H/0MJJOtEGbmRqxq8Wa5l1xki+TgNYgVtZzoVpuOBcIjQNe4r
	5GEzYv+dJ/jGDK6fnOXJa50=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by canpmsgout08.his.huawei.com (SkyGuard) with ESMTPS id 4dVwCW0FVYzmVC8;
	Tue, 16 Dec 2025 19:47:35 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 4C96C1800B2;
	Tue, 16 Dec 2025 19:49:35 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Dec 2025 19:49:34 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
Date: Tue, 16 Dec 2025 19:48:43 +0800
Message-ID: <20251216114844.2126250-6-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: e9x9yyjsawpya6p4w1du537yn34f5ek3
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6D1B918000B
X-HE-Tag: 1765885778-537669
X-HE-Meta: U2FsdGVkX18q+/rXM1Of4qYx3PHftarVHhH+eupS9GRPUQT3mtZL0Sq6kfG+YTOxp6vTy9D17tYTjEHA4WcZvzwn8zP91A39sdLqJEj8eU2DSYxyJtppjj+2DHSqIZUkwwBSLcgU46e7a5JyxqAmkuN2QSqflWsRUBRsJ3uIDvPPL6SSAzMWeyHWHijOyPZhPAnhZdPP5V4OPffzXy+Yn/3wGgmM2Ewb5b2GPJ4cshUk4pV1qeViTRsd/kyXW3WNBxHA4TOYkmy+JFbqd83dZBYvkUGbbfVbVJNrh/pbNHgdo4aEEgeu9/NAg4Rd3q0tIFvOCVa2Op4hXJnQFjd2d51dfDnpswFDveuVztyxg5HieBDo/X0VUDoLeAKoocVJnxNWTZM5Q6swVGc1CIQWIcFRzyJeGoMQZsgzVZDYQQBshKxs2M70rdSUy7Vtp6E2dTU05nN+dv/AWIoIbtG5Le7s0vXVZ7y3M+9F1+AAbypqlEHmyRXD8BNLnh1GKMmUa32JSjOfrqQWueeePRcPlJiGkVhm2YIvavu09m/+9ALSb//zGztqRHttIeO9tml7eDpi2EbQkIK0kPpCURikHQESXJIhYm2nB9ieM+to+u6IT5DqJJZMJtsiphc6Kn9DdYlXey9E5ReWccxti+UpoDbIco5owNRmdwu1SM0+zW2pw47jEsqHOaYL3jMfrvhpRoLfIMchN+0ye/aCdMK4pUnUFeX10r9zovZ/tPBhopsFx4NvST8r1vSiDG7jWOFcAFDRiM0YZsBGXdFZHDIMjyt0ND6+8s6GWpukSrYhbk8G1GdbOfMXek6saWb8iPoEPXA/CReLrJEmR97xXFj1gqdyIcjPc6MwV5Qag4bMtD4bQtScunMY1Q6fI0Z8a6+3EM8qjGblMBxpEER51el9aguPfxmt7jrBYxiKTomEQ2juJbvcH1VV/X8fQnAN77+uCSBN4uIMym2vyO+e3fh
 qcCZ9cfK
 ab8/IlwLkAYxaVwFHeARQyj8G7HVWlCcA/xNM/f1mvRMagqVIfkRvjehOWQ5LP8Ja3grLcrC3hBN1uWDd9cYfHKV1pCmQ5thLIfFqOEgwFq8EcZNbrld1raUAwQXOE7rFdNCpZiAB4cz66SVQRDP88X1C8vc9rWQ86heaXHHiSNl4CqnTsYSD3LeV/NFpqTUcL2z5qDPZPIPAh8v4ftH4ZgEz5Fe/x+RS1CJJP2Hki+fbGYKXqzS1wW+qsqn4sdgAQyUDUyQGTKAoRZ+prdH5YdKQM46Sl3c9nSH5t8vznNYzg5ZghUnb4rU/J75QzOp/hYrRNY95MNwLng+sjMA5sWjEGA==
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
after above changes, so remove the processing about PageHead.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/cma.h | 26 ++++++------------------
 mm/cma.c            | 48 +++++++++++++++++++++++++--------------------
 mm/hugetlb_cma.c    | 24 +++++++++++++----------
 mm/internal.h       | 10 +++++-----
 4 files changed, 52 insertions(+), 56 deletions(-)

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
index 75f624236ff8..6a3258f5ce7e 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -517,11 +517,6 @@ static inline void set_pages_refcounted(struct page *page, unsigned long nr_page
 {
 	unsigned long pfn = page_to_pfn(page);
 
-	if (PageHead(page)) {
-		set_page_refcounted(page);
-		return;
-	}
-
 	for (; nr_pages--; pfn++)
 		set_page_refcounted(pfn_to_page(pfn));
 }
@@ -949,9 +944,14 @@ void init_cma_reserved_pageblock(struct page *page);
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


