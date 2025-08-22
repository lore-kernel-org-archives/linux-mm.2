Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D50ACA0EEB
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 09:48:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B646B8E0085; Fri, 22 Aug 2025 05:48:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3C538E0056; Fri, 22 Aug 2025 05:48:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A51ED8E0085; Fri, 22 Aug 2025 05:48:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9453D8E0056
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 05:48:13 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 599C1118365
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:13 +0000 (UTC)
X-FDA: 83803917666.01.6444F8D
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf12.hostedemail.com (Postfix) with ESMTP id B636940004
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:48:10 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755856091;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=RmtiLXUUsrGLis4EgNM2buYPfH22zN6be6XhAPNmWtQ=;
	b=JD54Fg9GUsX385o2oVmTMNaOOjLSULjqBAghMVYkCLpei558zjappK/p3eA/wot5P7K+ky
	hoOJWrD3YebLP40ynJnFzwnbWwnfF8cPm2hqgmhmC75dyrE8JMSsE9Z94EeprNLZmVvp9q
	CtKYy5eFeLLax803M0Ve4zRC3PA0nAU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=quarantine) header.from=huawei.com;
	spf=pass (imf12.hostedemail.com: domain of yanquanmin1@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=yanquanmin1@huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755856091; a=rsa-sha256;
	cv=none;
	b=3fsyOcJB93Y2G75BzCRkeJoUxq2D7kG/D8x2cMQYhQm+tHhDtl7frqqvpCtjq2xBKSdgmV
	959BrB/Yr8IBpWwRQ9RJLmNLXYQKM8L1H82WQ/ixF5inlU136IBioDwgNeSBQW74Eg+aul
	D4pN55dBPVJDlWqMXuig/YAoDwJNIc8=
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4c7Zxv1mnlzPnbw;
	Fri, 22 Aug 2025 17:43:31 +0800 (CST)
Received: from dggpemf200018.china.huawei.com (unknown [7.185.36.31])
	by mail.maildlp.com (Postfix) with ESMTPS id 2DC64180495;
	Fri, 22 Aug 2025 17:48:07 +0800 (CST)
Received: from huawei.com (10.50.85.135) by dggpemf200018.china.huawei.com
 (7.185.36.31) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.1544.11; Fri, 22 Aug
 2025 17:48:06 +0800
From: Quanmin Yan <yanquanmin1@huawei.com>
To: <sj@kernel.org>
CC: <akpm@linux-foundation.org>, <damon@lists.linux.dev>,
	<linux-kernel@vger.kernel.org>, <linux-mm@kvack.org>,
	<yanquanmin1@huawei.com>, <wangkefeng.wang@huawei.com>, <zuoze1@huawei.com>
Subject: [PATCH v2 02/11] mm/damon/paddr: support addr_unit for access monitoring
Date: Fri, 22 Aug 2025 17:34:10 +0800
Message-ID: <20250822093420.2103803-3-yanquanmin1@huawei.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20250822093420.2103803-1-yanquanmin1@huawei.com>
References: <20250822093420.2103803-1-yanquanmin1@huawei.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.50.85.135]
X-ClientProxiedBy: kwepems500002.china.huawei.com (7.221.188.17) To
 dggpemf200018.china.huawei.com (7.185.36.31)
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: B636940004
X-Stat-Signature: 16r9huen7ma8fy67erug7neh6qcz3bkm
X-Rspam-User: 
X-HE-Tag: 1755856090-496106
X-HE-Meta: U2FsdGVkX19hIUoLRx0COx15sqBYbEZX6LsHSJ3bjk5s6hMJpQ6x3l0bXOl3C9PvAuvn+ERibG5uHqPZ6wVcnBX7HFAyIV7ZYxy8BlJsefH0aBhzzUPgKWSz+KH0MzXhHP/SjoKCtJvfr7dNjhfGrb1Xu5Gqh4D6F3CtQLAWxPh3RgyutEz+TsQkU4EskaPW/DPw9bfdqExtt8FCtjiPHcR7u3U976KXfGMN04BzSN1T44ewV9f+muaPMNcWlXKs87faY2f3thuT2eT+89iqZnekTLvPnun4XWTAA220b8gQRzDRO1KxmXC2AvFZ06IlWEuUfLe+Us7xhrBaapI+bUYUnl+PjmXpZfK6FO28+ocgaIpXkn28tY8ShioVHbDCcBrgnQINWjZ4b03nwkO9YeQIIhifBausD+P2Oo30TkUD2MTPzqna2F8aGwoUu9ndy+YV1y/PkgJ+9gLsXxrR8sr1XPVpcHR+Qmo/w1TGMQc2aCLnSVtcKevTwECdvMB/mX2lPIaJrn6XUcxgSxqQVQtQd4qdHZAbWiwAPS8z528dCEBXW6sZACVVXoU7FVQzm/2VFk5zvSEzMwGTLiuY/UuIVLMTZY/pJK3MIM/GAWzhJaJaI1+uGv9+u4mUTTycyCK9JWTQrVInVTVx02WJj7vZYvLYVrxedcQLwYhCcktXORodlnhlkdYXa7AWv1a6Wzw9u7UrtKu7O+edF4fESut+EyTC/RhDDeMTOrSzAhx9HPtFH834IHERUYqWzRnr7K3YpZzeeUfr0nSSu/UvvowWcDZWSS4FnGz+XM2eNL5uDKcvI9Fof8SECc6FhJoXUPlwxoFuu+D/g+fIi6Xp3bj7cT73+l+41UnSWyP4FAlvWgZHQpLyuOR50OBwVgASDX2g0RkfT2hDEZ3Ub2kDFAj+8HABIQcAvmyPLY1QgFvlQiVNNRaPd+BtjUiz+a92BPwOVL1piXw9k9PnYzI
 upOJSKB7
 Gqh+qbg5tgk2vhqzs30cqHRkShDbfiiYFgXLh8+koiRv0ecaIo8/ROcCCgwdFvfs5dziU8Vpw2Cl4don5h//N+E+UPsIn1JaVfdAfEmEXvmYXh6ZEayINqKO/ay/Tnn+WNgdNwiHRIhuShBDK9VT0T5PrKtYLed7KSDIU6lewkalZekiE6c0mdKVNeapz6WYDIQljUWIhsJ6DomLE+Bsi/sgs1VNKkuGAn/XnINxD2XBbUewNJ4dSdY/3RbgQA1CWZfB/m5ngFOuIVAF/L6ld72hGPdnITUz+BjmC2LwxKBahANI=
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
Reviewed-by: SeongJae Park <sj@kernel.org>
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


