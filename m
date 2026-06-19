Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C5BE5CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:34:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4A956B0092; Fri, 19 Jun 2026 15:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DFAF76B0093; Fri, 19 Jun 2026 15:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD8396B0095; Fri, 19 Jun 2026 15:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9283B6B0092
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:34:32 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCE95166635
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:31 +0000 (UTC)
X-FDA: 84897663942.17.689639A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 35F85100007
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:30 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EWhSqmhv;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897670;
	b=yisHyhXwrA/PkyrzHRRowXh3eQfyMgEearyFnL7O3k8LGGXai38PMRzu5tv2kdWap7ZYOj
	pv80FeKtRWUvn9mN37HTmAP2ip1cnm1Vez2VZi5n17R9XSfm3WJnwc3KPPbkAxyl7Ete4H
	S6VOljhah4IP7Iw+qksrMhqB7WdFzGU=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=EWhSqmhv;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eEAzl4fG1Rw1OmHjkx4B9ArVR15QPoOdbhEdOy2AmaM=;
	b=D1FFM/TOQdjJ0pu3XECxu0bStPzjg7oOAb9wQXyQFqqKptmwyJftwTCZoPjl4qGyyVOhF9
	oJ9qVGdr4no3nx8m/UHjfNCEO0L7pudND8ot2qZtn7c7wFxyUB00m9z6irXhPmLeXzvoUJ
	cLd6BF09ZrNnxBdTN4Wnugz8SIjf+4c=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8020944385;
	Fri, 19 Jun 2026 19:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 937C81F00A3D;
	Fri, 19 Jun 2026 19:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781897669;
	bh=eEAzl4fG1Rw1OmHjkx4B9ArVR15QPoOdbhEdOy2AmaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EWhSqmhvuGNgWCdXS1VFcABODMffItwEVnawJFTn/KVRaS2eOdPBSwlnco/ze3rnR
	 o76wbXNqCP88MNi9H+5vvWeUPiOL0mWsQlTZ0iSOU989Jcy4SrT0MIhbn03aRfR/Li
	 tLPa0ZwVfWfK0zK5hF7lbmuWicwAWrdGyhHa4jMBPj8C07qZSbzFe18ssvfhLseXoe
	 qNX80udaXyd2ptj354m2V4IGf0VaUgwR2EeFjHFsQSanXamBpcTtHRFS0uA8/i1yo6
	 Y/r/VMQ6Vp0k7VVCnQBf6KU5yPFyDza4hqphFwkx84ipf4c4dk4MBllEiiO2SWQd/D
	 0qjtFzn9TeqOg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 01/13] mm/damon: introduce damon_nr_accesses_mvsum()
Date: Fri, 19 Jun 2026 12:33:46 -0700
Message-ID: <20260619193415.73833-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619193415.73833-1-sj@kernel.org>
References: <20260619193415.73833-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: zssyeeux68iysskwtibxdxbezipyzrmf
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 35F85100007
X-HE-Tag: 1781897670-368642
X-HE-Meta: U2FsdGVkX19JjOghA6qTp5CVGxAyuOr4+TBVGDBQ8BpkZyRAuZbakQyTGJke5zDt9N/IAPud3RqdxaCwRaRqIgZTg1JqwA/ei8pDgkylPZDH9DmzxOP2ocEfVUNk8tEJAbMdnBUHExVYyuHg2cs91gngsWUE+Ngd3QW143G3Fl8QS//j5mzwjqTA8LwHCShjBfVuu2VYZM8efKAQ1YUp0a1uhUbaOhRgC84AaHQ2MLH7ODgDnkCj7EBPL/Zvuk2ix8oMU2mXYaXQX6BzJg9fbvDxZnLf6GfdZRN0av//qab1Qm8Ouhay8ImJ+bsiX2QHViBr/RoGDFc9z4seA/+ExaBjsHhMePPLpP7mCSLB3quvSiBEnwxRqqvzX/OjgBoBylvI6B5f8BcST7hCGltlTrC4o9xx2p+03TltoPQXgnb6vksywdScYm2JeaPyDSAIg0sx/UscgWAMP/auU0CKHIR3g2fB2/umK/Cqj5DSnqsCuwfwIlDvX9n4SapUc9WnEm9fwnHC5ALrclZHioLf9w8gQs7uoPauwiQmXKskt59d/BMgFpSpXZYCJooXrS8aCbTERdJgmhQiKIAG8+mA0W8rnF2Us2IT0EJiMvs8cJDYZ72FnhJn2T666YBMYBKfio+wqSmNlJIZVLlPUKfCzBseqykjuEVyeOVfGciT+L8/Uq4MbVIBEMB5P68yVIfhtIZpxEhEyuq18mw190b+6BgwDxvGexHoBFyCIplB5+MEb7w1R/+DEZr0939DS3MYRuXA3ecmx/xXyK4FiiNoZT1CNhAEJ0zO4WP0cPYEYYiNK2a4XTouMrBxcFJYAUL2st7M0ob4buVDZHfCvr2U6iDbBfA+6kgnRRwm/E7ePtQM8iGGr2jkDeA8PUgrErSq3IubPev2xUY4Chscg7KlJIDQuW7HgoKV1PhZRDw72GGGgbXHG96PUQEBaVizKYmlOasAjIydMvloF8Jn5aI
 cB1n7CkX
 jNEI7yuqheDnsOYgrIhZUD85Lumo1VKlyOpsZxX/nl4U6eZnXDM8lA97rja+9PGCbrqcDQi6l/Vw+/myllI3XZoKtd5PAiXDBrlJPGxVPnyGJnRHxiMuBZVh32i5rnvK3rlKFyolGsS1EMRBZamSHH8MyOA67QQevkRr2HTaV5AI2g9NW9qALrKezuOMY3vsbNJnJLZ3oMvBS+rm+WIRZXIWLxWdJtkI+EXQMqzTsslT+c/fhrH7Oia+xBoRtEKO9iFCPp0Pcf2TBW9lwaRMQ8ka8ew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a new DAMON core function, damon_nr_accesses_mvsum().  It
