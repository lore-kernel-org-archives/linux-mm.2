Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35F5ACA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 08:12:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB72D6B008A; Thu,  8 Oct 2026 04:12:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D66D66B008C; Thu,  8 Oct 2026 04:12:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7DFB6B0092; Thu,  8 Oct 2026 04:12:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9E1146B008A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 04:12:21 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1B21A1404AB
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:12:21 +0000 (UTC)
X-FDA: 85298741682.16.0A977FE
Received: from mta1.migadu.com (out-15.mta1.migadu.com [95.215.58.15])
	by imf16.hostedemail.com (Postfix) with ESMTP id D63CA180003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 08:12:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vWA+RxS2;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.15 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791447139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fQUt4iBa4Q2Qkd65C1KCtWnzMP+p/qieKpHfH2umKrw=;
	b=K13p7RXoYT0wmk2Jv4emd8rolWZvRSSIGd0bkWSMTwyVJsTAMc8aj0Gk4M4DtvguaNdYm9
	idlp63jkqj1uFjdWn4Uvw5wl4j8Ou6syv3Vh82UHC6C16yigkMI/Y3RDsfSndGSLx1n48X
	++sB3co/0lpDPw53UmCj7Exp9ZjM59w=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791447139;
	b=d1cofw35xkObtQ/86ILaJUfoX9EWjjAvzLVx6/PffetKBuHTT0Q7Z15qSzc0EHsPxiL3P3
	VXCS1p/7owThNXuc9IOv4bILWOcx5esGEStgeEfxTBy607hjRQx9wwhQwCUN7MP7dZ7W31
	G5DAmSoxclHzq92NEMgBMWhW6wYwXTQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=vWA+RxS2;
	spf=pass (imf16.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.15 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=PLvbKK8F/Bm5bhh9c08LKLirJfE5QGxiNc7t1L+MVUA=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791447137; v=1; x=1792051937;
 b=vWA+RxS2zeAYwJrl/QBJtmF6IaLB+kMyO61+dMRbeXGmiRTaJd0co5ibWcBsc7zvwWLdMCyc
 VQQv9ruCRXvqzB7vA9RBmX/jLXnnI7E4a2VOBx5RHHVcWu5ONJdn61SoQ7WuIuqjYX92slY4apz
 2iLUPthszWYs1apmRNOKKMHw=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 226010a611eb6f78;
	Thu, 08 Oct 2026 08:12:17 +0000
X-Mizu-Trace-ID: 226010a611eb6f78
X-Migadu-Flow: FLOW_OUT
Message-ID: <896c2dc7-4787-4c22-90dc-a3cd607be6fa@linux.dev>
Date: Thu, 8 Oct 2026 16:13:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 2/7] mm/vmalloc: undo partial mappings inside the
 mapping functions
From: Hao Ge <hao.ge@linux.dev>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>,
 =Kent Overstreet <kent.overstreet@linux.dev>,
 Luis Chamberlain <mcgrof@kernel.org>, Petr Pavlu <petr.pavlu@suse.com>,
 Daniel Gomez <da.gomez@kernel.org>, Sami Tolvanen <samitolvanen@google.com>,
 Aaron Tomlin <atomlin@atomlin.com>, Andrew Morton
 <akpm@linux-foundation.org>, Alexander Potapenko <glider@google.com>,
 Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
 Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-modules@vger.kernel.org, kasan-dev@googlegroups.com,
 Sashiko <sashiko-bot@kernel.org>, stable@vger.kernel.org
References: <20260929082014.160587-1-hao.ge@linux.dev>
 <20260929082014.160587-3-hao.ge@linux.dev> <arzgoe-bXAz1poAt@milan>
 <a15de109-a88a-49f8-80cc-7bf216d6954d@linux.dev>
