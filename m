Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F30F0606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 07:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=XjsCbxPS
Received: by kanga.kvack.org (Postfix)
	id 1E3B86B0617; Tue, 24 Nov 2026 02:53:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BB206B0619; Tue, 24 Nov 2026 02:53:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D1A46B061A; Tue, 24 Nov 2026 02:53:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CD6236B0617
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 02:53:43 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9FB511C450C
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:44:02 +0000 (UTC)
X-FDA: 85469223924.15.8B150E1
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf28.hostedemail.com (Postfix) with ESMTP id ACC35C0006
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 07:43:58 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=XjsCbxPS;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf28.hostedemail.com: domain of li.hanting@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=li.hanting@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795506240;
	b=a+4TCfXkKwOf1iNXrBXf8wPAHH5b+sz2E2rMOJVGvMsc7xJf8uKPwCgVj9qrTCrWK8cgwT
	MDgJc19kDEqG+zdOr+aJIwbrKHdcDCJv2L+xA3GPwpE3JPluALJrdBAZa4xSJbYOUCFNNV
	gOuj33qmpyT4hoDzxBu8S1cI/aIUl0s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795506240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ThakZ12NW5n+EVxOeLzJgVL3vhX2Gjt4+Ap1QAIpiY4=;
	b=z3zqNsxPXykPfnwkzZih5IRN+0TEp45WlHgnF/ACK6620hly1UU+FQvLYV9pASWQ0fMoyL
	K18Onk2x92ov+2g6sbfBFwLI6+yjO0robv9KmLPd7rW74v/jE483RbeP0nY3pCZEb5LFAP
	mGK4rI4BcXwJr1bnN3ZErmtnT6hB3sc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=XjsCbxPS;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf28.hostedemail.com: domain of li.hanting@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=li.hanting@zte.com.cn
Received: from mse-db.zte.com.cn (unknown [10.5.228.131])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4jYZZ05gNQz5BNRx;
	Tue, 24 Nov 2026 15:43:52 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1795506232;
	bh=vAlgFZAej5uUyO+1shCvosasemEXAe+b1UMxZEvgWR4=;
	h=Date:From:To:Cc:Subject;
	b=XjsCbxPS3YhpKqsXjlSaTYDT2Oo9p8qxF2I+n8sckYqEixCCDVL6/FW81dac8DbOH
	 OrpZrjNB2mfy3FANK3OrY7sMIrDrUZwwczJhqclo+bFY1YlK2GWYNl+lDmnUqELIDS
	 TCkZSlGbmIckhMAIJ+HWLFnjSoqRIZVgnXbliYwvXc+TFLVHCNpm2lSqVi8SW079Uh
	 7aWvMkWU17gS0EGqM8/oqjoXN5mI8T59OaMIW+WIdHVeHAxeKWsoqyBhzfrm3moXU2
	 GPXUddrKLdca1cqm/i43JbrcX1smiLIrFvWj+1RxC9f4if+RXKs00CsFp+2VyL1S4q
	 nseWqgDWmyCxg==
Received: (from root@localhost)
	by mse-db.zte.com.cn id 6AO7homY042860;
	Tue, 24 Nov 2026 15:43:50 +0800 (+08)
	(envelope-from li.hanting@zte.com.cn)
Message-Id: <202611240743.6AO7homY042860@mse-db.zte.com.cn>
Received: from njy2app01.zte.com.cn ([10.40.12.136])
	by mse-fl1.zte.com.cn with SMTP id 6AO71T83036888;
	Tue, 24 Nov 2026 15:01:29 +0800 (+08)
	(envelope-from li.hanting@zte.com.cn)
Received: from mapi (njb2app07[null])
	by mapi (Zmail) with MAPI id mid203;
	Tue, 24 Nov 2026 15:01:31 +0800 (CST)
X-Zmail-TransId: 2aff6b05364ba66-4f927
X-Mailer: Zmail v1.0
Date: Tue, 24 Nov 2026 15:01:31 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <li.hanting@zte.com.cn>
To: <palmer@dabbelt.com>, <pjw@kernel.org>, <aou@eecs.berkeley.edu>,
        <alex@ghiti.fr>
Cc: <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <akpm@linux-foundation.org>, <rppt@kernel.org>,
        <songmuchun@bytedance.com>
