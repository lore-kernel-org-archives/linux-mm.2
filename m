Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 917EDCD4F3D
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 14:35:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C78766B00CA; Thu, 21 May 2026 10:34:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8BB26B00C6; Thu, 21 May 2026 10:34:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A04736B00C9; Thu, 21 May 2026 10:34:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 75D7D6B00C6
	for <linux-mm@kvack.org>; Thu, 21 May 2026 10:34:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 38B4F120356
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:43 +0000 (UTC)
X-FDA: 84791673246.17.DE0606B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A75531C000B
	for <linux-mm@kvack.org>; Thu, 21 May 2026 14:34:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZzdDcdIQ;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779374081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rIvjFu8eu4Q0A0nJgGFhpNwMfwikQRRw8RbElJURXJw=;
	b=ExmOFnpx7rx6CpRGq6CddnxzCuMaxpPSlckSXzUez4jeJ25Y6h+aqMyCm6/QS5/Z+2DUIF
	NMQiYLyw1dKnyc/f7bfX1/fiQHPphQBjNPYqyrdR3MdWAiybz6bwAkNKzKF0Y35hhCCs0D
	imkoC5i6PgGT6CxPN56S/WWGmAGEsjI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ZzdDcdIQ;
	spf=pass (imf21.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779374081; a=rsa-sha256;
	cv=none;
	b=qN3WJwknER4b7QfpN4SbkxxaLWF1hVQq62atuDgeqgyUtb+OUt/6c4a70oRJ+TzPZH1Ns9
	iAErUeOw6m2IWFpMGBcQWhB2q4JM2VghMEpio5+00NYgFrmBamw2Su4HCWumxc+CqA9tJt
	8P1SQFgwnXqPutXlKFTGmndb6El9Xk8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4F71E601F3;
	Thu, 21 May 2026 14:34:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF16F1F00A3C;
	Thu, 21 May 2026 14:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779374081;
	bh=rIvjFu8eu4Q0A0nJgGFhpNwMfwikQRRw8RbElJURXJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZzdDcdIQERBkcPS+c3Xdfq2mJl9Iazp9/dme8M6FhGjAXPYTuUg71RZM2JuuZSU5z
	 TIO446K+cyJOang2ILC+ntls5a66HbUsd8CSc6hzJeQoYYfNHqVPiWrWPaXEA4DU7F
	 m3MqBPEJXg9S/IN3nqH3cmucS/VShH/Ts/HP/k0PmkMtMrylhvzbv11/InfM+larIO
	 SUwv5FvQylO8QE37HeWHiy2teZZgxArhPa3Fph+1JTlvv8PRDetnKgMBWRdZ0YWajo
	 pxGjF1CRk0aZWmOjlokfJNhxTahBwSxQUsq6sK1k2C0Dbyt6A1CSmcA3cWA3cUKSoS
	 +9FSMjAyB/plg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 10/14] mm/damon/tests/core-kunit: add damon_set_regions() test cases
Date: Thu, 21 May 2026 07:34:20 -0700
Message-ID: <20260521143428.83157-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521143428.83157-1-sj@kernel.org>
References: <20260521143428.83157-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A75531C000B
X-Stat-Signature: tujaq84fd9cheiesq3xe3iw7yrb8im64
X-HE-Tag: 1779374081-167679
X-HE-Meta: U2FsdGVkX18rQNvdvpLOrrkM44tUCUK9RlZrJjtlIdoRTaoV4s44Kg3bnKdMyDXQSjHXTYIyk1GpUoDP05uPZm0AAzAlZiYUSYqEH1gx+4aPK+jekrJ8Op9hnML3Z9oX4kQUoQVJmSBF3/4xN++aiqpiBwnu0luEUTyNGWFrIVlE9TDJTo/hl+00jW1E2HOJYjQCspfJdJB+iAXY0gUtE4GGCKUkJVkvbKI/ch/l4OgHRYyexo2834GKtYARpCT2Th7PQvJEe5PB6/FAD+tIiO8g/3CPzUsBXnrizPYR7ojpADbgqSYzPHtkNAicIKVO20MjWbG3sBm3lF3amYpOffhySRLiIHWjypHKiM5ayB62UCBnY/Uue3tCv+jTa4ZwDCKKa0z+H63Rx9ItV/g9eTsMlPlQc/0bStE5yobOgXUuFLFqaPLzsTUAlWifVFW7qqlq0BBLbFzTNW3m7KLSU6xFkiL+uK2XRaiAATBjfZiI8FKBr4r1Ik5IVXMZ0TnbZfYKoj1U0dfwgf2EbfUNOBUbAzpqWkn8Yrb5pdHAeJqM6uIl/U66g7mE0MfuTa34PruEuVq2fej90OpUOKMg98sKefDXGt6/FhYVhkep90qb9r/7d1tLfHil7dWH+y6CHotGZVjmM6//AsLVoX4Ul1g6tlqrXyY+gRPT2PEx16XfwY3VzsjzePz1wuq6OWoyhJGsZ9lT//6Zghdt3NM9XPljldL0D58owWzFKF0yQdFmlLth+CyIXVGBNHTjU2Bd1rJqGCFTPad5U9VbOdaLLVnWSMC0JnJOpD1YH7pFFh7IZl5cdB8JRMvg7/ChTIJlYt77PeRyfUhDfy7Wd81w6h2L5x13yC2ZAnCqvwHsBp+GEeY4DkTSNTNwWJau1zRx+0/kWwlVL9ztFoVegCXNJH4Tzet3q0qZRltLvrqNrM2eAIKlz5Xjf+ADQtPzIX9L0YQlPRNfpDchvWLxjGA
 msjS2GjE
 GLP4RDBwgMFAmhpM6NQJBEIqKuo6OMjyyxXxcrC0HJ5IYzriLZOIiHW8fvdH+suxN6jbiQ5dyTrtpdBNEdgoCUEgpVy4euyiZdF4l4y+6TD2+7SGRccrSDKdED3PYi5kklEmAy9qkBBINk0NMrjaNuoDRwe4ToMdPLVK4lBbJmAU2zUGVmuuXOkZ5IeNy808qXq0h13IKcXbbWVMZ2GpoUHBBbEQPjDgsJLK/PBIu4UV9LQ85mgimaXw4kqdTj1Ku2IT/2QqIey6vr6MF3Ta9soCKOQ==
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

