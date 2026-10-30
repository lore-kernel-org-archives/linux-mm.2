Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DCB57606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 14:44:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SRBbpSBh
Received: by kanga.kvack.org (Postfix)
	id E57E66B05C0; Fri, 30 Oct 2026 10:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E095D6B05C1; Fri, 30 Oct 2026 10:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF8D96B05C2; Fri, 30 Oct 2026 10:44:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A2E9C6B05C0
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:44:55 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 25CD51406E3
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:44:55 +0000 (UTC)
X-FDA: 85379564550.04.C4F664A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 7226740003
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 14:44:53 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SRBbpSBh;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793371493;
	b=waWbbCLsiI0FaPcJkCNUcdg84GX2E+e8auMBm5vrlNdDAAI6zj9DTdFBbbygaR729LrQyV
	1+fS+Y9JlZnzZ7F+32fuDIAxApiHGFP5WnBhgTSVCZOX35B03Gni3JOy0B6l/rPgrKWd8x
	z6aLYctduC/zH37mFPUsJqIBHlgl/QI=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SRBbpSBh;
	spf=pass (imf27.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793371493;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aZXf/CiAEOj3syudgngCaaHilsxgeSJVS9oPEnBDhwo=;
	b=yO/SbI3rmWmYgS/i0GOgcmlGk8x43lItZ2QyvmkOnKhrzHDfuy3G1CWGORjUYYZWsEmY22
	O+zisc22DW2oj8mn/zW87jy4gaISPZZ0wOI402VmM34MQtx/AZBCsdeJUWPuVQcxrXf2nP
	1oVpmZDaBGO7TnUHtv40VjtpdOnxeZ4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A316640739;
	Fri, 30 Oct 2026 14:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991E51F000C1;
	Fri, 30 Oct 2026 14:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793371492;
	bh=aZXf/CiAEOj3syudgngCaaHilsxgeSJVS9oPEnBDhwo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=SRBbpSBhbpzYPTxEYvVPe0YqNeqeeZXvc40Xfp6E/6NNdDO/YIaX1fQ9xoLaydR/l
	 M2KlDhSlKxubUE46HvQ8IqmdNWYZrcwWW0rYCpOC8z9eOomi+qBXtW7djAyVYPileJ
	 +PzoyM10G3unV5KEiQPfN0St5VDMkiFKoQfNFbdBE8xvvgcfkSHazcCfakn6zZPfet
	 cpZ5PrZ+eSWWsn97mve67wdNmQ+N/b1rVa8wT4L2I9P/WU2XIe0PhfoH7MSIkTEHOr
	 bqzInNADbdgGCR8YpCMJhAIZFeb+HHPjt+FFh9bSprH3bsl5nEAuJKQ2Tm8QnNWzpb
	 eWYFbkFOCP7nQ==
Message-ID: <sashiko-outbox-191117@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/4] mm/mprotect: add MM_CP_PERM_UPGRADE
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?Q2FybG9zIEzDs3Bleg==?= <clopez@suse.de>, kvm@vger.kernel.org, linux-mm@kvack.org, seanjc@google.com, pbonzini@redhat.com
Cc: linux-s390@vger.kernel.org, imbrenda@linux.ibm.com, "Andrew Morton" <akpm@linux-foundation.org>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Jann Horn" <jannh@google.com>, "Pedro Falcato" <pfalcato@suse.de>, "Heiko
 Carstens" <hca@linux.ibm.com>, "Vasily Gorbik" <gor@linux.ibm.com>, "Alexander
 Gordeev" <agordeev@linux.ibm.com>, "Christian Borntraeger" <borntraeger@linux.ibm.com>
In-Reply-To: <20261029143336.390231-4-clopez@suse.de>
References: <20261029143336.390231-3-clopez@suse.de>
 <20261029143336.390231-4-clopez@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 14:44:51 +0000
