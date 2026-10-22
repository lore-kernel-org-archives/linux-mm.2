Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0768606A31A
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:06:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NP3xBdTY
Received: by kanga.kvack.org (Postfix)
	id 6F9F76B088C; Thu, 22 Oct 2026 02:06:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CA736B088E; Thu, 22 Oct 2026 02:06:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B9936B088F; Thu, 22 Oct 2026 02:06:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 229576B088C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:06:44 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5D76780704
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:06:43 +0000 (UTC)
X-FDA: 85349228286.23.BE103DE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id AAC1F180002
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:06:41 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NP3xBdTY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792649201;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7rLS0uOUI/ocCbunTNg1g/PS0epTbYFvwScjZMSyXgI=;
	b=0qyUrYspYfGCamNpnD54K8tFOKmRbouDAbnCr/cv1PWPqqQMJlR/TbOyio/2Qv7YBKJ2bL
	/JLhheriRKFUQY+gm/nbr862RhJp8C5ppRCWBwvRk0yjir2jvWCCc7B0Ln/bi46JjMbWkJ
	IjBgRCD0slrYkoiLMGvASsNT2FYivkc=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=NP3xBdTY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792649201;
	b=6tEJyYgfIVX3WouLllU8zTYdjClBHXE9ojtoIN495fzme/PTjXQZv22Imo4Ox0cjSTgaBi
	IMsDCV63CRLO/uw2hzx7PJcRmvizejHbk0xaXvM7kCTJWu/Yw473wXkxte4q7EZnALBAmm
	GinaLYULqpN40xLT+t1DD0KbMSelTAs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 038E7447FD;
	Thu, 22 Oct 2026 06:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C98671F000C2;
	Thu, 22 Oct 2026 06:06:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792649200;
	bh=7rLS0uOUI/ocCbunTNg1g/PS0epTbYFvwScjZMSyXgI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=NP3xBdTYMG847D761cEGUwZNwnhTylJ1XIP9VO3OcSGPMlV0uAuE9uPztgE5XIBkm
	 QpUgUpq2nZpsXwWCwxpI1dy2s05mORatCtrPoaedUC50yp7QhXgqvL38RKY+V26Ctg
	 /Sj8MVvpu+UlQHDPZpFyJFC8ILeSS41blgjylYcx/Y1qCGPReMVMMqBFrMT9msYTd0
	 NfZMyB6WIWyNX+XqE/n91xcOhFuQSbHOEbyTD1qybNiDX2+JIHHZRHbGHoMgoI89Wr
	 O7IG+pSxWFBJIxZ00r9GNHJVRN04YWr0TcgG5i+tLCxLmXvxeIbvVc6z8xxFlnoTBV
	 pHLYhmyubPy3g==
Message-ID: <sashiko-outbox-181056@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 08/12] mm/hmm: implement rollback for device page
 migration in HMM pagewalk
Reply-To: sashiko-reviews@lists.linux.dev
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, "David
 Hildenbrand" <david@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Leon
 Romanovsky" <leonro@nvidia.com>, "Alistair Popple" <apopple@nvidia.com>, "Balbir
 Singh" <balbirs@nvidia.com>, "Zi Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <Liam.Howlett@oracle.com>, "Vlastimil Babka" <vbabka@suse.cz>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Lyude Paul" <lyude@redhat.com>, "Danilo
 Krummrich" <dakr@kernel.org>
In-Reply-To: <20261021060506.2377545-9-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
 <20261021060506.2377545-9-mpenttil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:06:39 +0000
