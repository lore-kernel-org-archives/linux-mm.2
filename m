Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A702E1099B33
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 18:23:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ADA0C6B00BD; Fri, 20 Mar 2026 14:23:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 979106B00BE; Fri, 20 Mar 2026 14:23:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 868576B00C0; Fri, 20 Mar 2026 14:23:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 705436B00BD
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 14:23:43 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E64EC1332
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:43 +0000 (UTC)
X-FDA: 84567264726.14.6638D97
Received: from mail-wr1-f74.google.com (mail-wr1-f74.google.com [209.85.221.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2C29A40007
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:23:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HAI5XrVP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3q5C9aQgKCBg7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3q5C9aQgKCBg7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774031021;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJ8SkeYHKeVD4r/zvzrMT4HJuUu/LIHCH2575HOl5G0=;
	b=e0jyeTeNK28SygEFrmSl/+moeXhX2iXsceHk2zomKCKGdAPXM6U40N455pybxjTfXLGcfB
	aOCPgCoLgTdBvmlTX8yf5zcN1HsqhkZSHvzhWK5kVldGsVfiPZYe1lSGWX2FerrT2i9cz3
	kC//DnvBzb4lJndKRofOCiRCI3d/QUE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774031021; a=rsa-sha256;
	cv=none;
	b=dG8bIjQbHK+VngI2O6N9aVxDHD5EKZyz2EyAcbbs5UUhBTgz94ZwnstZnKI1KM5BLH9Fuq
	tApkMtZJstb2Vfm+7rSUJN6tq35hxtIrb9zX9S6zMGq2dG3fJnXiEPmV+am8ycywiWyxeD
	rKzmm9VDhsQ0AtP2I3GDJ4O4sqp0rxk=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=HAI5XrVP;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of 3q5C9aQgKCBg7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com designates 209.85.221.74 as permitted sender) smtp.mailfrom=3q5C9aQgKCBg7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com
Received: by mail-wr1-f74.google.com with SMTP id ffacd0b85a97d-43b47c19ed8so1974520f8f.1
        for <linux-mm@kvack.org>; Fri, 20 Mar 2026 11:23:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774031020; x=1774635820; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=kJ8SkeYHKeVD4r/zvzrMT4HJuUu/LIHCH2575HOl5G0=;
        b=HAI5XrVPSCo06i+9toASivmhYddMmh7KOpfZ13M7jr35QeF95o/Z7rEFq+ZK98FQFB
         Vas27ffE980fX+4LI0x9TNwm6gKLEAweNxvJU8S4heJISp4/7tcYggYAXkKBq/TTAv9y
         19zI374fZZWyyeCPyJz4LyVHxTRSps2mITlp9pgcKp5kzVNaJ/jQu4GAj9IjreL4Qv8v
         dZteBKrEz7X21mJkL4URgE5vRkS5CizA0cLBIfUnhpGX1nMeSYHxWpkDKl6Z75VhXJHf
         Xipa8S1GOWLbIi8lAvLxCyuwHJiQEy5x3M5ZhUo+DukgKkuMOQ+zDtNl7I5Wg8Xe0Jbn
         /lzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774031020; x=1774635820;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kJ8SkeYHKeVD4r/zvzrMT4HJuUu/LIHCH2575HOl5G0=;
        b=hHHQtTSu3KsAywZUhzud4vReIMK+n8MuMRv+Fkw+J9BhcQl8BWOGDBAfEUUjFmnuMp
         TQGEaS+BHBDqQKYNMml1GwpSX6Ja/uvuseNIEicryv5LF9FGr9xTM2PEpPAnAe2K0inv
         m5jGWrUh8vKkKj42NfLj+xOGKbkbGxvDyfFHPjEgmo1ZAdilFwcf4kEilKQX3TPcWOqn
         GdyFU4MXfvrxXAEiOe62kdLxQljDJWTgw+t157SNOyKLXi6gIGrWbA5VG7wkLZdv4JJi
         QV+eI/fv4u/XRbP9pKTUg5WiE2cBZJ5Dqy5/PhAKJgV3DeCq997c9dzik9TIacJsEFx+
         IBgQ==
X-Gm-Message-State: AOJu0Yw9fA+v2UMVjH/2BkyQyBtSq61IgAhhW4fkwUSBMbyWPGek/KXx
	0lLgXOjNHAERfqg2gvBjgK3WPRAa3ulG46iF/4kwhHXowcBkvW+ylFV1wjb9KMbod7eT07yLBHF
	M6Y0QqCK2LXhLIw==
X-Received: from wrrv15.prod.google.com ([2002:a5d:43cf:0:b0:439:afd2:999b])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a5d:5d86:0:b0:439:b114:60c0 with SMTP id ffacd0b85a97d-43b6427840dmr7188274f8f.35.1774031019553;
 Fri, 20 Mar 2026 11:23:39 -0700 (PDT)
Date: Fri, 20 Mar 2026 18:23:26 +0000
In-Reply-To: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
X-Mailer: b4 0.14.3
Message-ID: <20260320-page_alloc-unmapped-v2-2-28bf1bd54f41@google.com>
Subject: [PATCH v2 02/22] x86/mm: Generalize LDT remap into "mm-local region"
From: Brendan Jackman <jackmanb@google.com>
To: Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, x86@kernel.org, 
	rppt@kernel.org, Sumit Garg <sumit.garg@oss.qualcomm.com>, derkling@google.com, 
	reijiw@google.com, Will Deacon <will@kernel.org>, rientjes@google.com, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, patrick.roy@linux.dev, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, 
	Brendan Jackman <jackmanb@google.com>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2C29A40007
X-Stat-Signature: udq81fhekcmgsh694g3a1nr7azzjd7kt
X-Rspam-User: 
X-HE-Tag: 1774031020-583685
X-HE-Meta: U2FsdGVkX1/pbxn6CdNebFIQ79/A+fOhStojlVzWYNrlDw8XebAraAdPm8EtmQHcy4XfzT9l4+AMJpOF8hKp21U6d3cjF7EXdTCdHEFd1FuHoL6wlyMGRwWiWM/lPpUdCYU+TA+qYf+mlC6KTeArb5ByW2h+ERve1ceWh+viD8/t9jkUE2FJpGu9mJUp/VdRFvuR98rZOAXmlB6omdSKyfIUbDObsMGJkTqzXo9nYf1Wref32nNQLUr++LxLrcHl1rNfkowxgviO5hPc+xkhSV2Vr/ijHGf47taryvI+7mPV1wrEfVvpzkRRDOh3MfxrpppPGyvuOOuJXIrfVazfDQHWiHfF3Ov6Av5p8NJgHJD++5eCgeAeZeNs0RTEqO37lJr8nud6ZGDRlYhoxtNzb8MtYooxF9cEEj/0DOM2oedHVIJ9EdJuXtOKRzMZIlwuvbQ1kTwZvYJ3HQmyhiBotN22N2VyIvaTKxn7EGf1RRkwCrDkyy85TFqUUuApZl6SLiufhXukCbomysL/tJ6O1gZsoB17xOr/XjiKmcav/3l/fomqJblMyDMqlgeBF3fx8oeja5iBQ6C/dxXcTZ1Wr7VqO5T3ZanrwH42eI/XX1H1fH8pDtQD4eNRRZ66v8VnVqeg+kpJ27yjGBuA7aOQxHcALGV9Kc4tX61CAvTWoKWzG19Dwj+kCRdMKfcuoM3eosrDb9GBF/ckY3brnWncuYKc1xTBllcNAGYMVoiPByMNue6/sbO3HPVuzLcppt3j80y6rJ5JFxzRZ3D1DPX2lAoFdP7Mm0qfl0PRok9jxs2sCZsVvonJBKtHcpfiXl/MqCSJji51TuyCUWma49V/ZkecWwHAc3AiYflews9teMf6VLFUKBat5RCcr4dC+GqIcO7W/g36cFxPDN7s06CGKThN3Oo3gDv7SiVvrNtznDKggBvdhtLm4eaJ2VVSwWExs5B0ZmgdttJYAD+2TDw
 0//2hrHw
 GQk5JGzADvb2kucuWkGHxfIPZ8YghEGSgnCujOqx/xDiwKbEFdEd2yjg5dlRimZdlKEUk/IR0X9Cp8jU3U8xoW49BkCrMr7QXJzp+hIteCY+PZj2aPtu/GSs0RWd7EtZURHLhZ6WQtAuYXMOmEQU++vOh7b7TRnu2oNL086RWacFcYhQ6WIFfybtr0///cPXdwB9vl+YKwJc1rkPL8GfLNX/H/wWQtebil3m3rEYBLyEx9l/7xh8MowI7EdOzblrIRDLp+TvMo2OKgzmAEl6IGqbuu+3ys5t0goWJ9kvFL423gD0HQGbK2HsZwJel5Ni/tjWxHkYLmxpKZOJ2GzEXqzJC2NqI621xKYoT34xLq7fzhgw9yyzbtSgzZOc0N1yXFpeLj1K40Uq+mI7leHHrRfVIYoMXNEl4+OrFVZH8PsXd/RwEd5F/zkpxA2oM9bm1cAs1QTGIr57CaEQnVrlt1+Ls2EJQ9IKjlrls/2dinXdj8IssM+8gdL3OW0osYMhNmy/BeF45dQ6mUyOcrtff88ix86gHbmtERQOMQ8CBU65/YHMc08RWxTgc4QDGNgPkDvI//D9ClCq79dA5CMRs8yg9oTWgVaczm62JIY5Lb4WoBwPr7AWTSwgDsE4m1VuOA6h8syxpyJAcn/J0xfdxpdgeBKAQCxVub2/S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Various security features benefit from having process-local address
mappings. Examples include no-direct-map guest_memfd [2] and significant
optimizations for ASI [1].

As pointed out by Andy in [0], x86 already has a PGD entry that is local
to the mm, which is used for the LDT.

So, simply redefine that entry's region as "the mm-local region" and
then redefine the LDT region as a sub-region of that.

With the currently-envisaged usecases, there will be many situations
where almost no processes have any need for the mm-local region.
Therefore, avoid its overhead (memory cost of pagetables, alloc/free
overhead during fork/exit) for processes that don't use it by requiring
its users to explicitly initialize it via the new mm_local_* API.

This means that the LDT remap code can be simplified:

1. map_ldt_struct_to_user() and free_ldt_pgtables() are no longer
   required as the mm_local core code handles that automatically.

2. The sanity-check logic is unified: in both cases just walk the
   pagetables via a generic mechanism. This slightly relaxes the
   sanity-checking since lookup_address_in_pgd() is more flexible than
   pgd_to_pmd_walk(), but this seems to be worth it for the simplified
   code.

On 64-bit, the mm-local region gets a whole PGD. On 32-bit, it just
i.e. one PMD, i.e. it is completely consumed by the LDT remap - no
investigation has been done into whether it's feasible to expand the
region on 32-bit. Most likely there is no strong usecase for that
anyway.

In both cases, in order to combine the need for an on-demand mm
initialisation, combined with the desire to transparently handle
propagating mappings to userspace under KPTI, the user and kernel
pagetables are shared at the highest level possible. For PAE that means
the PTE table is shared and for 64-bit the P4D/PUD. This is implemented
by pre-allocating the first shared table when the mm-local region is
first initialised.

The PAE implementation of mm_local_map_to_user() does not allocate
pagetables, it assumes the PMD has been preallocated. To make that
assumption safer, expose PREALLOCATED_PMDs in the arch headers so that
mm_local_map_to_user() can have a BUILD_BUG_ON().

[0] https://lore.kernel.org/linux-mm/CALCETrXHbS9VXfZ80kOjiTrreM2EbapYeGp68mvJPbosUtorYA@mail.gmail.com/
[1] https://linuxasi.dev/
[2] https://lore.kernel.org/all/20250924151101.2225820-1-patrick.roy@campus.lmu.de
Signed-off-by: Brendan Jackman <jackmanb@google.com>
---
 Documentation/arch/x86/x86_64/mm.rst    |   4 +-
 arch/x86/Kconfig                        |   2 +
 arch/x86/include/asm/mmu_context.h      | 119 ++++++++++++++++++++++++++++-
 arch/x86/include/asm/page.h             |  32 ++++++++
 arch/x86/include/asm/pgtable_32_areas.h |   9 ++-
 arch/x86/include/asm/pgtable_64_types.h |  12 ++-
 arch/x86/kernel/ldt.c                   | 130 +++++---------------------------
 arch/x86/mm/pgtable.c                   |  32 +-------
 include/linux/mm.h                      |  13 ++++
 include/linux/mm_types.h                |   2 +
 kernel/fork.c                           |   1 +
 mm/Kconfig                              |  11 +++
 12 files changed, 217 insertions(+), 150 deletions(-)

diff --git a/Documentation/arch/x86/x86_64/mm.rst b/Documentation/arch/x86/x86_64/mm.rst
index a6cf05d51bd8c..fa2bb7bab6a42 100644
--- a/Documentation/arch/x86/x86_64/mm.rst
+++ b/Documentation/arch/x86/x86_64/mm.rst
@@ -53,7 +53,7 @@ Complete virtual memory map with 4-level page tables
   ____________________________________________________________|___________________________________________________________
                     |            |                  |         |
    ffff800000000000 | -128    TB | ffff87ffffffffff |    8 TB | ... guard hole, also reserved for hypervisor
-   ffff880000000000 | -120    TB | ffff887fffffffff |  0.5 TB | LDT remap for PTI
+   ffff880000000000 | -120    TB | ffff887fffffffff |  0.5 TB | MM-local kernel data. Includes LDT remap for PTI
    ffff888000000000 | -119.5  TB | ffffc87fffffffff |   64 TB | direct mapping of all physical memory (page_offset_base)
    ffffc88000000000 |  -55.5  TB | ffffc8ffffffffff |  0.5 TB | ... unused hole
    ffffc90000000000 |  -55    TB | ffffe8ffffffffff |   32 TB | vmalloc/ioremap space (vmalloc_base)
@@ -123,7 +123,7 @@ Complete virtual memory map with 5-level page tables
   ____________________________________________________________|___________________________________________________________
                     |            |                  |         |
    ff00000000000000 |  -64    PB | ff0fffffffffffff |    4 PB | ... guard hole, also reserved for hypervisor
-   ff10000000000000 |  -60    PB | ff10ffffffffffff | 0.25 PB | LDT remap for PTI
+   ff10000000000000 |  -60    PB | ff10ffffffffffff | 0.25 PB | MM-local kernel data. Includes LDT remap for PTI
    ff11000000000000 |  -59.75 PB | ff90ffffffffffff |   32 PB | direct mapping of all physical memory (page_offset_base)
    ff91000000000000 |  -27.75 PB | ff9fffffffffffff | 3.75 PB | ... unused hole
    ffa0000000000000 |  -24    PB | ffd1ffffffffffff | 12.5 PB | vmalloc/ioremap space (vmalloc_base)
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 8038b26ae99e0..d7073b6077c62 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -133,6 +133,7 @@ config X86
 	select ARCH_SUPPORTS_RT
 	select ARCH_SUPPORTS_AUTOFDO_CLANG
 	select ARCH_SUPPORTS_PROPELLER_CLANG    if X86_64
+	select ARCH_SUPPORTS_MM_LOCAL_REGION	if X86_64 || X86_PAE
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF		if X86_CX8
 	select ARCH_USE_MEMTEST
@@ -2323,6 +2324,7 @@ config CMDLINE_OVERRIDE
 config MODIFY_LDT_SYSCALL
 	bool "Enable the LDT (local descriptor table)" if EXPERT
 	default y
+	select MM_LOCAL_REGION if MITIGATION_PAGE_TABLE_ISOLATION || X86_PAE
 	help
 	  Linux can allow user programs to install a per-process x86
 	  Local Descriptor Table (LDT) using the modify_ldt(2) system
diff --git a/arch/x86/include/asm/mmu_context.h b/arch/x86/include/asm/mmu_context.h
index ef5b507de34e2..14f75d1d7e28f 100644
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
@@ -59,7 +61,6 @@ static inline void init_new_context_ldt(struct mm_struct *mm)
 }
 int ldt_dup_context(struct mm_struct *oldmm, struct mm_struct *mm);
 void destroy_context_ldt(struct mm_struct *mm);
