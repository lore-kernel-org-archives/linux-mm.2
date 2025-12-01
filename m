Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7DA13D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 18:54:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 549176B00AF; Mon,  1 Dec 2025 13:54:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AAD76B00B1; Mon,  1 Dec 2025 13:54:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2AF706B00B3; Mon,  1 Dec 2025 13:54:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 14F0F6B00AF
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 13:54:44 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5466140398
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:54:43 +0000 (UTC)
X-FDA: 84171803646.09.432193F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 071B01C0007
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 18:54:41 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pnWWPZ6w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764615282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eI3UiaI9Cpt/KwwB62NraryTus/vNJ8QtcabaBpMO58=;
	b=znmQmp1uieHbLMNE+6Zv6Z7sgxDdZtLWFVXXEgYkSME9JzbvszVxyQ6yuS+BbHtsVUQe12
	fogqysN2B21WO0tiU/HU2bwRa98oyHp5drlT3sTr4VyyWC5yBRye6Q8ZgPq4QrnIcP7tav
	D131PUwPXKVvw7/P+vIF2CbYLBTtuIE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pnWWPZ6w;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764615282; a=rsa-sha256;
	cv=none;
	b=sR5CPX20JIRVvOrlT/pz7WJCZhgzLxDwUXeVGABEyFWvwe6/Zw9ikVNQGfV6RdvrLUH402
	ibpSmIvoq6kbeXP/ZIt3eqqscW6njlWM45WqJSRx5wbTDlOsB8zhX4kS/kKHOMtO5cG/tF
	svu9NguxdZVE118WVw5Zvqoi5soZDe4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CE8C943FB1;
	Mon,  1 Dec 2025 18:54:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6C69C116C6;
	Mon,  1 Dec 2025 18:54:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764615280;
	bh=1q3jskg7gK0OTAOEWa2SXDK5o1qCYd761gFxc0pcLdM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pnWWPZ6wjIQcVWY2jrPUogtwKylkMrX+ngJIuCPW6vH2Y8i4OtThTnLGilWvkxjk5
	 MJENeHOh57IOLCmn2Zo6TSirMhTsI1xeOl+YTT0J0P0WORaiJQCXDOKRZnHJjE5AQg
	 AyHLZ9okUVUWNX62zRbvxHa3G+e6Fdqxddwsh25RtsulKRlgWZjr7gpPOFfkfVaQUK
	 SemuJrkVA7PJYJ4nEsrlGowXYhiNIaMDXb8rjSHYk/O82RF0pmv3lodAzZDpP4+DKR
	 c0sVaXfq5YOdpkDKeUqn8WPb+4VVULkvS9oGzj0ftAd4h/Ep5V/WA21q7mSMCmXUov
	 Y7CgcRnJ4oE9Q==
