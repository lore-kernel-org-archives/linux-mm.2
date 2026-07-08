Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB2A7C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 02:49:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FCEE6B00A9; Tue,  7 Jul 2026 22:49:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 287486B00A6; Tue,  7 Jul 2026 22:49:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8B76B00A9; Tue,  7 Jul 2026 22:49:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D42FA6B00A4
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 22:49:08 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 586A11C3C42
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:08 +0000 (UTC)
X-FDA: 84964077576.30.02DBC23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id BF96040003
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 02:49:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zmx0Ebq1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783478946;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICUXWtwPA7N0zgAtv6Rd+r+IHx0h0YoQN07O3wyVQi8=;
	b=f5nsGbovqpoEjRh8gH6D0lHyDNiHkdWx3VNUS2cZIklpT3TMdm7uPJcUVuqHXeaYEE4drj
	lPkGPGPtpTNNRAHMNz3GJYm96U2FdDgaaT5GhAWo9OahenC5gp8wFN8gO+kacNmgUo3/0K
	nZvJfUMN08cqj/tKxkuFdob9y7Y2pNY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Zmx0Ebq1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783478946;
	b=EkS85DGaRIHG6Mzun6YzzusYOt4tI9CHHqWJ55IUIh6Vx8+t+k9T8SqH2gj6AuGyN6V4Oh
	+pJ28fiGtdNErHnokoE4AsmNI9vfYecd4+GMHxtQmFK/OPXDN5xn7MJNWrAR/AmHPBDpiC
	VcdP6glSG1s1ouRndX4tdSqLkrA8GLI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 165B060EEF;
	Wed,  8 Jul 2026 02:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 946CA1F000E9;
	Wed,  8 Jul 2026 02:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783478945;
	bh=ICUXWtwPA7N0zgAtv6Rd+r+IHx0h0YoQN07O3wyVQi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zmx0Ebq1MexgnI28uNAWoTO8oI3bmyirCkWuoMp0ZpxH3C7AJ6HW5TElD1KBNPicw
	 y/UNYFYm+rJLer043OcIKx1eKnXizfe6byE0ARG+s7NcgzD0guYkkZtV6psxrOJqBO
	 RNKxvxXgQWPXdSBJKwZpDi2RxI0fMeOxt1flbdc8C1CFuceQmcgWvlTZ1nPb1H/E6H
	 q9SV0jLDLSNCtNvw4Tm4lRrRNIg0fNfAfe9WMXt1ylxrhFQrqGT56rviTWjA+ZjpaU
	 rWgQpiV4ikicfx/czPNL2h2N4VR1hyCzMqa8CdmkiB8vSvOTWb+U9sX5wZUvMwtgua
	 Rh84tyDHcbsUw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 6/7] mm/damon/core: update probe hits for new parameter commit
Date: Tue,  7 Jul 2026 19:48:52 -0700
Message-ID: <20260708024855.116614-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708024855.116614-1-sj@kernel.org>
References: <20260708024855.116614-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: isrtnnra5f7p4rduh1dthjec6qey74mq
X-Rspamd-Queue-Id: BF96040003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783478946-302905
X-HE-Meta: U2FsdGVkX1/9tavXDaiyNH9JhJ/zdBR+MYl84KR2Ttj81R24KfPI1kog4djF/LTc3qMYiEV920jBM70PJXzWkPHIU5e8gxrHzWRg1TllG4E2RrywOV1DD6+xXocpf1RgUczB/ZEVFK24RxxWX/beXAeBdbW8j1LjK4v74p+WKx3o8lEdPYea8++K9sObImD0eIXN//lE8J/1WFPNT/1IEWIrhoIp4cuMkFdvFIIYd5wjaDGHPhVjxK7XtOhaeTkGZwE6KpGSFNC3JSqJgnlK/66Uh7rxMmEmw39rrlkMLxzc4WMLOFb7CofmMSDdclIfHdJOEhgKzfDY9WKBiUQOK1Hy8HLghrQo0AXyTlJ8IQz250kuonJxhlHbUXZ/MEjPfT9SoO9RMjKQXyYn6VVJhNwT31IIpnmhUgwHKlhhfCk/EFHKF3I5zBjXLLZ7J/gfTx/gt9OlTgxBuyoHn5UczUe+6ELcqaMz51xqFA1FzI3ClMzTgbOBNf7E0BvySG2qCro0bNjlCvG36M4OoVeX1DNx41kK/JZbPWCZJhXzt90HCJWo6lSw18GWKoFYasgL6bDpwBiTMX64KVrKoGpx9IYlzMQfNuUM239LAvpLIR75fBTFGy1kLlcY5YyRBCer4NiAuPVwxJIOJdoEa5KY3KOjkf2Mr1uEwDKaRdr8JKTdU5sPVGICslhw/1xhq5Zv0cJNylew4wytQOYVoN1Pmk82utfVCFEmAM24VlAEiXMfykLv3rPQlBTggufpSqR9pE7J9rp3P/vKZzigKbjbiZ/C6FWDIuRO1iafLLYbU+pgYSJ/aV6bVVjUqeNrGQvH92BSAl6DSkKm2AUaNHoU77u/Bq/Jg1QOP7joxxYm6LoY8pkA1NeNS1WmZMDoKF3nyct5jXbni8hH1iUWIYbYpjTc5D+kt/2TXEabN+wZJi2BQjVpXtXTmkhlTE6AHTuFu1ZUNv1j70Dct5biAfl
 21eQ25Ou
 ntaAVGTeEgMeA39ynrOmLaZc6PeeV3Cfr3pQth49kTI255IjtxEPsr71spZwqnMMaB3SHoxLDjXoDqMtt+56VisbbVmRMSjnAJIQwSVUGa9SpFPy1w3pE8INFxqHcerOf5SMD5ycGIIyfHXUbEpAhN9gLXuU78uCHzpnhNMT1vEd4dlnIHu59aUtONRPvvupv6WPP0IXAZHuHYszxJ6WCDsgYl2jvXT3l3oBHRHcUiuBYOrM=
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
index 800ff6b6d2473..15d31285515d6 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -897,10 +897,32 @@ static unsigned int damon_nr_samples_for_new_attrs(unsigned int nr,
 			damon_sample_count_to_bp(nr, old_attrs), new_attrs);
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
@@ -940,8 +962,8 @@ static void damon_update_monitoring_results(struct damon_ctx *ctx,
 
 	damon_for_each_target(t, ctx)
 		damon_for_each_region(r, t)
-			damon_update_monitoring_result(
-					r, old_attrs, new_attrs, aggregating);
+			damon_update_monitoring_result(r, old_attrs, new_attrs,
+					aggregating, ctx);
 }
 
 /*
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 278d46632eff4..d97280270c27b 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -581,32 +581,39 @@ static void damon_test_update_monitoring_result(struct kunit *test)
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

