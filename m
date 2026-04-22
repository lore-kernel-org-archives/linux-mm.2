Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E2261FA1FE3
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 19:03:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56EAB6B0088; Wed, 22 Apr 2026 15:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F826B008A; Wed, 22 Apr 2026 15:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E7596B008C; Wed, 22 Apr 2026 15:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2755D6B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 15:03:30 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B32AC1B75DE
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:03:29 +0000 (UTC)
X-FDA: 84687115338.02.0EB9114
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id E2B33C000D
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 19:03:27 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BOzDZ1C5;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776884607;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CEaWsbQrJvSk/911kBqo5YudSDmXcxCu82kwMtkWoUo=;
	b=DAYExeELHizkrmdlrTneeHEPtBh4spQocN14He7ykzLCteI/FIs/+rl2kTJbKSKOTix+uS
	ZRmXU9AcBOcK4hzRrt4iXkP4XUGRcIjj85fQfyTtJv+jTnucbDWj1jB4Ymm7tOwMe/zzKv
	bz9IGQEM9L1KTWaWfqxVN92BCfD/k9Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776884608; a=rsa-sha256;
	cv=none;
	b=b1k2fB2NH573aS+ufkCYUBijbeRbxpkG2EmpfrAs3DqRMEHyOl/7m4RtvkgvX2Lq5t4HZo
	azbCPTscuafr8RgG66PNJuAcXrGc7eJXkSmLFZxe7kD1WPThvhbBm+IL6hoXuZo3ozuvPR
	D5Mad7U07CeqD72oFFzNMZslSqQfxYw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BOzDZ1C5;
	spf=pass (imf22.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 20D0861868;
	Wed, 22 Apr 2026 19:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B9CC19425;
	Wed, 22 Apr 2026 19:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776884606;
	bh=7Y3OgaV9t+Pb9LH2uQohBSE5AYWE9s5cd0J/voxeBWM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BOzDZ1C5pt/R88NEe81p72strH0ZOBDeY1A9a4C5oAJDK2Iwha9ZkkalNvl3mQS2c
	 n2knUAp+YKEwiq6VZMi1VL+jHrbrlumjNI9Fs/3U3tpUDnVI4xboP8MHJu6fYiKeum
	 ASU2wJrZdn5kd03g23OmyLYM4ySJPohWnn7GrO2Qlwp6kkMsb84ubW2D9WmiLWyNMC
	 wUaCL3WpiP/C8rp7GCTXHhS0HZ3sQ+omQFSJw+95X0AeQx9C7TuD7+anFzdFF4Pu1x
	 rJxeD/WdFMIxFh3ohu3WBjoD6+E24Zkf62Qm8GHdPeY/oyjJvXfZty7Nlg7xkIainB
	 s1WQ0yCbeCqtQ==
Message-ID: <95d59eee-a4fe-4d11-b335-07f3b3ef2e66@kernel.org>
Date: Wed, 22 Apr 2026 21:03:19 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 4/5] mm/mm_init: Fix pageblock migratetype for
 ZONE_DEVICE compound pages
To: Muchun Song <songmuchun@bytedance.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 Michael Ellerman <mpe@ellerman.id.au>,
 Madhavan Srinivasan <maddy@linux.ibm.com>
Cc: Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>,
 aneesh.kumar@linux.ibm.com, joao.m.martins@oracle.com, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
References: <20260422081420.4009847-1-songmuchun@bytedance.com>
 <20260422081420.4009847-5-songmuchun@bytedance.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260422081420.4009847-5-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: izmukcbeiydiruga53kx8rdafd8zjaew