X-Stat-Signature: xif35ze79wdh4eckutwop31dshcezkgw
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7226740003
X-Rspam-User: 
X-HE-Tag: 1793371493-42272
X-HE-Meta: U2FsdGVkX18TUSbDeat0DmOKmRQe1fyTxvwxx9sLUGoerXkz9j4Hho0kkucLrb7PHe3O/dv4gBhe7qVwAwKTPs95DHJowRGgxtBLrifL101VLvVbvOHwI29vpVeXt7ama5n4u6OkflA3kvEihl6ubTEF94PmJauxMApFgxt91RbNgR1iMkd5DjJhilTP++TKuvy3vMM4trNH+JAbth3WWVvcFm13Q3tzQZPQBJw6S5uCS73qMB9Z5vaOp+cXETyG8kNQeLGzh7JC2lQQzdy7tHIPjIXgq8Vjfa8G0dBC2vF4eBoQZL+XuFieGvswylqi5DWqeMAWBiSpSk/D35lfsd9asL3ohkBqOdurRzqobrxSWa3oLUdwcFmTDCB3H0WvjSuMD68wPF9kXqgDC/rvFcWgNSTWtX9bepUcQS5+E+ndUWASSEnoYKEpJuisMYWmAfY2SdPhpCqDc5oEP20brEB66+SOaTDr34pTmIVxgbUAGiaL6O+rSqH5TL3qRGs1GbMPqOoUEQu63GupnCh6eyPvmKzxeO8P36J40CoBOVRTIy0B/5BQnCPSRxgmGBdBvc2opf3kndw5wm+KtwK4TXC2kIyolGx+dUuWnfq+LNjXZswEV6hHyni/VXSVd7IyNeoCwMabYMBiirD+PV19rP4m0dQAQDBewtAlhBvHzWZvdRaaVo+vq+I6W3C2itw/Ltqfl/qDmaYF5ynV1uRR2kB8bAeeVvUP1K2Klnv2C/2QVsrunw0Iikuj5GZd7IlogdNJY+ClYxZAUPChEfE5gFrlW9JUtVnYtTkruZLqpcQuUHgCqr+PaO2NJclI5RMwH/xdNvvdQoRB2KbBABnhbILuT8WJKA33sqyfJqfEMvRWL9u+CocOE3yenie+FTO4bhgSOwBv2tqMKWWv/MQF1HNytNTw1CsIYnxDGNOsURmLOqgZHligrqIaC3Mn6wLVbd9LzjASb2YoGAgkTi0
 AhmiwFDc
 GEHI3v7OzUu+zwrc29gCC3v3zAwA4DQqgcO10TxuTue/j6z1KjuocBL5i2/YvWoXNAwf09yyquwFXFp+roeo3cMrfwdUZTApr4WQ4gVtg1PrRuoKABLl+bruQq1chV3x4wY6WpicyNO8uJmlgrbPa0UyH1DxDIeVS1Egyk+9p4zB+hJ+RdSRWLZl8l6cgdv6pr2I+SMch2AwWlNm537VnL6AbdmaNKuyY2GMqBj7y4bp5wvtXHuedQJVQiO6eGCjCozadwl+BT1nkD93muO0GAToQoGhO4B86a8RDy+TgLFUDOSafKARlkV/KPiYGy5lHvGhvshHCEHblgtpKh4PqbQCrPAJrM5/CwyOEK5YhhJ5kgF8X6B6icC7BxYPPZUHjkS6Mkww3XQAytdvXNWVbfQ2sYcYJ6ZwAYvxFg4PujGvLhWy4m+anyNct/s1urWo1tKW30DOPfdSIWQsqE2560bopu/Izpw844mFqYGLJHq7To0ViEraO/PVnG03eQdlin7+27xLNGHgn4D7VGPTsjzGCnrECcSb/dnsZORQHGGkvrbyNRHoFGaEYFYouMCJ0vdpkBGvcme5dIpEtpJZuavJ7ivubqODNMfPJcnhQlcHHvbc=
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
- [High] mm/mprotect: MM_CP_PERM_UPGRADE set when change_protection() revok=
es write
- [Medium] mm/mprotect: vma_flags_is_perm_upgrade() ignores arch-specific p=
rot flags
--

commit f3d5a380cac712469a433d985427420721eea496
Author: Carlos L=C3=B3pez <clopez@suse.de>

mm/mprotect: add MM_CP_PERM_UPGRADE

This commit introduces the MM_CP_PERM_UPGRADE flag for change_protection()
when mprotect() updates VMA permissions to a superset of the previous
permissions without changing the protection key, allowing MMU notifier
consumers to avoid invalidating PTEs.

> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 754333698c1ea..96e32e0159166 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -756,6 +756,17 @@ static const struct mm_walk_ops prot_none_walk_ops =
=3D {
>  	.walk_lock		=3D PGWALK_WRLOCK,
>  };
> =20
> +static bool vma_flags_is_perm_upgrade(vma_flags_t old_vma_flags,
> +				       vma_flags_t new_vma_flags)
> +{
> +	vm_flags_t old =3D vma_flags_to_legacy(old_vma_flags);
> +	vm_flags_t new =3D vma_flags_to_legacy(new_vma_flags);
> +	vm_flags_t rwx =3D VM_READ | VM_WRITE | VM_EXEC;
> +
> +	return !(old & rwx & ~new) &&
> +	       (old & ARCH_VM_PKEY_FLAGS) =3D=3D (new & ARCH_VM_PKEY_FLAGS);
> +}

[Severity: Medium]
Does vma_flags_is_perm_upgrade() also need to check architecture-specific
protection flags that mprotect() can modify?

In do_mprotect_pkey(), newflags is computed via calc_vm_prot_bits() (which
calls arch_calc_vm_prot_bits()) and masks off VM_FLAGS_CLEAR (which includes
VM_ARCH_CLEAR):

mm/mprotect.c:do_mprotect_pkey() {
    ...
    mask_off_old_flags =3D VM_ACCESS_FLAGS | VM_FLAGS_CLEAR;

    new_vma_pkey =3D arch_override_mprotect_pkey(vma, prot, pkey);
    newflags =3D calc_vm_prot_bits(prot, new_vma_pkey);
    newflags |=3D (vma->vm_flags & ~mask_off_old_flags);
    ...
}

Several architectures expose PROT_* flags in mprotect() that set or clear
VMA flags affecting hardware PTE protection or attribute bits in
vm_get_page_prot():

- On arm64, arch_calc_vm_prot_bits() maps PROT_BTI to VM_ARM64_BTI (cleared
  via VM_ARCH_CLEAR when omitted) and PROT_MTE to VM_MTE. In
  arch/arm64/mm/mmap.c:vm_get_page_prot(), VM_ARM64_BTI sets PTE_GP (which
  restricts execution by faulting on indirect branches to non-BTI landing
  pads) and VM_MTE sets PTE_ATTRINDX(MT_NORMAL_TAGGED) (which enables MTE
  tag check faults).
- On sparc64, PROT_ADI sets VM_SPARC_ADI (cleared via VM_ARCH_CLEAR when
  omitted), which sets _PAGE_MCD_4V in
  arch/sparc/mm/init_64.c:vm_get_page_prot() to enable hardware ADI tag
  checking traps.
- On powerpc64, PROT_SAO sets VM_SAO, which sets _PAGE_SAO in
  arch/powerpc/mm/book3s64/pgtable.c:vm_get_page_prot() to alter hardware
  memory ordering attributes.

Because vma_flags_is_perm_upgrade() only inspects VM_READ | VM_WRITE |
VM_EXEC and ARCH_VM_PKEY_FLAGS, if userspace calls mprotect() to enable
PROT_BTI, PROT_MTE, PROT_ADI, or PROT_SAO while keeping the read/write/exec
bits identical (or a superset) and the pkey unchanged, won't this set
MM_CP_PERM_UPGRADE and allow MMU notifier consumers to skip secondary MMU
invalidation when access restrictions were tightened or PTE attributes
changed?

