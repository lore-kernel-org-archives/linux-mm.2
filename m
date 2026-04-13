Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3281F531C7
	for <linux-mm@archiver.kernel.org>; Mon, 13 Apr 2026 20:03:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 343786B00B7; Mon, 13 Apr 2026 16:03:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F3B46B00B8; Mon, 13 Apr 2026 16:03:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 20A096B00B9; Mon, 13 Apr 2026 16:03:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0F0446B00B8
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 16:03:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 8D672E30EF
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:03:02 +0000 (UTC)
X-FDA: 84654606204.24.80B52CE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id C1AA6A001F
	for <linux-mm@kvack.org>; Mon, 13 Apr 2026 20:03:00 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HxgT6fUn;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776110580;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oDzIliDM6S854tOGtnK9335dGZ7UluEeVHOtyDJVWLU=;
	b=REB84sgvHFgky7V6LLYPufXjIGNGWPJtJJk1K5P9HieceANkrPqXEImZMQKZ+x2jTscqpI
	zcvRQeQDaUEzJnuFo2cU6KzErJy4trpTYKTbibLZKGFIMtgJjQ6kOzmqAQboiwHkP19yhE
	a8N71D2hI+Vfornu7R6inMEIeN9TB2E=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=HxgT6fUn;
	spf=pass (imf15.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776110580; a=rsa-sha256;
	cv=none;
	b=aNDkPHgpAeBr64PDLVPMp5jP46FBmyEVu+i+ZQ8/c8mTEO/dEt9N3MgFEneDhCOzt17d7v
	qazrT3XPtemiy1D6sVRW9DtZ9JV0kajMhLlZLTdFBP9j7mRmOi5tujeo1t5cnyQPgRQtgp
	ZTckxP54PM+w0wIC29NCQP5cAihvOG0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0018F61843;
	Mon, 13 Apr 2026 20:03:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D03C2BCAF;
	Mon, 13 Apr 2026 20:02:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776110579;
	bh=X5Qr7RMZPcVsHaB67sBlEm7JbLFMJ0dv+rLoHvobS5U=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=HxgT6fUn+5kb5WwLOPN7Ze+RMzag6T9eul66Jd1aQhH3Ac+bnWH7NDyXrPyemABdp
	 I/Iqc9Wmid5rK7bX78l6MdpPYYovFk6XcU+m9MXNu2B9lQ3AE/CKKoV407TZ7lYy5y
	 ikjD7iopCPr000/vOdpw0eZ54kJ9LYsQxZIKjB5FzBynfxPRKf3vWruvwKWB3kUiOg
	 B3L96qx/q21+cISIF5UZsBJ6QF2HiTjat5Owme2y6anfyX/m7HxUJAVm5jFQNS131i
	 rE0oVtcBGYt4MEJCQDvGJUk6vIPguYRBddrEDPSx+80OIt4jrDXHePx/EBqg2x6Zoj
	 2ayc1/HcJ6uSA==
Message-ID: <9886b2c6-5516-4be8-ac31-db3133455af2@kernel.org>
Date: Mon, 13 Apr 2026 22:02:41 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3 4/4] mm: add PMD-level huge page support for
 remap_pfn_range()
To: Yin Tirui <yintirui@huawei.com>, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 willy@infradead.org, catalin.marinas@arm.com, will@kernel.org,
 tglx@kernel.org, mingo@redhat.com, bp@alien8.de,
 dave.hansen@linux.intel.com, hpa@zytor.com, luto@kernel.org,
 peterz@infradead.org, akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, anshuman.khandual@arm.com,
 rmclure@linux.ibm.com, kevin.brodsky@arm.com, apopple@nvidia.com,
 ajd@linux.ibm.com, pasha.tatashin@soleen.com, bhe@redhat.com,
 thuth@redhat.com, coxu@redhat.com, dan.j.williams@intel.com,
 yu-cheng.yu@intel.com, yangyicong@hisilicon.com, baolu.lu@linux.intel.com,
 jgross@suse.com, conor.dooley@microchip.com, Jonathan.Cameron@huawei.com,
 riel@surriel.com
Cc: wangkefeng.wang@huawei.com, chenjun102@huawei.com
References: <20260228070906.1418911-1-yintirui@huawei.com>
 <20260228070906.1418911-5-yintirui@huawei.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260228070906.1418911-5-yintirui@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: a999fbk1wfkh8g11c5hcw8s5uhjk8c7t
