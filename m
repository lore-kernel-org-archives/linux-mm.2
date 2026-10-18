Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DFAC4CCF2C4
	for <linux-mm@archiver.kernel.org>; Sun, 18 Oct 2026 22:03:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 712386B00AD; Sun, 18 Oct 2026 18:03:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C2916B00AE; Sun, 18 Oct 2026 18:03:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D8E36B00AF; Sun, 18 Oct 2026 18:03:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3142B6B00AD
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 18:03:10 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 93C1A8059A
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:03:09 +0000 (UTC)
X-FDA: 85337123298.25.5BB9AC7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 150CC100007
	for <linux-mm@kvack.org>; Sun, 18 Oct 2026 22:03:07 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PO1SlCH6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792360988;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=9jIwRePGhGl7Lj5AtdjryQO+SfZ1sGL+oGdwGuNfa24=;
	b=Kdzxpp1KfCbpTqOLv75qSowtl/m6CWdtesbgyUX4XRaopr0htInbqirP4CuvQGIkkpz4cs
	DGREJULguipl4Uu5qYRR0KkFOnPzAMnu7OcDmYwIXdnmNOx3Di1mpUtDRfeAVL1B1l6nhz
	0MFHytOh6JeoNhLycEIj1kMKujfCvfw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PO1SlCH6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792360988;
	b=6SiSVL3Uoa6JRUEN/0i3cQhcd+/5Fmewc5v/oe+ov9/j5ovztaLDqO74+TyHeltC+daPbp
	S3vTFxm6oHP4asKJ2bfra7+tFKpd+utIpwyEh4H4YBDVrin3ebfR/R5RBbrBo1rnvxUpmJ
	MOMS6dWQs49kEfRjQvwzjfTO0xJtzDM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1114960D9E;
	Sun, 18 Oct 2026 22:03:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 896111F000C4;
	Sun, 18 Oct 2026 22:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792360986;
	bh=9jIwRePGhGl7Lj5AtdjryQO+SfZ1sGL+oGdwGuNfa24=;
	h=From:To:Cc:Subject:Date;
	b=PO1SlCH62VrarZagP9eLCG2Zz/sSoHA25CDWscQESh9Jq62Iu5LnFfmDh8f54vvNM
	 mKQg9EFCHasXibgNzVZtonckwtoUm76FsgS4R8lUqAW+1Yu5885OHZ/Ulhm9/1MddY
	 E+TSJ0h1MKBmQDWb3fRQ/aOl4zyh+OLTmE4kcrujbQwUNf1YPVYTsJDhQkx2SpMg0Z
	 xMuiniBCwvhm4J6tqBlYGnUibF9HbliZsa29LOi5C4bFSXBHOsRdU79Aehhf3OEHUD
	 dNcAwF+k+V8jPs3aswqV3EmHp+yZzwyt70eQz9FBc25zdS8IWwf4lQelbi3HJkBYek
	 hbLnkEaLN5b8A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH] mm/damon/core: filter out damos address filter-split failed region
Date: Sun, 18 Oct 2026 15:02:52 -0700
Message-ID: <20261018220253.158238-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 150CC100007
X-Stat-Signature: 5k9rcret9uwrwi764ubee6cwfyt1c7sn
X-Rspam-User: 
X-HE-Tag: 1792360987-234628
X-HE-Meta: U2FsdGVkX1/mgXsl5ckZaVe4Nl2ueIacy7PIKS8lHiEFJHP74TngvCQiFIbm7lMs+mw7zzjFxbnCU5otlH55qHfHZeKUbT0G6JwpWqP897qMIVBJW19qzAJNnno3LiaQF/ICQUcolA1Rij90eC4YbLU9M4mx7R85AYwALlfAPkeqWTNMTm9+7GY3VdZcH2PW0HVOtGgNjYS2xJkdnxq1Vqg3avA5hRoMHNGTpOqhiqIWuHqY2XWXaQ9xT0EcOtDFb+T3d6qkthBHfqQuOBCSrGU2thgNXRFSmNW1bvL0fqwpMVN7NQYGMYlZL8vwces0m/RelOAE82yCrLLO7rq37QJ6jmRcOTkq8YQDiInvfgxRfb3wDxJImnDCQAWfT36wgkMygKpsn0WPCafdt36F+Eg2A1jiqnBB33L2RAZfJwTJwBgXA9LxStgZ1V24D1uWdHH1RDXJfJvwvVx0RVH0abRTH5XzfIcTtvjbl11QD//muBY3j4oXSBbSQePaUr490Qidx1ebmyipcqCpO95CEprsgWfChHp+YGyyUDLspT0Yh8UasaPA+RFhJdfPCDb7U0rQ6QArbTUhE3u85LfvPM/QwkYzQwZ2BZHGkDQAKwgpXA6kW1vGKJYuGK/l6DJkc9j2HeJaTHjqE07xCpRpWk1O4zFaHIcMBKyc1UkepBguSMHfUdlZWNaSQKeAEb5JAF/iVKG69qvNwQzQ+Sgv+aZynTy8eoiS1++n8d81aVF300ZfOWkZKk/w/VeuX87US/kUGG/XCnZ4X6Plm4aXwabeCUMCJrmZenhCumMSEhUp6QoeBdSgqvyuyggoy3gxRSUKKYhKx+5Z1xqxpq3PfyZppDaUHr6jQBHwKa6HLdNvjN/keBxGPg2dfRjKFdIv9BxL6R87GnjsZjuG5cLMXIbGJjKYACiidB+KKaMoWMrJrXi4tpvRX3oiIl3RsMRGgH7TcA6s+gHPCcDQ9FP
 UYIAkT5w
 lLD767Nq2SvEUWF2cA7ksgHB8Bg/6wlpPZmjqP16Nbtw6fL8smcO4qcl4eVJd7e7VzIU2ZFlxD7NRYbVbQKyzTxlER/smu6k28F6RqFDDKQHP8D0yKJiu1Oy2/OKcMUgSC6Px7bVv12Iwk/j3rDqctJQpg+paBsLAmL1ZGQKpNPRQzFLng3NoI0bVC9zYQwJ5DIh5LsV3xBQOwr1uyxNJ1jCHjtz0ymbqpE8xpgRNCbozzqI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
 mm/damon/core.c             | 15 ++++++++++++---
 mm/damon/tests/core-kunit.h | 11 ++++++-----
 2 files changed, 18 insertions(+), 8 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index b63e60ef89901..4d34587387456 100644
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
@@ -2588,7 +2589,9 @@ static bool damos_filter_match(struct damon_ctx *ctx, struct damon_target *t,
 			break;
 		}
 		/* start inside the range */
-		damon_split_region_at(t, r, end - r->ar.start);
+		*err = damon_split_region_at(t, r, end - r->ar.start);
+		if (*err)
+			return false;
 		matched = true;
 		break;
 	case DAMOS_FILTER_TYPE_PROBE_HITS_WSUM:
@@ -2607,10 +2610,16 @@ static bool damos_core_filter_out(struct damon_ctx *ctx, struct damon_target *t,
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

base-commit: dbff06b9dcfe3a45b66fcf20d0fec8c3e56f5624
-- 
2.47.3

