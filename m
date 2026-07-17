Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35C87C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 16:08:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E6F9D6B00AB; Fri, 17 Jul 2026 12:07:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF2976B00AE; Fri, 17 Jul 2026 12:07:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D08596B00AB; Fri, 17 Jul 2026 12:07:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7B80F6B00AB
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 12:07:57 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 54B401A010E
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:40:36 +0000 (UTC)
X-FDA: 84998378472.13.6CCC710
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id BA9BA1A0009
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 13:40:34 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wIUFl/UO";
	spf=pass (imf19.hostedemail.com: domain of 30DBaagoKCPMhXgVkdinfdbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=30DBaagoKCPMhXgVkdinfdbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784295634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=qJ3lF392ZnaDQ7ksH9U+tbRYSBGb3EW5QpOiJ+U17/M=;
	b=z1AC0RFVMfoJWzFH5nLKR2Wd/HKYSbwMyaOkfJVdgS3st0iPgB42qDJpKMzsOfpQxRSsH1
	u9u0szJ11F76+J4J9tAgaAHCJ/lUHSreXUWrAUi0hrLh6W8p7bGvVm3sm5wrNhgFVkonbL
	/HbuU/wCq4i4dEtz+Vdl2ioToJ5EisE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="wIUFl/UO";
	spf=pass (imf19.hostedemail.com: domain of 30DBaagoKCPMhXgVkdinfdbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--mclapinski.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=30DBaagoKCPMhXgVkdinfdbjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--mclapinski.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784295634;
	b=Cf9y4UHxwObCca1I4Hens6uT/AdMoAz/pBwtEhB11Ln5mRQvBZSxBrZeMIRmInoHKVM/jb
	b9XgIfN90/ayfitKBd0E42fssolqMOKDAtA8dng2/XDzqDLb8nyw5uTJCn/kWps+r6/ss6
	dkYGlSvpVjRjFlape6f+fZE2MMARDeg=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-493c20d0468so53594415e9.1
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 06:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784295633; x=1784900433; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=qJ3lF392ZnaDQ7ksH9U+tbRYSBGb3EW5QpOiJ+U17/M=;
        b=wIUFl/UOblcrsPaN8Y/UkiBLB/EcqctsKP+JFMy3ZSgVKokf7yo1G6pyvLJ+GX3kQc
         8D2I43bg4mhPI7Sl9PO2QaXiR/KilJ6Zt62ztQJiQJsTH0/vfpyyawOWYducXkbPqjU6
         R6iIdIArr6AWV459ZbBJSWXNstKYABVXz5tqJUOWAFs4n7f+8AFcoF7XQNt2RXxoBtoC
         +N/wKergCj4oZNnMmDTibTfVQKgFYC5gW4d49cUTBIQ1du2gW0xJ6ANi1aKh+CArMtV7
         CD7SKQtuMMGfBqNomzhKWU9KAqDaJElMTXL4tUFNxupDG997q9YJASSvH6Dct7FF0yjX
         nw+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784295633; x=1784900433;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qJ3lF392ZnaDQ7ksH9U+tbRYSBGb3EW5QpOiJ+U17/M=;
        b=eDEvf5mggBmj9wD8ux3be3eijOLwAvgSyYUQDi7zv9J2LP120RWhtITPSbBMHkwbar
         9HmgNwd+O4Q/xMfiRfFpGefc4dWbLmDfsQcJZxV2UeuINuVPW32pfBWj2bscvjrtnTVn
         ElLDyksLpqJjYm+ME1bUYlNT+4HMESVjRT0WoPqI7QeqOfN0gcHHq1UpP4FK3nxWqvgr
         Jc2dzegmh63gZmSeMy7nySGmL04Mx7YIxwChq86i0CVXMLijQBWEOX2chPmUqjeDC+z3
         Tu/vJQVka4icOCA+DXh6BXDdSJlWCLlwDGKrZwUXJpNAD/EpiJlPcL5MqIBHqavicp2R
         vbTg==
X-Gm-Message-State: AOJu0Yy5T7NlCl5iD31ZFbOZr2BcNWmok09nnvttJSz4MqHOQnbPJs2J
	m57uVbripoCpw0w3SD/pb5FOEp3lOXiwzI21HnyEi+Gy16UNRwZukAHQ7DyLPoPjX0opmjjiXc9
	LoDKnyzKw8NvbvArL78dyDQ==
X-Received: from wrvx6.prod.google.com ([2002:a5d:54c6:0:b0:47f:4443:1db4])
 (user=mclapinski job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:1382:b0:495:3f48:5df2 with SMTP id 5b1f17b1804b1-4954a40bcf6mr31154885e9.29.1784295632744;
 Fri, 17 Jul 2026 06:40:32 -0700 (PDT)
Date: Fri, 17 Jul 2026 15:40:28 +0200
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260717134028.2880508-1-mclapinski@google.com>
Subject: [PATCH v2] kho: align kho_scratch to MAX_ORDER_NR_PAGES pages
From: Michal Clapinski <mclapinski@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, 
	Evangelos Petrongonas <epetron@amazon.de>, kexec@lists.infradead.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Michal Clapinski <mclapinski@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: BA9BA1A0009
X-Stat-Signature: 14rye4g7egcw5yjakztu941hbppstydq
X-HE-Tag: 1784295634-24542
X-HE-Meta: U2FsdGVkX191Ukw9ZijMk3uO5FV0aTcNiIye56zgMlYefIx+HjMU8XuHcWNPvjj3uG4G4iZWodzbZnupUMhYP3yeNTGfU2Thlj1akiDkXBYksZDjWXukeaEoQ3eniQj3kXqm7yKyJQTIzZRoR7OvDOUojIF0mESUa9cWOODDDBV/4Vb/L+n/TS49BDyNurw6B6/K4+AJjZLDjybd2einvKcwO/GNGiONlEqWJDw0hwbD15B8h5WEZeAd6zA5nQ2lxh0RjuMu3Tl8ptXSuLBLtcwEwzdn5u8oiEtqZqraiZZh+Z/Y7daqPQAiaY3sqL2hzu8DlB2xhdRWoNJBywnWkTDL84AV6UXdHyHkX3PZezNZMS7cRQBBafnhDBEGZkVTpCAAEmM6ApGKFOwaUB0Gtm8tFar5mInxtlA6lLonoFYPagZjXqze8r8SW+nxAvusrYLZlk48/QVo7SLTuyiOScT7tUGMCl4hmGq8bL9eMvHozVy6HfskZlZ9+91S6OjeK6CXT/e4JwivT3bjAJES6NrAwtFRn+2KLfMyT6MGflj81ZVKXBJR29CbwkdYdF752AM1cPspGXBXrZ6nEK7DgLnKXOQ/5bhKG/prTyq3LYeUzBBIbWj26+CzKQ4pEh5Vm0eU2cM27V5H3NtWETumt59jgui8Xk99DxxWaGE/DGhUxA3pxqx/DWPc/MOMvHFtisngYGBv/iz8tphsyNbC8iWTFxziFNhpHcgQAQyripdh5iNQ1XBp1xRpJd3DRZlgrFPMDYncfEoQ7bYAiiHMPMKVTicRmk6WRrEAGteeW98+0UbcTWzYzRwusV5TatheE1a15CkBYWFL0ZhVQ6r+egoa/A61s8ej8YiMGQMPDDyyOeUwnXqDKymzHV0ev2+mEsu5hJ4ecZHCxac4QGf5CKBfMhkOMrQBYx45srYcc85BW9QbEeE4sN5hLglgTI/i1VIy/fSL20xVmJSOXH8
 2uiEn+Vg
 zk+Xfcd2mDgz2+e5FBTFUxhhxLaRfxfcPZDBXbyrLhrT54Fvu5oP/Iflf3qaWnMBxQeDefha8vtSdRQZSkFM8JXLJZZqrESDczqwrmDjl3UK7xWK1P1hV59uuAwxB9zidYU6k/LQdKV4QgfqUW1L28h9V+yzFnQGakR2rGSXKiFeg/bVcNBOIxLN9TE7zUEy797V0epWrw/c72Jv3KtmyRnpmqw6X1XRnlPd+mx/S5dwsV5RhVPlhxRfjQR1ZFLS7Ac3h3qb/yzZZ25Dwgssl+OeHOtpv0Hi5FqD2WebBn9ykVE8YbX4oqv9kdeeO4KBSWNtrsI6z8uKML19b0+/awlC/b9dJgCPffYqvtrwVU+0S9zdyMnpAkq3Pl9i6jEGfauXTUCoqInGbATYj6QJ1AgCXsq9xNMjzmIXi5l8jHxBHjegqnJ8R1nADLISWUgWhkQGbNgu1MFhveDx0IRymFxy4g3prboe1Iu8qvkcXvgserAp/Cod4PnSLGUvxpQlbjeVnuUUHH1PLmbTl0eMbl7FpFun+GlD242ozbYWRRByqaYGo1zj4v7YFDtLhGTddkL2XhlL/fdbCiJVdb9tSLEXnCoNTOvMU7OBwJ6Si/s8TkJUqM6p7EuhmDa2Ob4KWU1MVlONnuU7kfKwHpydhFc7VSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

While booting with KHO, the following crash was observed:

BUG: unable to handle page fault for address: ff19164fffff8328
RIP: 0010:__free_one_page+0x1a1/0x6b0
Call Trace:
 <TASK>
 [<ffffffff913208bf>] free_one_page+0xaf/0x240
 [<ffffffff93973288>] deferred_free_pages+0xa8/0xd0
 [<ffffffff93971b4f>] deferred_init_memmap_chunk+0x10f/0x1b0
 [<ffffffff9396e265>] padata_mt_helper+0x65/0xa0
 [<ffffffff90fac402>] process_scheduled_works+0x202/0x410
 [<ffffffff90fae739>] worker_thread+0x1f9/0x2d0
 [<ffffffff90fb62fd>] kthread+0x27d/0x2f0
 [<ffffffff90fae540>] ? __pfx_worker_thread+0x10/0x10
 [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
 [<ffffffff90efdc55>] ret_from_fork+0x145/0x280
 [<ffffffff90fb6080>] ? __pfx_kthread+0x10/0x10
 [<ffffffff90e2e46a>] ret_from_fork_asm+0x1a/0x30
 </TASK>

deferred_init_memmap_chunk() interleaves initialization of struct pages
with freeing them. This works fine without KHO because free regions
will never be neighbors. However, with KHO, free memory will be split
into (free && scratch) and (free && !scratch), which can be neighbors.

KHO scratch is aligned to CMA_MIN_ALIGNMENT_PAGES pages but buddy looks
at the neighborhood of MAX_ORDER_NR_PAGES pages. These values are
configurable but CMA_MIN_ALIGNMENT_PAGES is always less or equal to
MAX_ORDER_NR_PAGES. In the crashing configuration they were set as
follows:
CMA_MIN_ALIGNMENT_PAGES = 1 << 9
MAX_ORDER_NR_PAGES = 1 << 10

So while freeing one chunk, buddy accessed uninitialized struct pages
from another chunk, tried to merge the blocks and crashed.

To fix this, let's just align KHO scratch to MAX_ORDER_NR_PAGES pages.

Fixes: c6073743d0c7 ("kho: make preserved pages compatible with deferred struct page init")
Signed-off-by: Michal Clapinski <mclapinski@google.com>
---
Unfortunately, this is very hard to catch, so I don't have a good
reproducer. But I run the code with the fix through extensive testing
and it seems fine.
I think I've never caught it before because enabling HUGETLB is what
causes CMA_MIN_ALIGNMENT_PAGES to be 1 << 9, instead of 1 << 10.

If this passes review, please cherry-pick it to 7.2 so we don't release
a broken kernel.
---
 kernel/liveupdate/kexec_handover.c | 22 ++++++++++++++++------
 1 file changed, 16 insertions(+), 6 deletions(-)

diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kexec_handover.c
index 4834a809985a..175c08a6e41e 100644
--- a/kernel/liveupdate/kexec_handover.c
+++ b/kernel/liveupdate/kexec_handover.c
@@ -38,6 +38,16 @@
 #include "../kexec_internal.h"
 #include "kexec_handover_internal.h"
 
+/*
+ * This is the minimal alignment required by deferred struct page init.
+ * deferred_init_memmap_chunk frees memory to the buddy allocator, which looks
+ * at the neighboring pages (up to MAX_PAGE_ORDER) to merge them.
+ * If KHO scratch is not aligned to that value, buddy can access uninitialized
+ * struct pages, which can cause a crash.
+ */
+#define SCRATCH_ALIGNMENT_BYTES (PAGE_SIZE * MAX_ORDER_NR_PAGES)
+static_assert(SCRATCH_ALIGNMENT_BYTES >= CMA_MIN_ALIGNMENT_BYTES);
+
 /* The magic token for preserved pages */
 #define KHO_PAGE_MAGIC 0x4b484f50U /* ASCII for 'KHOP' */
 
@@ -640,8 +650,8 @@ static void __init scratch_size_update(void)
 	 * Scratch areas are released as MIGRATE_CMA. Round them up to the right
 	 * size.
 	 */
-	scratch_size_lowmem = round_up(scratch_size_lowmem, CMA_MIN_ALIGNMENT_BYTES);
-	scratch_size_global = round_up(scratch_size_global, CMA_MIN_ALIGNMENT_BYTES);
+	scratch_size_lowmem = round_up(scratch_size_lowmem, SCRATCH_ALIGNMENT_BYTES);
+	scratch_size_global = round_up(scratch_size_global, SCRATCH_ALIGNMENT_BYTES);
 }
 
 static phys_addr_t __init scratch_size_node(int nid)
@@ -656,7 +666,7 @@ static phys_addr_t __init scratch_size_node(int nid)
 		size = scratch_size_pernode;
 	}
 
-	return round_up(size, CMA_MIN_ALIGNMENT_BYTES);
+	return round_up(size, SCRATCH_ALIGNMENT_BYTES);
 }
 
 /**
@@ -692,7 +702,7 @@ static void __init kho_reserve_scratch(void)
 	 * next kernel
 	 */
 	size = scratch_size_lowmem;
-	addr = memblock_phys_alloc_range(size, CMA_MIN_ALIGNMENT_BYTES, 0,
+	addr = memblock_phys_alloc_range(size, SCRATCH_ALIGNMENT_BYTES, 0,
 					 ARCH_LOW_ADDRESS_LIMIT);
 	if (!addr) {
 		pr_err("Failed to reserve lowmem scratch buffer\n");
@@ -705,7 +715,7 @@ static void __init kho_reserve_scratch(void)
 
 	/* reserve large contiguous area for allocations without nid */
 	size = scratch_size_global;
-	addr = memblock_phys_alloc(size, CMA_MIN_ALIGNMENT_BYTES);
+	addr = memblock_phys_alloc(size, SCRATCH_ALIGNMENT_BYTES);
 	if (!addr) {
 		pr_err("Failed to reserve global scratch buffer\n");
 		goto err_free_scratch_areas;
@@ -721,7 +731,7 @@ static void __init kho_reserve_scratch(void)
 	 */
 	for_each_node_state(nid, N_MEMORY) {
 		size = scratch_size_node(nid);
-		addr = memblock_alloc_range_nid(size, CMA_MIN_ALIGNMENT_BYTES,
+		addr = memblock_alloc_range_nid(size, SCRATCH_ALIGNMENT_BYTES,
 						0, MEMBLOCK_ALLOC_ACCESSIBLE,
 						nid, true);
 		if (!addr) {
-- 
2.55.0.229.g6434b31f56-goog


