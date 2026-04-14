Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 784FFEBFD29
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 04:53:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4CBA66B0098; Tue, 14 Apr 2026 00:53:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47C456B009B; Tue, 14 Apr 2026 00:53:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20BC16B009D; Tue, 14 Apr 2026 00:53:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 00CEE6B0098
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 00:53:01 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9582B13AADA
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:53:01 +0000 (UTC)
X-FDA: 84655941762.17.7F2680B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id D6BFA180002
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 04:52:59 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cjzcbpiW;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776142380;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TTpH6Kw5QLE3UExpIDmia9iij2I10VfHMYC9LPgqO3Y=;
	b=1Im0iKbOH3eDuIfAnw2v2GjTyVE6NLf0TF56QlmwcXJl9A3YGdHvJLVl7YFCVcAuU5XAuQ
	IpOpXxFduGexqCLXSVmaL/QG1Hyt5SQMA8XIicNOpKlCs2VwqnUEepAHg6Q8yrQfbv/9hV
	5bRCyXRKWX3YNKUNf+h9LqLPnnA1XiM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cjzcbpiW;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776142380; a=rsa-sha256;
	cv=none;
	b=jk8ki+W1t5EZQw+HgoqdLdq7yCseTeW7exROvV5cSEBwL5HFaAO+PbFXstpCSldSLpEdrw
	xYnZS8P8SlrYgRKJKXMnhDnls9R6pdRSTj2hh54fsbR0oxNughjczSaQdPsyShsSIkxUFL
	Rdqr2TmnR40AD2OO123ha2lOtSm8fKM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 07BF041973;
	Tue, 14 Apr 2026 04:52:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6A79C2BCB9;
	Tue, 14 Apr 2026 04:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776142378;
	bh=c+5+KIyLfb5AgagNq7OxOOjGMcrikTwsTu2i1IKcfP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjzcbpiWnH2uB65rdaigC0+FBemAa4PWf3Twx+UyfL0pEA+MpPRB5kAHEAC/EVABJ
	 1NdlXi0gIrok93+fmpQYUgKyuOM0jNIsEDsQ2be/u+oJmrbjudwHgepgOuR2Q4DhvH
	 tngVuyVrhJ7mkLZHSZZFvXz23MyTaQvN1pl+Rv7tD+ZVSzYcZN9nPojWoOQfACZN8o
	 dNOWGyLec/7oBxc78lCvdEWiUMrlGWdHHB1dSIMo+4+auSHXTXayT4Dz5OPTeZc4ic
	 RP1zbawdqaow3vc6+3GigiP+YWIssR+GGsTM7tEMxfhYLDddW3Trl749pyECcT4tuZ
	 q4GHYHXqK/kEQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 1/2] mm/damon/reclaim: add autotune_monitoring_intervals parameter
Date: Mon, 13 Apr 2026 21:52:50 -0700
Message-ID: <20260414045253.88529-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260414045253.88529-1-sj@kernel.org>
References: <20260414045253.88529-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D6BFA180002
X-Stat-Signature: ib4nhdojsi39cwsau8gy487ornoiynf5
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1776142379-51968
X-HE-Meta: U2FsdGVkX1+fFVemqdxERQ+3GkFh+uwmQkjDdhEzqRy8eRgD8JgO8CL4dkRJRPfCm2cN2lVBBVos8dqNqvnw1YA0+VnREndusAPyIgaOjc9G+BKXxabaefmfHNDZCrHQQo3zb/AY18s6wIKldBK44ghZtqtySnADU8lXeMDeJW1uto0FaX3AxFVB4ktJeqAlBXDj2MdVLUva/LGUIx0flMznQnRP48WvHhCbjILc+hWKKmIQYPmLFxnlXZSXk14+BUg7/VS2J7FTH/5r/F1yG8DyA4CMOnBV+hzCOld4jy+GMDTGXaVY9L8r+f9jBu5oOdbtJ0CBVN4sOSjFBRJDdhsb63b7dn4ECW/zo1sJBSuigloXN9kWG1Dhlgmv4rkXGZWaDT9BjZ5/85BP+3p+IKwK6rOEcC1aoV/qkbXNgHk74JUm6/ugN6L+bfDH1UXBRlZyICLEVj3QlbR+29gQdaOR++eHbBwFHMgdDS+lTg2PD4j7nLwcnrUPk2E+iV7W63vtcTaTRNNzdm1k96nzp23vAPqocbjqZ8Lem8ilv2lcsdOaRk0OIA7KEIMSXD5Kn5a4ALKkHkPvE89OE/oi7Pb7nSw9GdP4HeV11PflQC5x6nUwaZIHSjQr61KsUWUi6CdedkkgeVuC+xkt2eOy4lHSroAocGyaCGPy8re7oykj4On67GJ5U8ImIKmnxVXCxEnYLXxiTZKb+miSeSRjGgrQvjoheFvwq284aquSC6fQJ1IHaj/qPNPjjtgt6xyIBTzpZDK0umvOaPaKoKyT3t8nQdt8RK2tCozG1goIN0GPkrq/D4RLCUGKxQDi1Lr2ZVpyHRA02eyy8hGR2lFTK5gYXPJ7xE1hWkyC3v5k/laXGrpUbEXu3yaITjLCT0+NM6NPpwwE+lMcAkj1MaDZbwWFQr7IimLzIOozy7CQyUPYUf0I3h57UDT0g053a7POFOHUp2Wav6yxb7otU8l
 E7Q/a4TS
 ggv8JLbp2+lI0Y5He2vUeV8lnUOizIOz47ORxQ2R2z3ygy2xEaGMcyX7+1wovaRVPrwVQ7gTxn8RZafOIfdPfLAqF8OXlq+ZXoq3Fqu8jgualuPLbLCi+Ranfdd5AnovY56U3nvVTaKcwVpxK5Pn39BnFzKJQZMU6obIGRTLyvItJSkNQ9cnEQ+BMEKtISCscJZQ4/LkjBkmWxGThX1x1bY02J/ZlVgDxz8RunsuokByFocE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON's monitoring intervals auto-tuning feature has proven to be useful
