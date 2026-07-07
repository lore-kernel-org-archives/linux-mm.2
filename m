Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FE0BC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 04:39:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 119F36B00A3; Tue,  7 Jul 2026 00:39:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07BA76B00A5; Tue,  7 Jul 2026 00:39:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9C36B00A6; Tue,  7 Jul 2026 00:39:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CA1496B00A3
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 00:39:11 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 52D0EA02DA
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:39:11 +0000 (UTC)
X-FDA: 84960726102.06.A53F43F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id A969FA0004
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 04:39:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ouIrKoiU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783399149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+XSDJAwa5tXme4d9cp7HNanm6CROUB+NOag32I1le3g=;
	b=k3ajsJ1raQXq/udb3clSQtwgUJ4JSZhqFRJ9dz817ZbLidsw0rSdc4i+pmEpp+/CyaMcJf
	ivzvo2VXnvdvyiqHkXCDfnagg1M600kPMm3DZ3i5A/Pryuy/WzPCXpmtza18ujOmTorlrS
	GygMDUWxp8jcIGp4ephPJ+nfUj3UI7Q=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ouIrKoiU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783399149;
	b=JisgEaqSHcUMyx9e6Z9grJl+oDVDigrtntynxfieKhtTjLdDwbmv+c8SV38L0NDtGwiP+w
	w5yghR0kmA21E9b2AISDLNXu5E+jaAuRSwyAxyoewfkk1dYntzvFXwb0pCVB0I/tv0o2kg
	mz+4tS8w2r7ocho/lJEZHXD4ClWxcl8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 076BC4168B;
	Tue,  7 Jul 2026 04:39:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 564D31F000E9;
	Tue,  7 Jul 2026 04:39:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783399148;
	bh=+XSDJAwa5tXme4d9cp7HNanm6CROUB+NOag32I1le3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ouIrKoiU9wgucKy3Mox6BiQ0RDq1VRQORbJxp3J5XvsGwT9XxiMClXsae+fz27ZEY
	 0yQ5NF9QFJYJZXDxBpmWLS0hYJnby1gpY88HT8DmAN3T4myvAvcUtsp7JyeOZvW9Yg
	 LFzd1zubKI0JOTdgrDKygsY4ijD/k9fn6uEx2ZiK0SJTUC1XaerZvh/3dDW/qj157D
	 qQaHVzfusjRud5HetQ02epHcanYXMqSUWOPFsMa0IsPzewlEST51kWB4Eex7Peiyk1
	 Re9D/LexNfmU+Z3XcZINE+dkk+t/AKf5ePsKiguUjMjGyGvkLALQ/m1S//629gObsd
	 TKNi0M4TeeG+A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 5/6] mm/damon/core: update probe hits for new parameter commit
Date: Mon,  6 Jul 2026 21:38:25 -0700
Message-ID: <20260707043828.97900-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260707043828.97900-1-sj@kernel.org>
References: <20260707043828.97900-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A969FA0004
X-Stat-Signature: dxtjjhkkqj6n71axoawpkjn5ohso3zmn
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783399149-776580
X-HE-Meta: U2FsdGVkX18Hn6KVVpk+mp4/tTRamV3Q8Yxkm2la1MsvT4wFtsSssoTwvR6BUyyPhWcuc54Lfuvnc86UuT5JlGAFvJkQDwy+gPB3eJRCEGqQi12o63xePFgHb+Y5WGnVC3MJ0/qjfi0jk/GT7aBg8G9j+WVMOoHQQTScokMmpZPe4cS/ZVUOlHCRmaIa/Z15Lx+z3jnYcRFPhL+R4AfiKbyS/Mta72TtOOF5SK1dakSQ1cvuBobma+jXYG+/K+rcARZrMT0csM7ZvpOM7RCb3orOcSRd2l3c8Znc9c5pq+RQGXqwJWUONL9yFTjc5ogjKpjsXQuy9jAUFnvIwXkQBYojgQ79VrTnwxDGZyA89uO9SZ8Rl+qlsbYTTZv06CaO67Aeqy7yj1AdM0svytuIF+x5OzLjRbrqSKljvDx2VUMV5pJnsuXZpSNGYswGp2AEGyxWAuMTx36wCy7KxWVRykaG0Xwh00DdauvGg05zImFvJ+nSCxgkfMs6SQCiQoC6HzjnCzW5QgBt0bNPZNh+4aQT7TZoeb7zp36mIBM9o8jVy24hOJlj2BxMRPAOBKdm/HrfGC9Bl0SSGJn0DiPfznlB2S3ASYhUPOuM+j1kzAG0bFcub5luZSIr0YCIsCPoc2q5XQJAyLaMAsd2MHxq159BM+q9adZsB5OizPfA+TVukA5s/tmGGRqclgVTYrMqHUYhb5AhmcAZrPl/tzZCctLPcjrVguudPuAjLOQsGv/3ogHxO1zOqx72StBK0DJosaNfglLhWe5QuPGqG/LvEMIiNpWeodYqk/kfcxVBu4HWi0UU3x4UTKsxnfNNRf3016X1HvdtWKaf5xAfaNavmbjklCiGmF7M0TaGPjuOq1eJ/VtgzXDLkR1EZb16Ee6fjjJKcWqeMtZp4m9dqOmSWxqiHjCVj2VEcw6ad1TJV8UmMY9DQq6btYhE0u2gC8fYGbGk27bKxG72oDd+zo7
 YEVOHDKD
 EaueRHihktmwpxP530kHRHm9ycQSjhL7qS+UzCgmXVN9WfhJGB9NcCE9US1/VP91HaSEYijEtOKD10P/mI+Cf7J8ZQx5zZ2s+LW7TkTFoeceB5vqXG4/TlU9xigTc1MUXx4asYqgQ9J8XG3x1VX2g3/X/kGQWH/s55leyRmHFVE5r8eYy8xlf1wH9eM4GIGbAnL1V+JNwMdbZYBimokXyfoemIM/qLIa6/w5FQLsVT5XLbeo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Users can update DAMON parameters at runtime.  If the samples and/or
