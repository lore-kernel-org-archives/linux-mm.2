Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64660C8303F
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CD49B8E0008; Thu, 28 Aug 2025 13:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9ADC8E0023; Thu, 28 Aug 2025 13:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B49458E0008; Thu, 28 Aug 2025 13:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 95E358E0008
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:12:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5FC0A1A02F7
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:53 +0000 (UTC)
X-FDA: 83826811026.30.8D49652
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id A0CFE14000E
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E6ZWd3xP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756401171; a=rsa-sha256;
	cv=none;
	b=v0nNX+Qnsv4yR/Qcqq6HXaW/7ZQOeCSwNsAw/IgZvaG7mUYY8S9eEYfGIlwzk5pjRwhVhj
	pDDbyJDqmgmZVDfze+AtrsaasdufseAnkNEySsvLfdEquJ7iNmiryus86VrSlBIHIHJLyw
	4notEDPBwMpDfXuKeQWFc+Dtta9T7kQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E6ZWd3xP;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756401171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pc7cPvH0OW192au+cjLt6bbwu4bH426JQHv6qfUYnsU=;
	b=Vf4NzZT6BIE+4DjqaHOxhLHTVansrk3D/ByltAhFQwiutgnq2REZPvExsLyDCsUTdIZk8U
	zh/pdpqSX9TXvom2Kdn+ynndHc/q0x/VrXn5agdL9WhW0DiAZK+/0H42grweK8UBDBIkH/
	OaZ6AOefU9BSTal8kH5ViEjH8axiQak=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1537451BC;
	Thu, 28 Aug 2025 17:12:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EAC6C4CEF9;
	Thu, 28 Aug 2025 17:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756401170;
	bh=fYhqOdJk8g7Kx4IsyLnZ52pSMGRQylBDNBv4D4Pqc2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E6ZWd3xPefENCDvxLUzYqof2Vqp7XK2zl+1MsWwPTYSiCWpjFxzhsxx3HgoYntLd3
	 KKs80tvDNSYseHgdp4uYx96ZzbbpYJSlJecQaVqV63H0YsIJ1BDp0e6ryZvWuNXpW0
	 zYxzih8BYLXwpN8Cw2Oa6yWhGH7R7CvoIbOqZFT19Ez0nbgRiBrMor49k9eR8TeYvL
	 Cd/dlw2ZYG6FyuMmrNLl3SaPNnhqyt44NSiCM25b+Zj751sI6Qsp3/fg+r74+/t72u
	 q1YDFa+BHVyU3VbzgDt0GI1Y0IfgyUda78LGuwojc6SkRehc1K9GsfIvddbIe0ztzR
	 fqTUmMnayD8SA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: [PATCH v3 03/11] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Thu, 28 Aug 2025 10:12:34 -0700
