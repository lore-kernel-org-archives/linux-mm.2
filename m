Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2F8D606A337
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 21:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Waouwtiq
Received: by kanga.kvack.org (Postfix)
	id 8C32E6B05B3; Sat,  7 Nov 2026 16:45:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 84C7D6B05B4; Sat,  7 Nov 2026 16:45:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 739FD6B05B5; Sat,  7 Nov 2026 16:45:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CE556B05B3
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 16:45:39 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 88F16A03AC
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:45:38 +0000 (UTC)
X-FDA: 85409655156.15.122685C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id E3634100007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:45:36 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Waouwtiq;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794087937;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nyCIxBA5mJ06vHi0FAU5PamOp23wz03gHLUhBxnc4Z0=;
	b=unY7gceFqeyZ2PVPsZUJaR56El/NV1CCvHyDDpCQpJ1v5iB89OeMscOdw1tCLBRpeZJ9jF
	zNUWeNkc7Gm5T2S6L5+rPvNIwS9M+yUICCExNhyVhCTnwlOR+5DRBI6a+q3vj0lLW1vMGT
	iY13mKXLJGuDD+CSe3xp6da1kHV7GpQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794087937;
	b=a1q5tlCJg+JYBh4ohi7PjMAwHaC/avcxPzJLO3YL37rz6sK/5N9nZ0OIdvACF9/3TP7rUi
	SG1rzCq9XO+pQr3LyijmPYsqqSJyQVL6hbj1VYJ9jXwue9K+xskJeeZ6VKU+FT5AHi3pcM
	8jQd3uYroHdMqGgA0tELSsLgaXW+Bs4=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Waouwtiq;
	spf=pass (imf05.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 45ECD4469D;
	Sat,  7 Nov 2026 21:45:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EEE1F008BC;
	Sat,  7 Nov 2026 21:45:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794087936;
	bh=nyCIxBA5mJ06vHi0FAU5PamOp23wz03gHLUhBxnc4Z0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WaouwtiqMvq5L/CDViXEiAdw/ify/xGtuBEoGC+6GV4wH3ZjrEhVyp1IXJeFliMGU
	 oADm7fa9Oot61Dq9T/QSCq3mKpsEeEaxTptLJ4FJJuo9RWzKYTQudvMWhCdg+Ts/XP
	 NaLfACOcdoKZYCqxKqFrqY+V4vwguWrNLPoy4SS4JBNioPAA0iwlo3KCZvz8PtlXhW
	 gByffuXzLXe2qT94Gml5QrWNLmBGbLnvOxSpLM0vyox7R8YuErLavXqyZAJwedZ3pw
	 6c/xTnnkiTa0AVBSvybrKW8Eca8wfCnsgSL30JeU0fISFGFCFuuwVaaLfzpUcUoHj8
	 F5aPM7J1o6NTA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.12.y 4/5] mm/damon/core: filter out damos address filter-split failed region
Date: Sat,  7 Nov 2026 13:45:23 -0800
Message-ID: <20261107214525.304638-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107214525.304638-1-sj@kernel.org>
References: <20261107214525.304638-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E3634100007
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: csso5rj1hbhs418fnjd5k8r6jrtgii8r
X-Rspam-User: 
X-HE-Tag: 1794087936-288833
X-HE-Meta: U2FsdGVkX1+5U72sYC5YPFkssPKrLL+zgNNVHIknxYLZ4t8O3hFd0Jwc5isfS7AnmJQ/YrGqqjaSCxsjC+P2N7KyafJPmhG46BqG325EHQgF2LvNxqHyoEKogojTgYSMxYjM+barpkER7hGMIKdH+Z61eANj/2alzkPSn9vFGmyY5wM6oKFarYDDSLzAAlbHwb2oLY7bXuZB7hGOkLek1rK2vqhBLEcZypGkzPqnq5knK3XZ7WOYNFlJgKeU7QkKNpECkRty5h7mrlb2xb3pNcY3OoJkcId1C4wxecz5C9XvTL08akdel4aJdxoLj+n020lfPWE9w7b3iiqv/56pcMcZNB4ayw6P4T0aJpAX0P3zoJjti6RoRa7Mmr7sGfMK65oUPbdDgBwWCRJK8H+NiEp4Cqpb0untjHQUj0AnxoU5Rs2Hf8EeP1Cf9v1TTWAhjuuAdcAZMkBDR4a22sMLaNbcKeh8xer01FF9M0rUe3qSuKYhXqBcBIuWNg2vQp0uOqSCMMBZiAlZbDTKDRcHb3hCBaD0JFjwpiZ+e4pw7cg+Z217oKPJ86Zf5snkvXfnjTd18efGLgEBp/4oMgB5hY6dr/Zlkc2tGHotY2wCbSiOj+TW6A/gdRI1sVIw7BJwHLvZJndPk5QYWVhon5kjpT/n+HQWBA5D6QSoGqVX2pl94dPYIncUwrbKLVWpmFqe/FIuifmmKAfCSTW/pczCpCffk8TS2XAcxHZnJgScKTXMTpEYMO5ZcNUWtFaeSY1Sl+uNdngjJVCKjzds4rWt79LtNw4KrUdhouUZkcFO0kb3eXPGQfXMFwoAd9ebtSBD9EYz68pXkkAvwl7yZmdiXhnMXuQM86FvH75ilKU+yO7Jh2ofT0V876bdkvE3TShFhZYdo7VKZaThjp8gVyGRFbg2TaTVIIPCT2I28bZ3opiAnydgHbn5H4eKBtNfloHuBBYKRNC62o7ezXEXBr7
 zYWVAdDY
 nM/XUyLKdMB0Kf7La1306R4EZMLMVDsVkqLjhR/qbyzT8bI3HSm8yg9sGoVUm4ffxBMDKHEJNr+go8WZRdgR1kBI9PubMsZ1/vX1HRUDO90QDsdQQZiVwl4xUyi/xBiZE/EjShjngSps2HO9oYwLRRBlW9Vlf9XZO9fOwmVQJj8u8v2sE50lO//pMqj49iq4NiZHpt2nfZ5nXwxMpuYA8ZEnC2JVHN31WvLMw8c420gXhhLNuTH9NRGcVSv1gnRcnEKE1npms4YIBF7mtbLZVlk1h0riTAahMe4ls
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When an address type DAMOS filter is configured, DAMOS tries to split the
region for the filter range, and apply DAMOS action to the filter-in
region.  The split operation (damon_split_region_at()) could fail from
allocation failure under extreme memory pressure.  In the case, DAMOS
action could be applied more or less than expected, ignoring the address
filter.

