Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86589FB44C4
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 08:20:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C924F6B0005; Fri, 24 Apr 2026 04:20:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C43CF6B008A; Fri, 24 Apr 2026 04:20:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B58FA6B008C; Fri, 24 Apr 2026 04:20:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A33FF6B0005
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 04:20:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2636A1408A5
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:20:33 +0000 (UTC)
X-FDA: 84692752746.12.0F5385F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 90A6C80006
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 08:20:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mOMKksAU;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777018831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IEwVWEzE2Dj0wHkg3NnVA6TubIBJog0kwGg5D1sN2jg=;
	b=ITdYNn0xArAHfV2Z/YrqDddA7zn5JR3JNSB3XpZ7ZR1lN/nY5qQVW0ZNUKv4v13ih1rFLE
	sJAcJB7AbXNPF/ITnCU8rVmkC2BcXR9U8Z+qpNI0CNpm0XZLrdE3VJpJy7WAZdEkR5sEgk
	fvs44K6dwUk5Ere1CaXasiYHzK0o2Mo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777018831; a=rsa-sha256;
	cv=none;
	b=rhZjawEsviNhwZp0zMK04re5vwojHa0azlJZ2WsuCRFC3KCPgZ8m1DtgPcV+45oDWqBhW1
	eI6AFF38kBjTIjZkqV2F+DIdI7flxDq2zJOq13dwQtpbnTnqTXkr5gdGyG1oKgi/4277DV
	x0N/O9G9d/b4vVPohrTM0egwnh111aM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mOMKksAU;
	spf=pass (imf30.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E24046001A;
	Fri, 24 Apr 2026 08:20:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68013C19425;
	Fri, 24 Apr 2026 08:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777018830;
	bh=Rv6jBW9C6+YIR0iVvSndpiy1+KRdv3tYvLeHDMmVn0c=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=mOMKksAUWZvCKb8Ojm6kYghsEM28I/Mztw1a92GaD+6XofYQMD1pQHKguAWOCnWjB
	 mTCyWZ3OkABdRLM9eSm+SbbPUvMy2otzMEK1ea5pHoNTIwmN90fPnX4+fAc41Z7+g8
	 QjLLsZLJEJfajKQorsSixJXC+QFFbdXKzmcVZXz68mssOqhvNN/+zrqCUrmfPet45f
	 Q7yhOOr6zoUcXl7tErxPsUGjWtZ5bDM/D/3/qNHD/2j09YrukMF1PMHi8WLDddOZgk
	 jGqxoyyzGn8vdvAf3mgz3hXtt5u+ISYKkrx106+Dc9WhXMb5NeUdq+P491a72duOd0
	 kyqvtA1rMJUCg==
Date: Fri, 24 Apr 2026 11:20:20 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>, aneesh.kumar@linux.ibm.com,
	joao.m.martins@oracle.com, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v6 6/7] mm/mm_init: Fix uninitialized struct pages for
 ZONE_DEVICE
Message-ID: <aesnxK_Use6wrCfE@kernel.org>
References: <20260424025547.3806072-1-songmuchun@bytedance.com>
 <20260424025547.3806072-7-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260424025547.3806072-7-songmuchun@bytedance.com>
