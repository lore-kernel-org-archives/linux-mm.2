Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99029606A31B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 06:18:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DZ58PL73
Received: by kanga.kvack.org (Postfix)
	id AEC0D6B05B1; Wed,  4 Nov 2026 01:18:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A9D7E6B05B2; Wed,  4 Nov 2026 01:18:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D306B05B3; Wed,  4 Nov 2026 01:18:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 71EA76B05B1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 01:18:01 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB38D16065F
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:18:00 +0000 (UTC)
X-FDA: 85396431120.15.8CC8132
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 3EB01180003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:17:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DZ58PL73;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793773078;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=znPXUcU3GFuKNEDHJd6W8vrioLqNoIpEWQ5zMXUyPmg=;
	b=DyVqwe7ot1rJuZ4Rh1dwtJxNpvVMSB0HIRNSYHVVYOeKIsGLyaU+wcBzPqUN2Qnr2g02Eu
	vDKLH1MpUOAj6J7jxic7hXEkha5NouzenIBPg8apN693VfaY14S+HG9hBpcXQl6Era3ktA
	PIubaqr7Gor7IPc7MWQM9Bi7mmmpbYY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793773078;
	b=5EjZkspDm0VMfvpAwYC1EJpTx5+prft6JPx+V06e4cXez/4DJKA+Y+Ief/poL0uJXDR2hV
	It185kW67XFT4f9guRMvtoUStQY39vOSUe4NN9yjP38UGofW2zuaur+wr/UAAJEmNV4DfN
	6/0c3JqS6pFi7tPsnLTpqTtVNlhnm7o=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=DZ58PL73;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7337F43CBF;
	Wed,  4 Nov 2026 06:17:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 646951F000C1;
	Wed,  4 Nov 2026 06:17:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793773077;
	bh=znPXUcU3GFuKNEDHJd6W8vrioLqNoIpEWQ5zMXUyPmg=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DZ58PL73lPr2V9GZqko0d9q9WdpjxCbkSWBsXZw+QoAeHHuPQBTFS6lpsW7qVtg2P
	 JMzJ+qJli58evfxK+fIHHpIxAXyJfcaJrEqXPCm83z44+3l4uqlczfjxH0vD+Q7F4x
	 yBAcIEfTxqqK+aXqCIY5RlBV06DcziIQSnFCAugRyFmkiC6MDrGgWg+fmx3MxUltKE
	 261M5XMYDtz2OHvvBLexbi7yEGg6Q5pDq1GByfSCMp3VakvpYQvt5CuHN8VJxfoNGr
	 m3iXKZ2OYscXvXXRWEetsCi9KJH/MZeJYPUva3gJnAeTE6CBaf41JtZz9Exnl/DnGd
	 VDxRFYDJD+iCA==
Message-ID: <sashiko-outbox-196741@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v17 03/12] mm/hmm: preparations for HMM to participate
 in migration
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
In-Reply-To: <20261103061629.972669-4-mpenttil@redhat.com>
References: <20261103061629.972669-1-mpenttil@redhat.com>
 <20261103061629.972669-4-mpenttil@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 04 Nov 2026 06:17:55 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: khajygfdm5j3m6r3gpi77wzcmj9mdobs
