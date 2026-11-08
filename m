Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D145606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 19:22:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=c3o8jXzq
Received: by kanga.kvack.org (Postfix)
	id 693C26B05BB; Sun,  8 Nov 2026 14:22:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5F6526B05C1; Sun,  8 Nov 2026 14:22:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 50BED6B05BB; Sun,  8 Nov 2026 14:22:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4CC86B05C1
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 14:22:33 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 554CD1C3147
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:22:33 +0000 (UTC)
X-FDA: 85412923386.05.8EA829E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id C0A571C0005
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 19:22:31 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3o8jXzq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794165751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIAVWRl5IyIEzSAGdy1Y9O94fKWUT6y4xqwWabU5n+M=;
	b=cmEcR0+/oCe2VsEiFKrWHfNedLotJGqgW0MiaN1MLuJph7PSiZJFaHMSgGNz8ifI+w8n6A
	czp7ZhgA0hw3Vi7uXqccWXDPTxXkoyW8KdtW04HyZg0eG5xnY1qz10vRjCKqQjw+J4XeE4
	NXI0ODn6rwfnRJD26Ok27wewu1FWKi8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794165751;
	b=pq3E3PwzjwRlvCgjLdt5tn8/pOwjPH/RIR7hj6cG+BXfpS/f1pdaDX9z/wARAYjNq/udZs
	xvV9aA1/8ES8qA+h9gWGaIQ72FDGzr6iisJBprvX3OvBDhmnT2cYolH9NizYsrgQbpVIoV
	Ycb1HoJ+6dm8m+3JL62/79CXYBIZILY=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=c3o8jXzq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5F6C561C6A;
	Sun,  8 Nov 2026 19:22:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 062DE1F008A6;
	Sun,  8 Nov 2026 19:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794165751;
	bh=TIAVWRl5IyIEzSAGdy1Y9O94fKWUT6y4xqwWabU5n+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c3o8jXzqd/cfJkZdfMFZQcY+niEfkkDqeJ0S+h5xlX008yN5KWS2qxytiiJldHf8b
	 RcRjD8XcF0XYITrHgicxWUBHGO99HRofEhk3hwIt5mpvYTmxCShKVgUK1BFB/MdtBA
	 ayUPQryMjxoDDa1RCjF/lrqIi3oQHj3m+a4nKJ4vcv5796zJgqAN6kiSAnIkeIXo7F
	 M5HAu04+aaQ0t9GvkCq8SwX2pHrhMlUSSYiUKJ524kioaMVIN5nb4SiXKO7VljO7P/
	 fCXCuBZ6xr/YHEPYbS0F0Ct/6iNYVynXLeG+nKyG4IXI3xJoUTG3pKcTd9emZWZaMr
	 nAQU0DI/gtShQ==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.18.y 5/5] mm/damon/core: filter out damos address filter-split failed region