aggregation intervals are updated in this way, monitoring results
depending on the intervals should also be updated for a more accurate
snapshot.  The age and nr_accesses are properly updated, while
probe_hits are not updated in the way.  Do the update.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             | 28 +++++++++++++++++++++++++---
 mm/damon/tests/core-kunit.h | 13 ++++++++++---
 2 files changed, 35 insertions(+), 6 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index cda318806b65b..9a3ff0fe55a61 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -898,10 +898,32 @@ static unsigned int damon_nr_samples_for_new_attrs(unsigned int nr_accesses,
 			new_attrs);
 }
 
+static void damon_update_probe_hits(struct damon_region *r,
+		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
+		bool aggregating, struct damon_ctx *ctx)
+{
+	struct damon_probe *p;
+	int i = 0;
+
+	damon_for_each_probe(p, ctx) {
+		r->last_probe_hits[i] = damon_nr_samples_for_new_attrs(
+				r->last_probe_hits[i], old_attrs, new_attrs);
+		if (!aggregating)
+			r->probe_hits[i] = damon_nr_samples_for_new_attrs(
+					r->probe_hits[i], old_attrs,
+					new_attrs);
+		else
+			r->probe_hits[i] = 0;
+		i++;
+	}
+}
+
 static void damon_update_monitoring_result(struct damon_region *r,
 		struct damon_attrs *old_attrs, struct damon_attrs *new_attrs,
-		bool aggregating)
+		bool aggregating, struct damon_ctx *ctx)
 {
+	damon_update_probe_hits(r, old_attrs, new_attrs, aggregating, ctx);
+
 	r->last_nr_accesses = damon_nr_samples_for_new_attrs(
 			r->last_nr_accesses, old_attrs, new_attrs);
 	if (!aggregating)
@@ -941,8 +963,8 @@ static void damon_update_monitoring_results(struct damon_ctx *ctx,
 
 	damon_for_each_target(t, ctx)
 		damon_for_each_region(r, t)
-			damon_update_monitoring_result(
-					r, old_attrs, new_attrs, aggregating);
+			damon_update_monitoring_result(r, old_attrs, new_attrs,
+					aggregating, ctx);
 }
 
 /*
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 86eae3a590354..8e01437eb5ea8 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -603,32 +603,39 @@ static void damon_test_update_monitoring_result(struct kunit *test)
 		.sample_interval = 10, .aggr_interval = 1000,};
 	struct damon_attrs new_attrs;
 	struct damon_region *r = damon_new_region(3, 7);
+	struct damon_ctx *ctx;
 
 	if (!r)
 		kunit_skip(test, "region alloc fail");
+	ctx = damon_new_ctx();
+	if (!ctx) {
+		damon_free_region(r);
+		kunit_skip(test, "ctx alloc fail");
+	}
 
 	r->nr_accesses = 15;
 	r->age = 20;
 
 	new_attrs = (struct damon_attrs){
 		.sample_interval = 100, .aggr_interval = 10000,};
-	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
+	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false, ctx);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 15);
 	KUNIT_EXPECT_EQ(test, r->age, 2);
 
 	new_attrs = (struct damon_attrs){
 		.sample_interval = 1, .aggr_interval = 1000};
-	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
+	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false, ctx);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
 	KUNIT_EXPECT_EQ(test, r->age, 2);
 
 	new_attrs = (struct damon_attrs){
 		.sample_interval = 1, .aggr_interval = 100};
-	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false);
+	damon_update_monitoring_result(r, &old_attrs, &new_attrs, false, ctx);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 150);
 	KUNIT_EXPECT_EQ(test, r->age, 20);
 
 	damon_free_region(r);
+	damon_destroy_ctx(ctx);
 }
 
 static void damon_test_set_attrs(struct kunit *test)
-- 
2.47.3

