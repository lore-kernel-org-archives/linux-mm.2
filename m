Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1D4AD6ACF0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 11:49:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14B976B0092; Thu, 18 Dec 2025 06:49:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1237C6B0093; Thu, 18 Dec 2025 06:49:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 059956B0095; Thu, 18 Dec 2025 06:49:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E76896B0092
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 06:49:27 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B433C140E70
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:49:27 +0000 (UTC)
X-FDA: 84232421574.07.140ECEF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id E8459140006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 11:49:25 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YyhtvcbE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766058566; a=rsa-sha256;
	cv=none;
	b=7nO+O8SVzDxxBGeHWaqegeGiahYrdDZYo6HssasduZaPsYAK24ePfz0Juqf8Zrn5u/2sSr
	ZS01KrbjFoADhzCQq09dVmDoqImqoQ3DA7wWM6Gsu/hKrOjKqoWZFJkOMNTYh49621TbGu
	urUbJci/01vN/y44DYf2US9FUZ89g/o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YyhtvcbE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766058566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CBNFdj8jNj4e73AwqH2b8RTYHD+SEa8VUUUZ4Jyp12I=;
	b=2rliDddwdceoG5f9C7WIIOwPvLtvL302rtpLOzppwpRJwSuXpPSJLcFcvFoX3S5NOFHbPd
	y0+zpMVqZ7MX8XZ8Edv8L/p4j/XtsBk5cvDwB6OLQfPFKhyVZ33zTibtB3g2Qe53eZmbu6
	WYAPn/JF3ugLodx/uL4XfqyfJW0C45A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D44AD43C9C;
	Thu, 18 Dec 2025 11:49:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB7B4C4CEFB;
	Thu, 18 Dec 2025 11:49:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766058564;
	bh=gM97SVLiy9VJPrcCvd10t4/kGkIwU1lgSn+lqj1MNrk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=YyhtvcbEpQ3dx0joR9Z84m74P1AJNxNm5ONNsJnIGdfoA6X59qp1wgOjkZldkGYOd
	 Lm1vova5Z6bcgbsyD7lrCsMUtdNhRo3bteUBlzqJFibthUXHJkLqVFX539iuUSMeKO
	 RQwiay1O5vobunnyWgmgLfU6EfhYYuOOjIChI956no22qzMHFrQ8vEYArCuGDo+5Cu
	 UFrAum8TaRD88pwmrnCeMWrmHCMW01FApulnS4qCPs1NbV5JZiJWtPLFdj3xYfMwQ8
	 8L87Lt0ucjEgfrMO5TUwhl87d1CKQhcHwOeoyOCKu0yFwTP53yrJcsDxiuNgZV09YI
	 EumNBapvE5wgw==
Message-ID: <d2aa6eb6-cf67-4b89-a9d4-306c720fad55@kernel.org>
Date: Thu, 18 Dec 2025 12:49:19 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] sparc: Use vmemmap_populate_hugepages for
 vmemmap_populate
To: Tao pilgrim <pilgrimtao@gmail.com>
Cc: davem@davemloft.net, andreas@gaisler.com, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, kevin.brodsky@arm.com,
 dave.hansen@linux.intel.com, ziy@nvidia.com, chengkaitao@kylinos.cn,
 willy@infradead.org, zhengqi.arch@bytedance.com, sparclinux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251217120858.18713-1-pilgrimtao@gmail.com>
 <d373f7b0-f822-4c31-990c-41a6cdc76db3@kernel.org>
 <CAAWJmAYJdEJyybVgD7erzZgvwufZ8gSmP_FCohmZLYozbhbb3g@mail.gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <CAAWJmAYJdEJyybVgD7erzZgvwufZ8gSmP_FCohmZLYozbhbb3g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: E8459140006
