Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0F88606A326
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 06:18:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O4lsASC1
Received: by kanga.kvack.org (Postfix)
	id 177776B05BB; Wed,  4 Nov 2026 01:18:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DA106B05BC; Wed,  4 Nov 2026 01:18:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E96796B05BD; Wed,  4 Nov 2026 01:18:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCFE76B05BB
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:18:11 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 420121405B5
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:18:11 +0000 (UTC)
X-FDA: 85396431582.20.6FA7462
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id ACB5AA0006
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:18:09 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4lsASC1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793773089;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pt0XVhVjyljVhnuHMdB8TolKbfhumpMz0JRl7SseDrs=;
	b=WeHpUt4s2+h4SDHfozU9lIrmgDHRcVN34d3AUbEszkCfVn8TT2Xg+qmEF0NHHuf5JZ0UOJ
	Fl484ynl6D3yRkohTC4KS5WEO2dkhMTyEBvKXG5xu4HrXnUbXJRQBzTu7j8krcP1yJ82Ks
	dsm7hP1GivbBHb13ZXZtJZL9zYxf0hA=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O4lsASC1;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793773089;
	b=YDpayCMWrmLsBHQH46XQchItay/Zwaup4Ff/Eom8ZxNZQvwignyJWsKuXgoMkezmiK15tB
	MzHnbW4+42M80x6dmm9vdfKJJSV9GfjKPy2uFZzFEIfjEYuvKvlLDnvXgD3n/4rPSP8MUO
	tWZ7E30237Xc3qr3FN4IlBe3mypaUMk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 33EBE601F6;
	Wed,  4 Nov 2026 06:18:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B6571F000C1;
	Wed,  4 Nov 2026 06:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793773088;
	bh=Pt0XVhVjyljVhnuHMdB8TolKbfhumpMz0JRl7SseDrs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O4lsASC1YJuUEb7A0nH/dE2MV+kRhvTYvbgwCXk+GMza9qmqHwSriHTKtRzH3RAYP
	 opdH6btYmWq+7u3V4gKNGPJDvhpTL9DrRQVx/37iXvgGr5pfhtQVk4EW9busVeaT3k
	 gNRCVVjHg0JGAcxIgdxK8n47sXALCjpynlEdPoxIrXu4JLA4n1rSUhHYFnL50v0DqG
	 1qiOkxLOcVxGvXYsxf0EmykpHriJiEFgjy7ahFKQra3FrQhKVCtPyTPMoUq8EBSoV3
	 LevJ9wrd/GiNeXqw+/x6pk2NJrZFcBPQpsY75XFRAydiR+LSynvaOa+CztrGriHbu+
	 XJ9mz4IBTGC3Q==
