Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DA04ACA0EE9
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 06:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4D8658E000E; Tue, 19 Aug 2025 02:18:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 489468E0006; Tue, 19 Aug 2025 02:18:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3C6568E000E; Tue, 19 Aug 2025 02:18:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 290808E0006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 02:18:32 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C3BD9B7793
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:18:31 +0000 (UTC)
X-FDA: 83792502822.08.C70DBE8
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
	by imf13.hostedemail.com (Postfix) with ESMTP id 28CB120006
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 06:18:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GGGjXeQB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755584310; a=rsa-sha256;
	cv=none;
	b=sRUP6y4rwFCcygQuX5x5RNZqcN2/F6sTv4cyMOqpV/1/e5UuMDRMc840uoWBkBhGs0GdmH
	wREA8cOsMvNPW1He1yy8DFMsY0SC3mOOvM4itgvLdnsLmvQQs/G4S5m5jFsibaHIrjwhgw
	ykWdUaoUsTKuifrOH3Hs6eUnG6RFVDc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GGGjXeQB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 139.178.84.217 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755584310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t4oq6mxq5kMQH7fiXuAgvyTrsr4O4g54Q8O3r7+0Xuc=;
	b=hO1enrdseTbCwwU+C4W0m6kXk4UjN5c/0YlgwbZ3/rxhD44HQwWM/b+EVXBbppk0uW2hRD
	CaqFwPeUmBgUdNd1Cm6vdxKAPGwfasyx1chOi7DFvNPpDXK6+qzAeBbLE18Kzw8qwHjNQT
	Fybicbx6aFCSsEH/GuatB3RiK+hSDkQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by dfw.source.kernel.org (Postfix) with ESMTP id 415235C58AC;
	Tue, 19 Aug 2025 06:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFC00C4CEF4;
	Tue, 19 Aug 2025 06:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755584308;
	bh=kBVuR1PC7Mm2y3ndvKGuUlyCPtizn8ZDSFX5bYFzIZo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GGGjXeQBZ6NMFAnzAMbGQ+qrRsVpc0/JMtGDrj7+0D/g1U+HgbYN3n1WPBKBTmAFw
	 +tGOfKzLlfRy1hZFhQ7A+Al57sUboQ5dLLFpV+oI5IbIvbxniBWtDCC1wygEaSgTPU
	 klpxXSNm95+v7gr00OwQI+hfEgixata3sxMarlc6ooX6Z4nMVMB5aQMM8QqTt05obg
	 hrlc8Rh3j5gjKhgZUeCD5nylk40Nd0cCXkdze8hf8LolaVh0ir1tn4Bis12t41UzLE
	 IaVJJnrv87lxtZRkJMkINjQEtKfVDn8MGFFNGc1dLuERcRRTevIAt/VzhsFz0nsMjx
	 hEtQIePJmgBKg==
From: SeongJae Park <sj@kernel.org>
To: Quanmin Yan <yanquanmin1@huawei.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	wangkefeng.wang@huawei.com,
	zuoze1@huawei.com
