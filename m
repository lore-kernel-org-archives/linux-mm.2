Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C9DCACD4851
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 08:36:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F25CE6B0005; Tue, 19 May 2026 04:36:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED6AC6B0088; Tue, 19 May 2026 04:36:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DEC136B008C; Tue, 19 May 2026 04:36:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D03406B0005
	for <linux-mm@kvack.org>; Tue, 19 May 2026 04:36:36 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 164A01C0100
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:36:36 +0000 (UTC)
X-FDA: 84783513192.26.7236E4F
Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	by imf29.hostedemail.com (Postfix) with ESMTP id 91CC812000B
	for <linux-mm@kvack.org>; Tue, 19 May 2026 08:36:31 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	spf=pass (imf29.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779179794;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Cn1AGDqiw8xUzQHx8msdlLS/366NZydqqbRZSm8H2ts=;
	b=6GcK6csPK3AnnlQTGiPaNPBtXTaVAPO5altgQOIRWzwEoLmV/3GdJ7Ex0Uj7eHapQBI20R
	+NdUDAYwaT4retk0PvuJYEApcMtOAkMn73lOAKTE04V6RhNpcp5oxMXb/N46LFbN2TdVv8
	w68LNcA6sLslbQegBtqm6u+8gix41zU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779179794; a=rsa-sha256;
	cv=none;
	b=VgYzYdrafgaGT2jtCzawQNNOicuAa6j8Ejr9ILYS02JiyTr+FLFK3j2jZLwCAGk4u1dHUG
	a48EMsuEyMCOglV+59+NylQ7BK7PCstCaAfa2MFvu3hjE6wnoF2uxpxOGoY8yfBBo1Q4uU
	oaqdye8XeFRYML2ScascxXeqOgzPzyo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of yi.zhang@huaweicloud.com designates 45.249.212.56 as permitted sender) smtp.mailfrom=yi.zhang@huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.170])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4gKSgr5lhqzKHMYv
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:36:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 61C774056D
	for <linux-mm@kvack.org>; Tue, 19 May 2026 16:36:26 +0800 (CST)
Received: from [10.174.178.253] (unknown [10.174.178.253])
	by APP4 (Coremail) with SMTP id gCh0CgD3v1sFIQxqMANpCw--.44303S3;
	Tue, 19 May 2026 16:36:24 +0800 (CST)
Message-ID: <a3c8038a-43e9-4427-92dd-8fed619001e8@huaweicloud.com>
Date: Tue, 19 May 2026 16:36:21 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm: do not install PMD mappings when handling a COW
 fault
To: linux-mm@kvack.org
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 david@redhat.com, yi.zhang@huawei.com, karol.wachowski@linux.intel.com,
 wangkefeng.wang@huawei.com, yangerkun@huawei.com, liuyongqiang13@huawei.com
References: <20251024102237.3332200-1-yi.zhang@huaweicloud.com>
Content-Language: en-US
From: Zhang Yi <yi.zhang@huaweicloud.com>
In-Reply-To: <20251024102237.3332200-1-yi.zhang@huaweicloud.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgD3v1sFIQxqMANpCw--.44303S3
X-Coremail-Antispam: 1UD129KBjvJXoWxCr1rWw17WFyrCF1rKw47twb_yoW5CF1Upa
	yxGa4YkFWfWrnFyF1fuw4vkry5Z397G3yUCFyxGryUuF13Gr13u39Yga17A34kGr48AF4r
	Xr4Ygryq9F4qg37anT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUylb4IE77IF4wAFF20E14v26r4j6ryUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_tr0E3s1l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr1j6F4UJwA2z4x0Y4vEx4A2jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x
	0267AKxVW0oVCq3wAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
	6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
	Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JMxkF7I0En4kS14v26r1q6r43MxAIw28IcxkI7VAK
	I48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7
	xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVWUtVW8ZwCIc40Y0x0EwIxGrwCI42IY6xII
	jxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw2
	0EY4v20xvaj40_Jr0_JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x02
	67AKxVWUJVW8JbIYCTnIWIevJa73UjIFyTuYvjxUF1v3UUUUU
