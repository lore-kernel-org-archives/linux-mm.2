Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F2D88CAC5B0
	for <linux-mm@archiver.kernel.org>; Mon, 29 Sep 2025 10:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 59E298E0003; Mon, 29 Sep 2025 06:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 575B38E0002; Mon, 29 Sep 2025 06:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B38A8E0003; Mon, 29 Sep 2025 06:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 375FC8E0002
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 06:10:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D0788B8663
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:10:26 +0000 (UTC)
X-FDA: 83941868052.22.A2FE526
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id C6785180015
	for <linux-mm@kvack.org>; Mon, 29 Sep 2025 10:10:24 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZLIgf0R2;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759140625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rV9QK51rsx4eLWCMpcFHElTpfQGO2X4unrpezssK7M4=;
	b=kgNPDVutYSNwBmxa7lTjKh5JTPtrLsaz2eyE03nND/dg3SuNqoUEu3Lpa5inPgjk5T2yhI
	vCkYnHPeJK3ABhslk1+yy7E05Lej+0/0W36MGP7zJgO//q7bYdiaywG2e4PCgjS1xQoyw5
	X4U9nT8VLEASW52bg30xxHaFV0Q9rwU=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZLIgf0R2;
	spf=pass (imf24.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759140625; a=rsa-sha256;
	cv=none;
	b=iaUItpdwUhJE4dLUFMZl1UczcHl+CuCc9Og0wF7nO9uhQ4ajkDFkKNXDvUibnXWaFiLuoI
	s1skcsHqrMxCHUxPSAiLB0ON4SrLU52w2bINga2CEN6labTyD+lJ6qhepxaAk3nCQbivRS
	l471vXiTLMAJKJeIWWosSpFDZWLsv3k=
Message-ID: <c41e3890-dea3-4ab9-8913-5bfe9665facf@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759140623;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rV9QK51rsx4eLWCMpcFHElTpfQGO2X4unrpezssK7M4=;
	b=ZLIgf0R2iCYlSrfsjOq/7WtFyFLGOg/YA6lT0DXwDmN/8fZktfpgKoMqf9JmwBwFzqUmGM
	SPwbJ2r19RNrqWXAn2BReT26CAYlM6ZiSrGo3pztvreXdbnecNuoeLH/OL3mLrkgqsLZRQ
	G8kDE47McoqbJdkRDKB1ELIhptJl4k8=
Date: Mon, 29 Sep 2025 18:10:10 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 1/1] mm/khugepaged: abort collapse scan on non-swap
 entries
Content-Language: en-US
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
To: David Hildenbrand <david@redhat.com>
Cc: lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, baohua@kernel.org,
 baolin.wang@linux.alibaba.com, dev.jain@arm.com, hughd@google.com,
 ioworker0@gmail.com, kirill@shutemov.name, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, mpenttil@redhat.com, npache@redhat.com,
 ryan.roberts@arm.com, ziy@nvidia.com, richard.weiyang@gmail.com,
 akpm@linux-foundation.org
References: <20250924100207.28332-1-lance.yang@linux.dev>
 <1282de5a-3dce-443d-91d1-111103140973@redhat.com>
 <69621b58-5142-48ea-9dd8-6baed69e50f8@linux.dev>
In-Reply-To: <69621b58-5142-48ea-9dd8-6baed69e50f8@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C6785180015
X-Stat-Signature: rxtb1a6qn6zsspn631a8frum4a1c3479
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1759140624-443921
X-HE-Meta: U2FsdGVkX184943pxI0U9cB8h94pIUT3J9bqkFDZeU8xgruRUpsRdaufGl+nWkL73opc48uw5Hj+I2413Sd4mSwcOi6aMbOP3t+mDomHirmRWJScw9zyhGDkwggMt62czBmgXHC8h2iWvR6lgH+jmX5VDi2alW0u0XeFhR3kuvo37XNc6cP5nb/BilcwvlN5btNVbypgHYFyXtrO3HXD8pKbD0mspudndNmGL/kIchMv4FpZZ8hbKRLY6nk6cMCUY0GOWpu8C4y+ia/NWYuBFlJisbMUoojrjmv3iQKEZUWj17ot5Gbm659P4gkI+SJF/e4BhpQgfK9RKGRs1SonyIC+7xCMChrDpvsVXmT3pJAv5YDdJArrQvpaqZ4CTbM6rTw7GnCo9Uqcth6Tf+NAQNfKlotrtcqAf62MkMofcw5bGfBQNMrtlV+fhoi5yPKHmZ0xGlq5/p4Xol9nFxNg19Dv9wkuzzM1Zw59LOZK8r6Lu37Dc1T/bPElLvGF+bXmEByxnqNFDn1/oXVXckshdxWGr+5Z1mn83P3EFUzz8kF9TZYrcBbr4csem/W4bze+aKmOxy8R+CKZsAY9Y0ogt1qPuoDIJcHfD5qnAPLpe9+SpQlXLknWJ8SpdEER0BUHpWuX7DslXWL5V+UzVsG0LD1aoMa4StnbFW11MZJZPTNhk5S6KD2r1CA8WxjP09FK35Ti55lujtfxlFyBzzD2Met6u7l688cZQguztUVoVSndQh1LNbCzFEO1EMIAjEcwO1Eipy2zVyhxsSSAFqNlmLkSvUijiZmgSvgPrKOUY6MJ0UR34YCJ7MWTfUotc0f/D+XrPIYakf39hEWsWOISS6fm0PvseqHsBkfaXTMB7anK9n+dC2C1gNjS1Sr0n89/Qn7+TUwGGZZFPDD/VOKz3jJ72Sr7Oy9Mis75Ex+lV71ctbYPGdoQKUGY0dXSlMAtFBZpC4i+dANujrTKIie
 /POrhjoX
 /7ZpoNK1ct+YE3KqkWx7v7I9F1OpvZnZ9m1CifhYYRnlfv8KHrsu8SLXKE67g2spbVj1ysss8mWN/Yq80tKvrbfIIklXMyHqP+a+sGZgpl8Gzn+xV0TDoTtTzuUnEwmHbLcEZMm93yJkN4qZRb70tE55WMxuzBkHntTe5G0XGMLR88i7Cage+QaCwrdzssIfYXb5ST1PCi0jE2cgRvWsxbmJTSFkoT4T7u4UBZiGAxrYR7u8QWV0lL5Nelq35hyLtNLHUFYPVar441Y19YwyOr4Cp9tGFjzzB+HjgO4qvkmVl8DM1Dz28wG+2BSxZD8ulQ3JIDVq+rnfCWAIAAZM5/03T/Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/9/24 19:47, Lance Yang wrote:
