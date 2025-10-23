Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7651ECCD1BE
	for <linux-mm@archiver.kernel.org>; Thu, 23 Oct 2025 12:00:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0949C8E001B; Thu, 23 Oct 2025 07:59:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D9F8E0010; Thu, 23 Oct 2025 07:59:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D16148E001A; Thu, 23 Oct 2025 07:59:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9432C8E0011
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 07:59:57 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 4EF761DDB91
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:59:57 +0000 (UTC)
X-FDA: 84029235234.28.675D690
Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	by imf10.hostedemail.com (Postfix) with ESMTP id 91FD9C0009
	for <linux-mm@kvack.org>; Thu, 23 Oct 2025 11:59:54 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761220795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=SGqtiyTssfwge4G79GqruHZc5o7k5eaTWb9CCbFaKo4=;
	b=i9tJyA3NPbyHGxDvX/mizKUcwmTWXlCwTYKuDZqaQGezdwUZcvkziKnZem1oFL149I8PHG
	uRKOogWpCSlo3sToqeU4TPv5ZYgvb58/A/7I7nCoVojXvw/X774zo013sCIYHzQWCIfggu
	RmHVXbTjEQF/m3c4tFUVJauSATpAnyM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	spf=pass (imf10.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.187 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761220795; a=rsa-sha256;
	cv=none;
	b=NKQLa5vnNY2RKAdUosMuXScX/D4wRE8WMdkdphGJDu8rkpvY1uIRCsZalpZsQpK0YKsd2S
	oOKYFyD8vg1BDEfebVXY3bjZIHaF4vlD7b4fPfZAB+AvCH/0HdIO94HsxngJ9yTHdLD7dW
	tpQvNW3ewLeWcHJrumJQCFhG/bb8SaU=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4csl1y2f1TzvX0w;
	Thu, 23 Oct 2025 19:59:18 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 344E518006C;
	Thu, 23 Oct 2025 19:59:51 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 23 Oct 2025 19:59:50 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v4 3/6] mm: cma: add __cma_release()
Date: Thu, 23 Oct 2025 19:59:37 +0800
Message-ID: <20251023115940.3573158-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
References: <20251023115940.3573158-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 91FD9C0009
X-Stat-Signature: 511pcxmn6ktbyq167x7znryaeon35gg1
X-Rspam-User: 
X-HE-Tag: 1761220794-511203
X-HE-Meta: U2FsdGVkX18xpUqJacxIkkPK29D+/X/TnqJnUPJlqRuJhdNByOWRf+zYSgTJ3Vh0dpmgDOuqCoxibNOnhsnqbf56gffx9wKN4KvDijLtE9YT0Vot0iHPGN5oynN0S6qCoyda/qybJ7fmlaaFghz+G7o5/tsIyXyUGPgR1cRsbR9eOpY+loW0M5q4QUjUN8Qi7GSUljV6lznuoPFjbgp7CtTLgeP2yT2cJuFYzv2BaNjs2OpqvB0VzSap3L4IppmTCK9ECXMgBzUeU4LncJA/HvZb4PMHGp0rihkVQ3G8XadCWuLNASv6sZ2Spzjts8AwgV+JBsIgfpPpY0bTJaen+1WzEnI6WZuifQPSsOjwy8HU9jy/xW8aUrfABXwVz1bTRIjL56eGonH4tWi7Kw1gPQH6ndw14edoRcZJabGmuIxjND9evVCRwlNyOodvZsXZZuoe05nYraPmiuW5dXA4gwGf5+p8Y+btglZMU5C2Qzn8XzA6q3cRtldQgBWVd3ZQKdNuAkazIcd4kvh1cDkJckfTIXma1Oz04aYtpHvhK3VzhOYDbPYmtAQuLidlT8V+8p90lqZaZU4+ovBSY/9ptKn5CPilvQlamFReH695jEcVTgaJhwDWAsmLwlOrANUMY6ropfqjoVN5Ed19D6F8dSFEoLGjrGfGWbFcIwk5M4CToI6uc8ReR6H7gzmsdUZxL3NfUYYvLk0JH1iLv9lneM4Gj2d3qiU/7jlx43NW7fI8GTL3GY9vvnyMWogvIpRFG4VqKFk05Ahb7SSINmKGs4IvFES9CjVsz3HYmcM+jtcGpSshn1Pp5W2xuk6LVY6gCs6vTrr4PXz4ig2AYn65dTVy1vn9iUAS+SAsSt7O2ChckaTGqpLmg3QEg7HKV83makDXFxuoadpl8QzNJlZL3mk3zctzpB8q2/b4SBMrzkAPoXSH0X1aSUzc8S+lhxuPSmu6ztly2cLHQx3XcBO
 wwqJbA+R
 lfjQj8+XLWzOVTGsBKPpST5KI/o325wZ77p49QGHnZEISCdIfzN5Z28J6IOtw2tOOjHIGEqX/UawYSCFiXQjoXPVR1SBWjGpct8JVHRT1Vd3G9W01DuJB3VL2h2AhL+9ez1f4Dpp9UyqVZ3O26ITr3oCZDU6cFQBeBhJs6REBqs0rUtqalPQuykvEPuRvVfjjAHhEtszQCeGTUdtiGM0aVRz6lrZJZBwPZgWkQBKXHKw4ft512qm/jketpWh3lXCtEhU/qJbZcKJGr/qzfInIrtrduZ5WLxZaKhwk
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
Acked-by: David Hildenbrand <david@redhat.com>
Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 include/linux/cma.h |  1 -
 mm/cma.c            | 62 +++++++++++++++------------------------------
 2 files changed, 21 insertions(+), 42 deletions(-)

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
index 813e6dc7b095..6df44541933a 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -942,34 +942,43 @@ struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
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
 		if (pfn >= cmr->base_pfn && pfn < end) {
-			ret = pfn + count <= end;
-			break;
+			if (pfn + count <= end)
+				break;
+
+			VM_WARN_ON_ONCE(1);
 		}
 	}
 
-	if (!ret)
-		pr_debug("%s(page %p, count %lu)\n",
-				__func__, (void *)pages, count);
+	if (r == cma->nranges) {
+		pr_debug("%s(page %p, count %lu, no cma range matches the page range)\n",
+			 __func__, (void *)pages, count);
+		return false;
+	}
 
-	return ret;
+	free_contig_range(pfn, count);
+	cma_clear_bitmap(cma, cmr, pfn, count);
+	cma_sysfs_account_release_pages(cma, count);
+	trace_cma_release(cma->name, pfn, pages, count);
+
+	return true;
 }
 
 /**
@@ -985,36 +994,7 @@ bool cma_pages_valid(struct cma *cma, const struct page *pages,
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
@@ -1022,7 +1002,7 @@ bool cma_free_folio(struct cma *cma, const struct folio *folio)
 	if (WARN_ON(!folio_test_large(folio)))
 		return false;
 
-	return cma_release(cma, &folio->page, folio_nr_pages(folio));
+	return __cma_release(cma, &folio->page, folio_nr_pages(folio));
 }
 
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
-- 
2.27.0


