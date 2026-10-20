Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D266E606A31B
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 00:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=erRlPRNc
Received: by kanga.kvack.org (Postfix)
	id DD0846B010E; Mon, 19 Oct 2026 20:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D80EB6B010F; Mon, 19 Oct 2026 20:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C96DD6B0110; Mon, 19 Oct 2026 20:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 952466B010E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 20:41:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 14EF31A08CF
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:41:35 +0000 (UTC)
X-FDA: 85341151350.12.120AB44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 932C8C0007
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 00:41:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=erRlPRNc;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792456893;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9m+CklygXiF/Y3wz9sotcxoYMguOY3YvD18SzXdCUOg=;
	b=MrcTVP28hMUicckCIgqEaJ97VTbUicGYL5eHZrZcpsFSniOQKAVjfMJmArRA04yLDAXIoU
	plkus5Y5BA7yRIjN0JL6026P2xwngy2sR7tiHeN8/QDzkQ6h5FjPgBWtzDDYLpFZEmYRwv
	TnNPhhJzao27iVWpFx+1Q5Ys4jb7194=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=erRlPRNc;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792456893;
	b=CgSC50bu3v6fSrTaqt8VDhItxDf2i8AuZHRJ+TabVdpGlKWP8jXdmjQn0XYGhYVPCYQ52r
	3yTj9KNAL3l+RAZWDVPAv3KHtSXfTLU239ZXfOCOU92ZK8Rd6Q74nZCY/tjUGwAST4mDAd
	/G3Y8iK4HuPp6Al1OdEAJlKUV5YzOzY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6FE5760098;
	Tue, 20 Oct 2026 00:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4BEB1F000C4;
	Tue, 20 Oct 2026 00:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792456892;
	bh=9m+CklygXiF/Y3wz9sotcxoYMguOY3YvD18SzXdCUOg=;
	h=From:To:Cc:Subject:Date;
	b=erRlPRNc32l3KGSD/8lf7EP4fmsIbQeF9K5KSK3is6u61gURDZA8QYKz4TsU9Zg71
	 RvT5ostrfK93nZoxMclI1uGwuNdRGZutakIZ0iitfHzuIZ8X4vGn5RV+VqhzE10h0L
	 Xrw0bmHzKuHR6tzCjP2LRC5Kua86B6qLe5MHiTjfyPCVSS2EFaVtDjSL/ghxtLy62l
	 GJ93bcu22RcBrYZKlxZWi3/xMDNuVAa7AaEJwSWBrJO2A6Zj8dUbqSsVlRPvd8ufSf
	 YvPX0bGWC8btTOVDBW/vMqpXeHiiwclEV4hkJyxbsvmku0JW7/VIxUv4pQPmwCraaL
	 7Mh3mm8OT4qmw==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH] mm/damon/core: filter out damos address filter-split failed region
Date: Mon, 19 Oct 2026 17:41:18 -0700
Message-ID: <20261020004119.106690-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 932C8C0007
X-Stat-Signature: 48yedcfpoacaucketrghjqoxzj8bykqn
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1792456893-330472
X-HE-Meta: U2FsdGVkX1/8/kjggPDRFlB1FAnko4xwpTQc+6GTbvzbacmH3LiOLRu2EJVmaK4EK5V7gPRAbfcbnrOmirv7U8ai9pNRrPgUHNGxSmeIWgIaUQJkwam+mcgnjeEpZvf0Qy0kSRnopht3b9HnVzwzN84N33i2NO5VIrwFinTEpI3P3M8vw3xVntY88YVKTQrzgJIc9Pa7h2ycoAm0NrHblBoQTIb7l6F/Ca5aBRYZiePaTlXGIsX7DPGqj/hzlY/qApNZTH/90K+u2on28TfhgQy8MtJkalELv6b7NTNCT9TJMkglRE51VtWElUuw59N1trpesAA2kcOgBCxc7YMPlfji7y2Dye25L2wimY1+USv2oifcUzjVh+NwhNlj7+FoyvXjbWyVpYIZGqKckzxcAWXRYaGydmghfOnoUAUapYXCPQ/R/WUY9mahpbSue2XmKnwlu7UoVV7uJ3a6Q4rRkxAwNqd4FL+8rveSTNBwNXQkfVYHCOVrFUAtXk9rUKeyrbaRwJF940jrwtT7uO+Qzugc5iXJQX5wtQPXoR0ZUsvjjrMqXYpyfQzCslOVODHLveMFXTuAichWUkmgUAE+dZFofXdZAwVICv5S60LKZyD9ATbQfj3CEZve/+sXIW3GuEIySiLbGVbm6+k0xFkEyG0K7MGYpIYSYnmSrx5KBOa9na17jjCZbl0Nt84GvGcH9ft0Esf42qHq+RvG3vp6a5vyREGqmwSmm0R3sWeD9qQjnt/sDtpkNXW+YanvwEgBBIEi1Kx4S02LfQUYfylxm/GzV5WENR3LHUjCeO3Ay5KzezBp/vua9c4WaBA2gBSiXlamJxJZbO2ioMb8ahczk3gACjw0qC3MZYLKO0e7jxcNvf60HWv6/5UcFWr3AetNnAlCi8q6l4+2ufkIpvdUXdQeo9R1fUhH/iyvWyZjMOsxmZdg3+o3UAaD3qpdLw4Rb/QoEu9uUhO18ICY2Kl
 MsyeHQ/n
 9Er+d5mBq5AlXTm/L+1xAgnIhwWyuKPv+HECQdmuucKZVOIqf0X5Ti6B8qdHAY1VtPzP/VqTLLDlwMjr2F8D1pyn/nZSQ6GDlzMmYRHof/Ziqhi/c1hR33mi6zfPWHpN+qsyqCoYihV58S0TURw5dHmJGVrFweSLcjFOJBrwQpG11A+7XDwLD4LkGVdKjlaMMwZye+g1snb/uXL1+rXi/xhS1uwwlOU8gdr3IUz00/O5LbWXhxYp0D3hwYMa6QuzPBB4XFt2eB8ni7wc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When an address type DAMOS filter is configured, DAMOS tries to split
