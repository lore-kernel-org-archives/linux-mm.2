Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8EA38D37E33
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 13:55:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F28B06B009F; Wed, 14 Jan 2026 08:55:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F00586B00A4; Wed, 14 Jan 2026 08:55:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2C8D6B00A5; Wed, 14 Jan 2026 08:55:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF9AF6B009F
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 08:55:33 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7B05DB99B1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:55:33 +0000 (UTC)
X-FDA: 84330716946.07.369388F
Received: from canpmsgout12.his.huawei.com (canpmsgout12.his.huawei.com [113.46.200.227])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1ACC6100004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 13:55:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=meyPpgHK;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768398931;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lLhImaTtyQlUStc6IBTxCVEdxc2yGG1I8evBeFzrV1Q=;
	b=EzVrRhhE5zFw4a2JE0QIwhM3dgXhN0ysUE+2pDCqNSH2G0Skhn9jy7cUh6RQFdTt031Y5Y
	YergYGI1w6trcwvYzOVAJ2f2BrLhxVDz2Pyv/wARTAtknJAoDygwelqFVp4Nt/wXy349/K
	qA6TUrsFSAoxDIwC3zIK8iQmenevT3s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=meyPpgHK;
	spf=pass (imf14.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.227 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768398931; a=rsa-sha256;
	cv=none;
	b=4RpcLYBVGwkoxBa784o+Bclrt6e7osQqdEGcaBWMX73ulXzJ/qf6V3FIkSnH6vQ/657Xmo
	y8n7WQNoRWotOfRFwSxpGzC/KmHR/zOD1KhOHf6z7sztLR5dPb+GTHSAHhTih/PzB1mz+p
	xhBBp1dGzRGTiBioaJjHLUInsyEk/gY=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=lLhImaTtyQlUStc6IBTxCVEdxc2yGG1I8evBeFzrV1Q=;
	b=meyPpgHKcsjUtNYQYEvHPS8R8QUo2L15poBmKSyDQm9sF+52Nux948X14T3+JOC8LJbp6q54W
	N+Ccw3RdQq2XqSxoS1GUQCJPPM9mW13YI2zV1IYbThNJzOjC8zX/p3ooSK3igXuaH9kCS4cPZbM
	ud1DAdFEQgzzTxCQuJZGmPw=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4drnc85f6QznTVP;
	Wed, 14 Jan 2026 21:52:24 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id E89D940562;
	Wed, 14 Jan 2026 21:55:24 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Wed, 14 Jan 2026 21:55:24 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 3/5] mm: hugetlb: optimize replace_free_hugepage_folios()
Date: Wed, 14 Jan 2026 21:55:12 +0800
Message-ID: <20260114135512.2159799-1-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260112150954.1802953-4-wangkefeng.wang@huawei.com>
References: <20260112150954.1802953-4-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Stat-Signature: 11d4guajwc19hdtxghnx7a8395t3ph8x
X-Rspamd-Queue-Id: 1ACC6100004
X-Rspamd-Server: rspam04
X-HE-Tag: 1768398929-27591
X-HE-Meta: U2FsdGVkX1/ggYv1fO5iwz+bDRblia+wQCXeOUtszz7rxCJykIsPcsVATzUg9a8P73qmnhsLJldSVgKC9nzF1Tf1QjvGFUictOVGz2GAqFXsd+lTQsjaSGlQegpfgK13Z2odfNo5u9Xjh+LrKOmshUKiXzx3V2IOqzu19pOJ2dzpNZEbKZ80tmmEor9Nqv0+Xjs2Uv96ArRebQGvbGO/e5F+2jvqFpUEx9EcHB8JJvemlHBOd8OodUryFW1gKfBR62DRKuHDnGcKfvms2Qc6RSIc8euGwdIH8kOdgPQMNd0pKGSMdoXMugQqaQlW54Tqv9jJSfLBLEuH8wtuWn9dFQPguXq77hM3KmoRyoSRvre9WJyiKQgM+MDKGHc1+bEz5RZBJ8ZM3jxtXjEBuXema6jYN+40ULJkY1Oi1UFRvG7+TLMvXjB5ndDx5tfvvR1Ucju57HO44e82U+iej1NEldgVs2yZVPK5C3XYYjAggeCBtaAStXEVbtXV9NZ54LnGSFjOL7I0FxNWaA0v0EV3bnzAk2qOJ426x5UI951YIYaXIhd3Z3t5M5IhLtV4g9Qw2c553Q079wNhkcwanybh9SbSJQEcgOzdeXV95sfmz7gvFLhLf4Gybw/nhIjPPcbWL8nX8pGPx/6ppmNxUwaWm8dAjdsD9AniGDBSGZYX4WHCS81hB8JD6uwcrVcqz53aoY7X+cf6hUEynD/NODDvTP9Ey9t/Jz3vxT5/oAb51HM1FGV7eslwD+njxsePdwW9HCHYPnxa0SB03fp88lb6g6DhjQfPnRUMLxcKz3+Q6GdvUgheDPRwbDyjtL7DN8lNlpew9RpzqS8WrsiwM6i574UPggmb14i4i+pNF5SfaMeSFny9u8gKPExSBT/vGfFjTKuvuTUBfCT5PezfNnRbEy1qN1LaT33uK6i2+dITJYjKLcgpSjgB+Bcu/F1Tcg98AqEAiGZW55zIvkWL3s8
 vwSPLDUt
 5Yh7Slco6C2fhu2cyNzuVOzBuc8uVbk77phvAcuCmkjbOFVtl3bRmib7sX3DDdxp3tXB5iW1Ur0e3lG0EU4w0tO9ZITEfa5e5nyAHSdasvLJxLkUmvATA1DM4xPkpnLHrdLEoPD+wEUyiSqp0WeAB2Wa8K517vngv3MF1tlFDioWp9HDUTpfC7oG9+ijhH7/Es4dvZAo2C0DeJDlfuBh8ecJ0jjAQlcMyZvtVyUy2vNyQhe2KIKa28AZM7Ei7EkDBEskyOTM+ApkqSuF9skQI1Mziq+eC8+6vDusA9Je1gK5HV/jPwzBshxBKj+H3bC/gL3lXa6fZiSm6x7gfGJd1lIwtNQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