-void ldt_arch_exit_mmap(struct mm_struct *mm);
 #else	/* CONFIG_MODIFY_LDT_SYSCALL */
 static inline void init_new_context_ldt(struct mm_struct *mm) { }
 static inline int ldt_dup_context(struct mm_struct *oldmm,
@@ -68,7 +69,6 @@ static inline int ldt_dup_context(struct mm_struct *oldmm,
 	return 0;
 }
 static inline void destroy_context_ldt(struct mm_struct *mm) { }
-static inline void ldt_arch_exit_mmap(struct mm_struct *mm) { }
 #endif
 
 #ifdef CONFIG_MODIFY_LDT_SYSCALL
@@ -223,10 +223,123 @@ static inline int arch_dup_mmap(struct mm_struct *oldmm, struct mm_struct *mm)
 	return ldt_dup_context(oldmm, mm);
 }
 
+#ifdef CONFIG_MM_LOCAL_REGION
+static inline void mm_local_region_free(struct mm_struct *mm)
+{
+	if (mm_local_region_used(mm)) {
+		struct mmu_gather tlb;
+		unsigned long start = MM_LOCAL_BASE_ADDR;
+		unsigned long end = MM_LOCAL_END_ADDR;
+
+		/*
+		 * Although free_pgd_range() is intended for freeing user
+		 * page-tables, it also works out for kernel mappings on x86.
+		 * We use tlb_gather_mmu_fullmm() to avoid confusing the
+		 * range-tracking logic in __tlb_adjust_range().
+		 */
+		tlb_gather_mmu_fullmm(&tlb, mm);
+		free_pgd_range(&tlb, start, end, start, end);
+		tlb_finish_mmu(&tlb);
+
+		mm_flags_clear(MMF_LOCAL_REGION_USED, mm);
+	}
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
+ * Do initial setup of the user-local region. Call from process context.
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
diff --git a/arch/x86/include/asm/page.h b/arch/x86/include/asm/page.h
index 416dc88e35c15..4de4715c3b40f 100644
--- a/arch/x86/include/asm/page.h
+++ b/arch/x86/include/asm/page.h
@@ -78,6 +78,38 @@ static __always_inline u64 __is_canonical_address(u64 vaddr, u8 vaddr_bits)
 	return __canonical_address(vaddr, vaddr_bits) == vaddr;
 }
 
