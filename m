Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3A16FD374E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 14:04:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EFA56B008A; Wed, 25 Feb 2026 09:04:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09DFC6B008C; Wed, 25 Feb 2026 09:04:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E974F6B0092; Wed, 25 Feb 2026 09:04:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D37936B008A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 09:04:28 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 4E0BFC2380
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:04:28 +0000 (UTC)
X-FDA: 84483149016.24.A82C608
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 470FB1C0008
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:04:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PClkNlBY;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772028266; a=rsa-sha256;
	cv=none;
	b=E6ojXRquKRNwlCYqXzYxHCQoQeYRx+sxWHcO5lpLRP4DdXlDzAX9ErMsQFF6VMICXQ1bdw
	LP8q0iPll6veQnOqEblJGeGSF2uH5jilmMpkT9ILQdFVX6z4ghN1rJHmCkMlN7CZo46JbM
	ICOlC3MG4PwIzMtta351FjA7nd6jCp8=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PClkNlBY;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772028266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DSAgkJWi5hoJt+P3JikprjcOkH0bitSNHNb5Lpt8ZRM=;
	b=qW5U+bhTC368FE8K54AcpSsKkgu7iDeo6mVNxRlcGk9ss1pYCjr3lBgw18tj8jwxXRgimG
	F0oaJx9d3dO/XV3K3aCt59JAaJHvIZ6bvLcbxGBVdpbqhQBQMHe5i+70W8dal+wtbKazIK
	THqZdS8vpfMnrsP7xqArXS/WHRNvV4A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 1921343C79;
	Wed, 25 Feb 2026 14:04:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1371FC116D0;
	Wed, 25 Feb 2026 14:04:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772028265;
	bh=uGl0916oRQSQUnxyyrcUO8NjVfohNTiN1mXCplhRCQA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PClkNlBYDQ2xdogeOlwf0lwcfsg8VJYH5FB61T1LdXbnCrDvl409Q9vKrvHyWSapz
	 6YHimcgknAFRJHtKYdKoKu3wtkVHa0WrB6Juwh5XxqTV+O4WE4DNivfekLfdQ2Y27J
	 Bs/XpORBfPSoslHXzkCwCQLmE6OKF0o5hV5mOrvRs6KNAcaVSLJjr7gSBQfR64L9sg
	 JOnakNnjyfNTVutKLSaugkSwjGDg4Vj7QhjoepZRF4yfpA/fjRpxmza7KB3+D2OG14
	 413W7Kgem4AGvcItQtQnCP+i6sLuxBtvhXQsW8uSxM0tT3LdwjhyW3lXj84sZLb3gb
	 9orwgTYjnzsTw==
Message-ID: <d172d6bf-c60c-4cf5-9da9-f30de38cdfed@kernel.org>
Date: Wed, 25 Feb 2026 15:04:17 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 3/5] mm: add a batched helper to clear the young flag for
 large folios
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
 <bfbe28e381b02452b455498e7ea82662e83a3865.1771897150.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <bfbe28e381b02452b455498e7ea82662e83a3865.1771897150.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 470FB1C0008
