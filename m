Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D355C43602
	for <linux-mm@archiver.kernel.org>; Sun,  5 Jul 2026 20:58:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EF266B00AA; Sun,  5 Jul 2026 16:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79E8C6B00AB; Sun,  5 Jul 2026 16:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 667116B00AC; Sun,  5 Jul 2026 16:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1B6BB6B00AA
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 16:58:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7D737A01CF
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:59 +0000 (UTC)
X-FDA: 84955935078.09.245584B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id EFCC1180006
	for <linux-mm@kvack.org>; Sun,  5 Jul 2026 20:57:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XvixD+Q4;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783285078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OzzZd8DigQnVYbi2j1POHwqutTVJPfVsJOTUlbgk6WA=;
	b=Jg6Q19p0a6zZvx6fB7LeI2lNPjmICRl0Nqss2PiFkXvo+72gQlf4hM0rmbgpW1nxepWQkv
	qy02YHzSpIQb5Oa6jkih/RVj343dpbwXUuFerlz8shpeBAy1rYZ2WgmlDoaZ7CBe2khnZD
	/O6z2l8NAYqdlZ2/UDcgOR/fIMfly6Q=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XvixD+Q4;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783285078;
	b=KLIrgpYecpwlJeOY8ns3QBiTcERbfwtHbVWq9iYKioOgRBUdnWT/YY3wu3iDwkFj1BDR3R
	TwdXxQyMMMCl3Y7G7AndNkjcX6fBaaiyDP3W9duVbzmYrVU2S7s5ImwTy9x7Rvf+hQ8vgR
	q17PR3K5GMjquNofKVMo9+nhECyMtNM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4FB7943C4F;
	Sun,  5 Jul 2026 20:57:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0F321F00A3D;
	Sun,  5 Jul 2026 20:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783285077;
	bh=OzzZd8DigQnVYbi2j1POHwqutTVJPfVsJOTUlbgk6WA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XvixD+Q45vVCPzUTcEpua+FYXT4H58BztouTBab8RhMvBOleLx/y1AlLFyW9V33w9
	 4eq0t+S0J8jmWYHN9KEJQkW2RNV+hB9je2gnLqzz5z0QSuJ2lY2j1iODdk6WUDqH/G
	 pTS2NRzr1hJUTG+n4z/tmf66dsFQgxNBU7d/sKQosWYEtGa9Mvsmu5grdP3zc7K7Jq
	 fSVNvpClGB+Fd1HqQ7DlkZ7aqo44tepeZF8WQHlfPBFnd+0VvtpZS5NoX4cvvEC7tI
	 b7ZF+4yZ9McJ1/VWs7HAlCsOssYwqwviv2zynXz+reqczFg72PYcenWLqF/+zgQnML
	 +ZEXZsA3YFV0w==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 10/16] mm/damon/core: s/max_nr_accesses/max_merge_score/ in kdamond_fn()
Date: Sun,  5 Jul 2026 13:57:32 -0700
Message-ID: <20260705205743.98656-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260705205743.98656-1-sj@kernel.org>
References: <20260705205743.98656-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: EFCC1180006
X-Stat-Signature: 1uamuedho8yeqtx6exfe6o9hjx9g78jj
X-HE-Tag: 1783285077-939317
X-HE-Meta: U2FsdGVkX1/Jl7qtLegIRRKpuBMzeDqWtF/CLKj8AHy+xWWPF+DpIKDeEHLCDaT++lQa+M0y5WI6oPGjMggsvXi+3RM4fjsbC62qjBvilwLW8oPcOgNcWDSd23RfoPJkLQplGGW7w8DjiLscELsIlQtUhTPQeC0KE5CNrSoL13S4XsvrAd9K+PK7fQVIZC0R4RAmr3c2OmfuEDx26ZnMvacBwm+TAh0GTfMqnkrfR488R+T4tM6aN3efAl9w1+HBaoqFdL4wULdej/Quf1if5/Ku7qCp8GaG4jypa0FnyeAFWhcRfbngNX6TdGoMKpWuEOSDh7NoWXQU382o6o8kr6XcxMfdWeOt7RislY6gUjPvHILCa0iBTgUp82fUDftqp7LeAn3fM8cGiB1qwXTMHFLlChLytGSDWwJVWvEMey+iqId1eNAXoFREI7kWsLE2JdHG0d6MFe8AEntu4VtLPykiylM86F+zbQv9s3P4uAiRM040sGYDLkZxIr20UmuoEYpG831GPhUtFgA88CpnhFJAuKR9pnrYHMpTvpoOC3pMUlo9ohagbBszTdgpEc7kkmok3Wd/vs91KPp7qke8y4UiNhPmJTFbIDci483mvPkzG1lSJVNNhY6Fx+qxHmDH0gbAsStS84cI7eTwHzvoYvVj7uHN07n0vTNZ5SjlN2U72haU2VbICspA4/JXRM2Os+Zxxr1eWxB75TwgxLu8VoxCzZswNNRQ8MoR0uHxLRWMWjmYHSczd3JPwM9QMGYynGiHTD5do40THsvpUjKt1pOa6m/P0rCSLrLSllDspVc71/otoYT4M9/BtAJtcv/0CQdzBJO66QdLAh7IL66aWue/BPcEczGUoTBvkwNtpLhm3JwyjlVORijI+7bNX3sFsHQPvzRIqXWFZPH4TYl1SJkZ9GrDk4oSr+6IlDrmKXa9yBMAURJNYoUfK3dzIt1W/sGzOeDP+EVqAXBDGO0
 wNGqczLE
 YTsrGNYFbWgmv55PLu3cJEQiGAAwaUVA63TERNmpGsTJHQ+XAlR3Hgdha55Y1b7IldypzQAbTEEJbFi2lVHPALyd8e8EhEdxTRvbRU8twEjHJQTQRl6EnTg/WHNgdNY2Ir9E95hhnbq5JTAbV12hUK57dAcpQ0mg7AJFjDtTa56fBZLhkrDMgEvgoX1wl6hAfcDD8B6O8lLKcQY/xYj8TMqT4/jOx42Lzw3HcqQmSJgS8kAQwQC568C1KC6xayVJqLpQhoNToNlMH6OqE74Cpd+yR5Q==
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
index 71008ee6ca243..a7ca69ea8e565 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3681,7 +3681,6 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 static int kdamond_fn(void *data)
 {
 	struct damon_ctx *ctx = data;
-	unsigned int max_nr_accesses = 0;
 	unsigned long sz_limit = 0;
 
 	pr_debug("kdamond (%d) starts\n", current->pid);
@@ -3715,6 +3714,7 @@ static int kdamond_fn(void *data)
 		unsigned long next_ops_update_sis = ctx->next_ops_update_sis;
 		unsigned long sample_interval = ctx->attrs.sample_interval;
 		bool access_check_disabled = damon_has_probe_weights(ctx);
+		unsigned int max_merge_score = 0;
 
 		if (kdamond_wait_activation(ctx))
 			break;
@@ -3726,7 +3726,7 @@ static int kdamond_fn(void *data)
 		ctx->passed_sample_intervals++;
 
 		if (!access_check_disabled && ctx->ops.check_accesses)
-			max_nr_accesses = ctx->ops.check_accesses(ctx);
+			max_merge_score = ctx->ops.check_accesses(ctx);
 		if (ctx->ops.apply_probes)
 			ctx->ops.apply_probes(ctx, access_check_disabled,
 					false);
@@ -3734,7 +3734,7 @@ static int kdamond_fn(void *data)
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