+#ifdef CONFIG_X86_PAE
+
+/*
+ * In PAE mode, we need to do a cr3 reload (=tlb flush) when
+ * updating the top-level pagetable entries to guarantee the
+ * processor notices the update.  Since this is expensive, and
+ * all 4 top-level entries are used almost immediately in a
+ * new process's life, we just pre-populate them here.
+ */
+#define PREALLOCATED_PMDS	PTRS_PER_PGD
+/*
+ * "USER_PMDS" are the PMDs for the user copy of the page tables when
+ * PTI is enabled. They do not exist when PTI is disabled.  Note that
+ * this is distinct from the user _portion_ of the kernel page tables
+ * which always exists.
+ *
+ * We allocate separate PMDs for the kernel part of the user page-table
+ * when PTI is enabled. We need them to map the per-process LDT into the
+ * user-space page-table.
+ */
+#define PREALLOCATED_USER_PMDS (boot_cpu_has(X86_FEATURE_PTI) ? KERNEL_PGD_PTRS : 0)
+#define MAX_PREALLOCATED_USER_PMDS KERNEL_PGD_PTRS
+
+#else  /* !CONFIG_X86_PAE */
+
+/* No need to prepopulate any pagetable entries in non-PAE modes. */
+#define PREALLOCATED_PMDS	0
+#define PREALLOCATED_USER_PMDS	0
+#define MAX_PREALLOCATED_USER_PMDS 0
+
+#endif	/* CONFIG_X86_PAE */
+
 #endif	/* __ASSEMBLER__ */
 
 #include <asm-generic/memory_model.h>
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
diff --git a/arch/x86/kernel/ldt.c b/arch/x86/kernel/ldt.c
index 40c5bf97dd5cc..fb2a1914539f8 100644
--- a/arch/x86/kernel/ldt.c
+++ b/arch/x86/kernel/ldt.c
@@ -31,6 +31,8 @@
 
 #include <xen/xen.h>
 
