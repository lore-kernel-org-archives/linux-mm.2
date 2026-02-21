Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D6A2C61DE3
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 18:04:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75F96B008C; Sat, 21 Feb 2026 13:03:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A315F6B0092; Sat, 21 Feb 2026 13:03:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797E26B0093; Sat, 21 Feb 2026 13:03:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5F7C26B008C
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 13:03:55 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 25459C1BFC
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 18:03:55 +0000 (UTC)
X-FDA: 84469237230.13.2A78A99
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6EA1520003
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 18:03:53 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eQ+JXmDf;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771697033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Am6TeYowM0pmbKXfm+LsyOSt8lxz98RGQ0YAOKcwFAY=;
	b=QOeqHtIjYIDkZTrWGIF4nvIaKWc9v8tuC4Hk7/6dDfe++/BN1C48VKzCpalwcho3nXybhd
	buqU3DkS5wLAWPFFoNq9cfUv3xNw59nO/dXuFSD7o3sui53f2P5Ig4sCdDBfxPkZiEExtS
	TAAv2RnwoUzkqj3ftRcoEAzRt9vq6Dg=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eQ+JXmDf;
	spf=pass (imf03.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771697033; a=rsa-sha256;
	cv=none;
	b=bzFmAMfuV/u43TOa/XiHod6cdeKRISeurMHwH/bucVw9K8bD8KaHb13yICDiKMOR23NaFg
	R4ewCMfbea9ZmUbaz0vVjhUTKllcli7TaYREzr1WGFvv1BLjl3j4ayCw5c4GBzm+zbvWlE
	LKAKd+GWIcgwIhC2lmA6gTsIugpmH+E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 8A92444556;
	Sat, 21 Feb 2026 18:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40F54C2BCB1;
	Sat, 21 Feb 2026 18:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771697032;
	bh=bCw9hVCbQXONIXZgAbBvfEk2u6XzT2XAiGuqMrqAhNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eQ+JXmDf6pJAEXnAMg/rBeh4QMAJ96ToBwrJSC3xu3M04NBGmadJ927JiIw4nGUjO
	 0OH2PQ/k+48lrdmKTXz1acmV6OU8VYOebosJba8HVzXawMOeqPQlkiPUQDTfsffSOG
	 X86AgXLcw2by4bsWmjLG7lUhq1r+hfIUXUmQc4mH9e8i03S0268tw6mcLcoLjn1C8h
	 oaxeiYMeKEiiCULy1/ml8nETzJH9kCpNrIs0xRQcxVHT72V4GQV1cK8RFCykqmlZxS
	 8Qa9pHyYYwB3DOE41AxRiVrtX6nPqEZwrEf40RvAO2ZDg/agHUdUyV4kDEjJSLKzDU
	 mX0aaykirReog==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 3/3] mm/damon/test/core-kunit: add damon_apply_min_nr_regions() test
