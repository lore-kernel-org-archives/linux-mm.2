Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 004E7EC01D3
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 11:42:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EBC16B0005; Mon, 23 Mar 2026 07:42:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19CB86B0088; Mon, 23 Mar 2026 07:42:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 08B4D6B0089; Mon, 23 Mar 2026 07:42:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ECF646B0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 07:42:26 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 82D431EC0C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:42:26 +0000 (UTC)
X-FDA: 84577139892.08.D5074EA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id AF4AF4000C
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 11:42:24 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="A9e8/8wO";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774266144;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1ue9X5XoLn9Kmh+e+BhBflKwCU1NWPJFkdjeU8yQSK8=;
	b=mDbMgLxsff3xFqxfWSQWsNlqPF9gAwj/0CV2fyqWL2nuSan/nbCnCqYs5U4VQ/IkHUaeKV
	iPQG5IGiUInEf5u0vOnwv0e9Lul3JAVJfPjU+WHS0nx3vGhjvH5CQkdkQkdYAaUmyUKbkc
	+PgSdor7T1/dEtZCP8aY97OjCLYUPOQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="A9e8/8wO";
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774266144; a=rsa-sha256;
	cv=none;
	b=YiAok9iZgcC/ZnEo7uIEMF55KOXcWhJatblsSwmVoZcDMIDJuqbf737WnLA/orJMu0AScG
	VwatKckWTep7n4U78/Vu3Jc7Sp0r/qsZpJitCNbPH9hiM0p4qCd+c+RQT9lXwwvqQ1k3DQ
	aF735Xb5eriE3Fwny8AcN2xAdkVQRac=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BCD70419EC;
	Mon, 23 Mar 2026 11:42:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6D5FC2BCB1;
	Mon, 23 Mar 2026 11:42:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774266143;
	bh=dLC6SP4EM8xLyJEG0yB5l0xv9xeTKuqp/PvgzfJWfF0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=A9e8/8wOYSIqy2CuuHmLMO9krzNDhF/9QpdvGobrrU2Y1p2BR3w/CClxvbK+JcTTP
	 YslIsieMvOC+1vGTS8nyZdxuwbf/fjpfVLv9I5yTeK51ZXwshnrKF/eFR3vPeXqQov
	 seAWXDB8j0cCMtI9Gyf8SYIgw/rcnFWYhQXKNBYmQCzb68ueM9Y2VRV9pliaxbhR7m
	 +zvItDY8dxcWqWlNVmSGcgrmV/zXM7OcXycOaEfqE7JI5SWGFjOQiWmL2vz8dUiKkO
	 Pk54PopJr50UAeIe357yB+Pd45RyxiorUWBhb3wv/4hTVUdnARrF4OIAfxg8nzbGr3
	 ieZAR4Af0raAA==
Message-ID: <168ab3c0-c44f-4d48-b7dc-33196b7ba6a5@kernel.org>
Date: Mon, 23 Mar 2026 12:42:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/memory hotplug/unplug: Optimize zone contiguous check
 when changing pfn range
To: Mike Rapoport <rppt@kernel.org>
Cc: Yuan Liu <yuan1.liu@intel.com>, Oscar Salvador <osalvador@suse.de>,
 Wei Yang <richard.weiyang@gmail.com>, linux-mm@kvack.org,
 Yong Hu <yong.hu@intel.com>, Nanhai Zou <nanhai.zou@intel.com>,
 Tim Chen <tim.c.chen@linux.intel.com>, Qiuxu Zhuo <qiuxu.zhuo@intel.com>,
 Yu C Chen <yu.c.chen@intel.com>, Pan Deng <pan.deng@intel.com>,
 Tianyou Li <tianyou.li@intel.com>, Chen Zhang <zhangchen.kidd@jd.com>,
 linux-kernel@vger.kernel.org
References: <20260319095622.1130380-1-yuan1.liu@intel.com>
 <48b497e5-1545-4376-a898-f3813a6ef989@kernel.org>
 <acEkfaycrJI-kWjk@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <acEkfaycrJI-kWjk@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: AF4AF4000C
