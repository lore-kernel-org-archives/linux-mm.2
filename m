Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 61E5260A381E
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 12:51:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y+OgHF7N
Received: by kanga.kvack.org (Postfix)
	id 88A666B05B0; Tue, 17 Nov 2026 07:51:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 83B9D6B05B2; Tue, 17 Nov 2026 07:51:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 72A8D6B05B3; Tue, 17 Nov 2026 07:51:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4BADE6B05B0
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 07:51:39 -0500 (EST)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0119A040B
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:51:38 +0000 (UTC)
X-FDA: 85444597476.14.652C6A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 3F2E7A000A
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 12:51:37 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y+OgHF7N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794919897;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J0TOUvk32E1rdNMExsYqIoOZFzxD3LaVQ2WnMx0hvlo=;
	b=BxKlQA7eL0fid0cfpGheTnGGTN4/CaagyuCxJFDLO7yDx39S16nugOnIBHSGHgXjEB8VSZ
	n1lV6gFcQgeC3mXAzp9a6j5PAxGHiicsq1oIPRSeZY1vJ2Ldh5nMmkPyTSISNPor2smpnU
	OLx4oUf8JTbQ7Nx/FZprPAYhFIW5Dmw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y+OgHF7N;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794919897;
	b=xGkxTE2VvLYYGMeSxCODC+JQGmI4tiqGwexREmtLWO0W44XjPBOMIpfRKEwd6nT/G8aV9E
	LCdX92YAxNDRSxHsKVmBl++Zt/8kjfjbLrqTRKkB1N6L93dZ74WkHtAuQZvEI61sOLu/Xc
	a+aWiNCyq41ddkz1D/faxx0KoPaP/N0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AA8D163492;
	Tue, 17 Nov 2026 12:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252EB1F000C9;
	Tue, 17 Nov 2026 12:51:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794919896;
	bh=J0TOUvk32E1rdNMExsYqIoOZFzxD3LaVQ2WnMx0hvlo=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Y+OgHF7N/NMRmrNc+apXZMxeQebI9nQAVImfiLvKWeNrfAK6s7oYdTCKMr++9hJN6
	 07JIvOT7ZZDZYJO3i7DjFi7i7i5n1VGEEy6vW7EXx8VOCaHhUFD5xhJgJyGzaOPGHs
	 Fm2e+QNUn7MBHDWTTSoQpbS82YYhXWlip1zedHesejk+2Mci/5RMHPpqeuUwtIJ8T3
	 LqHDd54pUApHRpqrO2hvjCpaRIugg0DLksj0A31M2Kli/nMbtj5XfTN9BGP7UBr0lL
	 nHRuwICvUnUXv2hhXQLy4Ke8LL6R+gxHiQ819hoJtZhBZtLSRQbDvLnCR7uypo6hCB
	 6EcefM8ZssCTg==
Message-ID: <sashiko-outbox-218808@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 2/3] mm: page_alloc: make the high-order watermark
 check honour ALLOC_NOFRAGMENT
Reply-To: sashiko-reviews@lists.linux.dev
To: =?utf-8?b?S2lyeWwgU2h1dHNlbWF1IChNZXRhKQ==?= <kas@kernel.org>, "Andrew
 Morton" <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "David Hildenbrand" <david@kernel.org>, "Harry
 Yoo" <harry@kernel.org>
Cc: "Suren Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>, "Brendan
 Jackman" <brendan.jackman@linux.dev>, "Zi Yan" <ziy@nvidia.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, "Mike
 Rapoport" <rppt@kernel.org>, "Qi Zheng" <qi.zheng@linux.dev>, "Shakeel Butt" <shakeel.butt@linux.dev>, "Kairui
 Song" <kasong@tencent.com>, "Barry Song" <baohua@kernel.org>, "Axel
 Rasmussen" <axelrasmussen@google.com>, "Yuanchu Xie" <yuanchu@google.com>, "Wei
 Xu" <weixugc@google.com>, "Baoquan He" <baoquan.he@linux.dev>, "Baolin Wang" <baolin.wang@linux.alibaba.com>, "Dev
 Jain" <dev.jain@arm.com>, "Usama Arif" <usama.arif@linux.dev>, linux-mm@kvack.org, kernel-team@meta.com
