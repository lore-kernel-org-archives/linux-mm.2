Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB280C61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 20:10:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B69E66B008C; Tue,  1 Sep 2026 16:10:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B1AD16B0092; Tue,  1 Sep 2026 16:10:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A312B6B0095; Tue,  1 Sep 2026 16:10:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7A4266B008C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 16:10:14 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6C08C4052C
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:10:12 +0000 (UTC)
X-FDA: 85166285064.01.D2C040D
Received: from pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com [50.112.246.219])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2257B20009
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 20:10:09 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=kBrajpUV;
	spf=pass (imf13.hostedemail.com: domain of "prvs=697d64fe3=zcgao@amazon.com" designates 50.112.246.219 as permitted sender) smtp.mailfrom="prvs=697d64fe3=zcgao@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788293410;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=VMfxCWDvZUXyWirDiYxrNIEcjCW+/otHqEMZLJ61jvw=;
	b=Lo3PdW5k9rHfd/OVAXdPZPRcTXIGyt8wETwCKDMuhoRXAvRIk+HqybW8OoVg7sjL+g7Cwy
	9q95JhXftizPufST1x3hyKpWr3LeO8bMwopO+xUpHS/6U4UXol+1EGlod82H5bbwO2nKQt
	OWm4A1KgUjkE2iiZmO6Xcl7zWmpHwaQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788293410;
	b=hWdGz/+qgZM+nIF1m7k6r1erL7eGAE99aDbbHOBN1P99rjeD0Fmk/8MtX3xEGr+MqzVJZa
	UhAKoSlsMICqX/RDpRKKpp3v3HpgefB+wz4R1HVBwrb5yXPD2zYFN/2rr60zSGc3ofmCb0
	/WcnNGN9b51D3YIzibUtdWDp1lYRP4E=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=kBrajpUV;
	spf=pass (imf13.hostedemail.com: domain of "prvs=697d64fe3=zcgao@amazon.com" designates 50.112.246.219 as permitted sender) smtp.mailfrom="prvs=697d64fe3=zcgao@amazon.com";
	dmarc=pass (policy=quarantine) header.from=amazon.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1788293410; x=1819829410;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VMfxCWDvZUXyWirDiYxrNIEcjCW+/otHqEMZLJ61jvw=;
  b=kBrajpUVvSsx2h4Fcf6Gtzu3tRBmpTD3hOBgK+AeCuRTSW/CIi4wxSMg
   R75P7ejRJUubQmFFtStsSt9Gd4QBOn4K0cFODeqhpMLiIn/ZddnL7+WiM
   qXhIyC/UcK63rBlirgGwbiJE91JFfXLq/t6et3lYqT+5gu9fFMT/kHWIZ
   od+CKJ88cGeAJqxIEvsEyiTW2ecLdCbH48j+l2eoFeVEMn0xsdY3Pr6Er
   4wKNILrclinL+q5+f+x2hgoA6CT99We1r2VC2qRd662MWEQJCY22rmOVL
   7AmkNxy6VN3+NOm/V7zVgGbThlCk8XiYKqdHZ8HWBKRBS55Q6TRZkXq/D
   w==;
X-CSE-ConnectionGUID: beGJdFdaS2KdmjdOvu7Tmg==
X-CSE-MsgGUID: A0hYJfScQiuZ8z7QG74jLw==
X-IronPort-AV: E=Sophos;i="6.25,256,1779148800"; 
   d="scan'208";a="27326812"
Received: from ip-10-5-12-219.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.12.219])
  by internal-pdx-out-015.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Sep 2026 20:10:08 +0000
Received: from EX19MTAUWA002.ant.amazon.com [205.251.233.234:18292]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.46.234:2525] with esmtp (Farcaster)
 id 3a513eab-567e-4f41-a68c-77fdee66390a; Tue, 1 Sep 2026 20:10:08 +0000 (UTC)
X-Farcaster-Flow-ID: 3a513eab-567e-4f41-a68c-77fdee66390a
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWA002.ant.amazon.com (10.250.64.202) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.45;
 Tue, 1 Sep 2026 20:10:07 +0000
Received: from 6c7e67c92ceb.amazon.com (10.187.170.39) by
 EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.46;
 Tue, 1 Sep 2026 20:10:07 +0000
From: Nathan Gao <zcgao@amazon.com>
To: <sj@kernel.org>, <akpm@linux-foundation.org>
CC: <damon@lists.linux.dev>, <linux-mm@kvack.org>,
	<linux-kernel@vger.kernel.org>, <baolin.wang@linux.alibaba.com>,
	<david@kernel.org>, <ryan.roberts@arm.com>
