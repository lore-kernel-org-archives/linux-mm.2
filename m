Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 11D26606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 06:18:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ghxJiKoB
Received: by kanga.kvack.org (Postfix)
	id 03F7D6B05B3; Wed,  4 Nov 2026 01:18:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E94A46B05B4; Wed,  4 Nov 2026 01:18:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE8846B05B5; Wed,  4 Nov 2026 01:18:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9AEAD6B05B3
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:18:03 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1EB53A0665
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:18:03 +0000 (UTC)
X-FDA: 85396431246.03.7068841
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6C41CA0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:18:01 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ghxJiKoB;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793773081;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CuJ0iEYeJ0qXki1Jq0werAEqmBdF9HjWdgIBgqLLHZo=;
	b=Ha7GugkGGjjhuuwsEWlgLOFewdM527MpiHa/o7U83yESeifEizN0r7Wv27yRe/q2IgCykv
	h5Urtn5YERKP8IHeyLx+BAyMpFV+GpsTvD/ifwHxEiHHiRfxSc42ZGvFiCYoLsef3tT6qR
	5ak6jwVWly7sVr62avaM2LfaGEu0uMY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793773081;
	b=x1yN1Ty6K0zkWKzMv2aJrmNGr+QrjfSjafULW2l7zFsFQFGn4JPen3wqoS+uzvcFrqSoyP
	VYvMuI+7z356X8d1wnIPKM6Ghuklkv88y7mC2bB8Po2Or0ThMYYSEbO61AjCAV1AnvpneH
	bbtUWP+YBvBYta0nlhpvcfiVTkQq/xk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ghxJiKoB;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E35D40F14;
	Wed,  4 Nov 2026 06:18:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52B9E1F000C1;
	Wed,  4 Nov 2026 06:17:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793773080;
	bh=CuJ0iEYeJ0qXki1Jq0werAEqmBdF9HjWdgIBgqLLHZo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=ghxJiKoBvgw3rjS264DhaVbfl70tvUpi0gvqRpYaPK7APNNm7GVK4miPpWjEe4WhS
	 gcWBcqKmp6lKQnsvmy8cRVhbtAg664okl396KIwOqKTg6tT0t87ifBXyzo2rthakUj
	 +aPNZeo2Z5eEpdDyyki+YQSue8JF1TahYCc7EsA/77lC7MKI1VpLTulSpIWZ9BwKo0
	 M2Zuq3k8UXI932gdjriPd7u7AGF//PLMNmelEU7oEcS8J9J07vGIK7AScxsNJm9OL2
	 rHR/KYAZSNEwcgYkD9EwSWZX/aE6foCYJSsMJc/OQEqKAyroAGvAbzBhx+r/AabxUy
	 4t3rlU4IIxs0A==
Message-ID: <sashiko-outbox-196743@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 05/12] mm/hmm: migrate collection in HMM pagewalk -
 pte level
Reply-To: sashiko-reviews@lists.linux.dev
To: mpenttil@redhat.com, linux-mm@kvack.org
Cc: dri-devel@lists.freedesktop.org, intel-xe@lists.freedesktop.org, "David
 Hildenbrand" <david@kernel.org>, "Jason Gunthorpe" <jgg@nvidia.com>, "Leon
 Romanovsky" <leonro@nvidia.com>, "Alistair Popple" <apopple@nvidia.com>, "Balbir
 Singh" <balbirs@nvidia.com>, "Zi Yan" <ziy@nvidia.com>, "Matthew Brost" <matthew.brost@intel.com>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Lorenzo Stoakes" <ljs@kernel.org>, "Liam
 R. Howlett" <liam@infradead.org>, "Vlastimil Babka" <vbabka@suse.cz>, "Mike
 Rapoport" <rppt@kernel.org>, "Suren Baghdasaryan" <surenb@google.com>, "Michal
 Hocko" <mhocko@suse.com>, "Lyude Paul" <lyude@redhat.com>, "Danilo
 Krummrich" <dakr@kernel.org>
