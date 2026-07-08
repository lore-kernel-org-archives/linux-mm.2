Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 169B8C43458
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 13:54:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3FA086B0095; Wed,  8 Jul 2026 09:54:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30EB26B0098; Wed,  8 Jul 2026 09:54:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 224236B0099; Wed,  8 Jul 2026 09:54:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E92326B0098
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 09:54:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5BF4B12013C
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:09 +0000 (UTC)
X-FDA: 84965753418.28.9C7FFFD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id C8844120005
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 13:54:07 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XAFZ8Sj1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783518847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ICUXWtwPA7N0zgAtv6Rd+r+IHx0h0YoQN07O3wyVQi8=;
	b=xQtxg/r7siDOvQR/pgnEl5xZaMAyuy+d+QVz/7aGfRsjoYRRw7E+aDO/qox714zAQlQB0d
	op7EZ6xcvOWEkr1qKdCh6a6RG9gbfxVHYV76Cxm3fMtSLAFpGxRoqOFqUfyKAJWcTJuIuw
	V8jVOdKQQyHEi5PW3r1aLVtUSIbz3fE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XAFZ8Sj1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783518847;
	b=azeZEJTj7TE6w1Ml5hrP3hqfNqq1Ufe5jrW+7r1Hmr/JLH5I00/l51HmFk5AF3uHs+hyOy
	KnRVMYM/iCk2ugUXBN/6Cm6NeCrd1SAMPFWGX0OxC2PY/1lRQBPx6J7lJMnbIQfZpJeblu
	Ty9bkjMZx1PQ6kiebsGZfGBe/ZlLTUg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5295160008;
	Wed,  8 Jul 2026 13:54:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C16B51F00ACA;
	Wed,  8 Jul 2026 13:54:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783518847;
	bh=ICUXWtwPA7N0zgAtv6Rd+r+IHx0h0YoQN07O3wyVQi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XAFZ8Sj1qWW3cLSKV/qcACmPCYLQg9p2LJLHoTRkjpeEXL5MD1N+0htJQGjslM+hE
	 /3BGo3uNcaa0eyILOC+2JtQn8vhn/1vGnZ8wDSxsZNCecEUTJ6EjzIClVqXLHyMzfp
	 QyfMLAygMZq355N8VQViE4vpua7I14y7P0dLQDIlOh/uL7l0e6r2ca2LNRXzwWPoz6
	 uy9OxRQwsIOJwjLxzUjtTAW4GBjncljTGlvanVTvYLz3hSjjw2qYFS4x6JBTW1lGAG
	 CpxOCYzmKoP7hNz8gUjZy/Kvh1H2V1NMNRRBb4qVcW7fatkXJr11VyuLVjTIopcYds
	 rCnwvoQyAJJHw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/7] mm/damon/core: update probe hits for new parameter commit
Date: Wed,  8 Jul 2026 06:53:56 -0700
Message-ID: <20260708135359.122587-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708135359.122587-1-sj@kernel.org>
References: <20260708135359.122587-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: C8844120005
X-Stat-Signature: 6aikc51p5ubcu4398zc8xch7m9ay88jq
X-HE-Tag: 1783518847-859448
X-HE-Meta: U2FsdGVkX1/PGC7hQ7F0+Dgyz1CbwvyIeuKuW9+x0C67Bqxr3VHmcpdoWCj+PqlH5CXYHKUpQs9j93qfE4Xi37v1f2fl5yRWoBohRWd7co78IB2Hb4WnnmDlxAIAl+5uhGJDh4kKc08TeP3sNNvvj70C5a/UC1/MKRxspBexH59dcAj8NyIocdkm1OSFpSgFgMTATQJpiX5d407kAxLYi2ZYsd3BFHcALq7W3fqD2UqRNA4PKj3y/V1IZBmLA9fXu/OsJQAXsd1Au1nLmjUBnvs1z0gjQDg4Gz1HPnINKwhxl/N982Un8uyuj5wMQkp95ptKz23a6e6zimuxpMkFMAHyW/kD1+ihA+enXihu9bKpShjUOLwXLr0xJo3s7QH8GXNgo/pKmWL+VQHz0VkPjCVANdVuJLRVOImpVBkpQM/UrsvudH3cuHDScw4r98YW72O8IcwcESEUqfLTcYwtlNj66vWqUpALj7NhKFbXxDq9M8u38CWlesQuOzU1Q6HDr+dZmHlkXZ0OQx2+7VxdukbKH59giRWkZWegmfoltCHb/JFmM8iBrRIgcmFejlNI+h8OwHGocMK3pJ3+SGeXsQr2oMROCLYx0PKLYhum4KtBproV5n3ZDD4No5Ir13Ewot1gPp61Yfsmq1R5MNSD8EWe+lAtOcSeiSUeqiEVuHjjKcST/ebJZkoAVkMcfHzqaqFmsgepwK//lxY3aCytr8b7t2LjLnvumbYslc9QMCgpG8ct+tXmvlkywjCbPkNHoGjAyzbLwJR9ThdWoA3iAb+TuPlrROFcfWEksH63Wi+40KVqNLrnodaEpf7NfoRMVmruc1ceu1GCO39yt3n/P+p5t1XlUdHOTNwAjppfeZY6zq6O2pChlufays3Ij28E7w/vpX8NoCYkJfy2mCaS6hdHPPTnjMToiSeTGwaZ03ZVITSqWaQL0o6lLegBSr5NQ01Zv7WxSs/8AYE3VTp
 7Wt9c5M8
 896z1b8xmCcYm0nMT9m2bzG3gAbPhj2HnELEnJzlXdBoIbyIuuuQX9RvH8GyAPE4aOkDWR2zCqDcwXAC0tU576kgoLIA3uXRtX0664L39CG+qA/YOQBHUlccA8obC5uG6FqtF9ZsPGOqKeYznv4LbUN6PwwdOPYRmn6JAS5Z7QU8dABpWRup8dG3MwDZsZ88vENHtODGjRQfCv6k8p0bTJMT65t1VYCOj7j6pO/sBWhH01G8=
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