X-Rspamd-Queue-Id: C1AA6A001F
X-Rspamd-Server: rspam09
X-HE-Tag: 1776110580-621228
X-HE-Meta: U2FsdGVkX1+HxUjQN1sr/2o2e0TDylRiHiatHuGEEdLhXLiAS+q7xESv+H4HCeVs3c/fmPY8s7WFc8jOAbE8iMgKed9CbK3cU8Mj+1eo23qcXJl0Xi0A7XMpP3/RvDw5syJTSReg/BFRVSw10tFfk1OjnrmNjl61qCsnq38kdCW0Nh3qGUs5FbNtJ/lVKHIEsFJEE89ZsOcPMwtrknfVZxTyftOhH5XG/vAAglpFinFnGbHVWBR4MxuLcRiTJeZTs1uCgBqIGLt6Y9FnsHfC9VnrjmFr3E/XsyGfeadW3P1FrCQWKMWg6u7yfnPGTXykBN+OBymiK4MjV/EjFA4kZuRwTpq5OSCXoH9M5OnOC3tHNl2S4Zx2QBLBGUgrtpGJHi1pvVkPOt30vjCNkTwnE0zFVUMva4gcZ9mC+nvBNNPij14weD5zXDf65ArrB9GR43dtQ4oWy6W7JFZVcssfz22w80T6FjHsRilxawJVlJUr4dFGq/a88SIMxbce5dV+STJUcX+eJA9ylYRAq2E0K4NCkuNb6tjfrNmJwen/3ZCYjf3q1+ote7VcnvWHKReJ5URoP2HQQ8zp17bxCAT0gJjKnRN8U43oAyUuacHDon9hYl0keBNq/FpGhUl9N1XTnlntkYeUs7wN11uNLuSvBSVwmAcxLJnbl7SXuKaX+l1KkL1XRZ4nZ0K/inPqTiZAQvMudGve0rIq+wlMupJw708xGQcbhFLnuDASbmI6Q9hbzdhN/UBLa7OEKflFHMObqj1MG83CWhxlt7oL49xzjTKQM99SYpS91Bne025GOr/Nz3Pdv1AcVejEWdEtiyvS1cmtLsEsFPm5V/pjbG65TgGIplDUfFWLgdJ+NE6fdLROoo5o98k+1PpnkPjKxyQGgm5s5na1q2LcwLPExYkwkdjTBnMvYsMM7uIP9ElSivcbvA5VJrMMfT9l/R0r9qdOf9hZWXXQrZOrFJb/b5w
 ykN6yoh0
 QXjK+f+GMtihMElPPj/kVr6bZZA0TN0TMDbNnmVP9xtr0YSsarqqheoiRnadF/sFPOcIv1rX3C629oFOENxK+WwU6i3ALNOoxOaA5pHmyeUVIMZB3AGzoQroSwsJYYHzXitgVWqs+cLoXSIiwSpthLmciDO14NbVhnKluSMCFWUbBY1IbVdXXW7pt86nm2siTxDghVGpq1awpvTvgeuQ0nEEMRb1OcvQA+1qinBA1PscszN2HmZrqGu4nZ4f+Z/NWAGDywJzpKNy1F4455Qrfb6ggCSuO9uksXisGCx8cg/ovB4rNadxyYDA77iJxJsgUP5bFn7r8kkfHkKrnbYw7mZeZTg28m+GSeb6Sf0L+b/LCzbjGeW1tKr4jB4zZk9mFyTjYxdEq7AUFKi1B073ay9TjYla59PH4qKNg
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/28/26 08:09, Yin Tirui wrote:
> Add PMD-level huge page support to remap_pfn_range(), automatically
> creating huge mappings when prerequisites are satisfied (size, alignment,
> architecture support, etc.) and falling back to normal page mappings
> otherwise.
> 
> Implement special huge PMD splitting by utilizing the pgtable deposit/
> withdraw mechanism. When splitting is needed, the deposited pgtable is
> withdrawn and populated with individual PTEs created from the original
> huge mapping.
> 
> Signed-off-by: Yin Tirui <yintirui@huawei.com>
> ---

[...]