> 
> 
> On 2025/9/24 18:10, David Hildenbrand wrote:
>> On 24.09.25 12:02, Lance Yang wrote:
>>> From: Lance Yang <lance.yang@linux.dev>
>>>
>>> The existing check in hpage_collapse_scan_pmd() is specific to uffd-wp
>>> markers. Other special markers (e.g., GUARD, POISONED) would not be 
>>> caught
>>> early, leading to failures deeper in the swap-in logic.
>>>
>>> hpage_collapse_scan_pmd()
>>>   `- collapse_huge_page()
>>>       `- __collapse_huge_page_swapin() -> fails!
>>>
>>> As David suggested[1], this patch skips any such non-swap entries early.
>>> If a special marker is found, the scan is aborted immediately with the
>>> SCAN_PTE_NON_PRESENT result, as Lorenzo suggested[2], avoiding wasted
>>> work.
>>
>> Note that I suggested to skip all non-present entries except swap 
>> entries, which includes migration entries, hwpoisoned entries etc.
> 
> Oops, I completely misunderstood your suggestion :(
> 
> It should be to handle all special non-present entries (migration,
> hwpoison, markers), not just a specific type of marker ...
> 
> How about this version, which handles all non-swap entries as you
> suggested?

@David

Gently ping ...

> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 7ab2d1a42df3..27f432e7f07c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1284,7 +1284,23 @@ static int hpage_collapse_scan_pmd(struct 
> mm_struct *mm,
>          for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>               _pte++, addr += PAGE_SIZE) {
>                  pte_t pteval = ptep_get(_pte);
> -               if (is_swap_pte(pteval)) {
> +               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> +                       ++none_or_zero;
> +                       if (!userfaultfd_armed(vma) &&
> +                           (!cc->is_khugepaged ||
> +                            none_or_zero <= khugepaged_max_ptes_none)) {
> +                               continue;
> +                       } else {
> +                               result = SCAN_EXCEED_NONE_PTE;
> +                               count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> +                               goto out_unmap;
> +                       }
> +               } else if (!pte_present(pteval)) {
> +                       if (non_swap_entry(pte_to_swp_entry(pteval))) {
> +                               result = SCAN_PTE_NON_PRESENT;
> +                               goto out_unmap;
> +                       }
> +
>                          ++unmapped;
>                          if (!cc->is_khugepaged ||
>                              unmapped <= khugepaged_max_ptes_swap) {
> @@ -1293,7 +1309,7 @@ static int hpage_collapse_scan_pmd(struct 
> mm_struct *mm,
>                                   * enabled swap entries.  Please see
>                                   * comment below for pte_uffd_wp().
>                                   */
> -                               if (pte_swp_uffd_wp_any(pteval)) {
> +                               if (pte_swp_uffd_wp(pteval)) {
>                                          result = SCAN_PTE_UFFD_WP;
>                                          goto out_unmap;
>                                  }
> @@ -1304,18 +1320,6 @@ static int hpage_collapse_scan_pmd(struct 
> mm_struct *mm,
>                                  goto out_unmap;
>                          }
>                  }
> -               if (pte_none(pteval) || is_zero_pfn(pte_pfn(pteval))) {
> -                       ++none_or_zero;
> -                       if (!userfaultfd_armed(vma) &&
> -                           (!cc->is_khugepaged ||
> -                            none_or_zero <= khugepaged_max_ptes_none)) {
> -                               continue;
> -                       } else {
> -                               result = SCAN_EXCEED_NONE_PTE;
> -                               count_vm_event(THP_SCAN_EXCEED_NONE_PTE);
> -                               goto out_unmap;
> -                       }
> -               }
>                  if (pte_uffd_wp(pteval)) {
>                          /*
>                           * Don't collapse the page if any of the small
> ---
> 
> Thanks,
> Lance


