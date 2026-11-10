Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F03260A260B
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:03:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W42SvcwD
Received: by kanga.kvack.org (Postfix)
	id 2EDFF6B05C5; Tue, 10 Nov 2026 11:02:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2C5D26B05C6; Tue, 10 Nov 2026 11:02:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1DBFA6B05C7; Tue, 10 Nov 2026 11:02:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4C066B05C5
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:02:57 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 920D61C4373
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:57 +0000 (UTC)
X-FDA: 85419677994.09.8A1E272
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CC11C40019
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:02:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W42SvcwD;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794326576;
	b=0d+YYEjAwrVhKjllWh9h6DHGWkuOdkYomxSDiO+JY5IfUjbdU1CYHD+9IbeY8TDgutW5PA
	2P+iHmIxtR+lMC/G0Wfjrauhk4mSTBBfrpARJO8QsRNCRpk/to/SIhoNJQ86nSDtwN7YMv
	TQRpaM4ckp4eWMjij4SrkoJzjhH0mu4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=W42SvcwD;
	spf=pass (imf07.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794326576;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PTzsHM7YGWcDrgttoGhFATlI9S7wA3QHEkEgkP8JfpA=;
	b=Lja8sbLrsS9WyLNk2mQ21YfxHBEFzbQtJraxSZEH7eI3It8nkxiWW56HrOtP1xST+qXk/A
	2zmE49wNArtwcjWgUV2M1Z/iaFSrcFQLEjcZZiV5w5OxUMYlp87Bdayri61tZDrKD8KzKZ
	bp9SmxrrXSiAllEuuRKs+o+ydOrCffQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2581F411DF;
	Tue, 10 Nov 2026 16:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 796D81F0089F;
	Tue, 10 Nov 2026 16:02:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794326575;
	bh=PTzsHM7YGWcDrgttoGhFATlI9S7wA3QHEkEgkP8JfpA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=W42SvcwDDTlyJkQtv//HiQ5F9a86+Db4LQ8mVjfipEBlofd2ExiUohrB427G4Gdqr
	 jipCMyk9cAorpcOPaVW2xFz5xL1ZHm0VUFRShUhbY7/65CAIQuSYb8jsZg2jdMdCHH
	 GB1qSW0ePow7L33VXrT0eDVKzRtslVvDYl9O4XuaC+AT4AkgczkqDqzB7+sEEkWIi3
	 zTu4dTzmiEjwPf4kcuNBSKhjCJnDvQskfvsa+FqYy7Ysmkguum5n5pUcpzc81Tfn0p
	 06dj6EdIsgloQQhSoKlch0PmUOqwFb14dEHLgCKWXGLVtqV2uovmwvjkQ61LUQUZ2y
	 9mfuJW8KsefLg==
Message-ID: <sashiko-outbox-207327@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH RFC v10 13/22] mm: kpkeys: Protect early kernel page
 tables
Reply-To: sashiko-reviews@lists.linux.dev
To: "Kevin Brodsky" <kevin.brodsky@arm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Ard Biesheuvel" <ardb+git@google.com>, "Andy
 Lutomirski" <luto@kernel.org>, "Catalin Marinas" <catalin.marinas@arm.com>, "Dave
 Hansen" <dave.hansen@linux.intel.com>, =?utf-8?b?RGF2aWQgSGlsZGVuYnJh?=
 =?utf-8?b?bmQgKEFybSk=?= <david@kernel.org>, "Jann Horn" <jannh@google.com>, "Jeff
 Xu" <jeffxu@chromium.org>, "Joey Gouly" <joey.gouly@arm.com>, "Kees Cook" <kees@kernel.org>, "Linu
 Cherian" <linu.cherian@arm.com>, "Linus Walleij" <linusw@kernel.org>, "Marc
 Zyngier" <maz@kernel.org>, "Mark Brown" <broonie@kernel.org>, "Matthew
 Wilcox" <willy@infradead.org>, "Maxwell Bland" <mbland@motorola.com>,
 =?utf-8?b?TWlrZSBSYXBvcG9ydCAoSUJNKQ==?= <rppt@kernel.org>, "Peter Zijlstra" <peterz@infradead.org>, "Pierre
 Langlois" <pierre.langlois@arm.com>, =?utf-8?b?UGllcnJlLUNsw6ltZW50IFRv?=
 =?utf-8?b?c2k=?= <ptosi@google.com>, "Quentin Perret" <qperret@google.com>, "Rick
 Edgecombe" <rick.p.edgecombe@intel.com>, "Ryan Roberts" <ryan.roberts@arm.com>, "Vlastimil
 Babka" <vbabka@kernel.org>, "Will Deacon" <will@kernel.org>, "Yang Shi" <yang@os.amperecomputing.com>, "Yeoreum
 Yun" <yeoreum.yun@arm.com>, linux-mm@kvack.org, x86@kernel.org, "Ira Weiny" <iweiny@kernel.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Thomas Gleixner" <tglx@kernel.org>
