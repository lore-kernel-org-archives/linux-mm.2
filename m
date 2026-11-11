Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A90D8606A321
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 11:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=CeDjNYV+
Received: by kanga.kvack.org (Postfix)
	id CE55C6B05B2; Wed, 11 Nov 2026 06:54:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CBC916B05B3; Wed, 11 Nov 2026 06:54:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD2036B05B4; Wed, 11 Nov 2026 06:54:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8B2576B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:54:21 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 98478A799B
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:54:19 +0000 (UTC)
X-FDA: 85422680238.10.513FD04
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf22.hostedemail.com (Postfix) with ESMTP id 96BACC000E
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 11:54:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CeDjNYV+;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794398058;
	b=ezKJz8ui5MZpAamratCM1ad38xArdf+09FgZgO0xM7HJXweQFN52q747RuD2e3EljnpDtD
	uJce4WAmWu3UQZPcOfPg4IxJD6gVVtMbXz/C0qWy0EyO/UG+WGzPAip4v2hmPfzVrRgLfe
	IB4UbdaYnMAHZVPa2w50KUym3MHQ+Eo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794398058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iRUIMS49hoSOEmD7qxA40rIo2Cj8FT0pTAOH5mtilWQ=;
	b=Ffn7tgQzhGpsBac6rwwYBiEb8cGnCH9VFyU9nAItpojwyFmQh45FdIPVeu0ravrN1f7gUp
	RMZVgNLFHE1q2ZZMieGRWsHuK69FPMrulkyixdW6Okh0jM019OnCZxgBeeG6foCs7qlp/f
	N3kQk0UiWWDIcwcZZ5uNZwzJLSvgl/g=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CeDjNYV+;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf22.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 857361576;
	Wed, 11 Nov 2026 03:54:13 -0800 (PST)
Received: from localhost (a085714.arm.com [10.164.19.28])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id C754C3F673;
	Wed, 11 Nov 2026 03:54:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1794398056; bh=vxb8GWA/SO+8jrDRzmH3YqjJX7cIOf8js4OHf9oUj8I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=CeDjNYV+DU+n1kv8g/R00VkmjUistcizknOF0lJDila5M+/zvChfcilFDI4dD+a+t
	 WTLpTd7uc0u4qY6x/s9XVKNMs+ViIfmYuQvFTnxCT/CNk/Ab8g/fXjU/BcBU6zQmPt
	 ruup/KASfrX/MiGPuq4eBBsTGorRly6spqexOL4E=
Date: Wed, 11 Nov 2026 17:24:13 +0530
From: Anshuman Khandual <anshuman.khandual@arm.com>
To: sashiko-reviews@lists.linux.dev
Cc: catalin.marinas@arm.com, will@kernel.org, 
	Ryan Roberts <ryan.roberts@arm.com>, Mark Rutland <mark.rutland@arm.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Linu Cherian <linu.cherian@arm.com>, linux-mm@kvack.org, kasan-dev@googlegroups.com
Subject: Re: [PATCH V4 4/4] arm64/mm: Use pgdp_get() for PGD accesses
Message-ID: <ohyhflzuoxdemccemutoosmj5hsfwylrlt6tvnyehulerk7gf3@ada6wu4zrzkp>
References: <20261105043403.3326445-1-anshuman.khandual@arm.com>
 <20261105043403.3326445-5-anshuman.khandual@arm.com>
 <sashiko-outbox-200739@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-200739@kernel.org>
X-Rspamd-Queue-Id: 96BACC000E
X-Rspamd-Server: rspam12
X-Stat-Signature: aoywom51shc3hawaamhj9f41bueirqpk
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794398057-157178
X-HE-Meta: U2FsdGVkX18GWwzRD1mjDXcHlvNKE1yOiMro5ZVLbvQJ9DhimK46lp6qTniqpafCD92J8LyekzAXKy97q8eU2C3pSV9HN/RSmTI9nTg2dyHfxieWUcd7osw9jGzVrh2bxVU1V3VhyBRboJoD93SPgyMdbqBNV431viKOAD5MngPP7SFxXT9k8Oc3BSTYFm+33tI5jiKTDbCGL/wGUXDR5eh9tlwlLQ9+fbxSI1QISjITXbhh8gRzBLjA3vCPQj3J6NNfb0yaREG8fgmBRnT095baRcZR8F8/sUArHZr8n3mTpB9zHCHOYqrX6YFHN0EHTvjwlX3HCxKZ3+5s4LRz50JYGzuYL/JXns/hRo663oHtvACUgOpJxcoMdLFnVAxDbjSv97RRWHr1X3Peednhdra3m5E0XefLrs9td+YrUmjXB12MTuw/6tSGxndCWE7wsoHF2cFQEFLMF19etdcCywcwB/gJi2hpeeHP1+pBqG0awKNYvg6L0dnCp4G7Lhl+dl2L9j0knrhHGpCWre4Sxtk1KRtyG0erzvse+PqeYZgNnPx0ls1kjNyJBXWPTjiCeNi+5OVzzo4sd1vfcnTb2Iy1Kgl3CfOtNWnqC/SzSnn11zRjlroYoEJXsIeFFGD4a2SSNAt3VKmFaj+r9rk3xIf2g39bS8r0JZHqtFDi124n+DNreKYYJyfw1waZzkx7V9Fwg0N4Y/fo9GE8joXDBe9rPLoBonh/3AHNX4L+3NRhm7C6lFDgZeWf2Awu9UMbJiyQEuIgpJqjs6SK9M/BInRtp1d9tHrpk1OR+S1oj7Y6cZlwcM82qKdKfpJZaRFHDLtUVXsyf9ya1/9OC9A9zxvIl3zqrhRxhvXbc+9uRYLwMR0F8tZIAjt3YqG9EM3tdprYhqYJap4XZypX3suMKGca6pFfInpVjp0XKjYurwcV3tAys8AoJQrtCJHJSzpLV+2CCx7CJm/Jb7da1zm
 a3IV3WPN
 fSQLLBU7dy6HXeTorTOcSL3hAxUtTBCcFjqYEWc77E5dfzINzGxa4RXcXj/pt2WytvuPmrpVkcU91djYJl2XLwkNE8aiYBE6eAiB1C6j+3FWi+idym2CV6i6kN9eZnML0ajIQv+cHo7ENixU62ngQePI1xUXNp7kUlY4+95u+6eI1jrCRKMd2sO4/LMLy1rV/7Ahp/WZj6Mi3wbk+e/WGyh2wgTP7duFwtQKPvIB+ma5WevtPS9Try/8jLzFWg7s46tl4v9TODiMERR7oZPJb7t3S6K+aiU1qcnRpqJg0xJvrYAKJIfsr1ye6rdAYqijPOZS8H9oUQ0Knf91NcJqM7r0d/vERcH3tMLDHBXZ1ATdlg9gKe97vdIxSM1et991lGp76Uxpj7rBIR7u64N5EN6wSnfMR04tasCaFlhmmIh70Ut6NcFz5/VK0R1SaA5UTlDOuhKBF85O26hgf4QZgkxOpAz8wdcAIV35I1l93+hkU+Iw/UNr2Dpl1WSvQ/4lEOHYc4RA7KNJURuH1knMj7R5Gd9RAVqR8b56hxzwTxv9uYlzg3RhMaZ3tlDYhlwl675VUxvudbCm5a0IkunhI1mrT48Qan0O9Hxokj2EpXjKYSIF+XBVcq7tgaDT3cWj/pYy11H2iMXwkVaw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 06, 2026 at 04:34:47AM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential issue(s) to consider:
> - [High] arm64/mm: KASAN fault in p4d_offset_phys() during kasan_early_init()
> --
> 
> commit e9bf68a7a555b3c58c2a0a8736f337dde8136ab9
> Author: Anshuman Khandual <anshuman.khandual@arm.com>
> 
> arm64/mm: Use pgdp_get() for PGD accesses
> 
> This commit replaces READ_ONCE() with pgdp_get() for PGD accesses and moves
> p4d_offset() and p4d_offset_phys() from arch/arm64/include/asm/pgtable.h
> into arch/arm64/mm/mmu.c to avoid header include dependencies.
> 
> > diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> > index 5b5a85a0527d6..11015e1deb32f 100644
> > --- a/arch/arm64/mm/mmu.c
> > +++ b/arch/arm64/mm/mmu.c
> [ ... ]
> > @@ -2463,3 +2463,17 @@ pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
> >  	return pud_offset_lockless(p4dp, p4dp_get(p4dp), addr);
> >  }
> >  #endif /* CONFIG_PGTABLE_LEVELS > 3 */
> > +
> > +#if CONFIG_PGTABLE_LEVELS > 4
> > +phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
> > +{
> > +	VM_WARN_ON_ONCE(!pgtable_l5_enabled());
> > +
> > +	return pgd_page_paddr(pgdp_get(pgdp)) + p4d_index(addr) * sizeof(p4d_t);
> > +}
> 
> [Severity: High]
> Does moving p4d_offset_phys() (and pud_offset_phys() in the preceding patch)
> out-of-line into arch/arm64/mm/mmu.c cause a translation fault during early
> boot when KASAN is enabled with 5-level (or 4-level) page tables?
> 
> During early boot, __primary_switched calls kasan_early_init() before the
> KASAN shadow region is mapped. Because any KASAN shadow check will fault
> until kasan_early_init() finishes populating the early shadow page tables,
> arch/arm64/mm/Makefile disables KASAN sanitization for kasan_init.o:
> 
>     KASAN_SANITIZE_kasan_init.o := n
> 
> and set_swapper_pgd() in arch/arm64/mm/mmu.c is marked noinstr for the same
> reason.
> 
> When kasan_early_init() populates the shadow page tables, it calls into
> p4d_offset_phys() and pud_offset_phys():
> 
>     kasan_early_init()
>       kasan_pgd_populate(..., early=true)
>         kasan_p4d_populate(..., early=true)
>           kasan_p4d_offset(..., early=true)
>             p4d_offset_kimg()
>               p4d_offset_phys()
>           kasan_pud_populate(..., early=true)
>             kasan_pud_offset(..., early=true)
>               pud_offset_kimg()
>                 pud_offset_phys()
> 
> Previously, p4d_offset_phys() and pud_offset_phys() were static inline
> functions in arch/arm64/include/asm/pgtable.h, so calls from kasan_init.c
> were inlined into kasan_init.o and compiled without KASAN instrumentation.
> 
> Now that both functions live in arch/arm64/mm/mmu.c, which is KASAN-sanitized,
> the compiler emits KASAN shadow checks for their memory accesses (such as
> pgdp_get(pgdp), p4dp_get(p4dp), and vabits_actual) before the early shadow
> memory is mapped.
> 
> Should p4d_offset_phys() and pud_offset_phys() be marked noinstr or
> __no_sanitize_address?
> 
> -- 
> Sashiko AI review · https://sashiko.dev/#/patchset/20261105043403.3326445-1-anshuman.khandual@arm.com?part=4
> 

The kernel does fail to boot with CONFIG_KASAN enabled and PGTABLE_LEVELS = 5.
An example configuration would be as follows aka 'defconfig' with CONFIG_KASAN

------------------------
CONFIG_ARM64_4K_PAGES=y
CONFIG_ARM64_VA_BITS_52=y
CONFIG_ARM64_VA_BITS=52
CONFIG_ARM64_PA_BITS_52=y
CONFIG_ARM64_PA_BITS=52

