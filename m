Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 53A9ACDB46F
	for <linux-mm@archiver.kernel.org>; Mon, 22 Jun 2026 14:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A749C6B00BA; Mon, 22 Jun 2026 10:22:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4D346B00BD; Mon, 22 Jun 2026 10:22:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 989DF6B00BE; Mon, 22 Jun 2026 10:22:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E871C6B00BA
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 10:22:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 123A11A01C7
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:14 +0000 (UTC)
X-FDA: 84907763388.28.8800466
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 37AF51C0009
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 14:22:12 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cXeHeMG9;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782138132;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KSGv/9otqbrlquaihaX+w+6y4eMmGuYdA/6muTWBzWI=;
	b=NckjTuBq5dtQQLEPqQ7WRL+Vs8EplFVETzmf3ftbF235H3hSQIYszRN0o1QF4ztTYeKyta
	geN5EwETJb/NoMXEni1x6Z8qdolZox1iAU+1xD7kPeUSwhqlefP70tsh/GwYWmz1/VM+Pr
	oVehr+B+HyIOKkyeor6JLpJsQ+56jh8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782138132;
	b=Khg/Ydd4o5c1opHPdFabLcu3oWiWXB+TJLot1LxzzWuuP/OR6XxcIxna0xcMokCl4oB/na
	yiKCOFPKSQvCcn6w8ZWA5UsWz9IMJsVCruiz75IWaq2UP1AzbrAniX/m6wW+sBha5xHCdA
	uYRDt0uAe+NLgns5xPKySUwtXGqy+E8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cXeHeMG9;
	spf=pass (imf18.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 834BC4169E;
	Mon, 22 Jun 2026 14:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 034001F00A3E;
	Mon, 22 Jun 2026 14:22:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782138131;
	bh=KSGv/9otqbrlquaihaX+w+6y4eMmGuYdA/6muTWBzWI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cXeHeMG9PadOesd3KSchhJODPBbIW6R7SggEOLMrMoGkEwJ+ptRkVGBdz4b/DV8/b
	 lu+myr1FZy0TY8jfStQbgtIuGY9obJYVgWcD/ALQmj/GtM1HQO6m+DIIEqGxbRm3V7
	 ViEa09tN1mRDLNM2SS376P/VVbYgPLeMfhRg83b1PwqwdPTRK2hdGxpfLK55toB5vC
	 0jDfKPLsznDdjN3Kq82xf1w5lpOILLpjNx5TOWVx481V1FAqSiBAGWtcjNCj+XlsWn
	 y9Hn0a7vAEhlfi2v2VIzaPAOilpWoAggZBXgIoMHc7cWH6Ye9kY4QNFxsMz8L0jvNA
	 KD6nPCQShmXAA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.3 17/18] mm/damon/core: remove damon_moving_sum() and its unit test
Date: Mon, 22 Jun 2026 07:21:37 -0700
Message-ID: <20260622142139.30269-18-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260622142139.30269-1-sj@kernel.org>
References: <20260622142139.30269-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 984u771asqqpzfx8hid9zz3twmw33f1m
X-Rspamd-Queue-Id: 37AF51C0009
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1782138132-323600
X-HE-Meta: U2FsdGVkX18gfOH9jiqG2JcwG90Wo54GXqZlTVrB7KVVFsSp1BwCC9Y5P6LPPXciKAZc4cZgwLIqG7SB81jeusuw4BhosMBv6U3OodPEPy+LYpsiiku7Pkt+Py9cqJu/2CASlyrEa/+IYaTxbAUT/as/xdsvuvT4iIrPGwLQ7mGV5opqVtCZ8k/6hmh3x6667nBdCCbQLNfbs/gkAMabNWYpYQ2YqiHqvd7RKSuqeTrx5gpv+v6LSDRZ6J3v4JJVOKKY2IHYC4qepjcSpaC0deIRYVEC2bo+CLbKc3fkCW94VzBog6FtQZRhbQ0ndXhLmALNBdg6Lsq5PEMadzzmco+BGM5+ke/3n1QHmenj2KJCq5JUw+ZfqSz/dsf1cnI/o8VeGTK51H4Kbxd5baeAqYtl9KB8svQXJYrhPDQqzFIvKFGf/vP29VQ7gVevPMGtmJF8GoQMVxagofqHiIZFTiLCdHpwcU4MQgsoFS2r26E8zltfHAmDueFDjaFXYxhiD8X03l7bOnvapaEe2+lRMFPV3KqM5lZEpgnnvToWMx5H2yCFksi5B0FNPyUooe5beKqtJXGX9snsX7ILbNQeg3EyNUbPjoTRxXoJ3o4/6nPGe/Z7NZCnnGNnZUgli2lmNDizuvtTLACkYebMIcjS1gijb6J1nE4FSYpVtd3H4hQrLvH7K/e0E6+OC+1GRDSXbu/1OUqSv4wp7qyZFHT7l5NVCc2tMaMk0s2vhdwkdt7wqisWCznKjBQXm0I6JzfBJpLjEljY5K9/jiZ9HAAn8lHM52gIfMbYiCrbDgq3nrn6W3JsHMahWRhLtGtnaYA6H/a18KsVL0tINVxceuoLsf1qkhs5ex508u337EFl5DCE68uH23Ua/joySqSoM351TQw6dcZSZPXKLeWABr5ozYhZindOQtFKc/IJy3AYRZ05Szfa1AI9osijEN6oTws//CO5rD6myaBjPeBXFHp
 yF9h8pdM
 WPpq0135t9bkeMF0iGwLBZ9kpM3ilNBmVhaTlQvtTVQMTIXLrIhxDSdWShpZVN5ACxUZN8YRQZxWPNig9lAcM3e4IyNuvrsXmRQZ8NGz+2GRh5IjbE/QUgHUoM3giRIS5Ca/fhcCemn9Hj3u2xprgfcM4JhJMrKAv0M57spkuHOckyCf9fvgrDrD26w0M/6GiC8VYnwwEhQuMNpC7cNgIkj/CiQT+P4u5qdQguZfY2hgFGumfvu4kRJUwUkeJ97WxPkPJiZayyYxceCEiHtilxP/5lA==
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
index 560e1aca5ee22..5b5375b035149 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3727,46 +3727,6 @@ int damon_set_region_system_rams_default(struct damon_target *t,
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

