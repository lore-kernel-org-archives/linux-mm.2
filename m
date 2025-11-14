Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B810BCE8D4B
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 15:56:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D2E68E003C; Fri, 14 Nov 2025 10:56:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 183778E0029; Fri, 14 Nov 2025 10:56:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 072BE8E003C; Fri, 14 Nov 2025 10:56:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E71788E0029
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 10:56:22 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AA0CFC03E2
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:56:22 +0000 (UTC)
X-FDA: 84109664604.05.D5FBD05
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf13.hostedemail.com (Postfix) with ESMTP id 51DB920017
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 15:56:19 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="g/B/dUgx";
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763135781;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CKysolUqeVjYcgMrPs/ejmALi8P8XvxL85H5NRIJlY8=;
	b=xN8Gpd+p+QyC8OrQ6Dn+oJh6XeKcs238RD48k1l4hsbzz+pMR6t99/fS5S9juqGtDXFX08
	fFsgd5EQAcPVILY/Jq6oQoj6QfwApFwde3gyBRgGcRFjpeNaS9hRHkQfTmGii2P1VzrPBx
	nbJDmxnO8EPyepsAMPccbIsj2QlHCKQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763135781; a=rsa-sha256;
	cv=none;
	b=RYWr7/1ChTNGGZdrwk/2Soz1GFwXx8Ezbhi+lGBCNlAX6trhdNs+b6IizS0SpZH2QwToLu
	lZrokzCDauDqijoQ9QAW9BrAvuRSxPb8l0wCf0IjpIezhGhjfjBWc/CCjQ1VrShZeOdohZ
	unmk25jFi7eQnumsc8HsrU5P+kTBIKE=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="g/B/dUgx";
	spf=pass (imf13.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <fc08c1a8-f469-43f1-93c0-7fcd2b1c477c@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763135775;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=CKysolUqeVjYcgMrPs/ejmALi8P8XvxL85H5NRIJlY8=;
	b=g/B/dUgxQJEHGDks1FfISlakIsod43sd1FWkLD53noWx1K51GzX035cGzeBE8Edv7rjSas
	eRoApfQqE5kMQiTGhq6jTv0fxdja6UCOlpRx6Wco9NKN4CqyYrziO6a9K/p051HV0WDT14
	Mhzi2WwkSotO4sbe8SdPRtkBrzsJI8U=
Date: Fri, 14 Nov 2025 23:55:11 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 3/7] loongarch: mm: enable MMU_GATHER_RCU_TABLE_FREE
To: Huacai Chen <chenhuacai@kernel.org>
Cc: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, dev.jain@arm.com, akpm@linux-foundation.org,
 david@redhat.com, ioworker0@gmail.com, linux-arch@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 linux-alpha@vger.kernel.org, linux-snps-arc@lists.infradead.org,
 loongarch@lists.linux.dev, linux-mips@vger.kernel.org,
 linux-parisc@vger.kernel.org, linux-um@lists.infradead.org,
 Qi Zheng <zhengqi.arch@bytedance.com>, WANG Xuerui <kernel@xen0n.name>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
 <146b5a0207052b38d04caac6b20756a61c2189b3.1763117269.git.zhengqi.arch@bytedance.com>
 <CAAhV-H6HL+mXeuLqgo5BOVBB0_GHTUmn7_7NTzdUpLX7NbuQ5w@mail.gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <CAAhV-H6HL+mXeuLqgo5BOVBB0_GHTUmn7_7NTzdUpLX7NbuQ5w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: 51DB920017
