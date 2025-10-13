Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52D73CCD183
	for <linux-mm@archiver.kernel.org>; Mon, 13 Oct 2025 13:40:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8664C8E004D; Mon, 13 Oct 2025 09:40:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 77D228E004C; Mon, 13 Oct 2025 09:40:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B9378E004D; Mon, 13 Oct 2025 09:40:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 57FE78E004C
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 09:40:44 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2B48816036E
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:40:44 +0000 (UTC)
X-FDA: 83993201208.27.F42B317
Received: from canpmsgout03.his.huawei.com (canpmsgout03.his.huawei.com [113.46.200.218])
	by imf01.hostedemail.com (Postfix) with ESMTP id C997C40006
	for <linux-mm@kvack.org>; Mon, 13 Oct 2025 13:40:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="SyM3q7/K";
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760362842;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LoVOLQNUfID9BQSJIknbuQ7OKuP6d73LjRFC25WXD1g=;
	b=TzdU4qIXjDiu7fYBy/ob0fnwkATZ8N5MRZ7ErVEy37Ck+h+n5AxO2Pf0pMuZ6ZNAsd30VG
	kaRo7JsYvGtPjD/rdwXTvT6SgEJgzSuvdvGZ3NoPDM9iX61uM1FmbarhBvoZFirvSrQvU6
	PAjEGT9EA2FwTn/yF6xJULsg9PB+DAE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=huawei.com header.s=dkim header.b="SyM3q7/K";
	spf=pass (imf01.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 113.46.200.218 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760362842; a=rsa-sha256;
	cv=none;
	b=ArFbAkXJICKcMaRdcX7UcKfPkgRvJpx8NiaV1E0RqZVxLlrLf3y661f33PAshQLPM3pdZp
	DcHiLToOyOs/WuU2HD+Hdstmp0H159Sfw+Un5qZVt035WkTz7TboMXmDLcvxq/9ipGZi9E
	ikQk9JjNyAdnOD6C0mDBImDCLRfNDrc=
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=LoVOLQNUfID9BQSJIknbuQ7OKuP6d73LjRFC25WXD1g=;
	b=SyM3q7/Kfq7UxlV0EZVRV5Uv48JG2GtODn5toTlaoSXNKwQP+YBDrenYnIfRudAFUMiGe6l4a
	TajUbUMs5DXRiOEquSXjA5xXDuXXpJCaaJH+5bjlDkfn+iQ4Ju3RiwQbyeuGkkb+LLVkN2qBJHj
	/KFrcK9s90hTqcjvjeCogT4=
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by canpmsgout03.his.huawei.com (SkyGuard) with ESMTPS id 4cldkT43KhzpSv6;
	Mon, 13 Oct 2025 21:39:45 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 0660914027A;
	Mon, 13 Oct 2025 21:40:37 +0800 (CST)
Received: from localhost.localdomain (10.50.87.83) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 13 Oct 2025 21:40:36 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v3 4/6] mm: cma: add __cma_release()
Date: Mon, 13 Oct 2025 21:38:52 +0800
Message-ID: <20251013133854.2466530-5-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
References: <20251013133854.2466530-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.87.83]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Stat-Signature: hgkptd4x8fmkrac4wogm7az4dgd376wx
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: C997C40006
X-HE-Tag: 1760362841-132612
X-HE-Meta: U2FsdGVkX1/DjA2Kn9kh2vk7b9GMmZ/TkD3M+mJfusJ9tXy0jNveWO6HBPGS2XnQm24aVtjRfVNoejN6vNoa5raQZh+AcOl4UE87yTUujeo5u0lUh0XK9gp0rMxB+0+jGa/2EtOsS5ge9FZ/pr74WAzl1eN86j1iaatxCEb55htcbU12506DJeXYTLeD8HdpGdA+065xWEmn0hA3R4YtUPsaoMAH7oJJ2jp6exMvPIi/lRdhYRcpJREIXdzFzPU6mMdvm50rSvFEUz0FmjSo9e7dVMIPTjElE2/AcA+cUrSWdyTVdSiwggvQ1cky8SZFnb+JL96OzV1zkH2eBNZwuFyhRiTY5E+Zt+B46yb+CyemTMxttuElh9gF4WxqQo5x8IKkqA0JgemkJD5CUgO/1CInURz4HLQZeiojpQ3Oyvaqx2VaKgOsDxNGtOHa8NzVnT9JZHwBWa8eXrcxpefXcV/PViY1aF556L08RC1nSFYEHebm/Ql2wl58fxNSeuduk59CmngV50azXIFcuzSnFl4a6Dijxdmch54UHYX06e61YFY15quraTqy9t469Po5Opjr6qp4hHqt08aKbzqPWr3vv5NXluB9h6qMkUhDXUggXz6ke7/KvoOYYAtt3HYa2cIcZ8RaErzV4Y4n6o7dKVJnjiUw2zC/g5SRVAN7n/Kk0Wm8E++VWPSYLUWWqP3rehhk3QSbXDDaIcGXaf+PjB+uqmNNISR9xvtTrHjY2GKnLzHTq7wxc7fPaFnIQjTtovGWNm8JYjkDovobUx23SYTgRNHKVhKgSSsDkiVaPk3YEuUYTujBdLs9qr3fXfeq9pRJ0bqjzziEbqIz+SbpmIwnlrOsQHehdyrq0AFPEki0xzPQxmeWojPqchqrU0kmdhIMBV9pu8IIFc4Q1Flp+4vAnqTSAcRJA7rW+XH648BMNk+S9wBF55dWXXsy9EmVJvNxAbjQF2uzFV37R+s
 OUrN5vre
 Zqr8WufWaGObg3nek/sNH8y1gTSI0VRaG5QzJgMS4NTCQAOw=
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
index 813e6dc7b095..88016f4aef7f 100644
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
+		pr_debug("%s(no cma range match the page %p)\n",
+			 __func__, (void *)pages);
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