In-Reply-To: <20261109-kpkeys-v10-13-aa6c4d9603bc@arm.com>
References: <20261109-kpkeys-v10-0-aa6c4d9603bc@arm.com>
 <20261109-kpkeys-v10-13-aa6c4d9603bc@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 10 Nov 2026 16:02:53 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CC11C40019
X-Stat-Signature: am1giudnuxj14quwhbsdi89fthrsj9cz
X-Rspam-User: 
X-HE-Tag: 1794326575-598246
X-HE-Meta: U2FsdGVkX18A9p8zeXcLatJlvrJy0ZQtoGfsgZOmABAqhIl/zQw0C9kSH/JEGMHMAsMlwQLB8DJPoL/FIFhXH7Nvf4Hxr+ZZNsV7H3WmPOx3w26dA2jGsgIR6BKUEfSuHn80ivkLkAZf4nAnWyTYERrTh3O2yxyJoIjWFq9fvTsEE73cRKpHjjA8cHzbp1Q7tGZLur84Ca+jROzoqukLuFPF34KLNgecRC4kI2BvqwI+vEmsBM6PJ5XtuHUMDNADWJ036zdl5EUwcMO4wQzoDux95MZTB3ZTdzph5FZJP3Pzl34CmCkRumFImuJ3J/fn+0BGqlrV5OtHUtsx85zMJ+YHY8NQDPXFWhghKfIjtu54rf1bTO+VgsEa9PHfJOSbwbvmwBEQr/E/u4hev9ce/Nwl9HeFdrQy+VRaDd/82rWamFM00Codm8PYxmsRCbTiZTwTigOg1QXsGXziVp5p/hBmPlsNJtJPYfWIV0obwxlhH2u/5cEha2LWVRhZw7sHvnDXP41nG11DyiFqVveRCecy5xyyY9lGsrdNbbUEeQPEWcR2LmrjLB1NXEtdCcG5NCYPygFkXLJbSRuPOV1AvHcTfUo2WIA7fZHkituzZBV1YAjkMRwpsJ9oQi9DvG6r+EzjzZGTum/PpP4G8wXuWp30T4GauT8zVWRmSqhJ88NvLhKi8E/YusTGgc0crAih/7ECDzHVr/RZV74q6ZFCHs1whH6gc9Yo7+dPDjMAUBRg5k2ypduu0BCSawzVWlngqdWlsITcA48gc6O1LPAVX0bAX4iJV8XB7LioS5lkkutWMYVQU9JpFCWvNkB5Bv0aUzeKawRECySPt4zkr3GXHFk5Z8kkG3m230mKsrU8jUsvembCYwGGDePn0E3uSrBcED1bhbuCvX6xGDFbqUHw/z/7wjSq2030TNnzhCeLwteFTcJeZHE6J2ubcOBuVeU4lM3ouaKsBctOqcEZIZC
 c+RnPH5H
 cnvkDlY3vzMm3LTXLHz9EKIlsJZXSf7nNKarz0581FOkjJYV+gamGlD09RzJ+kd68Nso25oBOOr1j/ihBxI5MKARzcF/h8yJmvxxv9M9ULcgddLAelSQmkY4sjaZDcizMpUK9rslF1eEQiS+C8F+0jLc8vA07oPVpvu3ZLYVZ871eR8F29b/C546rrplsR5N3LLzTqfyGCv64vD5ztlPywksQvCyqP09NB74DWDHHk2YK9zg5TyH5SFxCNYoyQRrSoXBa7Q+qbaerPodlNHh4DnRerEOCSyGOskEjs45gjEIBFSkGqSXubNJL2Or7cHMvjb2q7oQWFvNMPlYq4FjrIJ+EkotQE9xP15pSD/mYEjTsA/IOnFQ6/m1HZzrX6MWgPyLfVLzw8eY5TkInpz3IJ1AOpexizB1WVOw7hqsU5DbNKABrtXFCHiEWfMzzx0eApqKQCQmgJEJaIJptzXa4FWljhiYW513OwwpHU+3fQt5fg9p8Y7zy2AgvT6qebpSRVDoykg30N8oQWTL1Up0e8VVSfIBok3eoYDuFtmUJNPrOmv+TjgrnaEC5QEO6md5URgCGMyR9IU+PkyTwszvgMmn2OeFaJljnlB5xW8UMpUarh9HSdey1XxSCarMThO7kycoyyfbkWy5ZvyX9obuPA4DuuzPxivdojgm6KBZt0WyAgMNXrXfnrCiKOO8/Cj1TZvCGRanT7YC/nuxP3fiJ8do+8CUOMMYab3gZ9TmFrB8XsZs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Medium] mm: kpkeys: redundant KASAN shadow walks in
  protect_early_kernel_pgtables()
