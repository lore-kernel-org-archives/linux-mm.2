Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 06B57D74970
	for <linux-mm@archiver.kernel.org>; Fri, 19 Dec 2025 09:38:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 552936B0088; Fri, 19 Dec 2025 04:38:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 501A66B0089; Fri, 19 Dec 2025 04:38:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E1856B008A; Fri, 19 Dec 2025 04:38:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B73B6B0088
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 04:38:08 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C205B8AF13
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:38:07 +0000 (UTC)
X-FDA: 84235719414.21.D4D340C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 190C640002
	for <linux-mm@kvack.org>; Fri, 19 Dec 2025 09:38:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UypafefL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766137086; a=rsa-sha256;
	cv=none;
	b=aL5xbtCcPbL2GFtz40RIvRMZ4dBkSiIxc4v+kiTUk8V68/DpDMo5J+6a7uNoD/SgJuZ6gL
	v/11VuJCQj7+YigbYcC8bql4Lx+CV/sk4Of40OB+rCc7u/ICqAFWCHDKT3x7ScvsjZqlNu
	0KcT4wuG4rE03qHzEpXU1920dJKSFlU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UypafefL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766137086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=99m+UYZiJaObsz0ZOWVafjPumKPJGlkbn4mmMUz+loU=;
	b=e2E1L7WGmX9R1yiys4waDEmtihVXex8oNaPGasrGAsXZuPqWhpHwHAafzIK0Gx6EQ6j3kz
	ukrsrsAfBNMIiTd6Ofv1P0LPaVYMYLqEv5pqYt28YcoqlWo5+sarxhKUhXo7+EFFGa+0qQ
	/kdxTuPm7LMsiflo8JduG+eSVmfzoAE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E04DB43287;
	Fri, 19 Dec 2025 09:38:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03D1FC4CEF1;
	Fri, 19 Dec 2025 09:37:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766137084;
	bh=QRucwd58Q3iUPx5TpAFxLvxSW3Ui4n0gJQQkxLBi0VY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=UypafefLIlHW1HMmBo4AT2CBFg/Xz2177d7oodrDQgDkjRn+qBbEzPSSKxaL6f74S
	 9XPrW3itvb8QKGb2oJ+OTHqvVP5fWM5SqQI+2FgsRyVOQkBcCULhRtfIfDAm7DWojj
	 OHrGnzePuYVfsdEYRlQ/uXYEx9Vla1HD8By5/4hb4CBwQ7I1AImF2xfx1sKBfaMMiD
	 ulJ6AXkuWiT6XdVoCOpXP3rXbB20Wf+dM6w/Y6ZV1R/r7sfaRn67BUopp6bD5Ti7eW
	 sbcYAmfdPD12fDfK5DjIEo5N11mYuQHQltx9vnjDK6xKHZPIxhNz6IFoS4xRX594/P
	 EJR8hkvrUcqfA==
Date: Fri, 19 Dec 2025 11:37:56 +0200
From: Mike Rapoport <rppt@kernel.org>
To: Tianyou Li <tianyou.li@intel.com>
Cc: David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>,
	Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
	Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
	Yuan Liu <yuan1.liu@intel.com>,
	Tim Chen <tim.c.chen@linux.intel.com>,
	Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
	Pan Deng <pan.deng@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/2] mm/memory hotplug: fix zone->contiguous always
 false when hotplug
Message-ID: <aUUc9BNgUNguFS9K@kernel.org>
References: <20251215130437.3914342-1-tianyou.li@intel.com>
 <20251215130437.3914342-3-tianyou.li@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251215130437.3914342-3-tianyou.li@intel.com>
