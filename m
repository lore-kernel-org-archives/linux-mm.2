Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5CC63CCF9E3
	for <linux-mm@archiver.kernel.org>; Wed, 12 Nov 2025 15:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93B018E001B; Wed, 12 Nov 2025 10:42:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C3408E0002; Wed, 12 Nov 2025 10:42:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78B7C8E001B; Wed, 12 Nov 2025 10:42:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5B86B8E0002
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 10:42:44 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22DD489686
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:44 +0000 (UTC)
X-FDA: 84102372648.12.FE0B57E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 67CE7100004
	for <linux-mm@kvack.org>; Wed, 12 Nov 2025 15:42:42 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eKPHCnkr;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762962162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CiLupuITQJMKfhrY2VBbU+LjeIaNGwRxmjcG9HRFSjE=;
	b=dfkhO3+IOINKj2fWcHNddtQOfYVsLi5IGlozM8ZocluPidXlOsQcKPOgyzu5nhFcUU51pE
	qiOb1kxs5BWQPklPiVElpPnLLZTXa2l340hrhfGEqps6DwSX1o+Y/CfrJvoWTaVKr8lCVc
	vDDy9rHPA+SR6/86wuHaZGEj0sO+Z4o=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762962162; a=rsa-sha256;
	cv=none;
	b=5MInpX5UXZYiN2ML9+7usqBMTNJIDx9anWfT3tgqWlf99SpuseE2AQOE7PKigt+jR4rsiA
	9GtRcANjuzQYtx5nIkpJ3SMGltORgcC47HUWaaEKyYo/JmSc7Y7C5XeBAbs1+yWfH5gSBN
	MpCh5/z6GmKo53tC+QdMbWkrao9PJFo=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eKPHCnkr;
	spf=pass (imf14.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9E04B442AE;
	Wed, 12 Nov 2025 15:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04A8AC113D0;
	Wed, 12 Nov 2025 15:42:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1762962161;
	bh=+nAXiRSD3au0hre7wXKW+GzTCyBQWmgweSl5Hvkt0UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eKPHCnkr5xrhSxNOU3m625LuzkuCWOODKU1mxNA8UPfpVMV0HL4sjQoCKeTF7uCVz
	 72NUEswHEoG3hW6Z0dSp+AxdHBU7UPvYieZd57XItZIn0JaeTW5f4SmNLNX5+AomQe
	 2Pe7ETYWYPjTp+bCrBZPGCRuisiFDj+7B9XyHbwsiZu9XFlSVWzebW5aZHzhyVoE0s
	 UI+waiZR83g9weR6KegWdRkRc8dLl13dbAGkGHRNb+hnfOYEsqZJknnJc4wpoLUU3+
	 d+YU1ES+v9SaY8pH9XS8/JehwifOHZDttMieLdb81GXmKQtKmGysVI20TIj1Aq9iaG
	 hrHb2gI2ctpkA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	Brendan Higgins <brendan.higgins@linux.dev>,
	David Gow <davidgow@google.com>,
	damon@lists.linux.dev,
	kunit-dev@googlegroups.com,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 6/9] mm/damon/tests/core-kunit: remove DAMON_MIN_REGION redefinition