+/* LDTs are double-buffered, the buffers are called slots. */
+#define LDT_NUM_SLOTS		2
 /* This is a multiple of PAGE_SIZE. */
 #define LDT_SLOT_STRIDE (LDT_ENTRIES * LDT_ENTRY_SIZE)
 
@@ -186,100 +188,36 @@ static struct ldt_struct *alloc_ldt_struct(unsigned int num_entries)
 
 #ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
 
-static void do_sanity_check(struct mm_struct *mm,
-			    bool had_kernel_mapping,
-			    bool had_user_mapping)
+static void sanity_check_ldt_mapping(struct mm_struct *mm)
 {
+	pgd_t *k_pgd = pgd_offset(mm, LDT_BASE_ADDR);
+	pgd_t *u_pgd = kernel_to_user_pgdp(k_pgd);
+	unsigned int k_level, u_level;
+	bool had_kernel, had_user;
+
+	had_kernel = lookup_address_in_pgd(k_pgd, LDT_BASE_ADDR, &k_level);
+	had_user   = lookup_address_in_pgd(u_pgd, LDT_BASE_ADDR, &u_level);
+
 	if (mm->context.ldt) {
 		/*
 		 * We already had an LDT.  The top-level entry should already
 		 * have been allocated and synchronized with the usermode
 		 * tables.
 		 */
-		WARN_ON(!had_kernel_mapping);
+		WARN_ON(!had_kernel);
 		if (boot_cpu_has(X86_FEATURE_PTI))
-			WARN_ON(!had_user_mapping);
+			WARN_ON(!had_user);
 	} else {
 		/*
 		 * This is the first time we're mapping an LDT for this process.
 		 * Sync the pgd to the usermode tables.
 		 */
-		WARN_ON(had_kernel_mapping);
+		WARN_ON(had_kernel);
 		if (boot_cpu_has(X86_FEATURE_PTI))
-			WARN_ON(had_user_mapping);
+			WARN_ON(had_user);
 	}
 }
 