Message-ID: <sashiko-outbox-196750@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 12/12] drm/nouveau/svm: add support for migrate on
 fault
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
In-Reply-To: <20261103061629.972669-13-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <20261103061629.972669-13-mpenttil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 06:18:07 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: ACB5AA0006
X-Stat-Signature: xe6q6qffqkucgxubjrmwbozknywdteaa
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793773089-468970
X-HE-Meta: U2FsdGVkX18j/2Zm/3OiHmmahqP7OmfQDCz1jkrJyZ6foPKVsuPapXcyKoWFkUYQ7sydw/2i9Vf6TuRHeBNV+LXgM/+oKm9ZqL8qwjPkK9VxkfyVMn61Rg5ZmztW+LopJsLErzEJHiFruN6Td5p8/ff0hqx3TVrKj9pKJmVYZA3+39SoZivYOdg/uTq36YghsUo9M1RlCEvB11G727PbAMm7PoNFufBYSZSBkx3U6mko2WAsjsdq2TjBazErAkUqrn+56E9udhffYvzWilff0qprm9+ksTSyUxcBFIk3POek5K/6wJvNQbEOI/zgIMwoN2hC60DtN8mhSAiQBi++vBkgeFUVcoOulvpXURd9Ro2IMfj8FEweCtzys1x28uX2D+JL5xXVmLCN0gKfC2omsMETmifdpq7z9bgsJP26v/Idxkf+fJtMT/y4y+W5fmK+IPXurkE13tYHo+gREMv2blBOqNOPZBHzqp/OOaLt/0ygyBn8YHHr3bX/UOVEQcVrB5N7oza0hv6827OOqGyFTVJAkGncsHpTvPsXmpk5bsUgfHBwciD2XWzSkS2MvzdjJQzmmTEemfy7diacmrdB3BF4DSrga0vhyZIKIxfvamXZK1ZdP2rL4L+fUAlOvx43EqplQ+7bQ9b2Cb/euq7z0qy+nWL++WdTm/pSnpqCFCghHH6pO/mWpAiGi3R2jtRvRMG9iz5acu0LM7cTe1vIhJWM7TpBB20eqeIMF4f0+lqv8o1UtvNJq1FxbQk3ww5BGornWbCFXv9Qw9bqMTH0jXqR+brOuwcB/ZIdWiBaBDAfc3NhPi4ZWdOSGsRwkGwB6qDIPKd3Ncd6anc16VnBCBJsQ9wmdeFaRPSwdpxsZcXUIYRjRVfIBSo6NBpdswBjOk2Q+ZyL2C/fULPhwpcbIHwt9HGUMV3jMIuL/chnsFI2hymrph8ETNpkRk9RKaxdU92Fa7O4TnmXPL3AOUL
 8VvCdwY9
 ZLkuen8cBthEzFjYTivjzRhP+3z7BpCRvjEdraXPYEj8HmUBrqe+bcUGp+Rv0ZquL2pJlV1qi+rSczEFao1I37rW+ceRzEIG92D3IiV6EVnGCTWplSrPVrge35ka9D4le89yhHTMsFEqNm8R4++FoqAdy5BqAOzlPzb2PAbM9zNBZ3zHF1cqIs3hu4twOwDqWlV9lcIDwCrPvgADMR62OqRAI90ic3DhV9Pa/0lrqNf0pqpCvgF30akjtbc8zqoNqaZ0JUrXLm1O/C0byeERnGsKvzzj4rPC+CWLcT2GgsYBEWKgQ4SeT5lDb3F2Q8Z4hFgzEMrEazSe7iZm0P0cs6S90nBii/q4NKESZADAkvxb4kBGjZuyrwSB3rfav3OAnCO9dvjuEiqVTyyAfh00KENwc/lFq786ntSzc0J5WGpTp0vvjzvxTc6DXZ7HU3iMmTzcDW0TEYX+AODVwtOugtQhwuKJuqdTiAGq5tb4GurgkaFt8jQaAPrGSB+p0Pdr6uaa0FxwBlUhNdKtja3kgXCWv8GPdbr4fCRQ1LsGVziS8e6HV3K+i0Xago5dp1znITTMi3cqqKBnsETH5butjSRaUg+90uZ5EkunheUM1KgD76lQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 8 potential issue(=
s) to consider:
- [Critical] drm/nouveau/dmem: unserialized access to shared channel drm->t=
tm.chan
- [Critical] drm/nouveau/dmem: folio state corrupted after nouveau_dmem_mig=
rate_abort()
- [High] drm/nouveau/dmem: wrong folio pinned by nouveau_dmem_migrate_abort=
()
- [High] drm/nouveau: unreplayed GPU faults stall CE in nouveau_dmem_fence_=
poll()
- [High] drm/nouveau/svm: infinite GPU write fault loop in nouveau_dmem_mig=
rate_fault()
- [Medium] drm/nouveau/svm: nouveau_svmm_bind() skips migration on migrate-=
on-fault
- [Low] drm/nouveau/svm: missing kernel-parameters.txt entry for svm_migrat=
e_on_fault
- [Low] drm/nouveau: unused nouveau_dmem_fence_done() return and incomplete=
 changelog
