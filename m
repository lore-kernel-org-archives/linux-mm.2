Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1064C531C9
	for <linux-mm@archiver.kernel.org>; Sun, 26 Jul 2026 22:23:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 035016B0099; Sun, 26 Jul 2026 18:23:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 00BB06B009B; Sun, 26 Jul 2026 18:23:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E8BA86B009D; Sun, 26 Jul 2026 18:23:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B188A6B0099
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 18:23:34 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32EBE1405CA
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:34 +0000 (UTC)
X-FDA: 85032355548.11.7FD0F60
Received: from mail-ed1-f72.google.com (mail-ed1-f72.google.com [209.85.208.72])
	by imf06.hostedemail.com (Postfix) with ESMTP id 7CAA3180002
	for <linux-mm@kvack.org>; Sun, 26 Jul 2026 22:23:32 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b36Joras;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 34ohmaggKCOcSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=34ohmaggKCOcSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785104612;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t3PhqaxxZ1xAjFZ/fCk/opbDZbTshcWyWRb6oD1k9p0=;
	b=3fY/A5SVmj31WsOmxpCwjIpo/vTjErb3KT2r6qO9TQ2vF8e/JPl169xsNhyQ9QbnbGijxM
	3pJvUlnOZWlXhFTfvXpfMG37iRTBXf+VfwPdGJWbAbGV3IaAfWf1x+fnIoPmDLbtZfrebm
	s1zetmS5UR9wymRTb2+ndUBuHlZHKlI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=b36Joras;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of 34ohmaggKCOcSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com designates 209.85.208.72 as permitted sender) smtp.mailfrom=34ohmaggKCOcSJLTVJWKPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785104612;
	b=kYAuguv9jva/6ltIMcxStby2y27yb7B7NIGQ+OZhKzpF6gFRNlw2TEp5O0eieZ4SY0xrz1
	p9461hJImcdKISy5UT6NZzqI7r7z+gPen+rXcLz2UrNz7csAOb4DFyxe8bfrWuzSX69cB+
	ECMvGxDDtyI8yrjgNP8JpB4iQwDIXUQ=
Received: by mail-ed1-f72.google.com with SMTP id 4fb4d7f45d1cf-698addf0a80so2125965a12.1
        for <linux-mm@kvack.org>; Sun, 26 Jul 2026 15:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785104611; x=1785709411; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t3PhqaxxZ1xAjFZ/fCk/opbDZbTshcWyWRb6oD1k9p0=;
        b=b36Joras+L6syXZJBMEa7svSWxZDrrmDVcjkhVsUe0UihxKlCR63blhaX2hLupnIqm
         P3RHnD1eyqnlvFiRKc8DUZYh6B7LId2Wm7ji7pa1OkgrUTe69gPD2wyhhV2KBb3S/5XO
         rdRnlMHchs+l8CILrhF/okzlO2V8gEIWbzFeNFs6zhy+69I9eNvKdq4Kn+LkWCQGtA3H
         qhItYz+hQqEQgdOd/iud86al3UdC/uHrtjJ3uX6nOapQAOffcdbI/lPjbl9gyomKpg2X
         so41D3Wuwt+SoDIlkaqFavOjE3bQL82i42hKIhz4+zJSZ8w1RZC16D8C8wHQzpVF0xt+
         1VCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785104611; x=1785709411;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t3PhqaxxZ1xAjFZ/fCk/opbDZbTshcWyWRb6oD1k9p0=;
        b=gDxvHylBhpo/+Ao7Uz/KqhtZCdmOJPEUHa1u3LO2Swa7quqDbkHML5ojiV/+jAs78A
         r+rv0c4RLda1HspuKMvC0fq1TqTfTIiAK44R+DxPiw9a8Atut3xwuyCZLLrMShGobzfA
         KMDuQVNpNdqHiCCKrUBMV+XEDKK9S9bZ/fZLUgJLIV97SJhYm+eJsTcr/XiLkvNKpLrk
         0eTFGWXeGuBFcxC2zHr+DLI7vuvX4sa9mNM9R1p6aqOKfvCd+KaQcTsgEms98Rr7Y3Tp
         EIKPxoLD1FZo1AqX9pi8d6EDP+W72Ad/YH5eTAPRy0DZGx7N0NVDVOu5nj5bE+LxXf1G
         PTkQ==