In-Reply-To: <20261103061629.972669-6-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <20261103061629.972669-6-mpenttil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 06:17:58 +0000
X-Rspamd-Server: rspam06
X-Stat-Signature: 8ucsxr19coz14o1dn179neetsmjfer58
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 6C41CA0006
X-Rspam-User: 
X-HE-Tag: 1793773081-949846
X-HE-Meta: U2FsdGVkX1+lc7i4e/YNHhP11QCWTXWRxnTwUeewmnATc+sgIoesMSpe7Ru6av7cnzmoxyFv1G7N8ztR2MTL5VpfxoZosLky+NeHpZz95N29OegV0MRMdWTs0IpSlPlX33rBo247epv89EeD5v4AjRJ/xhW+zRLyeqo79opTvOrLOnnZWnQxyhYIE6qMp+N19zFAJ/el+A8Csqd0M8XjwhdQciV2G/sLtYH3IOziBIAcoyUhReRIGSewYmTYGu3EYd/9iAZPU/MnHDyh8CK7t2ZUqca+UKK7RUW6rlyyl36l0sFZ8TfSqQqVrDs1KAzrKvyh/vQOJlVA10NiCMh9hdutuh4kBRtBP/GOlTRmeHruC9pGarxv84qcUr2oNn8YB19Jb/sqv2qSRFLA2E9KdAP3Pn9Qwqm4uFCmdFpBSTvdwrVPkI1kLXmo8QcF9Qx4w8xhPZrAapMpYpMgwryYeONgfanERzKWZbEtHLJSrRwNn07lJvOTUfg2dDiAw7TQ/1zpp8AdE8BWtT0v8puN50OP8UoZeD0k8nkHyDtfKQNskJPICCSWrRonvItNSs38VcrCurc9cVKNdMwcGky8rng63ujCi46v+Np7LtG3nGnsYd4rTwxuI/+MHsij1vssqFwnY9xely+DngdJ7xouIxFFyxAW2Hh3DRrSJr2+Tvs1PkeYP0yRcBjhYBu69PNd+Y8tjWGLat2kO3YRoNIMwTbRKZEffNFrXd/lmxtCvAP7b4ycLfr+xdxgmtyHvDyybFTtAeS9xDRJLZo0JdQa1LvD3R3vsDLQzoa1Hd0jTe3Ra7uIW5Yq2wnoPiU6klvF3josrdE5rVW2GZ/S7dsQc+yl9WkbFn8KGuv5kM7Z7CEB7mzBvp943+78Rz8+SyTqe/bdsg8/1F9c18ZiHl3hfxvWtc4+Mk7dWsIb13Wej+ZC68Pwe4ZbNzIfJjXdq+veIFiU79OFvDSWGucEJlV
 AusECuE1
 zBu/ZcP1g5wSYMZHVt1CxLGUFK+xv0906ZimlzXi/vHS52lMFkFsB00mc5WugnlBgpRlOgbyiajpenfZc5aeq5hvyXFBCgbNSG4wJ9DPb5SWaANyG3cG++OPSn07PLu/g4LX8P+3duRP8I+x3nlj/pDVLs1/rn6Q9GAJwH0shDRm1XIv0Zb5q96wf6Re4ELmcTRBWMiBtwkKSYd7uoDgadXsNnH9fN5zHXGXaDWDUj6wJGj1X29tyxLBdhdQD/Cr1hAzvk/QnQ1YanPRX0W0OlDvLVnE6bDDRMUd12IdZIDKD6weMMdLOijml1jfSpZVg2/aUxVLngFqq96Yd3W3BfCCV6JKLRTGZzp7wJdIBYKj70nlfAVgyPKkzVWmKZvu5HgoPpzW7KHMvMFUGgjw8j1DvnqiGFnHS+EH2bmgve7+fmFwoQUdm+j81d2OzhYcn3e9LNWnKYvPzBiSwGJ1H8MLshfb3nGNKGZGS0zXaFJ8KZZNuB/BQpeLCRa1NK0AZW6ZRKqLkd6J9fSEvCcQlRbicPfRDpF7Wsh+M9LQL4LXBUaHdpnSImOe0lwS6NeBrzeNZG16TELHvTcfo+O5jzRfENOvrI4iRDyaZ/BC7ed2K7BY=
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
- [High] mm/hmm: split of non-anonymous large folios in hmm_vma_handle_migr=
ate_prepare()
- [High] mm/hmm: early PMD walk termination on folio split failure in hmm_v=
ma_walk_pmd()
- [High] mm/hmm: reject KSM folios in hmm_vma_handle_migrate_prepare()
--

