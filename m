Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 09C5C606A328
	for <linux-mm@archiver.kernel.org>; Thu,  5 Nov 2026 17:06:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=iC2dcB3k
Received: by kanga.kvack.org (Postfix)
	id 154CB6B05B6; Thu,  5 Nov 2026 12:06:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D7336B05B8; Thu,  5 Nov 2026 12:06:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2ED06B05BE; Thu,  5 Nov 2026 12:06:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 764526B05BC
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 12:06:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 971C680B80
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:06:44 +0000 (UTC)
X-FDA: 85401694728.10.80BD405
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id D5E7216000D
	for <linux-mm@kvack.org>; Thu,  5 Nov 2026 17:06:42 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iC2dcB3k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793898403;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ianTrveSK4dhFW5UqHYxXDFeTMj4FVLXLf+aTFzURnY=;
	b=23WSLRIyTLXI5cJJYmy+MESlqCGL+BiRawkZNk/R0ZBKF4axC68ZTjkmDvsEjmYipCBN2f
	TyG8izQt2wrFnRtcvpY6fX/NdDGGi7dzhWuAjMIGGsz0Dzm9C1Cb6QD5H2jXMVfhuWTrVy
	IFESyvowwkBxgmUzExG+sTq82Upi598=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793898403;
	b=m1Hkc9rnYcmkTotwhyU6lzFdZDhMBdFvHmVxicgFPSaKHhy1eBc9OolNlICLrzct1mHXSQ
	5De89u77nNqYdI/j5mFHcyUZMDHWWsOW1uA4b2hMB8j0dk1kw0hdTa81HKsMMUM+i2qIyb
	zZhVfTDm3fI9CuUXC3+ujRFT1DrsycU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=iC2dcB3k;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F12AE429D1;
	Thu,  5 Nov 2026 17:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6658B1F00A1C;
	Thu,  5 Nov 2026 17:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793898401;
	bh=ianTrveSK4dhFW5UqHYxXDFeTMj4FVLXLf+aTFzURnY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=iC2dcB3k5D083AyxQGoh0br5hmHCzcBMciwr0URm2plF6gm/0IObUPjrMo9g/exVo
	 nwVnrdMkve4CCOMdwiEv+Sm/HRK8BL2Pyw+QBM8SqpwKyvbIipTbfOzAf9hlXZMdlM
	 suPseaYWxWu6nkyF+SjiMXDqoFkCJrgROQM9SXiPEmfKtEylkaOXv4K597mboTvhtt
	 mf+adjoxQv/Ml5XKISFK5ehd1wVBBDeT0r0w/SH9fvoMsA7UIRwmwNd6h+qbvd5c6k
	 39jwlCnQA3D97nRwrey+AMeK1pk3deP5etzCSjv5YWgQh75VLzu1bv/ZDDbdqJzAPe
	 RqfA2nWLqPfxg==
Date: Thu, 5 Nov 2026 17:06:39 +0000
From: Harry Yoo <harry@kernel.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 1/3] mm: page_alloc: add a watermark check that knows
 the migratetype
Message-ID: <auynaZkzdzL6Aeyo@thinkstation>
References: <20261102093939.3340540-1-kas@kernel.org>
 <20261102093939.3340540-2-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261102093939.3340540-2-kas@kernel.org>
