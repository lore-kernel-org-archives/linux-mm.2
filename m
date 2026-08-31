Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7324BC61DD3
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 22:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43A0B6B008C; Mon, 31 Aug 2026 18:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EB246B0092; Mon, 31 Aug 2026 18:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DCF56B0095; Mon, 31 Aug 2026 18:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 058976B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:12:05 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7DF9314025A
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:12:05 +0000 (UTC)
X-FDA: 85162963410.05.288ED3A
Received: from pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.35.192.45])
	by imf31.hostedemail.com (Postfix) with ESMTP id 4574820003
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:12:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=B5wdXJYh;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf31.hostedemail.com: domain of "prvs=696c8a93a=zcgao@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=696c8a93a=zcgao@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788214323;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/X8kM8mFmh3GkThmAvG35lkCePNBjW1VUyypxdJ8g9A=;
	b=pV4e8iwZyM6jWiU9mYjvP0PAxdUQ6Ws15IuKKMvPgUdHSbMhpV3V2ZIUSnYAYxpP+j71FT
	QwhTP/9MYMIWSKwxncdTSYkMmcbyLOLuQ/C7eXtvgMcZz6bdrMFbfm4C9l7BgJQbfwFQY3
	Box6ApMYmIPvQUgMo3CmwgECOZG/qPs=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=B5wdXJYh;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf31.hostedemail.com: domain of "prvs=696c8a93a=zcgao@amazon.com" designates 52.35.192.45 as permitted sender) smtp.mailfrom="prvs=696c8a93a=zcgao@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788214323;
	b=GaawYgT58+5Qd6dQgfFYLL1kF0Vr0EI2HgLA6sWj+mkVNv9zflbby/0hxIN/U30B8qb0/O
	qztjdTm7WXojI5cEixHbVedp+w2F51PK4SSoXnp2xtNaoPYazTuodpYeEUq5QwUuzemPl6
	LFpMZOtuMMn1KbuVFL8CcToxabqpRHM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1788214323; x=1819750323;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=/X8kM8mFmh3GkThmAvG35lkCePNBjW1VUyypxdJ8g9A=;
  b=B5wdXJYhtj/MYi0NWx+uclmUu+J/Z3s3CTyG9I8aNapMz0k9d/znNHSl
   gKYexxTWape99ZryLvfot37o3d+oWTzWyx2UIxy2uLKkSDVXF5/4dDaaM
   7wtDxSjhBcauQjEiUhff+1knmyMLm+aWljWN8r/x4d7jOxeg0ERtkFf7I
   P9c1IeG7vw1CFYkc4/4DhW/ROiCK+mkpcC6ppmZZUAIxg0sUXjEojZfdp
   dbeIlgfCQM9BHZn+hISve+d7PFvcS06/ynFyACdtAoEZvitd1qo+lDMC8
   iq12ioeGUWmpUdsMAqWQPM4vVMK1perUT+ZUvcZDUuSem3h1M3givxfNU
   g==;
X-CSE-ConnectionGUID: mfHRJFKpS7GxXRUqgKEPDw==
X-CSE-MsgGUID: FyVwAOAWQJiu3Xorfce8cQ==
X-IronPort-AV: E=Sophos;i="6.25,254,1779148800"; 
   d="scan'208";a="27209376"
Received: from ip-10-5-0-115.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.0.115])
  by internal-pdx-out-011.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Aug 2026 22:11:59 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:13487]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.52.146:2525] with esmtp (Farcaster)
 id 6c0612df-8596-4553-97cd-ae226648a58c; Mon, 31 Aug 2026 22:11:58 +0000 (UTC)
X-Farcaster-Flow-ID: 6c0612df-8596-4553-97cd-ae226648a58c
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Mon, 31 Aug 2026 22:11:58 +0000
Received: from 6c7e67c92ceb.amazon.com (10.187.171.29) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Mon, 31 Aug 2026 22:11:58 +0000
From: Nathan Gao <zcgao@amazon.com>
To: <sj@kernel.org>, <akpm@linux-foundation.org>
CC: <damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <baolin.wang@linux.alibaba.com>,
	<david@kernel.org>, <ryan.roberts@arm.com>
