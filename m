Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 125B5606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 10:19:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PDQeurKP
Received: by kanga.kvack.org (Postfix)
	id D21396B05B7; Wed,  4 Nov 2026 05:19:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CCE1A6B05B8; Wed,  4 Nov 2026 05:19:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBFA66B05B9; Wed,  4 Nov 2026 05:19:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 82C236B05B7
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 05:19:06 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 094831C3EFB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:19:06 +0000 (UTC)
X-FDA: 85397038692.01.0F6252A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6165140002
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 10:19:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDQeurKP;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793787544;
	b=eIeYIESw3zTz1KSqnCsyvhaApra0SS6dXQYBF0u9lsH+gvbOwjEcPXJF/E8c7QZYXOaszK
	In3EYyPKUkab8mFFheDvLQNfuv8O1PAUWaCfqTY+hn+C4NTzsMx0natYgzBrMNjgtEdpkm
	qmU5lVU4DM0/Y+RpzvVdgQeIIWrmJHc=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PDQeurKP;
	spf=pass (imf12.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793787544;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fiP7fB5tjE/bGKl5f01aEj0fMlw9+KJpQqj6fqgzLPc=;
	b=sM4HKiZ61CeduXOh41QpNK7ytBiVQhDVt72rW/rWMb9/wWIbVcK9xWRO84b/FoVTawo5Yg
	gMifUKA+p+bFIdnCMY9BZ2K2LPGKTavH90nDDxrxn96YTy7mvE/SB3KJ0ytdJz4YWFXXQq
	KBYZF40H6nzQFz5nKomQ3akvggI55kw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id AD91742489;
	Wed,  4 Nov 2026 10:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B084B1F000C1;
	Wed,  4 Nov 2026 10:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793787543;
	bh=fiP7fB5tjE/bGKl5f01aEj0fMlw9+KJpQqj6fqgzLPc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PDQeurKPFEncaZS7L+EWZ+ZejdN5Oz3Rqw8JaEYneHalY5vmCM8nBiwKZfL11kXhz
	 74gXRwaM4EIKl0ye0XRD8Yjgedj7TZc7r8b9o2woxDgg9PDmaN3IzK/kxfPm9fax1u
	 fV1+4b63zfuoSjTa5CChqt5UAFLnU8sph3Metnwgc5OJSTH9e/RAh/LX5+yH1eWhEx
	 qvaJhmHacyAjOPl3Mzv0XvaF8nuizArswi8mF+LnHlvkF6H+YVzNSQavY3LNRJ+cxa
	 DwIiWRGvcPb1e6KMSoWXlvr+A2181Of4/dZROZfdtQfh74W+24DYwgK7/8UqotVTF2
	 /5InOZnwOMh6Q==
Message-ID: <sashiko-outbox-197081@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v11 09/10] mm/vmalloc: map contiguous pages in batches
 for vmap() if possible
Reply-To: sashiko-reviews@lists.linux.dev
To: "Wen Jiang" <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com, will@kernel.org
Cc: "Xueyuan Chen" <xueyuan.chen21@gmail.com>, ajd@linux.ibm.com, anshuman.khandual@arm.com, baohua@kernel.org, chleroy@kernel.org, david@kernel.org, dev.jain@arm.com, jiangwen6@xiaomi.com, leo.yan@arm.com, maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org, ryan.roberts@arm.com
In-Reply-To: <20261103101658.766905-10-jiangwenxiaomi@gmail.com>
References: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
 <20261103101658.766905-10-jiangwenxiaomi@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 10:19:01 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6165140002
