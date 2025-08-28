Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6CD59CA0FF7
	for <linux-mm@archiver.kernel.org>; Thu, 28 Aug 2025 17:13:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 384888E0031; Thu, 28 Aug 2025 13:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35BF68E0023; Thu, 28 Aug 2025 13:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 299758E0031; Thu, 28 Aug 2025 13:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 171508E0023
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 13:12:56 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D33131602EB
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:55 +0000 (UTC)
X-FDA: 83826811110.23.158FEE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 31D9D14000D
	for <linux-mm@kvack.org>; Thu, 28 Aug 2025 17:12:54 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fmFEKtsF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756401174; a=rsa-sha256;
	cv=none;
	b=GHR2rRc9cO+ptubRfHhgthfdsXvKTd/rKWjOcK/KJC16cIOPdIbQeVJypQSNppSrTTMrE6
	rc9/DjZoPBGXOyB1/tAUOi8DBUX0mHPmdhncsD8ll5qcdQ7d1e7w/Nt3cmlEIbVbOzQcSq
	dspia7cUwM3U8ytUYNocyq1B5la4ZIs=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fmFEKtsF;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756401174;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fZ+88kPwcX2XO3YDSUf113G2yESubxb41C4WKQ+PjiM=;
	b=8idJZBfrhv21eHlxoZXRLlbHtWfTc7VrFsfS8akj07sQ+4Br5YfEyHr2raOawLHDVCfiA4
	PuB/YsM0+mNyz7sLhy6zjNdMqhnuH01pA8uy9PWGnyVqr8W6dT+YSc80rroizwLEn7MMuO
	tjpfA5YJolsIp7MLOv7SHUYQ80v2FGA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E0D5B451CB;
	Thu, 28 Aug 2025 17:12:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0EF0C4CEF4;
	Thu, 28 Aug 2025 17:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756401173;
	bh=s/ZtUKWoi9HlBtotMtbYAXHGNUrzkyLE//5a+5BjQyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fmFEKtsF9NbDuJufKLJyMTnrxl4FEig2ZS4T+ULHygt3c8X7mDRAtCE5JAqcculiU
	 kyUE6iiiyi6fCLo3tx9CD3MPDkgiMihYeEpgqr/aRtpxbxs9TPz6SdGY4eB0I057BY
	 ZZBB3paIFdzOnC6yw1xnBAC6YBGb82+uCLxehk28tncossRjUA+r1qA4vpHB2YnNnF
	 oIa4cQxY78apjx6gQyTcgbPJFIB6Q0kM52+yTXLn7a+i8FVY0cLh3/OBhxQxc0iEVX
	 R5UKPDu38pyq5cY6Yw8gitFjkd1t/11AOrI3kOt1a7aGgOVz3z8oAUGUX7eSycSlMx
	 Jym+oTukm3YaQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Quanmin Yan <yanquanmin1@huawei.com>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: [PATCH v3 06/11] mm/damon/paddr: support addr_unit for DAMOS_STAT