X-Rspamd-Queue-Id: 3EB01180003
X-Rspam-User: 
X-HE-Tag: 1793773078-475868
X-HE-Meta: U2FsdGVkX19l+bTa5n9H6LxRtIveynPCYqPr0/2wppg7aVMweKWP6fwMGlXOeFR78BvRuz27F3+orIW5msYCliCoaEJJ7sJmxUdk/1ZTMdG40PV+OG1r8TeaVth2Niux8ic89RO3EWO0xeWy7JyoJRgBcK3/asqJbgdfRdyHO5JFZ/iZnQlLpaPiK2ne495IHP7Wja7Ix3ApI3QghJPUP9MIzy7N/AFvKrm0hasJ7l2Nrk2B+jqVw5vuQkbHP9nXmL2Fua0obnQvbjavUOyrBPzN4azyS3G3v62VoFJGRMCOCiXNq24Xfolmc10nbyGaQQxNJwRfRDe1IrQQ8lvznriQrQDfXKPxtA37ICCW595IHWkK/CakFIoj+qd5CGy8VD+fvaih+0Exw5k7kxpNIblvLkUzXmiW+ovKaMt2e1A8LnaNI+yBkyjRHo+Gxu1YTSMQA5mPnJQ/SzkJx9+IgVTQEUAgJghlsK4q5Zv1NwOJ+usDdks3isyu/p08/CPWyXuggGgeBEf+/9StDeEXITtPAQjaG2gdCNXalJYMOXr0k4MNJcYec5zBAU3lbHIp9KmUAsuD7oKqDb2phihmSdvLpveReBbNLAGPsTqw1BFzuKD8ZeqBnJLrxr7GXi4/yu4ajh2Xc+9gfVZp3O7KH3kvqO+B7FkTRNGrrf/2Bpwn8MLy59V9EQFcfSNOQWBCUhdQJOF2i8njND1rUbyIMow6nAQWr25zCccBxW3WXu9ElBRxmq7Fg1s2B6+1Ni8Ld15dCNRCLOEUS9BOI2mPbI7MeJNJADz3H8ePkfSu2GDsIUCxq2TwvteMmrzeyJs+DUp6GEt2p0xNb1L3IZZIpQezMT7woUrZO4gqKAFpRsM9S+BRIsUNeFbb9RQtm28FpZ07OodL2MYpuoHIiuPCXRXScwtjmfHXNcsu50aW4xnbDjuLruT7bM2FnZD5VPLYg/PIqKyFWV87La+Dl3/
 1rO2zIkk
 XBy304Q8XjeiaLy9I868meqifL+S6xdA/hYUgGGu24rDqYjo18p24RqPWd2NafgnVItarrPdg/iLXhnRQAW8UeajRlaUotze6U7BmSX+tEe3lE6IT+ArWbexMS06Bq6A/J+OhaXVral+ed3w2L9hNHeFHpAt7ZEkPDHzbMn5m3YczuRBU/xcS7HmI1A7+XTcpp4VHwGDw7ufAeXt2m8fQ76OVFmQrnWW28PwRkpRN2qiL6YDC9jdk6w0r6+lTMzemp7q5k6ry6a26JJNUROuGmdvN2oq4wkxPkeBJxx8vXQ9z0xekpDEe/tACc8hMP4Y75Ca1cgemmX1vYEdRxdvOnornCebFkuMGMfkZFlllGC7RiERyUEpcm6Ji8PlvJJyWslM98tiPJcj94YrZjhQ4S+C2EalTNQXJIau1/+HjDAhXR8fGKrLMTaYFzr4eOO0GuXkLLQXwrSvNzVY7A2VpMoY76IyE16tzqLug12PvUZezJhBATu9Enuqiw8c+tRNOIjwvjH9hYuYgPAOPMrXG1bs9nOsOjC3HwvC+3AlHwdm8vAT4RXA5Cf/a9LtnUrWqBmTwD3eMaedvsd9NFYsPiPb0Sw==
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
- [High] mm/hmm: memset() in hmm_range_fault_locked() wipes collected pfns =
on retry
- [Low] mm/hmm: build failure in hmm_range_fault_locked() when !CONFIG_MIGR=
ATION
--

commit 9e255c525419b859ce3c5e39d7de2c6153874013
Author: Mika Penttil=C3=A4 <mpenttil@redhat.com>

mm/hmm: preparations for HMM to participate in migration

This commit prepares hmm_range_fault() to participate in page migration by
capturing the VMA during page table walks, managing MMU_NOTIFY_MIGRATE
invalidations, and clearing range->hmm_pfns at the start of migrating
faults.

> diff --git a/mm/hmm.c b/mm/hmm.c
> index 2f1e98c6b6440..9220e6648636d 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c

[ ... ]

