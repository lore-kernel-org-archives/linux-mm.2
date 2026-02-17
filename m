Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D6866E83847
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 00:04:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7EE1A6B0095; Mon, 16 Feb 2026 19:04:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EF146B0092; Mon, 16 Feb 2026 19:04:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AACD6B0089; Mon, 16 Feb 2026 19:04:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19CC16B0092
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 19:04:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6F7B05D093
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:04:18 +0000 (UTC)
X-FDA: 84452001396.22.8256F2C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id DD3B2120013
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 00:04:16 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S6xTn4/Z";
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771286657;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBHIGIDsGfNA7f4EoJ0Itb6dG96pNiYz8OF0OEfYsYQ=;
	b=wEVfY0Qvb2U3L6J3/vUONJUOayQ8XRKE22XOj5KAIUnW149mKzIqoQcT4P/Ur95sL8+Odp
	sK1ubafQPbz6j998pH7OjVThwBU/juFsa29n3YyRFxpDT0JDc5yFABjOCCvWxiiEqqMgRG
	r+dbEC1ayST39kGMxi4Vjd4VQAzKx3I=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S6xTn4/Z";
	spf=pass (imf29.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771286657; a=rsa-sha256;
	cv=none;
	b=3/ETGOtxRu2lHVeLx0sw8cVpUTzfCbvG31oNg0QHvidRlzIJmtuNybiNxIKStAhGFtt3jQ
	YaSmv+68r5e5sXKOwlCP4JnuSXqx09Iujs+Uvm+naCmpnH+ll88scZISBTv1PR4jnMlD5F
	72cL5W+0TBQ9IRUqEeJ7CTCoZ7k2TKo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F2B1F44514;
	Tue, 17 Feb 2026 00:04:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2D8BC2BC9E;
	Tue, 17 Feb 2026 00:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771286655;
	bh=O5C60gzaAjye3NBs36/CbgGUC2VmIz0qx2BwHipnsFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S6xTn4/ZAOgV97D197xEQgfJDVMFHtAxGheucrTDdQeJ5ih34kaNezsFovtwsGKFz
	 xHknEHMphZtkYEJUR6SUCxuXrAZ563OxCzOvkVaH97RkeNj/YNrpwquv8CyzS/KtEO
	 d9UYK+mHDLPG7izHUsrgmDr1veyudyqNVa1Qt62hiiWmfb8XbBCMInTkzG4QXmBEcw
	 k+tpr+n+Ml2FUQvoxiFupRlA9ITIJ8q7yRdAUbRNJIyY3oUkJY4dY6q6t4QeMpGkmk
	 u8IiL8YpUMmMhUvxRDcEOhh2XQUFj/rYhjXOg3o1k4ADHv6TJ/6SzvtWCaC58r6WSs
	 b67kAka0jx+HA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 2/3] mm/damon/vaddr: do not split regions for min_nr_regions
Date: Mon, 16 Feb 2026 16:03:57 -0800
Message-ID: <20260217000400.69056-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260217000400.69056-1-sj@kernel.org>
References: <20260217000400.69056-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: DD3B2120013
X-Stat-Signature: eygiod7cdgp9dbmj4qqteytp8w69swfg
X-Rspam-User: 
X-HE-Tag: 1771286656-951654
X-HE-Meta: U2FsdGVkX19a/pWA0R7IamdyhBxveC+hyV04g6i8iGFfD7uWxX6Zn2DUsmknQrPHqw5Cy0FU1eyx9jeK34wN7eAVzq4bP6TwcKl/6Nvikqi2sklCdgalgTpPUovw1f78XjBEI0QggrnKO4H+9wUJnynCjnxl0VYQesg7ilagwkiajZEoTL/iN48Ua0IkotSvSB/VlRgOoeCf+5PxBFR2H7GPVxZJyN6yT53Hkl1RS6Pq97YApOUumUpKVCJJ3y6zKTVyNcSXGS1yMqJjdjL1P219MYkIZWqX2FkTQ5D+6GD9fCSYeDQCFtIHMHUKaUk7mx67NqcSF/ZYSR1FCJYTQ1HJFX0xABNdfOy9/VtJyTZdU/OlQD/KvP9wOzl8R9rd2AxuKWTQ6tsA/PM8UBEQd2+ulNWaptOc+p6C5pHTcpEoMSRD/hZkJEh4gmpQvRdUJnXRDTZaAbGEXuoPDVAwxoGhu7oIdKr1uuXcgub0Ir/qrPjGcCB8kHg0F8m/9OOygdWp0zr4/PUwwFK6H6pg1h9nywdYyomlwCD8zjhHgReQ8kjanjGxHkAmVcQ3f7EnWmbYQ67cnl0d5C0+f3+vppO93zzsWjzvxQNHsdJKslYWfIEhJb2tdrddc5LG/Thk5TwFpvFPgKzSLNW5ypvRwzzlC0pfbKPOnwLdxvgTc3z15sAiWEBTAfNzQHrmODrEqKde2wBFkAgqhp5tE9syOn/zdIJos2i+V87DAit6w2F7gZk/tA94aUaDGMXo7IK3i05w+BRVsj2Psw5Kx+D24CaTQDoeSa45a9zFylvlGoqK1LY22lMavC3mWXw98mCyFeV5PjRoU1SxJNlQRVcRONgcwCCRJmn2J+I3ZORozX38aRLqVkcz3AIxZUAHFeHX6v3XDOmDpKde5ItnjuqLl43sFDBmNrxI7rMwyC0CaEkvF0LyQXTXKqxJRrTFxY0giq6/kXfDwF8uDhYBb6n
 0puo5NcU
 Sap8o
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The previous commit made DAMON core split regions at the beginning for
min_nr_regions.  The virtual address space operation set (vaddr) does
similar work on its own, for a case user delegates entire initial
monitoring regions setup to vaddr.  It is unnecessary now, as DAMON core
will do similar work for any case.  Remove the duplicated work in vaddr.