-#ifdef CONFIG_X86_PAE
-
-static pmd_t *pgd_to_pmd_walk(pgd_t *pgd, unsigned long va)
-{
-	p4d_t *p4d;
-	pud_t *pud;
-
-	if (pgd->pgd == 0)
-		return NULL;
-
-	p4d = p4d_offset(pgd, va);
-	if (p4d_none(*p4d))
-		return NULL;
-
-	pud = pud_offset(p4d, va);
-	if (pud_none(*pud))
-		return NULL;
-
-	return pmd_offset(pud, va);
-}
-
-static void map_ldt_struct_to_user(struct mm_struct *mm)
-{
-	pgd_t *k_pgd = pgd_offset(mm, LDT_BASE_ADDR);
-	pgd_t *u_pgd = kernel_to_user_pgdp(k_pgd);
-	pmd_t *k_pmd, *u_pmd;
-
-	k_pmd = pgd_to_pmd_walk(k_pgd, LDT_BASE_ADDR);
-	u_pmd = pgd_to_pmd_walk(u_pgd, LDT_BASE_ADDR);
-
-	if (boot_cpu_has(X86_FEATURE_PTI) && !mm->context.ldt)
-		set_pmd(u_pmd, *k_pmd);
-}
-
-static void sanity_check_ldt_mapping(struct mm_struct *mm)
-{
-	pgd_t *k_pgd = pgd_offset(mm, LDT_BASE_ADDR);
-	pgd_t *u_pgd = kernel_to_user_pgdp(k_pgd);
-	bool had_kernel, had_user;
-	pmd_t *k_pmd, *u_pmd;
-
-	k_pmd      = pgd_to_pmd_walk(k_pgd, LDT_BASE_ADDR);
-	u_pmd      = pgd_to_pmd_walk(u_pgd, LDT_BASE_ADDR);
-	had_kernel = (k_pmd->pmd != 0);
-	had_user   = (u_pmd->pmd != 0);
-
-	do_sanity_check(mm, had_kernel, had_user);
-}
-
-#else /* !CONFIG_X86_PAE */
-
-static void map_ldt_struct_to_user(struct mm_struct *mm)
-{
-	pgd_t *pgd = pgd_offset(mm, LDT_BASE_ADDR);
-
-	if (boot_cpu_has(X86_FEATURE_PTI) && !mm->context.ldt)
-		set_pgd(kernel_to_user_pgdp(pgd), *pgd);
-}
-
-static void sanity_check_ldt_mapping(struct mm_struct *mm)
-{
-	pgd_t *pgd = pgd_offset(mm, LDT_BASE_ADDR);
-	bool had_kernel = (pgd->pgd != 0);
-	bool had_user   = (kernel_to_user_pgdp(pgd)->pgd != 0);
-
-	do_sanity_check(mm, had_kernel, had_user);
-}
-
-#endif /* CONFIG_X86_PAE */
-
 /*
  * If PTI is enabled, this maps the LDT into the kernelmode and
  * usermode tables for the given mm.
@@ -295,6 +233,8 @@ map_ldt_struct(struct mm_struct *mm, struct ldt_struct *ldt, int slot)
 	if (!boot_cpu_has(X86_FEATURE_PTI))
 		return 0;
 
+	mm_local_region_init(mm);
+
 	/*
 	 * Any given ldt_struct should have map_ldt_struct() called at most
 	 * once.
@@ -339,9 +279,6 @@ map_ldt_struct(struct mm_struct *mm, struct ldt_struct *ldt, int slot)
 		pte_unmap_unlock(ptep, ptl);
 	}
 
-	/* Propagate LDT mapping to the user page-table */
-	map_ldt_struct_to_user(mm);
-
 	ldt->slot = slot;
 	return 0;
 }
