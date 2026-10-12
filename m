Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3124ACA9ED2
	for <linux-mm@archiver.kernel.org>; Mon, 12 Oct 2026 07:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AD2D6B008C; Mon, 12 Oct 2026 03:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25EAA6B0092; Mon, 12 Oct 2026 03:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 174CB6B0095; Mon, 12 Oct 2026 03:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E6CA16B008C
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 03:39:21 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 86F5E409D8
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:39:21 +0000 (UTC)
X-FDA: 85313173722.07.5C0EB3C
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 86C601C0003
	for <linux-mm@kvack.org>; Mon, 12 Oct 2026 07:39:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=i0lGTdAo;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791790759;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ml3XzqnfvkPoJalIiDoqIEaqIWpXPrO+zTg3b+pyBTg=;
	b=HfsU0EJnDEu9SEczEXZn8NWk2PWFwRdMRJTHpp8vHmq0TMRUdssxWs1K/6kH9sE34gg7A4
	TQRNQShvQX6uas0HVawGtxfp0ZGEjewf8Q4U8ZOPW2SBYnACee3E4SZ15TWls5HzR6dKJ2
	etvSebu+DTYraQ6Nu+cQv1gWwJRHahc=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=i0lGTdAo;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791790759;
	b=p+Bdgg7mdN6JYvNXlrkgKSHAUK1e/Ibqm7PBgxG43QH2Dhp6Vfkx1tAqkIacDHZR+ARW7Z
	NRT9jp8HWE7gLUiY/c3DIPLepGOr6UMW0Uhx9cUH+0HA8OI5ygrZQqWFRGJhKvE0JQGghO
	TRbXeWKKM5CpbdFRiu6PKLR/3ZnJOR4=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 04CB61650;
	Mon, 12 Oct 2026 00:39:15 -0700 (PDT)
Received: from [10.164.19.62] (unknown [10.164.19.62])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 137743F882;
	Mon, 12 Oct 2026 00:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1791790758; bh=QFylubiAn6XF6+4lXPZWi1iu+KACNJaGKaA1OI3cGV0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=i0lGTdAoo7yNW9SwE9EHgLeyVZtho3vPYbLDUzDNLp0AxWuYAdwb5P/QXd71ZeYdL
	 OFHKbtD9gIlK5bb/aEwzvDVLDFJC+bn0oTyJtfKJ13Vjfq7MvuaZfl0HhJzwaQRrAl
	 ULUyyhH0aFG1ImOrjhUsnfRaO5vb7E26yyFrvCc0=
Message-ID: <4f812ef0-ab14-48c5-908b-b7d82ce418b3@arm.com>
Date: Mon, 12 Oct 2026 13:09:10 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v10 05/10] arm64/vmalloc: allow
 arch_vmap_pte_range_map_size() to batch multiple CONT_PTE
To: Uladzislau Rezki <urezki@gmail.com>, ryan.roberts@arm.com
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
 will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
 anshuman.khandual@arm.com, baohua@kernel.org, chleroy@kernel.org,
 david@kernel.org, jiangwen6@xiaomi.com, leo.yan@arm.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linuxppc-dev@lists.ozlabs.org, maddy@linux.ibm.com, mpe@ellerman.id.au,
 npiggin@gmail.com, rppt@kernel.org
References: <20261002090947.869220-1-jiangwen6@xiaomi.com>
 <20261002090947.869220-6-jiangwen6@xiaomi.com> <astarANeoldvqBxc@milan>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <astarANeoldvqBxc@milan>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 86C601C0003