X-CM-SenderInfo: d1lo6xhdqjqx5xdzvxpfor3voofrz/
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 91CC812000B
X-Stat-Signature: 395wh4sf3z6iakmgise9eugucqnzzs8h
X-Rspam-User: 
X-HE-Tag: 1779179791-131309
X-HE-Meta: U2FsdGVkX19zNYeX5R+2fdmOyDvFf3XlTQ2Mx8KXrfU57AcEt/ndhNxN4Lj6HnImfVxygVGf92FmUjLdA6pVpx4XfpeCLzXbqswx7SVH5r/i/zf38lwBVB/oKMrvl62583jGl6iBkUzU+t5iTbkjxxizazYQQIWuIP0KCXKpp+yrVccDCo2winItSeTMKFMCvmAO7bIeiGvvfW1ey2vZ4bZd4MfV229njgsqgoQu/FIUaE9WcU5yZ18rdsi1dg+uen3sXqAR+5anOp1z/U70ITTvv6DcDsTri4kPrxkUUBXhmDnx/YtvdPMFbjjt7uskqJPDFBlHrBz6SjbGNFgdnSj6eXdwZJ0yZryoppSCNnrPekN07o9XjU0fge57s35Zv5xKFkRO48ksnwxbAbNHB97eMA8slWrY7ZUwJElK9ziWhvh3bWFcYjGi4IJ6Z9lScWmb5qX9YRVi6rb61pJiDAtBCbWWou417JEt/UTMHDsrP7jrZZAiYSMsEQty1Bu/GZL46AN3Nj8en+Lr+/SV+xb16GaewYRHrXPpw7MARvwWun50cLtnWmOeL49XL+aSFVXdnRLvEMX3/pqFRFZ9Mca+Ohxt8A4LekmD7PE2XVSnSKmeaBUgFI054pB3c/VPIV7Py7ADpxHtCifxswR5bHiYyzt9rEAG5aNHEdX0lsPSErdD0q903A2EJgpmTh3TJkm1TKy5aoXIZ1Yz5LDPiMCqthvvX4bzP4a84LZB+SvCvA/HR8kYMG9lJBFkyc/J+fHxp0bLboxmsdHPgoZsqBgz8BuoQeHIg5bIHUVhikbIqug+1olOSciTV5W9vEkTHxYNGilEknGxJZkHN0HdgTJaCxQhXLWARsU+cECyROhCwxK6mnpuIx3HUWWQm7DKwO1NBcyurUA0lzpH/XnKCqiqDBcq3Nbsedh08eiY2e/SLRzorQd9CTkfC30LuMrtqiK/kDO0qSUWKv4RvV0
 F30D2Imr
 9Zra7M1jpCqwC1YPebH30ZQ6BrhHEKrZhgrut6nMG45M4T4m8/HaSegWXcQd8RWlcljF1qB5UtKUAKZPhAQzhznb8+qSVAsS+XWiBejO0CJD5GKuTO1Hd1pkp/ZwmAl6icMmkSAw2Ual+5ZTnM1/iE9lARYuOWSkN4X48W4+coB7sV+b5/Aqw55tFZQgXKG8KXY6eYzNg5ZbSMW7yUMZD8flOrqxJ3meQS5b04TBuuvoYDNo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gentle ping – could anyone take this patch?

Thanks,
Yi.

On 10/24/2025 6:22 PM, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> When pinning a page with FOLL_LONGTERM in a CoW VMA and a PMD-aligned
> (2MB on x86) large folio follow_page_mask() failed to obtain a valid
> anonymous page, resulting in an infinite loop issue. The specific
> triggering process is as follows:
> 
> 1. User call mmap with a 2MB size in MAP_PRIVATE mode for a file that
>    has a 2MB large folio installed in the page cache.
> 
>    addr = mmap(NULL, 2*1024*1024, PROT_READ, MAP_PRIVATE, file_fd, 0);
> 
> 2. The kernel driver pass this mapped address to pin_user_pages_fast()
>    in FOLL_LONGTERM mode.
> 
>    pin_user_pages_fast(addr, 512, FOLL_LONGTERM, pages);
> 
>   ->  pin_user_pages_fast()
>   |   gup_fast_fallback()
>   |    __gup_longterm_locked()
>   |     __get_user_pages_locked()
>   |      __get_user_pages()
>   |       follow_page_mask()
>   |        follow_p4d_mask()
>   |         follow_pud_mask()
>   |          follow_pmd_mask() //pmd_leaf(pmdval) is true because the
>   |                            //huge PMD is installed. This is normal
>   |                            //in the first round, but it shouldn't
>   |                            //happen in the second round.
>   |           follow_huge_pmd() //require an anonymous page
>   |            return -EMLINK;
>   |   faultin_page()
>   |    handle_mm_fault()
>   |     wp_huge_pmd() //remove PMD and fall back to PTE
>   |     handle_pte_fault()
>   |      do_pte_missing()
>   |       do_fault()
>   |        do_read_fault() //FAULT_FLAG_WRITE is not set
>   |         finish_fault()
>   |          do_set_pmd() //install a huge PMD again, this is wrong!!!
>   |      do_wp_page() //create private anonymous pages
>   <-    goto retry;
> 
> Due to an incorrectly large PMD set in do_read_fault(),
> follow_pmd_mask() always returns -EMLINK, causing an infinite loop.
> 
> David pointed out that we can preallocate a page table and remap the PMD
> to be mapped by a PTE table in wp_huge_pmd() in the future. But now we
> can avoid this issue by not installing PMD mappings when handling a COW
> and unshare fault in do_set_pmd().
> 
> Fixes: a7f226604170 ("mm/gup: trigger FAULT_FLAG_UNSHARE when R/O-pinning a possibly shared anonymous page")
> Reported-by: Karol Wachowski <karol.wachowski@linux.intel.com>
> Closes: https://lore.kernel.org/linux-ext4/844e5cd4-462e-4b88-b3b5-816465a3b7e3@linux.intel.com/
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Zhang Yi <yi.zhang@huawei.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> ---
>  mm/memory.c | 5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 0ba4f6b71847..0748a31367df 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5212,6 +5212,11 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>  	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
>  		return ret;
>  
> +	/* We're about to trigger CoW, so never map it through a PMD. */
> +	if (is_cow_mapping(vma->vm_flags) &&
> +	    (vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)))
> +		return ret;
> +
>  	if (folio_order(folio) != HPAGE_PMD_ORDER)
>  		return ret;
>  	page = &folio->page;


