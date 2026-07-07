Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 371BFC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 13:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 840E36B00B0; Tue,  7 Jul 2026 09:50:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C9AF6B00B2; Tue,  7 Jul 2026 09:50:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6911D6B00B4; Tue,  7 Jul 2026 09:50:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 30CA06B00B2
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 09:50:55 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BC1491C7B5F
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:54 +0000 (UTC)
X-FDA: 84962116428.20.538364F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2947EC000E
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 13:50:53 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HcpfY5Cp;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783432253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mSLKaa7yn0oJb/A+VytGndaYYZZ4X6C/aSyAoRapHq8=;
	b=1ph3F4GTYxohiD6C+7cuntcKs7s1Pk6NfldgmBgasPFJaI/viHb4M1FGc77fSPqKvm16hk
	x8VuYgYOHhVI9762QeeIjNMkBgpz2FYrZEknwAozJZ7RcN3TotBWMZP9uTBkpkMUoSA6vO
	/jQtdxrbHubwCKNFtFCjhPuqZ1lJrdE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HcpfY5Cp;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783432253;
	b=Qz7v9pkIaGepP8iyaxu2rStqFCJRtdNiCl2w7tibq3NpTlUKhnEaaOA22Yabwf46d1/c/1
	B++S6Sy8w6Nz95q6KhaXQ4rYYDt1/3KTzBWfmwOnqvHxKjJLOGLjGhwKa+loIckRB9PaNh
	3vDUgwKo/StuGGBhNwi3ExQgzbuibUw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7B9DA43CF5;
	Tue,  7 Jul 2026 13:50:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36A461F00A3F;
	Tue,  7 Jul 2026 13:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783432252;
	bh=mSLKaa7yn0oJb/A+VytGndaYYZZ4X6C/aSyAoRapHq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HcpfY5CpzJLvJb8OYL44EbLc7umxrd2jn0A+J85NlqQ+b/5iLnqdpee/RnCj2FApJ
	 GMxI7EY2qDmaYg7zYMfSY4BYc90mVlZ0RQETc3LJZauFc0mulYPwgFW9gefAypZJJu
	 REg2kiQmAftKvi60QWepshEnaDUCojit+N6Sin4TiOHeyS7Y/gOiPOi8u3j0aibVF0
	 SVUE0NRu1Y2CV/NbI3ao1uxl3Ke/XXzfn9eVK8B6yKhxRCK0FvtaWKbUv1EqUZ1J0u
	 GApy4J9nvkvx5lD7Yv3SZyrhF4bgVQycXAnBxl+cmlivlUTtBrtp1iIQpbG8a2HWlD
	 2weKb2k1TUcWw==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 6/7] mm/damon/core: update probe hits for new parameter commit
Date: Tue,  7 Jul 2026 06:50:35 -0700
Message-ID: <20260707135038.90068-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260707135038.90068-1-sj@kernel.org>
References: <20260707135038.90068-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 2947EC000E
X-Stat-Signature: du8atr3ddsnmd7ow5srbdmuz88dnefzj
X-HE-Tag: 1783432253-603889
X-HE-Meta: U2FsdGVkX1/NftMflZUMf6kYUyhPrMR57jrj+4UVrjBV6onvFPW+XkjKQVtaKePW6Azy8u0JEBflB43haL9cmZ3MAFIjtB8Ytq0tf9qXWGREztNcC7S7u4MbLDSuqhWuGmNwdcsx0eBXridXrd1mv+tyoeVrSrQV4auIAE3Wz16PdIlhPmueKpLVuC5LrRlw2dMYC5obgXn9/7k1fyzB0j/5mbmh5xw9LM3DlS9IAyu3yzr7JLadrcW8TNs87/+qW8a/MdiEbMwUb+mN0knpfQLQQZce7LiFiAFdTorIIasfkleaerG+C88lD+G9wo7P14rJvROZ0tGm/YbycXt93uenXj0FL8RP+qvg5lefcLfvGqrDeBFHVmbQpoO6YYsQbf6rB70VeqXhvGMWUmhf/4Fy6FdGdJQ0R1SchFlPiM4nimMGVVGa6Pkx+solPriXG+iVWn6iVv6fXG9gTSoQUa9apgOXNtOjpzqOxNpbQNQtWgCzIy3Qj53mIPomHg/mJRQikT5qSLJimjusup6H82uRKAZTc+ZlgkM5KZNXMwPRdVg72eay9dgNGEfo+Habzymxe0yKnfHdLL0HygjlvHkwxd2f9i95asID1pPOqNYaWgkPqIML12jLC9oLVZjmzxfqWfldFOUKpKyWUW9xSfzuHU2c0+8cCBzw/w8NAnZ7suiPwsQpnV5igQwrnhDW9DjgOP4KVcRclS1uWm1rbQqEuezGQmRCilQo1U37whWH5+mMm7dJPrgeRn4dRvx2zaSbwwh+PgHEUGwhCKbMG8RzY8orocCYTbRbkqevsnWhyPG0WYr3/VciNdYKBseCSOeX0jzSJXLTtIrdVm/6MaiR4jYlfH6aBtu1kcGAIIULBamXdV8hi/QkYs8q38NYRDIn8xL4H1/7ptF4YTm8iNY9UiVhX1i/VKqQ2pye+777SHnhzqKmc/QqoF22B1qZVNGBmG86R5Pm0wpC+xC
 WtzmAnlN
 7fOu2AqBAQZrCrRF7vZeY8jK7a1sxEmTqLmI3EgDCHELbcektja7Y1z2FICHZjVUCiKq26OOgLEmbZfIyomJesSug4Gj8WBSTHAd9xdz4TdeYbbmPd9t8aQsYb4ua0k5ikrBaabiJP0GaNPj9t26NDoIUAAWO1q1IoyQ1PjOrSYuU5CDhjetIEa39Yf3aHlNIcJ7FjhTkkxPMH/zGypoxAfre58eD0YDZgYqpeZj1WQmvaKY=
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
index 9e631b19b184a..b4feef1a460f4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -591,32 +591,39 @@ static void damon_test_update_monitoring_result(struct kunit *test)
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

