Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16003105A587
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 11:24:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4598F6B0088; Thu, 12 Mar 2026 07:24:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4072F6B0089; Thu, 12 Mar 2026 07:24:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 313076B008A; Thu, 12 Mar 2026 07:24:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F2146B0088
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 07:24:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A45A4B669F
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:24:02 +0000 (UTC)
X-FDA: 84537176724.09.B515DC7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id B3C10120003
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 11:24:00 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gddxThvu;
	spf=pass (imf29.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773314640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lHgPc4c+EM1wDk0QatI4ONB6TYrHc3Tzig8f9b6Zjag=;
	b=4fLLY3aJhmBMssKun3jERqH6MGuNLoH5J37Q/zEwUE+snJMMUtHvithTtkRxIYFSlmSjvl
	Cd8Yu49zzIz4XlG5Y2AoVVNAfoDQGhQTYu7JTTgbn5lW1I+GUYQIcsEtzCg3YhKYN9YwFL
	wEipJHdevXtBcpOLd3Eg09xtSR9wPsw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=gddxThvu;
	spf=pass (imf29.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773314640; a=rsa-sha256;
	cv=none;
	b=2Me6Kpoz95LeSyRp0+oKkGhSxcr89PhPHVJ9C7uIqq8+OZZLG7ngsSnhbxy1oF4JIC9I52
	lHMJfkyzR8bV+xXcIXVsYe9WIsCtcMikgtf2mY28OHybErVyBuGLLFYRJJM+Ia4fRRA7M6
	97eGp+yJpN0KyGLK0OMcXbAIvByDTio=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 88FA9403C8;
	Thu, 12 Mar 2026 11:23:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C32B8C4CEF7;
	Thu, 12 Mar 2026 11:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773314639;
	bh=QmUndoWKkvGu15ytPgiNk/W/zfIzuga6NPM0kq37X6g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=gddxThvuN8nEkxb1oe2xYVqYBPcAGoZjE0JamctgWmvcBJC+2RXK4H1Oaf+f3JOwW
	 fxwH+WLkxZbJY0MknBkur5pI7FCchUtXNdDKsThu5lMuoBANKs+UeoyfTMkJ1sO3+r
	 4hpyJwTo29UlAt3cBAFFMBFuxc1orHcop3iw89T3rJ87yz2VKPaAXnDxEi2c/fTd87
	 eJ/zbtp6tA8W/XODS6RYQsmWksPaTPRpOv5PRjQnkFFww5eYDtX/ErhgfeDObPX20h
	 SEdGEgkqgOZOHOJQuURbLLXig62kg6JD5Fx4CH2RFeTqabIPhh1ARDfQqZ3yTDKMjS
	 /FQjMq5HRAp3w==
Message-ID: <0bc30137-3f1d-4a4a-8573-8f26866fcc26@kernel.org>
Date: Thu, 12 Mar 2026 12:23:50 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5 09/15] arch/powerpc: don't initialize kasan if it's
 disabled
To: Sourabh Jain <sourabhjain@linux.ibm.com>, Baoquan He <bhe@redhat.com>,
 kasan-dev@googlegroups.com
Cc: linux-mm@kvack.org, andreyknvl@gmail.com, ryabinin.a.a@gmail.com,
 glider@google.com, dvyukov@google.com, linux-kernel@vger.kernel.org,
 linux-um@lists.infradead.org, linux-arm-kernel@lists.infradead.org,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, x86@kernel.org, chris@zankel.net,
 jcmvbkbc@gmail.com, linux-s390@vger.kernel.org, hca@linux.ibm.com
References: <20260225081412.76502-1-bhe@redhat.com>
 <20260225081412.76502-10-bhe@redhat.com>
 <71921cca-b890-41c4-93e9-957d3f647ffa@linux.ibm.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <71921cca-b890-41c4-93e9-957d3f647ffa@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 8ipo3q3ppeycoa9wyyts66nnmbaowjfy
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: B3C10120003
X-HE-Tag: 1773314640-688648
X-HE-Meta: U2FsdGVkX1/cyqE0LrAPVNRubhx/HAYqABMTRQVVuvt8cMwibRbKicmWg1KzY7cg7Ytpk3Ko2KhODz7lpMyfCThwikpDFkou9mEZDkUouxmxEKFDHPz27cxUmQbbTo2SX623l0ps8aIy2GBmCV4OMYjArRvAL7WGsq0mZnuoX6M5QW1hLqa5RHqbTTGHjoIO0vSG6cCbYjCMC+4m1UW7MXESM5Priasd2JqfphkSuoDRSAAs3d+yH+/GIbTccIuQuIqghRcnUKgypB0//l1vC9IuiH09A3Z2LpY1MjgId58zrplR4BUZONCOj8G9j051Tr6t5K1eKCbWKm+WaPLZsnXLLGN79qOz8sOINIJhzg+dJhFg1VhWl2Q+jIFsG1UNFD0YxKKWgYEArcpz+26HjKiA+X9NbjFFRK1tTsUJ4JnXmMIoKzJvUHrgySbK/4Mqbkj6DIvthG2frs2EpFGZ89hjG86LGdvpqnUQu/Ar4zHt4wIalhoPa7iQVcLnU0xCPTrgajHgZ4ECAmjs50em9vffMx9JE7+u6nMBr1AetEZ86RBZA5C8mrXcK1EOZdvbhu0Uj5n+8LHM+t2jiSDdMWa9i/ZbJ25+cYswm5frMyM3QUnzb+RBQy+2SNd7g6OmYrQsY1lAQujsymdP1pklje0faSYPkf5sm9wRUZB7FjiDbukrc80bu+RvxRbJIMB1G9ol02RxVjnZLqID+UAoeZRgIMZ5XLSqTWhwdP4DTWumhcytX/nRgzkd6+t0S1o3qhBt0an594kqRDyVdwszZSMdTfW9kb2m6grI7JVrE8KBN44OLoSftGSUK3P1+hFp5UuHGAJmb++2BcmFCvMXih9y4OxqRieSqbw/yd/wH2/LRHaouRtghlxbbyt9XKZFnLIn8cyKlBoW6upRbX2xP4upZ+QFC0LUMXBPF1eIYBzGu/alyGIzf+RjgoWUkD0t50TIF+oAaN3SQGOy0Pn
 m9XGgsHy
 0gePjzdEIVV8Pka9ByuMxhhIlJ/O5WWblqGOKYQUNfWBMdc4tOvGppolkLilxc62ZGxY98aATEE6ineIuR1wQIvQ9fUzj/SzJg3Rcos7Pi8j70XWchIPprXYZwNh/KK2GdfQQ9XCeiqyX/VmTfsSEnbDldvQsAYb/XmAieIsantdTtSFbSJnQBluvLeEYKTJPgFGXb76XZj+35TsN4bWpd2pdKKRGUZavb33x2mWM5deopLUOq8DDtcZ9MWp4JdbAfai60YcFP2qaq49R8iNgloF/sLznN4YaLdFUmUba5uXpc2/kItnuU/FlGN0ZMBwtLeREb26/NFRKjApqJnfukPp5zADjr/j9qLrvMd15nF1DNfOXjeX+HF+irhrcOXZiiZCVfBdmrmM03O0ZDdRg73OUuvTj5ASsHRBh7dHeDCBaMET3bscp8SQV3tTdbgRcbtkcEjGVe45HOpM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 12/03/2026 à 12:12, Sourabh Jain a écrit :
> 
> 
> On 25/02/26 13:44, Baoquan He wrote:
>> Here, kasan is disabled if specified 'kasan=off' in kernel cmdline.
>>
>> This includes 32bit, book3s/64 and book3e/64.
>>
>> Signed-off-by: Baoquan He <bhe@redhat.com>
>> Cc: linuxppc-dev@lists.ozlabs.org
>> ---
>>   arch/powerpc/mm/kasan/init_32.c        | 6 +++++-
>>   arch/powerpc/mm/kasan/init_book3e_64.c | 4 ++++
>>   arch/powerpc/mm/kasan/init_book3s_64.c | 4 ++++
>>   3 files changed, 13 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/powerpc/mm/kasan/init_32.c b/arch/powerpc/mm/kasan/ 
>> init_32.c
>> index 1d083597464f..0ea2a636c992 100644
>> --- a/arch/powerpc/mm/kasan/init_32.c
>> +++ b/arch/powerpc/mm/kasan/init_32.c
>> @@ -141,6 +141,10 @@ void __init kasan_init(void)
>>       u64 i;
>>       int ret;
>> +    /* If KASAN is disabled via command line, don't initialize it. */
>> +    if (kasan_arg_disabled)
>> +        return;
>> +
>>       for_each_mem_range(i, &base, &end) {
>>           phys_addr_t top = min(end, total_lowmem);
>> @@ -170,7 +174,7 @@ void __init kasan_init(void)
>>   void __init kasan_late_init(void)
>>   {
>> -    if (IS_ENABLED(CONFIG_KASAN_VMALLOC))
>> +    if (IS_ENABLED(CONFIG_KASAN_VMALLOC) && kasan_enabled())
>>           kasan_unmap_early_shadow_vmalloc();
>>   }
>> diff --git a/arch/powerpc/mm/kasan/init_book3e_64.c b/arch/powerpc/mm/ 
>> kasan/init_book3e_64.c
>> index 0d3a73d6d4b0..fbe4c9a7e460 100644
>> --- a/arch/powerpc/mm/kasan/init_book3e_64.c
>> +++ b/arch/powerpc/mm/kasan/init_book3e_64.c
>> @@ -111,6 +111,10 @@ void __init kasan_init(void)
>>       u64 i;
>>       pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page), 
>> PAGE_KERNEL_RO);
>> +    /* If KASAN is disabled via command line, don't initialize it. */
>> +    if (kasan_arg_disabled)
>> +        return;
>> +
>>       for_each_mem_range(i, &start, &end)
>>           kasan_init_phys_region(phys_to_virt(start), phys_to_virt(end));
>> diff --git a/arch/powerpc/mm/kasan/init_book3s_64.c b/arch/powerpc/mm/ 
>> kasan/init_book3s_64.c
>> index dcafa641804c..f7906f9ef9be 100644
>> --- a/arch/powerpc/mm/kasan/init_book3s_64.c
>> +++ b/arch/powerpc/mm/kasan/init_book3s_64.c
>> @@ -54,6 +54,10 @@ void __init kasan_init(void)
>>       u64 i;
>>       pte_t zero_pte = pfn_pte(virt_to_pfn(kasan_early_shadow_page), 
>> PAGE_KERNEL);
>> +    /* If KASAN is disabled via command line, don't initialize it. */
>> +    if (kasan_arg_disabled)
>> +        return;
>> +
>>       if (!early_radix_enabled()) {
>>           pr_warn("KASAN not enabled as it requires radix!");
>>           return;
> 
> Should we log in the kernel log buffer that KASAN is disabled?
> 
> Right now, I don't see the kernel advertising the same.

When KASAN is enabled it is advertised with:

	pr_info("KernelAddressSanitizer initialized (generic)\n");

Isn't the absence of that message enough to understand KASAN is not there ?

> 
> $ dmesg | grep -i kasan
> [    0.000000] Kernel command line: BOOT_IMAGE=(ieee1275//vdevice/v- 
> scsi@30000070/disk@8100000000000000,msdos2)/vmlinuz-7.0.0-rc3+ 
> crashkernel=2G kasan=off
> 
> Tested this series on powerpc Pseries platform.
> So feel free to add:
> Tested-by: Sourabh Jain <sourabhjain@linux.ibm.com>
> 
> - Sourabh Jain
> 


