Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D8A7606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 08:51:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=zte.com.cn header.i=@zte.com.cn header.a=rsa-sha256 header.s=z202610 header.b=rcxxw4Af
Received: by kanga.kvack.org (Postfix)
	id 4BB966B05B2; Mon, 23 Nov 2026 03:51:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46C396B05B3; Mon, 23 Nov 2026 03:51:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35AFA6B05B4; Mon, 23 Nov 2026 03:51:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0E5FB6B05B2
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 03:51:28 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 355C41C425A
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:51:27 +0000 (UTC)
X-FDA: 85465765014.08.1E2B945
Received: from mxct.zte.com.cn (mxct.zte.com.cn [183.62.165.209])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1831E80004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 08:51:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=rcxxw4Af;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf02.hostedemail.com: domain of li.hanting@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=li.hanting@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795423885;
	b=s5mtSPMczgNj+kTGoYGP8EErgVuwn7/33W3IUl2/8GhwZ9aTSzJh+UxNEqZUUd6fMbLdGi
	s2skHuZ9ykU1JYkUYpM3P9sWTb7SAbJWyQjoLFS6uC99lJJ/eSnkqwrOPjxWzmTyLA83w0
	u3+hRDt6Zf7URDK1hSWxCZm4bZS4z2I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795423885;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fpMnrjeY3CBP7QOeCEWZf+xXHJZqk25BVg5i//F7Edw=;
	b=qOU4ZMButHsMkXQMPFl016K2/1wHmykgbvzhxyfgp0FXA7Iyg9LgjJBUP8qn7gj4Lkp7H9
	C7KJMqgcueBidaRGO1TxKQVclE+kxQxx51Zl5dH23nMI2Mvn5USOSyMu8XDqEWDuIGX2xb
	wf6NwXnThFQmZ17UfWKCU56DABpnHfo=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=zte.com.cn header.s=z202610 header.b=rcxxw4Af;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf02.hostedemail.com: domain of li.hanting@zte.com.cn designates 183.62.165.209 as permitted sender) smtp.mailfrom=li.hanting@zte.com.cn
