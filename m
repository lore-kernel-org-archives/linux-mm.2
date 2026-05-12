Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A217CD4F24
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 14:37:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25F7A6B009F; Tue, 12 May 2026 10:37:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 146946B009E; Tue, 12 May 2026 10:37:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAC1B6B00A1; Tue, 12 May 2026 10:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C39456B009F
	for <linux-mm@kvack.org>; Tue, 12 May 2026 10:37:03 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8A7E41204ED
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:03 +0000 (UTC)
X-FDA: 84759019926.14.506572B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id E2FE318000C
	for <linux-mm@kvack.org>; Tue, 12 May 2026 14:37:01 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SHr6kjg9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778596622;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cf2bdlE4ziVui3OtGWtYzeuLdctz2fJM7ipSuN6p8Y8=;
	b=xvxvhen8CgunFj5e3MgWH5q+/J0snCrgsvb1OMUtkpI8JothiW04y9/oxV6arkdIHAOpNz
	JWHKciID/I81/MKi0i4HknEC1hr2NwcIs1lxn+7gXZMhwWCl0HnIXvN0wTgH+U4QAcpUOR
	UTYDTLfFa9fPEt1oY4Yawm1WtF7L4k8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778596622; a=rsa-sha256;
	cv=none;
	b=A13RDbN3nZki34fzKSf1joHIbf+1WIgJnCuilA8TJiSSSGnyrvCKNDgLW7txlh2gp9ZCJ7
	hqbtt1ZQRKonRf055YtYaJTuWXveOoTJTnxk1GWwsb3/RGP9E/jKsLxdzFUC0m4Ngvy0Rq
	c86mhB+lfNGD7wjIEON9/IQvbLc90sQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SHr6kjg9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B5B244AB6;
	Tue, 12 May 2026 14:37:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3898DC4AF0B;
	Tue, 12 May 2026 14:37:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778596620;
	bh=SGvDGH8HeHXn8zTVaCZsyhJzQGptwbmD0KfHLczQ4ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SHr6kjg97yrhddopCh8SrS0cwoGVIPtpCqP5/w4RUiObXCcA3wmwpgxqte3SYsJPn
	 X9BUHP6Oup1PCbFOBXJgiCcxuircBIQLf7Xh+GBaWXYOmk+dflW1dlupl3s/uYevFp
	 xN+10+EOp8rmU3yhqZMufXwuNrono7E4FdDODyi3HAFJ4ZD+/ZSi/bkAoNPPEX06ao
	 9tUNu/nNdEfddhknATnywZ1JFtzJywaZwg13YitlJVhXcAt7g/0YZjnG7/npKSHS1+
	 dghbEosUoqHDr0GBCgxeovXUzuJzod/OCt/aVTfHrDLccx1ujIKMYDnnrlK1iFsIi8
	 ArW2pUWni0raQ==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 07/28] mm/damon/core: do data attributes monitoring
Date: Tue, 12 May 2026 07:36:22 -0700
Message-ID: <20260512143645.113201-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260512143645.113201-1-sj@kernel.org>
References: <20260512143645.113201-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E2FE318000C
X-Stat-Signature: y4uesw3z3oqhdsf7rb3p6tiscyxn8uw7
X-Rspam-User: 
X-HE-Tag: 1778596621-658075
X-HE-Meta: U2FsdGVkX1/nwYSNytiFj+Xt2f0X/blNTFjjqZSBWb2c/SMFnKUVQOG5HdVm4hhn06fVPXqBTNalKySiHfJnKUtaH0sn8ktbyS7sGvpzzlRph3LrGsrDf21xrv6YCGFrOHFkYdANWnvzOnBbdfTivjqT+u3jvDN/El25q6/4e7AnYERr3ya95DIb61w72D6m/U/5W6N2R3GYHEM9i1t7lH7CC3bUxD+pP6tDyQ97Zmz8bgCjm1PHyThi9BpZWRQj6jm0F1XgJDB1tv6kK0aKyqbjQGhNG9b3rNVvXsoIgxbq6Xd2QQYCL5MEZyMoZMIfM/uynIlB/7wUCIvgdqcUJxBY0FnBYaEFPnG1dM2kfsGbk3pkMypyHuUVUk/1Hub7Biw088xG35dWECXeqVy81IqdH/1A/VrGA9NSuF7nGoSCvELge8o9JciJyBfYP7Eb64Qvcvu2rBK+2h1ss82+gb96BIl7x+a9Qh98MDUDOsBOj5jE2z46Jcxg8LN9/mGqUNAXW/SbhdDkml8txT0VwcrFD+8KX/MZXd4z04mLUhL7xOoaNXL51aJ3FJ15K5T/pgxsnVgjRL0l8U9UZ+vbQyxGpkUd+YYLYtgdayGDKmfnk9awGEIXHvjQVqglfJf2cxl6DpzXG9BT+8bAJUhsDISy8zhTdrZnUCTM8XbxW7aOX4pb69LfBfmeIkGWmcNnpgKarREJJnidJPoTSvsjXOkfptWcJP7mPpmbZjKqeWCZY4lMJz547P8XfptyB/Z8jQZ2uaQH/pm7twXZvV9ixT0UKKDWJZveUWpdWqSghYS350uvz5ShRP3W1/fthCGKsBYwpDkTZVrcZyrcTzx2mBSXprL36Ic9gYhFQYoHuHBICFibm7eC3MbKTY6jU5pzaoTzM+y6wKImSUD+ZWReKWGykF3mLb5ROzO04NpWdNUkbOJ17DfMaJglKFxUljN82rvB11G9AiGCvC7ghGc
 6VbWHO8k
 gqQVTJ70N+Uwf/S8gKImnkfc+8CBLBz9IrcuQgQCxP1G9K+g+B1gAr0KA/AkT12OGCN090/jI4J530WKPXxwN0f2WXhn82BeVOmfrnxxQIZMYgKWBEldyy2OpWrm0hMyd/w993oU9mfjsk9O2bAULjHmlo8f3xbp36SSbGo5z4C/8kpSAAiGg+lloqcPP3aKC6+54ZqldLMlwg/RMdyx0wOVulxS4oRijWEnMF2+0UprgpNk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Implement the data attributes monitoring execution.  Update kdamond to
invoke the probes application callback, and reset the aggregated number
of per-region per-probe positive samples for every aggregation interval.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 72acdeb8c478e..fe6c789f2cecb 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1910,10 +1910,14 @@ static void kdamond_reset_aggregated(struct damon_ctx *c)
 		struct damon_region *r;
 
 		damon_for_each_region(r, t) {
+			int i;
+
 			trace_damon_aggregated(ti, r, damon_nr_regions(t));
 			damon_warn_fix_nr_accesses_corruption(r);
 			r->last_nr_accesses = r->nr_accesses;
 			r->nr_accesses = 0;
+			for (i = 0; i < DAMON_MAX_PROBES; i++)
+				r->probe_hits[i] = 0;
 			damon_verify_reset_aggregated(r, c);
 		}
 		ti++;
@@ -3400,6 +3404,8 @@ static int kdamond_fn(void *data)
 
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
+		if (ctx->ops.apply_probes)
+			ctx->ops.apply_probes(ctx);
 
 		if (time_after_eq(ctx->passed_sample_intervals,
 					next_aggregation_sis)) {
-- 
2.47.3

