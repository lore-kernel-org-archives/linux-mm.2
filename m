Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44670CC6B29
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 08:08:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BB616B0088; Wed, 14 Oct 2026 04:08:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 545126B0095; Wed, 14 Oct 2026 04:08:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 40D196B0098; Wed, 14 Oct 2026 04:08:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D45B6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 04:08:02 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ADDB81C22D6
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:08:01 +0000 (UTC)
X-FDA: 85320503562.26.43E2722
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id B004F40004
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 08:07:59 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D36suGID;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791965280;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YZHQeVBPNU6rc5illaISM5DptVONwmd53i/boebMGqQ=;
	b=G/HBTvWBR2vTBcm3ZiHbeYKU7hIuOfF1NURdQugQjRewa5dXhe5Pt9Eyr9jXQW8WEm5FyZ
	SwgnMbqsAv4r9xAGEEI6cQOj5FJ7c+EMyV3IZAMPclyTcNegia/K6mj8jnqVbO0wZy/fJ6
	vxDy8r5QQ0VIUkLKSsXALUBhBFZdbDI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=D36suGID;
	spf=pass (imf04.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791965280;
	b=w3esds40A2vYrv55Y5ch2VHHi8gdE3854VbJh+TTAN9615W2XJfI53NeLCmv2RdduYxW/K
	hxYmacDYoiCeTJKYEXax0TE+IYdjdRS7LOaEJqT5Vxl3tQp97/9j6z8c8u5NdAil+kjvVM
	+hYTJDqiF+uH9Zh3ozpYcgCumtJAmxQ=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 56E2F1576;
	Wed, 14 Oct 2026 01:07:55 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 28C6B3F7B4;
	Wed, 14 Oct 2026 01:07:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791965278; bh=MUie6VSnW5OquybNhX7YpynpIviFja/SPKRkeO/X0wM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=D36suGIDWLUtoLdWoMaoApXTyWb2dzsEOXw/86kfMa+KgI93jY3cyZhzJ4faej4Sh
	 JoeimUdc+OnzEu/p97k/KVlKyD++ribIOtPYH/XLmQ5DbwSBE4LVzCjncH4gY/3l/L
	 763i0DKSevsHZIg/cPifkmIZayELI65poLThF0W0=
Message-ID: <1a34d980-4520-464a-b8d9-7720136bdacf@arm.com>
Date: Wed, 14 Oct 2026 13:37:50 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 04/10] arm64/hugetlb: drop the init_mm special case in
 clear_flush()
To: Wen Jiang <jiangwenxiaomi@gmail.com>, akpm@linux-foundation.org,
 catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com,
 will@kernel.org
Cc: Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, anshuman.khandual@arm.com,
 baohua@kernel.org, chleroy@kernel.org, david@kernel.org,
 jiangwen6@xiaomi.com, leo.yan@arm.com, linux-arm-kernel@lists.infradead.org,
 linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
 maddy@linux.ibm.com, mpe@ellerman.id.au, npiggin@gmail.com, rppt@kernel.org,
 ryan.roberts@arm.com
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
 <20261002090947.869220-5-jiangwen6@xiaomi.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20261002090947.869220-5-jiangwen6@xiaomi.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: B004F40004
