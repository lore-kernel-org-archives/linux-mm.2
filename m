Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C97CC624D0
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 03:17:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C46516B0088; Tue,  1 Sep 2026 23:17:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1E026B0092; Tue,  1 Sep 2026 23:17:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B5B446B0095; Tue,  1 Sep 2026 23:17:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 845776B0088
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 23:17:10 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 733ADA4694
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:17:08 +0000 (UTC)
X-FDA: 85167360936.01.C192A99
Received: from pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com [35.155.198.111])
	by imf18.hostedemail.com (Postfix) with ESMTP id 38EBE1C0003
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 03:17:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=iKUVOCam;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf18.hostedemail.com: domain of "prvs=6980ef5b6=zcgao@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=6980ef5b6=zcgao@amazon.com"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788319026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=1nCArtEkFHsetVE9HyV3SWkRXMjEedc6y2E/MROxKuc=;
	b=Nc2z1l+iE0RgnI/cSH4Q4Ffw9y/iBdzR25B8dwd5zqfLmVqDVns73sExRDSlmbkqXWy/A+
	5soHCWT+B1JWw+lSIesu23jy/hFYooe2xCCQm1daV8c3sTzTvtr4On1OSTsPdS2gckE9I9
	HEiLccYCgSAA41qc8fIthPq+uhBKiFQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788319026;
	b=rK6faJ7juuxfBuYMs/UsxF47oFaPVxIFMFkE+vPItWJODH5tgYmYE+d9/FEHjguuxYLdNA
	f85izrFIS7VdANuy999RieSGHcrhRxsPwcOac7k3BneJAayR0/Gutr26E/9E9/MAi1xUnG
	KVurGkLTZciats+79ac8/ecE9LXpj9Q=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=iKUVOCam;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf18.hostedemail.com: domain of "prvs=6980ef5b6=zcgao@amazon.com" designates 35.155.198.111 as permitted sender) smtp.mailfrom="prvs=6980ef5b6=zcgao@amazon.com"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1788319026; x=1819855026;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=1nCArtEkFHsetVE9HyV3SWkRXMjEedc6y2E/MROxKuc=;
  b=iKUVOCam4bKQoaCPBOqJTMEAdnEFfxmz5NbCPjjr0l+g6yGHVhtLvosa
   BteleWBlYjuOlH3JsfkGq9qkvTwNNi9C7LPLYlx5uRHHMULu0V5TCssTV
   dRdHCzUNf4u39sZQkANcZ8WXwGIhHNpbS/pXEBQvGe3Vhrid/2ZRRWqJR
   cvkAybu21aGxHBOESibBFPIgAl3vsjK8s8i3OpJmxHGThknmu7OZidFfA
   lmoGR3PGVOrIUUKg3AHPVjLwZ4yvvxEg7lYT210fN+gYE7nEm/wp3spjf
   KFKmdoVIFs3u36s3sPqtwk+J7CIDKFYnwxpzgxjlsIlvPygg5zKIdPYc2
   g==;
X-CSE-ConnectionGUID: ddspb9w1RqWyZOaLdv6KsQ==
X-CSE-MsgGUID: K6gsVCLcS5izi2wOuZbiyA==
X-IronPort-AV: E=Sophos;i="6.25,257,1779148800"; 
   d="scan'208";a="27466435"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-009.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 02 Sep 2026 03:17:03 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:12458]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.48.113:2525] with esmtp (Farcaster)
 id de3e0a65-3892-4861-a6e8-836a9a4f846d; Wed, 2 Sep 2026 03:17:03 +0000 (UTC)
X-Farcaster-Flow-ID: de3e0a65-3892-4861-a6e8-836a9a4f846d
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Wed, 2 Sep 2026 03:17:03 +0000
Received: from 6c7e67c92ceb.amazon.com (10.187.171.39) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Wed, 2 Sep 2026 03:17:02 +0000
From: Nathan Gao <zcgao@amazon.com>
To: <sj@kernel.org>, <akpm@linux-foundation.org>
CC: <damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <baolin.wang@linux.alibaba.com>,
	<david@kernel.org>, <ryan.roberts@arm.com>