@@ -390,28 +327,6 @@ static void unmap_ldt_struct(struct mm_struct *mm, struct ldt_struct *ldt)
 }
 #endif /* CONFIG_MITIGATION_PAGE_TABLE_ISOLATION */
 
-static void free_ldt_pgtables(struct mm_struct *mm)
-{
-#ifdef CONFIG_MITIGATION_PAGE_TABLE_ISOLATION
-	struct mmu_gather tlb;
-	unsigned long start = LDT_BASE_ADDR;
-	unsigned long end = LDT_END_ADDR;
-
-	if (!boot_cpu_has(X86_FEATURE_PTI))
-		return;
-
-	/*
-	 * Although free_pgd_range() is intended for freeing user
-	 * page-tables, it also works out for kernel mappings on x86.
-	 * We use tlb_gather_mmu_fullmm() to avoid confusing the
-	 * range-tracking logic in __tlb_adjust_range().
-	 */
-	tlb_gather_mmu_fullmm(&tlb, mm);
-	free_pgd_range(&tlb, start, end, start, end);
-	tlb_finish_mmu(&tlb);
-#endif
-}
-
 /* After calling this, the LDT is immutable. */
 static void finalize_ldt_struct(struct ldt_struct *ldt)
 {
@@ -472,7 +387,6 @@ int ldt_dup_context(struct mm_struct *old_mm, struct mm_struct *mm)
 
 	retval = map_ldt_struct(mm, new_ldt, 0);
 	if (retval) {
-		free_ldt_pgtables(mm);
 		free_ldt_struct(new_ldt);
 		goto out_unlock;
 	}
@@ -494,11 +408,6 @@ void destroy_context_ldt(struct mm_struct *mm)
 	mm->context.ldt = NULL;
 }
 
