Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D269FF8867
	for <linux-mm@archiver.kernel.org>; Wed, 29 Apr 2026 04:13:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CE6A6B0093; Wed, 29 Apr 2026 00:13:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97EC36B0095; Wed, 29 Apr 2026 00:13:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 894E06B0096; Wed, 29 Apr 2026 00:13:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7DD216B0093
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 00:13:26 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 06C08A08B8
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:41 +0000 (UTC)
X-FDA: 84710272122.03.8E984C4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 56C5A1C0008
	for <linux-mm@kvack.org>; Wed, 29 Apr 2026 04:12:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=On4DAleE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777435959; a=rsa-sha256;
	cv=none;
	b=f5Gx0Sdq6NUblArwz/80B9r/IUxBgn5PRPVwbcDLoe7eYkLvYtcO4epGUnTIbeJZ42LHZQ
	VvtURl9z6e7X4GKDDP9H8Za4ZHNbD+GgZQ6Ln+AnfVxOJesXCQQzyScaSipqDAHGra9EQ8
	ZUU2etSkumAp6AW4S5a4jAk8reLlc4k=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=On4DAleE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777435959;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a0QWU8FcJCJiMnEQirUceIVMc+tBT2yEJRa8nvRmAr0=;
	b=itRGCwmm5KS5C59g5E04IbChfaEgyQvVJXzcBZwQppFRoGJSoMTPVCV0lNK6t6BpWSGdue
	DPkpWoyJj7ZZcYNbhHzV8dMSr4kXCho6LauZ30uqyj9cEjVrng8p9OCGHIesKROSwxGmDb
	TXgFvHuDv77uKDQIWQLrWb2hDq0odjE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 873D7444EF;
	Wed, 29 Apr 2026 04:12:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40239C2BCB4;
	Wed, 29 Apr 2026 04:12:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777435958;
	bh=8jYx8KZ5p5GMU2eOGfXvJCf4Ua/nksXozWCmG0l4E4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=On4DAleEvzEblzRF0MfZsJJfDsA5lc6a6VvbWctwBhhMaR7JRPPqOwfKLyoKtTl2T
	 aONJzcB/oXaoUjqOxrTAojdkxjdwWOULDFXcC0Mw2KmVFLKWiaVV+sca6oTM+BBY+N
	 Q1XYQYzacmH6KI9j8AB3l1VApf6Vm+oeQ3bMs73ZGkkXbyhFJFeWa5bWFg+5dHH4N3
	 vcNSrxC6u6TGv+CPF5bTImH82jucZWOUcycziOI6/d6BSuHxXT3MmP2P/sIrLEarVW
	 719+xYSRV+31RrlCvNdc9mNSoJsJAuvrJqCUWkbAdJWDBZHEAMjnOcmnvoWXxHVqia
	 zZXP712hKTrtQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 4/7] mm/damon/core: remove damon_set_region_biggest_system_ram_default()
Date: Tue, 28 Apr 2026 21:12:26 -0700
Message-ID: <20260429041232.90257-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260429041232.90257-1-sj@kernel.org>
References: <20260429041232.90257-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8as5jzu8usx5iwkff8to6uqypmdzmunb
X-Rspam-User: 
X-Rspamd-Queue-Id: 56C5A1C0008
X-Rspamd-Server: rspam07
X-HE-Tag: 1777435959-33496
X-HE-Meta: U2FsdGVkX18qoUC6MiY7E+87oEyucYNR8YBkzI/r6LetwGBY5WknjD0VGi1qrDg+VQ4684iD3QUCkwCidAtinh1HqY+AFACi69Ey6MkwP5Y9R7pqrvzGuLT/Lw5xt2DmHVDhz3jJonVJ2N18x8/zccZN0X8zamaPrOkj65fgp9wXA1vCAN/JY0NmDJfkusa42abECtsxoJV5RSFGwck7HkFXB8YWhNqyx50ULOT/tOT8fQHdPPl761/ZlRwaLXrdIlhHWNC7yRLq+5g6XlFIrse2E3gMWPBLp5nvRD1dBCq7ubRVQ1m+psPU4f9QC4Ozdnm8bAJYjnQMvxHFQJcYH7AfK57WJYhft8o0rE3UxD2W8WPaP+2/sc6ImEjAGNwT+4kXgr319Dzrp8YSvlGossO+YOXHeHjjosEWQa9m4YUKW8MZ5mqHmVUKLwDznoJd25esObY3OKbt4XuRWU/8tdU6CMjM5RjTkw36FXRDUhpszhoVoGvW0aofJ/PmoN0pO9Aqx5PFKTRF9VXV4Prp6ueChxmlEgcZE/qSn9FF8Tv3u4qNkZX5yf0CeIoWhfMSWjBuZOKDLHYCsmkeMloWK32MG2Gi4B4VrO67qh7MCPvZ2/kmI7K+KsBcwPy1nC5+Xn+YksmUx3ygXq1np793wds3uESYiMDZnig40EHzaV9ZgKD6ZmTWlbd1bx665WpD8o4vvCe4DKWW0hm6G/jCOQ92AAShssCjvUZ4FCGAxm1Vi6jtc3ioXWSoRCLSBCLiStw42Q4rG9CHc9KfmslrFF2e1u9e85PR0/rgHxjms52dQCsKUDuUH+hZvXxJ+A9ZY8vYN1lfxMtRyUrHtRRxvpQ3XvozXyUWeRavK59X/1VKZ8HGxek6IiKirX6BsPWrT8GYeejcqvh8SksykVMPlVD3oidUU3FiICHB1P7JCF6K+2Nfbo6C3ve9398wWKF5p8QAIo/dGaOjNfnQwVX
 llqaXGcO
 jB/h+99BfquMCKENw4zBtPG5CF8YCTj586bXwGDxMznSUi06ySJau8LawCHhnYPaKZGtb//5/TF59olcFp1rFRdTzbIIAxAXjTI7Q+F9kpHWaJrFqKDl38EKVNo5uILM9JKNw0omxHk1smEVNbnvyDbDCbakr48+PO99ECygvRRNfzPomi3wZ/hWLpY1uLbgJyM8xHEmgJgNjU2ZJ40NjYkjsDPDNzZzJ89Onkk+AsFJ2H8xGdKTg0vj0Ag==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now nobody is using damon_set_region_biggest_system_ram_default().
