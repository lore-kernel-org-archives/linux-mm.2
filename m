Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 245F2CA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 04:06:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79CFD8E001B; Wed, 10 Sep 2025 00:06:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 74D8C8E0002; Wed, 10 Sep 2025 00:06:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 63CF88E001B; Wed, 10 Sep 2025 00:06:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 501308E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:06:33 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E1771C05C0
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:06:32 +0000 (UTC)
X-FDA: 83872003824.19.8DAB9B8
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf02.hostedemail.com (Postfix) with ESMTP id 2444B80003
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:06:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757477191;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=yo+PSV8jpUDSpjhwzwQUytnhxZwXp4lN1HGpADvBaxI=;
	b=MP0spNYQEIZF7FFCFw7G3C4hftIuTiRAnzBYVPN5BXrtO4WdCDlAZ7+cnk7oboUkRyLVgg
	3nyXsvgkKir0rX293xaTX0PXpwtowT1hmJQ2eq1SwGTqUUe0obqAtG9LZnEUCfQArMwSqi
	YS8Kv9IxqXwp8Zr5jPDr95R+qKWh7RQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757477191; a=rsa-sha256;
	cv=none;
	b=ClT4+ArRJ8r4ZPg1wAWf6bxrDm82udwnu7/9x4U6nyHgmYgxediBOvHKDiGuUsA2DL7kaT
	goAt/oPRckQCpz4j0xer4VgA5jgSXidhjDJRQ7gi7mBjm4WAuNUt/zrkS0Wcx1yjWGcYd7
	e8GDuFejaB9bbdeY08MmUJ9F9dPpn9g=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=none;
	spf=pass (imf02.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CD8191596;
	Tue,  9 Sep 2025 21:06:21 -0700 (PDT)
Received: from [10.163.41.55] (unknown [10.163.41.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 8BDC43F66E;
	Tue,  9 Sep 2025 21:06:19 -0700 (PDT)
Message-ID: <8f0cdb97-ea43-4142-993a-17d47762602c@arm.com>
Date: Wed, 10 Sep 2025 09:36:14 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm: Drop all references of writable and
 SCAN_PAGE_RO
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@redhat.com,
 kas@kernel.org, willy@infradead.org, hughd@google.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, richard.weiyang@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250908075028.38431-1-dev.jain@arm.com>
 <20250908075028.38431-3-dev.jain@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250908075028.38431-3-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 1gzw53o1af1wzfuczjrs7cszacegtfgt
X-Rspamd-Queue-Id: 2444B80003
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1757477190-798193
X-HE-Meta: U2FsdGVkX19FOeLxQBgS21XWXtNVweWrgzE15xQ/k/J93tAE7mX13CsxzczRqrjWNbmhPQSEaAz2OyqHy2XpdwfTfgBL3jrQYNqOuFo/sdzNqa7D9Iq6ubufBS84NOhdeETHrh/VL7z0vuGUwi4HyllKUCodgrv9cWqMidSiv3x63is8zlupWWrsaRwW8Sfx1p88hf1B9xfZt2o1cU0EKQRzrl35RscOGJvTL8bfCdUD/+l5j+YHA4xiuH9EbMErmkAcEM7KSn4K4vUy8n1MP/XlYWEjaB7u2Z98H1Qa+4t0bDpFnI6IoYH/TKix/WE+7x/raVbRdW52TdMHJC580a5jDljAAXPZbadzgJh6bPFMfhkCnY2RD6r6I3VkftnHxdIm64ofW3twoQKHreBNA/myoiB5cPFJ8ZV42rmQ/xqoMkZuZ6DHHCOuvyDVHtqd+XXyxJZ9eJjkx35x4Ejt0VwTn+ktBLc7Qp0G3rCHDSWTsu4V0BKcc1y4d2tuE21VPCammf1sBqYxSc2ZMbvir+iA5ClE6/FS+wh/wYlE5M1+iE7zEkOdvVXrM5Gzq++BGIJ4NxLTz3Nfv2xHCFusczpLqCPGMWTAZod4NjL4od37mlprZxRGD+Ky0iL19+6+V/HTdAYpoh9dEY39obztjVJhMV1QlI7Oe4/E5jmYpk+k6PYGUN9iMUi4pUQaOsmJ5+TjAsCBTs99GYuxORV1XrSIQLOECTn4R0MtUSW/56Rox6FKxNnBq2E6FMQbFOMPDTnIJukn8lZJjiv6Jbq0VscfO9JiTdkrVSoEZvmnZvlyabDofARqVyvQpu8El1CH1ti2LNWdzEaLB0RmuISyc1obmGak7yPIrpnrhxLNbM4Bf/1663SrMnYBPdf3DzAZmRQx0r9jG5a/vEhqgVyFqUlla/wSOPUmHJo+T1rtVA5Q1SgroLjHzrTtOgjUEdiZGsoDSCBWEMvX4jpBD5X
 zijZtwak
 hkUvMFh6hYZHYvVkAtk9/UffSYEGx5pc91ofgLvqGzuCjZ6b9u7hbY27COwHzJYoIW6rGKgajI7Dbsfq77HbPOL70i5v3gsfWs/izX14MVotX/Aue+HnVJKJU2CfY5I2IVweKEVSnQmopSqkRYgt0+Kep7jb2S9ePqQ8O+Wgnt/m6UKmP76SnNdRjp/9rsl7vOoL24k0UgZpEGL+pmYF4pqww4BJTLG7qoEUqUXqDAE3T0OYGTU75XPuahPDsU9KspK8v8BEjP7ESPs5WCQbs8cC2LGNwWsKGqdsKrR8FEKzLHEOq/dh+FY/iZQ/Kj0tN0hj0FvjLLUuJAmNOUtoH29ohTyWyDTo55BvedlqWkKJzwDMXhlHMqD7mVacO4cA0uv1xBsfdCPrZGXbxJil0D7Lc85x93mwYc74pTnuxXnMrwH36zXxgUxqN9vz4Yxp2DcRX03mAntGOTv91WkORt9qFbA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 08/09/25 1:20 PM, Dev Jain wrote:
> Now that all actionable outcomes from checking pte_write() are gone,
> drop the related references.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

> ---
>  include/trace/events/huge_memory.h | 19 ++++++-------------
>  mm/khugepaged.c                    | 14 +++-----------
>  2 files changed, 9 insertions(+), 24 deletions(-)
> 
> diff --git a/include/trace/events/huge_memory.h b/include/trace/events/huge_memory.h
> index 2305df6cb485..dd94d14a2427 100644
> --- a/include/trace/events/huge_memory.h
> +++ b/include/trace/events/huge_memory.h
> @@ -19,7 +19,6 @@
>  	EM( SCAN_PTE_NON_PRESENT,	"pte_non_present")		\
>  	EM( SCAN_PTE_UFFD_WP,		"pte_uffd_wp")			\
>  	EM( SCAN_PTE_MAPPED_HUGEPAGE,	"pte_mapped_hugepage")		\
> -	EM( SCAN_PAGE_RO,		"no_writable_page")		\
>  	EM( SCAN_LACK_REFERENCED_PAGE,	"lack_referenced_page")		\
>  	EM( SCAN_PAGE_NULL,		"page_null")			\
>  	EM( SCAN_SCAN_ABORT,		"scan_aborted")			\
> @@ -55,15 +54,14 @@ SCAN_STATUS
>  
>  TRACE_EVENT(mm_khugepaged_scan_pmd,
>  
> -	TP_PROTO(struct mm_struct *mm, struct folio *folio, bool writable,
> +	TP_PROTO(struct mm_struct *mm, struct folio *folio,
>  		 int referenced, int none_or_zero, int status, int unmapped),
>  
> -	TP_ARGS(mm, folio, writable, referenced, none_or_zero, status, unmapped),
> +	TP_ARGS(mm, folio, referenced, none_or_zero, status, unmapped),
>  
>  	TP_STRUCT__entry(
>  		__field(struct mm_struct *, mm)
>  		__field(unsigned long, pfn)
> -		__field(bool, writable)
>  		__field(int, referenced)
>  		__field(int, none_or_zero)
>  		__field(int, status)
> @@ -73,17 +71,15 @@ TRACE_EVENT(mm_khugepaged_scan_pmd,
>  	TP_fast_assign(
>  		__entry->mm = mm;
>  		__entry->pfn = folio ? folio_pfn(folio) : -1;
> -		__entry->writable = writable;
>  		__entry->referenced = referenced;
>  		__entry->none_or_zero = none_or_zero;
>  		__entry->status = status;
>  		__entry->unmapped = unmapped;
>  	),
>  
> -	TP_printk("mm=%p, scan_pfn=0x%lx, writable=%d, referenced=%d, none_or_zero=%d, status=%s, unmapped=%d",
> +	TP_printk("mm=%p, scan_pfn=0x%lx, referenced=%d, none_or_zero=%d, status=%s, unmapped=%d",
>  		__entry->mm,
>  		__entry->pfn,
> -		__entry->writable,
>  		__entry->referenced,
>  		__entry->none_or_zero,
>  		__print_symbolic(__entry->status, SCAN_STATUS),
> @@ -117,15 +113,14 @@ TRACE_EVENT(mm_collapse_huge_page,
>  TRACE_EVENT(mm_collapse_huge_page_isolate,
>  
>  	TP_PROTO(struct folio *folio, int none_or_zero,
> -		 int referenced, bool  writable, int status),
> +		 int referenced, int status),
>  
> -	TP_ARGS(folio, none_or_zero, referenced, writable, status),
> +	TP_ARGS(folio, none_or_zero, referenced, status),
>  
>  	TP_STRUCT__entry(
>  		__field(unsigned long, pfn)
>  		__field(int, none_or_zero)
>  		__field(int, referenced)
> -		__field(bool, writable)
>  		__field(int, status)
>  	),
>  
> @@ -133,15 +128,13 @@ TRACE_EVENT(mm_collapse_huge_page_isolate,
>  		__entry->pfn = folio ? folio_pfn(folio) : -1;
>  		__entry->none_or_zero = none_or_zero;
>  		__entry->referenced = referenced;
> -		__entry->writable = writable;
>  		__entry->status = status;
>  	),
>  
> -	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, writable=%d, status=%s",
> +	TP_printk("scan_pfn=0x%lx, none_or_zero=%d, referenced=%d, status=%s",
>  		__entry->pfn,
>  		__entry->none_or_zero,
>  		__entry->referenced,
> -		__entry->writable,
>  		__print_symbolic(__entry->status, SCAN_STATUS))
>  );
>  
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index a0f1df2a7ae6..af5f5c80fe4e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -39,7 +39,6 @@ enum scan_result {
>  	SCAN_PTE_NON_PRESENT,
>  	SCAN_PTE_UFFD_WP,
>  	SCAN_PTE_MAPPED_HUGEPAGE,
> -	SCAN_PAGE_RO,
>  	SCAN_LACK_REFERENCED_PAGE,
>  	SCAN_PAGE_NULL,
>  	SCAN_SCAN_ABORT,
> @@ -557,7 +556,6 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  	struct folio *folio = NULL;
>  	pte_t *_pte;
>  	int none_or_zero = 0, shared = 0, result = SCAN_FAIL, referenced = 0;
> -	bool writable = false;
>  
>  	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>  	     _pte++, address += PAGE_SIZE) {
> @@ -671,9 +669,6 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  		     folio_test_referenced(folio) || mmu_notifier_test_young(vma->vm_mm,
>  								     address)))
>  			referenced++;
> -
> -		if (pte_write(pteval))
> -			writable = true;
>  	}
>  
>  	if (unlikely(cc->is_khugepaged && !referenced)) {
> @@ -681,13 +676,13 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  	} else {
>  		result = SCAN_SUCCEED;
>  		trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> -						    referenced, writable, result);
> +						    referenced, result);
>  		return result;
>  	}
>  out:
>  	release_pte_pages(pte, _pte, compound_pagelist);
>  	trace_mm_collapse_huge_page_isolate(folio, none_or_zero,
> -					    referenced, writable, result);
> +					    referenced, result);
>  	return result;
>  }
>  
> @@ -1280,7 +1275,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  	unsigned long _address;
>  	spinlock_t *ptl;
>  	int node = NUMA_NO_NODE, unmapped = 0;
> -	bool writable = false;
>  
>  	VM_BUG_ON(address & ~HPAGE_PMD_MASK);
>  
> @@ -1344,8 +1338,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  			result = SCAN_PTE_UFFD_WP;
>  			goto out_unmap;
>  		}
> -		if (pte_write(pteval))
> -			writable = true;
>  
>  		page = vm_normal_page(vma, _address, pteval);
>  		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
> @@ -1435,7 +1427,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  		*mmap_locked = false;
>  	}
>  out:
> -	trace_mm_khugepaged_scan_pmd(mm, folio, writable, referenced,
> +	trace_mm_khugepaged_scan_pmd(mm, folio, referenced,
>  				     none_or_zero, result, unmapped);
>  	return result;
>  }


