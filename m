Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD4ECAC5B8
	for <linux-mm@archiver.kernel.org>; Fri, 26 Sep 2025 15:27:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32DFB8E000F; Fri, 26 Sep 2025 11:27:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 305868E0001; Fri, 26 Sep 2025 11:27:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21B3A8E000F; Fri, 26 Sep 2025 11:27:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0E4B58E0001
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 11:27:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A6E6DBB23B
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:27:31 +0000 (UTC)
X-FDA: 83931780702.12.C8515BE
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9336D100014
	for <linux-mm@kvack.org>; Fri, 26 Sep 2025 15:27:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SUu5EA1Z;
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758900449;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+rHEB641cb2GdpF/5/rE3pgDEs3o5nOg8UBPvdo7xdA=;
	b=Rpa85w5cvNEFxev/IgD/iZF8JIU1Jn0/PJO8n4WqTwG7UmGtVd3LMBAdHTSAgilv5iAEHz
	Jffo8plwVauDIl9lw1r1BZliiQtBIeapiLw4tQlBc8Kpf4vGTcfWzs10BnANhl8CDORruo
	fYCDaLOEraTywPOtlbocflVNXGVVXgo=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758900449; a=rsa-sha256;
	cv=none;
	b=DmlsosgxnIVwm8DTRbkd56vPsdIKRa2XzsKrss2+BrGYdi5h1sMzn29gQ1ObJQqL7mwcV/
	vUdArZtDwYWjUfj4VZAla7coARLXJ3OAXaaWu4Gi4bnyEMuKn1K2Bdb6aB1+qJI+iqW0RP
	xsUlVzVjFKbID80wzRbFEltfeGd9p74=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=SUu5EA1Z;
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3ef166e625aso1836090f8f.2
        for <linux-mm@kvack.org>; Fri, 26 Sep 2025 08:27:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758900448; x=1759505248; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+rHEB641cb2GdpF/5/rE3pgDEs3o5nOg8UBPvdo7xdA=;
        b=SUu5EA1Z4w47+vWWSXZ0u2swZftU8WyJdImmapvYa6WtVL9HI7WnMA/kBenUpPTc2M
         8emJRQNEav5qIvR8GwkjiEOtz/WoU12a9ECyWurV34vMBSU/UtcmCzdXv4NdCLiYCcPA
         ISA7b0nJ9xH+E6Z6H/UEezTfbc5Qe9MTovu+GCoInBy6Rep3iSBWwMZ2hDc6ghzfupnN
         JkdT9tXI2du1twM8ENFtMqVTRXb1fu2bcMEBp68/pPNoZu2ScfuX1KBr1+fYvIRL+VBA
         UNeZhmq0YxrejqQxl5Ge9Xsli0d0F4qGmt/PQaZ4Rx7yUlZ79u9nK+7/xHtBj9ym9kji
         l1Lw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758900448; x=1759505248;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+rHEB641cb2GdpF/5/rE3pgDEs3o5nOg8UBPvdo7xdA=;
        b=UFYxz7oC6wMO+v3cP2Vaoxk6ERlzkz2xUeP56LTgPTX4xBPvuiiCItnHRNLAQfyvAR
         ErB78PPC4AlxwL/2X4FhlwGOJFQkdV604hUijkhAfw7dWZh9L5oVmhhSW/z6PnuRhOp4
         raVOFd/7jvvvW7lrqhyJ0yo9JoiIm/locEnUSj5KElu3XKm2M4FabNXhO0fuJ74clkcy
         mqnpHDCL8vIEmauUC8JOk83E9yBFZd9yZP6UXxCzKABpKRMtEcrOdgIHaEKqPKUsa29n
         T0bDDfWWYdgfsIdTxuI4VdzJOWHsoI/VbucQmblNdjvBVvIFbSLOhSu+XyoqD0Yk00XJ
         V92w==
X-Forwarded-Encrypted: i=1; AJvYcCVGyhkC2xxnkCweKTj4bXcWUhtIzaTe0dHdhCe+fOMzkAN85gdO2TX1a/bvGDSDn4k8KgluRJQ7tg==@kvack.org
X-Gm-Message-State: AOJu0YwAAcTVFGtJ8YPqEzjsIk/5xIaZvSkSsGSvUCH1RjgH6SwD0+u5
	n1t8UcM1wbkyL24mKVITQM71YcCowhtlPPrOmGZMHmM4tFD7WWQSK1Bz
