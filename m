Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E1D1DCAC5B0
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 16:33:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 333838E0010; Fri,  3 Oct 2025 12:33:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 30B258E0005; Fri,  3 Oct 2025 12:33:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 270388E0010; Fri,  3 Oct 2025 12:33:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1725A8E0005
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 12:33:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA40013B9EB
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:33:27 +0000 (UTC)
X-FDA: 83957348454.11.0644A26
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf13.hostedemail.com (Postfix) with ESMTP id 08D9D20002
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 16:33:25 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759509206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=xub+CkbE/A9SeMiZbmTnZa3HqOqPqFzGn8nxuvyFRQg=;
	b=CcQB2ZFHcKWM5O4rOGi7FEwr396kxvunumzVIZgwX1lGuGMB5Gy7AlXjUspcNt2yyqMNdK
	x0ux27MKgZyIRkDig9y2uGXpTwoayfM0kCmcRraJWVZBidt1ObPctLyi5LpQR01JD2KBt8
	uwrwlBprISyuec9D+wQa3vDNm957ieM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759509206; a=rsa-sha256;
	cv=none;
	b=U5RHmjDSmV/2N/Nh8op1Bq/Eg91FTBRAcJeNX3eOxvCnJjKORljSAhXEdy4vfeSB88XMdU
	xlktgHaU9gczS6omGOIi1rtt6q3woLKLdsykFaEcdeQibdO9VZggZPxtfCiM72rCym96Pt
	YOxSDnXhbKNHw0SiMHXT+BSpw2Pj9hU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf13.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 0F13D1655;
	Fri,  3 Oct 2025 09:33:17 -0700 (PDT)
Received: from [10.163.65.114] (unknown [10.163.65.114])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 4E3AC3F5A1;
	Fri,  3 Oct 2025 09:33:18 -0700 (PDT)
Message-ID: <b8fc9ab7-a96f-4763-9432-8aa8c3c2a87d@arm.com>
Date: Fri, 3 Oct 2025 22:03:15 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new 1/2] mm/khugepaged: optimize PTE scanning with
 if-else-if-else-if chain
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, richard.weiyang@gmail.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251002073255.14867-1-lance.yang@linux.dev>
 <20251002073255.14867-2-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251002073255.14867-2-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: im9hm8h1nrb1euiwz7owwg49gsostxrg
X-Rspam-User: 
X-Rspamd-Queue-Id: 08D9D20002
X-Rspamd-Server: rspam10
X-HE-Tag: 1759509205-724827
X-HE-Meta: U2FsdGVkX18MerrFBqvkVJg/G/jYEJ6WSuiLTrVjQAzCj/buYjOa7oUl+zA7y9gjeb5XKUcbUA/RepWR5BNQyx1GY2s4Ip80FmIICSLFQvV8PsgCIlXgNzh8L46lWedBU/yh2uzAZsI6p33moQ8yfyDOJSR9nSp2LiAxMuk3cMLBU7sfXe/ojmpHhVyPmcXDo72D9P/2trQiKrH9tl/cZ++zse3NeFZeygqFly6RnrG79x6oEkVGroY93BBxYSSDLsvAytmsoqxxNCbps1OONwWatGEDfM7TiijL/6bR/tYcp7D4GjNrGuFOPJlfytM4uIqMrNeok224ZVdzaai7hepTFc28VAevXHvijvpkLd5TXznBtO47wZyzMFlq+1uS+6tBBw8yh0azBMghOVdMp7G3u7A0PYZUC8US9G1JU8tXY77S7b774DihKH7mMgkr4ZI0RyBusJ26/TsznYSW1XhmikgXZfg7qV3uJeNtGwsI2vOxZBRNfv0MX68YlXAw/cfGX/Np0VoEeSH2UCK3hlS2hOKE1W7MiQLcReo3bdQbECBH7yNkQFgIjj3gBP8qGFx9iDtbB/qJzqcoE8HE5bLy5RSxxgQMG3q5cpFeHIWWxMz63hz3pBfec4apZYdU3ByL5W5lYioJknJX0r1I0r/QzGmHXiNtjhGVJqxlJgUxrdP6zfsjURO/SLrAuMvaeBKUz2ZgfhOFCs1ZxFbdUtNyBnRRQvHGyPc2tUpnq6Ro5nI4yubBoMn5UFVzwWwyG0Ll3/gIdNwrcNK7TzQTxrReu6K8zZlwcHM3p85z+ytWAKZegSQUaulb5qX3Ou0e3FkZDEKzU42Me8Mj4GBiMvFHVzq1xGnIXs0xZ8SLxR6HQDQS0twLDaAUgE1gwwD7+Vl7Rb6ueo1zbi6pU17scJO4grjMO0CDDM4uuOWkJ6XqaQun9v9/ZutF1IkQM0ag8C4134Q/Bmpa4NZz20N
 2wZF5xdg
 UmawX2jqZO8lfXW6OlnLz5qM1a3V4EeLqB1w01vgmMLcs4Uv6CI/0bYSZbxKjA+gWdQKWav6RkxvTStnKPSwRqK3N+TxEeF41DKXx790wyyjj58bDc76YXjcleT7HXZQsrlHrbDtKNJ2AzOyxMlizQIbMtqmU+JqkMsUX1xI4Ndyxe2CoQpqs9YvHvRcTUhzEph/6Nqv4q1/ObjOwUd7IueOSc/1HM9UgYgxYaAQeNeP2xzanfsHPw3aY0ze0T5hAOrp7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 02/10/25 1:02 pm, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> As pointed out by Dev, the PTE checks for disjoint conditions in the
