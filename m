Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD792C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 10:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0D996B00F1; Mon,  6 Jul 2026 06:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE946B00F3; Mon,  6 Jul 2026 06:07:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884DA6B00F5; Mon,  6 Jul 2026 06:07:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4F59D6B00F1
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:07:34 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id CA1DA1A0364
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:07:33 +0000 (UTC)
X-FDA: 84957924786.19.E9C174A
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf21.hostedemail.com (Postfix) with ESMTP id E8C181C0009
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 10:07:31 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZylOI33n;
	spf=pass (imf21.hostedemail.com: domain of mclapinski@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783332451;
	b=rYKSugefVWBcFFVV700rMRQhdRYuuuFlCptsGHDXj5iNY+91xAJ50ekFlO94ctM2O7NRWs
	RC6FumNo0xY1pR1crB2leZeZkW8acdvj3AvgDDcLt8j0HmtdGj4T7MC4AbdVD5f882zh4I
	zuPD2/OKfjDCJb2xmC2WkK4zqaMu+5E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ZylOI33n;
	spf=pass (imf21.hostedemail.com: domain of mclapinski@google.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mclapinski@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783332451;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XV8hLM1BVaZzJ2YbfALYkq3xi+MgnRUgQHg6QJiWrc4=;
	b=DV9VnIbhmsNZRvPbEviDUnQdfIM5uZqttuseR7ijt1PtC7SY9lJVlwCyZWJvDlTCkJ2EoJ
	rFfIE7uaiIZacfsfcvRuYac9Oqv/vECV/a3u0GWoPNlAHG+/+u0ThJwI53QGTF+B/TUg8A
	mZjfkycpLeLt3x/0fy7hPi08WGuha4M=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-698411099d6so53533a12.0
        for <linux-mm@kvack.org>; Mon, 06 Jul 2026 03:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783332450; x=1783937250; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XV8hLM1BVaZzJ2YbfALYkq3xi+MgnRUgQHg6QJiWrc4=;
        b=ZylOI33n9p1oxJKhjFqqecn7P8VK7xc7lKI8d0ramvYzm2MF9CspC7JbeEnkChti58
         1o7aDSfMd9gIFl1IhMY/WHEps8+QPKeXut22M5WFVVk/hYrdfhP88NH+UuPi0r0mfyZI
         Q/uxOHxFdOUsjK2cJEGXM7yhfSTeFEdMj6IK5hiIC+K82v+Utue+WOG1OPrH4pKjICh7
         UIQ+8zBpXN/jJpoJJB+cb674T1cGcTGESuNTxOhHZlRYWq2qjgPeP+IA+6d3rguleSRh
         V8gW0IsmxlsLBrbuKsSif91lxezhkzUThIyae6ef31a0Y0iD44ZP+Epa8BowlMbQyqqG
         IGaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783332450; x=1783937250;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XV8hLM1BVaZzJ2YbfALYkq3xi+MgnRUgQHg6QJiWrc4=;
        b=hXvZ8sD3pAiral69PsW0IdeG9HpR+GIcWIzhD2w+KROWMt3NMmZCMuy5m5AzE/q6T1
         jPydGvxSdJH+pj7qq9i1gtAmwlKRA5RW5pPxAWdtI/wwQaFABGmKEulYM47FNwk9Q8k3
         ugkRhactDhPJV5qljzVltnF4+x3GmkNJvB9CUStbfoktT38hANixsvPNmpLWQz0KxbvS
         mpLP6VPS4gam25sbjP07aw/IfHBzABHyvu8RaX8OuAzfrW6mUuxy2smoQuP7htMfi7vu
         4Zqd1h5lsIWSezC9UjKL+gNn/TtYmtNDrQcYY4QZIesM3Di7b4gUzHkxN9R5eR04pXIo
         xsMw==
X-Forwarded-Encrypted: i=1; AHgh+Rqxb2DrRuzkf23LAIvBKWonTEAC740nIz2bxFSP+1njFBfe1PaiOmIR17N9/o/QXyBLSyzyzZuh9A==@kvack.org
X-Gm-Message-State: AOJu0Yyibc7kvHhsJgb0owpZCne9dQB+YL5yckzmpC/yo4v94zEKAenD
	OyT3/Zfk6f2c8VS0t58E3zcQbEn0xiSmaLsqAZRiMPKj0F3XMrrl817iBeVKSeS4vQ==
X-Gm-Gg: AfdE7cmfb2d9DAVGk687fuJYVmJpviP9a0Hc4bvMYmpE0sYE7sioNKV5c5xfgx9uWny
	1N2Ym5UhKjTY1H0Xb9cCQdZvoK42Bghzpd3ovbIBXpxkjiPiO5k9IdvFllvReRMxsPzT0nDAPRb
	Cl8MABBTc1ofoXM8cna75ggALEDXtr/4dvgIY8WZcpVF/o+aZOhSZe5ATm2r/Uxh680QzxUnkg+
	waJPgtdi7FWdoPJj/3BIMYyhEXUOqtTTwyE3Zh414Mp/i5JVJlXtkQha7aq4ncalcCzmuqFwnUu
	muVTG0CSPu8d2iK+cMY9+Z2vE+GwxXB30AyYd4VfPLeXd8h+zWsE+b80IvrsZD17tYcrIMRiCYQ
	HNvyEJdH+e811NIcocWArR6kyafkESgaBe+a5SH0aiEp2wwLIlKEVyjUA7hEuNRaakK5ZgPdwfq
	gu/2EBU74y2MRitM3FW8BZ+bCI1HIZ05Gw99Hme/eoYEMjQh7pZPrw3DeOvsXL4cj/yboMXC0Dy
	4ecJp7T1MNF35Dz84dZ
X-Received: by 2002:aa7:d9d2:0:b0:698:59af:fb08 with SMTP id 4fb4d7f45d1cf-69a19ca26d1mr52807a12.4.1783332449904;
        Mon, 06 Jul 2026 03:07:29 -0700 (PDT)
Received: from ?IPV6:2a00:79e0:2890:d:9f2c:a127:989c:b6af? ([2a00:79e0:2890:d:9f2c:a127:989c:b6af])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c12b62c552esm710227466b.49.2026.07.06.03.07.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jul 2026 03:07:29 -0700 (PDT)
Message-ID: <b4b200da-f510-4fe2-95ac-c63e4467c4bd@google.com>
Date: Mon, 6 Jul 2026 12:07:27 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 01/19] mm/hugetlb: Fix boot panic with CONFIG_DEBUG_VM
 and HVO bootmem pages
To: Muchun Song <songmuchun@bytedance.com>, Oscar Salvador
 <osalvador@suse.de>, David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>
Cc: Muchun Song <muchun.song@linux.dev>, Mike Rapoport <rppt@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Nicholas Piggin <npiggin@gmail.com>,
 Christophe Leroy <chleroy@kernel.org>, Ritesh Harjani
 <ritesh.list@gmail.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>,
 linuxppc-dev@lists.ozlabs.org, Mike Kravetz <mike.kravetz@oracle.com>
References: <20260612035903.2468601-1-songmuchun@bytedance.com>
 <20260612035903.2468601-2-songmuchun@bytedance.com>
Content-Language: en-US
From: =?UTF-8?B?TWljaGHFgiBDxYJhcGnFhHNraQ==?= <mclapinski@google.com>
In-Reply-To: <20260612035903.2468601-2-songmuchun@bytedance.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E8C181C0009
X-Stat-Signature: agha5xcayodxn7xr6bnbd9psdyg5hacq
X-HE-Tag: 1783332451-277253
X-HE-Meta: U2FsdGVkX199NZss7SmRuel5q9fg2gg2HnHn4wTFqil5d9+zBOX91ADbO7svbhT5VcZJ8u0JedpeQs7HV5WUANNOLCBnKG/GozRbscOqpuVABwAoz+oRy87vbbLDkgP3f2hK6B9awhVHRKrnDmQC718xUsMLusGUF+KX826spFf5Xe9F3CxxnLqrfUU1gHqsR0M+dhEoTXIqO6R+s+dV+zPGcwbhnD0MT87NWPOB8ouOkDL0fcP4mtNP4RejsEReaH8NOKfl3q4uQFxhH8BX8+lXqTiX/IteEgC3ZBxvfHbDhrQheMjbZPSA3QMFbj6G+uAtFbbqvZSlweId0j0UOQnvBes7dN4PAeUKhRZcaTn2EI7uBNbzKXW2iorI9YamYpmgB+L2a09BlLkvcen0VNwfCtZgaBzR6ygnRrWon/teXRRXaxChlNbgfvwiKqF/8tdnIQxzueAJNod3rPSA1uJtkXbkJqeffq34s1gxqFZY1vNneZtQqFgEbHmJIY39hR+DWOJhDg3k+j6MBHjrSKGA9c+peu7Q3BhRj4hJ1K/NVp6E7AjyQ07WNpNgyA4SuQAMX+tuA/xQVPEXwVMH8o6SwphouZ9QNdPA7hIL9PZg/d8Tg57IVA9T1oaXjIxZmThVAgXMbltzJY3cQRyLzy7qdSc+xe9tAB/OjPODuqSzcPZwWv63jEOQte8+GVjrwWVD8hcJV0s0COpZ0VKEZ6pJaUA3Z2bDGKBNU0ByNzGDcbECgvxQpoaxHS3xd35WNZk7DNx0VEJR7rBvpuIzRN7j/Ld24zbESvoBQI7PV2hQSCXeslM9xRmSSbWCsNGt9bHT3v5MWAKerXwabY7xLMdS0MPJxWm35LDrzbczZiMbt2P/y2Two01PJNcFvkF8JgBbokuplyJuLHEc/An8mkQUA+scyBnsUkQqOak4ZS25ljIjqYIAMTLgniP9rt6NL/ORG2K3unKdvSr2366
 yqwWa8L8
 713J+tQK1+vOn3QArjkwdVsED1OCvM5PpGfNdUEtrvd1TVchmWaH00gJa5NJ+g4SR92Uzgk2ccua4oiVJ5A3vjaFZFvZ21HE91kVF9IwSqMfpfddx49sMfzn1cqksWJP7GD9YT76F3uT0bcSOKk8UkzUXngL8LQGQ9uRh3P2qRrxev+S54Yyp+B8bd09B+bi8AaW1j1zhDIWluUFh7ZvaB57gkKOC4NbIyjYtRpnO8pZ7KdFVEvLd9WSILmaAV80RPSRhkwvTUUfAjeUowIzXeb2w3xoEed6EfmgfF/EDGJHLV+KgWPvRKjXV/jsSUYub9yTXEMInnsDJt5E8o8i6Eb6plPwLxLZXoUJtc3U7gbNBIbLApFJsenEqfKFg9CMkOPMygpUJG2gbuACB5DqYl0khdM1Femn1k8RY3KkKvFL/Lf5dLXTf5uoPGY56QY00EcoX1sMVnYJb4Ca47c2vJ/XcC9R5/jFy2iaBXQe6gwfWOnF7ExmjKQiM7vZVTWguoHLlZY4HeraO1doibhhflY8lShvnwWDZ62NtH5B4PkYdkK5+tk6JV63b12mx3a5rIJJRY6iBODVysUU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/12/26 5:58 AM, Muchun Song wrote:
> Commit 622026e87c40 ("mm/hugetlb: remove fake head pages") switched
> HVO to reuse per-zone shared tail pages from zone->vmemmap_tails[].
> 
> Those shared tail pages were initialized in hugetlb_vmemmap_init(), but
> bootmem HugeTLB folios are prepared earlier from gather_bootmem_prealloc().
> With hugetlb_free_vmemmap=on, prep_and_add_bootmem_folios() can access
> pageblock flags on bootmem HugeTLB pages whose mirrored tail struct pages
> already point to the shared tail page. On CONFIG_DEBUG_VM kernels,
> get_pfnblock_bitmap_bitidx() then dereferences the still-uninitialized
> shared tail page and can panic during boot.
> 
> Initialize zone->vmemmap_tails[] from gather_bootmem_prealloc(), before
> bootmem HugeTLB folios are processed, and drop the later initialization
> from hugetlb_vmemmap_init().
> 
> This bug only affects CONFIG_DEBUG_VM kernels, where the relevant
> assertion is evaluated.
> 
> Fixes: 622026e87c40 ("mm/hugetlb: remove fake head pages")
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Acked-by: Oscar Salvador <osalvador@suse.de>
> ---
>   mm/hugetlb.c         | 25 +++++++++++++++++++++++++
>   mm/hugetlb_vmemmap.c | 17 -----------------
>   mm/sparse-vmemmap.c  |  2 +-
>   3 files changed, 26 insertions(+), 18 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> index 571212b80835..cd55524c7e30 100644
> --- a/mm/hugetlb.c
> +++ b/mm/hugetlb.c
> @@ -3365,6 +3365,31 @@ static void __init gather_bootmem_prealloc(void)
>   		.max_threads	= num_node_state(N_MEMORY),
>   		.numa_aware	= true,
>   	};
> +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> +	struct zone *zone;
> +
> +	for_each_zone(zone) {
> +		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
> +			struct page *tail, *p;
> +			unsigned int order;
> +
> +			tail = zone->vmemmap_tails[i];
> +			if (!tail)
> +				continue;
> +
> +			order = i + VMEMMAP_TAIL_MIN_ORDER;
> +			p = page_to_virt(tail);
> +			/*
> +			 * prep_and_add_bootmem_folios() can access pageblock
> +			 * flags on bootmem HugeTLB pages, so initialize the
> +			 * shared tail struct pages here before bootmem folios
> +			 * start using them.
> +			 */
> +			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
> +				init_compound_tail(p + j, NULL, order, zone);
> +		}
> +	}
> +#endif

