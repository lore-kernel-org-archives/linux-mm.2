Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94AF6C43602
	for <linux-mm@archiver.kernel.org>; Wed,  8 Jul 2026 01:33:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A60B26B008A; Tue,  7 Jul 2026 21:33:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11C56B008C; Tue,  7 Jul 2026 21:33:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 94D8E6B0092; Tue,  7 Jul 2026 21:33:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 684176B008A
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 21:33:01 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D74A11405E3
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:33:00 +0000 (UTC)
X-FDA: 84963885720.11.F1F4C2E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 37004180007
	for <linux-mm@kvack.org>; Wed,  8 Jul 2026 01:32:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ESVkzhHw;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783474379;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=T+VOUcpSDlU3fuzMuw/UnhEEzVcjPNsnHwRJeSaH3SA=;
	b=01LXM2dXsyJhbel8C9fcmx6Jfw8heRgwg5BZ+Q4erO2TPXc+PjtNGXtr4YJSBQgd8UTA6U
	bsco9UMfiVMxHZNKwG4GhdR3FREtxIDNE9ep0XtXdRNtfN3+56U3rQD+tvqkEuNCKPThx6
	dPCN7VYjM8XcdJ3mwTvcaf1XWBQ8t/8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ESVkzhHw;
	spf=pass (imf16.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783474379;
	b=JcHSJYCQodR+WYnz2dSE2ia+9XxECGoQrizjcqg5D6RkyFhfRKxM1kv+xqtM6dtg7XIusy
	moSGDiE4vfUsIWXqr69tXGFtkKG0bEezSE61dKL8rAkS7G+dpEsEMNmF8vpd9IEpDHEeKl
	DIxzikC8B8+TgXfSXyimpxSm++hHScQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8639040705;
	Wed,  8 Jul 2026 01:32:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC02E1F00A3A;
	Wed,  8 Jul 2026 01:32:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783474378;
	bh=T+VOUcpSDlU3fuzMuw/UnhEEzVcjPNsnHwRJeSaH3SA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ESVkzhHw0s2qBTPVfEyF/jPjOX+JKGUFB47v8c78YsrlEtdX4+3//kpYIvSWvNl7m
	 kNS8q5Kx4OFadZm/wdtDw8Ql755HvxiUI949gn8+rMy+af7fWGts3/8sMkjzyph6Z3
	 sRpj08NMY9XKUFqH9NHRhf/Qjbdys99kUGRQMXQhY6RIotJqoTTQfdKACgpD0m2yHb
	 l9GJhMKUdGzs+N/9mg0nqCXJAVtBKSemJX20twrXm6L8ohkjIXqN6BfOGPHfqkK75e
	 1Pka7mi1nzq88ogt+z1ijBo2LwMLnvaWNM2zL6v7Fj/+mpdeYTRJ+kAuRaI0smBQIX
	 +0Q5aZNvFdHpQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.2 1/7] mm/damon/core: remove comment and test for nr_to_bp() divide-by-zero
Date: Tue,  7 Jul 2026 18:32:44 -0700
Message-ID: <20260708013252.95888-2-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260708013252.95888-1-sj@kernel.org>
References: <20260708013252.95888-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8o9rxbm38ghouadzi5peeci67hotsiax
X-Rspamd-Queue-Id: 37004180007
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783474379-50614
X-HE-Meta: U2FsdGVkX18bypdur1UOb8BH433LA7VhYHthq2THT1kLK6eSwqetP4DOY6JeFbQVwZshpHdKSzlhVA+7+mK4HOtw1eTSQTVDZ6rHyHKy8Pu80sbw38Kv8MJPj0I0ITp48ZWSc3GI4bGMQJMKBoaBuO38Qygvu14WKxL5L/uQHmyO8ohNhINwol52zVTRYA+GVqMbFRDtf6w2WncLlu8xlDA92xennVo45/iCO61LX+O7FDHWeQqFE86N4ZIAoVVjgEy/TsgguU9ZCA1R8szF/k7+D83dtjVTguUXyIKj+UCif7znag9NpYEbIP8IozKX8iaztif5ziKuDVjrS6bvyZuqzHfeYd5/AdKOo5ptkexeo8/SvsDl/lJW4/LX9T7etHyZZtAPdx9OFMyRMuDWwyyqCbFwRr6l+zwWJdSDyuEimOYCHMaGdReKt4Fsroc70gPW1GABvDPAFyyZC2SyGuZW3GzBMKFeJ2XCjWCSAkVRIvhVDLe44wRecnjMOMQ9jq6a95IiBfdnjjkCYhmrEq2aZ83OyKhf3fMp5SiBmLeaXCaz2RyA28trjeaAxeVZkS8AwxoC6Q1pzFLlrHoDj+sOw7WY4Kx7+oBfonlBnDr7TZs8nezClfsKFnHEhXl8tNuqKJUSXWix5gm0Vrd6HMyOwWFAhutHFjTgUVANyDEALnRumXk9WJCLtV7tFtKOqfVEk/cnroDIe5GBoBtfJZd+LT6LByykjdArhRBGC+RhMas/IKtn1qntu46I7xXUHomSFTLbgHzO1T0mWVYKQW7r1EGqG7vI1GOFDSSS9aLZ9jm6e/oOZvTY/Fg0tdul7NKuDf1QtiVagHg0xhfpMGW0gVUDuzsc6tED+ETUnY6SOUuhRroHL0hiwGcsMAU+qdtNJtZ/+QTDiwGL4fVUMm7hizzH5fydrLULmBnSPo0+gnYqCqGiC4ScMV3RgMQyz/4WCiO8GqTOHWB9uSq
 EBbPSL2o
 KVDWw32Kj1ZeHmc1eMyYORWHS4HWGK6ZrD6huQZ4rd+biC5rq7yP+bkbZKUzZSncJRxn7/JlTvBRaZtuTWP7XXkYK8Yscjba2OfLUOpH7J6lYiB5nJV+EydZBG8SVvKTFJfNRWHuJNiDaFHhHUROglIPb7BXWQnq5KvW805Ij/mI5+qcyjaJLCqPeimlFNT5I+Wi3diunlT4k03sUDZcK605YvO0+AAWj+S98pxkOcsp0VyehVhGtF10nnJkAz0VpzTNWb9TOQ9NRYRs4VN9Wz6Buew==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The comments on damon_nr_accesses_to_accesses_bp() and its unit test
