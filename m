Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 776F4CD13DE
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 01:18:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB5E86B0088; Thu, 30 Apr 2026 21:18:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3F946B008A; Thu, 30 Apr 2026 21:18:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9566C6B008C; Thu, 30 Apr 2026 21:18:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 816846B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 21:18:20 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 0828A1C1207
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:17:53 +0000 (UTC)
X-FDA: 84717089226.25.0BA89D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 3DA04160002
	for <linux-mm@kvack.org>; Fri,  1 May 2026 01:17:51 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cbMB9IzA;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777598271;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X/lDmM8rBWG4uqpENqamSasLBnCBbp32m9wrJYI/Daw=;
	b=7YWtr8w+cGbYJ/LOMC9US6ZZc0gFwcutT/lGGOMuWBtpTCdHHOqXNxLg2pi3Hj4Ro4PkqG
	kvxLliFtFwugnHJS7L6/6zo1RNOcIRUtNEdnYZpwAHZPlEGP4F/ES86NJyTy7nKQJh6a/6
	mN2cwMV+8Ut5jHohh/qPkSHYS95xwLE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cbMB9IzA;
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777598271; a=rsa-sha256;
	cv=none;
	b=wHPaSpqDFysPMI0HAJiEEr1kbfQsHUQaAd7Vh2Y42pt7U6dMpai/PJqewFHXO82c+NyXvX
	2n8VdWodz19G3EVTQKlkPLsyjjW31N/9g+whMnHKw+J1NX8T6/I/JhY0z3Ro2NQCILhivA
	cTseBIZHxYPIkrRjRCddegoixlMLDgQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5B8D3444D4;
	Fri,  1 May 2026 01:17:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F0E4C2BCC9;
	Fri,  1 May 2026 01:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777598270;
	bh=IXV4ofHUNMR7uLHKHC1smn2YPflRBM60edKH9TblUOs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cbMB9IzAxL8CGD1ii9D2yRqsbgrM9kjX/48Sp/hSKyIDsMlPVIPaPgMtx/x1wkb1r
	 USo9ckkVyeUSxsWNwZe+spjqCq7p4QpEIIb72fGShnD6EIRcZgUiC7QMpQzB53mXCF
	 YM/EMdTyUmgolIqihfckuNdUx9DavJreC5SIQMQrdLXE7dRk1W1JpDs/zqWJ477VBl
	 BGS4iy9o0ipTNocI4Fym69HFrW4pnBDty0c8zZS9CjbzocJAP475Kml3DzLlavFsz5
	 Gn0zoZHtDk1qVaW40EpSsXL8n7QawiqyHf4YkrLDlYg2ekMC9/g4UmfdTSwh1Bu31S
	 jgiB4ykXX6mog==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 1/2] mm/damon/reclaim: add autotune_monitoring_intervals parameter
