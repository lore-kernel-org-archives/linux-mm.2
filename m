Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C223ECA0EC4
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 03:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 883BE8E01A8; Tue, 12 Aug 2025 23:52:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F91A8E01A6; Tue, 12 Aug 2025 23:52:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BFF08E01A4; Tue, 12 Aug 2025 23:52:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 372238E01A6
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 23:52:37 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8A58C0236
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:36 +0000 (UTC)
X-FDA: 83770362312.29.FC8E0B6
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id 69C281C0003
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 03:52:34 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755057155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=R2NNL+FRhZR1zWQbSuyDSsQPfX61PQCt4SiAW0cN6Gk=;
	b=0DxIIoic9qzclf+DCJjjv+sgcbm2uOEDwKhjeYaoiEB0l+6nFwJ0Dd1KD48T2K325KZ+Wj
	rAx1Z9wc8Ea/JRlmGs6hdAQydZUVpGR1i1gI42EEJLeYKZ0pp0hhn9HMI8KzxGL4aD9AE7
	9MwyzUacFgSugif79izb1IIoCX45Yko=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=none;
	spf=pass (imf21.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.189 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755057155; a=rsa-sha256;
	cv=none;
	b=cMBSk12PIklt3a1OQViW9hNs9fPOfKhX4J5wy+VdROYPDA7G+vRYVzFDhAFBfpkz3tSQIs
	ob7sScj8dhmvdVl0oCP+jxtV3m3pslh78Cs5/9dRvm0iRKQrM36KnYcmQsz1AK81xG/sX5
	Gmxj0ii7ZonX4iUM1D4X7MJTyFq29aA=
Received: from mail.maildlp.com (unknown [172.19.88.194])
	by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4c1vV25thZzdcD1;
	Wed, 13 Aug 2025 11:48:10 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 91E7D1402ED;
	Wed, 13 Aug 2025 11:52:30 +0800 (CST)
Received: from huawei.com (10.175.113.32) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 13 Aug
 2025 11:52:29 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH -next 02/16] mm/damon/paddr: support addr_unit for access monitoring
Date: Wed, 13 Aug 2025 13:06:52 +0800
Message-ID: <20250813050706.1564229-3-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250813050706.1564229-1-yanquanmin1@huawei.com>
References: <20250813050706.1564229-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.175.113.32]
X-ClientProxiedBy: kwepems100002.china.huawei.com (7.221.188.206) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Queue-Id: 69C281C0003
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: 8auukorja1w7gc5jm6ddmzpydzukk9oq
X-HE-Tag: 1755057154-761962
X-HE-Meta: U2FsdGVkX1+j8K2MYewNA89HWNVwFDyuQPsu2XDYYrWLAhdLVfbfItW/C6lZ6FRL70EarWl5/pQRZGr2F7mz41iSxLpsTWHsiQgQ8Tb7tiVRY3NK1X8UuxkuFvZVvbubIBbYWlbeVKqSceRuDdBzQVtIyJYdBhIxylvjZgyNRvEC/5kVGQmWjSk+UXd636anNosHv/QtHhd8jzedLWwmbdmHzrNLvCf5fULI2rozBi3/D625dJCtiUhIuklzb01zSL4uKtTj978DyQZSAU1mt7NWSP6qDimiJr2pxpgYMz1LDr9YOznDSarIfaQOqkwlD+QuRowCloaEACVVS4qS7wKctnq/lewk+ITn+r6BUf29q5j0XsX1NkDy/smCIs8u/BPXHIvn4qjBx3R4weRyj2+ljsN+A2rrUegVF9XCfW0iWybdtTc27DAYWfUAQsb/u49moFGUrlq31cffcCiX5O9dP1eZS+mRFjJTAo6nnfZa/P3HpqBQ2FRmB/5W4ZufrhK6Yb8jneu0MxQn532kjmnKLjixKwAvbAmRQ/XJu6jFOjWO2v5naBELm5BlKhgVzl+W6H3lvaFVrULQHHWW8h5st8FlBRJVBZX0ghoneQ+3oHhDpnHsNJsI3EoHQmG7YqqNn42lVnzFths8iVBE+KPNN53AbJ/6hTO1gJw0ve5o14LVr6kYzzXBfzCn8/PPPQszEW/LUEpyqz6Zw4jw/W5/mILwOMjxcwsYxpjqGdqdWlwfocUAvvQg4ZQ/Z7ayFGEnJ8w+UwofxR8HdwyduFfJunlTzJs6/XyCdLQeGe1ez3fAS7i+mvjE2nIsTHU/gLjVVTBoIdge1OE72un5/fb3RI/3A/GcKsKNA9NILpVWyneXwz6O+y3TyZx1RWbBzPi1pmgEiw72ubQnwmTYdCJF/hp9AZRjjuYSSY1zDnVSZl91/iM3o3hgs1tCdwfxLrYAGoPszYWf2UZY674
 NEwaVNXJ
 kFUSprW4aEEm1yosB2lflMkmbQZzWEZhId4gsqAXaW6Tc1gUvsIpnhYUVYX3vCO8A3kmQpIiJvWQz2wThV4bHCYj1DK6Vg5u6lbyyLCu0hM1j0MDt9k2gI35BZabOWsitGJTemQBH73i/GuC5PoQ1fAQJOGRXLQpx6JfWqR1jBDRlaf8eqqcfhc7B6Cw++An4bZxvyeDV+umoKdaOAXbM6VhsgDMNn4/1Rlwu1NORqqYLwNvl0QPJv5nI3T2Aynef//6A3T3BHqPfV3zB9+dv8Oibxw==
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
---
 mm/damon/paddr.c | 32 +++++++++++++++++++++-----------
 1 file changed, 21 insertions(+), 11 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 53a55c5114fb..345a0ae63b19 100644
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
2.34.1