X-Gm-Message-State: AOJu0YyZglP3JGAVAk00G2hiIUpsK5x+EU+kljqrC+NI/cnQacNObIhM
	o8Z1FO2IRgfuBOb25ebY0AMs7+zEjJaPhxx8zwFec7JBgajeNR/nxmMFhFJ04LVvOFbDe2W+Xzo
	cE/w1X07db3kPnA==
X-Received: from edqj22.prod.google.com ([2002:aa7:c416:0:b0:69f:b160:de14])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2b8a:b0:698:3b7c:7e56 with SMTP id 4fb4d7f45d1cf-69fc116ad83mr2202096a12.34.1785104610714;
 Sun, 26 Jul 2026 15:23:30 -0700 (PDT)
Date: Sun, 26 Jul 2026 22:22:40 +0000
In-Reply-To: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
Mime-Version: 1.0
References: <20260726-page_alloc-unmapped-v3-0-6f5729aa9832@google.com>
X-Mailer: b4 0.16-dev
Message-ID: <20260726-page_alloc-unmapped-v3-7-6f5729aa9832@google.com>
Subject: [PATCH v3 07/26] x86/mm: introduce mm-local region
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Wei Xu <weixugc@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, 
	Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>, 
	Patrick Bellasi <derkling@google.com>, Reiji Watanabe <reijiw@google.com>, 
	Sean Christopherson <seanjc@google.com>, Brendan Jackman <jackmanb@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 7CAA3180002
