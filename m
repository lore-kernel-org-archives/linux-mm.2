Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07662CD98F2
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 19:35:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76D8B6B00A4; Fri, 19 Jun 2026 15:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 746256B00A5; Fri, 19 Jun 2026 15:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6821D6B00A6; Fri, 19 Jun 2026 15:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3C3A16B00A4
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 15:34:48 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BB9B11A0552
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:47 +0000 (UTC)
X-FDA: 84897664614.15.25DE690
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1DA7A40017
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 19:34:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qp4h1VmJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781897686;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LJ6B5daBD1Qcu2bd9AgIiNyXAbuz/p2ZLZIC9d3lORE=;
	b=0jpRrS/vNCTfXeSKRzMA41e0ED3uGDJHsw2ouZMPaiXY6MXN477ZYeeE63f5PbBDeixzUX
	7bnbd7vQFr65+PHn9n5C6Xejvg5Tiik8Cp0ocY3o2QsSsZJNuTL4KCmIQHFur8jn1HZOAu
	DG6qwFCTFyNss+I5rGAss9xONlkK6IM=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781897686;
	b=x1ab/tRBDHXBBw4LyrzPESzPgNQOhcsGhvAGlugKg/ZVeAdotCw5YUkuaf16pj7AGiCqJY
	mAwFVf8iZ6nVhsR0qJ9Frpm4nMoAHLwQyrXu2fn/qKDvbbcmkENcBmm82so31H+DlzvCsx
	bRyBloA5hhCaSet8x7l7BcZM7Jkjzy4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Qp4h1VmJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E999443412;
	Fri, 19 Jun 2026 19:34:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A851F000E9;
	Fri, 19 Jun 2026 19:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781897685;
	bh=LJ6B5daBD1Qcu2bd9AgIiNyXAbuz/p2ZLZIC9d3lORE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Qp4h1VmJwrMZYO4kMLPLcPcKikRziSYqbYWivQv4yp65n/C2qk/G48O0Bg2ANt7jq
	 z7/9bzUJKQ56+54FFA0cL8JbpDuCsME+wVE0d8VinKt2TBiQpRIUCXPIoPu4n/PcUB
	 V5HPgizJ8Tn+VYCAuTJT9jb3AFJgaW/VlGk0ATMSw28GbzYsywXfnxuRRgo2J3RIaT
	 EH9rMcbChue+N8ua7VbVCQEzrMLhbWNZJ/KQmp6q1gzxjmKPRUUuFGKBWPVCjfsqZu
	 V2R/dLQdWzPXwDDGOFH10buyQFclxka2d7EFfrMJXduws8HdKOgRdTKBoeFTlcHP2z
	 w/n8zLYnmiQXA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 12/13] mm/damon/core: remove damon_moving_sum() and its unit test
Date: Fri, 19 Jun 2026 12:33:57 -0700
Message-ID: <20260619193415.73833-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260619193415.73833-1-sj@kernel.org>
References: <20260619193415.73833-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 1DA7A40017
X-Stat-Signature: hzkowp1ibo7b4g8r3f5qh18wh4y367ng
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1781897686-447436
X-HE-Meta: U2FsdGVkX1/cymva77iCvH3HYdLzS/T1Uz3yFjbJjDPfiLR61MAHnTRp3DHKXX3ef6eFeIH3blSPMrauMHsa83GzxvRg1F6oE/O3KQY/yV7QuqLIoR/IVlABCGk3M+HBpd7Lp11M1t8p1ltxNRBtsFZX2ePRboAjK4sBuVxpweKusZenZkHl3BfZT4Jcyv2BAtNpV72pnnidn9gBMsekyBUjMOVRuDtNg8VPa/mv3sswIj0UMO6/DUN3AMUy3JgN7UmrFeqVm0qRj4lrMndqCEifZW99mvhYZeAMGefe0sDExkOcVVwsmTYipP7y2ZlgeEN6thtbJAjW195Qe5gY8wloOJrvdSx4mztCZwbYn16oE1xEsqYbcxfLBs5ZHKvaDG0Ar7f6mttU40eqDvs4Z2LYU8JIMVNFE9+PwhqWuLJamhFbZvkpoYNoA8HGonjWjXQfIllWzQrH2xckOPib35URv7PHJNWNHcefxZilWUKVObkRP8CFpnaA53TeBZ6opvCTEyVyzuUqWS6Y75chMIgY7addDNFXlFixOCbo4PVWi1SSD4ER9tchVQ3t9uJaHuCSz36T4X43yqSSgPMvHxf17X+73GIxsllanpGcCMwKFRwBxZ9x9LhAuzYEFZdNx2+lWqDg3TWeS1z2h87Y2WrPOCm1xTb1XQMyASdVcaLV6ZU9Es+rFfZkn1/nYjFrySOWOsIwN/y5XyBDDkdhyFx33hGEDYuT7vzaYynBq6lWLo7yjg4YbyH8Or5VIMnPhvVseqJA3PFAwGzUz6n4eMcVSdqnwpssQGuoW7RJhO4GRjP91+hr9bfUhk+SreszruQ8Uf+DeejGZjVNKa/sMfYVqtz8rzw9iaPccnF02ok/QP58/7egpXcVamOeBubB9WJOCnSvwjEpf4hbs2r9pnrXByTLUymsOTBc9fGA2l6apt3WeoRcBWzOhaQgc7sxqbKbrcorJ2R+8SzR7W1
 eNokTA4G
 8hoSoEC4XwbRzW0g64Hhxj/gz22+0Hdyo7Ck6K/42gdeyhaxSFdCNWHN9G9oubiD7Wk8Ss8IdjkonAcTFqlpsKzpbN9FpTdjtpwr81TMFHqOqjKP7O8Q3qxyGt7qG2HrY8tle78EjK2tAJ5rxxUiXg2ZEGyYpFJz2cPzMlkBLMWuYIhyHn/9RIz3NgehGxb9weW6fnuVvd0pMd7OxmqnCVGlVVyAbkrxhEtguTfAya5cRXl2k2wAKOZAZ6Mg/Y8l3w0Ld735EINOaDzSy/FLZ+4agd4dxMJUwqfJs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_moving_sum() is no longer being called for real purpose but its
