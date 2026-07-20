Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88958C44521
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 07:50:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9BEA96B008A; Mon, 20 Jul 2026 03:50:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96ECA6B008C; Mon, 20 Jul 2026 03:50:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 861006B0095; Mon, 20 Jul 2026 03:50:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5F52E6B008A
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 03:50:58 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E970BA0FDB
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:50:57 +0000 (UTC)
X-FDA: 85008383754.30.80D3E55
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 18027C0006
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:50:55 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=N3Y1fIEH;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784533856;
	b=L6zUFxzNjVk1SgWz0wwxQbP8w8/P4xkhL9diHRVDiMXQzM2dv/khm5lI+NUJkM823MlW2K
	+XX5Y0Aac0s85pCcNYBNAMvBiP5ffE6S/Razs44pciX9yePl8lC92WGMnMC68Zo0VufJBT
	PcFZzVOgCQnIKvP4yhLv9xCAZ0ugO5g=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=N3Y1fIEH;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784533856;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lodkTsyKKcDBj+yB9Hc1ozevSN9hyzeJ/bgAOus7jZU=;
	b=CalQxHW6w38RYbI5KFuxyoX5CKDLXY0xF7q577cIHvwihQMWrigY+uU6ISF42Ky2EJz200
	S9RPkmr3Oys7T+/u5/Wn9ITeIzB5EKRoP1lsQL/sFdoYYTb8u86M08a3hvuq7F1aLT1L7X
	fvv6b6xoptVwXkBU7s0dI7RCAGklowk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 299F22B;
	Mon, 20 Jul 2026 00:50:51 -0700 (PDT)
Received: from [10.164.19.57] (unknown [10.164.19.57])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 10F823F86F;
	Mon, 20 Jul 2026 00:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1784533855; bh=2Un4GO8yOvt4jQTKL0yMvo/Ed/dJKpSRadpiypHDvPg=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=N3Y1fIEH02S7auRV/kad7+v07C+/uk7U1HwOWDfGg9cVKuJxjpF4lLb4rTj8QcSVM
	 fy1FCBwPyvvEce0+BXG4UcjaKJJF9wjlLKZNU3G1qgpI12D+s8sxjqCjt5PHMGl/1o
	 HVQy4QlxnijXCCw0L/cqoKcHdjO0pr1e+G9OvkWc=
Message-ID: <243328f9-1247-4104-ad09-b2f6de520128@arm.com>
Date: Mon, 20 Jul 2026 13:20:48 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v7 5/7] mm/vmalloc: Extract vm_shift() to consolidate
 mapping shift selection
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 david@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, rppt@kernel.org, ryan.roberts@arm.com,
 baohua@kernel.org, Wen Jiang <jiangwen6@xiaomi.com>,
 Leo Yan <leo.yan@arm.com>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
 <20260715120813.3609949-6-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260715120813.3609949-6-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 18027C0006