Remove it.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  5 ----
 mm/damon/core.c       | 64 -------------------------------------------
 2 files changed, 69 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f656908b2d389..c7a31572689be 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1015,11 +1015,6 @@ int damon_set_region_system_rams_default(struct damon_target *t,
 				unsigned long addr_unit,
 				unsigned long min_region_sz);
 
-int damon_set_region_biggest_system_ram_default(struct damon_target *t,
-				unsigned long *start, unsigned long *end,
-				unsigned long addr_unit,
-				unsigned long min_region_sz);
-
 #endif	/* CONFIG_DAMON */
 
 #endif	/* _DAMON_H */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 980a31cd3498e..9f38deddcb30e 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3408,70 +3408,6 @@ int damon_set_region_system_rams_default(struct damon_target *t,
 	return damon_set_regions(t, &addr_range, 1, min_region_sz);
 }
 
-static int walk_system_ram(struct resource *res, void *arg)
-{
-	struct resource *a = arg;
-
-	if (resource_size(a) < resource_size(res)) {
-		a->start = res->start;
-		a->end = res->end;
-	}
-	return 0;
-}
-
-/*
- * Find biggest 'System RAM' resource and store its start and end address in
- * @start and @end, respectively.  If no System RAM is found, returns false.
- */
-static bool damon_find_biggest_system_ram(unsigned long *start,
-		unsigned long *end, unsigned long addr_unit)
-
-{
-	struct resource res = {};
-
-	walk_system_ram_res(0, -1, &res, walk_system_ram);
-	*start = damon_res_to_core_addr(res.start, addr_unit);
-	*end = damon_res_to_core_addr(res.end + 1, addr_unit);
-	if (*end <= *start)
-		return false;
-	return true;
-}
-
-/**
- * damon_set_region_biggest_system_ram_default() - Set the region of the given
- * monitoring target as requested, or biggest 'System RAM'.
- * @t:		The monitoring target to set the region.
- * @start:	The pointer to the start address of the region.
- * @end:	The pointer to the end address of the region.
- * @addr_unit:	The address unit for the damon_ctx of @t.
- * @min_region_sz:	Minimum region size.
- *
- * This function sets the region of @t as requested by @start and @end.  If the
- * values of @start and @end are zero, however, this function finds the biggest
- * 'System RAM' resource and sets the region to cover the resource.  In the
- * latter case, this function saves the start and end addresses of the resource
- * in @start and @end, respectively.
- *
- * Return: 0 on success, negative error code otherwise.
- */
-int damon_set_region_biggest_system_ram_default(struct damon_target *t,
-			unsigned long *start, unsigned long *end,
-			unsigned long addr_unit, unsigned long min_region_sz)
-{
-	struct damon_addr_range addr_range;
-
-	if (*start > *end)
-		return -EINVAL;
-
-	if (!*start && !*end &&
-			!damon_find_biggest_system_ram(start, end, addr_unit))
-		return -EINVAL;
-
-	addr_range.start = *start;
-	addr_range.end = *end;
-	return damon_set_regions(t, &addr_range, 1, min_region_sz);
-}
-
 /*
  * damon_moving_sum() - Calculate an inferred moving sum value.
  * @mvsum:	Inferred sum of the last @len_window values.
-- 
2.47.3