X-Rspamd-Queue-Id: AAC1F180002
X-Stat-Signature: fqntqa3tgcduh56cxrjmr7b8r6u7fug4
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792649201-922663
X-HE-Meta: U2FsdGVkX1/O8whyl9mfx/9zCfU70EGKotop6tl4Cy1l0QFYB3HFE0Om5+jkZFvmS11gMJWg6afGrkUFa0kAb73zwKvBx0/2gzHyoRLYLoVR+MAlBFPGOTAviE0XnpflTIBH2kThBSjrh/rgLStojEnaOjE/tmmHIAd+8dV6p3DD5Xkyv57/Tsg78LuskJ26ZluSqIlhSyG4VRy9SLfmIkns9LyJIrld+DbTnZ0myjSiKh/KBAZu2zUNayTKZf//NJU3Lb/NjODkqGcpO8U337S6ADEB+lv4I2oUPeEAlRohYl/l8Gr+oMTLHN6sqNA3QILgQU5Dp5ErG7qeonP7W3zoECoPborVlYSKS/xHbI8ujVryMrsVkN6su4+zPOyBZaqZrfwSXiAvgHzCnRcOUeIE7m4Xz5g3psbpixxCCFQvPmyi365NpXF3duBiv9n1BYb+2euZrF/b+C3wnvpST0uoXT0vrb0T4nV7aDLVgRT/j9rTFYDeM75IWAoEwbvRI7SSzVorW5STGnKq6ksB3I1PBLIlPu+FZ9/R5oWttQ95DusHXxXZMim4xNksaMsdI4X/wi40pZJnHGtMiOJUFqnTKqJFLj9djMTgXdfnNLLMKe802LzXR15qCVyHy1JIjVBQKDm55xP/+Tom1O+FE0VAeO1cuwS0A9SuE2fBSCUGSToTVL2Yvc9jvacs8eBYlqF5yxIUC8ayE8rLP3jGVJQqkeqzZjH4j2T2rAkEPmW7eaedQhejZX4BWzPINRfW0ZW3yXRkMFL2xu+9ISgQZn1qDbtmwP2PS38IrFWPJNdZ3n7/HZnDF7hQmRRx8K5oF/cAAmGrwdQByyX3dTdsoFP4KI9ZsMNooI863Ln5UXNVhPFQAzZRBXxuQ3quyEwJ2c3zisnql2uNg1A/W7iUUER4WbXcsyOZXrrZgPT6DgI41FdF3ztKrxECQHdsze6ARXXPiRiwMdSHhFk+pIi
 49Ex4jt/
 uvv9m4MVb9lTV4/iBS1EVAyVKFcUdC2BeFTwJs+K/iU4n9BLF5JOoEs5waCzc/b+shzT6EQz+4pt+EhxhixcqCr2PGA3NuDJ+4epb7ImS479tykpbafvmOZv6jfUaBioZ+RJpRl32o+DX9I26hwtX8Rc/JoKwpJeZBbTgUH2la+6mg+EAmVbd8kFsLyKWQU/XI7ei/dSYj/0t3Pd5QIVbOxUC6F4bXCaXPu3CZ1kHmrnSDkaDpERnznnqLZWqMtzqBLb5IaDb1HhYSUNE2CuPK/RtrtETSVYFkDDDhD+MvT267JfnRE/4aG20N8fkiFUACFerJ3Xe04m3FSLyuPXmyBfyVT6IPKSQnwD2riAVTfstutdJcaXE+r6PZ/diiBhl+4TcXlAzaVvLvpZCUJh7nMMe/M//Z7+fZjR3ge0XTRcgqqxgd+6tzeft5eINvHzBBP+VAgVSKDr6i2wCwqM5FO0EIb3WClb+4hAWRmvTwfdJA/hsaYM25OtbOKfIJmNuV2i36K4XC0Jbj7cMaEl2XQxizj5W6qjhvyJWcx6FepuFO8J2jGnlsr/7ynhqLUSeXN2oQ7+pQ4QWQYtht5k5GrNITVcXKv5xU8xIbTHhEzASjtApyXYReNWVDgw/JmpBBmFg+hWXqiIvzRRSpOzywcXq0oXZFzUQjejwygx50god4G8=
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
- [Critical] mm/hmm: premature rollback of migration PTEs in hmm_vma_handle=
_pte()
- [High] mm/hmm: incomplete rollback on mid-PMD lock drop in hmm_vma_walk_p=
md()
- [High] mm/hmm: missing rollback on fault and PMD migration in hmm_vma_wal=
k_pmd()
--

