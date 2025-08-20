Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5B06CA0EED
	for <linux-mm@archiver.kernel.org>; Wed, 20 Aug 2025 08:20:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FC6E8E002E; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D9648E002D; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59A9C8E002D; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 49DB78E0007
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 04:20:11 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E7ECB1174B4
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:10 +0000 (UTC)
X-FDA: 83796438180.27.B7E140F
Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	by imf09.hostedemail.com (Postfix) with ESMTP id 7891E140003
	for <linux-mm@kvack.org>; Wed, 20 Aug 2025 08:20:08 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755678009; a=rsa-sha256;
	cv=none;
	b=cHflgnNcsyoEkewieaUp+nes302S00p6Yw5/8+OZt4bT0I9x9qIcFg53zpDwUfSkhMdZnj
	nqIpDpQcr9RYskUddM9GdcVwmU+JhVatJhjjA2UPWNXtgv5TkqROnVFnJ6IZFncLYNxfZL
	iGMpTT4C4YExrj0Mno+SRnIX23fM5kw=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=none;
	spf=pass (imf09.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.191 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755678009;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=kLyNUNHpK8Pgx06z3Yxye//MlEyw7vKaenXAWX9C2Lw=;
	b=rTjhyeF4sUAbNrslCVIi9nyRO5XSnu3B+Y9WpJa4ahSz94XjXRKagpjG8Dof2hgaAKyD7N
	acuVI9Y+O8wZu6U7ggCyWnMtGz65vWLWHq/eaidVQgEne4e4EZtYIIpnl4ra+Qf1PlPGzL
	G5UhQMCeAh7AbD+iKt+5u45s9W6ssv4=
Received: from mail.maildlp.com (unknown [172.19.162.112])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4c6K7C1xx3z2gKym;
	Wed, 20 Aug 2025 16:17:11 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 5D4FF140275;
	Wed, 20 Aug 2025 16:20:04 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Wed, 20 Aug
 2025 16:20:03 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [RFC PATCH mm-next v2 02/12] mm/damon/paddr: support addr_unit for access monitoring
Date: Wed, 20 Aug 2025 16:06:12 +0800
Message-ID: <20250820080623.3799131-3-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250820080623.3799131-1-yanquanmin1@huawei.com>
References: <20250820080623.3799131-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7891E140003
X-Stat-Signature: xx8o34dses1puw3un5bsgp9cbtmzkm9e
X-Rspam-User: 
X-HE-Tag: 1755678008-935587
X-HE-Meta: U2FsdGVkX195NPpP7DKgko6P3mYKw0CFF1PILVYrp1oakwu47nHv6kR3+YP3S0Zz32xEV40ThRO5htxjvz9PKe+anL2cIGBiRveYMYY2T/ysoLJKOfS47tjbBbtxpSdlTTGSrqqsJG5RhqZHEEODYejcmHkvvrP8cO247AuoJc+caAsTZS2uDN4R3goyO2sDYrbjsOiRRUO/2kozEVjVK+4RTEYvOMcISwRnSXFVUaTcOPjSQq7D0YCDrueqTNDUVx1YoDZ6crW3yknAATZpteeh3HtOcn3AB13dB0FEUIHQS4d4U/CLd2PkxjU58/CvD9RyZpWgXf2sY0G3GVxpt4gzSVWbiwQBjZA7jxURJXoLyeh0DmD6o0YuNIPma/k4YPeNU2fDt0yJi+G/mUNxWTcRuNbZzNo9bn4dXMilRBZ45rLlOs4U0IH4vVdRHypG0J3HB4iKTCwR8kn3oRjKY2HoqAyfVoQGTCRPqw/AjhNPeRouFwRItg2dbAFARu0eIChdbYVVxHiM/k/uFKys5sSPGwpIO6cgNnXuXFOf+PL1Ue3QhdJmzwWYvvsDiWMA1OWu3R2SDYAVgs+ZrscRKjtyY6336eiZfKrY2tAhAAoOU61naekx9FyhFf67bwQshy29i14XPR5p5z+WBpdjCdvJMrx3b6yYc++ZDwaVXwsuY4cwhDy7mm0p1BWeOOy908gj2LVJEMkdocCJbxpMCegxjo5aqLNrkQGAtkkXDkD/T8tB/+v3RlnLgTyPPwqHor6rSfpuAYEwc8OhK1sQpxx66JIMeRsfjC/9wiPEnV39dn+y3XbMrQIw99XH5tonos+ebLvg8a8eyawSz8+hi1Zt4/djOUF8kFSAhjKX91nF2c5ugscORR7SAWgFn1Fcp8oc1OfFtpkUAarF7gx+sP4S24uz4yaDhYjmfEIAiohTAyTqWVF0FpGGIcETzTmuoD8whVrXyCmhYyzRoGb
 KFSvAc8n
 7lQzuPy+4KYeVOMdrjlQjma94SBmSRIk+o+GhcCtQ3rCQbLXA4Ckci7B3UzA5749OTPgQ/z0K+sMqf14nVLmig0ZxHYD6ZlddudNCXXS1ULQC+X+b9LYzoEki4viasPoq+Zsp9H7gD4FBdIVWytoP858+tTwXEYrVB76Qqpt7K1fTgu64MAEnnRrNJnJT+Ioa4Y1gbrJnFL03nQnbqPR71WU20VDuoDf10wNi4tTWAGtP2VUh/97eyNMgys4yUBf95xyc40oQkYdgTez9L2OTaXJ+yQN/WmmVEuPp
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


