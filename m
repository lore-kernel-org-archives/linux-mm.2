Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41A79ED7B91
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 09:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 727376B0088; Tue, 14 Apr 2026 05:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DA826B008A; Tue, 14 Apr 2026 05:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F06D6B0092; Tue, 14 Apr 2026 05:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DA046B0088
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 05:24:27 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id F10558B8D5
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:24:26 +0000 (UTC)
X-FDA: 84656625732.07.84C20B7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 13EFB80010
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 09:24:24 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YKmY5FLy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776158665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xvdDUBCGj6XuXQ9CtfaxjWMfYTY0EA+g6iJjiaF0qg0=;
	b=bwi0EqJo6JJAH5Um1yQ0WCIR3HS3dmOQPgIn5pbHRyYF2aK5Aig5mS8Sy9UB97/eGWhyOO
	u0y8WPQZVmhI/7fdROP9n2ivxSiO8m6d4vG2Iz53D2zEZj06X7UFvgFduOihJzWLH8IA52
	OzL2lmkt6GDCcoXN1NkQ+NpQz+mY/eM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776158665; a=rsa-sha256;
	cv=none;
	b=Hy2XKEApdnOt8nN5ehDTyZn7OxPMxmAYkRcJC7dyMC0FDfFhj2kftPxjMiGzxMwHDwlost
	wG1M0VEh3+WRYG959zG5xpApq/bosjsPK1en0EJtu0ceWqhyMhxzAo8vxmSAIR6w/22SjM
	JHRW0pT4CvumPQQZ+GbR8S1970OxWA4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YKmY5FLy;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B1DBE44183;
	Tue, 14 Apr 2026 09:24:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 51A4EC19425;
	Tue, 14 Apr 2026 09:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776158663;
	bh=8DmHQNhpWGOp+HH6UU6CLgoA3IZAxo/XcUuDqTaH/10=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YKmY5FLyGD22/qTK22QYVkokEJ3M/JMZR6NJSI8sVU+uPu3UYAzN+jfgWHgjhW1fZ
	 GtT+zwrhGFCDyxzs/lJ0uIpoOjdpVKZpvbTgZ9b8M9l4N5MdY0vbVriY69TktdjpPO
	 QOSJ/fYiQNOBPRSRAXSm9WnCdgXLP5HdZYeineSu9MYfOdDgM3lPZ8JMVv5OWFEACF
	 KXIpu+vgjL8WSD/lqGLxgh/WoYu0PlpKJqDJ5h6AX7yheInWslVACjmZgkl8hlDu4X
	 QzwqavVXJUrQFvx7Xt+GFywTVHB9PmCMsVxNORAfKM98v0R4lwCqkbACA5F1hfzXMl
	 NO0UrYVVIQslA==
Message-ID: <12b8ba83-54b1-454e-b787-2d2e967c9b58@kernel.org>
Date: Tue, 14 Apr 2026 11:24:17 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
 check when changing pfn range
To: "Liu, Yuan1" <yuan1.liu@intel.com>, Mike Rapoport <rppt@kernel.org>
Cc: Oscar Salvador <osalvador@suse.de>, Wei Yang <richard.weiyang@gmail.com>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, "Hu, Yong" <yong.hu@intel.com>,
 "Zou, Nanhai" <nanhai.zou@intel.com>, Tim Chen <tim.c.chen@linux.intel.com>,
 "Zhuo, Qiuxu" <qiuxu.zhuo@intel.com>, "Chen, Yu C" <yu.c.chen@intel.com>,
 "Deng, Pan" <pan.deng@intel.com>, "Li, Tianyou" <tianyou.li@intel.com>,
 Chen Zhang <zhangchen.kidd@jd.com>,
 "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20260408031615.1831922-1-yuan1.liu@intel.com>
 <17b821b6-0176-43d5-92f7-fe2a0c4f70cf@kernel.org>
 <ade6RVeXxDt7ImP4@kernel.org>
 <e86fee84-08d8-4563-8596-e40d8e196799@kernel.org>
 <MW4PR11MB6936CA77BF02BF498BBEAB1CA3252@MW4PR11MB6936.namprd11.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <MW4PR11MB6936CA77BF02BF498BBEAB1CA3252@MW4PR11MB6936.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 13EFB80010
