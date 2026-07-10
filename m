Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B6007C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 13:47:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0746B008A; Fri, 10 Jul 2026 09:47:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0127B6B008C; Fri, 10 Jul 2026 09:47:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6A2E6B0092; Fri, 10 Jul 2026 09:47:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C78CF6B008A
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 09:47:03 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 70FDEA045E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:03 +0000 (UTC)
X-FDA: 84972993126.01.391A14B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id E0E6240002
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 13:47:01 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kN6RGv2k;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783691221;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xQG5oz4wU5m7lLv6nGv8jRYxqbEgbwiFogSXia05QXQ=;
	b=zJmiqroYRRO9Xb2905bAzzd9eaF22znRHUrKb8V/RIF4cN2/Y+GhPeUJkuKt5Tvq+h+dwS
	LY51vr0wjJIMNwZOJWBnz6HGwXawVggtyd4rTFiiwDU1ACd3QUDHFCokTdr0b+dFiK+H0h
	PBjpi0jb63xx6Xr1SNkOWM/5yaaWuzo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kN6RGv2k;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783691221;
	b=zQKqnhczxbvRpvJfXkmIIowH9nR+veAcQXdsdlOnhi5LiKztXgLKGrDvoIWGzVYvjo9CyF
	R0/KDtK0hnPlt6xODSkUcMFBElCAf7/ar1Mo0G/oHgBCGPZNkn+/EUEm+rZ33r1MFi2yNQ
	zpR2C9VAQBn0GzVko2CRF3GFw2wE/5o=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65BD8600C3;
	Fri, 10 Jul 2026 13:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA231F00A3E;
	Fri, 10 Jul 2026 13:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783691221;
	bh=xQG5oz4wU5m7lLv6nGv8jRYxqbEgbwiFogSXia05QXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kN6RGv2kBQYvnluj9kSRwWn/4/aFEUj7Z34Y5X0eVd8qUpPGhMFyuNQevNjFxixuq
	 Y0zPoQw6R6zx43FjqD6+qcXi8jeiqt1a1sm+xtyZ9RAVshdkUwV89cZ4/Akv08x3A8
	 2v2bBTzt7McA7oODOjPbzvnh8vT7wvuoIWfuV0yf+mQ7utlCKHxACrAzcWQgIV1qAb
	 KDDBpgowGiofSckyaaqZ17kLHwH/N7zQ5Sd1KiqYra/SDZejcY2UiL/nsYggVSMyen
	 mPn+ZPygaxFS3V0gTcEmYTtiGzyOpLZAQ3jHs2fMGZbygdnVOl0B7dBpqxKBDCv2VX
	 5Hdsh6MN88BVw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 02/19] mm/damon/core: ask apply_probes() ops callback to set sampling address
