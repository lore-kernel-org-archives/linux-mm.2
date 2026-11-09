Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C4E186082BC0
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 16:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=krRhCx9Z
Received: by kanga.kvack.org (Postfix)
	id 92A196B05C7; Mon,  9 Nov 2026 11:01:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D99C6B05C8; Mon,  9 Nov 2026 11:01:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A5576B05C9; Mon,  9 Nov 2026 11:01:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3CA336B05C7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 11:01:46 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 993101C4106
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:45 +0000 (UTC)
X-FDA: 85416046170.13.B130280
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf28.hostedemail.com (Postfix) with ESMTP id 75290C0016
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 16:01:43 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=krRhCx9Z;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794240103;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=86HOuVQYzJ9HP9T+tU7Glqbpyaws8eMrdwgzBdBZAUs=;
	b=XJWKlIV2ROT8fjqDPIvElpAtDUeLLWHstLkBVAbnNtIMC858uIOCZHo4CPN3ssPtFkDbVe
	4YuNDauEIgBikYKYhVc/p40pvPaiLEKbRNLR6toMG5OzmxS5DYyZeq079pK9UuUNOhheWh
	VxKIY7IPI1FWQOZu/bM+cMRnWpNg69w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794240103;
	b=x9NTgy2Sx/BDfoTEDj/oygY0/w2da2BBS8kCngZU+vP6/FfZEGNidDod3YwrH2EfdQBIQx
	5+gu6vciGv6wycDF0tHGqKUfjRhQcnVokvnhoJsxD3pRsTLBjFn5UTroNiNDV8ZFbwCKF9
	GHLOCQxKKe3W3MZhUHIVUzlFYJIelKk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=krRhCx9Z;
	spf=pass (imf28.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A779F2F;
	Mon,  9 Nov 2026 08:01:39 -0800 (PST)
Received: from localhost.localdomain (e123572-lin.cambridge.arm.com [10.2.208.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C226C3F632;
	Mon,  9 Nov 2026 08:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794240102; bh=ZPX85IlkbQlPgohX2Zyn8cActE8CqgGaqWXBsgZhgrQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=krRhCx9ZXNmvUrrrUz1/ilS8737QW38epYNNuHQ0Flt/e3tmwQPDci92ie11wGuXf
	 2tVtTq99m7eeBgdC7hxFEUFpJjxY/eENnhgxz7dm4akpanIfza8CB3qBJl9tGviSd+
	 hAA06OrcTmHSTG+I8nCb3dtwuuvWKCAyEbY2qwnE=
From: Kevin Brodsky <kevin.brodsky@arm.com>
Date: Mon, 09 Nov 2026 15:58:38 +0000
Subject: [PATCH RFC v10 13/22] mm: kpkeys: Protect early kernel page tables
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261109-kpkeys-v10-13-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
In-Reply-To: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
To: linux-hardening@vger.kernel.org
Cc: Kevin Brodsky <kevin.brodsky@arm.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Ard Biesheuvel <ardb+git@google.com>, Andy Lutomirski <luto@kernel.org>, 
 Catalin Marinas <catalin.marinas@arm.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Jeff Xu <jeffxu@chromium.org>, Joey Gouly <joey.gouly@arm.com>, 
 Kees Cook <kees@kernel.org>, Linu Cherian <linu.cherian@arm.com>, 
 Linus Walleij <linusw@kernel.org>, Marc Zyngier <maz@kernel.org>, 
 Mark Brown <broonie@kernel.org>, Matthew Wilcox <willy@infradead.org>, 
 Maxwell Bland <mbland@motorola.com>, 
 "Mike Rapoport (IBM)" <rppt@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, 
 Pierre Langlois <pierre.langlois@arm.com>, 
 =?utf-8?q?Pierre-Cl=C3=A9ment_Tosi?= <ptosi@google.com>, 
 Quentin Perret <qperret@google.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Vlastimil Babka <vbabka@kernel.org>, 
 Will Deacon <will@kernel.org>, Yang Shi <yang@os.amperecomputing.com>, 
 Yeoreum Yun <yeoreum.yun@arm.com>, linux-kernel@vger.kernel.org, 
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, x86@kernel.org, 
 Ira Weiny <iweiny@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Thomas Gleixner <tglx@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1794240029; l=5621;
 i=kevin.brodsky@arm.com; s=20260427; h=from:subject:message-id;
 bh=ZPX85IlkbQlPgohX2Zyn8cActE8CqgGaqWXBsgZhgrQ=;
 b=BHEth1LPkXZiSPlKi9DxAsJzoM1sn8uQlPPkoyEZC2z4et3VLGO29Afdyoa35LNzsydljQBdG
 0v1bpT/UWh+Bl0VcgQu0qUQW/Cm6t2XuDnvDUnL2IisOv1rs7Hyy78Q
X-Developer-Key: i=kevin.brodsky@arm.com; a=ed25519;
 pk=N2QG+eJKrvkNovwhhwJhnJ4+ScVfsGCHldmqLfcMTFs=
X-Rspamd-Server: rspam06
X-Stat-Signature: j59n9bmy1dwtara9wcksb4kg9ii35egw
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 75290C0016
X-Rspam-User: 
X-HE-Tag: 1794240103-349131
X-HE-Meta: U2FsdGVkX18SSBLKW+LCpKNMQWmt+rBS/zjopDXB9sH5pyMilOcqckR2ys0ujpnXMpdZm94tQm8+NF43NLzKH+OKKsy9jh62L/5ajCPjyNKbU2r50BAe2qUCgXTb7cZrBZv0lC5c2/hCJoc0RhPonUGTSIRQf+P+FTDs/nc7e5bT6ZD23Nw5xmvIBoujj69DICJe4rEFSi+JlHy+CFwqQa8VblieHp1rFAdxVGL7gmHa2zTSV+fSi3q+eU4r13yQaH81AEgxo2AD8T2hwyR7bNCmU4gDVCV9T1aDi8VPdV2NaZ/viRz3/cFP+GsMcNqyLh8/jbhVSaQnbFDIS22NQovw0b16lL7At33W9p20qMZyMSW6Trcr33jtjFccIDjAaCAHV7pp5bZUmechpS39CHmpHGB+kjugoaro4sj+XmAoE0fC2Y+SVDrq/fv5gBT8MWZ9GORCNMx+tP/8g/E+iL+SOl/pPgZpDea5EQV2TYM0bMWidJXOdhIt2uaebkCNVjgzi590CWgeL9LgHNO8d64nKqFPTzas4A2SDFJsQWkGYQDZW3imGsIe6vAZ5Xno8J7daBc0sd3RDTC8Y5SkgWwqvJhCDwm2HNiBNbkXGFoixIfyFPyoUyQH56gFGQzpa9xSC1NY+HvWclj5kAR4WX72mDU3cNb2bVtPztO19V+yUhldm8x+XoixYXsOH8IiQHwVdfQVFZvU4l/neNWB/m4mIIrdbHfRFtb+oB/G2Uzuri0he4m++b7f8a8zOVBzvxOXbiYJ2iPOlueSgKYcNVNvPLzW4X33EHLBDlECyB597PF+wvB4dDdYW/LH7LHKnfyVoQbUDafy9R53GoApplbMDa8ZaqOPXfRWXTxSXG81mrHroPiW3eQQrxLAmWgADmR1Z00e75c03WHBXWIBUrXGYD01AVZhZ/luCMcmAgnU4dX3QkXmVJ35BmevRtI0D3bwv/byqS/HNSxFKTy
 tJdG+eHA
 rhXe9i/gVwwp5Z/Conrn5rnb90MHZhwWTVrG8ZaR75U4g4hBlivrDJGvtp+JS3YUCqunNtg+Nop0Ngz16qZytD5KfjWOSCHAAAkqUSrSbd3cHwpWGX1bPsKEyvGTcYm+LVvG9J6Uqz233oGpmz3ICoDhxbMdJT0NYxCB+SWnSYwhdv2ApZhzzX+w/0W3ybZWTwwytbwRZJgdEz2kMm6MOsBTvH2Tmot8ukhkJbClcT05W7RLflPgFFBUgvXCZuOpJY619acwJ3I+cjt5wosxPtMEHIsIN0UmvU98qlGwHgIZepx+bmLeAmaUWmEGfytEGueAoo2VFi3zvO1YGRMQyYYjnM4VDTPNDN1J3R7Nei7VIaZI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Initial kernel page tables (kernel image, direct map, vmemmap, etc.)
are not allocated using pagetable_alloc() - the buddy allocator
isn't ready at that point. We need to use a different approach to
protect them.

This patch takes the "brute force" route: when
kpkeys_hardened_pgtables is enabled, walk all installed kernel
page table, setting the pkey of their backing pages in the direct
map along the way.

The standard pagewalk API is used for that purpose, albeit in a
slightly unusual way:

* Visiting an entry is used to set the pkey of the table it points
  to, hence: .pmd_entry -> protect_pte_table

* PTE entries are always leaves, so no need to visit them (no
  .pte_entry callback)

* The range is meant to capture all installed kernel page tables.
  There doesn't seem to be a generic way to express this;
  [PAGE_OFFSET, ULONG_MAX) seems to be good enough on arm64/x86.

Locking probably isn't necessary so early during boot, but taking
the mmap_write_lock shouldn't hurt either. We also assume that all
page tables installed after that point are allocated using
pagetable_alloc(), which seems to be the case, at least on arm64.
There are some more assumptions - see comment above
protect_early_kernel_pgtables().

This simple approach should reliably protect all early kernel page
tables without invasive changes. However, adding support for large
blocks (PMD/PUD) is likely to be difficult and/or inefficient as
splitting will ocur when protecting individual page table pages.
Modifying the early page table allocators directly may be
preferable.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 mm/kpkeys_hardened_pgtables.c | 122 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
index 2311fd8da6bb..f6825a0e0689 100644
--- a/mm/kpkeys_hardened_pgtables.c
+++ b/mm/kpkeys_hardened_pgtables.c
@@ -1,6 +1,8 @@
 // SPDX-License-Identifier: GPL-2.0-only
 #include <linux/kpkeys.h>
 #include <linux/mm.h>
+#include <linux/pagewalk.h>
+#include <linux/pgtable.h>
 #include <linux/set_memory.h>
 
 #include <kunit/visibility.h>
@@ -54,10 +56,130 @@ void kpkeys_pgtable_free(struct page *page, unsigned int order)
 	__free_pages(page, order);
 }
 
+static void __init protect_pgtable_page(void *page)
+{
+	int ret;
+
+	ret = set_direct_map_pkey((unsigned long)page, 1, KPKEYS_PKEY_PGTABLES);
+	WARN_ON_ONCE(ret);
+}
+
+static int __init protect_pte_table(pmd_t *pmd, unsigned long addr,
+				    unsigned long next, struct mm_walk *walk)
+{
+	pmd_t entry = pmdp_get(pmd);
+
+	if (!pmd_present(entry) || pmd_leaf(entry))
+		return 0;
+
+	protect_pgtable_page(pte_offset_kernel(pmd, 0));
+
+	return 0;
+}
+
+static int __init protect_pmd_table(pud_t *pud, unsigned long addr,
+				    unsigned long next, struct mm_walk *walk)
+{
+	pud_t entry;
+
+	if (mm_pmd_folded(walk->mm))
+		return 0;
+
+	entry = pudp_get(pud);
+	if (!pud_present(entry) || pud_leaf(entry))
+		return 0;
+
+	protect_pgtable_page(pmd_offset(pud, 0));
+
+	return 0;
+}
+
+static int __init protect_pud_table(p4d_t *p4d, unsigned long addr,
+				    unsigned long next, struct mm_walk *walk)
+{
+	p4d_t entry;
+
+	if (mm_pud_folded(walk->mm))
+		return 0;
+
+	entry = p4dp_get(p4d);
+	if (!p4d_present(entry) || p4d_leaf(entry))
+		return 0;
+
+	protect_pgtable_page(pud_offset(p4d, 0));
+
+	return 0;
+}
+
+static int __init protect_p4d_table(pgd_t *pgd, unsigned long addr,
+				    unsigned long next, struct mm_walk *walk)
+{
+	pgd_t entry;
+
+	if (mm_p4d_folded(walk->mm))
+		return 0;
+
+	entry = pgdp_get(pgd);
+	if (!pgd_present(entry) || pgd_leaf(entry))
+		return 0;
+
+	protect_pgtable_page(p4d_offset(pgd, 0));
+
+	return 0;
+}
+
+static const struct mm_walk_ops protect_pgtable_ops __initconst = {
+	.pmd_entry = protect_pte_table,
+	.pud_entry = protect_pmd_table,
+	.p4d_entry = protect_pud_table,
+	.pgd_entry = protect_p4d_table,
+};
+
+/*
+ * Protect all installed kernel page tables by walking them and setting the
+ * direct mapping of all backing pages to pkey KPKEYS_PKEY_PGTABLES. We assume
+ * all non-root levels (PTE to P4D) are page-sized (asserts below).
+ *
+ * The root PGD page is left untouched; it is normally accessed via the kimg
+ * mapping only. On arm64 it cannot be written directly via any mapping.
+ *
+ * This approach is unsafe if set_direct_map_pkey() may split blocks in the
+ * direct map; we rely on the direct map being fully PTE-mapped.
+ */
+static void __init protect_early_kernel_pgtables(void)
+{
+	int ret;
+
+	mmap_write_lock(&init_mm);
+	/*
+	 * [PAGE_OFFSET, ULONG_MAX) covers all early kernel mappings on arm64
+	 * and x86 (at least).
+	 */
+	ret = walk_kernel_page_table_range(PAGE_OFFSET, ULONG_MAX,
+					   &protect_pgtable_ops, NULL, NULL);
+	mmap_write_unlock(&init_mm);
+	WARN_ON_ONCE(ret);
+}
+
+static_assert(MAX_PTRS_PER_PTE * sizeof(pte_t) == PAGE_SIZE);
+
+#ifndef __PAGETABLE_PMD_FOLDED
+static_assert(MAX_PTRS_PER_PMD * sizeof(pmd_t) == PAGE_SIZE);
+#endif
+
+#ifndef __PAGETABLE_PUD_FOLDED
+static_assert(MAX_PTRS_PER_PUD * sizeof(pud_t) == PAGE_SIZE);
+#endif
+
+#ifndef __PAGETABLE_P4D_FOLDED
+static_assert(MAX_PTRS_PER_P4D * sizeof(p4d_t) == PAGE_SIZE);
+#endif
+
 void __init kpkeys_hardened_pgtables_init(void)
 {
 	if (!kpkeys_supported())
 		return;
 
 	static_branch_enable(&kpkeys_hardened_pgtables_key);
+	protect_early_kernel_pgtables();
 }

-- 
2.56.0


