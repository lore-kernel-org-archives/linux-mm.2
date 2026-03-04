Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 88F9FEB7EB4
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 09:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C6BA96B0088; Wed,  4 Mar 2026 04:06:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19176B0089; Wed,  4 Mar 2026 04:06:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1BA76B008A; Wed,  4 Mar 2026 04:06:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9EC356B0088
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 04:06:29 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 477261604EF
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:06:29 +0000 (UTC)
X-FDA: 84507799698.18.D621B9B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 957CC1C0002
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 09:06:27 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UsR1FElG;
	spf=pass (imf18.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772615187;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KH00A08cR6IT6Hz5UznDJTJn1MmPOQBn/jw8icu2ijk=;
	b=FH7B8JaiZckMNh1/ghMwD/y0woWyYWKFHQpCDLU+5PK3gZkLtRg1ybIYblLgQkvWvProo0
	7UWvXVvVJVllS46OWxYpV7Xb5NQNdVYaMGclvU1iwZvzIuEUPH1lGRJl4SP0eFDwhG3+wa
	z4bLyNCXL1a7LIYv4XcYPKINZz3rIUU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772615187; a=rsa-sha256;
	cv=none;
	b=4ELeT76kbWcB28523r17EZ4IKmwbeUsIocU7t2hyY8UXlyIz1uEXXJPsL1W6KjR2kJfvRI
	saGixOSVuqA7fBJzhrXHhIBo8VRHVKF6aFmo+nx0cvqTO9Te2yc1nAANojyOulaOfWWGJ8
	HuZLw6V37B3qgizfvh1wR6B1jbIlkO8=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=UsR1FElG;
	spf=pass (imf18.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0091F600AD;
	Wed,  4 Mar 2026 09:06:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2965C19423;
	Wed,  4 Mar 2026 09:06:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772615186;
	bh=oUs+v1pdPjy3Vi0K/gUT11tHnZaaGcGTCSW7iS5qd5c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=UsR1FElGhcfLEwKM4L2dEwVCLrCJVas+KWIXGDqKHGtrF9DpFsmG6pAZcxKxWjJKD
	 xIWD8Uwz0f42/a6yLfrLl1ydbhT2oZx82t8APlW4VYUiWftR5tUxFxVM64bgsXmnHG
	 NnUz52ZG5NdnAB5hyio68eFbVHvPJ1TU7GakCH5KQj+AFk8vK73ySXZWbHDGQFI6zZ
	 NQl7H6c0COqGWdAi337BATD7szV/cxBTWD920Il67e6NPoGuxF7scMXNG5vqD3mumv
	 wx6yZUZf39t03Fgntf5kFZs7M0DENuAR6rnbRxsdExp63C+dZBsOSs8YtAk0INByJ8
	 akagilJuaf8AQ==
Message-ID: <5103eb9a-4a50-4f3b-9bcf-f66ed396e3ed@kernel.org>
Date: Wed, 4 Mar 2026 10:06:22 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC v1 08/10] powerpc: book3s64: Rename tlbie_lpid_va to
 tlbie_va_lpid
To: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 linuxppc-dev@lists.ozlabs.org
Cc: linux-mm@kvack.org, Hugh Dickins <hughd@google.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Nicholas Piggin <npiggin@gmail.com>,
 "Aneesh Kumar K . V" <aneesh.kumar@kernel.org>,
 Venkat Rao Bagalkote <venkat88@linux.ibm.com>
References: <cover.1772013273.git.ritesh.list@gmail.com>
 <91a6be6c26145dd2ce94d6c1f65aae86d424857d.1772013273.git.ritesh.list@gmail.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <91a6be6c26145dd2ce94d6c1f65aae86d424857d.1772013273.git.ritesh.list@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yphxun58c7kyj3fncojtkyehqz4tsr1q
X-Rspam-User: 
X-Rspamd-Queue-Id: 957CC1C0002
X-Rspamd-Server: rspam12
X-HE-Tag: 1772615187-780812
X-HE-Meta: U2FsdGVkX18LtRzPciWLUbx1S9kmJS36PPx/cgnAvPBLAiwzVZCJC7wK1iI/Cu2r4YFre0dNjkrUdgJod5t1q72dUz7P1acOpMa8LOIy425aSAcfEl1KDlsfCjVbInmIJ7htBFwr1lnJLQ503epRb8DkAoQv14msVFib0qg4Pp+JWRRsdqMvoaKYhZic5XcdSkB1qLbtaJimbAQMyJc5M4iR2/M/3StVLD/Gh7Bs1g7uLVZyzhxEnVDlBDHoZ6yD6shsQDONVW/eQpSWRaU1EDYUhQtyYYbeIvtzk6H1Xn40CXN5zoIN+LN6UqF8tbE9ahA4RsV0JhSXVax46at6M3fWNBcosVqHsd7EMAZTDpst5YPCigi6ybQ6CsKUP4CpPqGXYk1eEYALMAmJv4r9P4bIebb7OZr4ePePCL9XVm9pUDelSRmQeNOzbaPGhYKREptPzrbu67KQqp3yPeJM7k3dKyE6epRQ3VZZRnranWW5S4+vekFo5WgXlDgxfypT91VBha2Ale1wWCo58ApMdQvneE2SGhuL3nu6YBavUVaqwgkglNO8a3bhzk/YuYAWFHsHDtKVxHA+e7t9LRTkeFbyuqggo+Xxr8+cfg1ZN994Glt2jOdwm6wsj1sgaicA2ErA7xHmCWl/OcZ85Ua1cDw9A1ZYOCIhQjmWyLlcEQewEdXQd0Mo7Hq27bps08197O/jv9YKGaMoyFJeazqq4IiOSUa/4GLLCLsU6UcT0rBVtqymF+G/2SWjCIkmJw+ZoT6Q8/X8UidnH10eJKzynYMCPzXBSFQMt2/ollsSOFpO/Biz6GBrL+DZJQ9Q10qXXElgBXFAh0BZ6/oImL41tkc41RNdwNQ2yN3oIy0pG6HVXFIWv2ODPOvrYABWGYOwSXKby79SqHKvnLw58MUllaftOZENbjDOID4JaOQ5fqI7/g8FW09CjetssA+pnPCVH5Bh4WhgMlpaeK3k+sh
 KqURP5OD
 kPyStUrtRI9HvjrdHNoLdiIq6uITW2MEIUWaO1/VWLPrNBsTMDy1LppVyfiWelKxKXCDdiPC6Hlti6sgEmGUcSU0HiSKM3Q96JAU+LIqx7k+ik26Y8RunRu8fgk2NBXWRg/LjYbTCbcHnZzFCElYV5MDiMK0OX0r87584SPo/r6Qxp4rUPdglPb5A/06ztB/JMOf1Qn83gjBa25Ns+SCz14xDGPnw4GJQZNmdRejUbpyN7GoQZBDrxNG6df6qX0vCertlv8y5ot63nXW9BNeU1hPioBlkiiwA0c4Z2fbau2FzqmeJ40TRPewpz2tju5pHu+7ifE1Y1251Fc8AMPUH0Tmr6V8TR40WuhOsRpBW7aRcJiVBpmhA/WejE/yyjwwxLYVQV1aLrOT3Met+96xv2CR4yudezS72fv4dRNL7ldR8i59leV2DYSyVbAZDhauljXxb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 25/02/2026 à 12:04, Ritesh Harjani (IBM) a écrit :
> In previous patch we renamed tlbie_va_lpid functions to
> tlbie_va_pid_lpid() since those were working with PIDs as well.
> This then allows us to rename tlbie_lpid_va to tlbie_va_lpid, which
> finally makes all the tlbie function naming consistent.
> 
> No functional change in this patch.
> 
> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>

> ---
>   arch/powerpc/mm/book3s64/radix_tlb.c | 18 +++++++++---------
>   1 file changed, 9 insertions(+), 9 deletions(-)
> 
> diff --git a/arch/powerpc/mm/book3s64/radix_tlb.c b/arch/powerpc/mm/book3s64/radix_tlb.c
> index 1adf20798ca6..6ce94eaefc1b 100644
> --- a/arch/powerpc/mm/book3s64/radix_tlb.c
> +++ b/arch/powerpc/mm/book3s64/radix_tlb.c
> @@ -185,7 +185,7 @@ static __always_inline void __tlbie_va(unsigned long va, unsigned long pid,
>   	trace_tlbie(0, 0, rb, rs, ric, prs, r);
>   }
>   
> -static __always_inline void __tlbie_lpid_va(unsigned long va, unsigned long lpid,
> +static __always_inline void __tlbie_va_lpid(unsigned long va, unsigned long lpid,
>   					    unsigned long ap, unsigned long ric)
>   {
>   	unsigned long rb,rs,prs,r;
> @@ -249,17 +249,17 @@ static inline void fixup_tlbie_pid(unsigned long pid)
>   	}
>   }
>   
> -static inline void fixup_tlbie_lpid_va(unsigned long va, unsigned long lpid,
> +static inline void fixup_tlbie_va_lpid(unsigned long va, unsigned long lpid,
>   				       unsigned long ap)
>   {
>   	if (cpu_has_feature(CPU_FTR_P9_TLBIE_ERAT_BUG)) {
>   		asm volatile("ptesync": : :"memory");
> -		__tlbie_lpid_va(va, 0, ap, RIC_FLUSH_TLB);
> +		__tlbie_va_lpid(va, 0, ap, RIC_FLUSH_TLB);
>   	}
>   
>   	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
>   		asm volatile("ptesync": : :"memory");
> -		__tlbie_lpid_va(va, lpid, ap, RIC_FLUSH_TLB);
> +		__tlbie_va_lpid(va, lpid, ap, RIC_FLUSH_TLB);
>   	}
>   }
>   
> @@ -278,7 +278,7 @@ static inline void fixup_tlbie_lpid(unsigned long lpid)
>   
>   	if (cpu_has_feature(CPU_FTR_P9_TLBIE_STQ_BUG)) {
>   		asm volatile("ptesync": : :"memory");
> -		__tlbie_lpid_va(va, lpid, mmu_get_ap(MMU_PAGE_64K), RIC_FLUSH_TLB);
> +		__tlbie_va_lpid(va, lpid, mmu_get_ap(MMU_PAGE_64K), RIC_FLUSH_TLB);
>   	}
>   }
>   
> @@ -529,14 +529,14 @@ static void do_tlbiel_va_range(void *info)
>   				    t->psize, t->also_pwc);
>   }
>   
> -static __always_inline void _tlbie_lpid_va(unsigned long va, unsigned long lpid,
> +static __always_inline void _tlbie_va_lpid(unsigned long va, unsigned long lpid,
>   			      unsigned long psize, unsigned long ric)
>   {
>   	unsigned long ap = mmu_get_ap(psize);
>   
>   	asm volatile("ptesync": : :"memory");
> -	__tlbie_lpid_va(va, lpid, ap, ric);
> -	fixup_tlbie_lpid_va(va, lpid, ap);
> +	__tlbie_va_lpid(va, lpid, ap, ric);
> +	fixup_tlbie_va_lpid(va, lpid, ap);
>   	asm volatile("eieio; tlbsync; ptesync": : :"memory");
>   }
>   
> @@ -1147,7 +1147,7 @@ void radix__flush_tlb_lpid_page(unsigned int lpid,
>   {
>   	int psize = radix_get_mmu_psize(page_size);
>   
> -	_tlbie_lpid_va(addr, lpid, psize, RIC_FLUSH_TLB);
> +	_tlbie_va_lpid(addr, lpid, psize, RIC_FLUSH_TLB);
>   }
>   EXPORT_SYMBOL_GPL(radix__flush_tlb_lpid_page);
>   


