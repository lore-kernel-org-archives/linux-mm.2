Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7948AD339BC
	for <linux-mm@archiver.kernel.org>; Sat,  6 Dec 2025 17:03:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A56516B0006; Sat,  6 Dec 2025 12:03:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2DFE6B0007; Sat,  6 Dec 2025 12:03:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 943DD6B0008; Sat,  6 Dec 2025 12:03:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 832566B0006
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 12:03:31 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 422EF8AAB2
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 17:03:31 +0000 (UTC)
X-FDA: 84189667422.11.DE432F0
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf14.hostedemail.com (Postfix) with ESMTP id 31560100018
	for <linux-mm@kvack.org>; Sat,  6 Dec 2025 17:03:28 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TSjtdJt+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765040609; a=rsa-sha256;
	cv=none;
	b=zeiYdOGXDauDstWdINNr5tq1bOka0l8nFR0ZrUaqFx7aBJRpCVB5FWNXHYV0Copqe9B2Mx
	vPA90rJJqTQktQEBqsuwycc4McWeOtEGUKMFMDV6depqLT5PpIMPAlu7nCYQ4oGSDQXNaa
	/et+yyZRD5comG3IAygVRw9i874+GGw=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TSjtdJt+;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf14.hostedemail.com: domain of usamaarif642@gmail.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=usamaarif642@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765040609;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=arB2+q94C/RtjHwnCPSWjKQlAp5irwrD1W/n4e+MZLI=;
	b=sAkznLPn0wfoou7nq+r0qJlTXA/qPaMciL/w14V7GfIQJb6g5vWcCEj20TQW0DANuPi1Rn
	JaR9RICDGuUBUey7R9BNbAliqiKJK+px1sRwuUpqPbi3UuMD91e5Fhs86EMYjs6ISgrfvI
	zI66VH26R0Bn1QUkoLdeUn8DExi1d84=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-477563e28a3so22732705e9.1
        for <linux-mm@kvack.org>; Sat, 06 Dec 2025 09:03:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1765040607; x=1765645407; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=arB2+q94C/RtjHwnCPSWjKQlAp5irwrD1W/n4e+MZLI=;
        b=TSjtdJt+JmU3mk/OEKANYSTjfBUVwLl7FXBUGk9BF1DgO1/8sCXaVvkXIRldBLKzRt
         nqNnC/E2IVGM5EIlgXqYlXbriVeLhVIXAoe4BoOs0mx96aY8NbT4Pysec4jBI5FGOGoq
         +XlWIKk0rj2+P8XzCGh9vSOiMNABOWqRzM78nVphz+xXV9iQCK5wMyHV5+lDL5OZV8PE
         gaqPSbruGZpNR9UO4GOS07RdQ9RL63CVJuCS/IzTewyoZ2cZPFy/+uHfGgC6iq8RQQAD
         rOW92YINuQgHzx0cAynrip6S3SkpmneBQU75hfFkEGYauS+VCiepXCwuYIfWhP8XLVeR
         5iWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765040607; x=1765645407;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=arB2+q94C/RtjHwnCPSWjKQlAp5irwrD1W/n4e+MZLI=;
        b=YzqRlp3wPRD/jn1r4RWMImg+tjNRvZ0RH4EEUUtKGzzdP+h2ENvJCiV5s59sB3ViX1
         x0g2thHLlk9Aasxi1LAcuPTQeKcOKlTLWLooooBjekv04elVViNxjUWxvJYVW2p+j+oQ
         7vmw7bbNI/Zy4q1Agj1T4oMvJ4dzeAYQwHz83VIwsyuwpLfdLdU8U6JlW0iFCzfcfI59
         bzpDSfu4pyPoRShLKmnedt+GLl8IVcQQHTU99cfNyaZZWo3z2aw0Y3LtHYIucmMGg1bw
         i5KApfSORt8cCrTwGVtd1svYsswJcpxRWWUbvOoHQW8yi9DicluZyksdKZrbl2ny/9O7
         WKng==
X-Forwarded-Encrypted: i=1; AJvYcCW/B73Q2F2AoZpVQRWJu4OT36yINjLAdSHR7Khv8FbWi2zP0+jxcMahYCLL9ILY+cxxD5SkBredPg==@kvack.org
X-Gm-Message-State: AOJu0YxJZlT4LjIltiq/+Wpxb3GWQLiCD7NLKd/mkmjgOXXvU4zw3veU
	vDe8DqdspHMG4lap4HEFpPGF4BAoq2uWteOYxzCu5iqZnoOt9FOt3OY6
X-Gm-Gg: ASbGncsu3n0d975QW1c98cxBh2ptSGzJZRR5sf6bUssAdQ+ByqqNSDdnsWs9OHmYt9k
	fbPrnJLofvnoj4qQLk4OftJuZa+YWEFdTZz+GpNvNhPlWG1AXooXjBNkn9ZznVBP2tHgdpMXTvl
	GuLmUwhoWB9QIvMdx2o4XVTmLF8N/7qmh4ROCbUp6JM6x1BQMgVmouZXM24MEArKHK06ilw/X0Y
	LwgptqWjcxD4s9G+mzUlmP1W9jqzzBOl5aCTKsPEn4h4tZmpWGsZ/WjzrHD94L5iED9e2jfpgBn
	6XJKNen9XQxIDzmKIyKDKmfr/GNQRlfzCizCcHFG46Vs9ueqgkD99KI2cGDYGIMD1Vk/gXFx0sd
	jOfey+e2vvCYiKSyzlkDOzjN00hrnVfTRvP+FkL2oRquCyd/jB3elxCCpJeHWBEjsBYekynn4T3
	yVjiLNIOPBBb/n0g6jDWtyGHPzNqfwvSq7jJrmNCy/vU85SlOHCm4SCwqVJpDFPwN3vuEPvvwze
	7ZNkmyFbVQd
X-Google-Smtp-Source: AGHT+IFxBQAvElMtsjBtc/pCHGLPoVK2DXxycN7rAshm0uLF2efeabEBubsprobpgBgCpVi5MMqong==
X-Received: by 2002:a05:600c:46c6:b0:477:7588:c8cc with SMTP id 5b1f17b1804b1-4792eb19ee1mr114517705e9.7.1765040607347;
        Sat, 06 Dec 2025 09:03:27 -0800 (PST)
Received: from ?IPV6:2a02:6b6f:e750:1800:450:cba3:aec3:a1fd? ([2a02:6b6f:e750:1800:450:cba3:aec3:a1fd])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4792b17588asm84544545e9.17.2025.12.06.09.03.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 06 Dec 2025 09:03:26 -0800 (PST)
Message-ID: <db4538c3-84f8-4fb4-8307-b4fcf46ebe38@gmail.com>
Date: Sat, 6 Dec 2025 17:03:25 +0000
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 06/11] mm/hugetlb: Remove fake head pages
Content-Language: en-GB
To: Kiryl Shutsemau <kas@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Muchun Song <muchun.song@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, Oscar Salvador <osalvador@suse.de>,
 Mike Rapoport <rppt@kernel.org>, Vlastimil Babka <vbabka@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 Matthew Wilcox <willy@infradead.org>, Zi Yan <ziy@nvidia.com>,
 Baoquan He <bhe@redhat.com>, Michal Hocko <mhocko@suse.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org
References: <20251205194351.1646318-1-kas@kernel.org>
 <20251205194351.1646318-7-kas@kernel.org>
