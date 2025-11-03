Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABE91CCF9FE
	for <linux-mm@archiver.kernel.org>; Mon,  3 Nov 2025 05:53:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D49A68E0021; Mon,  3 Nov 2025 00:53:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CD2DC8E0015; Mon,  3 Nov 2025 00:53:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9AD58E0021; Mon,  3 Nov 2025 00:53:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id A25DA8E0015
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 00:53:49 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 38A1812BE7F
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 05:53:49 +0000 (UTC)
X-FDA: 84068229378.06.7951E44
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0A641180009
	for <linux-mm@kvack.org>; Mon,  3 Nov 2025 05:53:46 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762149227;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=26036eNkvcVnBbzf9PpYJagr9e/Lm8CECkkny5xN5IQ=;
	b=iHnlqofR7aGfGnzi2XemfnZP+Zd2uJRg3t8g5tWCnvVVJ46VioR0I6KEpBK6Xf4dXeb8Fk
	p8WmZgnUgtecSY/9GaFtPeQoQUuUP3tV8VQ0Hb1ggyfKkMrWNcw6uVPdfNDzNNaYsFf+U0
	XhCwNfVSagPaGf85sy7p+hk2/EsVktY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762149227; a=rsa-sha256;
	cv=none;
	b=WrHTqbjMP8ZIPJ8XLJSXZELdG8P72PxSTNN7Tmf/4yIb7oQeYVJti2BPdf/NAUz7fzMoZr
	MLOVdJUE/meuENm3K4oWA1anFySBzMCZZJ9pN4i6g0AEJKGHZiMgqd5u0nOskYyN5C8diC
	GCawp2rp/hlnPKbhax2eeVMe2SuedwM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1D80F28FA;
	Sun,  2 Nov 2025 21:53:38 -0800 (PST)
Received: from [10.164.136.41] (unknown [10.164.136.41])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 3BEB33F694;
	Sun,  2 Nov 2025 21:53:40 -0800 (PST)
Message-ID: <4bc562ea-2fba-4484-9548-c606e254bc00@arm.com>
Date: Mon, 3 Nov 2025 11:23:38 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 3/5] arm64: mm: support large block mapping when
 rodata=full
To: Ryan Roberts <ryan.roberts@arm.com>, Guenter Roeck <linux@roeck-us.net>,
 Yang Shi <yang@os.amperecomputing.com>
Cc: catalin.marinas@arm.com, will@kernel.org, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com, ardb@kernel.org,
 scott@os.amperecomputing.com, cl@gentwo.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, nd@arm.com
References: <20250917190323.3828347-1-yang@os.amperecomputing.com>
 <20250917190323.3828347-4-yang@os.amperecomputing.com>
 <f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net>
 <933a2eff-1e06-451e-9994-757d66f4b985@arm.com>
 <bee6b93d-aa2e-4335-9801-89f02eb3eccc@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <bee6b93d-aa2e-4335-9801-89f02eb3eccc@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Stat-Signature: xjhgu8j9niibtpx578st8jk3je77sut1
