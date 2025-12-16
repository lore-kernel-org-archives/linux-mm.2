Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8AF4CD609C2
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 16:28:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CACA06B0005; Tue, 16 Dec 2025 11:28:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C767B6B0088; Tue, 16 Dec 2025 11:28:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B76CD6B008A; Tue, 16 Dec 2025 11:28:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A55536B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 11:28:39 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A6258B424
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:28:39 +0000 (UTC)
X-FDA: 84225867558.21.337815B
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf18.hostedemail.com (Postfix) with ESMTP id 53EB31C0013
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 16:28:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=d60h3DFi;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765902517; a=rsa-sha256;
	cv=none;
	b=A8VrP0G7UcYUt75lpmmy1yaDmXl6X2swUxRd5FydCBPXbq96KToDpZR0XYREAMz1n7ftzG
	oaWcFWpxAvXxP/2+gQiBLVB0ArcG2iZjbvCdMWIBNatHTcEl3Gndk5EPypb5d5TafC7xyL
	XmuYwAZXeHhamb3lq8C3py6ZzpV6D+Y=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=d60h3DFi;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf18.hostedemail.com: domain of mhocko@suse.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765902517;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RxeKMLaOT+Gmz4/OdhDrThGJPpi1R6U2vxRByvnAG6Y=;
	b=YvtFStVLOhf3iqxDfUaxszSsVw7cXxrrkgsivhRIvI6NIq2NkaH83asfm+b9SmnYPCK1bl
	B/3WN0HWMCIIWK5y/0red6N35kuhSd6vzttqHFsdovOResvGJgUmKIK2x5PlN0dqxTceVK
	la85pnBojo2Ps/Gy0nD5O/QZGkjS2zk=
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-477aa218f20so32486015e9.0
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 08:28:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1765902516; x=1766507316; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RxeKMLaOT+Gmz4/OdhDrThGJPpi1R6U2vxRByvnAG6Y=;
        b=d60h3DFiCO9I0HQpioPpLETPuoVt8cBCmFSNn0ffnh/OVllSaAoCH/XvgPYQVMHKWI
         0UOjpmUojfygAaLRxIfzmegj6HiI08PHLv4zpztyNp9M2nny1ZBojyxUrpxDkFMnISVv
         zROgd1ejh8PYqfep7Z1D6iBR5L+7yoBDLVe0pZ9hoW+Rcxrxkfdc65Ma5ubK2Sdd+00g
         vxQBtKA/UKU71sl+ChgkekJG68bBIUTbzF4a1eAK4ClCjq3Py383V7VopHE2mNyCRwW3
         W4z3DLG6MaWQi/ppvLtpJ/M3ZfcJ8GXlhCzvOBIU1FHdk0/5yDV4mpqWiD9PHpAOQXXX
         gaNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765902516; x=1766507316;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RxeKMLaOT+Gmz4/OdhDrThGJPpi1R6U2vxRByvnAG6Y=;
        b=HFtXOeNR1oWpsy28NOEIH6biJR9EBBznMYOUx9J4znQICVqFDiovWUCB36TkrxIx3n
         6DZT19Sg1r0ggR/xuMHLCUpsJMqqLbHf3ursn3J1MYL9nkcWNeTkuQDAWCdAMCrWJ20J
         4kCmVzeYr4M7DvwJUrJWxdG6DlAxwQJ1YtSvHLMqldeVc42v/fjF2Iysx60MScXcAyL2
         VUqELjlXHdjXh1aOYx16Ikfa1jWFMcfir92MdwCOVWKL5ONNayFJI6R8MXw6mXMt6PNO
         Xqw78EADAXT0VAeG+7PMbnwFj3es8bi/g8FGD2Nunzy2Hhz7JfWTWpEIq8R6tH7tFuvH
         Qo4w==
