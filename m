Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6B750CD8CA4
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 13:16:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA6D36B008A; Tue,  9 Jun 2026 09:16:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D58186B008C; Tue,  9 Jun 2026 09:16:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C46526B0093; Tue,  9 Jun 2026 09:16:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id AEFC46B008A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 09:16:18 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 588151205DE
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:16:18 +0000 (UTC)
X-FDA: 84860422836.19.FCAF2E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id 89B034000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 13:16:16 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cpe2Y/6H";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781010976;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Md9uYTdoXt+1igdHcxOfaMQ8e9aV/4PGZd0SXvvZtwI=;
	b=LMOyyE8MI2wGdQQFDrhU+d1RNATx0ILHhIo8MMOPXFZ7NT+krzRQ6DopQArJHiZb+n1ZXA
	y7vFegDRNRTiQYWc8CYKZDLSZnq8/wOTWuhosIOILI2irLa/mjYkU2l44Zb/4Atr1NMZw8
	CMNbzElriWh76RNN4aOndXKknmLn+/c=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Cpe2Y/6H";
	spf=pass (imf04.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781010976;
	b=TvVAsZvnbn+zd0T2nOZjgsSOcOtZUOXMCWbnK6Nioqcxpgb3Acs4mBQkgH5ecR0N2wWq2S
	nSTXcvgeB9/F1qLAThNx7G8Q7oxC9J1ig80mwU5CZ++eCGpVGiMiQmPx1tP3d6jPVTkdQP
	w5f4GQ4ZtKESeSf5S6HdE2wX9MZuc0U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A613F409A4;
	Tue,  9 Jun 2026 13:16:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF2D41F00893;
	Tue,  9 Jun 2026 13:16:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781010975;
	bh=Md9uYTdoXt+1igdHcxOfaMQ8e9aV/4PGZd0SXvvZtwI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Cpe2Y/6HUYWDsZsW2QykjUkISeABRkT4830pDdu2CKDfQwUI0SK45H/EMnnzau5i1
	 1VQdjtBFHxuD/jI26wdo3UX9EhC1LlG3IlhhblWMXpLL2pY0VC3w8AiQkEyiwf3R5n
	 sV/mysie5tu9V/ITJvSd0+hHrbw+6goH9mBaCtSDE4av9m5OGsRoSfhUGenhTfWNn4
	 qsABEwBNMMM86qwY+CGQBTzdOncxKLOBsOSZ1lzgRD4arrWIO+xPijbCf8UA0Z9b2Y
	 cxeQRWDdwJmAJiPT1x6pPlr7SpexW7oG00mAX6u4JxjilZoXgBuGbceFLm6X+0eYtE
	 HvhwzNEGjv99w==
Message-ID: <7d081256-5b30-4e3c-b948-85ba76ad0e1d@kernel.org>
Date: Tue, 9 Jun 2026 15:16:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-unstable 1/1] mm/khugepaged: fix PMD collapse swap PTE
 accounting
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: ljs@kernel.org, ziy@nvidia.com, baolin.wang@linux.alibaba.com,
 liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com,
 dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260609120443.71864-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260609120443.71864-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 89B034000C
