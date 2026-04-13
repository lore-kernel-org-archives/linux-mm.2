Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1FDDEF34C62
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 15:32:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80ABA6B0093; Mon, 13 Apr 2026 11:32:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BAD56B0095; Mon, 13 Apr 2026 11:32:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683036B0096; Mon, 13 Apr 2026 11:32:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 559D56B0093
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 11:32:45 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 029221B7006
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:32:44 +0000 (UTC)
X-FDA: 84653925090.15.CD62957
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6536120005
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 15:32:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y8+8xS5g;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776094362;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOHUOP4Y3/UMpOmBHfK5O1vmalazLAO3iEGUAb28svQ=;
	b=QxVXKnAT1jwyILuxIZae/0Z1gvBywPdaW2vyOFYd+S6+9BpaGDOXZ1+E5cLceTggYoQbTU
	PT8e8g+g+SmImzDT3opmBGtj1LO5VfUjWayITnqZ+tdttMDTKVRxnn7Z34s3gl1SDyjU9k
	LDdYUAQP36goHlOAFoT9uZsC1kXjziw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776094362; a=rsa-sha256;
	cv=none;
	b=cqac2vEaA1OwSZA65Ac7yBVgU/L6EZs/1ymYmDbV3yK1PPHydgapIGtcrgEIp2Ww7LjzOR
	36wbp8J/KjgbUP62Qkyxj5ny5Z38a0aM7sKatuJ2YcVb6ijDkw9ORSh6zi2ZbMYTlsPISg
	wVdCUgC269nHIGL0n3vfGLquZdC0Y/g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=Y8+8xS5g;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1776094361;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hOHUOP4Y3/UMpOmBHfK5O1vmalazLAO3iEGUAb28svQ=;
	b=Y8+8xS5gxj5MaaTy7MLRByrLpxO3+/Lx88NMrkyO/u4PHgf/mhvBrtd+RXDPno55nRk4iU
	pgcCNxxOY/nYiazfwe01jhwHkpLJNUY2QAPZNba7z+70la9BjampF0zlDM5G+9caAHKnVm
	w3Zf7qHGuiCuJImmWg0VmrjizRO/yd4=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-204-gFucf2BRP9id_Q6mxVs2ZA-1; Mon, 13 Apr 2026 11:32:40 -0400
X-MC-Unique: gFucf2BRP9id_Q6mxVs2ZA-1
X-Mimecast-MFC-AGG-ID: gFucf2BRP9id_Q6mxVs2ZA_1776094360
Received: by mail-qk1-f198.google.com with SMTP id af79cd13be357-8cfc1634e43so489119485a.0
        for <linux-mm@kvack.org>; Mon, 13 Apr 2026 08:32:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776094360; x=1776699160;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hOHUOP4Y3/UMpOmBHfK5O1vmalazLAO3iEGUAb28svQ=;
        b=gyq5mxgP2v3vy/kTwXihIZcLKEmCK4P/gVQs3GUAUQfYmhzh5MB2aF3B/RxQZ6WBfZ
         DoptUaiIsybYdEcjWR4bK/H8jn/bd1vIaGJotRKROezNJ24B9m9OVFJrcdNkRyIKd4Fk
         RJLLBDMuoDPgYP+5oc1n5uwQK1z94nBk2S9oem0kXmBpmbRMiqh2MuTdRC6leT3yGePp
         CUcvBSwQj4fBgwS0Gw9XA0Zl5h98XLB5Dn7b2nbyxRFT+/pU+jj6gx/tNDBQQtXOcjnQ
         AeW4A+85X/UnC7/jLbkQIDhVdAJYyVNIkWKmlh8njWjkbb+UOPk73fr539yVn0jtiAUa
         5CEQ==
