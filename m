Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37D94606A326
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:15:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VupSj50k
Received: by kanga.kvack.org (Postfix)
	id 08A6E6B05B7; Sun,  8 Nov 2026 15:15:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03BCF6B05BA; Sun,  8 Nov 2026 15:15:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6D1E6B05BB; Sun,  8 Nov 2026 15:15:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B68016B05B7
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:15:11 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E2C71204C9
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:15:11 +0000 (UTC)
X-FDA: 85413056022.11.E3AD40A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 920B780003
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:15:09 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VupSj50k;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794168909;
	b=jxZ7/fD1IU/+XU9D81ZyBLJUv5IQdr7Ofz8qVWwfIpkF1h7CQORm18hY0+YdsJL5h3hyNf
	KfF5LKNUE6AeQ0hmYBz72olYM2G5Po0jSgvH/atKqitBQiHEdOxWbg+RTOqACajFq5YO47
	qcLMEE/8UG1CjGYu5Tdgi6pMZEgR9ss=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VupSj50k;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794168909;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e8b2BxiNM2zDfbsfHX5lOdltBPseBRShaz9qPJkxXRw=;
	b=0K6EpiOGv8D0uXHsIW5/PqVGM1PIdzaVraOb2HiJSnSEdwC2bcy5THWcX3gxe1KoWYaaBk
	fAp8CY9+iQ7hqao+QrQVXeaBsDLmpYqCXSpebMfYOkMoyr5g9AgfGLf3tZtwBTKq7vHaQN
	EadKMu/xC/T4uVnCrG7uIKbLGDiR4h8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D9291439FB;
	Sun,  8 Nov 2026 20:15:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D8CA1F008A3;
	Sun,  8 Nov 2026 20:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794168908;
	bh=e8b2BxiNM2zDfbsfHX5lOdltBPseBRShaz9qPJkxXRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VupSj50krcOI/QPET5RtqPM0krqDypQmTkx6pRkm0HkA8KP2sZ9E9tdnuSBoBhEAZ
	 L+k2As8MLvMhSOiw81m+bCd/p8oiD6187BWpSub9YaViomQQSvEQ7QDi2Maz+YkjYZ
	 LUgt2LbthyyHmH0UcTLyFiZtgm8TUXaYdq/e1eC0Lw8GSQyG7/u7W73obykvyFCxFs
	 FmgzCF/RBxggbaNi9NWjX7v0p4/WhDrMgz3r5ZHp6olDFRa6jJvf5WjbYf8tqljRCP
	 rs65bMSyWBVQyBXnV9Yf1Sm4/Az9aMZ0KHYjV19Ml7e47gChIeRSh8BYIfQU6pqyAZ
	 g4H3hNqAB+JfA==
From: SJ Park <sj@kernel.org>
To: stable@vger.kernel.org
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6.6.y 2/3] mm/damon/core: filter out damos address filter-split failed region
Date: Sun,  8 Nov 2026 12:14:54 -0800
Message-ID: <20261108201456.116824-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261108201456.116824-1-sj@kernel.org>
References: <20261108201456.116824-1-sj@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b9ox1b5st9gnz9z47kwa5iy5trh7gazf
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 920B780003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794168909-552785
X-HE-Meta: U2FsdGVkX18ifAaAgjLTWWXIAawdvIIfZVa/Ez1rzz+ZVHVoRjzVCHx7Oi+IU+548oHkGfcB459EcM+gakg6QpgDIN42zQyxxi8Yxp2lzKqqyb3+Eo2+RFN9x+eLigB/aEIZz3IEnY/JmHvSZPENXoIhNErl0qPAs2caMRExVNaq1jUj+rf/9byg6Ny8UDcUZqRPTkfllLvu70Hc1peSnXK+AejHpIELjs2QKvq9ko7H6s3CRf8FmAHMYXApb9hqZDTA3pH8jxLiAXuz7zi4PkL5YyHXHUmgNroxsxWq351E/8ehCjfewAgxOaClMpzFH8+JLwVW/a7iy8eqnhcCK6rGagAE9/pr3scIAI+JZgeJMUmvx/rZc991bXl4Be3d9PjoqXXQvksS+bh7tUxBVb1N0Jp42LuxdhHlMd3kqfcpdE25Rh9BF1mbdyt45uLhr2b/kNXyfEknC/ccVIaUQk6Ckw9o8XmNFrxboGCVNLJskADJDTKsK4IQsYsqlej/BwE2w1C8Q/U4j+eQeH8PePvayyQq+yGcpTG+oiyXPxnrbNuSxewNWTow+jufDGMvQlnAaQCrtx3vuQ5uJuvXgHI+zTG3I8QgyTUrPJM9cMOkpRQ+xhsbuoCvSiuRoJHPbp3UqeN8RlSNZeKqhSTfo2cF4Bl2MCjj8i5Z9PfzGJR/LcPME/EY4M7OfuOsALiZCihdjYxwRNe5zlsVj0Q4RyP8vgqr5KAVGSyglNz74I/boywZjhtX4aVJv2NdpCmYoZEpbWFXiRIIV2Zgs3q2My+/NdZ9A+Il1jfsmrXukDFXtU5eLfGPm/Sght70FzDrw7YlpOl3b/h8tVUPEXFa59YKT8qxd2yczGPmX/3D67TlWKRzVR6QaW8O05xq4kmh6++jXBecwPTRPToEzz0pmDmj+5VxMC+/pKdHAHOww7X7cj0eBkgL4AeTEvNRIuNpvh0rqBAu9FVztJ755js
 kQNkJ94E
 r5ohb46T7Z10/eCmSeyM/11lFw8PZiBz/Ov7WLvpMSSRAZmWQltkX3odhj0cWtSR26M7W1T1kqGkML33AqX6nylc/YqbfaZVFTNHj2mjY7eM1gWT9DNjZC3yaLjFMrvt2G/j5b1eDuPeoQ0WSl/jCnX5wVB/0hzHcC3jU9qi9NHT7LGvrUh6NiTZSOqTy30Bo60xX3QbAgT2DEk+fIYJbv1LeD7A1uj0/Bvh4DDvsFDjPdLyITjXK8wVr1Q1e425GD4nanFeJ4xXMVVSVk2Rpf5uOPgK7D9X8Ffiw
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

