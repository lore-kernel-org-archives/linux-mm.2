Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00779CA0EDC
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 11:06:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2C9E8E001B; Thu, 21 Aug 2025 07:06:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A19498E0003; Thu, 21 Aug 2025 07:06:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E10D8E001B; Thu, 21 Aug 2025 07:06:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 715488E0003
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 07:06:07 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24F4216035E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:07 +0000 (UTC)
X-FDA: 83800485174.02.31EE644
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf04.hostedemail.com (Postfix) with ESMTP id 9AEF540009
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 11:06:03 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755774365; a=rsa-sha256;
	cv=none;
	b=4/AfdWMeKaAhuQUvwbqHwkTbDJR7I+r94c1EtRcmK1Vun5oEjxHm84InaD5e/c45FC1MKv
	K7JqPHpt6UoZllJ+J6NJSWR4p5X/KwP5kntyDgGyw0U3copVMD+fRL5SWsuizUIieIHXoR
	vQAB+HzHVRreWi65wQi+hoGMNYiuX8s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf04.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755774365;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kLyNUNHpK8Pgx06z3Yxye//MlEyw7vKaenXAWX9C2Lw=;
	b=WUqoqkoATZY6/ImsFScXx/1pE6DsXbk8UEVXdXMmAzrpfzk9wupTN6ttV1tDu+I1Bf6id5
	plot2Rg8DicS43Znx21ga36s9HnyGVRszRF1bbNcPtUO1UxHoDOINinUjeRsY10ayHJcGK
	cBls+Lh5mPIEJL6H/DNwZWIprnDcCSE=
Received: from mail.maildlp.com (unknown [172.19.88.163])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c70lx5Dhpz2VRQp;
	Thu, 21 Aug 2025 19:02:53 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 358E218005F;
	Thu, 21 Aug 2025 19:05:44 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Thu, 21 Aug
 2025 19:05:43 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH 02/11] mm/damon/paddr: support addr_unit for access monitoring
Date: Thu, 21 Aug 2025 18:51:50 +0800
Message-ID: <20250821105159.2503894-3-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250821105159.2503894-1-yanquanmin1@huawei.com>
References: <20250821105159.2503894-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 9AEF540009
X-Stat-Signature: 66i5zmc454fxu56qqhkos3iq1hzq68a9
X-HE-Tag: 1755774363-466920
X-HE-Meta: U2FsdGVkX1837Vtr3KgW5yBkOGXewV2fYvB1a/J+HJP2Ma5nxoV+Q9I5fl5K7nI05wg979rFL9gNyfLKISuH32wBeAum7KDN/gT/8mAYZFrJmWfA4ZnTmuDvnMRtmABNgRIiBhV83yBwJE3FE71zuoWlyjjDCv7bfMizkKKfCnUqq0XGxsjCJmWywcvS+vYhB5G+JXS40a8EMAo28LomTEdMvsc6EABIBL31XIdIwoKX7nS9QIfx+7uac2qIJfGXAqpYwqLfTsZR52aWg9qTaSx3qFnNkiVAVhDbnaG/ZqAiIQLTpfT9PEvdnkj4xw498x4I1ZRmWAiFLH5cvpw0A3w1suWrzaLsex7LTLoyEVp19U5tvKWGE0eUzjklONnzAOWXjE8maDn8PzAXQLcsPnWJ8DpDmQB2bnYmhpQK6tQjj7M8ySilugVX6YyLX72u2WWaUzWZBnIZ/Jqio3pRhJwpb6cWCotR/Kim0wnXDpZgmWx2vk6Bm4Jox+VCj7ayAj6dgyh5Q9VKzLNDZkDHgvt3qC8li5DoJNNLqm7JsvSPXCjByijZZijve6/LWe0y6l1uCBBP0ZeducDG2nwStsb32Lvy4fe5z4uv51bCEuSZ7/XHsvoKOVzIi5cwvqTD1M8Nk0dAeQheXvnEbYBKbIJPFZKooF0/zs7J/etxMoDwOuPNwSzEuNKaNFFlSRZaOs0XQSgaE9+smlg8gWgcELFoPadDIbqVQkDCe5XkXueN2DtQx03zSfb9D1efOOLDLf2vc8LR/j8Llz50g0GWxsW6r7+s54oPv0xE19+K2BMW78rd4aLZN9aOQRtm6Ap8iBdN0CO2TtWC3z6RhrQxc8nvIqNzmLxywZSWU2iUuDCpgJqmwzXbUD23dpmC2qSlmcCDkCeJJY1L1mT22GEOna9ZAcnPA2yUAdXoJf2cuVjQ8DIXcIwkNrERyRqXudHVM/1MK3CMhQChQfuB1vM
 z4fkIJpe
 FLKfKe4qtetUfvQysLc7lLDS9hfeGQmIuI3+kBmiLLGZuBuxQlDAjYPZD0SHWjCobGvm+hHfQLtMjH7EFN3QLZzMtvMgc43y4mLhVjNxvwCOr4K3T90OnYf5ZY0a4oya75wpZLsigwUOF7mDFzayB6TcSwdt9T1Xs44GKqD9Nhq/LjBUz9zBrn2h8vHuDDPMBZV//g+sHCv0k01XaCQuHY8pw37gJwysjEufbn/S59qIqEGCG96AOeIA0CAgJpP8JtQ7fvoDVOzq29MamS98INP/7kMF5asDmvnc66iTyvBuyqJs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Add support of addr_unit paramer for access monitoing operations of