>  
>  	if (!vma_is_anonymous(vma)) {
>  		old_pmd = pmdp_huge_clear_flush(vma, haddr, pmd);
> +
> +		if (!vma_is_dax(vma) && vma_is_special_huge(vma)) {

These magical vma checks are really bad. This all needs a cleanup
(Lorenzo is doing some, hoping it will look better on top of that).

> +			pte_t entry;
> +
> +			if (!pmd_special(old_pmd)) {

If you are using pmd_special(), you are doing something wrong.

Hint: vm_normal_page_pmd() is usually what you want.

> +				zap_deposited_table(mm, pmd);
> +				return;
> +			}
> +			pgtable = pgtable_trans_huge_withdraw(mm, pmd);
> +			if (unlikely(!pgtable))
> +				return;
> +			pmd_populate(mm, &_pmd, pgtable);
> +			pte = pte_offset_map(&_pmd, haddr);
> +			entry = pfn_pte(pmd_pfn(old_pmd), pmd_pgprot(old_pmd));
> +			set_ptes(mm, haddr, pte, entry, HPAGE_PMD_NR);
> +			pte_unmap(pte);
> +
> +			smp_wmb(); /* make pte visible before pmd */
> +			pmd_populate(mm, pmd, pgtable);
> +			return;
> +		}
> +
>  		/*
>  		 * We are going to unmap this huge page. So
>  		 * just go ahead and zap it
>  		 */
>  		if (arch_needs_pgtable_deposit())
>  			zap_deposited_table(mm, pmd);
> -		if (!vma_is_dax(vma) && vma_is_special_huge(vma))
> -			return;
> +
>  		if (unlikely(pmd_is_migration_entry(old_pmd))) {
>  			const softleaf_t old_entry = softleaf_from_pmd(old_pmd);
>  
> diff --git a/mm/memory.c b/mm/memory.c
> index 07778814b4a8..affccf38cbcf 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -2890,6 +2890,40 @@ static int remap_pte_range(struct mm_struct *mm, pmd_t *pmd,
>  	return err;
>  }
>  
> +#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP

Why exactly do we need arch support for that in form of a Kconfig.

Usually, we guard pmd support by CONFIG_TRANSPARENT_HUGEPAGE.

And then, we must check at runtime if PMD leaves are actually supported.

Luiz is working on a cleanup series:

https://lore.kernel.org/r/cover.1775679721.git.luizcap@redhat.com

pgtable_has_pmd_leaves() is what you would want to check.


> +static int remap_try_huge_pmd(struct mm_struct *mm, pmd_t *pmd,
> +			unsigned long addr, unsigned long end,
> +			unsigned long pfn, pgprot_t prot)

Use two-tab indent. (currently 3? :) )

Also, we tend to call these things now "pmd leaves". Call it
 "remap_try_pmd_leaf" or something even more expressive like

"remap_try_install_pmd_leaf()"

> +{
> +	pgtable_t pgtable;
> +	spinlock_t *ptl;
> +
> +	if ((end - addr) != PMD_SIZE)

	if (end - addr != PMD_SIZE)

Should work

> +		return 0;
> +
> +	if (!IS_ALIGNED(addr, PMD_SIZE))
> +		return 0;
> +

You could likely combine both things into a

	if (!IS_ALIGNED(addr | end, PMD_SIZE))

> +	if (!IS_ALIGNED(pfn, HPAGE_PMD_NR))

Another sign that you piggy-back on THP support ;)

> +		return 0;
> +
> +	if (pmd_present(*pmd) && !pmd_free_pte_page(pmd, addr))
> +		return 0;

Ripping out a page table?! That doesn't sound right :)

Why is that required? We shouldn't be doing that here. Gah.

Especially, without any pmd locks etc.

> +
> +	pgtable = pte_alloc_one(mm);
> +	if (unlikely(!pgtable))
> +		return 0;
> +
> +	mm_inc_nr_ptes(mm);
> +	ptl = pmd_lock(mm, pmd);
> +	set_pmd_at(mm, addr, pmd, pmd_mkspecial(pmd_mkhuge(pfn_pmd(pfn, prot))));
> +	pgtable_trans_huge_deposit(mm, pmd, pgtable);
> +	spin_unlock(ptl);
> +
> +	return 1;
> +}
> +#endif
> +
>  static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
>  			unsigned long addr, unsigned long end,
>  			unsigned long pfn, pgprot_t prot)
> @@ -2905,6 +2939,12 @@ static inline int remap_pmd_range(struct mm_struct *mm, pud_t *pud,
>  	VM_BUG_ON(pmd_trans_huge(*pmd));
>  	do {
>  		next = pmd_addr_end(addr, end);
> +#ifdef CONFIG_ARCH_SUPPORTS_PMD_PFNMAP
> +		if (remap_try_huge_pmd(mm, pmd, addr, next,
> +				pfn + (addr >> PAGE_SHIFT), prot)) {

Please provide a stub instead so we don't end up with ifdef in this code.

-- 
Cheers,

David

