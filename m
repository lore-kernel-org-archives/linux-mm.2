Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6F691093172
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 03:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 127956B0413; Thu, 19 Mar 2026 23:49:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0D99D6B0415; Thu, 19 Mar 2026 23:49:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F309D6B0417; Thu, 19 Mar 2026 23:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E0AAC6B0413
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 23:49:28 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8884A8C3CC
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:49:28 +0000 (UTC)
X-FDA: 84565061616.20.C83DB62
Received: from out30-130.freemail.mail.aliyun.com (out30-130.freemail.mail.aliyun.com [115.124.30.130])
	by imf18.hostedemail.com (Postfix) with ESMTP id C86671C000C
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 03:49:25 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VZWNRl8h;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773978566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cCAfDsA4NBFgOqaizYqrOyWkTF9ekbPg4USKuuG8xsg=;
	b=YFfE563yfAMRRn8TULPJerFFttBPjj0nCPA+ctIIHGwlNvIIIhnC0WS9T3rIatlfmvxQFH
	NQjHxF2729LAqLEI2TzcIAcs01WV7plhS8x4Bp7LetxKuj6G7wjwS//xm0oAlD7uRl/zqG
	jOp3UWOzfU4ZfPh02jy7ujr3q7sGweA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=VZWNRl8h;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.130 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773978566; a=rsa-sha256;
	cv=none;
	b=QFJjASkS0uZ4TMk2wJnD3i46ro/5FdlkVCXglKQOgt/5g3E3pD3xPVI4tAvG/ClysbQLVI
	NFNb4nr1hDCQMq0rpQlw1RAuMPFIFunh6gK2aPYrti+k8zZWoTQK/tpmjTtSOclaeqG+K+
	OkK+NXCNFVRR5+Phs8J93JTT5096DJY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1773978561; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=cCAfDsA4NBFgOqaizYqrOyWkTF9ekbPg4USKuuG8xsg=;
	b=VZWNRl8hF42adLO2ssA+4W/7dsomIXuMYWOmN30DgbkT/oEaK9+kDf2xS3SaxEsK+AA5WfHuCxGCT0Qs1AdPzUGwFs+eAOZ4//qdqadCf47cfaGdAIt6y0hyviYB8G7liIvGjD4KKbUlBlaX/gAD550W5yvltVZw0iYUCVdfRmg=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R141e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033037033178;MF=baolin.wang@linux.alibaba.com;NM=1;PH=DS;RN=16;SR=0;TI=SMTPD_---0X.KMQ4a_1773978559;
Received: from 30.74.144.136(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0X.KMQ4a_1773978559 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 20 Mar 2026 11:49:20 +0800
Message-ID: <d67ff262-a627-4cd3-b126-dd82eb8d3412@linux.alibaba.com>
Date: Fri, 20 Mar 2026 11:49:18 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 8/9] mm/huge_memory: deduplicate zap_huge_pmd() further
 by tracking state
To: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache
 <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <cover.1773924928.git.ljs@kernel.org>
 <440f68edcb597c28918d89b0be279d498561c89a.1773924928.git.ljs@kernel.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <440f68edcb597c28918d89b0be279d498561c89a.1773924928.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: C86671C000C
X-Rspamd-Server: rspam07
X-Stat-Signature: rj3mm3gptqp1kddw13krb7x48yg3h3j8
X-Rspam-User: 
X-HE-Tag: 1773978565-884777
X-HE-Meta: U2FsdGVkX1993qj2vOid7f2ammeKGUppaQiQyD3vFLaZpfQNplQ0V/cgH/xD5JS0KUTLMgNZOY9qZBryOGVED41sl1klqsQX65zOYRz09FMgSeNgI3elfAWQepasWnunDsPt9o8/oMTiootW3ACxFgwRHnx6OkslBQ3zalX1JjUoiduoLDpwZR8VQ5v1mUWbgVg25CC8Nwbf0KlAL8s1EbuS5tVsZUH3KlctUJs8/bVXExPrpUmMsaP0Vm0JGgl7T1WsX3wOwI2PyRCqQiq3X/WNEw7MG/WlC4bnRrfY/lp6656+u9rz/6lCbLxb8DN8UjmaU6y+8F62kZKyS6ZUGjRiShrVPBhEhe4PcAaKrT2PjSWhteMR3irbE/NA7WI74ZtV25InncXnxg3zMJFT2bvYyMR21uwz+E36cYzLuI+F5fAycBLB27+b0N6Qx5tKo8HXVOTeRjd9y3SSfKAD0nN2RuutDHSgiK7dUUJ6pBySUy7wqlg/0NQ+kpQhfeCdO5lyK0PdtoPDzxQC2V84k1vzR8kbuljwLq/+Olt5Q3BjyWL+SIXenGf8FpfKaVRjI+TBeFK8p+cJb/+MiH9GDS7vc6y9FZxLuC8Sx/Tuvw6R7bLAuRI0GmLYANBcMiwRh8DiZ2WsZM0dRDsJ68E0bGBzvjhByqorWMUB6SscEvIi4wUtjIQx3QfDzWaX3EVR5+v6RgtZlUglbSujbmXwmqU8jfqqtgPCrfyWqq0sS2m2qjsLtPPoOMUQT9G0PMDLsQGuNNAW7jkFZJaDw1n3cL7NiHL3d/50KM58SWgjsp2DfhIdmH0jWX3YTw3C7ZipZgnrwUdzwiSfk2JLkPArL4AFE+wevhFCGiolfjaP4x7eNlh35NaCCrvpfrV5LsjA7WiIEYyXrStiVVi5F1yXm4TbP2MbFh75yuhO5HYykdE/r0xxfYI666PYD8Q7h9sQdro/Ymu+ydiXZCTl2u1
 3JFHGloX
 men5Yop62J4aQnu5aQkreidZlkSib11TAVNaFewMlIsTShF43yFWCEg8dBO7T0G3yAl0EbxZYrsFQhe8+hMWFfG6pXRb3X4udcJCnUC6oXBp851u9u6vdxssfWgmaHHrb/b7NIxxHCqGDK2IkHRiKl5HCS1jVovtvKXf6DG4Jhb1+xrfOey2haWjqL0fBCY2amtu9HUccqDg+nPSzhvu3xaMoJpe/KaIUx4UrzclxTSROViCAZ56Oiv5ylZq2KOlBFcWK/cPrCeeZ7Ci0YT5PqrNMlWg43cgAIWIAD/w2fihrFDzS4yxtf4d6PshnmkrzE71UkwICGWG5wXCrkZAlEqIt7Dqbvvlh+mpraOU+ck2WwN2ZgcR5wKgIaxLiI5sXNEtf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 3/19/26 9:00 PM, Lorenzo Stoakes (Oracle) wrote:
> The flush_needed boolean is really tracking whether a PMD entry is present,
> so use it that way directly and rename it to is_present.
> 
> Deduplicate the folio_remove_rmap_pmd() and folio map count warning between
> present and device private by tracking where we need to remove the rmap.
> 
> We can also remove the comment about using flush_needed to track whether a
> PMD entry is present as it's now irrelevant.
> 
> Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---
>   mm/huge_memory.c | 28 +++++++++++++---------------
>   1 file changed, 13 insertions(+), 15 deletions(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index c4e00c645e58..22715027e56c 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -2430,9 +2430,10 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
>   bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   		 pmd_t *pmd, unsigned long addr)
>   {
> +	bool needs_remove_rmap = false;
>   	struct folio *folio = NULL;
>   	bool needs_deposit = false;
> -	bool flush_needed = false;
> +	bool is_present = false;
>   	spinlock_t *ptl;
>   	pmd_t orig_pmd;
>   
> @@ -2449,6 +2450,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   	 */
>   	orig_pmd = pmdp_huge_get_and_clear_full(vma, addr, pmd,
>   						tlb->fullmm);
> +
>   	arch_check_zapped_pmd(vma, orig_pmd);
>   	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
>   	if (vma_is_special_huge(vma))
> @@ -2458,17 +2460,15 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   		goto out;
>   	}
>   
> -	if (pmd_present(orig_pmd)) {
> +	is_present = pmd_present(orig_pmd);
> +	if (is_present) {
>   		folio = pmd_folio(orig_pmd);
> -
> -		flush_needed = true;
> -		folio_remove_rmap_pmd(folio, &folio->page, vma);
> -		WARN_ON_ONCE(folio_mapcount(folio) < 0);
> +		needs_remove_rmap = true;
>   	} else if (pmd_is_valid_softleaf(orig_pmd)) {
>   		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
>   
>   		folio = softleaf_to_folio(entry);
> -
> +		needs_remove_rmap = folio_is_device_private(folio);
>   		if (!thp_migration_supported())
>   			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
>   	} else {
> @@ -2483,27 +2483,25 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
>   		add_mm_counter(tlb->mm, mm_counter_file(folio),
>   			       -HPAGE_PMD_NR);
>   
> -		/*
> -		 * Use flush_needed to indicate whether the PMD entry
> -		 * is present, instead of checking pmd_present() again.
> -		 */
> -		if (flush_needed && pmd_young(orig_pmd) &&
> +		if (is_present && pmd_young(orig_pmd) &&
>   		    likely(vma_has_recency(vma)))
>   			folio_mark_accessed(folio);
>   	}
>   
> -	if (folio_is_device_private(folio)) {
> +	if (needs_remove_rmap) {
>   		folio_remove_rmap_pmd(folio, &folio->page, vma);
>   		WARN_ON_ONCE(folio_mapcount(folio) < 0);
> -		folio_put(folio);
>   	}
>   
>   out:
>   	if (arch_needs_pgtable_deposit() || needs_deposit)
>   		zap_deposited_table(tlb->mm, pmd);
>   
> +	if (needs_remove_rmap && !is_present)
> +		folio_put(folio);
> +

This kind of deduplication splits the device folio handling into three 
places, which is not easy to understand (at least for me), since the 
device folio has some special handling.

Especially here, without looking closely at the if condition, it is 
unclear why we need to call folio_put(). Maybe some comments?

Anyway, I don't have a strong opinion. Let's wait for others' preferences.