X-Forwarded-Encrypted: i=1; AFNElJ8lbATXUBJh5D8dbeRRy3lzbO2G7wSwv8vTn1cMgulxaKwGWV5CsOIXPx/vtt5fYZtzZ5OT1hoLnw==@kvack.org
X-Gm-Message-State: AOJu0Yw6fuufe3CbYfgDubdZFkLu1xPPqh9DA0x5iTUJitOsxCOjaXWr
	7+5794okxEsSh9Ffs4f7KIlTOxbCWBey6VfWjULSmY3syXdoJRnH/7Kq43bTrEmzUO/oPHpZxgI
	fqWqepFqAXKVXubWNAiHH/cW+BOyRrqfPXxICyNEWfiAvZT+nZixt
X-Gm-Gg: AeBDietNpBDt9sAGuuuUIWDBcNpT91imrDBQCySI++DlUEd7zVcH9NNdaeQcnMzBOb8
	LzVGbpO8H3ihy/aMnFTivwT1pm+s91lP2z6+aYIHgkUicifaRRUr1U0ZKwjPnJREfpNtECLD4ag
	VvAQu54I8QdMuJVolY0i+cMvvT04GF7gwSA5chSKIPlmUbIMRx612crazM8kYxoh8whJIdPhw/k
	35LCXV00/fG1n4hcO+xE8dyPLmspIo6GFetgJmT0kKFasDBrfGuXlJYqTbptFaYM/6GMqxVZAJr
	z2SJr7WZztcNTVLXmhi79st/vyITtnSrvEuSIGSqeYGbubRyQlM4AxxkYgm3V0LU8TIJGJjvx7Y
	fTir8Vh8fZPVkEylUlA/0UFkbRw==
X-Received: by 2002:a05:620a:318b:b0:8d0:27b8:fb7 with SMTP id af79cd13be357-8ddcff98825mr2066534585a.46.1776094359657;
        Mon, 13 Apr 2026 08:32:39 -0700 (PDT)
X-Received: by 2002:a05:620a:318b:b0:8d0:27b8:fb7 with SMTP id af79cd13be357-8ddcff98825mr2066528585a.46.1776094358967;
        Mon, 13 Apr 2026 08:32:38 -0700 (PDT)
Received: from [192.168.2.110] ([69.159.169.238])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb9930572sm882765185a.45.2026.04.13.08.32.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Apr 2026 08:32:38 -0700 (PDT)
Message-ID: <056d8383-d373-436b-8841-6350425c52eb@redhat.com>
Date: Mon, 13 Apr 2026 11:32:27 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] treewide: rename has_transparent_hugepage() to
 arch_has_pmd_leaves()
From: Luiz Capitulino <luizcap@redhat.com>
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1775679721.git.luizcap@redhat.com>
 <4f640655f26b4cc2056a62bebfd570686dd6dc3c.1775679721.git.luizcap@redhat.com>
 <A1A0BC2F-A9AF-4929-8774-C5841A3F6020@nvidia.com>
 <315f7856-82aa-4566-8c16-1d96314b235c@redhat.com>