X-Forwarded-Encrypted: i=1; AJvYcCVzCUiGWM3yU7QSVLlExI0jTmRT6lYXawNWde+b75gQ76XsUMDMGUDlpY7rBEPt38ik6WuGE4Po4w==@kvack.org
X-Gm-Message-State: AOJu0YyFczNx6jHpfsXRLX7NBT/Csfu4x8zYTgOvgWjI3n5Sqfzy2z0a
	a3Hkw7gxmB4+qqqsGiYIa+zdg4Cx54SfJjqre3/tpZUA/zj3vsH5+uw4LfEfGmkuCKw=
X-Gm-Gg: AY/fxX488QwiFXVQEOFOmLzm8oAZlBrmxssJ6njbVLXPG3b7vqmbk4kshbzzTFa9IN4
	5eFAAt4Hnp/hN0H3kjjkqSYEjzxtnrL9ledgRDNxkYh7Kqwsn0PO4VoAFv16ed2We49I9/8rI06
	LElpOhEUGI/FH/C+MGv5Ze8VrEz+mNk71ABJpj2hR3C7lr0QcXoaTvWhpZYXc4XJWEoIc6hXLSz
	p8QTaNSeLykR8pZkDX2fPNTTi0lyvJYunzgJWFgdvB3Jl2efIMBNprxYumtt7Al4q/2gQBqcfjO
	zUHJFNQEw4OVZhjML/Yy07x4uuULZKevlST1DvrptyHUU/159Rx3cCGgDgs607wFfuUIrqOUooK
	yn1MRhJTx+lp1P+Mn7bDNEZmIIwhyyHgYP2hfN/abxQCMUnsCaNwvBqO6bssLnjoKWMkbF4zs5U
	9DoXedxylts0Fr7CY7Reln7fMo
X-Google-Smtp-Source: AGHT+IHF/ZrwzkXQkFGXwSJeeyzB3kQ8MoRC2nTu2wXkDipm8cdXjLOlcxh6nRuI4cVhlyEpCnkYsw==
X-Received: by 2002:a05:600c:524b:b0:477:bb0:751b with SMTP id 5b1f17b1804b1-47a8f90d716mr159410765e9.27.1765902515830;
        Tue, 16 Dec 2025 08:28:35 -0800 (PST)
Received: from localhost (109-81-92-149.rct.o2.cz. [109.81.92.149])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-430f38d01d6sm21590098f8f.8.2025.12.16.08.28.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 08:28:35 -0800 (PST)
Date: Tue, 16 Dec 2025 17:28:34 +0100
From: Michal Hocko <mhocko@suse.com>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	David Rientjes <rientjes@google.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Mike Rapoport <rppt@kernel.org>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Pedro Falcato <pfalcato@suse.de>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFC 2/2] mm, page_alloc: fail costly __GFP_NORETRY
 allocations faster
Message-ID: <aUGIstlaG_0B7-Ep@tiehlicka>
References: <20251216-thp-thisnode-tweak-v1-0-0e499d13d2eb@suse.cz>
 <20251216-thp-thisnode-tweak-v1-2-0e499d13d2eb@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251216-thp-thisnode-tweak-v1-2-0e499d13d2eb@suse.cz>