X-Stat-Signature: 3kenwfncci88egsozfubgqmjbiiu4jib
X-Rspam-User: 
X-HE-Tag: 1793787544-282413
X-HE-Meta: U2FsdGVkX18wM3KwKPgvwbH/o/I0iRZ+RzAF5/xx8KnWXB9bIw04+DvN4aIwFqHDm3yed/oI2ebFriTevT1ooEuNYSIbfPXNWc4Y/w72eLrW2MCAAzne3RjfsdQveWV7DO5+0DBHF+UClkCGW2n3uFJxXUKTshP9Ld0tabSBzdyyhQ/N8Md6dzInKeeAMi6Oj0T5X2WOJt+U6nBSoAybH1lenEsebiKRsLzc3IsRr8qEhBIip9fLsseQZTIeB8lxDxufSXspv0LY6omavJ3nPisWPu7//olGiTX+ZOGY8UKVwiZPGn+J9mEITX+5JzIMZr6mdZ3IanyGkI2QodivQgSpPMjBBWu8hqZsaMBNLWIGB6HIw5HupYdtALEUJ/DZnIKPBnSxWaycD7gO1JaR51s8WXuUVOdgvo8mG9qckTK9BMjs5gniSg/zPlhXR0FfvOpaOLVGzJzBHi8h7Z8a3k6RSuhGQqS3eCZ5d1OmvgWfEawTwncWBQNbHwXYYGgeA7kcl+29kbksvmkV8ndrW3qb/CBPmv7ejDkGVkiQTqRYJKbe5aBHBAgKXUXrDxvO+C1Uh3JCEV/IvB/m2uiUjlzUtMDNZ6MhttlS4RVNBAixCLuvckUT4i0N7eYPnIQVojUJCxxpN/QH6iwNe4YU5vZ89kmnETZ8a+NaIzd54ZQQurPRCajrRU1qWTyaRd0c35m7Mr1CS7W9ybM37q9XXG1sRid+PrbqlXWeFbXrZY5H5FmY2xjOTc/9jZVRgBVagWw09FOC1Tt669pX4KK3ylGFlAG72XU2B4o/ns6Lkxf/sZjY26SEA7yuSWeNtQZqVWle2zR5j0l1CNemtlkyArfaTr39unpIkizbsWn3dK4Hf+hWzhVCvYH9CNa+L+dnVv/uPTyla4dpTwt+5Ld5nxh0I9yTk3xvJCysj47yHD2nzStDPsQ+O+z4b4OfW/WeJq/QDUtIMgPmOZPxNXN
 SH1G6UWS
 CymvdI+0U4Ov07ayAAYWR+5Eu7cBfF6tvifq33q3mLAdrKGf9BMFuclaZjPewl3Wehh1tk27MnvWWxucrnOrDvITHHB1SXZvG4xRrx+8BtHVJ8WgrMANR73Zw4F7vyNyk7euWG89IKxzEbcTCXawf3u7EYV2fyzymbZ1ewhikSrn9z90THh+3WzqyKR61kwhdKOetqII5jJdJynLOJi+R28jwdljMf0rmvtvpmfaLiuQ7E/Cn5YzAADGvfdv0bOBBq4zNV+/MXnykKW1Hgc7KbDCIEFinMLxMhGTqNuVlCoLxDV5Cs1rML/myARAZjvmvSAHQPnd/reIDZ0abzKdXgT5RdvMP3yjQswSTjdbkFPkE+npkDcDGRIDWEYmSTJEijibhXXb7Y5pISQZehmjGUIrpVsb945R0M3ZVb1U4A9IPN1rqll9DmkdeDhkhmXQdLDqal9W1DjhfEAG8EyMF456XG8mXqFZ/IZxXcXAQfvn5jCWmbpcJ2QZGor5+WVVc7Dgj/Z9ZOggCGnj/oSKgNb0qJz2Sd5HnExZ+LBzGeatkvtjHI7d4ZsHUSHcy02BaQLjNev456Slm8Rd917xcmkyrqLX9hW3naC22mV45/b1Y4kIe/lDd5IorOadaa/KN/ziwtBzXOVj1FNsL420GTyrUe0hNfeMah/Gsn5DbBr207asyzeCRdPjrtnOHoF4f/L+B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] mm: physical memory overrun in vmap_pages_range_batched() acro=
ss PMDs
- [High] mm/vmalloc: missing VM_UNINITIALIZED in vmap() during huge PMD pro=
motion
--

commit 1baf52bf8f22bab279e2ffbca6ca7296ae8e5c51
Author: Barry Song (Xiaomi) <baohua@kernel.org>

mm/vmalloc: map contiguous pages in batches for vmap() if possible

This commit optimizes vmap() by scanning the input page array with
num_pages_contiguous() to detect physically contiguous page ranges and
coalescing ranges with the same mapping order into batched calls to
vmap_pages_range_noflush_walk().

> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index ee2c1ec4ff1f3..42b3addd20f98 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3613,6 +3613,85 @@ static inline unsigned int vm_shift(pgprot_t prot,=
 unsigned long size)
