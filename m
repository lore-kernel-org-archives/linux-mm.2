Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E742ACAC5B8
	for <linux-mm@archiver.kernel.org>; Thu,  2 Oct 2025 07:26:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4EDC88E000A; Thu,  2 Oct 2025 03:26:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4BE658E0002; Thu,  2 Oct 2025 03:26:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC208E000A; Thu,  2 Oct 2025 03:26:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 335CD8E0002
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 03:26:16 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3B77119AD9
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:26:15 +0000 (UTC)
X-FDA: 83952340710.02.8FF7A40
Received: from out-184.mta0.migadu.com (out-184.mta0.migadu.com [91.218.175.184])
	by imf16.hostedemail.com (Postfix) with ESMTP id E62EB180005
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 07:26:13 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=loFmx088;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759389974; a=rsa-sha256;
	cv=none;
	b=jb+xjtuM7rCo0D6Njh0B7+yksjN2Zlbdbp4fZvz4r2XWp4eK6ZjfJN648qMZ5oACKvBePA
	RUgAIBdkwqNYnzu7rAjwSGNCN5Vptw3LfrQC0M7OdEIfdQ3pxfKepxmyUEb4g3vs6sh4cM
	D0nyJYMkHzFGdDOnE3GAEm/mQPOS+4o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=loFmx088;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf16.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.184 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759389974;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wcfqctUWyMyKjwwrVZORei8dkKTWNNNgmJPwVrqv29Y=;
	b=Ncfi+sBsXS5Z7H7D7GRmYFy1NUEesAgdWQ+uqfeNRRs5h6ju3ti+B4U14KGZYJtMBTnY3S
	sEKUV+ygh8aFIf5rCb9N8x/INEpRYa1+j7SnoZq336EPfN9rD89ZJfs491A+AQpRElDTS1
	XBTTzHj8F6UPxR6T/QmcLKTSRVVmhnQ=
Message-ID: <b6788269-ac34-407a-9a5c-b94a90724a52@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759389971;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=wcfqctUWyMyKjwwrVZORei8dkKTWNNNgmJPwVrqv29Y=;
	b=loFmx0885gwXjnfIOCVEplFjluOdPJ+4irqQ3udyeTsxUCFyE9/aKOMTcQGJipS4gutdlD
	JKieqM6UTA3YPS8U1/l3j+/HvX4J4v5g9LWuRj9MABc3ed/X6W/QiRQCHOIXJbHw4jJmgp
	348lCGCcsfsBDoVc2k11eeV3ojgVJK8=