X-Stat-Signature: 3znf6a7bihbg8m6g3eoedcsaoe4aqjb1
X-HE-Tag: 1763135779-880959
X-HE-Meta: U2FsdGVkX1/cazMpixsm3TWzcqu8AXcLRjW0gjOAiFfrxe/UcCNEVRVgcOllwWd00oltooHV8vVKrXfBQvAUE6RB7oqERyh2pN0u9Tj5fkbGgtaAzom02MK6FU1UX1IKef05RuCpWz/n/V7H9bu/sWcNElAS8Xjukvqw+4MDyCEoDVPi8/J8A2koOy5O9NE2J05Stsz5GqlePuIDI6I/MCLqj4+WB9mFsmt+OmWH9apicC95VUjok1Ejw66Z6BxBr7/1W68BldMVhb2bM+TsDXxd38HCcBgP1umFakpMQykWRBwJZoSP/G13Jv5wrbN4ISC2QEINjWJBxDyIkCG9Ohh0iXBGDaCvI0tYMJgwmBx5e7FXPYN6C9ZQ07NWi565BHdfTqxAGVHXIre20t+CtqHm1pT1LhOKy/DGUJInN3W1m9q7ltdVRTlnJgONdUdhcgtk6YL93AbL+iZ5gsJ0Y4NM6j+0Z9kT45mflwSIPDum4jOtFAlbardWTSrfA1J3v+88GZAO5MGStgzhdGBaeCwBo47FH3sQoAcy2KZgGh38TtPDAyLTtozEItFyMzrKOktnV49AyMd8OOSb+RXxVCMgFJZl5xpfrU1OPRVLy0kvKOJS14ny2KtmDpTkfZkcIsZMlQS56zObsHi8kGMBgicV5BcRpc+vGIncDNTtWGa5hFRtceD13L/NmXKjzWjYZ1WqM9SH7ORHFodRqr02kMOiLZhSERSyabU5bWob9k75SKxv9hgDf5vZdyele4xVHYctoi3kdgRsbmTE1vHN+bvEo32NLYDm1bUuPQhymfECAbxWmPeI83O9Qa3b+749tJreDWgfzoCQbIJ7wwRKCqkU+EC5JD5X5azFN+8vcnTWDLCgc9Y0TWAIiNlM/m37xOraWdVXNIX4jI50wsM22HGSb94ZyNc3ri1IJk8bhnX9UtT5LkdJaLzgdD11pOxFrCHR6g+LDsZv2QWBXd1
 1SHw7N9a
 QV9WIDtsFEZOMF/iwYQ+/+oScRpmaa3Lk3KX07YQiPP7G2q5Dt3bpLHWq3hjlfA56vRBbYRz1365lDnoKkI0VME93wr5Yh5rbOrNs60fDKB8061765zXrP2T6ZnOaqLqeZbrbt6TiG6PUP7YnMfNhKY4jWb6GOy37WBs+ki7xmnSSYPMq+TQv8G+P3c4RsqDG5//utHGaNITLAsX2sGBD9ZENQToLbZeQ+406Yc7C22Q7l+4dCzsmMkTsPEs56AGiXNMKWsLJquFQko29o7keYhA+G4fEySY5/AgpcSovEMKqqzIMv7fqr9ZVonzMN01AIvcbjqUWZdBohuE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Huacai,

On 11/14/25 10:17 PM, Huacai Chen wrote:
> Hi, Qi Zheng,
> 
> We usually use LoongArch rather than loongarch, but if you want to
> keep consistency for all patches, just do it.

OK, will change to use LoongArch.

> 
> On Fri, Nov 14, 2025 at 7:13 PM Qi Zheng <qi.zheng@linux.dev> wrote:
>>
>> From: Qi Zheng <zhengqi.arch@bytedance.com>
>>
>> On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
>> empty PTE page table pages (such as 100GB+). To resolve this problem,
>> first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
>> PT_RECLAIM feature, which resolves this problem.
>>
>> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
>> Cc: Huacai Chen <chenhuacai@kernel.org>
>> Cc: WANG Xuerui <kernel@xen0n.name>
>> ---
>>   arch/loongarch/Kconfig               | 1 +
>>   arch/loongarch/include/asm/pgalloc.h | 6 ++++--
>>   2 files changed, 5 insertions(+), 2 deletions(-)
>>
>> diff --git a/arch/loongarch/Kconfig b/arch/loongarch/Kconfig
>> index 5b1116733d881..3bf2f2a9cd647 100644
>> --- a/arch/loongarch/Kconfig
>> +++ b/arch/loongarch/Kconfig
>> @@ -210,6 +210,7 @@ config LOONGARCH
>>          select USER_STACKTRACE_SUPPORT
>>          select VDSO_GETRANDOM
>>          select ZONE_DMA32
>> +       select MMU_GATHER_RCU_TABLE_FREE
> Please use alpha-betical order.

OK, will do.

> 
>>
>>   config 32BIT
>>          bool
>> diff --git a/arch/loongarch/include/asm/pgalloc.h b/arch/loongarch/include/asm/pgalloc.h
>> index 1c63a9d9a6d35..0539d04bf1525 100644
>> --- a/arch/loongarch/include/asm/pgalloc.h
>> +++ b/arch/loongarch/include/asm/pgalloc.h
>> @@ -79,7 +79,8 @@ static inline pmd_t *pmd_alloc_one(struct mm_struct *mm, unsigned long address)
>>          return pmd;
>>   }
>>
>> -#define __pmd_free_tlb(tlb, x, addr)   pmd_free((tlb)->mm, x)
>> +#define __pmd_free_tlb(tlb, x, addr)   \
>> +       tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
> I think we can define it in one line.

will do.

> 
>>
>>   #endif
>>
>> @@ -99,7 +100,8 @@ static inline pud_t *pud_alloc_one(struct mm_struct *mm, unsigned long address)
>>          return pud;
>>   }
>>
>> -#define __pud_free_tlb(tlb, x, addr)   pud_free((tlb)->mm, x)
>> +#define __pud_free_tlb(tlb, x, addr)   \
>> +       tlb_remove_ptdesc((tlb), virt_to_ptdesc(x))
> The same.
> 
> Other patches have the same problem.

Got it, will convert them all to the one-line type.

Thanks,
Qi

> 
> Huacai
> 
>>
>>   #endif /* __PAGETABLE_PUD_FOLDED */
>>
>> --
>> 2.20.1
>>