--

commit e30e6f260301c1f7393cda9890d6f9d63fe3f96e
Author: Mika Penttil=C3=A4 <mpenttil@redhat.com>

drm/nouveau/svm: add support for migrate on fault

This commit adds migrate-on-fault support to the nouveau SVM driver using
HMM_PFN_REQ_MIGRATE and a new nouveau_dmem_migrate_fault() helper, gated by
the svm_migrate_on_fault module parameter. It also introduces a migration
channel mutex and polling fence wait with abort handling for DMEM copies.

> diff --git a/drivers/gpu/drm/nouveau/nouveau_dmem.c b/drivers/gpu/drm/nou=
veau/nouveau_dmem.c
> index e74d7bb975a86..0a5d04068321b 100644
> --- a/drivers/gpu/drm/nouveau/nouveau_dmem.c
> +++ b/drivers/gpu/drm/nouveau/nouveau_dmem.c
[ ... ]
> @@ -76,6 +79,14 @@ struct nouveau_dmem_migrate {
>  	nouveau_migrate_copy_t copy_func;
>  	nouveau_clear_page_t clear_func;
>  	struct nouveau_channel *chan;
> +	/*
> +	 * Serializes the dmem users of chan (CPU faults in migrate_to_ram(),
> +	 * migrate on fault, bulk migration, eviction): the copy and clear
> +	 * commands they write to its push buffer and the fences they emit.
> +	 * Held only around those writes, never across page allocation.
> +	 * TTM serializes its own use of the channel with cli->mutex.
> +	 */
> +	struct mutex lock;
>  };
[ ... ]
> +static int nouveau_dmem_copy(struct nouveau_drm *drm, u64 npages,
> +			     enum nouveau_aper dst_aper, u64 dst_addr,
> +			     enum nouveau_aper src_aper, u64 src_addr)
> +{
> +	int ret;
> +
> +	mutex_lock(&drm->dmem->migrate.lock);
> +	ret =3D drm->dmem->migrate.copy_func(drm, npages, dst_aper, dst_addr,
> +					   src_aper, src_addr);
> +	mutex_unlock(&drm->dmem->migrate.lock);
> +	return ret;
> +}
> +
> +static int nouveau_dmem_clear(struct nouveau_drm *drm, u32 length,
> +			      enum nouveau_aper dst_aper, u64 dst_addr)
> +{
> +	int ret;
> +
> +	mutex_lock(&drm->dmem->migrate.lock);
> +	ret =3D drm->dmem->migrate.clear_func(drm, length, dst_aper, dst_addr);
> +	mutex_unlock(&drm->dmem->migrate.lock);
> +	return ret;
> +}
> +
> +static int nouveau_dmem_fence_new(struct nouveau_drm *drm,
> +				  struct nouveau_fence **fence)
> +{
> +	int ret;
> +
> +	mutex_lock(&drm->dmem->migrate.lock);
> +	ret =3D nouveau_fence_new(fence, drm->dmem->migrate.chan);
> +	mutex_unlock(&drm->dmem->migrate.lock);
> +	return ret;
> +}

[Severity: Critical]
As reported by Sashiko on v16 [1], in drivers/gpu/drm/nouveau/nouveau_dmem.=
c,
nouveau_dmem_migrate_init() sets drm->dmem->migrate.chan =3D drm->ttm.chan,=
 so
DMEM and TTM share the same struct nouveau_channel instance:

    drm->dmem->migrate.copy_func =3D nvc0b5_migrate_copy;
    drm->dmem->migrate.clear_func =3D nvc0b5_migrate_clear;
    drm->dmem->migrate.chan =3D drm->ttm.chan;