X-Gm-Gg: ASbGncs6SXKMObYNYsaiyzojPKxH33foBFEL0vdlbEVRBF69jE7Mhd8po2Y+7dA8Dy0
	LE8SRBg3JPfp9lvqOmTg+gLV8V6r3KLIrxTenFEXUBcmkMgxK3Vva57EUD2PWVz2t/iwvPgafBc
	dyza/E5GX8K+FeDxIdND8BFL2xv+MrZyQxOsiTEBsJzV1prOgF9XAZUF9QWhTe2m5jVbTAV/LWl
	rJN1wlePq/d8o2thZcxutdxz9uxQ9F3RQSbkNVo5N3tIbgX1cKkMWTrieZHSFVdjALAH1t5Y76u
	B0OH6oPjl0CH02T54U/DO9DHrxKAXjodhpqWAedZurx8gBA16TG60GWEWDm9nrpsjZBWDOOZe5V
	SuqwjaJYyOlxja+drK2+HJIqb9k2fjDrhC4/DF50+TRT0mkYveeZUaHEHrvNUaDDTTM4fy0BGM4
	LjyG0KTturM42flH/s35GdS5vjMLBI6Q9STZ8r1i0=
X-Google-Smtp-Source: AGHT+IHukc9PAc+ShA0a1/5BNvNstWVE/VpbllBdChFZdr1gLStyH3EQxZd0GUyYSjGKV5ErWMc6Vg==
X-Received: by 2002:a05:6000:240c:b0:3dc:1473:18bd with SMTP id ffacd0b85a97d-40e497c348dmr6881945f8f.3.1758900447759;
        Fri, 26 Sep 2025 08:27:27 -0700 (PDT)
