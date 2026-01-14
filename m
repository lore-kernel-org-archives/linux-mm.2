Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2FE0BD31A16
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 07:19:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 944EC6B0089; Wed, 14 Jan 2026 02:19:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F2646B008C; Wed, 14 Jan 2026 02:19:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8244E6B0092; Wed, 14 Jan 2026 02:19:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6F6586B0089
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 02:19:09 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 03A7C1B921
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:19:08 +0000 (UTC)
X-FDA: 84329718018.09.189F671
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4034EC0004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:19:07 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PH4+1cFm;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768375147;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FP4dwboDHq4cBs/tBe9qEA5HOUnAOHiZweMLLzmvIIY=;
	b=xjoOVgeSPGd2PqoRqB2ItmmPQiBfELebnMdk1yL89zx5DzqPItlWHSWMYKqivpbVJdFpQM
	e9vU8yTSOmLkrEjR+9/ohlQ51axRrzpnkocV4VRzBdsL1iafgJeYHwm4Jd2WwQCEqNj2lm
	A0OgzOgfocGKkgDzhocqUcwkmv7UOoU=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PH4+1cFm;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768375147; a=rsa-sha256;
	cv=none;
	b=Ygos0NOs2Ln7xUbswrxn9BLVIYB3n6yG1+1DNAe2AC9ulm7YmRPWFKRkppeCwXwiJkP4fB
	FvzuRm6BPqiri4h4b1MvhTBnLGQvDMNCwXpBTzvoI1WnPIa3HTP8SapAvqGpmHb29/Ngmd
	DNVFvR99TUZHDk/HJqQqPEK68wiQNnM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 225D643E4B;
	Wed, 14 Jan 2026 07:19:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 383E8C4CEF7;
	Wed, 14 Jan 2026 07:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768375146;
	bh=hVqqVaXS0GeC6kx6LwQASUNzGa6n/+1fT3TSbae2KTk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=PH4+1cFmqZ/jJP7uMNmA5XJANrv6IfwGkL1odjcuxuUkQH9mSNFKVFN0GFtw+IZzG
	 wUxxpTxKqddekHhX1oGIfA0PqGMsDz/HIRRQf7DVPy8ESy1k9Tsb+5c0D6deWnCtTh
	 /fNTtBtldbwUQ+3KIYsoJOV9AHo7mILOA29PwyD2GM2MyZVMDv/4vF38bqBfJCe6i8
	 UtI9kLeHLKePSFRKLB21jcvoItIYLKWGXQWvWISsGJtrJiLNxtyYGwWZcGT77xJIhW
	 NDl/3azjt90J7Gaiw22jkjmdLyDZunupBZMIeQLkb12D3L6DV6T5XfGA1HsFRDbimY
	 RSq5bunYFIMyg==
Date: Wed, 14 Jan 2026 09:18:56 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Robin Murphy <robin.murphy@arm.com>
Cc: m.szyprowski@samsung.com, akpm@linux-foundation.org, vbabka@suse.cz,
	david@kernel.org, bhe@redhat.com, iommu@lists.linux-foundation.org,
	linux-mm@kvack.org, vladimir.kondratiev@mobileye.com,
	s-adivi@ti.com, linux-kernel@vger.kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
	surenb@google.com, mhocko@suse.com, jackmanb@google.com,
	hannes@cmpxchg.org, ziy@nvidia.com
Subject: Re: [PATCH 2/3] mm_zone: Generalise has_managed_dma()
Message-ID: <aWdDYFkTeOqOnbWD@kernel.org>
References: <cover.1768230104.git.robin.murphy@arm.com>
 <bd002d2351074e57be1ca08f03f333debac658fb.1768230104.git.robin.murphy@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd002d2351074e57be1ca08f03f333debac658fb.1768230104.git.robin.murphy@arm.com>