Meanwhile, in drivers/gpu/drm/nouveau/nouveau_bo.c, nouveau_bo_move_m2mf()
uses drm->ttm.chan under cli->mutex without taking drm->dmem->migrate.lock:

    struct nouveau_channel *chan =3D drm->ttm.chan;
    struct nouveau_cli *cli =3D chan->cli;
    ...
    if (drm_drv_uses_atomic_modeset(drm->dev))
        mutex_lock(&cli->mutex);
    else
        mutex_lock_nested(&cli->mutex, SINGLE_DEPTH_NESTING);

Because nouveau_dmem_copy(), nouveau_dmem_clear(), and
nouveau_dmem_fence_new() take only drm->dmem->migrate.lock while
nouveau_bo_move_m2mf() takes only cli->mutex on the same underlying channel,
can concurrent DMEM migrations (from nouveau_dmem_migrate_fault(),
nouveau_dmem_migrate_to_ram(), nouveau_dmem_migrate_vma(), or
nouveau_dmem_evict_chunk()) and TTM buffer moves race on chan->chan.push,
interleave NVA0B5 copy engine methods in the pushbuffer, and corrupt
++fctx->sequence and fctx->pending in nouveau_fence_emit()?

> @@ -139,10 +185,12 @@ static void nouveau_dmem_folio_free(struct folio *f=
olio)
>  	spin_unlock(&dmem->lock);
>  }
> =20
> -static void nouveau_dmem_fence_done(struct nouveau_fence **fence)
> +static int nouveau_dmem_fence_done(struct nouveau_fence **fence)
>  {
> +	int ret =3D 0;
> +
>  	if (fence) {
> -		nouveau_fence_wait(*fence, true, false);
> +		ret =3D nouveau_fence_wait(*fence, true, false);
>  		nouveau_fence_unref(fence);
>  	} else {
>  		/*
> @@ -150,6 +198,54 @@ static void nouveau_dmem_fence_done(struct nouveau_f=
ence **fence)
>  		 * the hmem object.
>  		 */
>  	}
> +
> +	/* 0 on completion, -EBUSY on timeout, or other errno; propagated. */
> +	return ret;
>  }

[Severity: Low]
This isn't a bug, but nouveau_dmem_fence_done() is changed to return int
while its remaining callers in drivers/gpu/drm/nouveau/nouveau_dmem.c
(nouveau_dmem_evict_chunk() and nouveau_dmem_migrate_chunk()) ignore the
return value.

Also, the commit message only describes adding HMM_PFN_REQ_MIGRATE support,
nouveau_dmem_migrate_fault(), and the svm_migrate_on_fault parameter, witho=
ut
mentioning the addition of drm->dmem->migrate.lock or the rework of
nouveau_dmem_migrate_to_ram() to use nouveau_dmem_fence_poll() and
nouveau_dmem_migrate_abort() even when svm_migrate_on_fault is off. Could t=
he
unused return value be dropped and the changelog updated to cover these
changes?

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
> +		if (time_after(jiffies, deadline)) {
> +			ret =3D -EBUSY;
> +			break;
> +		}
> +		schedule_timeout_uninterruptible(msecs_to_jiffies(1));
> +	}
> +	nouveau_fence_unref(fence);
> +
> +	return ret;
> +}

[Severity: High]
As noted in nouveau_dmem_migrate_fault(), when a replayable GPU fault is
pending, a copy engine transfer does not make progress until
nouveau_svm_fault_replay() is issued. Can nouveau_dmem_fence_poll() stall
for 30 seconds and time out in two scenarios?

First, in nouveau_dmem_migrate_to_ram(), migrate_vma_setup() locks sfolio
and installs a migration PTE, nouveau_svmm_invalidate() unmaps the page from
the GPU, and nouveau_dmem_copy_folio() starts the copy before
nouveau_dmem_fence_poll() waits for completion. If the GPU faults on that
invalidated address while the copy is in flight, the pending GPU fault stal=
ls
the copy engine, while the fault worker in nouveau_svm_fault() blocks in
hmm_range_fault() -> migration_entry_wait() waiting for sfolio to be unlock=
ed
by migrate_vma_finalize(). Because nouveau_dmem_migrate_to_ram() never calls
nouveau_svm_fault_replay(), won't nouveau_dmem_fence_poll() stall until the
30-second timeout, leak the page in nouveau_dmem_migrate_abort(), and return
VM_FAULT_SIGBUS?

