Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BA39F43680
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 09:00:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F7A86B00B2; Fri, 17 Apr 2026 05:00:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8AFC16B00B3; Fri, 17 Apr 2026 05:00:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 797266B00B4; Fri, 17 Apr 2026 05:00:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 66A1B6B00B2
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 05:00:25 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DDAD9C3707
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:00:24 +0000 (UTC)
X-FDA: 84667451568.15.1ABE38D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 293F1180019
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 09:00:23 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a3U7XLCB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776416423; a=rsa-sha256;
	cv=none;
	b=aq7o9nHSLYnkmgFG7vgDlWgLTC14WMWTiJLaukhcD6McWak+OudN6b/MYNnODueL6SZ+sv
	Rj82b5jWOk9XPlJ1fLanGY1YIFfgma6SnlNftBlbPfzRBtRlctEFcU8DgqKAzaBvAihW2Z
	T8kFuFW1F63bg7B9Bya28jywvWhmabg=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a3U7XLCB;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776416423;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=te2tVqUFJ/FRYR/YfXCUmqqp8sYsfIQk/sq9C3ZoUwE=;
	b=qYtwEWrrk9q0zmVtwdwm7i7eBl3+Uuept90v4byF131MHYkMtelSiUe4tCqn9ehfqwlCoJ
	BPXGLrFX3OFDl3D15B20qnkbsFy47TqeeXgKxYoM+tTSyXpsOWMGIkAIO9mmLahQ0PpZ/F
	g6GV/34W3SJ8c0zC2BhJqd3JsnwY7Gs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 94F0F60128;
	Fri, 17 Apr 2026 09:00:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11179C2BCB6;
	Fri, 17 Apr 2026 09:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776416422;
	bh=rOVtwKaZuAQojNidWmETlWnlssUeGW/zGYlzgjncuoE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a3U7XLCBn31qXsO1C8KOPjrGtMwRGVzfyoBN8jhTyvQKRTUdvXIFBNQuhZFvyTtPX
	 5tzUQ1jFJQbwEoSaakSK/GAveRTamoVzrIsVlFaoFuOkO0upnulA0uD4pMEotnKqhu
	 Lty+Qo6wN5Jy5JJTWlk+6b0SKr0th/SIZVLVfRKuMXIHYLJi/eiFUxCB92P3UsxCMW
	 GPT3f27Dc2JZaFwUdwHo4fy6BeVIsEjowyvT3sggFlVaiWSkJ7Cs2LQW5qXVvzfFoZ
	 yQHCTSje+Xt49Qg+hASjiPJcoB+9MqSeAkpXJO9skYrRi0OEyGTkUX4nV2vfGK05I6
	 ORg83rarT/16w==
Message-ID: <c03d3d19-a2b2-4566-8922-661b92d06f95@kernel.org>
Date: Fri, 17 Apr 2026 11:00:15 +0200
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
 <12b8ba83-54b1-454e-b787-2d2e967c9b58@kernel.org>
 <MW4PR11MB6936E593C865F4E855CED602A3202@MW4PR11MB6936.namprd11.prod.outlook.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <MW4PR11MB6936E593C865F4E855CED602A3202@MW4PR11MB6936.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Stat-Signature: x67bfdhb8xhzemxkxphhjk3ijciyko4t
