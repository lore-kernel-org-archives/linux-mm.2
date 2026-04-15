Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3D55F9D0FD
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 01:21:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 807BC6B0099; Tue, 14 Apr 2026 21:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 791636B009B; Tue, 14 Apr 2026 21:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632DF6B009E; Tue, 14 Apr 2026 21:21:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 47C156B0099
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:21:01 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0E1291A0321
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:21:01 +0000 (UTC)
X-FDA: 84659036322.07.5CED6CD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 65129160003
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:20:59 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CnTw+psW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776216059; a=rsa-sha256;
	cv=none;
	b=jgKRLcZqaUn8g0BmQAbDkh4rqh/Q7l2J3NB0hL5nEUTdbO0DqoVkHATXuDNz9NBmnwRFy+
	Ixd1CicgcWELiHjJDYp0Tn3F+cvgfInBIno85cLwUndf7nmnO0SRDXIVtXQG7RylG49otc
	l7+YYATUJOSLK3XjYziMdND2Lku3fnc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=CnTw+psW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776216059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3iR+Wt7JltJe2WZwHpHwJsZFSfhEa4b1wPN5wX6FPY4=;
	b=7FQlWyMY6X/EtizKpx1h0+31zYyb5XzyA6c1/Sk5lPAKYvIGxPyd35xpbVXL7WDZzZrSiN
	vyrnPalXyN7/Fs6AmgXprOUKMLpcNekAIuUZ1DrjBwTX+5VkjYlHRNK/4jphe5WVXdGBt8
	w8zBBXbilTnjPLBcVgIP/H105DcYvEY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 66243444A8;
	Wed, 15 Apr 2026 01:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20456C2BCB3;
	Wed, 15 Apr 2026 01:20:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776216058;
	bh=N5D6bRH3BZfS+yc275UKlEY8TXSI6Z9gc0T71/W6wpY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnTw+psWl8aAIVYof592X9ltj79ixjRksFlUcDFybT/C6QT2R2sbnm3AxFn1pR3o7
	 OzbY23Ixwq4WX/1PGbQz/OX5w+x0VxoPXNhppwDvNFK3P37PgEjHP/BxYHsbDXDAST
	 U/TW5Wm9RS3HuiaaPtcYlya0QIBrgWWg+pExCZWd52QbUmGH/aYLjh+ekFGKGBSlAH
	 py3vdGmOoFW7Ha48wm9YpXVhnISzH6Btws5rRhpSNK8YKVOt2VlWJWziWeCvUNVkgg
	 /Smgt+0dqFKVUSt+EfZ5F4x3qXV/P2iWuyHqfGsy3ehDtgJ4Kbh18nEIaeEA8FwGGD
	 xTsZRBYdnDSaA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/7] mm/damon/stat: use damon_set_region_system_rams_default()
Date: Tue, 14 Apr 2026 18:20:33 -0700
Message-ID: <20260415012048.76508-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415012048.76508-1-sj@kernel.org>
References: <20260415012048.76508-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 65129160003
X-Stat-Signature: q5w8h9uouk4b1tmmoeiqtwmfmwuommhg
X-HE-Tag: 1776216059-369241
X-HE-Meta: U2FsdGVkX185hSsFCKkmDWPFE3/lbYN3IAxaWYezncC4uemCH0K9cl4BMV+zQKpUXbixqIm567ZDPdTwu8171WuzBjwOtVGQSMJaNZSo/h6gIujPyk+2ASVTG+HBCHaYPMHbsHc9pcvoQ3WAjKWXcBunFEQWyOO/D9k97gEPxsXJIAM5HvEgCeGMC+CcokJOvvzEf4O5Ja3RafhUooZJoEYAlTeUSOjtdeCz9fhLPD047lI0Uq2qMIZxc8ABnTuADxMMaLAh3wmr9LkH1cZ0GyNuro14jMS/M23h0YMbWE9ozGL3r4Biqb8oVSwmiNfWcv/PI3ipJbJgslxcMqxUU4uzCy5AhbAI0EcuUIykzx80Q7de7nPN1pYxA5A5qajWAQG+J6RbQDlOteeuUdyiusj16xradnPq9fS/O8gJPOn/lAPZcb/pUDbV3yvtLyRC4phrBnCA+EYBFmdZz5/FBFpwCJ6b/oMGgo5LJXP3TR0gTtbfXKxV6j7G3GtnNnEIHpmzc1EHYxkljhRhyZx+EXt8Lzy4Bxm7PeDwVgE8sCnCveCZ/FT5mKZ87TY7FJgYnLB+ZQoe8qus7/Hr5LB/hkKc6jiJB30Sur4qLPmpMpevbWvjHP9N+1EnqGnI5vVschz0nUwcK/8D7jCJ79AMPdeO6VGBMntl1dYLHvr/pmGSyA6REeTJE/IDmhmaX9d81z8SnHtB/F+MWDt3qEutfmrOlg3lQG8rzDTKllS6+a4qPu1fTe8yEziiXB3PuMEeuZs0/VfbkWRsaCfk3CU7xMva60/AkuuKYO/MovNjq+QvmuM+3jHz2lIJ//GOUUiVeCoZH9V5/yqIws56ZKkiPiZHyveLUwK9LCSUXNtCAQGVjQQFZGYF3LinbATKvVc3sxD08ATjqjSVDYcrZUHdAuFTyTMfzKQMHKx9nYtuYdM51j6zSBI+RgycJjTk2qJ0ni/Au3AJ8yOGVT8wXpy
 Qf1xBVWK
 mi+KPwrInLFqoIEN4VRDrp2PZ867V29TUWryOirysiVm5zxu+NyXZ4WP+075potmLZyZMaNSBQVW8Tsg8ttSs7aiASzmqZuzk/g75vr0R++U6+XQ8Ze2s5JPtVT/+zLJmnnazqVxuAwGZ+fqHA3fX7CvCPUcY/N/wxEMpYvpcaX19qo1rdSPRrmPGQZ6fUYvM2CHYU/+TTcAeTUVkSx2tjZ0YqLvrcuRn+iiK5f4GCKGN15wmTZWWsI6kb0zq4ldivfgEfWZbQV7trZf9+fEqRWxtJg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_stat_set_moniotirng_region() is nearly a duplicate of the core