- [Medium] mm: kpkeys: repeated swapper_pg_dir walks in
  protect_early_kernel_pgtables()
--

commit 9b67b4dcc54e06a0681d8d0ff9c11cb3015125f0
Author: Kevin Brodsky <kevin.brodsky@arm.com>

mm: kpkeys: Protect early kernel page tables

This commit walks the installed kernel page tables during boot and sets the
direct-map pkey of their backing pages to KPKEYS_PKEY_PGTABLES when
kpkeys_hardened_pgtables is enabled.

> diff --git a/mm/kpkeys_hardened_pgtables.c b/mm/kpkeys_hardened_pgtables.c
> index 2311fd8da6bbb..f6825a0e0689d 100644
> --- a/mm/kpkeys_hardened_pgtables.c
> +++ b/mm/kpkeys_hardened_pgtables.c
> @@ -54,10 +56,130 @@ void kpkeys_pgtable_free(struct page *page, unsigned=
 int order)
>  	__free_pages(page, order);
>  }
> =20
> +static void __init protect_pgtable_page(void *page)
> +{
> +	int ret;
> +
> +	ret =3D set_direct_map_pkey((unsigned long)page, 1, KPKEYS_PKEY_PGTABLE=
S);
> +	WARN_ON_ONCE(ret);
> +}
> +
> +static int __init protect_pte_table(pmd_t *pmd, unsigned long addr,
> +				    unsigned long next, struct mm_walk *walk)
> +{
> +	pmd_t entry =3D pmdp_get(pmd);
> +
> +	if (!pmd_present(entry) || pmd_leaf(entry))
> +		return 0;
> +
> +	protect_pgtable_page(pte_offset_kernel(pmd, 0));
> +
> +	return 0;
> +}
> +
> +static int __init protect_pmd_table(pud_t *pud, unsigned long addr,
> +				    unsigned long next, struct mm_walk *walk)
> +{
> +	pud_t entry;
> +
> +	if (mm_pmd_folded(walk->mm))
> +		return 0;
> +
> +	entry =3D pudp_get(pud);
> +	if (!pud_present(entry) || pud_leaf(entry))
> +		return 0;
> +
> +	protect_pgtable_page(pmd_offset(pud, 0));
> +
> +	return 0;
> +}
> +
> +static int __init protect_pud_table(p4d_t *p4d, unsigned long addr,
> +				    unsigned long next, struct mm_walk *walk)
> +{
> +	p4d_t entry;
> +
> +	if (mm_pud_folded(walk->mm))
> +		return 0;
> +
> +	entry =3D p4dp_get(p4d);
> +	if (!p4d_present(entry) || p4d_leaf(entry))
> +		return 0;
> +
> +	protect_pgtable_page(pud_offset(p4d, 0));
> +
> +	return 0;
> +}
> +
> +static int __init protect_p4d_table(pgd_t *pgd, unsigned long addr,
> +				    unsigned long next, struct mm_walk *walk)
> +{
> +	pgd_t entry;
> +
> +	if (mm_p4d_folded(walk->mm))
> +		return 0;
> +
> +	entry =3D pgdp_get(pgd);
> +	if (!pgd_present(entry) || pgd_leaf(entry))
> +		return 0;
> +
> +	protect_pgtable_page(p4d_offset(pgd, 0));
> +
> +	return 0;
> +}