commit 9b85d918ada9ba7990835bcd807b9973c5976885
Author: Mika Penttil=C3=A4 <mpenttil@redhat.com>

mm/hmm: migrate collection in HMM pagewalk - pte level

This commit implements PTE-level migration preparation and collection in
hmm_vma_handle_migrate_prepare(), along with migrate_vma_split_folio() to
split PTE-mapped large folios during an HMM page table walk.

> diff --git a/mm/hmm.c b/mm/hmm.c
> index 854d2c090b20c..ec9280ef26822 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -495,6 +495,71 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk =
*walk, unsigned long start,
>  #endif  /* CONFIG_ARCH_HAS_PMD_SOFTLEAVES */
> =20
>  #ifdef CONFIG_DEVICE_MIGRATION

[ ... ]

> @@ -512,8 +582,230 @@ static int hmm_vma_handle_migrate_prepare(const str=
uct mm_walk *walk,
>  					  unsigned long *hmm_pfn,
>  					  bool *unmapped)
>  {
> -	// TODO: implement migration entry insertion
> +	struct hmm_vma_walk *hmm_vma_walk =3D walk->private;
> +	struct hmm_range *range =3D hmm_vma_walk->range;
> +	struct migrate_vma *migrate =3D range->migrate;

[ ... ]

> +		if (folio_test_large(folio)) {
> +			int ret;
> +
> +			ret =3D migrate_vma_split_folio(folio,
> +						      migrate->fault_page,
> +						      hmm_vma_walk,
> +						      ptep);
> +			if (ret)
> +				goto out_error;
> +			return -EAGAIN;
> +		}
> +
> +		pfn =3D page_to_pfn(page);
> +		if (softleaf_is_device_private_write(entry))
> +			writable =3D true;
> +	} else {
> +		pfn =3D pte_pfn(pte);
> +		if (is_zero_pfn(pfn) &&
> +		    (minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +			/* Like pte_none(): only anonymous memory can be populated */
> +			if (!vma_is_anonymous(walk->vma))
> +				goto out;
> +			*hmm_pfn &=3D HMM_PFN_INOUT_FLAGS;
> +			*hmm_pfn |=3D HMM_PFN_MIGRATE;
> +			goto out;
> +		}
> +		page =3D vm_normal_page(walk->vma, addr, pte);
> +		if (page && !is_zone_device_page(page) &&
> +		    !(minfo & MIGRATE_VMA_SELECT_SYSTEM)) {
> +			goto out;
> +		} else if (page && is_device_coherent_page(page)) {
> +			pgmap =3D page_pgmap(page);
> +
> +			if (!(minfo &
> +			      MIGRATE_VMA_SELECT_DEVICE_COHERENT) ||
> +			    pgmap->owner !=3D migrate->pgmap_owner)
> +				goto out;
> +		}
> +
> +		folio =3D page ? page_folio(page) : NULL;
> +		if (folio && folio_test_large(folio)) {
> +			int ret;
> +
> +			ret =3D migrate_vma_split_folio(folio,
> +						      migrate->fault_page,
> +						      hmm_vma_walk,
> +						      ptep);
> +			if (ret)
> +				goto out_error;
> +			return -EAGAIN;
> +		}
> +
> +		writable =3D pte_write(pte);
> +	}

[Severity: High]
When walking a private file-backed VMA (which can contain a mix of
copy-on-write anonymous pages and read-only pagecache pages), will this
attempt to split non-anonymous large pagecache folios before checking
folio_test_anon()?

In the pte_present(pte) branch of hmm_vma_handle_migrate_prepare(),
migrate_vma_split_folio() is called on any large folio before verifying that
the folio is anonymous. If a PTE maps a read-only large file-backed folio in
the page cache, migrate_vma_split_folio() drops the PTE lock, takes the
sleeping folio_lock(folio) on the pagecache folio while already holding loc=
ks
on previously collected anonymous folios, and calls split_folio().

For file-backed folios, split_folio() -> __folio_freeze_split_file() takes
i_mmap_lock_read() and unmaps the folio without remapping it, leaving the
PTEs as pte_none() on the -EAGAIN retry, only for the resulting order-0
pagecache folio to be skipped by the !folio_test_anon() check. Furthermore,
if the filesystem sets mapping_min_folio_order() > 0, split_folio() fails
with -EINVAL (triggering VM_WARN_ONCE() in __folio_split()) and jumps to
out_error.

Should the !page || !folio_test_anon(folio) check happen before attempting =
to
split the folio in the present PTE path?

> +
> +	/* Only anonymous memory can be migrated to device memory */
> +	if (!page || !folio_test_anon(page_folio(page)))
> +		goto out;

[Severity: High]
Can KSM folios pass this check and be collected for device migration?

In include/linux/page-flags.h, FOLIO_MAPPING_KSM is defined as:

	FOLIO_MAPPING_ANON | FOLIO_MAPPING_ANON_KSM

Because FOLIO_MAPPING_ANON is set on KSM folios, folio_test_anon() returns
true for them. When hmm_range_fault() runs without HMM_PFN_REQ_WRITE (for
example during migrate_vma_setup() or a read fault with migration),
hmm_vma_handle_pte() does not break CoW on a read-only KSM PTE, and
hmm_vma_handle_migrate_prepare() locks and collects the KSM folio.

If the same KSM folio is mapped a second time later in the walked range,
hmm_vma_handle_pte() marks the second entry HMM_PFN_VALID before
folio_trylock() fails in hmm_vma_handle_migrate_prepare(), and
try_to_migrate() later unmaps that second mapping via rmap_walk_ksm(),
leaving a stale PFN in range->hmm_pfns. More importantly, migrating a KSM
folio to MEMORY_DEVICE_PRIVATE memory updates stable_node->kpfn via
folio_migrate_ksm() to a non-CPU-accessible ZONE_DEVICE PFN and installs
device-private swap entries into other processes sharing the KSM page,
causing ksmd to fault when it later accesses the page in memcmp_pages().

Should hmm_vma_handle_migrate_prepare() also reject folio_test_ksm(folio)?

[ ... ]

> +		set_pte_at(mm, addr, ptep, swp_pte);
> +		folio_remove_rmap_pte(folio, page, walk->vma);
> +		folio_put(folio);
> +		*hmm_pfn |=3D HMM_PFN_VALID | HMM_PFN_MIGRATE;
> +		if (pte_present(pte))
> +			*unmapped =3D true;
> +	} else {
> +		folio_put(folio);
> +	}
> +out:
>  	return 0;
> +out_error:
> +	return -EFAULT;
>  }

