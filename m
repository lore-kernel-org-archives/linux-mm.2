Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 520CBCA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 04:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2FA98E001A; Wed, 10 Sep 2025 00:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E0078E0002; Wed, 10 Sep 2025 00:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CEA38E001A; Wed, 10 Sep 2025 00:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 774228E0002
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 00:04:00 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 41A1159948
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:04:00 +0000 (UTC)
X-FDA: 83871997440.11.2BBE717
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf25.hostedemail.com (Postfix) with ESMTP id 6DF28A0006
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 04:03:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757477038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=EIyW0wC4SlBxAP4d1HRzH/Z73RZLPAZ/DuFLbislWY0=;
	b=PzU6XcqIz5WhQOVUPThuHZHm1qNiwh7GrKO+7G+DwXDE7DwkpXw+mCJdQ5xRXiapmfRyCZ
	a57lb/RftcZTu7jaUmUIlajsCmhj7MZkYdV5WNNdtRud4b2c10Q1xNEjXFhYSAw7xnTked
	yT5oByAv1V5wOWo3E8erLBPQyd8otbU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757477038; a=rsa-sha256;
	cv=none;
	b=qBix4Ck/ERSnPYeNPmhAG6RnJbjhboDjdaCJLGcun9bMuNdAGQvk+FI1QBJVbamV8ICvvP
	ravwHKQCQXzyhRSCIRjB8QPgDoIWrDzAFz2TAf+PwZaoLngNI6jnhwCf+bUW79AmUFQhml
	nIo/mLL+1NTD1YE7vhmcQtKxgpGCELY=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=none;
	spf=pass (imf25.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0324C1596;
	Tue,  9 Sep 2025 21:03:49 -0700 (PDT)
Received: from [10.163.41.55] (unknown [10.163.41.55])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id AAB133F66E;
	Tue,  9 Sep 2025 21:03:48 -0700 (PDT)
Message-ID: <8381d07d-f669-4e9e-8dd8-5951a4e5727b@arm.com>
Date: Wed, 10 Sep 2025 09:33:42 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/2] mm: Enable khugepaged anonymous collapse on
 non-writable regions
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@redhat.com,
 kas@kernel.org, willy@infradead.org, hughd@google.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, richard.weiyang@gmail.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20250908075028.38431-1-dev.jain@arm.com>
 <20250908075028.38431-2-dev.jain@arm.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <20250908075028.38431-2-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6DF28A0006
X-Stat-Signature: jf18c1g1wrgsj5qnk11ydrjpaj5yczc7
X-Rspam-User: 
X-HE-Tag: 1757477038-68642
X-HE-Meta: U2FsdGVkX1/tH59BmAJLh/37KL3+elpsNka3rpzQ99blTsEfhfNQ9XulrfWrwtJ89IxL2XjQ8A5rc78RI4XboDRTaKPV0Uuv1t1ZL1z/SEVKyKEMDihBAjipuMq9S9kqgXl6nBHMskrazkpkdvp9pLo6h5D1sYiViQbiJqb1qhhO1nbrhexMN+t/gjxbSMa+SJo9b0jcmYqe1ED6dUw7/FfrICiAPd/9Cr4oZ7dculConhlz0tPvj5ONjitPsh1nItx+eUoyIotM3mC8rMt4mXWtNV49GehS+ULHKhlygUcQNoDdrXMaPc8fQGoAgAxjAdpONgm58+2g8wnd3kf+l/pveaFKuIC9oWzUWyTeHhutC/gXHnLAVk5CD1j93XWeR1gSs1257nRmZLNWvFjwaY6M05FAM/oUTArHTdcPl8cE8GDRfJ+v55UmSz//Hmu4A5kLNNSzQtb9f2RUmwTQkAbPqmWAyAKE0I2wbJSkPZAsvzpD1OQb29n/wTR0Y0jXBcZYon81tdFzplKj3gZSZh76ZE/hB72KzIQcnBf0FiZ230QzRj5uOB5yur0RuMsqmG2iwNuD3JUBg4VEtD/zLmjG9U6gKbqkHr+ZVWNA4g1UEpFGou0C4sNxFXl97JtZSaXTrHYKfZ4w0N0HmvG5Htug7dl7NKtE5Hic6MUAMSjRYtfWKtmtDtP4dvqPNrhYZUib5lYl3XU8kqhXe21VBjMDv16CZKxekBTj5WBs1RyUHKe3rs2lFaVwAkd0ip5F++63Z4so9bwthxJO6SH+c5+6UTf3i2n8/VTR19ucIn95cDrokkgo3mTcEDaVYimXScLLBH9pIwtD/4JVjbRctywFZWK/WLc/6Be2w7uxtrU+GPsXNmtMEKUhJhS874xaHJ98oEHken4xO5Q93YnnPG5T8uxlPUqmn0WfaX2YU7OHSwfWe+BLre/CeOLTq9J/c6tFI8ndBUBA0e4widf
 Ev4WeFhw
 M8pQ+vh+q96S00WggZhN2GmnrC735d/x6bobewi8qDNYMwcsxut/L31qgKT7pUvZTzkbrP6Lb6K7Os0bfr+pz2HG2T3LsyU5TuZh1h65AXIfOvBtB3CpuStH+vJxwcouumLUj7P1qt7pBBcg7W1CeDXtitwCBVNJ0jG3OHhVhYpUQUHTBW5iont9dyT7wFf5XdOrQj0rf6F6vp0A02z/62qFY79kzTrnmTeKDdVLK1eGmUxKc2g/OoPX6n5xqANccptjbMo/WKj5SllT+8dV2KFgigWhG5wX4+MVxFOrajG6cXBJE1yPEKlZg7kIPjPvyuiZ9iwgNXV3niTFjWiCciDLkNkofIqCiqypjU4SbD4zd17XHmfDsEtEnWKHCp7//Ew9DymNuZi/YHwchWFhaj1Wp/Yx2AZS+uIN9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 08/09/25 1:20 PM, Dev Jain wrote:
> Currently khugepaged does not collapse an anonymous region which does not
> have a single writable pte. This is wasteful since a region mapped with
> non-writable ptes, for example, non-writable VMAs mapped by the
> application, won't benefit from THP collapse.
> 
> An additional consequence of this constraint is that MADV_COLLAPSE does not
> perform a collapse on a non-writable VMA, and this restriction is nowhere
> to be found on the manpage - the restriction itself sounds wrong to me
> since the user knows the protection of the memory it has mapped, so
> collapsing read-only memory via madvise() should be a choice of the
> user which shouldn't be overridden by the kernel.

Agreed. Dropping this constraint makes sense both for MAD_COLLAPSE
system call and khugepaged based collapse as well.
> 
> Therefore, remove this restriction by not honouring SCAN_PAGE_RO.
> 
> Acked-by: David Hildenbrand <david@redhat.com>
> Acked-by: Zi Yan <ziy@nvidia.com> 
> Reviewed-by: Wei Yang <richard.weiyang@gmail.com>
> Reviewed-by: Kiryl Shutsemau <kas@kernel.org>
> Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Reviewed-by: Anshuman Khandual <anshuman.khandual@arm.com>

>  mm/khugepaged.c | 9 ++-------
>  1 file changed, 2 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 4ec324a4c1fe..a0f1df2a7ae6 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -676,9 +676,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>  			writable = true;
>  	}
>  
> -	if (unlikely(!writable)) {
> -		result = SCAN_PAGE_RO;
> -	} else if (unlikely(cc->is_khugepaged && !referenced)) {
> +	if (unlikely(cc->is_khugepaged && !referenced)) {
>  		result = SCAN_LACK_REFERENCED_PAGE;
>  	} else {
>  		result = SCAN_SUCCEED;
> @@ -1421,9 +1419,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>  		     mmu_notifier_test_young(vma->vm_mm, _address)))
>  			referenced++;
>  	}
> -	if (!writable) {
> -		result = SCAN_PAGE_RO;
> -	} else if (cc->is_khugepaged &&
> +	if (cc->is_khugepaged &&
>  		   (!referenced ||
>  		    (unmapped && referenced < HPAGE_PMD_NR / 2))) {
>  		result = SCAN_LACK_REFERENCED_PAGE;
> @@ -2830,7 +2826,6 @@ int madvise_collapse(struct vm_area_struct *vma, unsigned long start,
>  		case SCAN_PMD_NULL:
>  		case SCAN_PTE_NON_PRESENT:
>  		case SCAN_PTE_UFFD_WP:
> -		case SCAN_PAGE_RO:
>  		case SCAN_LACK_REFERENCED_PAGE:
>  		case SCAN_PAGE_NULL:
>  		case SCAN_PAGE_COUNT:


