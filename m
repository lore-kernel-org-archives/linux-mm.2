Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55F45CFD317
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:57:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B2C466B0092; Mon, 24 Nov 2025 05:57:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADCF26B0093; Mon, 24 Nov 2025 05:57:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A47D6B0095; Mon, 24 Nov 2025 05:57:16 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 843526B0092
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:57:16 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2BB624EB54
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:57:16 +0000 (UTC)
X-FDA: 84145198872.28.CB8B88F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 739B340013
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:57:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VePoEB34;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763981834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p3hm4dFrkLcyp8+7N8GNbZ7vAlPs2OUB64mOaDeGzRo=;
	b=g7U8zEVsQSw6BMB4BrYDPuOZkOrklz8zRnrpUO8q8gmpAw4FCfN+5uFdRhn22VvQzQIrOj
	DpXPFewsr2ULAbieYs0WaAKrlgLbRi2ltk46WYNV1OeXCLzad4B2fDAnSqgerx0MPMmbT7
	Q7XfvZvE7GGeKvz1g6vRkH6MoMe9MPk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763981834; a=rsa-sha256;
	cv=none;
	b=K1qvLwBLBU+BCYpCW8KeVYu1UKOlrTG0EMWuXhF9BJQZzgo6EhMAaD7Zryp+iv/GVGZO5M
	K3qw2G19eTn1Mtew6hqroM6bQJmAGk0rDw/3P9nCFAvQNCyRCNllXPvrN1jideqaDR1GBq
	9rJDDSRM4PDRI1sNYj/TYJFHBgPYUOE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=VePoEB34;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D6FC5601E8;
	Mon, 24 Nov 2025 10:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E2B4C19421;
	Mon, 24 Nov 2025 10:57:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763981833;
	bh=g0SgFDwx/n/2NQ3BVN7ZnT89KG47z00z7AtE2JdLszE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=VePoEB34zuAvu2THOHBxoC/tlB7N05OHP+4DBYwT42SBJaJuoLu3j91Llk1NIZsOR
	 c2xcNDtP6LHfSfGEl9d2+92xhg+WVDMYZYl9++VLzEklPm71OjIXF+GI7y4QaDCnnW
	 8XTI/JWZYrpiGNPUZ75qab8QKGmdcZIyVaaE3NDJb7T24r6N8PacNfgQf/pP2xTodE
	 OIM/lTslb6pjFcxrREZgDdE/qNtBQxcbFh9T+ytKt+FOoK4JMxJIUeXCZW9YcaKc46
	 yWEzWETv7LNsnzbucoz8G6Q9wk/za5ISV5i/ZfAmbaV4qiOaFDVicQl21FCnb/8scW
	 jXNlKQNuc7cpg==
Message-ID: <e83945be-056a-443c-b140-e3301c2109c5@kernel.org>
Date: Mon, 24 Nov 2025 11:57:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: restrict __GFP_ZEROTAGS to HW tagging
 architectures
To: Balbir Singh <balbirs@nvidia.com>,
 Catalin Marinas <catalin.marinas@arm.com>,
 "David Hildenbrand (Red Hat)" <davidhildenbrandkernel@gmail.com>,
 "akpm@linux-foundation.org" <akpm@linux-foundation.org>
Cc: Jan Polensky <japo@linux.ibm.com>, akpm@linux-foundation.org,
 linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org, will@kernel.org
References: <20251031170133.280742-1-catalin.marinas@arm.com>
 <20251109003613.1461433-1-japo@linux.ibm.com>
 <690ce196-58cb-4252-ab72-967e1e1574cf@gmail.com>
 <aRG05VS-IIxV2y_C@li-276bd24c-2dcc-11b2-a85c-945b6f05615c.ibm.com>
 <fbca7868-6f68-4b98-a2f2-e39eb46b7f12@gmail.com> <aRIEkLw7BofLjOWs@arm.com>
 <9ab7f5c8-a2fd-497b-a32e-4def84e0be26@nvidia.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <9ab7f5c8-a2fd-497b-a32e-4def84e0be26@nvidia.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: b34wumb46676poa9ji8je77f44wtwkai