> scanning loops can be optimized. is_swap_pte, (pte_none && is_zero_pfn),
> and pte_uffd_wp are mutually exclusive.
>
> This patch refactors the loops in both __collapse_huge_page_isolate() and
> hpage_collapse_scan_pmd() to use a continuous if-else-if-else-if chain
> instead of separate if blocks.
>
> Also, this is a preparatory step to make it easier to merge the
> almost-duplicated scanning logic in these two functions, as suggested
> by David.
>
> Suggested-by: Dev Jain <dev.jain@arm.com>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
>   mm/khugepaged.c | 12 ++++--------
>   1 file changed, 4 insertions(+), 8 deletions(-)
>
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index f4f57ba69d72..808523f92c7b 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -548,8 +548,7 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>   	for (_pte = pte; _pte < pte + HPAGE_PMD_NR;
>   	     _pte++, addr += PAGE_SIZE) {
>   		pte_t pteval = ptep_get(_pte);
> -		if (pte_none(pteval) || (pte_present(pteval) &&
> -				is_zero_pfn(pte_pfn(pteval)))) {
> +		if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {

Should have mentioned in the description that pte_present() is not required
here, so removing it.

Reviewed-by: Dev Jain <dev.jain@arm.com>

>   			++none_or_zero;
>   			if (!userfaultfd_armed(vma) &&
>   			    (!cc->is_khugepaged ||
> @@ -560,12 +559,10 @@ static int __collapse_huge_page_isolate(struct vm_area_struct *vma,
>   				count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
>   				goto out;
>   			}
> -		}
> -		if (!pte_present(pteval)) {
> +		} else if (!pte_present(pteval)) {
>   			result = SCAN_PTE_NON_PRESENT;
>   			goto out;
> -		}
> -		if (pte_uffd_wp(pteval)) {
> +		} else if (pte_uffd_wp(pteval)) {
>   			result = SCAN_PTE_UFFD_WP;
>   			goto out;
>   		}
> @@ -1316,8 +1313,7 @@ static int hpage_collapse_scan_pmd(struct mm_struct *mm,
>   				count_vm_event(THP_SCAN_EXCEED_SWAP_PTE);
>   				goto out_unmap;
>   			}
> -		}
> -		if (pte_uffd_wp(pteval)) {
> +		} else if (pte_uffd_wp(pteval)) {
>   			/*
>   			 * Don't collapse the page if any of the small
>   			 * PTEs are armed with uffd write protection.