[Severity: High]
As reported by Sashiko on v16 [1], when migrate_vma_split_folio() fails in
hmm_vma_handle_migrate_prepare() and jumps to out_error (-EFAULT), does the
caller in hmm_vma_walk_pmd() abort the PMD walk too early and leave the
remaining pages in the PMD unprocessed?

In hmm_vma_walk_pmd(), the PTE loop handles non-zero returns from
hmm_vma_handle_migrate_prepare() by immediately returning 0:

	for (; addr < end; addr +=3D PAGE_SIZE, ptep++, hmm_pfns++) {

		r =3D hmm_vma_handle_pte(walk, addr, end, pmdp, ptep, hmm_pfns);
		...
		r =3D hmm_vma_handle_migrate_prepare(walk, pmdp, ptep, addr, hmm_pfns, &u=
nmapped);
		if (r =3D=3D -EAGAIN) {
			...
			goto again;
		}
		if (r) {
			HMM_ASSERT_UNLOCKED(hmm_vma_walk);
			if (unmapped)
				flush_tlb_range(walk->vma, start, addr);
			return 0;
		}
	}

Because hmm_vma_handle_pte() is called inside the same per-page loop,
returning 0 from hmm_vma_walk_pmd() when a split fails at addr skips both
hmm_vma_handle_pte() and hmm_vma_handle_migrate_prepare() for all remaining
addresses in [addr + PAGE_SIZE, end) of the PMD. As a result,
hmm_range_fault() can return 0 (success) while range->hmm_pfns[] entries for
[addr + PAGE_SIZE, end) remain zeroed without HMM_PFN_VALID, and pages in
that tail of the PMD are neither faulted in (when HMM_PFN_REQ_FAULT is
requested) nor migrated.

[1] https://lore.kernel.org/r/20261021060506.2377545-6-mpenttil@redhat.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103061629.9726=
69-1-mpenttil@redhat.com?part=3D5