X-Stat-Signature: usu116in1os4ak4zxojon44zq91bm61a
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D5E7216000D
X-HE-Tag: 1793898402-189424
X-HE-Meta: U2FsdGVkX18tN7W4a6/B3HW20mBnBpv3l/tD4Nw96/O3KnGxgUTyLKfTjrLncfYVvQfovye9dGJwKjLc/w8m1TrzJ9qcJ2opW3sFT0GJOCBamlGQ6wy7KQhz+S9zy7+y0HAgBClQhI+Yo2bUrb62Lvp9bSHtkqLsr5dTkUnnTtJT+iKkRJxOiI2XiTuMsxeTJ7rvOY4c6Rob7d/4vumb1uPMxkX9IqMYQauMX6Ie8Pqu+v2D4iY4kUIkAch4R5PDEmdE4fJmiwzW6nkPNtAU47hiIyaX+3uAi30NGJPpppuuOy23XyvwU78N7+9CpmJ9cqzY2guk65185R1AHXnj41yi7McdkaTZ181xI8OsdEfBAlxZhY5pRxvd0vpfJ/xqfDGmCmNQZj4LusonEzClrv17cgoURqQyw/R27xDYBeFw8C5GUs+m9RL+sx0ud31hlqNwOmMe0MXdaNuxSiMP6uAsTyr2baLyhpRRyA04Zi8JB/zwL/ow+zQxMpugjcsWRsHvaK0DklfYMRaM9fZLKhBCBfOl+t7cXXVofLxTZctMkv7zW+I2EdanXHs/ZLUjGCaoBBFB/KjU7IVG9TTToJ7keT0JXDRJM5igOqCEV/TJ75lDFnewri/5tDEDpoe1VbwqAkCq6m5ZyVUA4vaC1ufwM0ivUrIuHDiAVYR2d60oa55iZYQuoUXc8486gMCrdAA+6e+QeLNsJ9/BBvT/tvVYWJZu8d/6Mm6AJbEwV3dsagF/bAObRNHSMZSlj3zBLKQ0eR/RwjtgNdxA4z/tlL4IUwppAJasNVsCm8pkxmZsDuu9djKaJw+CBH6E0xhPiV9VNnrSYhlvC6pKPze2lspArvS96Sn7YZpW0m06SOxjjJK35/0GC9nqj2VmngYOIue/9WlsnfVTs5DuFtdcbxt+IP8MREdxz0GqR52XudtyC9R01Kiug6XowKu/ZC6dnrUxbSM6ufvccbVRS4c
 N6el/8Hg
 TKJ+UMQpYWnew5xu3+S2zMqRBYa41hy9rj5nJ0QeuYeIm+9lcS3GQd47bkuoP5VHaFEqawFmKgnyaeuU2nYzmLXn+xnSthIvUHTfVGCRm5ortUX1L60IElvHubSkGW6ZMaSPQSTPN/g/MJNju5WXnlVHzKUcV3hFPyEb/GD6ZeBulO3JlFM6OQYjg+Vq6auWGHvjIXXZhld3BnDNEjCk/6kcJTCOzCd85eG8KRkoC/+BqUXipRCDFKVk5rEvqONU5lHks0nLVvao16Tbj2we6biVhTpts9ZA9uTRLDyaptzljszCsmpg6D5UOl9rVy5nA2pj/PNISsGRJDQZRC5lL1/gfoB1P0KeREos8gUiMjqzRLRlt5pD2oOPFVnU+NLN5R+MT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 02, 2026 at 09:39:34AM +0000, Kiryl Shutsemau (Meta) wrote:
> The high-order check in __zone_watermark_ok() accepts a free page of any
> migratetype.  Under ALLOC_NOFRAGMENT, a request below pageblock_order can
> only take a page of its own migratetype or claim a whole free block, so
> the check can pass when the allocation cannot succeed.
> 
> Telling those apart needs the request's migratetype, but not every check
> wants them told apart.  A check whether an allocation can be served now
> has to count only the pages it can take.
>
> A check whether there is enough free memory counts every migratetype:
> kswapd and kcompactd balancing a zone, order-0 thresholds, the
> slowpath's forecast whether reclaim and compaction can still make
> progress.  Reclaim and compaction work across migratetypes to free whole
> pageblocks.

nit: perhaps we could make the changelog above bit more concise.

I think the necessary bit here is "With defrag_mode, allocations cannot
steal a page from pageblocks of other migrate type, thus
__zone_watermark_ok() needs to take that into account."

... and maybe

- "Ignoring the allocation's migrate type leads to
   stopping direct compaction and reclamation prematurely".

- "Indirect compaction and reclamation are not affected as they do not
   serve specific allocations"

> Move the body of __zone_watermark_ok() into __zone_watermark_ok_mt(),
> which takes the migratetype as well, and make __zone_watermark_ok() a
> wrapper around it for the second kind of check.  These use the new
> function:
> 
>   - the allocator fast path, zone_watermark_fast();
>   - its recheck after node reclaim in get_page_from_freelist();
>   - compaction's up-front check, compaction_suit_allocation_order().
> 
> Declare both in mm/internal.h: nothing outside mm uses them.
> 
> Nothing reads the migratetype yet: no functional change.
> 
> Tested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
> ---

otherwise looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

with a nit below.

>  include/linux/mmzone.h |  3 ---
>  mm/compaction.c        | 11 ++++++-----
>  mm/internal.h          |  7 +++++++
>  mm/page_alloc.c        | 37 ++++++++++++++++++++++++++++---------
>  4 files changed, 41 insertions(+), 17 deletions(-)
> 
> diff --git a/mm/compaction.c b/mm/compaction.c
> index f1b2060eb201..6c553d0e90f8 100644
> --- a/mm/compaction.c
> +++ b/mm/compaction.c
> @@ -3116,7 +3117,7 @@ static void kcompactd_do_work(pg_data_t *pgdat)
>  
>  		ret = compaction_suit_allocation_order(zone,
>  				cc.order, zoneid, cc.alloc_flags,
> -				false, true);
> +				MIGRATE_MOVABLE, false, true);

nit: maybe let's set cc.migratetype and pass it?

> @@ -3665,6 +3666,21 @@ bool __zone_watermark_ok(struct zone *z, unsigned int order, unsigned long mark,
>  	return false;
>  }
>  

-- 
Cheers,
Harry / Hyeonggon

