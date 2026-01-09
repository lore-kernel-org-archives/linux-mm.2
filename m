Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C3167D167E9
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 09:32:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CE256B008A; Fri,  9 Jan 2026 04:32:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 270146B008C; Fri,  9 Jan 2026 04:32:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 080696B0096; Fri,  9 Jan 2026 04:32:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DC16F6B008A
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:32:00 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 805AC1AB56F
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:32:00 +0000 (UTC)
X-FDA: 84311908800.12.1E7C3A4
Received: from canpmsgout11.his.huawei.com (canpmsgout11.his.huawei.com [113.46.200.226])
	by imf27.hostedemail.com (Postfix) with ESMTP id 081D640004
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 09:31:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="y9EKT//z";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767951118; a=rsa-sha256;
	cv=none;
	b=27nrdSt6RoXhRLsTgVGInaMtUfYXkHyhSvSyltZjhJKkR0GqIE1NYi/00mUzk3MD1ZUJ3J
	lHVW2uj5vkvz6E/cERqkWzNUr6QCT82eiEw0C8fqUlUA26MRBA+WSqXcsCD/8zEXNOIBdP
	UW1CnO9WpBgOquawsOyYe5FdbXtQGr0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="y9EKT//z";
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.226 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767951118;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=y7EVPQEBKSRZMRRlMzWlmgWzFSCz0HCbPGnBlFaEuVs=;
	b=KdgzuBo7Vidj2jMHTVllFhzbqgOk5nnzPWRTDHJE6lSMQKB5zU4j0HdN8VB5DymFPH96TD
	hjYnlJA9utoQgy1L/Lv64bjUn0SdoT9gsMGrwzdnVXgqf6CtVVKRBAmJ6xnFibYE2Los5f
	jDR4tt7+2qjm/mWtePWC0+VCNvxVP7c=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=y7EVPQEBKSRZMRRlMzWlmgWzFSCz0HCbPGnBlFaEuVs=;
	b=y9EKT//zqf+sUuAGD0O/ESeVm4/cnS4A32Gk5Tw9qoG4PSzMhwU+yJRwmNrEQBY0gQUxvWplg
	yxvMAO8gp+UD+FPjPjJHexO78Ui1VMI9PpZlh/j+nZryTzbfQd5TzyBOB2U39Ycm/XZ7UuhC/EM
	humorhiH3wc4Nfwl0/whB+U=
Received: from mail.maildlp.com (unknown [172.19.162.92])
	by canpmsgout11.his.huawei.com (SkyGuard) with ESMTPS id 4dnc050q5KzKm6J;
	Fri,  9 Jan 2026 17:28:37 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 6319B40565;
	Fri,  9 Jan 2026 17:31:54 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 9 Jan 2026 17:31:53 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>, <linux-mm@kvack.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Matthew Wilcox
	<willy@infradead.org>, <broonie@kernel.org>, Claudiu Beznea
	<claudiu.beznea.uj@bp.renesas.com>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v6 3/6] mm: cma: kill cma_pages_valid()