returns a pseudo moving sum value of a given region's nr_accesses for
the last aggregation interval.  The internal logic is the same to
nr_accesses_bp.  The difference is that nr_accesses_bp is updated for
each sampling interval, while the new function needs to be executed only
when requested.  Hence the function's return value is the same as the
value of nr_accesses_bp.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h |  2 ++
 mm/damon/core.c       | 55 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 64d75c78f4df4..16e3e0910526b 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -1013,6 +1013,8 @@ struct damon_probe *damon_new_probe(void);
 void damon_add_probe(struct damon_ctx *ctx, struct damon_probe *probe);
 
 struct damon_region *damon_new_region(unsigned long start, unsigned long end);
+unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
+		struct damon_ctx *ctx);
 
 int damon_set_regions(struct damon_target *t, struct damon_addr_range *ranges,
 		unsigned int nr_ranges, unsigned long min_region_sz);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 5b84b3ce3fcff..afb00f9bf7856 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -210,6 +210,61 @@ static struct damon_probe *damon_nth_probe(int n, struct damon_ctx *ctx)
 	return NULL;
 }
 
+/*
+ * damon_mvsum() - Returns pseudo moving sum value for a time window.
+ * @current_nr:		The value of the current aggregation window.
+ * @last_nr:		The value of the last aggregation window.
+ * @left_window_bp:	Left time of the current aggregation window.
+ *
+ * This function calculates a pseudo moving sum value of a counter that is
+ * aggregated for each time window.  @current_nr is the value of the counter
+ * that aggregated so far (maybe not yet complete), from the beginning of the
+ * current aggregation time window.  @last_nr is the value of the counter that
+ * has completely aggregated in the last aggregation time window.
+ * @left_window_bp represents how much time is left for the current aggregation
+ * time window in bp (1/10,000).  For example, the aggregation time window is
+ * for every 10 seconds and 7 seconds has passed since the beginning of the
+ * current window, this parameter will be 3000 ((10 - 7) / 10 * 10000).
+ *
+ * The logic assumes the aggregation in the last phase was made in a single
+ * speed.  Based on the assumption, the value from the last window that needs
+ * to be added to the current value is calculated as a portion of the last
+ * value based on the remaining time window.
+ */
+static unsigned long damon_mvsum(unsigned long current_nr,
+		unsigned long last_nr, unsigned long left_window_bp)
+{
+	return current_nr + mult_frac(last_nr, left_window_bp, 10000);
+}
+
+/**
+ * damon_nr_accesses_mvsum() - Returns moving sum access frequency score.
+ * @r:		Region to get the access frequency of.
+ * @ctx:	DAMON context of @r.
+ *
+ * This function returns for how many sampling iterations in the last
+ * aggregation interval (&damon_attrs->aggr_interval) the region was found to
+ * be accessed.  Hence the value can be interpreted as the relative access
+ * frequency score of the region (@r).  The value is calculated as a pseudo
+ * moving sum, and hence it is not an exact value but just a best-effort
+ * reasonable estimation.
+ *
+ * Return: the pseudo moving sum access frequency score.
+ */
+unsigned int damon_nr_accesses_mvsum(struct damon_region *r,
+		struct damon_ctx *ctx)
+{
+	unsigned long sample_interval, window_len, left_window, left_window_bp;
+
+	sample_interval = ctx->attrs.sample_interval ? : 1;
+	window_len = ctx->attrs.aggr_interval / sample_interval;
+	left_window = ctx->next_aggregation_sis - ctx->passed_sample_intervals;
+	left_window_bp = mult_frac(left_window, 10000, window_len);
+
+	return damon_mvsum(r->nr_accesses, r->last_nr_accesses,
+			left_window_bp);
+}
+
 #ifdef CONFIG_DAMON_DEBUG_SANITY
 static void damon_verify_new_region(unsigned long start, unsigned long end)
 {
-- 
2.47.3

