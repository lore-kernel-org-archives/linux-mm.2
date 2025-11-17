Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84B6ECE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 11:57:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8971C8E0017; Mon, 17 Nov 2025 06:57:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86E9D8E0003; Mon, 17 Nov 2025 06:57:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7ABD08E0017; Mon, 17 Nov 2025 06:57:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 652CF8E0003
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 06:57:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C714413C2EA
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:57:29 +0000 (UTC)
X-FDA: 84119949018.06.20BB19A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 1AD8214000D
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 11:57:27 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ce+/ifv4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763380648;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYmXbdbr2PqS7/n1s+hmGN1IPEAjDLhTdYFeIdefZTA=;
	b=EapEvL8IN7F51J0knJwKfV4T/bgECYfXrLo6x4jje05sUPNNWwUVWW2A9Un72jo4I8aKCb
	PW/A7fgv34hSLhDq02bdSnjDis072oeR4i676TfDeIQFj2MRF4q0vzCdXjC6ybGiVosM/0
	HTbViUYR/3sL0t0XYkzZJ6VIwNsoUBQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763380648; a=rsa-sha256;
	cv=none;
	b=tfI1oAZaExUm4BrTxc9/P2Mrpf9OnAED5+Q/MVt+OmRothuBJVbokd8Kz25SKARaz/v1TK
	jOYW4LSCQAW8TPPDP/Rt0lAqUukKVeVwYktv/ZJC5lONxCh068a9fRih4o9nwXkb++W6Qf
	ordflqiI8vPeJcMLWKjC4S57Ar00THM=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ce+/ifv4";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 15DCE442E3;
	Mon, 17 Nov 2025 11:57:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06FA2C113D0;
	Mon, 17 Nov 2025 11:57:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763380646;
	bh=On7O1Cp5WWBizgAKvohpLSYFrbGdKSFRN8lPAfBY5A0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ce+/ifv41T2tIaFu/N3RvueRAyuyujyJeGqb1DRXSNq3WK5XkMm4ZBcj6t41njbhU
	 gzFlxJocSHgRjCEp8bgt/HA4F8guIx/V58e8508MBp+B3x/RgazaeHo9voT0Pbrxwz
	 jbC/iseDDhQi3K/6riRCyHHrw/kosWqcxiU5MDnRWJ53nO5ccCEU0SxpfOCJ9UTmKa
	 o7cSbWB/QozAL0rgSpheOlkfLHo5o8r+14mF6sJReUDnzbKzUSLk/LkKdo8G1Bc75X
	 5vnEVtwZSSsLUABNQ0xeoSAY5WHmFcUcayUTxwfTxgeBuoO5Uooh56lRKhaSfR3Ylo
	 +sZZkKFdXgpOg==
Message-ID: <da7fea0d-8749-4905-b399-4b6c6551b173@kernel.org>
Date: Mon, 17 Nov 2025 12:57:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone->contiguous
 update when move pfn range
