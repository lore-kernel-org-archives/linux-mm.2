Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41992F364B5
	for <linux-mm@archiver.kernel.org>; Thu,  9 Apr 2026 19:43:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E4A46B0005; Thu,  9 Apr 2026 15:43:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8BBB36B0089; Thu,  9 Apr 2026 15:43:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D2046B008A; Thu,  9 Apr 2026 15:43:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6E44E6B0005
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 15:43:30 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 02F7E8725F
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:43:29 +0000 (UTC)
X-FDA: 84640041780.27.7A4E328
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id AE1B91C0011
	for <linux-mm@kvack.org>; Thu,  9 Apr 2026 19:43:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SbueGpkX;
	spf=pass (imf20.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775763808; a=rsa-sha256;
	cv=none;
	b=hsTAkFIK0Pbb7RCut2Z9CWjrLRKEde8knSxnDhU3vS+8l1NtxtlYQW3i2woF6YX1F4OVn6
	xyEB4E2cQnUW+rziL4SMBGoAa9wi+7SvDQtrB2ozMfZ24DQzmTSCNA9lvWyNe/dGoZ6TzG
	wGdptkR+aaVFuNjh8rvu1kWCnAH8s/g=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775763808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ra6N3tqtIXjDa5n23KMu+Hf3WRKsDK7vMmZt4WPbudU=;
	b=lEUaabq2c/ERNqQyS2IBqto7qm5b1uoQMmi6eP01HnaVySyJvl8FGjA1BtSKUSJhV8Bpgj
	SsnTTQKRL6rT7ewVRDqz8+h1nCZUaFhS2g3LYjyMReE2zlWZdLCX5bhU3t+lz6f50LIm0j
	18vKxDTrYM6ebPB6XvZl9AhPJNEWd1c=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=SbueGpkX;
	spf=pass (imf20.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1775763807;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ra6N3tqtIXjDa5n23KMu+Hf3WRKsDK7vMmZt4WPbudU=;
	b=SbueGpkXT6h9rIM+65K7nJqme6AIFCY/iJ1ok1IJ2mBpoNmwE7sIJTaXf+IHc+H/mqewZX
	NoxUiU1BzyxszDpBWKGQIOJTF4nLj+frwGG0uIrJ6yMpUYy6mnEVGZ5WAKOhYjcnE9TO3l
	WIH3K5mQ80KrQrV+paef7oHcSzcTcZI=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-462-HyLDFjXpPDeNS2djlcD-qA-1; Thu, 09 Apr 2026 15:43:25 -0400
X-MC-Unique: HyLDFjXpPDeNS2djlcD-qA-1
X-Mimecast-MFC-AGG-ID: HyLDFjXpPDeNS2djlcD-qA_1775763805
Received: by mail-qk1-f197.google.com with SMTP id af79cd13be357-8cfcf23c0e1so244461585a.2
        for <linux-mm@kvack.org>; Thu, 09 Apr 2026 12:43:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775763805; x=1776368605;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ra6N3tqtIXjDa5n23KMu+Hf3WRKsDK7vMmZt4WPbudU=;
        b=leg3nyi+KA8bEcmRSJsj/AJMItuLBN1UDy8smdisyCJMj9ey0b+K6JXS5KOQf+qAfi
         2YxIEqdvirbbXKhBozMprCtL3g1u8XTqVZHpgsdDaXO+//5HttSWDzRnGrZsmDoxdkvN
         e2bMZj/VC7tbPsqoiYCY43JaYuX0jcggEL7pkhcC3BJVypNxWFfEmq0uewN4lMKsbTIP
         hjNMoznL9I9UkM2foFLhzoNVvPHbt5LGhTwcRRxSFheV7A+NDWF24EkP6Wq959CAYfZN
         AYjIulxbaJcG9d2/Enrlc9f3Y5AQp8CgeBCoW276bExT2k/suUY8+Ym4meU7OT8GjH5X
         HZyA==
X-Forwarded-Encrypted: i=1; AJvYcCWzHp8eZDiPKuidIDIBPTOjEugwh/aVAtI4qkmZAhHyx90u8XSLSuScSzzXyfiaU2fd8v07H6ZulA==@kvack.org
X-Gm-Message-State: AOJu0YzwgstvNLfmu9oWgjschrsv1nrhsIi3aUSkmLdMyZk+hNHLIYa0
	L3FP15EXhuicO0nsoXHlDPLVcaeYec2eYcthQed4MEn1m5WSWuiviDrUu4iFzCsc1NTbA8bl+nY
	09LMWmfZVlLEAZeg0wIc2WqYo12uWwb9lpf4r8tT/s8fzo+Pno+zo
X-Gm-Gg: AeBDietU0/3aIKN3RuaekGoB4TS+qx/DyXF76Cs+VyqoKibvwqlo5H2KfzaCw5WiDnr
	6UzdyhS9nfOSBX3Hn0eyNrLPRjwj+nvkXKyhoBLUxzSNSayfZjyJDX3SRK+YL3yyUueb/UxVduM
	utjbcIkzlkykxGes4jETfDm7S969BAWay84h9UpbwaOehS13CY+eOrvQU019X3WqbuNhclPjETg
	XhTR36YLIi4kWa8zcih4DtwiAScfmlAKvuEnp+yEDcXugftxm3WhDk0WGSydCPnNiipPWJe+sdF
	W1oMpdn2RYHnKZGStYXVBsgOxlCvlaxqp6B/IE7WQoYxhyYTYiStyruR1mRDZbmDF7RSguTX+gi
	WdB5fz85RoWcIp6yDiQH95RXABZHgy+ET5zEfg5QLZHoIeQjQfFm0rCyZq9ZH4wKO95x9TKcvQa
	UEGFejWYhdXpzu7XM=
X-Received: by 2002:a05:620a:290d:b0:8c6:ff8f:58af with SMTP id af79cd13be357-8ddcf7ab003mr27970185a.51.1775763805209;
        Thu, 09 Apr 2026 12:43:25 -0700 (PDT)
X-Received: by 2002:a05:620a:290d:b0:8c6:ff8f:58af with SMTP id af79cd13be357-8ddcf7ab003mr27965685a.51.1775763804677;
        Thu, 09 Apr 2026 12:43:24 -0700 (PDT)
Received: from [192.168.2.110] (bras-base-aylmpq0104w-grc-53-69-159-169-238.dsl.bell.ca. [69.159.169.238])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8ddb9738cd3sm28965585a.40.2026.04.09.12.43.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 12:43:24 -0700 (PDT)
Message-ID: <315f7856-82aa-4566-8c16-1d96314b235c@redhat.com>
Date: Thu, 9 Apr 2026 15:43:23 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 07/10] treewide: rename has_transparent_hugepage() to
 arch_has_pmd_leaves()
To: Zi Yan <ziy@nvidia.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ryan.roberts@arm.com,
 akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1775679721.git.luizcap@redhat.com>
 <4f640655f26b4cc2056a62bebfd570686dd6dc3c.1775679721.git.luizcap@redhat.com>
 <A1A0BC2F-A9AF-4929-8774-C5841A3F6020@nvidia.com>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <A1A0BC2F-A9AF-4929-8774-C5841A3F6020@nvidia.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: gvrpXUH2J2odqHf6WLvYhmd7vbcYsMneq4fJzmaYM74_1775763805
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AE1B91C0011
X-Stat-Signature: bddfp68188rpkbpfui74od11h1tgrp8n
X-HE-Tag: 1775763807-694264
X-HE-Meta: U2FsdGVkX1+L/N5E/+t+bW6zXyCYhX594H8eXAu2zE774q1TQ1Qd7oFCEgAHr6nJu+7EqbgJEE+7aQzcM8LTLh61FAgwNqlWk6Yy4dGY82m66Vl48V29aPwHnC3rAd1h8f+g7KPBu8+9fiecN+9QB34own1wmGY6cUqSX35YuXfi0dB+mru0vkklTW5yflEPDG4jc7TwPppl2kvTGJtWqVSxpoR3FWl3hGKcIXHNHd8tX5RYGvzkKsGXoSBQJwaJqZcAP3WBYKyes4hG8/LczzYmdvuItvVCvnScA8nthzVO5X6bkTrAKplrtT4ihexNUNSRuRsTpxKNq5bfeRjFFuH9HCApzSTvL060JAK5d+Mkjr7D7YwaKcRqbVGHUM72APOL02/fLkY/VYIc4txWZePglc/jv4yBKJxwY/ylUQxV3TxmznfzIDakUFdnCDeh/S3bxVZ9f9X6lAfaBrU1LfeSOjyeNHm25H5YxGv/Xvc51FsOSONXWZ7DRPS1woK1/4EUGbjeDPNk3SRQb2lhq588ufbZrCvDxwzM5vqwf7JuZW0LnpEmh2iXJALVcL0wxSN3z9bZRNWgi+q3ttoHAOG51upngw7t4bWPvu4+Y3aeaqv4t4f4pPe76h3JWUGMBfZqdxE9VBXOZUuWh8fPCoZbP4gT89zx6ancoRNV7Kd+48EgKWWRt/5YX0nJdPVT3uWF71oWM7K381+Zg4ORLCx+frzmwmevdpF1p1GQAbHPWv+Ci2sGzzotrS8SXQfFyOss5T62gRpiqoSLsdCKbdwhzRlGmkN+cRZ0NP6tkgC7PKGZT+OjV+GZ/yXgj3P+Cg/Sij2jTpgpOm+mr8WRv5WTSRWfXHY/gLWJnd5a06ZfwroKXntp7BQLQlISjSRQJo6HHW256QVrwmZQxqn4zKIqR6vXjjRjSaX2/IcNNZ0waG1bM2RuJ4YP4ZPwzHUMiLboWxhSDc3IjvcWUqd
 eFMNtFjX
 z9zKsMW1FpivGtsSZ6x4oEDy131gSDp1JpmzekaqjBKz4Ot10Cjw35xJcyiji20fwP/Q2j4m3yBMI3SN8uHaLf4VjyG3tSqd9xzWVYv7O+xGcjFEHrSIx3L+/Z15c1XaSMy7pNvpNwELNlCxqTLCrP37GJqmGSucTAWqymgQ/wEiUgWRaK+uCBhwIfg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-09 11:41, Zi Yan wrote:
> On 8 Apr 2026, at 16:23, Luiz Capitulino wrote:
> 
>> Now that all the has_transparent_hugepage() callers have been converted
>> to pgtable_has_pmd_leaves(), rename has_transparent_hugepage() to
>> arch_has_pmd_leaves() since that's what the helper checks for.
>>
>> arch_has_pmd_leaves() is supposed to be called only by
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
>>
>> -#define has_transparent_hugepage has_transparent_hugepage
>> -extern int has_transparent_hugepage(void);
>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>> +extern int arch_has_pmd_leaves(void);
>>
>>   static inline int pmd_trans_huge(pmd_t pmd)
>>   {
>> diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
>> index 24fe85fa169d..c423b5784337 100644
>> --- a/arch/mips/mm/tlb-r4k.c
>> +++ b/arch/mips/mm/tlb-r4k.c
>> @@ -434,7 +434,7 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
>>
>>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>>
>> -int has_transparent_hugepage(void)
>> +int arch_has_pmd_leaves(void)
>>   {
>>   	static unsigned int mask = -1;
>>
>> @@ -450,7 +450,7 @@ int has_transparent_hugepage(void)
>>   	}
>>   	return mask == PM_HUGE_MASK;
>>   }
>> -EXPORT_SYMBOL(has_transparent_hugepage);
>> +EXPORT_SYMBOL(arch_has_pmd_leaves);
>>
>>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
>>
>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerpc/include/asm/book3s/64/hash-4k.h
>> index 8e5bd9902bed..6744c2287199 100644
>> --- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
>> +++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
>> @@ -165,7 +165,7 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>   				       unsigned long addr, pmd_t *pmdp);
>> -extern int hash__has_transparent_hugepage(void);
>> +extern int hash__arch_has_pmd_leaves(void);
>>   #endif
>>
>>   #endif /* !__ASSEMBLER__ */
>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/powerpc/include/asm/book3s/64/hash-64k.h
>> index 7deb3a66890b..9392aba5e5dc 100644
>> --- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
>> +++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
>> @@ -278,7 +278,7 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>   				       unsigned long addr, pmd_t *pmdp);
>> -extern int hash__has_transparent_hugepage(void);
>> +extern int hash__arch_has_pmd_leaves(void);
>>   #endif /*  CONFIG_TRANSPARENT_HUGEPAGE */
>>
>>   #endif	/* __ASSEMBLER__ */
>> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
>> index 1a91762b455d..e4d9b884af5c 100644
>> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
>> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
>> @@ -1121,14 +1121,14 @@ static inline void update_mmu_cache_pud(struct vm_area_struct *vma,
>>   {
>>   }
>>
>> -extern int hash__has_transparent_hugepage(void);
>> -static inline int has_transparent_hugepage(void)
>> +extern int hash__arch_has_pmd_leaves(void);
>> +static inline int arch_has_pmd_leaves(void)
>>   {
>>   	if (radix_enabled())
>> -		return radix__has_transparent_hugepage();
>> -	return hash__has_transparent_hugepage();
>> +		return radix__arch_has_pmd_leaves();
>> +	return hash__arch_has_pmd_leaves();
>>   }
>> -#define has_transparent_hugepage has_transparent_hugepage
>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>>
>>   static inline int has_transparent_pud_hugepage(void)
>>   {
>> diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
>> index da954e779744..c884a119cbd9 100644
>> --- a/arch/powerpc/include/asm/book3s/64/radix.h
>> +++ b/arch/powerpc/include/asm/book3s/64/radix.h
>> @@ -298,7 +298,7 @@ extern pmd_t radix__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>   pud_t radix__pudp_huge_get_and_clear(struct mm_struct *mm,
>>   				     unsigned long addr, pud_t *pudp);
>>
>> -static inline int radix__has_transparent_hugepage(void)
>> +static inline int radix__arch_has_pmd_leaves(void)
>>   {
>>   	/* For radix 2M at PMD level means thp */
>>   	if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
>> diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
>> index ac2a24d15d2e..f7933c52cca9 100644
>> --- a/arch/powerpc/mm/book3s64/hash_pgtable.c
>> +++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
>> @@ -370,7 +370,7 @@ pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>   	return old_pmd;
>>   }
>>
>> -int hash__has_transparent_hugepage(void)
>> +int hash__arch_has_pmd_leaves(void)
>>   {
>>
>>   	if (!mmu_has_feature(MMU_FTR_16M_PAGE))
>> @@ -399,7 +399,7 @@ int hash__has_transparent_hugepage(void)
>>
>>   	return 1;
>>   }
>> -EXPORT_SYMBOL_GPL(hash__has_transparent_hugepage);
>> +EXPORT_SYMBOL_GPL(hash__arch_has_pmd_leaves);
>>
>>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>>
>> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
>> index 1c3c3be93be9..e638d914fbad 100644
>> --- a/arch/s390/include/asm/pgtable.h
>> +++ b/arch/s390/include/asm/pgtable.h
>> @@ -1776,8 +1776,8 @@ static inline int pmd_trans_huge(pmd_t pmd)
>>   	return pmd_leaf(pmd);
>>   }
>>
>> -#define has_transparent_hugepage has_transparent_hugepage
>> -static inline int has_transparent_hugepage(void)
>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>> +static inline int arch_has_pmd_leaves(void)
>>   {
>>   	return cpu_has_edat1() ? 1 : 0;
>>   }
>> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
>> index 1662c5a8f445..8fe95270b713 100644
>> --- a/arch/x86/include/asm/pgtable.h
>> +++ b/arch/x86/include/asm/pgtable.h
>> @@ -314,8 +314,8 @@ static inline int pud_trans_huge(pud_t pud)
>>   }
>>   #endif
>>
>> -#define has_transparent_hugepage has_transparent_hugepage
>> -static inline int has_transparent_hugepage(void)
>> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>> +static inline int arch_has_pmd_leaves(void)
>>   {
>>   	return boot_cpu_has(X86_FEATURE_PSE);
>>   }
>> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
>> index c4c5282f795c..4b52a3abeab5 100644
>> --- a/include/linux/pgtable.h
>> +++ b/include/linux/pgtable.h
>> @@ -2222,8 +2222,8 @@ static inline void __init init_arch_has_pmd_leaves(void) { }
>>   #endif
>>   #endif
>>
>> -#ifndef has_transparent_hugepage
>> -#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
>> +#ifndef arch_has_pmd_leaves
>> +#define arch_has_pmd_leaves() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
> 
> Should this be
> #define arch_has_pmd_leaves() 1
> ?
> 
> Since all has_transparent_hugepage() is converted
> to IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && pgtable_has_pmd_leaves()
> and pgtable_has_pmd_leaves() is basically arch_has_pmd_leaves().
> The IS_ENABLED() is the same as IS_BUILTIN() here.
> 
> Before this patch, if an arch does not define has_transparent_hugepage,
> has_transparent_hugepage() basically means the arch supports PMD leaves
> and software controls the availability of THP. Now you rename it to
> arch_has_pmd_leaves() and setting it to 1 reflects its actual semantics.

Yes, you're right that the intended future semantics is: if an arch
doesn't define arch_has_pmd_leaves() then the kernel assumes it supports
PMD pages.

I originally kept arch_has_pmd_leaves() tied to THP because I was afraid
of breaking the current callers who want to use PMD pages with THP. But,
as you say, they should all be checking for
IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) now.

I'll look into implementing your suggestion for v4.


