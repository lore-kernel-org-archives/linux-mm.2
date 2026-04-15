Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 774F8F9D0F6
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 01:21:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 547B76B0098; Tue, 14 Apr 2026 21:21:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ABC56B009D; Tue, 14 Apr 2026 21:21:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2890A6B009B; Tue, 14 Apr 2026 21:21:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 02A7F6B0098
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 21:21:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B3D1DC1876
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:21:00 +0000 (UTC)
X-FDA: 84659036280.30.2E993AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id EEB32C0002
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 01:20:58 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oMrHzTi8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776216059; a=rsa-sha256;
	cv=none;
	b=uxVz65pSBCYQZdmhA21/GgYl0ZDglXU5QpwkY2FXG19N9OW10CeWc9lStp7JNiRlxbhFQF
	Ado2WnhHV1d57Qvn0tDKs3yHZ7tTa034UvW1TRx6FA7S6PeBXxd3ozClKJYG3EVXhqXbDx
	wI+x4oUNqM1aRq4hPJtZIjOf2Dw0OKQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=oMrHzTi8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776216059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aNCAAKR3p83SczFyX8jG3tXxutr8ChJDGbOis6ZBSDc=;
	b=xrFMDVvtYM1TeC75SLsBSFgpZ0FnLmFFDN9nftW0/fvt+Pd4nm4GkG/bZeTViIqJ8zrHM/
	o9Wz0I2xHPWeW7LCIMXlFV9dkV/AmKFRvQlDBaIYtCrYdDErcCbMdE0uD0cflllzA0p/LB
	v6xOT5cVy6jAEBuk513FRjNsmrY9HJI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 150814458D;
	Wed, 15 Apr 2026 01:20:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5D54C2BCB6;
	Wed, 15 Apr 2026 01:20:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776216058;
	bh=x8bXl3PuqEzl+QG+OoYKgf8IyRa9wew4podtKeqi3D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oMrHzTi8vNNouQyMdH3ZOkAv3j0wwweVvEdNKI41DrZLVNbhCIT9jmPJDnD/JXK+/
	 30PpgQOhHTwS7OvwdxHIlvIphHz4B1QHKR3pW56SG4c5/ZO2zj1rBjI/XgFjHXDMFO
	 Thvbx8JtZpJ6W99VJl5uQg6EAkitdmAYCYvb6dURq0UhoZ8KVL92WUK68WCwalo/JJ
	 GTBFb6A+Hl8DEJnjOddgTkqBd2QEXv892+FonCHsvi7TYsJkwxo5Cuz7gTYIfuPpQD
	 yeFPui7fpyYyYr0kEP0b7iVA7PZ0w+5vws9Co4PpBAToZIJL4trYe5LUkMvNBnAgGv
	 bsDP9QWnmzzXg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 4/7] mm/damon/core: remove damon_set_region_biggest_system_ram_default()
Date: Tue, 14 Apr 2026 18:20:32 -0700
Message-ID: <20260415012048.76508-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260415012048.76508-1-sj@kernel.org>
References: <20260415012048.76508-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EEB32C0002
X-Stat-Signature: owngdx3xp54nhybhqchhwe5oxw1bgn1t
X-Rspam-User: 
X-HE-Tag: 1776216058-757188
X-HE-Meta: U2FsdGVkX18eObYbl7EenQLAMy8DcjUc5X4rgIoZ0qqaz9YxO0ppXMAXSubRJZ2T33Ckjd+vKqaBI6TfwqC6/1zT8b7T3WIOrqrTqdT9dOjNJMLEIPEFpR9t0EMq21hC5cXSP65vewA4cH7sGzAWxvPxMD4yGnzsiW+HndWKF3pQQTFMPpENzctgklyyou+A36FuF7uXYrsM3rFbdjRtcbKdu6sD87F7xGl+tO3u+0R7Mvd+ltvjkHbGPefhlUSXTUA275sjeQrrutmXD3+KeP8DhxRbftlYbWHKGEICF6n3ha0mGknu7sbEj3Oi/KZlNT0QRmxnsShFPdGEsejxNRppUEhZ9NpiVccpqohE0eTiLsC6ftILbTkVg9Oz+ODIO511sBqo+Wm7t5o/LNfwuHmapdAMKSudsi6nWxfA/GCrs65ExXq0S5c0XAiORHsdn2lGKZVQzidrGL7XF3KrM9YA3ztkm677W3e3c/Z7JWqG8mqIT2FUddJpKP/0eGNI3Z53qXHdeCuQUiOPgm8iXlGpeOyDJhZQiD/qnz/ceG2OTd+sTE+ZGYelIHf/ayXeLrlb+4L6VhXXrdauM8fYxFAKuQR8F+6Qd3ymSDJeW+tV47iPjJsiqOxNO5bvkEDew2TxAxZ+8HdTPZvaBspb9yxYmvv6bZ9HLxKgWDm156t00SMq+SzFydfekbvAZy9Wk8M42Ym5Vl76OPV5x8eQfclRfZTrWKIzgYg6xYVhpMGhVjpImvefaTPYEf6Pj8/E+sLlFaNL0y7sdAvLdq2Ynou4dHwDXdgLzraaPE/K6rwCmN7WkQFA7FDFEK51RfHhmkwU3+6LPnPvyM4WcprqUXMB+jfhmh/4mS7qVG96TmSWbwX9y7Vzl2RQ1GttU/9M5M9SEsOiade7JcQeabH3mBacMG4l4dBI9BG47Jr0gCf/Usl1n9WBxZDyso+X5ejwt9Wr/eIJrTV1cBgVnuO
 WzBeybzd
 YTsToWQO+WEEExAgkI1qeg5T8Qd7/00fNZyDzXgROqBaVznF+YKkzp/IZBsSq6LKvHkWRpONhaAokPJ8lwCmcbcGBF+cxLTBRikKaP0HgBvJhl6biCKe5b9IznPlgbf2Y3oqWAIyS7O7UDKhd5RCPA5q0qyYjyaKn54DGJ3hsun22dq+CrkXQaqpmWW84i4WzZqDSiY2G8y4GmX5e7iphH11nY7FT3tnclx3Xre8ZkeVFq6k=
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
index c4cdaa01ea530..1a4f754ad89be 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1012,11 +1012,6 @@ int damon_set_region_system_rams_default(struct damon_target *t,
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
index 3cef74ba7f0f4..d2c8c088e7451 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3266,70 +3266,6 @@ int damon_set_region_system_rams_default(struct damon_target *t,
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

