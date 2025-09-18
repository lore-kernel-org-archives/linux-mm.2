Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0A10CAC5A0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D9ECA8E0093; Thu, 18 Sep 2025 09:20:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D282F8E010E; Thu, 18 Sep 2025 09:20:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BC6AC8E0093; Thu, 18 Sep 2025 09:20:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9E2DC8E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:20:39 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 61EFA1401A6
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:39 +0000 (UTC)
X-FDA: 83902430598.09.7045609
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf19.hostedemail.com (Postfix) with ESMTP id 3B9E51A0007
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:36 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758201637;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MyYHP0cflQ8JWlZ5Mdg0QKR23ZOrOUoMgyi8eF+MkV0=;
	b=hLqhuBMsw+mR8poocg6BVioBfu1sGrzBXO8+K3+wsLOWA/VmjLssUm+5uq1q9ZAx4esqHe
	18lFa3tl1KaqpLAvex+hRJcjZ9yWywVvMT+EiRRhl1TDqZBq4tnt+aXp2GSDPu/pUdo/y2
	Iup4P6ic3ffDFnZpVbLbjsVbN0Ss9YQ=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf19.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758201637; a=rsa-sha256;
	cv=none;
	b=d5ZqH3X7F985pIzEBoHjF6GP7xb3PTQLunLbeGeG+rkbaRJauyK5qSqyOGryFhZqtxKLvK
	FKJdONhJN9pwxABUuokAwmsLPLhrMa3EHRHcVyMAWEMKwA4UFGRZc6i3lgGOk9G+73IHZb
	b+FFbSildCrpNrvQqrCl/QK+IISyp7E=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cSGNV4XGnzRkQ6;
	Thu, 18 Sep 2025 21:15:54 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 5F9D9180490;
	Thu, 18 Sep 2025 21:20:32 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Sep 2025 21:20:31 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 1/8] mm: page_alloc: optimize pfn_range_valid_contig()
Date: Thu, 18 Sep 2025 21:19:53 +0800
Message-ID: <20250918132000.1951232-2-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: 8xmxmsw3akmt1q58cifhe71b5jj85pqp
X-Rspam-User: 
X-Rspamd-Queue-Id: 3B9E51A0007
X-Rspamd-Server: rspam04
X-HE-Tag: 1758201636-962408
X-HE-Meta: U2FsdGVkX18Ui+b+vhHeH3S6hW7xjc8zM5CHpA+HJRBHyrp9hBkkLrBdF14mO1h2404aS7q+4finD0O6O9xW3JbeTOclNHxeKsuvOowVuER/1QoLZEAQPce8TMTh/lKL/KeSQtUNLH6mil7AXpjHv0IqjlM2fsoSLM5ZFZkZBapFA4tF3BpR9u8jqisHix2K1kgEhNdzmq/bc9OV7pnKkul0TysC8+hQMsZichAslVodVdIi08RCceiFVV7TEzvFTWp6BlwLT7rLAjQBChTqjB5gGs2D3D0pq99qhA8WY0CUNaDKwDDkoNHwtkBOiYNUB1P1pGGc6d2OTMywqr2wtu2IqXlePVzzpGyMtP/NEWYiM3hAyJdI2TIMIc/S4+s7bH3+Lx18eZNYwcKAkFZfjym53ZJA6+C/2CFoHS7bo0eD4cjDjU+DwbUWaNWH7ckwhybTZyO2kZG3XrzIFZWw7bZ0pT9OAfhJf5/2nHzoQixtR5d/a2oDUF+goYtLk/ZnOoU7Z8H9kFErTGCYbIhtWJ/DOXS66OfZvcZ3bOhrF9Eew9HHNoa5esUXIqY4C9wIVUxSGe8E3QAcOX7Uy2ebwgKM55Y4JGKHWRJ8tPGgCJjiDBbl0La1LJxxLrZpUI0M+/vC7SKfR477BrfAqjh0YG+e1UvR2i/WDjJOFCfUJywNReDqNtjKzRu+VvXg8nRFpbuBD7A/b8fHD/6fqCzjgqBx7KdzPpTCtt0onPvvrc6due0nEo/P44s3BOOIwUgcJpJxH7uHoUwr6yMzB6rFBErooNLUkPemSO/ZNDLpbuRhnS9UXcn74MXEbKMnwR8DoDIvpOs2wfYftNVSbmHuS+QAE5h8XK0OzBFv1bMd1aTxRvo8Oi7Az7oH3bQcPpgvBL8IJ7fVtM9gUVPvxu1jEX39LVj7Y67CYlZhj08wiBj7dAV/1XQqgt4fPFckt4j+Z2pMtJ0wegZoWny26n6
 E5CWXqud
 sMJYa1NN4E7ra5vryhT9vxXKO74XoWBepHnDHOXXLeNE9iai0ede7bGgbCRJePEnQNJoiSLP+5p9mwZszuuw4udr9XrIge+auQ2mgQGx3o7F7rmgTyTKYmumv+9U+6zbWKejP9GC/JEtwYm5klWCvykO7tYsWlDbUFISZabyxM9wu5hcNkkRBtYPe1wV+VQlWuY0ZCmTrMX/qyG906LHP/WEYlxU/v9v4sErVB2EEsM7dRJOPf9g69gttAQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The alloc_contig_pages() spends a lot of time in pfn_range_valid_contig(),
we could check whether the page in this pfn range could be allocated
before alloc_contig_range(), if the page can't be migrated, no further
action is required, and also skip some unnecessary iterations for
compound pages such as THP and non-compound high order buddy, which
save times a lot too. The check is racy, but the only danger is skipping
too much.

A simple test on machine with 116G free memory, allocate 120 * 1G
HugeTLB folios(107 successfully returned),

  time echo 120 > /sys/kernel/mm/hugepages/hugepages-1048576kB/nr_hugepages

Before: 0m2.124s
After:  0m0.602s

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/page_alloc.c | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 478beaf95f84..5b7d705e9710 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7012,6 +7012,7 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 {
 	unsigned long i, end_pfn = start_pfn + nr_pages;
 	struct page *page;
+	struct folio *folio;
 
 	for (i = start_pfn; i < end_pfn; i++) {
 		page = pfn_to_online_page(i);
@@ -7021,11 +7022,26 @@ static bool pfn_range_valid_contig(struct zone *z, unsigned long start_pfn,
 		if (page_zone(page) != z)
 			return false;
 
-		if (PageReserved(page))
+		folio = page_folio(page);
+		if (folio_test_reserved(folio))
 			return false;
 
-		if (PageHuge(page))
+		if (folio_test_hugetlb(folio))
 			return false;
+
+		/* The following type of folios aren't migrated */
+		if (folio_test_pgtable(folio) | folio_test_stack(folio))
+			return false;
+
+		/*
+		 * For compound pages such as THP and non-compound high
+		 * order buddy pages, save potentially a lot of iterations
+		 * if we can skip them at once.
+		 */
+		if (PageCompound(page))
+			i += (1UL << compound_order(page)) - 1;
+		else if (PageBuddy(page))
+			i += (1UL << buddy_order(page)) - 1;
 	}
 	return true;
 }
-- 
2.27.0


