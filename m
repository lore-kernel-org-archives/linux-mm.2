Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2422F606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 16:36:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=L/fKrm27
Received: by kanga.kvack.org (Postfix)
	id 3C3A46B02E4; Thu, 22 Oct 2026 12:36:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 39C4B6B0994; Thu, 22 Oct 2026 12:36:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D8606B0996; Thu, 22 Oct 2026 12:36:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 04B6D6B02E4
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 12:36:34 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 8415CA680B
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:36:34 +0000 (UTC)
X-FDA: 85350815508.27.1BE2747
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id EAD13C0004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 16:36:32 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L/fKrm27";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792686992;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RO+eVQEMGCXGTb+gs3/7azRquJi55iZv5+oAKWw8EME=;
	b=fGKvHpblJQwJw8W+n9f09TnhFvEMIUNzGzFuYYs24DnF+qIZKX+MuTD/BTQDLOmiIOhHSW
	DxmWDLJJ2emQg0kMkdUfxisBWeWKBfnz9J5gYx81ihMI1/8sPne4eokxNlfXuMsCStuEoB
	1EdcZ/Wj3KcQYPrIvgd/w/5ak/259fU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="L/fKrm27";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792686992;
	b=O5mPVPXiSpYN5ipn7Kl04KMvSW5WZEgs0My73Uik3VOaMhvtTJtxN5XFa+njd9M78+RZZG
	EvyDxuBKd2SmgWeSVbT0FlZIwfTc7t3opLu/gqMGiuRdVEAHvwunV02IhUOdc/J955Xttv
	yeM6NskTysOkC0Jg179dfVXv4lQF9mA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6EE6A6024D;
	Thu, 22 Oct 2026 16:36:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 925B21F01825;
	Thu, 22 Oct 2026 16:36:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792686992;
	bh=RO+eVQEMGCXGTb+gs3/7azRquJi55iZv5+oAKWw8EME=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=L/fKrm27DKFGNBuYEi8ggi66Ycno6gUwj4dlF/blXgu1lnEAIIXmsvkTikJYQORi0
	 osBrnd9R2R9oG+nEpz41W2uXf+54GlFSK16QrWeRHTIIhu1cQsGTW+9vY/ZPZ6XMia
	 HTMGUgMFDCGqiSY5agmZQp/9w3Co/2L9neguyMQpKrQHHIjaVE09N4WJu+6QHtYI+G
	 fTKviX2MyjON6umwOb04Mx/148u9Z7/oSc8bohy5A5uyHn/TvIFA7CxCGxftwbfVHY
	 bA5mIcnagnE+OOVa9UgE+gUb5IBF5+0zpSPmmQ4xjO/L9d8rjidN631B8XCuS06Stb
	 rK7VrdVEzfpeg==
Message-ID: <sashiko-outbox-181816@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/3] mm/hugetlb: disable PMD sharing for UFFD missing
 mode
