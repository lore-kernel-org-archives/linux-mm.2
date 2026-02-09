Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44CE8E7E0C4
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 10:52:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF7086B0005; Mon,  9 Feb 2026 05:52:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAE8B6B0088; Mon,  9 Feb 2026 05:52:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B0CA6B0089; Mon,  9 Feb 2026 05:52:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8DDEC6B0005
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 05:52:38 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 48FDAC273A
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:52:38 +0000 (UTC)
X-FDA: 84424604796.06.EB20BA2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8849F160006
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 10:52:36 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FCLIYNsZ;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770634356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MG1uc8FZsYxoswt153jUfh8Qr1/WOAa0I+W6jtrcl/8=;
	b=3Q5rzalGOjZrgaJcRyYe3VtDYFNoYJmXsd7apeMm+N+n6a7L9ejA0xDyGKv+lbRlwMA3Gw
	kye4oneuz+rzjJd20sU1elaaKPgAZ0dMDZIopOlteIJU47xjhzIB+mTcPSx0KHZNoZmdal
	Hi0y1k16URDtqPnCGkr6pKyS4g6gFjo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FCLIYNsZ;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770634356; a=rsa-sha256;
	cv=none;
	b=A+ueW8TW5xIMRAQvFJ+xk8DYzd3VEXwZsTfjs4FJAqgDvqq55M8HUsVd1HO/56+YKebY7J
	xT7TYqsu+nN/TzvIGLY6ivqvNiyGxZRM24XX+3er9AlfpxNBSNRrEaCPCoj9cenKmlXQ6M
	PDVkIvVNk6JfJYrvZPTIiTKyIU2w1w8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id CE5BA60008;
	Mon,  9 Feb 2026 10:52:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 629BEC116C6;
	Mon,  9 Feb 2026 10:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770634355;
	bh=IR24Vdfq7pG2HtWxbV/YTzF/R3Kq/tn8271DHAb7T4c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=FCLIYNsZ0La4P7D1N5MRjYPotVTFu30AwadJ++pu5shWUHRI1QcWQu316aHe4xMFI
	 XL6H6r/HdsqMUkkoq50in+oqlLYxoZPpgsGx4cCRiwGqJkToL3NcbXpleK28GjcGcv
	 BkFv7WqFeT7+q4JN/AqwyqD5CE0Wq0qij/vEeUYR+lQDbMBr5OH6lfFzSKsX5LtIUm
	 soJdNT95sLpvTZFtUONiHkTjzUWyNIP8M9uwN8eP103rSXyKWrDAvqGkCFyDGIFlzt
	 ZzMP7y7LjsWpSfk/M8Tgf2TIEgbiCj97KdY6LrdzU6SSFh7dvxkMucEzsOOOMCHP1J
	 CV3cDz4eGC4oQ==
Message-ID: <6ea2dbce-c919-49d6-b2cb-255a565a94e0@kernel.org>
Date: Mon, 9 Feb 2026 11:52:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/2] mm/memory hotplug/unplug: Optimize
 zone->contiguous update when changes pfn range
To: Mike Rapoport <rppt@kernel.org>
Cc: Tianyou Li <tianyou.li@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Wei Yang <richard.weiyang@gmail.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, Yong Hu <yong.hu@intel.com>,
 Nanhai Zou <nanhai.zou@intel.com>, Yuan Liu <yuan1.liu@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>, linux-kernel@vger.kernel.org
References: <20260130163756.2674225-1-tianyou.li@intel.com>
 <20260130163756.2674225-3-tianyou.li@intel.com>
 <3cb317fa-abe0-4946-9f00-da00bade2def@kernel.org>
 <aYjmcZ4hg9bNbmiY@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <aYjmcZ4hg9bNbmiY@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 8849F160006
