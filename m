Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 79336CA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 09:25:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C0FD58E0008; Fri, 12 Sep 2025 05:25:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE74B8E0006; Fri, 12 Sep 2025 05:25:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24628E0008; Fri, 12 Sep 2025 05:25:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A11228E0006
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 05:25:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 57EB51A073A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:25:00 +0000 (UTC)
X-FDA: 83880063960.09.7128BCD
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf10.hostedemail.com (Postfix) with ESMTP id AD9C4C000A
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 09:24:57 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LQgf9naz;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757669098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yeQuxM0fjpmIe4g0xUTHddlrE41HXqCqb25Ih/uw2qU=;
	b=YOyBNQK5y+h/ojebiZKIuRQbWSpHCm5RipIJJuFjCdjttxUi+t+ld0bIaprJyCxCyYGEzx
	bWPiAZSkEDePLBuePxhobvy7DJvikJWW3bCZQcgKJkSOfoF04ucWxQC3+298/aZIHzTJRx
	wz11LbK1EIDzUV04UaU7i3vyijDf6OY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=LQgf9naz;
	spf=pass (imf10.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757669098; a=rsa-sha256;
	cv=none;
	b=tIB/ue92MLXkleYrdd+nxtfUFiVT0HuOjKR1gnneP3JMcrDmFcJyH0tB98qD58vBd78MVB
	Zxj66uyURz1Z2YG5zqlwjYiOKFAKa2WTbmWxQlBiwwhfmERKcyJFvZRFaYJ1HZ9W3bQbSi
	Ov1epi45Ca4s5EjsFCjyFQiUmmjqZZY=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1757669094; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=yeQuxM0fjpmIe4g0xUTHddlrE41HXqCqb25Ih/uw2qU=;
	b=LQgf9nazpTkfsOzxRUfJrhqOt4jk9EMMOVAA6Dypi8Epz5gCvBUtQ0b6O8fRiMQlZl2XIsalleKR+R2NkR6i7pOoW811DQcW1o7/2taMYN3370iioinhA37d7GC7zhZiU8KeBIfjumliAZL2Dc5sZALy6bcWcqswFNEZSOuUmTk=
Received: from 30.74.144.122(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WnqpgPM_1757669090 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 12 Sep 2025 17:24:52 +0800
Message-ID: <50305e9f-ad03-4ce9-9ae7-0c657bd87ef0@linux.alibaba.com>
Date: Fri, 12 Sep 2025 17:24:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 11/15] khugepaged: introduce collapse_allowable_orders
 helper function
To: Nico Pache <npache@redhat.com>, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Cc: david@redhat.com, ziy@nvidia.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
 corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
 mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
 baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
 wangkefeng.wang@huawei.com, usamaarif642@gmail.com, sunnanyong@huawei.com,
 vishal.moola@gmail.com, thomas.hellstrom@linux.intel.com,
 yang@os.amperecomputing.com, kas@kernel.org, aarcange@redhat.com,
 raquini@redhat.com, anshuman.khandual@arm.com, catalin.marinas@arm.com,
 tiwai@suse.de, will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
 cl@gentwo.org, jglisse@google.com, surenb@google.com, zokeefe@google.com,
 hannes@cmpxchg.org, rientjes@google.com, mhocko@suse.com,
 rdunlap@infradead.org, hughd@google.com, richard.weiyang@gmail.com,
 lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org, jannh@google.com,
 pfalcato@suse.de
References: <20250912032810.197475-1-npache@redhat.com>
 <20250912032810.197475-12-npache@redhat.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20250912032810.197475-12-npache@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: hwepjp8ux8w7fpcghinuq5t575hmfyo3
X-Rspam-User: 
X-Rspamd-Queue-Id: AD9C4C000A
X-Rspamd-Server: rspam04
X-HE-Tag: 1757669097-363689
X-HE-Meta: U2FsdGVkX18QfQ3stqQN1JYuDbLuYYg9CJUXtixATLLPYc8yypdG4RacH9lkR32kFg2cP5lk/LkRdw0bBtXDCw7EdultCxwe/J2HqOF6n7owaQ1jKyi2HTguhYCy2czmVMDRJZptVEKB446SVNj4PV3Xlnxmniq8xRqxNcq7EhVsbPTsMTN1Cq6LuK1Gvzw7F+ixFaCF4g5fOjPLzwpQubbcmrQZIRHq9LVwjJhNcXPQX90G+CEpphLCO3KWRlf2YFkVngrLEdKT1E6WwcYkLFp6pkLL3BaeI1U8eJFHzAjFdMa5oe/er+yYAyVHc3Pypb4A55fhCd+defJR6E0W/LVPjhmAgPrYzYHdnPfhOY5aGbisiS08xSaUuiUbuXgWSdCn8DmoIIiZ2sjjFHuFfL5BXjDCCNFLVz7MVcKC4U9qtablosU32o5dTlbEUnIOPhtdY1r7oACw8jWC8kdC7ydM7tb1xFHGmvB7lcK9t376wlAuOlSCM0quz/ZAHTC+50WyKmcdFx3aG5H/Im36rgo0FlOmdI/e46iIpLvZ98RQhrtIongdQJepWRNoVWJFwDmxS+jPTls76DXWjW7b88dsYzUyKboNmgtuKUe4qoOA2v9c5paA99SXRDwvii5i8MNqNn2V1D7Qg+AcND+pyZxpGWNp7O5UZi3gJpbRxq995aLfQjOs9QeNTKZQmHb7y1SgCyKVMQP4g7CM8HCcUY95f5STKHQfaAuFTWSLvA4CAqIrQ/PonIOMrYT/VszF9oKB1ZxT/16mDANtmieRr7mshtwF2GHuISND7gKqbDJZeWnmAyBGB/5+AHTMRnrk3oKR39IO9wzv5/b3sP2GmIwkmwDTzwJAW9pWdAioh0ySNure0AjrOdTWHfymEO3+3Hv7H1MYrca0su+Wo4CkEe4Vy/coOeVaIvYMzSdqrXByWRnS39UUuLcTFRXk3Fqncdil/GRaUushOVj4xv7
 9MSMgtuA
 WWC6UNyoLCKuKyND8aFprbw7576x/wGzEzu6iDZNHFHi1N/mjBdEt0Ldnalr3cRHtziWtj0a+F6eHYuIz6Fj0P8OG4QWggPYU8p18PGq+oJ1/cNyNRZvEY4N93bKxN3eyT3lyyHKRfINn45n5kqfquaA4o7J7yU9jqaQDXaGNTecv3PrJ4VjdbZZ0Sp2E+YcKrOsGgWTt76L0Ohs1gZI0wXRHrlALKL0Oefhh7XK6aPSol6fxZktkECHvcPGN736N7qxfUo0PFGlQut0mXJqy8w4/nBa4dELtftovoC8UtCCuRh+mUJ7KJUllMP9p2RZ2qU7ZwknUstCYX49gBl6ST6ZXrT8xKAJB9e6Q+ieOjBHeON57tZxZ8crDakf933i0mz0jqQwGUl1RyWHyIDdr9NwAg9ILXi6sfIX8mQfN7m03so/il2vjqUJ1mz8WovOMfNWbjb6uBz1/ciAnXfQVElZMbUVSJM81yFm3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/12 11:28, Nico Pache wrote:
> Add collapse_allowable_orders() to generalize THP order eligibility. The
> function determines which THP orders are permitted based on collapse
> context (khugepaged vs madv_collapse).
> 
> This consolidates collapse configuration logic and provides a clean
> interface for future mTHP collapse support where the orders may be
> different.
> 
> Signed-off-by: Nico Pache <npache@redhat.com>

LGTM.
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

> ---
>   mm/khugepaged.c | 15 ++++++++++++---
>   1 file changed, 12 insertions(+), 3 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 5b45ef575446..d224fa97281a 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -485,7 +485,16 @@ static int collapse_max_ptes_none(unsigned int order)
>   	else
>   		max_ptes_none = khugepaged_max_ptes_none;
>   	return max_ptes_none >> (HPAGE_PMD_ORDER - order);
> +}
> +
> +/* Check what orders are allowed based on the vma and collapse type */
> +static unsigned long collapse_allowable_orders(struct vm_area_struct *vma,
> +			vm_flags_t vm_flags, bool is_khugepaged)
> +{
> +	enum tva_type tva_flags = is_khugepaged ? TVA_KHUGEPAGED : TVA_FORCED_COLLAPSE;
> +	unsigned long orders = BIT(HPAGE_PMD_ORDER);
>   
> +	return thp_vma_allowable_orders(vma, vm_flags, tva_flags, orders);
>   }
>   
>   void khugepaged_enter_vma(struct vm_area_struct *vma,
> @@ -493,7 +502,7 @@ void khugepaged_enter_vma(struct vm_area_struct *vma,
>   {
>   	if (!mm_flags_test(MMF_VM_HUGEPAGE, vma->vm_mm) &&
>   	    hugepage_pmd_enabled()) {
> -		if (thp_vma_allowable_order(vma, vm_flags, TVA_KHUGEPAGED, PMD_ORDER))
> +		if (collapse_allowable_orders(vma, vm_flags, true))
>   			__khugepaged_enter(vma->vm_mm);
>   	}
>   }
> @@ -2557,7 +2566,7 @@ static unsigned int collapse_scan_mm_slot(unsigned int pages, int *result,
>   			progress++;
>   			break;
>   		}
> -		if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_KHUGEPAGED, PMD_ORDER)) {
> +		if (!collapse_allowable_orders(vma, vma->vm_flags, true)) {
>   skip:
>   			progress++;
>   			continue;
> @@ -2865,7 +2874,7 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>   	BUG_ON(vma->vm_start > start);
>   	BUG_ON(vma->vm_end < end);
>   
> -	if (!thp_vma_allowable_order(vma, vma->vm_flags, TVA_FORCED_COLLAPSE, PMD_ORDER))
> +	if (!collapse_allowable_orders(vma, vma->vm_flags, false))
>   		return -EINVAL;
>   
>   	cc = kmalloc(sizeof(*cc), GFP_KERNEL);