The issue only rarely happens under extreme memory pressure.  No crash or
leak happens.  Occasionally not applying the action to a few regions
shouldn't be a real problem.  But applying the action to a region that the
user has excluded via address filter could be a surprise depending on the
use case.  It is only theoretical.  No such real case is found yet.

Filter out the entire region if the split is failed.  Update
damos_filter_match() signature to receive the error from split.  Also
update kunit tests for the updated signature.

The issue was discovered [1] by sashiko.

Link: https://lore.kernel.org/20261020004119.106690-1-sj@kernel.org
Link: https://lore.kernel.org/20260801203121.117449-1-sj@kernel.org [1]
Fixes: ab9bda001b68 ("mm/damon/core: introduce address range type damos filter")
Signed-off-by: SJ Park <sj@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: <stable@vger.kernel.org> # 6.6.x
(cherry picked from commit bbeec2d8324d7aac438bb12dd2d22b184e0a8d43)
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             | 13 +++++++++----
 mm/damon/tests/core-kunit.h | 11 ++++++-----
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 52f01a6508b66..046c07b86a6e7 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1372,13 +1372,14 @@ static void damos_update_stat(struct damos *s,
 }
 
 static bool __damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
-		struct damon_region *r, struct damos_filter *filter)
+		struct damon_region *r, struct damos_filter *filter, int *err)
 {
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
 	unsigned long start, end;
 
+	*err = 0;
 	switch (filter->type) {
 	case DAMOS_FILTER_TYPE_TARGET:
 		damon_for_each_target(ti, ctx) {
@@ -1404,12 +1405,13 @@ static bool __damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
 		}
 		/* start before the range and overlap */
 		if (r->ar.start < start) {
-			damon_split_region_at(t, r, start - r->ar.start);
+			*err = damon_split_region_at(t, r,
+					start - r->ar.start);
 			matched = false;
 			break;
 		}
 		/* start inside the range */
-		damon_split_region_at(t, r, end - r->ar.start);
+		*err = damon_split_region_at(t, r, end - r->ar.start);
 		matched = true;
 		break;
 	default:
@@ -1423,9 +1425,12 @@ static bool damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
 	struct damos_filter *filter;
+	bool matching;
+	int err;
 
 	damos_for_each_filter(filter, s) {
-		if (__damos_filter_out(ctx, t, r, filter))
+		matching = __damos_filter_out(ctx, t, r, filter, &err);
+		if (matching || err)
 			return true;
 	}
 	return false;
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index ff9f73579f7b3..6b7cd8149a0e2 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -527,6 +527,7 @@ static void damos_test_filter_out(struct kunit *test)
 	struct damon_target *t;
 	struct damon_region *r, *r2;
 	struct damos_filter *f;
+	int err;
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true);
 	f->addr_range = (struct damon_addr_range){
@@ -537,25 +538,25 @@ static void damos_test_filter_out(struct kunit *test)
 	damon_add_region(r, t);
 
 	/* region in the range */
-	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
 	r->ar.start = DAMON_MIN_REGION * 1;
 	r->ar.end = DAMON_MIN_REGION * 2;
-	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
 	r->ar.start = DAMON_MIN_REGION * 6;
 	r->ar.end = DAMON_MIN_REGION * 8;
-	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
 	r->ar.start = DAMON_MIN_REGION * 1;
 	r->ar.end = DAMON_MIN_REGION * 4;
-	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_FALSE(test, __damos_filter_out(NULL, t, r, f, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 2);
@@ -570,7 +571,7 @@ static void damos_test_filter_out(struct kunit *test)
 	/* region started in the range */
 	r->ar.start = DAMON_MIN_REGION * 2;
 	r->ar.end = DAMON_MIN_REGION * 8;
-	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 6);
-- 
2.47.3

