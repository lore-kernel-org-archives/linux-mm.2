Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 385F4D3943C
	for <linux-mm@archiver.kernel.org>; Thu,  2 Apr 2026 14:57:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 201536B0088; Thu,  2 Apr 2026 10:57:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B2436B0089; Thu,  2 Apr 2026 10:57:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A1C76B008A; Thu,  2 Apr 2026 10:57:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EC2D66B0088
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 10:57:27 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A3CFFBAE46
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:57:27 +0000 (UTC)
X-FDA: 84613919334.26.1DD5F4F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id A121414000D
	for <linux-mm@kvack.org>; Thu,  2 Apr 2026 14:57:25 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cB6xcO46;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775141845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CvBSyTNXvqof8UX1/oUBnJqMsSDD7wia8djOdxU4wjA=;
	b=2GugUuei0WPLOtzfrpnUWXFCkRD9tfpM+QkfAFflt6RXMgdAnDJ0r5OEuIYFxutURTEZkG
	D7q53fB1Cqj6qzBo1xArazeHwoNkkt8sVFPFUURhf97Sy16miazIvUoNWvI84khBpL97XP
	1LNFgwswc2KvkATrVG4v47bXUtvPoHc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775141845; a=rsa-sha256;
	cv=none;
	b=VDN/9zfnVsrM4zgMhOIODWvcMKeGNqPZANruTYL50BfiadTyTsIDO1lDhPpP+KJenCeTzG
	F0rmcWtQVnT3F+O9nc/O3tLO9ughzy/EZeDOXAZBwUvEeBp87u8ITU2PPxBBPZYOvnojgv
	rSk77jJBi4QYcMI0hjSv2d7b/9MtmHk=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=cB6xcO46;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 00BC960123;
	Thu,  2 Apr 2026 14:57:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE33C116C6;
	Thu,  2 Apr 2026 14:57:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775141844;
	bh=G19qJFmt2AonBprkfDZPrfxmtSWXvwcPHqcht7Xl9Co=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=cB6xcO461o97vrayCR3JfcDh/zOPA/q4lbI9o36GawbhDw4YLvOjlSFrpKQRYbjV4
	 LQf6pwG4+kDcl+MvsPPgPVp2KZvEal5jvAMSBBKsGtdqkGn0pTg2TzMrPInUasiDAV
	 eORGA6+KZ6Ayv9/CB9cYASBW1ZTaFx+5VzkFxKaHlfGQ4rzq4iaQxQriyti8acQMn0
	 ALljyrWkubYz9x9oPOYkyU5PEVzbW0abCOarhxxDr+9PPdZV19wy9Yc8ksV7J+rYjh
	 fOkRg/vZU1xr7M/AH6KlKSik46Nqez/v7Nqax3ei3KeNhEtN74eS19GajlkeOfKmf1
	 RANirHk/82Cnw==
Message-ID: <a761a39b-3907-4d88-831f-f9c979802171@kernel.org>
Date: Thu, 2 Apr 2026 16:57:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
To: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
 Qiuxu Zhuo <qiuxu.zhuo@intel.com>, Yu C Chen <yu.c.chen@intel.com>,
 Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20260401070155.1420929-1-yuan1.liu@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260401070155.1420929-1-yuan1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A121414000D
X-Stat-Signature: tqygrga5jzhke6ithpiqkdz63xgckpih
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1775141845-839298
X-HE-Meta: U2FsdGVkX1+iRIv4ulmkwb/FnH8/77ORE5cuyYuj5cVNMY6Pvxc/RL8GV9iXX/WRCD3Q8pBuySOCD8Ms6gNwAgGjGmsXUCZL9lYiUGpl9f5/vgn6PRCxAUBMkOlo4c/FVbzyQ7J3hXpRuXzQZY1emp16IMKV/GwGHKD96DBb06BSlSVRxipnyNKUUOIwfKwY3PdbDQHQboXPhoZczF3kNAFO4d0QTgGIh4WwJeWDXwkiOQKS/G7vXw2Im9sddc1d0Z83axyYCa3KWI7XJTehP7/p8zeCqFskUjXHOe6X6RSKcwH5eQd/QY88/WL7gSUerLnGjHuVoUPbHzIUGUOmgJsXndjbb5Ohst77d3i2can79/Ue75OZFO4kD0mBFmj1DW+nOXmsP+9HVYZpF0EWc56zi7JMXqXOePkPZ/td1Sht0hjDatibjyQSWtCTOLFrwFBP6M4or+YGHJDwY0wbDVoKI8agJgo1m4G7HRiY5AfyegGOUOVZ+VtlT2EmmeSYc/Eh3+48C1ycOXLiLZc+YhB8wFtflXN+VZTnRSzdKqjCeSOl9O0oMJdr577nNgMeUvcTSnrSHLXuB5LUA6rPlfS0xfZlaxEmM6UuQJaU1uIPqAl6mw6NIfiZGpxcqZVt98ldvJdIy52NUWUCXWVxv3Asq+LnlzomtJHDXAYpNjvfmyIsVB1e5cOv7l0MstJv6yAM7V1wmQO6CKSSwLLQsYNljKOGrAYUGPDGDQ3/OcgIbiyHePwzuLSGkbxnUautO8mOH5beTZ/klsoGG6ayGAHQehfYglV0U/TD1eSYFJy9XEL2sjCR92fcSrQAhI1+wSTSThqXKeMfTulOqg1eDGkaWN2OzNhs6t+zjGJGkrBiIhnKJx3xM5XaAqo4DUPMCc0jJJjVNFKWJOFUBXE2XecW7aOQpiOqonYvX5DRa4vViZjNbUkB4jZXaXmaMreuwCSe8K0HG3mc66FGv+4
 XnDC16Tj
 XSTs3odxoRCEVZnt078PR+AImE3p6Op2v5fYwyvbdNUHd417PQKDXIPaa+OrMv64wz/CEcqVA9l1OKJ7tV0B/u7idrSrqsz/5OgXMU+4nhOod7pnnp13/pOlqU0BG/97jorCdHmg08vBV+x3Yt6JVQYav3Fik6i/VvVOl9KhmTgaGad25Zw/lxB1xydHx8lzY7TqcNDsxjpXQ1W2kYoW+gNRDbpCJgJ4NZaDAZSq3jwOppAWJodwUTdsf6+2YLg2dk8JL0FBJlJVoGRusR+w6lwr7Grc8NtJehtSoXISleRZZCOakGSJXEM1eamr+BK+rfPybB+VEKvgfoNX012fH/mD7mBsiJ1SABjxKKufPS+wjnsTq3LhbiDiJ2cM6+MLa2WILv58qEyrNjNgk+Uuo6wBCig==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 09:01, Yuan Liu wrote:
> When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
> zone, set_zone_contiguous() rescans the entire zone pageblock-by-pageblock
> to rebuild zone->contiguous. For large zones this is a significant cost
> during memory hotplug and hot-unplug.
> 
> Add a new zone member pages_with_online_memmap that tracks the number of
> pages within the zone span that have an online memmap (including present
> pages and memory holes whose memmap has been initialized). When
> spanned_pages == pages_with_online_memmap the zone is contiguous and
> pfn_to_page() can be called on any PFN in the zone span without further
> pfn_valid() checks.
> 
> Only pages that fall within the current zone span are accounted towards
> pages_with_online_memmap. A "too small" value is safe, it merely prevents
> detecting a contiguous zone.
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
> Co-developed-by: Tianyou Li <tianyou.li@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> ---
>  Documentation/mm/physical_memory.rst | 11 +++++
>  drivers/base/memory.c                |  6 +++
>  include/linux/mmzone.h               | 44 +++++++++++++++++++
>  mm/internal.h                        |  8 +---
>  mm/memory_hotplug.c                  | 12 +-----
>  mm/mm_init.c                         | 64 +++++++++++++++++-----------
>  6 files changed, 102 insertions(+), 43 deletions(-)
> 
> diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> index b76183545e5b..e47e96ef6a6d 100644
> --- a/Documentation/mm/physical_memory.rst
> +++ b/Documentation/mm/physical_memory.rst
> @@ -483,6 +483,17 @@ General
>    ``present_pages`` should use ``get_online_mems()`` to get a stable value. It
>    is initialized by ``calculate_node_totalpages()``.
>  
> +``pages_with_online_memmap``
> +  Tracks pages within the zone that have an online memmap (present pages and
> +  memory holes whose memmap has been initialized). When ``spanned_pages`` ==
> +  ``pages_with_online_memmap``, ``pfn_to_page()`` can be performed without
> +  further checks on any PFN within the zone span.
> +
> +  Note: this counter may temporarily undercount when pages with an online
> +  memmap exist outside the current zone span. Growing the zone to cover such

Maybe add here "This can only happen during boot, when initializing the
memmap of pages that do not fall into any zone span."


> +	 * we will not try to shrink the zones.

s/zone/it/ ?
[...]

> +
> +/*
> + * Initialize unavailable range [spfn, epfn) while accounting only the pages
> + * that fall within the zone span towards pages_with_online_memmap. Pages
> + * outside the zone span are still initialized but not accounted.
> + */
> +static void __init init_unavailable_range_for_zone(struct zone *zone,
> +						   unsigned long spfn,
> +						   unsigned long epfn)

Best to use double tab to fit this into a single line

		unsigned long spfn, unsigned long epfn)

		^ two tabs

> +{
> +	int nid = zone_to_nid(zone);
> +	int zid = zone_idx(zone);

Both can be const.

> +	unsigned long in_zone_start;
> +	unsigned long in_zone_end;
> +
> +	in_zone_start = clamp(spfn, zone->zone_start_pfn, zone_end_pfn(zone));
> +	in_zone_end = clamp(epfn, zone->zone_start_pfn, zone_end_pfn(zone));
> +
> +	if (spfn < in_zone_start)
> +		init_unavailable_range(spfn, in_zone_start, zid, nid);
> +
> +	if (in_zone_start < in_zone_end)
> +		zone->pages_with_online_memmap +=
> +			init_unavailable_range(in_zone_start, in_zone_end,
> +					       zid, nid);

Best to use a temporary variable to make this easier to read.

		pgcnt = init_unavailable_range(in_zone_start, ...

You can also exceed 80c a bit if it aids readability.

> +
> +	if (in_zone_end < epfn)
> +		init_unavailable_range(in_zone_end, epfn, zid, nid);
>  }


Only nits, hoping we don't miss anything obvious (or any corner case :) ).

If Mike tells us that we are processing all pages during boot
appropriately, this should work.

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

