Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 511BFC55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:53:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25CEA6B0088; Wed,  5 Aug 2026 07:53:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 20E1A6B008A; Wed,  5 Aug 2026 07:53:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0FDF56B0092; Wed,  5 Aug 2026 07:53:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CD01C6B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:53:32 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 56A32A0478
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:53:32 +0000 (UTC)
X-FDA: 85067055864.21.3E3D48F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8055C4000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:53:30 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n44OP+eV;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785930810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=31aVGJaX8RfL2Z5AdJBa9EWJWJvZ7u5FlbxMmmgXeR4=;
	b=OWf8z03uKgQNzvIXpAH10rBe2CCFFD+K5Qp0NgLXMUtIRifcfD8qxPAjirjwuZuUdg+WGr
	DZzvCyuJGyNC4p3pUZITwUBxa8Z/lB/5VZ9ESsyWWVTb7KoN4gI44e0yUDci2eScEMbrEZ
	aDW/Kx/kogO5EkLqnAn5g2Ex7XQhGqU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785930810;
	b=qRjypyxEo37EweN2CxuqwVqSXyueO/sPoIKtpnHFI1YNbPWD4SQkf/6HuYILtHD3gDqaQ6
	RjUUmx0b0QK4A0KSBSeh/FRGRpLFCLEjhy+QiOxTdFMdecqO7S63jKhEGDid6f7OKV+84H
	vDZxjAiLwq8TNN4PqQYqBDsl3opqx2I=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n44OP+eV;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4ED5D60A96;
	Wed,  5 Aug 2026 11:53:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C30A41F000E9;
	Wed,  5 Aug 2026 11:53:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785930809;
	bh=31aVGJaX8RfL2Z5AdJBa9EWJWJvZ7u5FlbxMmmgXeR4=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n44OP+eVydoeseseSlqTMb2x/wTcxbuZl44rAjzXQArJ8s8Wh44vNGO6vkJRi34lT
	 9U3kVOWuU7e/ddFI5EYlnHrAwpElkAbrYaivRUKxvRNqAhXREgJZK4HJ9d2WFjUfFd
	 leXZtDa2/Fi4vpgRob4krAZdeUYYZFeAJAdPaUgJcLPDWTPrk34qhBaQDABLOtIS6K
	 kmNXYIhq6nBkMCGzG2nWzEDMBiOZcmvS7GUjxGLo56LoFea9mNBqM9zlcWaKV565w6
	 GRjm4wiOvC+X/+ohU7xDlGwFzcPz95NoVBBSpgpV3yKhOvZRMUxpAJVTM9tvxhvbRd
	 hPFZwa9D+LMaw==
Message-ID: <a15107de-ab16-433a-a504-72c3e8dbf2a6@kernel.org>
Date: Wed, 5 Aug 2026 13:53:23 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
To: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, Nanhai Zou <nanhai.zou@intel.com>,
 Pan Deng <pan.deng@intel.com>, Tianyou Li <tianyou.li@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, Jason Zeng <jason.zeng@intel.com>,
 linux-kernel@vger.kernel.org
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-2-yuan1.liu@intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260723084946.189392-2-yuan1.liu@intel.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 8055C4000C
X-Stat-Signature: 5r98scw9ifmyiuuxyzsdqd9edzfb643g
X-HE-Tag: 1785930810-94891
X-HE-Meta: U2FsdGVkX19lShOgnC5qFWylv69uLuXHGsYfetD5YHNKyOeIdmHmsqvcF8z1ajAN82dY+oqE3pXsrzhilqZ8f3ysPqdHXvUXUfQtifSyrCK0ZmzuLrnhfvMVGvqfNb/CjbwY/N0akL3377uS1E/UohIbh1IVwZu51ACpGn2grNsVnYVqudfg8f1fRqFhgkg8YyGMjbPBxPBMeyK+4m2pgDAqCjvqyECxW2Be9aCXCMAKzWmPL3zfZLLm1zxflMsFchFkiWoIE6FJOxLFTZhUW9jlJwxJIiv4T4SrZQXWPW5uPwq/I/8C2CmavblT60JXlMyAIrGHUlRdiKyHrsLsGvXYkY0tTAkwhCchSlG8vUlVpOMY5DZUpCdtARrrfclVBzPFn7DUwd8VgLocxGvi0LT21rHfbpK0dPdlHeGN83TLtSOQ7Rl52HrseAudg6CeJ8jDYJmNesPShGh8zSpAMkWa0kKRfTSklg892CHSTB+oTINa9OpuyzAGcnyeQxCNLhLX8EgVI2wvUAk/Ov9+zS54EWwJKX5iTLLbdLZAKF5N6u3Y5h/tLpQ25g/CbrQfPsNw+NMeKyOQ69v1OiRNIZCRPZLRKvK42nr5esB4FEW54Uj6C2vsLYwbHIlmBeO2TJMqhKnTtJB3wZJTJz3D72xxOifHKc4psNU8oN7Tyd+P3KIZXVWUUfq9UfVaWDZGONvUPuyx6RcSnZ6GB4Z0RIV3aQd1Qf7NIXt8VRJHzvSkDSK8SwLoP40VaRCrmxWY0dq3EEtny3VJMUcy9bRogVc1OqrovoTaFeqD0Uf6j7SsNyOoYGfsIF8KAc6M/0gzyP+H0nyoBHWhSu4zysyiIh/lH5tPKwdPZitKorlLrpQ4kKpG4DXBltrYuSuImMdbDG1z6S4ZNGebevHoHzSPubDeNp/p9XAHGz9OgG2ZBVITtiUiD9stu7NVP55EWi4u16peiiH4UizZ1uVsxLb
 dg5YvcMY
 Irs7tzIBum7SNIkGO5suZlviCAik0a7RtTrRbX2tenSqbi/In9hCbWxKPTUGGSARDgmPLDeKgCes1KKXOghsWwbxpdcIqjTzOgzaNtlsLfA+Rw9QdOE6sbNXnMeWlbAFp1pFQLKVNGE++o8Grg44duwxDcmy57neDZV20WoJ3ewB6Iy9AP9XzCLeBgOs0lYckXhAELguzkrJuphbAnrczY4+mVSZ2u4Ls1r4aXfVvqHXAFfi9eGjkpd3tQmg5lW0o3akHwLFCntopfKaf/UpwE/1MwDQ1Njr2GvMxpbDjnW5YRo3jJAJaBUZGSfksjiI2iPiFM0F7phefyjgaJcjKaEiBny/o05HmqpBNbAT0i2UwR7LYEl4qHa+Q87awnCny/QhDVzD6xuJ6HaK2hykWRIU5Wj6m2+VXgD99K9nuULXaC4g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/23/26 10:49, Yuan Liu wrote:
> When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
> zone, set_zone_contiguous() rescans the entire zone
> pageblock-by-pageblock to rebuild zone->contiguous. For large zones this
> is a significant cost during memory hotplug and hot-unplug.
> 
> Add a new zone member pages_with_online_memmap that tracks the number of
> pages within the zone span that have an online memory map (including
> present pages and memory holes smaller than a subsection whose memory
> map has been initialized). When spanned_pages == pages_with_online_memmap
> the zone is contiguous and pfn_to_page() can be called on any PFN in the
> zone span without further pfn_valid() checks.
> 
> For early boot memory, pages_with_online_memmap is calculated in
> memmap_init_zone_range(). Since every PFN within a memblock region
> satisfies pfn_to_online_page(), the calculation aligns both boundaries
> of each memblock range to PAGES_PER_SUBSECTION and counts the aligned
> pages that fall within the zone span. If two adjacent memblock regions
> share a subsection (i.e. the hole between them is smaller than a
> subsection), the overlapping subsection pages are counted only once.
> For hotplugged memory, pages_with_online_memmap is updated through
> adjust_present_page_count(), which is called during memory online and
> offline.
> 
> Only pages that fall within the current zone span are accounted towards
> pages_with_online_memmap. A "too small" value is safe, it merely
> prevents detecting a contiguous zone.
> 
> The contiguity check using pages_with_online_memmap is stricter than the
> old pageblock-by-pageblock scan. The old set_zone_contiguous() iterated
> at pageblock granularity via pageblock_pfn_to_page(), so a zone could be
> marked contiguous even if a subsection-sized hole existed within a
> pageblock. The new check requires
> spanned_pages == pages_with_online_memmap, meaning every PFN in the zone
> span must satisfy pfn_to_online_page().
> 
> The following test cases of memory hotplug for a VM [1], tested in the
> environment [2], show that this optimization can significantly reduce
> the memory hotplug time [3].
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
> Reviewed-by: Pan Deng <pan.deng@intel.com>
> Reviewed-by: Jason Zeng <jason.zeng@intel.com>
> Co-developed-by: Tianyou Li <tianyou.li@intel.com>
> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
> ---
>  Documentation/mm/physical_memory.rst | 13 +++++++
>  drivers/base/memory.c                |  6 +++
>  include/linux/mmzone.h               | 47 ++++++++++++++++++++++
>  mm/internal.h                        |  8 +---
>  mm/memory_hotplug.c                  | 12 +-----
>  mm/mm_init.c                         | 58 +++++++++++++++++-----------
>  6 files changed, 105 insertions(+), 39 deletions(-)
> 
> diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
> index b76183545e5b..0aa65e6b5499 100644
> --- a/Documentation/mm/physical_memory.rst
> +++ b/Documentation/mm/physical_memory.rst
> @@ -483,6 +483,19 @@ General
>    ``present_pages`` should use ``get_online_mems()`` to get a stable value. It
>    is initialized by ``calculate_node_totalpages()``.
>  
> +``pages_with_online_memmap``
> +  Tracks pages within the zone that have an online memory map (present pages
> +  and memory holes whose memory map has been initialized). When
> +  ``spanned_pages`` == ``pages_with_online_memmap``, ``pfn_to_page()`` can be
> +  performed without further checks on any PFN within the zone span.
> +
> +  Note: this counter may temporarily undercount when pages with an online
> +  memory map exist outside the current zone span. This can only happen during
> +  boot, when initializing the memory map of pages that do not fall into any
> +  zone span. Growing the zone to cover such pages and later shrinking it back
> +  may result in a "too small" value. This is safe: it merely prevents
> +  detecting a contiguous zone.