Date: Thu, 30 Apr 2026 18:17:38 -0700
Message-ID: <20260501011740.81988-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260501011740.81988-1-sj@kernel.org>
References: <20260501011740.81988-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3DA04160002
X-Rspamd-Server: rspam06
X-Stat-Signature: y6z7jxnebephy68tthphdocdexjmfnob
X-HE-Tag: 1777598271-184437
X-HE-Meta: U2FsdGVkX1/od4z2dukEPxH/6glaeIyjS+0S/4VdhY9C5dgqL3DizaO3X/4vRr8OjIck9zLDcCAQmNwyw9ueRQF962KzDrVzNfzNclQKAHqobIzTLTEHl2NuACmRvk0fwPn8vbjrKEA2odvGxbNl9pMGSzCg8KNMm7mouKMXl+WSOKNa1wcjvx0bxGlNwk9CqLhIFIwiYZy4RSAF5KNVKOfAmTWRIio0bdKUClWlNycS+7NAB9IYMQN+eSviO51o3jMc/ubHt5DOrourYmPz6274yK+d1i8zZD+SS9kJ+n/n6/3lARVBNz2OT9CvR7qBLxyxusISGm6hzVzZEAtdszfrUDVTOXKkkPSnDiAcvKrNC1PDaXt5QEO9/BUSBHJLeGLiryKzD9WoDGkfvIubnsxXoQxl3iFgdVWTyhKs4QUA7NgDDli5f3ivbyqXRksznfjjCO/AvqeJVVQizTtG6TL7ozW9PzB+ICQLK/ngceBgECvepk4mVlf/vPqx3pVhhmQ6fJV9ZFTG0l602cNYpfBVnPU7GOkh6nS4+qkdEEvh5Mw53IYppLXlsPkO2KNg7yl2ONC9PtuusYMQhf92Hfqu7+6pSRYvDvxmDajx0E9HiR+2CC23RK6XTz9u1a/adXswWoPTxEnDemB+pu56/S/ZVP55OJw6GS+3hSNAb29KSi+vMP0EGCoMdkDyOUy/2H1fYGnAtsbUupnbCCJik7boTr/g2xqPSQaZNz70n7bER6I3IfR7C/indGCwWO9WKxxXFXfxwURugKLRufPN8CerKSAkpvhosikdwhUMTroLR/UfKYX/ZPtAuzcRTMMOonsXsDS3dtHc1mNJw1x3gLDZH/eg4EAfNcH9x3xSnp8ldpfG/nVP7NiJF2KQ0h85DJ/Y0GOeWtvPyU6F7/9UuocsErlEiIzSrasEptAUkcukFrx1vJ8Lv8VqE0QMcLPT1fYn4u6TwvhHv+OcVYl
 EWtYsHW8
 PhYFvLIqesyjeuxzyb6C12zh/UE6Rf5PSE7yK7KZQd6b1x1xyeqkJ+/uTNgWOkXCh7xcJZ7kAJHJDM/JhhgwvTcoFrT2ANLH2Rt1wNfRZCxI1DTZ/0isozVLNe39T3ppIM6whNP85rTnW30kuv1/ZYUVoM3svdsSu8YW1ofzSmk+tqzyOOPSOeLxGnxoAry/dO18hJFpf7wonhNlhKe8CpN8oloTY9GWV/H8ivH6aG/uThBGl6qjl8BTCwBvTNqcRJG7G4JNYkfBtMQ4hslqw181Vcw==
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

Note that use of the auto-tuning overrides the manually entered
monitoring intervals.  Also, note that the 'min_age' will dynamically
changed proportional to auto-tuned intervals.  It is recommended to use
'min_age' short enough and use 'quota_mem_pressure_us' like coldness
threshold auto-tuning features together.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/reclaim.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/mm/damon/reclaim.c b/mm/damon/reclaim.c
index a60ee800d63e9..7126d47fb8b2f 100644
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
@@ -152,7 +166,7 @@ DEFINE_DAMON_MODULES_DAMOS_STATS_PARAMS(damon_reclaim_stat,
 static struct damon_ctx *ctx;
 static struct damon_target *target;
 
-static struct damos *damon_reclaim_new_scheme(void)
+static struct damos *damon_reclaim_new_scheme(unsigned long aggr_interval)
 {
 	struct damos_access_pattern pattern = {
 		/* Find regions having PAGE_SIZE or larger size */
@@ -162,8 +176,7 @@ static struct damos *damon_reclaim_new_scheme(void)
 		.min_nr_accesses = 0,
 		.max_nr_accesses = 0,
 		/* for min_age or more micro-seconds */
-		.min_age_region = min_age /
-			damon_reclaim_mon_attrs.aggr_interval,
+		.min_age_region = min_age / aggr_interval,
 		.max_age_region = UINT_MAX,
 	};
 
@@ -184,6 +197,7 @@ static int damon_reclaim_apply_parameters(void)
 {
 	struct damon_ctx *param_ctx;
 	struct damon_target *param_target;
+	struct damon_attrs attrs;
 	struct damos *scheme;
 	struct damos_quota_goal *goal;
 	struct damos_filter *filter;
@@ -201,12 +215,21 @@ static int damon_reclaim_apply_parameters(void)
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

