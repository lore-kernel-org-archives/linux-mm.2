Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C657CD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 14:21:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 11DFB6B0088; Thu, 18 Jun 2026 10:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F6B36B008A; Thu, 18 Jun 2026 10:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00D836B008C; Thu, 18 Jun 2026 10:21:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C2D8D6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 10:21:32 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 33CD8120129
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:21:32 +0000 (UTC)
X-FDA: 84893246424.13.4EFAF62
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf06.hostedemail.com (Postfix) with ESMTP id B1BF1180002
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 14:21:28 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sWlfSJOn;
	spf=pass (imf06.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781792490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L9GEnYG33F17bRUebP70R9oSvlshe6oh8TC7uZQQU+Q=;
	b=3RrPn3wxu8ADjRb1OYOfuM3nA8OVTQyU0Rbq/7gi+Hrs5qgcq/moPT+ChVVgggNpFKrI2C
	vA3wzybuCIzuP8DnBeVYSxBplAqtydTqFgRlyCe3km9PUaahfumWjt7dNN9X3TCqs2WoLE
	V1YmcMD0jFHUbmGNwOBQrLtcALYaWgE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781792490;
	b=HmKGvkW7rjK6Fvg8nfLuAvnjhhYkJShVd+qUnyMJ2EqExGYBhk/myDb0dNp1mlUyMAIygk
	KDEnvhlb3PqDw3ahhWJnP+VFW7dMZ0QRGL1f4isoWx3brWSedXtivxEa2gcivYCvBkZugM
	KfgqzYNu4dZeR2MYgePX74tcNkln1jI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=sWlfSJOn;
	spf=pass (imf06.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE6582A31;
	Thu, 18 Jun 2026 07:21:22 -0700 (PDT)
Received: from [10.1.25.219] (XHFQ2J9959-3.cambridge.arm.com [10.1.25.219])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E2E653F62B;
	Thu, 18 Jun 2026 07:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1781792487; bh=UJvB2cE80ENLkJAysf+TRElR2F2FZEG3i8BWI3trRbs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sWlfSJOn+ZN3AFuGhMupaPTBVGQl78THl7kWB9Qc5De6MyoVUtz9XpHh9KnAiKzg4
	 Y02lLu4SbsrvtwX8WrzRTqxIqiJsCDc+aIE51T47IlccPbJ+fNQ60k821ooOPlS157
	 0OP/izXFX/EO2mnDAhmcuCh0OKsW4NJuJPv/SUf0=
Message-ID: <07ab8b6f-cb58-4f8c-af7e-c99c2fb8933a@arm.com>
Date: Thu, 18 Jun 2026 15:21:24 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 2/6] arm64: mm: allow huge vmap permission adjustments
 with bbml2_no_abort
Content-Language: en-GB
To: =?UTF-8?Q?Adrian_Barna=C5=9B?= <abarnas@google.com>,
 linux-arm-kernel@lists.infradead.org
Cc: linux-mm@kvack.org, Catalin Marinas <catalin.marinas@arm.com>,
 Will Deacon <will@kernel.org>, David Hildenbrand <david@kernel.org>,
 "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Ard Biesheuvel <ardb@kernel.org>, Christoph Lameter <cl@gentwo.org>,
 Yang Shi <yang@os.amperecomputing.com>, Brendan Jackman <jackmanb@google.com>
References: <20260611130144.1385343-1-abarnas@google.com>
 <20260611130144.1385343-3-abarnas@google.com>
From: Ryan Roberts <ryan.roberts@arm.com>
In-Reply-To: <20260611130144.1385343-3-abarnas@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B1BF1180002
X-Stat-Signature: 5nkiyt9w6dwrkr1wnks1bgx1yt7r167e
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1781792488-558238
X-HE-Meta: U2FsdGVkX1/nYw/cbaH81WeCiSKlUPHstZ16Dv59cJKbeT6B2l00Dq5k5HJejWXYs4dVk+GxWjZE95SZMCNT1uUKk8nOWh5Pjlh8HL8O0Ae4jpNz2MZfLlA6LZ2Hxj8a3SUcs/9/FFtmmHdAb0PomvGvjWEdrV0BX405SIiCEVMNZKNInTxGRKTIy9jJR1wKarEUNbWXMoeEbC9sn+/H7LanVOCFrwKmj08QLX3Mp5fOP6bdooDd0y/U6PpjlU21lhGzjiIjpRPjNl0iLLome6N7mLHX9U1W72S5ZY408gOSwk0md3PSF55hiHnJctSCSqSGiGApxxRbvTN/nzAADFBH3He9zZ4kGS/PMMzzePTScL9DBc/4y2NMPpQX0FOc2Zhm0BAyVkJGse52orWoLOcXngPqoeLL/T9bjUX1Xvx+e3KZOkfeN63t61dJmyNllbQL+yCkcUJPWcMgD+Drn44L1U9rm6dcaTmZF+9dMD7OTYD0kWGD2gBk7k6idXaxquWvxduHtxk4b6RJyZCzfqzEfHa03pYbdFDFfX2lCpuHnuZynRDAtI2dJGlkQY6bp/7PPX+gzr9FpU+1AXArG4eSCcJCP61R8Rve2uHvZwOLGmEeWVk0pNJCYZW1yQ265wobxKOf9on8CTWmROXmf4fJP1uVNASWa9an2zfSQVavnd2Nd5giMmIokcz2WMjgMXywXg30EYPhQHo/k3qy73U337/GedlEOz+cxObWXJ9c3pHoLI3oJwVO3yuqaZup4jYGRESgzXBlaV8Y14O2Em69tgUxP3mphsTP9l2xRiXoRw8b5cX624KzP6DNdX6X3ksCD0jnXHDmLAlrre7iqZx+RndhUtnFMikHNDceL4r/V3nyVQ8dVI9z0WkV0hccTmWn+apzKBuAu/N5HzHubJecjAT/I8upFtRw9xY582bHFCHidLhS9dxyeRZjYTMyIRpGg1WHXlW9PMJPSVT
 d6qeAhIe
 8abGPDfC7GPqtFg1OSLBE2qTeuPOJmdh9JQbNSDmPoJPblHjqJEUCtk+0XC1Es6dDF8gZk8gYcfhckUw3GqSAHQ7CqB8QWBzTCjTKfe3wecSvV9t2V3lhxJI5hcadNgOmjzHQWW8ly23PbQ1rJ+GAl6gyRQu716lmib2/79Jfz2ncKLzEp6znswmDJdMo98khikDWNA2QqryCsfODXIuNAcRftJfXR5uCQuPIaQwXF/AyCV/0cqLfMzYR+FLsJIKdFIgpy/ZPll9CqIh9bHfEs97NrKpBVZ3opM+oX9lfH5OfaBJ6Cwvj2xEopsAkbiekWQ1/+SR5bn/0Rf/l+eq7bi+MYWmIaynLfkIJ+/sQbLYRsYhc36Vo1+Yjsa2D6qg1/JmDynKIM7PSkD8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/06/2026 14:01, Adrian Barnaś wrote:
> Remove the protection against huge vmap permission adjustments on
> systems that support the bbml2_no_abort CPU feature.
> 
> Splitting live kernel VA section mappings into page mappings was
> restricted because it could cause TLB Conflict Aborts. This forced
> permission adjustments on memory allocated with VM_ALLOW_HUGE_VMAP to be
> rejected, resulting in performance drops (e.g., when enforcing rodata=on
> disables huge mappings).
> 
> The bbml2_no_abort feature (which mirrors the architectural guarantees of
> FEAT_BBML3) ensures that changing between table and block sizes without
> following a break-before-make sequence will not generate a TLB Conflict
> Abort. This hardware guarantee makes it safe to allow dynamic permission
> adjustments on huge vmap regions.

FYI Linu Cherian has a series that renames bbml2_no_abort to bbml3. I think he's
planning to post at -rc1. Would be good to rebase this on top once merged.

> 
> Signed-off-by: Adrian Barnaś <abarnas@google.com>
> ---
>  arch/arm64/mm/pageattr.c | 22 ++++++++++++++--------
>  1 file changed, 14 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/arm64/mm/pageattr.c b/arch/arm64/mm/pageattr.c
> index 358d1dc9a576..88720bbba892 100644
> --- a/arch/arm64/mm/pageattr.c
> +++ b/arch/arm64/mm/pageattr.c
> @@ -157,23 +157,29 @@ static int change_memory_common(unsigned long addr, int numpages,
>  	}
>  
>  	/*
> -	 * Kernel VA mappings are always live, and splitting live section
> -	 * mappings into page mappings may cause TLB conflicts. This means
> -	 * we have to ensure that changing the permission bits of the range
> -	 * we are operating on does not result in such splitting.
> -	 *
>  	 * Let's restrict ourselves to mappings created by vmalloc (or vmap).
> -	 * Disallow VM_ALLOW_HUGE_VMAP mappings to guarantee that only page
> -	 * mappings are updated and splitting is never needed.
>  	 *
>  	 * So check whether the [addr, addr + size) interval is entirely
>  	 * covered by precisely one VM area that has the VM_ALLOC flag set.
>  	 */
>  	area = find_vm_area((void *)addr);
> +
>  	if (!area ||
>  	    ((unsigned long)kasan_reset_tag((void *)end) >
>  	     (unsigned long)kasan_reset_tag(area->addr) + area->size) ||
> -	    ((area->flags & (VM_ALLOC | VM_ALLOW_HUGE_VMAP)) != VM_ALLOC))
> +	    !(area->flags & VM_ALLOC))
> +		return -EINVAL;
> +
> +	/*
> +	 * Kernel VA mappings are always live, and splitting live section
> +	 * mappings into page mappings may cause TLB conflicts if bbml2_noabort
> +	 * is not present.
> +	 *
> +	 * While bbml2_noabort is not present disallow VM_ALLOW_HUGE_VMAP mappings
> +	 * to guarantee that only page mappings are updated and splitting is not
> +	 * needed.
> +	 */
> +	if (!system_supports_bbml2_noabort() && (area->flags & (VM_ALLOW_HUGE_VMAP)))

nit: no need for the parentheses around VM_ALLOW_HUGE_VMAP.

With that:

Reviewed-by: Ryan Roberts <ryan.roberts@arm.com>

>  		return -EINVAL;
>  
>  	if (!numpages)


