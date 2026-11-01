Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AA53F606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 07:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=O7YmzRxr
Received: by kanga.kvack.org (Postfix)
	id D09776B05B2; Sun,  1 Nov 2026 02:35:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C930E6B05B3; Sun,  1 Nov 2026 02:35:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81D76B05B4; Sun,  1 Nov 2026 02:35:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6226B05B2
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 02:35:58 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D6868409EA
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:29:19 +0000 (UTC)
X-FDA: 85385724438.08.CEB33E0
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 22E0E140004
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 07:29:17 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O7YmzRxr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793518158;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QmalFTzk8PC4gVYAeFfovnjepN+ajuf1Nd4Y1xSkE4M=;
	b=JfY4LwvLzPRTohCa9k37u+D3frv5hkfIDkCzeW6HLoxAjd1J8I+OVU77am5EcUUANf3Rz+
	pBZzE1HDzG58A0UoGfmwvGpMydJ1+L9JbEFelud/9Lz7Vy3VwuIEOS7HTbVuuhjwJtHW8z
	5Yls39PrB0u34eY0tjkUmu+dLD+KgfY=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O7YmzRxr;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793518158;
	b=zsAlbze2zZgw9menl3GWsV4eGGLtsF3xtwKtJGL+Ug6OJQKgBAt+LcNdlOFX/VztnW78RL
	VmAdNnAZbnNJGzsVqr7xsKd1hXfjo7WorRsn0pob3cSiImldvtJtkTwe67ru96w0I6XJWg
	M0fybPC6ip0gaxzdpB6z+wwJo5xTn+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id E3B3743AD7;
	Sun,  1 Nov 2026 07:29:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D6B01F000C1;
	Sun,  1 Nov 2026 07:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793518155;
	bh=QmalFTzk8PC4gVYAeFfovnjepN+ajuf1Nd4Y1xSkE4M=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=O7YmzRxrLbjTpMT1FEqoCHCe31YZmF0Eok7kU6tCrqzr4x6Y+aK76GhC/tOzSzRtf
	 /aPOxiklaBQyp2eQQpxHjD2VcApMA7UinD+VsngnJTtFe6PHYySvKabGrUlxstZhR1
	 5M6gytN3t94qjQFDzmiL+8/+CYKPqmoqn54S/8aFVNUIlpSVMB2jEueQPYWW5q5gQU
	 BpjgBoztdlYROZIcb+jNsCszhWlxA9x2+exbL0d80sC2d1Uuz3MovKAVrhHemyySkP
	 xW9RoePoovA7cCByUWyjZeCt9RfssAn+Iq7TZQsBGHEGx3AP78KTcJcbsw3E0/UYDG
	 XeybIIC8Rjsmg==
Message-ID: <sashiko-outbox-192310@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] mm/hmm: honor write requests for owned device-private
 pages
Reply-To: sashiko-reviews@lists.linux.dev
To: "Aveline Noir" <jm5905938@gmail.com>, "Jason Gunthorpe" <jgg@ziepe.ca>, "Andrew
 Morton" <akpm@linux-foundation.org>
Cc: "Francois Dugast" <francois.dugast@intel.com>, "Christoph Hellwig" <hch@lst.de>, "Leon
 Romanovsky" <leon@kernel.org>, linux-mm@kvack.org
