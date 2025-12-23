Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E27C2E6B272
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 11:13:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C2A26B0005; Tue, 23 Dec 2025 06:13:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459606B0089; Tue, 23 Dec 2025 06:13:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 364F46B008A; Tue, 23 Dec 2025 06:13:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2340B6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 06:13:30 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B52BB139503
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:13:29 +0000 (UTC)
X-FDA: 84250474938.22.A960F0B
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf21.hostedemail.com (Postfix) with ESMTP id A4C571C0010
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 11:13:27 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eJTxNHGq;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766488408;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZhIVvsl+kpzgEGwl1JWdZa1JAIXGwZgZsmRbZEGTNGk=;
	b=Nhx+V9iCeaYx4l8ROEnJckf9URV2vH7eDsWpgH/LZ/7/zTu1kJNLqnNF+UEVD4GYqo34f/
	2QCycNbxEA1bV2ANQTqU4a+vln8SGk237TlYeycwz0mEpTKsTw0RMktmV2A9zna35mN0BG
	TfI4sqIYKBu7CNtHAFTVRqpNF5135Ac=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766488408; a=rsa-sha256;
	cv=none;
	b=ofbm4DWu0QTixm30tAkY5gJCAf+e2M1bBTAICIeburhC+Ldz/kklq8HOCb5pnEKPQdE6CM
	ckmN4eSwXiBnH9oqxTQ15Z32oX01L9DuK2dJZ7NkASDpvj9iit0cnnwkvbupNsKmjrHUcM
	yIwUsWiTxkQXNxQ8bBgRypkzE0p5vRA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=eJTxNHGq;
	spf=pass (imf21.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <5071efdf-8260-43dc-8042-69414b124009@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766488405;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZhIVvsl+kpzgEGwl1JWdZa1JAIXGwZgZsmRbZEGTNGk=;
	b=eJTxNHGqd0zgRdGACW7l9uVB91p+hd7jUu8xLNxdY88PLcL/Ox23THWP7GIWdP9wPpRiVK
	IVda/s6snYL6blU82ENpfx/RRVXo65APAzlVgxSQYOdkwWDF8iWlAwFHkvCuIIomaJcSI4
	dtkn2kjl8ImwtxZQD0hjSC52AQ7LQ94=
Date: Tue, 23 Dec 2025 19:13:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH RFC 2/3] x86/mm: implement redundant IPI elimination for
Content-Language: en-US
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, bp@alien8.de, dave.hansen@linux.intel.com,
 dev.jain@arm.com, hpa@zytor.com, jannh@google.com,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mingo@redhat.com,
 npache@redhat.com, npiggin@gmail.com, peterz@infradead.org,
 riel@surriel.com, ryan.roberts@arm.com, shy828301@gmail.com,
 tglx@linutronix.de, will@kernel.org, x86@kernel.org, ziy@nvidia.com,
 Lance Yang <ioworker0@gmail.com>
