Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08DECC54F55
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 03:38:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E62CF6B0098; Tue, 28 Jul 2026 23:38:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E13B36B0096; Tue, 28 Jul 2026 23:38:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A9E6B009B; Tue, 28 Jul 2026 23:38:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A80E36B0096
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 23:38:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 400B3140546
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:04 +0000 (UTC)
X-FDA: 85040405688.12.0510EC4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9E97340003
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 03:38:02 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ndhbkibA;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785296282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q+iR0WBRty/9e25KNHH96FJIzOaYrwS/QZZkMmGIIoI=;
	b=73I69c838ZemnqvKFQXKSPW+0REO7L1+gKSr+XpvlUVbW+V4Wh/Nl5IouuGvQc1o4HIuWi
	oVaVHs85T90oXU4t33V0Oc3RwLZnU2oC6D7HA38rU2ZubHkfr0dCJrtscuKUkBzthFLqOT
	iqpmfnSaKqmcN5DKjLM1426gz8z8S4U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785296282;
	b=uFq+YRq30hGQKcm1sBA/e3bxgAvamxSs9nTNqB5Nm8uQYRLwUTJ6UOGhPTz+4tJdEVc7Gj
	XmZtAElKavuJw0d64baL+WRVqJU6pfCkrpT4Yq7hDsN3Z/xs+/6m9OY1hHNQN/GRshF7i6
	oeJuZrdi0RF9TXJRhUsUcyalhBnzOOI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ndhbkibA;
	spf=pass (imf27.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 9F78D40412;
	Wed, 29 Jul 2026 03:38:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 394A31F00AC4;
	Wed, 29 Jul 2026 03:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785296281;
	bh=Q+iR0WBRty/9e25KNHH96FJIzOaYrwS/QZZkMmGIIoI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ndhbkibA2/s9ur+d/cyK5k0DFTmY8D405eQEYf//yQTvR/lfepmnQU8ahFcYI2Raq
	 NX8gie8bPbGAWyHcm9VWJdVihzcqG56lZJGNZaqtYcG4evevY4XXY5rZ79RyzaGj7g
	 q3Bz6bhC1D97H7+7xsbNeLdsZSAWPsDIfmjQNAjUPx8nVKa/jDQ34VHYIUglTr7NjJ
	 zPS2RjT/d5WYMaGAfa3Cd2TqCLm7fWBSm2dU2vR6ljnlWn2L77sSbjhADKNXtdajZC
	 oVNlaeJYoMjyaYckquNu8D3K60nCRMNEHTDTlfwUgUJdAyjtLWkuhcpW3mLJ/6eLLZ
	 0t4dwikdeI5XA==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@davidgow.net>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 04/10] mm/damon/tests/core-kunit: extend set_regions() test for error case
Date: Tue, 28 Jul 2026 20:37:44 -0700
Message-ID: <20260729033751.131213-5-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260729033751.131213-1-sj@kernel.org>
References: <20260729033751.131213-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 9E97340003
X-Stat-Signature: h1y5zgruuxxgm5qj8mds6sg9d5m6bnm9
X-Rspam-User: 
X-HE-Tag: 1785296282-773437
X-HE-Meta: U2FsdGVkX1/M1pBD4NRj5LYC9b8RKd8LH79LD+YR3nZN5W1mDEk/foRxSQ+t0AbL2EX8gG+5Pr7GdFcSIJVPvPOCG8uPJdvCMLtfIWKiC+xCveDs0sIOUTKFjiQ0TcYN1MBERk202BUfhNqcqWc1iZBbxZ7w1tIWq/S1a3EO35PmVdOn4Cx918hzp2lUTSycv/MPzPpqGeQnvY3oXpcQszt8LKxElYf3WutGQNg5vhh6RWzziruiK7j6ogAvD12JzoDC861NYjdEY9SXK1MQbe8zUWy4fGxFTPElyUt4Z5m0YaNjxCEYPw+T2bGJugMcS/IGBOVtSP1zHA9b197vvrKbIC0V9lJoUa1gN7t7BmLIl7+D1B9JK+DKICB9gc8rAgPPIQQpQPzOaKRywwf2RV0XOfY1NMONEt1ozj2PSqZDgcQtq8UL3SldQiMwwr/Vb5QZ02qkoVvFDVhwdvwW7THA6cr+oqoox2ryZyjTHgEt3XbHcKeSunv5Xapr3pdSUHYqzxuErfnaMIR7KyCsUBCAHpPtkWNOB/Ab0DKaMSdbGB29I02dl7S+8EH3/31+YmZJLMYIlP8J8hBQS6en1OqftdFZ5TH3ypIqDLI9NaGWEjxGLEDiX/21fY2U0XFTULdXSPOrOgC1KvuWgF8MIluqu2rgD2uhRxkusMoPDpNqVSN0OaDXYjbJmnEmAoUe+uALxRTWaevVvyWZSLYdhQeOu7/cSqCQm3oyBooXQO2ipk1flRp5XXSZu/+ENmlYfwmrN8TkfYVdWwzd+SCN3vw3z7WwzehabQTcTttTTWNDAcOtOEBLvFgySy2Sg059zLdDK4NN4I/fdKsvmL3NChQBan4dCqY9YXl20nwqYGT3b9d7J52+7tk3P7m3mkQGYGZCtAucaSFOCt6tAYEqqLmc6GGqateM3LpbkK0CFNbgcwvusALCVsg89htXO05kJYO94IYgZ+/T/f77FOZ
 UFCpyDLw
 7B9A1E0UeD9LKTTQmKZKu+wNLZOnwVA/HWkTmN0T44lVDu/wrGa9hUAiGqkPeHHPekMdPnnJdMvcP/A44Ot233icCCDrfI+JfXcj/SwYzc1D+VG8o6IULtNfQgH73oslnUCF4d3HVVm5fsbTvo6yQ+Mscr5jzJwGJwcIteLdWJzHuzfqQR/47VeAElpFBQn/J6iNagzjhf2bfhgDbBv2tZ8FVU2AGnAjlV8NONsRzHP9/2IgOk22hnm0LAuKSAeZvCjqGuXDTD3zBOxUegIoV4vk+Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damon_test_set_regions_for() is designed to test only success-expected
