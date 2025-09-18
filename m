Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 160F5CAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 256048E0111; Thu, 18 Sep 2025 09:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 198A88E010E; Thu, 18 Sep 2025 09:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E87DB8E0111; Thu, 18 Sep 2025 09:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CD3248E010E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:20:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7877B1401BF
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:43 +0000 (UTC)
X-FDA: 83902430766.27.82C1EB2
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf28.hostedemail.com (Postfix) with ESMTP id 4FD22C0017
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:39 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758201641;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nJC8vY1OFWCveZ2p+oqcaOuTpPBxBRj+1SaC7ITRr8s=;
	b=hrZWcpBL3q/wZ8I+L858ltt0C7UGFASjD4m5SyCH5Wy058Hb5oO4/BKtvzwuMFP42HIu9H
	7VUpxHTgqm+lKwMzmOtjDQKxDOSaqINoDvEkK/yM2YmuLPwktydsTVOz9Vmhq4xMlp4t2T
	HhD3cRIBN2KOdY+5FhJXP6F4woOO2Zw=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf28.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758201641; a=rsa-sha256;
	cv=none;
	b=Bl0x3jcOqHG+gTndPuhffzNtcXCFsHmW9jb1qOaTeWxqZQdKDy1Tn/IhdN7I62x6yg8NeA
	jqxpvHVPFrnrCvnWDIUrfY+XNIQf5J4TWBzXghZSCXDCYR/v5CcEQ9wxb4ppFBUz6vghpU
	6LV7xZuM6Shogl466Jf/w8l2xyWd5Rg=
Received: from mail.maildlp.com (unknown [172.19.163.252])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4cSGTX3vwLz14McN;
	Thu, 18 Sep 2025 21:20:16 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 79441180B63;
	Thu, 18 Sep 2025 21:20:33 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Sep 2025 21:20:32 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 2/8] mm: hugetlb: optimize replace_free_hugepage_folios()
Date: Thu, 18 Sep 2025 21:19:54 +0800
Message-ID: <20250918132000.1951232-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 4FD22C0017
X-Stat-Signature: 8h7nickad8p8j3mi13udybjtz5e34bhf
X-HE-Tag: 1758201639-380498
X-HE-Meta: U2FsdGVkX1+SG0u3mMpoOtrdypgTRdjIi8l+XZlwwElBjByFSoxnroZtvFHkGzXMX+urTgzMtyZScf/+kqzhsnixDdllnfpilXYxHYfh1pOye2bnUHkhPk4hIOExUN44l97TstDGi3S3qzQ1jYUcqnOlpEZP66I78d+yQoRhUUSRqhJE1ElgUc1NzkC2QLxY/yzWsAnqLgnGiJikDf/fmqLF9gefBr5tVjEaiLPdUFIpgclYLDXCa9n99TaVmEna1sd4NUNK7SSdsQXyBO4nmsU+Yy1bIceIctpnAnf3qYtj/wAb+AV/ltVQIGSJrDHdsTkMuNBPyAd52HYl5gGLJ8/BRtx5rKnOYLmHhjuNhrLTxQk+USUjqH+GXrYnFTQR2kX7HlonR6YlJHRrIWB+FY+fRUtC3qOUPhPb0hFdwP8IZC7HDw2PmddvYbyGgxMdMzIkzyif6GB9dTZ/x7PZOymLQnCl73hMOPLFsOqiYTxOU54llH9jzhLbhe3Ll14rZW9t+zA1M89+G4nYnlP0qlUpanU+tJ3bVFB0MpZNmxMnmxkl9/vOUzN3Cs7LGX8kk3/Hst9SvfuFm/oy8fpmEL6OWn9zRJgcQU7slAayEftvRMFLonfB77XpyMmB7OAS0ZPDS99CX8qLY4Zi5B8LIr91qU+r/+fs3vkDJR/0CjHmWpfrj3IN1PjMzcLTldSNXrWW+mg+wo+HPXHt43dlMITOegAlXbL684Eg4luNsLOeZT6N815zQolPop/rwPaZY93iPexeuQNbfddZPPN5iAGeJwa3g8rre3GI8K7wMD7p8EliXXq/XVaxMVB9ye0JcgBFiI07zqHPV6GbkyA10oJqQmi7akte7JWm9dCJfKbIGtZOEzBKkLE4k8zHTM2yLjAqvPJW3233GH9PlU+0gxfsWu4fdbIVjiXZb+Mwax7bWNQ1TeuAbeAsZHLqQByoCCnuahVSf68xbnagGuI
 hH7/Y+hW
 zqgiOhA9Cgwf4t70uN5+9vDJUSdO3cu/j5h1HCVGSxN5kcEc4uSfKjJ9B99oGIybPa7Xh23lV0AJDiMKNvkWhMl7LfISlu9slrEVKeXhiioghp2oWt+EmN6rTxf0wdqylfg0ILSJYT45cxZbyyAA9wUN5cMMLkehHR2pF4/7IvXDJfO/lxAoD2iwh9PRxJIkZAMV1pMV0Bhx0P2CJE0dc73BJcxq+ynqPohI/ik3SLq/pPFH+cdWNccVIkw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

No need to replace free hugepage folios if no free hugetlb folios,
we don't replace gigantic folio, so use isolate_or_dissolve_huge_folio(),
also skip some pfn iterations for compound pages such as THP and
non-compound high order buddy to save time.

A simple test on machine with 116G free memory, allocate 120 * 1G
HugeTLB folios(107 successfully returned),

  time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

Before: 0m0.602s
After:  0m0.429s

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 49 +++++++++++++++++++++++++++++++++++++------------
 1 file changed, 37 insertions(+), 12 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 1806685ea326..bc88b659a88b 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2890,26 +2890,51 @@ int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list)
  */
 int replace_free_hugepage_folios(unsigned long start_pfn, unsigned long end_pfn)
 {
-	struct folio *folio;
-	int ret = 0;
+	unsigned long nr = 0;
+	struct page *page;
+	struct hstate *h;
+	LIST_HEAD(list);
+
+	/* Avoid pfn iterations if no free non-gigantic huge pages */
+	for_each_hstate(h) {
+		if (!hstate_is_gigantic(h))
+			nr += h->free_huge_pages;
+	}
 
-	LIST_HEAD(isolate_list);
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
+			nr = 1UL << compound_order(page);
 
-			putback_movable_pages(&isolate_list);
+			if (folio_test_hugetlb(folio) && !folio_ref_count(folio)) {
+				if (isolate_or_dissolve_huge_folio(folio, &list))
+					return -ENOMEM;
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