Date: Fri, 10 Jul 2026 06:46:31 -0700
Message-ID: <20260710134651.18084-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710134651.18084-1-sj@kernel.org>
References: <20260710134651.18084-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E0E6240002
X-Stat-Signature: xfm1yii8t7asxe6sd9fjzin8ykc4x83o
X-HE-Tag: 1783691221-606050
X-HE-Meta: U2FsdGVkX1+a6b3NI9U5W/YPJ764yQnKyu68pHM/ykHAO/r0yzOJ5vXsnn7xqUNK/TTB3LyYWUx5O5wf8d3fYffKxKs1Wwk9M23tuS25YVnPbrjIK5MG+SXzC+39VwdDqVIFV48eVihcU5wkTo09a8YP5166Q020zGYFx0Bd5qkr/xAxY+Fu3p4j4zzgmi1OUMGnayOXW2WdT3w0PVZt2Kr9FhvLKYITVyIiJLFt0wxkD4CHe12pAREgT/L6euGj2CCZ8BIubjJhTvhqFu9XELe4aFnXMwKSefWkl4xrfus8xTkpCXZpkO86rAgfdlzB4TzljjEoEYUJucC7rQccCAps62gvqyjUULKkRxPnarFQmR9iCWMTPUpqL9x7gcpJfi+W+V9bRBY3oeMW1JgbqkADIPzlkyx6OkQuFjHrq6xrsrOSvRpQBnnnb+NsraUign+6LizHxHdtYnRs7qXzvLJ26oNh3arLbdySbuGSOUVxLmzVcQM745RFmyer2gLkjSQNMtb7gUib8HNTOmYbHKF1oQrl4Gly4s+zFQSJmIw0XAUrqgA034dq2+8Am1ms7WE8TUv/cQBq46FJOevMFEFWzWxYEXCUDhlqSJdwC+AXPXREq/o304+iVdemh9d6lCKN+/pG2VZ42AIQ/Qu01OYygtozOGY+qXkFq417MI78VwBnEs4Rdm/+cmJ97xW3OoQI+t+TMHkszqrcJozf6zNViqPLAAmR7DP5WUYkS1Cds/HYC+UjhxzfoEwemyZw1m9FaI6prClcJZRNN6KED93BL3b2W0Vtjd6PooPNW/3TxyWSueA4Of8/KBaTLIl68ruCLw36BtwtOVaKxOfiyzYkb/Pbsq6kHnYTTEz+pTY45W3dH4pjKePabDl+oRcuEpAw0PIyeYwPKbRNmbt2Kxaw9iRFmvlpTJPrCuW4rMzsCXHCDLytLP+BJ7qpDlpdZrMnfPeUX4qPylzdwai
 fjhC0u6+
 5jZ87NjhWwdx5jSg4aO9aGM3i3qZW96PZMbXcjl3Y//6aYHPBS1vjAcfWssz4RKMtG54TvO3lc4lJbdvXQEeysCZ+VM6QieL4sudspOyvU6qEPPng4IMH4GU7BhVF4OAvM9iEwteOw2vLkld4LmyF9n7h3idybh2Oz7QFGxd0HXxWUcdrRL7L9Y9QDG7xDUllOrtXvfymPuTeecsLBwE+iFv8BkeMRX3iyqro0xbDmNAksyzO+xHW0qETT/iQSB97StQiIycuA3PKdQHQcSWDeJspNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

prepare_access_checks() DAMON ops callback sets the monitoring sampling
address per region.  In future, DAMON will be able to call only
apply_probes().  In this case, applyy_probes() may need to do the
sampling address setup, to minimize unnecessary regions iteration.
Update the protocol for the request.

Signed-off-by: SJ Park <sj@kernel.org>
---
 include/linux/damon.h | 5 +++--
 mm/damon/core.c       | 2 +-
 mm/damon/paddr.c      | 2 +-
 3 files changed, 5 insertions(+), 4 deletions(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index d8251c83e6e55..aee28b05acc6c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -647,7 +647,8 @@ enum damon_ops_id {
  * It should also return max number of observed accesses that made as a result
  * of its update.  The value will be used for regions adjustment threshold.
  * @apply_probes should apply the data attribute probes to each region and
- * accordingly update the probe hits counter of the region.
+ * accordingly update the probe hits counter of the region.  It should also
+ * set &damon_region->sampling_addr of each region if ``set_samples`` is true.
  * @get_scheme_score should return the priority score of a region for a scheme
  * as an integer in [0, &DAMOS_MAX_SCORE].
  * @apply_scheme is called from @kdamond when a region for user provided
@@ -665,7 +666,7 @@ struct damon_operations {
 	void (*update)(struct damon_ctx *context);
 	void (*prepare_access_checks)(struct damon_ctx *context);
 	unsigned int (*check_accesses)(struct damon_ctx *context);
-	void (*apply_probes)(struct damon_ctx *context);
+	void (*apply_probes)(struct damon_ctx *context, bool set_samples);
 	int (*get_scheme_score)(struct damon_ctx *context,
 			struct damon_region *r, struct damos *scheme);
 	unsigned long (*apply_scheme)(struct damon_ctx *context,
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 327398fa4ee56..9fbea6204520b 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3692,7 +3692,7 @@ static int kdamond_fn(void *data)
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
-			ctx->ops.apply_probes(ctx);
+			ctx->ops.apply_probes(ctx, false);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 6172464981730..b13bf7c6eade3 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -166,7 +166,7 @@ static bool damon_pa_filter_pass(phys_addr_t pa, struct folio *folio,
 	return pass;
 }
 
-static void damon_pa_apply_probes(struct damon_ctx *ctx)
+static void damon_pa_apply_probes(struct damon_ctx *ctx, bool set_samples)
 {
 	struct damon_target *t;
 	struct damon_region *r;
-- 
2.47.3

