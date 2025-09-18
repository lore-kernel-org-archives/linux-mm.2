Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D0B5CAC5A7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A44168E0113; Thu, 18 Sep 2025 09:20:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9F5A28E0112; Thu, 18 Sep 2025 09:20:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86E578E0113; Thu, 18 Sep 2025 09:20:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 67DAB8E010E
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:20:44 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1E30184D9D
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:44 +0000 (UTC)
X-FDA: 83902430808.12.9D27D30
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf27.hostedemail.com (Postfix) with ESMTP id 3EE474000C
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:20:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758201642;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rZkjeIHEZTzJsGoFQz4ePh0aS3316Hr08aI3QDHYbrI=;
	b=e8FaHhnHiZSdVFbd/uNiE/QU5ir4/urZorH0B/mEdzmMcASCTuIVE90nsDFK5MWclBd6IC
	HJsy8lC33qPY/of67pkvmU+xa6nE1Scchk1kpE5ISFca4yHgpfEhagygb4sEpShJuyhaej
	Jul9dbd+E4iPYDPozKxmXlyMvu/fvAE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758201642; a=rsa-sha256;
	cv=none;
	b=T4gZyCnaS167AsbItdw2jTRbBFASOAGiSRGFccFLdrHGRCFw00rFXlS+srGaFdrUpctbzC
	91Xq2+SeqKiynmkt5xhnvBnB1CzwyzERuo7T2f/wWO1m0ofsrOBU6ezw/odDD1o7Amg9GO
	YHbQ2BayOQKW8J0gXBA4WFsHhjcfLXs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cSGPz3M57z2VRyD;
	Thu, 18 Sep 2025 21:17:11 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id D52BB1A0188;
	Thu, 18 Sep 2025 21:20:37 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 18 Sep 2025 21:20:36 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v2 6/8] mm: cma: add __cma_release()
Date: Thu, 18 Sep 2025 21:19:58 +0800
Message-ID: <20250918132000.1951232-7-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
References: <20250918132000.1951232-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems100001.china.huawei.com (7.221.188.238) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3EE474000C
X-Stat-Signature: wx7fm7erf54nh68n8t3r8hi8jdtwb3eb
X-Rspam-User: 
X-HE-Tag: 1758201640-575373
X-HE-Meta: U2FsdGVkX19zwxDkEOgHKQ3PpQh61P4RZPY+sOwrBTpVqLBV43W1tBHgNonoenAe6eeqN5Agv4Zi6rghMIAfT1jhiR4bxjG1dd3THE61MkNxivPZJ8kiZ5xsbRdCn9KHfLJrKK1+JswJA91GFmSmivdLutw7nsump6jruZiJGptjAz58iEEoUdvAa2nReK/RHJc6rEz07ZT4ZT/9CA57sdftdLuVu1dTFkKkotrMzDT1hqLxD1AE2p1LFFonFNdIHxOdEU0A0YtCD93hdfFe/2Vb8DUrV7Nb6B6C2Zq5LE7zaqghStpf44PKMCTinuFY3XiCeGlvgNVJaqYjx0COjz4wUbluD/AmlXUQUj8l8VtGROi7AzRndIB1owPJxo/twsUzvGXaUKOCGi2Puc6yDaknKyeOdyRR3o90+N+PWOW1iPz0YRoKcY5seCcg8bcHZKlaiNjMrplN+b/Gq4PL2LDpCIlZUxk74U54ulyWOghQkdeuU2dAj+JanpIYcD3ti6g1jSRCirB+yZFyOvFeVcDRuZw5zOsXmWuIRCjvBYyyEiYhxNAC4GFCPbwYj2xYj93WIpEXDfkaJO5ZxrnZbIlsInkOLrmdl7PmI/pIjR73oMIhlvGqpeKOiteQdQp8xKdaAneb6FuFlJvIrWquOwDUd8/eWfyVQMVMAaBDIzXqeyqtsXf4W5AsUPGQYFQkpRr/IQam1Jq4+graE9Lm2qe4MVPDqJv9IJqyQZUSYFdY/g+H/Pw/ltXE40ZvTsSu+cJ5rUa8bBnIF67cZnDYJIUGsrZw/NqQD96h8u0A7aoqhUxaSr1qv2Ybyx2skGMnL1U6IqEJ3SXScQ0r/D9VhDECtnHA7X8dC3HFAokbIhjhBk6eI5ejpwRSYJOVoXY2Jvq96Fqw8yUU3WLOSpwAO16g47KU4xMXB8FemKr3H1JZy7VtBkwQNmdAAdOPv9cb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kill cma_pages_valid() which only used in cma_release(), also
cleanup code duplication between cma pages valid checking and
cma memrange finding, add __cma_release() helper to prepare for
the upcoming frozen page release.

