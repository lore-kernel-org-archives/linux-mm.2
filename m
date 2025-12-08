Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B29ACEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00C26B0010; Mon,  8 Dec 2025 01:30:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD9466B0011; Mon,  8 Dec 2025 01:30:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A0B06B0012; Mon,  8 Dec 2025 01:30:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AF046B0010
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:02 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 29D8C1A0971
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:02 +0000 (UTC)
X-FDA: 84195328644.18.3A265A6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8016F8000A
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:00 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bBWtheks;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175400; a=rsa-sha256;
	cv=none;
	b=KvRxR8kgE0rFffcGAyOi9RN/Osz62Abh1b7BGW/Jds0rsa+8lTUJhXign1lcIv0jd43t7s
	q4RS2LLl1DP+p/zUF2yGZX4KBvbqFas9e67hwh7er9jEVHkhz15or0OJvf4vMJmx3ipFgI
	WnPBH89Ts9OXj5GIMjlyZmhLSSCZ3js=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175400;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Gt0isWEZG9Ko0k/Q5IOtviFX9RJx+Hx6npjX7FoMYs0=;
	b=hzpuG64rvDg1VKJ9qyXd+FWdcnlrvsZEFm07GiHoDf/iWh+d37EtwSPu156M7AVPKFp0Q+
	SvjnF26zujfBtNBNb0fhecIyTG9tWTh/myePfksbcxmc3ngkffhtOQxkdl/DHgtXw+acAb
	jfL9Zq6SpXL4McD3Lz/c4dov2SeXcKA=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bBWtheks;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B160B44400;
	Mon,  8 Dec 2025 06:29:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E4B2C4CEF1;
	Mon,  8 Dec 2025 06:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175399;
	bh=kw63posGt47cF3PzxW8YgBTIV3frYoxoD81lOplefX8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bBWtheksOgHWBstZsj7GigQ1TcugWneeQURbZ71ey2h+Ojpj12DQybju+3H4WjIaO
	 8oXwugeidzsjW8kCg3bXXZVOPcB44WgQsLlE+TZbM9Fq9J934FBXgLEaTRgZzSW7BL
	 2kb3lbw5g+TzzRC9SFzPsEL9ndBuajBI52JFKMYAyk9uusLf1jOOfgrIO2xJXvJTEn
	 r+IWVn9PyF/M5FJmGc2aMTqNu/ceeAxcMvgIU+YPnI1JDdG2MsCxXCz8Q1OeS94nSr
	 JXnvBWRlMqGrzYj6/pAYNxdw4YFQEhmB0Z8eiWLJJrUG96ZIFmIZtYblqvFQ7KUXZm
	 o5deaTstAHt7g==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 07/37] mm/damon/core: apply access reports to high level snapshot
Date: Sun,  7 Dec 2025 22:29:11 -0800
Message-ID: <20251208062943.68824-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 8016F8000A
X-Stat-Signature: xp6kskgyx8crdwc6mzrx61x8uf5sd4dx
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1765175400-261349
X-HE-Meta: U2FsdGVkX198XZZPVLlUzDDXp6dIN7ZbbFcHzguKt/GKvb7MCoRipnbO8jYtC6SUbCugp/ggVm2LH6ngD+Y6LkFzs+iaUAwkYut7McD1ZKjtwuIhdQmU95XdA1cXykmaS6q1eDf5vJw9zxdCsU+wzUkD/RbuqbTdA1sa02h+fYz9VRpkEycaq5H5YCsF+h2WmrcYS/zkC18ebXIDtSI2lu3RO+h2Fn2aO9EorAy6cTQs/uc2RiqXSS8i6hSJzq9R6ZjV53cxbpWlYDGKE1s6stiQSSUtxVuxDLLQ1oUlh51Km/rvjhXODchcFkqSyGABn9+ge5QszV+LFg6t8/uiYJIWd103xAnw5cio3NTbfvNDUVSFeQxziEW8UGFN/Sg/yrCGWQoT6FEKIqEtf/ih+HOStp2Fe9s0sv9uHp869M00V6jrNaNNpLS+kRsd7MnkSa4mdKz7aL19mmmsBJRMOs/bebSBaTDH7Ftxd+/k0Vn86aLch79f9NzE47cuRa3ybuvbvYql9zGALooZn9YrWbWC1etl1AVYFRMdMs/0knx17OGkbklmb/1e6DAhTi8v4IbmOUvDVPkHDs4Q+yzc8dy0QtwMPxBSAqW7Kjs8/lEMreyodn8MHDUJ4sw+hiQ4JzYNsGJ3RMt07275322wmfmNIHydY8vf6oSC3g450UMVipPg5hP1afRXiV9AtxMqsMGvpf0XfgdVqgUjHOxxOkjG7/6dxLKWouKUXfNZvoZ43opa79RlhTqlc6juCkrcUOeqag/zo28Pyyzyol0mZ/4p7aJ7/hibzy5POdX0UnPY+Tl4b98erKK9Zvgqf1ocm/+/LUajUvmo37Kigr0JBJ886lffeea9vovHoxd/hZ4hfASmLflBxHv4Bg+EZtmtVcWs/rOMu6olclbAuTT4P33htYZfC4/p6jteRHNEGDzKNuHQf11PxoYk84/fLPP/5sMqDJL4N7NCpNfD8oh
 UtyMFvpJ
 jKMPn2pCVjA0D+Rd1iNFf9LLAYUaOWLlg5dlP+ezxsLbsfw5C/ET/1lq5i+iqr0uDsUdIXbeVupVRT6W7MfXQOA3UATz5x3XwZWKBfhXAwD9TzhBhBBWiMdNgOe8gj097OccDqpuHH82ebFcjXx2iGZn57k+xcQ9VVWmUg7Yr6ajf6MIwAAH4jJjXbQ2OzUqw09dtOcNqbckwR/YhZAFWgHPwqXvQOVVPnElFEWrCP+ex5wSHsJ7jICXs/TyVBztj0/2Wq+oI3k4xsXQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now any DAMON API callers can report their observed access information.