To: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20251117033052.371890-1-tianyou.li@intel.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251117033052.371890-1-tianyou.li@intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: zw7uzzwnsa7nfqr69t7ubyxmkebr899p
X-Rspam-User: 
X-Rspamd-Queue-Id: 1AD8214000D
X-Rspamd-Server: rspam10
X-HE-Tag: 1763380647-988000
X-HE-Meta: U2FsdGVkX19OnMnK+93EeDPoWPw5hYfpUyD8RDIkpaNGRFDB2sl1RN8bXkBGIAmQusqrWnFUA8mGXSqbPSstWqC0xKwz5FY69aoumeZYvzwtukEnCC9jIsPnYcVf63trF0k+fSL9BNroUVdHkksylokFb7O7xOS0j5bEGyB36caEq067cPB7O1lYMZzaUKXO3vG640K1t+Wwl3tVW9kaGY0WV6VRWJo1LGE3mIUfnkwLXScNYdlLKjLis3DUsex871IYv6SjhyXzmdW6j8S/75xC84F3hHmeivzLKYbyNpVSZm73NziqD+82JwnsBvMkabJQao6nOGtmGJHWR0Ieg4HbNC3uqEXTIS6Y3mG5YMmwjY3cttlQ0Lq0Z+9/dNl1M8cqlfco4rwm2cBzvG6L6E79ELKaIUeSPp+5Ge/y00sOjR0/pOeU6pvWLOz2YUvm8nihOM2bAwJluEFKKpJk+2p3X33EG2BLKZtzyQATWo1aj0p2kR8DonApfc9y1o3zVYb8vGM0bhdgp0fwtkIEJJ0wqDmqPST5RuhCBn7wUFYGSeVU0dUmIBlhN5jvY4kvi/WJdZVVIcWd9+VNL/SM83a0PAWzKxjTa8aRw+Gw1gAT7KO85MiUUNOFQlD+uVdAcqI7Hj4dzRsDZLgSskSLBbjyHfZ5KLpln0mXjXLU6XAI8sztlk49IK4VT91fAB2Kv6bPavJfChC1F/dd22aAuLwLHP2E4xbjWMhdSJZ2quwABEnEeJpSvKRAUqT16usYSSMBqIpRB+2JTORbrnJb2YslhbjT4/dFdTtswGjtyiv87xMmiF94+wi0t0MnEpKhycPj9r2QTS23W3cgSpLqBleEZYC3K1MD3qgJtJuZEeFgHnsvXM9hOf11Hb2sj2HsiXYcsNmvRSYBEAmbbEJ7ruMDYfEWEVV94u5z+OD+9fxueDZx+Ho3+g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17.11.25 04:30, Tianyou Li wrote:

Sorry for the late review!

> When invoke move_pfn_range_to_zone, it will update the zone->contiguous by
> checking the new zone's pfn range from the beginning to the end, regardless
> the previous state of the old zone. When the zone's pfn range is large, the
> cost of traversing the pfn range to update the zone->contiguous could be
> significant.

Right, unfortunately we have to iterate pageblocks.

We know that hotplugged sections always belong to the same zone, so we 
could optimize for them as well. Only early section have to walk pageblocks.

	if (early_section(__pfn_to_section(pfn)))

We could also walk memory blocks I guess (for_each_memory_block). If 
mem->zone != NULL, we know the whole block spans a single zone.


Memory blocks are as small as 128 MiB on x86-64, with pageblocks being 2 
MiB we would walk 64 pageblocks.

(I think we can also walk MAX_PAGE_ORDER chunks instead of pageblock chunks)


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
> | Memory Hotplug | 256G |      10s      |      3s      |       70%      |
> |                +------+---------------+--------------+----------------+
> |                | 512G |      33s      |      8s      |       76%      |
> +----------------+------+---------------+--------------+----------------+

Did not expect that to be the most expensive part, nice!