X-Rspamd-Queue-Id: 53EB31C0013
X-Stat-Signature: w4zpsqab97xogy569c5k93ah1kxsheb4
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765902517-373175
X-HE-Meta: U2FsdGVkX18zeQAUwhp81U2YXblizk1NThBrgf4ZeWgDHwPffV7D5rCyPCUyEFUgPfL0fq+Fh59Cl+b/MeZ2jC6WEbjxWRqHYCGrsocdqbhzU3sVo7ThgkTmqYQWkBD1Q0uWkaabOYXge8NUdYKmZYQTkuSjHI3/bGhPk6+tfAHh1qjq+WlOt46evZqbCr8B/9Y4xaNvuc6bH0cp/RphtuKS7oC9MtM34sR5p1iUs2Wfdf9DaKE1nuVrqrpcKbK7AxdV8N9ypZwRvZYNFxNkNY9hqkpNMVhm3EesdFYCQM0aukD/jqyg+wM54iVW5KZfHp2NAijIV6o/+VaxuqZmnO16wVDQVnLpBuVoBnf3Jajm5Va75NcW2Hy6U09Tm2nP6RUL2OCcjStwQjPPlMSlfWyqk89BIzYycDmxx+sNRa9weh7Am4wvxxrUtoTrc+DAMDR+PhUOgpRu3i4Mcfk/5MdDXnDibSqHAq9gl8Nbl4VqGCuc+H9sVMpGJB8ZtDtXkxwFCUG/GXK0GRvaTTxg1wKWvKxKsfVNRRkPCjUzl5nPHkg0KN4yxw8sDUVMgmTomWp/VEz6H+RGBXR8hWC+mUXhF68jFE+xgnHRIAFpo+OrqmQuo20k2IKw5b09ACmbBSMS3r6lXp4dWq1yFAOjvmiqOvWnVhGxT9loHp8utWbcGSSaQYeC2M087PSQ5JosEe80K+cPAuZ6usaCfAZe0FWUf0EslM4CaMWj+OLLREJSPru/8UrZvM63B2y8vH+DPq9YzqdaVcB3pdWSa5DtCne5GhJk7BqaNY0LUZ/JTlE1nz4n9TvwoLouX8pDfdB1Gx5WHEXDfR8GR57++7ITb9+vbMrJzdArqpkds5nhfnY1QPxicBvF033Dj0oP7+alA8VtGfnzgSzwvHbFSXCG2bwMV0C/1nM3f5ZJC1Riwzy3UK2WdbH746xSaj1+e7JQdpoofjqxa/ZxOlAgzMR
 957O1NaP
 /95ZwVLj1eGVscqDVaI0K7dL+yqzyRilw9X9WMHk/44lCwnEKMserTwblfZpICHdH0kke/QZv0Cxds0pHgM0pg3JqM7Z0peKyMozIgyKfPwdL9qr8TtSiPe1tuviz1U/tqxrX75qLGRud65fbuRyrQVP6liVJN0a2voK7s+lQYT6qX8QGAsjyNPz2v9jkER27Rz6eUfvRaSmqV6XJTYtLwxxUHBwuQ/eltJVqot05oNQI7IoRM2GJXc+LkBYJc7eBSdo0Ybc3mryusllImib6ZFNTbu7jXCE9uPigOLoW5ToI+zishb3APx9A8Av368vOot66/K9AqGSYLPIXWIwVirjLCzqknEIEYVTiZIMrY+UmXGg+DQ05FcHghZCg5GAgXJFE+8d89dq7i6511KyAlb8G5zAvgo0DeBWkw2ozo3w3vSCCo+q48TaazwuRm2508euzOyASs0yUo9pwOR4tTBWIFN0yyhBeL6epEtIM5VuLQKnZBzk9Kby4LJaSy7hONxZEjtH2sjxCVzxBT7j5pjfdTQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 16-12-25 16:54:22, Vlastimil Babka wrote:
> For allocations that are of costly order and __GFP_NORETRY (and can
> perform compaction) we attempt direct compaction first. If that fails,
> we continue with a single round of direct reclaim+compaction (as for
> other __GFP_NORETRY allocations, except the compaction is of lower
> priority), with two exceptions that fail immediately:
> 
> - __GFP_THISNODE is specified, to prevent zone_reclaim_mode-like
>   behavior for e.g. THP page faults
> 
> - compaction failed because it was deferred (i.e. has been failing
>   recently so further attempts are not done for a while) or skipped,
>   which means there are insufficient free base pages to defragment to
>   begin with
> 
> Upon closer inspection, the second condition has a somewhat flawed
> reasoning. If there are not enough base pages and reclaim could create
> them, we instead fail. When there are enough base pages and compaction
> has already ran and failed, we proceed and hope that reclaim and the
> subsequent compaction attempt will succeed. But it's unclear why they
> should and whether it will be as inexpensive as intended.
> 
> It might make therefore more sense to just fail unconditionally after
> the initial compaction attempt, so do that instead. Costly allocations
> that do want the reclaim/compaction to happen at least once can omit
> __GFP_NORETRY, or even specify __GFP_RETRY_MAYFAIL for more than one
> attempt.
> 
> There is a slight potential unfairness in that costly __GFP_NORETRY
> allocations that can't perform direct compaction (i.e. lack __GFP_IO)
> will still be allowed to direct reclaim, while those that can direct
> compact will now never attempt direct reclaim. However, in cases of
> memory pressure causing compaction to be skipped due to insufficient
> base pages, direct reclaim was already not done before, so there should
> be no functional regressions from this change.
> 
> Signed-off-by: Vlastimil Babka <vbabka@suse.cz>

