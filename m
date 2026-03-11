Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E9BBFCC9B0
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 05:29:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3EF106B0092; Wed, 11 Mar 2026 01:29:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 387096B0096; Wed, 11 Mar 2026 01:29:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C91D6B0093; Wed, 11 Mar 2026 01:29:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B67776B0092
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 01:29:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 680EC1C8D7
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:29:34 +0000 (UTC)
X-FDA: 84532654668.16.5BBDE44
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id B103A180004
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 05:29:32 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MHV8bgoP;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773206972;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEcuHmfq2TEGyGnHx1pqw97JQaVHG35cqqvqSTlIPHE=;
	b=EufNd2vITPRkQr30d7es1+8w1JDFffPsku78crwBWvkjZ+fWUxWVCf8/5KF3FdygNu4qcj
	cnjRdzz2QEXmGtdsRKBlk3TUO5ACsA6Ve3DS/BYxh2eKTo4cgMP0AbeduTOptheyHZseNM
	G8OTSVr22g1LJQm1sB1+B9pF3LFNzqI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=MHV8bgoP;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773206972; a=rsa-sha256;
	cv=none;
	b=5RXq2ePH6T2WwEcbPbZ2B2FZqsAK5f08h5drpq1vbDZItTWSeuV6cuINLuNNcc+rbH/67q
	1KE2uJMxSLGqWT1WkdSexhR/Gxyqs/BpclQHMO0FhR64uQKljY3lg0HfibG42MraplXcTQ
	85yqmMRaUrHuLnBhzczZ9v/aqO7OjAI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DA2434429E;
	Wed, 11 Mar 2026 05:29:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83E2C2BCB2;
	Wed, 11 Mar 2026 05:29:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773206971;
	bh=kid8+DV+15MxZOJX+3t1IGU6wUDJNNJXItme1YWcb1M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MHV8bgoPLGkg/C+8Std46vK90hCsqe8haO2pX/KRjAmTqvPnjiHvIPENmLmfScqRW
	 yE/6CpcuHS+fcq374PZqPPtCsTZbuix9yONjFn9id8mMxZEOfacWjRTijwvVKAOU6Y
	 epb2/JASZSGFYXXHQoYT4v9OoN5EqTSM9Zd8CGFlC2TLllKqGgh/8wFG+kSJZs78rN
	 YwG8NDS+Ly8pNlHkWiqq47Lr6Ws7xHNuRjH7PkJObMnuZHidizHI9ek2HK5kS3QMoF
	 7YPyyS0yBSnpn4t6rrwpPjeXPhMBQCflKrBvIeccLpBV260wtqN3PX5Wh4s5wu8xU3
	 dEAJGf+bWzk3g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 3/5] mm/damon/core: receive addr_unit on damon_set_region_biggest_system_ram_default()
Date: Tue, 10 Mar 2026 22:29:24 -0700
Message-ID: <20260311052927.93921-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260311052927.93921-1-sj@kernel.org>
References: <20260311052927.93921-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B103A180004
X-Stat-Signature: udkjq7f57ck5191euzbsetnpaxtkiswa
X-Rspam-User: 
X-HE-Tag: 1773206972-905345
X-HE-Meta: U2FsdGVkX18sqV0KIJvv59TEstzlfhqiB8xZT4MS1aBB1ZMCINaFHCklhKaAuW+gXWK0Dp/P/+C3C6XU5xafMnkfcMXOgFQnouC8oeoFOksJWZ99zIYWuMrktuhKl3Qgniu60VOQLGDGdK/AoTEDlQGV5kxzKzAl4wZwtuf5ZmEQGAgyNtDWHjFDkpwqUs/UWU0UHSn6lDPFJM+Md4UoaVrAkHQfLvnfMaGvzWtoDWT7gs9lOqQou79rTDUi54OTfRkgbz/wYJZUw2ydqGRy3ig6ZwWpijrm1AS0evPQO3sCMneXVPbrMCgojNNVUuaXl8Vmm8DK6SoUMmKQ0Krm0RO4vSKPWwplooqch09KBZqHI7+ls9NXFt5iDT6qxil3t0C146Kcy+JX/OZZfCrrO9QAvD2TU0BH2zNvNe6rvnMOu+6xwge3JklTCYozO2FwZPURvn98hH5KbCMU6mH0qnJqdrAZ4sNjocQcEsfXTuWaB2uVbHNe9SeRRxF1abMJ4SLxd+bAMk08U8TBUnrjOH/IyjB05cvC1UolyddPeOXOFC+Act1i83igtIdsVR/5K+nsTnQKH53IUqDVCAvIsWGN7IyNvtP8rKd8Xc+RmwIZ7qcV4HHoAi3qxbjNcGfxNs3HmaUNJty0oPt6IvdMxd7vRu1XOqGWDwYuEUiQ6TziahZ5Iah+lFGXwuh9zCWVUBOUwjcclFHxJbFNnoHsnIFn4iTUH3V7tfI8qAuNV+sERSp4VBp9AG4FvwR3tN4438r6IBCVFavJPnZJJvMA9bNhRUEymtXpWDfYa6QJSQwHFqHsrZCp4Y/Lr1hVTFklxWagyyy70AJul4GMPkLE9/Dn+rhT06aE5u/6nHcON1+/b69FRoTY6tammXWGhz7CwGSCPCB0wafeqHQ9ESEFL1NskD566IcldafE69nP0sa95sTYudm/rXe/YAyBNXsIZdU3kmVAnCEYBUvfj0O
 1KkXU0I7
 iRw/kYSHNN9k8iKkv2Wu0RUpFMl1JfcT1pg2YgSZ+iGwH5gzZrmsQiXvyWJXz95QWcyBIu2VAVjIb7a1M6it0Rw/7UoU7ln6qP469lOrcGD/99qdfssG+7j2T8LU7DKzz0lYCTT3Kl4KTaWGwQb89ohF/LqArgLganQeXRk79bSt63rskMk786DtE3a7doG81/q+cs4wDHh66xRE2M2MdwsVpUg6IEtJHBjkT3UkYiVCE2Yr2ruvtXHGgGtSqxUuVpN/2/4yO5BLGEP1iHXL6O7wnjmQrYwHgPNg40TuPSLBQTePsZjv4blyCHA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_find_biggest_system_ram() was not supporting addr_unit in the
