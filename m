Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D95EACA5FF5
	for <linux-mm@archiver.kernel.org>; Mon,  5 Oct 2026 20:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A6ED86B0088; Mon,  5 Oct 2026 16:40:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A46DD6B008C; Mon,  5 Oct 2026 16:40:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9350C6B0092; Mon,  5 Oct 2026 16:40:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 69D006B0088
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 16:40:30 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DAA14160493
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:40:29 +0000 (UTC)
X-FDA: 85289740578.03.14BB684
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf17.hostedemail.com (Postfix) with ESMTP id 3901540010
	for <linux-mm@kvack.org>; Mon,  5 Oct 2026 20:40:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eiJZdfPl;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791232827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hW5P4NCcHfyGHbJZF1DNl1NQBu8IkdsCT0CTDVEsdgw=;
	b=bBiqpvnie84litUBgV8rHBj1BsiE6fOKJJ8NK7QH3yGoITKX1ZhBg0L2TZ0RN6Tu+jsP3z
	5pUiJJUayYZQ+H5uvVSwSGzIWDpeb2qHAkdrafnP6zS2OEgsaOgLSgdIYCkIlUN5gHmB0z
	vOtKThqH2APPdlkrvGbKNuFaZyZK0B0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791232827;
	b=BuDhKGtQRmsvepug9+AvLoUOy13JDiFgaqaZLQo7cJ2UnCel0T+z1Ka48mFviZbXI+fELV
	bC5sL70uazeFrNTRngEYHnnntToLYc5E/KBuPFSwL5LRXMFOVeaR91QH2p73qKTwmXKc+q
	LmgCb2/ty+iDFjgE0pt5Nkd6FkcaBJA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=eiJZdfPl;
	spf=pass (imf17.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1791232826;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=hW5P4NCcHfyGHbJZF1DNl1NQBu8IkdsCT0CTDVEsdgw=;
	b=eiJZdfPlK/vFaLtLo/M3S93+Kh+rLYhvjB6TjcyHGaFnB4zPCbX8AtgpGnJ3HRzV+z2qE5
	BLlPysAa7d7flJW68K4gL3eEcDEmB5j3gE1cYWnLgCHb8yrqL5x71XHsWOnKDjAxjO+u7y
	T0qDO9HTjzwUF+HoY4LiIsBHL7kGNi0=
Received: from mail-lj1-f199.google.com (mail-lj1-f199.google.com
 [209.85.208.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-311-4zz0Y31nMN6uCR6s8EbjJg-1; Mon, 05 Oct 2026 16:40:23 -0400
X-MC-Unique: 4zz0Y31nMN6uCR6s8EbjJg-1
X-Mimecast-MFC-AGG-ID: 4zz0Y31nMN6uCR6s8EbjJg_1791232822
Received: by mail-lj1-f199.google.com with SMTP id 38308e7fff4ca-3a781d434f0so15483821fa.3
        for <linux-mm@kvack.org>; Mon, 05 Oct 2026 13:40:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791232822; x=1791837622;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hW5P4NCcHfyGHbJZF1DNl1NQBu8IkdsCT0CTDVEsdgw=;
        b=EVjhTFnGOq9wgoAImA5Spsz1Pr3w676JA/v4WNWSU06g2zrt/7Z9gzazh6SbKnSaEI
         hLZnhFI2Wd6T8UOHB+FfsTzFazyNEV/WgTRkfImzdDwcZoGJptSKJf2xCYD8PwVp4EMi
         Y6gIjuhdXbrLO9s00w8ydEfrnbKZ9zUb1ZOCTafdsO6gOMs4lO7ZaeCk2HEW6i9LSE/u
         Vbq9mM7yVUM6oSeWxxUDbZMzZrV8IQJknAt/f6O3ThNe4a/F0ACRmerUzy8RqIxOY8zs
         sTrksSz4C9fuCFHUqu4hwncevePtrm99ZYDROxnFqX55wlmNdrKU3/6gax4cfMJg1LPQ
         Ut+Q==
X-Forwarded-Encrypted: i=1; AKwUvByaDCOE9yqqjmPN7vefS3LkmRZ0i7TkTcICt4k3hqqR9vF7qzyI0+PNlMn3m+LFqWdEYoDwN2qkZA==@kvack.org
X-Gm-Message-State: AFq9FYL61zsUFtX9QsXkACIiDeQfyT5cZk6jCO3BdwOaZwqSd1ckdrZ6
	G4kZeSlFMosXA30vGGKgYke27YUy+KHspBH1SUcyMUwU/RpvIPBnW5+23qgtKnPXSQ9Hugs5b5z
	Ma6TgpBR6Qh06nmU1K0RyK+50Ioeqa1Y5GxZqdIRxDKObmhAOnqzE
X-Gm-Gg: AYBFou1E/K+2XMc/hCBJLGoIlA9/1chuddfYEFwK7TxfFdn8y6+Gbx0tsNDfRkKlxix
	3/oETT586xeHgcKC6F0+xIiH2QUcuVdYKU1E3vV0bXb71d/KXxaaY/MMiM0GAzFpHEI4Q3xiCOE
	pkoKoGCHufUC2Twkx9+P0V+u5x/C8fLO+ZaaQTOgZNcyTPraTjo5unKc8u5n/6VYBu0AlayUaKP
	YsbCGvYvfHz16tqWl8wEh2D7H+cOLV+t/bObQxg6MaJPXpGB91xuoadlG7vJAeklWSBgXngttSY
	sfvmJaIG3YlIh0ky3rmMJ3Y87sdXWIVzvZZEIQxkT5SalwfUwVUhm6NEt7gY1rp1rP6mmoJn6dZ
	etBk=
X-Received: by 2002:a05:651c:1602:b0:3a5:b1f7:a7bf with SMTP id 38308e7fff4ca-3a974f64065mr22350591fa.21.1791232822110;
        Mon, 05 Oct 2026 13:40:22 -0700 (PDT)
X-Received: by 2002:a05:651c:1602:b0:3a5:b1f7:a7bf with SMTP id 38308e7fff4ca-3a974f64065mr22350491fa.21.1791232821598;
        Mon, 05 Oct 2026 13:40:21 -0700 (PDT)
Received: from [192.168.2.110] ([142.172.30.162])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-3a87e28b131sm45437081fa.1.2026.10.05.13.40.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 13:40:21 -0700 (PDT)
Message-ID: <9adb6aaf-6e50-4ab0-a021-2529807dff02@redhat.com>
Date: Mon, 5 Oct 2026 16:40:14 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 09/14] powerpc: move has_transparent_hugepage() out of
 THP guard
To: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
 "David Hildenbrand (Arm)" <david@kernel.org>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev,
 "linuxppc-dev@lists.ozlabs.org" <linuxppc-dev@lists.ozlabs.org>
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 dev.jain@arm.com, usama.arif@linux.dev
References: <cover.1789695931.git.luizcap@redhat.com>
 <05a71b6011a6eab7b096f262485fcb8b4987976f.1789695931.git.luizcap@redhat.com>
 <f54d5d75-5cc1-488b-b640-76163419cf4d@kernel.org>
 <25bb02df-a795-4e48-9de6-99f1ca799176@redhat.com>
 <802564f8-1376-451e-8308-6f98d1efb099@kernel.org>
From: Luiz Capitulino <luizcap@redhat.com>
In-Reply-To: <802564f8-1376-451e-8308-6f98d1efb099@kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: H786pmLFAxw9Av9kZ1i8xKq-yB0HCPEPBiOAAHsWurk_1791232822
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 3901540010
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: bwwwwic7we8tohxe96y53tf663q161r8
X-HE-Tag: 1791232826-897619
X-HE-Meta: U2FsdGVkX19DShWmMZuQFZRc8qdqy7hOHvt6sH3Oi8i2H69znBq3ehJ1QSrW/sLucQw3C2vWT44JUtX9cV6+a14oR3EyCDlNmVLmscx5ljwGidYyi7lgIWJ8FhCTXSxEGTkrM2fBIUTgRrwapIAN10HmK3OV/E6IOSR0Dz0Ji5glkXxwf1Z+/wO6Hdh8sXzSLABIBI78LeFHDr+5Y4FWYqyp2SamfU8Txxlawcs0M6YF0M3I5KRMXsq7izma0nakDG3Fo2CaGtZ8BaRU5gPYDshYnTRRW6aBCt+dIwqTiAIel4RD1V/BALQoML8TgyFXlTUejEp4spg/u7NOGOC8WU8xMYF8CBVqW2IdtuT6+ueD8qoNiRtc5KU3qf50+aJdTDemyvbvIBmWvGNm7Rkgp57R93EdRJ5C+jRn5wsqXwlRyyZckSxWZUYkuk9VGG4D2fIXwUuqxe79rVI6g5cGI7ey5RvppTffCsAF0BxhqsplJvZKi45hMBOQ6OR4vuO2x21PUoBwpGqGTRc8rp2FYy45WPtfPZqBUPWojQ5h+CNqmA5whLVaZmEnmgX2CQxGHpV0rpPdvsl3aDbXAl/YfL4tshJsScsCAf7Ql/dBA2gTOGwaJzJlo+7X+EhHnshDRTOvpMYxoNfsUpIRHD2TPGbj+njSzF9Vn6IZYVJ2E+38g5qb3TmNmIAQFE/gA68nJ2+ouh0N0rh1W6NPCOTw1Tq+A8QR3hKfpXXb9v+CPeoIwEtoezCyQFg/lWmSpUXLUegUQpsOJMevmW+k/hZegmHUfgdW6rhv2+iAuNo+LlqP4TBM0x9oE+fJuAq6k3snxPrJW8ZMbSHH6zD0O/neYYZD18b+/3iBX6RoHJwtOqPWiS+K5LQ7SZXu2A2OwhFIZGq8DtEPoV1ZOunVmJovySlpyULSaDKrsWRu020V8tnqh6uzuBX6y3HMpGt9iuss0+bdAo2Fv4+aeMc87JR
 DanBdgNu
 Po4NgH4DpLjb8FWJEwzocOrXeaqr6ePEc+D1JULUSLMuYzC0Hagr68szXagvuRJLlh6N7emQtGpAetH1cjz9U6tvyQWO9i1mQMyCDK+63L6RndHCIBeQe3Gl9jVBoR7kCvL2/yke4oFl8IqUsfATfetYcBgg/NhF4YnRA7UBTtaDG74+k6yLtO2GSUWvujX87yuo3G7aklRRJztep+2cR/PsXEmN3luW4xEfOUZ0mENh7Vzl3MTedc68WvumuUfy5IYfsHc6Hwth+Tm3GZ6sYoU/jD3Ylge+nx6M4iC7+Ij+LTEqzGO8MeuKtpvUJ3se48yza96v3Iql94IX6NY0i3s7tcuxp8HRLFDK7AEjH7MEe0RQHyE9DvoFwAkhvYnaqNdnci+BebPaQSi9ydMYqVbtGUQuBFFhrk4QhbS73RiNEOq6MFV8MU5MefdEtUINwx2V60IRs0RLjVBIgq1YeGZy9naHdqYzWz4xEptVvDwz+/zIcYPlGxfX6A59DWMfH7ktXvCftL/PlElNVhdsWiSSgWF/3AYKv9dqN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/5/26 12:52 AM, Christophe Leroy (CS GROUP) wrote:
> Hi,
> 
> Don't forget <linuxppc-dev@lists.ozlabs.org> when you address powerpc architecture.

Will do.

> 
> Le 03/10/2026 à 17:44, Luiz Capitulino a écrit :
>>
>>
>> On 10/2/26 3:28 PM, David Hildenbrand (Arm) wrote:
>>> On 9/18/26 03:45, Luiz Capitulino wrote:
>>>> A future commit will introduce a kernel API to allow for checking if the
>>>> CPU supports PMD-sized pages. This API will be based on the
>>>> has_transparent_hugepage() implementation but will be orthogonal to THP
>>>> and therefore must work when CONFIG_TRANSPARENT_HUGEPAGE=n.
>>>>
>>>> Move its definition out of the THP guard.
>>>>
>>>> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
>>>> ---
>>>>   arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>>>>   arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>>>>   arch/powerpc/include/asm/book3s/64/pgtable.h  | 18 +++++++++---------
>>>>   arch/powerpc/include/asm/book3s/64/radix.h    | 14 +++++++-------
>>>>   arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
>>>>   5 files changed, 20 insertions(+), 20 deletions(-)
>>>>
>>>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/ powerpc/include/asm/book3s/64/hash-4k.h
>>>> index 8e5bd9902bed..79511e6abfca 100644
>>>> --- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
>>>> +++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
>>>> @@ -165,9 +165,9 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>>>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>>>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>>>                          unsigned long addr, pmd_t *pmdp);
>>>> -extern int hash__has_transparent_hugepage(void);
>>>>   #endif
>>>> +extern int hash__has_transparent_hugepage(void);
>>>>   #endif /* !__ASSEMBLER__ */
>>>>   #endif /* _ASM_POWERPC_BOOK3S_64_HASH_4K_H */
>>>> diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/ powerpc/include/asm/book3s/64/hash-64k.h
>>>> index 7deb3a66890b..a4a44a112ff9 100644
>>>> --- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
>>>> +++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
>>>> @@ -278,9 +278,9 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>>>>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>>>>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>>>>                          unsigned long addr, pmd_t *pmdp);
>>>> -extern int hash__has_transparent_hugepage(void);
>>>
>>> Without some of these helpers in place, I assume actually using PMD leafs
>>> without THP would require some more work. (which is not the goal of this series,
>>> just asking).
>>
>> Yes, you're right.
>>
>>> I do wonder whether the architecture should instead simply say "not supported"
>>> if !CONFIG_TRANSPARENT_HUGEPAGE?
>>>
>>> That should still enable your series: using mTHP without PMD support.
>>
>> Yes, it would. However, I think this introduces an inconsistency.
> 
> powerpc has two types of MMU (HASH and RADIX) with different page layout. MMU type is selected at boottime based on the capabilities of the CPU. For transparent page you have:
> 
> static inline int has_transparent_hugepage(void)
> {
>      if (radix_enabled())
>          return radix__has_transparent_hugepage();
>      return hash__has_transparent_hugepage();
> }