I like this because, quite honestly, us trying to over-optimize for THP
(which seems to be the only costly allocation with GFP_NORETRY) has
turned out quite tricky and hard to reason about. So simplifying this
wrt. to the compaction feedback makes a lot of sense. Let's see where we
get from here.

Acked-by: Michal Hocko <mhocko@suse.com>

Thanks!

> ---
>  include/linux/gfp_types.h |  2 ++
>  mm/page_alloc.c           | 47 +++--------------------------------------------
>  2 files changed, 5 insertions(+), 44 deletions(-)
> 
> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
> index 3de43b12209e..051311fdbdb1 100644
> --- a/include/linux/gfp_types.h
> +++ b/include/linux/gfp_types.h
> @@ -218,6 +218,8 @@ enum {
>   * caller must handle the failure which is quite likely to happen under
>   * heavy memory pressure. The flag is suitable when failure can easily be
>   * handled at small cost, such as reduced throughput.
> + * For costly orders, only memory compaction can be attempted with no reclaim
> + * under some conditions.
>   *
>   * %__GFP_RETRY_MAYFAIL: The VM implementation will retry memory reclaim
>   * procedures that have previously failed if there is some indication
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index e6fd1213328b..2671cbbd6375 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -4763,52 +4763,11 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>  			goto got_pg;
>  
>  		/*
> -		 * Checks for costly allocations with __GFP_NORETRY, which
> -		 * includes some THP page fault allocations
> +		 * Compaction didn't succeed and we were told not to try hard,
> +		 * so fail now.
>  		 */
>  		if (costly_order && (gfp_mask & __GFP_NORETRY)) {
> -			/*
> -			 * If allocating entire pageblock(s) and compaction
> -			 * failed because all zones are below low watermarks
> -			 * or is prohibited because it recently failed at this
> -			 * order, fail immediately unless the allocator has
> -			 * requested compaction and reclaim retry.
> -			 *
> -			 * Reclaim is
> -			 *  - potentially very expensive because zones are far
> -			 *    below their low watermarks or this is part of very
> -			 *    bursty high order allocations,
> -			 *  - not guaranteed to help because isolate_freepages()
> -			 *    may not iterate over freed pages as part of its
> -			 *    linear scan, and
> -			 *  - unlikely to make entire pageblocks free on its
> -			 *    own.
> -			 */
> -			if (compact_result == COMPACT_SKIPPED ||
> -			    compact_result == COMPACT_DEFERRED)
> -				goto nopage;
> -
> -			/*
> -			 * THP page faults may attempt local node only first,
> -			 * but are then allowed to only compact, not reclaim,
> -			 * see alloc_pages_mpol()
> -			 *
> -			 * compaction can fail for other reasons than those
> -			 * checked above and we don't want such THP allocations
> -			 * to put reclaim pressure on a single node in a
> -			 * situation where other nodes might have plenty of
> -			 * available memory
> -			 */
> -			if (gfp_mask & __GFP_THISNODE)
> -				goto nopage;
> -
> -			/*
> -			 * Looks like reclaim/compaction is worth trying, but
> -			 * sync compaction could be very expensive, so keep
> -			 * using async compaction.
> -			 */
> -			compact_priority = INIT_COMPACT_PRIORITY;
> -		}
> +			goto nopage;
>  	}
>  
>  retry:
> 
> -- 
> 2.52.0

-- 
Michal Hocko
SUSE Labs

