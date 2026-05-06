Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7BA6BCD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 18:30:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DC7506B008C; Wed,  6 May 2026 14:30:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D78DF6B0092; Wed,  6 May 2026 14:30:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C66E46B0093; Wed,  6 May 2026 14:30:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B0D6F6B008C
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:30:39 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4AFB08B919
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:30:39 +0000 (UTC)
X-FDA: 84737835798.18.C85C303
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf07.hostedemail.com (Postfix) with ESMTP id B777540018
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:30:36 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GwerhWUL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778092237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8/RGMDkKi/0TpsTIZWOvUcys+qwq15zYbJSL/7mQVIU=;
	b=EXsZVnnOhDpYEO/EPF6+ijiH8vw7bF7e5FERMJ+3EjmkAj6EfTHsR6c7ngnqDM4hjcEzJw
	8sHHVgPUB307l1ojQHIrVJvDrxPjIlUuBpQl9aMt/FVL2/xSOdd+RHuUDPsFd2rL/wwUJZ
	Nr5XjErcCPo94AYEi2FY2N06g1c/w7M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778092237; a=rsa-sha256;
	cv=none;
	b=6JAdl4FQNUSoYhTlov9oE88TRZb1wLeo+2JI5vpRBovPB2d+20D5Z9eudPstVGvRy/EVeS
	upzSB0DesYAXWtTJRqzr9Qym+WD99X9xM+zR/ouIjyRqAeV96vORhnIM2VmJCFMoqqerqQ
	NV2ZaWmvXXM9R5g1hGD5dFbTGxBO+nQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=GwerhWUL;
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf07.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778092235;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8/RGMDkKi/0TpsTIZWOvUcys+qwq15zYbJSL/7mQVIU=;
	b=GwerhWULTJoufZbRmljmNm1L5DQH25NSCtzQuXr+yHP3hjuQs82aDZyKehdxg5DD1rcP0Y
	Q4RroKqwumNfz2iyu7ZsqaKeLWNzpoVg9/84mwQ9hE1sRIuxKPEsiE3PTHkXsnQCbct0pR
	mXwoj31gQf37fv2OnmPtohQIH7QWLbs=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-173-v7dmvifBM3OC0sebtNm2DA-1; Wed, 06 May 2026 14:30:34 -0400
X-MC-Unique: v7dmvifBM3OC0sebtNm2DA-1
X-Mimecast-MFC-AGG-ID: v7dmvifBM3OC0sebtNm2DA_1778092234
Received: by mail-qt1-f200.google.com with SMTP id d75a77b69052e-50fba8d8c40so170025401cf.3
        for <linux-mm@kvack.org>; Wed, 06 May 2026 11:30:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778092233; x=1778697033;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8/RGMDkKi/0TpsTIZWOvUcys+qwq15zYbJSL/7mQVIU=;
        b=mmZBmKnMJdMvr2n2Z5RvW/1y0AuJN0NQGPofCOflX8eWAdIGwKcH43cKqYvRh24Olr
         ks+xVXfomS4yb89qc9t1oUTeRpDoY94s6jpqnDATJTspW1uS12RwDxgQIf2LT24tGr93
         8B/HW9O7O645EjNoy7v3h1SgZFFBsKlDc9h1hE4QBpNAhlnEmUy8JOld9Kuk08OIKdK+
         dkhdfdN8uDSndJFHb92XAcHc2g3UH7rTUu+lQ08Lf4hDq+/RuXTZRUvhM99rzj6wQDjH
         MEsSuBpOknt9dApaZDMbFZOKw+nezXAd4fZ+OFvRrX7/Z/rnkcxPUlCRVg+yia2ppYN8
         wxZw==
X-Forwarded-Encrypted: i=1; AFNElJ/f8/fZF2nbpTSsynlcyVPqDSpLbvt0X2tgFi8pM5DSW5j6cf151XmlHy3Wxn+wVrg4VZr9sH8G4Q==@kvack.org
X-Gm-Message-State: AOJu0YxV6klxl7dVp7bcRkNQyEhbJjI9nWjbC+hwQSaePim0HH0+gNtM
	hXGLdTZKLgZCJFVvYNLvwvsyQTRVu4wAuwGFMdpgm83kX3AwR+L/zwl+wXcZvsX+8dDAo1QL1h/
	ejjRZZ8AeTs9g5WXSggB/Hms8OIcE8ryIXlvughGwGUZhUEphO3iULUiMp+kW