Second, in nouveau_dmem_migrate_fault(), nouveau_svm_fault_replay() is call=
ed
once before nouveau_dmem_fence_poll(), while the GPU page table entry is
still unmapped (__nouveau_pfns_map_locked() runs only after the fence compl=
etes).
If the replayed GPU access or another warp immediately refaults on the still
unmapped address before the copy finishes, won't the GPU re-enter the fault=
ed
state and stall the copy engine while the fault worker is blocked inside
nouveau_dmem_fence_poll()?

> +/*
> + * The copy could not be confirmed (fence timeout or no fence): don't mi=
grate,
> + * so finalize restores the original ptes and the source stays valid. Th=
e copy
> + * engine may still be using the pages, so keep the destination folios (=
an
> + * extra reference that finalize won't drop) and let the caller skip the=
 DMA
> + * unmap: leaking is safer than freeing memory a wedged engine might wri=
te.
> + */
> +static void nouveau_dmem_migrate_abort(struct nouveau_drm *drm,
> +				       struct migrate_vma *args)
> +{
> +	unsigned long i;
> +
> +	for (i =3D 0; i < args->npages; i++) {
> +		struct page *dpage =3D migrate_pfn_to_page(args->dst[i]);
> +
> +		args->src[i] &=3D ~MIGRATE_PFN_MIGRATE;
> +		if (dpage)
> +			folio_get(page_folio(dpage));
> +	}
> +	NV_ERROR(drm, "svm: copy not confirmed, migration aborted, pages leaked=
\n");
> +}
[ ... ]
> @@ -264,11 +361,21 @@ static vm_fault_t nouveau_dmem_migrate_to_ram(struc=
t vm_fault *vmf)
>  		goto done;
>  	}
> =20
> -	nouveau_fence_new(&fence, dmem->migrate.chan);
> +	/*
> +	 * Commit the migration only once the copy is confirmed. Without a
> +	 * fence the copy can't be confirmed: treat it as failed.
> +	 */
> +	fret =3D nouveau_dmem_fence_new(drm, &fence);
> +	if (!fret)
> +		fret =3D nouveau_dmem_fence_poll(&fence);
> +	if (fret) {
> +		nouveau_dmem_migrate_abort(drm, &args);
> +		ret =3D VM_FAULT_SIGBUS;
> +	} else {
> +		dma_unmap_page(drm->dev->dev, dma_info.dma_addr, dma_info.size,
> +			       DMA_BIDIRECTIONAL);
> +	}
>  	migrate_vma_pages(&args);
> -	nouveau_dmem_fence_done(&fence);
> -	dma_unmap_page(drm->dev->dev, dma_info.dma_addr, dma_info.size,
> -				DMA_BIDIRECTIONAL);
>  done:
>  	migrate_vma_finalize(&args);

[Severity: Critical]
As reported by Sashiko on v16 [2], when nouveau_dmem_fence_new() or
nouveau_dmem_fence_poll() fails in nouveau_dmem_migrate_to_ram() or
nouveau_dmem_migrate_fault(), nouveau_dmem_migrate_abort() clears
MIGRATE_PFN_MIGRATE in args->src[i] while leaving args->dst[i] non-zero, and
then the caller invokes migrate_vma_pages() and migrate_vma_finalize().

