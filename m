Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 276EBEC01DC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:01:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2805F6B0088; Mon, 23 Mar 2026 08:01:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 257D96B0089; Mon, 23 Mar 2026 08:01:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16DE36B008A; Mon, 23 Mar 2026 08:01:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 02E6D6B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:01:46 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5C49C13C065
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:01:45 +0000 (UTC)
X-FDA: 84577188570.18.1B3A8FD
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf21.hostedemail.com (Postfix) with ESMTP id 8A5FC1C0005
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:01:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hwd+PZ6l;
	spf=pass (imf21.hostedemail.com: domain of 3pSvBaQgKCFY7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3pSvBaQgKCFY7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774267303;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9PU7c6Ak+cD1xqE0Ag3FZYs88dCaVaPlNoPrIQ+v6QI=;
	b=BkF1CkQP64wNjJc7M3Gl9FQhEc5CicGIZbUalbJ+B/Uvmd7JWkYz9bvcCkubWg8E+AgPgf
	zOOgj1PQ7oDXrNbPXrHy3AV81RiCGwbL4c8rMrcdLFZG9tw4fEs1MueyuSJ5I62VNB09yZ
	HRKCIgWDq/VdtH6aHi9UXzFthIVBFO8=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Hwd+PZ6l;
	spf=pass (imf21.hostedemail.com: domain of 3pSvBaQgKCFY7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3pSvBaQgKCFY7y08AyBz4CC492.0CA96BIL-AA8Jy08.CF4@flex--jackmanb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774267303; a=rsa-sha256;
	cv=none;
	b=feVU7kOXY5VMYCydAKEID9QW6oFM1f+8sijjYQzYMNR+zaNxbi18cAYJrWFWPNnBsHl0pl
	g3pMAjwu9bmIoAROqcYlsAONdkuiCecpcPgIEmfGbU7Xk680un7EwKxmVbhAZ2A2zks15e
	MTa2p60GsQ7ea0jVBpfck9MYUaAbIBM=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-485c45885e6so49075545e9.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:01:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774267302; x=1774872102; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9PU7c6Ak+cD1xqE0Ag3FZYs88dCaVaPlNoPrIQ+v6QI=;
        b=Hwd+PZ6lrcPoo59VGYcca85eqkcvPi9eTVhXTvpaGS9xKtYhQ7YmJAZj5Skg2X3Bq3
         osnNP+klGuM41rVPEZodb6M/xsBWfd6JVHg4ccAiiYSlQ6m/bHXrzIZYIJwvglKKH1kT
         M+l95lVPQHV/jzcfyVD82m5yP3VNj0d0MUqRi9UWXzFR4Vyx4VADEMn8LDVmxCwsx/Ru
         sOINNck2z/NOMpTTpIXKj3qE87C3Dn92Av6+P0Jn5Fsh16DnsjP/IvMlDWt5bTROhSrC
         AKYIOVTerLJisaO2Tk4wVxjKTJNXdVm+qBtncdSAzrqvkLBfT6Dmnn/KyntZCMVo6WVO
         QKMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774267302; x=1774872102;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9PU7c6Ak+cD1xqE0Ag3FZYs88dCaVaPlNoPrIQ+v6QI=;
        b=oTo8z8EN5M1OVjaGBRdqarKsxgcVmZkFiHfFJ5iYSK89siewntPrqYBIbYUNsIbX+h
         t4BHbrhkQ5tsI9xgU/Iho92eHsgHlh1fNfGgGwuOiESWYWwznuIz1AFVYumQaCdi32hh
         Di7noNjMgNDR4kdI501GQp4H8FPnUISeqpusXLVC30G81spv+XhsIqi06MPwdmhQsUxr
         ybFZyiIFrEYixrvRXyWfQ35VrsblARl8ixJAcrFm+mgjK0LGrNrS3145zi3FrKHdsxIu
         djLvbm/TJJRCiQNz/0xWLkp4AxqTrmMzTRoyPepFGYFXDya8xY730aLSw4iw8jJtEXcr
         mc4Q==
X-Gm-Message-State: AOJu0YwlxADCHiMsfZwsnaGrkCYLA6UhKcWlbc1IHctEKSjtU727c6AE
	XfpJfccFnnFUB0aobtoDxo8QXgC8Ujc3LBaToUh81h7I8IMaCJvbm9g4Pm/hHXgFEpE06jUycV2
	RwspPrqc1bT5Lgw==
X-Received: from wmbha26.prod.google.com ([2002:a05:600c:861a:b0:486:fbd8:2af6])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:468b:b0:485:5812:bb9e with SMTP id 5b1f17b1804b1-486feb5a4d0mr174722475e9.0.1774267301692;
 Mon, 23 Mar 2026 05:01:41 -0700 (PDT)
Date: Mon, 23 Mar 2026 12:01:40 +0000
In-Reply-To: <17e58542-1221-48dd-88b9-236128515ed2@intel.com>
Mime-Version: 1.0
References: <20260320-page_alloc-unmapped-v2-0-28bf1bd54f41@google.com>
 <20260320-page_alloc-unmapped-v2-2-28bf1bd54f41@google.com> <17e58542-1221-48dd-88b9-236128515ed2@intel.com>
X-Mailer: aerc 0.21.0
Message-ID: <DHA59LJ1UQ1H.10RZVJ9V4X5TW@google.com>
Subject: Re: [PATCH v2 02/22] x86/mm: Generalize LDT remap into "mm-local region"
From: Brendan Jackman <jackmanb@google.com>
To: Dave Hansen <dave.hansen@intel.com>, Brendan Jackman <jackmanb@google.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, 
	Peter Zijlstra <peterz@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>, <x86@kernel.org>, 
	<rppt@kernel.org>, Sumit Garg <sumit.garg@oss.qualcomm.com>, <derkling@google.com>, 
	<reijiw@google.com>, Will Deacon <will@kernel.org>, <rientjes@google.com>, 
	"Kalyazin, Nikita" <kalyazin@amazon.co.uk>, <patrick.roy@linux.dev>, 
	"Itazuri, Takahiro" <itazur@amazon.co.uk>, Andy Lutomirski <luto@kernel.org>, 
	David Kaplan <david.kaplan@amd.com>, Thomas Gleixner <tglx@kernel.org>, Yosry Ahmed <yosry@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 8A5FC1C0005
X-Stat-Signature: cscsj3rscf1bjzpz1rf6th1aegtp4u55
X-Rspam-User: 
X-HE-Tag: 1774267303-31482
X-HE-Meta: U2FsdGVkX1/PW4w2+dLcVRdg5T0GS54iJEj1iNmvb1dCemvxTf2NFyxxvyftjIX0+oS4k6dcF6Gl1UswbGUepSve7a1b8ioLlrtEHdvluBOgr+QKKtNzafM9Ps8SUh00kykUsHgNPOxX4atEmqfGnOIFINL6O/rWXs+jl6IP1eHgi4ALBZMfpd3+rOLMEAg2zGNskWr7iNW1hEvye6oSkWuMlOw1bfIQdarf0iEv5sKIJayyTQi5jfE6KvJ2C3w94UDjtGDKCEj2h/+Jq2HjVOmHFgfwuI1AGRSI/ymnBRYBHty+ukJKrR4yI5EZvU58zlHtaQIw1/y+N21cvybmL9nnzxnVTVW+rBnjPBGy9GisfkdNtWnszUpmwW+4pVQh2fiAtishzXdSUj1Ht0r+7sxE2wuhSRUO/SFu7iLMVxm//s1DMr7FPyxQ2vMF4vbjWE/wFqJQhZ8J6/KBWT2jWlahiegGpHbRlzNXe6vfte0Cr+9hpO3Jdzi+Maosa7r+dGuWmqmigUBGw/YaaI1F0feWVdsk627pegXdwMBIm1A557mX0TlBLPamfmS80rA+fA1cxGcduQXA4nVyMjbKbOlsov+9UPIHiVHDrJ9vnH1PzDYQjwIUy4ua6jgOyyi7hS5ZqgFk1+pzIOgV+Kk+cPPzKl0Cf+7s4j9AEttkILNBGxI1dZd8V8ML0SX49nnLn07AG+7rn66OuDo5FFqPEKQxVXGYrK3/q45x86LDSLBduKD/Trrq/Cne9e4T2X2kAyUd/aVIomxarHduOvZB+qBwrkhpZcMe0UZXxEo/pMwtNSecfiKHLl+zRG0+lGZhylx6BGHx+nrWcb/5CY6rIvCBwHrwCI3uhnzNjuDVlN9MZAY3p6LBWEA4iN12G0A93vn9mz8fcgru9fqlE6vkZqsoSdrnc78gMLzHPPPEMRRbxf/r0AFXCXeFjsInAds9OFnEYYZ7o8RaKok5Scs
 g8wT6Vuv
 Rq2gWBEzejVI7YTbPPjZjAGkY337AW4OgZ9G2aHVkkpqVfzMLzR5C20Mhi9GBGZ/pTWHZRR6XsruZcEkK5aQ/bcBIxAk90Sp4XpbQ0O7erjaokBwHh0GKutp3lAWVwoo8vSvKFYY7V225RyZjYrkLLdjoLM8ZgdAcOtmfW2q8HOufxDDKevDYBK9+J2EzUQC8an8KJjtN2o+rcjsqdNbZWhrKDzxvJNj6A9ohQgbAZvLM+QcH/64KcQM6Hj6oo+HMUxs3CaE+E1iIVWCF++/msysmVN6JXpggZ1raYVgtI4QLhDvrSDB2D5dZsb64ot65ho8Gxe+7fZHhexYIoMxi0dVhc+r3+LuAMbAFCfYU4Ftn6THsBDr3uzc4pMCFHxYom7l3TliS88Qb5vlj6F7uhlqlZURghsF66SUnmKhsUx38Y/ThFwmAOLNz7vCgdS4/ZpYV2ID8ucoWUhtsWmIQFCCpxzBIL8Bpb/Izi5LrDOPLZ5JYrXOZsihZOlowW6eP2Tnq0zKXmxXuebTRxzvMDdX3rDJ5Efp+LUYOynpl9Ayv8hbZ/FG2AokfwTeA4J4Ivtli
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Mar 20, 2026 at 7:47 PM UTC, Dave Hansen wrote:
> On 3/20/26 11:23, Brendan Jackman wrote:
>>  
>> +#ifdef CONFIG_MM_LOCAL_REGION
>> +static inline void mm_local_region_free(struct mm_struct *mm)
>> +{
>> +	if (mm_local_region_used(mm)) {
>> +		struct mmu_gather tlb;
>> +		unsigned long start = MM_LOCAL_BASE_ADDR;
>> +		unsigned long end = MM_LOCAL_END_ADDR;
>> +
>> +		/*
>> +		 * Although free_pgd_range() is intended for freeing user
>> +		 * page-tables, it also works out for kernel mappings on x86.
>> +		 * We use tlb_gather_mmu_fullmm() to avoid confusing the
>> +		 * range-tracking logic in __tlb_adjust_range().
>> +		 */
>> +		tlb_gather_mmu_fullmm(&tlb, mm);
>
> These are superficial nits and I need to go through this series in
> actual detail, 

Thanks, this series is pretty brutal so I'm very happy to receive
incremental reviews!

> but here are the nits:
>
> Indentation is bad. What you have here double-indents the whole function.
>
> Do this:
>
> 	struct mmu_gather tlb;
> 	unsigned long start = MM_LOCAL_BASE_ADDR;
> 	unsigned long end = MM_LOCAL_END_ADDR;
>
> 	if (!mm_local_region_used(mm))
> 		return;
>
> 	... rest of code here

Ack

>
>> +		 * We use tlb_gather_mmu_fullmm() to avoid confusing the
>> +		 * range-tracking logic in __tlb_adjust_range().
>> +		 */
>
> Imperative voice, please.

Yeah I don't think I'm ever gonna stop making this mistake. Any LLM
should be able to catch this for me, I think it's time to find a way to
get that into my pre-mail workflow.

> And a meta-comment:
>
>>  Documentation/arch/x86/x86_64/mm.rst    |   4 +-
>>  arch/x86/Kconfig                        |   2 +
>>  arch/x86/include/asm/mmu_context.h      | 119 ++++++++++++++++++++++++++++-
>>  arch/x86/include/asm/page.h             |  32 ++++++++
>>  arch/x86/include/asm/pgtable_32_areas.h |   9 ++-
>>  arch/x86/include/asm/pgtable_64_types.h |  12 ++-
>>  arch/x86/kernel/ldt.c                   | 130 +++++---------------------------
>
> This is too big and there's too much going on here. This is doing a few
> logical things like both introducing mm-local regions *and* making the
> LDT remap one of them.

IIRC I tried this but having both an mm-local region and a separate LDT
remap at the same time is annoying, it would mean reviewing temporary
code to deal with both existing at the same time. 

However I just had an idea: I will try creating the mm-local region but
with size 0. Then in a separate patch I'll expand it and simultaneously
move the LDT remap into it.