Message-Id: <20250828171242.59810-4-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250828171242.59810-1-sj@kernel.org>
References: <20250828171242.59810-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: A0CFE14000E
X-Stat-Signature: jf98wpr4d5mo1gad5fybqfmf16br5bn7
X-HE-Tag: 1756401171-637189
X-HE-Meta: U2FsdGVkX18JOCz5ME6tJpLNpq/qRXtQsLcalCCF7qIoqXDQyj9gSnS0Js70PIAqRoAdDEgEnCNnbpGTjoc/sqzTREXXfR7pZph1qlJvHDU3zxRBuqWRu0OGA2g+zKfPoUEBQwQiFldfLqfPrAFac2jG+S3xA4JAnvi4QPab4TPSTR9zxa4rveLm53g+i/hg3/UFahhw1ZYTcd7ZXXPJS5l2v9HwcqyXkwiJRuEHsct42P4ZTVhjKPF50xYvO5sG++jSaH0dqViWoEsbg5SbPSrwIJyquj4RWCd6k1N9irYrsdWSqAvMIDU6O+XXxwLcTo2HHRFUQHopKbZ/X9e6jRNf9Vo0p6GvH23NpPW9ojnW2mTc/WIebHlsbRmaPEzT0gDXexqQ8iIn6P+60cv92uCpr6Fhyl6SpO+obqjzGTG22RvwKoyDJorezegtLaoiy8vusvK/GvSXhgtkyLNTPvGe+01fbrS7m2hulUTuzDDc8rIN8I28NWG1t/CtnS9q4kGP+efVUr/pAd1cLOFyzuJkIp40cm0lkWG+mHMktRMtPcFtTcprtyC/Za08L7njsHX2BclK1mWbfimfuVN9TZ831xioTnPgduleBYgta6sa5FDhIqIS0mRiVLP49GUuOL4w+VguSmfwRze9C4X8SHdrmnU+kM3Yl50IK2eaF3utNsMLvHla4mE7llhpZMSwiZIDOhZJu+5t4c3CAb7AI2gnR877GtaHb/FfAJVWKm7+ZKo9wfse9RGapsy61agsfucpcsqDiEibQkOxtWcHeS3leOPX8TABxBV3nlrCjS9p3DM7popirD+Pyxnmh8ga53yvlwL2fDjvR/uRRhXWBiDE0xWYPH5zixyhYGTzUv5CCoBeUkinXLD5tvGA1jMc8ICeuBG/6Ce9TJgtJRw/EkJY+XQ/CeWu9+kZ47aZ6z41FkZC2hYNWtX7DuF3rf5uXd6WZhxGRcKRj8ecaho
 yh2e6N9Q
 31gOyHE6mXlS42kd3gdQJPbueUSTdvD9YpDsSrOrK4J3Uwc1NHCOC36X96YnDvjO8l6XjVuLjtnLg6I3a5QzqsaFhH2vjVimkscpnj1ZiGgpdybr1H4phZRLdhoGiypsl4cEtwcBF7hDi+uUBS+igcSnCQdg/AUIxJOwMIP0m4txcQs2H4uIOredFT9YsKsMcn0MueWc78jx1CbmYw1y3IycomgCrD0rN09PYxS8GfGrjL3Cxt8nv2/FC1wHrrJM8W0bWZn79IN7bsQpNjy0usB5UVzl54cg9HzOjx3u1b9AevFHMCZotJpxHInjQNpbxCcGmejQ4M1SS98UeBpt0koKCzg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support of addr_unit for DAMOS_PAGEOUT action handling from the
DAMOS operation implementation for the physical address space.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index d497373c2bd2..696aeb0f6c8e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -24,6 +24,19 @@ static phys_addr_t damon_pa_phys_addr(
 	return (phys_addr_t)addr * addr_unit;
 }
 
+static unsigned long damon_pa_core_addr(
+		phys_addr_t pa, unsigned long addr_unit)
+{
+	/*
+	 * Use div_u64() for avoiding linking errors related with __udivdi3,
+	 * __aeabi_uldivmod, or similar problems.  This should also improve the
+	 * performance optimization (read div_u64() comment for the detail).
+	 */
+	if (sizeof(pa) == 8 && sizeof(addr_unit) == 4)
+		return div_u64(pa, addr_unit);
+	return pa / addr_unit;
+}
+
 static void damon_pa_mkold(phys_addr_t paddr)
 {
 	struct folio *folio = damon_get_folio(PHYS_PFN(paddr));
@@ -135,10 +148,11 @@ static bool damon_pa_invalid_damos_folio(struct folio *folio, struct damos *s)
 	return false;
 }
 
-static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
+static unsigned long damon_pa_pageout(struct damon_region *r,
+		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr, applied;
+	phys_addr_t addr, applied;
 	LIST_HEAD(folio_list);
 	bool install_young_filter = true;
 	struct damos_filter *filter;
@@ -159,8 +173,8 @@ static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
 		damos_add_filter(s, filter);
 	}
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -170,7 +184,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
@@ -189,7 +203,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r, struct damos *s,
 	applied = reclaim_pages(&folio_list);
 	cond_resched();
 	s->last_applied = folio;
-	return applied * PAGE_SIZE;
+	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
 static inline unsigned long damon_pa_mark_accessed_or_deactivate(
@@ -302,9 +316,11 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 		struct damon_target *t, struct damon_region *r,
 		struct damos *scheme, unsigned long *sz_filter_passed)
 {
+	unsigned long aunit = ctx->addr_unit;
+
 	switch (scheme->action) {
 	case DAMOS_PAGEOUT:
-		return damon_pa_pageout(r, scheme, sz_filter_passed);
+		return damon_pa_pageout(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_LRU_PRIO:
 		return damon_pa_mark_accessed(r, scheme, sz_filter_passed);
 	case DAMOS_LRU_DEPRIO:
-- 
2.39.5