function, damon_set_region_system_rams_default().  Use the core
implementation.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/stat.c | 53 +++----------------------------------------------
 1 file changed, 3 insertions(+), 50 deletions(-)

diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 4901e9a7c3398..da2ebf90ef64e 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -154,59 +154,12 @@ static int damon_stat_damon_call_fn(void *data)
 	return 0;
 }
 
-struct damon_stat_system_ram_range_walk_arg {
-	bool walked;
-	struct resource res;
-};
-
-static int damon_stat_system_ram_walk_fn(struct resource *res, void *arg)
-{
-	struct damon_stat_system_ram_range_walk_arg *a = arg;
-
-	if (!a->walked) {
-		a->walked = true;
-		a->res.start = res->start;
-	}
-	a->res.end = res->end;
-	return 0;
-}
-
-static unsigned long damon_stat_res_to_core_addr(resource_size_t ra,
-		unsigned long addr_unit)
-{
-	/*
-	 * Use div_u64() for avoiding linking errors related with __udivdi3,
-	 * __aeabi_uldivmod, or similar problems.  This should also improve the
-	 * performance optimization (read div_u64() comment for the detail).
-	 */
-	if (sizeof(ra) == 8 && sizeof(addr_unit) == 4)
-		return div_u64(ra, addr_unit);
-	return ra / addr_unit;
-}
-
-static int damon_stat_set_monitoring_region(struct damon_target *t,
-		unsigned long addr_unit, unsigned long min_region_sz)
-{
-	struct damon_addr_range addr_range;
-	struct damon_stat_system_ram_range_walk_arg arg = {};
-
-	walk_system_ram_res(0, -1, &arg, damon_stat_system_ram_walk_fn);
-	if (!arg.walked)
-		return -EINVAL;
-	addr_range.start = damon_stat_res_to_core_addr(
-			arg.res.start, addr_unit);
-	addr_range.end = damon_stat_res_to_core_addr(
-			arg.res.end + 1, addr_unit);
-	if (addr_range.end <= addr_range.start)
-		return -EINVAL;
-	return damon_set_regions(t, &addr_range, 1, min_region_sz);
-}
-
 static struct damon_ctx *damon_stat_build_ctx(void)
 {
 	struct damon_ctx *ctx;
 	struct damon_attrs attrs;
 	struct damon_target *target;
+	unsigned long start = 0, end = 0;
 
 	ctx = damon_new_ctx();
 	if (!ctx)
@@ -236,8 +189,8 @@ static struct damon_ctx *damon_stat_build_ctx(void)
 	if (!target)
 		goto free_out;
 	damon_add_target(ctx, target);
-	if (damon_stat_set_monitoring_region(target, ctx->addr_unit,
-				ctx->min_region_sz))
+	if (damon_set_region_system_rams_default(target, &start, &end,
+				ctx->addr_unit, ctx->min_region_sz))
 		goto free_out;
 	return ctx;
 free_out:
-- 
2.47.3