In mm/migrate_device.c:__migrate_device_pages(), MIGRATE_PFN_MIGRATE is only
checked in the !page branch; when both page (from src_pfns[i]) and newpage
(from dst_pfns[i]) are non-NULL, __migrate_device_pages() still executes:

    folio =3D page_folio(migrate_pfn_to_page(src_pfns[i+j]));
    newfolio =3D page_folio(migrate_pfn_to_page(dst_pfns[i+j]));
    mapping =3D folio_mapping(folio);
    r =3D folio_migrate_mapping(mapping, newfolio, folio, extra_cnt);
    if (r)
        src_pfns[i+j] &=3D ~MIGRATE_PFN_MIGRATE;
    else
        folio_migrate_flags(newfolio, folio);

This removes the source folio from the swap cache via folio_free_swap(),
migrates mapping and page flags to newfolio, and calls
mem_cgroup_migrate(folio, newfolio), which zeroes folio->memcg_data on the
source folio. Then migrate_vma_finalize() sees !(src_pfns[i] &
MIGRATE_PFN_MIGRATE) and restores the CPU PTEs to the corrupted source folio
whose memcg charge and swapcache state were already moved to the leaked
destination folio.

Should nouveau_dmem_migrate_abort() instead unlock and release/leak dst[i]
and clear args->dst[i] =3D 0 (or skip migrate_vma_pages() altogether when
aborting) so __migrate_device_pages() does not touch the source folio?

[Severity: High]
In addition, when nouveau_dmem_migrate_abort() is called from
nouveau_dmem_migrate_fault() during system-to-VRAM migration, does it pin t=
he
wrong folio?

In nouveau_dmem_migrate_fault(), migrate.src[i] is the host system RAM folio
that was DMA-mapped into dma_info by nouveau_dmem_migrate_copy_one(), where=
as
migrate.dst[i] is a device-private VRAM folio. When fret !=3D 0,
nouveau_dmem_migrate_fault() skips dma_unmap_page() on dma_info because the
copy engine may still be accessing the host DMA mapping, but
nouveau_dmem_migrate_abort() only calls folio_get() on migrate.dst[i].

Won't migrate_vma_finalize() drop the migration reference on the DMA-mapped
system RAM folio in migrate.src[i] (allowing it to be freed back to the page
allocator while still DMA-mapped), while the extra folio_get() on the
unmapped device-private folio in migrate.dst[i] prevents chunk->callocated
from ever reaching 0 and causes memunmap_pages(&chunk->pagemap) to hang on
driver teardown in nouveau_dmem_evict_chunk()?

