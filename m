Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3B8BCA600B
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 06:53:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD696B0092; Thu,  8 Oct 2026 02:53:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ACE66B0093; Thu,  8 Oct 2026 02:53:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 09BDD6B0095; Thu,  8 Oct 2026 02:53:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1CC46B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 02:53:42 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 57BC714045A
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:53:41 +0000 (UTC)
X-FDA: 85298543442.30.D4A4872
Received: from mta0.migadu.com (out-61.mta0.migadu.com [91.218.175.61])
	by imf23.hostedemail.com (Postfix) with ESMTP id 3192E140003
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:53:38 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=doZeMxEJ;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791442419;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BQHtkXh+0UhVMHQN2LEq96qme9/f7JJhPZSacUj/svY=;
	b=haBSIEqUcURZruc5/Fg0SjjOaziZXY/blGdOHjaNdodtiH50AgvRo0A/zf+AoNg7jnKyAP
	6pQ0nSmRWng+s9Ay3kmYJoFJ1LwLKwdtvbW4hXBGQEgCoQPFYM2qq26vV9q/MPcbxdTJhI
	dMKgOy/fINxJiS8ZBdA/GnBOIi9osCk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791442419;
	b=kcrz1rq7d9X8MCa5x+timZFeGU08Ej99LzFkHV3vWcGNIhcp67n28ZARTjrGGSIxnK3mhf
	9KhPTOBU3X1SHiyK/jIBs02poW0iAit/ZEMzKg2yQFfY8FMKPtb0qxkzol8z0P5eZfc+kO
	1yzL7qN3N+j6jmF7TO5WDdTEKajOF+A=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=doZeMxEJ;
	spf=pass (imf23.hostedemail.com: domain of hao.ge@linux.dev designates 91.218.175.61 as permitted sender) smtp.mailfrom=hao.ge@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=z2ehbjfdNRtNjl3Xf1WKPjKRNxEhnPWPrzzFO6wlB48=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1791442417; v=1; x=1792047217;
 b=doZeMxEJq3M+Ribv2UYlLjcTVwQgdFjMVCQzcDrgX3Dciuiw3O8QBBGF0nAo/LmK3tP/sqju
 5k7nSQyOFcb80Vi9qYbxjUFwTZLdpXqOpB4+Yl/C/EVBu/VclVMWpxHmVUr7ui2zPjRS4+VM4OS
 57orGijM8Pa/T8FwfbpKL5K8=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8493ebbdacfda9ac;
	Thu, 08 Oct 2026 06:53:37 +0000
X-Mizu-Trace-ID: 8493ebbdacfda9ac
X-Migadu-Flow: FLOW_OUT
Message-ID: <a15de109-a88a-49f8-80cc-7bf216d6954d@linux.dev>
Date: Thu, 8 Oct 2026 14:53:02 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 2/7] mm/vmalloc: undo partial mappings inside the
 mapping functions
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
Content-Language: en-US
From: Hao Ge <hao.ge@linux.dev>
In-Reply-To: <arzgoe-bXAz1poAt@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 3192E140003
X-Stat-Signature: ucjyu11c7rqba7xtg5ga66eundymcxrk
X-HE-Tag: 1791442418-224922
X-HE-Meta: U2FsdGVkX1+ZW+wtUjTbhSgE29zj1kFq3Ctc8xlZKBGtnwX4TSiTekl4XTh7kUfXDZuTn+kEvPdA5A31WTEjtowoAarqOXZuY7kAHu7WKMZHB/EJj7yUsjMeA1MIrzFvArtmsFhQXlb5XVZNW+Dc/UJQjowSZYbeodooz/zeHNEXxEmXV0Gl5517Je1NUREcyjpszHp0iMBAruwpkFRwsfVTmjiHCQp0iTrcIm3bFmyVnufMIYbdZh4O3FputU4ldxOiLY/MgZQn0NT1qxf7/wkbNgq7rWh3WGfl49ro1cwvk0ovFcYNYvF129Oxhf0doO9jrW6M+r/gVROjWoBxrNVXlTTVJoyT998hfIKzN7kO0cFneWK4uvtYJyQcMiXyA6nBp5DzkJ61i/QVIerEXKOqXf6o9H2CBJKPzmhLBJLpxNYG2Dx2OgKt7xBFCZhD3dYtqq69lyrtNLVyVSVtLTwovWorCnivXTBESj+sXzGtfTTKWlwStWRhqTyhyg6tYvCAXL7l9u0iyOKSA8oIqZiUXMwy3K4xHAldzkWoPmna0odcn4p04q9Y+/lb1rS56t5ap9JmFL2C9tq1jxUqfHyhsHbjYWrNwiRQDG47MZ532hyfYMEvNHeDNUNgvSTMDzCOQK2l/bD0EUXhHY9ldq6BoKTD3MLDXP/Y0M0hKmk7P0VHed9czEN2sq20hfwJpYv3NT8Z/MOoMYDVhA1ccBNiYIz8TjXRXTmwHzR4QCaEBm+1MbqVRzTz1UmOY9TBiRTZfjpJ1gguukcjpZ9IJhVtu/Ww9s3+PjuXz3Dv11GnIen9cJ8DwReVpuCN8vUH3P1xGdDHWL9GeODLTH1EkKzVR4279F043zMRBLERe+Vu7QD96/87m6BrzUdroVg30HdZzxGjGmQ9KGVHJu3KHL0Goni94W4McS6fAzdO/mkxK6FxeNB/jCDLAO/6cjUC8qehk8FRyu/tr75PCQ+
 SSmfqv7h
 m/yWGLoqyBpAYiwcR5U+DdKi+fc3ElZsxx9bfdylnhwAOaoQcAkQBv/AvjmU+MbP8J1EF0XBinfpvpdlGVNRYk0pXFiPPwe1k2JBEnAXe8HGoN6JStJGn8fgGDvF5p+iRarzQAc8mG7OkWkqwwYW8plwM0FV1gbPCZOu+P9lIl6u0jvV0gdFevixjKcZItS3kUbDdtSjMem/S4m+F4+sxW+BE7cjX+CJ9t3Tgb3BfS9rgJUhhuk69t1gppCDAE0Qa9lzu4PqroQ/RuKry5ROi1pVcoSrZkfRrUsaRuI/M71R8cgboWsz0ozeuIstz6IDKzhvGDhrwkxGNwTY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Uladzislau


