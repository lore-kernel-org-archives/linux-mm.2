Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6C1ACAC592
	for <linux-mm@archiver.kernel.org>; Mon, 22 Sep 2025 06:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FD998E000B; Mon, 22 Sep 2025 02:03:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1D4B38E0001; Mon, 22 Sep 2025 02:03:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 111AC8E000B; Mon, 22 Sep 2025 02:03:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 00BDA8E0001
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 02:03:04 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9F7321DF84D
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:03:04 +0000 (UTC)
X-FDA: 83915843088.12.7775B81
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf12.hostedemail.com (Postfix) with ESMTP id A59DC4000B
	for <linux-mm@kvack.org>; Mon, 22 Sep 2025 06:03:02 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758520983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=nKsNyOw7ODFvqki0SdW5tqx+B+H7GbQT1R2zDBNGKkc=;
	b=W/zLNuE+oGU1cmLzgGDtQC765Kv0nL7hALErhUN4W0V9puheCnnvkbajCJTBnw2D6yc/YL
	nfQOSv6AISW96T38c8ccw6PcqhTLgAIsiF0WHPwXys7SNwpTnEFS6ToSZ652uDUY+T4Sjt
	KqipDgHWNPPuikzaSo3k5UbSgHbzJdE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=none;
	spf=pass (imf12.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758520983; a=rsa-sha256;
	cv=none;
	b=Xpk662+LvifkeR85GLwDPrfrQZmXiNjiBS0b4j399rGVo8qtWE3U4Rxtz89L7jfBZq+rcK
	1gbPCZlapWWEYNJBGmi1fWLE+CfWaEdBcH3jXFiDp3C6gWDGiQXUZygMqoOIBjJuszjYxj
	WWq3AWzQlDNzagk8onKVh89FI+fq7bg=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 797B51515;
	Sun, 21 Sep 2025 23:02:53 -0700 (PDT)
Received: from [10.164.18.47] (unknown [10.164.18.47])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E81803F66E;
	Sun, 21 Sep 2025 23:02:59 -0700 (PDT)
Message-ID: <2a7e000c-f075-487e-a750-1fa8d29adfe8@arm.com>
Date: Mon, 22 Sep 2025 11:32:57 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Remove PMD alignment constraint in execmem_vmalloc()
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org
Cc: rppt@kernel.org, ryan.roberts@arm.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20250918093453.75676-1-dev.jain@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250918093453.75676-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: A59DC4000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 13n3xfxdj68jws7noh1nbku197zha6b8
X-HE-Tag: 1758520982-76272
X-HE-Meta: U2FsdGVkX1/PHrm/3a5XRaVlcglPAwrAV3JVFoXA/CFTXVGYJgv5Fk9UOVx4Sb3RgvIvRzRhYHnA6KGRCYXsA1x1MhEOsu6gmy9/iwNcKS68JAtm7egStRPAxSdl3040Mpj1k5/wn8WMVU/8FBEBZG/35C+wyJKtsHX9ZCkL5s7sJz/aJkVCHZQx4oG7vAcef9uPZkvWUEd7hQYmz/SiorPQbIXO/cTj6LoFl6rw+5F0yaFjQYoqItckV5BoTKLq8869u2Na21TmJsHqKA34Ih6IrGyuMZIpY4W0Gt039y2MA3/FgYPudXF6pua6OYnKigGshBK3lJQclYC5Edket3gpsBFNbs2whnY/odjw72PFYrxCW76Du2lsLxAsf85EFkaQPfpBJaXoCsI999oeN++7WwpyApuBQfm7yqvn13MzFGnqqJSJTpZigStyQv8ChDJHXzSr1vWb5achHjbTWAdHTMBUdhcnZwTreZmjQisgL27r85gPpiR5L8f6N4tKVxe9CdGhHPup4xHH81yLQZX5geO2AKQnasgJmULL0HEXjFxIgodPvzqSzULOnu6zJKGWl6FoKJyI/5st7Pr0hYFobNySZo2NPBH8NNJFjImYleC29mVqXkvJVu2uNNpVDNmDj9OvgKyr+uyz4mMzCI3jpr3VOCV8eKherJMC61b6Jncty0mp0GGTQaMODdUd7j1wiVKA2a/QlxwGTEeDBS1wn/Af2AIEwTRYc03RhOjXEUgHxdBIdBclWkuYQNOCB2dIjlUbShV5wuXee7HAwkkD0uP32EkYOWJtjWK8l9krOWdXvheGbyXLRJAD6PzFJyRkai6q3qRDKViD+pLJgaf9jB2zyHhmxTh/YwlSCteJ+URDWjXTDI4wGcA6fLNV2baXFjcsSCI01345MyzyuwINfZkrzIuvy585hWTVcWMl/09y+xYhscOy0EeN7J0X2HxIDhkFuHRG1pfyiXE
 2l/G5ZX5
 z3u+OG7pYes0uuAzjkKEfVtU6hxwHP1A67x7uBs2mwnyLXQNH52h8L7Fu+AvAdulEUTAaWS8ABoShntEOjO1sDt45p0oOzzOc29iZNcD3129pejKtFQQ+fp8/6hccApmxCIZuYkyCCnJoUAaWxR5ChAu/q07eJZZZi56I3dMsRVANl6FEcUNVdTZXj12Zu83lR38qO+TlG1w3F7k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/09/25 3:04 PM, Dev Jain wrote:
> When using vmalloc with VM_ALLOW_HUGE_VMAP flag, it will set the alignment
> to PMD_SIZE internally, if it deems huge mappings to be eligible.
> Therefore, setting the alignment in execmem_vmalloc is redundant. Apart
> from this, it also reduces the probability of allocation in case vmalloc
> fails to allocate hugepages - in the fallback case, vmalloc tries to use
> the original alignment and allocate basepages, which unfortunately will
> again be PMD_SIZE passed over from execmem_vmalloc, thus constraining
> the search for a free space in vmalloc region.
> 
> Therefore, remove this constraint.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> mm-selftests pass, but I am not sure if they touch execmem code, and I
> have no experience with this code.
> 
>  mm/execmem.c | 3 ---
>  1 file changed, 3 deletions(-)
> 
> diff --git a/mm/execmem.c b/mm/execmem.c
> index 0822305413ec..810a4ba9c924 100644
> --- a/mm/execmem.c
> +++ b/mm/execmem.c
> @@ -38,9 +38,6 @@ static void *execmem_vmalloc(struct execmem_range *range, size_t size,
>  	if (kasan)
>  		vm_flags |= VM_DEFER_KMEMLEAK;
>  
> -	if (vm_flags & VM_ALLOW_HUGE_VMAP)
> -		align = PMD_SIZE;
> -

So if the above assignment is getting dropped here, probably the local
variable 'align' could be dropped as well and range->alignment be used
directly instead ?
>  	p = __vmalloc_node_range(size, align, start, end, gfp_flags,
>  				 pgprot, vm_flags, NUMA_NO_NODE,
>  				 __builtin_return_address(0));


