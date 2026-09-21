Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D46EC982E1
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 08:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E43E06B00AF; Mon, 21 Sep 2026 04:27:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DF4276B00D3; Mon, 21 Sep 2026 04:27:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CE3146B00D5; Mon, 21 Sep 2026 04:27:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A5C3A6B00AF
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 04:27:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 298A6140584
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:27:07 +0000 (UTC)
X-FDA: 85237089294.17.B79B419
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 09C85120002
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:27:04 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a1hlKdD8;
	spf=pass (imf29.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789979225;
	b=wszD0w9OcmUe/VrCoVxzjdn6bGk9NqRqADLIe0YE9R2D6u6HACR0iYSf/PhFrkdnrTpxaP
	d2StQ0kKpSxj0oeZcyQk+aXHbzOz7I4cJBQFurKsLOcBrvo7NHQm87bTuNVd1JY+Zkbhpv
	GNJfgbT4DqMpOfIsTbVC6AP4dieIcbg=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=a1hlKdD8;
	spf=pass (imf29.hostedemail.com: domain of ryan.roberts@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=ryan.roberts@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789979225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wgKr7lb5Ys5zQrxRZvsNLpKVISyRcoh008pmPsogQQ=;
	b=mP6n+3vi0Wgvnldo6sIOmzoNvmnwql3lwgBF5yAed9mg7qayWw3lIKc+FMSYJN8DnNm42t
	bxhSAcIj5ReGzadUEOc2TggrHBOsffhxlFSbSyU/eblDTUrIVms/e64RNVqvmGKpUOkTm2
	djjg8TOUo8Do3KO/O+or40IPpWrpp6k=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 9B812175A;
	Mon, 21 Sep 2026 01:27:00 -0700 (PDT)
Received: from [10.57.83.12] (unknown [10.57.83.12])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E68713F86C;
	Mon, 21 Sep 2026 01:26:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1789979224; bh=DAIFdbL4xzUIu7ZahFa8TI9VqSq7uJsS8lo7ckS9dpo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=a1hlKdD8fyjBw+8gF3G8WZAD/mIi7EKGmaNrH8A7prWIORzqTVcC/DXPhIZ79c7vn
	 1vU1HYe/zUy8NNZfs3ZXkTmRkRKFCHIJuXnY3zhDPle3JQVTsugXbliOskfQjOZptF
	 UV56/60hoTzYfzFhV6U3gOs8WqSzLGS6eD578weE=
Message-ID: <86d4aea6-4272-427e-9229-295489e068d7@arm.com>
Date: Mon, 21 Sep 2026 09:26:58 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/6] arm64: convert between HW PTEs and SW PTE values
To: Muhammad Usama Anjum <usama.anjum@arm.com>,
 Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>,
 Mark Rutland <mark.rutland@arm.com>, Ard Biesheuvel <ardb@kernel.org>,
 Ilias Apalodimas <ilias.apalodimas@linaro.org>,
 Andrey Ryabinin <ryabinin.a.a@gmail.com>,
 Alexander Potapenko <glider@google.com>,
 Andrey Konovalov <andreyknvl@gmail.com>, Dmitry Vyukov <dvyukov@google.com>,
 Vincenzo Frascino <vincenzo.frascino@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 linux-efi@vger.kernel.org, kasan-dev@googlegroups.com, linux-mm@kvack.org
References: <20260914-pte0_arm-v1-0-bb53b663e396@arm.com>
 <20260914-pte0_arm-v1-3-bb53b663e396@arm.com>
From: Ryan Roberts <ryan.roberts@arm.com>
Content-Language: en-GB
In-Reply-To: <20260914-pte0_arm-v1-3-bb53b663e396@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 09C85120002
X-Stat-Signature: o5a6utxskx3t75cahhumaoinci7hdynk
X-HE-Tag: 1789979224-608474
X-HE-Meta: U2FsdGVkX18BqqClZGXTUvlqZJ+Np65rBv7mmzcZtQ3jjasco3bYRzCMxz8A9+68CtKNrOzqw9bfk5UfEvsbzzBcv7DpbZ5MfdslkB6b/YCluSwu+0w3SeZUppp6u1BxVrhfdMfXJscGv8+OM7hhUvdlfPo0oIv/TqkaQl8CYU6uWqnmxmN6pJtlkdxu+jb63spedGzxkhFUq34y19Pz8uWtaqmUPJY9xV/0rhBbs8Rai2nVJSJ8uTbGFVSA6X5wMgWuXK2KWpB4lRq0SjLR3q+fDz9yfy9hbPD0Dr/jYR2RGt2J47M1ljeBnviDW9iXgv47Uwa4J6s2yEEldFbV3huWBLtEnx1iL6diig9Ty0Yy0AhMToeESSDakmcrpNgspB7uGNzWk7aLq4qpY6uHI1+RB6w0/qbJR2ief48X1O5VuwuIMZbb0gLQ6n+iCb7eGoohNo88EVkPhUZelbTO/fNI7oqRBP9VJNKENQA+RB2Lzwd7NokIeXleMtBLfOweoZdhCMM/gcNc8vM0+JpoolS26v8yZOzZWXPwPbvBy+zZ953LP79WRuLSkJxI53xHuU9wZHN7ttqNvrgcwo1kneatGyWTr3hMzfs+7hk0sef717jVLPUdEUu7OMmZfsnGrq8lguEgSzP97V3JMIMJ/jT6yZ+uXFC7b60dRHHpmKtTk4fHLjwfg1G8qu1n/2BEhFRf1IhOCF8AYZ75KeEKqgx5LU0Vir7M8ohhq6PmFGXRFqvyz36bNy/c6EGz8MF+9Y2bSuvh69xoh6X+aIrNqCBn4Ks4uwiGnPe5RAta/XHzTyLjpDvUdA+IXd9Dh3T14asXUeZQA+l/cSqhJ0AYJ/ZwRTgmGtax9FljCWNkMWKH+JEigx5iZyryxHxE1W3DgZ0PWNhuEB0uirjQMm/rCvhcBFUF1yh3x4oQhmAudf3zqce1W12jpXAw/Kpa1eW1mtVGYRVoQ23Is1TAarS
 j9ILvqa9
 UYQWaYkOl36Am282sMgwQAfRDchWiRwtjqMN6nH+hqHaTUkocugARtXH8s+NKYrgDGJ/gBF1u+0dCwr6fsoo0cCucgwdXkd/XvgDEanOpkZhhJFthoQ4dOOKFxDy3byvbHt9XZg4cLfi7GoquGYsiD1noKS/E4heJnVQRk/96/HVACQN6ZPtMNAgn30R3VMWLnIOowr+TtVInSqY/J/sJsRpy6yLMDZgTtPZlWnzUa/KhxrRkcJsiL72ZraVdHt21SzmjIlgKwpmfPo4OCUjEcQaVyoRtPSzmMcGc1uvv5uPC4LzOGysBrLVFOCpQs2Ny3JDxlimUdL5MLJT9IuDkKQiqFJaA/VNplybThGXO+Ppg/gcE58gYmoX4RQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 14/09/2026 14:51, Muhammad Usama Anjum wrote:
> __ptep_get() returns a SW PTE value, and __set_pte_nosync() accepts one.
> When HW PTEs use a distinct hw_pte_t, directly reading or writing *ptep
> as a SW PTE value no longer satisfies those interfaces.
> 
> Use __pte_from_hw after READ_ONCE() to obtain a SW PTE value and add
> __hw_pte before WRITE_ONCE() to form an HW PTE.
> 
> Define __hw_pte for both the wrapper and alias configurations so the
> same accessor code works in either case.
> 
> Signed-off-by: Muhammad Usama Anjum <usama.anjum@arm.com>
> ---
>  arch/arm64/include/asm/pgtable.h | 4 ++--
>  include/linux/pgtable_types.h    | 2 ++
>  2 files changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
> index 4768ec59de555..67c4a6179e154 100644
> --- a/arch/arm64/include/asm/pgtable.h
> +++ b/arch/arm64/include/asm/pgtable.h
> @@ -360,7 +360,7 @@ static inline pte_t pte_clear_uffd(pte_t pte)
>  
>  static inline void __set_pte_nosync(hw_pte_t *ptep, pte_t pte)
>  {
> -	WRITE_ONCE(*ptep, pte);
> +	WRITE_ONCE(*ptep, __hw_pte(pte));

Would this work as an alternative? It removes the need for the new __hw_pte()
helper. In future, converting a pte_t to a hw_pte_t won't be trivial so having a
generic helper for it doesn't feel like a good fit.

	WRITE_ONCE(hw_pte_val(*ptep), pte_val(pte));

In general, I wonder if we should avoid defining both the __hw_pte() and
__pte_from_hw() generic helpers. Conversion between sw and hw representations
will become arch-specific in future and for arm64 that conversion will need
extra information so it's can't just specialize these interfaces as they are.

>  }
>  
>  static inline void __set_pte_complete(pte_t pte)
> @@ -381,7 +381,7 @@ static inline void __set_pte(hw_pte_t *ptep, pte_t pte)
>  
>  static inline pte_t __ptep_get(hw_pte_t *ptep)
>  {
> -	return READ_ONCE(*ptep);
> +	return __pte_from_hw(READ_ONCE(*ptep));


...Corresponds with:

	return __pte(READ_ONCE(hw_pte_val(*ptep)));

Thanks,
Ryan

>  }
>  
>  extern void __sync_icache_dcache(pte_t pteval);
> diff --git a/include/linux/pgtable_types.h b/include/linux/pgtable_types.h
> index ee4eace5c3e1c..b5862a16aa497 100644
> --- a/include/linux/pgtable_types.h
> +++ b/include/linux/pgtable_types.h
> @@ -9,11 +9,13 @@
>  #ifdef CONFIG_ARCH_HAS_HW_PTE_T
>  typedef struct __hw_pte_t { pte_t __pte; } hw_pte_t;
>  #define __pte_from_hw(pte)	((pte).__pte)
> +#define __hw_pte(pte)  ((hw_pte_t) { (pte) })
>  
>  #define hw_pte_val(x)  pte_val((x).__pte)
>  #else
>  #define hw_pte_t pte_t
>  #define __pte_from_hw(pte)	(pte)
> +#define __hw_pte(pte)  (pte)
>  
>  #define hw_pte_val(x)  pte_val(x)
>  #endif
> 


