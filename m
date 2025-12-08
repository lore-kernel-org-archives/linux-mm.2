Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3584D3B7E1
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CFD7E6B002A; Mon,  8 Dec 2025 01:30:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5FBA6B002B; Mon,  8 Dec 2025 01:30:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B290F6B002C; Mon,  8 Dec 2025 01:30:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7176B002A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:18 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 69B991409D1
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:18 +0000 (UTC)
X-FDA: 84195329316.05.E84DE9E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id C6A818000C
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:16 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hZn3EHdk;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175416; a=rsa-sha256;
	cv=none;
	b=Mi2nIH8EQq7CYmLAL6chdMcC8c1ciOWiLSY2c23W1K1TiZ4/P3WxpMWg/Ue2r6hMz9fRP0
	2hGW5+ATFlymsVD5dP+0dV49Zf58OgiOe3IENfSGlxW98axCvA7nhu8MuuyFha4Dc8UIXO
	ZQEA+BYks5kU46G3fBVqFy3hK/xBeNs=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=hZn3EHdk;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175416;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=juUdx+d0QMMu4b6tJQazESCtd7L4Tc/GnWi6gtnQQuE=;
	b=OMc8LbSgwi2LZ+Nlu6hw2+N+lO3UHNrkgXKV7SMQmUkFYtdbz5amKuXXPXAHKdxLY1Z5+b
	YwQUFo4doLawsP8fgoL6LHTzsLofRXmPYqS8akGjpsJJizCWUkPOc/k0O+K21KnFMz4ASD
	+Y0k5kZ8IW+idBVaefHTUC6uiFVVe1Y=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8DD2A444B2;
	Mon,  8 Dec 2025 06:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A998C116B1;
	Mon,  8 Dec 2025 06:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175416;
	bh=Fdrtqh4dKdLy2JHMv9GeJLVmZnlNDk6aLdhfIH2zS/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hZn3EHdkDpxrRmJltAlArQeaA57+8Wo92tB0OhFhhDJ4QTwsfWMhHq3XoUr5ZNDpA
	 GqBKwPf/5UC82CkIgWWTfyNVmJzrSmvqVvVn6Jt+UUQvfoDGHjye+RvrC7zuoZ20oG
	 EgguVOwNeu6ve5Dtxrf5Bo3fzHPjtI9ZJu/dpVkNSjpWhHDSMYWoP23uhZH/xMjmka
	 +qc4Zd9URYiVZRPV7ykkEm3gACny9AZ53ua1BElOi8w7XvPqBmls2ZWMllFgtiEnHr
	 1/qBFl51cnDBPbOi68h1fTJnvqk8NyIIJ/3VcoZIsOHqmHlKfkcMtZukfOSXuhJdbe
	 sFtnr5Tv+8Jmg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 18/37] mm/damon/core: apply sample filter to access reports
