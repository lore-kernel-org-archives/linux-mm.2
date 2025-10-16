Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E01BECCD194
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 05:35:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 108338E0003; Thu, 16 Oct 2025 01:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0DF738E0002; Thu, 16 Oct 2025 01:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 01BB78E0003; Thu, 16 Oct 2025 01:35:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E49C48E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 01:35:04 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8E3A9B6E43
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:35:04 +0000 (UTC)
X-FDA: 84002863728.06.1AAFEE3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 679E020004
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 05:35:02 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760592902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=9UAeECLvVapluOslyCBo82/2dZE3Qz2TqcG+s3/rVOA=;
	b=sphnCbHH/iW/BMkDHfkqdOLXB4YDDCbyjJkJhLGBbZoIodD8MP/gQxMqtI+FK1y5tDToHT
	bC2YhiVHecmyt/ysrCJzyRaROYlWPOU1hGoIhQ6tVLcHuaLTlX5BMRnknHUNrsYEAilQ7A
	KrB4bxo0DXNEY2Xiq6qTD0NR6vKaDs8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760592902; a=rsa-sha256;
	cv=none;
	b=Gg20jV+VTUSzZBT7M7G3kd/CIXG/EwDq6KMN2G674FDHqiw7/OnaTTVs0sueIvK/EV/CEp
	DSDW+mxpGW+yvTEeX+bwxLDOD8QjPH6k/40hL0at9/ifTKZ03IV2kKmb5xd/LqHlyG0UIS
	cXaNAc3JE/ttFeQ4VbYsdqA92O8rtP4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 65C441688;
	Wed, 15 Oct 2025 22:34:53 -0700 (PDT)
Received: from [10.163.68.150] (unknown [10.163.68.150])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 9D6D23F6A8;
	Wed, 15 Oct 2025 22:34:56 -0700 (PDT)
Message-ID: <ab4e7044-c285-426e-bf9c-fa06a0f47ae9@arm.com>
Date: Thu, 16 Oct 2025 11:04:52 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: guard is_zero_pfn() calls with
 pte_present()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251016033643.10848-1-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251016033643.10848-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: 5sdyurinxx61dcrouoff7ajr8k8kxnue
X-Rspam-User: 
X-Rspamd-Queue-Id: 679E020004
X-HE-Tag: 1760592902-996259
X-HE-Meta: U2FsdGVkX1/cSMCYDfKLhFa5uD3Y5M3ECf14YnpGfBAEMil1DRNna5zmN45mN7fdSrmuyND8LBO9GWvIfurguR84zU0Z4xmDQS00mS5ib2m1VPtmvW1e4DfsH0EDD+wA2O6uPPjwY3shkh1O0HI29YM6ZarsJ1RHpAcsQheXSaeD+bGqzez/Pq4YJ8bLkhlZqWBcOJEPPzp6aLYW1PKju8h5jcVThERIDyzJBBopRQZXuwG0MtDnW2yw66O2IreoriIZOKL2PpFPPRrM04srGcX0DwYMjaZFVuYFeUwcGOC1DxcI9VuAVnZPg0lkauJ2yxMjbXxnXCEFfHwkE8rsJ9Lsb8Y0JFCg74MiQFVRpl6T7eNrd9PzEg+uJLgb6pYK5VPuPgoHhhcZFyHsAxYHRpc6NXpE3OmcjGUKGSQDQs0LOj2409et6kuOeXr7Wl5VAEZyg/MxmMim2ywRSrj0DCdT1Kwe2eCVIaM3tq339EQORC58hwPTidDugUPS8rYTiEW+MVA5d4TLV9sg3xMpaICNKQGva59+c5BDLwMbZ+sqwtfaJYXjkz5/XyLwj9Sjn5uHbpShPEYMCknD8ZOF2deCs9uGlCbLatkHu1l6PlzXksgsVQ+E2P430kKtJSHGcbasBDHiatlszelO29yvz/B51FxkLyOVyK8sHNqAGV/rJNdjUq9zgM9i0cA/iRltVHmYBxH4Kgui1FjE5jKiqoJQR8O0bUKvoNBd19xz1wcKs0UDnmjNWi9XhbkIT0JuOyl5Bwn4zmkK9EAu0/IAxtLtdAspsvnfXWtkgjfsrUwYLyCI8O6i2d6ZqJSdwDS/REtdSoKWJZkbCAqLi14ygyQBaVXrVDjXtVbUH8dWtE2EPhcaprR/5L/6G3A5aNNbLLe/2jNllLi42oV66waVb9IxzXlp+1TTJxZ+J91rfuBMqFik0/HTgorIt8lLxH/slBd7BSAk/b5MYUEei7/
 jjcawvUY
 qXDyuNydi4Qf4zJ2WwFN5+fjjvfW6CNTlP4fMYsonOHvSCNfG/tk6iQCe/1vYdlv3+NLpDqtV+T8UhASgDUGL2Ysl3OVxryJ1s4iyJ2hUlMCWmTdc/kw7cknZ3G2KurD3kRtY+Sim5rXIwgFMooevk1E2E9YuAjy/dcKebMD+x9HctOEe5jaFHKazoz/gnCu2rtszwxdBj7GCRM+TiRNWWdYm6w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 16/10/25 9:06 am, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> A non-present entry, like a swap PTE, contains completely different data