X-Rspam-User: 
X-Rspamd-Queue-Id: 0A641180009
X-HE-Tag: 1762149226-378928
X-HE-Meta: U2FsdGVkX19tsPcAdw82dtLCofoXwlKtT+aSPJHEhaCvNrAqSBIWGakF5JLfuCZh+XpiZJVh48XJ3wmSzQ5lKfJH7nqQROedQbsStE8pmwHYPu1+omaysVkeyrMCXZ2AFDRILTQ1pMKIHTbcm0A6AlpG9S9DGc2devDRy/FOoO/44P5aT4WDTIqlwSW8cgQWskpWPw+5d89iCOHsWVFu3diJNBqIDIFxzmC0YwrpIKIv34xlswVIWB30RBJQFcMMew1F9f1aOelgP5rSKq57gN2t2TBY2eo8xqrqD9IGaGvYLgudjwEPdgOPzOKUPr1PeQQDyo5Qm8QVaMGsHsfW3aVxwiHSxGlS51W/ETuFdgqo6W9IcgV8N4zgumqxvq1SiQpOiv3hEuFJn+ycn8a2M1c65wZyz6upcoFqiNtd88csVS0FJmpGgPRCnM/3Nbww+d3fMfjIO0LxoDaadyyANX7a6LircGoWRHw5Iigbdrv7TyHx5PHvIr711mbETQMYIU4NaO1vyUWgrmjfez6aEg/IY2pxV/rpNjCZtLxm66TOLN+bNeOyCPndxhJkWfzFFTEfvQTAJtV/+pJoYnEDa+EALrPB21pDiqtjxyLphz2cMdEdIXpG/M+WBY4N3gZ+k7p9nCtEp/FpuzhipvyWVPudmn/X2j0xTOLQM9uYsu6fGlRW4tAGpY5nQeNhHYAYN8+RbSXtCvvETKwTsfZp8+hVIQSAP5qrWxcQLwJYiYHtqhZwq45EyePN1J2XPOUhGZrGA/yj5xPuuZAy7g06Z9ugX4tfuT7uaHWWeH695smWTygmzLQgnUN1yMFejxTEYIWCU5FPQ/gLcvCLL2Bcfs9LEI+Uprc9fK5OOTxJXTi+odqYDVbH0L17BJ41PuVqmVyv861pt/9fkuuiH1SAe0R1dyqtcAbGT+F6/6DT9wG1Cdg0XL02NoGdKnAI/kM+kZeEh78mkqhjN/+mQEY
 mCV9NseZ
 OAX795guBJ1898hjixW+Lgj2KklmNl9H6yFv5OxZkDs7F1d2xrNKwq++ENBfJ/WU5YMdHid6d4P3G3LmS98uXJaxLkbTKPIIVp0i/1NhcHdfYRNt7d+9bS50A0gIm0yGi9ioBAyHy8HV/jEw6it+Wo81W5aTnKmgHr7pi75yjRtTR++L1T5uAXS58qvoTshShd5FThpmlYumfewOVc80c58mFmf5SbEUgQYgeVAncd20N+PWr+3l82MVJi995COyvF5AutPzYZ2uZaK4l97I5u77HeS1EJvcF6bnO
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>>>>
>>> With lock debugging enabled, we see a large number of "BUG: sleeping
>>> function called from invalid context at kernel/locking/mutex.c:580"
>>> and "BUG: Invalid wait context:" backtraces when running v6.18-rc3.
>>> Please see example below.
>>>
>>> Bisect points to this patch.
>>>
>>> Please let me know if there is anything I can do to help tracking
>>> down the problem.
>> Thanks for the report - ouch!
>>
>> I expect you're running on a system that supports BBML2_NOABORT, based on the
>> stack trace, I expect you have CONFIG_DEBUG_PAGEALLOC enabled? That will cause
>> permission tricks to be played on the linear map at page allocation and free
>> time, which can happen in non-sleepable contexts. And with this patch we are
>> taking pgtable_split_lock (a mutex) in split_kernel_leaf_mapping(), which is
>> called as a result of the permission change request.
>>
>> However, when CONFIG_DEBUG_PAGEALLOC enabled we always force-map the linear map
>> by PTE so split_kernel_leaf_mapping() is actually unneccessary and will return
>> without actually having to split anything. So we could add an early "if
>> (force_pte_mapping()) return 0;" to bypass the function entirely in this case,
>> and I *think* that should solve it.
>>
>> But I'm also concerned about KFENCE. I can't remember it's exact semantics off
>> the top of my head, so I'm concerned we could see similar problems there (where
>> we only force pte mapping for the KFENCE pool).
>>
>> I'll investigate fully tomorrow and hopefully provide a fix.
> Here's a proposed fix, although I can't get access to a system with BBML2 until
> tomorrow at the earliest. Guenter, I wonder if you could check that this
> resolves your issue?
>
> ---8<---
> commit 602ec2db74e5abfb058bd03934475ead8558eb72
> Author: Ryan Roberts <ryan.roberts@arm.com>
> Date:   Sun Nov 2 11:45:18 2025 +0000
>
>      arm64: mm: Don't attempt to split known pte-mapped regions
>      
>      It has been reported that split_kernel_leaf_mapping() is trying to sleep
>      in non-sleepable context. It does this when acquiring the
>      pgtable_split_lock mutex, when either CONFIG_DEBUG_ALLOC or
>      CONFIG_KFENCE are enabled, which change linear map permissions within
>      softirq context during memory allocation and/or freeing.
>      
>      But it turns out that the memory for which these features may attempt to
>      modify the permissions is always mapped by pte, so there is no need to
>      attempt to split the mapping. So let's exit early in these cases and
>      avoid attempting to take the mutex.
>      
>      Closes: https://lore.kernel.org/all/f24b9032-0ec9-47b1-8b95-c0eeac7a31c5@roeck-us.net/
>      Fixes: a166563e7ec3 ("arm64: mm: support large block mapping when rodata=full")
>      Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
>
> diff --git a/arch/arm64/mm/mmu.c b/arch/arm64/mm/mmu.c
> index b8d37eb037fc..6e26f070bb49 100644
> --- a/arch/arm64/mm/mmu.c
> +++ b/arch/arm64/mm/mmu.c
> @@ -708,6 +708,16 @@ static int split_kernel_leaf_mapping_locked(unsigned long addr)
>   	return ret;
>   }
>   
> +static inline bool force_pte_mapping(void)
> +{
> +	bool bbml2 = system_capabilities_finalized() ?
> +		system_supports_bbml2_noabort() : cpu_supports_bbml2_noabort();
> +
> +	return (!bbml2 && (rodata_full || arm64_kfence_can_set_direct_map() ||
> +			   is_realm_world())) ||
> +		debug_pagealloc_enabled();
> +}
> +
>   static DEFINE_MUTEX(pgtable_split_lock);
>   
>   int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
> @@ -723,6 +733,16 @@ int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
>   	if (!system_supports_bbml2_noabort())
>   		return 0;
>   
> +	/*
> +	 * If the region is within a pte-mapped area, there is no need to try to
> +	 * split. Additionally, CONFIG_DEBUG_ALLOC and CONFIG_KFENCE may change

Nit: CONFIG_DEBUG_PAGEALLOC.

> +	 * permissions from softirq context so for those cases (which are always
> +	 * pte-mapped), we must not go any further because taking the mutex
> +	 * below may sleep.
> +	 */
> +	if (force_pte_mapping() || is_kfence_address((void *)start))
> +		return 0;
> +
>   	/*
>   	 * Ensure start and end are at least page-aligned since this is the
>   	 * finest granularity we can split to.
> @@ -1009,16 +1029,6 @@ static inline void arm64_kfence_map_pool(phys_addr_t kfence_pool, pgd_t *pgdp) {
>   
>   #endif /* CONFIG_KFENCE */
>   
> -static inline bool force_pte_mapping(void)
> -{
> -	bool bbml2 = system_capabilities_finalized() ?
> -		system_supports_bbml2_noabort() : cpu_supports_bbml2_noabort();
> -
> -	return (!bbml2 && (rodata_full || arm64_kfence_can_set_direct_map() ||
> -			   is_realm_world())) ||
> -		debug_pagealloc_enabled();
> -}
> -

Otherwise LGTM.

Reviewed-by: Dev Jain <dev.jain@arm.com>

>   static void __init map_mem(pgd_t *pgdp)
>   {
>   	static const u64 direct_map_end = _PAGE_END(VA_BITS_MIN);
> ---8<---
>
> Thanks,
> Ryan
>
>> Yang Shi, Do you have any additional thoughts?
>>
>> Thanks,
>> Ryan
>>

