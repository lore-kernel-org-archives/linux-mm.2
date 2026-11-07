Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 65D85606A32D
	for <linux-mm@archiver.kernel.org>; Sat,  7 Nov 2026 22:22:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FqsDAE7f
Received: by kanga.kvack.org (Postfix)
	id 1B1086B05B5; Sat,  7 Nov 2026 17:22:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C50E6B05B7; Sat,  7 Nov 2026 17:22:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E5D9E6B05B5; Sat,  7 Nov 2026 17:22:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B4C636B05B5
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 17:22:14 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 231AA80250
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:22:14 +0000 (UTC)
X-FDA: 85409747388.24.BA22582
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 7202DA0007
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 22:22:12 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FqsDAE7f;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794090132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8b2BxiNM2zDfbsfHX5lOdltBPseBRShaz9qPJkxXRw=;
	b=rAxEU1ofUbUrU/o8XZilnUH98MDW86chgt4AQuNH2ciH/WtUZVq3KRb+ikwJAF95ZGx3nP
	RnZT5+wWmerY4PWLU1oB4WvzHeHwFNQagSPvWJKgQ0vQG5XJGkwS6nfNudCxtUAIcqw69D
	1eTXY0T3R1lyAcZf3ya+xBQRD58QFwU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794090132;
	b=75a5wj+APBFD4QW40FcDcCatVFdaSyAbiW9QGfzbnNjQYhVU0BnsM7Cfv7BZfrcDc1PHFu
	y5UtR4G6Vo8SFEWNuaP8WyG2Lg2sx/rxLhvmJLAvtKuxpG9cv5kdSWN3p0ESyTUba8mjDq
	1VdtV4i68J8MirMqJu8nhLO8IAFad/4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FqsDAE7f;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8D6EA43ED0;
	Sat,  7 Nov 2026 22:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 402281F008A3;
	Sat,  7 Nov 2026 22:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794090131;
	bh=e8b2BxiNM2zDfbsfHX5lOdltBPseBRShaz9qPJkxXRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FqsDAE7f+a160tFFkgUqjUF6DTdHtN56zbOQZufBN6+E2VrZnKvqyakwl9OdCuNWf
	 7Kn9rtFQ3Ti9t+yZXjqVADYgS6eBXqRgznjBHQvKHWo+8KfF0SVVgx2SYhPCODCW/v
	 VzzW7/KzL8x/XBJ/ADaQXCrF94L7vHXFNArCz1KB01j6JW4NWbUcB2sQsKKRSXDmil
	 8MvXTzdjgpD0LvMZq2kRz8YezFtGlUOVpZU/ISC7ZaYWTDEk5Qjri1mer7zQfxVeDH
	 2y8B31pkpEt6hnDgwpYWZGdTa4tggab5HxuVd85yr7BJIfOLHC0g2NQ7LFp6HSRUj3
	 zMyGK3GoED4dg==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 6.6.y 2/3] mm/damon/core: filter out damos address filter-split failed region
