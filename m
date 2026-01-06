Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B79E9CEFD03
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 20:18:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3B226B008A; Tue,  6 Jan 2026 15:18:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E8436B0092; Tue,  6 Jan 2026 15:18:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BC056B0093; Tue,  6 Jan 2026 15:18:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 7804C6B008A
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 15:18:28 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0A29E5C4ED
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:18:28 +0000 (UTC)
X-FDA: 84302651496.18.D28A3E1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 4459C40012
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 20:18:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nJGDoRdX;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767730706;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Eacep/T9zRkrh3FOW4ZPezbJG3itMjVu1AgYsjO5j5M=;
	b=Xprn4ouhLUQXOTZG+3PZt9y+XVAzIx3yFvbYKrnWna7MP9H3NfArIUyawa+bo8d/dHVE2d
	LucJazKJeQIupScQBlWLG/p1Q7Uek3YJ46NqGXjOh8CDdLu7eeDewL9UEDVhuZ+lpLF6p9
	HJ5V2IEoMeqDyfnyRi4clF8r2J/zaZ0=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nJGDoRdX;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767730706; a=rsa-sha256;
	cv=none;
	b=XIf/a0Qegk0eb1p3FwiHTDhWkW5yXwyJekrGnJM02Oe8yiZ8OzNHZjgrm/IAhWZ3vf1esc
	w9uGzypsr5cNRWHMEo7ORJr/e5BGiat21G+UcW3nwpa9MXcIWGitP7i04cdac+V4/zCuRN
	+K3KXxLqNIji8dIiSp0FTegARqFCsbE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9052860007;
	Tue,  6 Jan 2026 20:18:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA30EC116C6;
	Tue,  6 Jan 2026 20:18:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767730705;
	bh=O82e2pqk042OKyz9pqR+aAPYRMu7JDu/SgdA25ivg0E=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nJGDoRdXlP43cTCNMdhiCGcM3wXV+vbopOMi+FOcGCe2KGGj9G3Ksm/E07oZKVCxP
	 1q2DU0gfwolrk1sQswHRUnjIZ3K2E0uXZaAK3Ll1i7YACc/AItW8BVEIvfvTROmZ7o
	 uUj3Ytd984f+mByFZsPs7rR5+ZVHY/mn8TyGL0LciwXOr7VYT20uzFrMg0yGJ0ZA9u
	 H5vioCG9/cliZx4E0YbW1huNWdDQgucwQEUlJKpQ8qvr0pkEdHTZX1dgimqQp3NQQ1
	 LvvIdREp6YSaDT/ang7y8ZIzlYmQlCv53lCEkNldiutsdkzKHx8sbs7YWfpunZW53a
	 G7DG3muTsIrEA==
Message-ID: <2786022e-91ba-4ac3-98ef-bf7daad0467a@kernel.org>
Date: Tue, 6 Jan 2026 21:18:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20251222145807.11351-1-tianyou.li@intel.com>
 <20251222145807.11351-3-tianyou.li@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20251222145807.11351-3-tianyou.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4459C40012
X-Stat-Signature: t8ccrx6fcdxng5ca736ptcpgdraj8j8f
X-Rspam-User: 
X-HE-Tag: 1767730706-702516
X-HE-Meta: U2FsdGVkX1/zz5kqzi7/jMgg8mR79pTd4oaxFWLk0GXWDkfg2Xs/AO5HKtf89WLDWvmnS5MkGzKoNaG+2cEw6HMIAT8bxF7a4ALRfbls+61yxRK9zndK0D0CFoF8xVWwsPdgVQthq+js3MEbt7SycosSo9YWvnIm7EU+L58VthaJGjVkdf1sUJkRDxY8McuKCEraeMsmp3YJZfDw5huEa+VGEjwSfl7549JUqJpvYecj97YSdbxngPfq1Zus3lFAeLAluClDQbFjP2Mzoi+nLSBef06rpGvJ918qtpQuek34A2f2BrYKtAtO7nqaJbxF5ITf6GNBhuSDyqqtXIaaFoi9qRZ+qXObQzhzo0reLJYzlDJkX80BMpINzxknMo0MjT0Yqoy+G4vkS4jeZ/evPfUCE+rd0ZpLgwWbXwgzrpW/ML9+bja+Hqy00P+84ogtxWjEaK5rQHMqU9GrDvAgCEFcEpwT0Th6Mel8Akt58hZxWz4A/FyG/pvb+nmqQ1fHjEdTqurrPu/mOPO7PJFlOijDwxXRkkA15/ImqvXlN/owL65mekwparo8mr7DjGLAheJ6st+ulhJheUbrbHaC11czao/pwIDnDS/TH5sWcvF/6mChOdM8PX3QakIqTNjUUnlWVoAqTOoKuRmMw7AlKmxI7x4XHJh9qMa7JMtzPmdJagWi9mRiVoGZw3/iaVnQ3sb9mhKYS5rfdw/zJ7FYVbVKdtPme2ExiDEDLdan4bX2WTYYq8DWky3cjKbIk9SiHKf5G6ahrXVihN9VgTyu012rmH43KJKJfXwrSA3bKZpQhi5+kdaGVJANUyFrPCe0YBaFaC5HZu0mY1B+CEkDY/wYLARb7qCKVYTXcgO6ISv08RjkcEycqxOAMLcuKlD6JVIq+Teg+NBpngt/zAYPZY6DoHItEhKyPN4JCJ3Cc1MfOdzjP8QMKA7GKoju2SNgWuKxUjubFtS/s25HQVI
 bX4i14H2
 YuFO3MnPcAA8eMPvaQLdaWO3sKiwtoZ/LzD4sYxYHCzHkMTofczAUSUP1qFCllGLIFUtivz02GdFM+kY8HUo4a15zh/fgo9aQyeP3oWwzrVf7ghsYlKBX6XFllsyjeJzdciHvMJFb/RAIcapb4iiavdqiPFfw2rKcyk+agiMPwpqzqWzVfoA2k9fwpCmtEYkFPmgtEOo8PR1ZVnpqg+kSYXYMZfElEYNphhDX7XBiDWGr0kChdzmjcqislF4zR4fF3crxlUiJ0LfjuklAaFNr5UhyQqkJmMbi57bTQNfHax+uj42ToikhwWMxvHOFwV637p0SUZP7vQ6IPDk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/22/25 15:58, Tianyou Li wrote:
> When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it will
> update the zone->contiguous by checking the new zone's pfn range from the
> beginning to the end, regardless the previous state of the old zone. When
> the zone's pfn range is large, the cost of traversing the pfn range to
> update the zone->contiguous could be significant.
> 
> Add fast paths to quickly detect cases where zone is definitely not
> contiguous without scanning the new zone. The cases are: when the new range
> did not overlap with previous range, the contiguous should be false; if the
> new range adjacent with the previous range, just need to check the new
> range; if the new added pages could not fill the hole of previous zone, the
> contiguous should be false.
> 
> The following test cases of memory hotplug for a VM [1], tested in the
> environment [2], show that this optimization can significantly reduce the
> memory hotplug time [3].
> 
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Plug Memory    | 256G |      10s      |      2s      |       80%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      33s      |      6s      |       81%      |
> +----------------+------+---------------+--------------+----------------+
> 
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Unplug Memory  | 256G |      10s      |      2s      |       80%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      34s      |      6s      |       82%      |
> +----------------+------+---------------+--------------+----------------+
> 

Again, very nice results.

[...]

