Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3CCC606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:22:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Jrap7F9O
Received: by kanga.kvack.org (Postfix)
	id DC7C66B08A4; Thu, 22 Oct 2026 02:22:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78476B08A6; Thu, 22 Oct 2026 02:22:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C41E76B08A7; Thu, 22 Oct 2026 02:22:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9528B6B08A4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:22:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1E036160746
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:22:53 +0000 (UTC)
X-FDA: 85349269026.05.BE9E8BF
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf23.hostedemail.com (Postfix) with ESMTP id 80859140009
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:22:51 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jrap7F9O;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792650171;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w/yfjiqIdvan+tzw/4666AzrT45OIjcjfTPwTJTEOYw=;
	b=3aq8tk1f3S1Kk4hkDIyHuwMRDCUrR795wog1LmcUnYRYw7OFDN2j5CszTva+j7eDRzysqK
	0im0sUwVVeFi0f9uNsKW3bE7fEyqHBCeS7vW+lsKTp49BxEOauPLIEXsF7AMxLFZ02/x2F
	LF3bsLJZetY25TtAYCcv7jVOuXFUkc4=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Jrap7F9O;
	spf=pass (imf23.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792650171;
	b=fJSR5M3PzEtkaxhfNvMGytpt09ptXSUc12gowd6wItA/Q6NmCA1vrbaMl9zRbf62fWhohp
	eqncWq0tJevWNePhu5QJZlAUJk/d+8wrDR4IT4JHhiIg94vWC4pzFLYWwZ7FHt4ns6QmfG
	iXm4fIaHEC0Pj3TbV6F2wAlSYF/XsDc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2438460211;
	Thu, 22 Oct 2026 06:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559FF1F000C1;
	Thu, 22 Oct 2026 06:22:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792650170;
	bh=w/yfjiqIdvan+tzw/4666AzrT45OIjcjfTPwTJTEOYw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Jrap7F9OxJ01g8nuVBWwIiZv55ktyzaGuk8slKZbOwP/c5zyJdhOXzCInEbwGV3Z0
	 iszXQiopKursZh+dIcDq51UpZuHSyG4hOruvBlEeYbhUgfbixk26sZ25n/k7LTzFjy
	 vsYAAkXebB97ZoIkTWLegUZuH790Ih/eP9EI0jftUqcwk7m3xFfNOB3vwbVu4UcnTO
	 W6G1UkmX64yyxANrhy/rWHvXuk4fT2+syiXuhFg651WynN0HiFV2MLvPAd/yulAmOY
	 uRMxyMkpL9YR1PyOgHtopHl50YlFqlXhdldpUA1U8lsPf9n5r43QqN9l6JoewlEhwF
	 7U+bHaai4//ZQ==
Message-ID: <sashiko-outbox-181090@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH] LoongArch: mm: avoid backing vmemmap beyond max_pfn
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wentao Guan" <guanwentao@uniontech.com>, chenhuacai@kernel.org
Cc: kernel@xen0n.name, linux-mm@kvack.org, akpm@linux-foundation.org, rppt@kernel.org, david@kernel.org, muchun.song@linux.dev
In-Reply-To: <20261021062115.116922-1-guanwentao@uniontech.com>
References: <20261021062115.116922-1-guanwentao@uniontech.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:22:49 +0000
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 80859140009
X-Stat-Signature: jdexcgqi4tj1z3x1cgyscpioapntfbe1
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1792650171-566438
X-HE-Meta: U2FsdGVkX18GAK7nhn8+4UdZPvM0ukWDpi3NeqJ0f4qNWHaJPNizhHYUNLNbpJGgkJ/uHtNSBsrbphQAUkqnYBYfn9ePmx/hQnaS5RqtJZ4s5kXpm697/89Ew9Pbp9EF1b/fX4qK4ZdnC8jbIBa4CQmgvx7UUi+G/PqoGRGTDShvaCjl9W9EhFLg1tx5yLLXaxQtWRsAfdoqExZaKmMLk3mpNPn0NZLD7s5iUOup/vm/RFL9aMP40sxLC9zlFiqV+A00XY6eq7yV0GMRlgGqFTsL3wOzGzURhvBgilUSEMgC1pUgNXJG/k1GM05UP3ldBrGg4aYam1qtR21aEvOWRCXc8iVxnmTZ+30eE8cBENVRpqsBIEbAswDrmJ2xMFhz2Rg8XKnymUQed8i0K62MfIw3en43kCYaHjhB/p2U1rMCi+dtLdRlCg5ubDnzYYkG/9Dim3JPlHk2c1Vd++0OmLIibaIkR95RmxRc+pdyCcvr9SOFLW7qi2vDtKwAnhz0DOJDiod8Ywnug2eFq5DdWBYVxk5RWWt5O8+Nz2B1tW5ODvwIkEsqYXPWXA0nJkpew8rWbvXQ5Obd/1P6oHta5PFH0sGIHG39A5d/JFB6rxoG3UNX+YW+gwHPor1aK7hfQf5FfyeM2ZzhO4IgqOLQF8PFcF0J46j75OViOMFWASCjfH8l087Y8z36fRmQdA8LuW7vD/1JT2riFsVYj2GPbs0FuJT0SxcMcR4PURZIBUt4WXQ1cdSRQLQOKvbXKyed46sGeD+HeyCc4+DzUj8lxjcAHuzHMOqDSC865UPCj2XPCFHIRQ2EPAwJJ8hdNnhnPaL2LFJ4IzNaR8DFKiriZwYsdsWGldvYCvYL0vEGAVnVNxY+eOSBA7ry4fNrYRsReRGBuiOj6Wi+8JthW5aXYeD0acqQcrn8K5YegwacdOa9VeT+eBnHw3i8Qcg4vpDcHEXeAosBIXxqWggHG1D
 9UPr/An4
 HSgyplBNopGsLUsgLgHcy05lEPzuQNUKauDCXWd0Di/rCCfRjwh7lAywm/wDTfnmqDq3U4OHdMflh8LUU8ERYFQE7b+vW6seTYevqolaUobArUI8FbHVsRxWqESFrNVIFYdYXSqi6uHj284xXvkBzUJEomkvL7Yek0g3ESD4SDHpEsksAMSY3EMfc7TmmpmYFySrFmgzbKcIYbkitACHBO8lBgr6jSc5f0F0kxaezxdLgzgfrVOpgNH60cAZ96LmyKAzvBn2zX5iZyn3faOCIQiP2t2CUDYEkZGRHt93KRF75NcFo7UXu6MvJLtAl7VklnCCeqMjOFgNeA0abc9zpNIdZCaniRZIg+Lkwiq5QUcaW6AVPjTRg8k0cFFPsM0uxp/z7rsnv4nNa3YpACIdS+psG/XC0Q+BbucwW63ispwevHzhoZNjiT2FqO0TIGkhdPzo98om3yaQ0Gs0cm7As0wsFqwwzMZHk3nLdASpGVRtM256SnKFgEtXGEDnX9zbHcjJPrcpzO99BPN/zZXPuDU64M3GKkhilSdYbFdYxZv0qyPtEsFbVRToQU3SUat6bVfyG1a2SlsGPNoD9BwjZlJG5g9lG570XHP1Ie/KOH82A3h9ibcGUz3h2O7bTredoDkldZi8YE+57PITWxUXkPRtPSh8/DFutkPVQo47SYOCcelc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] loongarch/mm: leaf PMD dereferenced as PTE table in vmemmap_popula=
