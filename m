Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05AA5C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:52:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B189A8E01A6; Tue, 12 Aug 2025 23:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF05C8E01A4; Tue, 12 Aug 2025 23:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DED38E01A9; Tue, 12 Aug 2025 23:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 7BC428E01A4
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:37 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 436AB116056
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:37 +0000 (UTC)
X-FDA: 83770362354.23.526E25E
Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	by imf13.hostedemail.com (Postfix) with ESMTP id D061D20002
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:34 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057155; a=rsa-sha256;
	cv=none;
	b=T6PpYF2iRu4NsHfQ1T3Td4LSbuMZqZhR9YycFi1h43oOnYULDn47+cMhLWGoDuyqS5I2d+
	HCVNsULcPgopauUC5WVjE9NW0B+DyQu1o2qYpuexSmeIR5BP6uFjvj1yzGGbm0teKIXJ/2
	FElwQzZLGl0r3poqpuwyL0dAlgFovds=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf13.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.190 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tBt2Na5M5ryD1bUX8J50jnRaE9caDMpDGJDb0tfW8QA=;
	b=ZkmgDHuQldh2Q9/NMxRJbHhYj7Dokdfr1hVJvSEGu1NF4dD8PBr4yqVA43wdvBGcdQG5JL
	ViPdh2yBybpxgHMhBlHJAnQIEUCJNAzQcRkkHabmIAj+U4cfdJwF8qfA/SRDyuBD2bYC4E
	ZtvDutS1z54uaZtEU9TfRz06oPEh1CY=
Received: from mail.maildlp.com (unknown [172.19.163.44])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4c1vV44ktFz2Cg50;
	Wed, 13 Aug 2025 11:48:12 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 2CEFD140109;
	Wed, 13 Aug 2025 11:52:32 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:31 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 04/16] mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
Date: Wed, 13 Aug 2025 13:06:54 +0800
Message-ID: <20250813050706.1564229-5-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Stat-Signature: e1i7wexw143op96nb3idxndsmpgq876e
X-Rspam-User: 
X-Rspamd-Queue-Id: D061D20002
X-Rspamd-Server: rspam02
X-HE-Tag: 1755057154-94938
X-HE-Meta: U2FsdGVkX18YYskuUAcdmmFRxg5ltdjq5R0dRn34Lj51gbEYtom1ebQLCuysM1wYJ8i2NZgTEden5j+kWff+JNm+B00Vq3fTnU/AvyTVSQpVTdjY+TShMfkQ7dsfRCbDtyv2hD9VVnbEgXFzXMxzxv63NFOEdmRcShcWMex9gFS275Ryox8Mz5ugnhF3gVBai8MCCAp0283kCUCuXOjIBKzPaQpefTU6FATyvbgO2OfXnVDA2JgYTd4h2HpBOWeksOIf7y6wPjebeH91clqdonZ5zTlIxW3WXUiq4KeJfjHtwEcgSSxX2LbBPJ8p5Sn+C73966AT57NUVTLFNiBiIdkzbdl/zOFVJzj8Ykrwm4ozo9Q8ZPPyQWZZQ0NoAG8t+fWfcC8QEElsp5BOiucW1MDZWQ8zEzmLcYwIojJVhdTWYM559hWTzejwQi1la1nketbVcoDDFPxx0Eaz5xXl0se3ZXFE00kLSRcw+JK18QWI4oO3r3TPxKjmR6Y5byafgQken4JM7YmEjozIfuvDR9q8XHlbHDdFortpGqqF3iPWaLZ72yY1jZ1VJwJZex5Mv6FBzvngXDivMxsWomgtJyT9K6eQO2CY+tEcRfDudgCfFiCB5hj8YIjoGD2W4R6ileVAcb2OjUbHbtKeugckjhNUkAF7JuUwqf21Jr2LmfkMEqbl7i4JkYGvMf3HyI3h4qoQVYVizVqKz30iNxPy6/hm43+snkzJi1+ThsY1E1ofdzjbJZkvU5V5EqDmEWltRsJ7ZQ5UCtOPxVZQbvInalZI+WsqAsBiosI5hGQy2TdyYUEnfYg2NGDP7L9WHgQtdXtLjGZqbD5bRBB9wwLR70UlzuWhVVSxo3TmcecUhp13vCa6CiywVaeR7q7hoQjecWx93+/WId/a5XClSUDFtaCDQ/cLa9JzxegDf0vD8rq3HNMvv7TR3KNxsOshahUmJwINeG8310Sjr9J3O8I
 lUxJjsMz
 2xJCaVstxZ7IFoe9hpyJKJq4FhIJeqrOnmJiMsnYk7cInSsQBjphunBhVx12pw93WxlAgj/Jh014puFWfVvAPCslfNIYZs3mlZmTGYwr3Hr/dAxFH596nl3kSPPoec5rKSL3yaKGeZ8HD9wTx2br7FfmSHHBiio5KgBv+IEVYh5kRQZppgpO5jmi6C/++kue7NHBY+/5ahW5EBAQ0TgxyQaEMWnr67quEmkPKTyj70CjeCeFNmuhJe3Tlf3QaPEHCW7ehYan3alMtGAnSvoSTQzE+Gg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: SeongJae Park <sj@kernel.org>

Add support of addr_unit for DAMOS_LRU_PRIO and DAMOS_LRU_DEPRIO action
handling from the DAMOS operation implementation for the physical
address space.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index b548813a0472..b8a7f462967b 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -195,14 +195,16 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 }
 
 static inline unsigned long damon_pa_mark_accessed_or_deactivate(
-		struct damon_region *r, struct damos *s, bool mark_accessed,
+		struct damon_region *r, unsigned long addr_unit,
+		struct damos *s, bool mark_accessed,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr, applied = 0;
+	phys_addr_t addr;
+	unsigned long applied = 0;
 	struct folio *folio;
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -228,16 +230,18 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 }
 
 static unsigned long damon_pa_mark_accessed(struct damon_region *r,
-	struct damos *s, unsigned long *sz_filter_passed)
+		unsigned long addr_unit, struct damos *s,
+		unsigned long *sz_filter_passed)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, s, true,
+	return damon_pa_mark_accessed_or_deactivate(r, addr_unit, s, true,
 			sz_filter_passed);
 }
 
 static unsigned long damon_pa_deactivate_pages(struct damon_region *r,
-	struct damos *s, unsigned long *sz_filter_passed)
+		unsigned long addr_unit, struct damos *s,
+		unsigned long *sz_filter_passed)
 {
-	return damon_pa_mark_accessed_or_deactivate(r, s, false,
+	return damon_pa_mark_accessed_or_deactivate(r, addr_unit, s, false,
 			sz_filter_passed);
 }
 
@@ -319,9 +323,11 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 	case DAMOS_PAGEOUT:
 		return damon_pa_pageout(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_LRU_PRIO:
-		return damon_pa_mark_accessed(r, scheme, sz_filter_passed);
+		return damon_pa_mark_accessed(r, aunit, scheme,
+				sz_filter_passed);
 	case DAMOS_LRU_DEPRIO:
-		return damon_pa_deactivate_pages(r, scheme, sz_filter_passed);
+		return damon_pa_deactivate_pages(r, aunit, scheme,
+				sz_filter_passed);
 	case DAMOS_MIGRATE_HOT:
 	case DAMOS_MIGRATE_COLD:
 		return damon_pa_migrate(r, scheme, sz_filter_passed);
-- 
2.34.1


