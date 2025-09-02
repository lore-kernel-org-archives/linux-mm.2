Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29E57CA1005
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:49:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F30CD8E001A; Tue,  2 Sep 2025 08:49:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBA118E0017; Tue,  2 Sep 2025 08:49:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE5C18E001A; Tue,  2 Sep 2025 08:49:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id AE7D88E000F
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:49:23 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7F94D140130
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:23 +0000 (UTC)
X-FDA: 83844291006.27.C3C0D6E
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf17.hostedemail.com (Postfix) with ESMTP id F148E4000D
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:49:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756817361;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=q8Wr5MW3DjvTOac13toYDvk5nPJvBRJ8aQnCXO5lot4=;
	b=72T3/A26WmCtOrkS4+bv/fSakJGbkBLzATAzJi3/ZrqKIfnaXY8N5Oey199gttv2hwu5Fj
	CRt6TAVx1kBXD2mIJzGHonXA0tsVg8la2UMFqQSpZI/4JVk3VVG0bCXD33ukcIcTGqewoy
	qEKJNZjMlAsE2FwFLflicFUYKcBH8lE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756817361; a=rsa-sha256;
	cv=none;
	b=RgmsTe5HzPhS1c/e6gwm0BRGOYa4S1/LcN0vyGMYOtWC6pUb4JVR4WXcaWk0nqG8HIKrbj
	JqKbGX3rpaF0/ar4bOuJl+zHK8qzmH34YreT2EwzbGZ9ImXlVOIXrcVho1+I/SKsFTAJrE
	yCNXtSqdTb3WqCBXQTmhISit+3Dweno=
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4cGQTc0tjnz24hrK;
	Tue,  2 Sep 2025 20:46:12 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id 847041A016C;
	Tue,  2 Sep 2025 20:49:17 +0800 (CST)
Received: from localhost.localdomain (10.175.112.125) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 2 Sep 2025 20:49:16 +0800
From: Kefeng Wang <wangkefeng.wang@huawei.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand
	<david@redhat.com>, Oscar Salvador <osalvador@suse.de>, Muchun Song
	<muchun.song@linux.dev>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Zi Yan
	<ziy@nvidia.com>, Vlastimil Babka <vbabka@suse.cz>, Brendan Jackman
	<jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
	<linux-mm@kvack.org>, Kefeng Wang <wangkefeng.wang@huawei.com>
Subject: [PATCH v2 7/9] mm: cma: add alloc flags for __cma_alloc()
Date: Tue, 2 Sep 2025 20:48:18 +0800
Message-ID: <20250902124820.3081488-8-wangkefeng.wang@huawei.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
References: <20250902124820.3081488-1-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.112.125]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: F148E4000D
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 3yosha1ep393gjj31cs3r4s4fczmswp8
X-HE-Tag: 1756817360-517150
X-HE-Meta: U2FsdGVkX1/H90pNqNxBqbuPujqBJO+QSAXoU4ViWTrFZ6/iw3d/45JpGRuoFyLO8Pdv/UGS5wqSHCRJrUTKgsk7aoNGCrVCR4gfTFKTJJ1f/9nfd+cNRI6RXSFbDFoeY9Gt6Lt0H/Bh4ozw+c7Yw1U26IKCJyOjwDV/Z1ymHaNsLDmB3+MS6EI9zILH82XrFG4SrNmhzhxe1EGXGwYquem/q5U0Xx+ScvT56lkfIBqdYZXwUvil+9FACrOuTilIpBMnT8aIEEExmxNegdK76uc58gyL89RQ7G6VsyxXMNPm9aBvvF+Ns22c6fq7dngkKtqdKhRO6hYzyB3zac3ALcHPIFRO1zg7xKgAUvLO59epjQRRv/HZrXcNM/MU/W1tvMoETMG4v91kKhnm7u1rUo8i/yEbb3BC5KWc0j0TbgB/OLQK6Je25Icz6R7nWaIDlOculMZ97Fbd+ekvslvzBDfSyEPDPIybZbgB6A9faUIOkNTsiuPvOSklq77dFys4pQYk6i72dRPp3P3Pp/WXAzF1dt+07B01gJnZcg14jQ3J3Dp1naNDD/KaUOz7RXU56yRBoY/F4cbigNrZDxwNgKU5eQ8DiqdV+BB+CXmiCqrHAiBX52T0A0A6Cmf5h862mio4UNDErTv6w8n98TrCA2mFhtNYzSS5v0FVIo4MP3rAIFVG1y44GEo0VU+WJNG5xi5g5TV3d0tEF1wld3XqG+GppQ2SFKt79quL/DqkQ6qLdbuKDsHJ7VN7sLxYBiCx/6eEGVjAWij5a610HrH+FWsIY/TKeepd9Qu/qkLdk4bqxHEDbZjyxSptx2nJ6re17oYJjhdtrd0hmaod9Z4HtckGTLqTGsAgG/zwDznsU1U+urOlSQ/e61UUD0V0Oe0Aztfr9e0C0nrkrOs8z1U/JOKRQNd1GRYJzGvBx2btN/hz2gH10H7VR30q6IS23uVKXhv6TK5sbFjFhMEHEHM
 7R37vW0h
 2PGfFOAPZ9FO1hzecLpXTij6vtMxHwIRx3kzurk2uFZWKxaHyPKAoBUBQozBA1Pfzjlgu+pmVsUWPQ6DUVE6sgBVO135Ae4GNlJMxETxfXCF+PJsCAEq6OzQeFFi9hoI/GDlWaGxqJmqKmQYo0XGt+zzKkqAobxckIcvj7235gAotibmW3HMS78wnbot8nQeY2YaqGEmLQc3oLjNUT4+SErjDRu0/uqELKDkQ9kEbLKrONEw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In order to support frozen page allocation in the following
