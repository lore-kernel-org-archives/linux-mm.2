Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B71DD606A319
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 06:07:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PmQs478R
Received: by kanga.kvack.org (Postfix)
	id 0D8306B0894; Thu, 22 Oct 2026 02:06:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 063B56B0896; Thu, 22 Oct 2026 02:06:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E6BDB6B0897; Thu, 22 Oct 2026 02:06:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AFBFB6B0894
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 02:06:51 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 984ECA7B0C
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:06:50 +0000 (UTC)
X-FDA: 85349228580.29.07CE39C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id EEB81180006
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 06:06:48 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PmQs478R;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792649209;
	b=TjyQr+swJHF9Vyb7QUfn2/tGIiSdfXkhIWQ4gB0FtIkrEz8BIQ9xGp1z3MVK5fNdXLwMMj
	NrWAGqjMUncxAZNnHG9pnMo/PyULkGx6NoKE0cVpzk0CJmqTDsXztmyWbyJI+oFBePzojx
	AsbXOnKJFd4QHidfuMdsYU87GjcglSg=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PmQs478R;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792649209;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t093X0QSCK+KMHsm1kHzPgB+nYnDNYmHt4aO+u2fk0A=;
	b=sVTLxtBTKlutpecC1KH1OjlLXRfPCTzTgmaN9hJYEyOFU6zE2rEGzVn1VRHWRy/EQCqKLA
	UDwTlG8YMn4HgBX0iLJqzSY+BCv8VanMZ/if0DsxT3RnjVbwRNuPp+zhr4i75w9NJKlQsj
	CFFvrAkXthHCnMD1dBfl4MXiDeMr+vQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4A5DC43261;
	Thu, 22 Oct 2026 06:06:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C21F1F000C1;
	Thu, 22 Oct 2026 06:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792649208;
	bh=t093X0QSCK+KMHsm1kHzPgB+nYnDNYmHt4aO+u2fk0A=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=PmQs478RgMa18TeW3N9JVkTB7hQaufXCA7JKi0lYfjFsFKfsFLI1hOEmc70j+0nPi
	 BUgRv1Uu4RgHDVr6nhKYoNtGkgDwpo9wJcHgtneSMyCJB3DMBfp03YkNTMpujlZ2Eg
	 VYO3WLAXUp8qMaEX3XjmEnaHiAY083XgZ+A9LiC4Vn4zb69h8ZRyLabNm+9OfXNpyn
	 0Tqh8KHNEKyDkpD2IULhB2Z3bkirVMoZZeK4VTM3wFO1InvP/iLrs05kEb8ZIxeDDT
	 W7STLRGsYqPWrany7SNUSwuHPBy2ohH5cy74vHVZj73V61F/8s3vIPF4beWde/jxhS
	 hLF+vVd3CbpIA==
Message-ID: <sashiko-outbox-181060@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v16 12/12] drm/nouveau/svm: add support for migrate on
 fault
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
In-Reply-To: <20261021060506.2377545-13-mpenttil@redhat.com>
References: <20261021060506.2377545-1-mpenttil@redhat.com>
 <20261021060506.2377545-13-mpenttil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 22 Oct 2026 06:06:46 +0000