Received: from ?IPV6:2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5? ([2a02:6b6f:e750:1b00:1cfc:9209:4810:3ae5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-40fb871d051sm7634404f8f.14.2025.09.26.08.27.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Sep 2025 08:27:26 -0700 (PDT)
Message-ID: <035a8839-c786-45b6-8458-87ac1c48f3bc@gmail.com>
Date: Fri, 26 Sep 2025 16:27:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 mm-new 06/12] mm: thp: enable THP allocation
 exclusively through khugepaged
Content-Language: en-GB
To: Yafang Shao <laoar.shao@gmail.com>, akpm@linux-foundation.org,
 david@redhat.com, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, hannes@cmpxchg.org,
 gutierrez.asier@huawei-partners.com, willy@infradead.org, ast@kernel.org,
 daniel@iogearbox.net, andrii@kernel.org, ameryhung@gmail.com,
 rientjes@google.com, corbet@lwn.net, 21cnbao@gmail.com,
 shakeel.butt@linux.dev, tj@kernel.org, lance.yang@linux.dev
Cc: bpf@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20250926093343.1000-1-laoar.shao@gmail.com>
 <20250926093343.1000-7-laoar.shao@gmail.com>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20250926093343.1000-7-laoar.shao@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 9336D100014
X-Stat-Signature: 8fcgysqtqne8xbx6g6kbjgfxyie98468
X-Rspam-User: 
X-HE-Tag: 1758900449-722603
X-HE-Meta: U2FsdGVkX1++OtBmF2b/1PG1VIAo1wA27HGT7vilDoF532vQPaDs7Gla9oaLcf3HG1p66MhxUsbe9C02sPVxdd9MEWNLKviVNBvpEuV0cxWrp78TSTIOWap9yllDVJA+Z3l1BTRVUMQlgbvcJUDm6Hb0dR2XGRUDFBzVKxzPmqc15mCJ3wtySgtOZonnqu8V6kMMXMGHsl1o7cTr5goC6sfe8uRqUvZWLmqDUh3x7PqzYVbS/VHyaQpO0qGjQowyL3OsOobHiOCuMPRrjRcYp7wswEk9W2Bh36NgzSUJcPORq/kOLDcb6pk0bGMgmxkt+fTiFoBP3pq2edauwAwicWY8a8L/1MoqdlBXZivtvH8XWbMZ0dbuUkwAY/r7GVoWCdyGxM60VE/oqkeXbH+7YlGl2Oz8mC3ZBaRUXo6iv7ubm+qGV/wI6ODIsckJNaYl7EfrgPKiKHAMxWH0EtSfhmWy7U0YqurQEfhZCtwaZnM/x6hwoCR8KLgWpkGhWqEC5BfC9EtyC7gIwwlRKLOMQWGLDEr2R6LoW5q+i2SW7qyacumzIdIkeQPikarFdwL/AMZABXf7ME8R/IFJ4C4bMi22HFXGRPEi+84wIXn73Wr3i8n54ymq6N7apZZmNGpy/BVMVEUHSBTJsTjyV42c5uF9IFvA67hgwAIfDhFCBvmMsf1LazLouIwxUM0cDrQH/sXCdf5teQ2PEACtZTux0r8sgstu66SC5qjibHCWzdsrTZcs1/ATNrPk7A18bZkBQdvzDN3XnvzMrh6XF0ZcnagBGQLAJlJT+eoXpvlZHCobWOdPdvZHn7JQJChuBdUu0mhrLEWLhUS/BFBztFBUsvIa77FK6URk4ZIVP6B7LQ02sM4ut7Oyi8nLs48dQUfglAxOYAsfEjJVkCi2J/EOL3LsycDkPeC4ywNGmrxLKIX6snlWjUeQlipdWuEfOS7U/EjQtr69Cln6+2h370Y
 g4oLy8UI
 n8dMuGM3I+qdMu8bNOJWNUlExwo964AvhR9qja+5qTR1exZKSfaTJVGM1kOvUEONuhAiCWKHEUU91L+jJyKutuC5oBh7HPEa9mY6ugFopQe6km9SGfA5iGVsz2YNSePfS79vrDcRMKlArToBVQQczFZJZPEeLyW5KMbLlR69sB3/WOYCmbg//ppxzWD20m9etTc9MJUVXrjA76j4f+F2SIHg9muYabXR+7RJMoTkrIEpHK3ND/CqfZPIVcnLzwhHqCtzzJfpGqjLW6LtnvVum3/Df9wNaV59v8rWDUUA6fC4rxTXphKEm9PSAN3OTFOQhWn1sdtbIKkn+LYZa6SCXX/0fsIS+nzCyJtOrHzsvxYIa9PWn8o7O3GbB/r5JwjW5AICLZh4HZirH0QaM0Em3BMUVtqx3qnqG3EuTqwzv0V6UCRq2Z+FHsjBS5Qud1znN8x1Nfacg3BTvX8n5oRu0e+qhEpK/GTiD9uWPsAB5NfqjW0B898hSaQeukuFEQl4TRF3OTNZnobooDnGxJe9iN+FJuVtoABgRH9V3qES5h4viNhFJObTHq+M1YQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 26/09/2025 10:33, Yafang Shao wrote:
> khugepaged_enter_vma() ultimately invokes any attached BPF function with
> the TVA_KHUGEPAGED flag set when determining whether or not to enable
> khugepaged THP for a freshly faulted in VMA.
> 
> Currently, on fault, we invoke this in do_huge_pmd_anonymous_page(), as
> invoked by create_huge_pmd() and only when we have already checked to
> see if an allowable TVA_PAGEFAULT order is specified.
> 
> Since we might want to disallow THP on fault-in but allow it via
> khugepaged, we move things around so we always attempt to enter
> khugepaged upon fault.
> 
> This change is safe because:
> - the checks for thp_vma_allowable_order(TVA_KHUGEPAGED) and
>   thp_vma_allowable_order(TVA_PAGEFAULT) are functionally equivalent

hmm I dont think this is the case. __thp_vma_allowable_orders
deals with TVA_PAGEFAULT (in_pf) differently from TVA_KHUGEPAGED.

> - khugepaged operates at the MM level rather than per-VMA. The THP
>   allocation might fail during page faults due to transient conditions
>   (e.g., memory pressure), it is safe to add this MM to khugepaged for
>   subsequent defragmentation.
> 
> While we could also extend prctl() to utilize this new policy, such a
> change would require a uAPI modification to PR_SET_THP_DISABLE.
> 
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Acked-by: Lance Yang <lance.yang@linux.dev>
> ---
>  mm/huge_memory.c |  1 -
>  mm/memory.c      | 13 ++++++++-----
>  2 files changed, 8 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 08372dfcb41a..2b155a734c78 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1346,7 +1346,6 @@ vm_fault_t do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>  	ret = vmf_anon_prepare(vmf);
>  	if (ret)
>  		return ret;
> -	khugepaged_enter_vma(vma);
>  
>  	if (!(vmf->flags & FAULT_FLAG_WRITE) &&
>  			!mm_forbids_zeropage(vma->vm_mm) &&
> diff --git a/mm/memory.c b/mm/memory.c
> index 58ea0f93f79e..64f91191ffff 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6327,11 +6327,14 @@ static vm_fault_t __handle_mm_fault(struct vm_area_struct *vma,
>  	if (pud_trans_unstable(vmf.pud))
>  		goto retry_pud;
>  
> -	if (pmd_none(*vmf.pmd) &&
> -	    thp_vma_allowable_order(vma, TVA_PAGEFAULT, PMD_ORDER)) {
> -		ret = create_huge_pmd(&vmf);
> -		if (!(ret & VM_FAULT_FALLBACK))
> -			return ret;
> +	if (pmd_none(*vmf.pmd)) {
> +		if (vma_is_anonymous(vma))
> +			khugepaged_enter_vma(vma);
> +		if (thp_vma_allowable_order(vma, TVA_PAGEFAULT, PMD_ORDER)) {
> +			ret = create_huge_pmd(&vmf);
> +			if (!(ret & VM_FAULT_FALLBACK))
> +				return ret;
> +		}
>  	} else {
>  		vmf.orig_pmd = pmdp_get_lockless(vmf.pmd);
>  


