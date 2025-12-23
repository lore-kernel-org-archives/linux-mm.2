Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90533E6F07A
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 09:45:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1A16B0005; Tue, 23 Dec 2025 04:45:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9BDE6B0089; Tue, 23 Dec 2025 04:45:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BAB556B008A; Tue, 23 Dec 2025 04:45:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id A86AF6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 04:45:00 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 412AD601BD
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:45:00 +0000 (UTC)
X-FDA: 84250251960.04.FD50405
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 831C24000B
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 09:44:58 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AwA5kqsw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766483098; a=rsa-sha256;
	cv=none;
	b=0dok+1agmyYUPU1HY5unKrJBIhOYSjP73hOsjlUOhc1GryaqFfin5oxciuo3sJuofb+12c
	qQmrba4HA9eZHF6X3mA0KYxispj++7sDSi1Mbd9aDO7LeGtajaMSv08V1h0ymLamoc4U9z
	agU/NI0Uj35v8fyuiLfFlfCOSTTwk/0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AwA5kqsw;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766483098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Js0wh5XC0gwQ5jZ1IZMKv70ZCWi3Flr8pugFkjPiRXs=;
	b=zuC8ZRzWwnQGtuXodxgIq/fDA6Wnw7/xqhf7vIWWQFTXFSM5e6dei63iihIsosJv/xMKPm
	Sk3CdV7XdvQzmG/dBde9KzkvhjIKUO4DnSFznfIskSQzaUjh7yoWPfP+f9T6GR7BMatxdN
	Mg3/zwpZ4LcgertfUyKijJwiiHq9OTI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DDEC160127;
	Tue, 23 Dec 2025 09:44:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65C9FC113D0;
	Tue, 23 Dec 2025 09:44:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766483097;
	bh=DCGhrQ/izT9mabKQhH7gNwx60UXdw1uGRsNl/jg6EzY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AwA5kqswS1v5X8LqqfpFgKT8CCyS3xLHd7JBBoyPxe53ML3idLKJLlwJG1ayGtw8K
	 hwJ9G0GuLM4yAzdCLZB2S9PWTDoI+U5ka4QpmzFt80rh+alnf9mzG46Yyvul7qUjEf
	 KeyxXhWKlvWp8aQPE+dfe05Meh16/DOPQM6SPsnDuQuJimb+g0Wx0RCMEtNvM5AAdx
	 BQ3Duc28hOSoCqkqtcsso8M8r4X7BgUL2C6uhaqpBqqXIH0gqX188uQp1NUFc/ZOo+
	 ZJqX0e2N97kFmNhUcVVhDBhPuqiU9jsXs4KX3WauHVYfjVB1b4VpMR7uOvOPSm5FJi
	 y5WI/x9oKINjA==
Message-ID: <ad5563b6-95d9-4f3a-9f6f-ad7afe72c846@kernel.org>
Date: Tue, 23 Dec 2025 10:44:48 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 2/3] x86/mm: implement redundant IPI elimination for
To: Lance Yang <ioworker0@gmail.com>
Cc: Liam.Howlett@oracle.com, akpm@linux-foundation.org,
 aneesh.kumar@kernel.org, arnd@arndb.de, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, bp@alien8.de, dave.hansen@linux.intel.com,
 dev.jain@arm.com, hpa@zytor.com, jannh@google.com, lance.yang@linux.dev,
 linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, lorenzo.stoakes@oracle.com, mingo@redhat.com,
 npache@redhat.com, npiggin@gmail.com, peterz@infradead.org,
 riel@surriel.com, ryan.roberts@arm.com, shy828301@gmail.com,
 tglx@linutronix.de, will@kernel.org, x86@kernel.org, ziy@nvidia.com
References: <c36501bc-2690-4ed2-b85e-13e64c41baaf@kernel.org>
 <20251222031919.41964-1-ioworker0@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251222031919.41964-1-ioworker0@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 831C24000B