X-Rspam-User: 
X-Stat-Signature: 5ufu8c8epiko66i4xeipibzdxr89bq7x
X-Rspamd-Server: rspam03
X-HE-Tag: 1784533855-782417
X-HE-Meta: U2FsdGVkX1/yOseQIUz/IdmF+iwvYZDBq1uC8FjrAmFSTHGN2EBQv3cL5iZhAVcAKxlug6VkI3hDcrwWwdIf9zmmd5FQd4L6ZhNDi0e+iDDIbe4uaekcEMLXxA3nEjsYDC9o7UhIZq558PpSwSwXWhmzJ0jekfeNWWJa2Cr82XbQCtxZnza7PFTLlPMTZBRnRcMj6BSYeFOjw3mor4ew+5A8Lav2rlo20lHIJfYSZeCHPZRe+4F//fCDh067ILLBsfulGp9eCDReO7+B5eBNf4O2j5v+W8u2B8oARhTq9lnmiuSlSN0jm8HKdomfrd3uBUFtu6yQZdPLp19qsDU/v/R/g1J1jEpOB/Cr5eBaFBCiBjMeTy/qNO1xdKwwqoJ5ZyFh16etOSzs5oWxOWe9q7eK2JfOzYgtPn+xNaOgTVzCWu+Zs6oyxL3zxPEkeG60HizSqBPpgS+FvWSlDaUyAn+Gmr/PfQxz0U2mXjqRuXO/WGBlcBuAxUKDY/uC8EEmsG17M3DCO9OXqt42CI9KdLByTPoj7WLcYJvga+CDObT/SJagDcH+JjpRQzrmX00Cvv4QadqHq9v56P4ZK2OJlQNm8NysdUZ6hI9ythdfnBVuXz2W/BLnQgklRnyUhPNDLW04KgHxesgJe6ozJHKstOG9aQviQzGGp/6Q+GvjPtIYmQ5lZk77YisIiH1g54IqKRoahyhEYXN10IRlguiSNe89SWpaq8p/1Nm2Am3lL5EbnttPwBULZOlyc+mHS++KWIl8J9pi0cYwofYeDiEKH4rDMisKpMLtenW+xeI/Sw8+/iQU3IHhjCJubqzGFejnscki2Nq0o/MmQJ/gwjJT4RBp13lqWG9ic09d60HqaGYirjJzBx+9OvFUXu9DPRYnZ2wFqqcsDjGuaGItMTuuuNrB1PRRfgN4Qt65XBfTC5RWXqJxMPnXbAMTGtxZtWlXxGV9Q2p95WLhGOhKsY3
 6by7X4lW
 +mroD2hOFlx6cwssxzRLbNY73aGRxGFOcQEA3e068OgWOXnO6NCqCAnIwzvNTTp0GQSYMEJX/+Z9KLuK8Iw10LmffCMkCap7GCICE2gMpfYj8s/1qmfMVZGLRt5OauyZeOt49/Q6cJ0KH34ZULsWiX6/r4emtuyWEeE3uthNdsiwwBxiEr71grox1CU9NQEYw/YWkk8MY/9AuUGcodDLqHzqIZ2UtSgcJ333nWDBn8FOrOgy32jYcO5LRMOxsvEbYKymGKlMdr36savbIeGBuH3YjtWDKIFPeIKVP8rqok2QaykqRSek37BcvbDLkmx3KM65Sl6pXTWTCPgJawy7s//8DHFrbaYMd6TQOZ56BH+PoN5iYzosYOkmMxgAW+UOQ6wutZzaZb6FmxOXf4yyeDQOGq81kFYY8EbWFDJx+6HsEJopN6GqHTWfhUo/GNTtUAsUlPP32+26RU/6YbBr869y/7w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 15/07/26 5:38 pm, Wen Jiang wrote:
> Extract the vmalloc mapping shift selection from
> __vmalloc_node_range_noprof() into vm_shift(), preparing for reuse by the
> vmap batching path.
> 
> No functional change.
> 
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  mm/vmalloc.c | 14 +++++++++-----
>  1 file changed, 9 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> index afc695d5973e8..a1e025120e9df 100644
> --- a/mm/vmalloc.c
> +++ b/mm/vmalloc.c
> @@ -3549,6 +3549,14 @@ void vunmap(const void *addr)
>  }
>  EXPORT_SYMBOL(vunmap);
> 
> +static inline unsigned int vm_shift(pgprot_t prot, unsigned long size)
> +{
> +	if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
> +		return PMD_SHIFT;
> +
> +	return arch_vmap_pte_supported_shift(size);
> +}
> +
>  /**
>   * vmap - map an array of pages into virtually contiguous space
>   * @pages: array of page pointers
> @@ -4047,11 +4055,7 @@ void *__vmalloc_node_range_noprof(unsigned long size, unsigned long align,
>  		 * supporting them.
>  		 */
> 
> -		if (arch_vmap_pmd_supported(prot) && size >= PMD_SIZE)
> -			shift = PMD_SHIFT;
> -		else
> -			shift = arch_vmap_pte_supported_shift(size);
> -
> +		shift = vm_shift(prot, size);
>  		align = max(original_align, 1UL << shift);
>  	}
> 
> --
> 2.34.1
> 


