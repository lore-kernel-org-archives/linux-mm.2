Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39768F9EDE0
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 14:23:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 48E1C6B0088; Wed, 22 Apr 2026 10:23:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 418186B008A; Wed, 22 Apr 2026 10:23:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 303EB6B008C; Wed, 22 Apr 2026 10:23:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BFF46B0088
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 10:23:38 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9F35DC04E0
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:23:37 +0000 (UTC)
X-FDA: 84686410074.30.DD5FE53
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 94E991C000E
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 14:23:35 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MoxMtnak;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776867815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9TPsmFQ39PduZdo/GWt0IEvzvzx2Pmcg2p2k0m9I6Bk=;
	b=cl5vCH6Cj7qOJCLhoDU3NoGPd2q1JLi0cwv9KK2dZAbFJFNipLawMnhNtMSRtKjSG1EC8d
	KN4PB19rIDiw+1ARJmyar1zDNq8pyzwfcAujBwZU+2jgxBZ9GEUh+XcTg+zWcNzKaFbN+b
	wU8m4/Nk13otcjCBKxausig4/H2gaQc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776867815; a=rsa-sha256;
	cv=none;
	b=b2HCpptaBbWsQvw7NA7Hf+/QOucVZPDUEdrodE64klUEH0BaxF2A0qxMtM6F0QrITmJckJ
	v3oKk4thyX+N5wazUqg0dIjfQc1QRVL+gKMowfQMB3itUQuPUHNjRIsLgWpou7mkBRbQto
	OcJs/ki05FPWbEZvi47UNRYFmiz/Wj8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=MoxMtnak;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id DD7AD22C7;
	Wed, 22 Apr 2026 07:23:28 -0700 (PDT)
Received: from [10.164.148.46] (MacBook-Pro.blr.arm.com [10.164.148.46])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AA9513FAA1;
	Wed, 22 Apr 2026 07:23:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1776867814; bh=3NdZd/WuExrdOhjBM6B86YQwKYjqjkYz8aDySCD3Xho=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=MoxMtnakTOjPpUv1jtEfMCfYYkyq+GiFsFE9GNNxiZEHRGpKfpiPW6cEDjFG1lCyx
	 hp4Ol0qcVbtZv8GPncyKh4QGo+uESHqgKLlw4mq9vIqlzSIgHv2XKXnVp3/EQYw6PH
	 PnPMavI/LOF2j1uBQ7iCANdL5ciagSMRKl/VXroM=
Message-ID: <e772bbfc-1f77-478e-b378-7947ca7a8b3f@arm.com>
Date: Wed, 22 Apr 2026 19:53:16 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/3] vmalloc: add __GFP_SKIP_KASAN support
To: Ryan Roberts <ryan.roberts@arm.com>,
 Muhammad Usama Anjum <usama.anjum@arm.com>, Arnd Bergmann <arnd@arndb.de>,
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>,
 Juri Lelli <juri.lelli@redhat.com>,
 Vincent Guittot <vincent.guittot@linaro.org>,
 Dietmar Eggemann <dietmar.eggemann@arm.com>,
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>,
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>,
 Kees Cook <kees@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Uladzislau Rezki <urezki@gmail.com>, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrey Konovalov <andreyknvl@gmail.com>, Marco Elver <elver@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Peter Collingbourne <pcc@google.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 david.hildenbrand@arm.com