X-Stat-Signature: 51zxngstyj7uug96cazd5jwtjz3z4qyw
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1766483098-778796
X-HE-Meta: U2FsdGVkX1/u/yqn/Ki/LO3FhOufMtLQCx841hAoaThA3ea5sUV3ujBhHWxY9290I6KN30k1g4Mi/CaSFonKoS9f0vddDlVcznVyLk/LlETA0NwuDRaBkKmFmXLPFKlnFxgigeMJ8Ycj8ljVA4kgyVtm+/j6WM0Tp/4iMsqWb88n4endv6gvnVKhD1mL8XekfS9GtQyDUlSOQajMjVC3a329iWEUSkVND2MQnpLII3Jze0sYjXLx62DKcXwjb+td4Wlng5JkGuP7uPP4YhR3byfPsz5NNMP0bQkGRddOBN8UU/pVou520Zt3sCi7LsYcPDUpi2yZdIwzF887IUaHvgyPhhQkMmqVGpqFo86+EhEyjxPuR4y4+m4WpKbACKA4yjalHmmNfu1sJwS49PzgpJRy6R7sVT4L7PROWbaO7NGvkWRZ4IpxcbJJU2xzXAbPDhe0yc9xF2d7srR8butQzcumKfu3eY5Yu7DmH7tzMBAxdppoPBdVawzp7bXlAwS8x1Jv+bIPfIoAwT270hsVub5CNZkTGiWCXw3KvYIpZX5e7iQAImI3f4/dOYeCo67OaJ3XYJY3oKLHJWSYSEiDe1R+V/KpK5q/ofWftQMGfXiHP5cBv02onzSDUucA3vLA4c48yQV+Ip+08HwlGs3jm6ogI0Ue324nrObsNdRXl2K6Fn/Rq7nDutPJnq5VV2QugHkvRCZM0RS1IklBv3I4+/igUtwiplVRcIlZsTzt9GhesTCCPqu3WhsmNB4ps/Ts+kRQ1VArAsM7vyEt6nZiYhb+/KF4S63JQ44Kwlnqb2ERlGz/Tsq7oZqRGAkTGF/zTww9lp1mHiTzkMn0HB22ryCRq+l1J0MCexDyABzmGLXV/P5aenT77R0AYcjcYrNuh3gESSLvbf3/PLNVMfbfsTjBmBPU25HihnCkvd9g3rmDNPD3SnD+bj0HY+4DvcoAojBss/EA+SH2BaFXG90
 TaWvc5/7
 6U+Lh6N/NaQbHtscj3urIeV+TvkKYUx3odCie9hbJ2WnDKXtBMd5nNoxXJT33g8H+9ISGW5Hk3Xxo6zHllbh9K2WmRR6pAVd6zQAzf53fR12Iaj6X81/x7AEdQzvVG952UsM/5wUsQROQpkkSpp58k63vmDJW8rmr2C+wRjkYPb5L2yNLBmFeH1vr264s6KOsVDD0bDIt86oU04VHNqxuYkuZzlqnPrwfai3ConaJyRwLQW2rzFFbAukca8dcQ4KecaJg8PautWfn7hQFOjtX11zbSHdi/XUh72LeP6O5MAYxQDFcgbLGSSqbQXHBfamdKR8O
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/22/25 04:19, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> 
> On Thu, 18 Dec 2025 14:08:07 +0100, David Hildenbrand (Red Hat) wrote:
>> On 12/13/25 09:00, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> Pass both freed_tables and unshared_tables to flush_tlb_mm_range() to
>>> ensure lazy-TLB CPUs receive IPIs and flush their paging-structure caches:
>>>
>>> 	flush_tlb_mm_range(..., freed_tables || unshared_tables);
>>>
>>> Implement tlb_table_flush_implies_ipi_broadcast() for x86: on native x86
>>> without paravirt or INVLPGB, the TLB flush IPI already provides necessary
>>> synchronization, allowing the second IPI to be skipped. For paravirt with
>>> non-native flush_tlb_multi and for INVLPGB, conservatively keep both IPIs.
>>>
>>> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>> ---
>>>    arch/x86/include/asm/tlb.h | 17 ++++++++++++++++-
>>>    1 file changed, 16 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
>>> index 866ea78ba156..96602b7b7210 100644
>>> --- a/arch/x86/include/asm/tlb.h
>>> +++ b/arch/x86/include/asm/tlb.h
>>> @@ -5,10 +5,24 @@
>>>    #define tlb_flush tlb_flush
>>>    static inline void tlb_flush(struct mmu_gather *tlb);
>>>    
>>> +#define tlb_table_flush_implies_ipi_broadcast tlb_table_flush_implies_ipi_broadcast
>>> +static inline bool tlb_table_flush_implies_ipi_broadcast(void);
>>> +
>>>    #include <asm-generic/tlb.h>
>>>    #include <linux/kernel.h>
>>>    #include <vdso/bits.h>
>>>    #include <vdso/page.h>
>>> +#include <asm/paravirt.h>
>>> +
>>> +static inline bool tlb_table_flush_implies_ipi_broadcast(void)
>>> +{
>>> +#ifdef CONFIG_PARAVIRT
>>> +	/* Paravirt may use hypercalls that don't send real IPIs. */
>>> +	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
>>> +		return false;
>>> +#endif
>>> +	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);
>>
>> Right, here I was wondering whether we should have a new pv_ops callback
>> to indicate that instead.
>>
>> pv_ops.mmu.tlb_table_flush_implies_ipi_broadcast()
>>
>> Or a simple boolean property that pv init code properly sets.
> 
> Cool!
> 
>>
>> Something for x86 folks to give suggestions for. :)
> 
> I prefer to use a boolean property instead of comparing function pointers.
> Something like this:
> 
> ----8<----
> diff --git a/arch/x86/hyperv/mmu.c b/arch/x86/hyperv/mmu.c
> index cfcb60468b01..90e9da33f2c7 100644
> --- a/arch/x86/hyperv/mmu.c
> +++ b/arch/x86/hyperv/mmu.c
> @@ -243,4 +243,5 @@ void hyperv_setup_mmu_ops(void)
> 
>   	pr_info("Using hypercall for remote TLB flush\n");
>   	pv_ops.mmu.flush_tlb_multi = hyperv_flush_tlb_multi;
> +	pv_ops.mmu.tlb_flush_implies_ipi_broadcast = false;
>   }
> diff --git a/arch/x86/include/asm/paravirt_types.h b/arch/x86/include/asm/paravirt_types.h
> index 3502939415ad..f9756df6f3f6 100644
> --- a/arch/x86/include/asm/paravirt_types.h
> +++ b/arch/x86/include/asm/paravirt_types.h
> @@ -133,6 +133,19 @@ struct pv_mmu_ops {
>   	void (*flush_tlb_multi)(const struct cpumask *cpus,
>   				const struct flush_tlb_info *info);
> 
> +	/*
> +	 * Indicates whether TLB flush IPIs provide sufficient synchronization
> +	 * for GUP-fast when freeing or unsharing page tables.
> +	 *
> +	 * Set to true only when the TLB flush guarantees:
> +	 * - IPIs reach all CPUs with potentially stale paging-structure caches
> +	 * - Synchronization with IRQ-disabled code like GUP-fast
> +	 *
> +	 * Paravirt implementations that use hypercalls (which may not send
> +	 * real IPIs) should set this to false.
> +	 */
> +	bool tlb_flush_implies_ipi_broadcast;
> +
>   	/* Hook for intercepting the destruction of an mm_struct. */
>   	void (*exit_mmap)(struct mm_struct *mm);
>   	void (*notify_page_enc_status_changed)(unsigned long pfn, int npages, bool enc);
> diff --git a/arch/x86/include/asm/tlb.h b/arch/x86/include/asm/tlb.h
> index 96602b7b7210..9d20ad4786cc 100644
> --- a/arch/x86/include/asm/tlb.h
> +++ b/arch/x86/include/asm/tlb.h
> @@ -18,7 +18,7 @@ static inline bool tlb_table_flush_implies_ipi_broadcast(void)
>   {
>   #ifdef CONFIG_PARAVIRT
>   	/* Paravirt may use hypercalls that don't send real IPIs. */
> -	if (pv_ops.mmu.flush_tlb_multi != native_flush_tlb_multi)
> +	if (!pv_ops.mmu.tlb_flush_implies_ipi_broadcast)
>   		return false;
>   #endif
>   	return !cpu_feature_enabled(X86_FEATURE_INVLPGB);

I'd have thought that the X86_FEATURE_INVLPGB heck should then also be 
taken care of by whoever sets tlb_flush_implies_ipi_broadcast.

-- 
Cheers

David