>  	return arch_vmap_pte_supported_shift(size);
>  }
> =20
> +static inline int get_vmap_mapping_order(struct page **pages,
> +		pgprot_t prot, unsigned int nr_pages)
> +{
> +	unsigned long pfn;
> +	unsigned int nr_contig;
> +	int order;
> +
> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMAP))
> +		return 0;
> +
> +	/* Limit nr_pages by pfn alignment */
> +	pfn =3D page_to_pfn(*pages);
> +	if (pfn > 0)
> +		nr_pages =3D min_t(size_t, nr_pages, 1UL << __ffs(pfn));
> +
> +	nr_contig =3D num_pages_contiguous(pages, nr_pages);
> +	if (nr_contig < 2)
> +		return 0;
> +
> +	order =3D ilog2(nr_contig);
> +
> +	if (vm_shift(prot, PAGE_SIZE << order) =3D=3D PAGE_SHIFT)
> +		return 0;
> +
> +	return order;
> +}
> +
> +static int vmap_pages_range_batched(unsigned long addr, unsigned long en=
d,
> +		pgprot_t prot, struct page **pages)
> +{
> +	const unsigned int nr_pages =3D (end - addr) >> PAGE_SHIFT;
> +	unsigned int prev_shift =3D 0, batch_idx =3D 0;
> +	unsigned long batch_start =3D addr, batch_end =3D addr;
> +	int err;
> +
> +	err =3D kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
> +					     PAGE_SHIFT, GFP_KERNEL);
> +
> +	if (err)
> +		goto out;
> +
> +	for (unsigned int i =3D 0; i < nr_pages; ) {
> +		unsigned int shift =3D PAGE_SHIFT +
> +			get_vmap_mapping_order(pages + i, prot, nr_pages - i);
> +
> +		if (!i)
> +			prev_shift =3D shift;
> +
> +		if (shift !=3D prev_shift) {
> +			err =3D vmap_pages_range_noflush_walk(batch_start, batch_end,
> +					prot, pages + batch_idx, prev_shift);
> +			if (err)
> +				goto out;
> +			prev_shift =3D shift;
> +			batch_start =3D batch_end;
> +			batch_idx =3D i;
> +		}
> +
> +		/*
> +		 * Once we fail to batch pages, we expect to fail batching
> +		 * for all remaining pages, so just give up.
> +		 */
> +		if (shift =3D=3D PAGE_SHIFT)
> +			break;
> +
> +		batch_end +=3D 1UL << shift;
> +		i +=3D 1U << (shift - PAGE_SHIFT);
> +	}
> +
> +	/* Remaining */
> +	if (batch_start < end)
> +		err =3D vmap_pages_range_noflush_walk(batch_start, end, prot,
> +				pages + batch_idx, prev_shift);

[Severity: Critical]
Can vmap_pages_range_batched() overrun a physical chunk and map unowned
physical memory when a coalesced batch of same-order chunks straddles a PMD
boundary?

In get_vmap_mapping_order(), nr_pages is bounded by physical PFN alignment
and physical contiguity via num_pages_contiguous(), returning the full
contiguity order (for example, order 8, shift 20 for 1MB chunks) without
bounding the order by the virtual address alignment of the current mapping
address.

vmap_pages_range_batched() then coalesces consecutive physically
discontiguous chunks that share the same shift into a single
[batch_start, batch_end) range passed to vmap_pages_range_noflush_walk().

