Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8357CCD98F2
	for <linux-mm@archiver.kernel.org>; Sat, 20 Jun 2026 17:23:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 529196B00A0; Sat, 20 Jun 2026 13:23:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4D9F26B00A1; Sat, 20 Jun 2026 13:23:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 416B06B00A2; Sat, 20 Jun 2026 13:23:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 113036B00A0
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 13:23:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 815BA1C3F4E
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:12 +0000 (UTC)
X-FDA: 84900961824.16.FAEA4C2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id DDD5220002
	for <linux-mm@kvack.org>; Sat, 20 Jun 2026 17:23:10 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L/vk2Zwl";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781976191;
	b=1uAY4Ef0Mzmfl7vx3ODeWm7hKsyzexogRkwReZP6AffbDIjrsuMe9lHU8oYXZwIc75KF+I
	WJUrffa6MjeNoZ8nlo/cbtOu9/9Z+FTWgSlTOgmrnRL9q5OXhRFGAkdNIoBAusmG8Cmb41
	HvhwvTRPiHfPQBs6Dn2TTPDaUlB/k74=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L/vk2Zwl";
	spf=pass (imf13.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781976191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A3RbtE69bByxdhP29KXrthoi8Z7pSsaegAvxhCquZFE=;
	b=TJuDBdpZP0td4wXwEdm6IKcIYwFNUBiqf/ef+DJGUJijI+j8mehMPpOxWLjwvP/0mmAOay
	0z2ITEhT/Ku+VPwQfxQNnvp1JdoCgPuJc5lLNVihMUuhyRqYN/0Wp9LKrcWr1bQtSq7eWv
	bSQNQqPqRqsoyI3aeCAigmrREQ5odSk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 315DB4421D;
	Sat, 20 Jun 2026 17:23:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CDE31F00ACF;
	Sat, 20 Jun 2026 17:23:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781976190;
	bh=A3RbtE69bByxdhP29KXrthoi8Z7pSsaegAvxhCquZFE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=L/vk2ZwlDmGI/W/mpDtQp9cU6aMHFl1EwT3t32yZv5rgtmnJuTNsVJYSW2RAVeaA7
	 IZQqQoMQK3rJXD1rBEgiANFF62acHACc3TTeELWr7AjucHjLIjQKDdQsDjcdN6cv3U
	 YoIp67dl7f6C6eRAdqoGsEVjUKccDIGIR1EWc8G7SVRVOmDEePg1QNSuvHwZn27qim
	 3CZmluttVnUJfuD8UuQ/m/UvvKWpa7BcS6JqI+Q8jV4SgYiX84SzniGwPuRZetyNzV
	 ljeGpT1OzyzAgqefxdeQJ0dwIdXEn+HijU2Dp95Kri8dIqkFLVzle1y/sMQ2UJHgMg
	 p+nZZWJi7OqSg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 12/13] mm/damon/core: remove damon_moving_sum() and its unit test
Date: Sat, 20 Jun 2026 10:22:42 -0700
Message-ID: <20260620172244.90953-13-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260620172244.90953-1-sj@kernel.org>
References: <20260620172244.90953-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 71r1fbscoqe81cjq1m9axkww5wguuuwr
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DDD5220002
X-Rspam-User: 
X-HE-Tag: 1781976190-100750
X-HE-Meta: U2FsdGVkX1+GbMirTj+yxGRHf6K3xVQbfGyC9MmZQJQHhIicljXOcaS2OuvBtUOfgd9XzOvL+NPCyg5Qr9RRZptwuvNRpia/pJl/mnD3diX1W2i4nSPvp3YL4ZxyG5eeTRznbkSgdEUf4gIK81cJLN0gTaM/Pxppq8aR7vnFrh8ILGvuA/5aPNRy+kR2MN9+ujTth3OckmdjIw2nMjeFJPYT0888HHO3ZUEeRB8l9iXy9D+GJnFwC6kBVSIHUYxRTaLITd7kkkhpXrRmFdaaIEsH/1ypIls9fcem8CVQdMh+2W9sfhCErGoLAFMkVAnSuJovyqOVetr5Z/k8iO92umBzGQFN4xUUdq059swzejNDESXl4GxJA4raXMLEv8yB6FycZQjOoBLLqNfik5/Ljq0HP1QGZLf5IykgsJ/vDze/c+vBpXL5Wl36uT45C6ucWvdt5sRNhktyHaedOYMvKlLODCnaebq3jE9KlVyhKyU4MKiQozGl9yrE/0ItXmueKR2OTE1JFRW80I1UMnGlzVQzsP47XuDgHyTDx96JnwZXDkbt+IsPQXE4agx5Zlu3Vlql3tMZYBu3JKxLN3kzX+xslzzw7dPqdWqIBlwMSdw6bo39WB3jC7mpvxuY0jBaOlc59l8W2MDzCLctRqwymqvymuTJbT7DP2cfOfZnEExBbbJ+RForUue7ootL1FvTOvPsFtRkSajaYWQmS3aENnXc1FCLxQtET+hnXfwO4wpyYdMBr6y6PEgaq1GIKUBMG3wvVzj8t56971qhog4H76YCqVU/K1gps4wPaZRJOXKztQ4dQSA/8BlOd8hwM/IIotvdJMpE/LdwoY2RI14X9H0vRuBJQlTRA769ijuVheA9SrjU2mldOppkuZdyxTmhyHnI1OJA8ee34a3JhMoYMX5vyL1QSrTwgTq3jfI1dJh4SIcCUzvRcyTrnSRlhWjLOQLtnHf2KgNwfvb0BNx
 r76nG6/k
 Y22Hz6daCU+E17QaYGehibCswiAmjgqowJH85btcOi6c5EV6ce4kvr84s/MPtMhm+T489zXZJ8KjwVaepax4d6R2qHNuKGAzh38P9OyC0jFlrx9eC8v4p2BEzNbGXguRuhMvOqIxtQ5SJghC07ddsRSv3svn4Fnmwy/rs3Doz1gcxTrxc78olpdbH/K9AahMY/xVgBBvRfWXB04Lgg21hwoNAY1GCkoO9VzxjzYFPRsrRQ1F5TzsjHTDbLTDIoiN1+Pw3zefvga5/A5OZSuxiVh5BIQ==
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
index 471b58e8e31b9..f96f54a7f178a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3720,46 +3720,6 @@ int damon_set_region_system_rams_default(struct damon_target *t,
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

