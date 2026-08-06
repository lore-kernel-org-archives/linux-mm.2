Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50FE1C55ABF
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 08:45:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BB7F6B0093; Thu,  6 Aug 2026 04:45:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46C9F6B009B; Thu,  6 Aug 2026 04:45:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35BEB6B009E; Thu,  6 Aug 2026 04:45:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0074E6B0093
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 04:45:44 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 71C50406B9
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:45:44 +0000 (UTC)
X-FDA: 85070211408.15.B983C7B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id AD6971C000E
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 08:45:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jVDnwyuV;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786005942;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lbr9b/qtPOe/Faxe4tR1mMwAtMEUx9LiVSdAIQLniKM=;
	b=SfOlnKmXMDJZmJn2o3PcYrKYkSDvUvDT5ysThdfZmCPS3R6pmkW+iLKzoCCjnBWtT9jew8
	R64CB3gleLwHtmyc6MXOKEUc6m6egUu0A8BFFNWqD0etclVqnZIQC0WiNZxskyMUGqqgaD
	4KC81H38yGKnVy7bBBj4ZJA7YzpWdy4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jVDnwyuV;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786005942;
	b=3+NHObZKlDo8kEtoVUlN9r7rA4io3qdRVDN3DfK8M4Jw6izVSReRtNNkGbZAyOep5XPjwb
	tNbOEwlk3EQBW/xC2vY8HEdMbHHx0XUEZ81lQWA/8aztIGBD30zQblLX3+4Jh/56aohQrt
	X9NNl2emX3m/gzcsKvdbLlD5rsadmPE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 32CFC60AA7;
	Thu,  6 Aug 2026 08:45:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A78CE1F000E9;
	Thu,  6 Aug 2026 08:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786005941;
	bh=lbr9b/qtPOe/Faxe4tR1mMwAtMEUx9LiVSdAIQLniKM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=jVDnwyuVrbu8xmITUkewRJXdiCkGi85k5+li2u7HyhGmXFfz4BbFRkDNfIpL9WDUE
	 qlumkyj9GRy1Veh3uHqgNq7tR11Wo/u3XjPYkfzgxfUtNu0bnAiV6iW//9ag6tvjKp
	 TlVD6Cc+Wp9RFTvCWcKfBTsqC+A2BDLHrJAqfWtlU5qspp8st7bIyUYhqAW4ocpYkv
	 Ov+DIl+0w0ZJRyZViZbYl1GTB5pm0tWNipd2etEMHnoI7Hn7qT7Itdq0ydoIfAsjYe
	 ywiicx4HXX1lfD/IPg2IPGHEAFxgXJhYzgBeJvhpKNNtosjydaGxeo8ID0D/n3LV2g
	 nVMFd4bckyYGQ==
Message-ID: <2cbd42e1-b5bb-474c-b0e7-ce3f46541891@kernel.org>
Date: Thu, 6 Aug 2026 10:45:36 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 1/2] mm/memory_hotplug: optimize zone contiguous check
 when changing pfn range
To: "Liu, Yuan1" <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Wei Yang <richard.weiyang@gmail.com>
Cc: "linux-mm@kvack.org" <linux-mm@kvack.org>,
 "Zou, Nanhai" <nanhai.zou@intel.com>, "Deng, Pan" <pan.deng@intel.com>,
 "Li, Tianyou" <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 "Zeng, Jason" <jason.zeng@intel.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260723084946.189392-1-yuan1.liu@intel.com>
 <20260723084946.189392-2-yuan1.liu@intel.com>
 <a15107de-ab16-433a-a504-72c3e8dbf2a6@kernel.org>
 <PH7PR11MB6932A554A6D18A4F1A29E90DA3D22@PH7PR11MB6932.namprd11.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <PH7PR11MB6932A554A6D18A4F1A29E90DA3D22@PH7PR11MB6932.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: cdmoz8yanxaxefuqbixq88nh1t4cakjy
