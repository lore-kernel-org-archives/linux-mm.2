Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ABCECFEE4C4
	for <linux-mm@archiver.kernel.org>; Sat, 28 Feb 2026 04:44:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A76116B0005; Fri, 27 Feb 2026 23:44:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24466B0088; Fri, 27 Feb 2026 23:44:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9059E6B0089; Fri, 27 Feb 2026 23:44:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 80C956B0005
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 23:44:22 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E185B13BAEE
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 04:44:21 +0000 (UTC)
X-FDA: 84492623922.01.836B49D
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf29.hostedemail.com (Postfix) with ESMTP id 0E25B120005
	for <linux-mm@kvack.org>; Sat, 28 Feb 2026 04:44:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pvUr+SNg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772253860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jY2ApfuCjEG20j8TkQHYrlMehNjrQ7bPhuWc9VDU1ws=;
	b=pCDCqG55gK23ux9aErA9f+HccSVPQ+xtA8Dep4Nij7nGki2lL4rVhwMHVpabAoiHWDM1A8
	SG4m6vu5iQq20oKMJWgxNYukKRlp5NXR/D5VuoqZoVQ97CBIx/RA6B778lICm8jQmoc//c
	Zzior0e6WdMkva46ZY4b1tN2C/utqpE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pvUr+SNg;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf29.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772253860; a=rsa-sha256;
	cv=none;
	b=pfIqz2r/a80IaAZ1GbUi9sUG08gJER4xcUkB2LB8VdyCL2BZVCV+oQbAQ2253Z6Q88Lrss
	iVF8bWhZNvd7MndhJrNn95+wIXpVEITeaSDqmX8BFDTyVNRGBUhmdLznnL6cCxDsQsIMIc
	Ovgpdmqw99BCMWXNXoDaBGoLXMqmuos=
Message-ID: <1f12f6f4-4d35-486d-b6cf-2672ae2c4979@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1772253857;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=jY2ApfuCjEG20j8TkQHYrlMehNjrQ7bPhuWc9VDU1ws=;
	b=pvUr+SNgFES/em2Zq2o641Pnyw4JGgWAe8XpZNJNc/M5WHzzzov/cdUQztTLF7staxU5ek
	RoAhE0lEl86BwsdvUcCFUm53ONNjSmgysdrgBJLHn9hMnkHbz18hwlT1gnZXWAktOxXgVE
	s9qsVtkKrEvBoBD/AvD7Kfw/tJ31zMk=
Date: Sat, 28 Feb 2026 12:44:10 +0800
MIME-Version: 1.0
Subject: Re: [PATCH v2] khugepaged: remove redundant index check for
 pmd-folios
Content-Language: en-US
To: Dev Jain <dev.jain@arm.com>
Cc: ziy@nvidia.com, david@kernel.org, lorenzo.stoakes@oracle.com,
 akpm@linux-foundation.org, baolin.wang@linux.alibaba.com,
 Liam.Howlett@oracle.com, npache@redhat.com, ryan.roberts@arm.com,
 baohua@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260227143501.1488110-1-dev.jain@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20260227143501.1488110-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 0E25B120005
