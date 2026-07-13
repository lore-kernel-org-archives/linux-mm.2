Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA524C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 17:34:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C57D06B010B; Mon, 13 Jul 2026 13:34:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C08DC6B010D; Mon, 13 Jul 2026 13:34:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6DE6B0114; Mon, 13 Jul 2026 13:34:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 765546B010B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 13:34:51 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0733B40141
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:34:51 +0000 (UTC)
X-FDA: 84984453582.23.086DDDE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 415B620007
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 17:34:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0eAvfdS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783964089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H9z7EIoWx2sCC/Q8euoaMwL2ld9Y9xIG46XmvenPEPE=;
	b=YrwmSBnooJLmVx7jtkYHjhRYAHKeAVTfDP1vvm7WL12EgX9Tv7kYmCmh0BCcUiO1YcUBJY
	eaFzffby0BMCQvK8NVH8enJobeRwn6kpEa/WEVqlcRSJr2Xoa2u08wuK4PKb2PEsWLa0Jd
	rzn9+z4NU0BGRiMcbnyEcZ90kZIkh9w=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I0eAvfdS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783964089;
	b=maIdvJ42LRmMKAT3MOyo1kbW6JgffsvP7l4YiYFu8F0JpGrih/6X/j+SEvvJc0p2saVMoA
	kGC8uXPVMss47kAMLkgyAdinCXFCH7Dr+QDwip4LfpSkyygbPBM0a2Qyxd1HUNVVpNe6h9
	guJaI4Lv3PM2K9BiLqLzXfj3zcEnLZ8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32A4443217;
	Mon, 13 Jul 2026 17:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 551A21F000E9;
	Mon, 13 Jul 2026 17:34:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783964088;
	bh=H9z7EIoWx2sCC/Q8euoaMwL2ld9Y9xIG46XmvenPEPE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=I0eAvfdSe9fzx/FK4W2PTqf/haS26znBzde5uSBglJCcC9DFp1+olacfpXid69CHm
	 Qw6jgEitzxtXNqU3CJHpAvSxrLHIDG48PbgGPKJp0V+elP68HrHauODRcz163qWYF0
	 UNZmK9vRDgzIbsC46KYpIcx47nscFuo8dxDri6in+m6ZyK7bpackuJzcN7KDN4iOZv
	 vuJDZ0IArQ1dQJFzA27rBLWL+4rSB6bPunvG+vhbcnjuQuDhS0oDiG4t9clVK2NqYG
	 9qsD2L7yVTYXFDadso1IrPhP25bdGQsizYg7vtZE4hd+VDM5ML8FQlN58t9NSrJx0L
	 XF/RoCQ0UvPmg==
Message-ID: <48dd2c46-bf55-44fe-b7e6-24037ba59aed@kernel.org>
Date: Mon, 13 Jul 2026 19:34:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 9/9] mm/page_owner: use memcg_data snapshot instead of
 PageMemcgKmem() to avoid TOCTOU VM_BUG_ON
Content-Language: en-US
To: Ye Liu <ye.liu@linux.dev>, Zi Yan <ziy@nvidia.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260701061101.344679-1-ye.liu@linux.dev>
 <20260701061101.344679-10-ye.liu@linux.dev>
 <0E890CCC-818A-47DE-9D1C-9EEF98CC758D@nvidia.com>
 <4d8e0125-0630-4070-95cd-acec3d626329@linux.dev>
 <622D6E1C-6E27-4912-A1A8-E5110A4581BB@nvidia.com>
 <4762af9c-e9ac-4162-a407-84d335325dac@linux.dev>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <4762af9c-e9ac-4162-a407-84d335325dac@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 415B620007