damon_set_regions() calls.  Extend it to cover error-expected calls,
too.

Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/tests/core-kunit.h | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4a536d41cdb2d..befc1196d6d60 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -463,11 +463,12 @@ static void damon_test_set_regions_for(struct kunit *test,
 		struct damon_addr_range *old_ranges, int sz_old_ranges,
 		struct damon_addr_range *new_ranges, int sz_new_ranges,
 		unsigned long min_region_sz,
-		struct damon_addr_range *expect_ranges, int sz_expect_ranges)
+		struct damon_addr_range *expect_ranges, int sz_expect_ranges,
+		int expect_err)
 {
 	struct damon_target *t;
 	struct damon_region *r;
-	int i;
+	int i, err;
 
 	t = damon_new_target();
 	if (!t)
@@ -481,7 +482,8 @@ static void damon_test_set_regions_for(struct kunit *test,
 		damon_add_region(r, t);
 	}
 
-	damon_set_regions(t, new_ranges, sz_new_ranges, min_region_sz);
+	err = damon_set_regions(t, new_ranges, sz_new_ranges, min_region_sz);
+	KUNIT_EXPECT_EQ(test, err, expect_err);
 
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), sz_expect_ranges);
 	if (damon_nr_regions(t) != sz_expect_ranges) {
@@ -510,7 +512,7 @@ static void damon_test_set_regions(struct kunit *test)
 			(struct damon_addr_range[]){
 			{.start = 5, .end = 15},
 			{.start = 15, .end = 25},
-			}, 2);
+			}, 2, 0);
 	/* Un-intersecting regions should be removed. */
 	damon_test_set_regions_for(test,
 			(struct damon_addr_range[]){
@@ -523,7 +525,7 @@ static void damon_test_set_regions(struct kunit *test)
 			1,
 			(struct damon_addr_range[]){
 			{.start = 18, .end = 23},
-			}, 1);
+			}, 1, 0);
 	/*
 	 * Holes should be filled up with new regions.
 	 *
@@ -544,7 +546,7 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 8, .end = 16},
 			{.start = 16, .end = 24},
 			{.start = 24, .end = 28},
-			}, 3);
+			}, 3, 0);
 	/*
 	 * New regions should be able to be appended.
 	 *
@@ -566,7 +568,7 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 0, .end = 4},
 			{.start = 4, .end = 15},
 			{.start = 25, .end = 40},
-			}, 3);
+			}, 3, 0);
 	/*
 	 * New regions should be able to be inserted.
 	 *
@@ -589,7 +591,7 @@ static void damon_test_set_regions(struct kunit *test)
 			{.start = 0, .end = 15},
 			{.start = 25, .end = 40},
 			{.start = 44, .end = 50},
-			}, 3);
+			}, 3, 0);
 }
 
 static void damon_test_update_monitoring_result(struct kunit *test)
-- 
2.47.3