Date: Wed, 12 Nov 2025 07:41:09 -0800
Message-ID: <20251112154114.66053-7-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251112154114.66053-1-sj@kernel.org>
References: <20251112154114.66053-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: wtbtyhdyz7nkpbfa5woou4fkwk61mtkt
X-Rspam-User: 
X-Rspamd-Queue-Id: 67CE7100004
X-Rspamd-Server: rspam01
X-HE-Tag: 1762962162-269114
X-HE-Meta: U2FsdGVkX1/nP7QZ77VLcZ7/SzEXrk5IWkrdQhkrJxzy+Hm5rhtd31NtrIzFYQaWd3BetzuMBIGJL9HSt86AMibMhQMjr6IVoVySE8w/zjc8TQvHt+26LgOvXJLTi2O9BuFDn8BtTgi38iRtlydjj8PVGY4pCVoL6+jm9WYCKmyWmc036VCUHEGyLr9EYA3HELpVwoWTX84+bXGawitUeTUA9+rEy/l+PBIwnGTa7Zn8r3hAxc6iU+VOKmzZTsIPbXrV/x7CJWmMZ/lIa1ppP+Pq3dv7guAYTYMNAnFkEavz9KIM9SVgSyuIVqQ7QRJgjxKoy2gqTgVtz5Hr+ER8gj23m3f3R9QsAFrxyTPpitjTMAq6u7gPtrklwgd5gx1dQsIbqI5T+ZFV/7GI+8Hf+ZiFZfBF+paUuOf98oLG5hg0ALdMRZSnJD32lfVjpFiATcU5xphgGucbP1eWSP5Cff8XW1eBYjhfAcfNyPBm518lID9Br4uwrj4Kzqvqz8+mlEIWLnnKJwWQ/mOqcPTZMbafMExHNhxpxI/r8bG0g1GDUD5mF0kQ50T6k0AaFFEedq2h77HXfx7nqimgievvTD2lP14lFXP6PN23DYu78pZEmf1ThulvrSXJcWm2ulYL5gkEy5MXjV8Hr7AexUwu47weljZMgh9uB9qX+EzM5TOj3tyCadbcdAKFCHVZ3OzU8IFQFs/mr/xKHWC071w3t9W3a48wMTcJJ3+NtZQkW+R8pdfJ3Os1UzZ17/lWXDcvs1g1a7TaRyCJHtj+QHcwV+ejBGo8V+3+1Vdj5GdfESRoRhbt3yoBFzphUtlR6qzN64QTL+qBZK0ZvSb6yOLEFtF2zN8JKKGYymLR2UqsRyxamv8EMfp0F5BHYa/wWOaYUhL2fayVauw/5I0xEiItS6k7ketmV+P2+8CbsDRwnxClyyFgb4EiUVIgTTs2zhaoRpB/MSgyRYEAhvPAD1C
 g2ct9YmZ
 u8aPiadFsqepUGsuU1udTvcVVxjWEkSCC3awxYJvQNN2HFwP93m2DeKZzj85dNY1qw97YrXJdXuVsp9TWLIW2Pl/gDfwEwa9QvYydald9xHx/TMfGX2D4AMilcgTyVK5bQ0DV9yGA7RvmDL1Hi/SLOlzjW6LzYmOyWkQD9xB0aqGoJzONh9v1yyIyYHdDLgtJlJ3/8WbeMxlT2gZXmDCS5Ddp+lhlkpp4439RPD2sMq0sW66QrgwtfRLr9W/qvyy4e3YlnGmEFns9+oJ64h+XTTt9CQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A few DAMON core functions including damon_set_regions() were hard-coded
to use DAMON_MIN_REGION as their regions management granularity.  For
simple and human-readable unit tests' expectations, DAMON core layer
kunit test re-defines DAMON_MIN_REGION to '1'.

A previous patch series [1] has removed the hard-coded part but kept the
redefinition and updated related function calls to explicitly use
DAMON_MIN_REGION.  Remove the unnecessary redefinition and update
relevant function calls to pass literals (number '1') instead of the
DAMON_MIN_REGION.

[1] https://lore.kernel.org/20250828171242.59810-1-sj@kernel.org

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/core.c             |  5 ----
 mm/damon/tests/core-kunit.h | 55 ++++++++++++++++++-------------------
 2 files changed, 26 insertions(+), 34 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index aedb315b075a..f9fc0375890a 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -20,11 +20,6 @@
 #define CREATE_TRACE_POINTS
 #include <trace/events/damon.h>
 
-#ifdef CONFIG_DAMON_KUNIT_TEST
-#undef DAMON_MIN_REGION
-#define DAMON_MIN_REGION 1
-#endif
-
 static DEFINE_MUTEX(damon_lock);
 static int nr_running_ctxs;
 static bool running_exclusive_ctxs;
diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 4380d0312d24..a1eff023e928 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -279,7 +279,7 @@ static void damon_test_split_regions_of(struct kunit *test)
 		kunit_skip(test, "region alloc fail");
 	}
 	damon_add_region(r, t);
-	damon_split_regions_of(t, 2, DAMON_MIN_REGION);
+	damon_split_regions_of(t, 2, 1);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 2u);
 	damon_free_target(t);
 
@@ -292,7 +292,7 @@ static void damon_test_split_regions_of(struct kunit *test)
 		kunit_skip(test, "second region alloc fail");
 	}
 	damon_add_region(r, t);
-	damon_split_regions_of(t, 4, DAMON_MIN_REGION);
+	damon_split_regions_of(t, 4, 1);
 	KUNIT_EXPECT_LE(test, damon_nr_regions(t), 4u);
 	damon_free_target(t);
 }
