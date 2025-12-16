Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A77AAD5E136
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 11:49:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F013C6B0005; Tue, 16 Dec 2025 06:49:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E84586B0089; Tue, 16 Dec 2025 06:49:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D830C6B008A; Tue, 16 Dec 2025 06:49:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C73136B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 06:49:39 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 60DF68B00C
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:49:39 +0000 (UTC)
X-FDA: 84225164478.16.A372C95
Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	by imf13.hostedemail.com (Postfix) with ESMTP id E0D332000E
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:49:36 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QH4RBQ5U;
	spf=pass (imf13.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765885777; a=rsa-sha256;
	cv=none;
	b=MUhxz9JinX/6Mhn2t7l/Lv4UcCFucC8Oi+VUYzTOpEwAHqo9Ppf64SbvK3SePBSEyfFJ/e
	a2xmcWPjJc676GBR1ptfGo0j9j5V4KsHk/Z9Wz2fkH0xOP0EQ4OglF+CYqS6EBLKywkusS
	yy2r1PImQdU7kJIlTOnBr8a9DWgk6fI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b=QH4RBQ5U;
	spf=pass (imf13.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.217 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765885777;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SGqtiyTssfwge4G79GqruHZc5o7k5eaTWb9CCbFaKo4=;
	b=1TV4d92qXpq4Ms2X2Ux4UGkEzeon7pCy95xCDrdIj+AQJUC+AhsZ2O3PVPcJuu68SCM9km
	KOh22kUBVYdYVk5a3CEKL0UX7pujS86Y20qjIgc2eQA3optSUC4zS/D1EaOTgzmf/MxRub
	qLarsQvjGOFyGYboRJTAfnOl3G7FUSM=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=SGqtiyTssfwge4G79GqruHZc5o7k5eaTWb9CCbFaKo4=;
	b=QH4RBQ5UwLsA4gX8Sv2K9keRLPBhuRXRPc5Unps/Y85dhXHTu8IrHgZtEncqBwAlxLRs0z4le
	b98ApFDMiWKq6K4ewEWUAukOVW2a6U5CntEsRuQVqni9jB3gFc8hHHkX0jDb2VhyIbzmWLKPfV/
	tA63QlSGQhuJ2+2ugkuIXSg=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4dVwBT6tvYzcb1b;
	Tue, 16 Dec 2025 19:46:41 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id BBB2D180466;
	Tue, 16 Dec 2025 19:49:33 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 16 Dec 2025 19:49:32 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, David Hildenbrand <david@kernel.org>, Kefeng Wang
	<wangkefeng.wang@huawei.com>
Subject: [PATCH v4 3/6] mm: cma: add __cma_release()
Date: Tue, 16 Dec 2025 19:48:41 +0800
Message-ID: <20251216114844.2126250-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
References: <20251216114844.2126250-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspam-User: 
X-Rspamd-Queue-Id: E0D332000E
X-Rspamd-Server: rspam04
X-Stat-Signature: 6g4ucjiexpbjndbe13j9a49cxtuoe9ou
X-HE-Tag: 1765885776-933157
X-HE-Meta: U2FsdGVkX19C3DumHt3KkJvDZKCIWZtddpNUQd1wGHF4v8rs1MMl22Od1r5nZUN+dFB+TIfrvwB2SMO9LraIAi2c4qKA8onfynJiXE+BPSjKw3HS/MLT7Cf3nSD9DfDbqq0g/tEQ8XsJ7tJuYHKdLEkry5ottZrIcBuJj8qpXGuOMNcUG+7v1W2BF1bT6/idhmjkvFXd6kX7ISykHbbJQEMqaXlOlFd0KBx5z67UBdPnSWkziNjtIYzwKF2S+uFt7EOIHE7r6Err7dE4Nf45KO/QYlPKga/9LW5V+sk09Zs2JFd53HEnHtA0oV8GgbDPmqLMIlqgL4l3mQWxeJw6zk/+o8AvagNSbhrjomXD/9NosdB27hq1uzphBWlDmT4yjqeaPityhG1ICbJ1huLsG22p+BhVooM3GH5sFXJrEoRN25LF5mPOJQKLgZj+Gnp5TPLDIhMjv/n3dZ/3/E0+aB6TbYIhz6UtfX4cJnH12LQNDuSCHrcrtb2xQmypHkUe8nwgyj+R3bRPArHkUWb08QpBvXey1Pz0LfdBawAaAZIjq/zZkoclYa4fJumoQmzphksdEEo2YuUBFwmRvSVqBzaXYDCvYtarUVMQAYdzZ88PM3/PPlVe1kZfJnPN55q84WzIGYN1b3IDiLgJ+Oi1Chrv4OaF9cC4QGyZfNIBbPPBkGfXgSD955LAn9XAGHZ5X0turZ+T36LWlkSUzFCLfQ8vJZYRMnliCpecsK048GTmne4ewKHuD2R9hYoiM5V84nohshZCWN5oSEPc1IqJpLJP/93MClu8ZisLQYvuWJ3MyG1vIX+HYb2bbHUj25OhYeluZIxg/WcjZuz1mrv/XwKjVHRggnOFLyNfaWzpfCkfUv9CjxuN6pfshCxtYanR8baNHf17Re6+pV8GbhOnnRl7dnaAkIrcBfqUw17FJHIqoWkcABnANWENCm3QB9+ejlxXNCh7tI4kLDOU/em
 23ZgVsAP
 H7QPKN4yoXXVLmRGBErM7Zr8tmK0rkWyW+qzgViOrTP9pH7k=
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