X-Rspam-User: 
X-Rspamd-Queue-Id: 293F1180019
X-HE-Tag: 1776416423-526277
X-HE-Meta: U2FsdGVkX1+B6U/s73J0RwOgEYL6a1brxmEa++Stzm+pRzzAisBI6LmfeOqt8oMOCAYXe/3ULNO8SJ7PRa/MIliV/KM2YOe39PZvTDtIOuCZQbpMp/+bJtEyYkgPdDvyPEYkL3NuNZb2CbLUiN0Ik5TixRb4xB0LqYxPgwpAGMUUf67pyb6Vwfe4vMui36bN9ewE6rDTsTCWJC3yGLEuMM+J9deEspeZK6VxILcUamNpv1NyoBGQd+WfZ03q/C5wgfGBRi/2rYJuTdHEGPIi/CZtmcVJWtL4+vQh8X/YzSjWE0kKkHTNBeV34c5x/yZNuNuTqzWqYmcDtf7qtXn5CeU2QQxo1bmKbaXv87dgASO/3zx5b4xtRoQHxY6cxUMzHRqZs/XCTtI7EN4rOwRDmjphJRYCMv1PVsyRhoMPnVn6DilvHRX5t6ouBaH6aOeDDkCCbeoOfNV8R8l/MS2nYJ8VNJVyDxUPqqWzRiXQ0JFUXCuA45S1PXEw/nRBmFCJi99ejOIplwHUzpxnDezsbnD3T7yykY+8U4ZEjbzY+uSc4dYz3ey2nMj0ebhKD+ngMk3VT5+xha1o37OKN1kPlfifPqWTDz8OtzoVgRKmjzx4z8ezkKXc5xFHjh4dTweqG1So4oUdu7EGEK2DW3JsQyPhvtgEjJphEuJzNxBDeaVkZffK9bLNM7YNf2h3ZxssZC5ZnBAYrDUVEZBhb6zZu1ICHpzakZZIbsDuyLWztQ6Cp6lnYP5s4tfc5vbya6oNXMhEgfqGBxl1dK86M/f78WXx+AHHNTGOLV5blJ4g0EI26APzsSqQRvVG/ZO85/lDfMlVPhp86OzisLrcF8kbeNrVKNflT1B3zOVk0aCYrB4rj17gnkOMoIz+nz4gpHajeJmUFRLIQV+nBR0Rgrs01S/gVOGMrciQyiJafn25z6kHqkNdO2AsOtkRW7M5WqOb4gqk/eR+EZ2gokOlK+B
 w+h4K8MM
 gkLPRzHaMImoXuC9T52qwvGaAvGEaZarIpiAhMBiqvAYqW5VdyA+QMgbOO2mbdHZyYB55RDnDviHXsHODGV7dB3Wc82JOytBtqwZxVh2JCuzfaqT0N8+m77aVfHFkgQXabwlECIVZy/b7E0m0U+zIOaArlVFNFIN8/WnlZfO7KC69JpX6IYksrg63aIBZKLUO+Ws5We7H72yIbVzkx6U527gNEhU6V1nl0ShAc6umua+ueA2cdj2+ukt6XSG0xSngjlYtyCDvFg/bgijfC3vG8O9eDjkyBFsf3uiakUvqAyB+dtiYnaseaTGVDy9M5l+xD7sIh8EL+T1ZHnj01IVXFHbeiPQDRnXDJZ+iaXPJaDu6jovqd+ros34YgOSWkM5Zr8aRTE5wmrSMT8E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/17/26 08:34, Liu, Yuan1 wrote:
> 
>>>
>>> Hi David & Mike
>>>
>>> I’ve spent some time working through these issues to better understand
>> them.
>>> For the overlapping physical spans(mirrored kernelcore), should I avoid
>> counting
>>> overlap_memmap_init in memmap_init_range in the next version?
>>> For example, change it as follows:
>>>
>>> +unsigned long __meminit
>>> +memmap_init_range(unsigned long size, int nid, unsigned long zone,
>>> +               unsigned long start_pfn,
>>> +               unsigned long zone_end_pfn,
>>>                 enum meminit_context context,
>>>                 struct vmem_altmap *altmap, int migratetype,
>>>                 bool isolate_pageblock)
>>>  {
>>>         unsigned long pfn, end_pfn = start_pfn + size;
>>> +       unsigned long nr_init = 0;
>>>         struct page *page;
>>>
>>>         if (highest_memmap_pfn < end_pfn - 1)
>>> @@ -893,7 +897,7 @@ void __meminit memmap_init_range(unsigned long size,
>> int nid, unsigned long zone
>>>         if (zone == ZONE_DEVICE) {
>>>                 if (!altmap)
>>> -                       return;
>>> +                       return 0;
>>>
>>>                 if (start_pfn == altmap->base_pfn)
>>>                         start_pfn += altmap->reserve;
>>> @@ -911,6 +915,7 @@ void __meminit memmap_init_range(unsigned long size,
>> int nid, unsigned long zone
>>>                         if (defer_init(nid, pfn, zone_end_pfn)) {
>>>                                 deferred_struct_pages = true;
>>> +                               nr_init += end_pfn - pfn;
>>
>> It's confusing. Could the remaining range also include overlapping inits?
>>
>> Maybe the whole "skip overlapping init" should actually be handled on a
>> higher level?
>>
>> I guess we'd want to skip any memblock_is_mirror(r) regions entirely.
>>
>> @Mike?
> 
> Hi Mike
> 
> David suggested moving the overlap handling to a higher level and 
> skipping memblock_is_mirror() regions entirely. I think this makes sense.
> 
> Would this work for you, or do you have a different preference?

Would that allow for removing overlap_memmap_init() entirely? The more I
look at that function, the more I hate it with passion :D

-- 
Cheers,

David

