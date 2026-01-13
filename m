Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2C412D2F339
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 15:27:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44B546B009D; Tue, 13 Jan 2026 10:27:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3933E6B009F; Tue, 13 Jan 2026 10:27:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 216F76B009E; Tue, 13 Jan 2026 10:27:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D839E6B009F
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 10:27:36 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A5AC31AE3E
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:36 +0000 (UTC)
X-FDA: 84327320112.18.461AED0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id D1D471C0006
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:34 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BU7j9M+T;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768318055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kIWVJxSb0cDPo5ZnyaLpjAMkbe7Qz85IFof+C6o0xoQ=;
	b=AWbLDYgycZAtOLul468MF87fA0naif4/jf7X+3mOBJQ1WesOYkZHPtOLXsjNxh08mjfF86
	AmrGcad8e0cto/7y9ZtffSoBa0pGr6GoXRB9JYNTJWV9FpaHBiXfFtW/ongRtDPHT6blUa
	ChTww4wcryf9EK3vcN54xS3W05Eb+9o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BU7j9M+T;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768318055; a=rsa-sha256;
	cv=none;
	b=umypUSg8mejXrtfgcyL37Y0hjwwtrfFjIgLSb7RPflk0kdvhDLqGgf60WWUQVFubdkfNuK
	PFGwViyN2UGG2kopXa6BKvDDC93LCbVZ5ffDNBuwAJ1W1VZ1BZgTcZJ39qpixINxS5nV/U
	cWCg3n85mpT+gIcRAPMRpXYVc+hhUaQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C5D0744458;
	Tue, 13 Jan 2026 15:27:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 963CBC19424;
	Tue, 13 Jan 2026 15:27:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768318053;
	bh=f3S6xDzMYwBAJsmHW3zullLbXTgyY6fprlw1+nJamAA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BU7j9M+T12Pl2/6y/ThZgQsOBqc2tov7ik5qihZ+zekXx4nv/okg1SjeyuMJKE8ct
	 UrrJK6PnCIRHTrzVLUx8eLaLQqYzPFlZRzqi0VP+0oPaXA6dcPAmoxzpwVvDUxRPc3
	 ZYkXjvDj37yDuO31Wj5O2XtCX47hiyIIh1/NIfE3vQz5BlKMHaafY/I/y3p6NdQFaZ
	 nwnwNdhHh5cJ4WyEhhHDDu8V0GHAqm0sj4jzdyThuvafKvoZpu214Q3E+edJaqqcGL
	 uqbxEceh/bVlsT6G7KOQYkYBBJQUXcIRGQ2nwvCDZqV64YiKPprYbLvO+nN6mdeN9B
	 PU1b4lvH3tbVQ==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/11] mm/damon/lru_sort: add monitoring intervals auto-tuning parameter
Date: Tue, 13 Jan 2026 07:27:15 -0800
Message-ID: <20260113152717.70459-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260113152717.70459-1-sj@kernel.org>
References: <20260113152717.70459-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D1D471C0006
X-Stat-Signature: afytaoo5ra6ybj85r8q1cdz99kmdf9bt
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768318054-323872
X-HE-Meta: U2FsdGVkX19OZ0ZeHrQDVts0FF3PCZaxPAVG/yo0DzX/Y6oebeSNv55jGgAITK0VvWwZ42zgKccPXE6DezUnXxoKwzOJJl7QzFaV+lkK/2zuaUywWVHGYXBBQHj1aHYkKJbM2sVJ+1BzqetQBwXUX6XaolyERFVD6FofZwC9ZbzL1VMroVj5/0e4qQU4BYDLUw00F1thVexy2JXmiKOwYFsLvoUKR4lCt+Vi9Y6BD/zwymXNMmt60zXTQ+KJ7dCK/l96DHvGdP9jW3JKdvP8enq3ZccOCIDeADtkphOGgME+r5N/Zb+64NhdRpCdPb/KjZ6u6BDXsrT2ydR8F6rXpd6msqtF/92YAB/i8s0ReHFmdZXpvtZnJ2Ay0NlWmLx5RvIvh6bPM6rxfvEakT7vraeRnCHwhgw+60ZOaWea3+tmo57szzrXsEMA0/uW4sfXL4XJ3IGSJWu0O/BobeUHqNoI1M1vOBQsoM11Zjb4RTYTBp8/sTRvxUMmvT4Xa+VD/DozN1gRlEv+fcM0YtYnqr3U7j5d1ZNrVm4HkGEQ1MMYl6Bo97mpKCKvO6HwHkZumnOP/j98y7+vFvzAVXGDUvXKC3+9crxHFrfnZvy1nd+K2oXK40pJ9GAWgK2KcpuhaTdoPEpwsk1mTl7IbFq2mGlLXvyulsp+9gPkj/lWFsX+xTZTplL04BX18+uSMnfCSSwc2lSOalgT0/bobmAOGEt9WKIcEbHJnORy2D1yMivAu8YzkGI4Kxl2/bXKW4AF5PZF8jYmVFsECv+OZhB2U3rrtc9bTERzoEI9B2Ej//y9J0sCvg06vi/LTbxXvxHLlb2cQEL8+KbMFpL/gO8AmIiv4SL+9AmXCtTeMz35D52EwFr+aIczikRVvBdcs0Py8vazJ34akwWvP6vGxTicrxEiprtOlXOuzwBmlfmbmyKhDeQOLWdwY/G+eYmBlKK5MV0nFLn2yDgVX5wBgEv
 vJpJDaAN
 DnTu5KrFjsyGKSOa1WGvKDlkGYaE8Sau1igpQNVFtHuUK3JUPtrQQ6VOVJ8/iS7dcXjz8ZT+UEm/TmXh8bWBGOVuPHAIJQtote0hCSqhHpQuUXE4ySiDh0Qw365r0fcGL+W1qlDkYBP/SJXyy3Kt6SAJUMaQ+vAVqS/d6cI1k2DW8zyQtkV1+rFVxNPCi+GAq1Qjqv6trspiYhOf190OkvWTmHeRBD8akoOO9c3KV3aPEZfb6CRgJEFmpSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

