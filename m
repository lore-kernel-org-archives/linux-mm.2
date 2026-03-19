Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 99867108E1F0
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 11:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A3E06B0486; Thu, 19 Mar 2026 07:34:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 07CB56B0488; Thu, 19 Mar 2026 07:34:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFB6C6B0489; Thu, 19 Mar 2026 07:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E2A6A6B0486
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 07:34:23 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 79A131A04EE
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:34:23 +0000 (UTC)
X-FDA: 84562604406.18.2CE274D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id E3D4D4000F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 11:34:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HXR9V298;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773920061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cP2v8J77qhH7+P6f3MKSn1tr8varIjm4aeTGVT+Ue4g=;
	b=1qEBbDtYhdZsFbPEuNJ4GxUfv0Vjp32Bs1RxeT5PgxvvmePy0rY4bRRc1afTTxVW0uL3pD
	qk+aJoVGa0xFN7KBcDiAb3HtEW9C6BgwoLzbLLirtVHnoeS2lPyzk7g0ytJJ9nQGs9+Qmz
	mesF0m9XYMtRSIZzI28CcF3UEbyRRWg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773920061; a=rsa-sha256;
	cv=none;
	b=XMhw7T4ilRW5wTT73vOrqUU8rGESfdruB6zJiqSE032uOARV21yi0XItEBoqBpT8JcU6e+
	JUgLE4ZdX/LG88KfnhbPXcGns2ky4IVRdbuS7z67JcUbClFxd3nT7b97UYVeFOtZgseXZq
	ekpMuGQlVZzk2dokhCBtX7YOnvvfPjQ=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HXR9V298;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 52D9E600AD;
	Thu, 19 Mar 2026 11:34:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5F2C2BCB0;
	Thu, 19 Mar 2026 11:34:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773920061;
	bh=vGPmcqAhZCk0gdlr+wYCcpNO1tqWQw2RngJu1gW9hIk=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=HXR9V298CpUtMI8uiUfzgXIhpTXpgltg84qzhP5tYL999s9u38RdIf5/+znO/AKE1
	 nqdW9Kq54pTvI4cGRFD2fUy4wjnBRVN+hAoSlkhQipxY5QwpDm0qw/h962PSLEsbLR
	 v6RwuOsIJQst5wZaS5ybKMq5k9XUSGo1qyD2DHzUbCEZzYDzvgPHeP/Dx+E4/aQnpy
	 yVeQFdy4I9jGYcI7u2KCScFjvcb5MeSUYYiTwA5vTmdH/rrgzTC2wcNRsJt4VgQH5M
	 eNJt8KcZbP8/OhTnGatWrUV8VPU4EftxdWW/1OF1NI646J0TpK4aNS9v3S1zz09OW3
	 LuZU7ah4P9Amg==
Date: Thu, 19 Mar 2026 11:34:14 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: akpm@linux-foundation.org, david@kernel.org, Liam.Howlett@oracle.com, 
	vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
	linux-arm-kernel@lists.infradead.org, x86@kernel.org, linux-parisc@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org, 
	kvm@vger.kernel.org, open <linux-mm@kvack.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/6] mm: change to return bool for
 pudp_test_and_clear_young()
Message-ID: <522588b0-1172-4cc6-9011-f077e94011df@lucifer.local>
References: <cover.1773890510.git.baolin.wang@linux.alibaba.com>
 <2711ec4bf6c30182004e34027fb31a2e8e24749e.1773890510.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2711ec4bf6c30182004e34027fb31a2e8e24749e.1773890510.git.baolin.wang@linux.alibaba.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E3D4D4000F