In-Reply-To: <20261116125103.2894162-3-kas@kernel.org>
References: <20261116125103.2894162-1-kas@kernel.org>
 <20261116125103.2894162-3-kas@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 17 Nov 2026 12:51:34 +0000
X-Rspamd-Queue-Id: 3F2E7A000A
X-Stat-Signature: 6stekqtu3okaw91d5ga5whjafg6piczd
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1794919897-916330
X-HE-Meta: U2FsdGVkX195McKde9ekbPzV0TnmDBEg/pYBnd51KCcRmAnNGaBpZ8JpgqwkU7vRgCWmwai3oFLtlnKeyz47LmUI+zw6Gd9OQ6tiaFcZcU1MLp/DUq0oS+fG2iWdJ/wPi/4mwWbt5BzxTd7DzOEEhmlvaHezqKhUMhJN7vFp8E45G/pHrpD8ta/y3ylcNgwSfxQjB/5a7qpKcN/yQMpuHsANuYUnlgm2p6FJ548EcO1iiAKc8Eh6KeTAV3+d3u1vkiKHh/A6VzHQsQ6Xov/A9rd+NKo5FqyDUiuCTNzunavQIKPYYAIHbBU3cLnoNDLmVrnXVoAzSdG28xajdY6+yjG7DY6tKsFTTHBusUyKdPcZSRlZsCglrIzl+7t5t0L+SwiI1RSbiNg0sXM4wR/MF6982DbQ5mJ37Np5X08nYu0eKEoL8LS9YFTS+iND8RadlxSW9ZyxAZniV7ICkZQKJXFYPePjTs9mNPB0AKYSVxEXQlKJnb/2Bjvtkp3qMN7VDgyxtDrfwmLkE+AMjssOnf60qbXl16jZas8mGwyBdC09qWNjw4ujp7qd0gyYH8Mp2pjRoEoNRonJ04TanT8um19Aalsb5eneM6W6qTm1qubcr+gtdDwLMAaOViBls2xyFhCcmWm1Kle5qLuKYeyEkZys9koVmU0mgTK5Jxk9FK7A5j9oUYQw5+1VphJfIt6uGy1+PHiJSAVGxB9aeZ3YCXwKOiMOGm44TaTdfLwbb4xmVb5HlB7rRWdyQeBIKdG1MitMGb+apOEt2Yr043XF+Roh9zhEf0+7Wgsb84GENRJ4X1oI/zzdU9r9z3VDMCNLCaoyuaLDGZN+fnde7nbHkNqEIVoapCwp/TY11M1jukYoR3ArnSCQIB0bxiPqoQTX65Tqfo3UjLTvB3R0lku/4Fb8fNPgPYf+jDIpN/gwdvmUkTGch0NxvIWKFllva3tyEL8aaZldS73uS9/ZmFT
 b9Zh4pjH
 NBUkNjXCA7igSdoQ7OzctIX3PsRZ5Z4J+RxnXeXT0dHSp7DMG6PmjSU9y+8VRdd30nx+kYBZXnS+G4DZHoS1xyyXRAwKBN1UCyXCAI3wOKlNEPbz3LIXPhfr+b0Cca28RmJiHhnxj/xsEdBpzL32hy/hmofuS+i9Kxohve7e+XC8+MXLzkUdwzPUgzbFxbKpYjoXXBw8oWGmW+GgCBI9aaoRF2K0Na1bOAA6bVKPTHE8d1BXOqSXtsKE0AdCuDg2NXLWPXhqx4Le/FTIMF357in9RZufxXLDH3splOfKcNgmqY9G1Gq8TZzKCeGHMhPssgaMHQ7O5nxU2O9CXGLTfd8+9jEame85DmVpnd/5zPVmYS28/3jt3ZtMvtpdRZe6jWXOpsFvKq0+SPeBpB189jt8bSuHyTeFcUH6zPqGhdIe4FoyIG3eCxHsaQIcrgDTsrt/H8ouTMH7P9+QM0ObfEsddJZ4Caj/V/b+Aj6G0ZjU1Mb4055k3ehuAS851dweQH3jiJnSzv4WzADEIlqCUfnQEz+XQAy+c10Ic0B3cJ4rTX7iU+IiITjLzORlH2MSdBTI/KHlZgM9n/X1NKxJX2EF2IItx4dVAF+P2KoizScJKgM2pDZz8FSrNOsnb9qmIOh3bmYBinXh6p7x7aXZJyIosyxLuMfpGkeJ/ZI5xAlUaU0w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [Medium] mm: page_alloc: should_reclaim_retry() counts unusable
  migratetype pages
