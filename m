Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC317D277CE
	for <linux-mm@archiver.kernel.org>; Sat, 10 Jan 2026 04:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 771516B00AB; Fri,  9 Jan 2026 23:21:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FDD16B00B0; Fri,  9 Jan 2026 23:21:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FF356B00AE; Fri,  9 Jan 2026 23:21:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F09856B00AB
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 23:21:32 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AE37D140107
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:21:32 +0000 (UTC)
X-FDA: 84314755224.08.875728D
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf29.hostedemail.com (Postfix) with ESMTP id 2006F120005
	for <linux-mm@kvack.org>; Sat, 10 Jan 2026 04:21:29 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ojKvlxGc;
	spf=pass (imf29.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768018890;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pFoA4TNvNSDcT3+oxlQmiTObbmVAyKNmX2D6/5F+JYw=;
	b=8BDwlySrLuYbx4kBbjKLqF1zfw/EermQhmhLG4ULPayVZlIWFr1fUS+sHVJ1k3tQkIWMbX
	TsROAeHbc3d5l492/OTsFq9CgJ/XbLW1ibj905++goLLCN2GapveViniHzu1QMRl3yUQPV
	5NuqlGYDEhRDsVmh7+YdvN/U0RU2gf8=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=ojKvlxGc;
	spf=pass (imf29.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768018890; a=rsa-sha256;
	cv=none;
	b=CGDaiKiDqD5CVG5pxB6ZwYHMl/2jiaVwi2QlPjIutBDeKei7sh5n3GbnvReiMR+ToIH9Bg
	IVENmThO7mxpzzR4EH+jlUtx8wsBUPs0hdmgxxp6ZRM2EWPoLxujt9MAJrUi+SXtX/w3ZZ
	Q36KjIWK7U6XVD39zqRkbK3+LKg9LAI=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=pFoA4TNvNSDcT3+oxlQmiTObbmVAyKNmX2D6/5F+JYw=;
	b=ojKvlxGcASHP3zaZTO3GsdP8rv6GKZffivPur8ivpJEQOSfWAI++bUEaJcblsLH4F5mpaUD1F
	LeMDUVC19WZrbjAHeoSlL0QE9Wx8WCfBPk55hkXv3aOPs58bYIUqOA8zF7IBxpKe/BelRNrHzVg
	6snmAJ3kg2rDTMW8XlDwByk=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dp5305Q9Fzcb1W;
	Sat, 10 Jan 2026 12:17:48 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id A7FFD4056A;
	Sat, 10 Jan 2026 12:21:25 +0800 (CST)
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
Subject: [PATCH 2/3] mm: hugetlb: optimize replace_free_hugepage_folios()
Date: Sat, 10 Jan 2026 12:21:10 +0800
Message-ID: <20260110042111.1541894-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260110042111.1541894-1-wangkefeng.wang@huawei.com>
References: <20260110042111.1541894-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: 49t7fd3edixfs36ouijzq15jox9c65af
X-Rspamd-Queue-Id: 2006F120005
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768018889-656209
X-HE-Meta: U2FsdGVkX19oHbbbbZRXCovWvL1xJ3JzX7TmQ2v2aTB6DzN8i5iphGXE+5aclBicr1U86KRpaZzu5O4Lono6OM6FDvctQWnrCrvTRaGEdpatgZa7hKrpbCUajZqhzGJ39Yk8fUhCBPqoxwRWSk8ruS8P1x3jz1zqLbyThYxRf86dlt7/10/GrclvIm3qWv5YXpJVZ8OkDVIgvgXTUuJxwbF210fK3500jUf/RoXL4wvuqyhIe9dvrFP2GUOmNnnEiE+/nQymbhEQ+pVnT5t92Pe4LuNGSCzS7nXqX5MzEbOSBOv8INXu4htfjQC95QRrXV91u96vpw0a7/yQC4TmClD+R5jXRULyu870zRljzH4chxIpXoZ2LFCbN3iQY2eMzF651jLRLy1tyPbiNB9dBpKxl91SiYuLfhwUU6gyCHq3uJLst0jZjgw2bUxX2HdylrfpahBiKROIFlakME/Sj9Zm9eNJ4a/OzLfvfWQZBeExkCDdn0077YGwNRFtgN7agxlzg8wiWoCnp+geI08AKgColJ8HGB6TPuIgo8haw/cinkSBUxKPN6E+9PA/vEiibYHO0nGeTvyGZlS9VmbXe4EQelOZbRt9A6vlxfLfsKpdRnQO2Bp5xA5EmUYNnjthHmhfX56wO8WPfJ7e6fWEsFHeXQbZO+IdjkMGXUVNLm+VS2g0fREgcGwzV9OflKnwcjlMgitVX2mRYvMC1k4RHt7twhA8CTIUgQKaHudaqyHZnM2kar/5qeZZudlSeiCySmXiKRap41k3oi6V5h65i/jMZJqDPbSFSmjVs1xhfgSVOn54T3tKolYnRjLdF7BdLqxVKz/c6YQfWMhqFauS74Om+REOrtgtx65o9R1eItyoU3Subc4K3hKEvaNlA064mmfU2/3IV1WLGWofiVpqptrbbjkL+tuOyB3j5I0g01gEizbqEYmrRLvm99RK5g1G4iJW1IA6ZpuAJgpOjJa
 pbutvu6u
 LX7usUyW2FzGsFYNWRN3wtmxnDR2dosiWkUetMAbevhjDDv6rPDlerTeqV0EUnlXptCxlCKxg6rR5CMWCP/iijCtL855VgSQ6+bmMK5mUEM1Dwozfv5c4FivBsY/O97JbcBPXxBIvPqI61u3IjkTGAPUkUAk/7drLUZWNCSm1f5rwGMbcTZ9Ml9SI6HBQm2yeFU8TFRKWQOdqCJcFnuhJi+DDnAy1B4Sl1PsGgAEdxkEF70c6ZxWoX89kSTgdzOG/v6jSPutucHJjW8IsC1roMMhkmm4H4HwduCA0bitH3qwj9AgkAG4jYQjJrjEj7nZrVxyBgjqeORta7UomsmWCn1HeeA==
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
presence of non-gigantic folios.

To ensure that gigantic folios are not mistakenly replaced, we utilize
the function `isolate_or_dissolve_huge_folio()`.

Lastly, to optimize performance, we skip unnecessary iterations over pfn
for compound pages, including THP and non-compound high-order buddy pages.
This helps save processing time.

A simple test on machine with 114G free memory, allocate 120 * 1G
HugeTLB folios(104 successfully returned),

  time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

Before: 0m0.602s
After:  0m0.431s

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 53 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 41 insertions(+), 12 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8c197307db0c..a80cef879f61 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2806,26 +2806,55 @@ int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list)
  */
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
 {
-	struct folio *folio;
-	int ret = 0;
+	unsigned long nr = 0;
+	struct page *page;
+	struct hstate *h;
+	LIST_HEAD(list);
 
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
+			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
+				if (isolate_or_dissolve_huge_folio(folio, &list))
+					return -ENOMEM;
 
-			putback_movable_pages(&isolate_list);
+				putback_movable_pages(&list);
+			}
+		} else if (PageBuddy(page)) {
+			/*
+			 * Buddy order check without zone lock is unsafe and
+			 * the order is maybe invalid, but race should be
+			 * small, and the worst thing is skipping free hugetlb.
+			 */
+			const unsigned int order = buddy_order_unsafe(page);
+
+			if (order <= MAX_PAGE_ORDER)
+				nr = 1UL << order;
 		}
-		start_pfn++;
+
+		start_pfn += nr;
 	}
 
-	return ret;
+	return 0;
 }
 
 void wait_for_freed_hugetlb_folios(void)
-- 
2.27.0