In-Reply-To: <179343062238.2.2773026701442863377@gmail.com>
References: <179343062238.2.2773026701442863377@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 01 Nov 2026 07:29:15 +0000
X-Rspamd-Queue-Id: 22E0E140004
X-Rspam-User: 
X-Stat-Signature: ixtcuwck7nmzfra66bb6rfncjnaitg1o
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793518157-800669
X-HE-Meta: U2FsdGVkX19X6+aBBVovpX5UO9mTB1RPdvWzi3Z1B2AJuD7RXxm878LEfp6X0aU8T0/qo2onqb11L+KJEEvKq5UKViu9oJh54iq1rij2ro6QQbShp2u719PjPInm80ZlEXDIV5s+E2UCTusC2Uxsb+0TpdAlOcVnwTiYwFT3v9wLQOQAa1hitp0XQT2+ZF8OeG7LYWWsVZYkTRc734mVKDsifAmb+CP3EFG4/Xd66h32BdujTYpo+r4d+Y7plfkbepINgFVqzxwyGMzWo4HSJEq2fz93XuT+giOPqi/5zSM6n3Ly5asBUOtEen9PARvNauNM1NIOireAqVnCaAeKvxMwAAjN5fZh5iKWQHJIj84yhs180V42FdM3aKGFYMNphivJ6EenewuEEfryqOKv3ZXagA4EZvcqiKh5CZTCeKxII6PcqAxS4ywrdzt+thPtVJtNaD4hdqpUUSCzlawcSXOywkMT3TBa1inJJhsgS6ZqEyYZYcT/hpN5qct7bZtE6DD8Ogd+HeEK6I+I2TIgVIHRHzYrnYiEw9WeZeFVe/Kt5tqk3RQNynokhPP63LX9fEM5sNm4zn3kboVq+VOljFAdVUdGBvq+lE7aumarxNzeNXH4QGllGIRcwN+qbChpjYI8vumzVE6RgWTkbVPWTVcd4/NfN0FF56jHgcU3u826WWe6dMkxWYBSFKyewJ0Pj2gURSs2xiVppLhc3InY9VN+J3lw3+3eAm3sbk23+Nj0z5Jolex8j9WWI+cDq4D5Z+azCnfCD8/jAjiLIaw6gaoABcrr/KR4f6TX/0ltpYf95SrYkc50kM0qBLHwmRtIsrZp8GlCZv9wFSk0CoXk5UzaduPF90hU6gb7dwZlUNyjRTbaPvgUAsl+NsCODNLKrobtiLD30MTY2Etr+VqHzhz5B4ahIcRg6XQ6oNr4+7q9bal/f05vpLUKVRJLtxvM3H8FB2ZTH+SzyuUBwK6
 ZIybNpnz
 yNIzZ3FCzw5W5gKMlb/DP7uPIyDXICd39yeu62k56agc+8Wz0KI/EloN7T9aws5+bVrlAcZ1xXQGlGdw2aLHiR17fI8oIFGlHWW0uYQMnRIS94BM4GH7RDyNWQGqua6xNqdtMae1AVGfKpaD6auIkUDPksYP5q2xhSaOx97SRt2WYboPV5X4YHCkmiPluLsjDbgBpbfHnvLZFP0cNVPQCcipI8dxfa3BQGR1H4RIIyETJ8OpEQIoQCFD7y8b4lOKusqWL7IIcHJi7EOjlKXo5RSkrk7DC5xfD4drII7FTeqO3xz8uyWnxAqFDaMc54uH73bMTMiVPORGQLS/MkpJShNHEkrTeL5TlrKvGDS+4Gst33gNwHDLee9BcJzUUurE6iZV7qW4Q9vn4YtMBG839KkVHO4X8Jf+5+MvALoo/4i9QOT4ksb1tTlUNi4OfnX7BwPpSqcW9MWiPUdo0nCAucjLeEYDeRFSJmaTE7rkAwD+81s241AU5QNz3imtoBP2v4ZDJpMiiKC34sQsU61uwDZbaclCrdXKAaYM2rl1f3mQdwn9mwVRavsX09OnIs1PBFCwLvW0mtCtgTy7F1/URIWWsPA==
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
- [High] mm/hmm: infinite fault loop in hmm_range_fault_locked() with amdkf=
d SVM
--

commit 1f96e5c5d80c40ba632786bdf9197a9a37329854
Author: Aveline Noir <jm5905938@gmail.com>

mm/hmm: honor write requests for owned device-private pages

This commit updates hmm_vma_handle_pte() and hmm_vma_handle_absent_pmd() to
check read-only, owner-matching device-private entries for write faults when
HMM_PFN_REQ_WRITE is requested, rather than returning their PFNs directly.