--

commit 214b943d575d3d5441bd4208e2c27a65d780e75c
Author: Kiryl Shutsemau (Meta) <kas@kernel.org>

mm: page_alloc: make the high-order watermark check honour ALLOC_NOFRAGMENT

This commit makes __zone_watermark_ok_mt() and __compact_finished() ignore
free lists of other migratetypes below pageblock_order when
ALLOC_NOFRAGMENT is set.

> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 0ebfbbb5d7c57..6e75c03b303b1 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
[ ... ]
> @@ -4693,10 +4705,13 @@ should_reclaim_retry(gfp_t gfp_mask, unsigned ord=
er,
> =20
>  		/*
>  		 * Would the allocation succeed if we reclaimed all
> -		 * reclaimable pages?
> +		 * reclaimable pages?  Count free pages of all migratetypes.
> +		 * Compaction can then free a whole pageblock for the
> +		 * allocation to claim.
>  		 */
>  		wmark =3D __zone_watermark_ok(zone, order, min_wmark,
> -				ac->highest_zoneidx, alloc_flags, available);
> +				ac->highest_zoneidx,
> +				alloc_flags & ~ALLOC_NOFRAGMENT, available);
>  		trace_reclaim_retry_zone(z, order, reclaimable,
>  				available, min_wmark, *no_progress_loops, wmark);
>  		if (wmark) {

[Severity: Medium]
Does stripping ALLOC_NOFRAGMENT here cause should_reclaim_retry() to keep
returning true when a free page with order <=3D o < pageblock_order only
exists on another migratetype's free list?

In __zone_watermark_ok_mt(), the order-0 watermark check against available
already counts free base pages of all migratetypes regardless of
ALLOC_NOFRAGMENT.  Clearing ALLOC_NOFRAGMENT instead changes the
z->free_area[o] loop for order > 0 so that it accepts existing high-order
free pages of other migratetypes that the ALLOC_NOFRAGMENT allocation and
compaction now reject.

In __alloc_pages_slowpath(), should_reclaim_retry() runs before
should_compact_retry() and the ALLOC_NOFRAGMENT fallback:

mm/page_alloc.c:__alloc_pages_slowpath() {
    ...
	if (should_reclaim_retry(gfp_mask, order, ac, alloc_flags,
				 did_some_progress > 0, &no_progress_loops))
		goto retry;

	if (did_some_progress > 0 && can_compact &&
	    should_compact_retry(gfp_mask, ac, order, alloc_flags,
				 compact_result, &compact_priority,
				 &compaction_retries))
		goto retry;

	/* Reclaim/compaction failed to prevent the fallback */
	if (defrag_mode && (alloc_flags & ALLOC_NOFRAGMENT)) {
		alloc_flags &=3D ~ALLOC_NOFRAGMENT;
    ...
}

When another migratetype holds a free page of order 1..pageblock_order-1,
this regression makes __alloc_pages_slowpath() jump back to retry before
should_compact_retry() can escalate compact_priority, and traps movable
allocations of order <=3D PAGE_ALLOC_COSTLY_ORDER in reclaim because
should_reclaim_retry() resets *no_progress_loops to 0 on every reclaim pass
that frees any page.

Calling __zone_watermark_ok_mt(zone, order, min_wmark, ac->highest_zoneidx,
alloc_flags, available, ac->migratetype) here would still count all
migratetypes in the order-0 available check while only accepting usable
high-order free pages, letting the slowpath fall through to
should_compact_retry() when compaction is needed to form a full pageblock.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261116125103.2894=
162-1-kas@kernel.org?part=3D2