@@ -373,7 +373,7 @@ static void damon_test_set_regions(struct kunit *test)
 
 	damon_add_region(r1, t);
 	damon_add_region(r2, t);
-	damon_set_regions(t, &range, 1, DAMON_MIN_REGION);
+	damon_set_regions(t, &range, 1, 1);
 
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 3);
 	damon_for_each_region(r, t) {
@@ -1037,15 +1037,14 @@ static void damos_test_filter_out(struct kunit *test)
 	f = damos_new_filter(DAMOS_FILTER_TYPE_ADDR, true, false);
 	if (!f)
 		kunit_skip(test, "filter alloc fail");
-	f->addr_range = (struct damon_addr_range){
-		.start = DAMON_MIN_REGION * 2, .end = DAMON_MIN_REGION * 6};
+	f->addr_range = (struct damon_addr_range){.start = 2, .end = 6};
 
 	t = damon_new_target();
 	if (!t) {
 		damos_destroy_filter(f);
 		kunit_skip(test, "target alloc fail");
 	}
-	r = damon_new_region(DAMON_MIN_REGION * 3, DAMON_MIN_REGION * 5);
+	r = damon_new_region(3, 5);
 	if (!r) {
 		damos_destroy_filter(f);
 		damon_free_target(t);
@@ -1054,50 +1053,48 @@ static void damos_test_filter_out(struct kunit *test)
 	damon_add_region(r, t);
 
 	/* region in the range */
-	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+	KUNIT_EXPECT_TRUE(test, damos_filter_match(NULL, t, r, f, 1));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region before the range */
-	r->ar.start = DAMON_MIN_REGION * 1;
-	r->ar.end = DAMON_MIN_REGION * 2;
+	r->ar.start = 1;
+	r->ar.end = 2;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, 1));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region after the range */
-	r->ar.start = DAMON_MIN_REGION * 6;
-	r->ar.end = DAMON_MIN_REGION * 8;
+	r->ar.start = 6;
+	r->ar.end = 8;
 	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, 1));
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1);
 
 	/* region started before the range */
-	r->ar.start = DAMON_MIN_REGION * 1;
-	r->ar.end = DAMON_MIN_REGION * 4;
-	KUNIT_EXPECT_FALSE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+	r->ar.start = 1;
+	r->ar.end = 4;
+	KUNIT_EXPECT_FALSE(test, damos_filter_match(NULL, t, r, f, 1));
 	/* filter should have split the region */
-	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 1);
-	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 2);
+	KUNIT_EXPECT_EQ(test, r->ar.start, 1);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 2);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
 	r2 = damon_next_region(r);
-	KUNIT_EXPECT_EQ(test, r2->ar.start, DAMON_MIN_REGION * 2);
-	KUNIT_EXPECT_EQ(test, r2->ar.end, DAMON_MIN_REGION * 4);
+	KUNIT_EXPECT_EQ(test, r2->ar.start, 2);
+	KUNIT_EXPECT_EQ(test, r2->ar.end, 4);
 	damon_destroy_region(r2, t);
 
 	/* region started in the range */
-	r->ar.start = DAMON_MIN_REGION * 2;
-	r->ar.end = DAMON_MIN_REGION * 8;
+	r->ar.start = 2;
+	r->ar.end = 8;
 	KUNIT_EXPECT_TRUE(test,
-			damos_filter_match(NULL, t, r, f, DAMON_MIN_REGION));
+			damos_filter_match(NULL, t, r, f, 1));
 	/* filter should have split the region */
-	KUNIT_EXPECT_EQ(test, r->ar.start, DAMON_MIN_REGION * 2);
-	KUNIT_EXPECT_EQ(test, r->ar.end, DAMON_MIN_REGION * 6);
+	KUNIT_EXPECT_EQ(test, r->ar.start, 2);
+	KUNIT_EXPECT_EQ(test, r->ar.end, 6);
 	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 2);
 	r2 = damon_next_region(r);
-	KUNIT_EXPECT_EQ(test, r2->ar.start, DAMON_MIN_REGION * 6);
-	KUNIT_EXPECT_EQ(test, r2->ar.end, DAMON_MIN_REGION * 8);
+	KUNIT_EXPECT_EQ(test, r2->ar.start, 6);
+	KUNIT_EXPECT_EQ(test, r2->ar.end, 8);
 	damon_destroy_region(r2, t);
 
 	damon_free_target(t);
-- 
2.47.3