te()
- [Medium] LoongArch: mm: vmemmap_populate() forces basepages for hotplugge=
d memory above boot max_pfn
- [Medium] LoongArch: mm: unnecessary basepage vmemmap fallback in vmemmap_=
populate()
--

commit 6672ecaf8ad946ad85463c3a10b46da193101efe
Author: Wentao Guan <guanwentao@uniontech.com>

LoongArch: mm: avoid backing vmemmap beyond max_pfn

This commit changes vmemmap_populate() on LoongArch to fall back to
vmemmap_populate_basepages() when !altmap and the PMD covering start
extends beyond pfn_to_page(max_pfn), avoiding PMD hugepage mappings that
extend past max_pfn.

> diff --git a/arch/loongarch/mm/init.c b/arch/loongarch/mm/init.c
> index f801f7097f037..8c33744b93fae 100644
> --- a/arch/loongarch/mm/init.c
> +++ b/arch/loongarch/mm/init.c
> @@ -146,6 +146,11 @@ int __meminit vmemmap_populate(unsigned long start, =
unsigned long end,
>  #if CONFIG_PGTABLE_LEVELS =3D=3D 2
>  	return vmemmap_populate_basepages(start, end, node, NULL);
>  #else
> +	unsigned long vmemmap_end =3D (unsigned long)pfn_to_page(max_pfn);

[Severity: Medium]
How does this check behave when memory is hot-added above initial boot DRAM?

On LoongArch, max_pfn is only initialized during early boot from
PFN_DOWN(memblock_end_of_DRAM()) in arch/loongarch/kernel/mem.c:

void __init memblock_init(void)
{
	...
	max_pfn =3D PFN_DOWN(memblock_end_of_DRAM());

and in arch/loongarch/kernel/setup.c:

static void __init arch_mem_init(char **cmdline_p)
{
	/* Recalculate max_low_pfn for "mem=3Dxxx" */
	max_pfn =3D PFN_DOWN(memblock_end_of_DRAM());

When memory is hot-added at runtime via:

  arch_add_memory()
    __add_pages()
      sparse_add_section()
        section_activate()
          populate_section_memmap()
            __populate_section_memmap()
              vmemmap_populate()

or via memremap_pages() without an altmap at physical addresses above boot
DRAM (pfn >=3D max_pfn), max_pfn is never updated, so start >=3D vmemmap_en=
d and
(!altmap && (start & PMD_MASK) + PMD_SIZE > vmemmap_end) is unconditionally
true.

Since get_order(PMD_SIZE) <=3D MAX_PAGE_ORDER on 64-bit LoongArch across 4K=
iB,
16KiB, and 64KiB page sizes, vmemmap_populate_hugepages() can allocate
PMD_SIZE blocks at runtime. Won't comparing against max_pfn unintentionally
force all non-altmap hotplugged memory above boot DRAM to fall back to
vmemmap_populate_basepages()?

[Severity: Medium]
Should vmemmap_end be aligned up to PAGES_PER_SECTION and gated on PMD_SIZE
exceeding the section vmemmap size?

During early boot, sparse_metadata_init_nid() in mm/sparse.c always populat=
es
a full PAGES_PER_SECTION range for every present section:

	for_each_early_section_nr(start_section_nr, section_nr) {
		...
		mem_map =3D __populate_section_memmap(pfn, PAGES_PER_SECTION, nid,
						    NULL, NULL);

So falling back to vmemmap_populate_basepages(start, end, node, NULL) still
populates the entire section up to SECTION_ALIGN_UP(max_pfn). However, in
memblock_init() in arch/loongarch/kernel/mem.c, EFI_RESERVED_TYPE and
EFI_RUNTIME_SERVICES_* regions at the top of DRAM are only passed to
memblock_reserve() (not memblock_add()), or DRAM may be capped with mem=3D,
leaving max_pfn unaligned inside the final section of a PMD. If all 16
sections of a 32MiB PMD on a 16KiB page kernel are present, but max_pfn is
unaligned within the 16th section, (start & PMD_MASK) + PMD_SIZE > vmemmap_=
end
is true for all 16 sections even though the entire 32MiB PMD is populated,
allocating an extra PTE page table page and losing the PMD mapping while
saving zero vmemmap pages.

Additionally, on 4KiB page kernels (CONFIG_4KB_3LEVEL and CONFIG_4KB_4LEVEL=
),
SECTION_SIZE_BITS in arch/loongarch/include/asm/sparsemem.h is 29 (512MiB, =
or
131072 pages), so one section's vmemmap is 8MiB, spanning four 2MiB PMDs.
vmemmap_populate_hugepages() never maps past the section end on 4KiB page
kernels, yet if max_pfn falls within the first 2MiB PMD of the last section,
(start & PMD_MASK) + PMD_SIZE > vmemmap_end forces the entire 8MiB section =
to
use 4KiB base pages instead of four 2MiB PMDs.

> +
> +	if (!altmap && (start & PMD_MASK) + PMD_SIZE > vmemmap_end)
> +		return vmemmap_populate_basepages(start, end, node, NULL);
> +
>  	return vmemmap_populate_hugepages(start, end, node, NULL);

[Severity: High]
Can calling vmemmap_populate_basepages() here dereference a leaf huge PMD a=
s a
PTE page table pointer and crash the kernel?

In arch/loongarch/mm/init.c, vmemmap_set_pmd() installs a leaf huge PMD
containing a shifted physical PFN and hardware page flags:

void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
			       unsigned long addr, unsigned long next)
{
	pmd_t entry;

	entry =3D pfn_pmd(virt_to_pfn(p), PAGE_KERNEL);
	pmd_val(entry) |=3D _PAGE_HUGE | _PAGE_HGLOBAL;
	set_pmd_at(&init_mm, addr, pmd, entry);
}

whereas a non-leaf PMD on LoongArch stores the kernel virtual address of the
PTE table (arch/loongarch/include/asm/pgtable.h):

static inline int pmd_none(pmd_t pmd)
{
	return pmd_val(pmd) =3D=3D (unsigned long)invalid_pte_table;
}
...
#define pmd_page_vaddr(pmd)	pmd_val(pmd)

While vmemmap_populate_hugepages() checks vmemmap_check_pmd() before reusing
an existing PMD, vmemmap_populate_basepages() in mm/sparse-vmemmap.c calls
vmemmap_pmd_populate() and then vmemmap_pte_populate():

static pmd_t * __meminit vmemmap_pmd_populate(pud_t *pud, unsigned long add=
r, int node)
{
	pmd_t *pmd =3D pmd_offset(pud, addr);
	if (pmd_none(*pmd)) {
		...
	}
	return pmd;
}

static pte_t * __meminit vmemmap_pte_populate(pmd_t *pmd, unsigned long add=
r, int node,
		struct vmem_altmap *altmap)
{
	pte_t *pte =3D pte_offset_kernel(pmd, addr);
	unsigned long pfn =3D page_to_pfn((struct page *)addr);

	if (pte_none(ptep_get(pte))) {

If *pmd is already a leaf huge PMD, pmd_none(*pmd) is false, so
vmemmap_pmd_populate() returns the leaf PMD unchanged and
vmemmap_pte_populate() treats pmd_val(*pmd) as a kernel virtual address in
pte_offset_kernel() and dereferences it in ptep_get(pte).

Because vmemmap_populate() passes NULL for altmap to both helpers and
vmemmap_free() in arch/loongarch/mm/init.c is a no-op, a leaf huge PMD can
already be present when vmemmap_populate_basepages() runs in two ways:

1. In a PMD straddling or above max_pfn, populating a range with
   altmap !=3D NULL (for example via memremap_pages() -> arch_add_memory() =
->
   __add_pages() -> sparse_add_section()) skips the !altmap branch and calls
   vmemmap_populate_hugepages(start, end, node, NULL), which installs a leaf
   huge PMD covering the entire PMD (up to 16 sections on 16KiB pages). A
   subsequent population in the same PMD with altmap =3D=3D NULL (via add_m=
emory()
   or memremap_pages() without altmap, or after memunmap_pages() since
   vmemmap_free() is a no-op) then takes the vmemmap_populate_basepages() p=
ath
   on that existing leaf huge PMD.

2. On 4KiB page kernels, a 512MiB section's vmemmap is 8MiB (four 2MiB PMDs=
).
   When max_pfn falls in the 2nd, 3rd, or 4th PMD of the last section,
   (start & PMD_MASK) + PMD_SIZE > vmemmap_end only tests the first 2MiB PMD
   (which is <=3D vmemmap_end), so vmemmap_populate_hugepages() installs le=
af
   huge PMDs for all four PMDs (also still mapping vmemmap beyond max_pfn in
   the trailing PMDs). If that section is later hot-removed (leaving the fo=
ur
   leaf huge PMDs in place because vmemmap_free() is empty) and a range
   starting in one of the trailing PMDs above vmemmap_end is populated with
   altmap =3D=3D NULL, (start & PMD_MASK) + PMD_SIZE > vmemmap_end is true =
and
   vmemmap_populate_basepages() runs against the existing leaf huge PMD.

>  #endif
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021062115.1169=
22-1-guanwentao@uniontech.com?part=3D1