X-Stat-Signature: eoytjskni41hc6uxeiqwaehwh7z83bwm
X-Rspam-User: 
X-HE-Tag: 1781010976-248879
X-HE-Meta: U2FsdGVkX19hp5c+IFQMcl43dNHnLpnVpIy6TNo9Z1DNs0PJt58JYrbUOC8TVsSVs/OQ8WDv/8gwOLaVP1g41JwWicOKiy2O3/nBmihgpqBdS15XhErxY/aTPRVLNHZ0FvsLLQ29Hz/4ubEYrZh3dWBpgV/YO3jTCOtULLGuZjDhn+FHB9ToUV4TDKHPnt5GhAgHolGh+aKKaxglt5VeMNOL2b9Dzvr4rxqNMbyuBycMDhg/vmVfp5t5Kze6TL8ooynyZa2a36mDrGhmIIQcMrtpLs4UJduR6KfK9AzaereaZ1Wzto6c9DSYMvasrsjkt2MvMG3wWfIVpdH7fi1v9NtUvQndXPw8ngTNBjc4NUstHESyS91xiqew/77k6FykUZdbVrdTMVGdCZLr5gfbrSH/k0eibJor5swhiyPu9a1W5FEG84sRNIPwAE0MzivIJYjPH61zZ9CzR3ONNgmPaInOP0PqV5BpbuIRZ2TxabamAGRo6Uty9BkIpy8w0sQXyZP2ZUP77M/Ef7HMtumiMZxMy3mcgZIdqSKRQ79/8MnNF6Z1lTJpW1u3FewnqLcvk+bJIZtfEAra/yGuN/MdTjYZJF20/cqn++m63hgLqAcQVYWDPg/I8IxVtw4NE1mNBMBZsbebItfYR2YB6UtJtZPeaZWKtB9OQuVJ5bbYOu1NNedT/Od55bx6SdbTvcjvaxp+U0P4linOUzMfPBvuw5FIQ5jnsYhxrQbZcH5st9sHGgBbFSvEJrnPgK897Bxc70xTVWHmzcR7ZYPQ2hnIrMQqRzGvGZfocc1nWp/GBNls1aQ5Yctj0wnk8x1XKcukxd4x4jBtVBVyUw79AzC2bAaU6pIo9cX3mPE2SUml4yQ/8szul+qU09KArQb3lZVjvcXU9p2ACF8W0a71hk9BC4TcFkIGm0GMz6qBP/KDGXS2+gPTGz7IBH5EMqyIyk07IYMu5PE59a3rNZ7iILa
 VK0BWe+s
 SP9LiCCGewin61s49jvfmsR3Ox4km7vrBFfnEonGDGwMi7faj47crunyPVNC8HJskfS+C7/EG5FY0FLq820DSXacuHvng1sbGrmjhB5gY1UaNeOk/lhg4pVN5lYhSNn786UM2QX+ocYbl8WlXZUkcV7cxt1jBRJNPB8iL4IBkR1/YKb7oFK58sjfgLUAzNNj2tFxR7DeXoYUBK4d3MUESLtYppHu2FSjp51tVfnF26TuvhWe6F1UlB9IxYYCpPiXdw67xp+DmwLQK6Nx5DJpbT8GNThIACYKsAZBrrR62YPT9Kt6CK3WtNUrvNZWEDO/KZQI+FG6FK6QTlA8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/9/26 14:04, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
> 
> mthp_collapse() uses mthp_present_ptes to decide whether a range has
> enough occupied PTEs to try collapse. Swap PTEs accepted by
> collapse_scan_pmd() are counted in unmapped, but are not represented in
> mthp_present_ptes.
> 
> When lower orders are enabled, collapse_scan_pmd() relaxes max_ptes_none
> so the scan can cover the whole PMD and build the bitmap. mthp_collapse()
> then checks the PMD-order candidate using the bitmap.
> 
> With max_ptes_none set to 0, a range with 511 present PTEs and one swap
> PTE no longer reaches collapse_huge_page(), even though PMD collapse can
> handle swap PTEs up to max_ptes_swap.
> 
> Account unmapped PTEs only for PMD order. PMD collapse supports swap PTEs
> through max_ptes_swap, while lower-order mTHP collapse does not currently
> support non-present PTEs. Keep non-present PTEs out of the lower-order
> eligibility check.
> 
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---
> Sent separately, as discussed in [1], to spell out the PMD-order swap PTE
> case. Patch [2] is still only in mm-unstable, so no Fixes: tag.
> 
> [1] https://lore.kernel.org/linux-mm/CAA1CXcD7WAiA1b9GTLAuNZ+kHaFx0SzZwpBkqAZ=s+RHsTUaow@mail.gmail.com/
> [2] https://lore.kernel.org/linux-mm/20260605161422.213817-12-npache@redhat.com/
> 
>  mm/khugepaged.c | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index b12187709f6d..617bca76db49 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1508,6 +1508,14 @@ static enum scan_result mthp_collapse(struct mm_struct *mm,
>  		nr_occupied_ptes = bitmap_weight_from(cc->mthp_present_ptes, offset,
>  						      offset + nr_ptes);
>  
> +		/*
> +		 * Swap PTEs accepted during the scan are counted in @unmapped,
> +		 * not in the present-PTE bitmap. Account them for the PMD-order
> +		 * candidate.
> +		 */
> +		if (is_pmd_order(order))
> +			nr_occupied_ptes += unmapped;
> +

LGTM, there is a bit of opportunity for cleanup in the future :)

Acked-by: David Hildenbrand (Arm) <david@kernel.org>


For example, as we no longer have the VMA here, collapse_max_ptes_none is
imprecise in uffd VMAs. We might try collapsing where there sure is nothing to
collapse.

We could likely handle the userfaultfd_armed() part easier: some indication that
we must not have any pte_none() would be sufficient.

Also, I don't see a good reason why uffd would not be allowed to collapse with
zeropages ... it's really just about missing faults due to pte_none().

-- 
Cheers,

David