> +
>  int
>  mprotect_fixup(struct vma_iterator *vmi, struct mmu_gather *tlb,
>  	       struct vm_area_struct *vma, struct vm_area_struct **pprev,
> @@ -836,6 +847,8 @@ mprotect_fixup(struct vma_iterator *vmi, struct mmu_g=
ather *tlb,
>  	vma_flags_reset_once(vma, &new_vma_flags);
>  	if (vma_wants_manual_pte_write_upgrade(vma))
>  		mm_cp_flags |=3D MM_CP_TRY_CHANGE_WRITABLE;
> +	if (vma_flags_is_perm_upgrade(old_vma_flags, new_vma_flags))
> +		mm_cp_flags |=3D MM_CP_PERM_UPGRADE;
>  	vma_set_page_prot(vma);
> =20
>  	change_protection(tlb, vma, start, end, mm_cp_flags);

[Severity: High]
Can setting MM_CP_PERM_UPGRADE when the VMA already had VM_WRITE (or on a
hugetlb VMA) violate the invariant that no access is revoked and the PFN
stays the same?

Follow-up commits ("mm/mmu_notifier: add MMU_NOTIFIER_RANGE_PERM_UPGRADE",
"KVM: plumb MMU_NOTIFIER_RANGE_PERM_UPGRADE into kvm_gfn_range", and
"KVM: x86/mmu: don't zap the secondary MMU on permission upgrade") wire
MM_CP_PERM_UPGRADE to MMU_NOTIFIER_RANGE_PERM_UPGRADE so that
kvm_unmap_gfn_range() skips zapping secondary MMU SPTEs.

However, when a VMA already has VM_WRITE and mprotect() adds permissions
(for example, upgrading PROT_READ | PROT_WRITE to
PROT_READ | PROT_WRITE | PROT_EXEC, or PROT_WRITE to
PROT_READ | PROT_WRITE), vma_set_page_prot() computes vma->vm_page_prot
(newprot) without write permission for all MAP_PRIVATE mappings (COW) and
for MAP_SHARED mappings where vma_wants_writenotify() is true.

When change_protection() applies this read-only newprot across the VMA,
there are several paths where write permission is stripped from existing
entries or entries are unmapped in the primary MMU while MM_CP_PERM_UPGRADE
is set:

1. In mprotect_fixup(), vma_wants_manual_pte_write_upgrade(vma) is called
   after vma_flags_reset_once() but before vma_set_page_prot(vma). For
   MAP_SHARED VMAs without vm_ops->page_mkwrite that use writenotify for
   VM_UFFD_WP or soft-dirty tracking (such as shmem),
   vma_wants_writenotify(vma, vma->vm_page_prot) compares the old read-only
   vma->vm_page_prot against vma_pgprot_modify(vm_page_prot, vma->flags)
   (which still has VMA_SHARED_BIT | VMA_WRITE_BIT) and returns false. As a
   result, MM_CP_TRY_CHANGE_WRITABLE is not set, vma_set_page_prot()
   computes a read-only vma->vm_page_prot, and change_present_ptes() /
   change_huge_pmd() strip write permission from all writable PTEs and PMDs
   in the VMA.

2. In mm/hugetlb.c:hugetlb_change_protection(), MM_CP_TRY_CHANGE_WRITABLE
   is not handled, so huge_pte_modify(old_pte, newprot) unconditionally
   strips write permission from already-writable COW huge PTEs in
   MAP_PRIVATE hugetlb VMAs; in addition, huge_pmd_unshare() unmaps shared
   PMD tables via pud_clear().

3. In mm/huge_memory.c:change_huge_pud(), MM_CP_TRY_CHANGE_WRITABLE is not
   handled, so pud_modify(oldpud, newprot) strips write permission from
   writable huge PUDs in writenotify DAX mappings.

4. In mm/mprotect.c:change_softleaf_pte(),
   mm/huge_memory.c:change_non_present_huge_pmd(), and
   mm/hugetlb.c:hugetlb_change_protection(), writable migration entries
   (softleaf_is_migration_write()) and writable device-private entries
   (softleaf_is_device_private_write()) are unconditionally downgraded to
   read-only entries via make_readable_exclusive_migration_entry(),
   make_readable_migration_entry(), or make_readable_device_private_entry().

5. In change_present_ptes() and change_huge_pmd(), pte_modify() /
   pmd_modify() strip write permission and do not restore it under
   MM_CP_TRY_CHANGE_WRITABLE when !folio in a private PFN/mixed mapping or
   when a shared writenotify PTE was cleaned (!pte_dirty(ptent)).

Wouldn't skipping secondary MMU invalidation in these cases leave secondary
MMUs (such as KVM SPTEs) with stale writable mappings to pages that
change_protection() has write-protected or unmapped in the primary MMU?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029143336.3902=
31-3-clopez@suse.de?part=3D1