Right and, unless I'm misunderstanding your comment, this supports my
position that the new arch_has_pmd_leaves() API is all about reporting a
hardware capability and not tied to THP support.

> 
>>
>> In in its current form, arch_has_pmd_leaves() should always report a hardware
>> capability. This is true even for the default case where
>> arch_has_pmd_leaves() defaults to
>> IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE) in the assumption that
>> archs supporting PMD-sized pages by default will have this config
>> enabled.
>>
>> Your suggestion will change this and for some archs
>> arch_has_pmd_leaves() may have different behavior depending on the user
>> configuration. Additionally, I intended to decouple the base API
>> implementation from THP.
>>
>> If you feel strongly about this I can implement your suggestion, but I'd
>> still vote for keeping the API about consistently reporting the hardware
>> capability. Even if the only user is THP code today, new use cases can
>> be added incrementally.
>>
>>>
>>> [...]
>>>
>>>> -static inline int radix__has_transparent_hugepage(void)
>>>> +static inline int radix__has_transparent_pud_hugepage(void)
>>>>   {
>>>> -    /* For radix 2M at PMD level means thp */
>>>> -    if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
>>>> +    /* For radix 1G at PUD level means pud hugepage support */
>>>> +    if (mmu_psize_defs[MMU_PAGE_1G].shift == PUD_SHIFT)
>>>>           return 1;
>>>>       return 0;
>>>>   }
>>>> +#endif
>>>> -static inline int radix__has_transparent_pud_hugepage(void)
>>>> +static inline int radix__has_transparent_hugepage(void)
>>>>   {
>>>> -    /* For radix 1G at PUD level means pud hugepage support */
>>>> -    if (mmu_psize_defs[MMU_PAGE_1G].shift == PUD_SHIFT)
>>>> +    /* For radix 2M at PMD level means thp */
>>>> +    if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
>>>>           return 1;
>>>>       return 0;
>>>>   }
>>>
>>> You are swapping both implementations, which might create some unnecessary churn
>>> I think.
>>
>> I suspect this was done by git diff as I just moved the functions, but
>> I'll take a better look.
>>
> 


