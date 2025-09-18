Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66EF0CAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 13:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9D4558E0108; Thu, 18 Sep 2025 09:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9853C8E0093; Thu, 18 Sep 2025 09:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 89B5B8E0108; Thu, 18 Sep 2025 09:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 702D08E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 09:06:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 322F5845F8
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:06:31 +0000 (UTC)
X-FDA: 83902394982.09.A8F0687
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id 4049D10000B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 13:06:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758200789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6uyT3BemPMd7JAA4sP5auQ9UDf661P/H9gmSch2VBpM=;
	b=crH1b+VQp6xaLiF263WFyd3+sIuG/B/N2fmk5B8CnHoeKo03e+n+G6ibIxlyWao4/hPlqg
	htCvCTtVLont+PEwauDxjL0RL4EQ/ZONTK0G9jNuXawZEslosVHa5qTYZupQzdcHXWOnoE
	Cc3Ex1S5ITLwO+rcc5CZT4TiyQMYGhU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758200789; a=rsa-sha256;
	cv=none;
	b=qAodMrNkAw6D2zz7Z9owF1UuC/UPmgiLGQ8V1hrqPMP+jYi0XM2iiioAxPhMk1+m391gqA
	tZ28yI2st2KcbW/naBZnnyiTGsvbTB79azQjVyMBZyNv9trQmoe2ExiteTC9NF4/sqYLL7
	O8h8Dic0WUjgd4DNsDu7C58Cy8aSqww=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf14.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id E8DE41A25;
	Thu, 18 Sep 2025 06:06:19 -0700 (PDT)
Received: from [10.1.33.171] (XHFQ2J9959.cambridge.arm.com [10.1.33.171])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 33A873F66E;
	Thu, 18 Sep 2025 06:06:27 -0700 (PDT)
Message-ID: <d4019be7-e24c-4715-a42a-4f1fc39a9bd4@arm.com>
Date: Thu, 18 Sep 2025 14:06:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove PMD alignment constraint in execmem_vmalloc()
Content-Language: en-GB
To: Mike Rapoport <rppt@kernel.org>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250918093453.75676-1-dev.jain@arm.com>
 <aMvf_R4ttLibbnQ1@kernel.org>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <aMvf_R4ttLibbnQ1@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: nkc79irt43ernxayonxhoihu9fkifjqd
X-Rspam-User: 
X-Rspamd-Queue-Id: 4049D10000B
X-Rspamd-Server: rspam10
X-HE-Tag: 1758200789-567398
X-HE-Meta: U2FsdGVkX19BW74/boYe7LrRCorioAoaW/2RZ5P7pqODwCOt15G8rbQmC5hhuqMY6xfrBYSO7nXUAd/3zQf739dx4Wgpw5op76O7mzrOsFmhss1qnHTlpev3SbWgC6KiPGfqhM8y9z0oBQlFXrPNPaiptyeMWOJ2dQAZa/USDLnpm7OsD3FmG++SnFYaWqIwOud9HRBWAIDoFYHWlHjdwYnB1g7wJr64HChBdccguNi6OsWC0KngUMlYwKQ6o5r8Q/S+8oqhPGzScVoC0z3YxyPmEWxdxPwg5/zXqqGtYop6BvzaA+7nnXL/oMsNEYfmTNQ5EXEYFehNSgu7uIkn1RjYxIAK2S5s4OwuY4hoiUHuR+QiXgwT7+2UUCMnTTjmCZrMicUFi+strz0tx6NhoSrfYt8kzmWkZ5FC5vQ4RO42yeTm+tNLpody+zz7v6Od/SgD3aSXSK08tssR9y2sDfDDX/EkpCrnue64TmWoj/xM9oEHRe/sWUhPJVwu/dbBv62QovzXfHOTqenN3HFuixKck+n8FLE8JtE7X03y8FME+CqprSWgThahrQ5M1vWB369c+ykOhQTwe2ooIhRZSjUPVF9+Zv9YyOixPU/aPpS4IZdXzkMUh9AQr4wKxJLijeJPtXqoVyyJJ8Uk9tQCXFf7Aczvwx8nJ1Dj9CfIlivDp5K1jL/ECapv9z/bl9k9XCrKEKrccgkdn2hJQXQ8uiRsy7jCirjbW/uOVEsyvbM6MEj/mm6ArS5tVaR92Wx0ZfG3oZX6OfA9GnxiY8nvVefKLZtsy3LAH5A0iWhd+1CFcm1JazbIP8V5Va4XTO5n07yPXg0o3R805wzdmAHIkt0dPKrgZpt8fU9Fxr9hW3f3HNhkHuQLTKSx6QrzKfTjcWPd2glIDxtbLbsPGpEIMeFdCrmWVtONqkojXteETI9Z4WqiKnlCVa4Bm7Uhn4p1HJZBObaKtMZglzTQ8Tz
 TM8PyWHg
 /qrwZyS+z95beGryJDoUnrr0xmCDNbAxLvUR69seqKtzglk2HqceZz5/Tbc2CO/KhCkWUsI8ZUKWLdG4wtXkIsNauGI1K/rqgCRaK135zdrWyK4wpY5U3hcxWyCWVugPjA6sxsngydsE2MNFhZRAd90i+1LaDBZxGmnpM7JUdLgIc9uIQtvL1u596Ziw6ho+/QYJNHjcxISmHnMY/efstT1oyHqRPIimoTGRe0kNujgnRd8MmbRNYp7mLxNhAcgU+hGb6NFKfklwf6j4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 18/09/2025 11:33, Mike Rapoport wrote:
> On Thu, Sep 18, 2025 at 03:04:53PM +0530, Dev Jain wrote:
>> When using vmalloc with VM_ALLOW_HUGE_VMAP flag, it will set the alignment
>> to PMD_SIZE internally, if it deems huge mappings to be eligible.
>> Therefore, setting the alignment in execmem_vmalloc is redundant. Apart
>> from this, it also reduces the probability of allocation in case vmalloc
>> fails to allocate hugepages - in the fallback case, vmalloc tries to use
>> the original alignment and allocate basepages, which unfortunately will
>> again be PMD_SIZE passed over from execmem_vmalloc, thus constraining
>> the search for a free space in vmalloc region.
>>
>> Therefore, remove this constraint.
>>
>> Signed-off-by: Dev Jain <dev.jain@arm.com>
> 
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

Hijacking this thread to ask Mike a related question, which I noticed during
code review...

execmem_alloc() determines the pgprot from the descriptor set by the
architecture, and for !CONFIG_ARCH_HAS_EXECMEM_ROX (a la arm64), passes the
value into __vmalloc_node_range() (via execmem_vmalloc()). vmalloc then uses the
pgprot to set the permissions of the vmap. But the linear map is left as is
(i.e. RW).

arm64 requests PAGE_KERNEL_ROX for the EXECMEM_KPROBES type. So by my reckoning,
the memory ends up ROX in vmap and RW in linear map. Naively that sounds like
something we should be avoiding? Is this intentional?

For arches using the ROX cache, execmem_cache_populate() calls set_memory_rox()
which sets both vmap and linear map to ROX.

Thanks,
Ryan

> 
>> ---
>> mm-selftests pass, but I am not sure if they touch execmem code, and I
>> have no experience with this code.
>>
>>  mm/execmem.c | 3 ---
>>  1 file changed, 3 deletions(-)
>>
>> diff --git a/mm/execmem.c b/mm/execmem.c
>> index 0822305413ec..810a4ba9c924 100644
>> --- a/mm/execmem.c
>> +++ b/mm/execmem.c
>> @@ -38,9 +38,6 @@ static void *execmem_vmalloc(struct execmem_range *range, size_t size,
>>  	if (kasan)
>>  		vm_flags |= VM_DEFER_KMEMLEAK;
>>  
>> -	if (vm_flags & VM_ALLOW_HUGE_VMAP)
>> -		align = PMD_SIZE;
>> -
>>  	p = __vmalloc_node_range(size, align, start, end, gfp_flags,
>>  				 pgprot, vm_flags, NUMA_NO_NODE,
>>  				 __builtin_return_address(0));
>> -- 
>> 2.30.2
>>
> 