X-Rspam-User: 
X-Rspamd-Queue-Id: 739B340013
X-Rspamd-Server: rspam10
X-HE-Tag: 1763981834-583193
X-HE-Meta: U2FsdGVkX19ykIvXMY/7gla2y0xOYz3SqdQcQHzi3qk2jb7teaKIgIltgCUiM1HnHVpUt0xpVD1E+KAQBeHQmbWiblqujaM0tfu599pG2IkMxyW1Yp9UqGwPZY80TYE9O0Ow70nFzY33jVxoOMR7fUu8HD6UgBdt1SeoZxJxGqcR7axZH6jnvW72fzH9j9v6BLtuU8RbVFwLWsFwFW5IICYDEh0feS6Q9ljwdp2Zp4wt2CxohznHDmAnDFF/bwT0Mojd5HoArjzu3dhuROEOlSqUZVmu4YBRbufX+7ixySv5IJJbnjiPPho3xgiq+8Ne7BjQJsFAdKt00rxJ4Iv2JbG3MFOBy0UE4hPJkmzePfLqFted+iEimjtImpfHKeVnQwhTnLvmyS9C2sQCHWFj3W2LobVkDnZVDBFKEciJtTGESupNliKl1v86KNGC1ZCF3vrFa0Tnw+YRfxI1s+mMDRqY1r+Lw742/0iE7Wc1xGn/ktat18DivtCw9eIcEs5Iq//szD/GKaFrXPxOol9T+Ppd9FcNvYNliLv4TZbqb01nmg4dB+0wSR5WWJ6LTDAqaE3E+bGPSREif5a4/bTT3R7IbWo+m5TlCyPub0YNyXWltOlOE9e1Mj3XLax/yhc+XO1WpwmAGOpz3NyWU2LyVEdQ7AEDEaplUDqBJwzmoGo4TiATlp9IA/Ca7xc4R6aiCStf/KF0/txMBT26PzSaFSIweG1aDbheyhTV+PrIl4Y5uJnQoVS6X/DouY8DtjKaOMy00SsFHDM0BMoNQIcLcqq5guf5hivzKN5egHjWo0YOwe4SYesvQangJjq90/g94dP4BNjeixPGjpVaX/RmhVw3Hq5gZV4jv+WVnDwAtGC/+HEKXNch8Yaax+UVFILpu7NbkdY5jCDppXEAjj6L8ON6CdqAOQX3UIxZL5PwpBjN58swfLdMZmMcbeICLsKp9lvBcQ7YTNqs9jDynGR
 LGqxDnHE
 V39ntfJDM12TaqJWxVSvA4PKJwKyWnT3Cfl3ItHNjQjElbDLKd0M1GBYko3nk7CgQknuSM+rTv7ZWfaHCNYe4oZZFiBbX03FsE4L+i8kZy9hztk+r7tnEvZYSaAYt/xgUTIWj7y6FTpFXn8GgR6GFe76qloM73fdvCPN/wUbraNpIHqiBGHkKqhSTT+wzS4VTDKzSJR8BGa74NPCfVnyN/g2fdODwpEHNt427aq+RhJB+xQiWLu8tu8mvjk2BS6Gs/jYNKkxjlT5pnWFHpQfslwpqsZs2PPXZ0ld0HmAh93ZqR5TfUQSVedqNY/mUuI2qeGoBp2GTuyyH5cB5qlbYjmM+I1IUg8rDt395jcGUDf086AgAvUwljorUjvTE62QLYC6YpP6ZHh8WFobMcYiRr4BU7bBRKd4fhHhD+WaB+AgJcNKIUhHKRlZjaaGCa0nW0/o7JhKAt+nUVNY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/22/25 13:04, Balbir Singh wrote:
> On 11/11/25 02:28, Catalin Marinas wrote:
>> On Mon, Nov 10, 2025 at 10:53:33AM +0100, David Hildenbrand (Red Hat) wrote:
>>> On 10.11.25 10:48, Jan Polensky wrote:
>>>> On Mon, Nov 10, 2025 at 10:09:31AM +0100, David Hildenbrand (Red Hat) wrote:
>>>>> On 09.11.25 01:36, Jan Polensky wrote:
>>>>>> The previous change added __GFP_ZEROTAGS when allocating the huge zero
>>>>>> folio to ensure tag initialization for arm64 with MTE enabled. However,
>>>>>> on s390 this flag is unnecessary and triggers a regression
>>>>>> (observed as a crash during repeated 'dnf makecache').
>> [...]
>>>>> I think the problem is that post_alloc_hook() does
>>>>>
>>>>> if (zero_tags) {
>>>>> 	/* Initialize both memory and memory tags. */
>>>>> 	for (i = 0; i != 1 << order; ++i)
>>>>> 		tag_clear_highpage(page + i);
>>>>>
>>>>> 	/* Take note that memory was initialized by the loop above. */
>>>>> 	init = false;
>>>>> }
>>>>>
>>>>> And tag_clear_highpage() is a NOP on other architectures.
>>
>> Hmm, another thing I missed. Sorry about this.
>>
>>>> Which works by the way for our arch (s390).
>>>>
>>>>    include/linux/gfp_types.h | 4 ++++
>>>>    1 file changed, 4 insertions(+)
>>>>
>>>> diff --git a/include/linux/gfp_types.h b/include/linux/gfp_types.h
>>>> index 65db9349f905..c12d8a601bb3 100644
>>>> --- a/include/linux/gfp_types.h
>>>> +++ b/include/linux/gfp_types.h
>>>> @@ -85,7 +85,11 @@ enum {
>>>>    #define ___GFP_HARDWALL        BIT(___GFP_HARDWALL_BIT)
>>>>    #define ___GFP_THISNODE        BIT(___GFP_THISNODE_BIT)
>>>>    #define ___GFP_ACCOUNT     BIT(___GFP_ACCOUNT_BIT)
>>>> +#ifdef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
>>>>    #define ___GFP_ZEROTAGS        BIT(___GFP_ZEROTAGS_BIT)
>>>> +#else
>>>> +#define ___GFP_ZEROTAGS        0
>>>> +#endif
>>>>    #ifdef CONFIG_KASAN_HW_TAGS
>>>>    #define ___GFP_SKIP_ZERO   BIT(___GFP_SKIP_ZERO_BIT)
>>>>    #define ___GFP_SKIP_KASAN  BIT(___GFP_SKIP_KASAN_BIT)
>>>>
>>>> This solution would be sufficient from my side, and I would appreciate a
>>>> quick application if there are no objections.
>>>
>>> As raised, to be sure that __HAVE_ARCH_TAG_CLEAR_HIGHPAGE is always seen
>>> early in that file, it should likely become a CONFIG_ thing.
>>
>> I'm fine with either option above but I'll throw one more in the mix:
>>
>> --------------------8<--------------------------------
>> diff --git a/arch/arm64/include/asm/page.h b/arch/arm64/include/asm/page.h
>> index 2312e6ee595f..dcff91533590 100644
>> --- a/arch/arm64/include/asm/page.h
>> +++ b/arch/arm64/include/asm/page.h
>> @@ -33,6 +33,7 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>>   						unsigned long vaddr);
>>   #define vma_alloc_zeroed_movable_folio vma_alloc_zeroed_movable_folio
>>   
>> +bool arch_has_tag_clear_highpage(void);
>>   void tag_clear_highpage(struct page *to);
>>   #define __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
>>   
>> diff --git a/arch/arm64/mm/fault.c b/arch/arm64/mm/fault.c
>> index 125dfa6c613b..318d091db843 100644
>> --- a/arch/arm64/mm/fault.c
>> +++ b/arch/arm64/mm/fault.c
>> @@ -967,18 +967,13 @@ struct folio *vma_alloc_zeroed_movable_folio(struct vm_area_struct *vma,
>>   	return vma_alloc_folio(flags, 0, vma, vaddr);
>>   }
>>   
>> +bool arch_has_tag_clear_highpage(void)
>> +{
>> +	return system_supports_mte();
>> +}
>> +
>>   void tag_clear_highpage(struct page *page)
>>   {
>> -	/*
>> -	 * Check if MTE is supported and fall back to clear_highpage().
>> -	 * get_huge_zero_folio() unconditionally passes __GFP_ZEROTAGS and
>> -	 * post_alloc_hook() will invoke tag_clear_highpage().
>> -	 */
>> -	if (!system_supports_mte()) {
>> -		clear_highpage(page);
>> -		return;
>> -	}
>> -
>>   	/* Newly allocated page, shouldn't have been tagged yet */
>>   	WARN_ON_ONCE(!try_page_mte_tagging(page));
>>   	mte_zero_clear_page_tags(page_address(page));
>> diff --git a/include/linux/highmem.h b/include/linux/highmem.h
>> index 105cc4c00cc3..7aa56179ccef 100644
>> --- a/include/linux/highmem.h
>> +++ b/include/linux/highmem.h
>> @@ -251,6 +251,11 @@ static inline void clear_highpage_kasan_tagged(struct page *page)
>>   
>>   #ifndef __HAVE_ARCH_TAG_CLEAR_HIGHPAGE
>>   
>> +static inline bool arch_has_tag_clear_highpage(void)
>> +{
>> +	return false;
>> +}
>> +
>>   static inline void tag_clear_highpage(struct page *page)
>>   {
>>   }
>> diff --git a/mm/page_alloc.c b/mm/page_alloc.c
>> index e4efda1158b2..5ab15431bc06 100644
>> --- a/mm/page_alloc.c
>> +++ b/mm/page_alloc.c
>> @@ -1798,7 +1798,8 @@ inline void post_alloc_hook(struct page *page, unsigned int order,
>>   {
>>   	bool init = !want_init_on_free() && want_init_on_alloc(gfp_flags) &&
>>   			!should_skip_init(gfp_flags);
>> -	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS);
>> +	bool zero_tags = init && (gfp_flags & __GFP_ZEROTAGS) &&
>> +		arch_has_tag_clear_highpage();
>>   	int i;
>>   
>>   	set_page_private(page, 0);
>> --------------------8<--------------------------------
>>
>> Reasoning: with MTE on arm64, you can't have kasan-tagged pages in the
>> kernel which are also exposed to user because the tags are shared (same
>> physical location). The 'zero_tags' initialisation in post_alloc_hook()
>> makes sense for this behaviour. With virtual tagging (briefly announced
>> in [1], full specs not public yet), both the user and the kernel can
>> have their own tags - more like KASAN_SW_TAGS but without the compiler
>> instrumentation. The kernel won't be able to zero the tags for the user
>> since they are in virtual space. It can, however, continue to use Kasan
>> tags even if the pages are mapped in user space. In this case, I'd
>> rather use the kernel_init_pages() call further down in
>> post_alloc_hook() than replicating it in tag_clear_highpage(). When we
>> get to upstreaming virtual tagging (informally vMTE, sometime next
>> year), I'd like to have a kernel image that supports both, so the
>> decision on whether to call tag_clear_highpage() will need to be
>> dynamic.
>>
>> [1] https://developer.arm.com/community/arm-community-blogs/b/architectures-and-processors-blog/posts/future-architecture-technologies-poe2-and-vmte
>>
> 
> I've run into the issue where due to init being set to false if zero_tags was set,
> the system does not clear the zero_folio. I just spent a lot of time debugging it :)
> 
> Catalin, were you going to send out this patch as a fix to be included in mm-unstable?
> I've for now reverted your __GFP_ZEROTAGS change to get_huge_zero_folio() for my testing
> 
> I am on the current mm-new branch.

We have a fix upstream now:

commit 5bebe8de19264946d398ead4e6c20c229454a552
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Tue Nov 18 08:21:27 2025 -0800

     mm/huge_memory: Fix initialization of huge zero folio


Andrew could consider picking it up as well temporarily to fix the issue 
until we rebase on top of the new kernel.

-- 
Cheers

David