Date: Thu, 2 Oct 2025 15:26:02 +0800
MIME-Version: 1.0
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, stable@vger.kernel.org, npache@redhat.com,
 lorenzo.stoakes@oracle.com, baohua@kernel.org, ziy@nvidia.com,
 dev.jain@arm.com, wangkefeng.wang@huawei.com, baolin.wang@linux.alibaba.com,
 david@redhat.com, ryan.roberts@arm.com, Liam.Howlett@oracle.com,
 akpm@linux-foundation.org
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251002013825.20448-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E62EB180005
X-Stat-Signature: xxbaegfmkgpza4i4oko3icz3sxi9xx6b
X-Rspam-User: 
X-HE-Tag: 1759389973-867421
X-HE-Meta: U2FsdGVkX185DD3GrxnJIxXNun40E3ASC6qdrV4L2CFrmfb1MBVlEEDGrWB4O2sRZ8tA/hfuMrjotEnDYzvA+dE3bDUUifyVUgZPLqX1MPtOHcguLj+DxKt5sv9H+i4rjuPVJ6PRLrlCl5Ud2ZVqUzTXjjbo18pkUoHWcX6tKOK98okMZOB1xho4XBMB2U8eHC4FqQ6GQVshOpq77fqVg7ugRkMVrHDtmciqc1IQ/lRX3liRp62l8SNUwyziX7iXASI7U4P2MxrXMmpX+CoMWSkTcCYuScKWVc/12a+HKc6ElOqpApU01Yblw7r4O47TDV22pCHf+E4/7/l3KDlnRjGXaLXnYgjq/Gagdq7jvNW6g14Hypl4twLycEkrpEESWtZxNAEu7m87xymqk0m6O6QijIPS0q2qTvskvfJ7AqbOscNfiDQUMIIEu2+vuEnqsdI1UwzWwGX3mmb7rI6jIs3eOiSPBSIwWCqJwIqu6G4+CxUycFFUPuCn4Fj5rWeeiXFH08VJcyephPMWOS6KSBTkYwEXUyEWMKJ0PImyhT0mOg60YR6mqbOAiHvUIB1jnspZaKF/xTnj9vBTePn46IYdk2zofF1XSKiX9deCCX/5EumRxuMbYaDxHpHMN9mtf9iP8/8PQANrUayfW6fr6qgLPs55bss5kI+8HAz2Ki78yRLstbpTeGrGSp6Xb2/HQ1DFVLb7MnNdRP8PKjbdgSpQicgadwcr8fuRGKHZNAnwxWXVK0+NUf3V4DEiuOEP8ehX+bmxIBVAiZbU44Axo17xanZt+08VksaNC8BCoQoeC1q/o0+JKn+QlT3cYvJ5yhD/E0hOThA0vmaZEQk/9GEJFOA8SdQJsqsFX/43or9/G24EZH+BYEUcUo5L8d2Kk1lMFaHnNCitUoAkWDWCsLj18jkN1baP8KkvWEs6C96ZEFfePjCm74Trof0nJH70G1dNsXJGYCqnxKqve1r
 YIEwtBsf
 STSHVPap0wakKREy7PdX9LfQg2C4QH6hJfyROPCNirE3AtsPouV96xxgjRPcyw+ZPvof6IbQoC8u+oEiRVJQ9oqEU037NSmeyhxvzZjP3nm2PQSxdU5NJWfV99eIPGx0H0KDzXtMTLbEqozVkIZgT6nJ8xCebS0UHiFnu4jW+zUn3GyR6uMuJZgFWpdOzG1GqS+GyPHSczwxzNIOXi+Z1m233MUU9eKyIJ1TyXIoECnGWOkOi5Xt/Y/d6DxOq12n4XTR44dkZLKfhfPFqDdEbWI7WJuwj1Lbu5ftE9MaOyBn5Gey38bxlNtiHVPs3ied/wTwwD3+ra/AdALeNYYSDGQyOJUSpnxIgNV6t0vcO42JKFq83R0YgemNt+C+v1RaPTJpmpw/doB9wCoWk9cjdy4aHodnA08xoE9e28a/eRB5BAm6R2SiMz3eBQEjrnOueK3buAOBuEoBzSMA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/2 09:38, Wei Yang wrote:
> We add pmd folio into ds_queue on the first page fault in
> __do_huge_pmd_anonymous_page(), so that we can split it in case of
> memory pressure. This should be the same for a pmd folio during wp
> page fault.
> 
> Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
> to add it to ds_queue, which means system may not reclaim enough memory
> in case of memory pressure even the pmd folio is under used.
> 
> Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
> folio installation consistent.
> 
> Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")
> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: <stable@vger.kernel.org>

Cool. LGTM.

Reviewed-by: Lance Yang <lance.yang@linux.dev>

> 
> ---
> v2:
>    * add fix, cc stable and put description about the flow of current
>      code
>    * move deferred_split_folio() into map_anon_folio_pmd()
> ---
>   mm/huge_memory.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index 1b81680b4225..f13de93637bf 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -1232,6 +1232,7 @@ static void map_anon_folio_pmd(struct folio *folio, pmd_t *pmd,
>   	count_vm_event(THP_FAULT_ALLOC);
>   	count_mthp_stat(HPAGE_PMD_ORDER, MTHP_STAT_ANON_FAULT_ALLOC);
>   	count_memcg_event_mm(vma->vm_mm, THP_FAULT_ALLOC);
> +	deferred_split_folio(folio, false);
>   }
>   
>   static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
> @@ -1272,7 +1273,6 @@ static vm_fault_t __do_huge_pmd_anonymous_page(struct vm_fault *vmf)
>   		pgtable_trans_huge_deposit(vma->vm_mm, vmf->pmd, pgtable);
>   		map_anon_folio_pmd(folio, vmf->pmd, vma, haddr);
>   		mm_inc_nr_ptes(vma->vm_mm);
> -		deferred_split_folio(folio, false);
>   		spin_unlock(vmf->ptl);
>   	}
>   