The DAMON core layer is just ignoring those, though.  Update the core to
use the reported information at building the high level access pattern
snapshot.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       | 68 ++++++++++++++++++++++++++++++++++++++++++-
 2 files changed, 68 insertions(+), 1 deletion(-)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index b8ebb2aa02c8..b04c2e36833a 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -83,6 +83,7 @@ struct damon_region {
 	unsigned int age;
 /* private: Internal value for age calculation. */
 	unsigned int last_nr_accesses;
+	bool access_reported;
 };
 
 /**
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 296117d5e7f7..a14754a47c7f 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -137,6 +137,7 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 
 	region->age = 0;
 	region->last_nr_accesses = 0;
+	region->access_reported = false;
 
 	return region;
 }
@@ -2745,6 +2746,68 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 	}
 }
 
+static void kdamond_apply_access_report(struct damon_access_report *report,
+		struct damon_target *t, struct damon_ctx *ctx)
+{
+	struct damon_region *r;
+
+	/* todo: make search faster, e.g., binary search? */
+	damon_for_each_region(r, t) {
+		if (report->addr < r->ar.start)
+			continue;
+		if (r->ar.end < report->addr + report->size)
+			continue;
+		if (!r->access_reported)
+			damon_update_region_access_rate(r, true, &ctx->attrs);
+		r->access_reported = true;
+	}
+}
+
+static unsigned int kdamond_apply_zero_access_report(struct damon_ctx *ctx)
+{
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned int max_nr_accesses = 0;
+
+	damon_for_each_target(t, ctx) {
+		damon_for_each_region(r, t) {
+			if (r->access_reported)
+				r->access_reported = false;
+			else
+				damon_update_region_access_rate(r, false,
+						&ctx->attrs);
+			max_nr_accesses = max(max_nr_accesses, r->nr_accesses);
+		}
+	}
+	return max_nr_accesses;
+}
+
+static unsigned int kdamond_check_reported_accesses(struct damon_ctx *ctx)
+{
+	int i;
+	struct damon_access_report *report;
+	struct damon_target *t;
+
+	/* currently damon_access_report supports only physical address */
+	if (damon_target_has_pid(ctx))
+		return 0;
+
+	mutex_lock(&damon_access_reports_lock);
+	for (i = 0; i < damon_access_reports_len; i++) {
+		report = &damon_access_reports[i];
+		if (time_before(report->report_jiffies,
+					jiffies -
+					usecs_to_jiffies(
+						ctx->attrs.sample_interval)))
+			continue;
+		damon_for_each_target(t, ctx)
+			kdamond_apply_access_report(report, t, ctx);
+	}
+	mutex_unlock(&damon_access_reports_lock);
+	/* For nr_accesses_bp, absence of access should also be reported. */
+	return kdamond_apply_zero_access_report(ctx);
+}
+
 /*
  * The monitoring daemon that runs as a kernel thread
  */
@@ -2790,7 +2853,10 @@ static int kdamond_fn(void *data)
 		kdamond_usleep(sample_interval);
 		ctx->passed_sample_intervals++;
 
-		if (ctx->ops.check_accesses)
+		/* todo: make these non-exclusive */
+		if (ctx->sample_control.primitives_enabled.page_fault)
+			max_nr_accesses = kdamond_check_reported_accesses(ctx);
+		else if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
 
 		if (ctx->passed_sample_intervals >= next_aggregation_sis)
-- 
2.47.3