changes, adding the alloc flags for __cma_alloc().

Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
---
 mm/cma.c | 15 +++++++++------
 1 file changed, 9 insertions(+), 6 deletions(-)

diff --git a/mm/cma.c b/mm/cma.c
index e56ec64d0567..3f3c96be67f7 100644
--- a/mm/cma.c
+++ b/mm/cma.c
@@ -778,7 +778,8 @@ static void cma_debug_show_areas(struct cma *cma)
 
 static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 				unsigned long count, unsigned int align,
-				struct page **pagep, gfp_t gfp)
+				struct page **pagep, gfp_t gfp,
+				acr_flags_t alloc_flags)
 {
 	unsigned long mask, offset;
 	unsigned long pfn = -1;
@@ -823,7 +824,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 
 		pfn = cmr->base_pfn + (bitmap_no << cma->order_per_bit);
 		mutex_lock(&cma->alloc_mutex);
-		ret = alloc_contig_range(pfn, pfn + count, ACR_FLAGS_CMA, gfp);
+		ret = alloc_contig_range(pfn, pfn + count, alloc_flags, gfp);
 		mutex_unlock(&cma->alloc_mutex);
 		if (ret == 0) {
 			page = pfn_to_page(pfn);
@@ -848,7 +849,7 @@ static int cma_range_alloc(struct cma *cma, struct cma_memrange *cmr,
 }
 
 static struct page *__cma_alloc(struct cma *cma, unsigned long count,
-		       unsigned int align, gfp_t gfp)
+		       unsigned int align, gfp_t gfp, acr_flags_t alloc_flags)
 {
 	struct page *page = NULL;
 	int ret = -ENOMEM, r;
@@ -870,7 +871,7 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 		page = NULL;
 
 		ret = cma_range_alloc(cma, &cma->ranges[r], count, align,
-				       &page, gfp);
+				       &page, gfp, alloc_flags);
 		if (ret != -EBUSY || page)
 			break;
 	}
@@ -918,7 +919,9 @@ static struct page *__cma_alloc(struct cma *cma, unsigned long count,
 struct page *cma_alloc(struct cma *cma, unsigned long count,
 		       unsigned int align, bool no_warn)
 {
-	return __cma_alloc(cma, count, align, GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0));
+	return __cma_alloc(cma, count, align,
+			   GFP_KERNEL | (no_warn ? __GFP_NOWARN : 0),
+			   ACR_FLAGS_CMA);
 }
 
 struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
@@ -928,7 +931,7 @@ struct folio *cma_alloc_folio(struct cma *cma, int order, gfp_t gfp)
 	if (WARN_ON(!order || !(gfp & __GFP_COMP)))
 		return NULL;
 
-	page = __cma_alloc(cma, 1 << order, order, gfp);
+	page = __cma_alloc(cma, 1 << order, order, gfp, ACR_FLAGS_CMA);
 
 	return page ? page_folio(page) : NULL;
 }
-- 
2.27.0