X-Stat-Signature: 47r1omibhdujuz7afgaauxfbbxhr8gq5
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1772028266-504958
X-HE-Meta: U2FsdGVkX19jXFP/Wiwp1b0fAKAZ8AHbCBK7y2WCECsy6Ont6rX//TTxLqTytJlDOP8GQC/JfEjqW+AZ/Zr9ykKbUOwdPXWBbiYHZXSCo+Tt9PyNFA/hbkelueFNUddfw7QjTlA3F74+ICXcqmGu8/aVFjmSsugqQT7G0Xq+/zz3Y79fPSH/Sh+dmybPT5LcIMx/d2ZUJRu/HtOYZ5Rwma/b4jQTrzPMoNnzkiOzhRiMsX6MwoozRjwQDbMzSpKSNwq4Pc1AhT+mmEgkCVen2HNRyyNI974WCMuU3TC39EMLHdmH1YI7pgTP7CZ6qjKmNKWb9cZVDuPQdRkTxQscC/JWNgg4QEHQfE+HQwD8Pe06+4aMEka26UBFWjp1vXkhTRokrsCpyVdDIPanpqQh4LzGEDM7Rj3g5d8r4M0BJma6hh2EdX3GKjil6zfFN4grFJ0nV0ULh+SjySGV5XARbbd83Sp4cIlOn2EBdHS9xi7UmZpSQ6JfAGtsHs4Xud5Kicv7DJurYIkSPR4jvL/V2kZlXnYUGkX8nuHu6eGqnZFRKjpoUTfNpCNkahdrEpE58x7SvVbpdF1dbuR7+9POPV3aaGHotWD15hwILMwigHCDAGX1l1QXKPwK1n32+YZnbE01OfV7QdCETj5ATfK+89zEqw257Nwjrd4URy47RvCM2io+Dz2bKDhABNu5PFgq8psms1QhSALtXAvbMXrcmuMnr+qkX1cu79Qb3BfUCd5poDIIs4gzP5pzECN1BvQRvFqMSE+ORcuUoUeEz+iVW8jO+J56Y/sXc3HnhE4ff4oXGTKeCLu3X68tMifaNnrDppyNfXuSSDPZtFi1AXPena6cqK+qd5U8M1vqPeSX5W5UamZpXGqyCvHuiTBW0l+TsKvdihGjbTzp4WdRmppsLRm7HpHbZRXBNDLzzFNq1mnjWP733p4Dhr7dzPPW8ijsETcbBNmnO3Dmx2trZfA
 z4a9UeKt
 MIbmklPWf311G+5Kn1+AuV3Na90Fqk9qxNNNada9xMlhKW9X/e3MEqco+NS+lss02+wttAPFGteZkkUzOR52HCyEMPJCEBbii43Xux7YKS0r/Asng1mo1yOV20kHlSPof9jNNMUA1utllUa8UgyagiMLSwjux8whhfrXd6M7YI1UbGKLXh587GBtmRuLTEKKzK0NYCWlNF930DboiXWEgDO7AH1LcBy8JthTs4ma28ZQkxcRgr/vX7bXb8P4GEpMixxZ/r9QKrYNHjZTjIZ7t1Bwd73b1gKAAcyaReBGbJLfpab6615I2oUr6lg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/24/26 02:56, Baolin Wang wrote:
> Currently, MGLRU will call ptep_clear_young_notify() to check and clear the
> young flag for each PTE sequentially, which is inefficient for large folios
> reclamation.
> 
> Moreover, on Arm64 architecture, which supports contiguous PTEs, the Arm64-
> specific ptep_test_and_clear_young() already implements an optimization to
> clear the young flags for PTEs within a contiguous range. However, this is not
> sufficient. Similar to the Arm64 specific clear_flush_young_ptes(), we can
> extend this to perform batched operations for the entire large folio (which
> might exceed the contiguous range: CONT_PTE_SIZE).
> 
> Thus, we can introduce a new batched helper: test_and_clear_young_ptes() and
> its wrapper clear_young_ptes_notify(), to perform batched checking of the young
> flags for large folios, which can help improve performance during large folio
> reclamation when MGLRU is enabled. And it will be overridden by the architecture
> that implements a more efficient batch operation in the following patches.
> 

Maybe mention that the implementation follows the other existing functions.

> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> ---
>  include/linux/pgtable.h | 36 ++++++++++++++++++++++++++++++++++++
>  mm/internal.h           | 23 ++++++++++++++++++-----
>  2 files changed, 54 insertions(+), 5 deletions(-)
> 
> diff --git a/include/linux/pgtable.h b/include/linux/pgtable.h
> index 776993d4567b..0bcd3be524d3 100644
> --- a/include/linux/pgtable.h
> +++ b/include/linux/pgtable.h
> @@ -1103,6 +1103,42 @@ static inline int clear_flush_young_ptes(struct vm_area_struct *vma,
>  }
>  #endif
>  
> +#ifndef test_and_clear_young_ptes
> +/**
> + * test_and_clear_young_ptes - Mark PTEs that map consecutive pages of the same
> + *			       folio as old
> + * @vma: The virtual memory area the pages are mapped into.
> + * @addr: Address the first page is mapped at.
> + * @ptep: Page table pointer for the first entry.
> + * @nr: Number of entries to clear access bit.
> + *
> + * May be overridden by the architecture; otherwise, implemented as a simple
> + * loop over ptep_test_and_clear_young().
> + *
> + * Note that PTE bits in the PTE range besides the PFN can differ. For example,
> + * some PTEs might be write-protected.

Document the return value?

Returns: whether any PTE was young.

Or sth like that.

> + *
> + * Context: The caller holds the page table lock.  The PTEs map consecutive
> + * pages that belong to the same folio.  The PTEs are all in the same PMD.
> + */
> +static inline int test_and_clear_young_ptes(struct vm_area_struct *vma,
> +					    unsigned long addr, pte_t *ptep,
> +					    unsigned int nr)

Two tabs ...

> +{
> +	int young = 0;
> +
> +	for (;;) {
> +		young |= ptep_test_and_clear_young(vma, addr, ptep);
> +		if (--nr == 0)
> +			break;
> +		ptep++;
> +		addr += PAGE_SIZE;
> +	}
> +
> +	return young;

BTW: can this function simply return (and use) a bool instead?

Likely we should do the same for the other functions, but that can be
done separately.

> +}
> +#endif
> +
>  /*
>   * On some architectures hardware does not set page access bit when accessing
>   * memory page, it is responsibility of software setting this bit. It brings
> diff --git a/mm/internal.h b/mm/internal.h
> index 1ba175b8d4f1..1b59be99dc3f 100644
> --- a/mm/internal.h
> +++ b/mm/internal.h
> @@ -1813,16 +1813,23 @@ static inline int pmdp_clear_flush_young_notify(struct vm_area_struct *vma,
>  	return young;
>  }
>  
> -static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
> -					  unsigned long addr, pte_t *ptep)
> +static inline int clear_young_ptes_notify(struct vm_area_struct *vma,
> +					  unsigned long addr, pte_t *ptep,
> +					  unsigned int nr)
>  {
>  	int young;
>  
> -	young = ptep_test_and_clear_young(vma, addr, ptep);
> -	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + PAGE_SIZE);
> +	young = test_and_clear_young_ptes(vma, addr, ptep, nr);
> +	young |= mmu_notifier_clear_young(vma->vm_mm, addr, addr + nr * PAGE_SIZE);
>  	return young;
>  }
>  
> +static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
> +					  unsigned long addr, pte_t *ptep)
> +{
> +	return clear_young_ptes_notify(vma, addr, ptep, 1);
> +}
> +
>  static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
>  					  unsigned long addr, pmd_t *pmdp)
>  {
> @@ -1837,9 +1844,15 @@ static inline int pmdp_clear_young_notify(struct vm_area_struct *vma,
>  
>  #define clear_flush_young_ptes_notify	clear_flush_young_ptes
>  #define pmdp_clear_flush_young_notify	pmdp_clear_flush_young
> -#define ptep_clear_young_notify	ptep_test_and_clear_young
> +#define clear_young_ptes_notify	test_and_clear_young_ptes
>  #define pmdp_clear_young_notify	pmdp_test_and_clear_young
>  
> +static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
> +					  unsigned long addr, pte_t *ptep)
> +{
> +	return test_and_clear_young_ptes(vma, addr, ptep, 1);
> +}

Why not outside of the ifdef a single generic

static inline int ptep_clear_young_notify(struct vm_area_struct *vma,
		 unsigned long addr, pte_t *ptep)
{
	return clear_young_ptes_notify(vma, addr, ptep, 1);
}

Same comment regarding bool.

-- 
Cheers,

David