Subject: =?UTF-8?B?W1BBVENIIHYzXSByaXNjdjogbW06IEZpeCBzcGxpdCBsaW5lYXIgbWFwIHBhZ2UgdGFibGUgYWxsb2NhdGlvbg==?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-db.zte.com.cn 6AO7homY042860
X-MSS: AUDITRELEASE@mse-db.zte.com.cn
X-TLS: YES
X-ENVELOPE-SENDER: li.hanting@zte.com.cn
X-SOURCE-IP: 10.5.228.131 unknown Tue, 24 Nov 2026 15:43:52 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6B054038.000/4jYZZ05gNQz5BNRx
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: ACC35C0006
X-Stat-Signature: i58aaiupyyupzfuoqfy4afwxhmzrrqm8
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795506238-213819
X-HE-Meta: U2FsdGVkX19UvjUA5h9h/7wYx9C0c9npP/4HLJgNo89/Or1sidhdnLZRNNumn/BdGDV6wJ/PVlUMjcpknE/QOGAk+6s1up133EyPTzLY6M4ljy7B/rS+qKH8lG08qSiDlDdM87rcrz413qiYnDyTnEj3ZbvDqvP4kH2axdrjFFR7wgjkzSeJZeUKSckms3qMkPhTsIXzFTjIP/ybIg5BosYEf/j5J1gtiTlk2bwdidkAmof5YCeaNL34aF32yeRhHWNRC1dEuZorLHm4BYUutxJWvcv2Mp5/5CtBd1+TV0EbIPgNYCMyZ89kbiu5ybiFcaFaLDaD0XwtqtisI3h5SbMclgXayZ66foRpNK6+4t2VRQeZKTusRqQloaTXAyn4Jniy/PSuAaRqGlEJh8x70sMv4nxtIRN9ose51ubUiSUCNnonakNOmOCJ/Sw/LVR3VH5khFW52QppViGCgsPJRtDD0lU8iii/KlyUEgRvmOnYKcuOeeoFXyXKED6Bu83aTKJJ6N2z7BmX1ejhT2EYHE+l8plJTLnOn94LW3Axa7yWfTa7B39BixEgmeulXhlxQah65Tzhjr7y8ecwAIy4JdLv2+qNw3LVW+Wgkt7uPXYH54wyP4JUZEMblOjhDsWWEyT8424kvSVLPtCdfatjrfpP3dz0+pyFdXU99fmwnTFivMG/69EzoATiK75hFqtnQyWKaxCGx6ch5dFbItGsSmd06Mg87W5fiFWEIeL/TQCvTe02b/8nDjmgXefRjRe1vj/U2zJ+jX6xolFivkuEnfq9PEhCZeENnizcvkf9cPTg1hLDn5MpALAhbMn6UdZ7hPMwljoaualx6jLzHGNzXBCC6PQ54tTnE4rd0pgg1MeCkUJddIpQoRMbWGCbEtYFH5EkV67XSAH5qD05A5iObkN5F4Nzapmr0IPlFwrqq85SXcwJkhx1kqlZ9EsHjDg6EyTbcpj5RJKSZHfWhyP
 gnT3OsaQ
 Tl5Oshb8M9skWQG4XYLGOSfl7+6zM3qx21rHdQhPEHR/w4qP6sQhRU+WOjRFTfgsJWlHJanb5QRLZmXXIrnrD+Q055xk3Ulpiks9VMHZ+qyvo1pflgky3Bhsr6P1I/Lu+pX8sorgeKSjcRMYmNbHR9zx0GeKsAhXveMvdYQfCURUtLYxtptwVJMnojvzEQMnD4A8p53lXsCCH+E23g3rG/9JwCdB88LCir5ZVyDMD62aINl+tDtxFaU/u5eFiYEw9ZDiKGmupYv2ddVjjZFqYceC8Be4tynj4voZ+PB6xO+KGapVLDTy+MzS7GtlpVdYqrKpX5rlnhjX2YO0PkloMsXlzhVWz8J81wtMA/ApL/6ba3WQERLsscjmmuHc4a+ukvwOqd3YggfT3v7f3bTOxfPiVR8owCxmAsTxba2D7dywSxtdg37bDXeAgnZSHI9FIMkvKIIUY2fQxBBvWTC6uU3c/KK0K+1wZFFksLYlwUmeBM8qBFGrcn5NuuXPgorl/fxnEpIVKI2QP/qU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Commit 9e4a3ec3411b ("x86/mm/pat: Allocate split page tables as kernel
page tables") recently fixed a latent inconsistency in the x86 CPA code
(assigned CVE-2026-97525): __split_large_page() allocated the new PTE
page with a bare pagetable_alloc(), bypassing pte_alloc_one_kernel(), so
the page table constructor never ran and the resulting page was neither
flagged PG_table, nor accounted in NR_PAGETABLE, nor marked as a kernel
page table.

RISC-V open-codes the same pattern when splitting the linear mapping on
behalf of set_memory_*(): __split_linear_mapping_{pmd,pud,p4d}()
allocate the new page table pages with bare alloc_page(GFP_KERNEL) -
three call sites in arch/riscv/mm/pageattr.c, introduced by
commit 311cd2f6e253 ("riscv: Fix set_memory_XX() and set_direct_map_XX()
by splitting huge linear mappings").

As on pre-fix x86, the resulting pages live in init_mm without the
PG_table flag, without NR_PAGETABLE accounting and without the kernel
ptdesc marking. Under CONFIG_MEMORY_HOTPLUG, hot-removing memory tears
down the linear mapping of the removed range via arch_remove_memory()
-> remove_linear_mapping() -> free_p*d_table(), which releases these
page tables through pagetable_dtor() even though the constructor never
ran, underflowing NR_PAGETABLE on current mainline. Muchun Song's
series "mm: Fix page-table teardown during memory hot-remove" [1]
fixes the freeing side by skipping the destructor for pages without
the PG_table flag, but the root cause remains: the allocation side
still bypasses the page-table constructors, so these tables are
unflagged and unaccounted for their entire lifetime.

Align the three sites with the standard page-table allocation and
population helpers:

 - the PTE level switches to pte_alloc_one_kernel(&init_mm), exactly
   like the x86 fix, and installs the new table into the parent entry
   with pmd_populate_kernel();

 - the PMD and PUD levels switch to the generic pmd_alloc_one() and
   pud_alloc_one(), which already handle the init_mm case by selecting
   GFP_PGTABLE_KERNEL, running the level constructors and marking the
   ptdesc as a kernel page table, and install the new tables with
   pud_populate() and p4d_populate().

No change to the resulting linear mappings is intended; the observable
difference is that split linear mapping page tables are now properly
flagged and accounted, so /proc/vmstat:nr_page_table_pages no longer
under-counts.

Fixes: 311cd2f6e253 ("riscv: Fix set_memory_XX() and set_direct_map_XX() by splitting huge linear mappings")
Signed-off-by: Hanting Li <li.hanting@zte.com.cn>

---
Changes since v2 [2]:

- Install the new page tables with pmd_populate_kernel(),
  pud_populate() and p4d_populate() instead of open-coding the
  virtual-address-to-PFN conversion, as suggested by Muchun Song.

- Reword the intended-behaviour statement: the accounting, PG_table
  state and hot-remove destructor behavior are intentional functional
  changes, so "no functional change" was misleading; it now states
  that no change to the resulting linear mappings is intended. Also
  suggested by Muchun Song.

- Shorten the subject and drop the greeting from the commit message.

[1] https://lore.kernel.org/r/20261008073021.2512665-3-songmuchun@bytedance.com
[2] https://lore.kernel.org/r/<202611230851.6AN8pFDD065900@mse-fl1.zte.com.cn>

Hello,

Thank you for the review, Muchun. All four suggestions are
incorporated in this version.

One detail worth spelling out about p4d_populate(): unlike the
previous open-coded set_p4d(), which falls back to writing through
the pud alias when 4-level paging is disabled, p4d_populate() is a
no-op in that case. The difference is not reachable here: with
3-level paging, best_map_size() caps the linear mapping at PMD_SIZE,
so a leaf p4d entry can only exist when 4-level paging is enabled,
where p4d_populate() matches the open-coded write exactly.

The discussion about deferring this change until free-path work
lands is now settled by Muchun's series [1] being queued for
mainline: this patch fixes the allocation side of the same lifetime
mismatch.

(Note: the generic CPA rework series "[PATCH RFC 00/18] arch, mm:
create a generic set_memory/change_page_attr core" would eventually
replace this code entirely; this patch is intended as a small fix in
the meantime.)

Comments welcome.

 arch/riscv/mm/pageattr.c | 38 +++++++++++++++++---------------------
 1 file changed, 17 insertions(+), 21 deletions(-)

diff --git a/arch/riscv/mm/pageattr.c b/arch/riscv/mm/pageattr.c
--- a/arch/riscv/mm/pageattr.c
+++ b/arch/riscv/mm/pageattr.c
@@ -3,9 +3,11 @@
  * Copyright (C) 2019 SiFive
  */

+#include <linux/mm.h>
 #include <linux/pagewalk.h>
 #include <linux/pgtable.h>
 #include <linux/vmalloc.h>
+#include <asm/pgalloc.h>
 #include <asm/tlbflush.h>
 #include <asm/bitops.h>
 #include <asm/set_memory.h>
@@ -109,23 +111,21 @@
 			continue;

 		if (pmd_leaf(pmdp_get(pmdp))) {
-			struct page *pte_page;
 			unsigned long pfn = _pmd_pfn(pmdp_get(pmdp));
 			pgprot_t prot = __pgprot(pmd_val(pmdp_get(pmdp)) & ~_PAGE_PFN_MASK);
 			pte_t *ptep_new;
 			int i;

-			pte_page = alloc_page(GFP_KERNEL);
-			if (!pte_page)
+			ptep_new = pte_alloc_one_kernel(&init_mm);
+			if (!ptep_new)
 				return -ENOMEM;

-			ptep_new = (pte_t *)page_address(pte_page);
-			for (i = 0; i < PTRS_PER_PTE; ++i, ++ptep_new)
-				set_pte(ptep_new, pfn_pte(pfn + i, prot));
+			for (i = 0; i < PTRS_PER_PTE; ++i)
+				set_pte(ptep_new + i, pfn_pte(pfn + i, prot));

 			smp_wmb();

-			set_pmd(pmdp, pfn_pmd(page_to_pfn(pte_page), PAGE_TABLE));
+			pmd_populate_kernel(&init_mm, pmdp, ptep_new);
 		}
 	} while (pmdp++, vaddr = next, vaddr != end);

@@ -149,24 +149,22 @@
 			continue;

 		if (pud_leaf(pudp_get(pudp))) {
-			struct page *pmd_page;
 			unsigned long pfn = _pud_pfn(pudp_get(pudp));
 			pgprot_t prot = __pgprot(pud_val(pudp_get(pudp)) & ~_PAGE_PFN_MASK);
 			pmd_t *pmdp_new;
 			int i;

-			pmd_page = alloc_page(GFP_KERNEL);
-			if (!pmd_page)
+			pmdp_new = pmd_alloc_one(&init_mm, vaddr);
+			if (!pmdp_new)
 				return -ENOMEM;

-			pmdp_new = (pmd_t *)page_address(pmd_page);
-			for (i = 0; i < PTRS_PER_PMD; ++i, ++pmdp_new)
-				set_pmd(pmdp_new,
+			for (i = 0; i < PTRS_PER_PMD; ++i)
+				set_pmd(pmdp_new + i,
 					pfn_pmd(pfn + ((i * PMD_SIZE) >> PAGE_SHIFT), prot));

 			smp_wmb();

-			set_pud(pudp, pfn_pud(page_to_pfn(pmd_page), PAGE_TABLE));
+			pud_populate(&init_mm, pudp, pmdp_new);
 		}

 		ret = __split_linear_mapping_pmd(pudp, vaddr, next);
@@ -198,23 +196,21 @@
 			continue;

 		if (p4d_leaf(p4dp_get(p4dp))) {
-			struct page *pud_page;
 			unsigned long pfn = _p4d_pfn(p4dp_get(p4dp));
 			pgprot_t prot = __pgprot(p4d_val(p4dp_get(p4dp)) & ~_PAGE_PFN_MASK);
 			pud_t *pudp_new;
 			int i;

-			pud_page = alloc_page(GFP_KERNEL);
-			if (!pud_page)
+			pudp_new = pud_alloc_one(&init_mm, vaddr);
+			if (!pudp_new)
 				return -ENOMEM;

 			/*
 			 * Fill the pud level with leaf puds that have the same
 			 * protections as the leaf p4d.
 			 */
-			pudp_new = (pud_t *)page_address(pud_page);
-			for (i = 0; i < PTRS_PER_PUD; ++i, ++pudp_new)
-				set_pud(pudp_new,
+			for (i = 0; i < PTRS_PER_PUD; ++i)
+				set_pud(pudp_new + i,
 					pfn_pud(pfn + ((i * PUD_SIZE) >> PAGE_SHIFT), prot));

 			/*
@@ -224,7 +220,7 @@
 			 */
 			smp_wmb();

-			set_p4d(p4dp, pfn_p4d(page_to_pfn(pud_page), PAGE_TABLE));
+			p4d_populate(&init_mm, p4dp, pudp_new);
 		}

 		ret = __split_linear_mapping_pud(p4dp, vaddr, next);

