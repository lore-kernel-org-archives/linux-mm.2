Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E99AFCEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 06:30:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3D58C6B0028; Mon,  8 Dec 2025 01:30:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 385FD6B0029; Mon,  8 Dec 2025 01:30:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29C686B002A; Mon,  8 Dec 2025 01:30:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1A4846B0028
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 01:30:16 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CB00A5B8D7
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:15 +0000 (UTC)
X-FDA: 84195329190.13.ED2D47B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 24EBD8000F
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 06:30:13 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bwtpk9Vd;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765175414; a=rsa-sha256;
	cv=none;
	b=IY+jGE0cDNqQD6MNfszps7VodsiqwW1oboXOl4Eoha3p0lE24b+2EZxlcnbpL6SSwO7/Z1
	SYeI8HCtlOK0fv3/vVGRpyeof8TSTQJaG0en/aV0SmPWCXS9Lq/jZgWB45KlFH9Mo8BT1n
	aY8bagI823tRwBbF18g11Bf4abgWHLw=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bwtpk9Vd;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765175414;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2VViJLgwTcFdVid7GF1N9irAC8uJvzDWDc/rlQmK2Y4=;
	b=cNw3mH9+dOLdEq0vn8rKQwzHgJ7hAicu327Hfjp+CCUJgKUKBo9M7tFYkLcZ44v/j3rAfV
	sTLN02T2W7DEm3l6Fp4nbLmw8D+brLPbAQpxQ88IgTCG0nCzYcgVZvlqZeuxKbu9b5nPZi
	L5X8KkuOBZJvwtI8qAoQqUFJqErSmUM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DD0A444400;
	Mon,  8 Dec 2025 06:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2673C113D0;
	Mon,  8 Dec 2025 06:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765175413;
	bh=YPnSi5M7u97aTRieMiHi7Bu1nhCZ+HHUKBFpBBpeqKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bwtpk9Vd4vrAjXdu+Ctd4td0gpjFcxyLgrazZzrenIIZvhJn+IUMrfbqM012cAkPK
	 4VyOKWJtp1gDHMdQ+i+MyhhJ9tz0oclTNl3ruANfwuKzTKbjbMp2uGqePbWHoHvztQ
	 9ghRHb7AHRZZAzH7iYKqlNrPAZuYtfgfBcdH2H3O6fZDYHfpA3bAQeGokqZ2OQ1dCs
	 t9bkI/OOqV/F5+nKVCawY9qS0EMKXsyDlervg5viMH36AAOUy0zD54FEcU6VMZwRo4
	 Mv6ak+y8CjbpLzR5hpINFvZFct2LEgTwreIMdv27mspWLjTQY1JJM9FHFUlEmrMoGK
	 TJgbSfE0dwdPw==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v3 16/37] mm/damon/core: implement damon_sample_filter manipulations
Date: Sun,  7 Dec 2025 22:29:20 -0800
Message-ID: <20251208062943.68824-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251208062943.68824-1-sj@kernel.org>
References: <20251208062943.68824-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 24EBD8000F
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Stat-Signature: rdg1p3bprq7nwu44m8cry3m54kzxs8co
X-HE-Tag: 1765175413-938240
X-HE-Meta: U2FsdGVkX1890JtFo1C/BOZfxLvIE1MxVfTFAnbVO/ZaoRREOwgWQqiwrtDYDszuH5L2F1Ly736UG1hG7RGrT2sHbjnoSBNhSQtlDXjDzoug8nd2mVZHSdsN3EBXaxU7QJh0pvJSELxAdbbqUtscLYDY7Tcq9mPW80FeKA5kJvZzSRgmw/jOUi8M55mzeKLWCTmpsiJxx+noFqg6cSmP6YOl+o7Lx1sPzP4q6tAOgNe4Cv/1kbfYk9yiEDdI4uU7SSkXF6Yi8CclY6Ob1paU2SCbyma6sp7GFQHgXIL36Prj+XHkrMuZlYJIaEs4zpik+2RjSZwQv8ru8J4FiG5b3mXYSHlwC5F5Crx5BhY3RgodG8D763FGrWwp7JK8KNJGgLt7/o6+rhrB9GRdFMh8KCIn6riwRDWZgpGIkOlZjiVcqagh/Ax6IwSOvvJT6SD6SuLMfZsL4FtbCAy5IO4A5LMaeYCCI2kPQV+Ziam+C0a1X1sZS0L/o1vaGkvKNUlliaQYtrP1sdqWtI2m3iynuRtMREw0YAqtnepjmusPUbjwv0beLQ9S/7OWt8tF6gnG3P8n428sO9wvrJr0WWPAykIfwTVyucgovBboKtDCug6CZWzZRcYAVIfyk1R4iGg4wIkaUMhaMtLMS5Tcx2FBWoVvbShdq9EX8QIFYF72XV3pUOKy2KuhFoYUp0gkXPA6P7L6Tbb9EBpoA2XLdjyaQ+KaxNZDQueTkDuIl492+63rNzhs44EoB0STUFR4B0IuBlhJ1eAgtzzfhfYVRhi+5M1Umq4RWsqhCItnQgcgvpv9R9rLxjaHBsTbLewfaCIeFMZg5dRaxTvGT+jytthCGgRXKvOiaDl5ZcMgKwZLej7FB03bmcOihZkSSVSwp2WsH+LCPhaVHJI5M2j7Vx0Dk/5z4K+CdkDNPIJoU/eUQyJVXhVJTRVydyT2mi/Ty5UUdqeGpOLxFFlhImAgSAm
 LDTZT+ni
 oX55UjNLsL2sRUNNOrKEyMmRs1Y2RLrrnKSsVxJDHgOxyqLDGj2dih1sXqLw2/JdDlpCBdrlp9ea8PInMJUj994pfdUVlQ08BsTdep9KyQh4mWiK1id0uOizR9HTLYC0H3n9OoXX/Y6pa0SJ0korphG2KZmcdyJja5yFYY2uTJK3g8e5racztSpDmQXHYiZjpdb+IAW4QVHJn8XHvtnWvekh4bB2lUZVAzlP09OloMsj8eZLOAX9vUx8maBR5qCGN4VcUoGS2HYpVlDjVq1h5T7+XrBrZB7noyyjRFcyMDEEZXiNUqoTF4eSCoN/viJtBRO63
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add basic manipulation helper functions for damon_sample_filter data
structure.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 include/linux/damon.h | 15 +++++++++++++++
 mm/damon/core.c       | 45 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 60 insertions(+)

