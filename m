Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6C4BC79FAD
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 09:56:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B811C6B009B; Wed,  9 Sep 2026 05:56:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B57FE6B009E; Wed,  9 Sep 2026 05:56:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A6F2D6B009F; Wed,  9 Sep 2026 05:56:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 809BE6B009B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 05:56:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 97458160155
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:56:23 +0000 (UTC)
X-FDA: 85193768646.03.01A17BD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id BC8FEC000B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 09:56:21 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KNEgf5mw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KNEgf5mw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788947781;
	b=umbOkLgDe60fay0MOhj7Dm4zAnh8jo78ih8m6f4LIKm70nlB5iocUI4MiPOa0Z0iXTDoX9
	QXLIUTTQbjqt47SjPUn4UYYClfSsh25/ZdljWpd+++WjnJlZQ+LDHaZgsr5PFAUjXEcPh9
	xwMsulkqrmrihAUHk67/Jbu28q84efA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788947781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ByKpa3vC0eC5ZuBtQYhI31h+rDqEMFcUW70pnZTcQhY=;
	b=pR5BUMpqfFzQ7YRqhjx0D0o3mHJNlQoq4t8RA+Ggjo1Z6AVsLVp/8aefwPI33ky6VvbRes
	/uSl+zRJcVIBOFU0Q+fFXcIK1aEFr06cw5LDG1wdAgJn4JKO3xuGS8OrOQCtGiYuUwFEen
	YTr0/oWj1e5Nc5n+hITgjecwHdO2gHI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 962CD4353A;
	Wed,  9 Sep 2026 09:56:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40CBA1F00A3D;
	Wed,  9 Sep 2026 09:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788947780;
	bh=ByKpa3vC0eC5ZuBtQYhI31h+rDqEMFcUW70pnZTcQhY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=KNEgf5mwgM8CxhI5IANttxJV2blzsgGI6l5uqybUi5NYt6gaDzOWGl2Dg9RMMLgE5
	 fytqZ2nxAvUTdgQuLelPTbAZgc1XjHLNVTQ7pO1JuizKM/dc6XC+t1ev0Bcy1eQ63M
	 5IG4lis2yjJMRvwt1T0h8Dc2i12Y6VN8i8tvb5yi8diRdsf1gXGBHHTG4NPt2N0DpL
	 POnHVDw2Mh620IUZOfsLcmFKY0/9+Z1Y3ghPiBj+VSXeewELZvZYmbgd1ituFFParz
	 v+3CpC7sKI7vbMqle+Xq1s6dPpMnYsPe3uL54chp2Uyt78nzn6+e0pO8aLgSzzy+n2
	 lnVRnnXJsG9yw==
Message-ID: <a2016390-28ce-4199-a063-d2e9101dacab@kernel.org>
Date: Wed, 9 Sep 2026 11:56:15 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/17] mm/sparse: initialize memory sections earlier
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>, Oscar Salvador <osalvador@suse.de>
Cc: Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 "Liam R . Howlett" <liam@infradead.org>,
 Suren Baghdasaryan <surenb@google.com>, Qi Zheng <qi.zheng@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Muchun Song <muchun.song@linux.dev>
References: <20260825084608.47437-1-songmuchun@bytedance.com>
 <20260825084608.47437-10-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260825084608.47437-10-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: BC8FEC000B
