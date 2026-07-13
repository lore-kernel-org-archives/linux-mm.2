Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D319C43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 07:03:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 77EAA6B0088; Mon, 13 Jul 2026 03:03:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72FDE6B008C; Mon, 13 Jul 2026 03:03:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6455C6B0092; Mon, 13 Jul 2026 03:03:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 3F9F36B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 03:03:17 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD56C120ADE
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:03:16 +0000 (UTC)
X-FDA: 84982861992.06.9AD12E1
Received: from cstnet.cn (smtp81.cstnet.cn [159.226.251.81])
	by imf13.hostedemail.com (Postfix) with ESMTP id CBC0120005
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 07:03:13 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	spf=pass (imf13.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783926195;
	b=Ul0VysOXYrKtYot5K1TNJjranYBLfRyeeD41L/o1OFvIQTetTBEQxrsQsTHLCZwxbo5pEf
	gWBUr+0raSQhBCHmMlzZWMiDgItP1E77Oqba89BUsDib0Rt46V+hRY5CaFyHd9xQA58Abp
	qEtAFNPgJUwk/0HU+rtxL7hUvADhIL4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	spf=pass (imf13.hostedemail.com: domain of wangruikang@iscas.ac.cn designates 159.226.251.81 as permitted sender) smtp.mailfrom=wangruikang@iscas.ac.cn;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783926195;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=m+MYmCSgDEUh9DJ/ZvioBGl2NNSaKnEgT4DSO+Eu6Mw=;
	b=MkWUu+wGPV7jJpwNtkTy6QvgL7L6w2sSmRhhYpEEIufw5jFdYIq0kukxQFup15XuKdvr3V
	gvKsk2mKp/QqNom/A9vysrMsz1LWQgHCBua5BOrtHx4mCCIfqRpTT6w9wNZ1EWhzEixnyZ
	5+VUzABN+/uuw1Ly5YNNCKgi1OovqWw=
Received: from [10.213.6.115] (unknown [36.110.52.2])
	by APP-03 (Coremail) with SMTP id rQCowAAHF86rjVRqPpeSFw--.30299S2;
	Mon, 13 Jul 2026 15:03:07 +0800 (CST)
Message-ID: <7bcc6988-f225-44fb-b616-a3ca12632187@iscas.ac.cn>
Date: Mon, 13 Jul 2026 15:03:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/2] mm/sparse-vmemmap: flush_cache_vmap() after
 hotplugging vmemmap
To: Muchun Song <muchun.song@linux.dev>
Cc: Alexandre Ghiti <alex@ghiti.fr>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>, Mike Rapoport <rppt@kernel.org>,
 Palmer Dabbelt <palmer@dabbelt.com>, Paul Walmsley <pjw@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-riscv@lists.infradead.org
References: <20260713-mark-after-vmemmap-populate-v6-0-b945ceba29d4@iscas.ac.cn>
 <20260713-mark-after-vmemmap-populate-v6-2-b945ceba29d4@iscas.ac.cn>
 <E058B2BD-768A-4949-B5F3-7CBAC1347410@linux.dev>
Content-Language: en-US
From: Vivian Wang <wangruikang@iscas.ac.cn>
In-Reply-To: <E058B2BD-768A-4949-B5F3-7CBAC1347410@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-CM-TRANSID:rQCowAAHF86rjVRqPpeSFw--.30299S2
X-Coremail-Antispam: 1UD129KBjvJXoW7Cw1rWF48Cr47tFy8ur4kJFb_yoW8ZFyxpr
	Z3C3WqkF4kJr45Aw4UZw1I9FZa9w43Kay8JFsYvr1j93s8Xr12gryakan29a48u3s5Ca42
	k3yY93s5WFyDAFJanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUvlb7Iv0xC_Kw4lb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I2
	0VC2zVCF04k26cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rw
	A2F7IY1VAKz4vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xII
	jxv20xvEc7CjxVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVWxJr0_GcWl84ACjcxK6I
	8E87Iv6xkF7I0E14v26rxl6s0DM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI
	64kE6c02F40Ex7xfMcIj6xIIjxv20xvE14v26r126r1DMcIj6I8E87Iv67AKxVW8Jr0_Cr
	1UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xK
	xwCY1x0262kKe7AKxVWUtVW8ZwCF04k20xvY0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJV
	W8JwC20s026c02F40E14v26r1j6r18MI8I3I0E7480Y4vE14v26r106r1rMI8E67AF67kF
	1VAFwI0_Jw0_GFylIxkGc2Ij64vIr41lIxAIcVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6x
	IIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcVCF04k26cxKx2IYs7xG6r1j6r1xMIIF0xvE
	x4A2jsIE14v26r1j6r4UMIIF0xvEx4A2jsIEc7CjxVAFwI0_Gr0_Gr1UYxBIdaVFxhVjvj
	DU0xZFpf9x07bnXd8UUUUU=