X-Rspam-User: 
X-Stat-Signature: a86rjwipgn6qmkpzpmjuubb63tw4mcgq
X-HE-Tag: 1785104612-670491
X-HE-Meta: U2FsdGVkX18eOEfMxl3O95gG9ZT2fuo3YT+sfM/l4GiUfYhxoQkub6qICWZ0XG1qwtJd5AEODoS5R7OKY+14GSGU/nOrZiq3qTEWd7R1SkwbQTRtisL2DX5I+NbLYr9/wrk+SDVS96srsNzh4jWQhT3IAiHLq5Ox2k/51RYW/CQuc3BadsK6cPsCz3nCTUfA1FBTMw20VlOSYtyvTUf6+rmSmUNdBSSrahaTJTgGR3nP09ce48T4XLaWVEqoAxxGr0EYAC/tiA8ZT2Uu4slwqZec69+TWm5hP5+vNxGRAa2Io2MKTsE2616nxIcfyr9UDU3rsAmJBfDoFC5/HiJ6WbXv5eQPnWDS+IxoVtjfJovBmPpCkdGklCrzronN2qt5638vpOTcQ8ZUQJuXRmAaZG093rPu+D5zJ0qsht0G5RLmTYqJSa3FISKK5d1BHe0M5JftoKIH9WrjXtWwOMOnzTX0p4uhaPaS+OzvsXPKJKYspsn7VF6tIuN+ygLuFseTpBHHLl5BZ9C6NaCSRNtFvQPfVSzMIKRBZywbN2hfqWD4YOnbn09JETEXo+yHLLBviRl3ONBYAfKPtKaNPoB8F7CFY60Ptc+M3Yt5yk3j47injIzfViSYELL/X9euo2VbmrDCG8uD3MXMHe8zvwmt40nOd1JWW4O6/FvIPT+vZgBcld9lRe1Rr/A1QsoEYFMNbsqemV7XnxkgOJyERdTT5veTID4XQlBGBHue97rXmizbUAyBuxjzreRCVBuZDfX+Cjx6Tk3p/j1Eu02W9R7faZ0yceT9Oz9pnmvWYbTmJdHSkl/h6R91l0OQOXE8R1u2FWrN1iVFnP96Q5hVOk1q0hM9F4iCvD1bIiJhVq6PlafOFjuRRX+h6n2Eibqv6laHvrRCc1gJ8IrJZWWRvuRseHL2Z8AXcy/2wfPyiyqh/bOhOh9Qnp7m22Ihn0vkqiGaVeiNSsYvmkqb+lg09/l
 c6rBp3TM
 0YKIQ0uUm+rN8h+ngkpNiqt8FMMamyj9jiCEQIh9xu2LLvpK70ZwNPKVhq5DN9WruHlSttTaHFNDPUvGgqZqkTbHMgxaUPcjNzIxUbKjA6lmcTuf3/l2ZIVZDZPFnxsC/oTU9toxFKym8Kuz6450Z1YLBTRN4uwSLSJYOQWMuG1Ed7fcesyWym3x93QeP0XRqC4Xri55BxWPcreGyxoEoOrDvkNs1G0m00HFulatjLjRn4XWcDA2QYriz2hx2ffkic0dOSPMtu7J8St3vSCewwK/G95z1VCyHvwA7NCNrWFzytEdww4UxT7RbNrhOO046CRQcrlTyH6eRIiiLdH7BWdL/XAWfn1H94GJVRboM7ql81Ui4OGaB6edVCZupd2VBUaOCZEXoypBFedqUr2scEfr6Vj/rn9e8FF69SBbS2apG96VU7eQgBmJHBWUiK2zd1NK9UzB4+VpH+x415B10YCEUnblbPU+Tinp86cQx4ZN+htov/C6FFaye0/cvEq7mBTFy9iETr/12cCblQS4Tuj5u9bdm3u6LIpQipcQvMSHY4paKV7ia9ZYVBtOnYwum4xLdrEhS2KqeRph8roHNsNMn41tZZ9bal/lGL/NHwbZPqUgYo1/sj7sSo94kdbww1y0s7oHQ21Nifh4n7H9m/ZbmwmRQNd9isTNU/hpSK1KdipnFRp25OS5XBVvB1hWwCFy3DyUfW2wqlKM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Various security features benefit from having process-local address
mappings within the kernel. Examples include no-direct-map guest_memfd
[2] and significant optimizations for ASI [1].

With the currently envisaged usecases, there will be many situations
where almost no processes have any need for the mm-local region.
Therefore, avoid its overhead (memory cost of pagetables, alloc/free
overhead during fork/exit) for processes that don't use it by requiring
its users to explicitly initialize it via the new mm_local_* API.

As pointed out by Andy in [0], x86 already has a PGD entry that is local
to the mm, which is used for the LDT. In a subsequent patch, the LDT
remap will be unified with the general mm-local region, but to help
keep the patch to a manageable size, first just introduce the mm-local
region.

On 64-bit, give the mm-local region a whole PGD. On 32-bit, just give it
one PMD. No investigation has been done into whether it's feasible to
expand the region on 32-bit. Most likely there is no strong usecase for
that anyway.

In order to combine the need for an on-demand mm initialisation, with
the desire to transparently handle propagating mappings to userspace
under KPTI, the user and kernel pagetables are shared at the highest
level possible. For PAE that means the PTE table is shared and for
64-bit the P4D/PUD. This is implemented by pre-allocating the first
shared table when the mm-local region is first initialised.

[0] https://lore.kernel.org/linux-mm/CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com/
[1] https://linuxasi.dev/
[2] https://lore.kernel.org/all/20250924151101.2225820-1-patrick.roy@campus.lmu.de
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 arch/x86/Kconfig                        |   2 +
 arch/x86/include/asm/mmu_context.h      | 118 +++++++++++++++++++++++++++++++-
 arch/x86/include/asm/pgtable_32_areas.h |   9 ++-
 arch/x86/include/asm/pgtable_64_types.h |  12 +++-
 arch/x86/mm/pgtable.c                   |   3 +
 include/linux/mm.h                      |  13 ++++
 include/linux/mm_types.h                |   2 +
 kernel/fork.c                           |   1 +
 mm/Kconfig                              |   7 ++
 9 files changed, 161 insertions(+), 6 deletions(-)

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index fb298e2191792..3efab3524a6cf 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -132,6 +132,8 @@ config X86
 	select ARCH_SUPPORTS_LTO_CLANG
 	select ARCH_SUPPORTS_LTO_CLANG_THIN
 	select ARCH_SUPPORTS_RT
+	# LDT remap temporarily clashes with mm-local region, can't have both.
+	select ARCH_SUPPORTS_MM_LOCAL_REGION	if X86_64 || X86_PAE && !MODIFY_LDT_SYSCALL
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF
 	select ARCH_USE_MEMTEST
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index ef5b507de34e2..3d4f54673014f 100644
--- a/arch/x86/include/asm/mmu_context.h
+++ b/arch/x86/include/asm/mmu_context.h
@@ -8,8 +8,10 @@
 
 #include <trace/events/tlb.h>
 
+#include <asm/tlb.h>
 #include <asm/tlbflush.h>
 #include <asm/paravirt.h>
+#include <asm/pgalloc.h>
 #include <asm/debugreg.h>
 #include <asm/gsseg.h>
 #include <asm/desc.h>
@@ -223,10 +225,124 @@ static inline int arch_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
 	return ldt_dup_context(oldmm, mm);
 }
 
+#ifdef CONFIG_MM_LOCAL_REGION
+static inline void mm_local_region_free(struct mm_struct *mm)
+{
+	if (!mm_local_region_used(mm))
+		return;
+
+	struct mmu_gather tlb;
+	unsigned long start = MM_LOCAL_BASE_ADDR;
+	unsigned long end = MM_LOCAL_END_ADDR;
+
+	/*
+	 * Although free_pgd_range() is intended for freeing user
+	 * page-tables, it also works out for kernel mappings on x86.
+	 * Use tlb_gather_mmu_fullmm() to avoid confusing the
+	 * range-tracking logic in __tlb_adjust_range().
+	 */
+	tlb_gather_mmu_fullmm(&tlb, mm);
+	free_pgd_range(&tlb, start, end, start, end);
+	tlb_finish_mmu(&tlb);
+
+	mm_flags_clear(MMF_LOCAL_REGION_USED, mm);
+}
+
+#if defined(CONFIG_MITIGATION_PAGE_TABLE_ISOLATION) && defined(CONFIG_X86_PAE)
+static inline pmd_t *pgd_to_pmd_walk(pgd_t *pgd, unsigned long va)
+{
+	p4d_t *p4d;
+	pud_t *pud;
+
+	if (pgd->pgd == 0)
+		return NULL;
+
+	p4d = p4d_offset(pgd, va);
+	if (p4d_none(*p4d))
+		return NULL;
+
+	pud = pud_offset(p4d, va);
+	if (pud_none(*pud))
+		return NULL;
+
+	return pmd_offset(pud, va);
+}
+
+static inline int mm_local_map_to_user(struct mm_struct *mm)
+{
+	BUILD_BUG_ON(!PREALLOCATED_PMDS);
+	pgd_t *k_pgd = pgd_offset(mm, MM_LOCAL_BASE_ADDR);
+	pgd_t *u_pgd = kernel_to_user_pgdp(k_pgd);
+	pmd_t *k_pmd, *u_pmd;
+	int err;
+
+	k_pmd = pgd_to_pmd_walk(k_pgd, MM_LOCAL_BASE_ADDR);
+	u_pmd = pgd_to_pmd_walk(u_pgd, MM_LOCAL_BASE_ADDR);
+
+	BUILD_BUG_ON(MM_LOCAL_END_ADDR - MM_LOCAL_BASE_ADDR > PMD_SIZE);
+
+	/* Preallocate the PTE table so it can be shared. */
+	err = pte_alloc(mm, k_pmd);
+	if (err)
+		return err;
+
+	/* Point the userspace PMD at the same PTE as the kernel PMD. */
+	set_pmd(u_pmd, *k_pmd);
+	return 0;
+}
+#elif defined(CONFIG_MITIGATION_PAGE_TABLE_ISOLATION)
+static inline int mm_local_map_to_user(struct mm_struct *mm)
+{
+	pgd_t *pgd;
+	int err;
+
+	err = preallocate_sub_pgd(mm, MM_LOCAL_BASE_ADDR);
+	if (err)
+		return err;
+
+	pgd = pgd_offset(mm, MM_LOCAL_BASE_ADDR);
+	set_pgd(kernel_to_user_pgdp(pgd), *pgd);
+	return 0;
+}
+#else
+static inline int mm_local_map_to_user(struct mm_struct *mm)
+{
+	WARN_ONCE(1, "mm_local_map_to_user() not implemented");
+	return -EINVAL;
+}
+#endif
+
+/*
+ * Do initial setup of the mm-local region. Call from process context.
+ *
+ * Under PTI, userspace shares the pagetables for the mm-local region with the
+ * kernel (if you map stuff here, it's immediately mapped into userspace too).
+ * LDT remap. It's assuming nothing gets mapped in here that needs to be
+ * protected from Meltdown-type attacks from the current process.
+ */
+static inline int mm_local_region_init(struct mm_struct *mm)
+{
+	int err;
+
+	if (boot_cpu_has(X86_FEATURE_PTI)) {
+		err = mm_local_map_to_user(mm);
+		if (err)
+			return err;
+	}
+
+	mm_flags_set(MMF_LOCAL_REGION_USED, mm);
+
+	return 0;
+}
+
+#else
+static inline void mm_local_region_free(struct mm_struct *mm) { }
+#endif /* CONFIG_MM_LOCAL_REGION */
+
 static inline void arch_exit_mmap(struct mm_struct *mm)
 {
 	paravirt_arch_exit_mmap(mm);
-	ldt_arch_exit_mmap(mm);
+	mm_local_region_free(mm);
 }
 
 #ifdef CONFIG_X86_64
