Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FFBECFA466
	for <linux-mm@archiver.kernel.org>; Mon, 24 Nov 2025 10:27:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E695C6B000D; Mon, 24 Nov 2025 05:27:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1A326B002C; Mon, 24 Nov 2025 05:27:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D57556B002D; Mon, 24 Nov 2025 05:27:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C09326B000D
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 05:27:11 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 378BD1402DB
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:27:06 +0000 (UTC)
X-FDA: 84145122852.22.7971B32
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id 8E005160005
	for <linux-mm@kvack.org>; Mon, 24 Nov 2025 10:27:04 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pW6a1ge/";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763980024;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Pi6qdedOvqA55zCFdmcR0d9sIinesowhL0gJtr3J8vM=;
	b=6l1r1KWxRihQBGZ8MRoTQQi57TfGxl9oCT1QJqeqXa0GqJwv+zFi7yIEgCYOPu5hBT3ZAL
	Oy0emFwnS6OLmfqZyKs6uOY9kQpOzm8HTlWt6VumROY3S3kPcJK21up4AVK2ncOjXae8Nm
	nDe1f8yGvDTUzK3bNHSEO7vj/ZNRGq0=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="pW6a1ge/";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763980024; a=rsa-sha256;
	cv=none;
	b=0OTXmCuD2Gaf3XIW8MPJEVYELVT3MmfAGH2lruN1vApRKfALksHRnbMi2RpkzTXpZA5Uca
	lPf3wir0+u5eh5T40KLDh6A4n0J5xv5eEM3VhfhwPWmjXVMpeXioGLIDtqnspUpYp+2T4q
	n/5uH2z1Vk7Ne1pShqUxYyNNNfItAs4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id F3AAB60138;
	Mon, 24 Nov 2025 10:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AA1CC116D0;
	Mon, 24 Nov 2025 10:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763980023;
	bh=Cw/QN7149lkWKCoCGFt6hcJE5ihImjpJqd3DyabjBzM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pW6a1ge/2iJNiBwbLWAnBy7dB+z64UWvW/6WI+bGI+5m8Lvq7RPsUL9+rqjKW5OfP
	 ZGRSwTWCO+dLoETToAo064G7cx48rQm3qkd62nyHJrZFV9IsOszth+ids3XYU9q9y/
	 OJmtPfNBrFIE/uG49bPv6quTnZDCXWW3XF5iDng/+twMNVOeqWdozny6kQK26wuoA1
	 XEL490Rrw/b5zwEpY5wQCQMWj2PzKTaTfDqsl+GGOjDvsJXT+1pFo/RB9Ysmv/WxRW
	 k0wXY9/p0xHZyxsn9QK42AGbZWAL6E5n8r5n8eC6Z0/BYbB9+XxKlzXYjaYFt1sdH7
	 FOiaMsOFeRCiQ==
Message-ID: <c9c75803-c8d3-4f9d-b726-d0aa19926b88@kernel.org>
Date: Mon, 24 Nov 2025 11:26:56 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v9 2/7] mm: introduce clear_pages() and clear_user_pages()
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 Ankur Arora <ankur.a.arora@oracle.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org
Cc: akpm@linux-foundation.org, bp@alien8.de, dave.hansen@linux.intel.com,
 hpa@zytor.com, mingo@redhat.com, mjguzik@gmail.com, luto@kernel.org,
 peterz@infradead.org, tglx@linutronix.de, willy@infradead.org,
 raghavendra.kt@amd.com, boris.ostrovsky@oracle.com, konrad.wilk@oracle.com
References: <20251121202352.494700-1-ankur.a.arora@oracle.com>
 <20251121202352.494700-3-ankur.a.arora@oracle.com>
 <10a90b15-3e26-451a-bebf-f7ad8ba67d1b@kernel.org>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <10a90b15-3e26-451a-bebf-f7ad8ba67d1b@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 8E005160005
