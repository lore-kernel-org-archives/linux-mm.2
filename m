Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7024C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 05:34:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36AC96B0005; Mon, 29 Jun 2026 01:34:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31BA46B0088; Mon, 29 Jun 2026 01:34:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20B0E6B008A; Mon, 29 Jun 2026 01:34:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 013C36B0005
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 01:34:19 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5ACBB120531
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:34:19 +0000 (UTC)
X-FDA: 84931834638.20.BA7DDF0
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5BDE5C0007
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 05:34:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Liaht61i;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782711257;
	b=tumjODAjwiaLXYHOfxGDpQU2bgnfOwAKSQeRluKHWaEIlD5NA6szsqvVWC5OWKfUM0DRPG
	7MnkjVuH86ACW7QDDNSfnWen8yVVBsH0+hgh+huWyFa4pqD8g8v4Y7Rrcyz82R/knsTHa+
	84pp30egfX2V2Xgq67l/DWDi9Q5rzhs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782711257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+KOHg6u/2xTJsrzKq2SXqbZKogi4gML0VvKTiWUZ+Y4=;
	b=IunD93b/ZeVLBo7jzQ0JaNGW9u+KCGx0mOBx3+/LZARSbIopmlb3oVkPbaCkMpFiKbGf06
	gYA5jFfbf+eXpHEAYbMvT4tKsJcLWPBGCd/FPueTFkI2xhu1mgWvQA+9S09lppCT/DZL4/
	12ckjZYgVfqxBy7aEZlNQNrKa6cASU4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=Liaht61i;
	spf=pass (imf10.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C94D71A2D;
	Sun, 28 Jun 2026 22:34:11 -0700 (PDT)
Received: from [10.164.19.15] (unknown [10.164.19.15])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id EBC1B3F836;
	Sun, 28 Jun 2026 22:34:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1782711256; bh=a86f8R4t+fLWwdQI0IgFLXsc0PI99dNs9xJPvkEy//M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Liaht61iOTcEOGbuAo7kQgdPOulUm68gQ1rGBf1CiX6T62Vbs4U/kRTa91X9IbaH9
	 pMujISxup9Dhkr5Lra9KRo0/uaUOzDcxazn3eOYj5aYMffHQ68077Vfoh2P0QVHHTF
	 bQWVYP1ScOX0/N405atZRUOj8Oxz40uoya7QKXhU=
Message-ID: <8ed36f5b-7421-4dcc-9ea1-29e8f0f15824@arm.com>
Date: Mon, 29 Jun 2026 11:04:09 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 1/6] arm64/hugetlb: Extend batching of multiple
 CONT_PTE in a single PTE setup
To: Wen Jiang <jiangwenxiaomi@gmail.com>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: baohua@kernel.org, Xueyuan.chen21@gmail.com, rppt@kernel.org,
 david@kernel.org, ryan.roberts@arm.com, anshuman.khandual@arm.com,
 ajd@linux.ibm.com, linux-kernel@vger.kernel.org, jiangwen6@xiaomi.com,
 shanghaoqiang@xiaomi.com
References: <20260618084726.1070022-1-jiangwen6@xiaomi.com>
 <20260618084726.1070022-2-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260618084726.1070022-2-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 5BDE5C0007