-void ldt_arch_exit_mmap(struct mm_struct *mm)
-{
-	free_ldt_pgtables(mm);
-}
-
 static int read_ldt(void __user *ptr, unsigned long bytecount)
 {
 	struct mm_struct *mm = current->mm;
@@ -645,10 +554,9 @@ static int write_ldt(void __user *ptr, unsigned long bytecount, int oldmode)
 		/*
 		 * This only can fail for the first LDT setup. If an LDT is
 		 * already installed then the PTE page is already
-		 * populated. Mop up a half populated page table.
+		 * populated.
 		 */
-		if (!WARN_ON_ONCE(old_ldt))
-			free_ldt_pgtables(mm);
+		WARN_ON_ONCE(!old_ldt);
 		free_ldt_struct(new_ldt);
 		goto out_unlock;
 	}
diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index 2e5ecfdce73c3..e4132696c9ef2 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -111,29 +111,6 @@ static void pgd_dtor(pgd_t *pgd)
  */
 
 #ifdef CONFIG_X86_PAE
-/*
- * In PAE mode, we need to do a cr3 reload (=tlb flush) when
- * updating the top-level pagetable entries to guarantee the
- * processor notices the update.  Since this is expensive, and
- * all 4 top-level entries are used almost immediately in a
- * new process's life, we just pre-populate them here.
- */
-#define PREALLOCATED_PMDS	PTRS_PER_PGD
-
-/*
- * "USER_PMDS" are the PMDs for the user copy of the page tables when
- * PTI is enabled. They do not exist when PTI is disabled.  Note that
- * this is distinct from the user _portion_ of the kernel page tables
- * which always exists.
- *
- * We allocate separate PMDs for the kernel part of the user page-table
- * when PTI is enabled. We need them to map the per-process LDT into the
- * user-space page-table.
- */
-#define PREALLOCATED_USER_PMDS	 (boot_cpu_has(X86_FEATURE_PTI) ? \
-					KERNEL_PGD_PTRS : 0)
-#define MAX_PREALLOCATED_USER_PMDS KERNEL_PGD_PTRS
-
 void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 {
 	paravirt_alloc_pmd(mm, __pa(pmd) >> PAGE_SHIFT);
@@ -150,12 +127,6 @@ void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmd)
 	 */
 	flush_tlb_mm(mm);
 }