Subject: [PATCH v4] mm/damon/ops-common: use a page-aligned address in damon_ptep_mkold()
Date: Tue, 1 Sep 2026 20:16:55 -0700
Message-ID: <20260902031655.84721-1-zcgao@amazon.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.171.39]
X-ClientProxiedBy: EX19D039UWB002.ant.amazon.com (10.13.138.79) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 38EBE1C0003
X-Stat-Signature: xhphfsueji1jrxbppyz77wekrat4y85t
X-Rspam-User: 
X-HE-Tag: 1788319026-513385
X-HE-Meta: U2FsdGVkX18DTsyCOkac09lZSDQX85qSXNkreCFle4iyeQtruUg4nDPH7clbR8Z+ZpgDewGiwwiYTVfI5NI5SUSQQPs4EoePGimGz/57OFnoAxxvwGHElGCSktRa+BsGVfccJMcJRZQQd24PNtQLWFwpfASJ2B7fOhhPfK94huNGmonPTgboE/UWyKGyd4AOGolvjpYFJVZ2KEkr7wrp7qclJSsUFbo62XN0tRvJCNuWyij8qgVGq8P+VFWwQxSjhhTONVgLt+ul41pA0SoWAvHlylNFnaXmfpy8fGY0p6jR+tpQrZobMIUUN8EnIUQuI4OAkI0HtvMIAshjpCn4afjoOSrUnOBDqh9y6WLvUooYRSx6/dCMjg8IKSjYxX4C8rhmkKVQwVr0CnGa2NmFNJAEpVQ72DiAsLBUOlHWhDsOoBYrqUwr+XD2otdj/bERNdG7qgTyEPuF1M0Hs9Cmu6FFV0YK/jnA2eHHIAdZABOT4ER4ednPjxBzf0tbs3LUYPuahS603L9sE+2e0GDMk5B3iUnFbMVozeMbp7NbnyxhnENVz8XNMFOyC9EA5vwyje+sMBp2ufNsdonmGTHIhFc2ghsQtEvkj3EuuRq429f+znmwny0Eot6QnfqV8YJ9mOL+m/mJZIxGDMM/PYe4Sl1WzuE5Bv2GT1ciNsl0PIqNcKJdwOyvKAgvCTkk8WOyBSSdVJZK1VnxPmc2D16tUAaGEIqQ3zlCCNx2/Lfetlmy/HBlO2n9DNN2UIch/vfLKGG7Y/wOz74E4HvA30CslFt0P0dx49fk4qp/YnKI64Md1gcxntGf+XnzDWDrOGAqOqjDLusgRyvSS3LKbdGi6s01DK6YLklUSK39DGQVO/RqCnFIB+jMA8dRy25JA/vms0dY6ujtOer4VpqjxrCWNKeG07sCq4DsdLVzU4L4hcCEacnRpPTUdKddwPGjFtTj2ZAlvTZQgWFeDH5WQCK
 mjH6T4W+
 901v8UJjC31A9/KN+xO6aYdb6slNylocV4Ra/tXzPBYWlYmfFIMbaR9MT+lnPad0Pa4Uxfe81a+OrOQZGC5Hgq6VHJOpDPJMTZzeS+lM1+tqjtPsQ8gAFeVkala9496UIaAYbiyTdZ/fpqieabUxHYIMX3bQLiAc92S/CVOTkFC0jeopx8iruXAbNA80QU4/R73NjQ57RIHm5ryMMjg5uInrY2mgoJSFUF7xi4iNn48RlCskRt05vLEixazf141PGuXhagVG/yZeYvyCQThO7IzKRX+RYQ8aDC0n6N32ImkpQ8ytdbKvF3gEIN1xFOMUJf2ZISf+v27uzDJ+MxyiRI7OWA9E8UwjZ1mxBaOl4dYDyTMpbSqwxfnrHOLYbLWtrtUZlhB+5wNoa+b9zpjeJNL4EC2iLgTo2dAdN/kLZzeWdhoKhlUgY/VpXbxoCqmUpmdLklzpL5wCi2isKqto8Lv1+yzBm81RRCwLk9vRYkXemBKZOIWf8cW/vkF2dkO/8fuhRlbw8o7BB4FHW23dl4+nrjH2RjJaqufliDgNFgJ35mvT7EKoDRJBtUmhInvvH+Z6IIgeEwpNubSHaj9eHfU5woTX4CPaZ74LCk7tEsQTYnYC8Wd76Xs8O2c7Y3zXkC1Rpt7KjxHcMrDhbfC9qcByvoUTAE+0dwk4SSxxl7//opmw5FO4LHzgcDbHs8mDtCne9RAoy/hxnwEI3KMW3rokRlAAxr3odVnp1NzZ7NdkrZhPy9OwVHBqqG/WRrOxmDq/GMVxFMJUEEuZx7O39GsvtXPWEK/1vJjY1KKWsQ9w8d2ROYfsnlWXb9F7W1M0aERlMoY+ZDg5j2DZfKFk5bD+rsK5CYdtcj7B0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

