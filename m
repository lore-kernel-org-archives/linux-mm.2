Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 071B2CD4F21
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 15:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174D36B00CF; Wed, 13 May 2026 11:58:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 14EF96B00D0; Wed, 13 May 2026 11:58:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 062966B00D2; Wed, 13 May 2026 11:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E427E6B00CF
	for <linux-mm@kvack.org>; Wed, 13 May 2026 11:58:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8643B12021D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:58:32 +0000 (UTC)
X-FDA: 84762854064.23.B8B21ED
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id CE71418000D
	for <linux-mm@kvack.org>; Wed, 13 May 2026 15:58:30 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dKPdBHzg;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778687910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TXLtQN/cID+YhbygPw/SZaS+Xkmzxcww0Agil5Ni8Fw=;
	b=LpJfhv0meCq/R61DtTdJYEKpwUcStNZ9YxXJ6dXT8N/z7kKGupcS9KJplpwpICOdwY3G4J
	CKtU4KOTxOzDAfo4xms11E4eOZ+EbbJhMdrO0WXS8NYkYI7HG+4cd9T6j7+zUB+Hp3I/ot
	RNASb8jhBE8hafr/UIkExsuj4OfwXvE=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dKPdBHzg;
	spf=pass (imf24.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778687910; a=rsa-sha256;
	cv=none;
	b=g0J7Uj8BBCHOhr7C/t2NZOk+AZoWRFTr/aNVeYnr1SPmwsVXACIrfkpyIgfKb1IkWyz6Bb
	qlSS9gGMcD+BI0cAEYFlNP+IzKg+ddnZbW7ldnxo0f4dWCDfo9WrTJC7xpgJXpw5dwa2rs
	MN1iYqw3r3+RlzBFpgrrNWZu2ml7hVo=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 414B260126;
	Wed, 13 May 2026 15:58:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8DE7C19425;
	Wed, 13 May 2026 15:58:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778687910;
	bh=PApq724J+inHsh/m+vC3mHQi47+Gf6kA+K/X2UX9bPM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dKPdBHzggy1jv2nLtIFJzrbMfMvFdRtzQjfjx3v2I5hYGntW/mQ56NO4UHf79ixeq
	 Ru3LDhIFJEOZdun9JTZ5Jsg3cGaJdw0xPGFHEBqWG2/02nnwzDQX3zTHD6lr0yOJNG
	 0h8uCZ8fwWPYAa49l6CVHltoAAFPFDX21YNvckPVns2algAidXm1KZlbbO8L++bvjd
	 iEtiyProkaSekvq81bKZ9EguFu5whLLfqyHl3/oZIUkKNp++fedZrZGkjJY+MsM8U4
	 bDLDRjcPEm7k8H2msYAzgWkUB7XtFdz6Pfrvt4Kafw2x75p8ENk6EuKX1BiG2ACrM5
	 Xw4kEAi9nIlPg==
Message-ID: <ff7bcd65-d444-4da1-890e-75504303ec3f@kernel.org>
Date: Wed, 13 May 2026 17:58:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 9/9] mm: thp: always enable mTHP support
To: Luiz Capitulino <luizcap@redhat.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, baolin.wang@linux.alibaba.com, ziy@nvidia.com,
 lance.yang@linux.dev
Cc: corbet@lwn.net, tsbogend@alpha.franken.de, maddy@linux.ibm.com,
 mpe@ellerman.id.au, agordeev@linux.ibm.com, gerald.schaefer@linux.ibm.com,
 hca@linux.ibm.com, gor@linux.ibm.com, x86@kernel.org,
 dave.hansen@linux.intel.com, djbw@kernel.org, vishal.l.verma@intel.com,
 dave.jiang@intel.com, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com
References: <cover.1777663129.git.luizcap@redhat.com>
 <f67da00a825da9097b5faf2f390ad344450b88be.1777663129.git.luizcap@redhat.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <f67da00a825da9097b5faf2f390ad344450b88be.1777663129.git.luizcap@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CE71418000D