X-Stat-Signature: bfed7wn8z38yf85nb5s88kshx99fgi5s
X-Rspam-User: 
X-HE-Tag: 1770634356-952613
X-HE-Meta: U2FsdGVkX189v9BNAK9O5qkYlGsmvjuBna6oT/Gtbgxicm8fOM8okh1EQwB4y0731D703GkzhwnHCgd005PLc+0muImYif3hEKRDmdju0ABnNQYEToK/ye/M1BF9bJJ6cO1owkIBYdtFZHrbaV8FvDs9pp7HXaHr4RLj4Rwy99I0lT41q8ZZNYRVHYI2+pAlPzRRub1zHJrgHUdVvFtJPxvBh56O+tFpgfY63vXX/I+SqJbackyioEldGxSPSqUGzqqUd34fs5roI03jD/9XotnPjPIRHfVGBcothI/QgdWEv5eCal8t+gqMJrLhI5yN9YY5XsemSdFaAxeQ6TZwZnpZQ6qt45HdJgkrAq8xENBZWQYZr6AXlblN8p/j+GKDfHkhw/R4PUvZOg7d1NSmsrTkLFXv95u6Klzx/5T56QVZG7m2PDj79uTwFoxG4BxZXEzIqBGeqv9wJE+yYfD+zMnAVwdFPthATNU1gFwDW5MpYUPK9AvWzk9YpTEeH0QtKgsSOeJ6ZMMuGwUToE8PK6PZ4EWbDBTCaxuerWta9IfDSoVHtx9tE6u+UBHPyNU/YaoIRqokgfa4cLVDSw6tuVgPJUspWtOouWtnkD/SvDV4Ym2JfatHePvxDHU+vINvvBg5RH2GYiIQoHVXuJSMdruVTgCgeOXNsUDVdg2bv5iL5rskb5vS4+Xx2qPqOX7pG3wMtq8qQ//jKz+cy9RFKfH2gxwIx8eJUtlsPTshLvXtuz1GOHYh02BOXUWmrf2KXtEUsD8E3KWnprU9aFFXN7kGAw9lUi+52aaDWixhHZCnjhz8XazHs+eKH87dGi7tLLA8I0A6mgxSDy5NWLladpVwNmRldtbWwHUxtbbLoAQ7lLHJQ5T97sGntvv65645/4H71tLXzf2zs25EQ8Gz2MUIgYQ3fWkzsWalOYkogMaG9lOBMACh8pyJp/iT2219LzSpAO3KWrkiOU0jEXW
 wOOmA9Ss
 DBEpjsk3oNbWv3wnWvpHZ9IOjjgiwmal4ozrdDnxeDvchcc51AG0xl/6oKxvU/Evn0h8l3ENszmsxggmsyLQMYUKxk9sd2kyadqG0iHvNT1wIQnoCPEFuHTFUH2X2Yc+t1YRq/ynYPbquI0knHtc6PCKJfz1Qg9mseGswDAyoLPhEkXx6349v1V8AMrIGM26l3vzj6AdESX404SLDz+WX7stQ9dcrbY49K8KkBwehSb3TJa+v6QTulRsUPo1CC4b48kStUhMJtcEAIB5r6JB+tNz0wp+KlpkPTspkGIn1RFGqftcMzCvAZhYCcYPbHM4wIYOvGvuN1gGj6QI1l8G6Qk1wKyYmibASWRMTg6MZnDlESrIRc8LwqzG3Cg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/8/26 20:39, Mike Rapoport wrote:
> On Sat, Feb 07, 2026 at 12:00:09PM +0100, David Hildenbrand (Arm) wrote:
>> On 1/30/26 17:37, Tianyou Li wrote:
>>> When invoke move_pfn_range_to_zone or remove_pfn_range_from_zone, it will
>>> update the zone->contiguous by checking the new zone's pfn range from the
>>> beginning to the end, regardless the previous state of the old zone. When
>>> the zone's pfn range is large, the cost of traversing the pfn range to
>>> update the zone->contiguous could be significant.
>>>
>>> Add fast paths to quickly detect cases where zone is definitely not
>>> contiguous without scanning the new zone. The cases are: when the new range
>>> did not overlap with previous range, the contiguous should be false; if the
>>> new range adjacent with the previous range, just need to check the new
>>> range; if the new added pages could not fill the hole of previous zone, the
>>> contiguous should be false.
>>>
>>> The following test cases of memory hotplug for a VM [1], tested in the
>>> environment [2], show that this optimization can significantly reduce the
>>> memory hotplug time [3].
>>>
>>> +----------------+------+---------------+--------------+----------------+
>>> |                | Size | Time (before) | Time (after) | Time Reduction |
>>> |                +------+---------------+--------------+----------------+
>>> | Plug Memory    | 256G |      10s      |      2s      |       80%      |
>>> |                +------+---------------+--------------+----------------+
>>> |                | 512G |      33s      |      6s      |       81%      |
>>> +----------------+------+---------------+--------------+----------------+
>>>
>>> +----------------+------+---------------+--------------+----------------+
>>> |                | Size | Time (before) | Time (after) | Time Reduction |
>>> |                +------+---------------+--------------+----------------+
>>> | Unplug Memory  | 256G |      10s      |      2s      |       80%      |
>>> |                +------+---------------+--------------+----------------+
>>> |                | 512G |      34s      |      6s      |       82%      |
>>> +----------------+------+---------------+--------------+----------------+
>>>
>>> [1] Qemu commands to hotplug 256G/512G memory for a VM:
>>>       object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>>>       device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>>>       qom-set vmem1 requested-size 256G/512G (Plug Memory)
>>>       qom-set vmem1 requested-size 0G (Unplug Memory)
>>>
>>> [2] Hardware     : Intel Icelake server
>>>       Guest Kernel : v6.18-rc2
>>>       Qemu         : v9.0.0
>>>
>>>       Launch VM    :
>>>       qemu-system-x86_64 -accel kvm -cpu host \
>>>       -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>>>       -drive file=./seed.img,format=raw,if=virtio \
>>>       -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>>>       -m 2G,slots=10,maxmem=2052472M \
>>>       -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>>>       -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>>>       -nographic -machine q35 \
>>>       -nic user,hostfwd=tcp::3000-:22
>>>
>>>       Guest kernel auto-onlines newly added memory blocks:
>>>       echo online > /sys/devices/system/memory/auto_online_blocks
>>>
>>> [3] The time from typing the QEMU commands in [1] to when the output of
>>>       'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>>>       memory is recognized.
>>>
>>> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
>>> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
>>> Tested-by: Yuan Liu <yuan1.liu@intel.com>
>>> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
>>> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
>>> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
>>> Reviewed-by: Pan Deng <pan.deng@intel.com>
>>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>>> Reviewed-by: Yuan Liu <yuan1.liu@intel.com>
>>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>>> ---
>>
>> Thanks for all your work on this and sorry for being slower with
>> review the last month.
>>
>> While I was in the shower I was thinking about how much I hate
>> zone->contiguous + the pageblock walking, and how we could just get
>> rid of it.
>>
>> You know, just what you do while having a relaxing shower.
>>
>>
>> And I was wondering:
>>
>> (a) in which case would we have zone_spanned_pages == zone_present_pages
>> and the zone *not* being contiguous? I assume this just cannot happen,
>> otherwise BUG.
>>
>> (b) in which case would we have zone_spanned_pages != zone_present_pages
>> and the zone *being* contiguous? I assume in some cases where we have small
>> holes within a pageblock?
>>
>> Reading the doc of __pageblock_pfn_to_page(), there are some weird
>> scenarios with holes in pageblocks.
>   
> It seems that "zone->contigous" is really bad name for what this thing
> represents.
> 
> tl;dr I don't think zone_spanned_pages == zone_present_pages is related to
> zone->contigous at all :)

