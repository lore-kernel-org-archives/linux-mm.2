Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA64CCD5BB3
	for <linux-mm@archiver.kernel.org>; Fri, 22 May 2026 15:40:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E98186B00B3; Fri, 22 May 2026 11:40:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E21366B00B6; Fri, 22 May 2026 11:40:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0FD16B00B7; Fri, 22 May 2026 11:40:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C49DF6B00B3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 11:40:40 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 909CF1C06B3
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:40 +0000 (UTC)
X-FDA: 84795468240.30.1FFED47
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id E4E2616000D
	for <linux-mm@kvack.org>; Fri, 22 May 2026 15:40:38 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aGORpS/a";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779464439;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rIvjFu8eu4Q0A0nJgGFhpNwMfwikQRRw8RbElJURXJw=;
	b=bfiNO6Wy3kJeyPkagZ4QMqXeFUXLceGPW24DkcfPMF1FGl9VSf6Z9mzuyKaXlkZfk1brxx
	wAuMSBhw45+kEA789c1V6gzIrQpVcP0+7aWokQdCKBYiUppKukaqjlcMSvvOFy5B4/nXMc
	sk1YLkveNd+zPWQuQP3IqFLmUO4N5+E=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="aGORpS/a";
	spf=pass (imf08.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779464439; a=rsa-sha256;
	cv=none;
	b=fBdId8NELK1BWbkM+mSeUgk4QG0g+/HHlOOtnZblU+yTJ3dHK0dQ/q7QoVOW8vHM6Depuc
	UewtE/8njJbJcmcmImHLfqCuHeVLNyXv49cHlCjbvJo6vM6sFfD6tPQdDX70kCzKx8B64f
	fm9xM+P/dSX7BRus/4w1v71W6TEIhEM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A75440B7F;
	Fri, 22 May 2026 15:40:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D845E1F000E9;
	Fri, 22 May 2026 15:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779464438;
	bh=rIvjFu8eu4Q0A0nJgGFhpNwMfwikQRRw8RbElJURXJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aGORpS/aDZWBOOgGeW2vYWhoOqRdFtY1dfp0KbtZFPBcbp+9O/njKPmQRNWhpuV4G
	 SjOBj9b4MZF98aoY8lobf1MA5NoK98X8FMXytnzJ7iAqxMfw60h6R6WCiVtns+s5i1
	 MNzlgHKEphm2PyayzjrGQCGB0a5hLsj9G1tJnbmnbaaXlvsMGNlunKQbvzvgZ1zwrD
	 beC11JV18qFtanY33f+XCXLgcnBwl5TCz4gePITpWZPn2ZTHXxZJ2OW19exRt14p3n
	 EXfHYdEOGkzkPCm27mLSDH8SVcohc2OJoE1Agnyv4a+RuEJfpfTcEgwpu9no5hg/ks
	 jYBxbKTj40Y8g==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 10/14] mm/damon/tests/core-kunit: add damon_set_regions() test cases