References: <c36501bc-2690-4ed2-b85e-13e64c41baaf@kernel.org>
 <20251222031919.41964-1-ioworker0@gmail.com>
 <ad5563b6-95d9-4f3a-9f6f-ad7afe72c846@kernel.org>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <ad5563b6-95d9-4f3a-9f6f-ad7afe72c846@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: 57weyffezai76xrg7bh3msszd9gapomq
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A4C571C0010
X-Rspam-User: 
X-HE-Tag: 1766488407-50506
X-HE-Meta: U2FsdGVkX1914wGZn6iDgtSBSCaYXqdluorfSAEjNeHD1SVEMhB5E/wIwWC3PUztV1FgMRF7/QHzDK0/6Onm4N5x8Lo7njlOIijDXzZ8g60N4sUrJd3MZySkcyriia3NBQHRhb3DTWBszoH1w2BBqxHbEdPoCVrgTVRv84nFkMFKk0MFch0yak17n1+7G0xORs6bCHjMEoTeuLcu16pcuXjNNAewcCRHsOWIWRjn7QRitpwm2hN9jxUmkFvjSujyBs9r0Bh64N7aNSPqQjTZLlGIitJ6mytjtPZokNZoXNMt62QEWjuQTbJU9cSPd44YeS1h2Kn3vqYWO4eskhvSSLJD9ZD1ni/UrqIYLh1tDF2q7vdg/ZgOsxlilNPBU7ET62u7y4w6D9w1IXq6xLX5AeR1K2wiMrDGoyakzpTB3fmrUQyFG4QJQ3u/lLgQ9s3MP7stLABPWXQKFr/ZKlK1UnQrNJz95/S2jhzs9Z9NIW8vNCaRzd/ugHmB2jRyPXSwH0UUnmAymsJ+MBNaAM0eV+n/wyMevGjLbGBL1n79oscMaBRonVRmuD4aO7b2zn2xDHZ3hCmlnYcdI8zzvbBSMAKHU13NnkDo8W6VAuvlwZXwi7qt/VMxsR16vT9MlvWGATKc10YdQAePRFm/p+5gpTlffXKjMnqZvVI9L0jmvDIeMMASWc0USXHVvrE0VtWh33QTU4Ebe13Lv142Ie+J55fv90bqznZbPNZ0wcYSKVpEFwX6kwEUdxdrkgMEETIUH/vamu3IGqWTGNdRug8fViUhngUL3aGV4FEPrgiqlq1fEj4xIyrOYaoONOdA3CR/F4YETfXXJSbBoZj9niN2i9q0JRURCNK7a8BDjLQQ8KVx7WDtquVc6hHFzDjLjdmKzK60xHDQhsHeuX73M6+ImvEBGeXL5t+sMnKK+LYkFKamAE8zuKrZf3/6wnZtPRtmMwvs2yzX0qNlkg5QFa3
 a7OjOCCm
 GcEqMV+n8CuV9wTOTB545cwH3HuFT14Le1EedtlNpWFWbZsnRBYl7oIQu+JezVqSVi2JdobFv9rWCMBdtPW+lXLZqt+uCp0HvoMXkbK2IypnstwsqFq9QEpamLDdQ3hffU4C8wq1flSCDfXOmZFa7EnBxrxOt+mbDXedNaEOPu7QnYbVMu8Lz29dGWUIhMPP2OT0kFo7STkg2m6OvvxQFYNdIKZZpyqtXRaDi8tcKlPJtfubc8TP+jv1mf2fYqU9T2fNXSNg36zFGo6BGkgofpAXpouFArL3/crTRny14EkQrjpY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/12/23 17:44, David Hildenbrand (Red Hat) wrote:
> On 12/22/25 04:19, Lance Yang wrote:
>> From: Lance Yang <lance.yang@linux.dev>
>>
>>
>> On Thu, 18 Dec 2025 14:08:07 +0100, David Hildenbrand (Red Hat) wrote:
>>> On 12/13/25 09:00, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> Pass both freed_tables and unshared_tables to flush_tlb_mm_range() to
>>>> ensure lazy-TLB CPUs receive IPIs and flush their paging-structure 
>>>> caches:
>>>>
>>>>     flush_tlb_mm_range(..., freed_tables || unshared_tables);
>>>>
>>>> Implement tlb_table_flush_implies_ipi_broadcast() for x86: on native 
>>>> x86
>>>> without paravirt or INVLPGB, the TLB flush IPI already provides 
>>>> necessary
>>>> synchronization, allowing the second IPI to be skipped. For paravirt 
>>>> with
>>>> non-native flush_tlb_multi and for INVLPGB, conservatively keep both 
>>>> IPIs.
>>>>
>>>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>>>    arch/x86/include/asm/tlb.h | 17 ++++++++++++++++-
>>>>    1 file changed, 16 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
>>>> index 866ea78ba156..96602b7b7210 100644
>>>> --- a/arch/x86/include/asm/tlb.h
>>>> +++ b/arch/x86/include/asm/tlb.h
>>>> @@ -5,10 +5,24 @@
>>>>    #define tlb_flush tlb_flush
>>>>    static inline void tlb_flush(struct mmu_gather *tlb);
>>>> +#define tlb_table_flush_implies_ipi_broadcast 
>>>> tlb_table_flush_implies_ipi_broadcast
>>>> +static inline bool tlb_table_flush_implies_ipi_broadcast(void);
>>>> +
>>>>    #include <asm-generic/tlb.h>
>>>>    #include <linux/kernel.h>
>>>>    #include <vdso/bits.h>
>>>>    #include <vdso/page.h>
>>>> +#include <asm/paravirt.h>
>>>> +
>>>> +static inline bool tlb_table_flush_implies_ipi_broadcast(void)
>>>> +{
>>>> +#ifdef CONFIG_PARAVIRT
>>>> +    /* Paravirt may use hypercalls that don't send real IPIs. */
>>>> +    if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
>>>> +        return false;
>>>> +#endif
>>>> +    return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
>>>
>>> Right, here I was wondering whether we should have a new pv_ops callback
>>> to indicate that instead.
>>>
>>> pv_ops.mmu.tlb_table_flush_implies_ipi_broadcast()
>>>
>>> Or a simple boolean property that pv init code properly sets.
>>
>> Cool!
>>
>>>
>>> Something for x86 folks to give suggestions for. :)
>>
>> I prefer to use a boolean property instead of comparing function 
>> pointers.
>> Something like this:
>>
>> ----8<----
>> diff --git a/arch/x86/hyperv/mmu.c b/arch/x86/hyperv/mmu.c
>> index cfcb60468b01..90e9da33f2c7 100644
>> --- a/arch/x86/hyperv/mmu.c
>> +++ b/arch/x86/hyperv/mmu.c
>> @@ -243,4 +243,5 @@ void hyperv_setup_mmu_ops(void)
>>
>>       pr_info("Using hypercall for remote TLB flush\n");
>>       pv_ops.mmu.flush_tlb_multi = hyperv_flush_tlb_multi;
>> +    pv_ops.mmu.tlb_flush_implies_ipi_broadcast = false;
>>   }
>> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/ 
>> asm/paravirt_types.h
>> index 3502939415ad..f9756df6f3f6 100644
>> --- a/arch/x86/include/asm/paravirt_types.h
>> +++ b/arch/x86/include/asm/paravirt_types.h
>> @@ -133,6 +133,19 @@ struct pv_mmu_ops {
>>       void (*flush_tlb_multi)(const struct cpumask *cpus,
>>                   const struct flush_tlb_info *info);
>>
>> +    /*
>> +     * Indicates whether TLB flush IPIs provide sufficient 
>> synchronization
>> +     * for GUP-fast when freeing or unsharing page tables.
>> +     *
>> +     * Set to true only when the TLB flush guarantees:
>> +     * - IPIs reach all CPUs with potentially stale paging-structure 
>> caches
>> +     * - Synchronization with IRQ-disabled code like GUP-fast
>> +     *
>> +     * Paravirt implementations that use hypercalls (which may not send
>> +     * real IPIs) should set this to false.
>> +     */
>> +    bool tlb_flush_implies_ipi_broadcast;
>> +
>>       /* Hook for intercepting the destruction of an mm_struct. */
>>       void (*exit_mmap)(struct mm_struct *mm);
>>       void (*notify_page_enc_status_changed)(unsigned long pfn, int 
>> npages, bool enc);
>> diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
>> index 96602b7b7210..9d20ad4786cc 100644
>> --- a/arch/x86/include/asm/tlb.h
>> +++ b/arch/x86/include/asm/tlb.h
>> @@ -18,7 +18,7 @@ static inline bool 
>> tlb_table_flush_implies_ipi_broadcast(void)
>>   {
>>   #ifdef CONFIG_PARAVIRT
>>       /* Paravirt may use hypercalls that don't send real IPIs. */
>> -    if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
>> +    if (!pv_ops.mmu.tlb_flush_implies_ipi_broadcast)
>>           return false;
>>   #endif
>>       return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
> 
> I'd have thought that the X86_FEATURE_INVLPGB heck should then also be 
> taken care of by whoever sets tlb_flush_implies_ipi_broadcast.

Makes sense!

Let's have the INVLPGB check happen at setup time, not at use time :P

Cheers,
Lance