My point in (a) was that with "zone_spanned_pages == zone_present_pages" 
there are no holes so -> contiguous.

(b), and what I said further below, is exactly about memory holes where 
we have a memmap, but it's not present memory.

> 
> If you look at pageblock_pfn_to_page() and __pageblock_pfn_to_page(), the
> check for zone->contigous should guarantee that the entire pageblock has a
> valid memory map and that the entire pageblock fits a zone and does not
> cross zone/node boundaries.

Right. But that must hold for each and ever pageblock in the spanned 
zone range for it to be contiguous.

zone->contigous tells you "pfn_to_page()" is valid on the complete zone 
range"

That's why set_zone_contiguous() probes __pageblock_pfn_to_page() on ech 
and ever pageblock.

> 
> For coldplug memory the memory map is valid for every section that has
> present memory, i.e. even it there is a hole in a section, it's memory map
> will be populated and will have struct pages.

There is this sub-section thing, and holes larger than a section might 
not have a memmap (unless reserved I guess).

> 
> When zone->contigous is false, the slow path in __pageblock_pfn_to_page()
> essentially checks if the first page in a pageblock is online and if first
> and last pages are in the zone being compacted.
>   
> AFAIU, in the hotplug case an entire pageblock is always onlined to the
> same zone, so zone->contigous won't change after the hotplug is complete.

I think you are missing a point: hotp(un)plug might create holes in the 
zone span. Then, pfn_to_page() is no longer valid to be called on 
arbitrary pageblocks within the zone.

> 
> We might set it to false in the beginning of the hotplug to avoid scanning
> offline pages, although I'm not sure if it's possible.
> 
> But in the end of hotplug we can simply restore the old value and move on.

No, you might create holes.

> 
> For the coldplug case I'm also not sure it's worth the hassle, we could
> just let compaction scan a few more pfns for those rare weird pageblocks
> and bail out on wrong page conditions.

To recap:

My idea is that "zone_spanned_pages == zone_present_pages" tells you 
that the zone is contiguous because there are no holes.

To handle "non-memory with a struct page", you'd have to check

	"zone_spanned_pages == zone_present_pages +
          zone_non_present_memmap_pages"

Or shorter

	"zone_spanned_pages == zone_pages_with_memmap"

Then, pfn_to_page() is valid within the complete zone.

The question is how to best calculate the "zone_pages_with_memmap" 
during boot.

During hot(un)plug we only add/remove zone_present_pages. The 
zone_non_present_memmap_pages will not change due to hot(un)plug later.

-- 
Cheers,

David