On 2026/9/30 18:12, Uladzislau Rezki wrote:
> On Tue, Sep 29, 2026 at 04:20:09PM +0800, Hao Ge wrote:
>> __vmap_pages_range_noflush() and friends can install some PTEs before
>> failing and leave them mapped, and the kernel callers do not agree on
>> who cleans them up. For example, pcpu_map_pages() and
>> kmsan_ioremap_page_range() unmap the leftovers themselves, while
>> vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
>> __vmalloc_area_node() relied on the mapping functions cleaning up and
>> did not call anything like vunmap_range() themselves. When the same
>> range is mapped again, the attempt hits the leftovers and fails, with
>> BUG() in vmap_pte_range() for huge mappings.
>>
>> After discussing with Suren and Ulad, we decided the cleanup belongs
>> to __vmap_pages_range_noflush() and friends, so the callers no longer
>> need to unmap the partial mappings themselves. Each function now
>> undoes the PTEs it installed itself.
>>
>> The rollback calls the low-level __vunmap_range_noflush(), it just
>> clears the PTEs of the range it is given, which is all a rollback
>> needs. It cannot use vunmap_range_noflush() because these mapping
>> functions also map the KMSAN shadow and origin, and for a metadata
>> range its hook would look up the metadata of the metadata, get 0
>> and BUG() on addr >= end. The failed mappings were never accessed,
>> no TLB flush needed.
>>
>> Fixes: 9376130c390a ("mm/vmalloc: add support for __GFP_NOFAIL")
>> Fixes: 0f9b685626da ("alloc_tag: populate memory for module tags as needed")
>> Reported-by: Sashiko <sashiko-bot@kernel.org>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
>> ---
>>  mm/kmsan/shadow.c |  4 ++++
>>  mm/vmalloc.c      | 31 +++++++++++++++++++++++++++++--
>>  2 files changed, 33 insertions(+), 2 deletions(-)
>>
>> diff --git a/mm/kmsan/shadow.c b/mm/kmsan/shadow.c
>> index 0c88d89bf0d6..2166086d3dc3 100644
>> --- a/mm/kmsan/shadow.c
>> +++ b/mm/kmsan/shadow.c
>> @@ -258,6 +258,10 @@ int kmsan_vmap_pages_range_noflush(unsigned long start, unsigned long end,
>>  					    o_pages, page_shift);
>>  	kmsan_leave_runtime();
>>  	if (mapped) {
>> +		/* Undo the shadow mapping set up above. */
>> +		kmsan_enter_runtime();
>> +		__vunmap_range_noflush(shadow_start, shadow_end);
>> +		kmsan_leave_runtime();
>>  		err = mapped;
>>  		goto ret;
>>  	}
>>
> Can we just do that inside the vmalloc? For example in the
> __vmap_pages_range_noflush() as entry function for all(?) helpers?
> So we do not need do it manually?
>
The hunk was for the failure path in kmsan_vmap_pages_range_noflush().
Shadow and origin are mapped there as two separate calls, and when                                                                   
the origin one fails the shadow is already up. __vmap_pages_range_noflush()                                                          
cannot do that undo, it only sees its own range.

kmsan_vmap_pages_range_noflush() has a single caller, so if we were to move this
logic into vmalloc, it would require some modifications as follows:

@@ -712,9 +724,14 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
        int ret = kmsan_vmap_pages_range_noflush(addr, end, prot, pages,
                                                page_shift, gfp_mask);
 