X-Rspamd-Queue-Id: AD6971C000E
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786005942-791274
X-HE-Meta: U2FsdGVkX19qUW4lo0gyJy4zi9nvtmfeZlwlYTDPHb3uX+DAtTfmFQfJmGeSE5lzdB/vFpevj6YFMPMSR50XSQNPje5goZymxKKfl12ub2wckrC1vSzxrJjKnTydGb6IeLzXWXktgTcddQNJRpo8p3Fcj3BOzuDLApdX79z4zXFhJQV84uxJnaStD26HtDQEB1UYUsqpjIGihJK8Y400iSWC6QllvA+1xT82gyJuVFysvs03dcjl/rY5V2NioZdB40N/N3s473f2Ng0hPffhe2e7M4MG6/Tp5htvoUdexN9p1+xKPVrblLfOQMXSujY8wbl+zqI9QLu+sJvM6e6y8V4ORTonZlKAoaL1Xytyt7UsviP34yxGTBmwUjU1q8jI9tdNaSllNo7BUvkZIKY8IAYBNjS83wOWYrF/JcE5PgpPCVCvTGvZ1nsYxL1qCdOr0970Z9jA+61Gvwb7eZsQOLsN+7HjV7wPjZ34+td73XQIwTWqRMb8T/tqm562VsBLiUY1graucfgrrpUDtUqa7SmIR84KGmpQLKaPdSd5KkJTQD8XzD4e71kXU4uCT7u5NUVH/ALBr3pIQMsFvMKsLZnUbzCZjON9ejJuw1Ya6x95ptSLWRrxbHJKJz3JLToQ5CQYUk3uFBDG0jiZEttiFjuuYFT7spomf9it/16XaDKzUiVjxXMrQMPTKE596wSJc3YNvCSNOIDFuQEjDqQRAr7W+UWZ34EoNQBIc3XsBBkiN1FsLIGr60YJa0h+Ykv5SfFNlJOUtGGBVlszyJL8owjLF/yQd+B1dUwqO8PG1eW08EVk2KjE/T8n+dfHWmkk+SUiEi2cttpA01hAKiKrAmzxmQt3dgXjkg2bgS83KPwqlqtxXyHHFAaOfOX7MHCdC8NgULxHEM7g9QYUI1C6NKsXfB94cxcv3hkVLUhvk8+ipS9IiOTtk0jrEv1+4acEdUwLsuBBS7osDB/z39h
 sbV1M1CI
 tR4pfjWJFckKvbJVIpkjnxcyhVd1576eTb+sOEpNxb6pm8f1X+3fmBjzR1XWwF8TgmEaQyskucr99hKXbP695yyhhtNWEdhAkj1C6ZCeSwSl8ny41iiGuscClaKB50tuBQ5UT5JilLLw1bv/sH8FwSDvV37t1uGWMxuxl7jgITp4Xy2yXd9E0QEAC17/dI/LclQXkhSSWLwaij9xYiEA+rjvmaudy5SWlO9T9vmgHxhLEclcO1/vKnWVFMuScq/dqjmTSalMEbtsddqd3wUuOgMqAgRnvlSMCHggCqj6LhSsFS3x6c4hIBnBuE/bFP5AEmt7jdhY+8QOcT0sTRoD0MrQVjmdufZgsioz04d5+/jPu5hSq4yMqQ6bwqC4BKuXtTYscwVEo1rxCPAoiLCuFS64tAt1Yf6VgGvgpYB/37rzuc+EURaMmd35nZ0j47NxkKHBz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>> +static void __init update_zone_online_memmap_pages(struct zone *zone,
>>> +						   unsigned long start_pfn,
>>> +						   unsigned long end_pfn,
>>> +						   unsigned long *hole_pfn)
>>> +{
>>> +#ifdef CONFIG_SPARSEMEM_VMEMMAP
>>> +	unsigned long zone_start_pfn = zone->zone_start_pfn;
>>> +	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
>>
>> These two can be const.
> 
> Will do.
> 
>>> +	unsigned long sub_start, sub_end;
>>> +
>>> +	sub_start = max(ALIGN_DOWN(start_pfn, PAGES_PER_SUBSECTION),
>>> +			zone_start_pfn);
>>> +	sub_end = min(ALIGN(end_pfn, PAGES_PER_SUBSECTION), zone_end_pfn);
>>
>> Hm, I don't immediately understand why we do the PAGES_PER_SUBSECTION
>> thing
>> here. Why is that required?
> 
> pages_with_online_memmap counts all PFNs where pfn_to_online_page() is
> valid. With CONFIG_SPARSEMEM_VMEMMAP, pfn_section_valid() operates at
> PAGES_PER_SUBSECTION granularity — when any page in a subsection has
> memory, the entire subsection is valid/online. So we align to subsection
> boundaries to include hole pages within partially-populated subsections.

But we must never account exceeding the zone range. So I don't understand why we
would have to care about PAGES_PER_SUBSECTION here at all?

-- 
Cheers,

David