-#else  /* !CONFIG_X86_PAE */
-
-/* No need to prepopulate any pagetable entries in non-PAE modes. */
-#define PREALLOCATED_PMDS	0
-#define PREALLOCATED_USER_PMDS	 0
-#define MAX_PREALLOCATED_USER_PMDS 0
 #endif	/* CONFIG_X86_PAE */
 
 static void free_pmds(struct mm_struct *mm, pmd_t *pmds[], int count)
@@ -375,6 +346,9 @@ pgd_t *pgd_alloc(struct mm_struct *mm)
 
 void pgd_free(struct mm_struct *mm, pgd_t *pgd)
 {
+	/* Should be cleaned up in mmap exit path. */
+	VM_WARN_ON_ONCE(mm_local_region_used(mm));
+
 	pgd_mop_up_pmds(mm, pgd);
 	pgd_dtor(pgd);
 	paravirt_pgd_free(mm, pgd);
diff --git a/include/linux/mm.h b/include/linux/mm.h
index 70747b53c7da9..413dc707cff9b 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -906,6 +906,19 @@ static inline void mm_flags_clear_all(struct mm_struct *mm)
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
index cee934c6e78ec..0ca7cb7da918f 100644
--- a/include/linux/mm_types.h
+++ b/include/linux/mm_types.h
@@ -1944,6 +1944,8 @@ enum {
 
 #define MMF_USER_HWCAP		32	/* user-defined HWCAPs */
 
+#define MMF_LOCAL_REGION_USED	33
+
 #define MMF_INIT_LEGACY_MASK	(MMF_DUMPABLE_MASK | MMF_DUMP_FILTER_MASK |\
 				 MMF_DISABLE_THP_MASK | MMF_HAS_MDWE_MASK |\
 				 MMF_VM_MERGE_ANY_MASK | MMF_TOPDOWN_MASK)
diff --git a/kernel/fork.c b/kernel/fork.c
index 68cf0109dde3c..ff075c74333fe 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1153,6 +1153,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 fail_nocontext:
 	mm_free_id(mm);
 fail_noid:
+	WARN_ON_ONCE(mm_local_region_used(mm));
 	mm_free_pgd(mm);
 fail_nopgd:
 	futex_hash_free(mm);
diff --git a/mm/Kconfig b/mm/Kconfig
index ebd8ea353687e..2813059df9c1c 100644
--- a/mm/Kconfig
+++ b/mm/Kconfig
@@ -1319,6 +1319,10 @@ config SECRETMEM
 	default y
 	bool "Enable memfd_secret() system call" if EXPERT
 	depends on ARCH_HAS_SET_DIRECT_MAP
+	# Soft dependency, for optimisation.
+	imply MM_LOCAL_REGION
+	imply MERMAP
+	imply PAGE_ALLOC_UNMAPPED
 	help
 	  Enable the memfd_secret() system call with the ability to create
 	  memory areas visible only in the context of the owning process and
@@ -1471,6 +1475,13 @@ config LAZY_MMU_MODE_KUNIT_TEST
 
 	  If unsure, say N.
 
+config ARCH_SUPPORTS_MM_LOCAL_REGION
+	def_bool n
+
+config MM_LOCAL_REGION
+	bool
+	depends on ARCH_SUPPORTS_MM_LOCAL_REGION
+
 source "mm/damon/Kconfig"
 
 endmenu

-- 
2.51.2