diff --git a/arch/x86/include/asm/pgtable_32_areas.h b/arch/x86/include/asm/pgtable_32_areas.h
index 921148b429676..7fccb887f8b33 100644
--- a/arch/x86/include/asm/pgtable_32_areas.h
+++ b/arch/x86/include/asm/pgtable_32_areas.h
@@ -30,9 +30,14 @@ extern bool __vmalloc_start_set; /* set once high_memory is set */
 #define CPU_ENTRY_AREA_BASE	\
 	((FIXADDR_TOT_START - PAGE_SIZE*(CPU_ENTRY_AREA_PAGES+1)) & PMD_MASK)
 
-#define LDT_BASE_ADDR		\
-	((CPU_ENTRY_AREA_BASE - PAGE_SIZE) & PMD_MASK)
+/*
+ * On 32-bit the mm-local region is currently completely consumed by the LDT
+ * remap.
+ */
+#define MM_LOCAL_BASE_ADDR	((CPU_ENTRY_AREA_BASE - PAGE_SIZE) & PMD_MASK)
+#define MM_LOCAL_END_ADDR	(MM_LOCAL_BASE_ADDR + PMD_SIZE)
 
+#define LDT_BASE_ADDR		MM_LOCAL_BASE_ADDR
 #define LDT_END_ADDR		(LDT_BASE_ADDR + PMD_SIZE)
 
 #define PKMAP_BASE		\
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 7eb61ef6a185f..1181565966405 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -5,8 +5,11 @@
 #include <asm/sparsemem.h>
 
 #ifndef __ASSEMBLER__
+#include <linux/build_bug.h>
 #include <linux/types.h>
 #include <asm/kaslr.h>