X-Stat-Signature: fo191pcteo4wpqc7ujrdu8eckh7qi5wo
X-Rspamd-Server: rspam01
X-HE-Tag: 1788947781-278634
X-HE-Meta: U2FsdGVkX1/W5lA8tS/frJ/UPJzS/X8Pk/OUPP9i6SHD1yQ0DrXPhp/Rs6DKJ8C/ZA67axd5TrF+ktCuNZEF0ONP1VeS2xFeoMehHuUD2vpAv3fZ3167LitqJX2qEQVbXFNOGTRkmfZRh6yrqXq81CDsoS8GItJ1XkgfPJ1V2urzaYOKalfULvShkhDHNFOJiI95ffmJYR1OBckbGB6z9luBp3yezn2JBEstU16j95wnFCeJhUuFZJDES5fks09dwK8uYMyM1k31zavYa0Rq7A8tfhIjnODV9lKsliEwHNX1JHl/8DL6aDYaaDMTIU/Jws2zuvYCgduGVOf+ujwqCqO/5KnYk1R9yroaDF5aBe0xXEa4SYMrTZKZN8Uyp6yoAF8f7eICBsNrSbCQKe0zVwsZHWRJjSPiZECUn0hDxDSKQLlRhvlU5vEPzXiHT7L0XgrDdq/r2DE/avrud2MMQaz63lRPduH5p77cH25UjhNkD88WDJuB7Z1DyWdzuBaVQldMvwoPe5mi3MkRLrW8RhKBZhnLRUavb3oMW2SnoyANAncQYeI4joabnvFZRzyIJeIxTcV+s3nw1Zc6kF7UT3Ak+YXOo44BQJWeRXLc/IxAlH44rhbdQqFzYbAAjMaInOsd9goikGa0D1NcppqpFSZiQ0h7bpwEErwbobWEYk6dTCmVzQRbXGkk8EIoDAo8tm1zORVf6C3lVagGX9UC5P0IGqYqiBIkXegKqFING/qGXd3/I1PtMHO95/nM2fC70d6rFJnxMK0jvy9Iz5Ng1QG6EhEpwy+pZxAcyhI6i0mOISeFBAQObJ5xRw2IyXeKkEjC0awISmie/4FKCLs75m88UeIPrRIEVKRErjWXPfINoDm42q2P86qqfc9TtHoLweQwXcIlcFwAuvWb9Vx1isRaOXs7fN2K/1/+aPR8cy6aDl4oaMHhBBgwZsrOB/XVcDoD270XD3r+9tnBkSu
 tuEEUOQV
 XhSInkFKMyKg1paiGXOKEPFhlmApqAq+/Z8QKhVSDdK78z/wHmDWAyTRN9JRsa5Ag34SYglQdWtzRUFBm9eIYESc46WjrDM5spTBJ5uSz3NkZYl/WLbMW0BRpoxcIvXd5msiw8PGS70xEICjCQj8cs9Dg6lwXAV6Bsb/NnffUXapBikhlnIig4IxlVVgHgBy4qrMcHpUBqbwSe3qhyiM0L127DBpoHanabx7FUUHiEw3wX86NleCdRsoQENT4z2Az+G19I8YHoJUpadRtaa6w+UQz6LDJ01z1kKCJ0UJM3PkATjQTZ/TQmbqsUMBVQUup8DEd2Da2L96+Mlzo0aM6nWUcPyfPigueJG0yS8uhAjoDV+s1LUO6xe1xB8HIV8iAajHA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 8/25/26 10:46, Muchun Song wrote:
> Upcoming HugeTLB bootmem changes need sparsemem section metadata before
> the HugeTLB bootmem allocation path runs. The memory sections are
> initialized from sparse_init(), which is called too late for that setup.
> 
> Move the code that initializes sparsemem section metadata for memblock
> ranges into mm_core_init_early(), before free_area_init() and the HugeTLB
> bootmem setup. Rename the helper to sparse_sections_init() so the new
> caller describes the sparsemem-specific initialization step.
> 
> This is a preparatory change.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---
> v5:
> - Collect Reviewed-by from Mike Rapoport
> 
> v2:
> - Rename the helper to sparse_sections_init() to describe the section
>   metadata initialization (suggested by Mike Rapoport)
> - Fix the !SPARSEMEM stub name so SPARSEMEM=n builds compile
>   (reported by Sashiko)
> ---
>  mm/mm_init.c |  1 +
>  mm/sparse.c  | 10 ++--------
>  mm/sparse.h  |  2 ++
>  3 files changed, 5 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 0317fb781e77..e2a16d833635 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2642,6 +2642,7 @@ void __init mm_core_init_early(void)
>  {
>  	kho_memory_init_early();
>  
> +	sparse_sections_init();
>  	free_area_init();
>  
>  	hugetlb_cma_reserve();
> diff --git a/mm/sparse.c b/mm/sparse.c
> index e6cb67ca9c8d..439802e6a6ad 100644
> --- a/mm/sparse.c
> +++ b/mm/sparse.c
> @@ -191,12 +191,8 @@ static void __init memory_present(int nid, unsigned long start, unsigned long en
>  	}
>  }
>  
> -/*
> - * Mark all memblocks as present using memory_present().
> - * This is a convenience function that is useful to mark all of the systems
> - * memory as present during initialization.
> - */
> -static void __init memblocks_present(void)
> +/* Initialize memory section metadata for all system memory. */

I'd drop this comment, it's not entirely accurate. A lot more initialization of
the sections happens later.

What this function mostly does is

(a) Allocate sparse-exteme metadata
(b) Temporarily store the nid and mark the section for being present and online

I have patches to get rid of __section_mark_present() and just set them all to
SECTION_IS_EARLY|SECTION_IS_ONLINE such that we can just iterate early sections
and get rid of that PRESENT monstrosity.

Apart from that LGTM, even though I don't particularly enjoy splitting us now
having two init entry points

sparse_init

and

sparse_sections_init


Where it's rather unclear from the name what is actually happening.

-- 
Cheers,

David