If no free hugepage folios are available, there is no need to perform
any replacement operations. Additionally, gigantic folios should not
be replaced under any circumstances. Therefore, we only check for the
presence of non-gigantic folios, also adding the gigantic folio check
to avoid accidental replacement.

To optimize performance, we skip unnecessary iterations over pfn
for compound pages and high-order buddy pages to save processing time.

A simple test on machine with 114G free memory, allocate 120 * 1G
HugeTLB folios(104 successfully returned),

  time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

Before: 0m0.602s
After:  0m0.431s

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---

v2:
- Turn back to use alloc_and_dissolve_hugetlb_folio() since Oscar
  pointed out that the return value is different. Then adding
  gigantic folio check independently, also update changelog.

 mm/hugetlb.c | 54 ++++++++++++++++++++++++++++++++++++++++++----------
 1 file changed, 44 insertions(+), 10 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8c197307db0c..e3c34718fc98 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2806,23 +2806,57 @@ int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list)
  */
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
 {
-	struct folio *folio;
+	unsigned long nr = 0;
+	struct page *page;
+	struct hstate *h;
+	LIST_HEAD(list);
 	int ret = 0;
 
-	LIST_HEAD(isolate_list);
+	/* Avoid pfn iterations if no free non-gigantic huge pages */
+	for_each_hstate(h) {
+		if (hstate_is_gigantic(h))
+			continue;
+
+		nr += h->free_huge_pages;
+		if (nr)
+			break;
+	}
+
+	if (!nr)
+		return 0;
 
 	while (start_pfn < end_pfn) {
-		folio = pfn_folio(start_pfn);
+		page = pfn_to_page(start_pfn);
+		nr = 1;
 
-		/* Not to disrupt normal path by vainly holding hugetlb_lock */
-		if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
-			ret = alloc_and_dissolve_hugetlb_folio(folio, &isolate_list);
-			if (ret)
-				break;
+		if (PageHuge(page) || PageCompound(page)) {
+			struct folio *folio = page_folio(page);
+
+			nr = folio_nr_pages(folio) - folio_page_idx(folio, page);
+
+			/* Not to disrupt normal path by vainly holding hugetlb_lock */
+			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
+				if (order_is_gigantic(folio_order(folio)))
+					return -ENOMEM;
+
+				ret = alloc_and_dissolve_hugetlb_folio(folio, &list);
+				if (ret)
+					break;
+
+				putback_movable_pages(&list);
+			}
+		} else if (PageBuddy(page)) {
+			/*
+			 * Buddy order check without zone lock is unsafe and
+			 * the order is maybe invalid, but race should be
+			 * small, and the worst thing is skipping free hugetlb.
+			 */
+			const unsigned int order = buddy_order_unsafe(page);
 
-			putback_movable_pages(&isolate_list);
+			if (order <= MAX_PAGE_ORDER)
+				nr = 1UL << order;
 		}
-		start_pfn++;
+		start_pfn += nr;
 	}
 
 	return ret;
-- 
2.27.0


