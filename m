Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02608CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 10:20:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 445A28E0008; Wed,  1 Oct 2025 06:20:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3CF2C8E0002; Wed,  1 Oct 2025 06:20:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2976A8E0008; Wed,  1 Oct 2025 06:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1523D8E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 06:20:49 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9A9985BF57
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:20:48 +0000 (UTC)
X-FDA: 83949151776.11.A5B18F1
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id BF41A1C0012
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 10:20:46 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759314047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=neZ7wzzhEnRPUgcnmNyEhaqnRGSNBeJVMijmsBujNU8=;
	b=cQ4KASYTJj0FOEkTswOBaCFrR9B0ASq9ZXqFFmCP8bG92O5td4ZWjvc0DYlIGHoWeR+9C0
	aB4tPMewowKNtvVnR0p5ZIrCAxb5EYhfcbt4YOAip6Qp/V0yMO7TUGMHp2vUwq9BGwyrcs
	ia7qElj3lgfhiSIb4QtdrBQWmos4rGk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=none;
	spf=pass (imf20.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759314047; a=rsa-sha256;
	cv=none;
	b=ewAeMh1tArLprUb09IV+SapUiWZjloG5SGX+MnBslHDfB+Fqg/Wy0lq5UjqeyDXUTNFDIj
	MfAaAYVUvAQ042jjUe74vuHym6Q+jFjk3JOZLvmPwAm++wMNPMAze+C/07abQrLqxlmd0i
	vyqT3/6Br6Qz8dHlRj6IzpT9N5o8brk=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id A7AA416F2;
	Wed,  1 Oct 2025 03:20:37 -0700 (PDT)
Received: from [10.164.18.53] (MacBook-Pro.blr.arm.com [10.164.18.53])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 735BF3F66E;
	Wed,  1 Oct 2025 03:20:40 -0700 (PDT)
Message-ID: <a1df234c-d003-4696-8f1f-609a360fdeda@arm.com>
Date: Wed, 1 Oct 2025 15:50:37 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 1/1] mm/khugepaged: abort collapse scan on
 non-swap entries
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com,
 baohua@kernel.org, baolin.wang@linux.alibaba.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com
References: <20251001032251.85888-1-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251001032251.85888-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: BF41A1C0012
X-Stat-Signature: 84anpcxdrujte3wkuqc934sgkp946m4n
X-HE-Tag: 1759314046-785383
X-HE-Meta: U2FsdGVkX1+akkqK3ENkgmUFXtHSRc6jHmEJCf/RWZWQQ2M7NnUei2V4LsoJZ7bZpzkeOP2TnI1o5vVehj+NyCy+RdWZgK/ZAPe3Zm5kz9MkjtgnHgtytUhLYXB6PKjtRpgVDjoQPF3uC96Jqdkkbd9GOl1dG36b4BMdHsAHKneVdsY6tzjk75oeuvfrokUgLuROEkhllsOahiZn6erT5315oqNF4SZPvl0V3B6pZ0iJc8X7nvHUMlPc66I9PtG33ErE7lAQ7Olk0rm1H6ZToXMp2GFKPRm6qQ6GOKwYY3GY67UQMDTuckVLEhxrtXsn8OnYEQUrrc27PKygoi5bIKeo+jC793OaOQ7125B+N1TTunWirmRSHenobNLb6DshLR7Ww4cp0O94fSn6c4B/9Tb7bowmtZ6yEeoEjqtU352R5h3Y7FoQ4kDGIlUS4tKKX79jSnH+pR+6u4agr6LN0RE5C7s9Wgz9lCB8z1Sjx3XiT6sEB4ZZoGxGSNiMTA5reBesBY8HAnrnpqTw2QLd/z6HFCNApKvyrHChPPkFj5+gzizsFKGZCTvnPNJsCLC3j/LD6XlPVRMzW9NwxOh0OyIwzMOTiOpdLwylGxitXXD9QZXNCXkcsb/QZCs8YXuaIzVfs+BCV3Cdw8e9LifDM9RFcWotzVERbpryEDrBkZexPKhm8JZ97hccLribMAWkoyeHyNHw3vEcwKeuLsSmIHw54Ykp/8ei7fRKrKDCzXMx0QWRr9kguSrCX8dR59krjOKYdSWFK84trdauJXmvpZi2TwZXxae0aakLpTe5zrRL4dF9WUWn1mrMYcaHYZiUUWMfuuqmIBiRDkPiv2paxVBJfDirJ5gj2YnqJaDZluPh8Fu6ewj3bIsXm09+mhtsTXlqAQh+TF2Ny3SCpoEC4aVFe3Opb6CzsRAEVpoYtcVSfddkhYAFkGEcFcI2jJ7Tvn9BZeNFse0NmSIBA9N
 83Tvg1dm
 T/bPT2hL+zVClz9P1057bzfqvglqD4qy3w++uSGgvbjVTTi6YQp37p73EwGZxTDIjoDdBfqHEJWYL1vEO5FtEhcHmLPiC2+OJL9lb5yjJE/Uvo8qtnFnTEV//cp3W2LszfifNsMo6Q6aYJLaq5hTJcseD1dOY3Te/VsIRb/WGfiNV0G9lTysd4qBUXG1kwn1qtXML/MQw1Pnoabe6G8N064ZvwgA0kWXtwgrPnAP9JA7q85ZsBeOX3tbzUKHsprcMCEn7mTMB8p9IL+PHJgBmfIM0B4Cc7SDZW+jcmFvjiyMHRsU4m+mkmxV8bMoAM2OqS6bYDwgKI13M/0JJuwWiy3MH/g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 01/10/25 8:52 am, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> Currently, special non-swap entries (like migration, hwpoison, or PTE