X-Stat-Signature: mtpkibn84bhnw6wnpbtmea1szt7jnwtc
X-Rspamd-Server: rspam02
X-Rspam-User: 
X-HE-Tag: 1763980024-267439
X-HE-Meta: U2FsdGVkX1/oz3Oq1DYOCrRE5A4vRZ666czG++zA2mjxa1oVs7dYuVbDR3tO3BrIL9inhKexpQLmeT8yxAmTKMtm7QBoT9igX5IgvncWzp5N/A28EhlWqqN2tTaHrJiYQSPmYC6ndwc0BIdJ6kT3PnmkDGDQLo7IFBieHzM1FEYnCMZA3wEvGkLwQh+tH40d1CDs4p6rXecKUGt+c5CjLE93TaR02RmuCi5tswI90k2hPYlMf+ss+UUq0jT+/mMkkj8hrh5CX1NRAGBMMpPJ+VphrI1MHkJ0e4RVlEbw6fJp4yYT4xG+1aYpMMRCZw8QuewA4KnJk5LHARk9kaMrx+lTnnXd82ou73QGsz8n+yurP0TWI8zRsZm7hdXc5Zf4XnukCGNm0dDqndMqwVTDEHYV+BdF/ZUmWmias7BpJpzU1w9xN0OyPGr/bSIQLCQjvSySOOIwq7bq+GbTZp/J0QW3NRAuao4zsP/q6kLY9+k7FbjKaTU4MabFt2yQMaizEoHWRCvjpLSpDbli8i5WQi1MRXHp0I7yeJkqyWPk17ZzMfX7VhXKgxFZNi5irqYZaFUEXqy2VW+82SdzCRFivHKr8YS2P7phM51zA7PdxLtx3mF86e2n5beBBrgp5AJAAspY7zzpA0X6DmCjE4LqTkkuR4g6HUaDZP/1DzJdzB0VKro++qo26Tm0zIPNldK6Qdplq4hCmNVTMp6d6T9sHgFB1Eyl1F4MrFk6sBuFju3UnU9cfrDUbMgvGL9HR81/R9FcKMV0IQ//0Dv85Q24JnSbtBTJcXZd71OTNg2ARQqnQp8QoztUjxQuvZS5UdUMM9rSllhG+JptO0cngQT4vawBhYpDRaNSSV52pyw/zMB/n5nPMQ/s0r7tkPfN/ei/mZj2Gx6vrEsSIM+CbG0QpeNKCdti7OoEza+1gKzgIrVWYZv/oPqNVKA3zcmnKmP/utT6EdZ2SvS90x29xvH
 Xpq17Unn
 vvATLPl21m56hn8m943mmrQP0aoUd6NtDYhzTNrBMhCFG2HD5klw9P+f6Pc9g8jIe5lcHWTEQ6jgMg1NkRCw6cc7rDHJsRjvakdXQ2I7ui/y6fi5Swp1YCdf/Twr9BDWwOZ5C2+tTIwG7x3v1c5X0F/H4vwvkQMuqM7PLPD5XW2Kj2Em/h/8Yc/pBEfseYXouOlbM4KfnuKUFTZt4E6cKKlM/ixnYTgdFKYC0Up8cs309NSoOl9TRz9ZkfNhGe/tyhvd1QmgZ8JNyoe8Y/4juH+h4JnUBZLW+MR3W8PBDkksiemURfDphKtFKDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replying here while I am already at it.

>> +#ifndef clear_pages
>> +/**
>> + * clear_pages() - clear a page range for kernel-internal use.
>> + * @addr: start address
>> + * @npages: number of pages
>> + *
>> + * Use clear_user_pages() instead when clearing a page range to be
>> + * mapped to user space.
>> + *
>> + * Does absolutely no exception handling.
>> + */
>> +static inline void clear_pages(void *addr, unsigned int npages)
>> +{
>> +	do {
>> +		clear_page(addr);
>> +		addr += PAGE_SIZE;
>> +	} while (--npages);
> 
> Why a 'do while' instead of a 'while' ?

More efficient when we know that npages > 0.

> 
> Are you certain that this function will never ever be called with a nul
> npages ?

That is the expectation here, yes. We should probably document that 
expectation.

> 
>> +}
>> +#endif
>> +
>>    #ifndef clear_user_page
>>    /**
>>     * clear_user_page() - clear a page to be mapped to user space
>> @@ -3901,6 +3921,27 @@ static inline void clear_user_page(void *addr, unsigned long vaddr, struct page
>>    }
>>    #endif
>>    
>> +/**
>> + * clear_user_pages() - clear a page range to be mapped to user space
>> + * @addr: start address
>> + * @vaddr: start address of the user mapping
>> + * @page: start page
>> + * @npages: number of pages
>> + *
>> + * Assumes that the region (@addr, +@npages) has been validated
>> + * already so this does no exception handling.
>> + */
>> +#ifdef clear_user_pages
>> +void clear_user_pages(void *addr, unsigned long vaddr,
>> +		struct page *page, unsigned int npages);
> 
> By doing this you forbid architectures to define it as a static inline,
> is that wanted ?

Note that this is not the intention. The intention is to either use a 
direct mapping to clear_pages(), or fallback to the variant in mm/util.c.

The architecture is currently never expected to provide clear_user_pages().

Wondering if we can make that cleaner.

I'm wondering if the dependency on highmem.h here in mm.h is rather the 
problem.

How I hate this macro crap with arch overrides.

> 
>> +#else
>> +static inline void clear_user_pages(void *addr, unsigned long vaddr,
>> +		struct page *page, unsigned int npages)
>> +{
>> +	clear_pages(addr, npages);
>> +}
>> +#endif
>> +
>>    #ifdef __HAVE_ARCH_GATE_AREA
>>    extern struct vm_area_struct *get_gate_vma(struct mm_struct *mm);
>>    extern int in_gate_area_no_mm(unsigned long addr);
>> diff --git a/mm/util.c b/mm/util.c
>> index 8989d5767528..3c6cd44db1bd 100644
>> --- a/mm/util.c
>> +++ b/mm/util.c
>> @@ -1344,3 +1344,16 @@ bool page_range_contiguous(const struct page *page, unsigned long nr_pages)
>>    }
>>    EXPORT_SYMBOL(page_range_contiguous);
>>    #endif
>> +
>> +#ifdef clear_user_page
>> +void clear_user_pages(void *addr,
> 
> What happens if clear_user_page is defined but not clear_user_pages ? In
> that case it seems like the definition in linux/mm.h will conflict.

The generic mm.h variant will not set clear_user_page() and consequently 
we map directly to clear_pages().

-- 
Cheers

David

