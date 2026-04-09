Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EF9EF31E24
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 15:08:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B02D6B008A; Thu,  9 Apr 2026 11:08:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 061A16B008C; Thu,  9 Apr 2026 11:08:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E92296B0092; Thu,  9 Apr 2026 11:08:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D96596B008A
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 11:08:27 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6E56913B83D
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:08:27 +0000 (UTC)
X-FDA: 84639348654.13.D0BF4E5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 92C2C40011
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:08:25 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tIUHmfcl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775747305; a=rsa-sha256;
	cv=none;
	b=hf/w+2lQtD0kLzZGebWtFn39+Fv2riz7xVT4zX8PP/9M8N/5/AY+BO1QDfngSrmz+uW28C
	NSGoXDSKmlE6ALHa6qxwSLHyod98ixn9/R1qSoSIfQzB9pHIQa4iWtl1CElXGKkodsAgjM
	2C85KA6g4hYEz4MckJYlqeLbZAQjzPo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=tIUHmfcl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775747305;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JoXFRMvB36TW375yAguZ3eZkYn9c4ydX2x4tY2Rf3Eo=;
	b=1wO3IhWtq9wDjw3BSuW2aQ8hOUKQyUwJzxrgTsYKbLj3xpArDiC9UQW7Q5U3mEJT6JlXJH
	jUtRGO9/aTVUX9E0BGKIB5qwTNkjKtJbax0N33EMn7uP0/FUdwMlJad1MvaVhnB7yps/ZO
	+1l9T+TFibYVq7BVkC6dfmFQ/PjguBg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 642A740714;
	Thu,  9 Apr 2026 15:08:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0FD0C116C6;
	Thu,  9 Apr 2026 15:08:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775747304;
	bh=8bKMs+7uL671pUbX7j8IgkjFDdALfxxzN+DgJ+2wuwE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=tIUHmfcliQiRyYv+4RxvHKh5zUVWOvlz9N1GJoHIWYmp/53VyeTZ/5Ys34S7aTQBi
	 ju8h66ch2EbJCr7Fqw93Y7S5JK4hWEQJJUIK3x0FOpp0uzGEJBzdYYcampYKFYjJB8
	 SvX2GZTBlHkepW3lNV2H3R6cus4MWC8DUxgvi3Eheh0S4+x60lVSZYjAhQG7QWRLOj
	 QTd6jqYQkJzvyMC1mvmZ+d7symxwkCHMMKqB7eYMITgpf+Cjdxk6jYPvmZcAa1dWaN
	 AmS2BQ5susZRgzcotybX5LvBXS7sMNMtSOXiUS2ypW8CTcx2eXrZtIIpbJOwvi8tOr
	 sDcFygQx1DCAg==
Message-ID: <e86fee84-08d8-4563-8596-e40d8e196799@kernel.org>
Date: Thu, 9 Apr 2026 17:08:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
To: Mike Rapoport <rppt@kernel.org>
Cc: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
 Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Tianyou Li <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 linux-kernel@vger.kernel.org
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <17b821b6-0176-43d5-92f7-fe2a0c4f70cf@kernel.org>
 <ade6RVeXxDt7ImP4@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ade6RVeXxDt7ImP4@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 92C2C40011
X-Stat-Signature: b1op5pxry4x6eefoq93ce7oypa4nijtx
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1775747305-861495
X-HE-Meta: U2FsdGVkX1+9ae1J4vjF7QlbK1NC/NsQGPtkwmlYYQmgC51lFme1oILKRPCWAjzSyzvVLKTkUAS2E2qcduX2S/jTv38ewnqR7sSVKdFUGSXW8JWHpud34xka65Q7KKtmbLR4UTcAvAoUxgxMY8zmia7cvdlJXcH/A78/x6156LIrQvMpi0jTFqckNKqXgYfYp98IzCMch1J9Ofjzh0fQE4/mL9luiOuFZ0cOLoD0yTe0YxgGtfwgBrGLOivCTJUwD3K2er5giqbd3bYPpFYxhEoTR8Flh/WNJEsLGKaGnmPHYAOFxWbSNrp010gX+uu9RQRAebizFis04Lyx2UxWnb3dBFZXWRriDfU/t5lZK5bVLHKeMxcuYh+ZTRn01euJYf75Ku18nBPlwFvCROwFZUXy0kVVfS6upzNm5GeBydWL6HW+QbmwBF7Vr3KWgbye/CoXYAmn1voLeL6Uyvq599EhKqZ0o8uWmOt3IJvBpzDwdgOeKLtH2EISUCYIesE557wbMtG96tCv7snAvdgCeHVrnajPbyVyDj+2bWfTlyzFZqZ7J9mJZlDISdQrjpoR11qn7buMErm2KC1Ft6D81/Nwjb2ZtLHzY045c2O9NthjMEARBT7E12oaAbNB+fSBKXqSbhJ0RJjsNmA0OpbHQLQdDwS8aeDtDf8ts+DdlkUPCFGsQhM4Ozjqwus2LLT/1HH1OiHy7HfHviEDT/bje5p4tqsblbUEHOvz3VE43w/vOK/QpiBatBYF8MAhE3TDC6DELi32CYJr72wBQlvQzHRNuBehqvNchIThBgO31nReY3y8etRoF8CmqO9zwrI0zJjB+iBdVg3NuT8nuxJ8QLkhum8Bg4UmZ/M075q+zUG8ddre1JDSddpGWHJb1zPTwuS3MMqyRHDax/xspg7Wz6AK9jhB6egcwDbIhNUbPlxHWNrJsbDyOFDSVfRCNeNY/3NeV2xibhI0nJqzyYr
 jv31e/75
 muaXOvAp9nXxapcDtxkH5iHrfcRaSuQZlRDovkTjUX0jVJnkTyg5w40frlyL+bkjcWe5crvieWg7AytEq5s+SpcpDCbTUf5dwe0KB9hu/oY+F032QEEWWDrdky8akiVOVff8egtSPrZzQ4969U73wmvk/MYzH8EqGDNqUWdSyxrS3Z9g6PS/Uq0d6QCRFejWTBqks+q7dcv0+nYgCSylT7PP7wRFM0wWZuqoISa5haHL1CtNB5ZsOoDpBGiGdqKDboqDmWo1+2SdbNC7CQvjzBT0XplF6mD7dIGKp7fRLN20X/jVZ2sDagdQtSbeXTOTMVmeRGhAbCQmq0SVtDbKuZvE1KXsneeNgs2GNKl2VdZuOEb+MrHaA5ud/vf2xrwo3547z8ViO9O9VE03p5qgMSM1XFFyWIpElBIC42mpJxnC5cnuiPat22EZxc+zOKCWdzfNbVl4kbgRaITw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/9/26 16:40, Mike Rapoport wrote:
> On Wed, Apr 08, 2026 at 09:36:14AM +0200, David Hildenbrand (Arm) wrote:
>> On 4/8/26 05:16, Yuan Liu wrote:
>>> When move_pfn_range_to_zone() or remove_pfn_range_from_zone() updates a
>>> zone, set_zone_contiguous() rescans the entire zone pageblock-by-pageblock
>>> to rebuild zone->contiguous. For large zones this is a significant cost
>>> during memory hotplug and hot-unplug.
>>>
>>> Add a new zone member pages_with_online_memmap that tracks the number of
>>> pages within the zone span that have an online memory map (including present
>>> pages and memory holes whose memory map has been initialized). When
>>> spanned_pages == pages_with_online_memmap the zone is contiguous and
>>> pfn_to_page() can be called on any PFN in the zone span without further
>>> pfn_valid() checks.
>>>
>>> Only pages that fall within the current zone span are accounted towards
>>> pages_with_online_memmap. A "too small" value is safe, it merely prevents
>>> detecting a contiguous zone.
>>>
>>> The following test cases of memory hotplug for a VM [1], tested in the
>>> environment [2], show that this optimization can significantly reduce the
>>> memory hotplug time [3].
>>>
>>> +----------------+------+---------------+--------------+----------------+
>>> |                | Size | Time (before) | Time (after) | Time Reduction |
>>> |                +------+---------------+--------------+----------------+
>>> | Plug Memory    | 256G |      10s      |      3s      |       70%      |
>>> |                +------+---------------+--------------+----------------+
>>> |                | 512G |      36s      |      7s      |       81%      |
>>> +----------------+------+---------------+--------------+----------------+
>>>
>>> +----------------+------+---------------+--------------+----------------+
>>> |                | Size | Time (before) | Time (after) | Time Reduction |
>>> |                +------+---------------+--------------+----------------+
>>> | Unplug Memory  | 256G |      11s      |      4s      |       64%      |
>>> |                +------+---------------+--------------+----------------+
>>> |                | 512G |      36s      |      9s      |       75%      |
>>> +----------------+------+---------------+--------------+----------------+
>>>
>>> [1] Qemu commands to hotplug 256G/512G memory for a VM:
>>>     object_add memory-backend-ram,id=hotmem0,size=256G/512G,share=on
>>>     device_add virtio-mem-pci,id=vmem1,memdev=hotmem0,bus=port1
>>>     qom-set vmem1 requested-size 256G/512G (Plug Memory)
>>>     qom-set vmem1 requested-size 0G (Unplug Memory)
>>>
>>> [2] Hardware     : Intel Icelake server
>>>     Guest Kernel : v7.0-rc4
>>>     Qemu         : v9.0.0
>>>
>>>     Launch VM    :
>>>     qemu-system-x86_64 -accel kvm -cpu host \
>>>     -drive file=./Centos10_cloud.qcow2,format=qcow2,if=virtio \
>>>     -drive file=./seed.img,format=raw,if=virtio \
>>>     -smp 3,cores=3,threads=1,sockets=1,maxcpus=3 \
>>>     -m 2G,slots=10,maxmem=2052472M \
>>>     -device pcie-root-port,id=port1,bus=pcie.0,slot=1,multifunction=on \
>>>     -device pcie-root-port,id=port2,bus=pcie.0,slot=2 \
>>>     -nographic -machine q35 \
>>>     -nic user,hostfwd=tcp::3000-:22
>>>
>>>     Guest kernel auto-onlines newly added memory blocks:
>>>     echo online > /sys/devices/system/memory/auto_online_blocks
>>>
>>> [3] The time from typing the QEMU commands in [1] to when the output of
>>>     'grep MemTotal /proc/meminfo' on Guest reflects that all hotplugged
>>>     memory is recognized.
>>>
>>> Reported-by: Nanhai Zou <nanhai.zou@intel.com>
>>> Reported-by: Chen Zhang <zhangchen.kidd@jd.com>
>>> Tested-by: Yuan Liu <yuan1.liu@intel.com>
>>> Reviewed-by: Tim Chen <tim.c.chen@linux.intel.com>
>>> Reviewed-by: Qiuxu Zhuo <qiuxu.zhuo@intel.com>
>>> Reviewed-by: Yu C Chen <yu.c.chen@intel.com>
>>> Reviewed-by: Pan Deng <pan.deng@intel.com>
>>> Reviewed-by: Nanhai Zou <nanhai.zou@intel.com>
>>> Co-developed-by: Tianyou Li <tianyou.li@intel.com>
>>> Signed-off-by: Tianyou Li <tianyou.li@intel.com>
>>> Signed-off-by: Yuan Liu <yuan1.liu@intel.com>
>>> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>>> ---
>>
>> [...]
>>
>>> @@ -842,7 +842,7 @@ overlap_memmap_init(unsigned long zone, unsigned long *pfn)
>>>   *   zone/node above the hole except for the trailing pages in the last
>>>   *   section that will be appended to the zone/node below.
>>>   */
>>> -static void __init init_unavailable_range(unsigned long spfn,
>>> +static unsigned long __init init_unavailable_range(unsigned long spfn,
>>>  					  unsigned long epfn,
>>>  					  int zone, int node)
>>>  {
>>> @@ -858,6 +858,7 @@ static void __init init_unavailable_range(unsigned long spfn,
>>>  	if (pgcnt)
>>>  		pr_info("On node %d, zone %s: %lld pages in unavailable ranges\n",
>>>  			node, zone_names[zone], pgcnt);
>>> +	return pgcnt;
>>>  }
>>>  
>>>  /*
>>> @@ -956,9 +957,22 @@ static void __init memmap_init_zone_range(struct zone *zone,
>>>  	memmap_init_range(end_pfn - start_pfn, nid, zone_id, start_pfn,
>>>  			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
>>>  			  false);
>>> +	zone->pages_with_online_memmap += end_pfn - start_pfn;
>>>  
>>> -	if (*hole_pfn < start_pfn)
>>> -		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
>>> +	if (*hole_pfn < start_pfn) {
>>> +		unsigned long pgcnt;
>>> +
>>> +		if (*hole_pfn < zone_start_pfn) {
>>> +			init_unavailable_range(*hole_pfn, zone_start_pfn,
>>> +					       zone_id, nid);
>>> +			pgcnt = init_unavailable_range(zone_start_pfn,
>>> +					start_pfn, zone_id, nid);
>>
>> Indentation of parameters.
>>
>>> +		} else {
>>> +			pgcnt = init_unavailable_range(*hole_pfn, start_pfn,
>>> +					zone_id, nid);
>>
>>
>> Same here.
>>
>>> +		}
>>> +		zone->pages_with_online_memmap += pgcnt;
>>> +	}
>>
>>
>> Maybe something like the following could make it nicer to read, just a
>> thought.
>>
>>
>> unsigned long hole_start_pfn = *hole_pfn;
>>
>> if (hole_start_pfn < zone_start_pfn) {
>> 	init_unavailable_range(hole_start_pfn, zone_start_pfn,
>> 			       zone_id, nid);
>> 	hole_start_pfn = zone_start_pfn;
>> }
>> pgcnt = init_unavailable_range(hole_start_pfn, start_pfn,
>> 			       zone_id, nid);
>>
> 
> Yeah, this looks better :)
> 
> sashiko had several comments
> https://sashiko.dev/#/patchset/20260408031615.1831922-1-yuan1.liu%40intel.com
> 
> I skipped the ones related to hotplug, but in the mm_init part the comment
> about zones that can have overlapping physical spans when mirrored
> kernelcore is enabled seems valid.

The set_zone_contiguous/clear_zone_contiguous can be ignored I think.

The comment about shrink_zone_span() is likely not realistic.
shrink_zone_span() would not shrink over boot holes.

Well, unless we have an odd case where the hole+memory starts in the
middle of a "PAGES_PER_SUBSECTION". That would already be problematic if
memory starts/ends in the middle of a PAGES_PER_SUBSECTION chunk. I
don't such a case exists.

We could improve shrink_zone_span() to let
find_smallest_section_pfn/find_biggest_section_pfn test the pfn_to_nid()
and page_zone() not on;y on the smallest/highest pfn, but also on the
highest/smallest PFN in a PAGES_PER_SUBSECTION chunk.

No need to test pfn_to_online_page() twice, as that is the same result
for all pages in a PAGES_PER_SUBSECTION chunk.

-- 
Cheers,

David

