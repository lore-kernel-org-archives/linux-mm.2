Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DDAD8C9EC98
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:10:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CBF76B0095; Mon, 12 Jan 2026 10:10:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 819496B0096; Mon, 12 Jan 2026 10:10:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 692F16B0098; Mon, 12 Jan 2026 10:10:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 549A66B0095
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:10:31 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AD73D0C34
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:10:31 +0000 (UTC)
X-FDA: 84323648262.25.C3BB6C6
Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	by imf26.hostedemail.com (Postfix) with ESMTP id D0637140018
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:10:27 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bz9Y2N77;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768230628; a=rsa-sha256;
	cv=none;
	b=irpuyL4LDWRPIWtzfn7vHnoZXxAlSS3iW4t/IjgsdlVfm8IzXxLT4wMeWHvs2rLs+dAMID
	MtPYZk2WjEHKwIlvS2d+FpUr+yod6zLHkYqEmFvK0QtAKsVs6fbcqV4ECWHj+bUeJ1hi6O
	yzWeBQxPQDgbserdoWSqAYExUZ2hRPE=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=bz9Y2N77;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf26.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.220 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768230628;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=d7Pe9JTh6oaI0w9sn2LUvBQy9RTuBy2ZUXoS90gZfG8=;
	b=SX2qkYgxwT25G8XF06Ok4C08qXgDkNs34p7exptN6wnNmnxoHlr5VdkLykavlH4P9boA9a
	g3VO5e1hEGBWsSloZjxnuXRd4eVc3Lxy2AWH3mzkKI57V/xnB4DYd3WaNSGiBfzAf6f28m
	RGt9PaGigPVHaH+qnPRexZvQIG/hDio=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=d7Pe9JTh6oaI0w9sn2LUvBQy9RTuBy2ZUXoS90gZfG8=;
	b=bz9Y2N77iNLYqfxqZ3kjPf1u10la7pV654oBr+Ty+xH4S7aXKPXdndehkm1U1Gg82Supg3ltr
	MTkiHiCFZMBQ+Ken9PTpcWS2MMYyXpPWKeN1S/a8D/8MRqE7aSVbqKzH9LG8CvCOpubm+PH+HyH
	hETU7SGeNbFg/mi6r0RO5D0=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4dqbMZ4D3Lz12LJ9;
	Mon, 12 Jan 2026 23:07:22 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id D10C9404AD;
	Mon, 12 Jan 2026 23:10:23 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 23:10:23 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 3/5] mm: hugetlb: optimize replace_free_hugepage_folios()
Date: Mon, 12 Jan 2026 23:09:52 +0800
Message-ID: <20260112150954.1802953-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: D0637140018
X-Rspamd-Server: rspam06
X-Stat-Signature: m683m5gxyz9pdiwtujmxntsqtm4ywc9i
X-Rspam-User: 
X-HE-Tag: 1768230627-634913
X-HE-Meta: U2FsdGVkX1+92JvZy7EIB7uR7GD1cftnsN+7/zckdbOuTNYaAouqpFO3ZJRhPhkLTMKSLUjXRpylp0PVBesOXDsYerQxCHqFeRmv9q8E7IMQkppPhmbGqJdKWEx5OSnjKPQj2doz5QlUXvBMd3czPnY3b26yaGw4mdsw5sB5gIOS8KRvbje+oAFRJusLHY81ov7WO1T9WVn6tZMPRPm6WHCAWgvtb9M7uMEM2zCoGk2KFVrA2Nw5dbvIBA5cgkjr+jTredWZJpT1T1vZduRNEd9Gmf2fni8rU/+cCc8aWp3QC72YzY+dZ1i+L8bH8m5h3hgcNYtG8Cqh9v8cSMtxqs5S9KrpeqvW6WzGmAIACc310ZDZR2SJxOgknumYK/4DXKc76FgEHJCRWZzmc+tSVSJvD1UXjo/b36xYn64VQg7/LkxGmhyD+awCEewl08kl+qiKpqwoyn2+qT8kL2/YKZ2dP8Yyc143p/TR+zkorwJDzqdi4zzMXq/vDXzR+S6kgN4m/qvsIG8AhST99aTLwsQiCnyMDOYzlG4JMgSY/7lrp/tSzafu+daf0fbryIgaDG93Cz5ODifddPKJFD/pQTTeJlRBUBNygbyfLqB65CXW0csdBnBndTsItPD0VmrVaSSuyzWmZv+sczhQe6PiqNPqG3pwzTNAqyA9JeoM3OLT67mbpFgieMVvDrzlzrr+IC0Pqhvi55a5iS0nohQ3rW8nQ1heBK+52jsYDCYjsAxDSlQQKAWkgY3YB5eygXprhre/gC5Hr0MI/V4xORUEVBEL/4sDiV+3vrQ/pGhvzG7ww2PF5ILxAiiI/8pI27J8AeGZ1JAhFJVv4LSsbIEDbtGCkFeBDQSFBdLXHg5ADn12QT1WuUsugzZXFk+74GkHhWFqQ9cwOiQCdtQ3AD+QiSfjgQjXgCAqiYbCWYh/f0Efgw13YevIgiX+5iFzfiT+fbvN+0N7t9rk/PpwyeS
 yeR48QOz
 PcLh6OMfZpFCLz2j6wQF62KLJVgvfWVH2sU6SXpmNnHfbr6bbNXmBbN6V1+UP6gP6dVsuPEkvsit9QQktIHAjG4APoRjQlyPVn1MY9/bjzTsnvrdB6SX/ts599Dsf83jct+UgjoukVZt7vKuTSiG/LXpcYcsEI/ewtDZjRwmE56lgt7l3qEIL0dvqUU3yfyWcoqsd0KQoLV9BFgM8Vy1HqlGzCaL5rFUpiVPEA15pUPBrPpgW9nYATsxP0reiAugu+k+bsyJ/rZCarHdC43U+vSdL8veTBTWQrjtZgQPKXE4ufUCDaRQTVxfyMUpbfmgDR92cCMt4mXIL2hyOHPzk1MyrwQ==
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
isolate_or_dissolve_huge_folio().

Lastly, to optimize performance, we skip unnecessary iterations over pfn
for compound pages and high-order buddy pages to save processing time.

A simple test on machine with 114G free memory, allocate 120 * 1G
HugeTLB folios(104 successfully returned),

  time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

Before: 0m0.602s
After:  0m0.431s

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/hugetlb.c | 54 ++++++++++++++++++++++++++++++++++++++++------------
 1 file changed, 42 insertions(+), 12 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8c197307db0c..2e296d30a8d7 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -2806,26 +2806,56 @@ int isolate_or_dissolve_huge_folio(struct folio *folio, struct list_head *list)
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
+			/* Not to disrupt normal path by vainly holding hugetlb_lock */
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