unit test.  Testing a function that is not being used for real users
makes no sense.  Remove the test and the function.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c             | 40 -------------------------------------
 mm/damon/tests/core-kunit.h | 16 ---------------
 2 files changed, 56 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index eb129e3f7029d..1b78b2eb99e49 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3718,46 +3718,6 @@ int damon_set_region_system_rams_default(struct damon_target *t,
 	return damon_set_regions(t, &addr_range, 1, min_region_sz);
 }
 
-/*
- * damon_moving_sum() - Calculate an inferred moving sum value.
- * @mvsum:	Inferred sum of the last @len_window values.
- * @nomvsum:	Non-moving sum of the last discrete @len_window window values.
- * @len_window:	The number of last values to take care of.
- * @new_value:	New value that will be added to the pseudo moving sum.
- *
- * Moving sum (moving average * window size) is good for handling noise, but
- * the cost of keeping past values can be high for arbitrary window size.  This
- * function implements a lightweight pseudo moving sum function that doesn't
- * keep the past window values.
- *
- * It simply assumes there was no noise in the past, and get the no-noise
- * assumed past value to drop from @nomvsum and @len_window.  @nomvsum is a
- * non-moving sum of the last window.  For example, if @len_window is 10 and we
- * have 25 values, @nomvsum is the sum of the 11th to 20th values of the 25
- * values.  Hence, this function simply drops @nomvsum / @len_window from
- * given @mvsum and add @new_value.
- *
- * For example, if @len_window is 10 and @nomvsum is 50, the last 10 values for
- * the last window could be vary, e.g., 0, 10, 0, 10, 0, 10, 0, 0, 0, 20.  For
- * calculating next moving sum with a new value, we should drop 0 from 50 and
- * add the new value.  However, this function assumes it got value 5 for each
- * of the last ten times.  Based on the assumption, when the next value is
- * measured, it drops the assumed past value, 5 from the current sum, and add
- * the new value to get the updated pseduo-moving average.
- *
- * This means the value could have errors, but the errors will be disappeared
- * for every @len_window aligned calls.  For example, if @len_window is 10, the
- * pseudo moving sum with 11th value to 19th value would have an error.  But
- * the sum with 20th value will not have the error.
- *
- * Return: Pseudo-moving average after getting the @new_value.
- */
-static unsigned int damon_moving_sum(unsigned int mvsum, unsigned int nomvsum,
-		unsigned int len_window, unsigned int new_value)
-{
-	return mvsum - nomvsum / len_window + new_value;
-}
-
 /**
  * damon_update_region_access_rate() - Update the access rate of a region.
  * @r:		The DAMON region to update for its access check result.
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index d1f019ab6fc25..df16cc070eeb0 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -600,21 +600,6 @@ static void damon_test_set_attrs(struct kunit *test)
 	damon_destroy_ctx(c);
 }
 
-static void damon_test_moving_sum(struct kunit *test)
-{
-	unsigned int mvsum = 50000, nomvsum = 50000, len_window = 10;
-	unsigned int new_values[] = {10000, 0, 10000, 0, 0, 0, 10000, 0, 0, 0};
-	unsigned int expects[] = {55000, 50000, 55000, 50000, 45000, 40000,
-		45000, 40000, 35000, 30000};
-	int i;
-
-	for (i = 0; i < ARRAY_SIZE(new_values); i++) {
-		mvsum = damon_moving_sum(mvsum, nomvsum, len_window,
-				new_values[i]);
-		KUNIT_EXPECT_EQ(test, mvsum, expects[i]);
-	}
-}
-
 static void damon_test_mvsum(struct kunit *test)
 {
 	unsigned long input_expects[] = {
@@ -1516,7 +1501,6 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
-	KUNIT_CASE(damon_test_moving_sum),
 	KUNIT_CASE(damon_test_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
-- 
2.47.3

