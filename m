Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 013C7CCD1AB
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 07:47:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 590288E004B; Fri, 24 Oct 2025 03:47:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 540708E0042; Fri, 24 Oct 2025 03:47:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E1518E004B; Fri, 24 Oct 2025 03:47:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2944F8E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 03:47:37 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id CBB56140D89
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:47:36 +0000 (UTC)
X-FDA: 84032228112.24.C65D4DB
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf16.hostedemail.com (Postfix) with ESMTP id 59984180002
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:47:34 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RC4DlXk2;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761292054; a=rsa-sha256;
	cv=none;
	b=VgHd0giSrt5wCq9BLDlILt9C80lM2P80SD+4+Di8nB5j5VmqLeiq9k+B1K/yLpVhi8RqGy
	AZMUEVdSRHjg8q+5jy5tY8PhJNNgrmdznf63ZZNuPQfaMOl7yzLlzn6VWJ1WvlsjAhbjEP
	6ytp5YMXQ2XDTxQIT1an7efMwxsaeNU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=RC4DlXk2;
	spf=pass (imf16.hostedemail.com: domain of david@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=david@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761292054;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5ecy7KW/4Q3PaNtjQEWD2FoEZh8uYi4fefNLgyAB9zU=;
	b=tVSKM3ZBh2SQQV/m9MAN1PoLlb+aqVgV75Yfv/vE1PigGmjYeTWOb/0Jk2TL0uGck6MlE8
	sXAAkCw3rs133SvEk2IY8BohW0qkDqLDiQikCaSoJGh7qYc+3d0bPdCvltIz7gEdB0JItb
	ETvHs7SovcNZ0MucqcAEZKiovgnoLYM=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1761292053;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
	bh=5ecy7KW/4Q3PaNtjQEWD2FoEZh8uYi4fefNLgyAB9zU=;
	b=RC4DlXk2k7Lbf14KKlQLA/ugjtDrz4ZDcy0FwCiHVMXHDwX2GUwBn0BtmlZFyIRFb0ZCmv
	NXqycpyxKkhVDxBkqTzjfQJgGiZ+Mk6W3ePDP0e/+UuGfCLORgXiQUoKLFU+WMxONlEQpy
	Vn9g048wctHv9HzCxF3/MD8PVfepIxc=
Received: from mail-wm1-f72.google.com (mail-wm1-f72.google.com
 [209.85.128.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-636-FUvzjfv4O6yeSvc9lioAtA-1; Fri, 24 Oct 2025 03:47:31 -0400
X-MC-Unique: FUvzjfv4O6yeSvc9lioAtA-1
X-Mimecast-MFC-AGG-ID: FUvzjfv4O6yeSvc9lioAtA_1761292051
Received: by mail-wm1-f72.google.com with SMTP id 5b1f17b1804b1-471148ad64aso9933595e9.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 00:47:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761292050; x=1761896850;
        h=content-transfer-encoding:in-reply-to:autocrypt:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5ecy7KW/4Q3PaNtjQEWD2FoEZh8uYi4fefNLgyAB9zU=;
        b=EiQG0w+ejiVZtAFSePa44PdqjWuldjzAM/LeNnKuqPyEDJ2BE7jXYK8NhCvOCfAXMT
         pIQRRgXZ0eE/y869nfyibOJzQZKCMef1ykKx+aoPEo4TLuDLJJqRtF7DRYEaRpuJXTfn
         mSgIT7zbKphecYnBEEnJkLKSKkVJltoDJt3v1uDF6EyEzUb4dhKNf+M5esqMXYE8Nwkm
         WgR+Ly3fAkCl/bw2bl4oAVtlnf2Hi3osU9pl/duMTIsp+DAy/qw4Udq4s+dstO8rEVYg
         DtedgJ2IfewwHA1LVNmRwitkfTN800k7ESXQ8MhpExyeMxTNPubvDDFs+THUJUhBwgwP
         dEJA==
X-Forwarded-Encrypted: i=1; AJvYcCXQfMblDOerA12iHJknkGeGsgIKI4GrH5FrRrge4TBEnOgFYHmw+gyMVly+eeVlHi1rpRSkYFUsLA==@kvack.org
X-Gm-Message-State: AOJu0YwytTJ7Gs5+5Gsv4DYeep017WVTRl7ZIi0BCNIJcDr0WF4sW36E
	rBPjLBiHOPLIsktni1PfsrdLXfOBuvjbsMfOh42FyuIYmMYYyT/5QHJzRu3fgUq7jfEweNnEVT9
	NU9t15MR6HCm5Dk5DPkprcz5wVtdbZQJ8BDhSl76fbTPzvPmXcRrG
X-Gm-Gg: ASbGncsHQoDC4uMTVFJzQNmbR26XyaVvnjNtCz/f0bPh0gHOLfIDRXglWeLRG/thzHJ
	vGSaEJ6GHny+a76wMYN0NcTkGPUbaB1kUNZ1gIpEL9j7WCFVALMQKIz+QuJ0Mn9tLRluKiB/pbA
	nEB7/vF5U2RDtnFdiJxT0X8QtHLpdPyWK+K9gS+nwOz/kK9T0IG3x+v8MlepFaWlOwGX5i+7PeD
	r9w2ajwfP6b0ck1yCt2kUG018PRcGb7HoZG6TqApRQK68B1P7dbEw7Hy+6m8JyYWJFrq0USWGBr
	S0c8H1p0mWzBJJUh65WHxuE+KaweuuZNUxi+YEAf8I3j68Jsuyxt0UIE+8xZ+McoEIa7UaMsfze
	WlHAcY0nN6VhocvDxoBsQVSFA2tUrz/dZKxEu5vPOmIg2niojZA3YJr1aHjdplW3fIb46LurJ1f
	AO6XvD3HqfGXEY7g/1rDSVzOhi/yk=
X-Received: by 2002:a05:600c:3b22:b0:471:989:9d85 with SMTP id 5b1f17b1804b1-471179122eemr199555085e9.19.1761292050463;
        Fri, 24 Oct 2025 00:47:30 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IFCk5knVvG9aEJVjQIGNEPj71HBH+RTp0yRPtlz2moXZyXlFUc8p92AbKQUvfwnx5Ns0MFGdw==
X-Received: by 2002:a05:600c:3b22:b0:471:989:9d85 with SMTP id 5b1f17b1804b1-471179122eemr199554895e9.19.1761292050063;
        Fri, 24 Oct 2025 00:47:30 -0700 (PDT)
Received: from ?IPV6:2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3? (p200300d82f4e3200c99da38b3f3ad4b3.dip0.t-ipconnect.de. [2003:d8:2f4e:3200:c99d:a38b:3f3a:d4b3])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-475cae9253bsm74552055e9.1.2025.10.24.00.47.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Oct 2025 00:47:29 -0700 (PDT)
Message-ID: <9bfd8972-4111-4afb-b8a2-f514ae67f67f@redhat.com>
Date: Fri, 24 Oct 2025 09:47:28 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: do not install PMD mappings when handling a COW fault
To: Zhang Yi <yi.zhang@huaweicloud.com>, linux-mm@kvack.org
Cc: linux-ext4@vger.kernel.org, linux-kernel@vger.kernel.org,
 yi.zhang@huawei.com, karol.wachowski@linux.intel.com,
 wangkefeng.wang@huawei.com, yangerkun@huawei.com
References: <20251024015459.2824162-1-yi.zhang@huaweicloud.com>
From: David Hildenbrand <david@redhat.com>
Autocrypt: addr=david@redhat.com; keydata=
 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
 qIws/H2t
In-Reply-To: <20251024015459.2824162-1-yi.zhang@huaweicloud.com>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: Sx4PyofYwWQPLUQjo_Qb1yGPC1zQCAlzdLXBOgyx1Qo_1761292051
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: kcde6f9iyakcutpganmznebmuy8nizjw
X-Rspamd-Queue-Id: 59984180002
X-Rspamd-Server: rspam09
X-HE-Tag: 1761292054-60052
X-HE-Meta: U2FsdGVkX18y/eFc0EkoV1cr4BuHJued0vboQmB2baMLZA6M3rbG+2AelbF/aHNavwpeLgdDs8S9y/eiCfDN5pd+1C50C3b8Auh1ePhKbYelC64n66Z0EXuvINpU2Km7LnhwlDv+HdyxlcfjfHpB0aDDweU83YA6a3BT3Uwa6IvCzi5q9sxSuptuwpO2L0EumngNIte9IQs2CwCfy9IwFwyWJu6FrMz8qUwqp8TbjBcZ5Ue+4OdtHizPL8kIdEkHCgW8H6Sz8CrpWhU3346lSzR1HpKVkzpZe82Szgc8FxyDb7Iae0dZ+Ds1DKHtxyXWd2hThbw5CF5k61CutBk1SeT0jGvngg2RDI6MDkj/Pte/ElNzY1yFaZ+CfLuiJGQIAivS90cb1cJGXW3JYvbwUPskNPHB1wxvk07icAiH2lRdz95ImnWDCxiQ9tTmHj9K0jmLsolQYCLM1TIifGmtdVuh/bF7Xmyycm8+nQlb+TIbjbzB2qXYo3qDUeCVS4mJYHYaMjhEumMv4KnvUMQyrcJ+0iJ7MCCYVHm7pYBxaqu8Urc7N9k6S999hgSVyir6VwXe2K3ZaFU8EUs/H+q3cb5BGZJ6khTZ3+lA4JxKAVf5Mxu5RHptIzmzz1G6zMYY+8o6CtXdiScktiaiG09vDnLuP/HmiF/0tCRDH+o4KjbLoycyPU/jxIMr9mkwUkRTodUpPa3j+3nuWj8GhBYQJHrQ3yltFscWZpY1PY7mwS/eqtGMRl8A5KniBN4RO/7r1lPo+9wyX2MKlPyz1JxAE0GQg1S0qhtqzArr/10u2ZcdBu+bFLA/PXkyLwgnwOnavmEMSY7b+eIzNKpYEHSRLJEuZ5Xz86T9AlwIuSPQf9mIvlta3+lgfLKr/0YFTykVUvnaNONclj4zgc6PvA/aDIqb4igHFoDdY/DUzG/Nfb2N17ztJRlxyzMcTedqlyD11szkQwMZa/njbhV18tW
 tmLoIbXO
 ujAZj9ISrCpSkNJFW9vJw+gF9w6lpuc1lL1fbBCQ8UFMdZnF+c9ym5McHe4hBiv4L3tu6x1pRptkcIOAi0eNsjvXfzkZZKmc4Ovsyco/PBXTMDwXjtX/4lzskjDQk2ttCEHV54Ik3VWzTUUw7WMNKwrMxA2l0rg+uM0Urf0LfyG0Eh7ptG8m3qvR8RugXIoSMo+aRj5fhmBBULpT6TxaJ1s2L7qF+iLxbmEqmru7dyXlsIVNqWOrAJkLXX16BRamZJLDmn5dj8NvF2uHaesHkqUY2+5N+kowfDy+6TGuwojfRsppNS9iaa9L3c8mnHqsd5DESrGoYqR0MhXlduAdtLPO5Xluv90t+ELnfH11Ey+oMTHlu/Jr9+1iJN/ufe/rYe5btjRZ6niA156/QODBNlXMNAYNW7BjzlmwOEJDKuZhE2W6yvl8Hs5fC7xn/SrOHhkxGOG6MzH0mFnCJWYR+ktYJCNJCYavpI7THzt5fW0CRLxE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 24.10.25 03:54, Zhang Yi wrote:
> From: Zhang Yi <yi.zhang@huawei.com>
> 
> During the ping of user pages in FOLL_LONGTERM on a COW VMA and a

s/ping/pin/ or better "When pinning a page with FOLL_LONGTERM in a CoW 
VMA ..."

> PMD-aligned (2MB on x86) large folio, follow_page_mask() failed to
> obtain a valid anonymous page, resulting in an infinite loop issue.
> The specific triggering process is as follows:
> 
> 1. User call mmap with a 2MB size in MAP_PRIVATE mode for a file that
>     has a 2MB large folio installed in the page cache.
> 
>     addr = mmap(NULL, 2*1024*1024, PROT_READ, MAP_PRIVATE, file_fd, 0);
> 
> 2. The kernel driver pass this mapped address to pin_user_pages_fast()
>     in FOLL_LONGTERM mode.
> 
>     pin_user_pages_fast(addr, 512, FOLL_LONGTERM, pages);
> 
>    ->  pin_user_pages_fast()
>    |   gup_fast_fallback()
>    |    __gup_longterm_locked()
>    |     __get_user_pages_locked()
>    |      __get_user_pages()
>    |       follow_page_mask()
>    |        follow_p4d_mask()
>    |         follow_pud_mask()
>    |          follow_pmd_mask() //pmd_leaf(pmdval) is true because the
>    |                            //huge PMD is installed. This is normal
>    |                            //in the first round, but it shouldn't
>    |                            //happen in the second round.
>    |           follow_huge_pmd() //require an anonymous page
>    |            return -EMLINK;
>    |   faultin_page()
>    |    handle_mm_fault()
>    |     wp_huge_pmd() //remove PMD and fall back to PTE
>    |     handle_pte_fault()
>    |      do_pte_missing()
>    |       do_fault()
>    |        do_read_fault() //FAULT_FLAG_WRITE is not set
>    |         finish_fault()
>    |          do_set_pmd() //install a huge PMD again, this is wrong!!!
>    |      do_wp_page() //create private anonymous pages
>    <-    goto retry;
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
> ---
>   mm/memory.c | 5 +++++
>   1 file changed, 5 insertions(+)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index 0ba4f6b71847..0748a31367df 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5212,6 +5212,11 @@ vm_fault_t do_set_pmd(struct vm_fault *vmf, struct folio *folio, struct page *pa
>   	if (!thp_vma_suitable_order(vma, haddr, PMD_ORDER))
>   		return ret;
>   
> +	/* We're about to trigger CoW, so never map it through a PMD. */
> +	if (is_cow_mapping(vma->vm_flags) &&
> +	    (vmf->flags & (FAULT_FLAG_WRITE|FAULT_FLAG_UNSHARE)))
> +		return ret;
> +
>   	if (folio_order(folio) != HPAGE_PMD_ORDER)
>   		return ret;
>   	page = &folio->page;

Acked-by: David Hildenbrand <david@redhat.com>

Thanks!

-- 
Cheers

David / dhildenb


