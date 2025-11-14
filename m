Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27553CE7AED
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 11:20:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 846448E0017; Fri, 14 Nov 2025 06:20:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F9338E0002; Fri, 14 Nov 2025 06:20:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 70F408E0017; Fri, 14 Nov 2025 06:20:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 597C38E0002
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 06:20:37 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 05C2FC0325
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:20:37 +0000 (UTC)
X-FDA: 84108969714.19.3344999
Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	by imf19.hostedemail.com (Postfix) with ESMTP id 4DEB91A000A
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:20:35 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UXfRqxSY;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763119235;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XNy4CVtGzelyvviljfMndhZwOP8iEHHQBelXlL4nqTk=;
	b=JRpUQZWoXoOH8Qda7ZjrDJS/1GLtk9Q3EpyKEvjpyCQ6zMbzcYKLYavxFMCD7kj1JTzmg6
	Vww2OsYxELzyZhyreRKyVUjZQVDPjx7cCKrN6PPtufWMOFKVtOSrOlCOg8CllCr7voHQro
	dI1zUEiW24KOIwGxnUsvPXfdau24yRc=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=UXfRqxSY;
	spf=pass (imf19.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.172 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763119235; a=rsa-sha256;
	cv=none;
	b=4nvVkN0pD/+9USwZ8rpCN7pvRnLui6xjBYmO3Oasyw5CKtNKyI/kuVxvvEMKiTkQt8PTru
	Ooi4DSiHAZ06synhFbBVb0ff2t9ScqIIsHwoV5wf/IS7WB+FnYyf10iSjYR3KTSkJyyrsi
	QXHVDTPxE+h8KmDaaTecEDVzrLYQeNs=
Message-ID: <5199c367-aabb-43e7-951e-452657dcdddc@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1763119233;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=XNy4CVtGzelyvviljfMndhZwOP8iEHHQBelXlL4nqTk=;
	b=UXfRqxSYKG2iIMsq0y7QI0YBpjYVA43NAZ9FotdfgEA7smTT1ii+ka8Donlv0ylAHxiqBn
	RyGAslbUmXZRKFrWlOaihR1yjcUSTjpJEG9FlXij0/eiQO2C2bzMCPOKJbOhp0uN/N5ZXK
	KS3JrJ92b7MC5d87CAz8uAxX76wAATE=
Date: Fri, 14 Nov 2025 19:20:02 +0800
MIME-Version: 1.0
Subject: Re: [PATCH 2/7] arc: mm: enable MMU_GATHER_RCU_TABLE_FREE
To: will@kernel.org, aneesh.kumar@kernel.org, npiggin@gmail.com,
 peterz@infradead.org, dev.jain@arm.com, akpm@linux-foundation.org,
 david@redhat.com, ioworker0@gmail.com
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, linux-alpha@vger.kernel.org,
 linux-snps-arc@lists.infradead.org, loongarch@lists.linux.dev,
 linux-mips@vger.kernel.org, linux-parisc@vger.kernel.org,
 linux-um@lists.infradead.org, Vineet Gupta <vgupta@kernel.org>
References: <cover.1763117269.git.zhengqi.arch@bytedance.com>
 <6a4192f5cef3049f123f08cb04ef5cd0179c3281.1763117269.git.zhengqi.arch@bytedance.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Qi Zheng <qi.zheng@linux.dev>
In-Reply-To: <6a4192f5cef3049f123f08cb04ef5cd0179c3281.1763117269.git.zhengqi.arch@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4DEB91A000A
X-Stat-Signature: 6f56jjdtkph1rewdympiqjr9ehc9totg
X-Rspam-User: 
X-HE-Tag: 1763119235-453652
X-HE-Meta: U2FsdGVkX1+TmIKPH0hRhY3zvd+jxzreUr4LKDtK2gtwWKERSsBpLooyz9KwS1NE5A4+Kh8wbe1nOiIMvYoF3DeFNXs+chtiRA7SdgVqO5p0xMjckER4qtnxHjuMCOSkMCOgBDww/0vYrR2Bs0FOkBuvo3wwREeW5dcy/EfGmKSVQU/o3mr4v2yqkTGM5rfj3m/u2x3q4+e1/ClwBRFVexPNsRr0iXQmzv5JBHbaLlJ+fwG5tNT2VSN+0olZaSFmJr77PsmRT4aWfgUZ/CSgsPlB9W9KjD5h0rTuZg2l8wq4KxfAo7ljSIfLPejjcszSXuvBZ2uFCIaOSDt8SQ+GP+M+1NFyxFSF9B3NPckqph6eNsYLKtqKzWKPJ1DdBewaKd3mm4z2+ApoWWRgrHnSK61ebTyrM1i0Dn/73l1j/xDFinR+9HY4Yb7qdsfiiFhhw3ltfUaPjdjwd5riDIAXYDSj29BXtfu0bshUTQfPh3fZbsp0RCls4CbjQTpdFx8CucZTLuVTWU5hqFWtFzm3hC6r5wLXMYjlvCMImWtTssonSpqlcwN8B/pBt5DdNrD4wH8ZAFYtgfTDy/sXFeXHcVD5F6m8etHAIebRk04c1EM2f/P4mgoqKyOre6ctBt/GnI9VgHz2l69zB4HOXEfzSknZwG7VT1YiGYlESOYfmj8oSmoUHcQDmz9Hv734tzg+O7Hq3puUVXLet4PdGdO5FXRo3hwPhuwQQJUjFD6DFCJ7fJJMgppOEtgVZTR1xDH624oXrkYEqGKBJaonm7/Qh3SoQBC8Ci6B+Ije0a8NovTMiIQe4wh/7ySG/SuFE0lgSiIwndYRscQz05/qcbtEGVsyxeEbmC8sdZhzG/t2tr+qSN6R80p9pQXHjErwed4ES7O/Ypnoy4sbQa8HofDpoQTDUqviBkbiU4Fv1emq2p4O1Q9r0npYBy0rFMdO3l2XJse7hMgAemoN5RWukO9
 JKZemdf8
 iX3uGaonJVADV70+f1d2VurPt2TjVplAYPM81AcUtW3ki46viEPzTkr08srD3IT50St7xtYiZknIQXDyTr6rbNW6L/Yfu+zxp9YqPVR/TEI1gwUG+qqhK9kQ7Weilenh4Jhus0Nf3mFfNP538kTnyq1CHy3cPcE47x4r8u7mJFEffPf6wvRomycmW6qQJwrzrJBkdG53ehrl0D7KXlSwuypIX/QQ1n2FIvSbg1t2TJ3r3vv6syOOEXFnT9Fe0CyiRVAjx/axPPMQibCdEMaQWEiLtQj3RqoUQM8RVIDCPsg+VPQozRei2vnFu5wzPkogk6WJROwwhopYtSKoMd2sYt3uVAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 11/14/25 7:11 PM, Qi Zheng wrote:
> From: Qi Zheng <zhengqi.arch@bytedance.com>
> 
> On a 64-bit system, madvise(MADV_DONTNEED) may cause a large number of
> empty PTE page table pages (such as 100GB+). To resolve this problem,
> first enable MMU_GATHER_RCU_TABLE_FREE to prepare for enabling the
> PT_RECLAIM feature, which resolves this problem.
> 
> Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
> Cc: Vineet Gupta <vgupta@kernel.org>
> ---
>   arch/arc/Kconfig               | 1 +
>   arch/arc/include/asm/pgalloc.h | 9 ++++++---
>   2 files changed, 7 insertions(+), 3 deletions(-)

Strangely, it seems that only ARC does not define CONFIG_64BIT?

Does the ARC architecture support 64-bit? Did I miss something?

> 
> diff --git a/arch/arc/Kconfig b/arch/arc/Kconfig
> index f27e6b90428e4..47db93952386d 100644
> --- a/arch/arc/Kconfig
> +++ b/arch/arc/Kconfig
> @@ -54,6 +54,7 @@ config ARC
>   	select HAVE_ARCH_JUMP_LABEL if ISA_ARCV2 && !CPU_ENDIAN_BE32
>   	select TRACE_IRQFLAGS_SUPPORT
>   	select HAVE_EBPF_JIT if ISA_ARCV2
> +	select MMU_GATHER_RCU_TABLE_FREE
>   
>   config LOCKDEP_SUPPORT
>   	def_bool y
> diff --git a/arch/arc/include/asm/pgalloc.h b/arch/arc/include/asm/pgalloc.h
> index dfae070fe8d55..b1c6619435613 100644
> --- a/arch/arc/include/asm/pgalloc.h
> +++ b/arch/arc/include/asm/pgalloc.h
> @@ -72,7 +72,8 @@ static inline void p4d_populate(struct mm_struct *mm, p4d_t *p4dp, pud_t *pudp)
>   	set_p4d(p4dp, __p4d((unsigned long)pudp));
>   }
>   
> -#define __pud_free_tlb(tlb, pmd, addr)  pud_free((tlb)->mm, pmd)
> +#define __pud_free_tlb(tlb, pud, addr)	\
> +	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pud))
>   
>   #endif
>   
> @@ -83,10 +84,12 @@ static inline void pud_populate(struct mm_struct *mm, pud_t *pudp, pmd_t *pmdp)
>   	set_pud(pudp, __pud((unsigned long)pmdp));
>   }
>   
> -#define __pmd_free_tlb(tlb, pmd, addr)  pmd_free((tlb)->mm, pmd)
> +#define __pmd_free_tlb(tlb, pmd, addr)	\
> +	tlb_remove_ptdesc((tlb), virt_to_ptdesc(pmd))
>   
>   #endif
>   
> -#define __pte_free_tlb(tlb, pte, addr)  pte_free((tlb)->mm, pte)
> +#define __pte_free_tlb(tlb, pte, addr)	\
> +	tlb_remove_ptdesc((tlb), page_ptdesc(pte))
>   
>   #endif /* _ASM_ARC_PGALLOC_H */