X-Stat-Signature: k9qsqqf98gdxiwte98auni5mk6pi6grx
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: EEB81180006
X-Rspam-User: 
X-HE-Tag: 1792649208-964039
X-HE-Meta: U2FsdGVkX1+kWdncUwzsOF7S4uhtOchgqQGdL4IfayP6P3JLwA20UwTA5uBD9QA76GzUMZjUXLYkITSRoiYMzRyCxe3vyjOA0WiNCPO2k/zxBy15vp9HV+RMVckAkWAcZAemsJpz08EnxSKdGrydZRlCNsCoPK/vmSCy3ZmcGGnfGMg3ZOcPDwxSSwUP27e/S91kftZOx2VlzCxRIZ0QMrJ1RBFyMO8s8UnF1XiDvsOuCW8FNd8RuEzmvAq0EryF9hHC03vCrDtBX7oLdF9jrvq/+SiUgXr+syUFQ5SfQ3OMl7Zo/KhetU/ymIRDlNZanrB93We0UwwuPDWt1VGarDhnZWvw2qRM/+QKRwL3f6zcF0jbkfI0ZE7FkvftZn9mk2W4VzAEW304TShjtgdIzgqiRRcIvydOwmFvLFIsb/gVtXcNmrWG7JL4ZxPb0IAbPH5BMIIbxImlo2SW13JTWUn6fUw4waCzNEgL1j68FgX4ghQ85FNinBbH/6TwdJaJytcZEWc6iQgbXquqrJq0uFOjrDpnhHmFDxY5S5lZc2o57H9jz2hQ+wGNJzfnVkrE8415Crr8qap8fFx9dCFk9QrhT+MKt0Z7s9D3k+aQ7TIDmmPj6yiFJa9bA6d5I4WLnp1xuHCj7agw47x5c3BV0tqO9pa/+m/bfFraxg7/6si4beakby5RXbcWUvztftgOXCMEz14K6gAbM0gfnDaFKRnyDn2MFHRwqzE+Osf13b/0zYnyVG20kDgv8e3oywPsPEV6AyZWZiFXPYWI3cbpkSelCJT9Nq+yJPmQkm+EfQvH0a1TYU0tfiwP54hJNJoD0jzTKW9zBDREE+r5LCEJPazoRj7nIR+vitdrgtP8lZANQ8ouj2jDUtBEYMtE0NiLA5iHOuk3AVsewav8vatRMzXU4UrLvBNDZQ1cESRpc1e5/AnZVFZbOJnPrNt2VScyZCPipwRUO8pLoAdo1DV
 tK+Lj6+k
 c2GlL+05tqDNmiSIRxo2ViUsrCvwcsKEPfwvDxxJQbbDiB7X5ACYjhmWC1worXN7YvJq1wWQvo2iMU0x8S0ogzWHLMMTic213IJrJ9WpB/Vch2khZBHC+a7uOlVYsIQ6SQfQ/u4TC3hBHoeZE6zIakzYNIT+LgKGhMW0ezy+1K19KA3eHJnbuuhV7xkA5BiXKCWpuY2Rueg9c9A6dSsiWBYILH7wILFY07uK49M0MhlyLHBQBMkpmNvY4d9gtF3v7txDdFqktFdRU0UB83uH4rSil7foxcERDul9P6QWBQJnFuxeokjEZMCvb0rUgyKJxFSZSHnX23RtBgYiGd7EIVrNlqsxqvqWM3IVm8LkCYdprVQjetvMJvnxwDpiyQfqcpQyQsjenz3a8luVDs+4nK2ZeCOO+iKMMjxhQSzXguxEDdCnxZdCk59l33EUpm3xfYPFAEEisc1pamYvII4qx8TpX8Wmyz+ysiIZKBf2iT/JAMB5Rd7Ix2jM2J3SoOkkC6LYzFq/j6An/8pzIey/pN+1vWPL+KQmsmrfhKRC9p7ASPRy+sBMRMsNyZTLZYixsTlfj+Yse37QIX7rnC9wsXkulFJhcpTwW7QtY9JnvnFd6uQzsmG5Zk9yKoA4ce3nsUFGLNa+gkuUJe0oVODPRsMOx8X4khw7dqlFC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 9 potential issue(=
s) to consider:
- [Critical] drm/nouveau/dmem: freed VRAM page mapped on migrate_vma_pages(=
) abort
- [Critical] drm/nouveau/dmem: copy timeout in nouveau_dmem_migrate_fault()=
 maps uncopied page
- [Critical] drm/nouveau/svm: nouveau_svm_range_invalidate() ignores all dr=
iver migrations
- [High] drm/nouveau/dmem: unchecked nouveau_fence_new() in nouveau_dmem_fe=
nce_poll() callers
- [High] drm/nouveau/svm: unguarded __nouveau_pfns_map_locked() on empty pf=
n in nouveau_dmem_migrate_fault()
- [High] drm/nouveau/dmem: unsynchronized access to migrate.chan in nouveau=
_dmem_migrate_fault()
- [Medium] drm/nouveau: unguarded pfn map and retry state in nouveau_dmem_m=
igrate_fault()
- [Medium] drm/nouveau/svm: __nouveau_pfns_map_locked() drops nvif_object_i=
octl() error
- [Low] drm/nouveau/svm: missing kernel-parameters.txt entry for svm_migrat=
e_on_fault
--