>   
> +static enum zone_contig_state zone_contig_state_after_shrinking(struct zone *zone,
> +				unsigned long start_pfn, unsigned long nr_pages)
> +{
> +	const unsigned long end_pfn = start_pfn + nr_pages;
> +
> +	/*
> +	 * If the removed pfn range inside the original zone span, the contiguous
> +	 * property is surely false.

/*
  * If we cut a hole into the zone span, then the zone is
  * certainly not contiguous.
  */

> +	 */
> +	if (start_pfn > zone->zone_start_pfn && end_pfn < zone_end_pfn(zone))
> +		return ZONE_CONTIG_NO;
> +
> +	/* If the removed pfn range is at the beginning or end of the
> +	 * original zone span, the contiguous property is preserved when
> +	 * the original zone is contiguous.

/* Removing from the start/end of the zone will not change anything. */

> +	 */
> +	if (start_pfn == zone->zone_start_pfn || end_pfn == zone_end_pfn(zone))
> +		return zone->contiguous ? ZONE_CONTIG_YES : ZONE_CONTIG_MAYBE;
> +
> +	return ZONE_CONTIG_MAYBE;
> +}
> +
>   void remove_pfn_range_from_zone(struct zone *zone,
>   				      unsigned long start_pfn,
>   				      unsigned long nr_pages)
> @@ -551,6 +573,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
>   	const unsigned long end_pfn = start_pfn + nr_pages;
>   	struct pglist_data *pgdat = zone->zone_pgdat;
>   	unsigned long pfn, cur_nr_pages;
> +	enum zone_contig_state new_contiguous_state = ZONE_CONTIG_MAYBE;

No need to initialize, given that you overwrite the value below.

>   
>   	/* Poison struct pages because they are now uninitialized again. */
>   	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
> @@ -571,12 +594,14 @@ void remove_pfn_range_from_zone(struct zone *zone,
>   	if (zone_is_zone_device(zone))
>   		return;
>   
> +	new_contiguous_state = zone_contig_state_after_shrinking(zone, start_pfn,
> +								 nr_pages);
>   	clear_zone_contiguous(zone);
>   
>   	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
>   	update_pgdat_span(pgdat);
>   
> -	set_zone_contiguous(zone);
> +	set_zone_contiguous(zone, new_contiguous_state);
>   }
>   
>   /**
> @@ -736,6 +761,39 @@ static inline void section_taint_zone_device(unsigned long pfn)
>   }
>   #endif
>   
> +static enum zone_contig_state zone_contig_state_after_growing(struct zone *zone,
> +				unsigned long start_pfn, unsigned long nr_pages)
> +{
> +	const unsigned long end_pfn = start_pfn + nr_pages;
> +
> +	if (zone_is_empty(zone))
> +		return ZONE_CONTIG_YES;
> +
> +	/*
> +	 * If the moved pfn range does not intersect with the original zone spa

s/spa/span/

> +	 * the contiguous property is surely false.

"the zone is surely not contiguous."

> +	 */
> +	if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone))
> +		return ZONE_CONTIG_NO;
> +
> +	/*
> +	 * If the moved pfn range is adjacent to the original zone span, given
> +	 * the moved pfn range's contiguous property is always true, the zone's
> +	 * contiguous property inherited from the original value.
> +	 */

/* Adding to the start/end of the zone will not change anything. */

> +	if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
> +		return zone->contiguous ? ZONE_CONTIG_YES : ZONE_CONTIG_NO;
> +
> +	/*
> +	 * If the original zone's hole larger than the moved pages in the range
> +	 * the contiguous property is surely false.
> +	 */

/* If we cannot fill the hole, the zone stays not contiguous. */