Content-Language: en-US
In-Reply-To: <a15de109-a88a-49f8-80cc-7bf216d6954d@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: D63CA180003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: swizkoiqhou6ab1neqhwegaxobruhoqt
X-HE-Tag: 1791447138-233602
X-HE-Meta: U2FsdGVkX19lbXC0C2vAJ5fzB2mbJ9FR23LF/d+I8XJV4fq+uxgIFgR0ad05fuJ++CixEkwEE1XVfqT0npyCkI4F/9WNQyXchtyyh2jsXZjztme1Tim+hZirA97eq/wBtj76vGqxfy3dIR2O30U890C6xUvC+sk+3dhrAoYP5fFEfqw6cXWergXOnvjHUQkFDkhpoaJAraFYCA3mYaqBP0ZsrYp2BXEKEzbWrRp0RpId4w47LUXQ3D63UVYNBxeJjYYeJt5eAittMqK/FwMPwCZD/+ab1ExVACheIJUwHqcZzxW1HLRCwpGcfrZpRdPZ8m0gjwtvEf9cwXzmqOA4C0/ycvl/nxDDrwEGUCF78pDRjU95VZc7424pb/lFB3WlBkaHZERbKiRi+Q/5U/58+5S6x2aUV24FmfGxugFO5gKTIvvYFj5kx/sOKTNewzdYpIhrgM3Lrje2b2w67mHFLXfoAr6zR9XG9wGirph1b3iIKaThIkvJ9VG1SG/sT20NluOwLV1nAuvKKop+ozeVltjit7iZOFHaBqEOALYnAoF3UN7zCE6CrZPXzhJPF85cJcgfCS1uz7a0QqkcLXz6f9+VijpFHHMFJK2XHJ+C6O1gzVwRK9/+X8Zr0PWOFxjzS4D0DmwwRjZmi6tfwYsnBSHk8/rE1JKDwiy+vRvyAwK/9xN+YKBs9MV3mPfIijCKEv7Cj85xdfvxKcjj1cYDC5dn7HdHimzoAXOfa9Ks9COxN4mcCW40yg5Kp8s4RD4ev1yfVtybLugiMi8nHZ/7MnsLqxPOhYDLG3FOXWYiXnocozuekbfOR5XHUBIvUWcj5F39/xYjl6sq8/UyO7Djyv2jfxE3cdBGAYNCdBrRu91wxGx2mSEnrTs+nDvPnxeH7HoNZtXxnuMHy8vEHCLdXNR1G372c8P6RaRltYiZxZ2UDcbb+IpqQZ10Tm0fvb+lT9avORZNUVSnWMGEqUz
 dTaVDfYs
 ep88anIbd4zHQEjKKEwffivm10F0sbW5fnlEUGAhKM54YdDkgEEswSwAMA2eOeJcYX4T4fsN2J+PFnRztgLGECT99hbML0K1swfv+0wTupPsLp5J4akPRMlaPEM3XRbSDVvwxgSYrSBKTnvVdytKG3OK9PN8JKBML1oh/JCu/hKgcTy67sjWWOQTXA09c8GAvX11LLNS/UpyFKeDzv3+FLZMaxdFAqpJs8fSBPy1eSFvMYInyHZyfc7R0I8qAudzPyl7BriA8hm7eeuj7reZ2qKGErr3Bh0kYpLSTa//Gh4x1DuMQjn+pDqbUblAHPJV9mfFHoDc81Cf+KLqId9hjlqnVMUNP0mvo2Jz0xftfreMzUiY/SKKxydbb7z5qnNCMZAHH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/10/8 14:53, Hao Ge wrote:
> Hi Uladzislau
> 
> 
> On 2026/9/30 18:12, Uladzislau Rezki wrote:
>> On Tue, Sep 29, 2026 at 04:20:09PM +0800, Hao Ge wrote:
>>> __vmap_pages_range_noflush() and friends can install some PTEs before
>>> failing and leave them mapped, and the kernel callers do not agree on
>>> who cleans them up. For example, pcpu_map_pages() and
>>> kmsan_ioremap_page_range() unmap the leftovers themselves, while
>>> vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
>>> __vmalloc_area_node() relied on the mapping functions cleaning up and
>>> did not call anything like vunmap_range() themselves. When the same
>>> range is mapped again, the attempt hits the leftovers and fails, with
>>> BUG() in vmap_pte_range() for huge mappings.
>>>
>>> After discussing with Suren and Ulad, we decided the cleanup belongs
>>> to __vmap_pages_range_noflush() and friends, so the callers no longer
>>> need to unmap the partial mappings themselves. Each function now
>>> undoes the PTEs it installed itself.
>>>
>>> The rollback calls the low-level __vunmap_range_noflush(), it just
>>> clears the PTEs of the range it is given, which is all a rollback
>>> needs. It cannot use vunmap_range_noflush() because these mapping
>>> functions also map the KMSAN shadow and origin, and for a metadata
>>> range its hook would look up the metadata of the metadata, get 0
>>> and BUG() on addr >= end. The failed mappings were never accessed,
>>> no TLB flush needed.
>>>
>>> Fixes: 9376130c390a ("mm/vmalloc: add support for __GFP_NOFAIL")
>>> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
>>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>>> Cc: stable@vger.kernel.org
>>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>>> ---
>>>  mm/kmsan/shadow.c |  4 ++++
>>>  mm/vmalloc.c      | 31 +++++++++++++++++++++++++++++--
>>>  2 files changed, 33 insertions(+), 2 deletions(-)
>>>
>>> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
>>> index 0c88d89bf0d6..2166086d3dc3 100644
>>> --- a/mm/kmsan/shadow.c
>>> +++ b/mm/kmsan/shadow.c
>>> @@ -258,6 +258,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>>>  					    o_pages, page_shift);
>>>  	kmsan_leave_runtime();
>>>  	if (mapped) {
>>> +		/* Undo the shadow mapping set up above. */
>>> +		kmsan_enter_runtime();
>>> +		__vunmap_range_noflush(shadow_start, shadow_end);
>>> +		kmsan_leave_runtime();
>>>  		err = mapped;
>>>  		goto ret;
>>>  	}
>>>
>> Can we just do that inside the vmalloc? For example in the
>> __vmap_pages_range_noflush() as entry function for all(?) helpers?
>> So we do not need do it manually?
>>
> The hunk was for the failure path in kmsan_vmap_pages_range_noflush().
> Shadow and origin are mapped there as two separate calls, and when                                                                   
> the origin one fails the shadow is already up. __vmap_pages_range_noflush()                                                          
> cannot do that undo, it only sees its own range.
> 
> kmsan_vmap_pages_range_noflush() has a single caller, so if we were to move this
> logic into vmalloc, it would require some modifications as follows:
> 
> @@ -712,9 +724,14 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>         int ret = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
>                                                 page_shift, gfp_mask);
>  
> +       if (!ret)
> +               ret = __vmap_pages_range_noflush(addr, end, prot, pages,
> +                                                page_shift);
> +       /* Undo whatever was mapped before the failure. */
>         if (ret)
> -               return ret;
> -       return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
> +               kmsan_vunmap_range_noflush(addr, end);
> +
> +       return ret;
>  }
>

I'd rather put this logic inside kmsan_vmap_pages_range_noflush.
This function should clean things up on its own, not depend on
the caller to do it, just like kmsan_ioremap_page_range.

https://elixir.bootlin.com/linux/v7.3-rc5/source/mm/kmsan/hooks.c#L185

Uladzislau, WDYT?

Thanks
Best Regards
Hao

