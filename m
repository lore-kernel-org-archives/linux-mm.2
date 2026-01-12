Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA358C9EC97
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 15:10:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E52566B0098; Mon, 12 Jan 2026 10:10:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1DB86B0099; Mon, 12 Jan 2026 10:10:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA1806B009B; Mon, 12 Jan 2026 10:10:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B69726B0098
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 10:10:33 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7D18513B068
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:10:33 +0000 (UTC)
X-FDA: 84323648346.05.CD724A1
Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	by imf04.hostedemail.com (Postfix) with ESMTP id 7C8C940003
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 15:10:30 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=u9kNmfbG;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768230631;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T3Wv2BWUzLcGxIwhVjVU7z2GqOUdv/lcccUWdduX86A=;
	b=owWJZPqU7wKUxTms5RR15q4kcFYMeQGTfEa/JlQa9SBloyg2kZKOUQ9bZnWo4y+r3zZSS1
	o1bXqexarBYUCTAOApgVFusA9BKpGpUY6D5EuoBXbrXLW2F4Ccn4s5KM2FoM6wVzjFSIKl
	QGATeT2qhhiGr9jyiY23PxDK9l/ZDXc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=u9kNmfbG;
	spf=pass (imf04.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.216 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768230631; a=rsa-sha256;
	cv=none;
	b=R3zFKekXWVeqzc1NzYbKdUu8UEc31clHBYbocuSZFrkAC7xi0VHQ+Wx0BEvKcZmGLkO5ZU
	0u6jWjthMttJI9cf/Xcx9twCTpFsIqIo1YWqZuS8m2t/7KC8hP2HOJ9q7GM1BxMsEPqts/
	NKr44Z6+gJ2y3OTNekEpT8XwlZkbiPU=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=T3Wv2BWUzLcGxIwhVjVU7z2GqOUdv/lcccUWdduX86A=;
	b=u9kNmfbGvWab56FOvlfQKeNdM/mte4pfWV697HOkZVjMJENm5PAydWsYgMUf0K+eSZu/XTdWY
	JSCeOWVzy+Z4WstdUXQ6mWgm2fA7ACJedVPncDTegq+wJx5MxL4iboCkH73eeBi5xXpAmont6LL
	S9sXREK8x9+N/VWJrckjn3U=
Received: from mail.maildlp.com (unknown [172.19.162.144])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4dqbLc4mLwz1T4Ff;
	Mon, 12 Jan 2026 23:06:32 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 0D93040538;
	Mon, 12 Jan 2026 23:10:23 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 12 Jan 2026 23:10:22 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@kernel.org>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH 2/5] mm: page_alloc: optimize pfn_range_valid_contig()
Date: Mon, 12 Jan 2026 23:09:51 +0800
Message-ID: <20260112150954.1802953-3-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
References: <20260112150954.1802953-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: 9qezqqqgo59rzkax7deec6akxdi1xw6t
X-Rspamd-Queue-Id: 7C8C940003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768230630-820520
X-HE-Meta: U2FsdGVkX183oErjWT5ed+rl6+uIvCF/wxORNvF2Pe0Ssk1WiXBH0Gmwflf6kaa6kDssD3MmdX9W2k+SfDgXsdWjo2XDCm3o11Pc2xeWFXb6mTEdqITKar+rXrzqiTaVUT4JhLJh9rsVnOhMmIcbLTgzPqtch46OGN9pioXvvDvh1GiCLRpxUqvPtvX2q/ZNDjtV0qTtg0aTTDqMpNcyz0vRT17OVdLr4crRKA83CRC9S55epjUMH5CywZy0gqgCScKOK+tz3NuTDZmIlhDHxGTQPxNxQmdaCmEC0DwKl4gdkyqjjmzlefaPaPeIp0WO9aOlX1xsV8pbOQ6L7jGui+OkHiJbhRXg3p6dmNL4rISIkxvT9yZS7WfgTcsTpXpWkHs3mNm+RFEkZgqbQYO+lgpDh69tlAo/EloV23+Ya0WNrog+cPRGO2xAt9BRqcZ5pBpNU9R82XU9gXAkB7T4Yfa3MUWDM+TTLTrkOjPzj30p2PHaq0b4z1SMrpagNfEK2TQidrqq9mEAc9akR476YlyEIdz+HCMfk0aXnfZIAnMyURAdVkhurArJvEOCfBg2ZWQ6+zGWxje82SaOByGRTGjR1lEJkphJOQpigmR0tp/0TmPciVLE0Xf/WaUcVi1jcTOSw06EBmxOPWOwivXNLy9gzeZX/QRVKiCHfnGQl0A1CF4+r1KphoNH0U49sj7oQaSr5zPXEY44xFD8ggpLblDDV1egE3PFWlVvNAgdK+cBayDw4eWc5ga42v4dB8m3IOwccAdo/415GS/0G43LWgPBAUmXyjMirgWytpqt8Sml4tYeQ0kEPn9Fo8wr1/XhWswmwgKcrmW17oDu+cFyh+4/GQPNBLwh9eSbkTUW7elAUEcCqmv5r44hyQIoS9/qsPjUbqc7NPkG8zkYen4uKH6mTUz4Fyon8TNWd96Yx6wkwRgZ+Vpwz89RAhcBXnQYQJYk5UMdiNWXk0pB6Ec
 SKKAj09X
 SRm4pt3sU9DdglDwZHMRsJBj50pn8VIUgZH4zx7ZLDz/7B4Lyvqnc0Yx3J1QxUjKJCgaL/xAALYFKmNbXQCSquljlwgNrjbIUG7j9Ucu37/+lNr8/PJlwQsbwwtppwk1S4ZIPvSPPh3fSyNy13eJJ7bAJZA5ExPsQQ8sl23zgl1eWsMbvPPcQu+soC7ZvkPac/Gqbm3FYE1YJrLGIt56l54tfle6jGXswDa7P0KO3SrGQvw8fDPOuvSWVgYAtrv2pybWQCI4ItBsbWXN94WBvcpFDNtpSJhcx5lsiFSp7b6PhRSjJiByEN1MOheV7lEZYiU19cpd7nU9xmHCaYweplnjkRg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alloc_contig_pages() spends a significant amount of time within
pfn_range_valid_contig().

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

To optimize this process, use the new helper has_unmovable_pages()
to avoid more unnecessary iterations for compound pages, such as
THP, and high-order buddy pages, which significantly improving the
efficiency of contiguous memory allocation.

A simple test on machine with 114G free memory, allocate 120 * 1G
HugeTLB folios(104 successfully returned),

  time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

Before: 0m3.605s
After:  0m0.602s

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/page_alloc.c | 25 ++++++++-----------------
 1 file changed, 8 insertions(+), 17 deletions(-)

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
-- 
2.27.0