[Severity: Medium]
When CONFIG_KASAN_GENERIC or CONFIG_KASAN_SW_TAGS is enabled, does this walk
and call set_direct_map_pkey() millions of times on the shared
kasan_early_shadow_{p4d,pud,pmd,pte} tables?

kasan_init() runs in setup_arch() before mm_core_init() calls
kpkeys_hardened_pgtables_init(), populating unbacked shadow ranges in
[PAGE_OFFSET, ULONG_MAX) with shared static tables where all 512 entries at
each level point to the same next-level kasan_early_shadow_* page.  Unlike
mm/ptdump.c, which detects those tables and sets walk->action =3D
ACTION_CONTINUE, the callbacks here descend through every entry and invoke
set_direct_map_pkey() (including a direct-map page table walk and broadcast
TLB flush) for every 2 MiB PMD slot across the multi-terabyte shadow range,
stalling boot.

[ ... ]

> +static void __init protect_early_kernel_pgtables(void)
> +{
> +	int ret;
> +
> +	mmap_write_lock(&init_mm);
> +	/*
> +	 * [PAGE_OFFSET, ULONG_MAX) covers all early kernel mappings on arm64
> +	 * and x86 (at least).
> +	 */
> +	ret =3D walk_kernel_page_table_range(PAGE_OFFSET, ULONG_MAX,
> +					   &protect_pgtable_ops, NULL, NULL);
> +	mmap_write_unlock(&init_mm);
> +	WARN_ON_ONCE(ret);
> +}

[Severity: Medium]
On arm64 with CONFIG_ARM64_LPA2=3Dy running on hardware where the top page
table level is dynamically folded (vabits_actual < VA_BITS), does starting
at PAGE_OFFSET walk and re-protect swapper_pg_dir 16 or 32 times?

On arm64, PAGE_OFFSET is the compile-time _PAGE_OFFSET(VA_BITS) rather than
_PAGE_OFFSET(vabits_actual).  When !pgtable_l5_enabled() on 4K pages (or
!pgtable_l4_enabled() on 16K pages), pgd_none() is always false and
pgd_to_folded_p4d() (or p4d_to_folded_pud()) wraps each top-level step in
[PAGE_OFFSET, ULONG_MAX) back to the start of swapper_pg_dir:

arch/arm64/include/asm/pgtable.h:pgd_to_folded_p4d() {
	return (p4d_t *)PTR_ALIGN_DOWN(pgdp, PAGE_SIZE) + p4d_index(addr);
}

As a result, walk_kernel_page_table_range() traverses the entire kernel page
table hierarchy and flushes TLBs across all page table pages 16 times on 4K
pages (or 32 times on 16K pages) during boot.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261109-kpkeys-v10=
-0-aa6c4d9603bc@arm.com?part=3D13