past.  Hence, its caller, damon_set_region_biggest_system_ram_default(),
was also not supporting addr_unit.  The previous commit has updated the
inner function to support addr_unit.  There is no more reason to not
support addr_unit on damon_set_region_biggest_system_ram_default().
Rather, it makes unnecessary inconsistency on support of addr_unit.
Update it to receive addr_unit and handle it inside.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 1 +
 mm/damon/core.c       | 7 ++++---
 mm/damon/lru_sort.c   | 1 +
 mm/damon/reclaim.c    | 1 +
 mm/damon/stat.c       | 2 +-
 5 files changed, 8 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 1130c2f9a92f4..3a441fbca170d 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -988,6 +988,7 @@ int damos_walk(struct damon_ctx *ctx, struct damos_walk_control *control);
 
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 				unsigned long *start, unsigned long *end,
+				unsigned long addr_unit,
 				unsigned long min_region_sz);
 
 #endif	/* CONFIG_DAMON */
diff --git a/mm/damon/core.c b/mm/damon/core.c
index aee61bf991baa..d4f86c20b4f48 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3103,6 +3103,7 @@ static bool damon_find_biggest_system_ram(unsigned long *start,
  * @t:		The monitoring target to set the region.
  * @start:	The pointer to the start address of the region.
  * @end:	The pointer to the end address of the region.
+ * @addr_unit:	The address unit for the damon_ctx of @t.
  * @min_region_sz:	Minimum region size.
  *
  * This function sets the region of @t as requested by @start and @end.  If the
@@ -3115,7 +3116,7 @@ static bool damon_find_biggest_system_ram(unsigned long *start,
  */
 int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 			unsigned long *start, unsigned long *end,
-			unsigned long min_region_sz)
+			unsigned long addr_unit, unsigned long min_region_sz)
 {
 	struct damon_addr_range addr_range;
 
@@ -3123,12 +3124,12 @@ int damon_set_region_biggest_system_ram_default(struct damon_target *t,
 		return -EINVAL;
 
 	if (!*start && !*end &&
-		!damon_find_biggest_system_ram(start, end, 1))
+			!damon_find_biggest_system_ram(start, end, addr_unit))
 		return -EINVAL;
 
 	addr_range.start = *start;
 	addr_range.end = *end;
-	return damon_set_regions(t, &addr_range, 1, min_region_sz);
+	return damon_set_regions(t, &addr_range, addr_unit, min_region_sz);
 }
 
 /*
diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index 7bc5c0b2aea3e..133ea17e258df 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -345,6 +345,7 @@ static int damon_lru_sort_apply_parameters(void)
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
+					param_ctx->addr_unit,
 					param_ctx->min_region_sz);
 	if (err)
 		goto out;
diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 43d76f5bed449..01f2f6cdbcdfe 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -251,6 +251,7 @@ static int damon_reclaim_apply_parameters(void)
 	err = damon_set_region_biggest_system_ram_default(param_target,
 					&monitor_region_start,
 					&monitor_region_end,
+					param_ctx->addr_unit,
 					param_ctx->min_region_sz);
 	if (err)
 		goto out;
diff --git a/mm/damon/stat.c b/mm/damon/stat.c
index 25fb44ccf99d0..f9a2028483b05 100644
--- a/mm/damon/stat.c
+++ b/mm/damon/stat.c
@@ -181,7 +181,7 @@ static struct damon_ctx *damon_stat_build_ctx(void)
 		goto free_out;
 	damon_add_target(ctx, target);
 	if (damon_set_region_biggest_system_ram_default(target, &start, &end,
-							ctx->min_region_sz))
+				ctx->addr_unit, ctx->min_region_sz))
 		goto free_out;
 	return ctx;
 free_out:
-- 
2.47.3