It's suboptimal that we repeat the same comment that we already have in struct
zone. Can we just keep it vry simple here?

"Pages within the zone that have an online memory map: present pages and memory
holes whose memory map has been initialized. See XXX for more details."

> +
>  ``present_early_pages``
>    The present pages existing within the zone located on memory available since
>    early boot, excluding hotplugged memory. Defined only when
> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
> index bcfe2d9f4adb..237ace435372 100644
> --- a/drivers/base/memory.c
> +++ b/drivers/base/memory.c
> @@ -246,6 +246,7 @@ static int memory_block_online(struct memory_block *mem)
>  		nr_vmemmap_pages = mem->altmap->free;
>  
>  	mem_hotplug_begin();
> +	clear_zone_contiguous(zone);
>  	if (nr_vmemmap_pages) {
>  		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
>  		if (ret)
> @@ -270,6 +271,7 @@ static int memory_block_online(struct memory_block *mem)
>  
>  	mem->zone = zone;
>  out:
> +	set_zone_contiguous(zone);
>  	mem_hotplug_done();
>  	return ret;
>  }
> @@ -282,6 +284,7 @@ static int memory_block_offline(struct memory_block *mem)
>  	unsigned long start_pfn = section_nr_to_pfn(mem->start_section_nr);
>  	unsigned long nr_pages = PAGES_PER_SECTION * sections_per_block;
>  	unsigned long nr_vmemmap_pages = 0;
> +	struct zone *zone;

Why the temporary variable, and why not initialize it directly here? Note that

>  	int ret;
>  
>  	if (!mem->zone)

We already use mem->zone here. So if you add a variable, convert that one as
well. But I guess we can just life without one.

> @@ -294,7 +297,9 @@ static int memory_block_offline(struct memory_block *mem)
>  	if (mem->altmap)
>  		nr_vmemmap_pages = mem->altmap->free;
>  
> +	zone = mem->zone;
>  	mem_hotplug_begin();
> +	clear_zone_contiguous(zone);
>  	if (nr_vmemmap_pages)
>  		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
>  					  -nr_vmemmap_pages);
> @@ -314,6 +319,7 @@ static int memory_block_offline(struct memory_block *mem)
>  
>  	mem->zone = NULL;
>  out:
> +	set_zone_contiguous(zone);
>  	mem_hotplug_done();
>  	return ret;
>  }

[...]

> +static inline void set_zone_contiguous(struct zone *zone)
> +{
> +	if (zone_is_zone_device(zone))
> +		return;
> +	if (zone->spanned_pages == zone->pages_with_online_memmap)
> +		zone->contiguous = true;

Maybe it was already discussed (and I recall that we previously had that), but I
think we really need READ_ONCE semantics here and WRITE_ONCE semantics in memory
hotplug code. Otherwise concurrent updates could lead to weird things when the
compiler does load-tearing.


[...]

>  
> +static void __init update_zone_online_memmap_pages(struct zone *zone,
> +						   unsigned long start_pfn,
> +						   unsigned long end_pfn,
> +						   unsigned long *hole_pfn)
> +{
> +#ifdef CONFIG_SPARSEMEM_VMEMMAP
> +	unsigned long zone_start_pfn = zone->zone_start_pfn;
> +	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;

These two can be const.

> +	unsigned long sub_start, sub_end;
> +
> +	sub_start = max(ALIGN_DOWN(start_pfn, PAGES_PER_SUBSECTION),
> +			zone_start_pfn);
> +	sub_end = min(ALIGN(end_pfn, PAGES_PER_SUBSECTION), zone_end_pfn);

Hm, I don't immediately understand why we do the PAGES_PER_SUBSECTION thing
here. Why is that required?
-- 
Cheers,

David