DAMON monitoring intervals tuning was crucial for every DAMON use case.
Now there are a tuning guideline and an automated intervals tuning
feature.  DAMON_LRU_SORT is still using manual control of intervals.
Add a module parameter for utilizing the auto-tuning feature with a
suggested auto-tuning parameters.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/lru_sort.c | 30 +++++++++++++++++++++++++++---
 1 file changed, 27 insertions(+), 3 deletions(-)

diff --git a/mm/damon/lru_sort.c b/mm/damon/lru_sort.c
index f3a9dfc246b6..717cc585d207 100644
--- a/mm/damon/lru_sort.c
+++ b/mm/damon/lru_sort.c
@@ -55,6 +55,20 @@ module_param(commit_inputs, bool, 0600);
 static unsigned long active_mem_bp __read_mostly;
 module_param(active_mem_bp, ulong, 0600);
 
+/*
+ * Auto-tune monitoring intervals.
+ *
+ * If this parameter is set as ``Y``, DAMON_LRU_SORT automatically tunes
+ * DAMON's sampling and aggregation intervals.  The auto-tuning aims to capture
+ * meaningful amount of access events in each DAMON-snapshot, while keeping the
+ * sampling interval 5 milliseconds in minimum, and 10 seconds in maximum.
+ * Setting this as ``N`` disables the auto-tuning.
+ *
+ * Disabled by default.
+ */
+static bool autotune_monitoring_intervals __read_mostly;
+module_param(autotune_monitoring_intervals, bool, 0600);
+
 /*
  * Filter [non-]young pages accordingly for LRU [de]prioritizations.
  *
@@ -268,6 +282,7 @@ static int damon_lru_sort_apply_parameters(void)
 {
 	struct damon_ctx *param_ctx;
 	struct damon_target *param_target;
+	struct damon_attrs attrs;
 	struct damos *hot_scheme, *cold_scheme;
 	unsigned int hot_thres, cold_thres;
 	int err;
@@ -290,18 +305,27 @@ static int damon_lru_sort_apply_parameters(void)
 		goto out;
 	}
 
-	err = damon_set_attrs(param_ctx, &damon_lru_sort_mon_attrs);
+	attrs = damon_lru_sort_mon_attrs;
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
-	hot_thres = damon_max_nr_accesses(&damon_lru_sort_mon_attrs) *
+	hot_thres = damon_max_nr_accesses(&attrs) *
 		hot_thres_access_freq / 1000;
 	hot_scheme = damon_lru_sort_new_hot_scheme(hot_thres);
 	if (!hot_scheme)
 		goto out;
 
-	cold_thres = cold_min_age / damon_lru_sort_mon_attrs.aggr_interval;
+	cold_thres = cold_min_age / attrs.aggr_interval;
 	cold_scheme = damon_lru_sort_new_cold_scheme(cold_thres);
 	if (!cold_scheme) {
 		damon_destroy_scheme(hot_scheme);
-- 
2.47.3

