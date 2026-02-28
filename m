Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51D30FD0040
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 22:28:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 61FF76B0089; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3026B008C; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 493CC6B0092; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 31B836B0089
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 17:28:43 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E4B4D14030E
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:28:42 +0000 (UTC)
X-FDA: 84495306084.07.D9661B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 64A9DA0007
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 22:28:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q8lIYuQs;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772317721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MPEmhHO4pAQIDi8xz7kLYTysxcxYNnWBHxHCh77oel4=;
	b=3Z3cvq0reItMx/Ow4/0rcd48f2dpRqY3odnckUePx6LMy7H0l3I0haXHtQITOV4BmgP+9Q
	OSLuKlNtO4CXcH2MO6HckG2wCrUEne09onCtcBsqrU8kSAhObIMiFM2371dBGu87VXQI2k
	QY0Psx4Z2KARcXCTK8aosx1JsyIa3nE=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Q8lIYuQs;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772317721; a=rsa-sha256;
	cv=none;
	b=N38/oq1Ama9m1oIuTAqlO6AwdRyn0M3bWY9JdmIiz1pxXHcfbk9lvcpNtfOTPSejEe/VvL
	2ghlNN0wmftlI9awUrw+1Nnc4Aiohx8JF36/cb5J9iLwsASNNEdGMMb9UYw7gPQgN3PKSi
	VCv2+s3MM/JeY5AznBvW92AQLnGst4o=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D90C600AE;
	Sat, 28 Feb 2026 22:28:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3316BC2BC9E;
	Sat, 28 Feb 2026 22:28:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772317720;
	bh=KfT9nJeTJCe56p+SPhAqwenoi3eGOWr/fZ5jtO4mm40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q8lIYuQsGzvV67CbVGFm0yN9GQr68kEnaIcvIXk7t30Rrl6Iv5B4R1J23SgdgckC5
	 dzSKdX8LWChQR8MKnaXacDJIBNSLWUAia9IVvEk16/Ij8CmgMgfS1VMTp7AlG4oG/H
	 CcRKgWqyXVGyUxqrlZO6Pexq5clyEFCHdM/9xBlcldZkl+hsONx6dTzmHO3Fa/ZhP2
	 oTz4SWep/4AHPOumZqqQQGclMNAIxd5yCIBr8wSXX5kF/jO6Sw1812xD56sYSFhPt0
	 qU0pHIxWo0ODQdADPm90jTO2dhjUI3cIqOj6fjGDa+pjIGD3gb02hbOPGy6Qkkc1jw
	 zUHrzJmrOX7MA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 2/3] mm/damon/vaddr: do not split regions for min_nr_regions
Date: Sat, 28 Feb 2026 14:28:26 -0800
Message-ID: <20260228222831.7232-3-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260228222831.7232-1-sj@kernel.org>
References: <20260228222831.7232-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 64A9DA0007
X-Stat-Signature: tyf4scxxe7gxi9ard8kr31dsghoojsxr
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772317721-161291
X-HE-Meta: U2FsdGVkX1/jEGUPKTx0kc2OEQwa6c24uMzLsjkXK+nx091Qgo2zCNOWVOCb2eSxLXREyBhisQ8JoSGU5TFFs8FLbrXxf8365MdZjfy5NffixyhGOysuDjEBMzGpRs021twZ/5c1VEf/9kvg6A9sOECWB5V6lY4NKTpZaJ0AeRUZET0P+Zn8gOvlQyu+0ewil4Szg/MC1MY4VtHxxAq8sDQCgPQVWV+TttADUozUKxQ2CTR2+7kYx24xaxeDFHj2DEsDY69jhdPRjTIPSmtTfNqWqby+YBv/igKfAXQvyKrOsMec3VZb7UE+xDeNjavSzNrTmRauX4hRot3J3pVhKjuPocTRwTkjowYn2qo2ehKgrkRRfoMFbNufT0ZUMVnSOhsCiuEfXsXZ1pczYE7y65fFX4TODAZ/ysTuyHyguUcTLMSySdOr3ZhORn0GwjhosPncZ4xmwmKJ8w+2vJkwWaSpKOvKYwSNyW3n5XiNG83ccirmQNUcHeg9ajGLznBFyrBjv0AjS69X+ixpQdnSMmN7IADUgR67wrhlzLrkLLC6boKvCL3aCzpwt4EUCuAQszKeZJ7kV2iDD5URlr898Bqa4RGEfEfUfkauglnjQt0ZCSP1N/gVreQFKR1Q0kXvpG2Yknn6G7PkGwEV1/O4SbzdJIZSqhMXRbVlNwakAZhqfVZV1/cdZrF5mZ4loqIWk4sAJx7luh7P56uSwEGLYsXuJHUHivgSy+HM9Fdkw5cQ3/OghUjSeL1wD3fhIFSNHFeH1qHpadtqs0oyBEGCF12PEp4ztRVpLYZZgMBdAtBwAOJLNJnfNxJtbehM7omf+EF2Fu8wQCHRikw/hxzOa2XZT9UdpBdwMiOq8/gY1+qyZi1ugmrMZeqvpsP68xj5KzOPViE5C1vHDgFkULPdiWvyW8ekaGsC3hsgqQu0AOWKLW+y6Qww96H3YoRA3NVqrJSSzlZ77hnbWePrYz6
 Pu7GekDh
 qI6Zk1Obm6icIb9d1kpaN93Gicybq4tG4U5gCAFTI+8zI4myM/jlmFOrgnyyfUP37Jt0jUVvM5arRXvlKwJHWJLFpOcSOP5ta2zaC0BWDJP/a0jxTonGYThm3r1PARh7JVDh9mzxRJJgFWZmV8ueOiZn6xI6SCjGhY08Wa4fBK8+toqPGh9yJXwhZ5GcZLlgYIvKH0ilspYpLYVKTKVTpgUcukxEks4SDV1u22+TxvbTfLtIf7Zmk0wQcsnG4H+QQvSnPrIzFF819nJC4GNmE8R2Z7w==
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
index 4d6d8251d4199..b069dbc7e3d25 100644
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

