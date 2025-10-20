Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5CD3CCD195
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 02:10:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E5648E0003; Sun, 19 Oct 2025 22:10:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 496A98E0002; Sun, 19 Oct 2025 22:10:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3ABFF8E0003; Sun, 19 Oct 2025 22:10:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2AABE8E0002
	for <linux-mm@kvack.org>; Sun, 19 Oct 2025 22:10:01 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6D9188899
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:10:00 +0000 (UTC)
X-FDA: 84016862160.01.84C786C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf07.hostedemail.com (Postfix) with ESMTP id 9AB114000B
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 02:09:58 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760926199;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h48VKldYNtXa/MN00+NnYPBXV8HoPhBppMeXQUpPGoA=;
	b=wKSu9Ukndsn8wlShbQsuLdUycLKSPbUE8aBDadj5lwP/30bdydG6QZFmczjGdRGc/KYHvY
	4rkzO5AMO+RyvP3pEkBrC8rWJJ520eVON3T4gBEaBRpRfTdIv9XK3/rd++yzXXxtBm1dI7
	kRJnYjolp8F3XR7OtTrKS38JCdFZOv8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf07.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760926199; a=rsa-sha256;
	cv=none;
	b=UA8jwvTmoMsr9zqKDw6Fjtb0+oy7R51cdfvRe9zY5Wpv3UiZrpYKAreTq0bnZbjrkdBqgv
	x9wH7BJamaiFba7N/PuiFbY2uMY9Y9FMqVk/isUcboVc3SCM4SLCCYMA/xr56AcJddoPNZ
	Du8Y9S3X2KmPsH0dzeaZLafcCAQEebo=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id BBE071063;
	Sun, 19 Oct 2025 19:09:49 -0700 (PDT)
Received: from [10.163.38.187] (unknown [10.163.38.187])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 995013F7A6;
	Sun, 19 Oct 2025 19:09:54 -0700 (PDT)
Message-ID: <0e6d1f1f-a917-4e36-80de-03ba94c6d850@arm.com>
Date: Mon, 20 Oct 2025 07:39:51 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] arm64, mm: avoid always making PTE dirty in pte_mkwrite()
To: Catalin Marinas <catalin.marinas@arm.com>,
 Huang Ying <ying.huang@linux.alibaba.com>
Cc: Will Deacon <will@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Gavin Shan <gshan@redhat.com>, Ard Biesheuvel <ardb@kernel.org>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Yicong Yang <yangyicong@hisilicon.com>,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
References: <20251015023712.46598-1-ying.huang@linux.alibaba.com>
 <aPKFmHg-FrkGJxWd@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <aPKFmHg-FrkGJxWd@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 9AB114000B