From: Usama Arif <usamaarif642@gmail.com>
In-Reply-To: <20251205194351.1646318-7-kas@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 31560100018
X-Stat-Signature: p6j3carpgktjnorsswja5qtxtm8r83tk
X-Rspam-User: 
X-HE-Tag: 1765040608-398067
X-HE-Meta: U2FsdGVkX18XSloZv/hTL/PDc3qyQXwUU3Rz5KryG1dp/OVjmUy4L6JEkuFS85fQJZCngnGyHxwqClgWiJnjUpCtNgW1lS/1+7DTDgvL3dRjjQoBvmqHzJhL6WeyHxw2aKdUm01Ui37qvoCx+SBbfXW9VWJ2BQkvHD9VXmHUYmrfA+KYsFXk8aLirQxxM8J762bv728rZcj9CtYQaJX3moRAPtoAf+2vP8arkiz+R+iZr2aI862RdRZU3qqEPM4+s0qKYUq0T1nqUVoPt5NYljzpBQz/4RlE+cK8QXuvZUl5xlP9x51HI3ONaLZF+KVEfOIMfTI1rP3WohYNiiLSivhLLrsAICobqCFEkzqugsmzPEtIREXUxcwEG1xTluv3q46YUZ1vQQMGOUKLdIekzsjLIC8SBotg3SvkVYWSkEvZs4GLaPIAPy5JFdgssq5NsJxKLGyywIfiHDzDRzCSI1fFDdOj+nGCM4mf7c5QGIzuIuXA8zIls1Hh+h7UOfmnktA9i88twIX31SR0cH4etx5Vk0FLaTt7Ro6jCbNMO5vWz44Vkeg4/zRm8JZ1hiXf6W4NgIenrQQWcHV6hxDyXu14DPyadM8C+/I1S4pvD6PVIFkh7nhDeSwzJR5pbcKHFyvTJnOGKzsQc8Z68ojw2VjWOdSa8mvwc17Y/oFbmM8u4WXv5VjbwVsZId4qiS9dnHwZ+8Y2sKejYCcVi4sGR9ROC4FmA410ogfnns/LVfj8SxKrFO0SvJFs7KiLr2yrBa2kkVjsEuXQ1ahWANjYIhrf7YcOfwPpoz9lQnsYm4bvXiwfEUMUurc2yQw1POU2x47OLbYvH37Zc2xA5gBp3uh81+Jm53UKIEk4DeGI+4UVIxECbl09gUNbNf5aszNXYz1xGvsBj/IfxN0DOYsacV+aNx3huQMWHIhx7TJI/Zpm1qChkNZ4R4UVz232BpKK32flfarW8tY5G3suLJn
 znztAlps
 s7ET5IcsCvUG8prBnZ5SIc8reU7uhmIWZS6z37rUQjJIHIbGeIKGr7xdA2AI1dv93L2VXt+8fLnF/DbtXRNbKrvEzXRveCVM4Oo2SoprBAjhEIzml1uV2hFloHTmkAhBD4XPkcBUKkOSfsuZIsFh8JfhkUDBsOaUsYSGB/EBVkzZNkDlOnb8jge0orGe9GFZjOLZuBjx6Fc7w6aEVb1hhPXxGhRP0xTIarGcIfNNhpMaZd236zNHYJ++PXtG6bDErFxuvC4YqHoIfSBm6Wo+BqPhlXkoGQZZRh4DS50mFlPqeuibIRC13sd1VAKcWE+cDg1i3ke8GSqZpu//2AansWmCF1aVuo/BbSol//dO2inHsx8fVET8dHItE4zQbvvbP6/kT5VI07m27Wh1R8biYktcl0JK28eIvA+ByObQSoCGnAWN5OFnipog95Mh4Xo980H4gyMKeVctmxNKYGgq+hnJ++OpVKiCq0BZIw3CdKfnTX/7WteVD3HdWxQBl/I4rLcuvmvMWIIKvEw0XkyrEFxA0dSPJtJweobr86yqZogA6AnHdF8a+p/prGcAb2ndRlHuN
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 05/12/2025 19:43, Kiryl Shutsemau wrote:
> HugeTLB optimizes vmemmap memory usage by freeing all but the first page
> of vmemmap memory for the huge page and remapping the rest of the pages
> to the first one.
> 
> This only occurs if the size of the struct page is a power of 2. In
> these instances, the compound head position encoding in the tail pages
> ensures that all tail pages of the same order are identical, regardless
> of the page to which they belong.
> 
> This allows for the elimination of fake head pages without significant
> memory overhead: a page full of tail struct pages is allocated per
> hstate and mapped instead of the page with the head page for all pages
> of the given hstate.
> 
> Signed-off-by: Kiryl Shutsemau <kas@kernel.org>
> ---
>  include/linux/hugetlb.h |  3 +++
>  mm/hugetlb_vmemmap.c    | 31 +++++++++++++++++++++++++++----
>  mm/hugetlb_vmemmap.h    |  4 ++--
>  3 files changed, 32 insertions(+), 6 deletions(-)
> 
> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
> index 8e63e46b8e1f..75dd940fda22 100644
> --- a/include/linux/hugetlb.h
> +++ b/include/linux/hugetlb.h
> @@ -676,6 +676,9 @@ struct hstate {
>  	unsigned int free_huge_pages_node[MAX_NUMNODES];
>  	unsigned int surplus_huge_pages_node[MAX_NUMNODES];
>  	char name[HSTATE_NAME_LEN];
> +#ifdef CONFIG_HUGETLB_PAGE_OPTIMIZE_VMEMMAP
> +	struct page *vmemmap_tail;
> +#endif
>  };
>  
>  struct cma;
> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
> index f5ee499b8563..2543bdbcae20 100644
> --- a/mm/hugetlb_vmemmap.c
> +++ b/mm/hugetlb_vmemmap.c
> @@ -18,6 +18,7 @@
>  #include <asm/pgalloc.h>
>  #include <asm/tlbflush.h>
>  #include "hugetlb_vmemmap.h"
> +#include "internal.h"
>  
>  /**
>   * struct vmemmap_remap_walk - walk vmemmap page table
> @@ -518,7 +519,24 @@ static bool vmemmap_should_optimize_folio(const struct hstate *h, struct folio *
>  	return true;
>  }
>  
> -static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
> +static void hugetlb_vmemmap_tail_alloc(struct hstate *h)
> +{
> +	struct page *p;
> +
> +	if (h->vmemmap_tail)
> +		return;
> +

The above check is unnecessary as we already check for !h->vmemmap_tail in __hugetlb_vmemmap_optimize_folio?

Is it possible that we could have a race here? Where 2 threads both trying to allocate a hugetlb page when none
exist in the system, both see h->vmemmap_tail == NULL, both call alloc_page and set h->vmemmap_tail?

Also, is there a good point where we can see that the number of hstate->nr_huge_pages has gone down to 0 and free
h->vmemmap_tail? Its a single page per hstate so not a big deal, but would be nice to have cleanup for it?

> +	h->vmemmap_tail = alloc_page(GFP_KERNEL | __GFP_ZERO);
> +	if (!h->vmemmap_tail)
> +		return;
> +
> +	p = page_to_virt(h->vmemmap_tail);
> +
> +	for (int i = 0; i < PAGE_SIZE / sizeof(struct page); i++)
> +		prep_compound_tail(p + i, p, huge_page_order(h));
> +}
> +
> +static int __hugetlb_vmemmap_optimize_folio(struct hstate *h,
>  					    struct folio *folio,
>  					    struct list_head *vmemmap_pages,
>  					    unsigned long flags)
> @@ -533,6 +551,11 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>  	if (!vmemmap_should_optimize_folio(h, folio))
>  		return ret;
>  
> +	if (!h->vmemmap_tail)
> +		hugetlb_vmemmap_tail_alloc(h);
> +	if (!h->vmemmap_tail)
> +		return -ENOMEM;
> +
>  	static_branch_inc(&hugetlb_optimize_vmemmap_key);
>  
>  	if (flags & VMEMMAP_SYNCHRONIZE_RCU)
> @@ -562,7 +585,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>  	list_add(&vmemmap_head->lru, vmemmap_pages);
>  	memmap_pages_add(1);
>  
> -	vmemmap_tail	= vmemmap_head;
> +	vmemmap_tail	= h->vmemmap_tail;
>  	vmemmap_start	= (unsigned long)folio;
>  	vmemmap_end	= vmemmap_start + hugetlb_vmemmap_size(h);
>  
> @@ -594,7 +617,7 @@ static int __hugetlb_vmemmap_optimize_folio(const struct hstate *h,
>   * can use folio_test_hugetlb_vmemmap_optimized(@folio) to detect if @folio's
>   * vmemmap pages have been optimized.
>   */
> -void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
> +void hugetlb_vmemmap_optimize_folio(struct hstate *h, struct folio *folio)
>  {
>  	LIST_HEAD(vmemmap_pages);
>  
> @@ -868,7 +891,7 @@ static const struct ctl_table hugetlb_vmemmap_sysctls[] = {
>  
>  static int __init hugetlb_vmemmap_init(void)
>  {
> -	const struct hstate *h;
> +	struct hstate *h;
>  
>  	/* HUGETLB_VMEMMAP_RESERVE_SIZE should cover all used struct pages */
>  	BUILD_BUG_ON(__NR_USED_SUBPAGE > HUGETLB_VMEMMAP_RESERVE_PAGES);
> diff --git a/mm/hugetlb_vmemmap.h b/mm/hugetlb_vmemmap.h
> index 18b490825215..f44e40c44a21 100644
> --- a/mm/hugetlb_vmemmap.h
> +++ b/mm/hugetlb_vmemmap.h
> @@ -24,7 +24,7 @@ int hugetlb_vmemmap_restore_folio(const struct hstate *h, struct folio *folio);
>  long hugetlb_vmemmap_restore_folios(const struct hstate *h,
>  					struct list_head *folio_list,
>  					struct list_head *non_hvo_folios);
> -void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio);
> +void hugetlb_vmemmap_optimize_folio(struct hstate *h, struct folio *folio);
>  void hugetlb_vmemmap_optimize_folios(struct hstate *h, struct list_head *folio_list);
>  void hugetlb_vmemmap_optimize_bootmem_folios(struct hstate *h, struct list_head *folio_list);
>  #ifdef CONFIG_SPARSEMEM_VMEMMAP_PREINIT
> @@ -64,7 +64,7 @@ static inline long hugetlb_vmemmap_restore_folios(const struct hstate *h,
>  	return 0;
>  }
>  
> -static inline void hugetlb_vmemmap_optimize_folio(const struct hstate *h, struct folio *folio)
> +static inline void hugetlb_vmemmap_optimize_folio(struct hstate *h, struct folio *folio)
>  {
>  }
>  