X-Rspamd-Queue-Id: 190C640002
X-Rspamd-Server: rspam03
X-Stat-Signature: fzbp7bpbt78qw37r5c8p9bdn9qfqc3jb
X-Rspam-User: 
X-HE-Tag: 1766137085-112491
X-HE-Meta: U2FsdGVkX18SsX5uDe6ao6xW1LFVndeg6PnXnAj8RgDjDBqipI1Ki2G+5Fy6GZ4iq54PoCxwVXKnz6AvaYxUU/+ml1/HKn7B1AIIB/+MMrlGx8cZ+HJ+WpuGV68kFkmcux1GLmxiZ0dpvppxuLxriEyB5vzV+MGRxV81buWou2omb3sXJ+LyNzQfVOpdmtH134hnLAwExZCLHypcPaVljBE124P1j+bIyLspLCzRe5xn4Mb+3wm9UM7gJ/dFrKo0w7OifefnaeXzbE59FDMELJHRJOOWzNuKZx8qI0UXDfR2BJ0eSt5vDFaYHF8mC0bRoVoBaNFsUeGDqjDU1uSwggzBfE9YEndOOqbMl3B+RUCp69d55vugUNR8mMb1yjJFrfL8aoD1tltScOKU1iQXnc9lzUEky4GZKG8JmSgyqvnpHnjfBtXC0Mn0Jehop8bXEo7uDsg/+ScuvLz1A0piy+3c+u0/1tmgxo2Les8gIZoBkunWhog9oBOkO52k4HWBrAlfyNMMSO+LFZqskSm73gzMKZvK7uoPQiqbzbPJeYGFBuBVXXLcFcQEQifoFRNoKXO0FroHJd+oexPdxtaGpDkaxKsLhlrVVddtdJ2UtP0+TUI7Zk9CyBCTSddnGE9ssxBE0N6vWHwEHj7TCMwMjU/8p6HvXPH0y1JFxZvSxkTpaLjmRHegf9eL6wXiuxKHIJXOs6YsczyH5tR3PPtMbjdjlDhl1xY+FqEXzwm47dsZ6wYrvMm6KjORJ9cBRtJJkJzC7wh0ZQifTBoxK0E5ITGhAuzPo0sKDQz5d35Zg9yJejM8LOvd/wP7AK0BUARYT0KQMd41Ph+cZyp7lbyVQ0qgpL2dLYrpq5MOT1vJdKJpzbeZ7e3ZGbcwGK/g1OXVY13l2AhMV34yI332lXjj8QpeyNgN1SWNN6Me4206dTSe7vnVC+PA8UBmG2Ba9jk6pPfADjLusUK2SoK3c2R
 gqTOVRVP
 tzj12E8IRvVVNWf90PmlLzjPWZ4XTD9XuULU0Mzwq8MDRTixXBjYXsupV7TwiyN2XpLKBBypKUclNj/F0tgtCI+dQc3ih9SpOcmDRype776PcDZT8Ippfgc9HZ4eUb81fqBT6eqgahwT+RtNSCh1AxFt6am2zg/mMRCepG5+SX+tUNuFjEoEi8+EnaQY7K1IqyVKQyb0oNZURPwz32bk+U+y/E4pAwD+Es/hdgPuKNGcJH/eWovIKjHWj3CwjoCzzW4vlNAtuhpOdVHSEv8W3B2pQL1qsQBRr7SJQ1sWbBNyd7qO1wBo5WTiho4NcvJP2a2Ky1aemrGsws1VxhsLZgELfoZGd6X2/xpkWP6nwMimtZlNVx4Qi8F4oM5xWIgHINdse
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Mon, Dec 15, 2025 at 09:04:37PM +0800, Tianyou Li wrote:
> From: Yuan Liu <yuan1.liu@intel.com>
> 
> Function set_zone_contiguous used __pageblock_pfn_to_page to
> check the whole pageblock is in the same zone. One assumption is
> the memory section must online, otherwise the __pageblock_pfn_to_page
> will return NULL, then the set_zone_contiguous will be false.
> When move_pfn_range_to_zone invoked set_zone_contiguous, since the
> memory section did not online, the return value will always be false.
> 
> To fix this issue, we removed the set_zone_contiguous from the
> move_pfn_range_to_zone, and place it after memory section onlined.
> 
> Function remove_pfn_range_from_zone did not have this issue because
> memory section remains online at the time set_zone_contiguous invoked.

