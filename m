Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7ECA5C79FBF
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 15:40:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 690EB6B0099; Thu, 10 Sep 2026 11:40:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 641826B009B; Thu, 10 Sep 2026 11:40:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 548E06B009D; Thu, 10 Sep 2026 11:40:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2B5E06B0099
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 11:40:10 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AF22512056C
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:40:08 +0000 (UTC)
X-FDA: 85198263696.04.3B5829D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C7A821C0006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 15:40:06 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e74Wo8lc;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789054806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dKt7ZEKAOjaYK5zl0yDCbXzIcJB2UTW/n2o2nRszZxw=;
	b=rlDaLrc4YasXA9KyM104NemU0Rl95neA8VBwfSQQcjhL83y+wqO0nqcUsaRRcb6mE5HKnh
	3G3wIk9fKlk1UZp0pLMc1vic1Rv6Qkmhwmh1zx+EK1YYsM0b0ttvuW4xrjBQAXqYSwPR8l
	9K4FsDFuYX5a8MG4o6GwycdMjURZwMs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789054806;
	b=FvmHULObOtDb7Hcoxo/+erZm+a7epQXoFLkrdE01yHox7v68l6Xxb2h1clI2h9Mhfsb7AP
	x1CGPWLoXsX76Iv8PV+AVTGeB/wa0Ml4irufaxm1Go+e1wXL1DvyicA5m0uGdsyt1Jb7Uf
	FOayy4/NzhUt01gOWcHrxnwwdjwPKBY=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=e74Wo8lc;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 11A9C42A87;
	Thu, 10 Sep 2026 15:40:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3EAD1F000FF;
	Thu, 10 Sep 2026 15:40:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789054806;
	bh=dKt7ZEKAOjaYK5zl0yDCbXzIcJB2UTW/n2o2nRszZxw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=e74Wo8lcuGe66beVgh35vTlfSYjYOgh1yT2IubpqbRHkqSfEo99s9FnukaQpFAXDf
	 wpW8zlA0dQBZjoe0mr6Kj6t6SSFwzBbQPFg3W77sH9yTeA2qoPqwykEXKbrhyGqnRl
	 l9XolbhPhNbEPtaBYJluX/7gRH2QtiV0U01CrCWqLaJfXhT29XPKKznJAY3bgoMjCs
	 wE+xHtGEm/BqkZfqvvayRvtQFwuKa2mW2mfbomTRVbAy+BiVUDAbD0/KXQ1a06GQUv
	 y7/Ye4s90QvzUUIUjSyDMAO7uDGaHBdWma/l8LxnQFPXMLrYEQJZifkrDdiFaY9o6l
	 bPR/IdBsvB+nw==
Message-ID: <a144c84d-bf82-49b5-b9ad-0f6938fd9b4b@kernel.org>
Date: Thu, 10 Sep 2026 17:39:58 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 2/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
To: Wei Yang <richard.weiyang@gmail.com>, Yuan Liu <yuan1.liu@intel.com>
Cc: Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
 linux-mm@kvack.org, Nanhai Zou <nanhai.zou@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, Jason Zeng <jason.zeng@intel.com>,
 Chen Yu <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Tianyou Li <tianyou.li@intel.com>, linux-kernel@vger.kernel.org
References: <20260901052950.3284540-1-yuan1.liu@intel.com>
 <20260901052950.3284540-3-yuan1.liu@intel.com>
 <20260904073856.5r56imgrwtpe56wl@master>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260904073856.5r56imgrwtpe56wl@master>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: x1qgsrmf3w9o5w7xnmqq8dxfindr7kf4