Received: from mse-fl1.zte.com.cn (unknown [10.5.228.132])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxct.zte.com.cn (FangMail) with ESMTPS id 4jY06C6Qnfz5B7RB;
	Mon, 23 Nov 2026 16:51:15 +0800 (CST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=zte.com.cn;
	s=z202610; t=1795423876;
	bh=cVG2XoK0ElJXi5aZovzr665A2Cep3ko3KkzHGkB5Ikk=;
	h=Date:From:To:Cc:Subject;
	b=rcxxw4AfncxsHVJ0HXC25OV2DcV4UaiLgYXBLt7TVvyXThhSFyFtqjqDyMbHFFLEW
	 IHWKczxIrUCKBFAi5Y/yjJWWLyS74WZrjEdMBTRxszKTcah3Jsxl3/XjP656XGK/8f
	 N5QCBoVRDQNpNBtJeV2avhW29sTmEju0Dzf2V0xuyv6/bSC9hw/RAFCGgvpKKTjdnl
	 sjjKYqvdR0Bn9Q7M9FUcB0a5N4M1bRrt59yAUHd3LJ1lhE7phS00MjeOUHKjRKDolx
	 J8QckCEUvuC1AZAWco76sw9d9Wxx+T9rGZ/SwUnf/7ss9v+Q9D8SZIrzG2la8nUY5b
	 NHaQyRubQceOQ==
Received: (from root@localhost)
	by mse-fl1.zte.com.cn id 6AN8pFDD065900;
	Mon, 23 Nov 2026 16:51:15 +0800 (+08)
	(envelope-from li.hanting@zte.com.cn)
Message-Id: <202611230851.6AN8pFDD065900@mse-fl1.zte.com.cn>
Received: from njy2app08.zte.com.cn ([10.40.13.206])
	by mse-fl2.zte.com.cn with SMTP id 6AN7vv0x060409;
	Mon, 23 Nov 2026 15:57:57 +0800 (+08)
	(envelope-from li.hanting@zte.com.cn)
Received: from mapi (njy2app08[null])
	by mapi (Zmail) with MAPI id mid203;
	Mon, 23 Nov 2026 15:57:59 +0800 (CST)
X-Zmail-TransId: 2b006b03f20744a-c5a8d
X-Mailer: Zmail v1.0
Date: Mon, 23 Nov 2026 15:57:59 +0800 (CST)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
From: <li.hanting@zte.com.cn>
To: <palmer@dabbelt.com>, <pjw@kernel.org>, <aou@eecs.berkeley.edu>,
        <alex@ghiti.fr>
Cc: <linux-riscv@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <linux-mm@kvack.org>, <akpm@linux-foundation.org>, <rppt@kernel.org>,
        <songmuchun@bytedance.com>
Subject: =?UTF-8?B?W1BBVENIIHYyXSByaXNjdjogbW06IGFsbG9jYXRlIHNwbGl0IGxpbmVhciBtYXBwaW5nIHBhZ2UgdGFibGVzIHZpYSB0aGUgc3RhbmRhcmQgcGFnZSB0YWJsZSBhbGxvY2F0aW9uIEFQSXM=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl1.zte.com.cn 6AN8pFDD065900
X-MSS: AUDITRELEASE@mse-fl1.zte.com.cn
X-TLS: YES
X-ENVELOPE-SENDER: li.hanting@zte.com.cn
X-SOURCE-IP: 10.5.228.132 unknown Mon, 23 Nov 2026 16:51:16 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6B03FE83.000/4jY06C6Qnfz5B7RB
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 1831E80004
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_PASS,SPF_PASS,UNPARSEABLE_RELAY
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 3wn1omwb34b7wtkjyey39sxwny3ujzgi
X-Rspam-User:
X-HE-Tag: 1795423882-142943
X-HE-Meta: U2FsdGVkX1928K3ji6GvlC97Y0XsNGO1HJ/WYvoc4DyoRYli8rr4YodCSBEL6CDpUdHEt7jK0wEAesWvT+fUXxAsVGnDgtAngg+LyoEyIFoJDJAnY7Q5dIocazLPpK6zcPRgNvOzJKwgs0mopd02MhNBpJz/rYzHeEdwGDpABgDQWKXG1gBhcEzaXOezlmhlYBncwF+xRyouGoMeNINq4QY/POqqltoiMsNXG/bsIzAv4LLw77rwcr0anSanP0UuqadhkWN4OVJzZNr1fPc8hOnHEA8WMTzrt/URUliLUeaQpavqnpA7KWRK2XpwxW6M7oQOzF9sct1Y2KXlWMLRjSa0YKeP42nEIq1IgZ6Gt8lPttWse3OXmi0CaxMWNHIoxojDXWDdxg8jnmt3Xo9L1le8dRnowmXeKRm9UQBu5BWp84/TRNDB5F2VDYFaWBjgwevjxx9qb04ez1LKXFZku5ORgTASHkFqWwaXEHImi6ULA0w7RLG+yQ1VuAGr7+uNZAPzf3qovWcVIzeKO8IHeVKT1pE0oTqORhzd9rIJRaR3jUiUgo0OngsSMcVXKEyUgS/QdgyASzpVY8cQPGSQKosnC6Yaf/GeMj+pzOFiuraSFXbpSpwZtY6aP8VOXyusMDyFd2QOyhWQpaSYdQlv8WCZ9Jv66Xq6ePc7ExxEntUNt3y2Tv3edYAiYglyaJogKB3Icgs7AMoD/3eXpXBqdmnxWSaIqQ8aOCWqKhB8DcVYwrkEDuQ6zGI6keSYwVgCzCRIlnj2tAlvEGik0TdqdIcKOjdWgf+Xh2NtgpTiHbS6yFY1NXasyyy+74lkwwRnkL3zi2Fu0tYte4/3BoeUoQI1ZIfrgcci5KPP+fIyB3A9oSlPe+0Ggh5UhsJt82zJnARiQSn8TLdJ6W4s4bTasMNEJaLucmpWiCBJggwpECVhDQQbQ3JNgl1Pojxpe11Zm5YgKqI6UDn+i1JtDkY
 Sk7IcQYh
 SxS8EwEoJw4pGgoZ0mQBs2RL+yA3jXdHHCWL/RA05yL1/zNOfGW6wxMYWGUEMCfcmUN15VaTfjjC92uaITu/1qIc4Q1pDVDEFhEc2DGiS3Yq2U/CEV/ApQe9lN37AuaKp0799xvK3SgmuLexoSJwNBBwgrnDRcyX8AzghytEXjYvW6eLnmlL0t6mBafT9sujxQ1hDax8LJ8nCfL36OdgKFyrwfgksGISVx/0P7DD533UkX5lD/2GGFdzpDFDwvceOOtdVJT1MTGK4gIETI96VmouRIBaoukXTlfQAfItspFRELM/hX8vGy32iGs50uVtX3GMWhsmTKgCcz+wtm7YCyetPHksGm+CnN+h7aisxBcMdMZmQFgkzu7biveqBsparssiK5/hh84rXsx4KDFIgZXg4fR3vLBqe3qFtMYzlYjgyVRkHi3zM6/EknuTeLzZkanGfd/IZ2b3FYWxjGLaWPqKYOyDX3FlVs1p0/vmdZlPTRF5WapGIAcqrhb4aOmssvEzn9LFOCKE4myk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

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
series "mm: Fix page-table teardown during memory hot-remove" [2]
fixes the freeing side by skipping the destructor for pages without
the PG_table flag, but the root cause remains: the allocation side
still bypasses the page-table constructors, so these tables are
unflagged and unaccounted for their entire lifetime.

Align the three sites with the standard allocation paths:

 - the PTE level switches to pte_alloc_one_kernel(&init_mm), exactly
   like the x86 fix;

 - the PMD and PUD levels switch to the generic pmd_alloc_one() and
   pud_alloc_one(), which already handle the init_mm case by selecting
   GFP_PGTABLE_KERNEL, running the level constructors and marking the
   ptdesc as a kernel page table.

No functional change is intended; the observable difference is that
split linear mapping page tables are now properly flagged and
accounted, so /proc/vmstat:nr_page_table_pages no longer under-counts.

Fixes: 311cd2f6e253 ("riscv: Fix set_memory_XX() and set_direct_map_XX() by splitting huge linear mappings")
Signed-off-by: Hanting Li <li.hanting@zte.com.cn>

---
Changes since v1 [1]:

- Switch the PMD and PUD levels to the generic pmd_alloc_one() /
  pud_alloc_one() instead of a local helper, as suggested by the
  Sashiko automated review. The generic versions already handle
  init_mm correctly, which also resolves the first open question of
  v1.

- Correct the severity discussion. v1 claimed these page tables are
  never freed; that is wrong under CONFIG_MEMORY_HOTPLUG, where memory
  hot-removal frees them through remove_linear_mapping() ->
  free_p*d_table() -> pagetable_dtor(), so the ctor/dtor mismatch can
  actually underflow NR_PAGETABLE. Also pointed out by the automated
  review.

- Add the Fixes: tag and move the discussion notes below the tear
  line.

[1] https://lore.kernel.org/r/202611091101.6A9B1Nf3015337@mse-db.zte.com.cn
[2] https://lore.kernel.org/r/20261008073021.2512665-3-songmuchun@bytedance.com

Hello,

One discussion point from v1 remains open:

Since RISC-V never collapses the split linear mapping back, one could
argue for deferring this change until free-path work actually lands.
My preference is to take it now: with CONFIG_MEMORY_HOTPLUG the free
path already exists today, and taking this now removes a trap for any
future work on the linear mapping.

(Note: the generic CPA rework series "[PATCH RFC 00/18] arch, mm:
create a generic set_memory/change_page_attr core" would eventually
replace this code entirely; this patch is intended as a small fix in
the meantime. The series author has said he is waiting for such fixes
to settle before posting a non-RFC version.)

Comments welcome.

 arch/riscv/mm/pageattr.c | 41 +++++++++++++++++------------------
 1 file changed, 20 insertions(+), 21 deletions(-)

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
@@ -109,23 +111,22 @@ static int __split_linear_mapping_pmd(pud_t *pudp,
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
+			set_pmd(pmdp, pfn_pmd(page_to_pfn(virt_to_page(ptep_new)),
+					      PAGE_TABLE));
 		}
 	} while (pmdp++, vaddr = next, vaddr != end);

@@ -149,24 +150,23 @@ static int __split_linear_mapping_pud(p4d_t *p4dp,
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
+			set_pud(pudp, pfn_pud(page_to_pfn(virt_to_page(pmdp_new)),
+					      PAGE_TABLE));
 		}

 		ret = __split_linear_mapping_pmd(pudp, vaddr, next);
@@ -198,23 +198,21 @@ static int __split_linear_mapping_p4d(pgd_t *pgdp,
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
@@ -224,7 +222,8 @@ static int __split_linear_mapping_p4d(pgd_t *pgdp,
 			 */
 			smp_wmb();

-			set_p4d(p4dp, pfn_p4d(page_to_pfn(pud_page), PAGE_TABLE));
+			set_p4d(p4dp, pfn_p4d(page_to_pfn(virt_to_page(pudp_new)),
+					      PAGE_TABLE));
 		}

 		ret = __split_linear_mapping_pud(p4dp, vaddr, next);