X-Stat-Signature: uiyu13qs95mca585cogxhtnegrhbk7ra
X-Rspam-User: 
X-HE-Tag: 1772253859-602977
X-HE-Meta: U2FsdGVkX18+3Kbb+W0oAnXEpCDBCgU9kJ96GQO7vmm+2CmJQ+DvJR9spysjJfNpFAG9B+XmQq2IYvtXwTbaJilrhkIi/txhNJ/CaAwv9x7AkWiAgmdsogDJvgBnLFLJeW1JHij81iXlTINwojAofKInGFeG1Nbr7G2xSLoIUODO/Zl3gfYP5xRrCMjSOUcaEmPp0nHWJIJPWOCZtXo0cToi8AGyny0oCTeF0gk2THdFLucvw2SfxHz0bS9o+MA3naQSGo4VfVz6JJmCjmEZ0oC222lO/U4mn/4Sauy/XGh3Vk5if+3bT7MR5I8HyN+UyNLuxQVCqKNVNaaiXA5l8ac+4RoeoX/3lf8xpVP05kiH6dVwpMZCzsz/p3BDjfuaG8D+t0SBkIKINqgXlMPTHFKVQ3kHXSVup7ihS3kywVj7/wMfZnvS8IG2hBgM3kt3N4wfWZBg8ha6rn75tQCoZb6H/t8LO8GcU8a4GT3qbM7ND6IBYimYbaFpu+VArRjaZ8mlqXMLFvyJTAF8zKQzFml2hpLaR964a+PxgM4JUzfRQQOVzRr0p7i8+0uj0wkfVPAFNvE1qCXf/pSi94n3jE/mdiwyXt2UgAZoL9Trw8wlkUNxoShNxcDj2kCgywQ0sv3hqPIWB0rdS0SgAyJTXObfSV2wS4vPkUd+kbxrmhZKTqdt7ndeM+vg/8mm5RBsnlN0X7+w0xI3+3KTEOVeeSGqTQeM4Ewc8gWsrpr7DxLBSCKeIMmc5F9os/wL8wNGvcw1BVt2FZX1N37Qg4SozpXTS1aqDKej4qiKQOsboecrMglFPGPdLPM3S5VGmYxPMP8wZDeJZl8ZD6d6fRA3tCFmIF4vbifwy4LmKDRGQU4eUrl0JDNd9NJGFb2/LhMTQ9o27EsZ3NbJeBAoYpE/WDiIhl6pnpzXi77+iiyuPmKfbxY136WveddwvHhpfAa4wi+eJ9GbfuLXWjlnd/E
 9JEtcJmM
 Irov+dLRp04DesisTp2sEcL3sQoI8SxEQXoFLVOf+UtEy+DHgQ0+WTkY4tza4slWsrC6qNDwVCIsD4J3k+NIM7jP8z5mr8bAiz501WbE8oENSHqRvVhJpzylviWixsPpiwOoVQPTd3Id04dAuwqSgc90oW6Yzs5cN18EBAJfoF883s/h7vJieJmqfe+mtyArFkVxIwgS1Y1E40vvhuBYrKDzLIDjlU49GiPZUBRgMYgJqddzLtLDa3XLQkb8aar5op/Bog/BDZwADse46CAHuXXDfbkTE8lCGAC3T3cCH44W3SQR18RL2MaGQqwxsSHSWS7L+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2026/2/27 22:35, Dev Jain wrote:
> Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.
> 
> Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
> iterate on the xarray, have the invariant that
> start <= folio->index < start + HPAGE_PMD_NR ... (i)
> 
> A folio is always naturally aligned in the pagecache, therefore
> folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, HPAGE_PMD_NR) == true ... (ii)
> 
> thp_vma_allowable_order -> thp_vma_suitable_order requires that the virtual
> offsets in the VMA are aligned to the order,
> => IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)
> 
> Combining (i), (ii) and (iii), the claim is proven.
> 
> Therefore, remove this check.
> While at it, simplify the comments.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
> v1->v2:
>   - Remove the check instead of converting to VM_WARN_ON
>   - While at it, simplify the comments
> 
> Based on mm-new (8982358e1c87).
> 
>   mm/khugepaged.c | 14 ++++----------
>   1 file changed, 4 insertions(+), 10 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 5f668c1dd0fe4..b7b4680d27ab1 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2015,9 +2015,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   		 * we locked the first folio, then a THP might be there already.
>   		 * This will be discovered on the first iteration.
>   		 */
> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
> -		    folio->index == start) {
> -			/* Maybe PMD-mapped */
> +		if (folio_order(folio) == HPAGE_PMD_ORDER) {
>   			result = SCAN_PTE_MAPPED_HUGEPAGE;
>   			goto out_unlock;
>   		}
> @@ -2345,15 +2343,11 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm,
>   			continue;
>   		}
>   
> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
> -		    folio->index == start) {
> -			/* Maybe PMD-mapped */
> +		if (folio_order(folio) == HPAGE_PMD_ORDER) {
>   			result = SCAN_PTE_MAPPED_HUGEPAGE;
>   			/*
> -			 * For SCAN_PTE_MAPPED_HUGEPAGE, further processing
> -			 * by the caller won't touch the page cache, and so
> -			 * it's safe to skip LRU and refcount checks before
> -			 * returning.
> +			 * PMD-sized THP implies that we can only try
> +			 * retracting the PTE table.
>   			 */
>   			folio_put(folio);
>   			break;

LGTM!

The proof is sound, the combination of the loop invariant, natural
alignment, and VMA alignment requirements indeed makes the index
check redundant :D

Reviewed-by: Lance Yang <lance.yang@linux.dev>