In this commit, get_vm_area_caller() in vmap() only aligns area->addr to
PAGE_SIZE. Even with follow-up commit bba985c9d433 ("mm/vmalloc: align
vm_area so vmap() can batch mappings"), vmap_get_aligned_vm_area() only
aligns area->addr to 1UL << arch_vmap_pte_supported_shift(size)
(CONT_PTE_SIZE, 64KB on 4K-page arm64) whenever size < PMD_SIZE (or when a
PMD_SIZE-aligned KVA allocation falls back), and any preceding smaller-order
batch (such as an order-4 chunk before order-8 chunks) can also leave
batch_start aligned to CONT_PTE_SIZE rather than 1UL << prev_shift.

Looking at the call chain on arm64:

  vmap()
    vmap_pages_range_batched()
      vmap_pages_range_noflush_walk()
        vmap_pages_pmd_range()
          vmap_pages_pte_range()
            vmap_set_ptes()
              arch_vmap_pte_range_map_size()
              vmap_pte_set_huge()

arch/arm64/include/asm/vmalloc.h:arch_vmap_pte_range_map_size() checks only
CONT_PTE_SIZE alignment and then maps up to 1UL << max_page_shift:

    if (!IS_ALIGNED(addr, CONT_PTE_SIZE))
        return PAGE_SIZE;

    if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
        return PAGE_SIZE;

    size =3D min(end - addr, 1UL << max_page_shift);
    size =3D round_down(size, CONT_PTE_SIZE);
    return size;

Consider two physically discontiguous order-8 (1MB, 256-page, prev_shift 20)
chunks at PFNs P0..P0+255 and P1..P1+255 coalesced into a 2MB batch starting
at a CONT_PTE_SIZE-aligned address that is 512KB (128 pages) below a PMD
boundary (for example, batch_start =3D 0xffff800080180000,
batch_end =3D 0xffff800080380000 across PMD boundary 0xffff800080200000):

1. In the first PMD [0xffff800080180000, 0xffff800080200000),
   vmap_pages_pmd_range() clips next to the PMD boundary (512KB).
   arch_vmap_pte_range_map_size() returns min(512KB, 1MB) =3D 512KB, mapping
   pages[0..127] (PFNs P0..P0+127) and advancing *nr to 128.

2. At the start of the second PMD [0xffff800080200000, 0xffff800080380000),
   *nr is 128 (pages[128], PFN P0+128), so only 128 contiguous pages (512KB,
   PFNs P0+128..P0+255) remain in the first chunk before the physical
   discontinuity at pages[256] (PFN P1).

3. Because both addr (0xffff800080200000) and PFN_PHYS(P0+128) are aligned =
to
   CONT_PTE_SIZE (64KB) and end - addr is 1.5MB >=3D 1MB,
   arch_vmap_pte_range_map_size() returns size =3D min(1.5MB, 1UL << 20) =
=3D 1MB
   (256 pages).

4. vmap_pte_set_huge() then maps 256 contiguous physical pages starting at
   PFN P0+128 (PFNs P0+128..P0+383), mapping 128 pages (512KB,
   PFNs P0+256..P0+383) of unowned physical memory past the end of the first
   chunk into the vmap() range, while advancing *nr by 256 to 384 and
   skipping pages[256..383] of the second chunk.

The same overrun also occurs for two coalesced order-9 (2MB, prev_shift 21)
chunks when batch_start is CONT_PTE_SIZE-aligned but not PMD_SIZE-aligned,
because vmap_try_huge_pmd() fails in both PMDs and falls back to
vmap_pages_pte_range() with shift =3D 21.

Should get_vmap_mapping_order() also bound the mapping order by the virtual
address alignment of the current page or by the supported architectural map
size?

[ ... ]

> @@ -3656,8 +3735,7 @@ void *vmap(struct page **pages, unsigned int count,
>  		return NULL;
> =20
>  	addr =3D (unsigned long)area->addr;
> -	if (vmap_pages_range(addr, addr + size, pgprot_nx(prot),
> -				pages, PAGE_SHIFT) < 0) {
> +	if (vmap_pages_range_batched(addr, addr + size, pgprot_nx(prot), pages)=
 < 0) {
>  		vunmap(area->addr);
>  		return NULL;
>  	}

[Severity: High]
Could switching vmap() to vmap_pages_range_batched() without setting
VM_UNINITIALIZED on area expose a race with vread_iter() when a PMD is
promoted to a huge page?

In vmap(), get_vm_area_caller() publishes area in vn->busy without
VM_UNINITIALIZED before vmap_pages_range_batched() populates the page table=
s.
Previously, vmap() always passed PAGE_SHIFT to vmap_pages_range(), which on=
ly
allocated missing page tables and wrote leaf PTEs without freeing existing
page table pages.

With vmap_pages_range_batched(), when get_vmap_mapping_order() returns an
order >=3D PMD_SHIFT - PAGE_SHIFT over a virtual address range that previou=
sly
held 4KB mappings (leaving an empty present PTE table at *pmd after
vunmap_range_noflush()), vmap_pages_pmd_range() calls vmap_try_huge_pmd():

mm/vmalloc.c:vmap_try_huge_pmd() {
    ...
    scoped_cond_guard(mmap_read_lock_try, return 0, &init_mm) {
        if (!pmd_free_pte_page(pmd, addr))
            return 0;
        return pmd_set_huge(pmd, phys_addr, prot);
    }
    ...
}

Concurrently, a reader of /proc/kcore executing vread_iter() checks:

mm/vmalloc.c:vread_iter() {
    ...
    if (vm && (vm->flags & VM_UNINITIALIZED))
        goto next_va;
    ...
}

Because VM_UNINITIALIZED is not set by vmap() (unlike
__vmalloc_node_range_noprof() and kho_restore_vmalloc()) and vread_iter()
does not take init_mm.mmap_lock, vread_iter() proceeds into
aligned_vread_iter() -> vmalloc_to_page() -> __vmalloc_to_page():

mm/vmalloc.c:__vmalloc_to_page() {
    ...
    pmd =3D pmd_offset(pud, addr);
    if (pmd_none(*pmd))
        return NULL;
    if (pmd_leaf(*pmd))
        return pmd_page(*pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
    if (WARN_ON_ONCE(pmd_bad(*pmd)))
        return NULL;

    ptep =3D pte_offset_kernel(pmd, addr);
    pte =3D ptep_get(ptep);
    ...
}

If pmd_free_pte_page() and pmd_set_huge() run concurrently with
__vmalloc_to_page(), __vmalloc_to_page() can dereference a freed PTE page
table page, hit WARN_ON_ONCE(pmd_bad(*pmd)), or pass a newly installed huge
leaf PMD entry to pte_offset_kernel(pmd, addr).

Should vmap() set VM_UNINITIALIZED when allocating the vm_struct and clear =
it
via clear_vm_uninitialized_flag() after vmap_pages_range_batched() finishes?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103101658.7669=
05-1-jiangwenxiaomi@gmail.com?part=3D9