paddr.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
---
 mm/damon/paddr.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 0b67d9321460..d497373c2bd2 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -18,7 +18,13 @@
 #include "../internal.h"
 #include "ops-common.h"
 
-static void damon_pa_mkold(unsigned long paddr)
+static phys_addr_t damon_pa_phys_addr(
+		unsigned long addr, unsigned long addr_unit)
+{
+	return (phys_addr_t)addr * addr_unit;
+}
+
+static void damon_pa_mkold(phys_addr_t paddr)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 
@@ -29,11 +35,12 @@ static void damon_pa_mkold(unsigned long paddr)
 	folio_put(folio);
 }
 
-static void __damon_pa_prepare_access_check(struct damon_region *r)
+static void __damon_pa_prepare_access_check(struct damon_region *r,
+		unsigned long addr_unit)
 {
 	r->sampling_addr = damon_rand(r->ar.start, r->ar.end);
 
-	damon_pa_mkold(r->sampling_addr);
+	damon_pa_mkold(damon_pa_phys_addr(r->sampling_addr, addr_unit));
 }
 
 static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
@@ -43,11 +50,11 @@ static void damon_pa_prepare_access_checks(struct damon_ctx *ctx)
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t)
-			__damon_pa_prepare_access_check(r);
+			__damon_pa_prepare_access_check(r, ctx->addr_unit);
 	}
 }
 
-static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
+static bool damon_pa_young(phys_addr_t paddr, unsigned long *folio_sz)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
 	bool accessed;
@@ -62,23 +69,25 @@ static bool damon_pa_young(unsigned long paddr, unsigned long *folio_sz)
 }
 
 static void __damon_pa_check_access(struct damon_region *r,
-		struct damon_attrs *attrs)
+		struct damon_attrs *attrs, unsigned long addr_unit)
 {
-	static unsigned long last_addr;
+	static phys_addr_t last_addr;
 	static unsigned long last_folio_sz = PAGE_SIZE;
 	static bool last_accessed;
+	phys_addr_t sampling_addr = damon_pa_phys_addr(
+			r->sampling_addr, addr_unit);
 
 	/* If the region is in the last checked page, reuse the result */
 	if (ALIGN_DOWN(last_addr, last_folio_sz) ==
-				ALIGN_DOWN(r->sampling_addr, last_folio_sz)) {
+				ALIGN_DOWN(sampling_addr, last_folio_sz)) {
 		damon_update_region_access_rate(r, last_accessed, attrs);
 		return;
 	}
 
-	last_accessed = damon_pa_young(r->sampling_addr, &last_folio_sz);
+	last_accessed = damon_pa_young(sampling_addr, &last_folio_sz);
 	damon_update_region_access_rate(r, last_accessed, attrs);
 
-	last_addr = r->sampling_addr;
+	last_addr = sampling_addr;
 }
 
 static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
@@ -89,7 +98,8 @@ static unsigned int damon_pa_check_accesses(struct damon_ctx *ctx)
 
 	damon_for_each_target(t, ctx) {
 		damon_for_each_region(r, t) {
-			__damon_pa_check_access(r, &ctx->attrs);
+			__damon_pa_check_access(
+					r, &ctx->attrs, ctx->addr_unit);
 			max_nr_accesses = max(r->nr_accesses, max_nr_accesses);
 		}
 	}
-- 
2.43.0


