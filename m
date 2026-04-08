Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A455DFD5F79
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 10:32:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96BB46B0088; Wed,  8 Apr 2026 06:32:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 91C806B0089; Wed,  8 Apr 2026 06:32:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 832636B008A; Wed,  8 Apr 2026 06:32:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 74C5B6B0088
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 06:32:33 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A53E7140A84
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:32:32 +0000 (UTC)
X-FDA: 84635024544.29.A73299C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 990CBA0011
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 10:32:30 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rxbWcZha;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775644351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pjJjA92jpppGzeBaX6wdEfL4GdFW8B7teHooqHk/f1Q=;
	b=a2TrfRHOkBb0kK+JRdCyhc3ujfk/DKQDRPpAzbIWE1Di2nM+MdB/PvxOrPS+EhC4KvjbVZ
	tiNsVJ1JrMICGntCdP6gwztvJ7pILm0QdOKDitkMEGNGY7hM2BMp/C1BjZlR/U0/fT4bS0
	qkMb3w72rraQCLt9VwxUOsTrkJ1k6GI=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=rxbWcZha;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775644351; a=rsa-sha256;
	cv=none;
	b=cSe7UkdJJD/a+N79rncdQngZIsSpoPMJf5pUInRCeB34FVrbqCBQsXP6Y4FUdZW1RsFD2m
	v4QNEACvcbbf5lBgE8T1UZEH6MDh76EzOSY9U812mlOHRkym2MlhEsKjYJNIs+CE9PyFR9
	YQ9zYOaOMJkMfAd9d4Hl7WwFAyTSlIE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id C30BD3161;
	Wed,  8 Apr 2026 03:32:23 -0700 (PDT)
Received: from [10.164.148.132] (unknown [10.164.148.132])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id D3D353F632;
	Wed,  8 Apr 2026 03:32:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1775644349; bh=35dZI7XO1PuiJnOPWLTJBYXPR5BzBRQMTO9NszVmMig=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=rxbWcZha44mxHubats2n644JcLuCJ2t6+aYwy3oEEKRUt585T1ypA4Zhmn6pH8tOh
	 NNizpDyFqVP89fY0uUhdFLY/E1hRXIFOiUJ0CWwbEZt/ipRNyeKL1dh1SllxAlwxnC
	 HVDu6czp/sLowr29z8aNI93SI/T5IsMynfnKbAmQ=
Message-ID: <02b0464a-13f6-4e0c-ad69-0f494bfacbf4@arm.com>
Date: Wed, 8 Apr 2026 16:02:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 1/8] arm64/hugetlb: Extend batching of multiple
 CONT_PTE in a single PTE setup
To: "Barry Song (Xiaomi)" <baohua@kernel.org>, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, catalin.marinas@arm.com,
 will@kernel.org, akpm@linux-foundation.org, urezki@gmail.com
Cc: linux-kernel@vger.kernel.org, anshuman.khandual@arm.com,
 ryan.roberts@arm.com, ajd@linux.ibm.com, rppt@kernel.org, david@kernel.org,
 Xueyuan.chen21@gmail.com
References: <20260408025115.27368-1-baohua@kernel.org>
 <20260408025115.27368-2-baohua@kernel.org>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20260408025115.27368-2-baohua@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 990CBA0011