Reply-To: sashiko-reviews@lists.linux.dev
To: "Li Zhe" <lizhe.67@bytedance.com>, akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev, osalvador@suse.de, peterx@redhat.com, rppt@kernel.org, azpijr@gmail.com
Cc: linux-mm@kvack.org
In-Reply-To: <20261022034543.51226-3-lizhe.67@bytedance.com>
References: <20261022034543.51226-1-lizhe.67@bytedance.com>
 <20261022034543.51226-3-lizhe.67@bytedance.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 16:36:31 +0000
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EAD13C0004
X-Stat-Signature: 1ayibgyoihqtzbdudhpibw4zddjz57zt
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792686992-252306
X-HE-Meta: U2FsdGVkX1/Ni6fcjy/JIU0eqnS77DVahBQcNo6YJdUnjqfgzR3TTm3xfFyPz2d+/QqN55hDODAzGBqRzRkpeRRouVqzxvLHI2AHZBhcxlJ6Y7ouZhvzL8tOemR6sZphZH4hGeSIYAJvo8fSAV0jP9zC1CVjcdFxd+r3bCoewGM96/8OOQevSXL8q6sZsLet4/ptTbvvqaWa8M7AV+g7lfepJCn7WDg3BQuG9BdlV45zdVGN0h0FY5raa2N5p58pGpdaHCx4NQyg0xYaxf3wKDcAdxJ2pPOMP2I6ld4I2S3adOfh+oqkULdoBWw2jy73ZyudQMFD/ZPq2eeRPByTEHrWcmKi4nHSgRJwkmYUk8Hr65zo1nTPFDwAOq1IEMPpg2bbjgB+i11+4DuJjU5e799mnSme+rXRblPRU2tGMqyljx1YaQYwA99DxGJhD9uAtmd/beeZJTlXV/lwdvKQSzpB59oQ8CeFwzCUN4Pu1JRx5Uj+yDcYVn63XI8P/36+mU3WJyeLMLdmWieYUX3Wmh2Um/TWBgIWRj4KPIwo7j/VUI9EMrJrg3EEtJIGeGna/x0//yItn9hm1F+03iL3fo6oMQ2lPihmkVwrsN5lenyIbWCFoE9Rtto50mDS/PLYx2eb8Bdl/mLm7MxifVY4fllfMuRc96C4vHrh38fFdSVYxZh0B6h+Hdekw0XKYyVZJwYTTQLl4SeSTlJ34L6m2DIqCF5Z+ROAfuA5SAIMrrG7hattaXADxp+TMFg1UI0yBmdrUYAwyG82KWFi3lrBmi5Ry1mbpShin6G4uiG6ZyVhvIh+6TYwlYJBuiN6pq9zE3Alfa4PS+82vmnAl3ViqORAoQAnuSd0D/At1SvuvVU9JopaD3uLpnLnl2uB/F8VHmgBKM0HoGrdtTPzrgTPYwQ+jttHRnzpZ/DZRsCr/0grDd6zZRn5eVFT2vW5KfVmCnOW+NXQwNaRU8H2kG2
 fpBqKuF9
 LIKOuo+fQMtrxOHxWBhnu5an8MZJ0JGsluYiDl8bCn9ELnJaxT3Tl8EMXKeLFF89AbViDPnOrcH+if2wgU5u7U2PV+W89HN0B1l3v3Z93F7lwk9N4HiuK/14GNk/Jn5pJVh0GmGkf+XLnZvDyjqJ1B3NevQxOXQqlT/BI5t4TmHBTFd5h6E2C9Kpbw2lkEQUG4Gtv2kvDbvLjBliGB5WytGb6s/6wCkyDYY1qBwNcO+utqr1Ez2t2o8uYvYcQq7poTuZ3JhA2VyenbEWZ3jtpa6O0Ffe72BTc2wY7sxRqymCQYQe+4xjc/ijI3U39xbh0kt8ytegn3fsiw0aZFqp0mzvor1PbVJyj/LI7TxCY/UG6hXupp69KqMhlCWKClsBwXJlluouO4X2BgMPgHn72DypTttVRMKgVBthjwsf/+g2NiQwjE6SA+Nz3Wl5CNbAvFYt3vHzHwAJ8BF+LLkOy3+ePErOUIRa8HgGXAt2VNz6oxNmbjxBvkyGukJ80R52Q2aOGXcV5L6KaI51kjRnnF1Ys447w8/oy1BiacvzncXM+VZn0rRwtWbw0U3WAAUbXx56e91i5WLzcityd/TAkulTvTjd2ZJz80VZCX7EVAXK1BxQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm/hugetlb: uffd_disable_huge_pmd_share() leaks poison markers on =
unregister
--

commit 5da87cbb6b8f2271fb75acc59e14e2d5860cb54c
Author: David Hildenbrand (Arm) <david@kernel.org>

mm/hugetlb: disable PMD sharing for UFFD missing mode

This commit disables hugetlb pmd page table sharing for all userfaultfd
registered vmas by checking vma->vm_userfaultfd_ctx.ctx in
uffd_disable_huge_pmd_share(), preventing poison markers installed under
missing mode from affecting shared pmd tables. It also adds a debug check
in hugetlb_mfill_atomic_pte() when installing a poison marker.

> diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
> index a14b8a9ffb7b1..ebd86677b052d 100644
> --- a/include/linux/userfaultfd_k.h
> +++ b/include/linux/userfaultfd_k.h
> @@ -168,22 +168,12 @@ static inline bool is_mergeable_vm_userfaultfd_ctx(=
struct vm_area_struct *vma,
>  }
> =20
>  /*
> - * Never enable huge pmd sharing on some uffd registered vmas:
> - *
> - * - VM_UFFD_WP and VM_UFFD_RWP VMAs, because the write protect / access
> - *   tracking information is per pgtable entry.
> - *
> - * - VM_UFFD_MINOR VMAs, because otherwise we would never get minor faul=
ts for
> - *   VMAs which share huge pmds. (If you have two mappings to the same
> - *   underlying pages, and fault in the non-UFFD-registered one with a w=
rite,
> - *   with huge pmd sharing this would *also* setup the second UFFD-regis=
tered
> - *   mapping, and we'd not get minor faults.)
> + * Never enable huge pmd sharing on userfaultfd registered VMAs, because
> + * userfaultfd state can be tracked per VMA or per page table entry.
>   */
>  static inline bool uffd_disable_huge_pmd_share(struct vm_area_struct *vm=
a)
>  {
> -	return vma_test_any_mask(vma,
> -		mk_vma_flags_from_masks(VMA_UFFD_WP, VMA_UFFD_RWP,
> -					VMA_UFFD_MINOR));
> +	return vma->vm_userfaultfd_ctx.ctx;
>  }
> =20
>  /*
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 966d249469454..7566f2eed50b0 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -6399,6 +6399,7 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_pte,
>  			return -EEXIST;
>  		}
> =20
> +		VM_WARN_ON_ONCE(size =3D=3D PMD_SIZE && hugetlb_pmd_shared(dst_pte));
>  		_dst_pte =3D make_pte_marker(PTE_MARKER_POISONED);
>  		set_huge_pte_at(dst_mm, dst_addr, dst_pte, _dst_pte, size);
> =20

[Severity: High]
Can a pmd table containing a poison marker still become shared across
processes after the vma is unregistered from userfaultfd?

When a process registers a shared hugetlbfs vma in missing mode and installs
a poison marker via hugetlb_mfill_atomic_pte(), the marker is written into =
the
process's private pmd table.

If the process later unregisters the vma or closes the userfaultfd descript=
or
(via userfaultfd_unregister() -> userfaultfd_clear_vma() or
userfaultfd_release_all() -> userfaultfd_clear_vma(), or remaps via
mremap_userfaultfd_prep()), the userfaultfd flags and context are cleared
while the poison marker remains in the page table:

mm/userfaultfd.c:userfaultfd_clear_vma() {
	...
	ret =3D vma_modify_flags_uffd(vmi, prev, vma, start, end,
				    &new_vma_flags, NULL_VM_UFFD_CTX,
				    give_up_on_oom);

	if (!IS_ERR(ret))
		userfaultfd_reset_ctx(ret);
	...
}

Unlike write-protect markers, which are resolved by change_protection() on
unregistration, poison markers intentionally persist after the userfaultfd
context is reset.

Once vma->vm_userfaultfd_ctx.ctx is cleared and the userfaultfd flags are
removed from vma->vm_flags, uffd_disable_huge_pmd_share() returns false and
page_table_shareable() in mm/hugetlb.c considers the vma eligible for shari=
ng
again:

mm/hugetlb.c:huge_pmd_share() {
	...
	mapping_rmap_tree_foreach(svma, mapping, idx, idx) {
		if (svma =3D=3D vma)
			continue;

		saddr =3D page_table_shareable(svma, vma, addr, idx);
		if (saddr) {
			spte =3D hugetlb_walk(svma, saddr,
					    vma_mmu_pagesize(svma));
			if (spte) {
				ptdesc_pmd_pts_inc(virt_to_ptdesc(spte));
				break;
			}
		}
	}
	...
}

When another process mapping the same shared hugetlbfs file faults in that
range (hugetlb_fault() -> huge_pte_alloc() -> want_pmd_share() ->
huge_pmd_share()), huge_pmd_share() walks the first process's vma, finds its
populated pmd table containing the poison marker, and shares it into the
second process.

That exposes the second process to the first process's poison marker. In
addition, if the first process subsequently unshares the pmd table (for
example via mprotect(), hugetlb_split(), or re-registering userfaultfd),
__huge_pmd_unshare() clears the pud entry in the first process, causing the
originating process to lose its own poison marker while leaving it installed
in the second process.

Should the vma or ptdesc record that a poison marker was installed so pmd
sharing remains disabled for it even after userfaultfd unregistration?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261022034543.5122=
6-1-lizhe.67@bytedance.com?part=3D2