Date: Sun,  8 Nov 2026 11:22:20 -0800
Message-ID: <20261108192221.114362-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108192221.114362-1-sj@kernel.org>
References: <20261108192221.114362-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: tdecm87rmfba93ruebmx8gaodo34nhqc
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C0A571C0005
X-HE-Tag: 1794165751-110086
X-HE-Meta: U2FsdGVkX18J/ZIZr+Frc31BLyENJxNJHr6L5PdNBAHu5SgHZ6IYEjkKiyXmeW+H7CoI8J3hBSg9SwaZYj1Bvo+4HJVxr0nHjL1rcgPU2cWkAiL7aH5l/tv5OmXS9M86zkdJNr6iYTKPfyvlYZlUfMhjRU0XMD1Nx2tM3Vq5wad+ukU44NGOiukfK97NiL5r/PKzkBC5jA0P1AQcxZqSuzLUZTzoAYluxLjZRJdxlL1XAg3QsoeUdQaYOp0Y+e7vpO2L+Q1J32mjK9A1zbas/WFuIULcjy0tVedm+pbZfSOsdD6i1xjF21JTZh1jniO55rKYaJNpjm+W289dVsLyRCDCoytzuKOxs3Z2TZBIM5X+BusCupm3hzTqd/PcLoxy++pOT9yKBJE431Sf8sHy9VKgkWOq8AbAEn9WY9Z0gAC+ZiagsjmkqdJbDuDCboE0lt1VlXN7RYYbXQaAXjG+x2bmZSyfobF1rcmx5p4Mj+0U2CeQDXk2LmROiznfyOxEoQ//ZDIUSEpS8KKFYWTs7iL6cTQtD7Q5svygOALlvNkeC2fiKMLELUmmZiT7noInO2xSQVOLbW7IxjFlQ+8xe4LypRRtnhi7TgsiVTteX4+SL7bNEg6fEOTUPJfgPpPQ2e42qtqh0W39NJg05EAoBc0JsoYR3J8+wjwXbNBMKL3hBVabo2I8Gdr6W8cp7yKUymdldN/+jOO0lSLu/fjZhAgZCfN8QrvWbVr2stN04VovLOLxjqQtyzkcfLUGFOVTWoZNIR9WZZ6o9kvDvFPEb6vvFLzULZk23dc8pKAfIL0Tmyiv4HLOtCqnPAl26vAFQJED8oO7/bZk5m4Lg63c0ZlGzep44yiQODsfjIhqFPkv6C9p7NBru2OrXv98WsnqZFH96NflG8ig7lg4fs3KUOpY/GyDnml2DNjadMbmRPqG3KegljQQA7SnhybD9mNiCyaPA0OiYQX4e/Iu55E
 XMEEfsqz
 VYfd/DBS9Vcb1igmd93Wfppb3aTN9IKll2PhjBGTsFrjsgcpQoUbEWeIMEOsX/dANd6IKCazWxqHXZKPqXXYW8WyRgr+z9Bj5FV4YrNM+fH075sJq2fkkylyPSG5emVwfge/DifiIaJ4nU+hbLTXDYsyGBKrcMA375zTqqoVvhOZCFqU0+/eX9jT669a3Xc2g+bAqS1gaffwYDXOF/rdqzTcWr2y2d17Ig52xJbjPn3737N5SZL5wpq60n9lFQarL5H/km97z6ib09a3ix7qJraltL55cQZNuWVcB
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
 mm/damon/core.c             | 16 ++++++++++++----
 mm/damon/tests/core-kunit.h | 16 +++++++++++-----
 2 files changed, 23 insertions(+), 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 00cd0e2a1e341..dc8608c3cae40 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -1812,13 +1812,14 @@ static void damos_update_stat(struct damos *s,
 
 static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos_filter *filter,
-		unsigned long min_sz_region)
+		unsigned long min_sz_region, int *err)
 {
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
 	unsigned long start, end;
 
+	*err = 0;
 	switch (filter->type) {
 	case DAMOS_FILTER_TYPE_TARGET:
 		damon_for_each_target(ti, ctx) {
@@ -1844,12 +1845,13 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
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
@@ -1863,10 +1865,16 @@ static bool damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
 	struct damos_filter *filter;
+	bool matching;
+	int err;
 
 	s->core_filters_allowed = false;
 	damos_for_each_filter(filter, s) {
-		if (damos_filter_match(ctx, t, r, filter, ctx->min_sz_region)) {
+		matching = damos_filter_match(ctx, t, r, filter,
+				ctx->min_sz_region, &err);
+		if (err)
+			return true;
+		if (matching) {
 			if (filter->allow)
 				s->core_filters_allowed = true;
 			return !filter->allow;
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0ce6481319432..814197da4f507 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -548,6 +548,7 @@ static void damos_test_filter_out(struct kunit *test)
 	struct damon_target *t;
 	struct damon_region *r, *r2;
 	struct damos_filter *f;
+	int err;
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
 	if (!f)
@@ -570,28 +571,32 @@ static void damos_test_filter_out(struct kunit *test)
 
 	/* region in the range */
 	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION,
+				&err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
 	r->ar.start = DAMON_MIN_REGION * 1;
 	r->ar.end = DAMON_MIN_REGION * 2;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION,
+				&err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
 	r->ar.start = DAMON_MIN_REGION * 6;
 	r->ar.end = DAMON_MIN_REGION * 8;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION,
+				&err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
 	r->ar.start = DAMON_MIN_REGION * 1;
 	r->ar.end = DAMON_MIN_REGION * 4;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION,
+				&err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 2);
@@ -607,7 +612,8 @@ static void damos_test_filter_out(struct kunit *test)
 	r->ar.start = DAMON_MIN_REGION * 2;
 	r->ar.end = DAMON_MIN_REGION * 8;
 	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION,
+				&err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 6);
-- 
2.47.3