Date: Fri, 22 May 2026 08:40:21 -0700
Message-ID: <20260522154026.80546-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260522154026.80546-1-sj@kernel.org>
References: <20260522154026.80546-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 85f6rx53im6msr7zwipnxzfgmntpr1id
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E4E2616000D
X-HE-Tag: 1779464438-785134
X-HE-Meta: U2FsdGVkX1+Pqfj/eTDXXdF7YoX3iiZBUoCDopQ32vLbfF/sQPBVshsq9g0hrbh6Y06LgkJttqtLPjcQhzBDeJyMb9d1sd0gg6eEl9yoJoRan2tob2jg2OYde9Rc0i0gxGUub0Spg0kN5qjfcQkeC6Ilq1WOnRJ5QKFP3CyU9Qe/Zkc0In7k9fClYqKe/4PXN4wIbsEU4kKGYXNFY0jE9a+9TwiFTaSRqusFbeJ6Tm2U8xD+zkpzNsUMBmJitfoFNVSfYH0QZNuxEIYCqH91bX56rJJuVWuYXIXeHcl41ZJbBxob6d4pty/qQCaR4KgC/DyjLKnrqeFkoOQ6Z5yRBrYrr4tviTzjo2f2lVlMzr+bPRYSwMqCwbTS4gi+u5jaER/MhhQ9mErWsUZVZTwoyoYgKAHJIuIQ0l5DI3Vnv4LmMzEk+om+7q8hp3q3usY80yB2M7nd7bpe16zhcy/GCzmtlIKI+QV9SBqmBzY17D1BJo6vl9FOZusaVVoa4fTQ8Zv0eorOs/ZAC+DuZJyIBqqry2aFO1rfhA4iRAlx62cQwYpMevJQ7W4n73jl2aivRzlatV5GOTXYDCBOC+pG108/GwHwgD3c75WkXErZq/SQW/WFvN4rYeC+RawPaIglOorpbjMF+33K5P519vc4kOSsOgIzkSUROFwx3P5nw+xR054vXK/iLBRfxWwCbMiuadCZeY/YTPVJMkDCD6HPtdFAG2+XGeS25Tr2fM4/kKZZFNjd9KGpyWVdZo53SOeNh38Ql+TDOu7fg1UM9ztTJwdJaKCFS+UpdgKol8WmeEOPniD53AVr+IRUzTGHE+sBjHpBs/B9S8T35FLZTJSOm9CDhjvejtgAO7tiIzjOlZjIN325CIFIQlJ4giJUhV/Zg+IzqyyHMGHSxnouUrTlqfz4y+0nZI5iuribWdacXWZtZdDohjbVBVSCmowGYW7bjYANuIWwydcbuqWVNvR
 WIQ3b0a3
 AMKMKXr48LWPxZVzsFTciAoKJnPUf/vdwOzAQHuifh5Bd6juBLt8CUylxh6J8MBYVB2bjIG8ZVM3G3DHllyMeXoZIiMItySKNUxEhkQ5yiHV3i+GU1xjjLNfbUe2n2mmPup5Meh71ZLkNVFlWEpm5pWnIq7Ojpyn0KaufnRHu5y2cFP5r3vVs0jJvhQGAYU2V2BgL6hiMgY5bkTWr0A9r8OJgM6/CGzx0bmb3NNsnVHPAbbib2el9DEGm1Ee6vkZaEJLDOnpdD3Tt3NqNRMMk2lVppw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_set_regions() is one of the main DAMON kernel API functions that
set up the monitoring target memory region boundaries.  Implement unit
tests for verifying its basic functionalities.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 142 ++++++++++++++++++++++++++++++------
 1 file changed, 120 insertions(+), 22 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 866f716e5760d..1cfb8c176b873 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -390,41 +390,139 @@ static void damon_test_ops_registration(struct kunit *test)
 	}
 }
 
-static void damon_test_set_regions(struct kunit *test)
+static void damon_test_set_regions_for(struct kunit *test,
+		struct damon_addr_range *old_ranges, int sz_old_ranges,
+		struct damon_addr_range *new_ranges, int sz_new_ranges,
+		unsigned long min_region_sz,
+		struct damon_addr_range *expect_ranges, int sz_expect_ranges)
 {
-	struct damon_target *t = damon_new_target();
-	struct damon_region *r1, *r2;
-	struct damon_addr_range range = {.start = 8, .end = 28};
-	unsigned long expects[] = {8, 16, 16, 24, 24, 28};
-	int expect_idx = 0;
+	struct damon_target *t;
 	struct damon_region *r;
+	int i;
 
+	t = damon_new_target();
 	if (!t)
 		kunit_skip(test, "target alloc fail");
-	r1 = damon_new_region(4, 16);
-	if (!r1) {
-		damon_free_target(t);
-		kunit_skip(test, "region alloc fail");
-	}
-	r2 = damon_new_region(24, 32);
-	if (!r2) {
-		damon_free_target(t);
-		damon_free_region(r1);
-		kunit_skip(test, "second region alloc fail");
+	for (i = 0; i < sz_old_ranges; i++) {
+		r = damon_new_region(old_ranges[i].start, old_ranges[i].end);
+		if (!r) {
+			damon_destroy_target(t, NULL);
+			kunit_skip(test, "%d-th r alloc fail\n", i);
+		}
+		damon_add_region(r, t);
 	}
 
-	damon_add_region(r1, t);
-	damon_add_region(r2, t);
-	damon_set_regions(t, &range, 1, 1);
+	damon_set_regions(t, new_ranges, sz_new_ranges, min_region_sz);
 
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 3);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), sz_expect_ranges);
+	if (damon_nr_regions(t) != sz_expect_ranges) {
+		damon_destroy_target(t, NULL);
+		return;
+	}
+	i = 0;
 	damon_for_each_region(r, t) {
-		KUNIT_EXPECT_EQ(test, r->ar.start, expects[expect_idx++]);
-		KUNIT_EXPECT_EQ(test, r->ar.end, expects[expect_idx++]);
+		KUNIT_EXPECT_EQ(test, r->ar.start, expect_ranges[i].start);
+		KUNIT_EXPECT_EQ(test, r->ar.end, expect_ranges[i++].end);
 	}