> diff --git a/mm/hmm.c b/mm/hmm.c
> index 2f1e98c6b6440..92957541ba95c 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -268,15 +268,22 @@ static int hmm_vma_handle_pte(struct mm_walk *walk,=
 unsigned long addr,
>  		const softleaf_t entry =3D softleaf_from_pte(pte);
> =20
>  		/*
> -		 * Don't fault in device private pages owned by the caller,
> -		 * just report the PFN.
> +		 * Don't fault in device private pages owned by the caller unless
> +		 * a write fault is required.
>  		 */
>  		if (softleaf_is_device_private(entry) &&
>  		    page_pgmap(softleaf_to_page(entry))->owner =3D=3D
>  		    range->dev_private_owner) {
>  			cpu_flags =3D HMM_PFN_VALID;
> -			if (softleaf_is_device_private_write(entry))
> +			if (softleaf_is_device_private_write(entry)) {
>  				cpu_flags |=3D HMM_PFN_WRITE;
> +			} else {
> +				required_fault =3D
> +					hmm_pte_need_fault(hmm_vma_walk, pfn_req_flags,
> +							   cpu_flags);
> +				if (required_fault)
> +					goto fault;
> +			}
>  			new_pfn_flags =3D softleaf_to_pfn(entry) | cpu_flags;
>  			goto out;
>  		}
> @@ -358,8 +365,15 @@ static int hmm_vma_handle_absent_pmd(struct mm_walk =
*walk, unsigned long start,
>  		unsigned long pfn =3D softleaf_to_pfn(entry);
>  		unsigned long i;
> =20
> -		if (softleaf_is_device_private_write(entry))
> +		if (softleaf_is_device_private_write(entry)) {
>  			cpu_flags |=3D HMM_PFN_WRITE;
> +		} else if ((range->default_flags | range->pfn_flags_mask) &
> +			   HMM_PFN_REQ_WRITE) {
> +			required_fault =3D hmm_range_need_fault(hmm_vma_walk,
> +							      hmm_pfns, npages, cpu_flags);
> +			if (required_fault)
> +				return hmm_record_fault(addr, end, required_fault, walk);
> +		}

[Severity: High]
Can triggering a fault on an owner-matching SOFTLEAF_DEVICE_PRIVATE_READ
entry in hmm_vma_handle_pte() or hmm_vma_handle_absent_pmd() cause an
infinite loop in hmm_range_fault_locked() when used with amdkfd SVM?

An anonymous VM_WRITE VMA can contain an owner-matching read-only
device-private entry (SOFTLEAF_DEVICE_PRIVATE_READ) either after fork() via
copy_nonpresent_pte(), or when svm_migrate_vma_to_vram() migrates a present
read-only PTE (!pte_write(pte), such as a read-faulted anonymous page) to
VRAM via migrate_vma_collect_pmd() and remove_migration_pte().

When validating and mapping an SVM range in a VM_WRITE VMA, amdkfd calls
hmm_range_fault() with default_flags =3D HMM_PFN_REQ_FAULT | HMM_PFN_REQ_WR=
ITE
and dev_private_owner set to the GPU owner while p->svms.faulting_task is s=
et
to current:

drivers/gpu/drm/amd/amdkfd/kfd_svm.c:svm_range_validate_and_map() {
    ...
			WRITE_ONCE(p->svms.faulting_task, current);
			range =3D amdgpu_hmm_range_alloc(NULL);
			if (likely(range))
				r =3D amdgpu_hmm_range_get_pages(&prange->notifier, addr, npages,
							       readonly, owner, range);
			else
				r =3D -ENOMEM;
			WRITE_ONCE(p->svms.faulting_task, NULL);
    ...
}

With this change, hmm_vma_handle_pte() and hmm_vma_handle_absent_pmd() see
HMM_PFN_REQ_WRITE without HMM_PFN_WRITE on the owner-matching read-only
device-private entry and return HMM_FAULT_PENDING at addr.

In mm/hmm.c, hmm_range_fault_locked() then invokes:

  hmm_do_fault()
    -> handle_mm_fault()
      -> do_swap_page()
        -> pgmap->ops->migrate_to_ram() (svm_migrate_to_ram())

In drivers/gpu/drm/amd/amdkfd/kfd_migrate.c, svm_migrate_to_ram() checks
p->svms.faulting_task to avoid deadlocking on svms.lock and
prange->migrate_mutex:

	if (READ_ONCE(p->svms.faulting_task) =3D=3D current) {
		pr_debug("skipping ram migration\n");
		r =3D 0;
		goto out_unref_process;
	}

Because svm_migrate_to_ram() returns 0 without migrating the page to RAM,
modifying the PTE, or firing an MMU notifier, hmm_do_fault() returns -EBUSY:

mm/hmm.c:hmm_range_fault_locked() {
	do {
		/* If range is no longer valid force retry. */
		if (mmu_interval_check_retry(range->notifier,
					     range->notifier_seq))
			return -EBUSY;
		ret =3D walk_page_range(mm, hmm_vma_walk.last, range->end,
				      &hmm_walk_ops, &hmm_vma_walk);
		if (ret =3D=3D HMM_FAULT_PENDING) {
			ret =3D hmm_do_fault(mm, &hmm_vma_walk);
			if (ret =3D=3D HMM_FAULT_UNLOCKED) {
				if (fatal_signal_pending(current))
					return -EINTR;
				return -EBUSY;
			}
		}
	} while (ret =3D=3D -EBUSY);
}

Since no MMU notifier fired, mmu_interval_check_retry() returns false and
walk_page_range() restarts at the same hmm_vma_walk.last address. Won't this
spin forever on the unchanged SOFTLEAF_DEVICE_PRIVATE_READ entry while
holding mmap_read_lock(mm) (or mmap_write_lock(mm)), svms.lock, and
prange->migrate_mutex?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/179343062238.2.2773=
026701442863377@gmail.com?part=3D1