Subject: Re: [RFC PATCH -next 03/16] mm/damon/paddr: support addr_unit for DAMOS_PAGEOUT
Date: Mon, 18 Aug 2025 23:18:26 -0700
Message-Id: <20250819061826.39289-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250813050706.1564229-4-yanquanmin1@huawei.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 28CB120006
X-Stat-Signature: 87jdxux4ws4paotnd5naixdkudckok8m
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755584309-666981
X-HE-Meta: U2FsdGVkX19bAJSwmKQfjQFpJnm8jOoL0CiWrgEIoYUT3m9TlA08roIDgmdYwfXydaxOUuzRORK3xrrSEr/JiuTV6Za/UMGyR3YPQd7+EzSoz9nytkGe5uInLO0S+KMnIGag8PUmTh5UcaAdXgdACRzx77tZK0DcooMrp2M3ki9Gf4yY+4LaphI4C9fv4qwqMWfsncjmkuHwhWWrKOcvBcnFzSIppoD/FwnM0ETXsa4A2a86PnzOETuwYWyKFpdRK/1x8ceGJ2vW2MqRKGWYzbeXeK44QhlicGXGHyka8b4Lv9euP64hkreLRw339etXc9uM2BUe6ju/4WkOx6988iZpFdF/sF8DwKDiO665DPrGOYXBBwdM974jkbs0Pcp/D2tBfrKMc7VikGKj2fZj2xC5z7iC/PCINOB4YlS/Qs6VVShwT1ncc6AkOM+djaEaF+XYe9/f/8np32e7HBwkcGrBzR+e/WtfIdSI5zqj9/hUEFoKbt7eRPcXV2Anw7OhFRlg8xDs/QefU1mZK2O9jE6LSqeiZAwHA3vNS997Bz4GOdC9YBp/WPqK2H0VLfSVQLNR1W8dUNQJKgBDVunI2dm8khTmO796CT/8uD2ICUawbc5RSjNrBcfnQPpuTGjFkhd2fqGk0GTgCGNXjHodY44D013JjaamwmICxLdU3KKbP13jvZkubBcAiVKQjthspf7QW0VdKoxlqXbcq3H/0lXejMA/mEJXoNkoscj7nHBTEYUovFKm/uwYJVVj2jh8ufKO7vITaTY2NMAkKKHcbBuntfiYO0+/aPrYPQlLzLvrjKfIyxYWqng0xKz079X9+6ongl+ztcWdgmOsGpIRqQJfdC6RiMDUcX58vccqArfl4cwplE+rs5xeszNpRjAIM05rM3hWFu3vOkxXNXmwalocKEa8YqPr0Xc4/tJZiXDKxiGJRsRZKjj6tPVc4lNt9ilf78TbGsqcfPu1OfE
 SIJaNd8X
 W24i6dzECMvjbYm7kVYM0UBxeCCrycSmHe6lRJ+g+WiA9nqBbTytiZ+M31GjTI77zzM3XcL0JGi8Px9cDE2QLn9xMONuIaP9e0yFC2SPZPuQiVPA8rHjqOH4NfKpbzoOZIVZ/rbGz+nWSA2yxWnhgKfwTuywgaJgJUi5rAxB0lRSbN7bWfYXk+nrT24+LrOvcPAsgIm+PZ2+jOoge7XGh/DuzUZy3I3ByuwOsl1cJcxybR4u8Bdt2LjQNIVq0VLKHrliqWcyxrhO4BXHMDZfFQN1EeRLsV3nTrtAFPme55isXINJ0uhHZiO2UeqrddGK4WIQc71l8fZsGP+rIn3SKDHcAHg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Quanmin,



On Wed, 13 Aug 2025 13:06:53 +0800 Quanmin Yan <yanquanmin1@huawei.com> wrote:

> From: SeongJae Park <sj@kernel.org>
> 
> Add support of addr_unit for DAMOS_PAGEOUT action handling from the
> DAMOS operation implementation for the physical address space.

As I suggested on another reply[1], please squash attaching patch to this one
when you post next version of this series.

[1] https://lore.kernel.org/0001-mm-damon-paddr-set-DAMOS_PAGEOUT-stat-in-core-addres.patch

[...]


Thanks,
SJ

==== Attachment 0 (0001-mm-damon-paddr-set-DAMOS_PAGEOUT-stat-in-core-addres.patch) ====
From 525b3d1d9dd53f4ca6b4d2254e5cc7f99c8eae0d Mon Sep 17 00:00:00 2001
From: SeongJae Park <sj@kernel.org>
Date: Wed, 13 Aug 2025 21:24:35 -0700
Subject: [PATCH] mm/damon/paddr: set DAMOS_PAGEOUT stat in core address unit

Operations layer should set DAMOS stat in core layer address unit, but
paddr is returning that for PAGEOUT in paddr address unit.  Fix it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/paddr.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 98cb6930c183..826c2064dbfd 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -139,8 +139,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 		unsigned long addr_unit, struct damos *s,
 		unsigned long *sz_filter_passed)
 {
-	phys_addr_t addr;
-	unsigned long applied;
+	phys_addr_t addr, applied;
 	LIST_HEAD(folio_list);
 	bool install_young_filter = true;
 	struct damos_filter *filter;
@@ -172,7 +171,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 		if (damos_pa_filter_out(s, folio))
 			goto put_folio;
 		else
-			*sz_filter_passed += folio_size(folio);
+			*sz_filter_passed += folio_size(folio) / addr_unit;
 
 		folio_clear_referenced(folio);
 		folio_test_clear_young(folio);
@@ -191,7 +190,7 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 	applied = reclaim_pages(&folio_list);
 	cond_resched();
 	s->last_applied = folio;
-	return applied * PAGE_SIZE;
+	return applied * PAGE_SIZE / addr_unit;
 }
 
 static inline unsigned long damon_pa_mark_accessed_or_deactivate(
-- 
2.39.5