Date: Sat, 21 Feb 2026 10:03:40 -0800
Message-ID: <20260221180341.10313-4-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221180341.10313-1-sj@kernel.org>
References: <20260221180341.10313-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6EA1520003
X-Stat-Signature: nbc9hxfeb198uxztnku3meyazg3apn66
X-Rspam-User: 
X-HE-Tag: 1771697033-681203
X-HE-Meta: U2FsdGVkX18qHLNX4sx1HzUQuMymBlw/pp93v7jh0i71C95ypLJ5nI9jX6NmzsPvxlbMzqBCUYuk3Ez/pOKNXyCjDTmCMbCGdhVIVX8fdlZEb9Lyi6EoTHfNGKHIbeDWbUcGZljyMgrowLhIO5FgWK9qOlk16fFw6UxnsIRA4/B9LVW8og8aVsULeIB+G4khK3+F0fC9RpIpUgTRrSQETH7qiHh9Pw5rOr8S2qrYktQQaLpZLZ2aTgQFEw0i1JaJRuZZrZf1VRA6PJEm67pjV7aiNGDprLJhJLHO7apqzfbroVIJq5W9oNhstNFj9xy4hZlHBJQuJLOfdR1C/gaeUFgcOEugKpMsfYzA4cRLrcQC5V213pFylx5V49RcCDw76Rs3jgI7U6tiIsxxAHoEAMIySksqC/TyBWdB3aAmK+h0534YdMi5IaBCUSsCIMzt1ebun+U+RahSp7B54a2L+b1PDSkcXRxJu0IDddtp9n4d9i2ctufR7vc69ACSBgHMno5zgVZ9eEemAqCsRtGY1Mm6d19amKGkLL8A9EBiuI5KOT1Q0QXif7jP4Bu+V4NjYlvOdMHEAFeb1N5vGpyezAkMy6PdTGXdrLlN06Ztr8f4lgSuH4Itd91dvf5AkC1bPElpcvMfnvH4yJrwecSMV79JbB6YS8xUEwdJ+RRU830kD6hB0JPwN9fznzww8cJ4d7DXUzy8f3xnW8ZElecFoleE/8+AAwgTR6ms/l6I1eP969BWLb6HTu3hXGpuNPo2qxW47/1SbzbvAzIUrRju0SS7S8Tuok4bHFLEFFkAczjywHynUjweCbLPALowxyZ5gekjRiceWqJUHS85Wj8+UsEkhTiN4Ub8Txdg1fp7tBSaMtGaWedobstCwVP7bs2p0r3cYMgjPOwexOX/RN24O+fiwF1tnZnOD2U46YCMqTzjY052nTDqbBKqY+UDTF3OnnZ8U0/WYMCVsjtOpZ6
 YRvKWe1n
 riJKXf+bYJKw/J9Y88cJvUoDxaRsXum+hQi+Kynqo2UCVnZHsJ4KZNrNEKm/go8b4uw46r+dTB16ypl0hyrkO4F06+8ibiNu9/4bQRAmnaEt3nSoB7gZw39VsWOxRIIW4v3A87bNzu3Kr+dmNJC0/7rLvhsVSbtglxF00HPFsMbA3/wTplDrf2M3VqOULAs1e/0pGPoNT6mD9FkrDAAmrzXxw7vJZ6rqyB0Axlm584Iq6tQ0nWbiF9tKZMA52J3XGpWny0LkWJa7aiebQUr2D/EPIhISgKSuRyZkdd5ebSWyR572DFpu4KrCkgyAm4ZEwG59NsWLCLSs0YChaspHYujKPdbcU93MnabJd
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kunit test for the functionality of damon_apply_min_nr_regions().

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 52 +++++++++++++++++++++++++++++++++++++
 1 file changed, 52 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 92ea25e2dc9e3..4c19ccac5a2ee 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -1241,6 +1241,57 @@ static void damon_test_set_filters_default_reject(struct kunit *test)
 	damos_free_filter(target_filter);
 }
 
+static void damon_test_apply_min_nr_regions_for(struct kunit *test,
+		unsigned long sz_regions, unsigned long min_region_sz,
+		unsigned long min_nr_regions,
+		unsigned long max_region_sz_expect,
+		unsigned long nr_regions_expect)
+{
+	struct damon_ctx *ctx;
+	struct damon_target *t;
+	struct damon_region *r;
+	unsigned long max_region_size;
+
+	ctx = damon_new_ctx();
+	if (!ctx)
+		kunit_skip(test, "ctx alloc fail\n");
+	t = damon_new_target();
+	if (!t) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "target alloc fail\n");
+	}
+	damon_add_target(ctx, t);
+	r = damon_new_region(0, sz_regions);
+	if (!r) {
+		damon_destroy_ctx(ctx);
+		kunit_skip(test, "region alloc fail\n");
+	}
+	damon_add_region(r, t);
+
+	ctx->min_region_sz = min_region_sz;
+	ctx->attrs.min_nr_regions = min_nr_regions;
+	max_region_size = damon_apply_min_nr_regions(ctx);
+
+	KUNIT_EXPECT_EQ(test, max_region_size, max_region_sz_expect);
+	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_regions_expect);
+
+	damon_destroy_ctx(ctx);
+}
+
+static void damon_test_apply_min_nr_regions(struct kunit *test)
+{
+	/* common, expected setup */
+	damon_test_apply_min_nr_regions_for(test, 10, 1, 10, 1, 10);
+	/* no zero size limit */
+	damon_test_apply_min_nr_regions_for(test, 10, 1, 15, 1, 10);
+	/* max size should be aligned by min_region_sz */
+	damon_test_apply_min_nr_regions_for(test, 10, 2, 2, 6, 2);
+	/*
+	 * when min_nr_regions and min_region_sz conflicts, min_region_sz wins.
+	 */
+	damon_test_apply_min_nr_regions_for(test, 10, 2, 10, 2, 5);
+}
+
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_target),
 	KUNIT_CASE(damon_test_regions),
@@ -1267,6 +1318,7 @@ static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damos_test_filter_out),
 	KUNIT_CASE(damon_test_feed_loop_next_input),
 	KUNIT_CASE(damon_test_set_filters_default_reject),
+	KUNIT_CASE(damon_test_apply_min_nr_regions),
 	{},
 };
 
-- 
2.47.3