X-Rspamd-Queue-Id: C7A821C0006
X-HE-Tag: 1789054806-887281
X-HE-Meta: U2FsdGVkX19cGBoH3xJkyaVggigMs12aYkhVOhFoTmEcb4VcvKmhTwzfptJsMIdfaz/fea+SPu6T9GMv7ZVekxxPbLawiTQUcjOX8e2J6+xwNaosFomvneKE4/eUksWdINuSHaAsbXcDmD8Xc/weoN0oCLq2J9PjEyqeO8DMmr1lSzDX0Z4jncNZM/6UMrQQVXyb0eRhfNXmue5DGe1K+q2gxDKQyke0mSGFApRbLIzDVVducnzPIYsrivjvIKzy8WQi7BO1H3rZ1rriPwwR59zv2j99BlpBP/R0v46u7fKiGYZ0yUb46I4HKgeuqD1e6X+4u1BhvHqX3+RDIzQYjwGBygNNSC2FQMri5FKn23Ie/x5QZpnWOPVrcvpd5pzU3Qvn2jUcKb+544KULKE0hdygv7XVJhlZO2e+J054H4+I5igkAJg9GidKk8jPc75THJx5mWqH2761BDUdgSMNfF8Xv+wThl4OT4XYH7J/oLo8FTfiE0EY77vFxE6/FySBug9NaJYBdm46xPQZYSfPTN/v9+JTpk5SEQT4wxz1BYdhkleeAsSHv7eLzCgXdhjLkywYZ6aw6JnWFNN6jnwKZ2yNkBubialtBAy8tVx9i00xUaDDkdTvXXTtixyfclvOlYw6pqqzgfGRwrJspRjmrIohiqH43XLXGDbY2jyAlprsbAFZEn8HrDjzAvwDdZsgsTc0kQky8tUpFGGFsyA63OhsMoLacw/tbY5VWV2/kV0p30iWIaywHkgZvG4kk/CBbZtCycHOfnRCsOPqeRPBYZevBUxQQdfcQJUBkcoBIC55v2gzvpFB0oFDRg/V3Z0MDZSdVWKXkomIctT47UdfUrgNMUZMgjipOg0IH7uhC/OHMq+IkGieihOonWNNJLuU6m05qf3SMJ2gE8XUFDZEaL6MC3MtDF6iU96F3JvGf2tSZwiQlRC3Zzm3Vsx+QduEPLNv6zDjsv7kXBZT3MC
 yjcxStU4
 vVXQyAMt1Nl/VlgQT36TtGrvgHsgt9w6pg2pG2TJQhy0EBINaqONmTyu5dAdZWyeTLFj6Rv4z1SFtvK8lCkaSbm/mQe18YC9OkB4fLTvYUk16HHzw+wwbO313YAWF+iwJjZq51pn7yIVECRhxUDKKEfXzGkkZ7xVvd9Ml7BclauaBxRu4r4ftBGIbsv9PuhRN0j/zoi+uMbkBoZ4VP/dLqsmgJaEo+cZdZd9VGwK9sfnQy9c1Uyh5aUI69DWvkSY7892RlK++e5/npmwVv8pyBd2PkZzakVwA8ndXmGRzNtCQx1vvqfKkonQJOcEj7HHVxGAQ9KgWze+LbD7ndLQlnFm4erGpS9W5WpSZ1YKgRRlaYwVCLLKAB2O3nYkYtBHYpUuR2KZdhkRWEpNYOFTpVRZ9aXkgTsPjq5htZtNTvBYJHx8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/4/26 09:38, Wei Yang wrote:
> On Tue, Sep 01, 2026 at 01:29:50AM -0400, Yuan Liu wrote:
>> When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
>> zone, set_zone_contiguous() rescans the entire zone pageblock-by-pageblock
>> to rebuild zone->contiguous. For large zones this is a significant cost
>> during memory hotplug and hot-unplug.
>>
>> Add a new zone member, pages_with_online_memmap, that tracks the
>> number of pages within the zone span that have an online memory map,
>> including present pages and memory holes whose memory map has been
>> initialized and for which pfn_to_online_page() succeeds.
>>
>> For early boot memory, pages_with_online_memmap is calculated in
>> memmap_init_zone_range(). PFNs initialized by memmap_init_range() are
>> included in pages_with_online_memmap, and hole PFNs for which
>> pfn_to_online_page() succeeds are also counted in
>> init_unavailable_range(). For hotplugged memory,
>> pages_with_online_memmap is updated through adjust_present_page_count(),
>> which is called during memory online and offline operations. When
>> spanned_pages == pages_with_online_memmap, every PFN in the zone span
>> has a valid memmap entry, so pfn_to_page() can be called for any PFN
>> within the zone span without an additional pfn_valid() check.
>>
>> The counter may temporarily undercount when pages with an online
>> memory map exist outside the current zone span. This can only happen
>> during boot, when initializing the memory map of pages that do not
>> fall into any zone span. Growing the zone to cover such pages and
>> later shrinking it back may result in a value that is too small.
>> This is safe, as it merely prevents detecting a contiguous zone.
>>
>> The contiguity check using pages_with_online_memmap is stricter than
>> the old pageblock-by-pageblock scan. The old set_zone_contiguous()
>> iterated at pageblock granularity via pageblock_pfn_to_page(), so a
>> zone could be marked contiguous even if a subsection-sized hole
>> existed within a pageblock. The new check requires
>> spanned_pages == pages_with_online_memmap, meaning every PFN in the
>> zone span must satisfy pfn_to_online_page().
>>
>> The following test cases of memory hotplug for a VM [1], tested in the
>> environment [2], show that this optimization can significantly reduce the
>> memory hotplug time [3].
>>
>> +----------------+------+---------------+--------------+----------------+
>> |                | Size | Time (before) | Time (after) | Time Reduction |
>> |                +------+---------------+--------------+----------------+
>> | Plug Memory    | 256G |      10s      |      3s      |       70%      |
>> |                +------+---------------+--------------+----------------+
>> |                | 512G |      36s      |      7s      |       81%      |
>> +----------------+------+---------------+--------------+----------------+
>>
>> +----------------+------+---------------+--------------+----------------+
>> |                | Size | Time (before) | Time (after) | Time Reduction |
>> |                +------+---------------+--------------+----------------+
>> | Unplug Memory  | 256G |      11s      |      4s      |       64%      |
>> |                +------+---------------+--------------+----------------+
>> |                | 512G |      36s      |      9s      |       75%      |
>> +----------------+------+---------------+--------------+----------------+
>>
>> [1] Qemu commands to hotplug 256G/512G memory for a VM:
>>    object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>>    device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>>    qom-set vmem1 requested-size 256G/512G (Plug Memory)
>>    qom-set vmem1 requested-size 0G (Unplug Memory)
>>
>> [2] Hardware     : Intel Icelake server
>>    Guest Kernel : v7.3-rc1
>>    Qemu         : v9.0.0
>>
>>    Launch VM    :
>>    qemu-system-x86_64 -accel kvm -cpu host \
>>    -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>>    -drive file=./seed.img,format=raw,if=virtio \
>>    -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>>    -m 2G,slots=10,maxmem=2052472M \
>>    -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>>    -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>>    -nographic -machine q35 \
>>    -nic user,hostfwd=tcp::3000-:22
>>
>>    Guest kernel auto-onlines newly added memory blocks:
>>    echo online > /sys/devices/system/memory/auto_online_blocks
>>
>> [3] The time from typing the QEMU commands in [1] to when the output of
>>    'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>>    memory is recognized.
>>
>> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
>> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
>> Tested-by: Yuan Liu <yuan1.liu@intel.com>
>> Reviewed-by: Jason Zeng <jason.zeng@intel.com>
>> Reviewed-by: Chen Yu <yu.c.chen@intel.com>
>> Reviewed-by: Pan Deng <pan.deng@intel.com>
>> Co-developed-by: Tianyou Li <tianyou.li@intel.com>
>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>> ---
>> Documentation/mm/physical_memory.rst |  6 +++
>> drivers/base/memory.c                |  7 +++-
>> include/linux/mmzone.h               | 48 +++++++++++++++++++++
>> mm/memory_hotplug.c                  | 12 +-----
>> mm/mm_init.c                         | 63 +++++++++++++++-------------
>> mm/mm_init.h                         |  6 ---
>> mm/page_alloc.h                      |  2 +-
>> 7 files changed, 98 insertions(+), 46 deletions(-)
>>
>> diff --git a/Documentation/mm/physical_memory.rst b/Documentation/mm/physical_memory.rst
>> index a09407d72973..2e67e8b23a99 100644
>> --- a/Documentation/mm/physical_memory.rst
>> +++ b/Documentation/mm/physical_memory.rst
>> @@ -480,6 +480,12 @@ General
>>   ``present_pages`` should use ``get_online_mems()`` to get a stable value. It
>>   is initialized by ``calculate_node_totalpages()``.
>>
>> +``pages_with_online_memmap``
>> +  Pages within the zone that have an online memory map: present pages and
>> +  memory holes whose memory map has been initialized and
>> +  ``pfn_to_online_page()`` succeeds. See the comment for
>> +  ``pages_with_online_memmap`` in ``include/linux/mmzone.h`` for more details.
>> +
>> ``present_early_pages``
>>   The present pages existing within the zone located on memory available since
>>   early boot, excluding hotplugged memory. Defined only when
>> diff --git a/drivers/base/memory.c b/drivers/base/memory.c
>> index 5eead3346f1e..28f9503f6a71 100644
>> --- a/drivers/base/memory.c
>> +++ b/drivers/base/memory.c
>> @@ -255,6 +255,7 @@ static int memory_block_online(struct memory_block *mem)
>> 		nr_vmemmap_pages = mem->altmap->free;
>>
>> 	mem_hotplug_begin();
>> +	clear_zone_contiguous(zone);
>> 	if (nr_vmemmap_pages) {
>> 		ret = mhp_init_memmap_on_memory(start_pfn, nr_vmemmap_pages, zone);
>> 		if (ret)
>> @@ -279,6 +280,7 @@ static int memory_block_online(struct memory_block *mem)
>>
>> 	mem->zone = zone;
>> out:
>> +	set_zone_contiguous(zone);
>> 	mem_hotplug_done();
>> 	return ret;
>> }
>> @@ -304,6 +306,7 @@ static int memory_block_offline(struct memory_block *mem)
>> 		nr_vmemmap_pages = mem->altmap->free;
>>
>> 	mem_hotplug_begin();
>> +	clear_zone_contiguous(mem->zone);
>> 	if (nr_vmemmap_pages)
>> 		adjust_present_page_count(pfn_to_page(start_pfn), mem->group,
>> 					  -nr_vmemmap_pages);
>> @@ -321,8 +324,10 @@ static int memory_block_offline(struct memory_block *mem)
>> 	if (nr_vmemmap_pages)
>> 		mhp_deinit_memmap_on_memory(start_pfn, nr_vmemmap_pages);
>>
>> -	mem->zone = NULL;
>> out:
>> +	set_zone_contiguous(mem->zone);
>> +	if (!ret)
>> +		mem->zone = NULL;
>> 	mem_hotplug_done();
>> 	return ret;
>> }
>> diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
>> index 94f9c3ff5416..7bfb871d6344 100644
>> --- a/include/linux/mmzone.h
>> +++ b/include/linux/mmzone.h
>> @@ -1043,6 +1043,21 @@ struct zone {
>> 	 * cma pages is present pages that are assigned for CMA use
>> 	 * (MIGRATE_CMA).
>> 	 *
>> +	 * pages_with_online_memmap tracks pages within the zone that have
>> +	 * an online memory map: present pages and memory holes whose
>> +	 * memory map has been initialized and pfn_to_online_page()
>> +	 * succeeds. When spanned_pages == pages_with_online_memmap,
>> +	 * pfn_to_page() can be performed without further checks on any
>> +	 * PFN within the zone span.
>> +	 *
>> +	 * Note: this counter may temporarily undercount when pages with an
>> +	 * online memory map exist outside the current zone span. This can
>> +	 * only happen during boot, when initializing the memory map of
>> +	 * pages that do not fall into any zone span. Growing the zone to
>> +	 * cover such pages and later shrinking it back may result in a
>> +	 * "too small" value. This is safe: it merely prevents detecting a
>> +	 * contiguous zone.
>> +	 *
>> 	 * So present_pages may be used by memory hotplug or memory power
>> 	 * management logic to figure out unmanaged pages by checking
>> 	 * (present_pages - managed_pages). And managed_pages should be used
>> @@ -1067,6 +1082,7 @@ struct zone {
>> 	atomic_long_t		managed_pages;
>> 	unsigned long		spanned_pages;
>> 	unsigned long		present_pages;
>> +	unsigned long		pages_with_online_memmap;
>> #if defined(CONFIG_MEMORY_HOTPLUG)
>> 	unsigned long		present_early_pages;
>> #endif
>> @@ -1694,6 +1710,38 @@ static inline bool zone_is_zone_device(const struct zone *zone)
>> }
>> #endif
>>
>> +/**
>> + * zone_is_contiguous - test whether a zone is contiguous
>> + * @zone: the zone to test.
>> + *
>> + * In a contiguous zone, it is valid to call pfn_to_page() on any PFN in the
>> + * spanned zone without requiring pfn_valid() or pfn_to_online_page() checks.
>> + *
>> + * Note that missing synchronization with memory offlining makes any PFN
>> + * traversal prone to races.
>> + *
>> + * ZONE_DEVICE zones are always marked non-contiguous.
>> + *
>> + * Return: true if contiguous, otherwise false.
>> + */
>> +static inline bool zone_is_contiguous(const struct zone *zone)
>> +{
>> +	return READ_ONCE(zone->contiguous);
>> +}
>> +
>> +static inline void set_zone_contiguous(struct zone *zone)
>> +{
>> +	if (zone_is_zone_device(zone))
>> +		return;
> 
> After this patch, set_zone_contiguous() is only used in two cases:
> 
>   * memory_block_online()
>   * page_alloc_init_late()
> 
> If I understand correctly:
> 
>   * zone_for_pfn_range() won't return ZONE_DEVICE
>   * there is no ZONE_DEVICE memory populated at this point, device memory is
>     populated during do_initcalls()
> 
> So we don't expect ZONE_DEVICE here?
> 
>> +	if (zone->spanned_pages == zone->pages_with_online_memmap)
>> +		WRITE_ONCE(zone->contiguous, true);
>> +}
>> +
>> +static inline void clear_zone_contiguous(struct zone *zone)
>> +{
>> +	WRITE_ONCE(zone->contiguous, false);
>> +}
>> +
>> /*
>>  * Returns true if a zone has pages managed by the buddy allocator.
>>  * All the reclaim decisions have to use this function rather than
>> diff --git a/mm/memory_hotplug.c b/mm/memory_hotplug.c
>> index 9f19876ec3ec..100941d1b828 100644
>> --- a/mm/memory_hotplug.c
>> +++ b/mm/memory_hotplug.c
>> @@ -549,18 +549,13 @@ void remove_pfn_range_from_zone(struct zone *zone,
>>
>> 	/*
>> 	 * Zone shrinking code cannot properly deal with ZONE_DEVICE. So
>> -	 * we will not try to shrink the zones - which is okay as
>> -	 * set_zone_contiguous() cannot deal with ZONE_DEVICE either way.
>> +	 * we will not try to shrink it.
>> 	 */
>> 	if (zone_is_zone_device(zone))
>> 		return;
> 
> One question not closely related to this patch.
> 
> This check is introduced in commit 7ce700bf11b5 ("mm/memory_hotplug: don't
> access uninitialized memmaps in shrink_zone_span()"), at that time
> pfn_to_online_page() couldn't handle ZONE_DEVICE pfn correctly.
> 
> Then commit 1f90a3477df3 ("mm: teach pfn_to_online_page() about ZONE_DEVICE
> section collisions") enables it.

That's something different. pfn_to_online_page() will always fail on ZONE_DEVICE
parts as ZONE_DEVICE pages are never online.

We'd have to hand-code some check similar to what is done in
pfn_to_online_page() to deal with collisions in online_device_section(ms) and
provide a custom shrinking alternative.

But given that there is no actual demand (nobody uses zone->contig there), it
doesn't really make sense to add support.

-- 
Cheers,

David

