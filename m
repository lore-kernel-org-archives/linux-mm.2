Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F1C84EC01C9
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 10:56:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10BD36B0088; Mon, 23 Mar 2026 06:56:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0961C6B0089; Mon, 23 Mar 2026 06:56:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E77EB6B008A; Mon, 23 Mar 2026 06:56:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CDCF66B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 06:56:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6E2455C003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:56:43 +0000 (UTC)
X-FDA: 84577024686.03.E1260AA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 88D871C0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 10:56:41 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qh+eCwdu;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774263401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xtO86w/MgmBnR5Xh9Qfd1VSOQCtkUZlckIzy4v3dc8I=;
	b=TL0410jvxMJ+f14oU6H2RwmfB2NjDDOIpFr52VnkG35oL4aWoWIvQJGMkjUC0bghmFGk4A
	0wFjCb1rvpUwr+mmNEueKlc5PhJR0928gUldagIZhLD8OEYyn+6OOmEwCztcv1vwh5A7WR
	bURwLShLlvKoz7U+BbpKc3K6BpwduDs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774263401; a=rsa-sha256;
	cv=none;
	b=j0mApdepfRTQRf1edI0xKxoE4rM/tv9NB5OXjvWoPd6cZzrue6ktlyHYq/gV9uzMPdOYSK
	uhHopmzc0bBUK/EYQD9F/cLiFGPqvlZh1i+8xaD53b6EO50zWA2hGAzKqvW64lgKQJGdXf
	EJ5MJhj6Wp5ujrUeTWsr3PFXnbWl//I=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Qh+eCwdu;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 55F8743D7E;
	Mon, 23 Mar 2026 10:56:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 972CCC4CEF7;
	Mon, 23 Mar 2026 10:56:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774263400;
	bh=AdD1eD65nIz1GhVgQLpYox+mOMszpT+GqF+MDJcleFg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Qh+eCwdulZZxnVFh5T+KPjyjD29WyOs5XUv/MFdISjkCzZLM/F5CGAlnn0qs1wLaf
	 OCeqlCMhqs3sgPSNwhPUKVqojpzJx1a61tKcLINz0z6cmcHthGKjJ45WnbVPmHL8Uc
	 tF76CM+0Hj9xQ89XOzqwc8sgI0WLCpNJ6inyY0t/Bc5XHCOjkuwuRrGgYHvzdbRw/h
	 qk1JAONC5gJ87t7BU1Bq5p82m0Raurgxyd/rsy7ZYGH6mnl2dfigOCl5/byzueKoyR
	 f+pKfvKZtZwnR22l78yz7SFSxIV+EEOrHzm6pXfK/ac+aj8V3VQy6pRLzGabrdHxtE
	 31KdARthsPRLQ==
Message-ID: <48b497e5-1545-4376-a898-f3813a6ef989@kernel.org>
Date: Mon, 23 Mar 2026 11:56:35 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
To: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
 Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
 Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260319095622.1130380-1-yuan1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: egubfiwpmj69zarhuetgstthdpnag3uo