> @@ -694,19 +774,45 @@ static int hmm_range_fault_locked(struct hmm_range =
*range, bool *locked)
>  {
>  	struct hmm_vma_walk hmm_vma_walk =3D {
>  		.range =3D range,
> -		.locked =3D locked,
> +		.mmlocked =3D locked,
>  		.last =3D range->start,
>  	};
> -	struct mm_struct *mm =3D range->notifier->mm;
> +	/*
> +	 *  Could be serving a device fault or come from migrate
> +	 *  entry point. For the former we have not resolved the vma
> +	 *  yet, and the latter we don't have a notifier (but have a vma).
> +	 *
> +	 */
> +	struct mm_struct *mm =3D hmm_range_fault_mm(range);
>  	int ret;
> =20
> +	/* Migration is incompatible with mmap lock drop */
> +	if (locked && hmm_select_migrate(range))
> +		return -EINVAL;
> +
> +	/*
> +	 * Migration takes its requests only from default_flags, so the input
> +	 * pfns carry nothing. Clear them so that collected entries can be
> +	 * told apart reliably during the walk and on rollback.
> +	 */
> +	if (hmm_select_migrate(range)) {
> +		WARN_ON_ONCE(range->pfn_flags_mask);
> +		WARN_ON_ONCE(range->dev_private_owner !=3D
> +			     range->migrate->pgmap_owner);

[Severity: Low]
Will this break the build when CONFIG_HMM_MIRROR=3Dy and CONFIG_MIGRATION=
=3Dn?

Several Kconfig options (such as CONFIG_INFINIBAND_ON_DEMAND_PAGING and
CONFIG_DRM_AMDGPU_USERPTR) select CONFIG_HMM_MIRROR without depending on
CONFIG_MIGRATION. In include/linux/hmm.h, struct migrate_vma is only
forward-declared, and in include/linux/migrate.h, its definition is guarded
by #ifdef CONFIG_MIGRATION while a stub is provided for
hmm_select_migrate() when !CONFIG_MIGRATION.

Even though hmm_select_migrate(range) returns 0 when CONFIG_MIGRATION is
disabled, the compiler still type-checks range->migrate->pgmap_owner inside
hmm_range_fault_locked() in mm/hmm.c and fails due to dereferencing a
pointer to an incomplete type.

Should this check be moved into a helper in include/linux/migrate.h with a
matching !CONFIG_MIGRATION stub?

> +		memset(range->hmm_pfns, 0,
> +		       ((range->end - range->start) >> PAGE_SHIFT) *
> +		       sizeof(*range->hmm_pfns));
> +	}
> +
>  	mmap_assert_locked(mm);
> =20
>  	do {
>  		/* If range is no longer valid force retry. */
> -		if (mmu_interval_check_retry(range->notifier,
> -					     range->notifier_seq))
> -			return -EBUSY;
> +		if (range->notifier && mmu_interval_check_retry(range->notifier,
> +								range->notifier_seq)) {
> +			ret =3D  -EBUSY;
> +			break;
> +		}

[Severity: High]
Can unconditionally calling memset() on range->hmm_pfns in
hmm_range_fault_locked() cause a self-deadlock on the folio lock or leak
locked folios when a migrating hmm_range_fault() call is retried after
-EBUSY?

When migration is enabled in this series with range->notifier set (such as
in dmirror_range_fault() in lib/test_hmm.c), walk_page_range() collects
present pages by locking each folio, elevating its reference count,
installing a migration PTE, and marking range->hmm_pfns[i] with
HMM_PFN_VALID | HMM_PFN_MIGRATE.

If a later page in the range needs a fault, walk_page_range() returns
HMM_FAULT_PENDING, hmm_vma_migrate_disarm() closes the MMU_NOTIFY_MIGRATE
invalidation, and hmm_do_fault() calls handle_mm_fault() while the
previously collected folios stay locked by current and mapped as migration
PTEs. If handle_mm_fault() or a concurrent operation triggers an MMU
notifier invalidation, mmu_interval_check_retry() on the next loop
iteration returns true and hmm_range_fault_locked() exits with -EBUSY (or
the caller retries after mmu_interval_read_retry() fails).

When the caller retries hmm_range_fault(range) with the same
range->hmm_pfns array, the unconditional memset(range->hmm_pfns, 0, ...) at
the top of hmm_range_fault_locked() wipes the HMM_PFN_VALID |
HMM_PFN_MIGRATE markers for the folios that are still locked and installed
as migration PTEs. On the retry walk, hmm_pfn_collected() will return false
for those entries, causing hmm_vma_handle_pte() or hmm_vma_walk_pmd() to
treat current's own migration entries as another task's migration entries
and wait in migration_entry_wait() on a folio already locked by current
(or leak the locked folios and migration PTEs if the caller aborts).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261103061629.9726=
69-1-mpenttil@redhat.com?part=3D3

