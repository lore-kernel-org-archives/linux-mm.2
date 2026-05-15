Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81F20CD4F25
	for <linux-mm@archiver.kernel.org>; Fri, 15 May 2026 13:36:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E9C716B0088; Fri, 15 May 2026 09:36:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E738E6B008A; Fri, 15 May 2026 09:36:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8A6D6B008C; Fri, 15 May 2026 09:36:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id C5C806B0088
	for <linux-mm@kvack.org>; Fri, 15 May 2026 09:36:50 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 548BC120684
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:36:50 +0000 (UTC)
X-FDA: 84769754580.12.A6CBAA0
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf30.hostedemail.com (Postfix) with ESMTP id 7A86D80008
	for <linux-mm@kvack.org>; Fri, 15 May 2026 13:36:48 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v0aYQLOh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3biEHaggKCCUKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3biEHaggKCCUKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778852208;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w0CIEuptY6BMu7SFz0yWG+fGqpoNXud+HkJ9T3GbtD4=;
	b=Ffg1yQ5JynOhtqYrKbiR8I2aV4GO1Pl0To8cEYStWCGXpTPwydjwWkg0neU4m4f6IYT/rj
	DJzk3sebEu7/mYQFPhUAGE7fLuue2l/2z0OwDLS/cKb/zHUbnERQww65cehQeLqeErs9gz
	ILY5QXGLfYN1NdGFDgXLp0atELDE96Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778852208; a=rsa-sha256;
	cv=none;
	b=TkgS9rKaNRFJZEuTYRUnqffl+yGWGSZQm8BG1kSMzhTon7o8p8/I+9GvG5SHwd3BsvKYWI
	pJ8jlRBp2nr+5KvrvUYs+8VWfTZ2Yv8pYdqBcjC4ye24UrbeDhSs+AyT+8Soa1npGPXGlF
	wizOcRkYxqsG3rni04KGltj9Mo97isk=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=v0aYQLOh;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf30.hostedemail.com: domain of 3biEHaggKCCUKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3biEHaggKCCUKBDLNBOCHPPHMF.DPNMJOVY-NNLWBDL.PSH@flex--jackmanb.bounces.google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-48fdb2b0cb8so14332565e9.0
        for <linux-mm@kvack.org>; Fri, 15 May 2026 06:36:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778852207; x=1779457007; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=w0CIEuptY6BMu7SFz0yWG+fGqpoNXud+HkJ9T3GbtD4=;
        b=v0aYQLOhVKacOb6k7f7pQgv4XyRMbXMFnX2cij4yijty560AaW9mRNCv4/s6HCYjHI
         PvHwurcNE4cr+YCv0JB3u1QWP4ybDquvsc0+jrm6+wqOfhWcui7qiO01LAhkNLKqTLZ1
         5XEP7tm7cplmqxu/VoIj96pUXjRsO9L4iReplLk8dVnrAaY5Pp4p/du/p/eC2ii/uc7s
         SGmQ7bNwlOFM9gBKijc9q/qIgbVLb7noppQTDWaApPODnTa5+d75Pw+H8Xm+xGwFiwv2
         uEPavsVM1ZEJGpaBjcOj5zWLDZTmD9ho28kKT6JuSfaotcoMjnWN2IidFCu2sMxo+1oJ
         nfsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778852207; x=1779457007;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=w0CIEuptY6BMu7SFz0yWG+fGqpoNXud+HkJ9T3GbtD4=;
        b=ALY1Ynfdn9GyVR1Ea2eJMgpwlvVr2FWZ3ERMvsE1LSgVTcpYxDppeY1fzgvcFO/egm
         NLqz3zJzu45TdFM3ET7qSS3iX3GY8y8LvXnsIzFmaFr59D3i4n88aLFknVekDMF+dCNI
         qKdJDtFNy0icNvzP+Ss/C5l5fJZKkRBiMwxi6ItCTHDNCgT1d/WY5//FnituoohWbcsc
         6yJY8DsNLnEECwfvex5YJP2DDO3jyoWO5MLWBFBL0SRSfLBLqBe5DcDSHTVK9UtBqWvS
         OtAQM/cg8DOFmzJXgkC5grNCliSgult3zSpd+D1ZBavCDngN0eepIgi739knyc9SUPwX
         1p9g==