+       if (!ret)
+               ret = __vmap_pages_range_noflush(addr, end, prot, pages,
+                                                page_shift);
+       /* Undo whatever was mapped before the failure. */
        if (ret)
-               return ret;
-       return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
+               kmsan_vunmap_range_noflush(addr, end);
+
+       return ret;
 }

>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index 859e6d2d57a3..9bbf75706627 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -349,6 +349,10 @@ static int vmap_range_noflush(unsigned long addr, unsigned long end,
>>  	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
>>  		arch_sync_kernel_mappings(start, end);
>>  
>> +	/* Undo the PTEs installed before the failure. */
>> +	if (err)
>> +		__vunmap_range_noflush(start, end);
>> +
>>  	return err;
>>  }
>>  
>> @@ -363,6 +367,9 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>>  	if (!err)
>>  		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>>  					       ioremap_max_page_shift);
>> +	if (err)
>> +		__vunmap_range_noflush(addr, end);
>> +
>>  	return err;
>>  }
>>  
>> @@ -667,6 +674,10 @@ static int vmap_small_pages_range_noflush(unsigned long addr, unsigned long end,
>>  	if (mask & ARCH_PAGE_TABLE_SYNC_MASK)
>>  		arch_sync_kernel_mappings(start, end);
>>  
>> +	/* Undo the PTEs installed before the failure. */
>> +	if (err)
>> +		__vunmap_range_noflush(start, end);
>> +
>>  	return err;
>>  }
>>  
> The only one user of that function is __vmap_pages_range_noflush()
> so we can cover both cases there small and huge path.
> 
> Is that enough just to do unroll in the below:
> 
> __vmap_pages_range_noflush()
> vmap_page_range()
> 
> functions? It will also fix NOFAIL case:
>

I see. right, __vmap_pages_range_noflush() is just above the
actual page‑table mapping, so it's low‑level enough.
Thanks a lot for your prototype.

I'm tidying up the code and will post a REF patch afterwards.

Thanks
Best Regards
Hao

> <snip>
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index 89c327a6ce7d..fa1f357ecf3f 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -359,10 +359,19 @@ int vmap_page_range(unsigned long addr, unsigned long end,
>  
>  	err = vmap_range_noflush(addr, end, phys_addr, pgprot_nx(prot),
>  				 ioremap_max_page_shift);
> +	if (err)
> +		goto error_cleanup_range;
> +
>  	flush_cache_vmap(addr, end);
> -	if (!err)
> -		err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
> +	err = kmsan_ioremap_page_range(addr, end, phys_addr, prot,
>  					       ioremap_max_page_shift);
> +	if (err)
> +		goto error_cleanup_range;
> +
> +	return 0;
> +
> +error_cleanup_range:
> +	__vunmap_range_noflush(addr, end);
>  	return err;
>  }
>  
> @@ -683,26 +692,35 @@ int __vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  		pgprot_t prot, struct page **pages, unsigned int page_shift)
>  {
>  	unsigned int i, nr = (end - addr) >> PAGE_SHIFT;
> +	unsigned long start = addr;
> +	int err;
>  
> -	WARN_ON(page_shift < PAGE_SHIFT);
> -
> -	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> -			page_shift == PAGE_SHIFT)
> -		return vmap_small_pages_range_noflush(addr, end, prot, pages);
> +	if (WARN_ON(addr >= end))
> +		return -EINVAL;
>  
> -	for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> -		int err;
> +	if (WARN_ON(page_shift < PAGE_SHIFT))
> +		return -EINVAL;
>  
> -		err = vmap_range_noflush(addr, addr + (1UL << page_shift),
> +	if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> +		page_shift == PAGE_SHIFT) {
> +		err = vmap_small_pages_range_noflush(addr, end, prot, pages);
> +	} else {
> +		for (i = 0; i < nr; i += 1U << (page_shift - PAGE_SHIFT)) {
> +			err = vmap_range_noflush(addr, addr + (1UL << page_shift),
>  					page_to_phys(pages[i]), prot,
>  					page_shift);
> -		if (err)
> -			return err;
> +			if (err)
> +				break;
>  
> -		addr += 1UL << page_shift;
> +			addr += 1UL << page_shift;
> +		}
>  	}
>  
> -	return 0;
> +	if (err)
> +		__vunmap_range_noflush(start, end);
> +
> +	/* 0 on success. */
> +	return err;
>  }
>  
>  int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
> @@ -714,7 +732,13 @@ int vmap_pages_range_noflush(unsigned long addr, unsigned long end,
>  
>  	if (ret)
>  		return ret;
> -	return __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
> +
> +	ret = __vmap_pages_range_noflush(addr, end, prot, pages, page_shift);
> +	if (ret)
> +		/* Cleanup KMSAN metadata. */
> +		kmsan_vunmap_range_noflush(addr, end);
> +
> +	return ret;
>  }
>  
>  static int __vmap_pages_range(unsigned long addr, unsigned long end,
> <snip>
> 
> --
> Uladzislau Rezki

