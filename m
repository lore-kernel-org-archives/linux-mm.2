Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D40AECA1016
	for <linux-mm@archiver.kernel.org>; Thu, 11 Sep 2025 06:57:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AEC38E0008; Thu, 11 Sep 2025 02:57:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48CD28E0006; Thu, 11 Sep 2025 02:57:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B2AF8E0008; Thu, 11 Sep 2025 02:57:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 085E68E0006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 02:57:12 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id AD55A1A03DC
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:57:11 +0000 (UTC)
X-FDA: 83876062662.29.DC3D823
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf09.hostedemail.com (Postfix) with ESMTP id 384A7140006
	for <linux-mm@kvack.org>; Thu, 11 Sep 2025 06:57:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757573829;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XX0wbfAKhYgJhV1n+dgiBSEabylg1bLmE4V9V3qfaxU=;
	b=K8fREKeDrxHXe/86DoWT5xFsflPkEjuc/tGQivgTV52CMi+aOOWmsBYtdUC0awuf5Jpduz
	f/POx4lU8LK5k6nFxFjRTdc7npXLgKjCMGWbxZciiiJ3z0vRojo3Byzubiat7CSnQWpQhr
	so9NKfMRyze+yAoY1KbpCwIJ3hBuQv8=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf09.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757573829; a=rsa-sha256;
	cv=none;
	b=hyl8clWXqtinN7OZWgFy5T0W9/DAwLMbbBZiqr1L3ZtmFJmZVbrGSw3yTga9zqDmrHEtqo
	PGx9Irq1hWHYIzLV62Ms1bqH1V5443AlGTsm0aR2xoaTlU0DFuJDypNUdUshPsUq7xFlSS
	JdqkYH+Oarvp0FGW7GgJ5CMnqHAGt74=
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4cMpDr6S1Kz2VRdL;
	Thu, 11 Sep 2025 14:53:48 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id EEB7F1A0188;
	Thu, 11 Sep 2025 14:57:05 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 11 Sep 2025 14:57:04 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Matthew Wilcox
	<willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH 3/4] mm: cma: add __cma_release()
Date: Thu, 11 Sep 2025 14:56:58 +0800
Message-ID: <20250911065659.617954-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
References: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
Reply-To: <20250910133958.301467-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 384A7140006
X-Stat-Signature: y99bjzgydotmqkpn5xqx66kia3qt8sxg
X-HE-Tag: 1757573828-763625
X-HE-Meta: U2FsdGVkX1/i4OcRh/bcfXPsHhcu6Irzpi3LQ54fRX29vF7o+hvG+CqCa+7EmlgQxJl3JSmhHsGGd0nLHykA4uXPs5zWCGYdHy2Rn7nALSuRC/uQF7lrxUU3Ey315msOYeXSuR/ATbAV6xBMKdkK8lOiSa/doIMS6niAYxBi0M9ljPY4SJsW18UXgZ8Lx03o2rhCVi7cw4fndaWEYM2E+WO+qYd8xDEpzyQorw7+Ypmk1e9ohn38SGr/nl2ijo3k6swdTu37sm/LaWtIyggjPEAT1U/ZF5PBN5Sx4TvuDfCrQT76IqR78gdNL6PMEy/gnCa9tQSQsoyPxNA/nAwvbFoWW8jjbw84ITQbuDho8RZsPIUK8KQMUKYESvI6Ev5IRjgTQmWJdC6/IEVT/EQ1Ol5qDGHsChT6ffcOAAegHYu584mVnNdgQdOnXP10WwDgpkZj3obCRs6qJ9yBcFfnC+5+HkA6AcsyAqX7hLbsjBOnNNWfn7anKZQzfZ1aRJ/uaEcRrGTBTLuliMODix4dpFikQLQalR1fq9daNFOvf3sA7gX6gMf9tm8CNtQTjJKFmj1ZrnTNKnZUUdROmekDNUIKLUvgrhWhJ6bmUrQkldAYMdkIcHVUXJsHjzOz0WqSwWZL1SgQkOJxAFdbvRJ8OtDag16xOpiOxS6aWc9OzYCyS0SYUb4NoaW+qgR/Jgsaba9Nwrp/mlnZvmScE+SKECDXMV++jo5UfIewEs9NwrSg309lt3otRUXZIhamJA33ri3xiBTG6aisBAyKmVv9ncvIX0uQ+TmYLKC5dw18VrJbTmAy850eznA1S76wKY4AfWAtYG1kJvphn3hpuzjuA1qdfF2WoDhGRZGpFtJNHOh0YRcbBQ9+K6b8t7DG+8iYEUMvvA2TBbmBEKGszwdHVSADGzfvs8JyPqSSJANiucx+oIuT5ZX744VOyFWWrfHGKGsUIp9vbbFbntyDs4Y
 R3WkQKGe
 xj8Mxkpq2GKyZUcgYYDmebuEK+rxebxXm+2Pa4h/K7uSndGuhfYUpOewf0zu8b05qLnVzJdZ2FtFAOaHoy9sEyZalwiRwgIn5GtEnjgH8zQe7XXM8o9sVaaZ95B5Q1FHyPB/vWglAGpeA916SPVvewdo5bgsDquReO3lUwuzonGK4z/pMBbZXEGHAAuxGRRLppwdrQ6JFNv1BY5HF5v+B0JLjxmbm/3Qh3HGC/8D2bfiRIWOsF52yaOVqM/WY8w6X9B6gR/BCylJoq0shozIl0liApCZO1V6mYA8CwOTPmIlWBsfHT2VHo7agnAufdjUC3xgvRk3zph/Z0bDvrX0F5wiXybl5dJXFIsSXacuSjM20WnZA8ZGanivbH4I9z7ByNSy3WUQ/cj1p2NMHG3byMGqnJzTOBy+fyr5IY1yDmxsJKCbjfPM2ya1DqpxwNfWdHGgOGgpFbqsW17M=
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
2.43.0