X-Rspam-User: 
X-Stat-Signature: htio56i95nxuu6dz4s5f8x9mw9otbhgz
X-HE-Tag: 1791790759-518309
X-HE-Meta: U2FsdGVkX186KsPMbgvSUPFPk/QZYfdRvaTf15tgY4Fug5ozJT+NAIwZJ2F6tRh1YPwUQRuIHy+iunXKiYAvEy00Fbhrzg9byOYCMy1VftdL1n25A4UB3qJ5HowvJdR2rRMEnMdcDB3XNBogkaYdZ2oBojI1RqnIO874tehuhbDoHZRpNAr0YnPGebZXrGF309xiGSVhXi9kwMnXI+HMkIY6gbVjz+Rb1REhPrc0ztC+Qek2pddcyS282z9OQzODBuaECVoKAK5eKqRye/7BKGPWakhMpvgbDsXsWKhJAJVwq7yktxGZlv7il+eAr13FxII3UryMQf6KeObKf5Mesp7a1JF8XzhrOcfWWHhzAltnZxQgdbCeRS0/vIMTXW3SuNh9Ru3VXfiMgeD9DsExX2lTAw1baZkI80IkiVdMsPGMmj68GxJsLzyaGhUG2dGxy3Mc1hjq3MG/dJVro9usoOQNbl00NKE/tgaGwZhZ8qOJmZt05QVZCmNttd0XSY+WV3V3QAOjjdKfsN9Hz177Hjd6GvjaQi7ahZKm344rMAiYUscIvdywSaS8ZGKR5C4SP0oOuMK1fkz+gEmGtOej2u6Czs/EN+nRljD5FmGhHcH7/501yrFKVH96R9JuUujihSPMwVqXZ7m47qHS7Bl4xkXqacmDH6Ec5pWIo5kyA+HFu559GX2V85fXNDKQLARcCGr1lKhpNAZMe/d54USKvy5CS8qzs6Rb3+lR0CGubL2ax3dDrnF2r+RieOcDnOgTe6ayANZn8HT1jcoRwfPilYcmLptPLJsxZUlCRB8Y0vBp8CvHasqiUw0XhjvETLswyyQ2PGD0NtSHfb60k+dfMJD0+1+DncgD8CZUiWDH4pWj/YyY4xI8MyQJsEGiSi/VhTQa06RtbHGsLkaUAZbLHS6tupwODgYGQEAjGAV/Rx+7tbLqLnCaNwAqA2RAyizxB5tY72sacyPT7oDNFOy
 wjJO7MRd
 Le3emAaEp6Hzt9CtMkAZOOBKcl+nLpTgfYtnyulkMSOdo2xSReIZdjvDVJY/8J3+PRCuZcZuVk5D17iVGDXdTXcpHpawgRe7ykIJ+G4ek0++9JUY8qrcibBfHtybhbMa4Chqfp4rNILXnZ9Qv1hZR/JHtAuN+84ltTG3SMXgy1n/sdRsJ2WB8OXZD0J7QOphdFun5O1Py6Cy9dHcNRPOIDLOIfJ+Asu+1DeSVVSFxBZE8ABREYdwiM10ef63rpAoGs8QEn1LTUaGM7LbVecPsN2CDNJ+cMXd7CxtWGZxmfvKjEhwu3Kh7m4Ee+c+KW5+PVZZ5ChHuNUM8oaIva3kAKZXuoyEGNKNWjfaW49jo156bJrVLmRWifk9HNPoTEUb2TUzLF+XUNGO97zqf85Z0QX0h94EbRT2MMzuuoiLkprVvsQM8jMzFQwfMiUoz22uf3FOlB4vUfE290e3xnZBW2XD6o8UrHTFZNx19I/yRuj03BLA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/10/26 3:15 pm, Uladzislau Rezki wrote:
> On Fri, Oct 02, 2026 at 05:09:42PM +0800, Wen Jiang wrote:
>> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
>>
>> Allow arch_vmap_pte_range_map_size to batch across multiple CONT_PTE
>> blocks, reducing both PTE setup and TLB flush iterations.
>>
>> Previously the function returned a single CONT_PTE_SIZE for an aligned
>> range, so the caller mapped one CONT_PTE block per iteration. Now, for a
>> CONT_PTE_SIZE-aligned range, it returns the largest CONT_PTE-aligned size
>> that fits within both the remaining range and the caller's max_page_shift,
>> so a single pte_set_huge() call installs several CONT_PTE blocks at once.
>>
>> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
>> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
>> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
>> Tested-by: Leo Yan <leo.yan@arm.com>
>> ---
>>  arch/arm64/include/asm/vmalloc.h | 12 ++++++++----
>>  1 file changed, 8 insertions(+), 4 deletions(-)
>>
>> diff --git a/arch/arm64/include/asm/vmalloc.h b/arch/arm64/include/asm/vmalloc.h
>> index 4ec1acd3c1b34..c29704a19e276 100644
>> --- a/arch/arm64/include/asm/vmalloc.h
>> +++ b/arch/arm64/include/asm/vmalloc.h
>> @@ -23,10 +23,12 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>>  						unsigned long end, u64 pfn,
>>  						unsigned int max_page_shift)
>>  {
>> +	unsigned long size;
>> +
>>  	/*
>> -	 * If the block is at least CONT_PTE_SIZE in size, and is naturally
>> -	 * aligned in both virtual and physical space, then we can pte-map the
>> -	 * block using the PTE_CONT bit for more efficient use of the TLB.
>> +	 * If the range is at least CONT_PTE_SIZE and naturally aligned in both
>> +	 * virtual and physical space, return the largest CONT_PTE-aligned size
>> +	 * that fits, for more efficient use of the TLB.
>>  	 */
>>  	if (max_page_shift < CONT_PTE_SHIFT)
>>  		return PAGE_SIZE;
>> @@ -40,7 +42,9 @@ static inline unsigned long arch_vmap_pte_range_map_size(unsigned long addr,
>>  	if (!IS_ALIGNED(PFN_PHYS(pfn), CONT_PTE_SIZE))
>>  		return PAGE_SIZE;
>>  
>> -	return CONT_PTE_SIZE;
>> +	size = min(end - addr, 1UL << max_page_shift);
>> +	size = round_down(size, CONT_PTE_SIZE);
>> +	return size;
>>  }
>>  
>>  #define arch_vmap_pte_range_unmap_size arch_vmap_pte_range_unmap_size
>> -- 
>> 2.34.1
>>
> This is arch/arm64 code. Can you, Jain or Ryan from ARM folk review this change?
> 
> Thank you!
> 

I will come to this soon.


> --
> Uladzislau Rezki