the region for the filter range, and apply DAMOS action to the filter-in
region.  The split operation (damon_split_region_at()) could fail from
allocation failure under extreme memory pressure.  In the case, DAMOS
action could be applied more or less than expected, ignoring the address
filter.

The issue only rarely happens under extreme memory pressure.  No crash
or leak happens.  Occasionally not applying the action to a few regions
shouldn't be a real problem.  But applying the action to a region that
the user has excluded via address filter could be a surprise depending
on the use case.  It is only theoretical.  No such real case is found
yet.

Filter out the entire region if the split is failed.  Update
damos_filter_match() signature to receive the error from split.  Also
update kunit tests for the updated signature.

The issue was discovered [1] by sashiko.

[1] https://lore.kernel.org/20260801203121.117449-1-sj@kernel.org

Fixes: ab9bda001b68 ("mm/damon/core: introduce address range type damos filter")
Cc: <stable@vger.kernel.org> # 6.6.x
Signed-off-by: SJ Park <sj@kernel.org>
---
Changes from RFC v2
- RFC v2: https://lore.kernel.org/20261019133856.86835-1-sj@kernel.org
- Drop RFC tag.
Changes from RFC
- RFC: https://lore.kernel.org/20261018220253.158238-1-sj@kernel.org
- Handle failure in another split operation in damos_filter_match().

 mm/damon/core.c             | 16 ++++++++++++----
 mm/damon/tests/core-kunit.h | 11 ++++++-----
 2 files changed, 18 insertions(+), 9 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b63e60ef89901..479169dc9ac75 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2551,13 +2551,14 @@ static void damos_update_stat(struct damos *s,
 
 static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos_filter *filter,
-		unsigned long min_region_sz)
+		unsigned long min_region_sz, int *err)
 {
 	bool matched = false;
 	struct damon_target *ti;
 	int target_idx = 0;
 	unsigned long start, end, wsum;
 
+	*err = 0;
 	switch (filter->type) {
 	case DAMOS_FILTER_TYPE_TARGET:
 		damon_for_each_target(ti, ctx) {
@@ -2583,12 +2584,13 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
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
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
@@ -2607,10 +2609,16 @@ static bool damos_core_filter_out(struct damon_ctx *ctx, struct damon_target *t,
 		struct damon_region *r, struct damos *s)
 {
 	struct damos_filter *filter;
+	bool matching;
+	int err;
 
 	s->core_filters_allowed = false;
 	damos_for_each_core_filter(filter, s) {
-		if (damos_filter_match(ctx, t, r, filter, ctx->min_region_sz)) {
+		matching = damos_filter_match(ctx, t, r, filter,
+				ctx->min_region_sz, &err);
+		if (err)
+			return true;
+		if (matching) {
 			if (filter->allow)
 				s->core_filters_allowed = true;
 			return !filter->allow;
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 3fbb4e4e36fac..43e2f950f8ff4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1783,6 +1783,7 @@ static void damos_test_filter_out(struct kunit *test)
 	struct damon_target *t;
 	struct damon_region *r, *r2;
 	struct damos_filter *f;
+	int err;
 
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
 	if (!f)
@@ -1803,27 +1804,27 @@ static void damos_test_filter_out(struct kunit *test)
 	damon_add_region(r, t);
 
 	/* region in the range */
-	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, 1));
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
 	r->ar.start = 1;
 	r->ar.end = 2;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, 1));
+			damos_filter_match(NULL, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
 	r->ar.start = 6;
 	r->ar.end = 8;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, 1));
+			damos_filter_match(NULL, t, r, f, 1, &err));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
 	r->ar.start = 1;
 	r->ar.end = 4;
-	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, 1));
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, 1, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, 1);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 2);
@@ -1839,7 +1840,7 @@ static void damos_test_filter_out(struct kunit *test)
 	r->ar.start = 2;
 	r->ar.end = 8;
 	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, 1));
+			damos_filter_match(NULL, t, r, f, 1, &err));
 	/* filter should have split the region */
 	KUNIT_EXPECT_EQ(test, r->ar.start, 2);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 6);

base-commit: c120c766883129cc62ff62a5c2b531625d1e5d2c
-- 
2.47.3