> markers) are not caught early in hpage_collapse_scan_pmd(), leading to
> failures deep in the swap-in logic.
>
> hpage_collapse_scan_pmd()
>   `- collapse_huge_page()
>       `- __collapse_huge_page_swapin() -> fails!
>
> As David suggested[1], this patch skips any such non-swap entries
> early. If any one is found, the scan is aborted immediately with the
> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
> work.
>
> [1] https://lore.kernel.org/linux-mm/7840f68e-7580-42cb-a7c8-1ba64fd6df69@redhat.com
> [2] https://lore.kernel.org/linux-mm/7df49fe7-c6b7-426a-8680-dcd55219c8bd@lucifer.local
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> v1 -> v2:
>   - Skip all non-present entries except swap entries (per David) thanks!
>   - https://lore.kernel.org/linux-mm/20250924100207.28332-1-lance.yang@linux.dev/
>
>   mm/khugepaged.c | 32 ++++++++++++++++++--------------
>   1 file changed, 18 insertions(+), 14 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7ab2d1a42df3..d0957648db19 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>   	     _pte++, addr += PAGE_SIZE) {
>   		pte_t pteval = ptep_get(_pte);
> -		if (is_swap_pte(pteval)) {
> +		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +			++none_or_zero;
> +			if (!userfaultfd_armed(vma) &&
> +			    (!cc->is_khugepaged ||
> +			     none_or_zero <= khugepaged_max_ptes_none)) {
> +				continue;
> +			} else {
> +				result = SCAN_EXCEED_NONE_PTE;
> +				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +				goto out_unmap;
> +			}
> +		} else if (!pte_present(pteval)) {

If you are trying to merge this with the _isolate() conditions, we can do
a micro-optimization here - is_swap_pte, (pte_none && is_zero_pfn), and pte_uffd_wp
are disjoint conditions, so we can use if-else-if-else-if to write them.

> +			if (non_swap_entry(pte_to_swp_entry(pteval))) {
> +				result = SCAN_PTE_NON_PRESENT;
> +				goto out_unmap;
> +			}
> +
>   			++unmapped;
>   			if (!cc->is_khugepaged ||
>   			    unmapped <= khugepaged_max_ptes_swap) {
> @@ -1293,7 +1309,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   				 * enabled swap entries.  Please see
>   				 * comment below for pte_uffd_wp().
>   				 */
> -				if (pte_swp_uffd_wp_any(pteval)) {
> +				if (pte_swp_uffd_wp(pteval)) {
>   					result = SCAN_PTE_UFFD_WP;

Could have mentioned in the changelog "while at it, convert pte_swp_uffd_wp_any to
pte_swp_uffd_wp since we are in the swap pte branch".

>   					goto out_unmap;
>   				}
> @@ -1304,18 +1320,6 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   				goto out_unmap;
>   			}
>   		}
> -		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> -			++none_or_zero;
> -			if (!userfaultfd_armed(vma) &&
> -			    (!cc->is_khugepaged ||
> -			     none_or_zero <= khugepaged_max_ptes_none)) {
> -				continue;
> -			} else {
> -				result = SCAN_EXCEED_NONE_PTE;
> -				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -				goto out_unmap;
> -			}
> -		}
>   		if (pte_uffd_wp(pteval)) {
>   			/*
>   			 * Don't collapse the page if any of the small

Otherwise LGTM

Reviewed-by: Dev Jain <dev.jain@arm.com>