X-Stat-Signature: zd4g8g1cywr5f1d663ug6c6sahnr5574
X-HE-Tag: 1782711257-151611
X-HE-Meta: U2FsdGVkX18qwDcSnjXR1rcSO7bmCfauRnjSx6OrlgZWkheZaJ3qUrBwzeE7WzsOhfy0Q3NFOYpXJp3OzZXg3iib0zMT67Q0yOk0HxHr0q7/HCe9cBfPhiyMUT/vXTi9d1knif/OXBP/KTXrGjCWXCqaz17WTeNxeuG43+cNRzL9DG3VYTWQKqoJZc9PApIhd69CsIl3y8AxIEKLxQJAxuJ3lXTR0ehO0HXTaDm1RtYtkVA0ZJC/U6fQLuRjcR6NBWHd35pVh5FQZCMFgqAj9S0QuKl0h8TvxLe5/wZKGrAJZGyYDk9TTJlGpZ3KL/AWYgXVcfyEDqjxHCtsm7OhUZq7wh+/HWdKAhM8UlXZ8AJ/VXtqTMI03hqqP0K1eVY5Jeph2QwuYJU066vL6io/ss/vTeHNZ4WqUSwLHHHx5TlFGHYsvtlUZONrMktn4GQ9XyRdANiHbNKzatvUNVF7MF7GLEPtc5DPTzcebIMf6/hiMaAnXl0WKQYv7U6yNzV+gX6OKyEwYbioa1amSNDSMXmr1Ig+6Do3xRczClOd5sAu9WNj0NzdccCyErV0KmPcnYNOhrUQPqW6kJPp5Dwa9F3/S9rVLeN+QS3LlYB3NYyAt6ltexoWVDZes+jAhcBmyGf2W1HEEdHn579zG21hYDNQAQJ7o3q2gd/fiUSrgza3r6e7Hs0/M9n2+Bjh7XHQDS+PKgwYJsTWC+c3Zen48Ju4UjzfS6Ao36viR3nJLSYX4OdLAM0GAgnQ2ZynrWtbSJ2Y4PqAo8OfBJNrlPEtvxyBo3+CSrLFEZxZWRNu+C0+00yWu0pwUS1JlQSA2Nl8jGHlyLwe6Vyn/CoSyWEe0VmMu01wbkeFhc5DtGeYgPvykbceFuP6CqIyQRpneeTzVik6j3s3gcXEHzX12a6GG+RohPaL0TvyzP/VRwO2xlG1f+eqpoZGM0iMHsbB7bQWlhxtlDwtQyNabf2GE2g
 GvNnVNHj
 VNEjwfq1hB49AtEQOM2Aze6199npRKMXxisrLP2azQnS86hmbrXocUtVs4miGufyxhNR7QKvoj3dsQ9QfYTyb+XHUKu8a3w+3PUKvgVKxvfGgSZd1DfIDspv2QiraNoaEOAXk4B6m5l5FfPfeSRnwVOLWvutIGKt+ne/haOKGGDGj2lucMQ21BsexmzacfOMB2cMFE+4Jztq05zAHM8EynmY7Zmv+/leHXK9+4O6ZIT3FHAXVL4YaNXgISWwSefltY9KgzvcBY6Fl60WtGOnVaT0u71HY11kaQirzhlwl4qSSf58cT/YJYh3A/VifK3jnkDczzh1HIMC40DXeHyv6TvEt0scelBBH6PXIedjdwM8cLzpQ0Dj2yFeeeslIevbjqwkwlht+Od8yfQtM3njQCoZ7FfHAxVXT+YDIGiMk+gMFPOxrky4hecL46sfGnm/XeX5aHsJbbSi+x50jOQiKQokXtOA0vODrvK/IXbIhwHDD0C4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 18/06/26 2:17 pm, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
> we can handle CONT_PTE_SIZE groups together.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> ---
>  arch/arm64/mm/hugetlbpage.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index a42c05cf56408..c4d8b226126cb 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -110,6 +110,12 @@ static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
>  		contig_ptes = CONT_PTES;
>  		break;
>  	default:
> +		if (size > 0 && size < PMD_SIZE &&
> +				IS_ALIGNED(size, CONT_PTE_SIZE)) {
> +			contig_ptes = size >> PAGE_SHIFT;
> +			*pgsize = PAGE_SIZE;

Nit: *pgsize update can go before contig_ptes, to keep the pattern elsewhere.

Reviewed-by: Dev Jain <dev.jain@arm.com>



> +			break;
> +		}
>  		WARN_ON(!__hugetlb_valid_size(size));
>  	}
>  
> @@ -359,6 +365,10 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
>  	case CONT_PTE_SIZE:
>  		return pte_mkcont(entry);
>  	default:
> +		if (pagesize > 0 && pagesize < PMD_SIZE &&
> +				IS_ALIGNED(pagesize, CONT_PTE_SIZE))
> +			return pte_mkcont(entry);
> +
>  		break;
>  	}
>  	pr_warn("%s: unrecognized huge page size 0x%lx\n",