In-Reply-To: <315f7856-82aa-4566-8c16-1d96314b235c@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: ZtrTmBEYyR_N2LeYmwIPXs5T9CC-ak4dKZ1XXPWxBkk_1776094360
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 6536120005
X-Stat-Signature: 873iqciqj37txk6pby4zu3fcjfkwor16
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1776094362-182324
X-HE-Meta: U2FsdGVkX1/8fir9cP3LfsH8sRD0CnLx7svSsD48QsjqJAXqfzLQf1It/na/Y/h1R6SX1EWAIF7JWiP9Qwejurgg1uppd47FwgDHNOTtSUPdtlDzcLzOl5BzOs2F0AjmZxDGyuZun7xAF4V11tcbvCNf0KA+3aDLat3kFaK39cCeGixuN/g3SzO7r0rZgf48OhVfAiqDgz8Dei8BYJOdmDrdluRiaP2fK4O94FucFzF8Subg/GcTDMzjMr7lnsDgtpRVQRiZHBIH13TJDwcKK30839tfkEOD1U1g9IJBMTGzQ89fOW9nUOTRKJyGWPclS9gZlDwnJ2PgfPMYonX2temtTx7R28HZCvwVhlPSaY0Fsmg3uW7Npg1svzagCmMqTK+UvPZVHlZcE7aszomyjaOD2eynauV44n9a1TGq9FA/PoGB/4ax6N4sbss0pO+B7nNEmx5rckLThi0UBHMsKRbwmrBn41Gz1u6EgUIXny+TejsB5dnIvI1Q3WLeNDsbSJsT0qlh/Vs+www5/aZYm9rpUSvO5ygGV/AX6OwqGySGpjfIVQGY6Y1qLpon1K//etDeuN+lBD+ls8Vjl5qHTj9DW3ZaKUD0hweUj/aL6HJ7ps3rR1vznALOOnW04Q9jX/83cXxxmv5GA/mvguGVr8tPJxHckPo+qvX81ihy2Hbn8NiDQvNsW+CcckXKlEjqLkXgXCuCnTTxYOR21AxCyb2ni2H8WwPJ8sV5e2zoDzb4YCSU9mKPycrzg3ibCmagsIa+1iarglwTvTxEKHG/OgHwuWZ3dGXd8sHbg6LddY5CKJEv3wFUJbAmNRXV0JJ/ca9DtI7qravF1f5CtVprdFQFObULJl5daMRWSaPE7HiM8kDkZQ3YdpZvZJN3SWff10lBGZEU/G07cNR65hosw+GKVVsxhcwScXUoxOv44/lDoB1lUPm18vfYy1Z53sXONVokegsswB3hZhr35WN
 zFlL/nal
 O92ns1HXEY1Z3vAp3C669i19V+3h6pDH+ZyfLMejsdZVmZBfeFfb6LM/EHt/z0ckHbHtk2kQVS3JG5sd4AaCuBMS91z25z48vShrYQ0PyiuJH8AlfjhqIcxdEnEz/hCYyfPo8po3+/W+9We5TnZM0IM81eURoEywwX7hpUSy709g5y3HBf1Wbz4WC12f4FvZigEjk0lF3JUJ7K6mPR2YEPQDE+Dmc0B4U2FyPwkQJQLolnKQpu2qvgmV9w5j9zSKJXb5FsXw8CICQJ/wVVJgdiscWC2eU8zKK5Mcs2ThlrOJPQml14Zlz8usPTIxAybdkilr9WgHhmin9Y65Z2mHVDtWssE4n34Mpy4S22NWhOGjxiRYR+oC35IlIlZ6r+JI97QbfmFM08r1JgBMtnRP0GYIUBU91Xm9Thk8/Mkq8K6iVHC4XgqAOZ1bBRFLoSNY46wZijoQ5I69OFUUi0H9tjMNvAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-09 15:43, Luiz Capitulino wrote:
> On 2026-04-09 11:41, Zi Yan wrote:
>> On 8 Apr 2026, at 16:23, Luiz Capitulino wrote:
>>
>>> Now that all the has_transparent_hugepage() callers have been converted
>>> to pgtable_has_pmd_leaves(), rename has_transparent_hugepage() to
>>> arch_has_pmd_leaves() since that's what the helper checks for.
>>>
>>> arch_has_pmd_leaves() is supposed to be called only by
>>> init_arch_has_pmd_leaves(). The remaining exception is hugepage_init()
>>> which will be converted in a future commit.
>>>
>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>> ---
>>>   arch/mips/include/asm/pgtable.h               |  4 ++--
>>>   arch/mips/mm/tlb-r4k.c                        |  4 ++--
>>>   arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>>>   arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>>>   arch/powerpc/include/asm/book3s/64/pgtable.h  | 10 +++++-----
>>>   arch/powerpc/include/asm/book3s/64/radix.h    |  2 +-
>>>   arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
>>>   arch/s390/include/asm/pgtable.h               |  4 ++--
>>>   arch/x86/include/asm/pgtable.h                |  4 ++--
>>>   include/linux/pgtable.h                       |  4 ++--
>>>   mm/huge_memory.c                              |  2 +-
>>>   mm/memory.c                                   |  2 +-
>>>   12 files changed, 22 insertions(+), 22 deletions(-)
>>>
>>> diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
>>> index fa7b935f947c..a97b788315e2 100644
>>> --- a/arch/mips/include/asm/pgtable.h
>>> +++ b/arch/mips/include/asm/pgtable.h
>>> @@ -615,8 +615,8 @@ unsigned long io_remap_pfn_range_pfn(unsigned long pfn, unsigned long size);
>>>   /* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
>>>   #define pmdp_establish generic_pmdp_establish
>>>
>>> -#define has_transparent_hugepage has_transparent_hugepage
>>> -extern int has_transparent_hugepage(void);
>>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>>> +extern int arch_has_pmd_leaves(void);
>>>
>>>   static inline int pmd_trans_huge(pmd_t pmd)
>>>   {
>>> diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
>>> index 24fe85fa169d..c423b5784337 100644
>>> --- a/arch/mips/mm/tlb-r4k.c
>>> +++ b/arch/mips/mm/tlb-r4k.c
>>> @@ -434,7 +434,7 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
>>>
>>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>>
>>> -int has_transparent_hugepage(void)
>>> +int arch_has_pmd_leaves(void)
>>>   {
>>>       static unsigned int mask = -1;
>>>
>>> @@ -450,7 +450,7 @@ int has_transparent_hugepage(void)
>>>       }
>>>       return mask == PM_HUGE_MASK;
>>>   }
>>> -EXPORT_SYMBOL(has_transparent_hugepage);
>>> +EXPORT_SYMBOL(arch_has_pmd_leaves);
>>>
>>>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
>>>
>>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerpc/include/asm/book3s/64/hash-4k.h
>>> index 8e5bd9902bed..6744c2287199 100644
>>> --- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
>>> +++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
>>> @@ -165,7 +165,7 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>>                          unsigned long addr, pmd_t *pmdp);
>>> -extern int hash__has_transparent_hugepage(void);
>>> +extern int hash__arch_has_pmd_leaves(void);
>>>   #endif
>>>
>>>   #endif /* !__ASSEMBLER__ */
>>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/powerpc/include/asm/book3s/64/hash-64k.h
>>> index 7deb3a66890b..9392aba5e5dc 100644
>>> --- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
>>> +++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
>>> @@ -278,7 +278,7 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>>                          unsigned long addr, pmd_t *pmdp);
>>> -extern int hash__has_transparent_hugepage(void);
>>> +extern int hash__arch_has_pmd_leaves(void);
>>>   #endif /*  CONFIG_TRANSPARENT_HUGEPAGE */
>>>
>>>   #endif    /* __ASSEMBLER__ */
>>> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
>>> index 1a91762b455d..e4d9b884af5c 100644
>>> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
>>> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
>>> @@ -1121,14 +1121,14 @@ static inline void update_mmu_cache_pud(struct vm_area_struct *vma,
>>>   {
>>>   }
>>>
>>> -extern int hash__has_transparent_hugepage(void);
>>> -static inline int has_transparent_hugepage(void)
>>> +extern int hash__arch_has_pmd_leaves(void);
>>> +static inline int arch_has_pmd_leaves(void)
>>>   {
>>>       if (radix_enabled())
>>> -        return radix__has_transparent_hugepage();
>>> -    return hash__has_transparent_hugepage();
>>> +        return radix__arch_has_pmd_leaves();
>>> +    return hash__arch_has_pmd_leaves();
>>>   }
>>> -#define has_transparent_hugepage has_transparent_hugepage
>>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>>>
>>>   static inline int has_transparent_pud_hugepage(void)
>>>   {
>>> diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
>>> index da954e779744..c884a119cbd9 100644
>>> --- a/arch/powerpc/include/asm/book3s/64/radix.h
>>> +++ b/arch/powerpc/include/asm/book3s/64/radix.h
>>> @@ -298,7 +298,7 @@ extern pmd_t radix__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>>   pud_t radix__pudp_huge_get_and_clear(struct mm_struct *mm,
>>>                        unsigned long addr, pud_t *pudp);
>>>
>>> -static inline int radix__has_transparent_hugepage(void)
>>> +static inline int radix__arch_has_pmd_leaves(void)
>>>   {
>>>       /* For radix 2M at PMD level means thp */
>>>       if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
>>> diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
>>> index ac2a24d15d2e..f7933c52cca9 100644
>>> --- a/arch/powerpc/mm/book3s64/hash_pgtable.c
>>> +++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
>>> @@ -370,7 +370,7 @@ pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>>       return old_pmd;
>>>   }
>>>
>>> -int hash__has_transparent_hugepage(void)
>>> +int hash__arch_has_pmd_leaves(void)
>>>   {
>>>
>>>       if (!mmu_has_feature(MMU_FTR_16M_PAGE))
>>> @@ -399,7 +399,7 @@ int hash__has_transparent_hugepage(void)
>>>
>>>       return 1;
>>>   }
>>> -EXPORT_SYMBOL_GPL(hash__has_transparent_hugepage);
>>> +EXPORT_SYMBOL_GPL(hash__arch_has_pmd_leaves);
>>>
>>>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>>
>>> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
>>> index 1c3c3be93be9..e638d914fbad 100644
>>> --- a/arch/s390/include/asm/pgtable.h
>>> +++ b/arch/s390/include/asm/pgtable.h
>>> @@ -1776,8 +1776,8 @@ static inline int pmd_trans_huge(pmd_t pmd)
>>>       return pmd_leaf(pmd);
>>>   }
>>>
>>> -#define has_transparent_hugepage has_transparent_hugepage
>>> -static inline int has_transparent_hugepage(void)
>>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>>> +static inline int arch_has_pmd_leaves(void)
>>>   {
>>>       return cpu_has_edat1() ? 1 : 0;
>>>   }
>>> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
>>> index 1662c5a8f445..8fe95270b713 100644
>>> --- a/arch/x86/include/asm/pgtable.h
>>> +++ b/arch/x86/include/asm/pgtable.h
>>> @@ -314,8 +314,8 @@ static inline int pud_trans_huge(pud_t pud)
>>>   }
>>>   #endif
>>>
>>> -#define has_transparent_hugepage has_transparent_hugepage
>>> -static inline int has_transparent_hugepage(void)
>>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>>> +static inline int arch_has_pmd_leaves(void)
>>>   {
>>>       return boot_cpu_has(X86_FEATURE_PSE);
>>>   }
>>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>>> index c4c5282f795c..4b52a3abeab5 100644
>>> --- a/include/linux/pgtable.h
>>> +++ b/include/linux/pgtable.h
>>> @@ -2222,8 +2222,8 @@ static inline void __init init_arch_has_pmd_leaves(void) { }
>>>   #endif
>>>   #endif
>>>
>>> -#ifndef has_transparent_hugepage
>>> -#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
>>> +#ifndef arch_has_pmd_leaves
>>> +#define arch_has_pmd_leaves() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
>>
>> Should this be
>> #define arch_has_pmd_leaves() 1
>> ?
>>
>> Since all has_transparent_hugepage() is converted
>> to IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && pgtable_has_pmd_leaves()
>> and pgtable_has_pmd_leaves() is basically arch_has_pmd_leaves().
>> The IS_ENABLED() is the same as IS_BUILTIN() here.
>>
>> Before this patch, if an arch does not define has_transparent_hugepage,
>> has_transparent_hugepage() basically means the arch supports PMD leaves
>> and software controls the availability of THP. Now you rename it to
>> arch_has_pmd_leaves() and setting it to 1 reflects its actual semantics.
> 
> Yes, you're right that the intended future semantics is: if an arch
> doesn't define arch_has_pmd_leaves() then the kernel assumes it supports
> PMD pages.
> 
> I originally kept arch_has_pmd_leaves() tied to THP because I was afraid
> of breaking the current callers who want to use PMD pages with THP. But,
> as you say, they should all be checking for
> IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) now.
> 
> I'll look into implementing your suggestion for v4.

In taking a second look at this, I realized that a better default should
be:

#define arch_has_pmd_leaves() IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE)

Since archs defining CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE should
support PMD pages. This is also consistent with
has_transparent_pud_hugepage().


