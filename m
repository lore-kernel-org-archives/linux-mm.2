Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6762EFB801
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 08:21:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D2116B0088; Tue, 24 Feb 2026 03:21:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 080346B0089; Tue, 24 Feb 2026 03:21:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECDB16B008A; Tue, 24 Feb 2026 03:21:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D900A6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 03:21:50 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 697FD8BAB4
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:21:50 +0000 (UTC)
X-FDA: 84478656780.29.096A630
Received: from out30-132.freemail.mail.aliyun.com (out30-132.freemail.mail.aliyun.com [115.124.30.132])
	by imf30.hostedemail.com (Postfix) with ESMTP id 6B56580016
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 08:21:45 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nzzcL8rN;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771921308;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a2mypeU4nOLirbcjVG6GWg/74SRIJqs9Praf4sUkMT0=;
	b=IkdFQiT1YTubhD4Poch1YMbt5+ZHvJNPUmKiwvm++hQqhhpRxOlBg0kM98luF53Jt1PYXP
	c/DGv0QGRpQ2zLi/aylrXCr6wQenKXfZuVbq5j2lAmu/9j+kSb5gLaxm0q+T/cAXv/rE4H
	AYUITM7c7T8Mx9cmP9vtgaAA5KNFLkQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771921308; a=rsa-sha256;
	cv=none;
	b=arzgNEWLWfrh5ATBXAPk+tCB//aXFhv0ad3Isf3EfhhAI0aQL5Ce33nhUokp9B8NxhjfsB
	Yqfg79uomyFpmglFGqeh6PKFdIDJ6Ax6F4ZPLE6bCwiQ8zBYEhuNqaSlgLaKKXZioZoge0
	5gEj/c3n4W4ObJQLNO5pUAYjKgq1ACc=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nzzcL8rN;
	spf=pass (imf30.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.132 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771921301; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=a2mypeU4nOLirbcjVG6GWg/74SRIJqs9Praf4sUkMT0=;
	b=nzzcL8rN1y1sdLLD4V+B85IM8f3/IUissP9QZoNApB+tnyPQFIJYhij+J3cOrc+BEEQIkkeCVsDkmRboGm+br3NGeHaJEK8d8LNtrLyqbUKOwi1HEKI81FFE97Qo31Lc9F4PKukEvmchY2HpXopvoeagLDjq2o2YTn8WCN9MKsg=
Received: from 30.74.144.111(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WziwIZz_1771921299 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Feb 2026 16:21:40 +0800
Message-ID: <ea59d95b-80a3-4f67-adc5-3634016eac28@linux.alibaba.com>
Date: Tue, 24 Feb 2026 16:21:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] khugepaged: convert redundant check to WARN_ON
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, david@kernel.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, baohua@kernel.org, lance.yang@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260219054827.4111334-1-dev.jain@arm.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260219054827.4111334-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: coxy3aegbnrmf4pph7u3f7m3f8xcgo56
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6B56580016
X-HE-Tag: 1771921305-835664
X-HE-Meta: U2FsdGVkX18303n/wSIO8Ba2kx9pXVNpqtt0JWVfUectrLrSFaKbRMg0qdDo4J0B7UFYveFspP4Ccvz/B6TlvQFXyC526uSApr6kG39CBJXAwU4tRPtZI7zfG0Shu8rtfF9grb0plnHcyeStFkVU0ZV9w4genZNRbuCuxYbricisFJWdbjxTK9wp7ZeOcdIYY/JMZXXoSsI05UjHR9cBLJtPeVAWhrHd7V50qQ8mhlYkJ4rYgNv4byRFZDAQkzm1RhmFB0AKCmOeIV2OqvqFpzh8Z8WJnVzX1A6rbE4TeDSrj+9daZu8gWioxv5l7zIxCcUr1yqBe9o+odoG3a+JYjgVW5/bl+ixCBPgeFdWXcKIeH/KPrSiUkl4OYru7TEdlAvXDpUH3AgBb+GaEdRczvhrFkaLFpLOFfSotzKcxZERjDHVyzeoNq63BPZuy3igFc23MSkyeEC1qMh10wjTGRsoDXId4936fLy0JAVhzTyHK+Ebs7jFDq4NwdyeX2oYmOkdugqrVsFCGX25V2fcUrmhhH3LjPY4H9JzKDnYZhYca83jSMt68khYLtAZ6k1C2yliBsvIviIJgA1SFWfdsnTNOuplJ51yeH97I/abzuSGilyTPpxdWor03pA8aATWmcEWUkcFJx5zDSVdUj7Xbx6OYC2hjg9SdhGapvDSgs2DX9UfGDPbUrhySwsUdcj+IwnZYlDvwUldaRchbIxJ3QV5B6XtgIbT/2bv7mlcME/WTSGz//qPT2jmkUCLCxkEWrIux+kyt/frV11PWeejoEYcvwmKrKdlLCrFsl+dX4qOeYKLsjya9oOoH8Csf7Jc8w4DVSuTQiKFid9bldroEHtlTe9CZpVU1LNNcgLTgTayOCr/VNrOAjgYK6KNW+fT1GzfEpn0oopYXU3oJ1rMovEGdL5RfX9CX9XoYyRuQgRBLhartHPsswMih4I9K/DghAeOuxxnoLxN2e5lZIl
 X7n6fLI3
 ch5Od9UYKaikveH2hzWgxsCzBR9kYc7O9beTOMqnvXZ0z/YTazBffDRgffp2iKeXsn5qMreHJlmXTm4BRodxSqZSSL+laSjpljArwnUQ5NMkL1bx5XBvyjAqW65i6eAAgK1sX7az23s1UWA8cFPVyIeSJUsMFAKR8LRKVJt38uuMHysOyG88rMhYAu/Tot0yvGjuAgWi+a4oX58cMd5/Ooq0joJqEW/ULOEncdP48AItFmA53t6jLLn5nyPVmofCg7N6g5sbCsniI8Yg9GoEav9L45EO3+M8BYCJhpBuXLgULcxmdvJpe8UWVNdxnJ67QtSPn0tMWwYCl8zFp3Vnh9e3Dt9U8p58qL1FtyHDh5I9cdQ0ShAhSmG8EEUqVv6GTacJmLjzknCrtnNP4K9ZXQFsVNcsftyhMR1y/RI+JtOYpDgnZfs2/UgL5SA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/19/26 1:48 PM, Dev Jain wrote:
> Claim: folio_order(folio) == HPAGE_PMD_ORDER => folio->index == start.
> 
> Proof: Both loops in hpage_collapse_scan_file and collapse_file, which
> iterate on the xarray, have the invariant that
> start <= folio->index < start + HPAGE_PMD_NR ... (i)
> A folio is always naturally aligned in the pagecache, therefore
> folio_order == HPAGE_PMD_ORDER => IS_ALIGNED(folio->index, HPAGE_PMD_NR) == true ... (ii)
> thp_vma_allowable_order -> thp_vma_suitable_order requires that the virtual
> offsets in the VMA are aligned to the order,
> => IS_ALIGNED(start, HPAGE_PMD_NR) == true ... (iii)
> 
> Combining (i), (ii) and (iii), the claim is proven.
> 
> Therefore, convert this to a VM_WARN_ON.
> 
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Make sense to me. Personally, I’d like to keep this VM_WARN_ON() to 
catch unexpected behavior.

Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>

> Based on mm-unstable (d9982f38eb6e). mm-selftests pass.
> 
>   mm/khugepaged.c | 10 ++++++----
>   1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index fa1e57fd2c469..f27cbb4d1f62c 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -2000,8 +2000,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   		 * we locked the first folio, then a THP might be there already.
>   		 * This will be discovered on the first iteration.
>   		 */
> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
> -		    folio->index == start) {
> +		if (folio_order(folio) == HPAGE_PMD_ORDER) {
> +			VM_WARN_ON(folio->index != start);
> +
>   			/* Maybe PMD-mapped */
>   			result = SCAN_PTE_MAPPED_HUGEPAGE;
>   			goto out_unlock;
> @@ -2329,8 +2330,9 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>   			continue;
>   		}
>   
> -		if (folio_order(folio) == HPAGE_PMD_ORDER &&
> -		    folio->index == start) {
> +		if (folio_order(folio) == HPAGE_PMD_ORDER) {
> +			VM_WARN_ON(folio->index != start);
> +
>   			/* Maybe PMD-mapped */
>   			result = SCAN_PTE_MAPPED_HUGEPAGE;
>   			/*