X-Stat-Signature: 5551ai81kknixfsqy7rwzyodaodkswxn
X-Rspam-User: 
X-HE-Tag: 1766058565-828729
X-HE-Meta: U2FsdGVkX18Qi+403hmRO6JSgdKupd8tbCwZYIjd/PMjf8lLxgM90GjL9Y1LH2LNI08k4YJWnbi7IJEXeFMHm1AmlfV5N2u+2b+oe2NUCzL7G/3sCb3uO3Of7KRAV2665FaBM0Q/tQCNP3TSPhokhf4M6/KnshABT4f40hvCYxvPnISZk9GM4+y3Yr22ZKD14GGDHk0c3Vt/IgM66kRi49rpDLFhuMai8SyUeu5RSaBVeBo2rLv2aLiiOt+qT5YlAqqDEmTjOTN8LIroRl6I6krCB8fQcvCtju0gnnTEKo3m26zMpCbkytngZR16MkyZ/AwZbWo61eG+7m+ZZ8pmKHB/QWBKV3xr3urZQhjiCTfFWUZYTFhNVhoNvqg2zmSkL1Uf9+SodW7KnfOCL1dErQLNrTyFEzrgUUnrbIDvWRNvvPwV+6E6jM/bxOuG1W9vE09y14wOPWKY1Ys+WJRy+8g99p/VPfSVz9971S+3l4Dic3K5TXUp+D6zbBCwsbfCo0uDsrJrjqwvq5N188/kthWnO1agrwEV8GwK/BJqGItFzUbmqyfMBdkm6JHF/gFbh88QFbkhq73HsE3/cEYWPhyiwBUEgb5IJxTvVJfYULjp2HGZ6XFn6Rftx75z8EV+70cd97BHH1sGUbN0NeJu0Sj7qzJ7THyBrdKm56cvZzCiQfCtSwcgg8OaphNLquRmvup2ARlbW4yQ7e7krntDY4XmVisU5IboYhktvXv7WACOdzG1GTlxDoEGEzZDBHY6v5mHrzq3xrjEC1iqpWfjJOIUCxrFwihBWHv9vxHC9UkLXRWrN6h/3UixmdNqxw2DqbpAMpbsOrFPGdtqAGVZFOOiqLiIL4n/TYnQuhdVLMJKksLQ8wxhWNHQkSlpRV23OEaqwo7GwDJoF5ao+d/7E+XqEeZ4x/pnvx6f9QHAaLZtYBKvWTxgsZdNVGAzE4tHMNgrvrGH3hrZFaiJZZz
 IkBkvYSZ
 XZBNUWuTwRblqscfE7OS1NYFspesdgd1vYtp1xu00ckHsjnf0Dx376bTrrLHkNegKnpghbPCeioB5silZXjTDkSaKUSpirkfvz18i37C+ArQUIHzcQtz/YZkbtVOCfUKZHcavp/vKCMI3cTw7qFhlcD34nR9w3bJSkfVqlv4G28HMxbemZnYNUepoXHL6s4buIKM9IgqoMNTRjA7EQz7QYkalRWXOMyA7nsl8o6E8zJg+YPvz5TpUeT78cVj/IUEHKT4QMckaBkHUtG9+mA/ogKuYAlPQqaD7FnSlMwgGqibkAgdbZ1uRIJfKpzJReoaFQMBo
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/18/25 12:02, Tao pilgrim wrote:
> On Thu, Dec 18, 2025 at 4:44 PM David Hildenbrand (Red Hat)
> <david@kernel.org> wrote:
>>
>> On 12/17/25 13:08, chengkaitao wrote:
>>> From: Chengkaitao <chengkaitao@kylinos.cn>

^ this is the author

And you reply from a completely different address with a completely 
different name.

To whom am I talking here? The patch author?


[...]

>>>
>>
>> Bunch of unrelated changes that should not go in here.
> 
> This indeed contains some unrelated code changes and removal of
> extra whitespace. These could be split into a separate patch,
> but the new patch might be somewhat redundant, lol. If you'd
> like me to proceed this way, please reply confirming.

We usually don't do random other stuff as part of one patch. It's a 
different story if you touch the surrounding code, but that doesn't look 
like that here?