Date: Sat,  7 Nov 2026 14:22:00 -0800
Message-ID: <20261107222202.331476-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261107222202.331476-1-sj@kernel.org>
References: <20261107222202.331476-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: 6h9fq3o95b3ugd8b13q8dcssx4y63bbx
X-Rspamd-Queue-Id: 7202DA0007
X-Rspam-User: 
X-HE-Tag: 1794090132-981584
X-HE-Meta: U2FsdGVkX1+FydUKnSs8Q5ksNZHT1P+MGp0173YMLvuN4uOpwgtljMk9i+8T6gblq+xyxuaUD6rGh1CM3cEquWf4aGCkAnhAlGZ7iA0EnUf5sL0JbXr3qsJT6GQepuqDbH24NgH185DqV8xtVh8H30ivr44ZmSqzMs9egP3mNQu8uMmnFwsktLqPxNq+FXLtOuZ7t/XbT84+qgoS59hpRWQaUFZFPIVMij2tgJ9hUiWUHimJKyA999NK/tjIRJpgen9ucUijUeTsG28WfiFzx7tzmCJv5cTCLtYnK7+4jZQ/9qkQFIzQyP16V2uCnk0n5AD4SIJYbHWtooMrVHlZDLpOmkGLKDYuzybq/0TToI3yWDrQr/m3yx8Hey3a/5vjYu10jiO2LLf7cofgYJ6CKhq8pVUfrmgXKmWGRu1ve3woK5Pn1LThLWvkWeOBzs4w1FMoPwOekYjeVSjsxvOv8aLEBp94t+CczcxO42ldnKWOeXzbaNt0klkm1E/vxS7TedTr5cQ3ZLMm0UCBlG6NzYcrAyYzcabB1fnkm0VekUovb3iFeYLKXhQ4tOIbmoLD6xktbV+pWa9EPiIJoj36J75gW0HFffNBXzJ4dNx9FH+jMYHtC7rMFfm8xwCL9bfFZsdu4QsaZH9FnOFVZ+K6W5J2sSgU4T67aorFi6nCBPlYNijieblEAUQfh1QKCgpkNH0EvsxQnzikC0njwXwTutGmg9i/+hR9CYlOaJ4REVsLTSgHmy3kA24Oiq9cmYvh+Qdfgp24dr4uB2dj4XnKK7IuoMXWo12gCvK+3uy30HdP/WwrVE9f6kv2MT2SxYNcjM9Y1JagROvcNL19xZ3Z5ZP7/X4souLfHnd9/e7ZGp8rjFbVgjC6IUFigjJLGR9aGTnvwO+A1V42VRiMOQCGBy6vT9P6zCTOpVHm5eNrY4T8QPO2qZlnUZDUAy7WoxUt1WuACRJ8WekRGlALAhI
 fVpph32k
 acGe+9Rxb4GEUYeD5sbpsi9d754ABOYTXoeg77YL8FsXT60r8H9Av3qlmPlNhxAFV+GSthDsi70lYT1nDAgJuSmltRgXbyDMODNAatf1oUMeF6y/ihwZMCp5ZIo6bPOPv8sOYoWQSwrszmHpDaTOSIiiqQK7phST+N0PKBYrT0N3f5kjkXA0ewqsW6oyt1/z3V9smNejxeG47uD3lfrEZ2KotEumJCVXhz9g2x3NlawwkmqgWyG8NBkLthOVWzBPTi+o6ky3kVNvGxa5YrqESFQ+PyQzHuRp/rLm2
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
 mm/damon/core-test.h | 11 ++++++-----
 mm/damon/core.c      | 13 +++++++++----
 2 files changed, 15 insertions(+), 9 deletions(-)

diff --git a/mm/damon/core-test.h b/mm/damon/core-test.h
index dd91b0eea61ff..1988b7dd29e96 100644
--- a/mm/damon/core-test.h
+++ b/mm/damon/core-test.h
@@ -461,6 +461,7 @@ static void damos_test_filter_out(struct kunit *test)
 	struct damon_target *t;
 	struct damon_region *r, *r2;
 	struct damos_filter *f;
+	int err;
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true);
 	if (!f)
@@ -482,25 +483,25 @@ static void damos_test_filter_out(struct kunit *test)
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
@@ -515,7 +516,7 @@ static void damos_test_filter_out(struct kunit *test)
 	/* region started in the range */
 	r->ar.start = DAMON_MIN_REGION * 2;
 	r->ar.end = DAMON_MIN_REGION * 8;
-	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f));
+	KUNIT_EXPECT_TRUE(test, __damos_filter_out(NULL, t, r, f, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 6);
diff --git a/mm/damon/core.c b/mm/damon/core.c
index 9d4a78deaa06a..99e934a6d1ce9 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -930,13 +930,14 @@ static void damos_update_stat(struct damos *s,
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
@@ -962,12 +963,13 @@ static bool __damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
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
@@ -981,9 +983,12 @@ static bool damos_filter_out(struct damon_ctx *ctx, struct damon_target *t,
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
-- 
2.47.3

