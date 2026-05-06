Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0EAA9CD342C
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 18:22:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7535B6B0099; Wed,  6 May 2026 14:22:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 72A5E6B009B; Wed,  6 May 2026 14:22:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 640C96B009D; Wed,  6 May 2026 14:22:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 58C6B6B0099
	for <linux-mm@kvack.org>; Wed,  6 May 2026 14:22:35 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E9B151201A2
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:22:34 +0000 (UTC)
X-FDA: 84737815428.27.B7EB0D1
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	by imf03.hostedemail.com (Postfix) with ESMTP id 81C8C2000D
	for <linux-mm@kvack.org>; Wed,  6 May 2026 18:22:32 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T8bIPA9a;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778091752;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MEwKi/yEAVBufitkI7q1YFn1s0vNFnHu/rXcw0dUDa0=;
	b=cF6Uh8vJxem2gXLD9Jm+q2C9VZse0BTgO8yjsIkQGysKG2Ievbba9EyzEnMVzc/eCezZNM
	W6Jesi5sWQEcNshBA3bn+Sam4olVXO/BhpHIYpRlq/i0zVWQC2EYlD/MZxriBiVH3D80x+
	VoeviAD0kzLr7h2XvvygIjY0H1PMxbw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=T8bIPA9a;
	spf=pass (imf03.hostedemail.com: domain of luizcap@redhat.com designates 170.10.129.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778091752; a=rsa-sha256;
	cv=none;
	b=a5r25Hq6WzPZtkL+ZXFNzkMBe8oS3Hqh7HoHEERsKwppuDpW1c/OjAYFmmYwEzfv0YOTIL
	UZq+z7UxOcJazVxY5ZZ/dHl/Zw5hwvACPNK8zyaGFdrFZeWVIRVNEjABL14uJICwa2TYix
	LE19eEb0Yn5+yAE2P78B7pDCu8tkf4M=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1778091751;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MEwKi/yEAVBufitkI7q1YFn1s0vNFnHu/rXcw0dUDa0=;
	b=T8bIPA9a5gWltKcURyKVHFO7DTrSFOpzcRFRxph7iYLs3oNP+DJClhAVqtE5oRHsGJCIQi
	fUEJIvJUdapKOBdlEpFL38HsQr41YTPiLYPE74VUyTZlmqEe6RfJhn+4M4iZ1vv8Yoskkr
	fyfjQ9LgoytF1vIz+tLsniNPQzzE0X4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-225-0LqceUfoNsmbecOFr1u2VA-1; Wed, 06 May 2026 14:22:25 -0400
X-MC-Unique: 0LqceUfoNsmbecOFr1u2VA-1
X-Mimecast-MFC-AGG-ID: 0LqceUfoNsmbecOFr1u2VA_1778091745
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-8eaee67d1afso706528885a.1
        for <linux-mm@kvack.org>; Wed, 06 May 2026 11:22:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778091745; x=1778696545;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MEwKi/yEAVBufitkI7q1YFn1s0vNFnHu/rXcw0dUDa0=;
        b=earKvxpRGLhLSLoC6JLcTxgNzVRIVDO7QlCiQiZxJCRs8eG/sDJWpH3zuz2VyZ17lC
         zKaDNhUHjSDUbKzsFg24M5BMl0uWu8JIO0WKxFm/QE82o4rduXvny00vshvxd97OZNou
         Cjf9l11IJTH9yOQaEggLGzR6NMGK7uRL3UduUw4zqL8BfH0EfhvWjeiyud/86YGMLyEz
         kN01XhJk6jxgyhnjxLqacuyQvAKovBvSSSl4rnTFF+7otQQCCzTxtKNkxibVXaZ/7VPG
         9OiQsqJr6ebjR81TJzU/fJv6hqWikpXsyi/OnQfiYhWC+pCTgK6xD/VW3UZ08k68T9QC
         xfCw==
X-Forwarded-Encrypted: i=1; AFNElJ/jZgs9Ji2MlPtBlgXsPB2BsmLRZKjrrKj/A1fecCKzjHqZqylLHiNyyvQebv9NrRaqjJPUDINUaA==@kvack.org
X-Gm-Message-State: AOJu0Yydyb3gTBv+i5WMKAbCHNjfpOd5PF11cZ4hvPbRUrh1RmA1a4On
	9MCuYgcVMWyRmA1YVfguI6XjESwaoWMI1A4aw3tCsx6438Qr7KLIdkFJ+AyMVRLZAscr6Q0ejz6
	+0Jzc3kvb8iVVuhBTmgh5AlKbLHT3hgbrFSVPr5Pxoo1/1oRhn4+4
X-Gm-Gg: AeBDieun+I4iqSnZ5+EVN/iEqgqO0cUFmz+D/rrhHpCreH5VcNis8xRkndyaChQJQD5
	o8nWFH29fqlmQI645o0V80oj/qYWr6sQPEffbZ6cS+STjg/7DP0wL5eQw+ruCOsTU83K4IB8BVa
	jIWAZhUzeGWFCU8AREhha3yjaiHM/9tNqE4YFi5c6Xl0EkOHD5mZKgeQt/zoHeZ6z295eYobUuI
	j4o1Peuygw21QTwx7Si69XDb+gkxNq86sZZBJRzQQnBwODTOSOHZyGwrXDxVmG1Yj5Va8d13hYc
	2CtHagoH1VPfvSGcO1V+vfwijP7yeCwl/WWWfBrRu5PI1I+DkiIyWMEcrZbeWgAHEGnEXmYuFLf
	2RHaMiSFvvqZZ0ul+onlDIRl+B78+uX1VOasdJEgexlGhOA==
X-Received: by 2002:a05:620a:2849:b0:8e3:4182:6c4e with SMTP id af79cd13be357-904d69d8fd1mr673160585a.49.1778091744780;
        Wed, 06 May 2026 11:22:24 -0700 (PDT)
X-Received: by 2002:a05:620a:2849:b0:8e3:4182:6c4e with SMTP id af79cd13be357-904d69d8fd1mr673153785a.49.1778091744151;
        Wed, 06 May 2026 11:22:24 -0700 (PDT)
Received: from [192.168.2.110] ([70.53.202.134])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-8fc2cd04de9sm1746500785a.44.2026.05.06.11.22.23
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2026 11:22:23 -0700 (PDT)
Message-ID: <415c4158-f87d-4a61-8aab-9f957b1fe1c8@redhat.com>
Date: Wed, 6 May 2026 14:22:12 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: (sashiko review) Re: [PATCH v4 7/9] treewide: introduce
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
In-Reply-To: <85674af7934cd363ceadd1d4f2b784d833a183cc.1777663129.git.luizcap@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: diAN_xUdKOZHodM3MoJOvjAJBgKVhg503BrEZfx77c0_1778091745
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 81C8C2000D
X-Rspam-User: 
X-Stat-Signature: di3czfftjkyu8tazpa5kjeu3r4zuof9s
X-HE-Tag: 1778091752-944488
X-HE-Meta: U2FsdGVkX18h6X0CzsiuM7j+d9W5nzWY8uIotwuLZ7mJ0gxbl+Ot7tCFnYF4OgcjQP5Csd7nNmYF3NE0s21ykLmFbBzGiFW0uW9cqClJ+XBQEGUKhRWu8OpsPB5j6yJT3tKU2Xuei3qqig2fyEqcvU2XmeyZt6q0MRUCJAme8CRUCO3Wpo1aM9W6ODchb1ImWFYq3jDPy2f2xv6IPUrvu3sWAIfmJjwrULcxVf0hxfxWBDOA8PCkfQ74QuY1DEWcOskYsjGY0vvG5bkJh9DYAPgE4zolUL1DEQoOaWqVGovPkYPXKfxdTCfgB2nZK61g8CHvQ4ECQil4hKtE4bG0yqCt6AgST4pUgkU/R3/zyGtst66t0PXhhlj9rMRx++t0yqHZpqGbt3E4slR0powfVrQZlz845f8Y+byHfeVv2BDZGwzvxGVFTRtiXEz5gN3YAG88nhoHjH5mtn3mUT5yaXDMdgaXBbELLCpD0ia6If7CfQo3aXHSFVhzeeUEc/Ql9gRxv/M2OSBwWbp7Vzf7VxczP/xv2kbDD9W2r4Ed8OAHcPxV5n6IFs74BSV+F9EZzP4BntJsE/J+mSA+d5xL8zfl99cR/CCChfBT/f3Pr5x9gQB2MM6y+skbFgCkHSTLYM6pYRRUyXw0F9Tctd+mwWIFKUsG1DFhgwP2cBp0pTt/kvqaqGpI6/JTMme0WVUS4z94SlJw5sC552LqCM0I/6YbxBeFL355k1M06TIJEMr9kBueYKsnLk0Cd/l0QwYlKTHu8kg0HMOxxXoJ+BQhXYNjh7eOPEJbweMdNft8pQpgouQL2/7pEHLUrd+sL/qdYUWh36iAxLsGBH4KWjiMBHykca/3XE4L/Inf5JQv+lnRXKU4ehdUmOaXmo/cztf/ZX5kTNlrnOQWGHjrJoFLGd6f2KHG5cERdQmKk2iSHUn4ufdRFQ9Vx532ONQamzhmx9tyqivvUWFKy1514E/
 5PhQMXd1
 FLMWv1BqtERnagaP+F5qFHiHsfwaIRpUNcobBwQ4rQWDvssLGQ5FZKVXIH6SVen8ZUUXheTc6b+yiuFy5NGmaMrDCRpgICoJoeMyc7dlcyf68QgkuMLvhXpf04OnrNKzLCcHf6nfCHEOlBgk6eb6bxYkpqHu/EOgyoP/0OjHYrQiTZXEnHJPv2eG/bSRhLPXz3FwfHauryWkftvuoiuVJUwUzqg5219K5di8ql8PPHafObPgYfVjF5CrkwrvQb9wMPnGAWRyQkDo/X4SieYg2yPrnk4n8yrieNZN6gCRp8dX3ZVkA+Hf+IAYzN+XP+u6CwakYyRaSxVpIBcg4wEMxyNQ7TTf5YjAOS+fEdfdF/4dNjBUOuL1hWwYrt6o3VF/A/GQFDsBMv4rw4eVToUYkU3eqvIkF1akriJvU2UGjnZ3TT9ACWOQmlMfOqS69KtfjwU3BNIbck5l7srsmGF/GuBt+q97F8y+OB2Ut4mLFAGM9tvRnA3mIa93bSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-05-01 15:18, Luiz Capitulino wrote:
> Now that all the has_transparent_hugepage() callers have been converted
> to pgtable_has_pmd_leaves(), this commit does two things:
> 
> 1. Rename has_transparent_hugepage() arch implementations to
>     arch_has_pmd_leaves(), since that's what the helper checks for
> 
> 2. Introduce the default implementation of arch_has_pmd_leaves() as
>     IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE). This means that if
>     the arch doesn't implement arch_has_pmd_leaves() we default to checking
>     CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE as a way to determine if
>     PMD-sized pages are supported
> 
> Note that arch_has_pmd_leaves() is supposed to be called only by
> init_arch_has_pmd_leaves(). The remaining exception is hugepage_init()
> which will be converted in a future commit.
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>   arch/mips/include/asm/pgtable.h               |  4 ++--
>   arch/mips/mm/tlb-r4k.c                        |  4 ++--
>   arch/powerpc/include/asm/book3s/64/hash-4k.h  |  2 +-
>   arch/powerpc/include/asm/book3s/64/hash-64k.h |  2 +-
>   arch/powerpc/include/asm/book3s/64/pgtable.h  | 10 +++++-----
>   arch/powerpc/include/asm/book3s/64/radix.h    |  2 +-
>   arch/powerpc/mm/book3s64/hash_pgtable.c       |  4 ++--
>   arch/s390/include/asm/pgtable.h               |  4 ++--
>   arch/x86/include/asm/pgtable.h                |  4 ++--
>   include/linux/pgtable.h                       |  4 ++--
>   mm/huge_memory.c                              |  2 +-
>   mm/memory.c                                   |  2 +-
>   12 files changed, 22 insertions(+), 22 deletions(-)
> 
> diff --git a/arch/mips/include/asm/pgtable.h b/arch/mips/include/asm/pgtable.h
> index fa7b935f947c..a97b788315e2 100644
> --- a/arch/mips/include/asm/pgtable.h
> +++ b/arch/mips/include/asm/pgtable.h
> @@ -615,8 +615,8 @@ unsigned long io_remap_pfn_range_pfn(unsigned long pfn, unsigned long size);
>   /* We don't have hardware dirty/accessed bits, generic_pmdp_establish is fine.*/
>   #define pmdp_establish generic_pmdp_establish
>   
> -#define has_transparent_hugepage has_transparent_hugepage
> -extern int has_transparent_hugepage(void);
> +#define arch_has_pmd_leaves arch_has_pmd_leaves
> +extern int arch_has_pmd_leaves(void);
>   
>   static inline int pmd_trans_huge(pmd_t pmd)
>   {
> diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
> index 24fe85fa169d..c423b5784337 100644
> --- a/arch/mips/mm/tlb-r4k.c
> +++ b/arch/mips/mm/tlb-r4k.c
> @@ -434,7 +434,7 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
>   
>   #ifdef CONFIG_TRANSPARENT_HUGEPAGE
>   
> -int has_transparent_hugepage(void)
> +int arch_has_pmd_leaves(void)
>   {
>   	static unsigned int mask = -1;
>   
> @@ -450,7 +450,7 @@ int has_transparent_hugepage(void)
>   	}
>   	return mask == PM_HUGE_MASK;
>   }
> -EXPORT_SYMBOL(has_transparent_hugepage);
> +EXPORT_SYMBOL(arch_has_pmd_leaves);
>   
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE  */
>   
> diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerpc/include/asm/book3s/64/hash-4k.h
> index 8e5bd9902bed..6744c2287199 100644
> --- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
> +++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
> @@ -165,7 +165,7 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>   				       unsigned long addr, pmd_t *pmdp);
> -extern int hash__has_transparent_hugepage(void);
> +extern int hash__arch_has_pmd_leaves(void);
>   #endif
>   
>   #endif /* !__ASSEMBLER__ */
> diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/powerpc/include/asm/book3s/64/hash-64k.h
> index 7deb3a66890b..9392aba5e5dc 100644
> --- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
> +++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
> @@ -278,7 +278,7 @@ extern void hash__pgtable_trans_huge_deposit(struct mm_struct *mm, pmd_t *pmdp,
>   extern pgtable_t hash__pgtable_trans_huge_withdraw(struct mm_struct *mm, pmd_t *pmdp);
>   extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>   				       unsigned long addr, pmd_t *pmdp);
> -extern int hash__has_transparent_hugepage(void);
> +extern int hash__arch_has_pmd_leaves(void);
>   #endif /*  CONFIG_TRANSPARENT_HUGEPAGE */
>   
>   #endif	/* __ASSEMBLER__ */
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
> index e67e64ac6e8c..b6629c041e75 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -1121,14 +1121,14 @@ static inline void update_mmu_cache_pud(struct vm_area_struct *vma,
>   {
>   }
>   
> -extern int hash__has_transparent_hugepage(void);
> -static inline int has_transparent_hugepage(void)
> +extern int hash__arch_has_pmd_leaves(void);
> +static inline int arch_has_pmd_leaves(void)
>   {
>   	if (radix_enabled())
> -		return radix__has_transparent_hugepage();
> -	return hash__has_transparent_hugepage();
> +		return radix__arch_has_pmd_leaves();
> +	return hash__arch_has_pmd_leaves();
>   }
> -#define has_transparent_hugepage has_transparent_hugepage
> +#define arch_has_pmd_leaves arch_has_pmd_leaves
>   
>   static inline int has_transparent_pud_hugepage(void)
>   {
> diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
> index da954e779744..c884a119cbd9 100644
> --- a/arch/powerpc/include/asm/book3s/64/radix.h
> +++ b/arch/powerpc/include/asm/book3s/64/radix.h
> @@ -298,7 +298,7 @@ extern pmd_t radix__pmdp_huge_get_and_clear(struct mm_struct *mm,
>   pud_t radix__pudp_huge_get_and_clear(struct mm_struct *mm,
>   				     unsigned long addr, pud_t *pudp);
>   
> -static inline int radix__has_transparent_hugepage(void)
> +static inline int radix__arch_has_pmd_leaves(void)
>   {
>   	/* For radix 2M at PMD level means thp */
>   	if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
> diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
> index d9b5b751d7b7..88a4a2eab513 100644
> --- a/arch/powerpc/mm/book3s64/hash_pgtable.c
> +++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
> @@ -391,7 +391,7 @@ pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>   	return old_pmd;
>   }
>   
> -int hash__has_transparent_hugepage(void)
> +int hash__arch_has_pmd_leaves(void)
>   {
>   
>   	if (!mmu_has_feature(MMU_FTR_16M_PAGE))
> @@ -420,7 +420,7 @@ int hash__has_transparent_hugepage(void)
>   
>   	return 1;
>   }
> -EXPORT_SYMBOL_GPL(hash__has_transparent_hugepage);
> +EXPORT_SYMBOL_GPL(hash__arch_has_pmd_leaves);
>   
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index 2c6cee8241e0..33b165dbf3db 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1799,8 +1799,8 @@ static inline int pmd_trans_huge(pmd_t pmd)
>   	return pmd_leaf(pmd);
>   }
>   
> -#define has_transparent_hugepage has_transparent_hugepage
> -static inline int has_transparent_hugepage(void)
> +#define arch_has_pmd_leaves arch_has_pmd_leaves
> +static inline int arch_has_pmd_leaves(void)
>   {
>   	return cpu_has_edat1() ? 1 : 0;
>   }
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 2187e9cfcefa..2edd6c9d789c 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -306,8 +306,8 @@ static inline int pud_trans_huge(pud_t pud)
>   }
>   #endif
>   
> -#define has_transparent_hugepage has_transparent_hugepage
> -static inline int has_transparent_hugepage(void)
> +#define arch_has_pmd_leaves arch_has_pmd_leaves
> +static inline int arch_has_pmd_leaves(void)
>   {
>   	return boot_cpu_has(X86_FEATURE_PSE);
>   }
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index b365be3516bf..3d7eeb50c183 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -2273,8 +2273,8 @@ static inline void __init init_arch_has_pmd_leaves(void) { }
>   #endif
>   #endif
>   
> -#ifndef has_transparent_hugepage
> -#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
> +#ifndef arch_has_pmd_leaves
> +#define arch_has_pmd_leaves() IS_ENABLED(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE)
>   #endif
>   
>   #ifndef has_transparent_pud_hugepage
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 970e077019b7..4da10e94bbb6 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -969,7 +969,7 @@ static int __init hugepage_init(void)
>   	int err;
>   	struct kobject *hugepage_kobj;
>   
> -	if (!has_transparent_hugepage()) {
> +	if (!arch_has_pmd_leaves()) {
>   		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
>   		return -EINVAL;
>   	}
> diff --git a/mm/memory.c b/mm/memory.c
> index 90b2d9e84320..c62fce83b8d0 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -169,7 +169,7 @@ EXPORT_SYMBOL(__arch_has_pmd_leaves_key);
>   
>   void __init init_arch_has_pmd_leaves(void)
>   {
> -	if (!has_transparent_hugepage())
> +	if (!arch_has_pmd_leaves())
>   		static_branch_disable(&__arch_has_pmd_leaves_key);
>   }
>   