> 
>>> @@ -2581,8 +2581,8 @@ unsigned long _PAGE_CACHE __read_mostly;
>>>    EXPORT_SYMBOL(_PAGE_CACHE);
>>>
>>>    #ifdef CONFIG_SPARSEMEM_VMEMMAP
>>> -int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
>>> -                            int node, struct vmem_altmap *altmap)
>>> +void __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>>> +                            unsigned long addr, unsigned long next)
>>>    {
>>>        unsigned long pte_base;
>>>
>>> @@ -2595,39 +2595,25 @@ int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
>>>
>>>        pte_base |= _PAGE_PMD_HUGE;
>>>
>>> -     vstart = vstart & PMD_MASK;
>>> -     vend = ALIGN(vend, PMD_SIZE);
>>> -     for (; vstart < vend; vstart += PMD_SIZE) {
>>> -             pgd_t *pgd = vmemmap_pgd_populate(vstart, node);
>>> -             unsigned long pte;
>>> -             p4d_t *p4d;
>>> -             pud_t *pud;
>>> -             pmd_t *pmd;
>>> -
>>> -             if (!pgd)
>>> -                     return -ENOMEM;
>>> -
>>> -             p4d = vmemmap_p4d_populate(pgd, vstart, node);
>>> -             if (!p4d)
>>> -                     return -ENOMEM;
>>> -
>>> -             pud = vmemmap_pud_populate(p4d, vstart, node);
>>> -             if (!pud)
>>> -                     return -ENOMEM;
>>> -
>>> -             pmd = pmd_offset(pud, vstart);
>>> -             pte = pmd_val(*pmd);
>>> -             if (!(pte & _PAGE_VALID)) {
>>> -                     void *block = vmemmap_alloc_block(PMD_SIZE, node);
>>> +     pmd_val(*pmd) = pte_base | __pa(p);
>>> +}
>>>
>>> -                     if (!block)
>>> -                             return -ENOMEM;
>>> +bool __meminit vmemmap_false_pmd(pmd_t *pmd, int node)
>>> +{
>>> +     return true;
>>> +}
>>>
>>> -                     pmd_val(*pmd) = pte_base | __pa(block);
>>> -             }
>>> -     }
>>> +int __meminit vmemmap_check_pmd(pmd_t *pmdp, int node,
>>> +                             unsigned long addr, unsigned long next)
>>> +{
>>> +     vmemmap_verify((pte_t *)pmdp, node, addr, next);
>>> +     return 1;
>>> +}
>>>
>>> -     return 0;
>>> +int __meminit vmemmap_populate(unsigned long vstart, unsigned long vend,
>>> +                            int node, struct vmem_altmap *altmap)
>>> +{
>>> +     return vmemmap_populate_hugepages(vstart, vend, node, altmap);
>>>    }
>>>    #endif /* CONFIG_SPARSEMEM_VMEMMAP */
>>>
>>> diff --git a/include/linux/mm.h b/include/linux/mm.h
>>> index 15076261d0c2..5e005b0f947d 100644
>>> --- a/include/linux/mm.h
>>> +++ b/include/linux/mm.h
>>> @@ -4248,6 +4248,7 @@ void *vmemmap_alloc_block_buf(unsigned long size, int node,
>>>    void vmemmap_verify(pte_t *, int, unsigned long, unsigned long);
>>>    void vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>>>                     unsigned long addr, unsigned long next);
>>> +bool vmemmap_false_pmd(pmd_t *pmd, int node);
>>>    int vmemmap_check_pmd(pmd_t *pmd, int node,
>>>                      unsigned long addr, unsigned long next);
>>>    int vmemmap_populate_basepages(unsigned long start, unsigned long end,
>>> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
>>> index 37522d6cb398..bd54b8c6f56e 100644
>>> --- a/mm/sparse-vmemmap.c
>>> +++ b/mm/sparse-vmemmap.c
>>> @@ -407,6 +407,11 @@ void __weak __meminit vmemmap_set_pmd(pmd_t *pmd, void *p, int node,
>>>    {
>>>    }
>>>
>>> +bool __weak __meminit vmemmap_false_pmd(pmd_t *pmd, int node)
>>> +{
>>> +     return 0;
>>> +}
>>> +
>>
>> Reading that function I have absolutely no clue what this is supposed to
>> do. :)
>>
>> Also, why are you passing pmd+node when sparc ignores them completely
>> and statically returns "true" ?
> 
> The pmd+node is indeed unnecessary. My original intention was
> to provide convenience for future architecture extensions, but
> upon reflection, this appears to be a case of over-engineering.

Jup.

> 
>> If you can tell me what the semantics of that function should be, maybe
>> we can come up with a more descriptive name.
> 
> In the SPARC architecture, the original vmemmap_populate
> function does not retry with vmemmap_populate_basepages
> after vmemmap_alloc_block fails. I suspect SPARC doesn't
> support basepages, which is why we need to modify
> vmemmap_populate_hugepages to provide an interface that
> skips basepages handling.

So, something like vmemmap_pte_fallback_allowed() ?

-- 
Cheers

David