X-Stat-Signature: gs8u6b36s77b189596y4khbdkuzn4x47
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1775644350-257106
X-HE-Meta: U2FsdGVkX188GC4hriPmwr1Uu5WDdDSRyiLVN2jr0ExhCsAwOAND0E+eSQ4ayaUi1zj3JkKsdxEkac9C7ZfTS4PmRLv8Hq/pzQIZAUvB3eVwCk0YVtoMoLxbR6KzH+4ywEFgsL1/vi9oN6kWk3cu+fzDxCSMfzysGrjMRf+R1AcNLvqRIV/4QyETuT7ge2s0P3sKkbHsb1Fdnwfaios1uxXASx+9itldy8YdyrYVguOxl0rm+7Q5h6OxRALX676crkhj0aPkMqdxIfluoOQHpxsbZAWw2E4zI6Lwyw+o8qc552eaGREPrJ+jiN9Yk+oOQOa4UO3vF90FU0jgHxivSzTrOmTN0r31DIVoK1pSkUpxgt28duT4jEBsQc2JR/uz6hyyW80DHohq6uemTvaz7nXLZaveXAqnZDrxDMeo7Wm2qHzXjEZDEzb/axWrGnkGop89wEFQBAAF9zLnS9Z+sCrLer0yHyXfN4rd9zvCzIrrmF+7/xtC5MF28Lxs+cA+V+NAs6I4kd57by23TLxXyj3MczlJFOvEEBsXMc0n4IVrKsYNvQ9yxt0+bWk7bQaAYg1wjWDZiXXEPpZnLBgLyoCcPCZA9oxi3RhSnHvWFi0EHbq76O5uuYy/+XnH6ztpL0ivojLSiM374pm3MZPJjh+weav+vJ+YpHisrgi+VrnQu1ASnbnhvxIjcWCRv62PBAslEa+Pjvpo35YtXUgq3ceLEudEugqTlk+lWwjANZaqdpg3od+ub0eZQDXjCHNeRvwgqwM7KWf1rxQXPjsMUN1qqnxDLaihKFDme5nlI3aCGRUDPbpw2rgOE6BVnaZfDjbyHWvno/DOifeKJxu7zj1lRXrfF/X7PI58gFXgU6e9UyMmnnFRs41DLMJ8dm6YA/Ijo5LLRNuR7THhtqKAzGK94pnpCV5ullosn0JEIkre9bqZkLZykhnzoERYJOUpy6RKGv+cbfYm74PgYHO
 vBvp6lwT
 DusDu7uTp31dfD2Aadf+6y/uDKqKFtIgE48NgNhhOr4L2nF2lgEQ9X6Vk1/KMG2MMn3CFZlp8mvLuATCTjwgm5qmXNXh7axQCA/JO9Ky+hKkSycPCYjFFReJwo1ccAdTHs3PF3P/pUt2Eh6Ns0feojqVHZ6MmgaBmgVVFZ6ND7bqM5Qh6bWZzMJMARqcZajyhls6IJGhsQri+oHpKwen9/Boe06FZgX0OkUkgqS34+32m3xLLxi91x2KP4/LkwCGDYWVaa9y895c+Ou6YO4/Ior6H0c2xCLU5vieMwPVy57TC8/6WDl8ARj19mYdiONfej3/5Bx3/B4k6u3jJUkzKmK8XbYWSGSRY2M22ZpOZOi9E1E88ax1IUyLo5B5+yfOpCJyBJp6JNr49GLwZIpWA9YxvbaVyqI7MCK5u
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/04/26 8:21 am, Barry Song (Xiaomi) wrote:
> For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
> we can batch CONT_PTE settings instead of handling them individually.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  arch/arm64/mm/hugetlbpage.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index a42c05cf5640..bf31c11ebd3b 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -110,6 +110,12 @@ static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
>  		contig_ptes = CONT_PTES;
>  		break;
>  	default:
> +		if (size < CONT_PMD_SIZE && size > 0 &&
> +				IS_ALIGNED(size, CONT_PTE_SIZE)) {

Nit: Having the lower bound check before upper bound is natural to
read, so this should be size > 0 && size < CONT_PMD_SIZE (i.e written
the other way around).

Also IS_ALIGNED needs to go below size.


> +			contig_ptes = size >> PAGE_SHIFT;
> +			*pgsize = PAGE_SIZE;
> +			break;
> +		}
>  		WARN_ON(!__hugetlb_valid_size(size));
>  	}
>  
> @@ -359,6 +365,10 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
>  	case CONT_PTE_SIZE:
>  		return pte_mkcont(entry);
>  	default:
> +		if (pagesize < CONT_PMD_SIZE && pagesize > 0 &&
> +				IS_ALIGNED(pagesize, CONT_PTE_SIZE))
> +			return pte_mkcont(entry);
> +
>  		break;
>  	}
>  	pr_warn("%s: unrecognized huge page size 0x%lx\n",


