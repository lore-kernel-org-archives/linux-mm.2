Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8429DE81BD4
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 14:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C62836B0089; Mon,  9 Feb 2026 09:47:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0DA46B00B1; Mon,  9 Feb 2026 09:47:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B39B66B00B3; Mon,  9 Feb 2026 09:47:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A07C16B0089
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 09:47:47 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 512DBC02E3
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:47:47 +0000 (UTC)
X-FDA: 84425197374.15.613BD48
Received: from mgamail.intel.com (mgamail.intel.com [192.198.163.10])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3E5031C0011
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 14:47:43 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X9rpIA9S;
	spf=pass (imf18.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770648465;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0zp0gELXTjD7k73tSRJT0rk01wV2cdIWRTlcR22in2g=;
	b=AVr2BHktkNubpo/mNMSjpBA5XAAmOCZTDUOPqDpJ/DzmAbhKMjzH/0n/onLjgyPhOOGNCA
	9XL2XjHwrA/0vYjHO8IQ7M3R9J7ELyndliYVH5bx11cuxeT2Aib0wzGRQh08fddeXKRLpM
	sFPzdVFab+DCTj83YjMTh+/hAMZoNuA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=intel.com header.s=Intel header.b=X9rpIA9S;
	spf=pass (imf18.hostedemail.com: domain of thomas.hellstrom@linux.intel.com designates 192.198.163.10 as permitted sender) smtp.mailfrom=thomas.hellstrom@linux.intel.com;
	dmarc=pass (policy=none) header.from=intel.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770648465; a=rsa-sha256;
	cv=none;
	b=2JXTQDCgFuktk6StjV/O5g85GCylcPVkPQwE6qafuUHR5hHxFvN2HLrkC+rEqpbIZ1Gkfp
	bsT3RM4ZBuh3+KOj+ai1GbTFtq6NVurGjsbNBNrnDojemBbpHYaOW3iqz/1ItT5dmU5BeR
	sDTR+OwzTWkyiiku96kzDZHN0HHpqoQ=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1770648464; x=1802184464;
  h=message-id:subject:from:to:cc:date:in-reply-to:
   references:content-transfer-encoding:mime-version;
  bh=ojeQRBv8bzl/j97EeAF06BrN9pveqc9QIkYGezj3hXM=;
  b=X9rpIA9S7w3wbRgff0tRaE3xEyyooZ2fvHX7LnCUj265JWJ5BztRinjx
   QdxOSZu2jLMnhrcZCf82xYW0In2XQi83R76simpuOWoCrinsaJSwa6/HI
   9NvLfYuDuvanpfPDshe6TdY+L1Hny9wKlg5Ekey/g9CEX1vyOofszMKuf
   Qrmla0ZAT9xrEWljB6D1YJgPUAST+1uQGvjdxw82D7T7hvTDSSm+BcWXM
   /TC7TNF/DC/C6IejBcLW3O4pTJMXQrIzuPL/EX/QskljoHlPiKBUFhi7o
   dFqiBCm5mevikJz3a4Sim7velt9XLubUMRYBSuIWbIDtGxl+iU780YBKE
   A==;
X-CSE-ConnectionGUID: 5yW6pSZrSCCuPIMye4ae1w==
X-CSE-MsgGUID: uCb5uupFS3ukRXqrurRHqA==
X-IronPort-AV: E=McAfee;i="6800,10657,11696"; a="83129946"
X-IronPort-AV: E=Sophos;i="6.21,282,1763452800"; 
   d="scan'208";a="83129946"
Received: from fmviesa003.fm.intel.com ([10.60.135.143])
  by fmvoesa104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 06:47:43 -0800
X-CSE-ConnectionGUID: ON98wxCIRHu35vc14P9ZiA==
X-CSE-MsgGUID: bjaKtFV/QKqKQsgPUhRYhw==
X-ExtLoop1: 1
Received: from egrumbac-mobl6.ger.corp.intel.com (HELO [10.245.245.179]) ([10.245.245.179])
  by fmviesa003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Feb 2026 06:47:40 -0800
Message-ID: <89cb1d4744789702cd80dba8eb40dd50bf053b4e.camel@linux.intel.com>
Subject: Re: [PATCH v4] mm: Fix a hmm_range_fault() livelock / starvation
 problem
From: Thomas =?ISO-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>
To: intel-xe@lists.freedesktop.org
Cc: Alistair Popple <apopple@nvidia.com>, Ralph Campbell
 <rcampbell@nvidia.com>,  Christoph Hellwig	 <hch@lst.de>, Jason Gunthorpe
 <jgg@mellanox.com>, Jason Gunthorpe <jgg@ziepe.ca>,  Leon Romanovsky	
 <leon@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Matthew Brost
	 <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
	linux-mm@kvack.org, dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Date: Mon, 09 Feb 2026 15:47:38 +0100
In-Reply-To: <20260205111028.200506-1-thomas.hellstrom@linux.intel.com>
References: <20260205111028.200506-1-thomas.hellstrom@linux.intel.com>
Organization: Intel Sweden AB, Registration Number: 556189-6027
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.58.2 (3.58.2-1.fc43) 
MIME-Version: 1.0
X-Stat-Signature: pznfyxthijki4isxmrkxjxza6qamum9t
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3E5031C0011
X-HE-Tag: 1770648463-600227
X-HE-Meta: U2FsdGVkX1+RzqP2/MR9HCPSO3234eFlVXwVjl8X6sCbTxYPzJQdFo/+TD7uBmf/k2ej/iutZPfTEBjG8lHPGPkzDm3ECGsbaha3cKYuK9hMVQteTNkr95qVd3gM6wYP45Baeut5pDJ8exMvIIWaFbwuaq3ZTKF9eIyjWQBALMSjjdM5cqEUDi5xFtzALhSECNYkQAydZ+UKiuK7Cog7OmyUdAcSdQQRdO1h1U1wrrc0VngXZjO2IZIpH34sWi6dQFiaSNrTjX5OX50rMjc20IC8E7qSXokzcN3b3mzynkN+pZrXji8XCPtc1wImi93yiQ2N806T6ruLPTH3PBI0dtHUQIikaw+WvWMBnBq3Ff6GQi4O42iTd05Z0fbA7cH7iila8T0Z75ubr8HMBoLywclhSPXgAKfY5hkWnM+ZJe72g+cITSMfvnWfJssNdVkdHuHepB69rj5SiL/VW8L5PMIf51v4iCb9bn7JCfFrQxvW2S3GwxYevfEbbRv2hbuf82D1o/5zEu+Kz5tBiDUuENcFNResLWkYancL/uqmDEv79ERUxZbfxJ6Sez/WwP25J7K0IcBQO9JGizNQPpXWzRr8/U4+vuNg3akbkL1Wclq83ekLRAOg/5R5YtBrdgJ1CJ0KhvWLOw5eht9Y5yGPP218CW5v0SFx8y1vanjXYrQfVvE2/bN/oy5hpmrPB1o74E7ij/YaA7zUlBjyOPx3bKEDX4AXN0gUTJHoP5ss7cKkE/h9q85PJFaxdJpSJohgrnxzBTFsbojhTUdz/haujszFtHjmqKtzdZPULjsjJ7HWZptMMvl+AYc1FyeyTGN0FWJhR3kbtmUoAAORhnpAjJq7ce8xpaH2AWZVHOIyTGic2JlDmL+BXzx4NOWCggwYNA6B7phXll2V1EpPjP2sGIUOs2/wDtsQvLCQEyWOkxjlY+9KOPlHMs2kObPYYY2CtWHDsY0F+bjTxsGibRl
 oTtVmy2H
 5AfmVD0IGtAO6jkK1f6HElnO8vuxfaFdbvvYN2EBxpdpK1SZxuUF857m8xLK9+L5SxVXiE7Z0UwT8cLnob8pZcG8pJi8KcJuwbUBA70qStJemt4qZRRhSCvOD3pILIqtIXud0Xnl5nnqGcAPNhe8SuL6CtbXLDqPgNKl0YGSrDUw8nfi3895opXE3c6jiPl9LYvx8gd9RAffmeTFLNF0y8klfRWop2ESFJH01ZK2xoeJ7fNajHF6WWnjO4L9cEMdX3SN+vbj27l9HuWW236qItloI7cBFjrY3IxDrhrpUHyi5JQYSbiYQa1jfTVLhgmDUFA202IMp2uO2GGzO+NjfiDOgH6bGIKQmTz4TiJOE++ZENtFkEOfCmUtFwO4s+FAx4d3nBkcMbjS9xd0X5OpVLPxC8aVoSpnR2GsBO/BdY4xVlndR29aTokiUq47vz8WcxmA4UuWXjkn+6fzWDo5ONIF/ptDIIITHyj5Y4c514HUeoOI28VxPLHdAhtLqTeihAu+DK0/S72iiHZJLFYQMwpxB1ZHMqZpZx53TIYFND7duQhV1vZouQObMtEchNYpIhEk4YC0aiD7w8tLZV8uhDEM80NDTjnChbfikd3fh+sEgVEggVYjFPGDLcA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

@Alistair, any chance of an R-B for the below version?
@Andrew, will this go through the -mm tree or alternaltively an ack for
merging through drm-xe-fixes?

/Thomas

8<-------------------------------------------------------------------

On Thu, 2026-02-05 at 12:10 +0100, Thomas Hellstr=C3=B6m wrote:
> If hmm_range_fault() fails a folio_trylock() in do_swap_page,
> trying to acquire the lock of a device-private folio for migration,
> to ram, the function will spin until it succeeds grabbing the lock.
>=20
> However, if the process holding the lock is depending on a work
> item to be completed, which is scheduled on the same CPU as the
> spinning hmm_range_fault(), that work item might be starved and
> we end up in a livelock / starvation situation which is never
> resolved.
>=20
> This can happen, for example if the process holding the
> device-private folio lock is stuck in
> =C2=A0=C2=A0 migrate_device_unmap()->lru_add_drain_all()
> The lru_add_drain_all() function requires a short work-item
> to be run on all online cpus to complete.
>=20
> A prerequisite for this to happen is:
> a) Both zone device and system memory folios are considered in
> =C2=A0=C2=A0 migrate_device_unmap(), so that there is a reason to call
> =C2=A0=C2=A0 lru_add_drain_all() for a system memory folio while a
> =C2=A0=C2=A0 folio lock is held on a zone device folio.
> b) The zone device folio has an initial mapcount > 1 which causes
> =C2=A0=C2=A0 at least one migration PTE entry insertion to be deferred to
> =C2=A0=C2=A0 try_to_migrate(), which can happen after the call to
> =C2=A0=C2=A0 lru_add_drain_all().
> c) No or voluntary only preemption.
>=20
> This all seems pretty unlikely to happen, but indeed is hit by
> the "xe_exec_system_allocator" igt test.
>=20
> Resolve this by waiting for the folio to be unlocked if the
> folio_trylock() fails in the do_swap_page() function.
>=20
> Rename the migration_entry_wait_on_locked() function to
> softleaf_entry_wait_unlock() and update its documentation to
> indicate the new use-case.
>=20
> Future code improvements might consider moving
> the lru_add_drain_all() call in migrate_device_unmap() to be
> called *after* all pages have migration entries inserted.
> That would eliminate also b) above.
>=20
> v2:
> - Instead of a cond_resched() in the hmm_range_fault() function,
> =C2=A0 eliminate the problem by waiting for the folio to be unlocked
> =C2=A0 in do_swap_page() (Alistair Popple, Andrew Morton)
> v3:
> - Add a stub migration_entry_wait_on_locked() for the
> =C2=A0 !CONFIG_MIGRATION case. (Kernel Test Robot)
> v4:
> - Rename migrate_entry_wait_on_locked() to
> =C2=A0 softleaf_entry_wait_on_locked() and update docs (Alistair Popple)
>=20
> Suggested-by: Alistair Popple <apopple@nvidia.com>
> Fixes: 1afaeb8293c9 ("mm/migrate: Trylock device page in
> do_swap_page")
> Cc: Ralph Campbell <rcampbell@nvidia.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Jason Gunthorpe <jgg@mellanox.com>
> Cc: Jason Gunthorpe <jgg@ziepe.ca>
> Cc: Leon Romanovsky <leon@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: Matthew Brost <matthew.brost@intel.com>
> Cc: John Hubbard <jhubbard@nvidia.com>
> Cc: Alistair Popple <apopple@nvidia.com>
> Cc: linux-mm@kvack.org
> Cc: <dri-devel@lists.freedesktop.org>
> Signed-off-by: Thomas Hellstr=C3=B6m <thomas.hellstrom@linux.intel.com>
> Cc: <stable@vger.kernel.org> # v6.15+
> Reviewed-by: John Hubbard <jhubbard@nvidia.com> #v3
> ---
> =C2=A0include/linux/migrate.h |=C2=A0 8 +++++++-
> =C2=A0mm/filemap.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 | 15 ++++++++++-----
> =C2=A0mm/memory.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0 |=C2=A0 3 ++-
> =C2=A0mm/migrate.c=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0 |=C2=A0 8 ++++----
> =C2=A0mm/migrate_device.c=C2=A0=C2=A0=C2=A0=C2=A0 |=C2=A0 2 +-
> =C2=A05 files changed, 24 insertions(+), 12 deletions(-)
>=20
> diff --git a/include/linux/migrate.h b/include/linux/migrate.h
> index 26ca00c325d9..3cc387f1957d 100644
> --- a/include/linux/migrate.h
> +++ b/include/linux/migrate.h
> @@ -65,7 +65,7 @@ bool isolate_folio_to_list(struct folio *folio,
> struct list_head *list);
> =C2=A0
> =C2=A0int migrate_huge_page_move_mapping(struct address_space *mapping,
> =C2=A0		struct folio *dst, struct folio *src);
> -void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t
> *ptl)
> +void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t
> *ptl)
> =C2=A0		__releases(ptl);
> =C2=A0void folio_migrate_flags(struct folio *newfolio, struct folio
> *folio);
> =C2=A0int folio_migrate_mapping(struct address_space *mapping,
> @@ -97,6 +97,12 @@ static inline int set_movable_ops(const struct
> movable_operations *ops, enum pag
> =C2=A0	return -ENOSYS;
> =C2=A0}
> =C2=A0
> +static inline void softleaf_entry_wait_on_locked(softleaf_t entry,
> spinlock_t *ptl)
> +	__releases(ptl)
> +{
> +	spin_unlock(ptl);
> +}
> +
> =C2=A0#endif /* CONFIG_MIGRATION */
> =C2=A0
> =C2=A0#ifdef CONFIG_NUMA_BALANCING
> diff --git a/mm/filemap.c b/mm/filemap.c
> index ebd75684cb0a..d98e4883f13d 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1379,14 +1379,16 @@ static inline int
> folio_wait_bit_common(struct folio *folio, int bit_nr,
> =C2=A0
> =C2=A0#ifdef CONFIG_MIGRATION
> =C2=A0/**
> - * migration_entry_wait_on_locked - Wait for a migration entry to be
> removed
> - * @entry: migration swap entry.
> + * softleaf_entry_wait_on_locked - Wait for a migration entry or
> + * device_private entry to be removed.
> + * @entry: migration or device_private swap entry.
> =C2=A0 * @ptl: already locked ptl. This function will drop the lock.
> =C2=A0 *
> - * Wait for a migration entry referencing the given page to be
> removed. This is
> + * Wait for a migration entry referencing the given page, or
> device_private
> + * entry referencing a dvice_private page to be unlocked. This is
> =C2=A0 * equivalent to folio_put_wait_locked(folio, TASK_UNINTERRUPTIBLE)
> except
> =C2=A0 * this can be called without taking a reference on the page.
> Instead this
> - * should be called while holding the ptl for the migration entry
> referencing
> + * should be called while holding the ptl for @entry referencing
> =C2=A0 * the page.
> =C2=A0 *
> =C2=A0 * Returns after unlocking the ptl.
> @@ -1394,7 +1396,7 @@ static inline int folio_wait_bit_common(struct
> folio *folio, int bit_nr,
> =C2=A0 * This follows the same logic as folio_wait_bit_common() so see th=
e
> comments
> =C2=A0 * there.
> =C2=A0 */
> -void migration_entry_wait_on_locked(softleaf_t entry, spinlock_t
> *ptl)
> +void softleaf_entry_wait_on_locked(softleaf_t entry, spinlock_t
> *ptl)
> =C2=A0	__releases(ptl)
> =C2=A0{
> =C2=A0	struct wait_page_queue wait_page;
> @@ -1428,6 +1430,9 @@ void migration_entry_wait_on_locked(softleaf_t
> entry, spinlock_t *ptl)
> =C2=A0	 * If a migration entry exists for the page the migration
> path must hold
> =C2=A0	 * a valid reference to the page, and it must take the ptl
> to remove the
> =C2=A0	 * migration entry. So the page is valid until the ptl is
> dropped.
> +	 * Similarly any path attempting to drop the last reference
> to a
> +	 * device-private page needs to grab the ptl to remove the
> device-private
> +	 * entry.
> =C2=A0	 */
> =C2=A0	spin_unlock(ptl);
> =C2=A0
> diff --git a/mm/memory.c b/mm/memory.c
> index da360a6eb8a4..20172476a57f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4684,7 +4684,8 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> =C2=A0				unlock_page(vmf->page);
> =C2=A0				put_page(vmf->page);
> =C2=A0			} else {
> -				pte_unmap_unlock(vmf->pte, vmf-
> >ptl);
> +				pte_unmap(vmf->pte);
> +				softleaf_entry_wait_on_locked(entry,
> vmf->ptl);
> =C2=A0			}
> =C2=A0		} else if (softleaf_is_hwpoison(entry)) {
> =C2=A0			ret =3D VM_FAULT_HWPOISON;
> diff --git a/mm/migrate.c b/mm/migrate.c
> index 4688b9e38cd2..cf6449b4202e 100644
> --- a/mm/migrate.c
> +++ b/mm/migrate.c
> @@ -499,7 +499,7 @@ void migration_entry_wait(struct mm_struct *mm,
> pmd_t *pmd,
> =C2=A0	if (!softleaf_is_migration(entry))
> =C2=A0		goto out;
> =C2=A0
> -	migration_entry_wait_on_locked(entry, ptl);
> +	softleaf_entry_wait_on_locked(entry, ptl);
> =C2=A0	return;
> =C2=A0out:
> =C2=A0	spin_unlock(ptl);
> @@ -531,10 +531,10 @@ void migration_entry_wait_huge(struct
> vm_area_struct *vma, unsigned long addr, p
> =C2=A0		 * If migration entry existed, safe to release vma
> lock
> =C2=A0		 * here because the pgtable page won't be freed
> without the
> =C2=A0		 * pgtable lock released.=C2=A0 See comment right above
> pgtable
> -		 * lock release in migration_entry_wait_on_locked().
> +		 * lock release in softleaf_entry_wait_on_locked().
> =C2=A0		 */
> =C2=A0		hugetlb_vma_unlock_read(vma);
> -		migration_entry_wait_on_locked(entry, ptl);
> +		softleaf_entry_wait_on_locked(entry, ptl);
> =C2=A0		return;
> =C2=A0	}
> =C2=A0
> @@ -552,7 +552,7 @@ void pmd_migration_entry_wait(struct mm_struct
> *mm, pmd_t *pmd)
> =C2=A0	ptl =3D pmd_lock(mm, pmd);
> =C2=A0	if (!pmd_is_migration_entry(*pmd))
> =C2=A0		goto unlock;
> -	migration_entry_wait_on_locked(softleaf_from_pmd(*pmd),
> ptl);
> +	softleaf_entry_wait_on_locked(softleaf_from_pmd(*pmd), ptl);
> =C2=A0	return;
> =C2=A0unlock:
> =C2=A0	spin_unlock(ptl);
> diff --git a/mm/migrate_device.c b/mm/migrate_device.c
> index 23379663b1e1..deab89fd4541 100644
> --- a/mm/migrate_device.c
> +++ b/mm/migrate_device.c
> @@ -176,7 +176,7 @@ static int migrate_vma_collect_huge_pmd(pmd_t
> *pmdp, unsigned long start,
> =C2=A0		}
> =C2=A0
> =C2=A0		if (softleaf_is_migration(entry)) {
> -			migration_entry_wait_on_locked(entry, ptl);
> +			softleaf_entry_wait_on_locked(entry, ptl);
> =C2=A0			spin_unlock(ptl);
> =C2=A0			return -EAGAIN;
> =C2=A0		}