diff --git a/include/linux/damon.h b/include/linux/damon.h
index 78be584ce5dd..aff34dce7c7c 100644
--- a/include/linux/damon.h
+++ b/include/linux/damon.h
@@ -947,6 +947,12 @@ static inline unsigned long damon_sz_region(struct damon_region *r)
 #define damon_for_each_target_safe(t, next, ctx)	\
 	list_for_each_entry_safe(t, next, &(ctx)->adaptive_targets, list)
 
+#define damon_for_each_sample_filter(f, control) \
+	list_for_each_entry(f, &(control)->sample_filters, list)
+
+#define damon_for_each_sample_filter_safe(f, next, control) \
+	list_for_each_entry_safe(f, next, &(control)->sample_filters, list)
+
 #define damon_for_each_scheme(s, ctx) \
 	list_for_each_entry(s, &(ctx)->schemes, list)
 
@@ -1022,6 +1028,15 @@ void damon_free_target(struct damon_target *t);
 void damon_destroy_target(struct damon_target *t, struct damon_ctx *ctx);
 unsigned int damon_nr_regions(struct damon_target *t);
 
+struct damon_sample_filter *damon_new_sample_filter(
+		enum damon_sample_filter_type filter_type, bool matching,
+		bool allow);
+void damon_add_sample_filter(struct damon_sample_control *ctrl,
+		struct damon_sample_filter *filter);
+void damon_free_sample_filter(struct damon_sample_filter *filter);
+void damon_destroy_sample_filter(struct damon_sample_filter *filter,
+		struct damon_sample_control *ctrl);
+
 struct damon_ctx *damon_new_ctx(void);
 void damon_destroy_ctx(struct damon_ctx *ctx);
 int damon_set_attrs(struct damon_ctx *ctx, struct damon_attrs *attrs);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index d2f842d8afd2..4b98473eef84 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -533,6 +533,46 @@ unsigned int damon_nr_regions(struct damon_target *t)
 	return t->nr_regions;
 }
 
+struct damon_sample_filter *damon_new_sample_filter(
+		enum damon_sample_filter_type filter_type, bool matching,
+		bool allow)
+{
+	struct damon_sample_filter *filter;
+
+	filter = kmalloc(sizeof(*filter), GFP_KERNEL);
+	if (!filter)
+		return NULL;
+	filter->type = filter_type;
+	filter->matching = matching;
+	filter->allow = allow;
+	INIT_LIST_HEAD(&filter->list);
+	return filter;
+}
+
+void damon_add_sample_filter(struct damon_sample_control *ctrl,
+		struct damon_sample_filter *filter)
+{
+	list_add_tail(&filter->list, &ctrl->sample_filters);
+}
+
+static void damon_del_sample_filter(struct damon_sample_filter *f,
+		struct damon_sample_control *ctrl)
+{
+	list_del(&f->list);
+}
+
+void damon_free_sample_filter(struct damon_sample_filter *f)
+{
+	kfree(f);
+}
+
+void damon_destroy_sample_filter(struct damon_sample_filter *f,
+		struct damon_sample_control *ctrl)
+{
+	damon_del_sample_filter(f, ctrl);
+	damon_free_sample_filter(f);
+}
+
 struct damon_ctx *damon_new_ctx(void)
 {
 	struct damon_ctx *ctx;
@@ -561,6 +601,7 @@ struct damon_ctx *damon_new_ctx(void)
 	ctx->attrs.max_nr_regions = 1000;
 
 	ctx->sample_control.primitives_enabled.page_table = true;
+	INIT_LIST_HEAD(&ctx->sample_control.sample_filters);
 
 	ctx->addr_unit = 1;
 	ctx->min_sz_region = DAMON_MIN_REGION;
@@ -582,12 +623,16 @@ static void damon_destroy_targets(struct damon_ctx *ctx)
 void damon_destroy_ctx(struct damon_ctx *ctx)
 {
 	struct damos *s, *next_s;
+	struct damon_sample_filter *f, *next_f;
 
 	damon_destroy_targets(ctx);
 
 	damon_for_each_scheme_safe(s, next_s, ctx)
 		damon_destroy_scheme(s);
 
+	damon_for_each_sample_filter_safe(f, next_f, &ctx->sample_control)
+		damon_destroy_sample_filter(f, &ctx->sample_control);
+
 	kfree(ctx);
 }
 
-- 
2.47.3