commit 44e0adde7e1aeb837684fa123e764779afbd3db4
Author: Mika Penttil=C3=A4 <mpenttil@redhat.com>

drm/nouveau/svm: add support for migrate on fault

This commit adds migrate-on-fault support for Nouveau SVM using
HMM_PFN_REQ_MIGRATE and migrate_hmm_range_setup(), gated by a new
svm_migrate_on_fault module parameter. It introduces
nouveau_dmem_migrate_fault() to fault and collect migratable pages in a
single hmm_range_fault() walk, and polls migration fences via
nouveau_dmem_fence_poll().

> diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nou=
veau/nouveau_dmem.c
> index e74d7bb975a86..998c63e2ae78b 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
[ ... ]
> @@ -150,6 +155,32 @@ static void nouveau_dmem_fence_done(struct nouveau_f=
ence **fence)
>  		 * the hmem object.
>  		 */
>  	}
> +
> +	/* 0 on completion, -EBUSY on timeout, or other errno; propagated. */
> +	return ret;
> +}
> +
> +/*
> + * Poll the copy fence instead of the lazy (interrupt-driven) wait since
> + * completion IRQ is randomly missed, hitting the timeout.
> + *
> + * Returns 0 on completion, -EBUSY on timeout. Consumes the fence refere=
nce.
> + */
> +static int nouveau_dmem_fence_poll(struct nouveau_fence **fence)
> +{
> +	unsigned long deadline =3D jiffies + 30 * HZ;
> +	int ret =3D 0;
> +
> +	while (!nouveau_fence_done(*fence)) {

[Severity: High]
What happens in nouveau_dmem_fence_poll() in
drivers/gpu/drm/nouveau/nouveau_dmem.c when nouveau_fence_new() fails in its
callers?

In drivers/gpu/drm/nouveau/nouveau_fence.c, nouveau_fence_new() can fail in
nouveau_fence_create() (without writing *pfence) or in nouveau_fence_emit()
(which calls nouveau_fence_unref(pfence) and sets *pfence =3D NULL).

Both callers of nouveau_dmem_fence_poll() ignore the return value of
nouveau_fence_new():

1. In nouveau_dmem_migrate_to_ram() in
drivers/gpu/drm/nouveau/nouveau_dmem.c, fence is declared uninitialized on
the stack:

	struct nouveau_fence *fence;
	...
	nouveau_fence_new(&fence, dmem->migrate.chan);
	migrate_vma_pages(&args);
	fret =3D nouveau_dmem_fence_poll(&fence);

2. In nouveau_dmem_migrate_fault() in
drivers/gpu/drm/nouveau/nouveau_dmem.c, fence is initialized to NULL:

	if (migrated)
		nouveau_fence_new(&fence, drm->dmem->migrate.chan);
	...
	if (migrated)
		fret =3D nouveau_dmem_fence_poll(&fence);

Since nouveau_fence_done() in drivers/gpu/drm/nouveau/nouveau_fence.c
immediately dereferences fence via nouveau_fctx(fence) and
dma_fence_is_signaled(&fence->base), won't a failure in nouveau_fence_new()
cause an uninitialized or NULL pointer dereference in
nouveau_dmem_fence_poll()?

> +		if (time_after(jiffies, deadline)) {
> +			ret =3D -EBUSY;
> +			break;
> +		}
> +		schedule_timeout_uninterruptible(msecs_to_jiffies(1));
> +	}
> +	nouveau_fence_unref(fence);
> +
> +	return ret;
>  }
[ ... ]
> @@ -266,9 +299,12 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struct=
 vm_fault *vmf)