commit 5c75620371e34a43110051163d33f29ab4f700b4
Author: Mika Penttil=C3=A4 <mpenttil@redhat.com>

mm/hmm: implement rollback for device page migration in HMM pagewalk

This commit adds rollback handling during HMM migration page walks to unlock
and drop references on previously collected folios if page tables change wh=
ile
locks are dropped.

> diff --git a/mm/hmm.c b/mm/hmm.c
> index 36a4edde9823c..5a1471fd5d288 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c

[ ... ]

> @@ -282,6 +289,8 @@ static int hmm_vma_handle_pmd(struct mm_walk *walk, u=
nsigned long addr,
>  		return hmm_record_fault(addr, end, required_fault, walk);
>  	}
> =20
> +	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
> +						end, hmm_pfns);
>  	pfn =3D pmd_pfn(pmd) + ((addr & ~PMD_MASK) >> PAGE_SHIFT);
>  	for (i =3D 0; addr < end; addr +=3D PAGE_SIZE, i++, pfn++) {
>  		hmm_pfns[i] &=3D HMM_PFN_INOUT_FLAGS;

[Severity: High]
What happens if entries in hmm_pfns were previously collected, locks were
dropped, and on re-walk the page table entry now requires a fault, fails wi=
th
-EFAULT, or is a PMD migration entry?

In hmm_vma_handle_pmd(), if required_fault is non-zero, it returns
hmm_record_fault() before calling hmm_vma_handle_migrate_prepare_rollback().
Several other paths similarly return before rolling back previously collect=
ed
entries in range->hmm_pfns:

  - hmm_vma_walk_hole() returns -EFAULT (when !walk->vma) or
    hmm_record_fault() when required_fault is non-zero before reaching
    hmm_pfns_fill().
  - hmm_vma_handle_absent_pmd() returns hmm_record_fault() or -EFAULT when
    required_fault is non-zero without calling
    hmm_vma_handle_migrate_prepare_rollback().
  - hmm_vma_handle_pte() jumps to the fault: label or returns -EFAULT witho=
ut
    rolling back *hmm_pfn.
  - hmm_vma_walk_pmd() returns -EFAULT on pmd_bad(pmd) when
    hmm_range_need_fault() is non-zero, and returns 0 when
    thp_migration_supported() && pmd_is_migration_entry(pmd) is true with
    minfo non-zero, without rolling back collected PTE entries in
    hmm_pfns_start.

If hmm_record_fault() returns HMM_FAULT_PENDING while the current task still
holds folio_lock() on previously collected folios in that range, can
hmm_do_fault() -> handle_mm_fault() deadlock trying to lock the same folio,=
 or
can the early returns leave stale collected folios locked and referenced in
range->hmm_pfns?

> @@ -412,6 +421,9 @@ static int hmm_vma_handle_pte(struct mm_walk *walk, u=
nsigned long addr,
> =20
>  	new_pfn_flags =3D pte_pfn(pte) | cpu_flags;
>  out:
> +	hmm_vma_handle_migrate_prepare_rollback(hmm_vma_walk, addr,
> +						addr + PAGE_SIZE,
> +						hmm_pfn);
>  	*hmm_pfn =3D (*hmm_pfn & HMM_PFN_INOUT_FLAGS) | new_pfn_flags;
>  	return 0;
> =20

[Severity: Critical]
Could reaching the out: label in hmm_vma_handle_pte() prematurely roll back=
 a
migration PTE that this walk already installed?

In hmm_vma_handle_pte(), when !pte_present(pte) is true, the required_fault
check runs before softleaf_is_migration(entry):

	if (!pte_present(pte)) {
		...
		required_fault =3D
			hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags, 0);
		if (!required_fault)
			goto out;
		...
		if (softleaf_is_migration(entry)) {
			if (!hmm_select_migrate(range)) {
				...
				return -EBUSY;
			}
			return 0;
		}

During a migration walk without HMM_PFN_REQ_FAULT (such as migrate_vma_setu=
p()
where range.default_flags is HMM_PFN_REQ_MIGRATE),
hmm_vma_handle_migrate_prepare() locks the folio, takes a reference, instal=
ls
a migration PTE, and marks *hmm_pfn with HMM_PFN_VALID | HMM_PFN_MIGRATE.

If the walk restarts over that range (for example, after dropping locks in
migrate_vma_split_folio() or on an -EBUSY retry), hmm_vma_handle_pte() sees
!pte_present(pte) for its own migration PTE. Because HMM_PFN_REQ_FAULT is n=
ot
set, hmm_pte_need_fault() returns 0 and jumps to out: with new_pfn_flags =
=3D 0.
At out:, hmm_vma_handle_migrate_prepare_rollback() unlocks the folio, calls
folio_put(), and clears HMM_PFN_VALID | HMM_PFN_MIGRATE from *hmm_pfn while
the migration PTE remains installed in the page table, so
remove_migration_ptes() will never be called for it.

Conversely, when HMM_PFN_REQ_FAULT is set (required_fault !=3D 0), the
softleaf_is_migration(entry) branch returns 0 whenever
hmm_select_migrate(range) is non-zero without checking that
hmm_pfn_collected(*hmm_pfn) is true and that softleaf_to_pfn(entry) matches
the PFN in *hmm_pfn. If the migration PTE belongs to a concurrent migration
(at an uncollected slot or in a replacement PTE table), shouldn't
hmm_vma_handle_pte() roll back any mismatched *hmm_pfn and wait via
migration_entry_wait()?

[ ... ]

> @@ -1117,6 +1193,9 @@ static int hmm_vma_walk_pmd(pmd_t *pmdp,
>  		if (ptep) {
>  			lazy_mmu_mode_enable();
>  			hmm_vma_walk->ptelocked =3D true;
> +		} else {
> +			/* The pte table is gone */
> +			hmm_vma_handle_migrate_prepare_rollback(walk->private, addr, end, hmm=
_pfns);
>  		}
>  	} else {
>  		ptep =3D pte_offset_map(pmdp, addr);

[Severity: High]
Does this rollback miss entries collected in [start, addr) when the PTE lock
is dropped partway through a PMD?

In hmm_vma_walk_pmd(), the PTE loop advances addr and hmm_pfns from start
toward end while collecting folios into hmm_pfns_start. If
hmm_vma_handle_migrate_prepare() hits a large folio at addr > start,
migrate_vma_split_folio() drops the PTE lock and returns -EAGAIN, and
hmm_vma_walk_pmd() jumps to again: without resetting addr =3D start:

again:
	hmm_pfns =3D &range->hmm_pfns[(addr - range->start) >> PAGE_SHIFT];
	...
	if (minfo) {
		ptep =3D pte_offset_map_lock(mm, pmdp, addr, &hmm_vma_walk->ptl);
		if (ptep) {
			lazy_mmu_mode_enable();
			hmm_vma_walk->ptelocked =3D true;
		} else {
			/* The pte table is gone */
			hmm_vma_handle_migrate_prepare_rollback(walk->private, addr, end, hmm_pf=
ns);
		}
	}
	if (!ptep) {
		addr =3D start;
		goto again;
	}

When ptep is NULL at addr > start, hmm_vma_handle_migrate_prepare_rollback()
is called with addr and hmm_pfns before addr is reset to start, so it only
scans the uncollected tail [addr, end) and leaves folios collected in
[start, addr) (at hmm_pfns_start) locked and referenced.

In addition, if the PTE table was cleared and replaced by another PTE table
while the lock was dropped in migrate_vma_split_folio() (or during a mid-PMD
fault where hmm_record_fault() sets hmm_vma_walk->last =3D addr),
pte_offset_map_lock() succeeds at addr > start on the new PTE table and res=
umes
from addr without re-walking or rolling back [start, addr). Should mid-PMD =
lock
drops restart from start (with hmm_pfns_start) so that [start, addr) is
re-validated?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021060506.2377=
545-1-mpenttil@redhat.com?part=3D8

