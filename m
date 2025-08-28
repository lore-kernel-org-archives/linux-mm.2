Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBC49CA0EED
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:13:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF65D8E002D; Thu, 28 Aug 2025 13:12:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA6968E0023; Thu, 28 Aug 2025 13:12:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D96778E002D; Thu, 28 Aug 2025 13:12:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B926A8E0023
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:12:54 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4014F1402F3
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:54 +0000 (UTC)
X-FDA: 83826811068.26.39CF2ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id A109B18000A
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E+RxwoPO;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756401172;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CnsBTactJxbQpwHX5wOMbI+swtoXgeqO2yceph5ZPzY=;
	b=Vjdga0ud6BdCMZLJSxdkkIs6syg70lhed8Il5alrOgUZTJL67eev2wRd2zUNE3nYsWeVZ8
	xVsaVa8I0kJka2RbHxBDHGHGn0FAJ9CW9IJe5MPNKIaK9KyGoaAjhR3dXYs5eSYWz9cjxt
	zPc25ZiU7RGtBGASssCs25+voOpij7Q=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=E+RxwoPO;
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756401172; a=rsa-sha256;
	cv=none;
	b=OEWdGLYcKVN+q7Gj24v7lp87hEUUSDsfh10yOJH1USEWWUuuoqnaGp+r0hfGC6wuEEcSHL
	t79rZl9QV/mr1EPU6+WTHa9l7anUdPT/bCPA9XSLhq9l/B5exap6ipCMnw9ZmAnC2qhQW5
	3vfxkCqr5ECx+OZct7lgEAE/1PIo3TU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id ED6A46013F;
	Thu, 28 Aug 2025 17:12:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E51FC4CEEB;
	Thu, 28 Aug 2025 17:12:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756401171;
	bh=C5/zayeob6MyHQaVS/Yc9d/xPufVGppR2LXlEsxQyJY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E+RxwoPOAEE+6jUb93CGgu+N6foU77IcMgIU/87tAcSSi2wYKwDyaOYnSOSomt+li
	 /xDZnGQAvwX1L2Vek8rmEa461XJOgKk5LfvRos+Abtckv2z4YuKsF239Cbb7dqvvcl
	 dOXRJ3TRkBpJ7ZCqbkCHbWFxIGJSKK2vpGVqHP80M3qeheEoH3esTsRFv41uViIM3o
	 yvU2ehSWKban9MeYyACMeMVN2ff9nv94NHh98uGlL6pykxvRQQQkFavhrIAAeVjcGj
	 ywTA1SpaujwfKMiJ3BLprrKkCE8Rpak/kLQEE4KXxewVlYiXIZeKUMsfgNSpdmbIih
	 S3nuORtUmagUQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: [PATCH v3 04/11] mm/damon/paddr: support addr_unit for DAMOS_LRU_[DE]PRIO
Date: Thu, 28 Aug 2025 10:12:35 -0700
Message-Id: <20250828171242.59810-5-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250828171242.59810-1-sj@kernel.org>
References: <20250828171242.59810-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A109B18000A
X-Stat-Signature: fexzpyxdjnihr6utdcpi88qj1mrkqmjt
X-Rspam-User: 
X-HE-Tag: 1756401172-346566
X-HE-Meta: U2FsdGVkX19ig0hImqHfm8YkO4bAQ2vM6efbJ7zNHPPSMj9erBllYsrF0Ls5PJPV2UtT7iW4LcwYyZm4sfFt+lrvaU1fn1WXM5Dvvg6IS942kuEBycMOPCENKrILVAUyrIgJo8bDg1IyEf0numbg5cXGVPniHDYD6SoRcEq0RYZlHXEv6QrLZ2DJ1xQdUrwAi1EiHS8PQ9ga0/6QMK+EX+0/Zv984ldvY37yIRGBG0tf/jESq+bDGhoq1VyXwgwG4vGTKL2GugrGxXwi8DRuHjEwhrzuK0iKNCUpSISKBIJVaCYpBDDKbp14x1Z6hd66s5P9K2V3mjOnBygpd0AnglOSs5sUjmJ6NQDxmVYx8anH9p3X43GPwuO5gRNwpmFr6Qm1qCFSBGFUnoYel8bEYi8IUzzOhImxQi7bJmsgy1FSnHOVXixGbuNIsASAKUlSkLsBF1S/YH+PzjCxaKwY+aUXDYP6KNefahafLLeEobR9+1NXr3xOqJtGekCeTC8rC9LkToVr3xBohvVwYO6z9Fgup/FMz2Oo3rxcW8mEFk0SP4eJKdhNIjb8Ry0P4Y1MmTBDTxKNAzm7l5RQSyIejWrXc+JrtgYbeumGX+8VN3XSQhotII/eJQ+dM1BkbwDJ/hQzHS7Z6Hxp1TcmgvOmoKlNrMtwOBjvq0jkiAP+AY4nrz3jSl0GYPR8wbNADtX6dxMPhF5DGhWtKFGVbjL+oapxRgRaVwDsp1nG6aNIOLcIRMhUm9X98F7nM3rrCDXxjk9tH3v575ayzCm7z/TKoEThEaaWWip8OCBlq9Y24YrMsdASBKcP6eN7dNfDfTyfFaKZpk0FdMVsx5DBdvBHb9yES4mvOfcjPvtP+GR+ceAd0j5J08Fh+zjhDccijgl6tXdKqar5MziCiomG8k4lPnay4hB/zojXBbdGcm5JHBRLU23WvLQEVoaJ3FBURdMuA7vkvpiehrf3y/eQ+Cs
 N37U/8U/
 ljZz0keC4g7SLiULUH5M+FkJYP3p6cZMILCu7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support of addr_unit for DAMOS_LRU_PRIO and DAMOS_LRU_DEPRIO action
handling from the DAMOS operation implementation for the physical
address space.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 29 +++++++++++++++++------------
 1 file changed, 17 insertions(+), 12 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 696aeb0f6c8e..2cd1c9953983 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -207,14 +207,15 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 }
 
 static inline unsigned long damon_pa_mark_accessed_or_deactivate(
-		struct damon_region *r, struct damos *s, bool mark_accessed,
+		struct damon_region *r, unsigned long addr_unit,
+		struct damos *s, bool mark_accessed,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr, applied = 0;
+	phys_addr_t addr, applied = 0;
 	struct folio *folio;
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -224,7 +225,7 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 
 		if (mark_accessed)
 			folio_mark_accessed(folio);
@@ -236,20 +237,22 @@ static inline unsigned long damon_pa_mark_accessed_or_deactivate(
 		folio_put(folio);
 	}
 	s->last_applied = folio;
-	return applied * PAGE_SIZE;
+	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
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
 
@@ -322,9 +325,11 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
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
2.39.5