Message-ID: <7633c77b-44eb-41f0-9c3a-1e5034b594e3@kernel.org>
Date: Mon, 1 Dec 2025 19:54:34 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when changes pfn range
To: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20251201132216.1636924-1-tianyou.li@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251201132216.1636924-1-tianyou.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 071B01C0007
X-Rspamd-Server: rspam11
X-Stat-Signature: ndszjcb5ynwcyggus8a33j3i3g9q77n8
X-HE-Tag: 1764615281-497294
X-HE-Meta: U2FsdGVkX1+O8hFaR+imzq/omhX2duJ/GaieDALKiGbJ4TCT44thTclt/VtdmRpBtDDLZqC8y4i4yW+lSn7Pivae/bcHVzb4Vc+OCCcjjwkxIqxosAGmEVnBRWABDkpj/1d20taAW42w6v9cPj55Ez0YxSP+VIUTlbMIgpVlsNX0UXQIc8Oe/AlC8IhLhu3rTttlnF2zAqGaIFk/O1vKqdqKnvy+eMcoHiXG46mbUb/PAELceX1bqSrSkAeelmy0CCsw0sLIAsMYtG+WWE3VdHVtQOXMoMwCvawxYev2KbRmeAJFQbO0UZLkLC8MJopMGF18aZGw9RzVmuuEXIRMoEf87Ta/SbBowUiSlC7YhquH0OyFzdHZSjwiGlnNlNCedubI7cepliWQ4C/1rv0lppgLUX+vfQgfJ6bZviUKrcnK8GEJtUasFpobaFRtOhpE20FiHcCBdlm4GCi0RpBvU8pKdtYGk02bQNIAsLvLn46Prn2XcHhPy1KIeFbAq/yi0FIKrWF4f0Ni/Rxim8GM4XjkjNV5q1ukNaBdZ3fWTPhB4L9G1w0DJoRG66VEuzObkD8LcInT2A6hsyjqS+B0y6b5LANYHb5jUSsJxE6ba4ornVLBMHekobKrmzE/+tWB2y5R9eWkGpHcIzzBsqfFQt5UGHm4ThlXVyfR5pjWfvry7t4K9qg7kzz0XW3UX+coItYRGMKDL2ItBVX8WqIS1+v65km4d3au/I30atnDxhR6ul4XspniMNG8GLwfAr8UOuQFibdGzL6PXU2ZC5KqjpeLyUE8nogk/iaKdTFJJ07MgZ77vixlAzMzb+wnMHS40nXsncbC/rsqN0RZMBfR+us9D7ers9Y4BSnT5DM8d83bFGc9CXFaxV27zM+5Zz+titzXMVX7anu/gPAxBI/nBCbuH0UVgsCSGQHm0d5zewzgc5K1aKi6KRFXL64w1Ghgx3TV2tj6JSiXTfJd5Nb
 CKeDMWf2
 kUJarezOzTpV6PVfxImo8BdwAt9UejEZDRVE/NCBHRuF7L99KTnhV0/w1xlc3WpoJA34YaRZZFAqRLFagl+WzGqKOBZYOXCLITPqU10eLPFSfZagd/hyLReHggQ3shNfN4MDvFdb04hxPyRmjcggomKizripfuNIyFZMAQ2SBZXjr4Br4CWLcGTfHZ7pqfA7LuyBnVAnLLugByWvI7JNSnvctvFlUWKdn5dTnlRohZys5zj8zk4EWRihUUZyUni7YgOD9frCJBBfzbQegXZbf/8gi/KO8qLzMs5x7RQPD1jG7SsDWgnhI90kghA6QYFmHX7CrbqiQGZxL+xTzTpZO1EYHOV+SD3MWZoN3kMQJsQUu3W2V6xf9xylCFQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/1/25 14:22, Tianyou Li wrote:
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
> [1] Qemu commands to hotplug 256G/512G memory for a VM:
>      object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>      qom-set vmem1 requested-size 256G/512G (Plug Memory)
>      qom-set vmem1 requested-size 0G (Unplug Memory)
> 
> [2] Hardware     : Intel Icelake server
>      Guest Kernel : v6.18-rc2
>      Qemu         : v9.0.0
> 
>      Launch VM    :
>      qemu-system-x86_64 -accel kvm -cpu host \
>      -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>      -drive file=./seed.img,format=raw,if=virtio \
>      -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>      -m 2G,slots=10,maxmem=2052472M \
>      -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>      -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>      -nographic -machine q35 \
>      -nic user,hostfwd=tcp::3000-:22
> 
>      Guest kernel auto-onlines newly added memory blocks:
>      echo online > /sys/devices/system/memory/auto_online_blocks
> 
> [3] The time from typing the QEMU commands in [1] to when the output of
>      'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>      memory is recognized.
> 
> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
> Tested-by: Yuan Liu <yuan1.liu@intel.com>
> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
> Reviewed-by: Pan Deng <pan.deng@intel.com>
> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> ---
>   mm/internal.h       |  8 ++++-
>   mm/memory_hotplug.c | 79 ++++++++++++++++++++++++++++++++++++++++++---
>   mm/mm_init.c        | 36 +++++++++++++--------
>   3 files changed, 103 insertions(+), 20 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 1561fc2ff5b8..a94928520a55 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -730,7 +730,13 @@ static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>   	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
>   }
>   
> -void set_zone_contiguous(struct zone *zone);
> +enum zone_contiguous_state {
> +	CONTIGUOUS_DEFINITELY_NOT = 0,
> +	CONTIGUOUS_DEFINITELY = 1,
> +	CONTIGUOUS_UNDETERMINED = 2,

No need for the values.

> +};

I don't like that the defines don't match the enum name (zone_c... vs. 
CONT... ).

Essentially you want a "yes / no / maybe" tristate. I don't think we 
have an existing type for that, unfortunately.

enum zone_contig_state {
	ZONE_CONTIG_YES,
	ZONE_CONTIG_NO,
	ZONE_CONTIG_MAYBE,
};