CONFIG_KASAN_SHADOW_OFFSET=0xdfff800000000000
CONFIG_HAVE_ARCH_KASAN=y
CONFIG_HAVE_ARCH_KASAN_SW_TAGS=y
CONFIG_HAVE_ARCH_KASAN_HW_TAGS=y
CONFIG_HAVE_ARCH_KASAN_VMALLOC=y
CONFIG_CC_HAS_KASAN_GENERIC=y
CONFIG_CC_HAS_KASAN_SW_TAGS=y
CONFIG_KASAN=y
CONFIG_CC_HAS_KASAN_MEMINTRINSIC_PREFIX=y
CONFIG_KASAN_GENERIC=y
CONFIG_KASAN_INLINE=y
CONFIG_KASAN_STACK=y
CONFIG_KASAN_VMALLOC=y
------------------------

The following change fixes the problem. Although not sure if this is worth
the churn. Earlier vesion V3 might be a better trade off where all generic
pxdp_get() helpers were just copied over into the platform thus preventing
subsequent header to C movement in the first place which caused this KASAN
problem.

------------------------
diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 6a38de07e599..d0b3292ee18e 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -940,7 +940,7 @@ static inline void p4d_clear(p4d_t *p4dp)
                set_p4d(p4dp, __p4d(0));
 }

-static inline phys_addr_t p4d_page_paddr(p4d_t p4d)
+static __always_inline phys_addr_t p4d_page_paddr(p4d_t p4d)
 {
        return __p4d_to_phys(p4d);
 }
@@ -1057,7 +1057,7 @@ static inline void pgd_clear(pgd_t *pgdp)
                set_pgd(pgdp, __pgd(0));
 }

-static inline phys_addr_t pgd_page_paddr(pgd_t pgd)
+static __always_inline phys_addr_t pgd_page_paddr(pgd_t pgd)
 {
        return __pgd_to_phys(pgd);
 }
diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
index 1f56db9a946c..14e3b0387ed7 100644
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -2452,7 +2452,7 @@ bool pmdp_test_and_clear_young(struct vm_area_struct *vma, unsigned long address
 #endif /* CONFIG_TRANSPARENT_HUGEPAGE || CONFIG_ARCH_HAS_NONLEAF_PMD_YOUNG */

 #if CONFIG_PGTABLE_LEVELS > 3
-phys_addr_t pud_offset_phys(p4d_t *p4dp, unsigned long addr)
+phys_addr_t noinstr pud_offset_phys(p4d_t *p4dp, unsigned long addr)
 {
        VM_WARN_ON_ONCE(!pgtable_l4_enabled());

@@ -2466,7 +2466,7 @@ pud_t *pud_offset(p4d_t *p4dp, unsigned long addr)
 #endif /* CONFIG_PGTABLE_LEVELS > 3 */

 #if CONFIG_PGTABLE_LEVELS > 4
-phys_addr_t p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
+phys_addr_t noinstr p4d_offset_phys(pgd_t *pgdp, unsigned long addr)
 {
        VM_WARN_ON_ONCE(!pgtable_l5_enabled());

diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
index 780fe849ff8b..5e88015cdaac 100644
--- a/include/linux/pgtable.h
+++ b/include/linux/pgtable.h
@@ -511,14 +511,14 @@ static inline pud_t pudp_get(const pud_t *pudp)
 #endif

 #ifndef p4dp_get
-static inline p4d_t p4dp_get(const p4d_t *p4dp)
+static __always_inline p4d_t p4dp_get(const p4d_t *p4dp)
 {
        return READ_ONCE(*p4dp);
 }
 #endif

 #ifndef pgdp_get
-static inline pgd_t pgdp_get(const pgd_t *pgdp)
+static __always_inline pgd_t pgdp_get(const pgd_t *pgdp)
 {
        return READ_ONCE(*pgdp);
 }
------------------------