X-Originating-IP: [36.110.52.2]
X-CM-SenderInfo: pzdqw2pxlnt03j6l2u1dvotugofq/
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CBC0120005
X-Stat-Signature: tm8kng81gp44qek5ht9y88i8p7cp7kxm
X-HE-Tag: 1783926193-944459
X-HE-Meta: U2FsdGVkX1+IbxmgJeYspebB5fVRrU7vgzjPq7ELEBqiwL01IXz5yhQkFkt4aHrvb9yczXFCxNBn+raDxZce6IPuNI92X31cEF0VfyaHShoktj0RdOS19ZAo5acQ8hRZJiwPgkEWwiiD/V7O3kBKH19G8cSpkQE9O1qCerfYDFOvMiNtarSqjmzX7AlE/pzUOj9acrRSCy3tBorzCKwyjX2+0daIxEblx9H9DhOX33/ntV+26C01QF8B3/4fcXlUx6JrjwuxYVCRyxa9YwLrdaz8EtwhQ6ZP3Dg5AYzA9CxLTeLjHKcDrASAPGJm0xLXqeHFWMTG5xi5n14RYDYNxv8KtEk5h9mB4r0SXSgjj2mBUiXrxuEyvB0RU71AKxI8UV/uh812hL4efrmCetm0yys8hsm/HP8pcyD1s7wZu93C5F0IfqR46xJ0HjyjacSFlb/VhRlFxuOhKeazERm2rhVPxuA+7oC+L4jCgvgRCMnx4WiPP9GKkMtaWvieYlMJXMOFszgwK4VaUmdOBBCtsmD+/sr0xdV5PiQss59chX3bKLrmO9c/5gkqjeo8iLkF4XwtyB3ITYH1nVYU6O8pDXPqVZoAjfa1s/cmWWGY+u+LBBe69J3aiV2bANHSVETMZGlDIjXSQYLIIFbUKw70OtVMFXht1gyttDBTqPtY/kEYbnhUQ1PYzmnLBGWxjhSgZ4x/0D2CiCjUoKvbi+Q5L38SV9p2arritLslVwx4xxvNzfMeaFSFvPvleF3vlzotW9yciUqbpdcOGPOkmIas9sD6niCrobWhJtTZDJA/B3bLqjksGwIxxcDV2gKueQjo2kTB5FDV9Ppdw84eSjuGWo4ahIgpoEYJ+d0mVI/hD7K3iib2ssrO8n4Sl4igJ9VGqetORqzoX25UblulKOZnyj0yGQ/OjXaL0I0B8gtWGTjTP0+w3tbrIPM7zY1CFFdLjOboAR/a1vQWkfd3m9C
 lqxjuszb
 qwYth00zw3Oj4Gy8MhP+xvgMWc2yP/L3o4vUpSTcT0FuwKl3J4orNNtbZsQB+EjmDwTEfsx6glG5IJjr6W3zTKbzq2FzPaNmkzAPpGm33JW5tGrIKMcFka7MBp05aefFx0W69jp+RLsSyqCG7GqMhSqkQiaat2Pzv0CrSJmSUGu0JHAIcGV7z5Ys0OKLMBPwqVZthXxrMSBHR0Bn7CnpwDQQueo2CJnt7Pk9cR7wsVAt7LYOlH3anWLbwtLF3hs4GIjNC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 7/13/26 14:56, Muchun Song wrote:
>
>> On Jul 13, 2026, at 14:15, Vivian Wang <wangruikang@iscas.ac.cn> wrote:
>>
>> section_activate() does not flush TLB after populating new vmemmap
>> pages. On most architectures, this is okay. However it is a problem on
>> RISC-V since there the TLB caching non-present entries is permitted,
>> which causes spurious faults on some hardwares.
>>
>> This seems to be most easily reproduced with DEBUG_VM=y and
>> PAGE_POISONING=y, which causes these newly mapped struct pages to be
>> poisoned i.e. written to immediately after mapping.
>>
>> Extend the RISC-V flush_cache_vmap() to also handle the vmemmap range,
>> and call it after hotplugging vmemmap, which gets the possible spurious
>> fault handled in the exception handler.
>>
>> At least for now, the only other architecture with both
>> SPARSEMEM_VMEMMAP and flush_cache_vmap() is PowerPC, which has a similar
>> problem with newly valid PTEs. But there flush_cache_vmap() is just a
> PowerPC is actually unaffected here since it achieves the desired effect
> via vmemmap_set_pmd. However, your patch will pave the way for a great
> cleanup to remove PowerPC's architectural vmemmap_set_pmd, given that it
> already relies on flush_cache_vmap() for the required barrier operations.

I agree. I was just talking about PowerPC in general, which requires a
ptesync after "newly valid PTEs". In this sense, PowerPC in general is
affected.

>> ptesync. So it should be safe to do this for generic code while having
>> minimal performance impact.
> After the cleanup for the PowerPC, it will emit only once ptesync operation,
> so it will be a minor performance improvement.

I haven't mentioned the future cleanup because, well, future. Otherwise
I agree on this as well.

>> Suggested-by: Muchun Song <muchun.song@linux.dev>
>> Signed-off-by: Vivian Wang <wangruikang@iscas.ac.cn>
> Reviewed-by: Muchun Song <muchun.song@linux.dev>

Thanks for your review.

Vivian "dramforever" Wang