X-Gm-Gg: AeBDiesPDMLxYvRrksD+4Q837wpmHiAOqtgCYkzVTZlGBFAaGIl96aqY3u90Klqiwg4
	+MjkPoDoy3C7+vJ5mP796MFaY0TQ+iZ1j3NOM21Nj722YzrdNhxl2iFvN2Y+RP1ETUMmjSrUfAp
	9D/Du7J2oP4UM7RcjXaE6XPjlKMOuVswMh+vSSE6wrlc6EgU3H4fSvBDTpq0u6yrGtiuBVlUUmo
	6EHI7x8TybcOm69LaHs7z0EbTSrsT45sfCMHigWfcUaVyW1Nf6NcqjPc+cvYm7qUAub2HUc1lLZ
	QnIHUgSzXgR4ZgURfXWnpFVEtoWTD+OnG53htpGpwSKcN3u5ILRGczZGnsS9nMyToDL+biJkSYZ
	iQ1Gn3O3OyGUUCA+zAaI/1eHpIqvG99lzblPrqYUNxcf1eQ==
X-Received: by 2002:a05:622a:1b15:b0:50e:5ca8:8c2a with SMTP id d75a77b69052e-51461be0e30mr62123111cf.2.1778092233349;
        Wed, 06 May 2026 11:30:33 -0700 (PDT)
X-Received: by 2002:a05:622a:1b15:b0:50e:5ca8:8c2a with SMTP id d75a77b69052e-51461be0e30mr62121861cf.2.1778092232505;
        Wed, 06 May 2026 11:30:32 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-51040b5e8b4sm178062701cf.23.2026.05.06.11.30.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2026 11:30:32 -0700 (PDT)
Message-ID: <cff55de9-3689-4fa4-b468-59083958c2c5@redhat.com>
Date: Wed, 6 May 2026 14:30:21 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: (sashiko review) Re: [PATCH v4 7/9] treewide: introduce
 arch_has_pmd_leaves()
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <85674af7934cd363ceadd1d4f2b784d833a183cc.1777663129.git.luizcap@redhat.com>
 <415c4158-f87d-4a61-8aab-9f957b1fe1c8@redhat.com>