+#include <asm/page_types.h>
+#include <uapi/asm/ldt.h>
 
 /*
  * These are used to make use of C type-checking..
@@ -100,9 +103,12 @@ extern unsigned int ptrs_per_p4d;
 #define GUARD_HOLE_BASE_ADDR	(GUARD_HOLE_PGD_ENTRY << PGDIR_SHIFT)
 #define GUARD_HOLE_END_ADDR	(GUARD_HOLE_BASE_ADDR + GUARD_HOLE_SIZE)
 
-#define LDT_PGD_ENTRY		-240UL
-#define LDT_BASE_ADDR		(LDT_PGD_ENTRY << PGDIR_SHIFT)
-#define LDT_END_ADDR		(LDT_BASE_ADDR + PGDIR_SIZE)
+#define MM_LOCAL_PGD_ENTRY	-240UL
+#define MM_LOCAL_BASE_ADDR	(MM_LOCAL_PGD_ENTRY << PGDIR_SHIFT)
+#define MM_LOCAL_END_ADDR	((MM_LOCAL_PGD_ENTRY + 1) << PGDIR_SHIFT)
+
+#define LDT_BASE_ADDR		MM_LOCAL_BASE_ADDR
+#define LDT_END_ADDR		(LDT_BASE_ADDR + PMD_SIZE)
 
 #define __VMALLOC_BASE_L4	0xffffc90000000000UL
 #define __VMALLOC_BASE_L5 	0xffa0000000000000UL
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 8f3505b1eefec..cc768ea8c19c8 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -335,6 +335,9 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
+	/* Should be cleaned up in mmap exit path. */
+	VM_WARN_ON_ONCE(mm_local_region_used(mm));
+
 	pgd_mop_up_pmds(mm, pgd);
 	pgd_dtor(pgd);
 	paravirt_pgd_free(mm, pgd);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 7fabe6c66b4b7..28022c96edcb5 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -989,6 +989,19 @@ static inline void mm_flags_clear_all(struct mm_struct *mm)
 	bitmap_zero(ACCESS_PRIVATE(&mm->flags, __mm_flags), NUM_MM_FLAG_BITS);
 }
 
+#ifdef CONFIG_MM_LOCAL_REGION
+static inline bool mm_local_region_used(struct mm_struct *mm)
+{
+	return mm_flags_test(MMF_LOCAL_REGION_USED, mm);
+}
+#else
+static inline bool mm_local_region_used(struct mm_struct *mm)
+{
+	VM_WARN_ON_ONCE(mm_flags_test(MMF_LOCAL_REGION_USED, mm));
+	return false;
+}
+#endif
+
 extern const struct vm_operations_struct vma_dummy_vm_ops;
 
 static inline void vma_init(struct vm_area_struct *vma, struct mm_struct *mm)
diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
index b5d4cd3b067bf..d39fddf57edc8 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1997,6 +1997,8 @@ enum {
 #define MMF_TOPDOWN		31	/* mm searches top down by default */
 #define MMF_TOPDOWN_MASK	BIT(MMF_TOPDOWN)
 
+#define MMF_LOCAL_REGION_USED	32
+
 #define MMF_INIT_LEGACY_MASK	(MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
 				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
diff --git a/kernel/fork.c b/kernel/fork.c
index f0e2e131a9a5a..4fb23ea33b7da 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1154,6 +1154,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p)
 fail_nocontext:
 	mm_free_id(mm);
 fail_noid:
+	WARN_ON_ONCE(mm_local_region_used(mm));
 	mm_free_pgd(mm);
 fail_mm_init:
 	free_mm(mm);
diff --git a/mm/Kconfig b/mm/Kconfig
index c52ab6afcb159..cb531c1436f77 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1500,6 +1500,13 @@ config LAZY_MMU_MODE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config ARCH_SUPPORTS_MM_LOCAL_REGION
+	bool
+
+config MM_LOCAL_REGION
+	bool
+	depends on ARCH_SUPPORTS_MM_LOCAL_REGION
+
 source "mm/damon/Kconfig"
 
 endmenu

-- 
2.54.0


