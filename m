Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95723FD374E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 13:56:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E75C26B0095; Wed, 25 Feb 2026 08:56:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E23596B0096; Wed, 25 Feb 2026 08:56:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CFC866B0098; Wed, 25 Feb 2026 08:56:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B973C6B0095
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 08:56:37 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6402013B2FC
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:56:37 +0000 (UTC)
X-FDA: 84483129234.16.2C09760
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id 82547C0007
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 13:56:35 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BrrhvcB6;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772027795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ic0tJ9oGrpcJbx0Ys3nLG4VmEW5f6HgZdRcOvHuGYr4=;
	b=fjwUFb9aW1B4+yDoqXz4DHprl5oTUWs1ptQPV3dHClUSckXyg7oIlRf67uuriEjs8eYbH0
	+VpCz3dJtm1R8bIXRnTvPe69jjqR5kVHcGc3fKw7V0pwMPgaDoC1QtS+BzStgr5uKQr7YC
	vuTI0eBvHQ/Tx+Qz5yosrm2RfBrNsh8=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BrrhvcB6;
	spf=pass (imf28.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772027795; a=rsa-sha256;
	cv=none;
	b=eaU9IlZBNxv9Fow1shtyWVQrVN3vvObGXSRsZxxYNPU7XYGHx/53DJnZ08lHSAM3OpH04M
	9EwGJKJtwidYnIymHP9dy+Pi9AdiOxVcRSMhsZRCBq1+Rz6sJpUoHF4xt7aGdxv5zr6BU5
	L0i+4/B+orpZpdbL/bqdxxKfuIo4C1w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7706F40774;
	Wed, 25 Feb 2026 13:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69545C19421;
	Wed, 25 Feb 2026 13:56:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772027794;
	bh=adewTxheBJ0exE2Odd3Bcl/XDcxF8jBrDVD2w5lYLiM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=BrrhvcB6m+QHlz7bEjPpcTkhpxbZOBs5XQrkDdBe/HikRWLNblps/GYtmxvT8NLmT
	 lwjp4a9/wkSHSw83DXgMJkE26YbADXQ5Wgrzma0Lzkxe6PrTvGTmGMkcr0S7tjD25a
	 cUbxobXSpjd3msn5/omXQOip0YId1+NkqtVjYSR8RRdQzG4xfaRZOJR/ihRWKT8neU
	 CyfSniRPgXT1bmdKqFRcjIn51gGNFGCW55g6/YssgE3kDtmeAaQ5AMDeliVC3lBXzs
	 mR57N/UT6rGaAzfrKRvdVNfv/88j0Bmfs9tfmn8MrYQmlFcMu4cjEn1Wx+6+4aZ3sn
	 DrC3YTLtn/MQA==
Message-ID: <1e90b26c-5934-47e4-a0ea-96fd8af45076@kernel.org>
Date: Wed, 25 Feb 2026 14:56:26 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/5] mm: use inline helper functions instead of ugly
 macros
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
 <dc94552605926f9ce84f9fc2ddfe5f7d1319e41c.1771897150.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <dc94552605926f9ce84f9fc2ddfe5f7d1319e41c.1771897150.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6pbzwxdd63ffy3sdfgo18iwnniz3zfaf
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 82547C0007
X-HE-Tag: 1772027795-41490
X-HE-Meta: U2FsdGVkX18POALQGJp4K1tgz/aunOhbSFiyJQ/dqAGcoQtQkUagkwbDXBmCwjvsnC0BDU8JVP1bGCapxC/NoLw6dgTLBgGOlvyfCTCFIZsxS5XnL5zLpGKQon1zJrIHhTr/GFKvnLPApOpCpbFA7oK4Z30lgTH0e2kCMPtlSSoMxWwLDdQqgN7kB2Z+JYLzxMNqu+xj/Pygqp8HqljDdH206cBildFaGVZQ5wjaSRRoSi1KjXXk5Es1QcC8x/LyEDQM7H44LQAamXZ8lFeTo9UGcsOFIDv7jIKfAuuDWD2w5qgQf4Np/zY6J3ia9i8jcJmTYXHBX5GLd7yC2Le+UXY6cF8X+vRpFM3/oieUqcFXcxIAtdO6kR48ouGqsHt3E/Qan4VqlcJwSqMNCYOJ22sh3bNYAUuk5McE7WzPv3QPhFtMvAz9adi0hI4v/O5+cIlTwxBGxDVXPUnhMPRj9r8UAr9bEV+u+fXpOyOhBb3f9dGGgIi6jx1VIE8eVXwU/m7xzX0YKpOP4mD3yeiwDPKa0XbVQK0JGd+BcUX/yjFb8ev6AnJy1/819kjBlZ/dOtIcojL5hH4uR065GYA5oSMdHnUeSOQpU982Z1+pWpP2XhatgrJKq1Da9jvwCmWQnSiAerVl5JiWuNu/n/FIhtjXfxptPnDzYKrQRdiuHTUYOSRW3Nk7d1pN3gVAhXV/uhynyIXas1mAm1YZ3P5Ts6xvurjp5SOPYfZlTY1l2b2a1KZhsU95YTulEQiMdemZDAzUQd0Mg8nSu/V12DHUeze8sBm0Ailm58vgQQ6a90oXWQw56ugmzlglqwuba9XCMdWNKtyoQRrevMA8LNSgOrqCqeUz/Zh+tOGlme4DY9W76UAWmBRTCzkjGEgD8yaMTws9L9U3q/GbLOdEQZdKOIxB9Mh9eOHq5OoTC7XIxQng5QzrksZyCLRgSK3k/p9DEei1Z9HaxQW3pm46qB5
 0fyKPL6j
 TweqZJUhClUxX1AygOI4Hem36ySZiGNovSMRA0Lgyr1Lll2fw9Ec/MmY6X28iYZrRXhL3FWrgJR/WyG/+vsxuQGbBU+6qR1oB61rfrRMRSkXnW6qxWJrhrkVz93galJN9NC77XimaPsXewGOlNZ0syJf9O0rujK4K09RRw+44oWyd1eA7eYD6WuG6cRBEeHwVdo4k6UOyziUzzxNtlnPj3m6d7dCs3ljdfWhU0ebvoNrJelpDVpRYRxbcP3MkDe8uvTp8ZhpH5DrLMlK1iX9k3BUo0ryzg3Ky8wBAeOVg21Zg9xkEmDjNcYS3ItKTVv2NBQncIz53T0raheaXFMQQRyIiuw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 02:56, Baolin Wang wrote:
> People have already complained that these *_clear_young_notify() related
> macros are very ugly, so let's use inline helpers to make them more readable.

Could it have been me :)

> 
> In addition, I cannot implement these inline helper functions in the

"We cannot implement ..."

> mmu_notifier.h file, because some arch-specific files will include the
> mmu_notifier.h, which introduces header compilation dependencies and causes
> build errors (e.g., arch/arm64/include/asm/tlbflush.h). Moreover, since
> these functions are only used in the mm, implementing these inline helpers
> in the mm/internal.h header seems reasonable.

Agreed. if it compiles, all good.

> 
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  include/linux/mmu_notifier.h | 54 ------------------------------------
>  mm/internal.h                | 53 +++++++++++++++++++++++++++++++++++
>  2 files changed, 53 insertions(+), 54 deletions(-)
> 
> diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
> index 07a2bbaf86e9..93894b90c8c1 100644
> --- a/include/linux/mmu_notifier.h
> +++ b/include/linux/mmu_notifier.h
> @@ -515,55 +515,6 @@ static inline void mmu_notifier_range_init_owner(
>  	range->owner = owner;
>  }
>  
> -#define clear_flush_young_ptes_notify(__vma, __address, __ptep, __nr)	\
> -({									\
> -	int __young;							\
> -	struct vm_area_struct *___vma = __vma;				\
> -	unsigned long ___address = __address;				\
> -	unsigned int ___nr = __nr;					\
> -	__young = clear_flush_young_ptes(___vma, ___address, __ptep, ___nr);	\
> -	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
> -						  ___address,		\
> -						  ___address +		\
> -						  ___nr * PAGE_SIZE);	\
> -	__young;							\
> -})
> -
> -#define pmdp_clear_flush_young_notify(__vma, __address, __pmdp)		\
> -({									\
> -	int __young;							\
> -	struct vm_area_struct *___vma = __vma;				\
> -	unsigned long ___address = __address;				\
> -	__young = pmdp_clear_flush_young(___vma, ___address, __pmdp);	\
> -	__young |= mmu_notifier_clear_flush_young(___vma->vm_mm,	\
> -						  ___address,		\
> -						  ___address +		\
> -							PMD_SIZE);	\
> -	__young;							\
> -})
> -
> -#define ptep_clear_young_notify(__vma, __address, __ptep)		\
> -({									\
> -	int __young;							\
> -	struct vm_area_struct *___vma = __vma;				\
> -	unsigned long ___address = __address;				\
> -	__young = ptep_test_and_clear_young(___vma, ___address, __ptep);\
> -	__young |= mmu_notifier_clear_young(___vma->vm_mm, ___address,	\
> -					    ___address + PAGE_SIZE);	\
> -	__young;							\
> -})
> -
> -#define pmdp_clear_young_notify(__vma, __address, __pmdp)		\
> -({									\
> -	int __young;							\
> -	struct vm_area_struct *___vma = __vma;				\
> -	unsigned long ___address = __address;				\
> -	__young = pmdp_test_and_clear_young(___vma, ___address, __pmdp);\
> -	__young |= mmu_notifier_clear_young(___vma->vm_mm, ___address,	\
> -					    ___address + PMD_SIZE);	\
> -	__young;							\
> -})
> -
>  #else /* CONFIG_MMU_NOTIFIER */
>  
>  struct mmu_notifier_range {
> @@ -651,11 +602,6 @@ static inline void mmu_notifier_subscriptions_destroy(struct mm_struct *mm)
>  
>  #define mmu_notifier_range_update_to_read_only(r) false
>  
> -#define clear_flush_young_ptes_notify clear_flush_young_ptes
> -#define pmdp_clear_flush_young_notify pmdp_clear_flush_young
> -#define ptep_clear_young_notify ptep_test_and_clear_young
> -#define pmdp_clear_young_notify pmdp_test_and_clear_young
> -
>  static inline void mmu_notifier_synchronize(void)
>  {
>  }
> diff --git a/mm/internal.h b/mm/internal.h
> index e0ef192b0be3..1ba175b8d4f1 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -11,6 +11,7 @@
>  #include <linux/khugepaged.h>
>  #include <linux/mm.h>
>  #include <linux/mm_inline.h>
> +#include <linux/mmu_notifier.h>
>  #include <linux/pagemap.h>
>  #include <linux/pagewalk.h>
>  #include <linux/rmap.h>
> @@ -1789,4 +1790,56 @@ static inline int io_remap_pfn_range_complete(struct vm_area_struct *vma,
>  	return remap_pfn_range_complete(vma, addr, pfn, size, prot);
>  }
>  
> +#ifdef CONFIG_MMU_NOTIFIER
> +static inline int clear_flush_young_ptes_notify(struct vm_area_struct *vma,
> +						unsigned long addr, pte_t *ptep,
> +						unsigned int nr)

Two tabs indent on the second line makes this fit into two lines.

Same for the others.

With that

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

> +{
> +	int young;
> +
> +	young = clear_flush_young_ptes(vma, addr, ptep, nr);
> +	young |= mmu_notifier_clear_flush_young(vma->vm_mm, addr,
> +						addr + nr * PAGE_SIZE);
> +	return young;
> +}
> +
> +static inline int pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
> +						unsigned long addr, pmd_t *pmdp)
> +{
> +	int young;
> +
> +	young = pmdp_clear_flush_young(vma, addr, pmdp);
> +	young |= mmu_notifier_clear_flush_young(vma->vm_mm, addr, addr + PMD_SIZE);
> +	return young;
> +}
> +
> +static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
> +					  unsigned long addr, pte_t *ptep)
> +{
> +	int young;
> +
> +	young = ptep_test_and_clear_young(vma, addr, ptep);
> +	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
> +	return young;
> +}
> +
> +static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
> +					  unsigned long addr, pmd_t *pmdp)
> +{
> +	int young;
> +
> +	young = pmdp_test_and_clear_young(vma, addr, pmdp);
> +	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PMD_SIZE);
> +	return young;
> +}

Wonder why someone thought it would be a good idea to not include the
"test_and_", to make the function names inconsistent.

-- 
Cheers,

David

