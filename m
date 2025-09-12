Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9FDE4CAC582
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 06:58:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4B6E8E000D; Fri, 12 Sep 2025 02:58:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E22C78E000A; Fri, 12 Sep 2025 02:58:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D60018E000D; Fri, 12 Sep 2025 02:58:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C149A8E000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 02:58:32 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 65026C070F
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:58:32 +0000 (UTC)
X-FDA: 83879694864.23.86F258C
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1E67C40007
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:58:29 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757660310;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=2E6yMIhNSy6cSyfxW49TGCbvOUJeebZDL5mutmJ4gxY=;
	b=HlueMz1GkH2d3/FMIxmn4ZH4T7e5p47VXi4qUcnmQouMmzPmIpLXaUkr2ttvZXJlbIZQaC
	c4myWlkC2zKpAjBvOsooc+ygne6wEgAYwDr+X7yiBas8Ui6p+CHf4QOj/0HwvZuvMrGqa4
	0qzrwRJ4pLEoqqjOKN1L2YMPNoZ/3kY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=none;
	spf=pass (imf27.hostedemail.com: domain of wangkefeng.wang@huawei.com designates 45.249.212.188 as permitted sender) smtp.mailfrom=wangkefeng.wang@huawei.com;
	dmarc=pass (policy=quarantine) header.from=huawei.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757660310; a=rsa-sha256;
	cv=none;
	b=Br5L2M+XLoeIIzyb/mEimJ30oIvAX+9/WjrgNrSU9nE8TLFacSVV/u5cTqVeGXq9GnUO2U
	u/jJ5f0t8l5PBxgFGhVs5Vkq3NhNih0UYAzA96FGmRwoscr0cW2eKhm5aFMJC0+zLHPEHY
	3xWLT01r9bPzi6oTFHo/DEQE5RdS+1I=
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4cNQBM47CVzQlNX;
	Fri, 12 Sep 2025 14:53:47 +0800 (CST)
Received: from dggpemf100008.china.huawei.com (unknown [7.185.36.138])
	by mail.maildlp.com (Postfix) with ESMTPS id A7FD1180064;
	Fri, 12 Sep 2025 14:58:24 +0800 (CST)
Received: from [10.174.177.243] (10.174.177.243) by
 dggpemf100008.china.huawei.com (7.185.36.138) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Fri, 12 Sep 2025 14:58:23 +0800
Message-ID: <e02c04f9-2ab2-43fb-a9e6-f63d0acbdba3@huawei.com>
Date: Fri, 12 Sep 2025 14:58:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/4] mm: debug_vm_pgtable: add
 debug_vm_pgtable_free_huge_page()
To: <20250910133958.301467-1-wangkefeng.wang@huawei.com>, Andrew Morton
	<akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, Oscar
 Salvador <osalvador@suse.de>, Muchun Song <muchun.song@linux.dev>, Zi Yan
	<ziy@nvidia.com>, Matthew Wilcox <willy@infradead.org>
CC: <sidhartha.kumar@oracle.com>, <jane.chu@oracle.com>, Vlastimil Babka
	<vbabka@suse.cz>, Brendan Jackman <jackmanb@google.com>, Johannes Weiner
	<hannes@cmpxchg.org>, <linux-mm@kvack.org>
References: <20250911065659.617954-1-wangkefeng.wang@huawei.com>
 <20250911065659.617954-2-wangkefeng.wang@huawei.com>
Content-Language: en-US
From: Kefeng Wang <wangkefeng.wang@huawei.com>
In-Reply-To: <20250911065659.617954-2-wangkefeng.wang@huawei.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.174.177.243]
X-ClientProxiedBy: kwepems200001.china.huawei.com (7.221.188.67) To
 dggpemf100008.china.huawei.com (7.185.36.138)