[ ... ]
> @@ -832,6 +956,238 @@ static void nouveau_dmem_migrate_chunk(struct nouve=
au_drm *drm,
[ ... ]
> +		mutex_lock(&svmm->mutex);
> +		if (fret) {
> +			/* Copy did not complete; don't map a half-copied page. */
> +			ret =3D -EIO;
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
> +			/*
> +			 * Nothing to map: leave the GPU mapping alone, the
> +			 * caller falls back to nouveau_range_fault().
> +			 */
> +			if (pfns[0] & NVIF_VMM_PFNMAP_V0_V) {
> +				/* On failure the caller falls back, then cancels */
> +				ret =3D __nouveau_pfns_map_locked(svmm, map_addr,
> +								pfns, n,
> +								page_shift);
> +				if (!ret) {
> +					*out_pfn0 =3D pfns[0];
> +					*out_addr =3D map_addr;
> +					*out_shift =3D page_shift;
> +				}
> +			}
> +		}
> +		mutex_unlock(&svmm->mutex);

[Severity: High]
What happens in nouveau_dmem_migrate_fault() when a GPU write fault
(hmm_flags containing HMM_PFN_REQ_WRITE) hits a read-only device-private
VRAM PTE owned by drm->dev (for example, a page migrated to VRAM on an
earlier GPU read fault when the CPU PTE was read-only, or after fork() or
mprotect(PROT_READ))?

In mm/hmm.c:hmm_vma_handle_pte(), when a non-present PTE is a device-private
entry owned by range->dev_private_owner, hmm_range_fault() returns 0 with
HMM_PFN_VALID but without HMM_PFN_WRITE (because
softleaf_is_device_private_write(entry) is false) and without
HMM_PFN_MIGRATE.

Then in nouveau_dmem_migrate_fault(), nothing migrates, so it falls back to
nouveau_dmem_hmm_pfn_to_map(hmm_pfn0, ...), which encodes pfns[0] with
NVIF_VMM_PFNMAP_V0_V | NVIF_VMM_PFNMAP_V0_VRAM but without
NVIF_VMM_PFNMAP_V0_W. __nouveau_pfns_map_locked() installs a read-only GPU
PTE and returns 0, and nouveau_svm_fault() replays the fault without falling
back to nouveau_range_fault(). Won't the GPU write instruction fault again
indefinitely in an infinite fault-replay loop because write permission was
requested in hmm_flags but not granted in hmm_pfn0?

> diff --git a/drivers/gpu/drm/nouveau/nouveau_svm.c b/drivers/gpu/drm/nouv=
eau/nouveau_svm.c
> index c519c28164fa0..6e109274bd77a 100644
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
As reported by Sashiko on v16 [3], this adds the nouveau.svm_migrate_on_fau=
lt
module parameter via module_param_named() in drivers/gpu/drm/nouveau/nouvea=
u_svm.c
without an entry in Documentation/admin-guide/kernel-parameters.txt (noting
that CONFIG_DRM_NOUVEAU_SVM is marked experimental and depends on STAGING in
drivers/gpu/drm/nouveau/Kconfig). Should this parameter be documented in
Documentation/admin-guide/kernel-parameters.txt?

> @@ -182,9 +190,10 @@ nouveau_svmm_bind(struct drm_device *dev, void *data,
> =20
>  		addr =3D max(addr, vma->vm_start);
>  		next =3D min(vma->vm_end, end);
> -		/* This is a best effort so we ignore errors */
> -		nouveau_dmem_migrate_vma(cli->drm, cli->svm.svmm, vma, addr,
> -					 next);
> +		/* Best effort; skipped when migrate-on-fault does the migration. */
> +		if (!nouveau_svm_migrate_on_fault)
> +			nouveau_dmem_migrate_vma(cli->drm, cli->svm.svmm, vma,
> +						 addr, next);
>  		addr =3D next;
>  	}

[Severity: Medium]
In drivers/gpu/drm/nouveau/nouveau_svm.c, why does nouveau_svmm_bind() skip
nouveau_dmem_migrate_vma() when nouveau_svm_migrate_on_fault is enabled
(while still taking mmap_read_lock(mm) and walking the VMAs in the range)?

If pages in the bound range are already mapped to system memory in the GPU
page tables (for example from a prior FAULT_ACCESS_PREFETCH fault, an atomic
fault in nouveau_atomic_range_fault(), or an in-place fallback mapping in
nouveau_dmem_migrate_fault()), subsequent GPU accesses will not fault, so
skipping nouveau_dmem_migrate_vma() prevents explicit
DRM_IOCTL_NOUVEAU_SVM_BIND requests from ever migrating those pages to VRAM.
Furthermore, nouveau_dmem_migrate_vma() migrates compound PMD THPs with
MIGRATE_VMA_SELECT_COMPOUND, whereas deferring to nouveau_dmem_migrate_faul=
t()
faults one 4KB page at a time without MIGRATE_VMA_SELECT_COMPOUND and splits
2MB THPs. Is it intentional that enabling svm_migrate_on_fault turns the
migration ioctl into a no-op?

[1] https://lore.kernel.org/r/20261021060506.2377545-13-mpenttil@redhat.com
[2] https://lore.kernel.org/r/20261021060506.2377545-13-mpenttil@redhat.com
[3] https://lore.kernel.org/r/20261021060506.2377545-13-mpenttil@redhat.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103061629.9726=
69-1-mpenttil@redhat.com?part=3D12