X-Stat-Signature: gkr57177razy3togo5k6cq6ndatzp1yd
X-Rspam-User: 
X-HE-Tag: 1773920061-71238
X-HE-Meta: U2FsdGVkX18CFWL7yiAHu5grCyV6j2slY49lTvWe2DHtx9zqusIALdpP5dU8xZb0h4ysfD1HmjOMQFrb/9e/FUR1jCp6oshbdr9vvftmrYKisnNI2Vk6WdcCriOkSrfpcoWVgyirmRG2eJcB299Ly6PRKgzIa5Q7/QfY/jFKwdJ2XUtBB3ge5kw6vaIRhnQa7TZaE5DykPdqGCtrXlbCKOV4ygYcot/bTgNeR3gRiHwg8F17PGcNj364hncpVkoGN7JkSPKh6jCoMMY0Ti51JdbOklex9PQP7knUqqr7Uj5+Daf7ZDUrwXDgHBpf1b+VB7gZU7ItdzKfWxfFYvkwz0/nR3Te5mbzIpe+NCki7VpoVYK9j/3THknReCrFskyXRQmYZBL3rtnSlZKGfqhoWEHcKnyjuw6wl6IXRyB4DoEhPx79bTftBHZW6jgdhLk4c/eh9RhZKZ9jHyy3hnLN47yoTcgxoBjihpfkaOXk0ACZcJLOO+oTReIPglhEl3CaShEDNVDLvcfE86mdLYr/beHrzzwcJTUTpi7NpJ4K4Kmv9cbMU2SMvB96PsxPadDBRqCkPlEYH6tYCSNamCSU2KA0Y/PlJ4vUDBKcz7HY+KejPrnha+ftCRF0e3mFJXrwIU89lTY18cHlQZxAlueSHEJj48Xgoc//CT6dc/qKaYLGDKdOrGyR+uuNaNRcuLWs90SeFID1jRaaF50F9XmMTddsE3cjVMCp3wRP8/hYkdTk4QnCEocBk7S/OZxt0kLhoCxV0CVKlhzLDYoq/u23rn2Rac0kdAN6vJJ6k+E822cFFPvTpqJFFNGCeY0v0Kt21Fw75CTsimtaTBHhSXdWumwlkgIamELVORoAc8kYbm07vmAfgXILsx5GAj6J8Em1XjTT8wX6JiDag2LNey89Is14G0GZgnoP26W/wDeiEp9BFf4dsWuhTemCFTHTNgMqWOFGC7W93n5QrgwZlCr
 IkwkuJBC
 JztviY6dqFl8UlsoOWFj3qaw88FO3aPCDzn6B3K2p87ia9GDoomAjRtZn0Z9XukNtKwyqUgDVcUitxttSpKZfbu9KlOgGvWljOQW+1JZnXRZNI8dhrqDZG6NEE5PtKfSo9Lf8tv4UohABpl5cHRriosvSAfiBbtEgESRaL5K9rVanfQvIvdthSfIkxxl7R3huflLASRD8nt3WNzFxfRKqV6gPMdUhC5qxVL9GF9/XziTIkPcf5Hlf5tgd8vKodieUgioPh0T3MYluJYBlj8EfHmUH4k9inDoI9X/D6ak4Td7qO78HTaao4V03YQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 11:24:04AM +0800, Baolin Wang wrote:
> The pudp_test_and_clear_young() is used to clear the young flag,
> returning whether the young flag was set for this PUD entry. Change
> the return type to bool to make the intention clearer.
>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Some nits but otherwise loogs good so:

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>

> ---
>  arch/powerpc/include/asm/book3s/64/pgtable.h | 10 +++++-----
>  arch/powerpc/mm/book3s64/pgtable.c           |  4 ++--
>  arch/riscv/include/asm/pgtable.h             |  4 ++--
>  arch/x86/include/asm/pgtable.h               |  4 ++--
>  arch/x86/mm/pgtable.c                        |  6 +++---
>  5 files changed, 14 insertions(+), 14 deletions(-)
>
> diff --git a/arch/powerpc/include/asm/book3s/64/pgtable.h b/arch/powerpc/include/asm/book3s/64/pgtable.h
> index 0f34011665a6..083c4b9ed5b3 100644
> --- a/arch/powerpc/include/asm/book3s/64/pgtable.h
> +++ b/arch/powerpc/include/asm/book3s/64/pgtable.h
> @@ -1172,13 +1172,13 @@ static inline bool __pmdp_test_and_clear_young(struct mm_struct *mm,
>  	return ((old & _PAGE_ACCESSED) != 0);
>  }
>
> -static inline int __pudp_test_and_clear_young(struct mm_struct *mm,
> -					      unsigned long addr, pud_t *pudp)
> +static inline bool __pudp_test_and_clear_young(struct mm_struct *mm,
> +					       unsigned long addr, pud_t *pudp)

Formatting yada yada you know the drill, 2 tabs etc. :))