Subject: [PATCH v2] mm/damon/vaddr: use a page-aligned address for the sampling walks
Date: Mon, 31 Aug 2026 15:11:51 -0700
Message-ID: <20260831221151.50561-1-zcgao@amazon.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.29]
X-ClientProxiedBy: EX19D036UWC004.ant.amazon.com (10.13.139.205) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: sfcuum9tdme1yppi1d48rmwy4zamt1cy
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4574820003
X-Rspam-User: 
X-HE-Tag: 1788214323-179579
X-HE-Meta: U2FsdGVkX1/AmhrBHrgjHLYi6t5uZLBn5K6dPjXioWHxUQC6Q0M5SjHVLrR/RdPQab093OnWqUMwlW50l/QpSKl6jUydp+BarmMOaupPGlaCHfeChx74xEA9w6WXoUJSZLHyksU/LCFllLZRys+2pcyuKO27q0Bfo2pEZZQ2dIHeT3EmXYtj2gIyurmjYSTPSL47QE9DGRapVHrNfSLRvdLaREFDUZb/6ZqjBEi2Vrbu5jgu+TFXQWQlmu0Aar+cuSopaPPYOXGIhx9m9S7dUbTS/DUcB3VcJ+aGoVxi3UZeCUgc6wsAAwvNGlxej2CIv3lY0cmwp+aMyWoStj+YFCGvYxKyqpGxy4npjj9ElrdnhQ4m+rmCUH0pEtJGNBB1PitGEa5/g69pjShjTCwE4/naJVO2dGw5IuNsGCaBlB23rJcBmrF4mEmXIPzYOmHUieucvH29P5Agy7byvxHFgJVjA1E7e+esgYdX9N2wDX/hgqeR1Zo66sH4YnSrH0m/ldHZp5cI9q+zYD8GTl74cprLhPoGI1Grgwj5j/eL4Af2T7Tr948tT1J+TejzkC+7OZ8HiZkxayUybCFqbsaQP8fNHeHGG1/PnzIok4dnExlWtv9Y98sc4LqYiDJFUTPRJkMAplKM+CoQ8l5Qm6rhwRCqpA5VgQu5icBYBcojC8onv5H5oCjTnklcxDGfLn7f7Ox1gg4F1wPTLQkW7EvxygpM+BaDGUuIWyxSIoY7OiID2r8/hJ/hjnLvGqPHsbO9foMPQH7wEP27YiRDmHA3wiHqm7x+ZR4T1D47mr1hJm6wcOoPScd0c8fQw168QLC1M6aAlrjJdkr1R4CL3bSykcqcK1vVX55yfES+M+HsytRObhoiuPGh5R2X75wLmFQ7vaEqJEPdnJELBwxJ8NIvbQEgpOWntqmSq2NC+qygU0jEb6T1iUAno3tNZsHe1T9myU/apPxdYhIedDxNHft
 UpGo5Bb5
 OTyXeizOQ1d6c+ZwjGVGiAYTUnLrlTY9Y8lrjpB2JULn4bh3xVvdNDFkCZvtrzAH9asPTXkoUHfK35XHW+gYE1Nbf4xYrt0NBr/YNYpLshhaPy9VHDfvcblg08RLh3YgZbJrRU/Z0gbxpKkVDfuAdLu4nIijukiedDvu2wXqrlU2XzWnvolcEZmK04Mk2MJ7yxIMgWwfj1PasDKgL6j2cPhFrFmT9b+7wWJz59im5TqLeXyx2i+wCDF9vOvRiwjfu3fkeZWfbAgzH7/sD9CY4IN+ipZwUiO4UW8uim2KQLRbofFQqNN3fRJgk/gssopfpktgZGsTo+tBcOt2WsQE8jxVe0F4gUHO6pcXcHvybkQC8Fvo5SBeiigQQlMnFproFG2K/zx/eanwgLMy5HxRBF6kmY+ZK+xdkywPzbQ50jSZtAJdgTIvIC8C3g5fYqINlMwT4hkeFnmwbVkE44sIEnss2w03M5qPF0gcMOlUieo9nyYaY4ARTD77Utn3WNf8XxdC6M5IlOLeBxuxjOXhDsXpaHcXlc0Kf7n9xfPk+tZBWO5eT5qWvAglX53aM+UTE0Wfh7KqBXz4JxHVbVyP77pJXKW0XGbNpaaUPgaP6H+9pgdxzjmvALlnvSt9ZFKuy+do+KOiooclEuFLPZow0yuVzUyEtycsX+Brg1bHpwZ31n0qehNbG81lrCv+9P4rO4rqMCTK4WYlLBFODtUV1h5AT2nGYwTqi+vsfBMeEaerqdE6B6sZQSfRRJLROO1Xy91y3/nnh4dGwoYwNDppkkhZUpiI2yfUwvgNUfMl/2qBQitw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__damon_va_prepare_access_check() picks a random byte address within the
region and stores it in r->sampling_addr. There are two users of
r->sampling_addr in vaddr.c that pass it into a page table walk, and
both use it as the address of a page.

  damon_va_mkold(mm, r->sampling_addr)
    damon_va_walk_page_range(mm, addr, addr + 1)
      damon_mkold_pmd_entry()
        damon_ptep_mkold(pte, vma, addr)
          ptep_test_and_clear_young(vma, addr, pte)
          mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)

  damon_va_young(mm, r->sampling_addr, &folio_sz)
    damon_va_walk_page_range(mm, addr, addr + 1)
      damon_young_pmd_entry()
        ptep_get(pte)
        mmu_notifier_test_young(walk->mm, addr)

