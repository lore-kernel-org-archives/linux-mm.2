Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E4C0AC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 04:09:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 868866B00BB; Tue, 30 Jun 2026 00:08:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CB436B00BE; Tue, 30 Jun 2026 00:08:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5D0556B00BD; Tue, 30 Jun 2026 00:08:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 130596B00BA
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 00:08:35 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 253A7166DA6
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:34 +0000 (UTC)
X-FDA: 84935247348.30.E4EB717
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 80007A0005
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 04:08:32 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSbt7htF;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782792512;
	b=0nsrIF+lG5jd7qn/QUIfcyfbJxHl6M/ygGS6k32wjjWpVNSsTLj6+M97NbbjE5GnjlblFP
	tw810tBrPV3erDntjUKWHWD0x2eBCRIvHc0TmronBtjk/i6BBZnApipiFZRUKRMBUHcShY
	WoRSdsYk8ByIuhPOTaRRKABVXQfh/LY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782792512;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TgT+hutf52OMB9dkbc+zfxYhctcg5UGA4qdO43qT8No=;
	b=6FeURQqWyMLgXQzpMOLdecYGfPwgV6WrbDk/nF5jGfU1XHmpwqDKgH6rLsJAsrx761LBVQ
	a8os3a9HhaHCW4dzfsGMTPswkuSXj6Iu2Am77egONZDIl5tp0sQX/uVCIKf6o3tWFilZ6d
	ErrjRlkiezAbRGUV4RV1tDze4k3Qho4=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cSbt7htF;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A680542BA0;
	Tue, 30 Jun 2026 04:08:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CC601F00AC4;
	Tue, 30 Jun 2026 04:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782792511;
	bh=TgT+hutf52OMB9dkbc+zfxYhctcg5UGA4qdO43qT8No=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cSbt7htFkvo6FVDM6mxTp73nHeXmXclLh25DPBmKhf5ZK3xiaVeDIJAgPF5I+xJ3L
	 n1i8PMZvMCsRGMtg6mvv8bcmlJsmaw4X1Sb/+L78YJuluKzgwys1UB3kC5dn0QdUR2
	 jgzGPpzSHL+F9NKH1tiu1nvPOTSex9RnIhvNLae/6J71tltHs4IGN/hKn0FhHjJiBI
	 DnMY8BD+OshSKuGHF4J96OjrTMvDpbmmvpYNGpQkCzpmuYkhsTF2QCDtFFJBf93ryt
	 tK2LnqofzwvRQF+Ui21CYtnlMU1YoDlnuQpUzLcy/QnYmplyq00X8sns0NP8+zO2vh
	 xdm+JCB3/lSyA==
From: SJ Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 17/18] mm/damon/core: remove damon_moving_sum() and its unit test
Date: Mon, 29 Jun 2026 21:08:10 -0700
Message-ID: <20260630040812.149729-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260630040812.149729-1-sj@kernel.org>
References: <20260630040812.149729-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cgxmt4r9uhsai4dt54s7i33d634mqsxu
X-Rspam-User: 
X-Rspamd-Queue-Id: 80007A0005
X-Rspamd-Server: rspam02
X-HE-Tag: 1782792512-159994
X-HE-Meta: U2FsdGVkX1948MXrNz9gdhQF6Z4pZVHwuinrmZ8o9of0StPlYERrsodeU2aajxGW3pRgcOSshRey+O6MQxmTZu2JaIClv8NVHJSlgHRlCKD0F25at1rBGf6lmML6JjCYL6qf9GKdFBRBdYpDPOqyrAJsGyuteRuWFqwl4uT6KLwz5cCIPlGYtfmLx/Ey172aSdQbLlP32Jv/w7E3lTlJXMMOC3+maqR5Cn2Xj3vdKHBkbmVSnXGKStVERLgtVYmzoXu72FdSnWh4p1qSUAHyY2naas0TkQhXHmScCRKB/UzcnsTF1gm7k6mza2MIzeW6fu7MDAelK5hbrk5js8z/NPtL04WV09MDA5nS7jFFtFujQsmRyFLm/M6ig/i0xQ592mJbX9A5wKruNStL0gEVlOGVX97i/mSbjCoHCyQaoBG1/QbpZu9DiNOEKKJhFASUWwwyPh/tEo01JuT+pZd+cC7sXX2TCZ6YoqtHcy+bTqf1TWOTuzES9eXoG4NeV+CtBTZHqsSVhL00jdOv8YY3IAP5AgvDH4ibsyq8/0oUj7obPfazCdqLCIE1Bp3a4cR37CrYYSIOvNrIxin99KTzVPm4+TaWqnaUqspG5S6naYLdkH3/yg1gPb7c0ZEzu8t97z6N/fLDhV4aeRSHoQBb9Bfja16pURSJ+N2Goq/dI236ZZy01gwybuU/y0dYQASEzBKMu0szzLbIYutPf40t8a9YVfCrc5EhFk1GDlENMCqyuF+jIJI3Ib3fYZgXA1JvI04R+/QNkp3Kpx4yhf7iCFWdu1CO6XNlg/UtU1gA3diYcg5ASD/87/C7n5sjEz3bpRHF+AW3ouXi7Y8IjEkCqipK5niP/jIh+Up3Yohk5hwLPyxj2XMFWlTdiq2hITebbOJvUrAjJPqkUPdw1cMc1KajjiBxDNRx0997xG5iydEHbDJXT7xr2qCXckE84MpctDnP0j+f19s45NrZUex
 hbG715Tv
 YoVEjIZKEbS42WfLm5LSEpbGsZsRXoJLmCfOh6XlbAq8ln+WY4n3u0l+Np+8hMzoy4ypQfyTnBt9T5PrmALYvfbcz+7pZ0mBCwYxqC7CygzvHDi40viEj6eg8h08sZ3k6kqmLQaU2MM75EZ5LIiUIROYBHyjcnSnYiKzVZGFVOG7ht1bz3ajcGVSVWWbg2j5n6m/aobdXCFsD1/x4kfcdu52FziN+G8or1viSncxr1RGjxjW+MpbXKbdNgNGwP13rmq/q7o0SSchhG6i7D8hFI8tFJPNmd8MBvkWD
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_moving_sum() is no longer being called for real purpose but its
unit test.  Testing a function that is not being used for real users
makes no sense.  Remove the test and the function.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             | 40 -------------------------------------
 mm/damon/tests/core-kunit.h | 16 ---------------
 2 files changed, 56 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 33c6fade59d37..83753a53e7b98 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3770,46 +3770,6 @@ int damon_set_region_system_rams_default(struct damon_target *t,
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
index e1d22abfbbc22..aef7e0553cba4 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -659,21 +659,6 @@ static void damon_test_set_attrs(struct kunit *test)
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
@@ -1576,7 +1561,6 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
-	KUNIT_CASE(damon_test_moving_sum),
 	KUNIT_CASE(damon_test_mvsum),
 	KUNIT_CASE(damos_test_new_filter),
 	KUNIT_CASE(damos_test_commit_quota_goal),
-- 
2.47.3

