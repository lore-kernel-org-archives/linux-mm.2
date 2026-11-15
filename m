Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31A90606A31A
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 12:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=k8A4nVmI
Received: by kanga.kvack.org (Postfix)
	id 03AA06B05B0; Sun, 15 Nov 2026 07:24:05 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2CEA6B05B1; Sun, 15 Nov 2026 07:24:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E43B46B05B2; Sun, 15 Nov 2026 07:24:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BC0BB6B05B0
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 07:24:04 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24EE21606DA
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:24:04 +0000 (UTC)
X-FDA: 85437270408.17.3D9E9DC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7DA5B20002
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 12:24:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k8A4nVmI;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794745442;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NJ71py6i4waAq8tFr24Jq5kGVUA8O+SGz5SBTC+E7w8=;
	b=lgpWyasZy1SVoMkWznyDcuIzcq0lxQUJChKLIGZF0/l4IuSAsERBSiqPjD1a4VfrW7p3BE
	pMk7sCx9vU9gpKFtXEe+LixIEIgV/WZraNQ/tEkb8xnYRdOy9fcXAIT2OKezSm2FMQ7RMq
	bMtUwL4iFByDpVdEyUUWEN+WWatGdRc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794745442;
	b=gzVd3MCVxNm0cCIXK+t4GD5I5YLCyz/pRRn6p8FAK/H1hGb9lMVbODFJxlTX2Zq2HWj/zS
	ho0JYhjCqmB0CATwrGbfEW5Y1mQdn2+wjEhpFsgM4tnWoxHdhVQVrbq/iV4uyXeHWdzY+w
	4prOZOcxa0efSTa5gMEQKTVxMd+JtH4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=k8A4nVmI;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 431A7605E7;
	Sun, 15 Nov 2026 12:24:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA941F000C4;
	Sun, 15 Nov 2026 12:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794745441;
	bh=NJ71py6i4waAq8tFr24Jq5kGVUA8O+SGz5SBTC+E7w8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=k8A4nVmIqoi/NWmPd2U6byTM0cbL4NjprWGfkLWfObyXrqMlOPrnyd9MN2qnIZi7T
	 +UR+9z4YpesMhoi76B4Yr2u5UZqePcDOgCCU2BFXmYWmQ4Zr4fZk2b1UqzAv03KgTE
	 sdM/rAAym81NYGbfIqts+y85jlUJyAXXE+CNNPkEEpPP8MzmNkKLY+5+SZzyzJfo/B
	 DPndMAI9VsTgO7l1SRzjp7m0mf/BFQvpmD6dKoELyl5iIxQFdycv5GYGeMLjWISK6S
	 V/n7GouF6Y2sotIGr62b9yJ73VWHApvR5rL/Bfuv4G1ut+M8y3uo3zi/dspZTlUrLu
	 e58HmdJdqOPjQ==
Date: Sun, 15 Nov 2026 12:23:56 +0000
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: sashiko-reviews@lists.linux.dev
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>, 
	linux-mm@kvack.org, Tal Zussman <tz2294@columbia.edu>
Subject: Re: [PATCH v2] mm/madvise: zap markers from guard regions
Message-ID: <avmkGrQbxiu2_XYm@lucifer>
References: <20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org>
 <sashiko-outbox-215027@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <sashiko-outbox-215027@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: 5pypwp8atf1un3onb37irwewatuek31y
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7DA5B20002
X-Rspam-User: 
X-HE-Tag: 1794745442-374234
X-HE-Meta: U2FsdGVkX1+i8krNomOwpRr8DURioL1Nu2rku+BTMiMM66qztciDMMvQfqWURGUL6HlZTls+KFHaUPYCn+85j0w7tMJalcNa5Pjhcm2AcMXUy6ugkbhZ1R5xq6WqWhGPwtr5o2JMe2UOC+Xg+jktAn1ZS8IVU74pI+lQHg7bX1UL2FL/znNWIhswqfBFAQlO1xgwJQXmc6nq6ycDcgS+ltx0V5nG0DaJQSHC/tVW/nc3v5+gc/P8a6EUFsQ0osQOy4V/sN/twQs1i/S1gJ/07gGFVRt73LA/vVLHrmtthV0A816TDvA6a8XCeh/NH9b47uEu+mA4RJkCysG167Ny9opYymTwDgwDOp/Mnp3AOKOIjZFV58fh9nEAcHKBB6PVUuL6cZTDujqRFQ8yQcryxBSgDKw+CyOfqQNH8a6elD/QcalG1Y/fNMobJOb6nCuYN/scNTg725sqsxTp6b6Cwzpb9UaVErSoGi5n9W9LcBHtMa8BRWSVxSak2UpQRdAtmb92liQBJ2iuf+/IeuHelhlAqWIIz+rYekFZ9YissbwKIKORNNVHs90D19iIZrG7iNcykdvPMoK0F6AG6lOmLVTouQWI12/Utqlu/XpXwCpz4FJsFzZzAZ2jEkMily0Hjla+wlPIU8XXAdSHKOiDl8s2eLkWsZcIalxZySZ26Sg4/mr16HQLWjkDHs17mfv9gZ7TFQh9ZizBilrmQPEqQ1/DG4WLEzj+XdJw4w3Esmjkx6czDo0Z4dyuA/bdaDuZvzLfP9zKOSX+cHEqeeqnw9tGRbkUVw30VDFbB/AxBhQXzCGOAEVSw1dBM2Kw+C8v1KfTjTjw256Aw4A2IBdLBjUcXpTgfV6iriU+EdQzB4OJH+k+m/EUNQuHRyTvTX8A6PE4lt3xMgHcVpEdUFbt0ECGrSgP09fPwlw3YKFNDyA5jVu45n1ZlXwBbEog4cadpn7nfp7v5MH+XjehDvE
 Jy/69N6w
 4pInYzvQahHDqnMtQ837+XffzA3JU1ev/0arRZxx7QE/2rRp1tJHmDBWHcd7dOwDJDDoJZ/GD/kAbofEZEGvDuTqOuMbrjrniRKEUDv8rMkaltD2J6rSHgLiZOw7r40ZqvOX4OInMzLfEwp6t2flZ8qbb4sQsiiuNJYXHcyHQ3uAQVFW6631gv3grXWBD3zzLLTVKRp04y3U7MhNmBWVsjjPbmxX2YQb2gDTdVZY3UXyHSEFv+n8RSxOx22xvMQ5W3IS6gg6cmiEvGXFp1tuHM/4+WoSaAWCo2RO47f6g6+E7iNsBTx2PQ+BewqNDcp2Alwe3SbUcLdqtIW0GgBjbTO8AHpBMfUT9ErrK8WtMZaG5Kz4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 14, 2026 at 09:05:04PM +0000, sashiko-bot@kernel.org wrote:
> Thank you for your contribution! Sashiko AI review found 1 potential
> issue to consider:
> - [Medium] mm/madvise: zap_range() reclaims PTE tables needed by
>   madvise_guard_install()
> --
>
> commit b93124c4df6f4f255fb9c4d2510c6ff4b474ec35
> Author: Lorenzo Stoakes (ARM) <ljs@kernel.org>
>
> mm/madvise: zap markers from guard regions
>
> This commit introduces a zap_range() helper and uses it in
> madvise_guard_install() with ZAP_FLAG_DROP_MARKER so that existing PTE
> markers are dropped when zapping a range prior to installing guard markers.
>
> > diff --git a/mm/madvise.c b/mm/madvise.c
> > index 0214efd2a014f..4f77285832079 100644
> > --- a/mm/madvise.c
> > +++ b/mm/madvise.c
> > @@ -850,6 +850,19 @@ static int madvise_free_single_vma(struct madvise_behavior *madv_behavior)
> >  	return 0;
> >  }
> >
> > +static void zap_range(struct madvise_behavior *madv_behavior,
> > +		      zap_flags_t flags)
> > +{
> > +	const struct madvise_behavior_range *range = &madv_behavior->range;
> > +	struct zap_details details = {
> > +		.reclaim_pt = true,
> > +		.zap_flags = flags,
> > +	};
> > +
> > +	zap_vma_range_batched(madv_behavior->tlb, madv_behavior->vma,
> > +			      range->start, range->end - range->start, &details);
> > +}
>
> [ ... ]
>
> > @@ -1217,9 +1224,11 @@ static long madvise_guard_install(struct madvise_behavior *madv_behavior)
> >
> >  		/*
> >  		 * OK some of the range have non-guard pages mapped, zap
> > -		 * them. This leaves existing guard pages in place.
> > +		 * them. This also drops any PTE markers in the range,
> > +		 * including existing guard markers, which we reinstall on
> > +		 * the next attempt.
> >  		 */
> > -		zap_vma_range(vma, range->start, range->end - range->start);
> > +		zap_range(madv_behavior, ZAP_FLAG_DROP_MARKER);
> >  	}
>
> [Severity: Medium]
> Should zap_range() avoid setting details.reclaim_pt = true when called from
> madvise_guard_install()?
>
> When a guard installation range spans at least a full PMD and contains any
> mapped page, swap entry, or non-guard marker, zap_range() with
> ZAP_FLAG_DROP_MARKER clears every PTE in the PMD and reclaims the empty PTE
> page table via pte_free_tlb().  On the very next iteration of the loop,
> madvise_guard_install() walks the same range to install PTE_MARKER_GUARD
> entries and walk_pmd_range() has to allocate a replacement PTE page table via
> __pte_alloc() while the old table is still queued in madv_behavior->tlb.
>
> Besides the unnecessary page table teardown and reallocation, __pte_alloc()
> on the retry pass can fail with -ENOMEM under tight memory or memcg limits
> even when the PTE page tables were already allocated before the zap, leaving
> any pre-existing guard markers in the zapped range removed.

This is an edge case and doesn't matter. And fine, reallocate the PTE :) It
allows sensible sharing with the MADV_DONTNEED bits.

The ENOMEM stuff is silly, if you're going to fail there you need unreal memory
pressure + fatal signal, so failing early is right.

>
> --
> Sashiko AI review · https://sashiko.dev/#/patchset/20261113-disallow-uffd-guard-install-v2-1-9d0063c70542@kernel.org?part=1

--
Cheers, Lorenzo

