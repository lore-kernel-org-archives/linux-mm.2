Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 08CE7C531C9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 18:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EFDD26B007B; Fri, 24 Jul 2026 14:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EAF0E6B0088; Fri, 24 Jul 2026 14:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA0296B008A; Fri, 24 Jul 2026 14:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2146B007B
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:55:54 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20F01C0115
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:55:54 +0000 (UTC)
X-FDA: 85024574628.07.0028F74
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8E34320008
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:55:51 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Zc24E/9t";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784919351;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FPHtkNUMgxa/OR2MtUUZl4a87NDGmPOsJ6CY7gp7UTQ=;
	b=QKP3Ok0CoVpsb+tRcE2U+6ydrFSm4Gr3v8rlt5W46YBx22HMVJiI8thlbe4ExCQSWXJ0L4
	46a99Tq6Atb9M1EKwtxPk/b2KEiBmfY63DrUcjxOUYsoMcbhc99y+njTvG+yVQaOW7sRCQ
	XQ9BLq5XX8mRpVHwkFW6e2NGM4I7k7k=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b="Zc24E/9t";
	dmarc=pass (policy=quarantine) header.from=redhat.com;
	spf=pass (imf13.hostedemail.com: domain of luizcap@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=luizcap@redhat.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784919351;
	b=1WJPtpRD4ivwkD3TEM6uCyvdo3y3YVt1ZnbSGkC3bsPEpIcXJKS7W9rbjkdWTcM80IwBV+
	QODQ/8XBrfsq8i2WborKdmS1Hf0g/lJ5DdAj6QPKExljWsrTLbg34CnQeGKql+uE4U1UOQ
	ZDiJwuqZeGo6/GoD4W1Z925v066u2Oo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1784919351;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FPHtkNUMgxa/OR2MtUUZl4a87NDGmPOsJ6CY7gp7UTQ=;
	b=Zc24E/9tRAzhrOFEW7wTZ3o2Ei1Rr7Pu3V8gMDM/e7WmGGVOzSIFKtZSlpILNnCZDL8GDd
	pr++4fI9zUcpwAGaGcfoEnAirarLKeZ1l7tGkPhDzJ6aM3xqot/da9kzVEopRZdPKJB+8P
	7+z+JcHRNRNP2cK+wkekISr5OzzywyM=
Received: from mail-qv1-f71.google.com (mail-qv1-f71.google.com
 [209.85.219.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-542-Jb1GNvl-MzW9IhDfYfNhkA-1; Fri, 24 Jul 2026 14:55:49 -0400
X-MC-Unique: Jb1GNvl-MzW9IhDfYfNhkA-1
X-Mimecast-MFC-AGG-ID: Jb1GNvl-MzW9IhDfYfNhkA_1784919349
Received: by mail-qv1-f71.google.com with SMTP id 6a1803df08f44-8f0f45415cfso11796736d6.2
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:55:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784919349; x=1785524149;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FPHtkNUMgxa/OR2MtUUZl4a87NDGmPOsJ6CY7gp7UTQ=;
        b=Uku2uW8TD4v8hkgm8Cuo7rhoN9yI/rQIocCbGXddyzSZ5tNVGq7pjfJ6FbQwgRUk/N
         NLtruEoe5K+nEvnASj1UD6a5YjFsOK+NN9odbELCiJ9rcGVo96djKoZfO1wjlTsXB2xN
         Pll/3e901iAZFMlzAqu6BrLAaDkFiupbzqKCoxNtdWerCqPxbLa3S15XDmWSz5LC5SU2
         EvxSZX8TmZq+ApzAW483gjuF5M0i0RRCFksDe1RSmqgShnKDz0Ht8WtPcmkVkMiM7lDw
         5hsvKvbcXo0ovKD6wqS+u7T3psB7yLoIUgCHiGIkYe+nIIjUjdcuL4TA1SFlnqf2bGbG
         Qa3A==
X-Forwarded-Encrypted: i=1; AHgh+RoToy564lcRBpzSNrQfTLxcFDN3fQUrPmSbwB242FOy53TV+vYHqACIB/X3cGxv4R75WakTni5cZw==@kvack.org
X-Gm-Message-State: AOJu0YykFWBRdGnMiF5OMi983cyOqYl0qlDIjFYPrQBAgJ4p3MMbgOGh
	zUoC//66UEBM4tSsA8pMt42pNJzPx1S9MlzceXktP++Qz5SJgO7M5m/GpALF3YKzY4VjKJ+Oxu/
	tj8b7Fv7F2FHXG9SYQ7AyrO25AnemoqxqB2q7NSBSL0y5jkJzrbyR
X-Gm-Gg: AR+sD11JtZk+9bLd8vWMlnobkvC3Zr3UI9KgoI9vx5wx7gJdv1gx1OuBmpFxs5PcYU+
	nnB0Bc3gA5LLu1SX5z/lLP1f58ZSJzYjED8OyBAm6ubELlT6kLopyJYvGbcyXcox97YotdCnZK5
	di5LopQJ8IZX2mvJavR/qkNQn/vf7cqaYHnafCIaAwUur76faZcyD4/ZSiGf+0AgyGxA4vkO7tY
	RsCN2XnjuJvX9DxC9MKaIuIdc2pKRfdrvYvhQoElykCH5axNIL5ecBeQDgynDKeqJs/ZrAjqL+a
	mzhxf8i7A5iyhFqNtBK2KibG7EYRp9UijaGnOq/1xT7w0rANxokphlWDW37JOpjPWW94sdnH06Y
	G
X-Received: by 2002:a05:6214:4283:b0:8f2:9be8:f444 with SMTP id 6a1803df08f44-907ca28fce9mr111232326d6.8.1784919348938;
        Fri, 24 Jul 2026 11:55:48 -0700 (PDT)
X-Received: by 2002:a05:6214:4283:b0:8f2:9be8:f444 with SMTP id 6a1803df08f44-907ca28fce9mr111231796d6.8.1784919348404;
        Fri, 24 Jul 2026 11:55:48 -0700 (PDT)
Received: from [192.168.2.110] ([70.49.81.60])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e86d7a94sm4173806d6.40.2026.07.24.11.55.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 11:55:48 -0700 (PDT)
Message-ID: <4190508a-4783-4ee9-8a82-acb9d1f71b87@redhat.com>
Date: Fri, 24 Jul 2026 14:55:36 -0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 12/14] treewide: introduce arch_has_pmd_leaves()
From: Luiz Capitulino <luizcap@redhat.com>
To: linux-kernel@vger.kernel.org, linux-mm@kvack.org, david@kernel.org,
 baolin.wang@linux.alibaba.com, ziy@nvidia.com, lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org, tglx@kernel.org,
 mingo@redhat.com, bp@alien8.de, ira.weiny@intel.com, hughd@google.com,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, yintirui@huawei.com,
 ljs@kernel.org, dev.jain@arm.com
References: <cover.1784856856.git.luizcap@redhat.com>
 <b6799a44719adc8dee18810c0a2ee223e713f756.1784856856.git.luizcap@redhat.com>
In-Reply-To: <b6799a44719adc8dee18810c0a2ee223e713f756.1784856856.git.luizcap@redhat.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: BPbgsA7EkUST78nqM7EoDqNY-yzMlMga9bb3QdcYdLs_1784919349
X-Mimecast-Originator: redhat.com
Content-Language: en-US, en-CA
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 8E34320008
X-Rspam-User: 
X-Stat-Signature: 5odec6kd56w7o6cfwdh33fz4j6y5fx8u
X-HE-Tag: 1784919351-309180
X-HE-Meta: U2FsdGVkX1/uROu7k2+RgwjLCb4iO/m2UKE99y+n+Y7/wlaifC5qlmGVjHLjWGHc4eUOsghTs+hoX6vpwEELHnX7B8tRhUlZiRE6ClkkHbM/E1nJzQ78D5cp+2ODBhWYlslckcvKsTs8m0f4B2je6k/bWXHqFCHG7OeSYfnm6PfKssO9Rnr7eMGMUXISB4BGFS02LtUd1uINuZt8NiCNtQi9NaoY1v286LUlSNXhOeMhEWxRjCUPju0Pe+brM8Fi2+TMnbU6Dqj02LOpcvXOAEF3GacDReGIm53RBhXmndBJPRTWck3RYwsRQNCmy3g9UfDtGmzMM6NsMRxhrT8MZUnycCohoJKzGBqvSmz9/UzgYJ8YGSwaWsWNou3VanFQZDcq4BXUme1zLveklEDyrjVAKQb3BuxbreBTvdRSsR6+bPX4VGkhsDDXIsiEb3wfP2m8KnaHxB+MdnuUQUipEFyIfJ8tNKkkI/rBvrf0l80m0PqL9uvK+B1vomaO1KM4zfXfLWX1d5CEtWalxE07Li7n8x9+ThuI8XIju429YfM4lrDUI5Cuw39/UCYkZY0MEIuw72lmsyrcbUVbV5pVxvbChegpTNBf3RDlnI6Y2SIVhwtfSwOPZ0iSNg5aNbIr4JtY/8sQ/LLSuq1i9uxQP9EDY/YGdcDXuoOvSwQ6Qjg+ZI5kQfa72Zam7WZen07Zwax8cMLJF1wicJSbkbkzS++5JS+8SsJZjyETGYX8bUHrfzhY/urA6hXpYiP9AaAyV7krI367FMIJhvTXAVzpNrAPi3SDxZLeGKIj6q8cNRJNlHO59N6k85RD9cr0K0XsDRKbR/Qi3EgeNayLqWyr0fVHvPvcEpGPZ2yx5qshlxpQkw9dhfUzepdQZGpfAW4rFCy6er4QF77b8CG36mheERb0WRl3kpDJnxzHVZl1RY+SBmT+FNLY8J25/rXijvTQ/LoBaNW8D7UchsiYL2b
 hjsIz3FY
 EHcdtp7VnqoRK3tYPUdhJZEPFEb6yeAJ7a7J3RPIngSBeXbd3Da13O7416LXjHMNJYRMrrjUxdRCDC+FtZCJUOkmzZOTbyWZIg/IkT8GffJnTjqAw2OhCQmkeFDZO04wrgcfo7VMmNSP7AEW3FaDxE+FduZzx11egW+zNFnZbURYgUh5CBPSxmLij3tixJERPhxH/DSGw2xidV6/VtesoAcP5RG2wu48+293gWn8URqa7laRFFFEgIR882TucT+ZYlaHvYPtoDtORAjwCDm2vcYz+rIq8otUdxlZw8xaHrdIR7Gih0RcNRiW/BVAfO0RLFeH5u+ZUI7srS+oIQsUkCBrujpsGT3qsN4xnVHRzOTTquHzmpuElftSmvfz5cx0QwlrlhOBrAc259zY4XmBHAUiPRBpJROWzGBAc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-23 21:34, Luiz Capitulino wrote:
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

s/init_arch_has_pmd_leaves/pgtable_leaf_support_init

Typo found by Sashiko, in case I don't need to send v7, can this be
fixed w/o a re-post?

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
> index b038da872ec6..2a0a7ddf8bee 100644
> --- a/arch/mips/include/asm/pgtable.h
> +++ b/arch/mips/include/asm/pgtable.h
> @@ -740,8 +740,8 @@ static inline pmd_t pmdp_huge_get_and_clear(struct mm_struct *mm,
>   
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
> -#define has_transparent_hugepage has_transparent_hugepage
> -extern int has_transparent_hugepage(void);
> +#define arch_has_pmd_leaves arch_has_pmd_leaves
> +extern int arch_has_pmd_leaves(void);
>   
>   #ifdef _PAGE_HUGE
>   #define pmd_leaf(pmd)	((pmd_val(pmd) & _PAGE_HUGE) != 0)
> diff --git a/arch/mips/mm/tlb-r4k.c b/arch/mips/mm/tlb-r4k.c
> index f4e369342a56..9339ebb0815f 100644
> --- a/arch/mips/mm/tlb-r4k.c
> +++ b/arch/mips/mm/tlb-r4k.c
> @@ -432,7 +432,7 @@ void add_wired_entry(unsigned long entrylo0, unsigned long entrylo1,
>   #endif
>   }
>   
> -int has_transparent_hugepage(void)
> +int arch_has_pmd_leaves(void)
>   {
>   	static unsigned int mask = -1;
>   
> @@ -448,7 +448,7 @@ int has_transparent_hugepage(void)
>   	}
>   	return mask == PM_HUGE_MASK;
>   }
> -EXPORT_SYMBOL(has_transparent_hugepage);
> +EXPORT_SYMBOL(arch_has_pmd_leaves);
>   
>   /*
>    * Used for loading TLB entries before trap_init() has started, when we
> diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerpc/include/asm/book3s/64/hash-4k.h
> index 79511e6abfca..d532e3f0dfc3 100644
> --- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
> +++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
> @@ -167,7 +167,7 @@ extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>   				       unsigned long addr, pmd_t *pmdp);
>   #endif
>   
> -extern int hash__has_transparent_hugepage(void);
> +extern int hash__arch_has_pmd_leaves(void);
>   #endif /* !__ASSEMBLER__ */
>   
>   #endif /* _ASM_POWERPC_BOOK3S_64_HASH_4K_H */
> diff --git a/arch/powerpc/include/asm/book3s/64/hash-64k.h b/arch/powerpc/include/asm/book3s/64/hash-64k.h
> index a4a44a112ff9..d523c80f44f7 100644
> --- a/arch/powerpc/include/asm/book3s/64/hash-64k.h
> +++ b/arch/powerpc/include/asm/book3s/64/hash-64k.h
> @@ -280,7 +280,7 @@ extern pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>   				       unsigned long addr, pmd_t *pmdp);
>   #endif /*  CONFIG_TRANSPARENT_HUGEPAGE */
>   
> -extern int hash__has_transparent_hugepage(void);
> +extern int hash__arch_has_pmd_leaves(void);
>   #endif	/* __ASSEMBLER__ */
>   
>   #endif /* _ASM_POWERPC_BOOK3S_64_HASH_64K_H */
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
> index 2a795f6d9263..41166d44fa75 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -1432,14 +1432,14 @@ static inline bool arch_needs_pgtable_deposit(void)
>   
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
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
>   #define __HAVE_ARCH_PTEP_MODIFY_PROT_TRANSACTION
>   pte_t ptep_modify_prot_start(struct vm_area_struct *, unsigned long, pte_t *);
> diff --git a/arch/powerpc/include/asm/book3s/64/radix.h b/arch/powerpc/include/asm/book3s/64/radix.h
> index 50545cf519bd..e8b74528953f 100644
> --- a/arch/powerpc/include/asm/book3s/64/radix.h
> +++ b/arch/powerpc/include/asm/book3s/64/radix.h
> @@ -307,7 +307,7 @@ static inline int radix__has_transparent_pud_hugepage(void)
>   }
>   #endif
>   
> -static inline int radix__has_transparent_hugepage(void)
> +static inline int radix__arch_has_pmd_leaves(void)
>   {
>   	/* For radix 2M at PMD level means thp */
>   	if (mmu_psize_defs[MMU_PAGE_2M].shift == PMD_SHIFT)
> diff --git a/arch/powerpc/mm/book3s64/hash_pgtable.c b/arch/powerpc/mm/book3s64/hash_pgtable.c
> index 50316f3fc5d3..a67bc1723404 100644
> --- a/arch/powerpc/mm/book3s64/hash_pgtable.c
> +++ b/arch/powerpc/mm/book3s64/hash_pgtable.c
> @@ -393,7 +393,7 @@ pmd_t hash__pmdp_huge_get_and_clear(struct mm_struct *mm,
>   
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
> -int hash__has_transparent_hugepage(void)
> +int hash__arch_has_pmd_leaves(void)
>   {
>   
>   	if (!mmu_has_feature(MMU_FTR_16M_PAGE))
> @@ -422,7 +422,7 @@ int hash__has_transparent_hugepage(void)
>   
>   	return 1;
>   }
> -EXPORT_SYMBOL_GPL(hash__has_transparent_hugepage);
> +EXPORT_SYMBOL_GPL(hash__arch_has_pmd_leaves);
>   
>   #ifdef CONFIG_STRICT_KERNEL_RWX
>   
> diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
> index 5aa8f621df04..24ee90c7e9bf 100644
> --- a/arch/s390/include/asm/pgtable.h
> +++ b/arch/s390/include/asm/pgtable.h
> @@ -1827,8 +1827,8 @@ static inline int pmd_trans_huge(pmd_t pmd)
>   }
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
> -#define has_transparent_hugepage has_transparent_hugepage
> -static inline int has_transparent_hugepage(void)
> +#define arch_has_pmd_leaves arch_has_pmd_leaves
> +static inline int arch_has_pmd_leaves(void)
>   {
>   	return cpu_has_edat1() ? 1 : 0;
>   }
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index 3c62b33147fa..3c6a641e6c21 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -331,8 +331,8 @@ static inline pud_t pud_mkspecial(pud_t pud)
>   #endif	/* CONFIG_ARCH_SUPPORTS_PUD_PFNMAP */
>   #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
>   
> -#define has_transparent_hugepage has_transparent_hugepage
> -static inline int has_transparent_hugepage(void)
> +#define arch_has_pmd_leaves arch_has_pmd_leaves
> +static inline int arch_has_pmd_leaves(void)
>   {
>   	return boot_cpu_has(X86_FEATURE_PSE);
>   }
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 4c00cf53e183..d571d161a84b 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -2344,8 +2344,8 @@ static inline void __init pgtable_leaf_support_init(void) { }
>   #endif
>   #endif
>   
> -#ifndef has_transparent_hugepage
> -#define has_transparent_hugepage() IS_BUILTIN(CONFIG_TRANSPARENT_HUGEPAGE)
> +#ifndef arch_has_pmd_leaves
> +#define arch_has_pmd_leaves() IS_BUILTIN(CONFIG_HAVE_ARCH_TRANSPARENT_HUGEPAGE)
>   #endif
>   
>   #ifndef has_transparent_pud_hugepage
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 04e8a6b55343..3f3a929e3069 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1010,7 +1010,7 @@ static int __init hugepage_init(void)
>   	int err;
>   	struct kobject *hugepage_kobj;
>   
> -	if (!has_transparent_hugepage()) {
> +	if (!arch_has_pmd_leaves()) {
>   		transparent_hugepage_flags = 1 << TRANSPARENT_HUGEPAGE_UNSUPPORTED;
>   		return -EINVAL;
>   	}
> diff --git a/mm/memory.c b/mm/memory.c
> index d6540d6d4ef9..b0d3a8a8a25d 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -169,7 +169,7 @@ EXPORT_SYMBOL(__arch_has_pmd_leaves_key);
>   
>   void __init pgtable_leaf_support_init(void)
>   {
> -	if (!has_transparent_hugepage())
> +	if (!arch_has_pmd_leaves())
>   		static_branch_disable(&__arch_has_pmd_leaves_key);
>   }
>   


