Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8C64606A321
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 06:56:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UNkyA3Jn
Received: by kanga.kvack.org (Postfix)
	id A7B876B05FC; Fri, 13 Nov 2026 01:56:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A53B56B05FE; Fri, 13 Nov 2026 01:56:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 991506B05FF; Fri, 13 Nov 2026 01:56:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 73C856B05FC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 01:56:45 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id DB21F140152
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:56:44 +0000 (UTC)
X-FDA: 85429187928.18.43BC4A5
Received: from mta1.migadu.com (out-156.mta1.migadu.com [95.215.58.156])
	by imf12.hostedemail.com (Postfix) with ESMTP id A0A9140007
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 06:56:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UNkyA3Jn;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.156 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794553003;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dleCmS+wcIoZt0s8RSq4SghUIJElDi6eszWr991uRyM=;
	b=bFTo6dW6wskjoID6v4x0NpxDA1Ht1j4Swf6RfDXsyg9Lmsg/tfHsXOeyzMTbHDj2hKU/pX
	QVm78TAbqbkDxa1p5VvVOWqF/RF1dZVnzKOl1dzmDcJatLW1xLUdAOxyqqJ9W0qHBp/olj
	DxnIklZso0+mVP1CxHORby9KM+DMEjk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794553003;
	b=MkGcOgmSRgKHxPA5Wlf9S97uEqFvCxEO1U8TlJMjhXKuOcH4UJyYC0aKoK5Iylde3wdQuu
	NEnCTrTc64pyRzLJ4Za+xKTifDXdJJdxQEH6KsCDExjf4HiJiXzZKtpInGUiwc922Dk77U
	j/Y/7Ugk53JSVZHzB/S9EfYZ+YbK+sk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UNkyA3Jn;
	spf=pass (imf12.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.156 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=I3d8MPdHTNroLOq0wxxtMmc+Uc1DmX33W42S6M5zY04=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794553000; v=1; x=1795157800;
 b=UNkyA3JnPdAidvUvOJTuIvQmZpPY8ozTwnkilYyO2Yz0+psZFKteeR6nuYxReRyUReMJdiBE
 LK7CSRmGggvJbt1kemXL0HN7gbpIFRn15BASDwSvJbIJ5HiIuxAgqWbjQxEINhQQ/iIfCEpWU50
 ksCYhpiYNihWqFiKDcKbRxY0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 120149e2deeb02e7;
	Fri, 13 Nov 2026 06:56:40 +0000
X-Mizu-Trace-ID: 120149e2deeb02e7
X-Migadu-Flow: FLOW_OUT
Message-ID: <dbfa9791-5a4e-4837-a2cc-ac506826761c@linux.dev>
Date: Fri, 13 Nov 2026 14:56:34 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 3/3] mm: hugetlb: fix GFP mask propagation to CMA
To: Kefeng Wang <wangkefeng.wang@huawei.com>, muchun.song@linux.dev,
 osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org,
 azpijr@gmail.com, lance.yang@linux.dev, Qi Zheng <zhengqi.arch@bytedance.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@vger.kernel.org,
 "Oscar Salvador (SUSE)" <osalvador@kernel.org>