X-Rspam-User: 
X-Stat-Signature: auc64b4qd1j348r7enhh6t7gxpk5rwbz
X-HE-Tag: 1778687910-193692
X-HE-Meta: U2FsdGVkX1+CuXnAPkPFXVQBElG2hhJOJo+9p0iApKIMHs0bV0FgOPfhFXQIfJXZEJAe47aVTXM/RvalpM4nl0GscdL43Zj33GavLW8kAKGGQfHp/LFDtC42plBL9jI63d4mQD0jhU5IQFtrH00XdhshUgkMzdd1krqR3ucWEj0JYYPS8Q4FA4mYYeMt2ZI4p3gxpPNYv3mOK0dxJyHYUCzmbhfRDiLCfXp5HVNwnIe1/QxXu9qMyrCt6ThToEdon4Smr2AfGt93rsJI+PkxMf+4VTkry/gUyjw/IC6l0aRWqmZhPI+BVeM3kmTye/306rPiKvbJmXX1twL3NL7PFQXQ4U+bDyN2iOXI7aw3IitG8xUp9whZ7ADW19wX4tDlLMCAHl3PguPiWgX8FaKiErXP0xrMJ3IpCArud7OLtCbuE/fNeQt/YftgqWKCBXNnhhU8nZySI3kANH3PKSeW/O8K++s0Qxq+63uekFr2zLB0G1yUoVBvwXSBEgOB1Ho9hsyostmCpUNGx4JqY+SpURrt0h5C75r6wGhTf8K2v9JyNpUsBO72S/tl1y8AmP3/7Cr02sfM659rb/ch2Ihf8WpVos/Ur51SaUtfoNPCcaQ2IEjrv6wf+iZqbFGaOXJ6P+wG3YaLN4jKx3vxKMTitPPzhlCV31Bv87qnD6JI0/z+/7uEqp5bfJ0j5oBaczNHtykHDMGC8TSn9F7+sOCSx1l3Gx4PPEbpIA7YUi+jKatjba85pKUKOOzAW5Lis5wrtnCzO3Gfflr1kRtw3p5tkTfbLUON/QTBuWqVfFKs4tgOjrqDqq8JeNV8JcQEHR7OPoMXe2Px8YKg0JyAlDr8FlYyAV3l6WoMr+I5eMw7xTef6SNnaJ1SXyTmp4TKWTP1xb94yL4qg/cEUeQnxihJbe5aBIClnzjMWHR641qWI/iRXEAxo1+ALiQLzDgO/sFFidy0lJczXXkXi5Nguro
 2vGFO/Y6
 NVLac+s0DkOdigOTFlsIdAyqIAtEFyrDnYvwXF07IrYJwQT0pvSC053JROrKo/XXWYRyOSf8Q3/QD1PzP6Qm6WboEiZgzwZJ6bAPJOdCboYduo9fpTKyX2OPxRevYAahxgIMlMYATDrBzpOnS4mdMD6//bsYdt0jxMesCSY1ZisAoAEYoG3RUeRXj3k9uh2PSQWhPWIRj9Kd+datPOipaWDvhHuCTS7zZE9aZT8Y29n0yNNtWDs98b53EZ82FRtFNP4HMux8hGLSn7LlitlzAMOdFPw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/1/26 21:18, Luiz Capitulino wrote:
> If PMD-sized pages are not supported on an architecture (ie. the
> arch implements arch_has_pmd_leaves() and it returns false) then the
> current code disables all THP, including mTHP.
> 
> This commit fixes this by allowing mTHP to be always enabled for all
> archs. When PMD-sized pages are not supported, its sysfs entry won't be
> created and their mapping will be disallowed at page-fault time.
> 
> Similarly, this commit implements the following changes for shmem in
> shmem_allowable_huge_orders():
> 
>  - Drop the pgtable_has_pmd_leaves() check so that mTHP sizes are
>    considered
>  - Filter out PMD and PUD orders from allowable orders when
>    PMD-sized pages are not supported by the CPU
> 
> Signed-off-by: Luiz Capitulino <luizcap@redhat.com>
> ---
>  mm/huge_memory.c | 23 ++++++++++++++++++-----
>  mm/shmem.c       | 14 +++++++++-----
>  2 files changed, 27 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 32254febe097..c1765c8e3dc6 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -126,6 +126,14 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  	else
>  		supported_orders = THP_ORDERS_ALL_FILE_DEFAULT;
>  
> +	if (!pgtable_has_pmd_leaves()) {
> +		/*
> +		 * The CPU doesn't support PMD-sized pages, assume it
> +		 * doesn't support PUD-sized pages either.
> +		 */

I'd say here "If the CPU does not support PMD leaves, assume for now that it
does not support PUD leaves and disable both folio orders."


> +		supported_orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> +	}
> +
>  	orders &= supported_orders;
>  	if (!orders)
>  		return 0;
> @@ -133,7 +141,7 @@ unsigned long __thp_vma_allowable_orders(struct vm_area_struct *vma,
>  	if (!vma->vm_mm)		/* vdso */
>  		return 0;
>  
> -	if (!pgtable_has_pmd_leaves() || vma_thp_disabled(vma, vm_flags, forced_collapse))
> +	if (vma_thp_disabled(vma, vm_flags, forced_collapse))
>  		return 0;
>  
>  	/* khugepaged doesn't collapse DAX vma, but page fault is fine. */
> @@ -848,7 +856,7 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>  	 * disable all other sizes. powerpc's PMD_ORDER isn't a compile-time
>  	 * constant so we have to do this here.
>  	 */
> -	if (!anon_orders_configured)
> +	if (!anon_orders_configured && pgtable_has_pmd_leaves())
>  		huge_anon_orders_inherit = BIT(PMD_ORDER);
>  
>  	*hugepage_kobj = kobject_create_and_add("transparent_hugepage", mm_kobj);
> @@ -870,6 +878,14 @@ static int __init hugepage_init_sysfs(struct kobject **hugepage_kobj)
>  	}
>  
>  	orders = THP_ORDERS_ALL_ANON | THP_ORDERS_ALL_FILE_DEFAULT;
> +	if (!pgtable_has_pmd_leaves()) {
> +		/*
> +		 * The CPU doesn't support PMD-sized pages, assume it
> +		 * doesn't support PUD-sized pages either.
> +		 */
> +		orders &= ~(BIT(PMD_ORDER) | BIT(PUD_ORDER));
> +	}
> +
>  	order = highest_order(orders);
>  	while (orders) {
>  		thpsize = thpsize_create(order, *hugepage_kobj);
> @@ -969,9 +985,6 @@ static int __init hugepage_init(void)
>  	int err;
>  	struct kobject *hugepage_kobj;
>  
> -	if (!pgtable_has_pmd_leaves())
> -		return -EINVAL;
> -
>  	/*
>  	 * hugepages can't be allocated by the buddy allocator
>  	 */
> diff --git a/mm/shmem.c b/mm/shmem.c
> index a48f034830cd..23893c2bc2dd 100644
> --- a/mm/shmem.c
> +++ b/mm/shmem.c
> @@ -1840,16 +1840,19 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>  	unsigned long mask = READ_ONCE(huge_shmem_orders_always);
>  	unsigned long within_size_orders = READ_ONCE(huge_shmem_orders_within_size);
>  	vm_flags_t vm_flags = vma ? vma->vm_flags : 0;
> -	unsigned int global_orders;
> +	unsigned int global_orders, filter_orders = 0;
>  
> -	if (!pgtable_has_pmd_leaves() || (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force)))
> +	if (vma && vma_thp_disabled(vma, vm_flags, shmem_huge_force))
>  		return 0;
>  
> +	if (!pgtable_has_pmd_leaves())
> +		filter_orders = BIT(PMD_ORDER) | BIT(PUD_ORDER);

Would "disabled_orders" or "unavailable_orders" be more appropriate?

There is no need to disable PUD-orders, as shmem does not support PUD-orders
(unlike DAX). So you can keep it simpler here.

> +
>  	global_orders = shmem_huge_global_enabled(inode, index, write_end,
>  						  shmem_huge_force, vma, vm_flags);
>  	/* Tmpfs huge pages allocation */
>  	if (!vma || !vma_is_anon_shmem(vma))
> -		return global_orders;
> +		return global_orders & ~filter_orders;
>  
>  	/*
>  	 * Following the 'deny' semantics of the top level, force the huge
> @@ -1863,7 +1866,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>  	 * means non-PMD sized THP can not override 'huge' mount option now.
>  	 */
>  	if (shmem_huge == SHMEM_HUGE_FORCE)
> -		return READ_ONCE(huge_shmem_orders_inherit);
> +		return READ_ONCE(huge_shmem_orders_inherit) & ~filter_orders;
>  
>  	/* Allow mTHP that will be fully within i_size. */
>  	mask |= shmem_get_orders_within_size(inode, within_size_orders, index, 0);
> @@ -1874,6 +1877,7 @@ unsigned long shmem_allowable_huge_orders(struct inode *inode,
>  	if (global_orders > 0)
>  		mask |= READ_ONCE(huge_shmem_orders_inherit);
>  
> +	mask &= ~filter_orders;
>  	return THP_ORDERS_ALL_FILE_DEFAULT & mask;
>  }
>  
> @@ -5457,7 +5461,7 @@ void __init shmem_init(void)
>  	 * Default to setting PMD-sized THP to inherit the global setting and
>  	 * disable all other multi-size THPs.
>  	 */
> -	if (!shmem_orders_configured)
> +	if (!shmem_orders_configured && pgtable_has_pmd_leaves())
>  		huge_shmem_orders_inherit = BIT(HPAGE_PMD_ORDER);

Do we really want to change that? We can just leave the defaults as is, no?

-- 
Cheers,

David

