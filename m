Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DB125C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 12:03:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60526B0088; Tue, 28 Jul 2026 08:03:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B114A6B008A; Tue, 28 Jul 2026 08:03:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9DAEA6B008C; Tue, 28 Jul 2026 08:03:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 751D76B0088
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 08:03:04 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id ED356A14C6
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:03:03 +0000 (UTC)
X-FDA: 85038049446.23.5DCA861
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 4C48520007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 12:03:02 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kJT3l3QX;
	spf=pass (imf03.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785240182;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ngSI3Q4vIhFKWjmDx5jZEvBPeOv5VUXzzg0prABQgHM=;
	b=IWEPJcHUdaQfhIhLSVAPh1cqmSTMpcavpJ+8BRGNeR+xrl3+V0CSVs9LZUFqdB+5i3Konk
	76IcXfZrbfVEcrNz7BKdhsWNOwlriKCZTWqpd46h5zjmeKrE5Lf3Cu3npCLtRagIW40s86
	sicZLYx+So2WKB0vPG4d0bKu1yLRmKU=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kJT3l3QX;
	spf=pass (imf03.hostedemail.com: domain of will@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785240182;
	b=kDhEZLYdijEbcuHuhJTsg5LnJuUwH9VmEkGtfvDulZnlnFHIvGFL0sbFI1DKWHEra2HGAH
	ZdNODNrvpWtHt0Kd70Njkwf71aLemswEfBsWdceumYjlqRB4W3US12APu8LEwmZmXJqv8/
	xn4FhKf08SYExNoRRlWnpgaSsWwPt4U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 69293438D4;
	Tue, 28 Jul 2026 12:03:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230131F000E9;
	Tue, 28 Jul 2026 12:02:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785240181;
	bh=ngSI3Q4vIhFKWjmDx5jZEvBPeOv5VUXzzg0prABQgHM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=kJT3l3QX0SOCL0bfIt294zpl70CdxnCDhs43jrRz5jlxB5zOfFptE41eAqWlCMn8B
	 pfsuwwn1vgSr2MObaC2UlPqlj6Z8RSdDJMA42cAiRnkYhLCquk0hvu1A5SLuRkKcwW
	 x0UAdTzr/a4HRssfbPQA0+RQV2Zgc+AShibCbTRQ4V7hBbUSCnwEjaLUKA6kkjcP4h
	 jJz7VDcmINqhx3QHd5Z+6FXUek2qTlnb2K9dGhL/ckYlVqgJxrLWngwxP1pnNqHWok
	 NcSA8mYorOqBkGj6uPp2dKvdujI5hjNkaFzA70ytIz0gRBiSDOwXiq5aVCYnVDZ/Jo
	 EdM1gq39lqYmg==
Date: Tue, 28 Jul 2026 13:02:54 +0100
From: Will Deacon <will@kernel.org>
To: Wen Jiang <jiangwenxiaomi@gmail.com>
Cc: akpm@linux-foundation.org, catalin.marinas@arm.com, linux-mm@kvack.org,
	urezki@gmail.com, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com,
	anshuman.khandual@arm.com, david@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
	rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com,
	baohua@kernel.org, Wen Jiang <jiangwen6@xiaomi.com>,
	Leo Yan <leo.yan@arm.com>
Subject: Re: [PATCH v7 1/7] arm64/hugetlb: Extend batching of multiple
 CONT_PTE in a single PTE setup
Message-ID: <amiabgyHSz3ZYY5k@willie-the-truck>
References: <20260715120813.3609949-1-jiangwen6@xiaomi.com>
 <20260715120813.3609949-2-jiangwen6@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260715120813.3609949-2-jiangwen6@xiaomi.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 4C48520007
X-Stat-Signature: f41n1jemtexxhhco7ezci45f7r64yfzm
X-HE-Tag: 1785240182-993532
X-HE-Meta: U2FsdGVkX191EzRXKEKBgwKSCURHdkZlmMh3VDts89+9bGrHzBvNnGvWnY/uDkwp30VQ3ld/EIYf8FmP7UTj7DG755IR8HyR6uQlJrfw4C4znqzHjXzefLuLsUAA3m9K/wus7U1enMpgYdLp0cdK2BUGsjIpRVuWJvviS2200WjGeJ67neOaIuq7g7s889k3QQTxUfpCOHUGniLfh7gooMHma6HFhvGSIdCdvm/QOPidZzT18T3HIx6nPMKa85H1OqjGgpEeS5i1Sorvlknw47nt4+dlkq42aDj6iX8ZezkQAabR5YelJ6uKGriQNdSxQq5Vhcol5qRAzuk0tKfYzFufBShMYOt5YQO0TtsuB8iD5yDb8sNT3iowOuQBiwEWbkO5XlBAiLeuwJgW4YX8CFa70MmLZzFLrnlGd1LF/BR0OXzFl2rjlsM2sb9i8urAbmQSKW82xmSkd8dPqRWmKLQRVgfZ/ciVSnEBKhHP+AUrQP5QUwNVAp27oCE4bc7g/x3Mm1FoAt+flZWsymIEZrmSONhDm/Hlz0a7d3roQtxg4T+2ECXS8dOc/a1AYfYEupyCbIs2qosudK8kpgkeNWsMBO2NPvLVmQM3oxTIWO1J0OeFzJ1TrV+qomX5+P1NJWuo+o9sCvB7uys8bNTnN5Tlw9QI12SGXntnADofEJV1/wjJ5ha+D2mAF8KmVcxmmYZOb98peq/JTB7T7Vn9h2mJ2AeUU1qXWVhpsY/pTn3Oe9Mf7ZLRpDY/8FvhfzB9NBnr2pTmNtAdyWUl/UO8sJOF1SWHLEszSII1LEQakwvvgu1n/CUgB0nu+fexdnsEr8tSeFXm9N8M90VjWh/m22T+VcqKMBL+6Ej9mx8K7+WUWAb6NY2qRERP7r0i0Dcgc00OR/L6I7bSgWc0feKO3x4rM0rVMSakBneqCho8WGKAQSPGZjKhKMP9OnFIE+EMTcMliHdZztLCj/2Qv0T
 5d935UIZ
 GD0Vnjjkk3zcPPN+dKqRSugUTu7qtQgYii7llj3Qui6oTm6Gb/xYvjGrT+LEgM3SxBBlPdVjEbsh5isONPXspuP+WmP1Z12ckJG1mrwmx+THMv8/SJfP7Tm5X7gGVf7j3ymKnYaT1YfryogO3147wGFrY9b0aQgcHRgqVog/b4dMR1qYgGMrUrAwPzfXcsNhTTVQ0wx1JPSFc6bNQN+0kIx+EE8+k6dBAtnnKzHHTTUVLn9aeGejzTEE1jdgRTnpdy4My7O4nPH6n4USFepKUdx8foxOj9pDrnqeEF1zMPGu9KZO+n6pmgG29ApX1atNV4X6FugOr5pBsx7qeBoZt4Z76bRZQtbLZjs29K4Rxta/e6V8uKXrjtJ+2rXP1PcD5Cm8e9e8qKa0wXuur5em3vsZNMc9CdqbtPQDWK/x0jFfbP3J7x+XXRHSR6jcfNCcpCTlpVvThfoOF3x5uhzCJklR2RV0SrRvbOAaumdDS1q1saLdksTSJ1Iif3Feo+y7uyuxS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 08:08:07PM +0800, Wen Jiang wrote:
> From: "Barry Song (Xiaomi)" <baohua@kernel.org>
> 
> For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
> we can handle CONT_PTE_SIZE groups together.
> 
> These additional sizes are mapping spans used by non-hugetlbfs(vmalloc)
> mm code, not new HugeTLB hstate sizes.
> 
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
> Tested-by: Xueyuan Chen <xueyuan.chen21@gmail.com>
> Tested-by: Leo Yan <leo.yan@arm.com>
> Reviewed-by: Dev Jain <dev.jain@arm.com>
> ---
>  arch/arm64/mm/hugetlbpage.c | 15 +++++++++++++++
>  1 file changed, 15 insertions(+)
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index a42c05cf56408..7ce159483a354 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -94,6 +94,11 @@ static int find_num_contig(struct mm_struct *mm, unsigned long addr,
>  	return CONT_PTES;
>  }
> 
> +/*
> + * num_contig_ptes(), set_huge_pte_at() and arch_make_huge_pte() can be
> + * used by non-hugetlbfs(vmalloc) mm code to set multiple huge mappings
> + * at the PTE level.
> + */
>  static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
>  {
>  	int contig_ptes = 1;
> @@ -110,6 +115,12 @@ static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
>  		contig_ptes = CONT_PTES;
>  		break;
>  	default:
> +		if (size > 0 && size < PMD_SIZE &&
> +				IS_ALIGNED(size, CONT_PTE_SIZE)) {
> +			*pgsize = PAGE_SIZE;
> +			contig_ptes = size >> PAGE_SHIFT;
> +			break;
> +		}

Under which circumstances would you get a size of 0 here?

Given that you're relying on arch_vmap_pte_range_map_size() to give you
a well-formed size, why isn't if sufficient to check only the alignment?

>  		WARN_ON(!__hugetlb_valid_size(size));

I agree with David that it's messy having hugetlb tangled up in here.
It means this validity check is now going to miss some genuinely bogus
cases for the hugetlb path (as opposed to the vmalloc path).

Will