X-Gm-Message-State: AOJu0YxQa/vN36Txn/4Rf26Hj5E+d47neqcQVgljj3lLUHZPiDNS2oLL
	pPe+jCwaEfDmzjmROUJsViIzTS2/aP4rNQv3jwxCLfLQ6MUtTUZ9jkaUnpvPIwfKLB3dn4TBmfh
	wfpSyl8nlo234vA==
X-Received: from wmrc26.prod.google.com ([2002:a05:600c:ada:b0:48e:6f63:7624])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:a405:b0:489:1f04:96c3 with SMTP id 5b1f17b1804b1-48fe5fcded3mr53489255e9.2.1778852206796;
 Fri, 15 May 2026 06:36:46 -0700 (PDT)
Date: Fri, 15 May 2026 13:36:43 +0000
In-Reply-To: <d5972a1d-42cd-4510-b734-c47b927af501@kernel.org>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-18-28bf1bd54f41@google.com> <d5972a1d-42cd-4510-b734-c47b927af501@kernel.org>
X-Mailer: aerc 0.21.0
Message-ID: <DIJAH8TVP33G.2YWJ4Z0KO0PZJ@google.com>
Subject: Re: [PATCH v2 18/22] mm/page_alloc: introduce ALLOC_NOBLOCK
From: Brendan Jackman <jackmanb@google.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 7A86D80008
X-Stat-Signature: 4g7hu5is1x43oow4jgzxxho9gbfxyyes
X-Rspam-User: 
X-HE-Tag: 1778852208-883003
X-HE-Meta: U2FsdGVkX193tProXV3kYyUNSOaOYKWASSWpFC86olfsEcb98zxLbphFLX9kiceRUmvTkFrLcBy/WBbQE9dC3oEd/hoLy5EWmQKpxwf2dvcUqiDUKWauX33FpHIy9MWIsTYQYa8IBR4BsqmxODFMWl/YcFf4WBAFEMSw/pPKX4IQs8vLTywrEMb9YsUlGZhSGVf/MBl2lADrP0oz9M81bENePVYQdf9aGzgBBPux+cdEq/fG5g5UAFE2G4D4MsAG3B7HQpJFDTbgzPYwsRw2dODxJTJnwDJB2RAwYEr4OQGgxNhPF2SF4mG6li0D6W0UD4nPSINfaoPKr8+OqoPdy6lgpvBGOxTvg9g7iP5Nu8OdpCL5+ebD34nOdEl33mIguVh0tY/X+RF+nBApPcJ+hVEDLV47aE7ep4wIRnDekIdIq7tjg/AJPpOUEb/OgwAqdjdAug5j8EDsN4JuMHA/vNR+ulAt7RI5KCSvnppnANqOTj3wtLQU0A16LemOWbWkmtA8vLjiWazBrmeLpNBt+UCigeWGpiS99rewWV7LnfJ1wDTXNPsepuk/gjANF11q6BKCxz+Yno9fURgr9I/wIYwJddFNsbltg1uNmpImJTO31oD80uhkK02rynCVcTDaYgBiFwfRKmKzkX0lcrzTb118IgdYcNj5t6qkG+Koly7XSU60u+X04yIVk1O61idH0VVAu9ozTIubQmimFJtlzsVQVDLl0/Vwkzbjq0EwMQsiE//vHPyzN5ILV/y4i1kOCRvueZRcAYZJuhznpfznxYPzIAYGDWWJx5pltbiIcCChyDN70IBP/EyH3qRzSLjmrwaCYe9EDZqGVXNyF+c//bVt61ENFHA2KfzU50kN3VvEFSs8qttkRGrCahJ5P1jCN/1H1VIxaT6mMKQKc+eVcISqQmbxlyQWmpkWN+hlf/zgSbVRbszspvkRBtcPWSvqgmpN75A8dZExV7Mjc6C
 MhSBNI8q
 AfXxuGvNGdNsi9RZbxyhYLfaoDRgS87if04pwtR6HhzLOvnTxlKOp1xIfWKevGSVsghe3k6nuU7cnLfuFRpPEd0WpiFF7P3J9OrGbL58r8r7Y2oHRbpUpOt2ss5KzhDsyzkcsx3N58raC6xOHNH6j7F0F/C9Ist8VDf9McPK8YG3YbWz4YOCn5uJf2prhlNn9QbryLl0pT9ejEDL6YnwOHLQWT2w/Htu46bEGEcb9lA/MIAYU4HBvMmFIisj2WAOOv/JryayS0s1nibuUDD3/Ro7B16TIKVJIETVsYQMJ2b3YKXZXcQXgK8mgpStmUWi94bAyOaTO6359Jfi1+erEMBQA636Z/yfIKrjK+GisG5ynZNFiEyoNhNoJuIS4eo8pi71kKnIjfYkbZH46OHP3CxAAdfvN4SQLi+NjdNQ+rgZTECjAWj6qnxDdLb/Rp99HiT97pUZzG/hMRCFOImXbwas3aVaBChNB/50V5GXwUbXXBnVv0ar8SFEjikEJGKWE6Z2Oc90AOdk6uxj3HfqGb0+EK9JB5DSZcSSzWdOZ9w4p9Z/15mx1BfFm6Z9UbXoLpypqaoL53FmIdm4zFsPGffO/S9IR0GdoBMoHi6UZA4aG5Hu43l+2nClJoAb2kB+38w8L
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed May 13, 2026 at 9:43 AM UTC, Vlastimil Babka (SUSE) wrote:
> On 3/20/26 19:23, Brendan Jackman wrote:
>> This flag is set unless we can be sure the caller isn't in an atomic
>> context.
>> 
>> The allocator will soon start needing to call set_direct_map_* APIs
>> which cannot be called with IRQs off. It will need to do this even
>> before direct reclaim is possible.
>> 
>> Despite the fact that, in principle, ALLOC_NOBLOCK is distinct from
>> __GFP_DIRECT_RECLAIM, in order to avoid introducing a GFP flag, just
>> infer the former based on whether the caller set the latter. This means
>> that, in practice, ALLOC_NOBLOCK is just !__GFP_DIRECT_RECLAIM, except
>> that it is not influenced by gfp_allowed_mask. This could change later,
>> though.
>
> I don't think it should change later? We wouldn't want false positives
> during boot, or what do you have in mind?