warn it can trigger division-by-zero when the aggregation interval is
zero.  Commit 35d4a3cf70a8 ("mm/damon/ops-common: handle extreme
intervals in damon_hot_score()") modified damon_nr_samples_per_aggr() to
always return non-zero.  Hence no division-by-zero of the note can
happen.  Remove the obsolete comment on the function.  The test code was
written to test the division-by-zero case, which cannot happen anymore.
Having it makes no sense.  Entirely remove the test code and its
comment.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c             |  8 +-------
 mm/damon/tests/core-kunit.h | 25 +++++++++----------------
 2 files changed, 10 insertions(+), 23 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 390e00b3685ef..a15005db82899 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -883,13 +883,7 @@ static unsigned int damon_accesses_bp_to_nr_accesses(
 	return accesses_bp * damon_max_nr_accesses(attrs) / 10000;
 }
 
-/*
- * Convert nr_accesses to access ratio in bp (per 10,000).
- *
- * Callers should ensure attrs.aggr_interval is not zero, like
- * damon_update_monitoring_results() does .  Otherwise, divide-by-zero would
- * happen.
- */
+/* Convert nr_accesses to access ratio in bp (per 10,000) */
 static unsigned int damon_nr_accesses_to_accesses_bp(
 		unsigned int nr_accesses, struct damon_attrs *attrs)
 {
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 0124f83b39b83..b2a280556b841 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -575,26 +575,20 @@ static void damon_test_set_regions(struct kunit *test)
 			}, 3);
 }
 
-static void damon_test_nr_accesses_to_accesses_bp(struct kunit *test)
+static void damon_test_max_nr_accesses(struct kunit *test)
 {
 	struct damon_attrs attrs = {
-		.sample_interval = 10,
-		.aggr_interval = ((unsigned long)UINT_MAX + 1) * 10
+		.sample_interval = 0,
+		.aggr_interval = 0,
 	};
 
-	/*
-	 * In some cases such as 32bit architectures where UINT_MAX is
-	 * ULONG_MAX, attrs.aggr_interval becomes zero.  Calling
-	 * damon_nr_accesses_to_accesses_bp() in the case will cause
-	 * divide-by-zero.  Such case is prohibited in normal execution since
-	 * the caution is documented on the comment for the function, and
-	 * damon_update_monitoring_results() does the check.  Skip the test in
-	 * the case.
-	 */
-	if (!attrs.aggr_interval)
-		kunit_skip(test, "aggr_interval is zero.");
+	/* Zero aggregation interval doesn't cause division by zero */
+	KUNIT_EXPECT_EQ(test, damon_max_nr_accesses(attrs), 1);
 
-	KUNIT_EXPECT_EQ(test, damon_nr_accesses_to_accesses_bp(123, &attrs), 0);
+	/* Too large aggregation interval doesn't cause overflow */
+	attrs.aggr_interval = (unsigned long)UINT_MAX + 1;
+	KUNIT_EXPECT_GE(test, damon_max_nr_accesses(attrs), 0);
+	KUNIT_EXPECT_LE(test, damon_max_nr_accesses(attrs), UINT_MAX);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
@@ -1572,7 +1566,6 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_split_above_half_progresses),
 	KUNIT_CASE(damon_test_ops_registration),
 	KUNIT_CASE(damon_test_set_regions),
-	KUNIT_CASE(damon_test_nr_accesses_to_accesses_bp),
 	KUNIT_CASE(damon_test_update_monitoring_result),
 	KUNIT_CASE(damon_test_set_attrs),
 	KUNIT_CASE(damon_test_mvsum),
-- 
2.47.3