> =20
>  	nouveau_fence_new(&fence, dmem->migrate.chan);
>  	migrate_vma_pages(&args);
> -	nouveau_dmem_fence_done(&fence);
> +	fret =3D nouveau_dmem_fence_poll(&fence);
>  	dma_unmap_page(drm->dev->dev, dma_info.dma_addr, dma_info.size,
>  				DMA_BIDIRECTIONAL);
> +	if (fret)
> +		/* Copy failed; the pte now points at possibly stale sysram data. */
> +		ret =3D VM_FAULT_SIGBUS;
>  done:
>  	migrate_vma_finalize(&args);
>  err:
[ ... ]
> @@ -832,6 +884,215 @@ static void nouveau_dmem_migrate_chunk(struct nouve=
au_drm *drm,
[ ... ]
> +int
> +nouveau_dmem_migrate_fault(struct nouveau_drm *drm, struct nouveau_svmm =
*svmm,
> +			   struct mmu_interval_notifier *notifier,
> +			   unsigned long start, unsigned long end,
> +			   unsigned long hmm_flags,
> +			   u64 *out_pfn0, unsigned long *out_addr,
> +			   unsigned int *out_shift)
> +{
[ ... ]
> +	/* hmm_range_fault() shares the source pfn array with migrate_vma. */
> +	range.hmm_pfns =3D migrate.src;
> +
> +	do {
> +		mmap_read_lock(mm);
> +		range.notifier_seq =3D mmu_interval_read_begin(notifier);
> +
> +		ret =3D hmm_range_fault(&range);
> +		/*
> +		 * Snapshot the pfn before migrate_hmm_range_setup() overwrites the
> +		 * shared array; used to map in place if nothing migrates.
> +		 */
> +		if (!ret)
> +			hmm_pfn0 =3D range.hmm_pfns[0];
> +		migrate_hmm_range_setup(&range);

[Severity: Medium]
When the retry loop in nouveau_dmem_migrate_fault() in
drivers/gpu/drm/nouveau/nouveau_dmem.c repeats after ret =3D=3D -EBUSY (eit=
her
from hmm_range_fault() or from mmu_interval_read_retry()), does migrate.src
(aliased by range.hmm_pfns) retain stale migrate_pfn values from the previo=
us
iteration?

migrate_hmm_range_setup() in mm/migrate_device.c overwrites range.hmm_pfns[=
i]
with migrate_pfn(...) flags, and neither migrate_vma_pages() nor
migrate_vma_finalize() clears migrate.src[]. Unlike migrate_vma_setup() in
mm/migrate_device.c, which zeroes args->src before calling hmm_range_fault(=
),
nouveau_dmem_migrate_fault() re-enters hmm_range_fault(&range) without
clearing migrate.src. If the next walk hits an early return path that does
not overwrite *hmm_pfn (for example, softleaf_is_migration() in
hmm_vma_handle_pte()), won't range.hmm_pfns still hold stale migrate_pfn da=
ta
from the prior attempt?

> +		if (ret) {
> +			migrate_vma_pages(&migrate);
> +			migrate_vma_finalize(&migrate);
> +			goto unlock;
> +		}
> +
> +		n =3D nouveau_dmem_migrate_alloc_and_copy(drm, svmm, &migrate,
> +							dma_info, pfns,
> +							&nr_dma, &order);
> +
> +		/* Only a migrated page has an in-flight CE copy to unblock below. */
> +		for (i =3D 0, migrated =3D false; i < npages; i++) {
> +			if (migrate.dst[i]) {
> +				migrated =3D true;
> +				break;
> +			}
> +		}
> +
> +		/*
> +		 * Track a copy fence only when a copy was enqueued; waiting on an
> +		 * empty fence would block until the fault's CTXSW_TIMEOUT.
> +		 */
> +		if (migrated)
> +			nouveau_fence_new(&fence, drm->dmem->migrate.chan);

[Severity: High]
How is access to drm->dmem->migrate.chan synchronized in
nouveau_dmem_migrate_fault() in drivers/gpu/drm/nouveau/nouveau_dmem.c?

Here, nouveau_dmem_migrate_alloc_and_copy() (which calls
nvc0b5_migrate_copy() and nvc0b5_migrate_clear() to push multi-word DMA
commands via PUSH_WAIT(push, ...) on drm->dmem->migrate.chan->chan.push) and
nouveau_fence_new(&fence, drm->dmem->migrate.chan) run while holding only
mmap_read_lock(mm).

Because drm->dmem->migrate.chan aliases drm->ttm.chan (set up in
nouveau_dmem_migrate_init()), can this race with concurrent CPU faults in
nouveau_dmem_migrate_to_ram() (which pushes copy commands under svmm->mutex
and calls nouveau_fence_new() outside svmm->mutex) or concurrent TTM buffer
moves in nouveau_bo_move_m2mf() in drivers/gpu/drm/nouveau/nouveau_bo.c
(which serializes using cli->mutex), corrupting the shared channel pushbuff=
er
or racing on ++fctx->sequence?

> +		migrate_vma_pages(&migrate);
> +
> +		/*
> +		 * The fault-in path must replay the faulting channel before waiting on
> +		 * the copy fence: with the fault still unreplayed the copy does not
> +		 * make progress. GPU has no mapping so it might refault, until it
> +		 * gets the migrated or mirrored mapping.
> +		 */
> +		if (drm->svm && migrated)
> +			nouveau_svm_fault_replay(drm->svm);
> +
> +		if (migrated)
> +			fret =3D nouveau_dmem_fence_poll(&fence);
> +
> +		mutex_lock(&svmm->mutex);
> +		if (fret) {
> +			/* Copy did not complete; don't map a half-copied page. */
> +			ret =3D -EIO;

[Severity: Critical]
If nouveau_dmem_fence_poll(&fence) times out and returns -EBUSY here in
nouveau_dmem_migrate_fault() (or above in nouveau_dmem_migrate_to_ram()) in
drivers/gpu/drm/nouveau/nouveau_dmem.c, doesn't the page migration still get
committed with uncopied data while DMA may still be active?

Because migrate_vma_pages(&migrate) was already called before
nouveau_dmem_fence_poll(&fence), the folio metadata migration has already
succeeded and MIGRATE_PFN_MIGRATE remains set in migrate.src[0]. When fret =
is
non-zero:

1. dma_unmap_page() is called immediately on the source page (or destination
page in nouveau_dmem_migrate_to_ram()) even though the timed-out copy engine
DMA may still be in flight.

2. migrate_vma_finalize(&migrate) sees MIGRATE_PFN_MIGRATE still set in
migrate.src[0], so it installs a device-private swap PTE for the half-copied
VRAM page into the CPU page tables and frees the valid source system RAM
folio (or in nouveau_dmem_migrate_to_ram(), installs a present CPU PTE to
the stale system RAM page and frees the source VRAM folio).

3. In the GPU fault path, nouveau_dmem_migrate_fault() returns -EIO to
nouveau_range_fault_and_migrate(), and nouveau_svm_fault() in
drivers/gpu/drm/nouveau/nouveau_svm.c then executes:

	ret =3D nouveau_range_fault_and_migrate(svmm, svm->drm,
					      args, hmm_flags,
					      &notifier);
	if (ret)
		ret =3D nouveau_range_fault(svmm, svm->drm, args,
					  __struct_size(args),
					  hmm_flags, &notifier);

Won't nouveau_range_fault() walk the CPU page table, find the device-private
swap PTE just installed by migrate_vma_finalize(), and map that half-copied
VRAM page into the GPU anyway?

> +		} else if (mmu_interval_read_retry(notifier, range.notifier_seq)) {
> +			ret =3D -EBUSY;
> +		} else {
> +			unsigned long map_addr =3D migrate.start;
> +			unsigned int page_shift =3D PAGE_SHIFT + order;
> +
> +			/*
> +			 * If nothing migrated might still be able to mirror.
> +			 * In that case use the snapshot hmm_pfn.
> +			 * npages =3D=3D 1 always today.
> +			 */
> +			if (npages =3D=3D 1 && !(pfns[0] & NVIF_VMM_PFNMAP_V0_V))
> +				pfns[0] =3D nouveau_dmem_hmm_pfn_to_map(hmm_pfn0,
> +						start, &map_addr, &page_shift);
> +
> +			__nouveau_pfns_map_locked(svmm, map_addr, pfns, n,
> +						  page_shift);

[Severity: Critical]
Can nouveau_dmem_migrate_fault() in drivers/gpu/drm/nouveau/nouveau_dmem.c
map a VRAM page into the GPU that migrate_vma_pages() rejected and that
migrate_vma_finalize() is about to free?

Before migrate_vma_pages(&migrate) is called,
nouveau_dmem_migrate_alloc_and_copy() -> nouveau_dmem_migrate_copy_one()
allocates a destination VRAM page dpage for any entry with
MIGRATE_PFN_MIGRATE set and populates pfns[0]:

	*pfn =3D NVIF_VMM_PFNMAP_V0_V | NVIF_VMM_PFNMAP_V0_VRAM |
		((paddr >> PAGE_SHIFT) << NVIF_VMM_PFNMAP_V0_ADDR_SHIFT);

Next, migrate_vma_pages(&migrate) calls __migrate_device_pages() in
mm/migrate_device.c. If migration of the folio is rejected or fails =E2=80=
=94 which
happens for all present file-backed or shared/shmem pages (collected by
hmm_vma_handle_migrate_prepare(), then rejected by __migrate_device_pages()
at !folio_test_anon(folio)), or when folio_free_swap() or
folio_migrate_mapping() fails with -EAGAIN due to extra references =E2=80=94
__migrate_device_pages() aborts the migration by clearing MIGRATE_PFN_MIGRA=
TE
in migrate.src[0].

However, pfns[0] still has NVIF_VMM_PFNMAP_V0_V set from
nouveau_dmem_migrate_copy_one(). Because nouveau_dmem_migrate_fault() checks
!(pfns[0] & NVIF_VMM_PFNMAP_V0_V) without checking whether
migrate.src[0] & MIGRATE_PFN_MIGRATE is still set after migrate_vma_pages():

1. The in-place mirror fallback is skipped.
2. __nouveau_pfns_map_locked() maps the aborted VRAM page dpage into the GPU
VMM.
3. Immediately below, migrate_vma_finalize(&migrate) sees
!(migrate.src[0] & MIGRATE_PFN_MIGRATE), restores the CPU PTE to the origin=
al
system RAM folio, and calls folio_put(dst) on dpage, freeing it back to
dmem->free_pages via nouveau_dmem_folio_free() while the GPU retains a live
mapping to it.

Should nouveau_dmem_migrate_fault() check migrate.src[i] & MIGRATE_PFN_MIGR=
ATE
after migrate_vma_pages(&migrate) and clear pfns[i] when migration did not
succeed?

> +
> +			*out_pfn0 =3D pfns[0];
> +			*out_addr =3D map_addr;
> +			*out_shift =3D page_shift;
> +		}
> +		mutex_unlock(&svmm->mutex);
> +
> +		if (fret)
> +			NV_ERROR(drm,
> +				 "svm: migrate copy did not complete (%d) for %lx-%lx\n",
> +				 fret, start, end);
> +
> +		while (nr_dma--) {
> +			dma_unmap_page(drm->dev->dev, dma_info[nr_dma].dma_addr,
> +				       dma_info[nr_dma].size, DMA_BIDIRECTIONAL);
> +		}
> +		migrate_vma_finalize(&migrate);
> +unlock:
> +		mmap_read_unlock(mm);
> +	} while (ret =3D=3D -EBUSY && !time_after(jiffies, timeout));
> +
> +	/* Nothing migrated or mappable in place, fallback to nouveau_range_fau=
lt(). */
> +	if (!ret && !(pfns[0] & NVIF_VMM_PFNMAP_V0_V))
> +		ret =3D -ENOENT;

[Severity: High]
Why is __nouveau_pfns_map_locked() called before checking whether
pfns[0] & NVIF_VMM_PFNMAP_V0_V is set in nouveau_dmem_migrate_fault() in
drivers/gpu/drm/nouveau/nouveau_dmem.c?

hmm_range_fault(&range) can return 0 while hmm_pfn0 does not have
HMM_PFN_VALID set =E2=80=94 for example:
- when faulting on a PMD-mapped THP or PTE-mapped large folio where
folio_trylock() or folio splitting fails in
hmm_vma_handle_migrate_prepare_pmd() or hmm_vma_walk_pmd() in mm/hmm.c
(setting HMM_PFN_ERROR and returning 0),
- when faulting on the huge zero folio in
hmm_vma_handle_migrate_prepare_pmd(), or
- on a read fault to the shared zero page where
hmm_vma_handle_migrate_prepare() sets *hmm_pfn =3D HMM_PFN_MIGRATE (without
HMM_PFN_VALID) and VRAM allocation in nouveau_dmem_migrate_copy_one() fails.

In those cases, nothing is migrated (pfns[0] is NVIF_VMM_PFNMAP_V0_NONE) and
nouveau_dmem_hmm_pfn_to_map(hmm_pfn0, ...) also returns
NVIF_VMM_PFNMAP_V0_NONE with page_shift =3D PAGE_SHIFT. Calling
__nouveau_pfns_map_locked() with pfns[0] =3D=3D NVIF_VMM_PFNMAP_V0_NONE inv=
okes
nvkm_vmm_pfn_map() in drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c with
map =3D=3D false at 4KB granularity. If the faulting address was already ma=
pped
in the GPU VMM (for instance, mapped read-only prior to a write fault),
nvkm_vmm_pfn_map() splits the GPU VMA and unmaps the 4KB range; and if the
existing GPU VMM mapping was a 2MB page (vma->refd at shift 21 with no 4KB
page table allocated), walking down to shift 12 with ref =3D=3D false in
nvkm_vmm_iter() leaves it.pt[0] =3D=3D NULL and dereferences it in
nvkm_vmm_unref_ptes().

Should __nouveau_pfns_map_locked() only be called when
pfns[0] & NVIF_VMM_PFNMAP_V0_V is set?

> +
> +	nouveau_pfns_free(pfns);
> +out_free_dma:
> +	kfree(dma_info);
> +out_free_dst:
> +	kfree(migrate.dst);
> +out_free_src:
> +	kfree(migrate.src);
> +	return ret;
> +}
[ ... ]
> diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouv=
eau/nouveau_svm.c
> index 58735446d7832..83ea480abcf58 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_svm.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_svm.c
[ ... ]
> @@ -78,6 +79,13 @@ struct nouveau_svm {
>  #define SVM_DBG(s,f,a...) NV_DEBUG((s)->drm, "svm: "f"\n", ##a)
>  #define SVM_ERR(s,f,a...) NV_WARN((s)->drm, "svm: "f"\n", ##a)
> =20
> +/* When set, migrate the faulting range to VRAM on GPU fault (default of=
f). */
> +static bool nouveau_svm_migrate_on_fault;
> +module_param_named(svm_migrate_on_fault, nouveau_svm_migrate_on_fault, b=
ool,
> +		   0644);
> +MODULE_PARM_DESC(svm_migrate_on_fault,
> +		 "migrate system memory to VRAM on GPU fault (default off)");

[Severity: Low]
This adds the nouveau.svm_migrate_on_fault module/boot parameter in
drivers/gpu/drm/nouveau/nouveau_svm.c. Should this parameter also be
documented in Documentation/admin-guide/kernel-parameters.txt?

[ ... ]
> @@ -514,6 +523,14 @@ static bool nouveau_svm_range_invalidate(struct mmu_=
interval_notifier *mni,
>  	    range->owner =3D=3D sn->svmm->vmm->cli->drm->dev)
>  		return true;
> =20
> +	/*
> +	 * Ignore our own migrate-on-fault invalidation; otherwise its
> +	 * MMU_NOTIFY_MIGRATE bumps the seq and read_retry() spins to timeout.
> +	 */
> +	if (range->event =3D=3D MMU_NOTIFY_MIGRATE &&
> +	    range->owner =3D=3D sn->svmm->vmm->cli->drm->dev)
> +		return true;

[Severity: Critical]
Doesn't ignoring all MMU_NOTIFY_MIGRATE events with
range->owner =3D=3D sn->svmm->vmm->cli->drm->dev in
nouveau_svm_range_invalidate() in drivers/gpu/drm/nouveau/nouveau_svm.c also
ignore concurrent migrations triggered by other paths on the same device,
allowing freed VRAM or system RAM pages to be mapped into the GPU VMM?

drm->dev is also passed as pgmap_owner in nouveau_dmem_migrate_to_ram() (on
CPU page faults migrating device-private VRAM pages back to system RAM) and
in nouveau_dmem_migrate_vma() (on nouveau_svmm_bind() migrating system RAM =
to
VRAM).

Consider two races:

1. A page is currently in device-private VRAM. The GPU faults on it (either
via nouveau_range_fault() when svm_migrate_on_fault is off or on
FAULT_ACCESS_PREFETCH, or via nouveau_dmem_migrate_fault() which only sets
MIGRATE_VMA_SELECT_SYSTEM so hmm_vma_handle_migrate_prepare() skips the
device-private page without locking or referencing it). HMM records the VRAM
page into range.hmm_pfns[0] / hmm_pfn0. Concurrently under shared
mmap_read_lock(mm), a CPU fault on the same address runs
nouveau_dmem_migrate_to_ram(). Its migrate_vma_setup() emits
MMU_NOTIFY_MIGRATE with owner =3D=3D drm->dev, which
nouveau_svm_range_invalidate() now ignores without taking svmm->mutex or
calling mmu_interval_set_seq(). nouveau_dmem_migrate_to_ram() invalidates t=
he
GPU VMM under svmm->mutex, copies the page to RAM, and frees the VRAM folio
in migrate_vma_finalize(). The GPU fault worker then takes svmm->mutex, sees
mmu_interval_read_retry() =3D=3D false because invalidate_seq was never bum=
ped,
and maps the freed VRAM page into the GPU VMM.

2. In nouveau_range_fault(), after hmm_range_fault_unlocked_timeout() reads=
 a
system RAM PFN and drops mmap_read_lock(mm), a concurrent
nouveau_dmem_migrate_vma() or nouveau_dmem_migrate_fault() unmaps the
single-mapped PTE in hmm_vma_handle_migrate_prepare() while emitting only
MMU_NOTIFY_MIGRATE with owner =3D=3D drm->dev, migrates the page to VRAM, a=
nd
frees the system RAM folio. Because nouveau_svm_range_invalidate() ignored
that MMU_NOTIFY_MIGRATE event, nouveau_range_fault() sees
mmu_interval_read_retry() =3D=3D false and maps the freed system RAM page i=
nto
the GPU VMM.

[ ... ]
> @@ -922,21 +965,29 @@ nouveau_pfns_free(u64 *pfns)
>  }
> =20
>  void
> -nouveau_pfns_map(struct nouveau_svmm *svmm, struct mm_struct *mm,
> -		 unsigned long addr, u64 *pfns, unsigned long npages,
> -		 unsigned int page_shift)
> +__nouveau_pfns_map_locked(struct nouveau_svmm *svmm, unsigned long addr,
> +			  u64 *pfns, unsigned long npages,
> +			  unsigned int page_shift)
>  {
>  	struct nouveau_pfnmap_args *args =3D nouveau_pfns_to_args(pfns);
> =20
> +	lockdep_assert_held(&svmm->mutex);
> +
>  	args->p.addr =3D addr;
>  	args->p.size =3D npages << page_shift;
>  	args->p.page =3D page_shift;
> =20
> -	mutex_lock(&svmm->mutex);
> -
>  	nvif_object_ioctl(&svmm->vmm->vmm.object, args,
>  			  struct_size(args, p.phys, npages), NULL);
> +}

[Severity: Medium]
Should __nouveau_pfns_map_locked() in drivers/gpu/drm/nouveau/nouveau_svm.c
propagate the return value of nvif_object_ioctl() to
nouveau_dmem_migrate_fault()?

In nouveau_range_fault() and nouveau_atomic_range_fault(), the return value
of nvif_object_ioctl() is returned to nouveau_svm_fault() so that failed
mappings trigger nouveau_svm_fault_cancel_fault().

In contrast, __nouveau_pfns_map_locked() discards the return value of
nvif_object_ioctl(), and nouveau_dmem_migrate_fault() only checks
!(pfns[0] & NVIF_VMM_PFNMAP_V0_V). If nvkm_vmm_pfn_map() in
drivers/gpu/drm/nouveau/nvkm/subdev/mmu/vmm.c returns early with -EINVAL (f=
or
example, when hmm_pfn_to_map_order() returns an order such as a 1GiB PUD or
64KiB hugetlb page that the GPU VMM page table descriptor does not support)
or -ENOENT (when the address is not in a managed GPU VMA), nvkm_vmm_pfn_map=
()
returns before the loop that clears NVKM_VMM_PFN_V in pfns[0]. Won't
nouveau_dmem_migrate_fault() then falsely return 0, causing
nouveau_svm_fault() to replay the unhandled GPU fault in an infinite fault
loop instead of cancelling it?

> =20
> +void
> +nouveau_pfns_map(struct nouveau_svmm *svmm, struct mm_struct *mm,
> +		 unsigned long addr, u64 *pfns, unsigned long npages,
> +		 unsigned int page_shift)
> +{
> +	mutex_lock(&svmm->mutex);
> +	__nouveau_pfns_map_locked(svmm, addr, pfns, npages, page_shift);
>  	mutex_unlock(&svmm->mutex);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021060506.2377=
545-1-mpenttil@redhat.com?part=3D12