X-Stat-Signature: nbj7dwpw1j4qwgbeahcsfysnwgk1wreu
X-Rspam-User: 
X-HE-Tag: 1774266144-963702
X-HE-Meta: U2FsdGVkX1+N8nsCHoEqGaDIvFE+uym5dXjDDaUmjujP0LY4MX9Sr1nPoZWiC2zdzqqSldJXaImjUFr96ShVRULG4EviYb4Nl/CHvF00ElKG2pWcGeg+S50rs/VpRkrE5+q+QxWwqp3pUOiYiqyTR0H4YZ5XNhkZfCRjo2rtHaGRSIYDuUnUCZflfAbdqlwohQUvhrVf9mOSfyNbtA0q9/h+m05A1LWOfrnsWaeCIQZMl4qU7g5FWVTg9EwUF5EBApNfCHspdgXVO3KNLLpTHl6jc48jcoY4cq+NC1dWrBKgZ6NL8ZQUsCPHHu9b4RspFdPRP9F554zu6A4XcfDawk8e263dsyiYMWQYu6A2MbHJCkN0cDJQSpsf3iVFqOGkJTdcGig1licOFZyikipJBBtuvs26QQNOG2yhByrSvmkDWQxDCvfoSQWoH8dWQHXHP/gnFcghwnB/wk3LoZiXi2JaTdJbu37pqTYXlNRh5iUMZk0/rz/7xRiT1mBXeatda/ObTjpSptrirY1bGdAHakKA0wftcn4IyqHsrU21Kqg0j6o8fg/6sWIcVJbIiO5Zn+/hOqyuMQ+OuUN3P/YBecF6MH2N/ECf09Yx+08teI5hCNCZ4QEB4nEkMkLA7cCErsmWwaC/0FD+mpsW5sYwIqb5Gv4gtpdIk9BxEjhAF1X/eX4sVDDpQ9L7487/ZO1rlGTBWeO9IFtxy4Ev7FjA62bryQFmzqgxOloOBOcDKIQnNlEcXZM0qwCJuU2+lhGk/wWWJFUORYdbw05ajmbHfuWrkAt9/pqefn2CkkyTyBQCeQWAI2L2N1+A11HoGScRWdsJh4xLI53ua3vWXWOR3yiEQ4lr8QPBpEaPHHwU+d1aRlSya9zF7jjA9nd31GoU+sDjeZ33nFuBfh39WDeognmTzvfueaI0dyLv4VDN8P854NLQ+SvY7Aoy4raxsoG0JcX9HLJBBdGe0b/7Sxw
 97hs44H2
 KHg5HdVxEaAFSwOVZOhygYWmkz5nrxKnOJ2tHtE11VefnkhJRp41iJJeq5CTHv4VqmyYaMxYfE84TRQyhhB7a4Ue8uHyjFPutQmoovfMpK0w/kisoG0MENHy/hA+/Y44msmcwSVJT8GqMxIM6Yx8W0ckvpMQICQunWcsqcNW/+cSiYDGUsVHsmHIK3IZrXMkEeQKEFyGfwLPB79rEu6K0fg+ycjl6z40wC6s7JqMOSbgMlr7iun58Y3LHS4SCHTEoG/0ueSA7A9h3Tp2gc50bTUbjHK3MmhX1QFBA6cONQaiJN+SDVyseVSq1v74t1Ev/SFl+fON9LSTuE1A=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/23/26 12:31, Mike Rapoport wrote:
> On Mon, Mar 23, 2026 at 11:56:35AM +0100, David Hildenbrand (Arm) wrote:
>> On 3/19/26 10:56, Yuan Liu wrote:
> 
> ...
> 
>>> diff --git a/mm/mm_init.c b/mm/mm_init.c
>>> index df34797691bd..96690e550024 100644
>>> --- a/mm/mm_init.c
>>> +++ b/mm/mm_init.c
>>> @@ -946,6 +946,7 @@ static void __init memmap_init_zone_range(struct zone *zone,
>>>  	unsigned long zone_start_pfn = zone->zone_start_pfn;
>>>  	unsigned long zone_end_pfn = zone_start_pfn + zone->spanned_pages;
>>>  	int nid = zone_to_nid(zone), zone_id = zone_idx(zone);
>>> +	unsigned long zone_hole_start, zone_hole_end;
>>>  
>>>  	start_pfn = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
>>>  	end_pfn = clamp(end_pfn, zone_start_pfn, zone_end_pfn);
>>> @@ -957,8 +958,19 @@ static void __init memmap_init_zone_range(struct zone *zone,
>>>  			  zone_end_pfn, MEMINIT_EARLY, NULL, MIGRATE_MOVABLE,
>>>  			  false);
>>>  
>>> -	if (*hole_pfn < start_pfn)
>>> +	WRITE_ONCE(zone->pages_with_online_memmap,
>>> +		   READ_ONCE(zone->pages_with_online_memmap) +
>>> +		   (end_pfn - start_pfn));
>>> +
>>> +	if (*hole_pfn < start_pfn) {
>>>  		init_unavailable_range(*hole_pfn, start_pfn, zone_id, nid);
>>> +		zone_hole_start = clamp(*hole_pfn, zone_start_pfn, zone_end_pfn);
>>> +		zone_hole_end = clamp(start_pfn, zone_start_pfn, zone_end_pfn);
>>> +		if (zone_hole_start < zone_hole_end)
>>> +			WRITE_ONCE(zone->pages_with_online_memmap,
>>> +				   READ_ONCE(zone->pages_with_online_memmap) +
>>> +				   (zone_hole_end - zone_hole_start));
>>> +	}
>>
>> The range can have larger holes without a memmap, and I think we would be
>> missing pages handled by the other init_unavailable_range() call?
>>
>>
>> There is one question for Mike, though: couldn't it happen that the
>> init_unavailable_range() call in memmap_init() would initialize
>> the memmap outside of the node/zone span? 
> 
> Yes, and it most likely will.
> 
> Very common example is page 0 on x86 systems:
> 
> [    0.012196]   DMA      [mem 0x0000000000001000-0x0000000000ffffff]
> [    0.012221] On node 0, zone DMA: 1 pages in unavailable ranges
> [    0.012205] Early memory node ranges
> [    0.012206]   node   0: [mem 0x0000000000001000-0x000000000009efff]
>  
> The unavailable page in zone DMA is the page from  0x0 to 0x1000 that is
> neither in node 0 nor in zone DMA.
> 
> For ZONE_NORMAL it would be a more pathological case when zone/node span
> ends in a middle of a section, but that's still possible.
>  
>> If so, I wonder whether we would want to adjust the node+zone space to
>> include these ranges.
>>
>> Later memory onlining could make these ranges suddenly fall into the
>> node/zone span.
> 
> But doesn't memory onlining always happen at section boundaries?

Sure, but assume ZONE_NORMAL ends in the middle of a section, and then
you hotplug the next section.

Then, the zone spans that memmap. zone->pages_with_online_memmap will be
wrong.

Once we unplug the hotplugged section, zone shrinking code will stumble
over the whole-pfns and assume they belong to the zone.
zone->pages_with_online_memmap will be wrong.

zone->pages_with_online_memmap being wrong means that it is smaller than
it should. I guess, it would not be broken, but we would fail to detect
contiguous zones.

If there would be an easy way to avoid that, that would be cleaner.

-- 
Cheers,

David

