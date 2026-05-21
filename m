Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB3E9CD343F
	for <linux-mm@archiver.kernel.org>; Thu, 21 May 2026 03:54:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6691A6B009D; Wed, 20 May 2026 23:54:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 645E46B009E; Wed, 20 May 2026 23:54:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 557846B009F; Wed, 20 May 2026 23:54:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3B8D16B009D
	for <linux-mm@kvack.org>; Wed, 20 May 2026 23:54:06 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 04B13C1D5C
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:05 +0000 (UTC)
X-FDA: 84790058892.24.690B93E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 615318000D
	for <linux-mm@kvack.org>; Thu, 21 May 2026 03:54:04 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bmzAYJEl;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779335644;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rIvjFu8eu4Q0A0nJgGFhpNwMfwikQRRw8RbElJURXJw=;
	b=3TFHyGLV457vPN2C4tipMHrZBHa1iYaqSgm4aoJ1b7JKvLFKDgz78naf4kdgpgn/7fGK/+
	F+hezCUh12dAU3ART1aZr58eYUT/LVyKwmflnz9kbSFeP2y8Ao5aWjfd8iy2rnx9PgOBJw
	Ab9JzpYHSxbBEg12S1BmuDQkjGwfnOM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bmzAYJEl;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779335644; a=rsa-sha256;
	cv=none;
	b=50SMvvg6WtoRU6+BIGTMGkVbJ1pUNNK1TxmpIM4Q362VJY5HRuICKvxfZMX8GMy+IItZ3p
	SMl/q8oo0RDvbeGE/ygd46mIHES5bVLpuNoiTYhVPG9axFmFbIQSuFxYUDrfC9T+er+5uj
	uVwgQko9Vx/z/1jj5GGWU0S+mvKja1U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id EF72660212;
	Thu, 21 May 2026 03:54:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 539221F000E9;
	Thu, 21 May 2026 03:54:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779335643;
	bh=rIvjFu8eu4Q0A0nJgGFhpNwMfwikQRRw8RbElJURXJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bmzAYJEll8beXB1K/C2rujBcnZyVxDXkAMd3rVCyK9z6Fpp86xKLbo8E55/uw7VVb
	 sU1Aop6f5Z4N8W+A9qVBfohA5Fa0unL8Jrsv68U+VJofuW4CB2JzTdGzxjTu9NC2Pa
	 EdG/JRw3hTz8oRZ/amUEiC+okx0En2B5c9PMFbPkAQP9dTEL7SiFMfCPPqS0PtkDzD
	 9mArS5FsCI5EadfOgVKgWd/KRBajy4KN51uyjTGDJ7rIGYD4eJB4Vr3tYZpUEp3B99
	 vV7ssmAz+bxGlTe4DoE2unbYgF1lE6VSkNcmUwXWVfkgAEyg/j58IS+lCvkxcgVL58
	 GAQdNDK6UGfqw==
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
Subject: [RFC PATCH v1.1 10/14] mm/damon/tests/core-kunit: add damon_set_regions() test cases
Date: Wed, 20 May 2026 20:53:44 -0700
Message-ID: <20260521035349.87565-11-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260521035349.87565-1-sj@kernel.org>
References: <20260521035349.87565-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 615318000D
X-Rspam-User: 
X-Stat-Signature: ra5rw6wn7gpf9n5f4ms6q9qfyq7xxfc4
X-HE-Tag: 1779335644-272484
X-HE-Meta: U2FsdGVkX18UIB5xfKmuWvub3nFVZeIgQ3ZwtKTwWAO2fK7Grxh+Cxs7JmHIkbQGcefoyD7mZrxbkPwv312WHxuWFp8rlF2t5aR6uhCKVPyYj9Gjytr3/ZSilLaYqXOIKOyNGAA2qtGCu+KWID/Monbc17I7D7cNHE5c41O9wLkYEvnwS9SvgFGvNlmh7g5gr/jxOfBdbSRHAOAVu4XqZCpMySluhKSEkp9B22x7PpdRIMCWRL+EvhMk6sPmAkUd+Y7IdORgta5J352U0191vDHV0o5+72hXp/SFngbA7S3BB53IvtasbSe2neu4/2LyO2jejSkXTnTM0owCOm9NFa7/d6CDczEhB6OMD+8Qfkzjs1v//OA+SB44DfpS8NNYZ9DuIWN+MwwiGZV4zl5865Om3UhQd+XIRodA1WFc1lXWqG4wVHXrsiHNP+U+yKlAv3tVolT71jIWhfCdSX9eeakqXoof346M8k7QlbC4ODfym3SFEPjgYVixF+M1yMmUX9LH7I0urZTL9AUH9mPHoOi9EbOpIP1V5dePQjCrYCIZEL6U01cFv7AxoYPMCnlQKIn81ZEgkR+Rw4/C3o0RYYjvA5sTMepmYchv/DsS4Hd+xernRsy4B8g1Vg0aSNBkW76D5SHePCZYmhIN3+QTKyV90EsRXVP4ZiH8vJe5oQfJ3d8wKhpwCa+jEcqS5d+Sxtv1S+uLEIqwlGldw6wAYMYJvNa9zDHHKtM6xjoB2iUYvMO0soJRzh9eJ6ldZfuMKaM0oN/jpotSclucxUJThegkN3FJGjmEAmtI3M1BNw0G44qnQk71nqBFX+XqjvcHgaq9dSZJu5oWmpAk+7XhOalJHfMtJKbvECaiqlNY1ACkWx2UGJX9Ts1auHF0n7p4UzEUp2aBCI9VckBK7ojd7yRZUphF/OzpLXxI2ug/98QpoJel7Vgek6nRJmGoPUeDMZSj6cM9QUlzAe+itHO
 WbYqE0yg
 tgSO5y0r/4whWuixkvc5DyM9IJBeK/OJGZrb88M7IOwqV9p3xrbksViU0ZtpRi9SzqS5kmPxAlFPiDC1Ob334Zz8Sfr7kPzpU4og4mC/gwSusRKamE81+nDthf5UohLeTQzmxZEcDMhDg7Je3Lw0iOHsnC3Ccyk17iJimyi3A3fbkA419l/GhHp+QYqNoirN3cwUta4PG6kLn/Jcr6U8xjQzeVySGNBZMC7NgfPuR5H5pGLBMbomotc+lVcPlWVB0xFLp0Wg4rSdEfGqy1oOi3BDohw==
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