Date: Sun,  7 Dec 2025 22:29:22 -0800
Message-ID: <20251208062943.68824-19-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C6A818000C
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: 91wmktzuxgiy8fz7s94e7zgphbyambr8
X-HE-Tag: 1765175416-892341
X-HE-Meta: U2FsdGVkX19/XPkCPY2gbzNyvzx/TFpXC1oMJDPCnniUZ8vbYVBJ2GD14QJru5q3vgNsm97utLg5BLo86jeWOJEw24DegVdyBzbZGSCE8y0aaRaqDeti2d5j8A8wHwZJJhUDt7QxYZMnctK4Yu1qN8NBTssaFueIN0Y2moMFewyaLcx7rz4jJVAIL4Gq0c1UoFLYci59+bHPHd4lPMWSHo+8DmI19PZcKAkrgVuI7rln3UalboQC4Q9uYbMVlJ7fdJNNOXqy+qKvCi/S/Xbz5pr4qKfVKuuZoUPDLnZHDU7OYCgCWt7gSDFDrS/aGw+BerjFP85amFB3Ko6lZe6LB/A5g5VnHqoSWhZsrWsT2DHQzpKCzkmmbStoo19lXzwi0J4Kn/taRRcf6E0klMpA3JwHY/DPwXhePj9yopNH34Woh1Kby52z6DJVd8AM5tEFPM4xXA5P3pkOrz8GKtqYFA1jSMnAIlfGQpNvAlM2h+k01MEK4Ig+lE0RA6iA9R3ARQKubPHL4bzK5Za4eNUNlcCtRSqMv7Zf0d88FphVbZJD31eOpCR7Ch98ICBbR52bYn1yR9tQeHgFswBBlMvsNXd+D+AcikFzBL7OKTabkzfuoBehLDelXDFw0nkItG6NepQzokGM/U1liLX2I0h0a1gT4s+aP/zjw3szji522wv/iPBioH91uU76g45wgIhsJrpcBO/kmKy7JTez11p3Ymt2LbxtAJY0EQPKk5Irx6GlMTYNR8HiV12B/m1XUxM2S3ks/PnAvmK6/+ThCH57xyimWNxQFq68jodG12zo2as9av9O7eIzx55nSrjcfXEwRPomKy/rYKuBoKqw9I25kF55irk5c9s7aUjVknrTIoP9qB1F82KKIgB8CMLSTTCXXk4oOw+0xbi5x0YhipkX1/zcpJPARMxVQwfp/g1PQlVoSW4dpHI4LBoF5n4UA43XedHrgG5+vqVLJRK9rVP
 1PFUSHY9
 w3R0CJiNdSHvNwjejK4OWPDoi8HvviyEDTqDkw/5mHSYm/qYYEF0kgFhJxTJ73BDBf+EI5eE91BPp+JqM3Ml0HTcwopkZYIf3aMY5CKjkmqIN5dXTrlGgCTdmEHh9RoLq7aeFOaIV7QL0N05P1Nn6LAeSdFHlRcQPcMWeH3mE9FWg0k/L+QKSLnOudEiaQXarOlcBnAlBxgBVxStb+qzuTcUWaPqtA3H4w8IApFtSJsqhuLEdjeuHAj9mt61U2uH1HRnszlk/bqcZ4vQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The data structure for access sample results filtering is not really
being used on the core layer.  Implement the support.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c | 41 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 41 insertions(+)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index d952a833a05e..b627fc84161c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -586,6 +586,13 @@ static struct damon_sample_filter *damon_nth_sample_filter(int n,
 	return NULL;
 }
 
+static struct damon_sample_filter *damon_last_sample_filter_or_null(
+		struct damon_sample_control *ctrl)
+{
+	return list_last_entry_or_null(&ctrl->sample_filters,
+			struct damon_sample_filter, list);
+}
+
 struct damon_ctx *damon_new_ctx(void)
 {
 	struct damon_ctx *ctx;
@@ -2866,11 +2873,45 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 	}
 }
 
+static bool damon_sample_filter_matching(struct damon_access_report *report,
+		struct damon_sample_filter *filter)
+{
+	bool matched = false;
+
+	switch (filter->type) {
+	case DAMON_FILTER_TYPE_CPUMASK:
+		matched = cpumask_test_cpu(report->cpu, &filter->cpumask);
+		break;
+	default:
+		break;
+	}
+	return matched == filter->matching;
+}
+
+static bool damon_sample_filter_out(struct damon_access_report *report,
+		struct damon_sample_control *ctrl)
+{
+	struct damon_sample_filter *filter;
+
+	damon_for_each_sample_filter(filter, ctrl) {
+		if (damon_sample_filter_matching(report, filter) &&
+				!filter->allow)
+			return true;
+	}
+	filter = damon_last_sample_filter_or_null(ctrl);
+	if (!filter)
+		return false;
+	return !filter->allow;
+}
+
 static void kdamond_apply_access_report(struct damon_access_report *report,
 		struct damon_target *t, struct damon_ctx *ctx)
 {
 	struct damon_region *r;
 
+	if (damon_sample_filter_out(report, &ctx->sample_control))
+		return;
+
 	/* todo: make search faster, e.g., binary search? */
 	damon_for_each_region(r, t) {
 		if (report->addr < r->ar.start)
-- 
2.47.3