Date: Fri, 9 Jan 2026 17:31:33 +0800
Message-ID: <20260109093136.1491549-4-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20260109093136.1491549-1-wangkefeng.wang@huawei.com>
References: <20260109093136.1491549-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 081D640004
X-Rspamd-Server: rspam06
X-Stat-Signature: zfq1m6kz7ctx11dcygekb9q4j6ef97s7
X-Rspam-User: 
X-HE-Tag: 1767951117-499504
X-HE-Meta: U2FsdGVkX1/UPr9fzHlFBlutbQKAI9AuQgFCzKsGzMEwDQaIaFd/D1XZHTwIm2uHODoads5RA41EcAEMlSSBwpbuexyr0SAXUsqqgj1Z2J80TTxr3xMgzeejB4lCvnnGz5iV7Qv1ocZaCekSLdm2USc/yFGVvSSJkF8cgYf4lVgy5xvXWlZaO/0tojE8qx6snC1W288TE9CJdOMLKob0WZeiSfgGR7stqqR43rM9g0FAuyMw8JwNmGASA3KOw/SVFqsinsCvqfjDN6drdu2MSzbg3/XJM3fZ+ggUXuCm+ZxYKJuecX2CXVEH6n4Y5/7iSfYUJJBHLGRok/ZocSRWAosCecEXNsSNWSopx43sktlWKoCvQyc2oJ1br6jGjS3xw3kx/9YjE3AHbre13V5n/68mpv3Q5MBIbItzcbcec2oiGRgz45JqONvsWZPEbwiNVYvMgOIFwDSqXGLLzRKfnKx97m6fdh+E8GAADEBqZIEpALx6HBv04AId49h+jI+6A4x2uK2bDWnuKya0kNy0tNqeYJiyWM4VepXgvMCM/Mvj/WijTpIgm3E9jfukhIwIxgOQlHqOjdv/0pESmwa/e6hzjmuTmjwKSLzVTWrs2hsIA9jgNXWpVCmeFZH5cKvS9l5aSqgdywOTeKsXLwUBaf6bCvaXZvdtNv59ALh34MrLBTFBLdbU8xejyOHuI8SCZRRlIvc95jo5elhzORN+XfXDdCTeeoIVKt8JsRmzQhPl689d42xhp1pPGwWH4BXSOodlWWZ3PT8F1M9oqBYi7393Agd8M/yBJpUad+5C7nvq9gq873/j1bwSSvwSDq3TtfdgRDNwwPkENyppst3EqJ47GAEXt9iCBPOEz3itQSkieYV+Fxd8nyfOcYgjHr3iC+N2cI0/NkPDMxAbfemn0MSv8+ZHgx87FW48mKC/2WNLFW6Qxo3b4asf7jXPlx6IR09rrzimXQzmo9lgoXJ
 ncO7szHB
 NoueJjDFG88dNbIxTfWwT0hlhrJfzBSJLl8tdu2t38NqLn12giHc8PpJe2eO4zYLrqL7D/jSRB2g1BVjbBbgLiaBuWVzYHnlXK6ADC1qPlvjL3jH/FkJF6/Q/MSLyR/bCiCl6W/gy6H0HlowMBvoLKxxVbNRK7FmSAH3t/dQZ5KhUzX4JRzc+StlZyBV2BSzwe67Ki58+5O6X6wyAmI+8wj0tcuom728uJGQa4zdu5TyaygxrWS7Tl3kFg5vufrU9kfM8zPe8MuQAFGq4dtyCvMO0Rifj+8P1+xeJQVNKy7GNUmHkRWwh6KeJ2TLRAXn+pDqE8ipW3hvngTncLQGOWXB/V5qXVlw5m6uwJatcgO0Lj226j/1D9/x4aztGX7P/yjKLLyjZucWSfEnnEZhDcCfCh3jNtg6dL/jdu1UGK4+Rk9RAWWDEW7mqZ6SWgc/JcYXyYHXE4QkeljX1mp+lKs1hzs+rRUxQAOjjHTeNESmyBPlUgtEgA5p/Sdxc06LF09Ge9UjICoKtl8MBcro1kaR1gk29lrc2TfqMKMZvMnP7BrL29uzRjuyHCjwgH5PpnB81IhSwr0qkZU0WTkpqgtq5BeJbao2dmWeVc3NxS+dclNk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Kill cma_pages_valid() which only used in cma_release(), also cleanup code
duplication between cma pages valid checking and cma memrange finding.

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Muchun Song <muchun.song@linux.dev>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Brendan Jackman <jackmanb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: Vlastimil Babka <vbabka@suse.cz>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---
 include/linux/cma.h |  1 -
 mm/cma.c            | 48 +++++++++++----------------------------------
 2 files changed, 11 insertions(+), 38 deletions(-)

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
index 813e6dc7b095..fe3a9eaac4e5 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -942,36 +942,6 @@ struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
 	return page ? page_folio(page) : NULL;
 }
 
-bool cma_pages_valid(struct cma *cma, const struct page *pages,
-		     unsigned long count)
-{
-	unsigned long pfn, end;
-	int r;
-	struct cma_memrange *cmr;
-	bool ret;
-
-	if (!cma || !pages || count > cma->count)
-		return false;
-
-	pfn = page_to_pfn(pages);
-	ret = false;
-
-	for (r = 0; r < cma->nranges; r++) {
-		cmr = &cma->ranges[r];
-		end = cmr->base_pfn + cmr->count;
-		if (pfn >= cmr->base_pfn && pfn < end) {
-			ret = pfn + count <= end;
-			break;
-		}
-	}
-
-	if (!ret)
-		pr_debug("%s(page %p, count %lu)\n",
-				__func__, (void *)pages, count);
-
-	return ret;
-}
-
 /**
  * cma_release() - release allocated pages
  * @cma:   Contiguous memory region for which the allocation is performed.
@@ -991,23 +961,27 @@ bool cma_release(struct cma *cma, const struct page *pages,
 
 	pr_debug("%s(page %p, count %lu)\n", __func__, (void *)pages, count);
 
-	if (!cma_pages_valid(cma, pages, count))
+	if (!cma || !pages || count > cma->count)
 		return false;
 
 	pfn = page_to_pfn(pages);
-	end_pfn = pfn + count;
 
 	for (r = 0; r < cma->nranges; r++) {
 		cmr = &cma->ranges[r];
-		if (pfn >= cmr->base_pfn &&
-		    pfn < (cmr->base_pfn + cmr->count)) {
-			VM_BUG_ON(end_pfn > cmr->base_pfn + cmr->count);
-			break;
+		end_pfn = cmr->base_pfn + cmr->count;
+		if (pfn >= cmr->base_pfn && pfn < end_pfn) {
+			if (pfn + count <= end_pfn)
+				break;
+
+			VM_WARN_ON_ONCE(1);
 		}
 	}
 
-	if (r == cma->nranges)
+	if (r == cma->nranges) {
+		pr_debug("%s(page %p, count %lu, no cma range matches the page range)\n",
+			 __func__, (void *)pages, count);
 		return false;
+	}
 
 	free_contig_range(pfn, count);
 	cma_clear_bitmap(cma, cmr, pfn, count);
-- 
2.27.0