Reviewed-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/cma.h |  1 -
 mm/cma.c            | 57 ++++++++++++---------------------------------
 2 files changed, 15 insertions(+), 43 deletions(-)

diff --git a/include/linux/cma.h b/include/linux/cma.h
index 62d9c1cf6326..e5745d2aec55 100644
--- a/include/linux/cma.h
+++ b/include/linux/cma.h
@@ -49,7 +49,6 @@ extern int cma_init_reserved_mem(phys_addr_t base, phys_addr_t size,
 					struct cma **res_cma);
 extern struct page *cma_alloc(struct cma *cma, unsigned long count, unsigned int align,
 			      bool no_warn);
-extern bool cma_pages_valid(struct cma *cma, const struct page *pages, unsigned long count);
 extern bool cma_release(struct cma *cma, const struct page *pages, unsigned long count);
 
 extern int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data);
diff --git a/mm/cma.c b/mm/cma.c
index 813e6dc7b095..2af8c5bc58dd 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -942,34 +942,36 @@ struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
 	return page ? page_folio(page) : NULL;
 }
 
-bool cma_pages_valid(struct cma *cma, const struct page *pages,
-		     unsigned long count)
+static bool __cma_release(struct cma *cma, const struct page *pages,
+			  unsigned long count)
 {
 	unsigned long pfn, end;
 	int r;
 	struct cma_memrange *cmr;
-	bool ret;
+
+	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
 
 	if (!cma || !pages || count > cma->count)
 		return false;
 
 	pfn = page_to_pfn(pages);
-	ret = false;
 
 	for (r = 0; r < cma->nranges; r++) {
 		cmr = &cma->ranges[r];
 		end = cmr->base_pfn + cmr->count;
-		if (pfn >= cmr->base_pfn && pfn < end) {
-			ret = pfn + count <= end;
+		if (pfn >= cmr->base_pfn && pfn < end && pfn + count <= end)
 			break;
-		}
 	}
 
-	if (!ret)
-		pr_debug("%s(page %p, count %lu)\n",
-				__func__, (void *)pages, count);
+	if (r == cma->nranges)
+		return false;
 
-	return ret;
+	free_contig_range(pfn, count);
+	cma_clear_bitmap(cma, cmr, pfn, count);
+	cma_sysfs_account_release_pages(cma, count);
+	trace_cma_release(cma->name, pfn, pages, count);
+
+	return true;
 }
 
 /**
@@ -985,36 +987,7 @@ bool cma_pages_valid(struct cma *cma, const struct page *pages,
 bool cma_release(struct cma *cma, const struct page *pages,
 		 unsigned long count)
 {
-	struct cma_memrange *cmr;
-	unsigned long pfn, end_pfn;
-	int r;
-
-	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
-
-	if (!cma_pages_valid(cma, pages, count))
-		return false;
-
-	pfn = page_to_pfn(pages);
-	end_pfn = pfn + count;
-
-	for (r = 0; r < cma->nranges; r++) {
-		cmr = &cma->ranges[r];
-		if (pfn >= cmr->base_pfn &&
-		    pfn < (cmr->base_pfn + cmr->count)) {
-			VM_BUG_ON(end_pfn > cmr->base_pfn + cmr->count);
-			break;
-		}
-	}
-
-	if (r == cma->nranges)
-		return false;
-
-	free_contig_range(pfn, count);
-	cma_clear_bitmap(cma, cmr, pfn, count);
-	cma_sysfs_account_release_pages(cma, count);
-	trace_cma_release(cma->name, pfn, pages, count);
-
-	return true;
+	return __cma_release(cma, pages, count);
 }
 
 bool cma_free_folio(struct cma *cma, const struct folio *folio)
@@ -1022,7 +995,7 @@ bool cma_free_folio(struct cma *cma, const struct folio *folio)
 	if (WARN_ON(!folio_test_large(folio)))
 		return false;
 
-	return cma_release(cma, &folio->page, folio_nr_pages(folio));
+	return __cma_release(cma, &folio->page, folio_nr_pages(folio));
 }
 
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
-- 
2.27.0