> (swap type and offset). pte_pfn() doesn't know this, so if we feed it a
> non-present entry, it will spit out a junk PFN.
>
> What if that junk PFN happens to match the zeropage's PFN by sheer
> chance? While really unlikely, this would be really bad if it did.
>
> So, let's fix this potential bug by ensuring all calls to is_zero_pfn()
> in khugepaged.c are properly guarded by a pte_present() check.
>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

Thanks, I missed this.

>   mm/khugepaged.c | 13 ++++++++-----
>   1 file changed, 8 insertions(+), 5 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index d635d821f611..0341c3d13e9e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -516,7 +516,7 @@ static void release_pte_pages(pte_t *pte, pte_t *_pte,
>   		pte_t pteval = ptep_get(_pte);
>   		unsigned long pfn;
>   
> -		if (pte_none(pteval))
> +		if (!pte_present(pteval))

There should be no chance that we end up with a pteval which is not none *and*
not present, if you look at the callers of release_pte_pages. So perhaps we
should keep this either the same, or, after "if(pte_none(pteval))", do a
WARN_ON_ONCE(!pte_present(pteval))?

>   			continue;
>   		pfn = pte_pfn(pteval);
>   		if (is_zero_pfn(pfn))
> @@ -690,9 +690,10 @@ static void __collapse_huge_page_copy_succeeded(pte_t *pte,
>   	     address += nr_ptes * PAGE_SIZE) {
>   		nr_ptes = 1;
>   		pteval = ptep_get(_pte);
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +		if (pte_none(pteval) ||
> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>   			add_mm_counter(vma->vm_mm, MM_ANONPAGES, 1);
> -			if (is_zero_pfn(pte_pfn(pteval))) {
> +			if (!pte_none(pteval)) {
>   				/*
>   				 * ptl mostly unnecessary.
>   				 */
> @@ -794,7 +795,8 @@ static int __collapse_huge_page_copy(pte_t *pte, struct folio *folio,
>   		unsigned long src_addr = address + i * PAGE_SIZE;
>   		struct page *src_page;
>   
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +		if (pte_none(pteval) ||
> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>   			clear_user_highpage(page, src_addr);
>   			continue;
>   		}
> @@ -1294,7 +1296,8 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   				goto out_unmap;
>   			}
>   		}
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +		if (pte_none(pteval) ||
> +		    (pte_present(pteval) && is_zero_pfn(pte_pfn(pteval)))) {
>   			++none_or_zero;
>   			if (!userfaultfd_armed(vma) &&
>   			    (!cc->is_khugepaged ||