In-Reply-To: <415c4158-f87d-4a61-8aab-9f957b1fe1c8@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: XKHGbn84RVpNRd2R-7ctNN7K3qt3bcxvsxjnEZjKJyc_1778092234
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: B777540018
X-Rspamd-Server: rspam04
X-Stat-Signature: 1hkhrefmf4wi38y615az8cb99yi6muy4
X-HE-Tag: 1778092236-463011
X-HE-Meta: U2FsdGVkX1/pDsGcEZt1zZ/ol1vREVBvMuzjGENCEftzVS2bNXJO2wP//jrx0wrWmgJYxykN4itOtvjaHGfCyWrlVniU3gXquW3/1RKThOzv+1A4bcFYDarkuIb/yljBWi3nXOWVKKxpPunYSh9aK2EpyhTItWuN+PGMxAT1ad+ZhfgWtwjYNs98/bYrwm+WP+SV0cvXsxlDIWN5jdv1+9fz/XSA/9zrQRAURl1FcMmNdYuwoBRX4Pf8De0Q9F134ddKyoUXVFKowtLP7iv380svAal8ZOqEXEkr1q3CXXus4v85wY4+n6Rv2S70UvGFNe58Ach5kZyqgzcayVooV+AzrHOc6MyOEBwgjc0OCmjp2x6lGCjFHHMq6SZSK9v8W41J8+jp7zx8rgeGebmTJmc4NPFWMxOZY9cA695z2GyuB4NLY2gHYT+hvetWURXM6eh7/TURGdwvmMoAAkebx0PlkfUAg8kUrlmppyL+Cg0mCee+jos1I1Bqshrg2iE7zT15LffAsHS6PLyWtFv57T8mQeKx6i8lWLg5Z+bmS5FGihgnjiC09E+SNfU3EBG5LfNMO1+A2ZXZxK2R3WTtpGWrFbMOr7OZgb6QsipKEl0Ak3+cOlXBRmG+YzgUm7KeJq7AUJAYg7B9U1jHzNlHNjizW9VL8OE/f++LQO6X45XVzclXT0h9nfG6xEeIQ9sp0PheirZL69FfYlEuiGtt9Z3UT/J0XrfCbGMe13vUmsUN6pPLl3h0d8p3JV9C7SpXiXl7XJPz5UVZljz9aUhlGiUxIHEah81OasHCsnAP50gdnXWbDIU49NDkslk17bIV1MMc/LTmfIR9Sv+RXE0r0oGfBN3lI0s/9j1xWqnVP7jKU1B48iR49SV4ficmGkukVV7r2pm23tdXbFsUkwwi9Q3KzFKLqs7FFo1SZU7LaP3RcTHeO19cfbLxICm9rlC145bsRVprJ0Z/eVXfndx
 njCDUUTR
 CGGMQYwDFDg/pkR/dJ/D7v+BjfH9U8KPUH1R2GuRdR1Vw2j1gAwmyg24T6WIe9oHaCbNMME0QVvdC+pb9TSxT1tD0bLjOv68GSr/jMubCuBAdyjkulff4iyukPfWRmzmulisc935V+jbmJUtZpsqLmpIeEmBHV8nw+40135Qu1Vn0SLX3G3y4eVBeZMMwBbr06I+Zb2KWkeCREs/qcd4U1FIxeF2dPTzc1gwE+krAGQZvDdQN7ZHpCNH7aVAz2iqyQ6KXskxCLMiI4LjOHAF9xf8zH6BDtMTBhiJCPtjwbYWuuGEdXxU0ouA0hdSGoDvwUiVkO1CDbTxeZ0lGzBaRw5mU4RS1yP+7QqR+5WhdJ6EGDZMttovOOs6iRoH73adb4p79m2WMu6Xws6zeT+HeYRqhtIXsl69bIT5OK92hcuttZnMG3qZoPnHUXtnh1ZSBhoA0p6SREsNq09xmSjbSWyC37bTcxQCanSOv1+LS5C2raxaLYVlDYZ2GXQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-06 14:22, Luiz Capitulino wrote:
> On 2026-05-01 15:18, Luiz Capitulino wrote:
>> Now that all the has_transparent_hugepage() callers have been converted
>> to pgtable_has_pmd_leaves(), this commit does two things:
>>
>> 1. Rename has_transparent_hugepage() arch implementations to
>>     arch_has_pmd_leaves(), since that's what the helper checks for
>>
>> 2. Introduce the default implementation of arch_has_pmd_leaves() as
>>     IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE). This means that if
>>     the arch doesn't implement arch_has_pmd_leaves() we default to checking
>>     CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE as a way to determine if
>>     PMD-sized pages are supported
>>
>> Note that arch_has_pmd_leaves() is supposed to be called only by
>> init_arch_has_pmd_leaves(). The remaining exception is hugepage_init()
>> which will be converted in a future commit.
>>
>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>> ---
>>   arch/mips/include/asm/pgtable.h               |  4 ++--
>>   arch/mips/mm/tlb-r4k.c                        |  4 ++--
>>   arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>>   arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>>   arch/powerpc/include/asm/book3s/64/pgtable.h  | 10 +++++-----
>>   arch/powerpc/include/asm/book3s/64/radix.h    |  2 +-
>>   arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
>>   arch/s390/include/asm/pgtable.h               |  4 ++--
>>   arch/x86/include/asm/pgtable.h                |  4 ++--
>>   include/linux/pgtable.h                       |  4 ++--
>>   mm/huge_memory.c                              |  2 +-
>>   mm/memory.c                                   |  2 +-
>>   12 files changed, 22 insertions(+), 22 deletions(-)
>>
>> diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
>> index fa7b935f947c..a97b788315e2 100644
>> --- a/arch/mips/include/asm/pgtable.h
>> +++ b/arch/mips/include/asm/pgtable.h
>> @@ -615,8 +615,8 @@ unsigned long io_remap_pfn_range_pfn(unsigned long pfn, unsigned long size);
>>   /* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
>>   #define pmdp_establish generic_pmdp_establish
>> -#define has_transparent_hugepage has_transparent_hugepage
>> -extern int has_transparent_hugepage(void);
>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>> +extern int arch_has_pmd_leaves(void);
>>   static inline int pmd_trans_huge(pmd_t pmd)
>>   {
>> diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
>> index 24fe85fa169d..c423b5784337 100644
>> --- a/arch/mips/mm/tlb-r4k.c
>> +++ b/arch/mips/mm/tlb-r4k.c
>> @@ -434,7 +434,7 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>> -int has_transparent_hugepage(void)
>> +int arch_has_pmd_leaves(void)
>>   {
>>       static unsigned int mask = -1;
>> @@ -450,7 +450,7 @@ int has_transparent_hugepage(void)
>>       }
>>       return mask == PM_HUGE_MASK;
>>   }
>> -EXPORT_SYMBOL(has_transparent_hugepage);
>> +EXPORT_SYMBOL(arch_has_pmd_leaves);
>>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerpc/include/asm/book3s/64/hash-4k.h
>> index 8e5bd9902bed..6744c2287199 100644
>> --- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
>> +++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
>> @@ -165,7 +165,7 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>                          unsigned long addr, pmd_t *pmdp);
>> -extern int hash__has_transparent_hugepage(void);
>> +extern int hash__arch_has_pmd_leaves(void);
>>   #endif
>>   #endif /* !__ASSEMBLER__ */
>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/powerpc/include/asm/book3s/64/hash-64k.h
>> index 7deb3a66890b..9392aba5e5dc 100644
>> --- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
>> +++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
>> @@ -278,7 +278,7 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>                          unsigned long addr, pmd_t *pmdp);
>> -extern int hash__has_transparent_hugepage(void);
>> +extern int hash__arch_has_pmd_leaves(void);
>>   #endif /*  CONFIG_TRANSPARENT_HUGEPAGE */
>>   #endif    /* __ASSEMBLER__ */
>> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
>> index e67e64ac6e8c..b6629c041e75 100644
>> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
>> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
>> @@ -1121,14 +1121,14 @@ static inline void update_mmu_cache_pud(struct vm_area_struct *vma,
>>   {
>>   }
>> -extern int hash__has_transparent_hugepage(void);
>> -static inline int has_transparent_hugepage(void)
>> +extern int hash__arch_has_pmd_leaves(void);
>> +static inline int arch_has_pmd_leaves(void)
>>   {
>>       if (radix_enabled())
>> -        return radix__has_transparent_hugepage();
>> -    return hash__has_transparent_hugepage();
>> +        return radix__arch_has_pmd_leaves();
>> +    return hash__arch_has_pmd_leaves();
>>   }
>> -#define has_transparent_hugepage has_transparent_hugepage
>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>>   static inline int has_transparent_pud_hugepage(void)
>>   {
>> diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
>> index da954e779744..c884a119cbd9 100644
>> --- a/arch/powerpc/include/asm/book3s/64/radix.h
>> +++ b/arch/powerpc/include/asm/book3s/64/radix.h
>> @@ -298,7 +298,7 @@ extern pmd_t radix__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>   pud_t radix__pudp_huge_get_and_clear(struct mm_struct *mm,
>>                        unsigned long addr, pud_t *pudp);
>> -static inline int radix__has_transparent_hugepage(void)
>> +static inline int radix__arch_has_pmd_leaves(void)
>>   {
>>       /* For radix 2M at PMD level means thp */
>>       if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
>> diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
>> index d9b5b751d7b7..88a4a2eab513 100644
>> --- a/arch/powerpc/mm/book3s64/hash_pgtable.c
>> +++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
>> @@ -391,7 +391,7 @@ pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>       return old_pmd;
>>   }
>> -int hash__has_transparent_hugepage(void)
>> +int hash__arch_has_pmd_leaves(void)
>>   {
>>       if (!mmu_has_feature(MMU_FTR_16M_PAGE))
>> @@ -420,7 +420,7 @@ int hash__has_transparent_hugepage(void)
>>       return 1;
>>   }
>> -EXPORT_SYMBOL_GPL(hash__has_transparent_hugepage);
>> +EXPORT_SYMBOL_GPL(hash__arch_has_pmd_leaves);
>>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
>> index 2c6cee8241e0..33b165dbf3db 100644
>> --- a/arch/s390/include/asm/pgtable.h
>> +++ b/arch/s390/include/asm/pgtable.h
>> @@ -1799,8 +1799,8 @@ static inline int pmd_trans_huge(pmd_t pmd)
>>       return pmd_leaf(pmd);
>>   }
>> -#define has_transparent_hugepage has_transparent_hugepage
>> -static inline int has_transparent_hugepage(void)
>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>> +static inline int arch_has_pmd_leaves(void)
>>   {
>>       return cpu_has_edat1() ? 1 : 0;
>>   }
>> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
>> index 2187e9cfcefa..2edd6c9d789c 100644
>> --- a/arch/x86/include/asm/pgtable.h
>> +++ b/arch/x86/include/asm/pgtable.h
>> @@ -306,8 +306,8 @@ static inline int pud_trans_huge(pud_t pud)
>>   }
>>   #endif
>> -#define has_transparent_hugepage has_transparent_hugepage
>> -static inline int has_transparent_hugepage(void)
>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>> +static inline int arch_has_pmd_leaves(void)
>>   {
>>       return boot_cpu_has(X86_FEATURE_PSE);
>>   }
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index b365be3516bf..3d7eeb50c183 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -2273,8 +2273,8 @@ static inline void __init init_arch_has_pmd_leaves(void) { }
>>   #endif
>>   #endif
>> -#ifndef has_transparent_hugepage
>> -#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
>> +#ifndef arch_has_pmd_leaves
>> +#define arch_has_pmd_leaves() IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE)
>>   #endif