Date: Thu, 28 Aug 2025 10:12:37 -0700
Message-Id: <20250828171242.59810-7-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250828171242.59810-1-sj@kernel.org>
References: <20250828171242.59810-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: 31D9D14000D
X-Stat-Signature: 6nckj55rtuqurb44bptjry1bdghhhdp8
X-HE-Tag: 1756401174-739915
X-HE-Meta: U2FsdGVkX186WmP5yPXumyRKRjZ9D3dTGvlkChX7RbAhFqJZElhEh2yA/tdkSVA4ZKl5kxOKMjlu2Yfrgp7fcLvHyY+8SPKykxO9P+iGJuuL+YP2L5rTDE+mwROzvag4DcDupvb6Ueh+1tYUJLOyyG90zEsdcPFK51o130Gg0VBv427MzPS7wgv0M78uZrTbiXfcMKMuYKOxnCUfmHFMP+TwzRE8AZxWvKJRVbVWv+QD5sRnO8qWnhvzvguPDdRzbv8kaNTLzr6z2KZWb58LLOodCvtWkKcNY51nIZEemYAE8orytcpvEuDzYkI/t/x6xWslKc7DRhqeBgKlWCUpuwxC8lmTtPBHJ1Bzl1mieeQCVg4HXSSCUz+FsnLcTx9s9dZzrGIz2f/m3HV+SCK4UfxDvz0xD7rZDOVfjkVsdQ71n7sb9q/N/HYjopPUr43l2QDKRtb8yAtVyrSAYALevwRWYVlOLO8SIOE5IEijTBu2t6IOi2svAL8TIdrunvProaiMWwC/Pynq3HuA5rz2LNjInCqgvr2fWcd1k1KQdFb2lhEJ1xhLaMRVMVJkWrz5ia7mBjGMbPID+b9skThFKvXGEHMfGn8MqglIbxnNxayBZY7Gjg1x2W24ersx5Wk/R8fIYFN1VVG5/ImaaNLJo1l0BPaABDJQNqn0Q4Q9pIz0W1XzW6otRZ8M00jvcagS5O78HHSNTGMhqkRzhpk8SSuLiBV7f5mbOXHpuMgR0xtR8WyD+fsyWTDwkyqWlVe5EqAHpDXaXH/U4nB8oclVEnqKwyUqcfJ6lQzGrcYu4Sx7sdThY5na43o5ddRonWcfKBqPj1l1PO+yMY5x8qg7PhF+91Ux1CqZvoj/4SjDZOSf31WCoK7Ugq8Lj0ygbFfRuQPyXAbz7PHERY5cGdKtEe5ilNdL/yiLFMFs4IR60k3Y7s3xNauU5AgR/D6SrqtrSLtPV1m6DcdLJXUODt1
 CBZmvYyQ
 w2Viwoj9EGS0o+D9EcEcldznM9DBC+oE1ZeGn8/JTKOmLdgt7CcAO6miGQLRNDRnqYzoSCN1tcLHwuDIf1hJ2yLv30WUKQBVWzI5R9s2acDscP8wyG4SoZiL2UKJ9wl3wTtVkPNFj7e4K7IyjpwT1MHO6NkXWHOA7QSgegAr/mky3gEVp1VmG9gU47BEAdmP1JL9MNHQvaJKLihY6yiI7T6d2hRof4Gvkr28sulB9pJcu0HDDhTEUxODLCxOF2T1TQDhwROFEHh+bhSpp6Yg3r4gEMQjyBjozUoBQHSv26rrjdvjKA4vQkcuSO2JmGDM1D+Ab5/khwt3aK0A/d010eUBJDw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add support of addr_unit for DAMOS_STAT action handling from the DAMOS
operation implementation for the physical address space.

Signed-off-by: SeongJae Park <sj@kernel.org>
Signed-off-by: Quanmin Yan <yanquanmin1@huawei.com>
Reviewed-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 0a122a8a9f1c..07a8aead439e 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -290,17 +290,18 @@ static unsigned long damon_pa_migrate(struct damon_region *r,
 	return damon_pa_core_addr(applied * PAGE_SIZE, addr_unit);
 }
 
-static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
+static unsigned long damon_pa_stat(struct damon_region *r,
+		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	unsigned long addr;
+	phys_addr_t addr;
 	struct folio *folio;
 
 	if (!damos_ops_has_filter(s))
 		return 0;
 
-	addr = r->ar.start;
-	while (addr < r->ar.end) {
+	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
+	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
 		folio = damon_get_folio(PHYS_PFN(addr));
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
@@ -308,7 +309,7 @@ static unsigned long damon_pa_stat(struct damon_region *r, struct damos *s,
 		}
 
 		if (!damos_pa_filter_out(s, folio))
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 		addr += folio_size(folio);
 		folio_put(folio);
 	}
@@ -335,7 +336,7 @@ static unsigned long damon_pa_apply_scheme(struct damon_ctx *ctx,
 	case DAMOS_MIGRATE_COLD:
 		return damon_pa_migrate(r, aunit, scheme, sz_filter_passed);
 	case DAMOS_STAT:
-		return damon_pa_stat(r, scheme, sz_filter_passed);
+		return damon_pa_stat(r, aunit, scheme, sz_filter_passed);
 	default:
 		/* DAMOS actions that not yet supported by 'paddr'. */
 		break;
-- 
2.39.5

