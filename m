Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 395BECA0EED
	for <linux-mm@archiver.kernel.org>; Fri, 22 Aug 2025 13:50:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 578458E00AD; Fri, 22 Aug 2025 09:50:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 54FF68E009D; Fri, 22 Aug 2025 09:50:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 48C448E00AD; Fri, 22 Aug 2025 09:50:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 385CA8E009D
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 09:50:53 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C7F391360BB
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:50:52 +0000 (UTC)
X-FDA: 83804529144.08.B8DB8A4
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id BD86080008
	for <linux-mm@kvack.org>; Fri, 22 Aug 2025 13:50:50 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lFCfhXPk;
	spf=pass (imf30.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755870650;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mGhO3kmVIYGRWufT14ynMiV/yGtuvvh15Hsd9JEr9n8=;
	b=pL3ZnrykcVk23bigtiCdwcAzniGFxlzU6tkrxlZkycKg3P04yOD4qyDylueRRcEfyE6WNP
	d28xzOb8OIsIeLer++AJYAEASYuB/DoWl37MYSTKxBvUpuTsYQd1vKPYt/qLVGHyy/XHEC
	WExKb0qOzPEb4E7V6W2fHSNlhwHXvMQ=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lFCfhXPk;
	spf=pass (imf30.hostedemail.com: domain of giorgitchankvetadze1997@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=giorgitchankvetadze1997@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755870650; a=rsa-sha256;
	cv=none;
	b=kopscvqfLQKbOnTCjn5wf2mFZryJkk9GECSIR4sVAfJ7CHGmt/sfBiP74y8TLNfTeF1yOm
	AAO9TqL0NsowlDbvaSpOcMB5tNCqOTDl2iyTbaYcGxZ4XXRlXv3fsQy0VXHxpw6ppcBC8Z
	Nk/tozrQfo/CFDSKmteZ86VNsMX5aaQ=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-3c6ed2ec758so2443f8f.1
        for <linux-mm@kvack.org>; Fri, 22 Aug 2025 06:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755870649; x=1756475449; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mGhO3kmVIYGRWufT14ynMiV/yGtuvvh15Hsd9JEr9n8=;
        b=lFCfhXPkUqr6j102ZUqzGTuymcUDJjwH89N6xsJfubSJD/apbCgW6W7g+UDTfRgI1u
         zitX4+KjCUsOi/wrmvc2sixvL2XmFC237hrBdeX83k/hcIDwnnbgV2IDxF31Gc0+mk9D
         cX2fLRmlk+ZgSutjkXbJKO1qjJWMz6FHa7zK9IcphBN85lWEOUxYt/J/WyfB1FUT+8AF
         7GYk+wH6sR10E/1wzAo0zf88KVY/RzuD6aYeSQAiWPqu2aR1ipU5LK4ZyilMja+IpshK
         zbRug7Ns+oM2/8tP+V3OVHNw3cf0wU/b0jtzsqIkjLW2TN2swPZ8DIs7ppCxmHVjRJe4
         Y0Lg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755870649; x=1756475449;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=mGhO3kmVIYGRWufT14ynMiV/yGtuvvh15Hsd9JEr9n8=;
        b=g0kqIOW9LeNFr1RSAZHX0/JmKj8j3dg0jliwgZxWxB1AyZnY2GIUId6ikCL/SolohY
         jtMyfyplaYM2OwNy/sTHpKqEUN36A2g3XnJpn6qyv1a/FnqHAFi99KPVokycxRqtbTy7
         A0uLFhPsKzkqPrxfb0g+mrNwLt6/EC6PlgZ5aJp6gsewBmW+v4JblZcpFvfJhOJx+XSC
         AY4Xug1hGJF4Tf/0pUGQRb6CoZVofsZEmrvkYOHy0R1VosPLhIJPsOo4wgKrlN8bqCxs
         H5dxkIDXwRhksJq/D6VhdrUbCWoF/UM1DtRMyvcstMQ/iMEXVtW+aDzep/GF4O37+iJz
         NWig==
X-Forwarded-Encrypted: i=1; AJvYcCXtpl6ChRkct/7TqRoKGi/f6y4Zb6EifGw2ZWyC7uX6CAY7gIFkPoZInD0vt3rKM9hLskXJt3cF0Q==@kvack.org
X-Gm-Message-State: AOJu0YycPMHK9W3X0kCLATfqJsZ7hR+Wqh4iVmMq93xVbNxXyABcIeTA
	2u4hRjtfoV5bTonL1wtgJeqYQnjah9So0GdXb/sfoHiNK/Xp/GmWzGIe
X-Gm-Gg: ASbGncv3tZz5DE9z//gPlCWX5JMbLTHBZb54cujsM7nA6Z3wxPCyBNhGEP9+5oLs/J5
	91PBsWLKx1/31awUyJzCLc/hSmf3uRII6bFL3kEJSSGy03dkkxkMirFUxLuLDp1jvipEVwcFc4a
	zOAtjenC+AiuUMMki45tK5yibvsmwa9s1XkyqxkVSB3lH0LHLB/kro7Llsg0sIPquXzlOB8QHFL
	JH4xy8CJcP5Sx1V2LbHicrpbTO8sru9XTZPif67oWNvGbCaa9VrkHtrp2kgLTyd/lz6OGiG/Ebn
	G0MXa2NYw5v6DGU8JUMe+iMdD/Ew6BFWgw2T2EVUa/Ka46StmF1M/oWPd6AFr6uPPb/+EkBMpvI
	fFvA7XouJYP2Fxh5H+4HVXmakflwtf9Qb4HrBYHNnVQok+DfTDbHgRuyXtz79NyAz6W3+3DP9GT
	m8wsqW5Njio01AOj3mRjE=
X-Google-Smtp-Source: AGHT+IFgLJnsa2QDWZ7yy8ttoVwSdR672VRHn6w/2d2eIUK/l081Cm2xTXQ1WfEHFk7l29E3EP1adg==
X-Received: by 2002:a05:6000:240c:b0:3c3:c280:d43c with SMTP id ffacd0b85a97d-3c5d7ea4ba8mr1184915f8f.0.1755870648896;
        Fri, 22 Aug 2025 06:50:48 -0700 (PDT)
Received: from [192.168.100.6] ([149.3.87.76])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3c6e2d3f2aesm165454f8f.58.2025.08.22.06.50.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 22 Aug 2025 06:50:48 -0700 (PDT)
Message-ID: <4391e3f5-e0a5-4920-bd50-05337b7764e7@gmail.com>
Date: Fri, 22 Aug 2025 17:50:47 +0400
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: lirongqing@baidu.com
Cc: akpm@linux-foundation.org, david@redhat.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev,
 osalvador@suse.de, xuwenjie04@baidu.com
References: <20250822112828.2742-1-lirongqing@baidu.com>
Subject: Re: [PATCH] mm/hugetlb: two-phase hugepage allocation when
 reservation is high
Content-Language: en-US
From: Giorgi Tchankvetadze <giorgitchankvetadze1997@gmail.com>
In-Reply-To: <20250822112828.2742-1-lirongqing@baidu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BD86080008
X-Stat-Signature: ar4fbwgkwgxutp5gs4ht4nkraktcppst
X-Rspam-User: 
X-HE-Tag: 1755870650-402449
X-HE-Meta: U2FsdGVkX18Kh5R+Vrj4seaEmFexyiUN2B3rH7LvZmbVJoGv/8BnkHFm5oO/w/VaRcXoFL1ykyXDlxQvtHv+UtPLK99U0ASz0D6vJ7Y+SLORoYNdCr6ME1NLTdnUbQFlYmgbOUwrT4a6GNL4FuJhYT/NNL5SzHCoYE19jI0DliD05W4Z8rZpewPwrGbX/dwhAkiCEvW4HlmiSrP/IEvWok1Vv2RJByCwmTVF2muHV7o5CxwvLvmKJZzi4RqegmunLidQP44uc/EUx227um2eUG91VEvrjVhjFlHZAHsJN3Cg8Sdvf0AoJ0iOWmAguUA71cW+1Oug+3WxOQDFd/cth/0Y/g9k+RVYv8qKCAT84SOV+ZMCro1DxVzZQowD4xQGA++A4Is7TpvByVOCjKKybYV4ixMzope8K9Qns/G1BdPL5sT7ehbhzKuV+ogKB5MguRO1WEPwwaXq+LH+VQ8ZcCcFWqnKeX8vsRF4u6wVJUWNn4iyL2jovmAsfdbVAo9HoQTUA1KUyqUlcsqjMf1rDkVeXIQz8gAbU6aaw7J3/JyOLLFv3FftQuGZSXLv7knXmQCQU2ATXq8qLrFKvUlfyF+OktZnatwA72uopMZqa34XsAFjhRDsYRAtXKPhXDitQbcl+QQLoz4u/gvJWFA8dbEx+IYel936E7rVIaeGA4MEGPoF/RuKfvvdHUh+qYuBPPHaZQK5qD84ZTJvE9Rv4FvdAI+zgt01urXygvptfrMF+pgiWSDoy/yVjF3I57X5pwN6rTmFJvv7QRnfpjCsLpjMDvRXyFLKlGoWEj00qCzPtUArZCuWG5x/C9gWtcr4BRetaa8gN9SDYfeZvLmERYCMqHBdLOEJgOzVXRWk/WbLNcwoV+5wG3XMjSpjuyKokHsKCpUP7wMk4aS7znZCNkg7JQ6CTLdebVnDmP0pT9TCzxMfC/BWGzzvfLPSGVUQfQL1alwfWxglct4m4i8
 R4izl6A7
 No6fLHYpM0ddAM623nfX3rSloowgr111ftgbG0bxxVhbLBwrEzB4U9/X41lrKVYHsHNJx6J7FTv6qLOUWO39zvTAfVWHfTsDIuP3HOhXBMg03Wq7TTuzSphf+2gWdugNmEjdUY26GqMINFfs6DeZGaxF7YZx04oXKAxlmozjlzICShG6TjtuVYNP2IKD1NXBD+gONMG0aVFZdDsFqE0/9wy8MFxPLgaH8e2nSTQAC+0NGamRI+dA3+0YNEffeWl5iVSqGNaEHVuOUbE0wBunyGG6J163ja948YSpSPhO/z6U/8gFSK7K4f9Vqacn+zyhl62XSnBZbrpwKEJgasYw31bR9mcf/QJ9l7+bqT7rUpTjQe3oSRhiBA8/zwRbQtBwobxP+jSdsOZsEyx+vFaj73SM38tzN56Zg3GEJJ9YfnEXpH6ex2UmNji6byqT71aai+JsNX4FxQvnrJiKKh5ccnNwMiZxwzTDQOobyLnb97y4GCRrPWwdUahl2ZQad4EcetMFb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi there. The 90% split is solid. Would it make sense to (a) log a 
one-time warning if the second pass is triggered, so operators know why 
boot slowed, and (b) make the 90% cap a Kconfig default ratio, so 
distros can lower it without patching? Both are low-risk and don’t 
change the ABI

Thanks
On 8/22/2025 3:28 PM, lirongqing wrote:
> From: Li RongQing <lirongqing@baidu.com>
> 
> When the total reserved hugepages account for 95% or more of system RAM
> (common in cloud computing on physical servers), allocating them all in one
> go can lead to OOM or fail to allocating huge page during early boot.
> 
> The previous hugetlb vmemmap batching change (91f386bf0772) can worsen
> peak memory pressure under these conditions by deferring page frees,
> exacerbating allocation failures. To prevent this, split the allocation
> into two equal batches whenever
> 	huge_reserved_pages >= totalram_pages() * 90 / 100.
> 
> This change does not alter the number of padata worker threads per batch;
> it merely introduces a second round of padata_do_multithreaded(). The added
> overhead of restarting the worker threads is minimal.
> 
> Before:
> [    8.423187] HugeTLB: allocation took 1584ms with hugepage_allocation_threads=48
> [    8.431189] HugeTLB: allocating 385920 of page size 2.00 MiB failed.  Only allocated 385296 hugepages.
> 
> After:
> [    8.740201] HugeTLB: allocation took 1900ms with hugepage_allocation_threads=48
> [    8.748266] HugeTLB: registered 2.00 MiB page size, pre-allocated 385920 pages
> 
> Fixes: 91f386bf0772 ("hugetlb: batch freeing of vmemmap pages")
> 
> Co-developed-by: Wenjie Xu <xuwenjie04@baidu.com>
> Signed-off-by: Wenjie Xu <xuwenjie04@baidu.com>
> Signed-off-by: Li RongQing <lirongqing@baidu.com>
> ---
>   mm/hugetlb.c | 21 +++++++++++++++++++--
>   1 filechanged <https://lore.kernel.org/linux-mm/20250822112828.2742-1-lirongqing@baidu.com/#related>, 19 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/hugetlb.c b/mm/hugetlb.c index 753f99b..a86d3a0 100644 
> --- a/mm/hugetlb.c +++ b/mm/hugetlb.c @@ -3587,12 +3587,23 @@ static 
> unsigned long __init hugetlb_pages_alloc_boot(struct hstate *h)  		.numa_aware	= true
>   	};
>   
> + unsigned long huge_reserved_pages = h->max_huge_pages << h->order; + 
> unsigned long huge_pages, remaining, total_pages;  	unsigned long jiffies_start;
>   	unsigned long jiffies_end;
>   
> + total_pages = totalram_pages() * 90 / 100; + if (huge_reserved_pages > 
> total_pages) { + huge_pages = h->max_huge_pages * 90 / 100; + remaining 
> = h->max_huge_pages - huge_pages; + } else { + huge_pages = h- 
>  >max_huge_pages; + remaining = 0; + } +  	job.thread_fn	= hugetlb_pages_alloc_boot_node;
>   	job.start	= 0;
> - job.size = h->max_huge_pages; + job.size = huge_pages;  
>   	/*
>   	 * job.max_threads is 25% of the available cpu threads by default.
> @@ -3616,10 +3627,16 @@ static unsigned long __init 
> hugetlb_pages_alloc_boot(struct hstate *h)  	}
>   
>   	job.max_threads	= hugepage_allocation_threads;
> - job.min_chunk = h->max_huge_pages / hugepage_allocation_threads; + 
> job.min_chunk = huge_pages / hugepage_allocation_threads;  
>   	jiffies_start = jiffies;
>   	padata_do_multithreaded(&job);
> + if (remaining) { + job.start = huge_pages; + job.size = remaining; + 
> job.min_chunk = remaining / hugepage_allocation_threads; + 
> padata_do_multithreaded(&job); + }  	jiffies_end = jiffies;
>   
>   	pr_info("HugeTLB: allocation took %dms with hugepage_allocation_threads=%ld\n",
> -- 
> 2.9.4
> 
> 