Since the fix is relevant even without the optimization patch, can we
please reorder the patches so that the fix will be the first in the series?
Than it can be applied to stable trees as well.
 
> Reviewed-by: Tianyou Li <tianyou.li@intel.com>
> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> ---
>  mm/memory_hotplug.c | 18 ++++++++++++++----
>  1 file changed, 14 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 12839032ad42..0220021f6a68 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -810,8 +810,7 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  {
>  	struct pglist_data *pgdat = zone->zone_pgdat;
>  	int nid = pgdat->node_id;
> -	const enum zone_contig_state new_contiguous_state =
> -		zone_contig_state_after_growing(zone, start_pfn, nr_pages);
> +
>  	clear_zone_contiguous(zone);
>  
>  	if (zone_is_empty(zone))
> @@ -841,8 +840,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>  	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
>  			 MEMINIT_HOTPLUG, altmap, migratetype,
>  			 isolate_pageblock);
> -
> -	set_zone_contiguous(zone, new_contiguous_state);
>  }
>  
>  struct auto_movable_stats {
> @@ -1151,6 +1148,7 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
>  {
>  	unsigned long end_pfn = pfn + nr_pages;
>  	int ret, i;
> +	enum zone_contig_state new_contiguous_state = ZONE_CONTIG_NO;
>  
>  	ret = kasan_add_zero_shadow(__va(PFN_PHYS(pfn)), PFN_PHYS(nr_pages));
>  	if (ret)
> @@ -1165,6 +1163,14 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
>  	if (mhp_off_inaccessible)
>  		page_init_poison(pfn_to_page(pfn), sizeof(struct page) * nr_pages);
>  
> +	/*
> +	 * If the allocated memmap pages are not in a full section, keep the
> +	 * contiguous state as ZONE_CONTIG_NO.
> +	 */
> +	if (IS_ALIGNED(end_pfn, PAGES_PER_SECTION))
> +		new_contiguous_state = zone_contig_state_after_growing(zone,
> +								pfn, nr_pages);
> +
>  	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_UNMOVABLE,
>  			       false);
>  
> @@ -1183,6 +1189,7 @@ int mhp_init_memmap_on_memory(unsigned long pfn, unsigned long nr_pages,
>  	if (nr_pages >= PAGES_PER_SECTION)
>  	        online_mem_sections(pfn, ALIGN_DOWN(end_pfn, PAGES_PER_SECTION));
>  
> +	set_zone_contiguous(zone, new_contiguous_state);
>  	return ret;
>  }
>  
> @@ -1221,6 +1228,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>  	};
>  	const int nid = zone_to_nid(zone);
>  	int need_zonelists_rebuild = 0;
> +	enum zone_contig_state new_contiguous_state = ZONE_CONTIG_NO;
>  	unsigned long flags;
>  	int ret;
>  
> @@ -1235,6 +1243,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>  			 !IS_ALIGNED(pfn + nr_pages, PAGES_PER_SECTION)))
>  		return -EINVAL;
>  
> +	new_contiguous_state = zone_contig_state_after_growing(zone, pfn, nr_pages);
>  
>  	/* associate pfn range with the zone */
>  	move_pfn_range_to_zone(zone, pfn, nr_pages, NULL, MIGRATE_MOVABLE,
> @@ -1273,6 +1282,7 @@ int online_pages(unsigned long pfn, unsigned long nr_pages,
>  	}
>  
>  	online_pages_range(pfn, nr_pages);
> +	set_zone_contiguous(zone, new_contiguous_state);
>  	adjust_present_page_count(pfn_to_page(pfn), group, nr_pages);
>  
>  	if (node_arg.nid >= 0)
> -- 
> 2.47.1
> 

-- 
Sincerely yours,
Mike.