References: <cover.1794379433.git.zhengqi.arch@bytedance.com>
 <1c5e8c4ae230dc238a16f2f42d65bffac6244ad3.1794379434.git.zhengqi.arch@bytedance.com>
 <7def88b4-cba5-4e8b-9e68-6069c492b582@huawei.com>
 <1cd3c151-24c2-4fec-8356-99853f8d6971@linux.dev>
 <9b46d8e0-104e-4659-8dec-67eb6f059dac@huawei.com>
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <9b46d8e0-104e-4659-8dec-67eb6f059dac@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: A0A9140007
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Stat-Signature: pgwe1pt3kiak3xcc6at9cs5rgi3u6s4s
X-Rspam-User: 
X-HE-Tag: 1794553002-206429
X-HE-Meta: U2FsdGVkX1+3wc4PdkqHj/E6oZzu0zJMKIZbbDIGzOF3N2Q2DN+lP5A+FxREjcQKsr2lHl6xuMRvFD9Tu72pbH+pQLABZcFT9sxE0f3E0LG93mY3WUYsBM58axGjklstMmIuSEw+gDgkbBoJJ2uUjiiK7PP7E7TfTTispRATPhJjD+4ZPo1HN4ltTdicq9VuoFpe4URlqhKN2L1VNiV2YFBBfT4sDIvNw88lC2Po+11/wjp4ZA3ipEN4eYQXh/AcjzyFzllIoC9TSXgsVCCa455EkP7vvTa+gx5wgUXRul2f0wVzaE4VEjYIP2w5OrHgt6n13Vclgj8Qbwxpdd4ux/0GC9qfZ36m4OvUfFQbXBu5DMqjbGGfIQWRm3EwSAKFOgb1r/DJm069kgNgcqAHBv4EzJwKWiI6KJUiGPgOcx2ZGUi5p0gmMuZ9Z9t9++IrAZNR4lZyZdk5OLLToIwB8HBZ2rbMV2m6KAFQGsqeN2Hvn4Bdn80p922n1Xc7G+V5TzpHEuCez9Qi1Vj3dGHOxvr71VnJCE3WSMdNUjNfrybkenYEik7aj00OJb7dnbKKvXM7eKsJiIm5iU7T4TIynS8FOyivKnH9XUpkEXQGA7VZoeoVV4z2WF5fe/SCD29LuYzFzG6efDdrT1lZXNH29+OAxmN/vrztihMuBtrZcG4XtowYrp8/zLhcWbsnTzwIbIXSGNMsamCCTD7U3KY91Wvrzg+8NE58k1b7D7g3fhOTULTC9G+eBaIxTNosvzzG36gl56J2zE0kLO7Ss4+EEY7YiEHuS4HEit/FdItRgEOiZ3dRj2d3n6ML+Lvw7jjPZ6aycVKloudyUsVzlIMBS6AZITV6qaJHCkgfOTydkQ1XK3wBJL4hxMTFXPjxQygwNYLo9bey6dMLgpvA3iDLtfbv4eOtAUrMu/P8/CahI3ELwluN9BRLYyPm/qTOupn3sr+ADMG7lGx4QXU09LK
 Eqw8GLrr
 goITrSkJZOhQRGKjrVW6yoAdoRtzk06SHh/ABoFmKysJ4rjBZRLMoFn0JQarLxj7yPzuDYeTb24V+xvcP7x5uT2KZz/Ajhl6B/xBmDQRYBzk7lMGt7aIkEqOtdyUN1ibfNGVasyGneSd02KNECk3UcyTramGR0y+wosMV5kw9Bz718dnsVK/weti8Vt5BXLsSUj5LDYVXEaCI94aw4iuOzi9Vw/zFTHg01IZEic/OKV8MSGfnHpw4AeWMYzl4nCTx6kURIti8uI+PwYYUgggXGr0MBixMgJTmyvobnEO2baNdIhVbRdLuxNsF1nsti6I7ejJRQy6ENLoQMFE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 11/13/26 11:56 AM, Kefeng Wang wrote:
> 
> 
> On 11/13/2026 10:30 AM, Qi Zheng wrote:
>>
>>
>> On 11/12/26 7:27 PM, Kefeng Wang wrote:
>>>
>>>
>>> On 11/11/2026 2:46 PM, Qi Zheng wrote:
>>>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>>>
>>>> cma_alloc_frozen_compound() uses GFP_KERNEL, allowing direct reclaim
>>>> during the first MPOL_PREFERRED_MANY allocation attempt even though
>>>> the caller clears __GFP_DIRECT_RECLAIM.
>>>
>>> MPOL_PREFERRED_MANY is only used for the partner allocator. Without your
>>
>> It's doesn't seem so.
>>
>> Gigantic surplus allocations already use MPOL_PREFERRED_MANY, following
>> eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepages"),
>> which predates 9bda131c6093.
>>
>> alloc_buddy_hugetlb_folio
>> --> MPOL_PREFERRED_MANY
>>      --> gfp_t gfp = gfp_mask & ~(__GFP_DIRECT_RECLAIM | __GFP_NOFAIL);
>>          folio = alloc_surplus_hugetlb_folio(h, gfp, mpoli->nid, 
>> nodemask);
>>          --> alloc_fresh_hugetlb_folio
>>              --> only_alloc_fresh_hugetlb_folio
>>                  --> alloc_gigantic_frozen_folio
>>                      --> hugetlb_cma_alloc_frozen_folio
>>                          --> cma_alloc_frozen_compound
>>
>> Before 9bda131c6093, cma_alloc_folio() forwarded the caller's GFP mask.
>> The conversion to cma_alloc_frozen_compound() replaced it with
>> GFP_KERNEL, re-enabling direct reclaim during the preferred-node
>> attempt.
> 
> Oh, I forgot about that commit. The naming and some of the comments are 
> misleading because alloc_buddy_hugetlb_folio/alloc_surplus_hugetlb_folio
> can allocate both buddy and gigantic folios (which can be allocated from
> CMA).
> 
> Maybe rename alloc_buddy_hugetlb_folio to hugetlb_alloc_surplus_folio,
> or other names...

Naming is difficult. ;)

The Hugetlb implementation seems quite messy in many places; let’s focus
on fixing the issues first.