X-Rspam-User: 
X-Stat-Signature: 9qg171j9fesmtf5oeyjpdak3bdxnjcbh
X-HE-Tag: 1791965279-341538
X-HE-Meta: U2FsdGVkX1/oBdIxoQ/FxTSsK8I6C85Ha2EMVumaA6VXPkps8llLkgYCRKCeHvEz0GJ1suNX1okXWI/vaC2vuKNLKBDxtdduHOTP2REa99iilfwEHPAuPAxsoHM50e8YI5aRLuZr+TgRBxJl97s7W2BvUwB2sNuf1RTwu77y5uHN3oOoQK1ETBhJLDFUXOj/y7x56ZT5wkL4KbdzwId/BLw7MefsIt8yjG2V+KBdUYvKnJgxr/U6WTPlatnK1G9zJ4uIJzOlgF2fhfKBXlujj5GuVVKBOvEsMEoeaE1RSLAkRNnIQO293jbTArqZITJFP8xUV4vfv2EN2eivRy7tyCPvKJI1M6Upmg1olDiEdid0Gu3enJwIWJolHTmEIQSsJ66GUe5n16iBNy+Fk21Hx4QbjZqzwevceQSw5BmI4Tswm0TrbZFRmhLpZI0VJHLvUFcyfg+I3V4B5P4hAuMba/1u3SY4wyLOXGbJQs2WwsraOyRYTQXbg3AMGyiBDUviBb4kz0XW4gD7lWgpjpfTbjaQslXFrBQDKm58mo0oiem1whu0ku7LwRTw50kGXEyKejgV1vvi+Bm5FAoe33OUwSpOTJTFQLuJy4iIX+1flYMSIuGiyVY5oO+UXWOO9zaPHR0nqhc7fYya3telhUffsgtpO98SZBg0GRewuCLH6pLeRyNptVyuhptiYOwT5zlOS+XEyFI94GBV9+xYMCJGIybTJSeqIbqlA3yo/4DNzo7LFYidg8VqLJBNOkqybiL5tVP4IXvN30H1uK5yv1MAvTXR6aOCj650UwbL56wy+LNuKVe9mJZ5qdzhQZ0F/vCUqNjZl6wvq6HIcB43DpyIgTWQC53abwqWMhopIFw2BxRDkvkytV2/nHGfB8US6fJ1Of9FvelMSCfCaCrWmWOma3AWHZP+JPHQNwa16WZvywI/GCOcpHlfQ3XQM5a9muP3xETTF3R66ekbByZIv27
 oTRmlNSS
 HO78/oCCmsydpvOlE6YfnEn15Ec35iaGaUu+3tlVS/6sf7e7T2vK1n+iSPjyiGWFA6aC6fxFl3ixYeHi2RRvRLhEqEf3bx7JFWhXh9D3IkE8U+KObZUcqgMJfbnPFselSc7HjIt3wzILj8Pf61IlaUtyOTvJPd5mL6gK44btYP0icwZuBMG+NJz9bUrbXHkqYMuY/+Mhv6fprYJmk29pRtISnrCbISPVQ9PVuip2F3W6mTkv8Hx1jlpLzrbTosiNSjfrdUlvSaVgj38LIUlsFfsGCkGYp8stPYPlXW33hoayEiFCDUGqfhPqlDDVgKIHTZik/0qQmzyNDlnQJa+zxHEK+3umgaTcr5O5MtyiwgwfDUUGohODrWVDkDS+NMRAFzyQQxo5AvuIWb0CdsF7UIymDuzzp1ggqXw7ojfp1QtSNHIdGUbszy7kAyoe0msCWTUT7FjQItma69bjcQEbbnGx7+Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 02/10/26 2:39 pm, Wen Jiang wrote:
> clear_flush() calls flush_tlb_kernel_range() when mm is &init_mm. This
> was added by commit 06fc959fcff7 ("arm64/mm: Support huge pte-mapped
> pages in vmap") because vmap called set_huge_pte_at(&init_mm, ...).
> 
> Now that vmap uses pte_set_huge()/pte_clear_huge(), mm/vmalloc.c is no
> longer a caller of set_huge_pte_at() on arm64. The only remaining
> callers passing &init_mm are in arch/powerpc, which uses its own
> implementation. Remove the dead branch.
> 
> No functional change.
> 
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Reviewed-by: Barry Song <baohua@kernel.org>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


>  arch/arm64/mm/hugetlbpage.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 8e799c1fe0aa6..ce247b06fe03d 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -206,10 +206,7 @@ static void clear_flush(struct mm_struct *mm,
>  	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
>  		__ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
>  
> -	if (mm == &init_mm)
> -		flush_tlb_kernel_range(saddr, addr);
> -	else
> -		__flush_hugetlb_tlb_range(&vma, saddr, addr, pgsize, TLBF_NOWALKCACHE);
> +	__flush_hugetlb_tlb_range(&vma, saddr, addr, pgsize, TLBF_NOWALKCACHE);
>  }
>  
>  void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,