Also, remove a helper function that was being used only for the work,
and the test code of the helper function.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 mm/damon/tests/vaddr-kunit.h | 76 ------------------------------------
 mm/damon/vaddr.c             | 70 +--------------------------------
 2 files changed, 2 insertions(+), 144 deletions(-)

diff --git a/mm/damon/tests/vaddr-kunit.h b/mm/damon/tests/vaddr-kunit.h
index cfae870178bfd..98e734d77d517 100644
--- a/mm/damon/tests/vaddr-kunit.h
+++ b/mm/damon/tests/vaddr-kunit.h
@@ -252,88 +252,12 @@ static void damon_test_apply_three_regions4(struct kunit *test)
 			new_three_regions, expected, ARRAY_SIZE(expected));
 }
 
-static void damon_test_split_evenly_fail(struct kunit *test,
-		unsigned long start, unsigned long end, unsigned int nr_pieces)
-{
-	struct damon_target *t = damon_new_target();
-	struct damon_region *r;
-
-	if (!t)
-		kunit_skip(test, "target alloc fail");
-
-	r = damon_new_region(start, end);
-	if (!r) {
-		damon_free_target(t);
-		kunit_skip(test, "region alloc fail");
-	}
-
-	damon_add_region(r, t);
-	KUNIT_EXPECT_EQ(test,
-			damon_va_evenly_split_region(t, r, nr_pieces), -EINVAL);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), 1u);
-
-	damon_for_each_region(r, t) {
-		KUNIT_EXPECT_EQ(test, r->ar.start, start);
-		KUNIT_EXPECT_EQ(test, r->ar.end, end);
-	}
-
-	damon_free_target(t);
-}
-
-static void damon_test_split_evenly_succ(struct kunit *test,
-	unsigned long start, unsigned long end, unsigned int nr_pieces)
-{
-	struct damon_target *t = damon_new_target();
-	struct damon_region *r;
-	unsigned long expected_width = (end - start) / nr_pieces;
-	unsigned long i = 0;
-
-	if (!t)
-		kunit_skip(test, "target alloc fail");
-	r = damon_new_region(start, end);
-	if (!r) {
-		damon_free_target(t);
-		kunit_skip(test, "region alloc fail");
-	}
-	damon_add_region(r, t);
-	KUNIT_EXPECT_EQ(test,
-			damon_va_evenly_split_region(t, r, nr_pieces), 0);
-	KUNIT_EXPECT_EQ(test, damon_nr_regions(t), nr_pieces);
-
-	damon_for_each_region(r, t) {
-		if (i == nr_pieces - 1) {
-			KUNIT_EXPECT_EQ(test,
-				r->ar.start, start + i * expected_width);
-			KUNIT_EXPECT_EQ(test, r->ar.end, end);
-			break;
-		}
-		KUNIT_EXPECT_EQ(test,
-				r->ar.start, start + i++ * expected_width);
-		KUNIT_EXPECT_EQ(test, r->ar.end, start + i * expected_width);
-	}
-	damon_free_target(t);
-}
-
-static void damon_test_split_evenly(struct kunit *test)
-{
-	KUNIT_EXPECT_EQ(test, damon_va_evenly_split_region(NULL, NULL, 5),
-			-EINVAL);
-
-	damon_test_split_evenly_fail(test, 0, 100, 0);
-	damon_test_split_evenly_succ(test, 0, 100, 10);
-	damon_test_split_evenly_succ(test, 5, 59, 5);
-	damon_test_split_evenly_succ(test, 4, 6, 1);
-	damon_test_split_evenly_succ(test, 0, 3, 2);
-	damon_test_split_evenly_fail(test, 5, 6, 2);
-}
-
 static struct kunit_case damon_test_cases[] = {
 	KUNIT_CASE(damon_test_three_regions_in_vmas),
 	KUNIT_CASE(damon_test_apply_three_regions1),
 	KUNIT_CASE(damon_test_apply_three_regions2),
 	KUNIT_CASE(damon_test_apply_three_regions3),
 	KUNIT_CASE(damon_test_apply_three_regions4),
-	KUNIT_CASE(damon_test_split_evenly),
 	{},
 };
 
diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 4e3430d4191d1..400247d96eecc 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -53,52 +53,6 @@ static struct mm_struct *damon_get_mm(struct damon_target *t)
 	return mm;
 }
 
-/*
- * Functions for the initial monitoring target regions construction
- */
-
-/*
- * Size-evenly split a region into 'nr_pieces' small regions
- *
- * Returns 0 on success, or negative error code otherwise.
- */
-static int damon_va_evenly_split_region(struct damon_target *t,
-		struct damon_region *r, unsigned int nr_pieces)
-{
-	unsigned long sz_orig, sz_piece, orig_end;
-	struct damon_region *n = NULL, *next;
-	unsigned long start;
-	unsigned int i;
-
-	if (!r || !nr_pieces)
-		return -EINVAL;
-
-	if (nr_pieces == 1)
-		return 0;
-
-	orig_end = r->ar.end;
-	sz_orig = damon_sz_region(r);
-	sz_piece = ALIGN_DOWN(sz_orig / nr_pieces, DAMON_MIN_REGION_SZ);
-
-	if (!sz_piece)
-		return -EINVAL;
-
-	r->ar.end = r->ar.start + sz_piece;
-	next = damon_next_region(r);
-	for (start = r->ar.end, i = 1; i < nr_pieces; start += sz_piece, i++) {
-		n = damon_new_region(start, start + sz_piece);
-		if (!n)
-			return -ENOMEM;
-		damon_insert_region(n, r, next, t);
-		r = n;
-	}
-	/* complement last region for possible rounding error */
-	if (n)
-		n->ar.end = orig_end;
-
-	return 0;
-}
-
 static unsigned long sz_range(struct damon_addr_range *r)
 {
 	return r->end - r->start;
@@ -240,10 +194,8 @@ static void __damon_va_init_regions(struct damon_ctx *ctx,
 				     struct damon_target *t)
 {
 	struct damon_target *ti;
-	struct damon_region *r;
 	struct damon_addr_range regions[3];
-	unsigned long sz = 0, nr_pieces;
-	int i, tidx = 0;
+	int tidx = 0;
 
 	if (damon_va_three_regions(t, regions)) {
 		damon_for_each_target(ti, ctx) {
@@ -255,25 +207,7 @@ static void __damon_va_init_regions(struct damon_ctx *ctx,
 		return;
 	}
 
-	for (i = 0; i < 3; i++)
-		sz += regions[i].end - regions[i].start;
-	if (ctx->attrs.min_nr_regions)
-		sz /= ctx->attrs.min_nr_regions;
-	if (sz < DAMON_MIN_REGION_SZ)
-		sz = DAMON_MIN_REGION_SZ;
-
-	/* Set the initial three regions of the target */
-	for (i = 0; i < 3; i++) {
-		r = damon_new_region(regions[i].start, regions[i].end);
-		if (!r) {
-			pr_err("%d'th init region creation failed\n", i);
-			return;
-		}
-		damon_add_region(r, t);
-
-		nr_pieces = (regions[i].end - regions[i].start) / sz;
-		damon_va_evenly_split_region(t, r, nr_pieces);
-	}
+	damon_set_regions(t, regions, 3, DAMON_MIN_REGION_SZ);
 }
 
 /* Initialize '->regions_list' of every target (task) */
-- 
2.47.3