> +	if (nr_pages < (zone->spanned_pages - zone->present_pages))
> +		return ZONE_CONTIG_NO;
> +
> +	return ZONE_CONTIG_MAYBE;
> +}
> +
>   /*
>    * Associate the pfn range with the given zone, initializing the memmaps
>    * and resizing the pgdat/zone data to span the added pages. After this
> @@ -1090,11 +1148,20 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
>   {
>   	unsigned long end_pfn = pfn + nr_pages;
>   	int ret, i;
> +	enum zone_contig_state new_contiguous_state = ZONE_CONTIG_NO;
>   
>   	ret = kasan_add_zero_shadow(__va(PFN_PHYS(pfn)), PFN_PHYS(nr_pages));
>   	if (ret)
>   		return ret;
>   
> +	/*
> +	 * If the allocated memmap pages are not in a full section, keep the
> +	 * contiguous state as ZONE_CONTIG_NO.
> +	 */
> +	if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
> +		new_contiguous_state = zone_contig_state_after_growing(zone,
> +								pfn, nr_pages);
> +

This is nasty. I would wish we could just leave that code path alone.

In particular: I am 99% sure that we never ever run into this case in 
practice.

E.g., on x86, we can have up to 2 GiB memory blocks. But the memmap of 
that is 64/4096*2GiB == 32 MB ... and a memory section is 128 MiB.


As commented on patch #1, we should drop the set_zone_contiguous() in 
this function either way and let online_pages() deal with it.

We just have to make sure that we don't create some inconsistencies by 
doing that.

Can you double-check?

>   	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_UNMOVABLE,
>   			       false);
>   
> @@ -1113,7 +1180,7 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
>   	if (nr_pages >= PAGES_PER_SECTION)
>   	        online_mem_sections(pfn, ALIGN_DOWN(end_pfn, PAGES_PER_SECTION));
>   
> -	set_zone_contiguous(zone);
> +	set_zone_contiguous(zone, new_contiguous_state);
>   	return ret;
>   }
>   
> @@ -1153,6 +1220,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>   	const int nid = zone_to_nid(zone);
>   	int need_zonelists_rebuild = 0;
>   	unsigned long flags;
> +	enum zone_contig_state new_contiguous_state = ZONE_CONTIG_NO;
>   	int ret;
>   
>   	/*
> @@ -1166,6 +1234,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>   			 !IS_ALIGNED(pfn + nr_pages, PAGES_PER_SECTION)))
>   		return -EINVAL;
>   
> +	new_contiguous_state = zone_contig_state_after_growing(zone, pfn, nr_pages);
>   
>   	/* associate pfn range with the zone */
>   	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE,
> @@ -1204,7 +1273,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>   	}
>   
>   	online_pages_range(pfn, nr_pages);
> -	set_zone_contiguous(zone);
> +	set_zone_contiguous(zone, new_contiguous_state);
>   	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
>   
>   	if (node_arg.nid >= 0)
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index fc2a6f1e518f..0c41f1004847 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2263,11 +2263,19 @@ void __init init_cma_pageblock(struct page *page)
>   }
>   #endif
>   
> -void set_zone_contiguous(struct zone *zone)
> +void set_zone_contiguous(struct zone *zone, enum zone_contig_state state)
>   {
>   	unsigned long block_start_pfn = zone->zone_start_pfn;
>   	unsigned long block_end_pfn;
>   
> +	if (state == ZONE_CONTIG_YES) {
> +		zone->contiguous = true;
> +		return;
> +	}
> +

Maybe add a comment like

/* We expect an earlier call to clear_zone_contig(). */


And maybe move that comment all the way up in the function and add

VM_WARN_ON_ONCE(zone->contiguous);

> +	if (state == ZONE_CONTIG_NO)
> +		return;
> +
>   	block_end_pfn = pageblock_end_pfn(block_start_pfn);
>   	for (; block_start_pfn < zone_end_pfn(zone);
>   			block_start_pfn = block_end_pfn,
> @@ -2348,7 +2356,7 @@ void __init page_alloc_init_late(void)
>   		shuffle_free_memory(NODE_DATA(nid));
>   
>   	for_each_populated_zone(zone)
> -		set_zone_contiguous(zone);
> +		set_zone_contiguous(zone, ZONE_CONTIG_MAYBE);
>   
>   	/* Initialize page ext after all struct pages are initialized. */
>   	if (deferred_struct_pages)


-- 
Cheers

David

