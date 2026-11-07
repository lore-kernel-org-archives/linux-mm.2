Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 594AD606A326
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 20:10:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=LPjsm0m9
Received: by kanga.kvack.org (Postfix)
	id 7CB986B05B5; Sat,  7 Nov 2026 15:10:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 773106B05B6; Sat,  7 Nov 2026 15:10:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B0166B05B7; Sat,  7 Nov 2026 15:10:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2636B05B5
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 15:10:15 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BC9601C3AAA
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:13 +0000 (UTC)
X-FDA: 85409414706.13.B702E55
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 38A7C40006
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 20:10:12 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LPjsm0m9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794082212;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TIAVWRl5IyIEzSAGdy1Y9O94fKWUT6y4xqwWabU5n+M=;
	b=Vhpmcl+CI6ZpsMgGDgl1kjeTXFpsx/ZWZMbvmjVKoAisLcelV34LfmwFsTfC3Xz+3xE4M7
	zqygEWB+saVQec40hFBIVG7wROMBay2ZwR82kb/zXv4jUZJGN7KvZimitXQkFLcqRcwpdq
	JvBUGcU16WyndNStuZafunfbo83VIVw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794082212;
	b=X8SmQRhob3Tp6ogc7dBaD4nY/pOWrI3U9j+dbq9D7srV/G1FXhIJwqJdDB/CbCdVO3JL1I
	XXck6yKIxvE8B39/qLtBC/XPWM7PxKGt52F4K4kZNL7b7PceXp9GIENu9+dA+dXErA5dMR
	UrPuFfREIiL5TfVUdCEkRT5e6grVLP4=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LPjsm0m9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C86C961190;
	Sat,  7 Nov 2026 20:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF501F008AB;
	Sat,  7 Nov 2026 20:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794082211;
	bh=TIAVWRl5IyIEzSAGdy1Y9O94fKWUT6y4xqwWabU5n+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LPjsm0m9nACOdC0KAk8ANoS9Ly8u0kM51qmquHDqDhuZLfKLwr0Q2z+iSYMtsUHwd
	 hlRiCO4hNc2UxC0daRQWjOhW3r3CSX/Wxl8FLRhB8yi/92VZs1S5sfwbdoIUgkKCEo
	 Loc4iyzPizp6Ny1ISQiSKE+WeF7mKUVsQ8scyNMhlvxSTpgHrg9ZPEPrhjs8cO7uYj
	 TNk6Ls8ow1sOBcwuevAjSVsf9t81VnW/uKpJjlFaMi1g3ov/m1Dsa+WPMQ/8snOHMn
	 9RpG6DxmoaYM4Vxpa3iYaCHoUuMsEE7p2xQWcILdwmd2YZUnJ4eA0OCWneA8Qy8ruL
	 ST7jwRmPY7dcQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.18.y 5/5] mm/damon/core: filter out damos address filter-split failed region
Date: Sat,  7 Nov 2026 12:10:01 -0800
Message-ID: <20261107201001.206120-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107201001.206120-1-sj@kernel.org>
References: <20261107201001.206120-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: a7sfe8ee61o4ojpgdzm3uuyt9tx8cj68
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 38A7C40006
X-HE-Tag: 1794082212-223491
X-HE-Meta: U2FsdGVkX1/lx4vJAKhRVcAgmwV6WYQWToN62dRqqdOtFIjjT60aXwy5JxzRJWSaBzxpNAiS7NwNtb6fKfBIXkg+QltcUEQDhNxjrvZ8UYUdDvajn879DRMa8tl2/LDDN87qMMybBTk6HLM6GPG2yoyTUSrmfeTdPyJp78/uXdwbM8dgpxUjSQhGRopjdWgAIDj+Cfmk7pnIE8/v/L5rFFkEUwZnRrZh1T8An5EPL0NsFrAlNpEAlymIuhYvz0A5BnF5x2zIjyoZoREvPAxKPmAzfLwqwtycys38ZzEg5KH8+aSP83EV5JlrkXHt/LtVOZpRBNmdm2KCcwnpKabpWvUCwzFLEqYeuv1uigWAk6s+9EXYsqH1Xazc+NSM/0qKtrhGlclx4y1LxKoeK/3GLUt0JH3FC7xZxrubJHk993jKfF25+N+Yegumbex10hn4cy6+L5hD5JC24ZnRWKLpZKHgAmywlK/r5c1Cy040r4HQxRZpJI+PflTMjj/SoKrJOIdYXig1inziyOf4+VQ18/bkoyJSBD0VdCCDkU+GA16oZXpKm0I4lemBS279st3/Cubg4wVXDM3x6yyNFalhl1yq15ZjQBiOFkWPeBqbwcG9Bz++vWLIN26/rZLNx+l29GmJKXZ3D1QILtrf50If0ew/nXrDn3wodPOoFD675zQoej/85vWQkWR3hQUyEPEwmSP/dv5sjsaDM5doe2Y77dfs7/mm1HtB3RNXeuhjvzukV/7IBf2hVX7vPHYGJXOIkUXbR9BTFIDYy70qw2cMZoHHcSsvRdCJNhIS0PEkzL3GkCswUJCEpE1CVCOpfhr8SO+KAX3bHqCZnK/aIR6hqJ4P1gYTwsMX1rFQotL3U9susU5JFTRvDaLVB/MJTlgy8M7q/ddXPM6Xtda/RoKbecDqTEp1ppwyozBsvEU9ZBUVFb89nuVaJtYaYTmX8WX2uH6hgQzIqW69ooaN6dP
 RjUE5Sf+
 hdv1ipPZC2ND6OQa8saLxEyYebtgsJKRt4Gs3+Oc/xQR1hn54mpLbQ6VCO8tAsWlMzcT7hIsQB51KVmT/M+Q9QUHV71WRTNnZ0ADzgjeTKkhsF87mJyps41WXkXl3dgNlNnTmt/hNGgM0qsY8l9HEA5VwCU2Z3+GVnQTpXSHMJyh5Ng+GcWwpGQafRI2DIjcUfLZM/M3BqURA2DfYj/HCYaDrWOV6JbQoLOniZYaDkZz/QyOiW8vGoXkiISC8HcKpDJ/GkM9uwnqfZNGoo98kA5nfnKa/Bi8L7NAT
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