+
 	damon_destroy_target(t, NULL);
 }
 
+static void damon_test_set_regions(struct kunit *test)
+{
+	/* Initial build up on empty target. */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){}, 0,
+			(struct damon_addr_range[]){
+			{.start = 5, .end = 15},
+			{.start = 15, .end = 25},
+			}, 2,
+			1,
+			(struct damon_addr_range[]){
+			{.start = 5, .end = 15},
+			{.start = 15, .end = 25},
+			}, 2);
+	/* Un-intersecting regions should be removed. */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){
+			{.start = 4, .end = 16},
+			{.start = 24, .end = 32},
+			}, 2,
+			(struct damon_addr_range[]){
+			{.start = 18, .end = 23},
+			}, 1,
+			1,
+			(struct damon_addr_range[]){
+			{.start = 18, .end = 23},
+			}, 1);
+	/*
+	 * Holes should be filled up with new regions.
+	 *
+	 * old:       [4,   16)        [24,     32)
+	 * new:         [8,                 28)
+	 * expect:      [8, 16)[16,24),[24, 28)
+	 */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){
+			{.start = 4, .end = 16},
+			{.start = 24, .end = 32},
+			}, 2,
+			(struct damon_addr_range[]){
+			{.start = 8, .end = 28},
+			}, 1,
+			1,
+			(struct damon_addr_range[]){
+			{.start = 8, .end = 16},
+			{.start = 16, .end = 24},
+			{.start = 24, .end = 28},
+			}, 3);
+	/*
+	 * New regions should be able to be appended.
+	 *
+	 * old:       [0, 4)[4,    17)
+	 * new:       [0,       15)     [25, 40)
+	 * expect:    [0, 4)[4, 15)     [25, 40)
+	 */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){
+			{.start = 0, .end = 4},
+			{.start = 4, .end = 17},
+			}, 2,
+			(struct damon_addr_range[]){
+			{.start = 0, .end = 15},
+			{.start = 25, .end = 40},
+			}, 2,
+			1,
+			(struct damon_addr_range[]){
+			{.start = 0, .end = 4},
+			{.start = 4, .end = 15},
+			{.start = 25, .end = 40},
+			}, 3);
+	/*
+	 * New regions should be able to be inserted.
+	 *
+	 * old:       [0, 4)                      [42,    52)
+	 * new:       [0,       15)     [25, 40)    [44, 50)
+	 * expect:    [0,       15)     [25, 40)    [44, 50)
+	 */
+	damon_test_set_regions_for(test,
+			(struct damon_addr_range[]){
+			{.start = 0, .end = 4},
+			{.start = 42, .end = 52},
+			}, 2,
+			(struct damon_addr_range[]){
+			{.start = 0, .end = 15},
+			{.start = 25, .end = 40},
+			{.start = 44, .end = 50},
+			}, 3,
+			1,
+			(struct damon_addr_range[]){
+			{.start = 0, .end = 15},
+			{.start = 25, .end = 40},
+			{.start = 44, .end = 50},
+			}, 3);
+}
+
 static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
 {
 	struct damon_attrs attrs = {
-- 
2.47.3