For arm64, before commit 6f0e1142173a ("arm64: mm: support batch
clearing of the young flag for large folios"), the contpte helper walked
exactly CONT_PTES entries from the aligned-down page table pointer and
used @addr only to pass down to each entry, so an unaligned value was
harmless:

        ptep = contpte_align_down(ptep);
        addr = ALIGN_DOWN(addr, CONT_PTE_SIZE);
        for (i = 0; i < CONT_PTES; i++, ptep++, addr += PAGE_SIZE)

Now the range to walk is derived from @addr instead: end = addr +
nr * PAGE_SIZE, rounded up to CONT_PTE_SIZE. For a sample in the last
page of a contpte block, the sub-page offset puts end just past the
block boundary, so the round-up lands a whole block further and the
walk clears PTE_AF in CONT_PTES entries beyond the sampled block. For
the last block in a page table page, those entries are past the end of
that page, so the walk writes into the page that follows.

Triggered by the full 7.1/7.2 kernel selftest suite on arm64 (EC2
c/m6g.4xlarge). The kernel sometimes crashes at or shortly after the
DAMON test.

What the overrun does depends on the page that happens to follow the
page table, so there is no single signature. If that page is read-only,
the write faults in the sampling path itself:

  Unable to handle kernel write to read-only memory at virtual address ffff0003c5d2d000
    FSC = 0x0f: level 3 permission fault
    CM = 0, WnR = 1, TnD = 0, TagAccess = 0
  CPU: 10 UID: 0 PID: 3487 Comm: kdamond.2
  pc : contpte_test_and_clear_young_ptes+0x70/0xc0
  lr : damon_ptep_mkold+0x1e8/0x1f8
  Call trace:
   contpte_test_and_clear_young_ptes+0x70/0xc0 (P)
   damon_mkold_pmd_entry+0x150/0x170
   walk_pmd_range+0x110/0x2b0
   walk_pud_range+0x10c/0x208
   walk_pgd_range+0x134/0x258
   __walk_page_range+0x98/0x1b0
   walk_page_range_vma_unsafe+0x90/0x148
   walk_page_range_vma+0x28/0x40
   damon_va_walk_page_range+0x114/0x2b8
   damon_va_prepare_access_checks+0xec/0x1a8
   kdamond_fn+0x534/0x770
   kthread+0x128/0x138
   ret_from_fork+0x10/0x20

Otherwise the page is writable, the PTE_AF clearing succeeds silently
and the damage only surfaces later, in whatever happened to own the
page, so the backtrace is unrelated to DAMON and differs between runs.

Align the address down to a page boundary in damon_va_mkold() and
damon_va_young(), the two users that pass it into a page table walk. It
is the address of the page to sample, so this matches its intended
meaning. r->sampling_addr itself is left as is, so the sampling and
region bookkeeping semantics are unchanged.

Fixes: 6f0e1142173a ("arm64: mm: support batch clearing of the young flag for large folios")
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nathan Gao <zcgao@amazon.com>
---
V1 -> V2:
- Align inside damon_va_mkold() and damon_va_young(), the two users that
  pass the address into a page table walk, rather than aligning
  r->sampling_addr itself, so that sub-page sampling addresses remain
  possible for future non-PTE access check primitives (SJ)
- Point Fixes: at 6f0e1142173a instead of 3f49584b262c, since the
  unaligned address was harmless before that commit (SJ)
- Describe how the issue was noticed and what it does to the kernel (SJ)
- Reword the subject to match the narrower change

v1: https://lore.kernel.org/all/20260827193821.46115-1-zcgao@amazon.com/

 mm/damon/vaddr.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
index 2c1c1952c008d..e7aa18200088f 100644
--- a/mm/damon/vaddr.c
+++ b/mm/damon/vaddr.c
@@ -349,6 +349,9 @@ static void damon_va_mkold(struct mm_struct *mm, unsigned long addr)
 		.hugetlb_entry = damon_mkold_hugetlb_entry,
 	};
 
+	/* Arch helpers can derive a page range from @addr; align it down. */
+	addr = PAGE_ALIGN_DOWN(addr);
+
 	damon_va_walk_page_range(mm, addr, addr + 1, &damon_mkold_ops, NULL);
 }
 
@@ -482,6 +485,9 @@ static bool damon_va_young(struct mm_struct *mm, unsigned long addr,
 		.hugetlb_entry = damon_young_hugetlb_entry,
 	};
 
+	/* Arch helpers can derive a page range from @addr; align it down. */
+	addr = PAGE_ALIGN_DOWN(addr);
+
 	damon_va_walk_page_range(mm, addr, addr + 1, &damon_young_ops, &arg);
 	return arg.young;
 }
-- 
2.50.1