X-Stat-Signature: gajees6wngscpygnknrztutotz6we4cm
X-Rspam-User: 
X-HE-Tag: 1760926198-799934
X-HE-Meta: U2FsdGVkX1/ThzwdHFgFYxzO3y0Vkv4QkxUsFsh366BG1FRYXGh11ywKaEhzDlP6cCqAUMPKotzvOIQvK0BI92kv4h9hiVuGJum6UXlfeNP83PoqxBt9+SxO8uV5hNmm1f51RRneRYCwA+GsSWfFNOnsz5+ClvBIcQKyRcwZJNJ8YQ8OyXXbwl8MYRYI9CJcHgCNnR2Edc3BNeFQJwB3tVFcgDCWszrrmCKNnML7RMJ7Htpdri6rGh+aFiH8rNKVt3jFLxgsmZ/jQ0dWOZYohfJ8nJUeBfsXJliXMopUSxO5BDFEeqqqMgiMjfpt+qk0DmQKtEcvasVFpmgjGGOymldN+voAL7UlR4f5BLLDLtYn05BtaeIPAzxeuyjXZbmzsU72xnsJ611kyQ8ONVAwW86P8OSFuQlcBDGk7k9wCFDMzdvbb8AG3rwDdyz/Xdvqlu+lNWONLPILZ11oTR1jaQchhZBCY8iFi3LsJGWr4MiBvTPrAUiEHXix/Bz1U6XjJYTUl39WRUgN2Qr0YwunDO9zTXBI7NqKgiUhHpqbgPjVOu+YfL+uNUmjTGiGv8a9cSFS53ZGOxsIJleGnqltobmfYFg6WFCcVT0BjVSiXdximqdwayv8UCNk4XOiYMxVyY2uHRxAs+lPkJv1ekaOlD76FmsYSW69bQDgxuiVTnLlf+m7Ao0ooTv9LcEsw33lN7dSlMA1CV2W+FpdaDVrBKsmdWgc+lEyCN8h1HkTQfzYj/uJu7spODDNmAAnZNRjTJcmiO3HAvg1PuvPVuTO7VVyIyX03cOVrakrNbw2QkM0E9MoSjsVqYFSFxrAU/Nz6ihkFIFob5Udm+0LLYWaKBkR9HJ3eqVvJ+alZ/8Pwii2JvKiDgPwqggKnw/QQXawRF4VCnCSBvs+Uhph6vGUpAv2R/NVp77iTgMZr+LfKmgIHoY2y3HJt1qbKBIp8RZWe/vFbEymW3/XoEb7alE
 WSJgi+KG
 VPzi5LQ8InQYd4Tm47+sDcVtKn0FmOQ7ghpJW5JinRXSWkfFRMPrHcjebuoeP8Kr6wxU66WUSGZJkrfn6DdaAyadu4CvLsyvPWMcc5mZkLj7jGhkWIWAzgcXqT1A5YjN9wdW9vqbY4yEAfZJePMZy0DuKgxptU1S1rrkXHNQda1zmfqRzMPHQ1neFGcPOjema08R5CDhc4eFBunparN83jkp9yBZhQnlqUNq3CjCax11sJNEJ23EMnNHtj6pSelg6JmtU43aMF+6ru/ntopH59t6w7/EllJMnzdKO0fE+2xDEkdqgjgHXKyNGXrPoToYb8BGDddSctdmx3SWpw639AvbVJt8wg4MuytgMuul0X43w6cref7YhbaS30lEhBRTBhHlkvnpS1kaLINfE9ekG4vsOUQj3j0Ak6UL+9OvQk0uKaFCX6q6cBJekHQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 17/10/25 11:36 PM, Catalin Marinas wrote:
> On Wed, Oct 15, 2025 at 10:37:12AM +0800, Huang Ying wrote:
>> Current pte_mkwrite_novma() makes PTE dirty unconditionally.  This may
>> mark some pages that are never written dirty wrongly.  For example,
>> do_swap_page() may map the exclusive pages with writable and clean PTEs
>> if the VMA is writable and the page fault is for read access.
>> However, current pte_mkwrite_novma() implementation always dirties the
>> PTE.  This may cause unnecessary disk writing if the pages are
>> never written before being reclaimed.
>>
>> So, change pte_mkwrite_novma() to clear the PTE_RDONLY bit only if the
>> PTE_DIRTY bit is set to make it possible to make the PTE writable and
>> clean.
>>
>> The current behavior was introduced in commit 73e86cb03cf2 ("arm64:
>> Move PTE_RDONLY bit handling out of set_pte_at()").  Before that,
>> pte_mkwrite() only sets the PTE_WRITE bit, while set_pte_at() only
>> clears the PTE_RDONLY bit if both the PTE_WRITE and the PTE_DIRTY bits
>> are set.
>>
>> To test the performance impact of the patch, on an arm64 server
>> machine, run 16 redis-server processes on socket 1 and 16
>> memtier_benchmark processes on socket 0 with mostly get
>> transactions (that is, redis-server will mostly read memory only).
>> The memory footprint of redis-server is larger than the available
>> memory, so swap out/in will be triggered.  Test results show that the
>> patch can avoid most swapping out because the pages are mostly clean.
>> And the benchmark throughput improves ~23.9% in the test.
>>
>> Fixes: 73e86cb03cf2 ("arm64: Move PTE_RDONLY bit handling out of set_pte_at()")
>> Signed-off-by: Huang Ying <ying.huang@linux.alibaba.com>
>> Cc: Catalin Marinas <catalin.marinas@arm.com>
>> Cc: Will Deacon <will@kernel.org>
>> Cc: Anshuman Khandual <anshuman.khandual@arm.com>
>> Cc: Ryan Roberts <ryan.roberts@arm.com>
>> Cc: Gavin Shan <gshan@redhat.com>
>> Cc: Ard Biesheuvel <ardb@kernel.org>
>> Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>
>> Cc: Yicong Yang <yangyicong@hisilicon.com>
>> Cc: linux-arm-kernel@lists.infradead.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  arch/arm64/include/asm/pgtable.h | 3 ++-
>>  1 file changed, 2 insertions(+), 1 deletion(-)
>>
>> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
>> index aa89c2e67ebc..0944e296dd4a 100644
>> --- a/arch/arm64/include/asm/pgtable.h
>> +++ b/arch/arm64/include/asm/pgtable.h
>> @@ -293,7 +293,8 @@ static inline pmd_t set_pmd_bit(pmd_t pmd, pgprot_t prot)
>>  static inline pte_t pte_mkwrite_novma(pte_t pte)
>>  {
>>  	pte = set_pte_bit(pte, __pgprot(PTE_WRITE));
>> -	pte = clear_pte_bit(pte, __pgprot(PTE_RDONLY));
>> +	if (pte_sw_dirty(pte))
>> +		pte = clear_pte_bit(pte, __pgprot(PTE_RDONLY));
>>  	return pte;
>>  }
> 
> This seems to be the right thing. I recall years ago I grep'ed
> (obviously not hard enough) and most pte_mkwrite() places had a
> pte_mkdirty(). But I missed do_swap_page() and possibly others.
> 
> For this patch:
> 
> Reviewed-by: Catalin Marinas <catalin.marinas@arm.com>
> 
> I wonder whether we should also add (as a separate patch):
> 
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 830107b6dd08..df1c552ef11c 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -101,6 +101,7 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
>  	WARN_ON(pte_dirty(pte_mkclean(pte_mkdirty(pte))));
>  	WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
>  	WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
> +	WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
>  	WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
>  }
> 
> For completeness, also (and maybe other combinations):
> 
> 	WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));

Adding similar tests to pte_wrprotect().

diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
index 830107b6dd08..573632ebf304 100644
--- a/mm/debug_vm_pgtable.c
+++ b/mm/debug_vm_pgtable.c
@@ -102,6 +102,11 @@ static void __init pte_basic_tests(struct pgtable_debug_args *args, int idx)
        WARN_ON(pte_write(pte_wrprotect(pte_mkwrite(pte, args->vma))));
        WARN_ON(pte_dirty(pte_wrprotect(pte_mkclean(pte))));
        WARN_ON(!pte_dirty(pte_wrprotect(pte_mkdirty(pte))));
+
+       WARN_ON(pte_dirty(pte_mkwrite_novma(pte_mkclean(pte))));
+       WARN_ON(!pte_write(pte_mkdirty(pte_mkwrite_novma(pte))));
+       WARN_ON(!pte_write(pte_mkwrite_novma(pte_wrprotect(pte))));
+       WARN_ON(pte_write(pte_wrprotect(pte_mkwrite_novma(pte))));
 }

 static void __init pte_advanced_tests(struct pgtable_debug_args *args)
@@ -195,6 +200,9 @@ static void __init pmd_basic_tests(struct pgtable_debug_args *args, int idx)
        WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite(pmd, args->vma))));
        WARN_ON(pmd_dirty(pmd_wrprotect(pmd_mkclean(pmd))));
        WARN_ON(!pmd_dirty(pmd_wrprotect(pmd_mkdirty(pmd))));
+
+       WARN_ON(!pmd_write(pmd_mkwrite_novma(pmd_wrprotect(pmd))));
+       WARN_ON(pmd_write(pmd_wrprotect(pmd_mkwrite_novma(pmd))));
        /*
         * A huge page does not point to next level page table
         * entry. Hence this must qualify as pmd_bad().
> 
> I cc'ed linux-mm in case we missed anything. If nothing raised, I'll
> queue it next week.
> 
> Thanks.
> 