I think it would be better if this was located in mm/hugetlb_vmemmap.c 
as a separate function.

>   
>   	padata_do_multithreaded(&job);
>   }
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index 133b46dfb09f..c713c0d2593a 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -870,27 +870,10 @@ static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
>   static int __init hugetlb_vmemmap_init(void)
>   {
>   	const struct hstate *h;
> -	struct zone *zone;
>   
>   	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
>   	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
>   
> -	for_each_zone(zone) {
> -		for (int i = 0; i < NR_VMEMMAP_TAILS; i++) {
> -			struct page *tail, *p;
> -			unsigned int order;
> -
> -			tail = zone->vmemmap_tails[i];
> -			if (!tail)
> -				continue;
> -
> -			order = i + VMEMMAP_TAIL_MIN_ORDER;
> -			p = page_to_virt(tail);
> -			for (int j = 0; j < PAGE_SIZE / sizeof(struct page); j++)
> -				init_compound_tail(p + j, NULL, order, zone);
> -		}
> -	}
> -
>   	for_each_hstate(h) {
>   		if (hugetlb_vmemmap_optimizable(h)) {
>   			register_sysctl_init("vm", hugetlb_vmemmap_sysctls);
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index 99e2be39671b..bb23fb3077a3 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -342,7 +342,7 @@ static __meminit struct page *vmemmap_get_tail(unsigned int order, struct zone *
>   	 *
>   	 * Any initialization done here will be overwritten by memmap_init().
>   	 *
> -	 * hugetlb_vmemmap_init() will take care of initialization after
> +	 * gather_bootmem_prealloc() will take care of initialization after
>   	 * memmap_init().
>   	 */
>   

It gets the job done.

Tested-by: Michal Clapinski <mclapinski@google.com>
Reviewed-by: Michal Clapinski <mclapinski@google.com>