> 
> [1] Qemu commands to hotplug 512G memory for a VM:
>      object_add memory-backend-ram,id=hotmem0,size=512G,share=on
>      device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>      qom-set vmem1 requested-size 512G
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
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> ---
>   mm/internal.h       |  3 +++
>   mm/memory_hotplug.c | 48 ++++++++++++++++++++++++++++++++++++++++++++-
>   mm/mm_init.c        | 31 ++++++++++++++++++++++-------
>   3 files changed, 74 insertions(+), 8 deletions(-)
> 
> diff --git a/mm/internal.h b/mm/internal.h
> index 1561fc2ff5b8..734caae6873c 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -734,6 +734,9 @@ void set_zone_contiguous(struct zone *zone);
>   bool pfn_range_intersects_zones(int nid, unsigned long start_pfn,
>   			   unsigned long nr_pages);
>   
> +bool check_zone_contiguous(struct zone *zone, unsigned long start_pfn,
> +			   unsigned long nr_pages);
> +
>   static inline void clear_zone_contiguous(struct zone *zone)
>   {
>   	zone->contiguous = false;
> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
> index 0be83039c3b5..96c003271b8e 100644
> --- a/mm/memory_hotplug.c
> +++ b/mm/memory_hotplug.c
> @@ -723,6 +723,47 @@ static void __meminit resize_pgdat_range(struct pglist_data *pgdat, unsigned lon
>   
>   }
>   
> +static void __meminit update_zone_contiguous(struct zone *zone,
> +			bool old_contiguous, unsigned long old_start_pfn,
> +			unsigned long old_nr_pages, unsigned long old_absent_pages,
> +			unsigned long new_start_pfn, unsigned long new_nr_pages)

Is "old" the old zone range and "new", the new part we are adding?

In that case, old vs. new is misleading, could be interpreted as "old 
spanned zone range" and "new spanned zone range".


Why are we passing in old_absent_pages and not simply calculate it based 
on zone->present pages in here?

> +{
> +	unsigned long old_end_pfn = old_start_pfn + old_nr_pages;
> +	unsigned long new_end_pfn = new_start_pfn + new_nr_pages;

Can both be const.

> +	unsigned long new_filled_pages = 0;
> +
> +	/*
> +	 * If the moved pfn range does not intersect with the old zone span,
> +	 * the contiguous property is surely false.
> +	 */
> +	if (new_end_pfn < old_start_pfn || new_start_pfn > old_end_pfn)
> +		return;
> +
> +	/*
> +	 * If the moved pfn range is adjacent to the old zone span,
> +	 * check the range to the left or to the right
> +	 */
> +	if (new_end_pfn == old_start_pfn || new_start_pfn == old_end_pfn) {
> +		zone->contiguous = old_contiguous &&
> +			check_zone_contiguous(zone, new_start_pfn, new_nr_pages);

It's sufficient to check that a single pageblock at the old start/end 
(depending where we're adding) has the same zone already.

Why are we checking the new range we are adding? That doesn't make sense 
unless I am missing something. We know that that one is contiguous.

> +		return;
> +	}
> +
> +	/*
> +	 * If old zone's hole larger than the new filled pages, the contiguous
> +	 * property is surely false.
> +	 */
> +	new_filled_pages = new_end_pfn - old_start_pfn;
> +	if (new_start_pfn > old_start_pfn)
> +		new_filled_pages -= new_start_pfn - old_start_pfn;
> +	if (new_end_pfn > old_end_pfn)
> +		new_filled_pages -= new_end_pfn - old_end_pfn;
> +	if (new_filled_pages < old_absent_pages)
> +		return;

I don't quite like the dependence on present pages here. But I guess 
there is no other simple way to just detect that there is a large hole 
in there that cannot possibly get closed.

> +
> +	set_zone_contiguous(zone);
> +}
> +
>   #ifdef CONFIG_ZONE_DEVICE
>   static void section_taint_zone_device(unsigned long pfn)
>   {
> @@ -752,6 +793,10 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>   {
>   	struct pglist_data *pgdat = zone->zone_pgdat;
>   	int nid = pgdat->node_id;
> +	bool old_contiguous = zone->contiguous;
> +	unsigned long old_start_pfn = zone->zone_start_pfn;
> +	unsigned long old_nr_pages = zone->spanned_pages;
> +	unsigned long old_absent_pages = zone->spanned_pages - zone->present_pages;
>   
>   	clear_zone_contiguous(zone);
>   
> @@ -783,7 +828,8 @@ void move_pfn_range_to_zone(struct zone *zone, unsigned long start_pfn,
>   			 MEMINIT_HOTPLUG, altmap, migratetype,
>   			 isolate_pageblock);
>   
> -	set_zone_contiguous(zone);
> +	update_zone_contiguous(zone, old_contiguous, old_start_pfn, old_nr_pages,
> +				old_absent_pages, start_pfn, nr_pages);
>   }
>   
>   struct auto_movable_stats {
> diff --git a/mm/mm_init.c b/mm/mm_init.c
> index 7712d887b696..04fdd949fe49 100644
> --- a/mm/mm_init.c
> +++ b/mm/mm_init.c
> @@ -2263,26 +2263,43 @@ void __init init_cma_pageblock(struct page *page)
>   }
>   #endif
>   
> -void set_zone_contiguous(struct zone *zone)
> +/*
> + * Check if all pageblocks in the given PFN range belong to the given zone.
> + * The given range is expected to be within the zone's pfn range, otherwise
> + * false is returned.
> + */
> +bool check_zone_contiguous(struct zone *zone, unsigned long start_pfn,
> +			    unsigned long nr_pages)
>   {
> -	unsigned long block_start_pfn = zone->zone_start_pfn;
> +	unsigned long end_pfn = start_pfn + nr_pages;
> +	unsigned long block_start_pfn = start_pfn;

Can be const.


-- 
Cheers

David