>>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>>> index 859e6d2d57a3..9bbf75706627 100644
>>> --- a/mm/vmalloc.c
>>> +++ b/mm/vmalloc.c
>>> @@ -349,6 +349,10 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
>>>  	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
>>>  		arch_sync_kernel_mappings(start, end);
>>>  
>>> +	/* Undo the PTEs installed before the failure. */
>>> +	if (err)
>>> +		__vunmap_range_noflush(start, end);
>>> +
>>>  	return err;
>>>  }
>>>  
>>> @@ -363,6 +367,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>>>  	if (!err)
>>>  		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>>>  					       ioremap_max_page_shift);
>>> +	if (err)
>>> +		__vunmap_range_noflush(addr, end);
>>> +
>>>  	return err;
>>>  }
>>>  
>>> @@ -667,6 +674,10 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>>>  	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
>>>  		arch_sync_kernel_mappings(start, end);
>>>  
>>> +	/* Undo the PTEs installed before the failure. */
>>> +	if (err)
>>> +		__vunmap_range_noflush(start, end);
>>> +
>>>  	return err;
>>>  }
>>>  
>> The only one user of that function is __vmap_pages_range_noflush()
>> so we can cover both cases there small and huge path.
>>
>> Is that enough just to do unroll in the below:
>>
>> __vmap_pages_range_noflush()
>> vmap_page_range()
>>
>> functions? It will also fix NOFAIL case:
>>
> 
> I see. right, __vmap_pages_range_noflush() is just above the
> actual page‑table mapping, so it's low‑level enough.
> Thanks a lot for your prototype.
> 
> I'm tidying up the code and will post a REF patch afterwards.
> 
> Thanks
> Best Regards
> Hao
> 
>> <snip>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 89c327a6ce7d..fa1f357ecf3f 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -359,10 +359,19 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>>  
>>  	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
>>  				 ioremap_max_page_shift);
>> +	if (err)
>> +		goto error_cleanup_range;
>> +
>>  	flush_cache_vmap(addr, end);
>> -	if (!err)
>> -		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>> +	err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>>  					       ioremap_max_page_shift);
>> +	if (err)
>> +		goto error_cleanup_range;
>> +
>> +	return 0;
>> +
>> +error_cleanup_range:
>> +	__vunmap_range_noflush(addr, end);
>>  	return err;
>>  }
>>  
>> @@ -683,26 +692,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>  		pgprot_t prot, struct page **pages, unsigned int page_shift)
>>  {
>>  	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
>> +	unsigned long start = addr;
>> +	int err;
>>  
>> -	WARN_ON(page_shift < PAGE_SHIFT);
>> -
>> -	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>> -			page_shift == PAGE_SHIFT)
>> -		return vmap_small_pages_range_noflush(addr, end, prot, pages);
>> +	if (WARN_ON(addr >= end))
>> +		return -EINVAL;
>>  
>> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>> -		int err;
>> +	if (WARN_ON(page_shift < PAGE_SHIFT))
>> +		return -EINVAL;
>>  
>> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
>> +		page_shift == PAGE_SHIFT) {
>> +		err = vmap_small_pages_range_noflush(addr, end, prot, pages);
>> +	} else {
>> +		for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
>> +			err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>>  					page_to_phys(pages[i]), prot,
>>  					page_shift);
>> -		if (err)
>> -			return err;
>> +			if (err)
>> +				break;
>>  
>> -		addr += 1UL << page_shift;
>> +			addr += 1UL << page_shift;
>> +		}
>>  	}
>>  
>> -	return 0;
>> +	if (err)
>> +		__vunmap_range_noflush(start, end);
>> +
>> +	/* 0 on success. */
>> +	return err;
>>  }
>>  
>>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>> @@ -714,7 +732,13 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>>  
>>  	if (ret)
>>  		return ret;
>> -	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
>> +
>> +	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
>> +	if (ret)
>> +		/* Cleanup KMSAN metadata. */
>> +		kmsan_vunmap_range_noflush(addr, end);
>> +
>> +	return ret;
>>  }
>>  
>>  static int __vmap_pages_range(unsigned long addr, unsigned long end,
>> <snip>
>>
>> --
>> Uladzislau Rezki

