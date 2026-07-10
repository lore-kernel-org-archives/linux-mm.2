Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93268C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 00:24:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D9FE6B00A0; Thu,  9 Jul 2026 20:24:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3145A6B00A2; Thu,  9 Jul 2026 20:24:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 251BA6B00A3; Thu,  9 Jul 2026 20:24:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F420F6B00A0
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 20:24:05 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 669AFC1A67
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:05 +0000 (UTC)
X-FDA: 84970969650.17.43792BA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id CE5EE18000E
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 00:24:03 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AawtbD5S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783643043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UYlXBFEEj8Bqit1WCVkStlsJk2B9S/H0owK0kWMcnr8=;
	b=lngV8bZmZ5cA1XadDmKCpbaMKoXhIKTQ6yjNNRGICYWCCewO+w6RhOGjMn4imrE+UVn4I9
	7Anxcg7d2GI8ENtVmut+S9brYdqeSRltpUAGp1Katc7TOWufcDxWw0RMUWWCnTIyacLRCh
	ShJ8hS3puku/obRQuR9j4KF5kzAQFBE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AawtbD5S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783643043;
	b=i+rJWE6C4Pfa+HKAH+pATS2BmNCz2vrxnfnu423mxm07/V590pUh4StRSvmeghvX+ozVs4
	1bxYqfbLcsF5Qw1j9rdFyq0oa7LqhTIX3iy8gq7lxUS1py7suxUKz/x3sIxnB87WabrpNM
	zbtdtWSMU3pHU+LbtlLVu39P0Q7x5iQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 21BEC4512F;
	Fri, 10 Jul 2026 00:24:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2E0B1F000E9;
	Fri, 10 Jul 2026 00:24:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783643043;
	bh=UYlXBFEEj8Bqit1WCVkStlsJk2B9S/H0owK0kWMcnr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AawtbD5STBYfcSixB/tTmjtfvyloEiP08rldHpcaTOQppP0oCEg9m0xvHNNZe+Oof
	 kcYqmvF3Hx/Lqn7Ge+nJiPY3aiKQvwZkFCSl6A+ApPxONZsQvjgGNAgoeFlznFumnY
	 pdBmnRo5qTJsvE42Nuii6obfmCDbN4OPZt/MCOUUplHFesUD2bN7pOqZoNpTKSU/Ue
	 cjmce34HrF2EHsVMXNr6mwYMtnetMKsWJEp9TX2zqIHbOLxgreONT3zvGQHGDKBBwS
	 9uYrrr69BxnhrhPfRuLA6aSaBr5gTpVJ4dCf1bLFLlpmWT/uxHDk3d3W+0sgDxa85S
	 ZdZnFFngwBgFg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 13/19] mm/damon/core: s/max_nr_accesses/max_merge_score/ in kdamond_fn()
Date: Thu,  9 Jul 2026 17:23:39 -0700
Message-ID: <20260710002349.111414-14-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260710002349.111414-1-sj@kernel.org>
References: <20260710002349.111414-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CE5EE18000E
X-Stat-Signature: kdeg6je1dc5txiate3aoxsddgrsma7gq
X-HE-Tag: 1783643043-287269
X-HE-Meta: U2FsdGVkX19AM0E3D/pJWySxGXZL6FDTeijNhehgyoHuVr0hf6HjUJv3Apq64uxi9pqH3lE9em0EdsFIfNyY+CoXH9W9BvKcuu8v6t2iUHN4uZ675UjRA2LqOKS/m4/g6T8bolNOch+TFHCvNoGY5562sL67KxTastB9tv42MczXljqQOqjvnz0lXBTKOUKLeq8T9LrUWBgBPALxuagdtq/lL3RWdtdQy+0xk7rDtnwpFqOH54+O1D5HoeEtjL24sgAjiztBXj6vPXpm0X55bisLybleBg3IqJ01o3Wx1eN3AswiCxgbnzvwU8LhmaiN4nyEf10IlYKM4m9ICWZn8kmJRje69wRB4HCpvFO79DOOk083f26WSuwDULXsP55S5pv/YOvHrGL998NuPi6OsjivXOMHbUUI3rgg+6/lIIvOtvB32nkSz4/FP9rM6qhXjcE99mlbqTUmB/uvl22Qd2JtAYuKdpK+vYA+Nsl4gQDNmkWXaVZS0v72xGIpHMKDDcQlKkGc3DZC7Ii4iWs4C9Gt5W1jvht5EHY+JGgrvOSQUOHpDaBSr07E+1F5OzHY6w+q3B5cFY7IhBaU8FLKXgH8Zdw7t9wxoBu8L7s2uDEpL7sDjSfe5ibh78mCxcWkHPTujXdGoHmdREIOhUKwKdtz0aRTLEww3EUTCXtHxpb5SmbLN4VgSKcaraZzBAyxqLnOvKBgVsbRqIqsal9eMgLs1jr52NkJdS5beIay4c2JRKp1SsF6hDVzMN8FRR3uH1xnKSANZFOmnEfGJRlOC1OV02y0fWMZ9BEr8bOYEd3cAeWExG4mDUjf9o1zhFG8divOllU73FIFEV7n5k/atFs9vy2R3GPuPOs8NzW8jAp/Vq5xcS6gSh9r1mxB8dCS0oAZXfZpohtODeX1JLJKql0pI/IJQn4oyDgeSWNWuhnY1YE1FNy0QuqpgDIbIRDJELigfxcLivVSivCEWf/
 6MrjdSze
 Npea9tMctME5B8AKSoaumR8wjlnHW+2Rmxac3DklQpxjWrUTvK83fXSuYdAQwIEJDjgrKbl7yxgBUhqN9sz5Hb5q0Sg00ivdOT/LGOglAEjotWc63ea6SpPJ4E5xTCLagj+a4ixNVeMRZWkQILYRjBWAiszC/9CRQrnIMKbn76op7i6EQ9DqR0IWXxxuxe58X9ldhzdS7yvyqripnYMMLgatMBrkT3SHG16hGH7HW77FK18b9CJXDiipWXJ/bf+0rsj5drYzd3+feIkRcKSwmUAcwHw==
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
index dd0612e1a408b..f7782c69037da 100644
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