Subject: [PATCH v3] mm/damon/ops-common: use a page-aligned address in damon_ptep_mkold()
Date: Tue, 1 Sep 2026 13:10:01 -0700
Message-ID: <20260901201001.33271-1-zcgao@amazon.com>
X-Mailer: git-send-email 2.50.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-Originating-IP: [10.187.170.39]
X-ClientProxiedBy: EX19D035UWA001.ant.amazon.com (10.13.139.101) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Stat-Signature: xrdo3wcuk7sw4xuj4ku93yagjuare43k
X-Rspamd-Queue-Id: 2257B20009
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1788293409-722597
X-HE-Meta: U2FsdGVkX19zu9pkXZTo0W+NVzUk8kGDh5CArfqAYIhV82SSo0n15nrFYZ8gsWerXgxbLXo56dAZ7YcytKaDGNI0JiTgAYLqcxBTrcqebkH1B51MwlLKRe6eMnLF1JXgrHt+x5nhMT77AI1j+Ndkh0STD/Q0OHCTcNyCNGohqda6zi4ldaZzamcL5+eguYPWZP2M31+aHAKrOCJq19yDuDqtRgm5qjusI1sqFlky/R55K1hhoHJQ5lWmeYsw8e6DPHdOCMzRHEstTeLlj2//ZY7QBmOfF1jGoN0JlRP/qd7UDR5DrtJpZ0K0jdO0vqPeLygAop3dwB5FxAesGr156L+bHlPftbwPxaj6ZZ3zAmhkJRbJierKBpuEzJVaja7vH6JDUpr6CtLWNcQv0gSN2cJRmTdsZS7aBiRj+UAGLJL93UAqWS8q96y/p/Pjaqq1uCNr07lByEqUgf0l/eF1eqeoQ++Voe4UtK9ZcMmyDODM75PePku3AdyC/63HdSqSAI5yY9YYvmljMyU3qPmhDylkW44xRb2x+ogyxVPbm7Ldw0Hhu+srBVgZbLoNfcR3pnC/ZKSlU4UGBtWbWpMquundjwYZumg8xFVcS+Cfzi2LOA7sr8Pa7lt/M7Ls36lErAMuh5inqpuUYBH8reWDou6IEEfruVS9uJkniTccEc3LXEJKGvIq2tQh12Q/Eae5HLy7WJnpIyNC/RW4XKG4x9ua+G78L3I/K0Nzsx/S5kSuHybwFT5p4y/BcjucrhpzViVEfav5px7JAbFyt9xsKwQGA4RA3mJSK8rn94SjLGYtklDM/Ek/5ZQkMj2+wC0gfKnSJz9rBsJhKoMZgdSHJCfdagGrtPH/drN/tp5PoajMsHRFgg774JAj6kxlFjrFb4sGsNeR85wAz23Cib7r354PMGzsraALXo5aa0FQVAeN8Rad/5Fc/0XHjqzID6xzh3gcQStV4f1wGyf43jZ
 kXfgA9Br
 IgtxgsDrzYokVc6xzwxWx8fe3CAdd4GRUgLpeDinsj+z4XVMChrs2qJL0rZI5HDY71UV0R+WpMwQkcEvZdjjiP2pn0I9GWy0F3aw4vBI9ye0moHJWHAd2pHLbJhKUGJpkC/oW1plHIWHHr5cJRMX1V/t1o0Y/WqRGT72kM3CFr9mSUdZd0fOKrN1dPXOqM42O+eUd20ZSjTkrAAjXEXmQ+sZ17GC/AY4tYlUvaTnA01EbTFi9j6lLy4Ba9T54bj2Ut0OuJ8kFrQOUoUw9SmElJKAZ9VSlnHbAGJs3s6pjywr69y/8thYotkKpCXqMJnVjoR7RPsXOdEjDGhWBUS5KeYeeoDSBRX+P+U7NC6bP+o33pDECrpewAURlAxdgQT14LLea1/deVDZQ+fS72tOUJaNhRqrHeL3M4iP2Vc4hOhPbP3r2vH68Un8gTa/WGZHABD56IbcySuEYhoMgofa4E35TgTmjHiAJblMT6jvhbRQAAL2pZSpFPJYjeBZCQCoEa/z+U///zvHm9jZVJ55B01cQ1Fu5MUdOSVJ1J/MMpdoRLHbitorfxwiYCdEpin/WAMzw2ard/sDLMU9/Jyrcf+Dbc8eM9n9/Kw3DjiYtOuqyI1BXbMCawVZPFRyQwz9Ey6oG4yHmC068hM1TJ71u5jTpIE+qhhw4WCGQ9nceU2UGjOA7rW+3Vu3y+jMQzNOVqTyrKoPxH9iUyE2lhcUCS8lQVzoSLHwEgN69sKWI07FB2NHwDPoxRsQUIvopd8lRf2L9euMYeO8tDqiVJc/21W9naoSDw8BGisvMZwVBJVPvqfhWRskMY4Lx7vZBjnXBXC+YNYCK7czDIVaYFgpEYwA6vliPMALR2Jdg
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

Align the address down to a page boundary in damon_ptep_mkold(). Its
ptep_test_and_clear_young() call is the only place DAMON can reach
contpte_test_and_clear_young_ptes() from. r->sampling_addr itself is left
as is, so the sampling and region bookkeeping semantics are unchanged.

Fixes: 6f0e1142173a ("arm64: mm: support batch clearing of the young flag for large folios")
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: David Hildenbrand (Arm) <david@kernel.org>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: stable@vger.kernel.org
Signed-off-by: Nathan Gao <zcgao@amazon.com>
---
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

v2: https://lore.kernel.org/all/20260831221151.50561-1-zcgao@amazon.com/
v1: https://lore.kernel.org/all/20260827193821.46115-1-zcgao@amazon.com/

 mm/damon/ops-common.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 0bcad6b1e5b9e..cd8aa08233e54 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -46,6 +46,12 @@ void damon_ptep_mkold(pte_t *pte, struct vm_area_struct *vma, unsigned long addr
 	bool young = false;
 	unsigned long pfn;
 
+	/*
+	 * Arch implementation of ptep_test_and_clear_young() may require
+	 * aligned @addr
+	 */
+	addr = PAGE_ALIGN_DOWN(addr);
+
 	if (likely(pte_present(pteval)))
 		pfn = pte_pfn(pteval);
 	else
-- 
2.50.1


