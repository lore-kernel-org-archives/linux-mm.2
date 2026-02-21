Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B87EC61DE3
	for <linux-mm@archiver.kernel.org>; Sat, 21 Feb 2026 18:03:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A4136B0089; Sat, 21 Feb 2026 13:03:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0B5166B008C; Sat, 21 Feb 2026 13:03:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF51A6B0092; Sat, 21 Feb 2026 13:03:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id CED886B0089
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 13:03:54 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9113213B2A2
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 18:03:54 +0000 (UTC)
X-FDA: 84469237188.26.1C4BB6A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 089A84000B
	for <linux-mm@kvack.org>; Sat, 21 Feb 2026 18:03:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gqDXXGlV;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771697033;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBHIGIDsGfNA7f4EoJ0Itb6dG96pNiYz8OF0OEfYsYQ=;
	b=fD1sSmQfTzO+RERDQlT3YyIlRwavMS/47rkH4U3HN2KN/NZBhUBCRNK+BDh+dFUbubG32F
	lRceZeBqChSpoJ8sZ0fJzPVp+KYaHoNs4ulWzGcFGpA2zNY0gaktpoGSCIWGQ8+YQLvgG0
	UixBIPwJgn5udfX2R9ZDCaKX+a3F6vA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gqDXXGlV;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771697033; a=rsa-sha256;
	cv=none;
	b=mYdxQjbM5xPWOCuwhQxhNhwuaNdurIdmiF5ao56QlIASF1Qs6GWvdoJ+vXSZSWfO5tcRSy
	AbVaUcrfBzqRw+axd9QwjY8sZkNLMrvm2B6twBbEFCXGztVqQ3XBZtggiUE1aXjAAC2O0B
	nAPbmKinwnCpPrY15ZFRNKA0upfEpSE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 7B34D600BB;
	Sat, 21 Feb 2026 18:03:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE868C19421;
	Sat, 21 Feb 2026 18:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771697032;
	bh=O5C60gzaAjye3NBs36/CbgGUC2VmIz0qx2BwHipnsFA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqDXXGlVX/k/2IrS1XIz/JSoNRKnaAWfaxmxznspptpHHK0T/U/T0/myG2Llxie3u
	 chOK9W5x01FKFc5QU3tCgyruByyyMy3nIpRGvzebYd8AWsM5yOO6VFyPAyanAJByqn
	 +x4/3wnbCeq7OeskKROFZXEHAfLr0PNVektAlXTEpnARDUli9rP35phVYpnQj+xeaq
	 H/hX2c0jgvdznlNJVRdtO+VlekcIYAPGKvW5filv1B2e6G082lTZ2iQ9jg4K8gDjVs
	 bPgilvJnbMyGvCYTPm5WDDB2eKNueTRbHKRWNpzbavN1FVO6V2DFUp1lGWqb16SSsh
	 +nRcE+4+X5JDA==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	Akinobu Mita <akinobu.mita@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v2 2/3] mm/damon/vaddr: do not split regions for min_nr_regions
Date: Sat, 21 Feb 2026 10:03:39 -0800
Message-ID: <20260221180341.10313-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260221180341.10313-1-sj@kernel.org>
References: <20260221180341.10313-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rwa11csmd9y8d9bm89hn5u4thmkb1cd7
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 089A84000B
X-HE-Tag: 1771697032-782517
X-HE-Meta: U2FsdGVkX1/rSR55VhVnFwL5adYwS3Gz4k6quZoJeSOqby19KcR/oYc5GFFZ7svCJdT0HJCy+nm7KWaNSDxTojofhdZHWuep/CWVFP3pYFdEulIKqSgsu82PwofKXgVeMjyac1vIJOXH61sBQ9f5MnqYjZzsEJ/VY1ID3GfOMTea1G/0fPkM2TPIBv0FZ3TCyVLCLhfoidKQF4/tcyx+Kv7k3s97pGobkUJX1P+m7KLlHUyCjgKWuU5jrlxxEUkUM2Pl2dxyg0OpapHMTUyrsC/uc1u88Sgncfb1VfnynGGbuCPbObEKAEY8XsuZoVdU5+jYjwsv2zeXKJ9nHGudQxJxOb8UkdaPgniSb/G7+RRQmtusT1oi2Wy7SNp4JiX9Ophva2FsF8UBNpneEfuda4MDwNheVTlK5DUpUa8W9eQAC9Soag7WXAfUcckGlsJg8kUKXSyxKNdxuuHXSb44xakgtz0wA/5TDV1odumP6xocqZfDdFO6Rdkhh2CwvFzTdbMGeK8s9TPH7fOMsm8vvKAVHecKTdFiW679nVfBHUsF7OnYxvvZQd6docB/6aSDUWMU+akDDu4g2XRUbdMUnmy2fnLgPCESDBVzHMGw+LI0dGcZofhjHBuDUmzJG/Gtqd399pfNNR0NuLKtz832MYJ2tWwlQG9YRFXvM+RjelZg1Et6g1UHSZhez7O9XXGG28BKLjLtssJ+c6o6RxNO8mMNOvipj0AsqV82fAKeQ0cjwjzS7obVpmO5EqAITSU8orO0xo1Kj0CxfRwsA2G7ULmEivr73cfTT+I8np7lg4Utplw58tOBgyy/P6svnHEE2RHUx8iucGA9y9V8Vcf2RAIRZO41/iQWffM6Q1h3fHYgsrHVw9iQJVNX42RkUivJZC9qVmlSDBvNz5O4/XK31NJmxfzY8mZnqFulqW1id58/R0xcFlbcvExuuB3332ONMiCNWgJAal7dNCxBfbP
 6OskB54x
 bXJK31S++U0thT7BbasyQJTbXpl9t5if6P4noaKSosqJTYKHlGV/Sw5zzhFTPW+fpZs9KW2l07smM1OgagokxAEC3bX2F8n4FCEyrGDGFdD07Q8/mHetgfrhb/zZ3Y0w3gUqtL2EZwvRvsvZynyYcOE6KZma5dtA7RMyzUZOD2aagPz6ZjkgD9slDrkYaRl1wSD6LmIWxY4zYT2QTtgmU9sDqVmNrU0vVkYu8OwhOc7xOzOZ6oFHlMQEqh1mxQuu67MtOSQhhp7fp8LmLGOR0IuraYh6Hml9/mmCA4EbOnifl6wamlZlcU7nLdDnkY67W5uvnWe3AbaWiPTXEpOmMLIZFXEGj/hzm8KaQ
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