X-Stat-Signature: 1eayjmtgx6jdxeq8kg87gw9iqurc6woe
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1776158664-390189
X-HE-Meta: U2FsdGVkX19s2S/lCeZkKjhmWlckvdqiV85okRP7nejalzYT7K2jlqJdETNajC2+aRHXv1PD+1YBz/U3MkzQ2PJBAMMLab9z3RFka4VYCcHY9GQU7flRfuwfssAX63DHMoLP+yLegU1HCI2oqLz4I73+FmkUytNzcWAkKxLNmxRpQssAjVESnvhvHif6htkc5QYePcR2VYkx3GymMp/MbuWTss6hNvJxhjjUW5Es0p/Hkx2KdzUb7rHyx6AwqCHz/ruDkft4y39YZcvZnPJF5sGkUJj3VPq1bVsJx0Whfkt9eWR/dbLUan6hUuU8K+VHfYlhttNTBfCt/Z9YHaOXaDLzUdmuUJIdNLT/PMVKtjtNs5+bQiPIjk7PGivmrlxrFRJyIixAP6XMPT1OFxkD9b5/OFWFYkd1qW9CEkYypwofFZ8jemC3cgnaKVkWFPhwKMzBBafL6hp99C2+w1HB/aO7TucozQK76P4+ugmOCGqbwXHpcfd1hsKEZYvRUSGojFLV5ICjSLrHzURalUv2//We83GeQyB6jvz8Q1IYx0yutnN8pDjv880qOdJU7JtStg/82tXU3yUHZqoaHX/ywxFZzoGJJus7w1qZ0fI6idFKM2COmaHy40uGOnfEdrIYQTzLQ52LLersvPVa901+1pc8gOV1ZtPZUFGIPEdTLmZP+Yy9PgXCix60WXrISRYv0Ut9TlkmbEHQkAkmxztp8ZhK5YA4lmLlbPPxhVqQ8BHnJ+IQXnI4y0M6DiXA4n0FMT4pUag3s3eJLU7RWtR7WVXL4fm2jKHBsqoVUFbCLHNSWHVIqvg4J/sKspK2LI8eB+wEjCJTIit4+c26FskVLCSjk3CZ3gPzxIzj649RQUOOk3G+rNUaH6kiiSaT0C4be/TIQVNM0ktguO+CxNkrLChgmSdIIuNuXBq11KedFMT/zJ+qWj7GQ/a7pwXQFAOXMxLQoYzoJA7Dv0I3pwt
 dCKgNk4N
 foiI/Gaxq7qHPii9ZXRg6x1itUagHagoRoisE1quCMpLeklp5Gq9DUIHt70XqFEhM3IU1TJhX17WBJI2NF4R3HdkeETk/GNDx9+zoVj6GNrRn3O1ufrfic7TUxbfvSRaqwOSu6XcOul6lJj2K2Decpigojkl7UFRVTcaZYBCKLAoiyXmTmKVRNkGahcHMdSuHMQgD2z+PIqqK1Kxy6zB+4wg92RYGnd+U/9qZu+wyqKznJDvinGtPD4ZOtkFwQ9fZEvMaeQM16pV/ZvK/7DV7nx0HXVpzcJuXKvvQyV7pIdxSvsQYhLbl06HoAiM+wV0M1wh60WPwNB/pAoGE5KNoiAhpdfl6eAC4y4TcujIu5FIKQP1lR8YYgzm6scepULbcImdWzrIEADSOCobqquJRSw31vk2v3IBTMkHN+1X2Vx45oy24WhSJmUDfgorvo8vPyBpwc067rhB2il1KIFdrH173Bm5Swm0fKk024Ug32VvR17kZA7Lo5z0KX5YQbs+iSlvcsIF67o3WpftU1VjJ6WA3kifrMTowGLR0/K4+/jYA8qCBpqkuh6gFO8kmPAinx1jqBU7ABchsDBVT5gdAS2+ijW1CFiYWM/te
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/14/26 09:06, Liu, Yuan1 wrote:
>> -----Original Message-----
>> From: David Hildenbrand (Arm) <david@kernel.org>
>> Sent: Thursday, April 9, 2026 11:08 PM
>> To: Mike Rapoport <rppt@kernel.org>
>> Cc: Liu, Yuan1 <yuan1.liu@intel.com>; Oscar Salvador <osalvador@suse.de>;
>> Wei Yang <richard.weiyang@gmail.com>; linux-mm@kvack.org; Hu, Yong
>> <yong.hu@intel.com>; Zou, Nanhai <nanhai.zou@intel.com>; Tim Chen
>> <tim.c.chen@linux.intel.com>; Zhuo, Qiuxu <qiuxu.zhuo@intel.com>; Chen, Yu
>> C <yu.c.chen@intel.com>; Deng, Pan <pan.deng@intel.com>; Li, Tianyou
>> <tianyou.li@intel.com>; Chen Zhang <zhangchen.kidd@jd.com>; linux-
>> kernel@vger.kernel.org
>> Subject: Re: [PATCH v3] mm/memory hotplug/unplug: Optimize zone contiguous
>> check when changing pfn range
>>
>> On 4/9/26 16:40, Mike Rapoport wrote:
>> a
>> pageblock
>> cost
>> of
>> present
>> further
>> towards
>> prevents
>> the
>> --+
>> Reduction |
>> --+
>> |
>> --+
>> |
>> --+
>> --+
>> Reduction |
>> --+
>> |
>> --+
>> |
>> --+
>> \
>> of
>> hotplugged
>> long *pfn)
>> last
>> spfn,
>> long spfn,
>> ranges\n",
>> zone *zone,
>>>
>>> Yeah, this looks better :)
>>>
>>> sashiko had several comments
>>> https://sashiko.dev/#/patchset/20260408031615.1831922-1-
>> yuan1.liu%40intel.com
>>>
>>> I skipped the ones related to hotplug, but in the mm_init part the
>> comment
>>> about zones that can have overlapping physical spans when mirrored
>>> kernelcore is enabled seems valid.
> 
> Hi David & Mike
> 
> I’ve spent some time working through these issues to better understand them.
> For the overlapping physical spans(mirrored kernelcore), should I avoid counting 
> overlap_memmap_init in memmap_init_range in the next version? 
> For example, change it as follows: 
> 
> +unsigned long __meminit
> +memmap_init_range(unsigned long size, int nid, unsigned long zone,
> +               unsigned long start_pfn,
> +               unsigned long zone_end_pfn,
>                 enum meminit_context context,
>                 struct vmem_altmap *altmap, int migratetype,
>                 bool isolate_pageblock)
>  {
>         unsigned long pfn, end_pfn = start_pfn + size;
> +       unsigned long nr_init = 0;
>         struct page *page;
> 
>         if (highest_memmap_pfn < end_pfn - 1)
> @@ -893,7 +897,7 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
>         if (zone == ZONE_DEVICE) {
>                 if (!altmap)
> -                       return;
> +                       return 0;
> 
>                 if (start_pfn == altmap->base_pfn)
>                         start_pfn += altmap->reserve;
> @@ -911,6 +915,7 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
>                         if (defer_init(nid, pfn, zone_end_pfn)) {
>                                 deferred_struct_pages = true;
> +                               nr_init += end_pfn - pfn;

It's confusing. Could the remaining range also include overlapping inits?

Maybe the whole "skip overlapping init" should actually be handled on a
higher level?

I guess we'd want to skip any memblock_is_mirror(r) regions entirely.

@Mike?

>                                 break;
>                         }
>                 }
> @@ -935,8 +940,10 @@ void __meminit memmap_init_range(unsigned long size, int nid, unsigned long zone
>                         cond_resched();
>                 }
> +               nr_init++;
>                 pfn++;
>         }
> +       return nr_init;
> }
> 
> @ -954,13 +962,21 @@ static void __init memmap_init_zone_range(struct zone *zone,
>         if (start_pfn >= end_pfn)
>                 return;
> +       nr_pages = memmap_init_range(end_pfn - start_pfn, nid, zone_id,
> +                                    start_pfn, zone_end_pfn, MEMINIT_EARLY,
> +                                    NULL, MIGRATE_MOVABLE, false);
> +       zone->pages_with_online_memmap += nr_pages;
> +
> 
>> The set_zone_contiguous/clear_zone_contiguous can be ignored I think.
>>
>> The comment about shrink_zone_span() is likely not realistic.
>> shrink_zone_span() would not shrink over boot holes.
>>
>> Well, unless we have an odd case where the hole+memory starts in the
>> middle of a "PAGES_PER_SUBSECTION". That would already be problematic if
>> memory starts/ends in the middle of a PAGES_PER_SUBSECTION chunk. I
>> don't such a case exists.
>>
>> We could improve shrink_zone_span() to let
>> find_smallest_section_pfn/find_biggest_section_pfn test the pfn_to_nid()
>> and page_zone() not on;y on the smallest/highest pfn, but also on the
>> highest/smallest PFN in a PAGES_PER_SUBSECTION chunk.
>>
>> No need to test pfn_to_online_page() twice, as that is the same result
>> for all pages in a PAGES_PER_SUBSECTION chunk.
> 
> Hi David
> 
> I think I understand your point. 
> Just to confirm, should the improvement to shrink_zone_span be included in this patch?

I would do it in a separate patch that you move before this patch.

-- 
Cheers,

David