X-Rspamd-Queue-Id: 88D871C0005
X-Rspamd-Server: rspam03
X-HE-Tag: 1774263401-519618
X-HE-Meta: U2FsdGVkX1/9gjMsztcBu4snIZAqQN/5LtQXca0/ARwvUroQr9DisgeH+sUdPECCn3+L1R1x8fvByWnQBFIRYyn7+tUER5MAdSbWD99H7HTBfwnkSBG96E/zGrE+C1V/C2YEJoyY8/37+WwIrd77SsOuqBUmRc1AlwqGwMlC+fiJHStM8AOKWlbjZ1Qxsi4/9K/h/CdjVS9YCz6vU1OGFRI0khrWh3IYOV8rnoBgkvQn4WIh+1VQBxaQjuIIS6DWSUGh3KaVcv157hPh742dV7ZNGdhHKovIx0hGPdfnMtJPWMNWRCcOxQtdDNuu2ALJCmFbMimbUf5UmI5Y2ybfKcPqtVr97tWAAtY8LwpAOx9wzy2wLEKc2Aunijnr01s1NILRGtSi++eh2ckUmePrQUaGgx7cY62g1vQ7fFfn5l9aQnAp2Q14aPSf1s7UC9Yo2Kj6JcJab/0HyRTuIzLWg78yFgUyHgRXquUT2IABBzH64GYsegUTuaCPDOHTZ5XvYJFe7FMszeTs5yQyAYmQiI6Sfs8oHqhZU87Du+Mit6rFnkzwzV8ESDQRUWsMVqaDkHolL75Rcp0gG/rkznt87i8BxULacahhL1Osb83BpV2HuQ6DJh0wy3LG9i5khkTX9lYyuNtCwFF7gu4Ju/UAa+AanT2RWZe5ERP/v2No3kAFzDI/p5k93E3Ms4EzQ60EJ8xtKCKFKBmkCWsNSzmO3VOVe/dcNZtXQFHVjvKZuLjvAtV4vVQqRd4Nli0ghajEomvcxFRhg6dXtZ1rHYLXnDRYCR1XMMaNBHkOlxFauvTavlppJklGEFhbjDih3WPsHvN5CHPuoXh/bsb/ieaGZT5hu/EqmP5zHHou91+d9JhDjHitOSxc8AG7tkJnCv3IMPW9u8SXCUaDXb+3ov424HMPufoS3RyPF8wJKfamGZ2zLY626dHCLtrs4InvWmhpu8GRSZzVSYhbgKgtprV
 yFqbOtuh
 Jl7vGb7ZSD3ImeTt6uU8itIePGNXIGOE4BRKWzEW7CyO2cfn/JztM5mWX2czNrK01jqJ1U0I6kH1TH2I2BEI5FAi6RQ9dJegeJfHefqtW/wVW4RNXWUlAcZTiyODjXKht1/OjWrGbyNAY+LkKFLOqLYfw1x3Z4eWD/h9B8jK4+ZqLNM9Dnd5MrdlG+qT7Ei5hV0DZ/L0UJ3dO4PX8ejQ5r7iUU3ds5fzT9JYcu37pGeaW4SfzHO133iP4wBaDcgaD3/m/i3o/eNVLfvPd4a47oUNBewWO3SfVxeMA1GW9BDOGTiFePVHvIShtdDmxrVDRttWj3lCcR1RcdutM+3//pJCRCctjLyGksDIdJD/v1ifcKEdc4qoqaRBUDHStJgKlJMLxGyCFy4Li3cnNwQBBpMZOxA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/19/26 10:56, Yuan Liu wrote:
> When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it will
> update the zone->contiguous by checking the new zone's pfn range from the
> beginning to the end, regardless the previous state of the old zone. When
> the zone's pfn range is large, the cost of traversing the pfn range to
> update the zone->contiguous could be significant.
> 
> Add a new zone's pages_with_memmap member, it is pages within the zone that
> have an online memmap. It includes present pages and memory holes that have
> a memmap. When spanned_pages == pages_with_online_memmap, pfn_to_page() can
> be performed without further checks on any pfn within the zone span.
> 
> The following test cases of memory hotplug for a VM [1], tested in the
> environment [2], show that this optimization can significantly reduce the
> memory hotplug time [3].
> 
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Plug Memory    | 256G |      10s      |      3s      |       70%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      36s      |      7s      |       81%      |
> +----------------+------+---------------+--------------+----------------+
> 
> +----------------+------+---------------+--------------+----------------+
> |                | Size | Time (before) | Time (after) | Time Reduction |
> |                +------+---------------+--------------+----------------+
> | Unplug Memory  | 256G |      11s      |      4s      |       64%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      36s      |      9s      |       75%      |
> +----------------+------+---------------+--------------+----------------+
> 
> [1] Qemu commands to hotplug 256G/512G memory for a VM:
>     object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>     device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>     qom-set vmem1 requested-size 256G/512G (Plug Memory)
>     qom-set vmem1 requested-size 0G (Unplug Memory)
> 
> [2] Hardware     : Intel Icelake server
>     Guest Kernel : v7.0-rc4
>     Qemu         : v9.0.0
> 
>     Launch VM    :
>     qemu-system-x86_64 -accel kvm -cpu host \
>     -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>     -drive file=./seed.img,format=raw,if=virtio \
>     -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>     -m 2G,slots=10,maxmem=2052472M \
>     -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>     -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>     -nographic -machine q35 \
>     -nic user,hostfwd=tcp::3000-:22
> 
>     Guest kernel auto-onlines newly added memory blocks:
>     echo online > /sys/devices/system/memory/auto_online_blocks
> 
> [3] The time from typing the QEMU commands in [1] to when the output of
>     'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>     memory is recognized.
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
> Co-developed-by: Tianyou Li <tianyou.li@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> ---


