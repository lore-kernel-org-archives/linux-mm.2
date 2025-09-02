Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D095CA1009
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:49:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D5CA28E0017; Tue,  2 Sep 2025 08:49:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE4BC8E001D; Tue,  2 Sep 2025 08:49:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B381A8E0017; Tue,  2 Sep 2025 08:49:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8F4558E001D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:49:25 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 555891A013F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:25 +0000 (UTC)
X-FDA: 83844291090.30.962C7CB
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf22.hostedemail.com (Postfix) with ESMTP id EAC7AC0008
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:22 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756817363;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Sbnro22SFv8m5CdBKvPnr8v7Fl7aYhkn+QQTWR1LUiw=;
	b=OOkofC4a+CWOPFn35c0hOZENELg0KQba4ryoUtgW55nAQDibGyP6cdJf9tEtVIuSrXcUih
	BZfzBmCGjuj2orvdwyDp8dEnFUiep2qzGgui4FxbXcljeryXPi+8U47SMqrpQ1hTJTk5tA
	wY5gN0cT0WuU8hF8/9P1ZRRtWaUv7zE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf22.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756817363; a=rsa-sha256;
	cv=none;
	b=cx5D6PMgZBA89KV0NwEyMkwtNNOkuPiKDAoxs2GVmjdidd7MPMb48sXA12HUi3ubMLY2MR
	Il0rsMd8mc8+HeLVXwm866lP6l+MY3eUhj+0kW8FcwuTlXnOQrcRUf7/Ro2JuLY2qX/SfI
	ETLY5PlgRflxeUcJH7BkTrnDD2gE8sg=
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cGQTd0ZfBz24hrd;
	Tue,  2 Sep 2025 20:46:13 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 7EDA71402C1;
	Tue,  2 Sep 2025 20:49:18 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 20:49:17 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 8/9] mm: cma: add __cma_release()
Date: Tue, 2 Sep 2025 20:48:19 +0800
Message-ID: <20250902124820.3081488-9-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EAC7AC0008
X-Stat-Signature: ue3in8ssia9qjjdjjbee9hdadp3pysha
X-Rspam-User: 
X-HE-Tag: 1756817362-93175
X-HE-Meta: U2FsdGVkX1+FDspQsS+WBBmsc9kn4zy298O5mqw4+j6DFLsX1ouTsmjzQUF2Lb6mhRP2VHm2mSvq10qM9TDtIBfAkTpigCTdL4qcrHL/gRvoUueqyrTJF/yPuZhdf3pCHQw+KT4S8C5VmVutVA2N4fTyp3KFmMpkaJlOxkehQPJnrxxFBytXXPTSIScJO2K/VvUpygX1XVw3pUKQ5cU30QeJpoGWjneKcMSTv0fzbXr/lxXDkx6BBSkPo8X6T5MERxWGZKLZ/Vj1Unet6V8Y2bS/OX35GMeNe7WXLFtdza/Mudrn09H9nbOLpqQ4JE3ti1iPkp+7acycX08B/hfTN0I08gNs8XAJIYWfPeZeTGKm5W8cgcYvng+6eLXrrmt4W5m4KWPfP+IrBNeHXJoHsn2OPKBPqx1mGb7aFOn55qvaloa2k8A6xHWL6mjKUYuXoLCXLWzMhg1ffv37debcFUFnes/OJ7thglylv4hFLVNFAS/OGLW0opvQfWhin2SWZFXKVFAiDzV7n6ZSS1BBNbOlKyWplhneBqq+jIddqg622ZuZbezUdR+XLLVEcek7ftyrYnyeTwQNue9CVnjky5Vg4PyC0EAAO1OiaqG8Ez/p1W5PQH/RNpqw+JLGYV4bVtrtXPrXezCAgKYnI6sVfGbXoTHy5p2LTZ9m6OsOCgRjIdm8WqRkcsCgPMtzx7RDunW3saqOvtHOGQsaJyOw23D+ClVLSiDlLh+gudQewtOnhsMEZXVFHhs8bjf1I7KYFD8VcwR93A2PE6P4ctbrC/Cvq8rv+ypEC5EgbdKmkAS8kqCyzHNgAFUVt9hu7PDoNAQu/1WCbi59OOO1s0M7GBrPavYKrMoI4vYIn7SM251rbfBs9gcdjPb/BxNxUIqBjHKtcLfz0O9rV+Say0YLEbVY0+gPavhxVeYcUm4FDSU0fL5AdFWtapk1BDoy6qUUbpsTT0Ho04KekjxUqlg
 7u6nRkR6
 Bf0KU9gXbCG93HTYFRTv/kLtUrqHfcXt2F56prLPiLcp4JeJ54PLyq31Ccvf+ilLX5G76Qjl9wyYoEr4uq4YNtJrW2IdScGaOSvyW82fSom9KZyAVd+n6pejCELqDkK76/kYe9Gp2PpBl/Xxbpy0u3L3ILPe4U8DPekXntYQPl4TzSDK9w0Fb2hShJE2rMwJHXD+ZJNyulSOETqn3EfLYedgtUypSuhKer4/gGgul3/TyZss=
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
index 3f3c96be67f7..b4413e382d5d 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -936,34 +936,36 @@ struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
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
@@ -979,36 +981,7 @@ bool cma_pages_valid(struct cma *cma, const struct page *pages,
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
@@ -1016,7 +989,7 @@ bool cma_free_folio(struct cma *cma, const struct folio *folio)
 	if (WARN_ON(!folio_test_large(folio)))
 		return false;
 
-	return cma_release(cma, &folio->page, folio_nr_pages(folio));
+	return __cma_release(cma, &folio->page, folio_nr_pages(folio));
 }
 
 int cma_for_each_area(int (*it)(struct cma *cma, void *data), void *data)
-- 
2.27.0