References: <20260324132631.482520-1-usama.anjum@arm.com>
 <20260324132631.482520-2-usama.anjum@arm.com>
 <727df89e-2069-4a7d-b3c0-88f89cd3dcf8@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <727df89e-2069-4a7d-b3c0-88f89cd3dcf8@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: rthutqxt6pbny3kj8yhcu7w3n1gwyaop
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 94E991C000E
X-Rspam-User: 
X-HE-Tag: 1776867815-892650
X-HE-Meta: U2FsdGVkX18vGXt2N/u4t3YuXznGIFrhVxWlq/NqtTccm195tERujVsX5Yh2Ak/QKnhq4fdTyYWq4Ri352jE33ySc0FIk/iJfO/4SrJoC6TPf23NQ2fmqOi1fvw3PFdLOb2RvjbuDJqIcbKV26DGFfJPj0RY/PcqtuqdU2yrqKDYQNG9ww42qBrZngWOLzFCl+PWBLZcO7CAAoBitVo7/Mr7Uub5t9SwFUleSy4w1svTbt6sZHf05Rkytubt0RH8qRr6y8KhPEo7ofDUKEYqkzukQJqdwYLSnOvCB03L/76Km+bFTqXNbLQ5sRZyHc4n96+m28mfwQYhvNz8vzL4N6tc6QaQAPvpaIDELsIgcPLXo+JrObJr4QE6ppCCM1zr5AdTFxtBOC+G72qc/TJv5cSyO6Bi9cETXSO/EILMDTM/hxbPLCZ9nIelOgszA2RbkkfCSFPrZjIpJ5FkEHBkjPWJarcNEeHYkEse1/ZKc+traMIjQMnaOb+rom2jnBIv5q609HDpdvAe1JU2EUY/hMbAMjjz/5JpJjiSvQTJxypopyL8Mg0MsLs8gASCfLh5FI+26D29Oinnv+fbVf38lKjr8wX9TvU3GwrDE7PLmx255Owb9LutZzQsTpYW7fuDIQp7sA0hpC+SsGwg0UV5Qjp6NhWCJeVGcNQyfqFADQ6qAzOOnjeCTnR9+sWPYunCq34hrQ/ZVpeZiVBpLGDVJ1VAvloX8oAu3ZRdgpX5DukIwjExfP9oi4FFSH/uw4yRLjPMqaQNLUE3MECNTtUm+EmKO2Pkcp5OtMVUn5yyh14pzCRATXO9O3qeaUsqx3tW9+S5YcV0t7Sbed6Q+W/35tS4JKrzqvdV2NawFyVwuPTjyTykXiZ4l5bNJL8PPS7PYkWB91dWtHXFtGSeVr395tuVBmXjbT/k8IQsruYp1R8SonpdOeYldURXC15ou25AMSk/UGn/OuxwYrqJjTy
 IwoG8udY
 d8PbPxDM7HeSB3LjWi0YudvXcVZQIKQb3oRPKx8gcIbeQAj9RaChS+lcgTEBcDKxq/gQoiWQOUPdOwqRbpGuzFeM2ZXal1KJq/2alC4F5wG+T9A3QVvliIQyCXcn2WftmiXcRCG+ECtfgSyhaemurWyctPM5C1wGrEHJMfaXlSA89s1YXEJ9h5R3vaHmECK/3muWbZlRX3+UjTkmkAa0vIshZDu5ZXsQwP35xhf+Upmf1jFpIyoFfXZQ4htoKK1MFrnNKem3UsMu1lgB7I3Md/D/T+mZPXeRw/G7WEdss405FiGBL9vRCUTgoXi/I2GOF1P35kiQC4bmFmfXlj5fgbZp2y3WyvSyG/Ru16/ywb9NQe2dFeiC7/BPg8fQ9MuMXZte3W4aPK8U6PzA3keSQmhE6eg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22/04/26 6:51 pm, Ryan Roberts wrote:
> On 24/03/2026 13:26, Muhammad Usama Anjum wrote:
>> For allocations that will be accessed only with match-all pointers
>> (e.g., kernel stacks), setting tags is wasted work. If the caller
>> already set __GFP_SKIP_KASAN, don’t skip zeroing the pages and
>> don’t set KASAN_VMALLOC_PROT_NORMAL so kasan_unpoison_vmalloc()
>> returns early without tagging.
>>
>> Before this patch, __GFP_SKIP_KASAN wasn't being used with vmalloc
>> APIs. So it wasn't being checked. Now its being checked and acted
>> upon. Other KASAN modes are unchanged because __GFP_SKIP_KASAN isn't
>> defined there.
>>
>> This is a preparatory patch for optimizing kernel stack allocations.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
>> ---
>> Changes since v1:
>> - Simplify skip conditions based on the fact that __GFP_SKIP_KASAN
>>   is zero in non-hw-tags mode.
>> - Add __GFP_SKIP_KASAN to GFP_VMALLOC_SUPPORTED list of flags
>> ---
>>  mm/vmalloc.c | 11 ++++++++---
>>  1 file changed, 8 insertions(+), 3 deletions(-)
>>
>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
>> index c607307c657a6..69ae205effb46 100644
>> --- a/mm/vmalloc.c
>> +++ b/mm/vmalloc.c
>> @@ -3939,7 +3939,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
>>  				__GFP_NOFAIL | __GFP_ZERO |\
>>  				__GFP_NORETRY | __GFP_RETRY_MAYFAIL |\
>>  				GFP_NOFS | GFP_NOIO | GFP_KERNEL_ACCOUNT |\
>> -				GFP_USER | __GFP_NOLOCKDEP)
>> +				GFP_USER | __GFP_NOLOCKDEP | __GFP_SKIP_KASAN)
>>  
>>  static gfp_t vmalloc_fix_flags(gfp_t flags)
>>  {
>> @@ -3980,6 +3980,8 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>>   *
>>   * %__GFP_NOWARN can be used to suppress failure messages.
>>   *
>> + * %__GFP_SKIP_KASAN can be used to skip poisoning
> 
> You mean skip *un*poisoning, I think? But you would only want this to apply to
> the actaul pages mapped by vmalloc. You wouldn't want to skip unpoisoning for
> any allocated meta data; I think that is currently possible since the gfp_flags
> that are passed into __vmalloc_node_range_noprof() are passed down to
> __get_vm_area_node() unmdified. You probably want to explicitly ensure
> __GFP_SKIP_KASAN is clear for that internal call?
> 
>> + *
>>   * Can not be called from interrupt nor NMI contexts.
>>   * Return: the address of the area or %NULL on failure
>>   */
>> @@ -4041,7 +4043,9 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>>  	 * kasan_unpoison_vmalloc().
>>  	 */
>>  	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
>> -		if (kasan_hw_tags_enabled()) {
>> +		bool skip_kasan = gfp_mask & __GFP_SKIP_KASAN;
>> +
>> +		if (kasan_hw_tags_enabled() && !skip_kasan) {
>>  			/*
>>  			 * Modify protection bits to allow tagging.
>>  			 * This must be done before mapping.
>> @@ -4057,7 +4061,8 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>>  		}
>>  
>>  		/* Take note that the mapping is PAGE_KERNEL. */
>> -		kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
>> +		if (!skip_kasan)
>> +			kasan_flags |= KASAN_VMALLOC_PROT_NORMAL;
> 
> It's pretty ugly to use the absence of this flag to rely on
> kasan_unpoison_vmalloc() not unpoisoning. Perhaps it is preferable to just not
> call kasan_unpoison_vmalloc() for the skip_kasan case?
> 
>>  	}
>>  
>>  	/* Allocate physical pages and map them into vmalloc space. */
> 
> Perhaps something like this would work:
> 
> ---8<---
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index c31a8615a8328..c340db141df57 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3979,6 +3979,8 @@ static gfp_t vmalloc_fix_flags(gfp_t flags)
>   * under moderate memory pressure.
>   *
>   * %__GFP_NOWARN can be used to suppress failure messages.
> +
> + * %__GFP_SKIP_KASAN skip unpoisoning of mapped pages (when prot=PAGE_KERNEL).
>   *
>   * Can not be called from interrupt nor NMI contexts.
>   * Return: the address of the area or %NULL on failure
> @@ -3993,6 +3995,9 @@ void *__vmalloc_node_range_noprof(unsigned long size,
> unsigned long align,
>  	kasan_vmalloc_flags_t kasan_flags = KASAN_VMALLOC_NONE;
>  	unsigned long original_align = align;
>  	unsigned int shift = PAGE_SHIFT;
> +	bool skip_kasan = gfp_mask & __GFP_SKIP_KASAN;
> +
> +	gfp_mask &= ~__GFP_SKIP_KASAN;

Okay so this is so that metadata allocation can keep using normal
page allocator side unpoisoning.

>   	if (WARN_ON_ONCE(!size))
>  		return NULL;
> @@ -4041,7 +4046,7 @@ void *__vmalloc_node_range_noprof(unsigned long size,
> unsigned long align,
>  	 * kasan_unpoison_vmalloc().
>  	 */
>  	if (pgprot_val(prot) == pgprot_val(PAGE_KERNEL)) {
> -		if (kasan_hw_tags_enabled()) {
> +		if (kasan_hw_tags_enabled() && !skip_kasan) {

Why do we want to elide GFP_SKIP_ZERO (set below) in this case?

>  			/*
>  			 * Modify protection bits to allow tagging.
>  			 * This must be done before mapping.
> @@ -4054,6 +4059,12 @@ void *__vmalloc_node_range_noprof(unsigned long size,
> unsigned long align,
>  			 * poisoned and zeroed by kasan_unpoison_vmalloc().
>  			 */
>  			gfp_mask |= __GFP_SKIP_KASAN | __GFP_SKIP_ZERO;
> +		} else if (skip_kasan) {
> +			/*
> +			 * Skip page_alloc unpoisoning physical pages backing
> +			 * VM_ALLOC mapping, as requested by caller.
> +			 */
> +			gfp_mask |= __GFP_SKIP_KASAN;
>  		}
>   		/* Take note that the mapping is PAGE_KERNEL. */
> @@ -4078,7 +4089,8 @@ void *__vmalloc_node_range_noprof(unsigned long size,
> unsigned long align,
>  	    (gfp_mask & __GFP_SKIP_ZERO))
>  		kasan_flags |= KASAN_VMALLOC_INIT;
>  	/* KASAN_VMALLOC_PROT_NORMAL already set if required. */
> -	area->addr = kasan_unpoison_vmalloc(area->addr, size, kasan_flags);
> +	if (!skip_kasan)
> +		area->addr = kasan_unpoison_vmalloc(area->addr, size, kasan_flags);

I really think we should do some decoupling here - GFP_SKIP_KASAN means,
"skip KASAN when going through page allocator". Now we reuse this flag
to skip vmalloc unpoisoning.

Some code path using GFP_SKIP_KASAN (which is highly likely given that
GFP_HIGHUSER_MOVABLE has this) and also using vmalloc() will unintentionally
also skip vmalloc unpoisoning.

I think we are doing patch 1 because of patch 2 - so in patch 2, perhaps
instead of calling __vmalloc_node we can call __vmalloc_node_range_noprof and
shift this "skip vmalloc unpoisoning" functionality into vmalloc flags instead?
Perhaps this won't work for the nommu case (__vmalloc_node has two definitions),
just a line of thought.


>   	/*
>  	 * In this function, newly allocated vm_struct has VM_UNINITIALIZED
> 
> ---8<---
> 
> Thanks,
> Ryan
> 
> 