>  {
>  	unsigned long old;
>
>  	if ((pud_raw(*pudp) & cpu_to_be64(_PAGE_ACCESSED | H_PAGE_HASHPTE)) == 0)
> -		return 0;
> +		return false;
>  	old = pud_hugepage_update(mm, addr, pudp, _PAGE_ACCESSED, 0);
>  	return ((old & _PAGE_ACCESSED) != 0);
>  }
> @@ -1303,8 +1303,8 @@ extern int pudp_set_access_flags(struct vm_area_struct *vma,
>  extern bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
>  				      unsigned long address, pmd_t *pmdp);
>  #define __HAVE_ARCH_PUDP_TEST_AND_CLEAR_YOUNG
> -extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
> -				     unsigned long address, pud_t *pudp);
> +extern bool pudp_test_and_clear_young(struct vm_area_struct *vma,
> +				      unsigned long address, pud_t *pudp);

Drop the extern please!

>
>
>  #define __HAVE_ARCH_PMDP_HUGE_GET_AND_CLEAR
> diff --git a/arch/powerpc/mm/book3s64/pgtable.c b/arch/powerpc/mm/book3s64/pgtable.c
> index aed39bba891e..838cb4a8e2cf 100644
> --- a/arch/powerpc/mm/book3s64/pgtable.c
> +++ b/arch/powerpc/mm/book3s64/pgtable.c
> @@ -104,8 +104,8 @@ bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
>  	return __pmdp_test_and_clear_young(vma->vm_mm, address, pmdp);
>  }
>
> -int pudp_test_and_clear_young(struct vm_area_struct *vma,
> -			      unsigned long address, pud_t *pudp)
> +bool pudp_test_and_clear_young(struct vm_area_struct *vma,
> +			       unsigned long address, pud_t *pudp)
>  {
>  	return __pudp_test_and_clear_young(vma->vm_mm, address, pudp);
>  }
> diff --git a/arch/riscv/include/asm/pgtable.h b/arch/riscv/include/asm/pgtable.h
> index bac559d29036..88fa63186ca5 100644
> --- a/arch/riscv/include/asm/pgtable.h
> +++ b/arch/riscv/include/asm/pgtable.h
> @@ -1109,8 +1109,8 @@ static inline int pudp_set_access_flags(struct vm_area_struct *vma,
>  	return ptep_set_access_flags(vma, address, (pte_t *)pudp, pud_pte(entry), dirty);
>  }
>
> -static inline int pudp_test_and_clear_young(struct vm_area_struct *vma,
> -					    unsigned long address, pud_t *pudp)
> +static inline bool pudp_test_and_clear_young(struct vm_area_struct *vma,
> +					     unsigned long address, pud_t *pudp)
>  {
>  	return ptep_test_and_clear_young(vma, address, (pte_t *)pudp);
>  }
> diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
> index f9439449c9bd..6ca1fdd25191 100644
> --- a/arch/x86/include/asm/pgtable.h
> +++ b/arch/x86/include/asm/pgtable.h
> @@ -1297,8 +1297,8 @@ extern int pudp_set_access_flags(struct vm_area_struct *vma,
>  #define __HAVE_ARCH_PMDP_TEST_AND_CLEAR_YOUNG
>  extern bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
>  				      unsigned long addr, pmd_t *pmdp);
> -extern int pudp_test_and_clear_young(struct vm_area_struct *vma,
> -				     unsigned long addr, pud_t *pudp);
> +extern bool pudp_test_and_clear_young(struct vm_area_struct *vma,
> +				      unsigned long addr, pud_t *pudp);

Drop the extern please!

>
>  #define __HAVE_ARCH_PMDP_CLEAR_YOUNG_FLUSH
>  extern bool pmdp_clear_flush_young(struct vm_area_struct *vma,
> diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
> index 8c336edf0e65..2677dcf0bbce 100644
> --- a/arch/x86/mm/pgtable.c
> +++ b/arch/x86/mm/pgtable.c
> @@ -470,10 +470,10 @@ bool pmdp_test_and_clear_young(struct vm_area_struct *vma,
>  #endif
>
>  #ifdef CONFIG_TRANSPARENT_HUGEPAGE
> -int pudp_test_and_clear_young(struct vm_area_struct *vma,
> -			      unsigned long addr, pud_t *pudp)
> +bool pudp_test_and_clear_young(struct vm_area_struct *vma,
> +			       unsigned long addr, pud_t *pudp)
>  {
> -	int ret = 0;
> +	bool ret = false;
>
>  	if (pud_young(*pudp))
>  		ret = test_and_clear_bit(_PAGE_BIT_ACCESSED,
> --
> 2.47.3
>

