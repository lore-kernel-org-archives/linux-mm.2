Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 19518C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:12:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 076B78E001F; Thu, 28 Aug 2025 13:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 028318E0008; Thu, 28 Aug 2025 13:12:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E593D8E001F; Thu, 28 Aug 2025 13:12:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C24908E0008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:12:52 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 8F6221602F8
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:52 +0000 (UTC)
X-FDA: 83826810984.15.365B4A1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id B56CC40019
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:50 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ShoWSbxe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756401171; a=rsa-sha256;
	cv=none;
	b=ona7GAH30z1amZkUHdKYTT2tccLAAnb3yzx0kFuOZVyQr9SnZQXrv9LgNblZV/E7SGRi+6
	LtzanYvBUjC1iDZN0yMmdeDwKketME81848d3qs9y8Ujkdg3KrHIou9moHi1vZIOmdEN7O
	VEYBjoAQjBmkB7zx6152Qe6wDG3DdPM=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ShoWSbxe;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756401171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72XHPJGrRzPivcfSn9J81HbMHRhHG4JO2mBFkOb32XE=;
	b=iDGKL7Xy+3nIBKshZNcygOitYtUKPlzs4dxx1WIExB71zuKKcnO/kNk1tynwXxw4k14be3
	hzRBdxTus8UB+Iics48wWVhNkc/dnhxVKYXw0zxsTeK81PzFyX8VSVuQ8DEYa8uoxr0XiE
	5pvmRyxA5S4GaPf1OhDTm8MIFd4hAuE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BAB4A451B1;
	Thu, 28 Aug 2025 17:12:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DED1C4CEEB;
	Thu, 28 Aug 2025 17:12:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756401169;
	bh=/viP4eNKlIp3xNvGENLPiu9ygdeBlYDEw/GbgmbYmHU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShoWSbxe/VvRANS1E4btJRQii4QhZd4/DyUYBSCTQIJf+/FMvp59isNQLoZyRyWt0
	 /wRnFM9kYrcNo+SdHTDNCzwhIYfMoH/Opof0rlgrAxwNB7U4E+vdyPYfjgJ3R13Hwb
	 /OVKiFSvOuap6k0V6h/XNSqen2Gt98MzZkp9J/7vJCtSWZFqSVQ1hDNcsvjWW92eN4
	 1tk38a9xbnwiNQErYYyxtmHetcl99oox3epZiEWoElrPgQZbZf+lIN/l6xeis+GEZ+
	 HikmhBENmXwOZk3CbzDeLf/UpEF8EJOtrDrmnls8ylJgkXQ5xH8c4wVMvTHHvCo6Ok
	 wuljHjyCK4eRg==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: [PATCH v3 02/11] mm/damon/paddr: support addr_unit for access monitoring
Date: Thu, 28 Aug 2025 10:12:33 -0700
Message-Id: <20250828171242.59810-3-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250828171242.59810-1-sj@kernel.org>
References: <20250828171242.59810-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: B56CC40019
X-Stat-Signature: andwe5dyu9sb3cxxrr81yjacpmaefj4q
X-HE-Tag: 1756401170-954901
X-HE-Meta: U2FsdGVkX19nIyRt8ThjrCBckvO+jRg0wOHijLIYCRWValWUJe5Jrg3286mmwvmckS1Qzs0AlKQ+r2kQqGdLROhehuHbnq8as7rQlj5XJyRW0/deAN5Cwf/AVimYFbUsRi4SrhpLmItF9zLumsTP5zThEDYJIs9JDQ3i+iF2gm+2x8EvbvJS+hFKVrx84WOk9H99IG8XGVILUcLNalmULo/F2NJl898zkCiKn1snjMx18P7529OCJgNEXaSNCo0zn5zavc7RMdifloIjY0C6RwZ4h8RNFH70zEQY43nGDEftSLYmH70j73AAp/locjRYAIbLaLICyf/JGEPHkNZniNT3McbhclNtn8bq+e1srLh75Taeo1nyqO0kBn/CHjq00YkLCZsvf2ZXKRhG9EKYb4NrkjaLDmeL8KAyaFXzRXACSmz1rIRj8xL1X1kVncvGszyZckWozpgEcJPx4tFszdjYvMqWfQE6B3pOTvqOxMGx/I61MU6UzkS0Z1xcbrK9rxJIZ6r1Vf5K8MXqCOJuIvZbG8NAIICUF9qPtC6aTEebJ29ogpsXQKq0+5O0u9WmR1ZLljN8D8Vr8FyPEYMlPaSE4ls7kPEXihDDRxOfv+8hwovkD/cfQKp5ZyUiByL+KNu9B49uGrGPqP2MAR4XOnXGouxxZtA14v8dv8x/9OwMlPIo+Vc+2TqQkoSseaASqZaPxXCfwWbjwQaRmkaL4l10/khq9PSqsC8EUfU/DcdiBh++VdstCIE5nqOPIMn2R0jNqNWbFZwDYmU3teHFti5g2Hcm72+WZPuOmykrxqYfEeISQe2lLWFD4MUcCnQBfYBAucJWNIgI2kUe5Xau67T8fgu5baQjR2jUBuShDkOjZ5OQTKTpqJcm7p+iDBtmeqbUuAIvIFcBamv3JXvzGXUOTZN8CXsuETIDxkiCqtNwFBip014A5DOzDnhWOa+6udXr0hTRTqkiGE0iHuu
 pFDVJxLB
 F6wdxwJOSCZMNGXuif6RcRY2Srp4sSXf7VdP5ZUUq9mYpMsnkUfJJr5e7vVAs+xn6MmlXKB+F0PXSCtqriHhw+HXoV63YqdfDujarm6sgnDlD4b7/YacSDnY8Y32gw54VtG55Y5fQA+Nb/VzA9XLe84ezEmfitai3buz+mgOOUsHHQcsQrV6iycwlAES7MhCGrSJbLEwqrWhLcTVCG4nfwigWsRyltkTscMUwa+pY9JVK62lXaj9AIXFobmGJt7MnzGaI05r3fBSLIf6UmXsZsLZATYH7Ec1DRY/nSnMMA49o8MokZSqzZWdenFjrIIqDgmHelKvBDOG+A88/0NeUQKoERg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
2.39.5