[...]

>  
> +/**
> + * zone_is_contiguous - test whether a zone is contiguous
> + * @zone: the zone to test.
> + *
> + * In a contiguous zone, it is valid to call pfn_to_page() on any pfn in the
> + * spanned zone without requiring pfn_valid() or pfn_to_online_page() checks.

I think there is a small catch to it: users should protect from concurrent
memory offlining. I recall that, for compaction, there either was some protection 
in place or the race window was effectively impossible to hit.

Maybe we should add here for completion: "Note that missing synchronization with
memory offlining makes any PFN traversal prone to races."

> + *
> + * Returns: true if contiguous, otherwise false.
> + */
> +static inline bool zone_is_contiguous(const struct zone *zone)
> +{
> +	return READ_ONCE(zone->spanned_pages) ==
> +		READ_ONCE(zone->pages_with_online_memmap);

	       ^ should be vertically aligned

> +}
> +
>  static inline bool zone_is_initialized(const struct zone *zone)
>  {
>  	return zone->initialized;
> diff --git a/mm/internal.h b/mm/internal.h
> index cb0af847d7d9..7c4c8ab68bde 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -793,21 +793,17 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
>  static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
>  				unsigned long end_pfn, struct zone *zone)
>  {
> -	if (zone->contiguous)
> +	if (zone_is_contiguous(zone) && zone_spans_pfn(zone, start_pfn)) {

Do we really need the zone_spans_pfn() check? The caller must make sure that the
zone spans the PFN range before calling this function.
Compaction does that by walking only PFNs in the range.


The old "if (zone->contiguous)" check also expected a caller to handle that.

> +		VM_BUG_ON(end_pfn > zone_end_pfn(zone));

No VM_BUG_ONs please. But I think we can also drop this.

>  		return pfn_to_page(start_pfn);
> +	}
>  
>  	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
>  }
>  
> -void set_zone_contiguous(struct zone *zone);
>  bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>  			   unsigned long nr_pages);
>  
> -static inline void clear_zone_contiguous(struct zone *zone)
> -{
> -	zone->contiguous = false;
> -}
> -
>  extern int __isolate_free_page(struct page *page, unsigned int order);
>  extern void __putback_isolated_page(struct page *page, unsigned int order,
>  				    int mt);
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index bc805029da51..2ba7a394a64b 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -492,11 +492,11 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
>  		pfn = find_smallest_section_pfn(nid, zone, end_pfn,
>  						zone_end_pfn(zone));
>  		if (pfn) {
> -			zone->spanned_pages = zone_end_pfn(zone) - pfn;
> +			WRITE_ONCE(zone->spanned_pages, zone_end_pfn(zone) - pfn);
>  			zone->zone_start_pfn = pfn;
>  		} else {
>  			zone->zone_start_pfn = 0;
> -			zone->spanned_pages = 0;
> +			WRITE_ONCE(zone->spanned_pages, 0);
>  		}
>  	} else if (zone_end_pfn(zone) == end_pfn) {
>  		/*
> @@ -508,10 +508,10 @@ static void shrink_zone_span(struct zone *zone, unsigned long start_pfn,
>  		pfn = find_biggest_section_pfn(nid, zone, zone->zone_start_pfn,
>  					       start_pfn);
>  		if (pfn)
> -			zone->spanned_pages = pfn - zone->zone_start_pfn + 1;
> +			WRITE_ONCE(zone->spanned_pages, pfn - zone->zone_start_pfn + 1);
>  		else {
>  			zone->zone_start_pfn = 0;
> -			zone->spanned_pages = 0;
> +			WRITE_ONCE(zone->spanned_pages, 0);
>  		}
>  	}
>  }

As the AI review points out, we should also make sure that
resize_zone_range() updates it with a WRITE_ONCE().

But I am starting to wonder if we should as a first step leave
the zone->contiguous bool in place. Then we have to worry less about
reorderings of reading/writing spanned_pages vs. pages_with_online_memmap.

See below

[...]

> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index df34797691bd..96690e550024 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -946,6 +946,7 @@ static void __init memmap_init_zone_range(struct zone *zone,
>  	unsigned long zone_start_pfn = zone->zone_start_pfn;
>  	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
>  	int nid = zone_to_nid(zone), zone_id = zone_idx(zone);
> +	unsigned long zone_hole_start, zone_hole_end;
>  
>  	start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
>  	end_pfn = clamp(end_pfn, zone_start_pfn, zone_end_pfn);
> @@ -957,8 +958,19 @@ static void __init memmap_init_zone_range(struct zone *zone,
>  			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
>  			  false);
>  
> -	if (*hole_pfn < start_pfn)
> +	WRITE_ONCE(zone->pages_with_online_memmap,
> +		   READ_ONCE(zone->pages_with_online_memmap) +
> +		   (end_pfn - start_pfn));
> +
> +	if (*hole_pfn < start_pfn) {
>  		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
> +		zone_hole_start = clamp(*hole_pfn, zone_start_pfn, zone_end_pfn);
> +		zone_hole_end = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
> +		if (zone_hole_start < zone_hole_end)
> +			WRITE_ONCE(zone->pages_with_online_memmap,
> +				   READ_ONCE(zone->pages_with_online_memmap) +
> +				   (zone_hole_end - zone_hole_start));
> +	}

The range can have larger holes without a memmap, and I think we would be
missing pages handled by the other init_unavailable_range() call?


There is one question for Mike, though: couldn't it happen that the
init_unavailable_range() call in memmap_init() would initialize
the memmap outside of the node/zone span? If so, I wonder whether we
would want to adjust the node+zone space to include these ranges.

Later memory onlining could make these ranges suddenly fall into the
node/zone span.

So that requires some thought.


Maybe we should start with this (untested):

From a73ee44bc93fbcb9cf2b995e27fb98c68415f7be Mon Sep 17 00:00:00 2001
From: Yuan Liu <yuan1.liu@intel.com>
Date: Thu, 19 Mar 2026 05:56:22 -0400
Subject: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check when
 changing pfn range

[...]
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 Documentation/mm/physical_memory.rst |  6 ++++
 drivers/base/memory.c                |  5 ++++
 include/linux/mmzone.h               | 38 +++++++++++++++++++++++++
 mm/internal.h                        |  8 +-----
 mm/memory_hotplug.c                  | 12 ++------
 mm/mm_init.c                         | 42 ++++++++++------------------
 6 files changed, 67 insertions(+), 44 deletions(-)

diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
index 2398d87ac156..e4e188cd4887 100644
--- a/Documentation/mm/physical_memory.rst
+++ b/Documentation/mm/physical_memory.rst
@@ -483,6 +483,12 @@ General
   ``present_pages`` should use ``get_online_mems()`` to get a stable value. It
   is initialized by ``calculate_node_totalpages()``.
 
+``pages_with_online_memmap``
+  The pages_with_online_memmap is pages within the zone that have an online
+  memmap. It includes present pages and memory holes that have a memmap. When
+  spanned_pages == pages_with_online_memmap, pfn_to_page() can be performed
+  without further checks on any pfn within the zone span.
+
 ``present_early_pages``
   The present pages existing within the zone located on memory available since
   early boot, excluding hotplugged memory. Defined only when
diff --git a/drivers/base/memory.c b/drivers/base/memory.c
index 5380050b16b7..a367dde6e6fa 100644
--- a/drivers/base/memory.c
+++ b/drivers/base/memory.c
@@ -246,6 +246,7 @@ static int memory_block_online(struct memory_block *mem)
 		nr_vmemmap_pages = mem->altmap->free;
 
 	mem_hotplug_begin();
+	clear_zone_contiguous(zone);
 	if (nr_vmemmap_pages) {
 		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
 		if (ret)
@@ -270,6 +271,7 @@ static int memory_block_online(struct memory_block *mem)
 
 	mem->zone = zone;
 out:
+	set_zone_contiguous(zone);
 	mem_hotplug_done();
 	return ret;
 }
@@ -295,6 +297,8 @@ static int memory_block_offline(struct memory_block *mem)
 		nr_vmemmap_pages = mem->altmap->free;
 
 	mem_hotplug_begin();
+	clear_zone_contiguous(mem->zone);
+
 	if (nr_vmemmap_pages)
 		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
 					  -nr_vmemmap_pages);
@@ -314,6 +318,7 @@ static int memory_block_offline(struct memory_block *mem)
 
 	mem->zone = NULL;
 out:
+	set_zone_contiguous(mem->zone);
 	mem_hotplug_done();
 	return ret;
 }
diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index e11513f581eb..463376349a2c 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -1029,6 +1029,11 @@ struct zone {
 	 * cma pages is present pages that are assigned for CMA use
 	 * (MIGRATE_CMA).
 	 *
+	 * pages_with_online_memmap is pages within the zone that have an online
+	 * memmap. It includes present pages and memory holes that have a memmap.
+	 * When spanned_pages == pages_with_online_memmap, pfn_to_page() can be
+	 * performed without further checks on any pfn within the zone span.
+	 *
 	 * So present_pages may be used by memory hotplug or memory power
 	 * management logic to figure out unmanaged pages by checking
 	 * (present_pages - managed_pages). And managed_pages should be used
@@ -1053,6 +1058,7 @@ struct zone {
 	atomic_long_t		managed_pages;
 	unsigned long		spanned_pages;
 	unsigned long		present_pages;
+	unsigned long		pages_with_online_memmap;
 #if defined(CONFIG_MEMORY_HOTPLUG)
 	unsigned long		present_early_pages;
 #endif
@@ -1710,6 +1716,38 @@ static inline bool populated_zone(const struct zone *zone)
 	return zone->present_pages;
 }
 
+/**
+ * zone_is_contiguous - test whether a zone is contiguous
+ * @zone: the zone to test.
+ *
+ * In a contiguous zone, it is valid to call pfn_to_page() on any pfn in the
+ * spanned zone without requiring pfn_valid() or pfn_to_online_page() checks.
+ *
+ * Note that missing synchronization with memory offlining makes any
+ * PFN traversal prone to races.
+ *
+ * ZONE_DEVICE zones are always marked non-contiguous.
+ *
+ * Returns: true if contiguous, otherwise false.
+ */
+static inline bool zone_is_contiguous(const struct zone *zone)
+{
+	return zone->contiguous;
+}
+
+static inline void set_zone_contiguous(struct zone *zone)
+{
+	if (zone_is_zone_device(zone))
+		return;
+	if (zone->spanned_pages == zone->pages_with_online_memmap)
+		zone->contiguous = true;
+}
+
+static inline void clear_zone_contiguous(struct zone *zone)
+{
+	zone->contiguous = false;
+}
+
 #ifdef CONFIG_NUMA
 static inline int zone_to_nid(const struct zone *zone)
 {
diff --git a/mm/internal.h b/mm/internal.h
index 532d78febf91..faec50e55a30 100644
--- a/mm/internal.h
+++ b/mm/internal.h
@@ -816,21 +816,15 @@ extern struct page *__pageblock_pfn_to_page(unsigned long start_pfn,
 static inline struct page *pageblock_pfn_to_page(unsigned long start_pfn,
 				unsigned long end_pfn, struct zone *zone)
 {
-	if (zone->contiguous)
+	if (zone_is_contiguous(zone))
 		return pfn_to_page(start_pfn);
 
 	return __pageblock_pfn_to_page(start_pfn, end_pfn, zone);
 }
 
-void set_zone_contiguous(struct zone *zone);
 bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
 			   unsigned long nr_pages);
 
-static inline void clear_zone_contiguous(struct zone *zone)
-{
-	zone->contiguous = false;
-}
-
 extern int __isolate_free_page(struct page *page, unsigned int order);
 extern void __putback_isolated_page(struct page *page, unsigned int order,
 				    int mt);
diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
index 70e620496cec..f29c0d70c970 100644
--- a/mm/memory_hotplug.c
+++ b/mm/memory_hotplug.c
@@ -558,18 +558,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
 
 	/*
 	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
-	 * we will not try to shrink the zones - which is okay as
-	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
+	 * we will not try to shrink the zones.
 	 */
 	if (zone_is_zone_device(zone))
 		return;
 
-	clear_zone_contiguous(zone);
-
 	shrink_zone_span(zone, start_pfn, start_pfn + nr_pages);
 	update_pgdat_span(pgdat);
-
-	set_zone_contiguous(zone);
 }
 
 /**
@@ -746,8 +741,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	struct pglist_data *pgdat = zone->zone_pgdat;
 	int nid = pgdat->node_id;
 
-	clear_zone_contiguous(zone);
-
 	if (zone_is_empty(zone))
 		init_currently_empty_zone(zone, start_pfn, nr_pages);
 	resize_zone_range(zone, start_pfn, nr_pages);
@@ -775,8 +768,6 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
 	memmap_init_range(nr_pages, nid, zone_idx(zone), start_pfn, 0,
 			 MEMINIT_HOTPLUG, altmap, migratetype,
 			 isolate_pageblock);
-
-	set_zone_contiguous(zone);
 }
 
 struct auto_movable_stats {
@@ -1072,6 +1063,7 @@ void adjust_present_page_count(struct page *page, struct memory_group *group,
 	if (early_section(__pfn_to_section(page_to_pfn(page))))
 		zone->present_early_pages += nr_pages;
 	zone->present_pages += nr_pages;
+	zone->pages_with_online_memmap += nr_pages;
 	zone->zone_pgdat->node_present_pages += nr_pages;
 
 	if (group && movable)
diff --git a/mm/mm_init.c b/mm/mm_init.c
index e0f1e36cb9e4..6e5a8da7cdda 100644
--- a/mm/mm_init.c
+++ b/mm/mm_init.c
@@ -854,7 +854,7 @@ overlap_memmap_init(unsigned long zone, unsigned long *pfn)
  *   zone/node above the hole except for the trailing pages in the last
  *   section that will be appended to the zone/node below.
  */
-static void __init init_unavailable_range(unsigned long spfn,
+static unsigned long __init init_unavailable_range(unsigned long spfn,
 					  unsigned long epfn,
 					  int zone, int node)
 {
@@ -870,6 +870,7 @@ static void __init init_unavailable_range(unsigned long spfn,
 	if (pgcnt)
 		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
 			node, zone_names[zone], pgcnt);
+	return pgcnt;
 }
 
 /*
@@ -958,6 +959,7 @@ static void __init memmap_init_zone_range(struct zone *zone,
 	unsigned long zone_start_pfn = zone->zone_start_pfn;
 	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
 	int nid = zone_to_nid(zone), zone_id = zone_idx(zone);
+	unsigned long hole_pfns;
 
 	start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
 	end_pfn = clamp(end_pfn, zone_start_pfn, zone_end_pfn);
@@ -968,9 +970,12 @@ static void __init memmap_init_zone_range(struct zone *zone,
 	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
 			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
 			  false);
+	zone->pages_with_online_memmap = end_pfn - start_pfn;
 
-	if (*hole_pfn < start_pfn)
-		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
+	if (*hole_pfn < start_pfn) {
+		hole_pfns = init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
+		zone->pages_with_online_memmap += hole_pfns;
+	}
 
 	*hole_pfn = end_pfn;
 }
@@ -980,6 +985,7 @@ static void __init memmap_init(void)
 	unsigned long start_pfn, end_pfn;
 	unsigned long hole_pfn = 0;
 	int i, j, zone_id = 0, nid;
+	unsigned long hole_pfns;
 
 	for_each_mem_pfn_range(i, MAX_NUMNODES, &start_pfn, &end_pfn, &nid) {
 		struct pglist_data *node = NODE_DATA(nid);
@@ -1008,8 +1014,12 @@ static void __init memmap_init(void)
 #else
 	end_pfn = round_up(end_pfn, MAX_ORDER_NR_PAGES);
 #endif
-	if (hole_pfn < end_pfn)
-		init_unavailable_range(hole_pfn, end_pfn, zone_id, nid);
+	if (hole_pfn < end_pfn) {
+		struct zone *zone = &NODE_DATA(nid)->node_zones[zone_id];
+
+		hole_pfns = init_unavailable_range(hole_pfn, end_pfn, zone_id, nid);
+		zone->pages_with_online_memmap += hole_pfns;
+	}
 }
 
 #ifdef CONFIG_ZONE_DEVICE
@@ -2273,28 +2283,6 @@ void __init init_cma_pageblock(struct page *page)
 }
 #endif
 
-void set_zone_contiguous(struct zone *zone)
-{
-	unsigned long block_start_pfn = zone->zone_start_pfn;
-	unsigned long block_end_pfn;
-
-	block_end_pfn = pageblock_end_pfn(block_start_pfn);
-	for (; block_start_pfn < zone_end_pfn(zone);
-			block_start_pfn = block_end_pfn,
-			 block_end_pfn += pageblock_nr_pages) {
-
-		block_end_pfn = min(block_end_pfn, zone_end_pfn(zone));
-
-		if (!__pageblock_pfn_to_page(block_start_pfn,
-					     block_end_pfn, zone))
-			return;
-		cond_resched();
-	}
-
-	/* We confirm that there is no hole */
-	zone->contiguous = true;
-}
-
 /*
  * Check if a PFN range intersects multiple zones on one or more
  * NUMA nodes. Specify the @nid argument if it is known that this
-- 
2.43.0


-- 
Cheers,

David

