Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95CBEC43458
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 14:06:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 806AA6B00A0; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 78FFC6B00A1; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A6946B00A3; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 444AE6B00A0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 10:06:11 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E9EEA019F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:10 +0000 (UTC)
X-FDA: 84969412500.03.9787011
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id E4A2180015
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 14:06:08 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kmWqvOkQ;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783605968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B8V92yvjw2SyU/dNzdlsr6pPt37KiwtlzMcTn7UeWbg=;
	b=y5yyhFuBHp53WFpzbkhK9fyi1QgT4fM8WcdHFeTGwt7v2Nv8atJbY4e4oLKiJMDd44EiNo
	ybHTnXiJRpYHB6jpHALFZm7ukRV5UFIC/Q9iHY1p3B0EXy7E9Auaqy9L+eLbBY7TlXJETI
	dfrUDmiU/EQRn53WnGaSYEZYKZbBrY4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kmWqvOkQ;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783605969;
	b=r/mm4LB9noZO8Q4SP3aHBD9y+sGA9PHNx3UUzwXTbdQbH+JuXeYMhW4i5qVoAsFV5TtSxS
	hC0d3Fa6YIIZccc1M6DxW5TTRGcZGIlAfakFNjJaSuGeRWL7TwcEaZ3JvjQCGmr0EBvzzf
	EsXfWV17LXx7XxgdDIcvzC+wplFCU7c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 41B4F42E73;
	Thu,  9 Jul 2026 14:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F31811F00A3A;
	Thu,  9 Jul 2026 14:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783605968;
	bh=B8V92yvjw2SyU/dNzdlsr6pPt37KiwtlzMcTn7UeWbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kmWqvOkQqQNagbDCpLqVlB9rcK8Itp2cQY4lZmBJI3jF7JRicCqH22EVRhFW+OrnP
	 d1dVgQpmI7ar1jaxmU8ra4j3tDTVp+OjKIN6h4Wpw0/N5pFeifZbJEZdAwy9l15eEY
	 9ZE4ji1qrqCgQ1KYechJtCLBcSV4S492xjTQOIfJByZambMXlmtf57nFY5GUpf/WUy
	 IrS3xjWcjCe9pLCsVVpE5BuxCl4pWTtPKRkLR7+3Geq47dq1vZwyOqKuba4g5KFMyB
	 ZaI4vfXO9tmbJHQ3cNn8KYZUzf+TMg7U0TqXvzU0JBPhREdcS8XZ7WZA9vhTj/O2dw
	 9axFUaP96GLQA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 13/19] mm/damon/core: s/max_nr_accesses/max_merge_score/ in kdamond_fn()
Date: Thu,  9 Jul 2026 07:05:51 -0700
Message-ID: <20260709140600.90950-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260709140600.90950-1-sj@kernel.org>
References: <20260709140600.90950-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: E4A2180015
X-Stat-Signature: g7b375teb6f4zsxrqubfty18ge9iswn3
X-HE-Tag: 1783605968-672896
X-HE-Meta: U2FsdGVkX1+lKPuF5sv5jOfciAbEL6GhOwTyLtR+CP9eZoGQrcGxCTdaI6Jioy7x3nPlky134StjFe/s9KRywBrPPkrOkxTvIoWmqCzE08bov12aCsHw/ucRc3628uLJf4ngtfA1jn8EosyPmWDxHK+3KwZ1ZQcXJAVAmSshKJpLcoQL+ZSiWVhY9TZXkCCD+GIgbmcOF3q2lc3L48RqMGHVuxzYpdDf8dp9ovNaEbrkOfk2gLb9uTapB/O0LaWEv51BVLDiQyAYOn6apa2AbqmkiLRe03/uR4jdvYRpaIWvOlNzvzn3TI3BdPOl4fB4JTn8W5VPfwkbqOwniNkT4/G68BQHeQerJoGYI/soBtOTlgxYl7l1OjVKPLbz79PiliUPeSTZ4a7+rHJ7Hg/WFsG4Oem/zM6NA/swvb9ArPosSzGLOVyXnjdTcgP67mQQ6s7z4+cGB33WVJ1Y6/fsNHTKf2h4sd7ZV/IQpqFC2J7QZOWdpbO+0YQRMeDkqZFK/E4AHgkp5XtNVJ1469av4Vhuy4uEKpQMctQW12SSKBqgPvi3jvPBUT01uL941gB/ksEZh6XR++4u3fFZVHb3V7IfpscxWJWJwYo8slMmMdreGoPWtXJbadX8rK9WLD1cNEgEVXf2KbgkFMkmI/TRh10VWCLgeII0OUZMjcUXXvUplF4fgFwrN7p238/ziTjqvufBx0qDLMfZG64lSgMm8C0VOWQ/7L10vKgqSL4mgm3xmFXbpajWkH8Ifs61RVLS1wZUbfbLjYGFXSRfduEQ63MZ8xDcbaZFwvoLOeO8uuPf0CNpFWu2B8nHwdnju6hns+aeAK/Fzu6ElNDAt/QTtw/pRWVV7Drwzhs9aOuFnR3kK+cU+GUMTOZkqBWqrcjBMU2XnH8/aQwoek7An3JBm1lfTpV7YZHYcUfrIGWl+ZS0/7oYJC+RM+60FuB6TEkj4OBR14Fhx0MXQDjKD1I
 ru4mUx3Y
 eD5Qln5eLcxN66c64bHGJ8bm2mk6DTGNouN5TiUfYaIJAqZXdjBu0CtFoPNkLQ/F/ffIZCTvRSY+oiMb6Asq5fnQ9qrhioUKkmG2E0nPsdn0Mc5Qe5mKLQbMdMTn6pxhJUWJsCYTjU/CyM8GA/HArK4VFee5uk1wZiNJ9mq9nClcUsjXoPAOwtJOZP6dKO1hr8+8DcNty4XcgV9wfkn/T+elJG71fcKBYX6vQ2rUt5Di5ZY/r0OgXnIl7XXtTjeoUaujApjlr9q+qBMkIK1PceJAkJQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When probe weights are set, DAMON merge logic works with the probe hits
weighted sum.  The core logic is setting the merge threshold based on
the access frequency, though.  Before using probe hits based threshold,
rename the variables to look more general.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index f1be748e9a674..8837b2129baa6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3730,7 +3730,6 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 static int kdamond_fn(void *data)
 {
 	struct damon_ctx *ctx = data;
-	unsigned int max_nr_accesses = 0;
 	unsigned long sz_limit = 0;
 
 	pr_debug("kdamond (%d) starts\n", current->pid);
@@ -3764,6 +3763,7 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
+		unsigned int max_merge_score = 0;
 
 		if (kdamond_wait_activation(ctx))
 			break;
@@ -3775,7 +3775,7 @@ static int kdamond_fn(void *data)
 		ctx->passed_sample_intervals++;
 
 		if (!access_check_disabled && ctx->ops.check_accesses)
-			max_nr_accesses = ctx->ops.check_accesses(ctx);
+			max_merge_score = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
 			ctx->ops.apply_probes(ctx, access_check_disabled,
 					false);
@@ -3783,7 +3783,7 @@ static int kdamond_fn(void *data)
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
 			kdamond_merge_regions(ctx,
-					max_nr_accesses / 10,
+					max_merge_score / 10,
 					sz_limit);
 			/* online updates might be made */
 			sz_limit = damon_apply_min_nr_regions(ctx);
-- 
2.47.3