[Forgot to include the review, doing it now]

"""
When CONFIG_TRANSPARENT_HUGEPAGE is disabled, do we bypass crucial runtime
hardware feature checks on multiple architectures?

Because the architecture-specific declarations are often placed inside
CONFIG_TRANSPARENT_HUGEPAGE blocks (as seen above, and similarly in
arch/x86/include/asm/pgtable.h and arch/s390/include/asm/pgtable.h), they
will not be exposed to the generic headers when THP is disabled.

The preprocessor will then fall back to the default implementation here. Since
architectures like x86, s390, and powerpc select
HAVE_ARCH_TRANSPARENT_HUGEPAGE in their Kconfig independent of the THP
setting, this fallback evaluates to true.

Will this cause init_arch_has_pmd_leaves() to keep the static key enabled,
making pgtable_has_pmd_leaves() unconditionally return true at runtime even
when THP is disabled?

If this happens on older hardware without these features, could subsystems
like DAX that rely on pgtable_has_pmd_leaves() attempt to map PMD-sized
leaves and cause page table corruption or hardware exceptions?
"""

Although a bit of a corner case, this is a real issue.

Checking on x86, the problem is that the arch's implementation of
arch_has_pmd_leaves() lives inside a CONFIG_TRANSPARENT_HUGEPAGE block so
it won't be built when CONFIG_TRANSPARENT_HUGEPAGE=n which will cause
arch_has_pmd_leaves() to default to true without the proper hardware
check. I'll check the other archs and get this fixed.

>>   #ifndef has_transparent_pud_hugepage
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index 970e077019b7..4da10e94bbb6 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -969,7 +969,7 @@ static int __init hugepage_init(void)
>>       int err;
>>       struct kobject *hugepage_kobj;
>> -    if (!has_transparent_hugepage()) {
>> +    if (!arch_has_pmd_leaves()) {
>>           transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
>>           return -EINVAL;
>>       }
>> diff --git a/mm/memory.c b/mm/memory.c
>> index 90b2d9e84320..c62fce83b8d0 100644
>> --- a/mm/memory.c
>> +++ b/mm/memory.c
>> @@ -169,7 +169,7 @@ EXPORT_SYMBOL(__arch_has_pmd_leaves_key);
>>   void __init init_arch_has_pmd_leaves(void)
>>   {
>> -    if (!has_transparent_hugepage())
>> +    if (!arch_has_pmd_leaves())
>>           static_branch_disable(&__arch_has_pmd_leaves_key);
>>   }
> 