X-Rspamd-Queue-Id: 4034EC0004
X-Stat-Signature: o5ux7nkz4dbkf8paurwagysrb56etqbz
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768375147-485831
X-HE-Meta: U2FsdGVkX1/o+DirjQmHTPtTjlrRNstwqFBdE8TcjAVAMAR9VuGM2swz7Y/J7H7k9zKequJrxVETpSUy5OQZRTCJVFhD7bSmhQTLQv0suY/UgfHY9OceaenFP4/lApPJo9lZS1k8CqHE8soIqcq23/v6phySSgPjBkU0+0zyYf7/MwCoo75stC3wuU6XnWmgWWgpIKLJ1Uaw2mVWdAg1ocYvO0VBI/HxasiIv36g+0ycP/SiiM6nxQ3z72vDpBk1/Xt1xGN3yNdagQ+DTdLeLtYuY/tZAZWQWCVRB7oEITX/y4m71s+KK1Yhzd98Mc7afPgDpBDjdgc9DXz9DG7LQO+TVnOtKTujKRIQGxrY6ZCumzcxf6Q0Tv3D42PN3AlKnBxg05t+wlkZw8ungT1gwrb3Y2GRm2vBOCtazCTUj+mUIr9md8aBrmb5t7gVLwyeGjreeMOiHFtrtGr2b6SANBzfaIylqNjdu9NttjG6PSx5g3tmPQeKO3OnBw0OmZF24FKHXDl+fcm3GkgDpC2jzEI0AHeWU6pA7gKESwQ4xcKYk79pNEubpCvVxgNgeyq2TDeH/t/jB9/StJXFWAPwE79hbnyFBgywg9SJ8e7wZaCB4p4r4LL8rzGlmcvI4EJsaX244oFSYHOgeT38TYycE+tCpeh67tolXk9IZ4R0H2UmapGs/OtU7SN94it+VtyRJfKuKLr9AWQjYBOjj0OqiVAnCIF/kMNoiJl5+uJyD5uBKGwmDWAfK3AgF8SFu5eDrLrPV15Fe3AFE7v5h8O2OayEgCpXiWNBQa5QbL9JWSBkb2YNCmLzVLvNsw3RMI6Lldt//p3w0u+dHtBuBe2YoBU2ZoS1MkiJbU0xw/Ta0jf5/PNxA6Gkz8EJZdGDI744U57S8Wz6qBID26+1Bz9nSdjbVHpz+E3SQ2n4dgsmQgr6QOJZ1QauKV2RpYpEowr9E1BMV5MkKghdYXGEzuM
 aQRlQ5TF
 M8F8iYueJuI90YiD3W0ctTC3zX49hIytrXGxo13Nptt3hEDRKoifwUkZBVd3Ctp/oSZDnkPlGZFpCLSyfgrYF8bgpLrcDhqB6Kn0z4P+wyA30hFkgYW405DgX8U3FDPQK3nOOH68aOI3cbo7MRBLWXTSC8nt0YVvFBYKQdKgCK8p4qgFXdJ6I3jvbGUqV9QAJ9o3Pm4TxUJkBjWCSo0eCT5wwjTy8zzRtYp+3cBsWYyAq1dMNnOp12oUdr0FYjGBCVLpsTPpFY6w6a03cUdA0/uECscFQnk+W0HHwem2QkmGLamKCjchkM3jJshJVf4udooHb5OLemr9lyVU3o4FzwejhKMWJ/NSSzC5BykK3ONArvZWAPFwQm1mwx9dZ9G4mpnSD
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 12, 2026 at 03:46:37PM +0000, Robin Murphy wrote:
> It would be useful to be able to check for potential DMA pages beyond
> just ZONE_DMA - generalise the existing has_managed_dma() function to
> allow checking other zones too.
> 
> Signed-off-by: Robin Murphy <robin.murphy@arm.com>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  include/linux/mmzone.h | 9 +++++----
>  mm/page_alloc.c        | 8 ++------
>  2 files changed, 7 insertions(+), 10 deletions(-)
> 
> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
> index 75ef7c9f9307..fc5d6c88d2f0 100644
> --- a/include/linux/mmzone.h
> +++ b/include/linux/mmzone.h
> @@ -1648,14 +1648,15 @@ static inline int is_highmem(const struct zone *zone)
>  	return is_highmem_idx(zone_idx(zone));
>  }
>  
> -#ifdef CONFIG_ZONE_DMA
> -bool has_managed_dma(void);
> -#else
> +bool has_managed_zone(enum zone_type zone);
>  static inline bool has_managed_dma(void)
>  {
> +#ifdef CONFIG_ZONE_DMA
> +	return has_managed_zone(ZONE_DMA);
> +#else
>  	return false;
> -}
>  #endif
> +}
>  
>  
>  #ifndef CONFIG_NUMA
> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
> index 822e05f1a964..36ccc85c5073 100644
> --- a/mm/page_alloc.c
> +++ b/mm/page_alloc.c
> @@ -7418,20 +7418,16 @@ bool put_page_back_buddy(struct page *page)
>  }
>  #endif
>  
> -#ifdef CONFIG_ZONE_DMA
> -bool has_managed_dma(void)
> +bool has_managed_zone(enum zone_type zone)
>  {
>  	struct pglist_data *pgdat;
>  
>  	for_each_online_pgdat(pgdat) {
> -		struct zone *zone = &pgdat->node_zones[ZONE_DMA];
> -
> -		if (managed_zone(zone))
> +		if (managed_zone(&pgdat->node_zones[zone]))
>  			return true;
>  	}
>  	return false;
>  }
> -#endif /* CONFIG_ZONE_DMA */
>  
>  #ifdef CONFIG_UNACCEPTED_MEMORY
>  
> -- 
> 2.34.1
> 

-- 
Sincerely yours,
Mike.