X-Rspam-User: 
X-Rspamd-Queue-Id: E2B33C000D
X-Rspamd-Server: rspam05
X-HE-Tag: 1776884607-589046
X-HE-Meta: U2FsdGVkX1/rn6tku7VqB+HR4GBMWetP2gbIxpfpsDMYz+Ek1Wjt7oz4yMZSXznPsZpmt2ln3IgMnrdZLEYZamVC3orb9CKAmCTLSe9r8hDZ6fJKgd7yA9bHeNB99qNVJnn4KDnyMLD1s3RAtsZISGRIF1ozdyYsLTSyXPqVtw3lkAa4PTMdn/2Rk9fC1VhrYGe8rXhG50txXEa3n+ENDmUoaN2Hagy2rUnUngpO9SfIbn6ImUxZbhTUt8zVQEVVuDOWCeei78NxO1yE2V+XxBIvFuBrBLqUXZpW9IhEqzjpMI+jaUB1WkrewUGPOTVD4/SgliWsrvVrF5nD3p5uO7lAWLoCt1iL+2c4qL99E2qAEwq3dAe4s3DKkvTPElJt3FaDQn5IlzqZrWjFDGcIebOVBLD7vUFK688M+GhZ6sDVN2pwRAS5a1+78YkY3GQk8Ce+P6brB9TtNx51Dy/zpBy10OMvwnQjy0GMI9IPMh+9K6lIi6y8u2bFFtrExJzW1jBcIqsRbnxl7OOq/YS4on+HzfO/g0akAcZYfvOj1khIPyRlvkl5K+79IjCNezxKRVcQfEvgZGM/cVTwZxhkixlUhh7F+Ic68hrsbwErHpWp89ye2f9tXsSGyld3fBJjD/kepU/s4/VMiNQwWDxjt5LlLgciK+vK5eEQd0r/HJs9zoTtZMBow/Y54LFIRzX9yZvT/fzwhuwKBvmUGPe9DaiLZsF+XFJyyuopaqSjYq5l4RWBsXmZWEUqWnDonDgZLy037E4TQbNfHY/m8STN+y+gRqsKi/R49zEJlJOGtkxDNF1uLa2kyCQDBsK73o8q6SweHOStE6ws+gYJcCDzwZVV65FrU5z/+r3cb401HTCnzNJDjBUOZKJmEaFUIWHLgGoMDShTyoYPS9hNvmwlXl+Zc6QoFeWRPfqu3HUoIZHF/wkXobjC3L3DKP+7R5Am0ZlkP501m/kq7ai/H4k
 RHyNOPuu
 G11rzT9F6NNemuaqFwz9grJq9kwyyPaqIWoMXFmvWJ4raRP5iaSF96HBysC1ZD375w9Kgl8Qq5rmrE2EtKVH3fUyqEs7vOfP7jaTsiqWDFXGTEskngXBTnbD9Tpcuo1D+aml65bI6p80JeHU0RQz4QbQ1KKVAzfjAnfAZk1DXRnZ+f7ifepItRxeGVVAXMlrnqkUGFdNCHBgxpbp1mrwBtuhL2wY3pEVA8PgxmSUaO0vuXWaa0ZLsw240Y68AA7ARIlMIm9vXWr4+52temTwqmzLSjVQQanm+372K/d5BSb+QjPH4IBjAuryraWftX/qRp4qZnkywsTdnAUzrZ105UxmES7XDHyWk50qKMBzIPNaBfDUSL2tb4ajSQ46NxJGHvTtK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/22/26 10:14, Muchun Song wrote:
> The memmap_init_zone_device() function only initializes the migratetype
> of the first pageblock of a compound page. If the compound page size
> exceeds pageblock_nr_pages (e.g., 1GB hugepages with 2MB pageblocks),
> subsequent pageblocks in the compound page remain uninitialized.
> 
> Move the migratetype initialization out of __init_zone_device_page()
> and into a separate pageblock_migratetype_init_range() function. This
> iterates over the entire PFN range of the memory, ensuring that all
> pageblocks are correctly initialized.
> 
> Fixes: c4386bd8ee3a ("mm/memremap: add ZONE_DEVICE support for compound pages")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Oscar Salvador <osalvador@suse.de>
> ---
>  mm/mm_init.c | 45 ++++++++++++++++++++++++++++++---------------
>  1 file changed, 30 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index f9f8e1af921c..9d0fe79a94de 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -674,6 +674,21 @@ static inline void fixup_hashdist(void)
>  static inline void fixup_hashdist(void) {}
>  #endif /* CONFIG_NUMA */
>  
> +#ifdef CONFIG_ZONE_DEVICE
> +static __meminit void pageblock_migratetype_init_range(unsigned long pfn,
> +						       unsigned long nr_pages,
> +						       int migratetype)

Two-tab indent says hi :)

> +{
> +	unsigned long end = pfn + nr_pages;

Can be const.

> +
> +	for (pfn = pageblock_align(pfn); pfn < end; pfn += pageblock_nr_pages) {
> +		init_pageblock_migratetype(pfn_to_page(pfn), migratetype, false);
> +		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
> +			cond_resched();
> +	}
> +}
> +#endif
> +
>  /*
>   * Initialize a reserved page unconditionally, finding its zone first.
>   */
> @@ -1011,21 +1026,6 @@ static void __ref __init_zone_device_page(struct page *page, unsigned long pfn,
>  	page_folio(page)->pgmap = pgmap;
>  	page->zone_device_data = NULL;
>  
> -	/*
> -	 * Mark the block movable so that blocks are reserved for
> -	 * movable at startup. This will force kernel allocations
> -	 * to reserve their blocks rather than leaking throughout
> -	 * the address space during boot when many long-lived
> -	 * kernel allocations are made.
> -	 *
> -	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
> -	 * because this is done early in section_activate()
> -	 */
> -	if (pageblock_aligned(pfn)) {
> -		init_pageblock_migratetype(page, MIGRATE_MOVABLE, false);
> -		cond_resched();
> -	}
> -
>  	/*
>  	 * ZONE_DEVICE pages other than MEMORY_TYPE_GENERIC are released
>  	 * directly to the driver page allocator which will set the page count
> @@ -1122,6 +1122,9 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  
>  		__init_zone_device_page(page, pfn, zone_idx, nid, pgmap);
>  
> +		if (IS_ALIGNED(pfn, PAGES_PER_SECTION))
> +			cond_resched();
> +
>  		if (pfns_per_compound == 1)
>  			continue;
>  
> @@ -1129,6 +1132,18 @@ void __ref memmap_init_zone_device(struct zone *zone,
>  				     compound_nr_pages(altmap, pgmap));
>  	}
>  
> +	/*
> +	 * Mark the block movable so that blocks are reserved for
> +	 * movable at startup. This will force kernel allocations
> +	 * to reserve their blocks rather than leaking throughout
> +	 * the address space during boot when many long-lived
> +	 * kernel allocations are made.
> +	 *
> +	 * Please note that MEMINIT_HOTPLUG path doesn't clear memmap
> +	 * because this is done early in section_activate()
> +	 */

I am deeply confused about the "memmap" comment here.

There is no MEMINIT_HOTPLUG special-casing. Nobody "clears memmap".


That comment was introduced in

commit 966cf44f637e6aeea7e3d01ba004bf8b5beac78f
Author: Alexander Duyck <alexander.h.duyck@linux.intel.com>
Date:   Fri Oct 26 15:07:52 2018 -0700

    mm: defer ZONE_DEVICE page initialization to the point where we init pgmap

Where we added memmap_init_zone_device().



Is that commit still valid, and this it actually belong here, above the
migratetype setting?


> +	pageblock_migratetype_init_range(start_pfn, nr_pages, MIGRATE_MOVABLE);
> +
>  	pr_debug("%s initialised %lu pages in %ums\n", __func__,
>  		nr_pages, jiffies_to_msecs(jiffies - start));
>  }


-- 
Cheers,

David

