Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1180FD45FA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:27:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A4E0E6B0088; Wed, 25 Feb 2026 18:27:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A25516B0089; Wed, 25 Feb 2026 18:27:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 924BA6B008A; Wed, 25 Feb 2026 18:27:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7E8A56B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:27:26 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 01FDC1C9FF
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:27:25 +0000 (UTC)
X-FDA: 84484567692.06.292E11A
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.9])
	by imf18.hostedemail.com (Postfix) with ESMTP id 566D61C000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:27:23 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gCFk0fqD;
	spf=pass (imf18.hostedemail.com: domain of ak@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772062044;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=hOWeA1NClVofwdvF5iaoLEM8+V8PRZp9QWBu+z0Uc6w=;
	b=O0ercyV8Awg39VyV+D0Iav65nXCpDYv4RuV3hvZ/jLWIoBZtyK92PfrNMfvdzkDzk2JW0F
	xUHTB82XP/ryg0vlWDPVqc2wVaOsLrf+CBA5i+o4ZyegdbPkHsT6i1WBlAI5ae61HfGGfK
	G7C+H4/CGRe6uG2I1aJ5K4RFiqVRJ3k=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=gCFk0fqD;
	spf=pass (imf18.hostedemail.com: domain of ak@linux.intel.com designates 192.198.163.9 as permitted sender) smtp.mailfrom=ak@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772062044; a=rsa-sha256;
	cv=none;
	b=tqbfpHDkyhPReDZeWIUDz/FONKFfVJesm1M5JHRNHvKB/o0lG10qNVMNgEEnzWf+Hn01jy
	PInHNJrqI+DxmBDKwBe1TwRowQ4qWjIRxZiUXOieDXmJi14fx+j42ZCsyrPE9dDwwtpEXw
	/Gr+g27V7VB9F0NNM+9NdjHYhVVu3ck=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1772062043; x=1803598043;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fifEoQlwYYM9oaaiAw2EITJXAxa/xzNY+qiNqiCHK4I=;
  b=gCFk0fqDketwEndwKilQsR5GMKcWQd+/eElAbDjUgNOnxTuhrysIE/5w
   Zk/esUs4LB6ltuuqW8w8K+MR/ziWMgyG+gF96W40iIB+Xr0idSdFF5ZCf
   UAsoIyeSSJuq7TxjlRl4KOTsS0H6zG0Tx9GpA5fs8GCo/rfFI36fdjouD
   tDaFJD50MqlfoKQQWP134oU/oi03bqnLOYytqjrgLI3gJ+7B05pVjaI4F
   UtFCJ/i75KO/iBzF/hNOEpbZoVoCLRIs67J7+58ccKFU05D3dnMd60qUv
   ajjDdUEYRr6AKJT442+vmbBsVTZQMxpvNpE0HzfbKfnCJBIt8xZqPRWZL
   w==;
X-CSE-ConnectionGUID: 4Q9hY7t4TlyhJ05/5eKuLw==
X-CSE-MsgGUID: hOpd8FaEQee0RpZw7h5jjQ==
X-IronPort-AV: E=McAfee;i="6800,10657,11712"; a="83823658"
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="83823658"
Received: from orviesa004.jf.intel.com ([10.64.159.144])
  by fmvoesa103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 15:27:22 -0800
X-CSE-ConnectionGUID: hSyfAgRqTDyiURS+Y6RSGw==
X-CSE-MsgGUID: bnMcmLYpRoykkn4Vgb4XCA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="6.21,311,1763452800"; 
   d="scan'208";a="220884326"
Received: from tassilo.jf.intel.com ([10.54.38.190])
  by orviesa004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2026 15:27:22 -0800
From: Andi Kleen <ak@linux.intel.com>
To: linux-mm@kvack.org
Cc: akpm@linux-foundation.org,
	Andi Kleen <ak@linux.intel.com>
Subject: [PATCH v2] smaps: Report correct page sizes with THP
Date: Wed, 25 Feb 2026 15:27:08 -0800
Message-ID: <20260225232708.87833-1-ak@linux.intel.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 566D61C000A
X-Stat-Signature: 9ic6pfmdycbehj5ahwwath1zn7berbsk
X-HE-Tag: 1772062043-748352
X-HE-Meta: U2FsdGVkX1/yGixK0XGU2xShjKKr9HR+9FSygInJVe4rXosFGQ/NelnbYEe6PwU56rzmjbVjw8An4YAwKkqJwkCfIICvcH5ZZ/ACOuW4uOXQu4SA1Ns63vTtIVhxdBlGApuTtD7ZcgbWqeWNVcR4L4cq5eXZTXSXnZEO8h5f0OUX3+p41Dkr8SDK/Qc44jJWs8RyjcE+qicOQ/vK5NJHWKeIdq8SaBaSJoxetWj75MtM1Ct+hU0cujNDG52ean/zeEL3QmfjY3E+bsficYwEzjZy2FNDZQYWdDAwogqI3l9lEVhmbkcPfQiNd7HwwxJplSlZgsYuAI0YLtdp1xDFWNnjvCBaRfMEgYLkyxATmnViT57xJxy9lK4YeZfgX3H9+pll7X0+vZ3ggSFPWcdwzPQlU4wD9O2fwLVEPBHcedOAq6hXFIYcKZvnwk4GTXgNGSgOpXffKFn0zWTzn+0B+uHs0bzbGmN84//nDr33SbtRYGnrdqPnr4sw8WPtC3tICF9PLVsZN/fDyK1ToGQ/S+ddjUqSS7uOMBtkm4zCWHVjGWIfSYOqMdtZypIFFPYt9BA5m4K6TQ1r8tG+AWmPBl1gXD9wPHTZvwuTJNfKPLMg73Sg7CvokGBItGugIH71iutCifx+3y/SdxLAz7UqGY2kWE5n1LegVpfg4+cWFlMfYssktWpg+XSyPa4tuJohtN07FKPDmGE9Czf52jeNEKLU7FirTxtPoTYB3ZRE7ABoxYdqOHvmJrO6uCtcSswvxU/0J8kRiyKJY421UghBgPDkj5XFY1jCC9ThYe75NdKZ6l497t5+Ix546r5XdpNcnYNejTbfiHpiIVRH3iZvqSE2629kP7oeyaEiz8gpERwBrcH37p7j/fKSxvcd9kWLhtHMJu1t+qBtA+WlWCIDPr60fJmbEXYJyBFwDXvlSKYsdF92+Y/CzQexwIrL+UVhX5ful9w1SPgwV1BJELW
 zJpGa98C
 7lgfpQLKjSwcAlhfl93mI5z8zs1dDc774J9Wr0RLSagp0Tnfs5TdTL4UbRoHHT37+tPHdYM+W6UI2W4MP7ZxvOfRs8aVGhVPP18DD+cdH5q19K/jKrTIZ0hvwRKnVPhbm44KEryp6hKs1paOYAM1hGcs6Z8WA9ktsAcKEq48QQ06mwRo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The earlier version of this patch kit wasn't that well received,
with the main objection being non support for mTHP. This variant
tracks any mTHP sizes in a VMA and reports them with MMUPageSizeN in smaps,
with increasing N.  The base page size is still reported w/o a
number postfix to stay compatible.

The nice thing is that the patch is actually simpler and more
straight forward than the THP only variant. Also improved the
documentation.

Recently I wasted quite some time debugging why THP didn't work, when it
was just smaps always reporting the base page size. It has separate
counts for (non m) THP, but using them is not always obvious.
I left KernelPageSize alone.

Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 Documentation/filesystems/proc.rst |  8 ++++++--
 fs/proc/task_mmu.c                 | 14 +++++++++++++-
 2 files changed, 19 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
index b0c0d1b45b99..c5102ef7a2eb 100644
--- a/Documentation/filesystems/proc.rst
+++ b/Documentation/filesystems/proc.rst
@@ -452,6 +452,7 @@ Memory Area, or VMA) there is a series of lines such as the following::
     Size:               1084 kB
     KernelPageSize:        4 kB
     MMUPageSize:           4 kB