X-Rspamd-Queue-Id: 1E67C40007
X-Stat-Signature: rcuu8gaghmmo1kdaep4prbdes15ie1e5
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757660309-746947
X-HE-Meta: U2FsdGVkX19SybuCNvnBjQivydPQZukqw88PPJE/7h6vxgCg4d1NWq++E601OcDNcWlvDyZACesp7dDEGfyRoOW5S3zt50bVeMxkwysG2JOkD+oSKcbRelfFNWRN7sxWI11RT581SSe6GguxEQ7GEZ0DnfuLvs1GWnEwDaVOANzU2XU86UrptCXxHQUSynjDuopJaQA396NceHjKa3Aaw75tHA6DdVAFYQJDIR22KXIzeLxlXSdScU6K6GHQjh4KmHos0vo6OFJefummWjRZ7bzIMANsGl2DMlX6roKsUx/iBZzB7cj0asHzZlHyFCWKGXEYxAlqSwpfjkPPt3xFXMmvB90WeW5/+SQ48jH4Uqn2OnYkz72mPRZ3KHqRNI8rZnwNkWeDIDncBkdPGeW/dQ7KTHRUkjvYPQsW206bCzQXBnVxYHJxMfp83bjvnAjt7KKKjXf4SoD8D9C3KKyVkDyLVlGekfMOPFWPpM/0wUysfUrfzemfZNSswfhW+VBDwul1IRrX1qXkION4v5a3IlSJIlZ3PKoW1F1h7xs0c2I6LSFJ0dj4IDQnSnXY/DpfxGtxH1RQH8jFF4kOdrBGNcfRTEGcxWB4PZ5TmUKzpnaQ3DBxO4KRWlmsR++M90otlzxIErjvilq+3i/19kiUin/5EDifD8WbZIU1qhC2yRji7HA8zI5ejDC01/8CJRN2qOtbmpHrS6D8D1Yjk+IpHpdzL69GPoEj6KNYR+9WE0rG9sXWUxuSoy1ZArUla+cuiq/r04QZTiwqs3TvOMed8Uijxv5Fbfd6GNX457BBGtuddz3Tjr2Tscj2IugYusbdVgw01e/hz21EYmEUOpI2qVC/TT3ha/XSvGx4Kdrjlq/eNjVkMJDNHFdNOy+H6prMahUoOVydADhLKDd+pvv8PJz5oZO3GxyOtIm/acEeMtockxNgBkUjaGXuTPs4TnJbP9hN1Z7n6hp1enKQb6C
 L1JUZwCn
 JbSps
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/11 14:56, Kefeng Wang wrote:
> Add a new helper to free huge page to be consistency to
> debug_vm_pgtable_alloc_huge_page(), also move the
> free_contig_range() under CONFIG_ALLOC_CONTIG since all
> caller are built with CONFIG_ALLOC_CONTIG.
> 
> Signed-off-by: Kefeng Wang <wangkefeng.wang@huawei.com>
> ---
>   include/linux/gfp.h   |  2 +-
>   mm/debug_vm_pgtable.c | 35 ++++++++++++++++-------------------
>   mm/page_alloc.c       |  2 +-
>   3 files changed, 18 insertions(+), 21 deletions(-)
> 
> diff --git a/include/linux/gfp.h b/include/linux/gfp.h
> index 5ebf26fcdcfa..651acd42256f 100644
> --- a/include/linux/gfp.h
> +++ b/include/linux/gfp.h
> @@ -437,8 +437,8 @@ extern struct page *alloc_contig_pages_noprof(unsigned long nr_pages, gfp_t gfp_
>   					      int nid, nodemask_t *nodemask);
>   #define alloc_contig_pages(...)			alloc_hooks(alloc_contig_pages_noprof(__VA_ARGS__))
>   
> -#endif
>   void free_contig_range(unsigned long pfn, unsigned long nr_pages);
> +#endif
>   
>   #ifdef CONFIG_CONTIG_ALLOC
>   static inline struct folio *folio_alloc_gigantic_noprof(int order, gfp_t gfp,
> diff --git a/mm/debug_vm_pgtable.c b/mm/debug_vm_pgtable.c
> index 830107b6dd08..767321a8b26c 100644
> --- a/mm/debug_vm_pgtable.c
> +++ b/mm/debug_vm_pgtable.c
> @@ -946,22 +946,26 @@ static unsigned long __init get_random_vaddr(void)
>   	return random_vaddr;
>   }
>   
> -static void __init destroy_args(struct pgtable_debug_args *args)
> +static void __init
> +debug_vm_pgtable_free_huge_page(struct pgtable_debug_args *args,
> +		unsigned long pfn, int order)
>   {
> -	struct page *page = NULL;
> +#ifdef CONFIG_CONTIG_ALLOC
> +	if (args->is_contiguous_page) {
> +		free_contig_range(pfn, 1 << order);
> +		return;
> +	}
> +#endif
> +	__free_pages(pfn_to_page(pfn), order);
> +}
>   
> +static void __init destroy_args(struct pgtable_debug_args *args)
> +{
>   	/* Free (huge) page */
>   	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
>   	    has_transparent_pud_hugepage() &&
>   	    args->pud_pfn != ULONG_MAX) {
> -		if (args->is_contiguous_page) {
> -			free_contig_range(args->pud_pfn,
> -					  (1 << (HPAGE_PUD_SHIFT - PAGE_SHIFT)));
> -		} else {
> -			page = pfn_to_page(args->pud_pfn);
> -			__free_pages(page, HPAGE_PUD_SHIFT - PAGE_SHIFT);
> -		}
> -
> +		debug_vm_pgtable_free_huge_page(args, args->pud_pfn, HPAGE_PMD_ORDER);

Should be HPAGE_PUD_ORDER, will fix it.