Maybe someone reading along has a better idea.

> +
> +void set_zone_contiguous(struct zone *zone, enum zone_contiguous_state state);
>   bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>   			   unsigned long nr_pages);
>   
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 0be83039c3b5..b74e558ce822 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -544,6 +544,32 @@ static void update_pgdat_span(struct pglist_data *pgdat)
>   	pgdat->node_spanned_pages = node_end_pfn - node_start_pfn;
>   }
>   
> +static enum zone_contiguous_state __meminit clear_zone_contiguous_for_shrinking(
> +		struct zone *zone, unsigned long start_pfn, unsigned long nr_pages)
> +{
> +	const unsigned long end_pfn = start_pfn + nr_pages;
> +	enum zone_contiguous_state result = CONTIGUOUS_UNDETERMINED;
> +
> +	/*
> +	 * If the removed pfn range inside the original zone span, the contiguous
> +	 * property is surely false.
> +	 */
> +	if (start_pfn > zone->zone_start_pfn && end_pfn < zone_end_pfn(zone))
> +		result = CONTIGUOUS_DEFINITELY_NOT;
> +
> +	/*
> +	 * If the removed pfn range is at the beginning or end of the
> +	 * original zone span, the contiguous property is preserved when
> +	 * the original zone is contiguous.
> +	 */
> +	else if (start_pfn == zone->zone_start_pfn || end_pfn == zone_end_pfn(zone))
> +		result = zone->contiguous ?
> +			CONTIGUOUS_DEFINITELY : CONTIGUOUS_UNDETERMINED;
> +

See my comment below on how to make this readable.

> +	clear_zone_contiguous(zone);
> +	return result;
> +}
> +
>   void remove_pfn_range_from_zone(struct zone *zone,
>   				      unsigned long start_pfn,
>   				      unsigned long nr_pages)
> @@ -551,6 +577,7 @@ void remove_pfn_range_from_zone(struct zone *zone,
>   	const unsigned long end_pfn = start_pfn + nr_pages;
>   	struct pglist_data *pgdat = zone->zone_pgdat;
>   	unsigned long pfn, cur_nr_pages;
> +	enum zone_contiguous_state contiguous_state = CONTIGUOUS_UNDETERMINED;
>   
>   	/* Poison struct pages because they are now uninitialized again. */
>   	for (pfn = start_pfn; pfn < end_pfn; pfn += cur_nr_pages) {
> @@ -571,12 +598,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
>   	if (zone_is_zone_device(zone))
>   		return;
>   
> -	clear_zone_contiguous(zone);
> +	contiguous_state = clear_zone_contiguous_for_shrinking(
> +				zone, start_pfn, nr_pages);
>   

Reading this again, I wonder whether it would be nicer to have something 
like:

new_contig_state = zone_contig_state_after_shrinking();
clear_zone_contiguous(zone);

or sth like that. Similar for the growing case.

>   	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
>   	update_pgdat_span(pgdat);
>   
> -	set_zone_contiguous(zone);
> +	set_zone_contiguous(zone, contiguous_state);
>   }
>   
>   /**
> @@ -736,6 +764,47 @@ static inline void section_taint_zone_device(unsigned long pfn)
>   }
>   #endif
>   
> +static enum zone_contiguous_state __meminit clear_zone_contiguous_for_growing(
> +		struct zone *zone, unsigned long start_pfn, unsigned long nr_pages)
> +{
> +	const unsigned long end_pfn = start_pfn + nr_pages;
> +	enum zone_contiguous_state result = CONTIGUOUS_UNDETERMINED;
> +
> +	/*
> +	 * Given the moved pfn range's contiguous property is always true,
> +	 * under the conditional of empty zone, the contiguous property should
> +	 * be true.
> +	 */

I don't think that comment is required.

> +	if (zone_is_empty(zone))
> +		result = CONTIGUOUS_DEFINITELY;
> +
> +	/*
> +	 * If the moved pfn range does not intersect with the original zone span,
> +	 * the contiguous property is surely false.
> +	 */
> +	else if (end_pfn < zone->zone_start_pfn || start_pfn > zone_end_pfn(zone))
> +		result = CONTIGUOUS_DEFINITELY_NOT;
> +
> +	/*
> +	 * If the moved pfn range is adjacent to the original zone span, given
> +	 * the moved pfn range's contiguous property is always true, the zone's
> +	 * contiguous property inherited from the original value.
> +	 */
> +	else if (end_pfn == zone->zone_start_pfn || start_pfn == zone_end_pfn(zone))
> +		result = zone->contiguous ?
> +			CONTIGUOUS_DEFINITELY : CONTIGUOUS_DEFINITELY_NOT;
> +
> +	/*
> +	 * If the original zone's hole larger than the moved pages in the range,
> +	 * the contiguous property is surely false.
> +	 */
> +	else if (nr_pages < (zone->spanned_pages - zone->present_pages))
> +		result = CONTIGUOUS_DEFINITELY_NOT;
> +

This is a bit unreadable :)

if (zone_is_empty(zone)) {
	result = CONTIGUOUS_DEFINITELY;
} else if (...) {
	/* ... */
	...
} else if (...) {
	...
}

> +	clear_zone_contiguous(zone);
> +	return result;
> +}
> +
>   /*
>    * Associate the pfn range with the given zone, initializing the memmaps
>    * and resizing the pgdat/zone data to span the added pages. After this
> @@ -752,8 +821,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>   {
>   	struct pglist_data *pgdat = zone->zone_pgdat;
>   	int nid = pgdat->node_id;
> -
> -	clear_zone_contiguous(zone);
> +	const enum zone_contiguous_state contiguous_state =
> +		clear_zone_contiguous_for_growing(zone, start_pfn, nr_pages);
>   
>   	if (zone_is_empty(zone))
>   		init_currently_empty_zone(zone, start_pfn, nr_pages);
> @@ -783,7 +852,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>   			 MEMINIT_HOTPLUG, altmap, migratetype,
>   			 isolate_pageblock);
>   
> -	set_zone_contiguous(zone);
> +	set_zone_contiguous(zone, contiguous_state);
>   }
>   
>   struct auto_movable_stats {
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 7712d887b696..06db3fcf7f95 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2263,26 +2263,34 @@ void __init init_cma_pageblock(struct page *page)
>   }
>   #endif
>   
> -void set_zone_contiguous(struct zone *zone)
> +void set_zone_contiguous(struct zone *zone, enum zone_contiguous_state state)
>   {
>   	unsigned long block_start_pfn = zone->zone_start_pfn;
>   	unsigned long block_end_pfn;
>   
> -	block_end_pfn = pageblock_end_pfn(block_start_pfn);
> -	for (; block_start_pfn < zone_end_pfn(zone);
> -			block_start_pfn = block_end_pfn,
> -			 block_end_pfn += pageblock_nr_pages) {
> +	if (state == CONTIGUOUS_DEFINITELY) {
> +		zone->contiguous = true;
> +		return;
> +	} else if (state == CONTIGUOUS_DEFINITELY_NOT) {
> +		// zone contiguous has already cleared as false, just return.
> +		return;
> +	} else if (state == CONTIGUOUS_UNDETERMINED) {
> +		block_end_pfn = pageblock_end_pfn(block_start_pfn);
> +		for (; block_start_pfn < zone_end_pfn(zone);
> +				block_start_pfn = block_end_pfn,
> +				block_end_pfn += pageblock_nr_pages) {
>   
> -		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
> +			block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
>   
> -		if (!__pageblock_pfn_to_page(block_start_pfn,
> -					     block_end_pfn, zone))
> -			return;
> -		cond_resched();
> -	}
> +			if (!__pageblock_pfn_to_page(block_start_pfn,
> +						block_end_pfn, zone))
> +				return;
> +			cond_resched();
> +		}
>   
> -	/* We confirm that there is no hole */
> -	zone->contiguous = true;
> +		/* We confirm that there is no hole */
> +		zone->contiguous = true;
> +	}
>   }
>   


switch (state) {
case CONTIGUOUS_DEFINITELY:
	zone->contiguous = true;
	return;
case CONTIGUOUS_DEFINITELY_NOT:
	return;
default:
	break;
}

... unchanged logic.

>   /*
> @@ -2348,7 +2356,7 @@ void __init page_alloc_init_late(void)
>   		shuffle_free_memory(NODE_DATA(nid));
>   
>   	for_each_populated_zone(zone)
> -		set_zone_contiguous(zone);
> +		set_zone_contiguous(zone, CONTIGUOUS_UNDETERMINED);
>   
>   	/* Initialize page ext after all struct pages are initialized. */
>   	if (deferred_struct_pages)


-- 
Cheers

David