__damon_va_prepare_access_check() picks a random byte address within the
region and stores it in r->sampling_addr. damon_va_mkold() passes it into
a page table walk, which hands it to damon_ptep_mkold() as the address of
the page to sample:

  damon_va_mkold(mm, r->sampling_addr)
    damon_va_walk_page_range(mm, addr, addr + 1)
      damon_mkold_pmd_entry()
        damon_ptep_mkold(pte, vma, addr)
          ptep_test_and_clear_young(vma, addr, pte)
          mmu_notifier_clear_young(mm, addr, addr + PAGE_SIZE)

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

Pass a page-aligned address to the ptep_test_and_clear_young() call in
damon_ptep_mkold(), which is the only place DAMON can reach
contpte_test_and_clear_young_ptes() from. Nothing else sees the aligned
address, and r->sampling_addr itself is left as is, so the sampling and
region bookkeeping semantics are unchanged.

Fixes: 6f0e1142173a ("arm64: mm: support batch clearing of the young flag for large folios")
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nathan Gao <zcgao@amazon.com>
---
V3 -> V4:
- Align only the address that is passed to ptep_test_and_clear_young(),
  rather than @addr for the whole of damon_ptep_mkold(), so the
  mmu_notifier_clear_young() call keeps seeing the sampled address (SJ)

V2 -> V3:
- Move the alignment into damon_ptep_mkold(), instead of aligning in
  damon_va_mkold() and damon_va_young().  The ptep_test_and_clear_young()
  call in damon_ptep_mkold() is DAMON's only path to
  contpte_test_and_clear_young_ptes(), so damon_ptep_mkold() is the
  closest place in DAMON to the function that requires an aligned
  address (SJ)

V1 -> V2:
- Align inside damon_va_mkold() and damon_va_young() rather than aligning
  r->sampling_addr itself, so that sub-page sampling addresses remain
  possible for future non-PTE access check primitives (SJ)
- Point Fixes: at 6f0e1142173a instead of 3f49584b262c, since the
  unaligned address was harmless before that commit (SJ)
- Describe how the issue was noticed and what it does to the kernel (SJ)

v3: https://lore.kernel.org/all/20260901201001.33271-1-zcgao@amazon.com/
v2: https://lore.kernel.org/all/20260831221151.50561-1-zcgao@amazon.com/
v1: https://lore.kernel.org/all/20260827193821.46115-1-zcgao@amazon.com/

 mm/damon/ops-common.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index fbda70d8ea4d..8fc61d06d358 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -61,7 +61,12 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
 	 * device aspects.
 	 */
 	if (likely(pte_present(pteval)))
-		young |= ptep_test_and_clear_young(vma, addr, pte);
+		/*
+		 * Arch implementation of ptep_test_and_clear_young() may
+		 * require aligned @addr
+		 */
+		young |= ptep_test_and_clear_young(vma, PAGE_ALIGN_DOWN(addr),
+				pte);
 	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
 	if (young)
 		folio_set_young(folio);
-- 
2.50.1