X-Stat-Signature: bjb49pwitrwhkmuijqmdxgpuqtgj5iuw
X-Rspam-User: 
X-Rspamd-Queue-Id: 90A6C80006
X-Rspamd-Server: rspam05
X-HE-Tag: 1777018831-917689
X-HE-Meta: U2FsdGVkX1+WTfo3pwapdD28eTHgbiw9qg0EJyfmHnCdkupwqDP0Yp9NuX6vpl032hKratQTZjQB5usZsmpkp4NEbNJQPphi0P5xKTF1YJhkORsZkmREUC5W+61qMPHQpu1G5CMaIAmtRDWGVXXD8OhGz0iCCGzU8naceCDbJodEbQj/lJgPalGgu0un0fpNL+x925SdyjDz4NOsjv7YHzoOiurQNCNj1KxAujwc37G86N750s5PJ9epIKTuJ6gZN/2gVhFWW/G2Am4J7rZ4z1RhL0uVrkF564A5p65zqRJX3f8fdySJEvb3S1kfQvsp+DjF//tJjROhI2cArZfGoZJXO1HfmAz672M8z/SInZ3R9pV63JH95ZbAOceYHrvMbr6NI147ZZTRNwwZEk0FaIUahnyqhrr1zTym0gUABAAAneB1qB1cn2EwEoQk+1s3wnuLA0SXi6VAZS2K5e/jrZaIf55/hNlTvEs+qGhjspxlgSQl980miIaz/FD5eNLRKQw2fGneF9BZHSymD3VwMoEAFPipCL/4+GVH2BO6Zyd5dRYAsOPJzAohuCfrfSm6LVa0bCUN3bL47rLVo5CzmyADw3Rhoyg/9WTBatwPoPC9arFuIXcH6hCEldicJ8uykeZIhd2gnID5xEfEIeUkIAFHrwgH/TMlW5+9eOL2Q+wqTPUBAMoHKYk8pyN0IK3gI85BNwLbDvcxhi8TaRNlmzL1MNGVnaHDYldJqzdwIshEim9HskpDBXB3thFksAPQB5pVqaCXEK1Zwv1CI0MVmsFBkkfOEnzL/qUbEsaxIkccE5Ve2WKLrT8XwYDUuOqQgL0YYqR3vt2a4jcPnQmbZDKgbmzAEGUZFy1oMs353vLBJ/Ggbj7oiM+74poZS2mQYrGM4seoxT4uz4aH6zvM77KA27+a66cJV2H63ZAWeXH4NRU6caZ0gl8e6S+0d0ef54QlFA1fHtYUCOfp3t2
 FWX95g7U
 RMr6SQenLALetSaEujjYk6D3vk9bzjPwrxlxRYaqWeB9nozIGfCUMWghpWF8CZ/ls4k2A553QvrrcJJFqeDhrhWV4rFVwDVSTXCnY3dgHlcrjLqyGBPjYGLthrM3K1R6VBjky//3kr9uqspzfQGyshinMYl5Tc/Zqr2TkFWSNDaUvJsBq8Pu4xp1EowqaYyAGrX6JrYY+ssVho/ea5mH3EW8foKm0ibjC3PYS6br2QvT9k7yJyl/VvHPm3jBrp9Bg0tledKpJAVDDiMKAskCcfSR/c+GfFrdyTDMWdZ7WOb0z1MxHzH5hHL61NHjqYgilC9LuKcBrskf5u6D4194bwrhDFUe+VD+IjAre
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 24, 2026 at 10:55:46AM +0800, Muchun Song wrote:
> If DAX memory is hotplugged into an unoccupied subsection of an early
> section, section_activate() reuses the unoptimized boot memmap.
> However, compound_nr_pages() still assumes that vmemmap optimization is
> in effect and initializes only the reduced number of struct pages. As a
> result, the remaining tail struct pages are left uninitialized, which
> can later lead to unexpected behavior or crashes.
> 
> Fix this by treating early sections as unoptimized when calculating how
> many struct pages to initialize.
> 
> Fixes: 6fd3620b3428 ("mm/page_alloc: reuse tail struct pages for compound devmaps")
> Cc: stable@vger.kernel.org
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

> ---
>  mm/mm_init.c | 13 ++++++++++---
>  1 file changed, 10 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index cfc76953e249..bd466a3c10c8 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -1055,10 +1055,17 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>   * of how the sparse_vmemmap internals handle compound pages in the lack
>   * of an altmap. See vmemmap_populate_compound_pages().
>   */
> -static inline unsigned long compound_nr_pages(struct vmem_altmap *altmap,
> +static inline unsigned long compound_nr_pages(unsigned long pfn,
> +					      struct vmem_altmap *altmap,
>  					      struct dev_pagemap *pgmap)
>  {
> -	if (!vmemmap_can_optimize(altmap, pgmap))
> +	/*
> +	 * If DAX memory is hot-plugged into an unoccupied subsection
> +	 * of an early section, the unoptimized boot memmap is reused.
> +	 * See section_activate().
> +	 */
> +	if (early_section(__pfn_to_section(pfn)) ||
> +	    !vmemmap_can_optimize(altmap, pgmap))
>  		return pgmap_vmemmap_nr(pgmap);
>  
>  	return VMEMMAP_RESERVE_NR * (PAGE_SIZE / sizeof(struct page));
> @@ -1128,7 +1135,7 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  			continue;
>  
>  		memmap_init_compound(page, pfn, zone_idx, nid, pgmap,
> -				     compound_nr_pages(altmap, pgmap));
> +				     compound_nr_pages(pfn, altmap, pgmap));
>  	}
>  
>  	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
> -- 
> 2.20.1
> 

-- 
Sincerely yours,
Mike.