I don't think I had anything specific in mind or any reason to _want_ to
change it. But I think (??) there are reasons to clear
__GFP_DIRECT_RECLAIM even if you are not atomic? Like some sort of
generalisation of __GFP_NOIO/NOFS. So all I'm getting at here is: I'm
using __GFP_DIRECT_RECLAIM to set ALLOC_NOBLOCK, but I think of that as
a total implementation detail and these two flags should conceptually be
decoupled.

> I wonder if the implementation of the "not influenced" is correct though...

This has been broken in several local iterations of this patchset so I
would not be surprised...

>> Call it ALLOC_NOBLOCK in order to try and mitigate confusion vs the
>> recently-removed ALLOC_NON_BLOCK, which meant something different.
>> 
>> Signed-off-by: Brendan Jackman <jackmanb@google.com>
>> ---
>>  mm/internal.h   |  1 +
>>  mm/page_alloc.c | 29 ++++++++++++++++++++++-------
>>  2 files changed, 23 insertions(+), 7 deletions(-)
>> 
>> diff --git a/mm/internal.h b/mm/internal.h
>> index cc19a90a7933f..865991aca06ea 100644
>> --- a/mm/internal.h
>> +++ b/mm/internal.h
>> @@ -1431,6 +1431,7 @@ unsigned int reclaim_clean_pages_from_list(struct zone *zone,
>>  #define ALLOC_HIGHATOMIC	0x200 /* Allows access to MIGRATE_HIGHATOMIC */
>>  #define ALLOC_TRYLOCK		0x400 /* Only use spin_trylock in allocation path */
>>  #define ALLOC_KSWAPD		0x800 /* allow waking of kswapd, __GFP_KSWAPD_RECLAIM set */
>> +#define ALLOC_NOBLOCK	       0x1000 /* Caller may be atomic */
>>  
>>  /* Flags that allow allocations below the min watermark. */
>>  #define ALLOC_RESERVES (ALLOC_HARDER|ALLOC_MIN_RESERVE|ALLOC_HIGHATOMIC|ALLOC_OOM)
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index 9a07c552a1f8a..83d06a6db6433 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -4608,6 +4608,8 @@ gfp_to_alloc_flags(gfp_t gfp_mask, unsigned int order)
>>  		(gfp_mask & (__GFP_HIGH | __GFP_KSWAPD_RECLAIM));
>>  
>>  	if (!(gfp_mask & __GFP_DIRECT_RECLAIM)) {
>> +		alloc_flags |= ALLOC_NOBLOCK;
>
> When this is called from __alloc_pages_slowpath(), gfp_allowed_mask is
> already applied, so it will be influenced.

... yep. 

I have tried to generally refactor the flag setup in here to make
these kinda mistakes harder but I didn't have any good ideas (this was
when I spotted [0]). Maybe I was being too timid, I will try again.

[0] https://lore.kernel.org/linux-mm/20260331-b4-prepare_alloc_pages-flags-v1-1-ea2416def698@google.com/

>> +
>>  		/*
>>		 * Not worth trying to allocate harder for __GFP_NOMEMALLOC even
>>  		 * if it can't schedule.
>> @@ -4801,14 +4803,13 @@ check_retry_cpuset(int cpuset_mems_cookie, struct alloc_context *ac)
>>  
>>  static inline struct page *
>>  __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>> -						struct alloc_context *ac)
>> +		       struct alloc_context *ac, unsigned int alloc_flags)
>>  {
>>  	bool can_direct_reclaim = gfp_mask & __GFP_DIRECT_RECLAIM;
>>  	bool can_compact = can_direct_reclaim && gfp_compaction_allowed(gfp_mask);
>>  	bool nofail = gfp_mask & __GFP_NOFAIL;
>>  	const bool costly_order = order > PAGE_ALLOC_COSTLY_ORDER;
>>  	struct page *page = NULL;
>> -	unsigned int alloc_flags;
>>  	unsigned long did_some_progress;
>>  	enum compact_priority compact_priority;
>>  	enum compact_result compact_result;
>> @@ -4860,7 +4861,7 @@ __alloc_pages_slowpath(gfp_t gfp_mask, unsigned int order,
>>  	 * kswapd needs to be woken up, and to avoid the cost of setting up
>>  	 * alloc_flags precisely. So we do that now.
>>  	 */
>> -	alloc_flags = gfp_to_alloc_flags(gfp_mask, order);
>> +	alloc_flags |= gfp_to_alloc_flags(gfp_mask, order);
>
> Is it safe to just combine them? You come with ALLOC_WMARK_LOW and combine
> with ALLOC_WMARK_MIN from gfp_to_alloc_flags() but these are not bit flags,
> I think you end up with ALLOC_WMARK_LOW effectively.

Ah, thanks, I do remember thinking about this and deciding that it was
safe but I probably just misunderstood the watermark code.

This makes me a bit more attracted to the idea of a struct like Gregory
suggested in [1]. Then this could be captured in the type system.

> Probably you need to pass the old alloc_flags to gfp_to_alloc_flags, mask
> only ALLOC_NOBLOCK from it and combine with newly calculated alloc_flags. By
> not recomputing ALLOC_NOBLOCK you also avoid the problem pointed out above?

Nice, thanks for the pointer.

> (or we decide to not use gfp flag but a new function and then it's more like
> what alloc_frozen_pages_nolock_noprof() does).