X-Stat-Signature: b4h1jsspn86hhzdd7czehecemzu5gprp
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783964089-966723
X-HE-Meta: U2FsdGVkX18UVZSW/1Q5Ue/tctXDQj5ESmN2PGmN4hf6z0woHcUrBvoDmOHKrR7M2hCMQrtGWohrHWyZagcv19VxMlOyjC52AnMX5TRkyKNc7MCigd9HB/Du4vgQR+jmghgnJdHNEdL5LBiN2bbFGWYgu9zoV5Tj/lWt/y4E7fob7R/NEScripJPyrCSfVMa87J3PbTKBa2X4NpZkJlFf1A1qEKd1Xvt5OBR4KlZH4Woz4bCk+eB2Al96RTU6x8nreXFcNJ8eZWOx+o9NRJPTvp68gJjEUVQMdlBV5vOff4e62vcZS0Nvf2WzIxAYCKGrbAnwrQ2KKE3OVzSCc3aLHxB6spwq5qg7fczckU5iuSi5b5yGmUTPeYH9vDjwuq8O1sBZhX7WFaI5nQ7pdZb3oJKkbgcts4Q+OxFazHDSvVR6K9zWKbymEbmkRnlLG++KcvTOqwtuq/si2OtMXjxeWy90/YxQvRogmFi7I33agIP0OJqwL8ISp6j/VfPgmspymBzeRCod5hMNnhsdtcyjyesY1OMN5sMEqe8Wc1e+Q04PMEsCeqKGKqrwkCQjWt0m2c0V+uAqpwLiDTuGZjH6yWZCdR/y9PNLjk94hAJ/nGuO1JSzyQbqYX1DuIyZpWxdio8hytYRkLvenCjRpbiu37sOAS7jznQVHTrpT5f+Az0fafpei/nHi2llcVw3ZzkHPk+Zqi38VhIoKSSw4i/AcUgIruKz/oIdGi2Vn3V5YLlVFUklU3nAqxR/UlASkPcZiPPSOnz74PmdOFFFpC7JiJnIwhWmb044D8IPEREXJLdbPl0Kj90gFmlW5p3L5Cbx4INzhifoEnDe35VskoKYt/4iyxOb07MYU4ZxRvXnDLeaJ6YS1Tuy7JaRoC4/Kad87SXjmB7B62Rb2wZvRR1ff4UZUJ9LvvweadAoo3W79R9BbkJJkh2BEiu5WED01L4LITOwnbX8gUD7AurX2Q
 lR9pqAE1
 fnhs1pKtWS5u6hoykUtUGFTLOjRARWddFbdO93hZgFfXPh+fH7RhNILqUd3cxlOx5buzN5Z0sg//KqtXwqNaO3+3c9GgcvibE+pwr/0JG+cbIUaLzslOv6qD3HaudL9mQcZEgfnKq9CMWanK4I54U7sTLiFVb/ZjvV7UaQvAIFowcbMgrtn7M02voMuiyMd3QHAuAdtCGLMjSBKDvc7Xmns4Cf3704YrQoCEY19rTEUnJcf5kIC7A06GQT+0j3S2DVuYDMxvuLEC6CGQ7Qa0IM9wyfjTP09/8nxkVh+jdn7695EJO8c0M4TKUuXFMI+bDoZMoS0Ygc0b/szBG91HB+7+vwzEsqU/900D0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/13/26 04:40, Ye Liu wrote:
> 
> 
> 在 2026/7/10 23:56, Zi Yan 写道:
>> On 10 Jul 2026, at 2:51, Ye Liu wrote:
>> 
>>> 在 2026/7/2 10:02, Zi Yan 写道:
>>>> On 1 Jul 2026, at 2:10, Ye Liu wrote:
>>>>
>>>>> print_page_owner_memcg() takes a snapshot of page->memcg_data via
>>>>> READ_ONCE at the top of the function and guards against tail pages
>>>>> and NULL memcg_data.  However, at the end it calls PageMemcgKmem(page)
>>>>> which internally calls folio_memcg_kmem() — and that function re-reads
>>>>> folio->memcg_data and page->compound_head locklessly, wrapping both
>>>>> in VM_BUG_ON assertions:
>>>>>
>>>>>     VM_BUG_ON_PGFLAGS(PageTail(&folio->page), &folio->page);
>>>>>     VM_BUG_ON_FOLIO(folio->memcg_data & MEMCG_DATA_OBJEXTS, folio);
>>>>>
>>>>> If the page is concurrently freed and reallocated as a THP tail page
>>>>> or a slab page between the initial guards and this final call, the
>>>>> VM_BUG_ON assertions can fire on debug builds (CONFIG_DEBUG_VM=y),
>>>>> causing a kernel panic.
>>>>>
>>>>> Fix by reusing the memcg_data snapshot already taken at function entry
>>>>> instead of calling PageMemcgKmem(), which is semantically equivalent:
>>>>> PageMemcgKmem()->folio_memcg_kmem()->folio->memcg_data & MEMCG_DATA_KMEM.
>>>>> This avoids both the TOCTOU window and the assertions entirely.
>>>>>
>>>>> Signed-off-by: Ye Liu <ye.liu@linux.dev>
>>>>> ---
>>>>>  mm/page_owner.c | 2 +-
>>>>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>>>>
>>>> LGTM.
>>>>
>>>> Reviewed-by: Zi Yan <ziy@nvidia.com>Hi,Zi,Vlastimil
>>>
>>> This patch still has warnings (see sashiko link[1]).
>>> I've made the following modifications, or do you have any better suggestions?
>> 
>> Maybe use snapshot_page() from mm/debug.c, so that you do not need to replicate
>> the code from folio_memcg_check(). You probably still need the rcu_read_lock()
>> when reading memcg_data from the snapshot to prevent memcg going away.
>> 
> But it does a full struct page + struct folio memcpy with retry loops,        
> which is more than what we need here -- we only care about memcg_data.        

Yeah seems too unnecessarily heavy.

> The READ_ONCE() snapshot is sufficient since the function already             
> holds rcu_read_lock() to keep the memcg alive once resolved.                  
>                                                                               
> The two-line inline of folio_memcg_check() logic is minimal, and we need      
> the OBJEXTS check to be explicit anyway (to print "Slab cache page\n"         
>  -- page_memcg_check() just returns NULL silently for slab pages).            

Yeah LGTM.