in multiple environments.  DAMON_RECLAIM is still asking users to do the
manual tuning of the intervals.  Add a module parameter for utilizing
the auto-tuning feature with the suggested default setup.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index 4fc4a54b5e546..89998d28628c4 100644
--- a/mm/damon/reclaim.c
+++ b/mm/damon/reclaim.c
@@ -91,6 +91,20 @@ module_param(quota_mem_pressure_us, ulong, 0600);
 static unsigned long quota_autotune_feedback __read_mostly;
 module_param(quota_autotune_feedback, ulong, 0600);
 
+/*
+ * Auto-tune monitoring intervals.
+ *
+ * If this parameter is set as ``Y``, DAMON_RECLAIM automatically tunes DAMON's
+ * sampling and aggregation intervals.  The auto-tuning aims to capture
+ * meaningful amount of access events in each DAMON-snapshot, while keeping the
+ * sampling intervals 5 milliseconds in minimum, and 10 seconds in maximum.
+ * Setting this as ``N`` disables the auto-tuning.
+ *
+ * Disabled by default.
+ */
+static bool autotune_monitoring_intervals __read_mostly;
+module_param(autotune_monitoring_intervals, bool, 0600);
+
 static struct damos_watermarks damon_reclaim_wmarks = {
 	.metric = DAMOS_WMARK_FREE_MEM_RATE,
 	.interval = 5000000,	/* 5 seconds */
@@ -159,7 +173,7 @@ DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(damon_reclaim_stat,
 static struct damon_ctx *ctx;
 static struct damon_target *target;
 
-static struct damos *damon_reclaim_new_scheme(void)
+static struct damos *damon_reclaim_new_scheme(unsigned long aggr_interval)
 {
 	struct damos_access_pattern pattern = {
 		/* Find regions having PAGE_SIZE or larger size */
@@ -169,8 +183,7 @@ static struct damos *damon_reclaim_new_scheme(void)
 		.min_nr_accesses = 0,
 		.max_nr_accesses = 0,
 		/* for min_age or more micro-seconds */
-		.min_age_region = min_age /
-			damon_reclaim_mon_attrs.aggr_interval,
+		.min_age_region = min_age / aggr_interval,
 		.max_age_region = UINT_MAX,
 	};
 
@@ -191,6 +204,7 @@ static int damon_reclaim_apply_parameters(void)
 {
 	struct damon_ctx *param_ctx;
 	struct damon_target *param_target;
+	struct damon_attrs attrs;
 	struct damos *scheme;
 	struct damos_quota_goal *goal;
 	struct damos_filter *filter;
@@ -208,12 +222,21 @@ static int damon_reclaim_apply_parameters(void)
 		goto out;
 	}
 
-	err = damon_set_attrs(param_ctx, &damon_reclaim_mon_attrs);
+	attrs = damon_reclaim_mon_attrs;
+	if (autotune_monitoring_intervals) {
+		attrs.sample_interval = 5000;
+		attrs.aggr_interval = 100000;
+		attrs.intervals_goal.access_bp = 40;
+		attrs.intervals_goal.aggrs = 3;
+		attrs.intervals_goal.min_sample_us = 5000;
+		attrs.intervals_goal.max_sample_us = 10 * 1000 * 1000;
+	}
+	err = damon_set_attrs(param_ctx, &attrs);
 	if (err)
 		goto out;
 
 	err = -ENOMEM;
-	scheme = damon_reclaim_new_scheme();
+	scheme = damon_reclaim_new_scheme(attrs.aggr_interval);
 	if (!scheme)
 		goto out;
 	damon_set_schemes(param_ctx, &scheme, 1);
-- 
2.47.3

