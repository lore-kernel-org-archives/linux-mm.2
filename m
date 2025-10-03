Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B3B29CCA471
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 13:49:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 226C68E0020; Fri,  3 Oct 2025 09:49:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1FE958E001C; Fri,  3 Oct 2025 09:49:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13BB18E0020; Fri,  3 Oct 2025 09:49:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 002BC8E001C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 09:49:46 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id AED385B75C
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:49:46 +0000 (UTC)
X-FDA: 83956935972.29.D887FCE
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf06.hostedemail.com (Postfix) with ESMTP id A7112180009
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 13:49:44 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iMS901TJ;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759499385;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1O4lGRBUIO8tMHHDJsnRMdq/TLfJSS09aZziMz7CPOo=;
	b=Sny3EuFo9SgZYUt4Bb3+DWTnRjVWC3NI8sHa39fUArwksNKxDtP/n6UrC6Eew2TJVz5EUm
	OiDLQwk40wX0kqa1GqfmoUvHrjBA1BN5l6OYtOuNq8Q3Kos3shYsPKMkBBkVUZM9ywFFT1
	AeU2IuUtC01w0N/HOC9/c2agXmRf7+w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759499385; a=rsa-sha256;
	cv=none;
	b=jDoQaEhJtRu3nWaKDrVmXeDaalann9mBN043NBR9bWoLe1+XhzBBb+ua73CCiJTMkG0anB
	mipG8FI3Cvm2VdZtDxu39eQAWxnqmjJ7XtfxzV7EEb6nh1ggOyC+S7Pzr406QfnbbCQUfk
	h7iqhK2thilUn9yP7hH7y7SdhjGaIG4=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=iMS901TJ;
	spf=pass (imf06.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Message-ID: <d8467e83-aa89-4f98-b035-210c966ef263@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759499382;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=1O4lGRBUIO8tMHHDJsnRMdq/TLfJSS09aZziMz7CPOo=;
	b=iMS901TJmkXV6yhuEmITcV9H9/1QSDuf7iyoTHlxjbI7yzc8sOXgRL4HpfNEJI4k4vF+8K
	SNUi5sAKcTdp2Fj8BHxwrCU38Mnz4T5nKS4QjqdxdSB9l7OYu+kEJgEdqyvrY4xgS3dgdA
	PbsZWQ2G1tPlvaK0Q0rurQ3k0NP08Cc=
Date: Fri, 3 Oct 2025 21:49:28 +0800
MIME-Version: 1.0
Subject: Re: [Patch v2] mm/huge_memory: add pmd folio to ds_queue in
 do_huge_zero_wp_pmd()
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>
Cc: linux-mm@kvack.org, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 wangkefeng.wang@huawei.com, stable@vger.kernel.org, ziy@nvidia.com,
 ryan.roberts@arm.com, dev.jain@arm.com, npache@redhat.com,
 baohua@kernel.org, akpm@linux-foundation.org, david@redhat.com
References: <20251002013825.20448-1-richard.weiyang@gmail.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20251002013825.20448-1-richard.weiyang@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: hpt84s7dzfshstoqiu487hqjhstpfsqo
X-Rspam-User: 
X-Rspamd-Queue-Id: A7112180009
X-Rspamd-Server: rspam10
X-HE-Tag: 1759499384-749314
X-HE-Meta: U2FsdGVkX1/OGN/MDDla+sQ4G9F99YSid8wvtfOwMDGP1Z66PDVMVdZcAqUoHuvk9Z/05WBOh4/S2YEjKpi5I36jBf9ROZ8r6i+Cz3m7q+w4WdHvIlfUhhpDQPbvW0zsxXnDNVEdc1ys5ij5UjMwRTzdkI2KJhxPRh1oVeVRbPuvGbTPpWveP8AwP+1MBMsASFx6NRuGz0Hyy7NkNd6q1YtyM2rKAB8hQkLmiMI1dkzc/f93uxSOwKu0q/TcDCjNHUMZBUMcfb9SnYuJu/XNfCJN3g3+PNFA4+aN/HEOXtWbTG1rd6fyH5RAb3b1zkfYnGwA3lcHRSojp8xzzDhCeDPBxNjJvlCgE823wY3oZMc4I2rjgvjnY+zsvD4Yw+FYFeJqbeSnQFGVr+/sAOQjHqLAI9ngyLF/Qf/fdtC43USDmiqzPM37l6RldCRD3VjcuWlTnby4ZYpnGWa0vDaSKy7sTDOj+4XbGjGfOdf6NBKTuCHfIGNv3yw+Hy1ySXso4J1xBXDCxkxwJaLZDC3Dr8LLYfy/iOig/Ll1KetSayQgbS09LL//Oavn0QZI2IimnoqF7ly2eUxwg/gVXtlkefvX7mIC9Qx+LzXbOq0+6viXi3Kzl+1+Dp60nP40FWnTdlDl+xdOJLoDq4SyZ4aKyXddENrIZLhT4tk14BRGeKgBeZMy/xLeemmMcHqClpABPsgAKbrEl9jtWFzMk1IrDD0CGJlF0co54DGclddvuDpuXHngnbwHWYpBibf3H7OJ1un1BParAe78eHjD3zTlY/7O4GhQvJYz+b/y9K5KJDZdwyE7+KHNMN+1A+TdbDdmySKlwuxAcz+tTJbvj3K64bpfL2DEWUV+a/T/hdI+WdQiEdnZTJD2MNhhi05sG5nAfA80TG0B6ER440i4c1RJEUqNSn/YlxxEQKF103xqCDspzxjyX6Too4iF4ehbsjHY/MijzZHemlJBtN6AR9M
 S8A9mM3k
 kQRa7iNOjJH/WyI+zr9MdXDWr21qMBn1bk1mt4kuoJVLGdzoRFUzfE9oikxforhD1284OFmTdmgHZoTVsVg3ZLFbqq6ez594nZuuMrq9+J+WQ61HOZJ5Etra2xWRjuUZPfxjKFtyEZtQLcy/qqxnckOUwRprxsK8ajSRfZLgvJtqVDXNLA6lSnlZ/WSOrhwTxm8qQe6PJfrkC3KdYdK8gCqzjZZep51Qw46FBG0TQ2XJES8h4vNuTjVk1pC2Ye83isxdS5lKYNuZUR17EmlVfWd64rz4qIGuhtARjMkAHF6fei7GIhfj0VDszm5pWZMhH9x/udoF69YtZkP1PqOPa0pJ1dfFOK0sJMnzBZkRvVTFgdBg3dZn2aNCv3GuHEmGSgVVDbYNUwu0sYCsgYvsJ3fHdFS03rAkMGrx/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hey Wei,

On 2025/10/2 09:38, Wei Yang wrote:
> We add pmd folio into ds_queue on the first page fault in
> __do_huge_pmd_anonymous_page(), so that we can split it in case of
> memory pressure. This should be the same for a pmd folio during wp
> page fault.
> 
> Commit 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault") miss
> to add it to ds_queue, which means system may not reclaim enough memory

IIRC, it was commit dafff3f4c850 ("mm: split underused THPs") that
started unconditionally adding all new anon THPs to _deferred_list :)

> in case of memory pressure even the pmd folio is under used.
> 
> Move deferred_split_folio() into map_anon_folio_pmd() to make the pmd
> folio installation consistent.
> 
> Fixes: 1ced09e0331f ("mm: allocate THP on hugezeropage wp-fault")

Shouldn't this rather be the following?

Fixes: dafff3f4c850 ("mm: split underused THPs")

Thanks,
Lance

> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: Lance Yang <lance.yang@linux.dev>
> Cc: Dev Jain <dev.jain@arm.com>
> Cc: <stable@vger.kernel.org>
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