+    MMUPageSize2:       2048 kB
     Rss:                 892 kB
     Pss:                 374 kB
     Pss_Dirty:             0 kB
@@ -476,14 +477,17 @@ Memory Area, or VMA) there is a series of lines such as the following::
     VmFlags: rd ex mr mw me dw
 
 The first of these lines shows the same information as is displayed for
-the mapping in /proc/PID/maps.  Following lines show the size of the
+the mapping in /proc/PID/maps (except that there might be more page sizes
+if the mapping has them)
+Following lines show the size of the
 mapping (size); the size of each page allocated when backing a VMA
 (KernelPageSize), which is usually the same as the size in the page table
 entries; the page size used by the MMU when backing a VMA (in most cases,
 the same as KernelPageSize); the amount of the mapping that is currently
 resident in RAM (RSS); the process's proportional share of this mapping
 (PSS); and the number of clean and dirty shared and private pages in the
-mapping.
+mapping. If the mapping has multiple page size there might be a be multiple
+numbered MMUPageSize entries.
 
 The "proportional set size" (PSS) of a process is the count of pages it has
 in memory, where each page is divided by the number of processes sharing it.
diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index e091931d7ca1..8bfd8b13c2ed 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -874,6 +874,7 @@ struct mem_size_stats {
 	unsigned long shared_hugetlb;
 	unsigned long private_hugetlb;
 	unsigned long ksm;
+	unsigned long compound_orders;
 	u64 pss;
 	u64 pss_anon;
 	u64 pss_file;
@@ -942,6 +943,9 @@ static void smaps_account(struct mem_size_stats *mss, struct page *page,
 	if (young || folio_test_young(folio) || folio_test_referenced(folio))
 		mss->referenced += size;
 
+	mss->compound_orders |=
+		BIT_ULL(compound ? folio_large_order(folio) : 0);
+
 	/*
 	 * Then accumulate quantities that may depend on sharing, or that may
 	 * differ page-by-page.
@@ -1371,6 +1375,7 @@ static int show_smap(struct seq_file *m, void *v)
 {
 	struct vm_area_struct *vma = v;
 	struct mem_size_stats mss = {};
+	int i, cnt = 0;
 
 	smap_gather_stats(vma, &mss, 0);
 
@@ -1378,7 +1383,14 @@ static int show_smap(struct seq_file *m, void *v)
 
 	SEQ_PUT_DEC("Size:           ", vma->vm_end - vma->vm_start);
 	SEQ_PUT_DEC(" kB\nKernelPageSize: ", vma_kernel_pagesize(vma));
-	SEQ_PUT_DEC(" kB\nMMUPageSize:    ", vma_mmu_pagesize(vma));
+
+	for_each_set_bit(i, &mss.compound_orders, BITS_PER_LONG) {
+		if (cnt++ == 0)
+			SEQ_PUT_DEC(" kB\nMMUPageSize:    ", PAGE_SIZE << i);
+		else
+			seq_printf(m, " kB\nMMUPageSize%d:   %8u",
+					cnt, 1 << (PAGE_SHIFT-10+i));
+	}
 	seq_puts(m, " kB\n");
 
 	__show_smap(m, &mss, false);
-- 
2.53.0


