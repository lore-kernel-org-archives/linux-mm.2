Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 55CD5CCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 06:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B34E78E000C; Thu, 16 Oct 2025 02:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0C448E0002; Thu, 16 Oct 2025 02:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A21D98E000C; Thu, 16 Oct 2025 02:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8EE6A8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:17:17 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 404EE1401D8
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:17:17 +0000 (UTC)
X-FDA: 84002970114.24.6B75818
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf17.hostedemail.com (Postfix) with ESMTP id 94E054000A
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:17:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760595435; a=rsa-sha256;
	cv=none;
	b=PdB3XGdDAyFwfFrFacI+L/g76u6277vcLpIbWFopIQGmBIFssocprLkwiVOKBgeIvS8kYo
	5ztrmHUGxE8RY/L5EPGB2MP97yU7Up0Ra90BcPyL1DKfSlEjUc3ZDsmmlrt3XVBZUWRoqB
	eyXAv3p6LtefiBV6B4JqqujsO7p/yhw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	spf=pass (imf17.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760595435;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6mqJf4dZbOJFeRUMTb9bkAIAgj6hAxtv87Xey0ua6XA=;
	b=AiOqdBk/6PwyXrWfcA1AFnEaYxKKkHZj7QTrFMiL7KEdWUPEhh7nPNFO3lWzVF36b5Ky3n
	V6OQrAGlPHgvr6KyKDwKO3SL0aCLL2rZX7JQbcpSxKytexz0vBTih17i6RpZNZ3rcf116B
	1Fuzt+HDoM4cCOqQBiI06AzmwZKncEE=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A04871688;
	Wed, 15 Oct 2025 23:17:06 -0700 (PDT)
Received: from [10.163.68.150] (unknown [10.163.68.150])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id E1D8F3F738;
	Wed, 15 Oct 2025 23:17:09 -0700 (PDT)
Message-ID: <17c4c5f9-6ac8-4914-838f-f511dfbf948f@arm.com>
Date: Thu, 16 Oct 2025 11:47:06 +0530
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
X-Stat-Signature: 99f4hqyaqxectc5qgw96ifz583ugqihm
X-Rspamd-Queue-Id: 94E054000A
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-HE-Tag: 1760595435-239581
X-HE-Meta: U2FsdGVkX1+97WUCfwzhUnp4MXWiNvLGNlmfXaBfBr3doSEv428J9wmsWAAP01qNjrSdfOsXstnGeTd+Z1F7kSm1R+9BR1e4D4kjWq/iIVOhuG6nSbuZ40jcHkJV0tFquWrMco26/wnuxXQQjII5aS8vCIJYwCOfxDv0xIUKfz9+xjD1/mNgTsAYvaIhdBd3wCfmvpW23vEi+SvEXrOok5OpvI9x/MXJUMY5mwY7ulQZe1elwpsq+Nzo/Ysfrj2QUan+2qJOI89VHQjoT4rqUj8DKqpqnBIbGx9pr+NeH1uZR8JF5hNdTdY/PGEuXnIm/sSnC65JDBrDsPI5X2xZjMcoCAFBM9B2b6gYvaGbSV5hwr9vmHZZh08FE0baReMukyJzXPdovq7CYHamhG6i2MAIVcuOr6hUYnxvrwy0kRq7Vo+wnf8jKfqdxY1hH5L4Wmn6znn9HwoGRPpc6hLpwFx5AVwXL284HunVviHM6XkozUrW1S98KVwtlrJc/qIv6IPwluFpOibeJOb2+zlR/pUpNb4UZoT3MXorh0v80Flcs6GBIZxSQ4hez5kMAnLniRvTvx2q5ATIqXZyxJQXj+eA+14ZO1NohVidJY9ATMwJW93mDQwuwT0uv9n5oe1m6RezBnLWf/WJsAV/d/YuRchDx5BT3igj+il7lWW6kKoxh8q1gLRNkyU6JtYxcvsuoBNSI/KI/gqpO3izArFX1Ab2gJYSu0mvOeOKkIFZjNHcUczD59T3UmkfjB4ysk8+opWqFLOl/ZzP5Izekceyo8sizZczRlaZxud2CJfT/NXMdH8ydrjozxLcfwgHdi2Pz6lBNE/Ql97cbEJeWad3DJRdNfO4hPxelyu6GTLVoydZ8zEEwcwSloR7fHOwfst5+BcTjrb/c8S20OHn0LOPMp+SAR8SiwyRt5C3YjPrBEjjLI2m15XXnea1ZD0eyZIxWH9uoL1Snf4nNbdoVDN
 9qoU/HAd
 UhPF/KYcVLMXemJKPONKeJYltFmnIZLUrm0PFim7JW7/wQxWwlNWowLvlBZsC5v/3NQDYLS1AXpo7mLNyyPyYwIlO7dpFqYlnvRPhC0VCuIm+/PdQU37uU8sqY/rw7Kfbj9ULtyKA5S+JfsBXjhHE+TOl90WJxQ1R/RrBNb3kQCFdyi1RNJc6QxjcB52G4HCWTss1JD7acxKgtxyNyfl5/s6X31J6mjBGFELPr4ar3cAd2r1S1h573lLv2mayQOv6Kt1k4x7w0sPIM/0=
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

Could save a level of indentation by saying
if (pte_none(pteval))
     continue;

That would make it crystal clear that we do nothing when pte is none,
and we do something when pte is pointing to zero pfn.

Reviewed-by: Dev Jain <dev.jain@arm.com>

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

