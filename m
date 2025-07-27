Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6334C87FCC
	for <linux-mm@archiver.kernel.org>; Sun, 27 Jul 2025 20:18:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C04BB6B0093; Sun, 27 Jul 2025 16:18:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDDED6B0095; Sun, 27 Jul 2025 16:18:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF1DC6B0096; Sun, 27 Jul 2025 16:18:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A001E6B0093
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 16:18:25 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5F0545CD48
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:25 +0000 (UTC)
X-FDA: 83711156970.09.8E3EAAA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 9D08E40009
	for <linux-mm@kvack.org>; Sun, 27 Jul 2025 20:18:23 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bb43SF+4;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753647503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=clLqrvllYDnGzySVMdjDlscH4gR1RB/iS/nFoM+86PQ=;
	b=ozXhjlh5D9DzdV9rnD+uwgraPAy4TKXunPU25DWxH51lNWrTKnt5bzenKM1UZEt0tYRi+F
	JseO8HHMqh3MUG90V+GUbbXwi+7pOcJZTMLzKRVix80lYgeYCuO3QDgcNjxAhoLo3jqC1g
	6zT0elcecszGATJy3uu8uY1L+QdyCeE=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bb43SF+4;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753647503; a=rsa-sha256;
	cv=none;
	b=RbJVX9OAX3PsHbU443X/Zf2HVR9PqRBUvxerCRvO1pB2+hMu+xJBRIA7eC67QFFHTSMe0O
	qMDneVKV7ccG+hq0pm8xWvnhZiOidIBjUgYIWYW9bJTJG6ux5thbS+FQqvHHDgC2J9qWHF
	FapRA1OVLsFjUoXS2gav6J5KH6PiFX8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC2DE45CA4;
	Sun, 27 Jul 2025 20:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F0BDC4CEF7;
	Sun, 27 Jul 2025 20:18:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1753647502;
	bh=3yxuU0XQzbUfmqOxngAFD/wzk8Fov7BuHvufkENc1Gc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bb43SF+4/x6PxpUFYRnY7Va/Dus59O6I/kDuN5DbBrKHFG6Dpo4/TOdUmPY4GEtMd
	 tWGacLr/fxtnXvK8Lyry7QnrR7qp6bYDT+gGfa1Qgl2rTrAkTNwTcTFyI+p34hjpSR
	 GJUeVDZ2U/JN2ED6Qgi9JUg1KJgCrKxFz2p7TtJtmR18eN8KTs6nCTk3OeusD6cJ9X
	 QdoY3JqwGct1q99PIlZtLVIMX7L0lhVZqwAxnaFhwdqGwX8zLGr1yQh7oLDB+p3KRj
	 uf4bODK9O0BUK1L6t0tshazTj6xjuHCyCbjhOgl+b/jKipBip4Es2B5YQLN8cVS8vL
	 oPFcUvAYYaIJA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC v2 4/7] mm/damon/core: read received access reports
Date: Sun, 27 Jul 2025 13:18:10 -0700
Message-Id: <20250727201813.53858-5-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250727201813.53858-1-sj@kernel.org>
References: <20250727201813.53858-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 9D08E40009
X-Rspamd-Server: rspam06
X-Stat-Signature: 4be5ctbhzkcih4ge4x6qr3zuwjumwsio
X-HE-Tag: 1753647503-567501
X-HE-Meta: U2FsdGVkX18BFeIDD6GueKVw3ANctjOHD032T2sZlyo8rNggOiT6B2GcLxqjSmVaM2K14uwNFm/v4eOhQuXCHYZgMeRXA2QJDAyhQwj9UQ0a8yTGBD0kMF0NcdYhZwlasdByVKAX6cy93EMC850Q1QrzQUN1H1simpxNF8xRJynlfzWLA8ViKehLhjRWJWfKQCIHIA31mQYh2OvlaFZ7h2SL9NgTvdMB4DerAaf3ZwvxhDeEUU2TWBe1lmZ3shg8DPyVoYbgtViUJmIxfOkWU/6goOGKdTxXFaJYqeXE+dBbq4WJcgJYNQGBYb+3/xl1VYcc0Ko8S+JKJriWTqUTpaAxmD0e6wyMmbmfAkITlg6iIkWCN9BJACozHGJBpryicEeu0ztFXwJIJXgbFhxv1JdcIYLRKbGPvWCl58y0Cm1JyL9adKPZ57lvMpUcKgu830mPJyxJkgbdjkPVY9+zSkAvVvXZ9FkAVgvVcgs7+B5mLCjPjmcARO5Cb1S2Xn6VawljiOwiYejNVFUGbUkXBdmnx5RWIgdWIbEqdOKArgVrjok/tKX1s9nwShrnUdpq1KeXKxRe7qm7LdYYl3PQmNHbJO9AlKYzdchM7IIQXT5U/aGHkol2V4KbHI7yrvr13FqlEVPT1bcdM3S6lOGXkU+CF79NCbIT563Epf0J/20PM4J4ETFvR6WD+8uBZLgz/kzpML+DOyhskpwnpZNtchN2gh8F65Oy6WXkfGcgk/7+ATNXjWl00fGG27gHLGES1r6mX6xpTxmxvvLpypOwo9DjoI34cChJthloj9rYyJRZadXY44APJ1Kcw8LSHl1NGumJ6QdB3/xfXbK+CvnmKRIPe4/eZkeTsF/lrl8lyV/rHnU2wB4ud2AUpGZZORj5h+oHS9vu0NwYBHKKXUOtPbY0E5Escchz51fKsZmTROahSG8xXYvKtcqCOG2Hc9MECAk8BeShiuAkclQsRFW
 WdUyDLg2
 Z/Rt3kF3N5m0DE3yia+KNm8RPGc8f8D4HKbY0Iyrcl25WLPMvinmcOH0NFjc9BTQu6yS41gR7fcKC+Ekg7aOZzcerxSdmIA5K48CIvKiDjB0nSSfRWOUO2W3Sxg7Ka+6GIEkPOGjQMdaZICb3voHqTjW4MTr6XDX401cqsJLYIzdS9bwSQww/Q0bSSSjXz+0YVrEgaQhFTYpsibWwoS30Fy4CNRadV2zFwZ72MEBmvbfljZtA2YRJ+rCB0XU0LwrER9m9c6NPJP7OpCDp47XbydmHjFV6K1e4Y9gb/7+qPpiG4N0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Reported access information is only saved in the core layer's internal
data structure.  Those are not really being used for final monitoring
results.  Update core layer access information (DAMON regions) using the
reported access information.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  1 +
 mm/damon/core.c       | 66 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 67 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index f3e5c585b5f1..8ec49beac573 100644
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
index 4e25fe100b56..428ac1b83118 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -141,6 +141,7 @@ struct damon_region *damon_new_region(unsigned long start, unsigned long end)
 
 	region->age = 0;
 	region->last_nr_accesses = 0;
+	region->access_reported = false;
 
 	return region;
 }
@@ -2560,6 +2561,69 @@ static void kdamond_init_ctx(struct damon_ctx *ctx)
 	}
 }
 
+static void kdamond_apply_access_report(struct damon_access_report *report,
+		struct damon_target *t, struct damon_ctx *ctx)
+{
+	struct damon_region *r;
+
+	if (ctx->ops.eligible_report && !ctx->ops.eligible_report(report, t))
+		return;
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
+	mutex_lock(&damon_access_reports_lock);
+	for (i = 0; i < damon_access_reports_len; i++) {
+		report = &damon_access_reports[i];
+		if (time_before(report->report_jiffies,
+					jiffies -
+					usecs_to_jiffies(
+						ctx->attrs.sample_interval)))
+			continue;
+		if (report->pid && !damon_target_has_pid(ctx))
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
@@ -2607,6 +2671,8 @@ static int kdamond_fn(void *data)
 
 		if (ctx->ops.check_accesses)
 			max_nr_accesses = ctx->ops.check_accesses(ctx);
+		else
+			max_nr_accesses = kdamond_check_reported_accesses(ctx);
 
 		if (ctx->passed_sample_intervals >= next_aggregation_sis)
 			kdamond_merge_regions(ctx,
-- 
2.39.5

