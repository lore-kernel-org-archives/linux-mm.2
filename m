Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1D00CD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 15:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 840836B00A5; Sun, 21 Jun 2026 11:57:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F64A6B00A6; Sun, 21 Jun 2026 11:57:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A7B86B00A7; Sun, 21 Jun 2026 11:57:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1EF6D6B00A5
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 11:57:47 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A35871C2BDC
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:46 +0000 (UTC)
X-FDA: 84904375332.14.AD556E3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 040B7180006
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 15:57:44 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ieUGizRa;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782057465;
	b=DeUvBgPoWf846pUcq7ZpUYSJc8iNAWGdQCWA46KGRFxOF3S44cZDu0k5mIzx8e6emKohno
	ffZxYye9UXSr0edwgSIxgNultZWlDL+z5UcGt3Oa+hiLXZKOh7U53yQUpcb+MKCD8GdSHz
	mgngm+qJuH8jLBGEV1D4vKi9TrGQKb4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ieUGizRa;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782057465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sKw7x2CXNs6bqiqh92iTOYiiNqe5DL6LY5pildJccFY=;
	b=U9SvhlmxdDdISN7bXZll28TJjXhdhHH+bMu6udFe27YKpcfXFa43LhscBCFa7m1Oti77VA
	rB1wLbarl1VgIBhhjKKuE3qI6NGoAYQfM9vzzgnhOe8EH9P4azNKB6ZyVYBJeCoSf2N6b9
	3g5ppyHpzQ4XLg2EiATcoyGFytx4V6I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5AB314409C;
	Sun, 21 Jun 2026 15:57:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8E351F00A3A;
	Sun, 21 Jun 2026 15:57:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782057464;
	bh=sKw7x2CXNs6bqiqh92iTOYiiNqe5DL6LY5pildJccFY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ieUGizRaO1O6EdEY+2X9rHBPopLOwwdoscwzW01KVXR38nTeXJNcpIj+qDWGscvcI
	 qkYfmDEJVKIUjAKfpqdTxqgNev6Zzw71Oa9me0SKbegyQqaAHg85/1yS0XrlwDA7oI
	 PCgR1CH9KfCC62S7O4gu6brTsBsFryWo+vS7Deb6W1+YkN1CEr4iXbWUB/NktVUjUt
	 Q5tVQ27jy0JauF1Yf9O48lwmdVBGRVIltbXUXFBlqukfPFnPuDCQt8bWtJHy8FvyTl
	 a1P1Z8Ai21vwwe0o71gPQJebgSMzT2LQuOZeLNOuxjktKSbq+mFs+TMulDwJGsTHu9
	 VJLbNub1ykRlA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 16/17] mm/damon/core: remove damon_moving_sum() and its unit test
Date: Sun, 21 Jun 2026 08:57:12 -0700
Message-ID: <20260621155715.87932-17-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260621155715.87932-1-sj@kernel.org>
References: <20260621155715.87932-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: bhgn69fyphjoh6odh4tnem4cjw59osz5
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 040B7180006
X-HE-Tag: 1782057464-108291
X-HE-Meta: U2FsdGVkX18S0DLF2/nKa0fR53ggBFiTwnncyvyPbkzqYF4+onLS8SpQkuuURPDUi4a/qanMD9jsPMSrHkWaqW3kQXeBqA7NjSLJLMVWmR0mjNypjywnlxF/+I81Cx31z/PyxkHumye/WsTGCUT1xJZct+dDacBBrvE8QJtkAuQPPlkaARTYFY3FItHuFMBx42+27CJdTz1nj1SBLQFQkv5UXnWGSOKm3mDRHFFIJW8adWyDaG5FF/dDZb0Fh2FeTr484liaQlPdtW7mfPLxcjummth6MomUag2C5TiudObDseoEzE7hmXiPQtTpjxwz32+8BFrCg3pWnEvi8Oi1i/bl//cPGGKoYhXIlOyPpBEDRsaMYEl2oRpmVIpoUB9tr2WEnE4oqAWIee8DmcN8ngtqolX+s4F+DaoQCX49+Cm4m5tfRkwHhxH8uOWy49fIbUaFTtEaeoMbq0Jee7LX/Yn0lrZ5XIxnkTjoDo2sLprM7JGo7Kw3At2EI4vDjko3oYHZGokLrS1NWJOKhO9sxUZ0NND4RzOcWmMGFx+gB3zVBT8SqsLQdp5ChDxDoLPNKDotCXEmsuf5K2tkigf6RfqIFC75XZXqBR+6NIbKxTFv1HmZe+K6Vn0MgAOMOGs19yX6qAbOeW/fgKF/P1T+VYygJEw72V+g1WT3xhJwJnjPHBJFPMNOzhAjhZQ1wm5swJXOk3ICvG9LrimtcEMHObhBQpooRyfVicMohsla/YsA5/DnugcsZQn6D3SHREsfbVLe5oi/YP2GpsYK08OWxuvvmpHP1fZO2fSCKCePSVTJGKK+rPLUZ+HJSRXeDnNZP7MQM0yFX3mG5ie17Y/MRun/x4AfjKzdaTZpPb74l+IbsWeI3K3yp4kUnK0CIqoL6aiDJ+DPm1IEG9i9KGGr2khoDLVYkcQWGGbj/Qh5WADCD313SkLjVqkfF86pLkKy/vV2OauS5Q5ocOi1XWR
 s3qKQ7Zp
 W6NM1YaH5qdnpw9PZ56at195QBmlE9P3jzPD9XiWVzYydkMU8VYv3e4TaQb23Rh7fh6H7hlTtdH1hL+fr6hlz4GtDooy8HZHUMBYjvr32qP3zdOr1CXopIvXfxO7IWmR8nuVfrFb0o7vwPTOO+nMY6SdrrWadmZhBSRu1ekx+eRtDgJ18YOlukKrwMjQG4hpQmwRmF/wp6NtIZMN/Sowo7elprq+M44GeplqkYcoZeQeNr8hcLMW/5ZZdFeZWhEirTQlxf9ub8NH3iBsdd9t4TeVfz0OhCE/8451Y
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
index 6b36e17660c05..6542ebf13d4d8 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3724,46 +3724,6 @@ int damon_set_region_system_rams_default(struct damon_target *t,
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

