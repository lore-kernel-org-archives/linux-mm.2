Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 588BFCD8C9D
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 12:29:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97F336B0005; Mon,  8 Jun 2026 08:29:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92F356B0088; Mon,  8 Jun 2026 08:29:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 81DD76B008A; Mon,  8 Jun 2026 08:29:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7161E6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 08:29:42 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 09399A0AD4
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:29:42 +0000 (UTC)
X-FDA: 84856676604.19.7C104C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5CD5F4000B
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 12:29:40 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gJomfNfj;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780921780;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rAUA5rzcwEowomF8bvC+wP4/eskLSjeaT0mDws2eabw=;
	b=DlIG5kfwfI8kI9b3ZzEkm02RNVkycxy4/ZOqcsCZOmVCWEdNxLgNMa18KhMDYxt3Ld263U
	2yoBvM5XcdBWXBMUWW/Uk9WqZt5RDBePIF3LT/J1m83MhtBiwAwYJJH2/Td4+0bTgtBrNj
	TxHGcvWXWZgFtw32wjtgERvJYWvti18=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gJomfNfj;
	spf=pass (imf27.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780921780;
	b=IbAWzwCw0TUoV1/1NGhHsuzaHL9cAysKH+abw2HkvqmC/kMThpc1uBY1DFnm3Is3tDRPsD
	KASLPpt080jKodjW9YwgY1jmhgvil6aOEBNWaQuiFRwZGePrkH4eNdn4wImQDo1GyOdAm/
	AxdanC0HyHcA3PbRrjK+fMONi2rGeIc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7FDA742B04;
	Mon,  8 Jun 2026 12:29:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5A2B1F00893;
	Mon,  8 Jun 2026 12:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780921779;
	bh=rAUA5rzcwEowomF8bvC+wP4/eskLSjeaT0mDws2eabw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=gJomfNfjHUXhpfXzIbWi9ZWTWmsfuKpfU1PN5tXQ9+wVWf/J0u5GwDYGvXpWIlJLl
	 o0N5Lma90r++0YOHdXe4SBXQaxTq8P7MaieFdchHBWlEb3fuvtzrFk0GSCC0lPsYjy
	 /spwzit17UxG8bDETTvG6Mm+C2ZqWV8t9ef8QUg3cZwujC3qcOEZaeQ2HkLIKFsQKC
	 dCwMJ65PdahtJ8/5VI1bz/J4JdrVpbWYCe7LIkNjHbpAeJJHQto4wEZhQhi5FwuO2m
	 q/Vf9HKa9Ls7GMplUEjCoK4+L8TLk9SoaxAHnZ5Dr1puE3DjxNj34OzQ81R4iNeZME
	 c/yob3kPsmkMQ==
Date: Mon, 8 Jun 2026 13:29:26 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: linux-kernel@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Jason Wang <jasowang@redhat.com>, 
	Xuan Zhuo <xuanzhuo@linux.alibaba.com>, Eugenio =?utf-8?B?UMOpcmV6?= <eperezma@redhat.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	Andrew Morton <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	Matthew Brost <matthew.brost@intel.com>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
	Rakie Kim <rakie.kim@sk.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Harry Yoo <harry.yoo@oracle.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, virtualization@lists.linux.dev, 
	linux-mm@kvack.org, Andrea Arcangeli <aarcange@redhat.com>
Subject: Re: [PATCH v10 25/37] mm: use __GFP_ZERO in alloc_anon_folio
Message-ID: <aia1bDGUj7SRcswo@lucifer>
References: <cover.1780906288.git.mst@redhat.com>
 <13ed2aa6607d510bd8dc6d602e96626511ee4fee.1780906288.git.mst@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <13ed2aa6607d510bd8dc6d602e96626511ee4fee.1780906288.git.mst@redhat.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5CD5F4000B
X-Stat-Signature: cf8zry3nkbhjs98x77ke1kzy3qr9qt6i
X-Rspam-User: 
X-HE-Tag: 1780921780-536189
X-HE-Meta: U2FsdGVkX1/NCXdDFzRWIqG96fkS/gOQakQYDcMBeHTeb0xbgKZuC9JuxOKRnCYDifdnWNmofRlKelsuaXBfg3096m/077t5SNdo6zcivz8DyUG/UGOuZx+4pSTGvZ3+XXx6VQMJirF5OZt8hqQ2+0zdTAizKX4zo1S4OnBLUHPLZFXS0o5yO+HIexpIEfX9EWR6FCt4iegIqpdZQ/uPRQHSdGrjoza9UD4H5l7SFxb2fDXFvOEr0d2jKoyrtOzo3iQtZtBwKlbDDkWV20TJZgRma7VHwzkKzEYxVupO01mvWtTvcn+4tGUNUXiOmcsv8Au1r6gOLjhfGrDFqt5XBLMPRR37mPYUVOTgTnEvve0P4KLfO5Kt+LMeqO81dOXZ2OqNfXjUMzjsGolryqDYDbf0779c2ZqMVwRw4jtuyWudpDrT+kNJsphAJPo/WaglDTVNzKRlnV+4ZRJg608VLJ5ECNKP7FPtQeavEyT8ChRSCd6hxZCqzrjMEnV42ZeFif4+D2A7l3ZqTRHsZ/i1kfSFw/H/YVKhIsDxaomhMNC23wFh3vmyCrOzTQ/8UfwtYdQtmMXUMti8tEfYtI1uvhy7IdHgFccBuPi3jxAKOBFqGnCZ82/5m+GcHfHXBgL8ftnUOKWvHd1COwvvq26VE6qAWSWIV5W9IMLla58BnsBIVcBJACGJc9cnsuUKu2Ax5bYhXbr+IdjXd8D1EVGi438qCrzyTiAp2/16cwwvR/xBzzApxDgTiUsUPayXxzhtJQJVVUCr6Xc6QQu+pKrCiuIhK8bE0v2wHQAReH2lfaIb6/SJkFpXoPmNsXFyY1gc7Be7xILo0dpT/2eucml/VNK9xN2o41tyy8aFhbB2YIAMW/uPWf7ZQdbdzktk3NbUWUZOuvc1Df4QFmp3MCM2fgIkY2CfpPQet/dpvrB4LqdngQS3N3OcatM9AgeOgg+0rO35gWmziIgYu4wtOEP
 NiUTZBIl
 jTL60z7lrlIWrUng3YZoEiH1aG4pg5eZtfLEJeF4OGykzXkuwfI6DzGP1HD/7OhehXzOmnyUSJJ0bFzBrjaALM51E38FhpvdAo4n3IAwiNC0EuFYLzy/Wb+1T1jYbQ643IMuHkJMHqqRqQFi0Q67K3E+cooXZZ/mqiMBOKvS6gLKMKh7/y/aXU1ec5v5T8V7fuyU0G0i0G0uUjt/U5lo+Xs6OasRyDaJvmyL+Gmu1TJSG+2giJgNKPJqKSUX317WmEPEpXS0bJ1UeJ0K26sWcwLp4VG00KbKcWPMmFcMgYYTrirUdzROtHGKUJ0nh22mN1djWetdfSfrXD0p6US7HM7sMjmApl/8K9w6qTrBZyeQ2h7X5abz7Ll3sYPK450s41Z/05wtiXMTwxmEG9uSWkojcLlcD/KGMb0nXLlGLoiC3zmzl1guvRzdvYRn7eAZNPovR4NGPL1MNiyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 04:39:02AM -0400, Michael S. Tsirkin wrote:
> Convert alloc_anon_folio() to pass __GFP_ZERO instead of zeroing
> at the callsite. post_alloc_hook uses the fault address passed
> through vma_alloc_folio for cache-friendly zeroing.
>
> Note: before this series, replacing clear_user_highpage() with
> __GFP_ZERO was unsafe on cache-aliasing architectures because
> __GFP_ZERO uses clear_page() without a dcache flush. With this
> series, it is safe if the caller passes a valid user address
> (not USER_ADDR_NONE) to vma_alloc_folio() etc., which delivers
> it to post_alloc_hook() for the dcache flush via
> folio_zero_user(). It is only unsafe if USER_ADDR_NONE is passed.
>
> Note: with __GFP_ZERO, the folio is zeroed before
> mem_cgroup_charge().  If the charge fails, the zeroing work is
> wasted.  Previously zeroing was done after a successful charge.
> This is inherent to moving zeroing into the allocator.
> Charge failures are rare (only at cgroup limits).
>
> Use folio_put_zeroed() on charge failure so the zeroed hint
> propagates to the buddy allocator, avoiding redundant re-zeroing
> on the next allocation attempt.

Is this even worth the effort? This is surely not a hotpath...

>
> Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
> Reviewed-by: Gregory Price <gourry@gourry.net>
> Assisted-by: Claude:claude-opus-4-6
> ---
>  mm/memory.c | 13 ++-----------
>  1 file changed, 2 insertions(+), 11 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 6c14b90f558e..6d6a3e1a02c1 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5265,25 +5265,16 @@ static struct folio *alloc_anon_folio(struct vm_fault *vmf)
>  		goto fallback;
>
>  	/* Try allocating the highest of the remaining orders. */
> -	gfp = vma_thp_gfp_mask(vma);
> +	gfp = vma_thp_gfp_mask(vma) | __GFP_ZERO;
>  	while (orders) {
>  		folio = vma_alloc_folio(gfp, order, vma, vmf->address);
>  		if (folio) {
>  			if (mem_cgroup_charge(folio, vma->vm_mm, gfp)) {
>  				count_mthp_stat(order, MTHP_STAT_ANON_FAULT_FALLBACK_CHARGE);
> -				folio_put(folio);
> +				folio_put_zeroed(folio);

You just allocated the folio as zeroed above, should PG_zeroed not be set thus
making it unnecessary to add folio_put_zeroed()?

>  				goto next;
>  			}
>  			folio_throttle_swaprate(folio, gfp);
> -			/*
> -			 * When a folio is not zeroed during allocation
> -			 * (__GFP_ZERO not used) or user folios require special
> -			 * handling, folio_zero_user() is used to make sure
> -			 * that the page corresponding to the faulting address
> -			 * will be hot in the cache after zeroing.
> -			 */
> -			if (user_alloc_needs_zeroing())
> -				folio_zero_user(folio, vmf->address);
>  			return folio;
>  		}
>  next:
> --
> MST
>

Thanks, Lorenzo

