Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1CC63C43602
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 00:56:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2D5296B0154; Thu,  2 Jul 2026 20:56:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 268B96B0156; Thu,  2 Jul 2026 20:56:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1560A6B0158; Thu,  2 Jul 2026 20:56:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B9C8D6B0154
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 20:56:19 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3849E1C0C4D
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:28:39 +0000 (UTC)
X-FDA: 84944218758.06.1BD0640
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 69AAF1C000D
	for <linux-mm@kvack.org>; Thu,  2 Jul 2026 15:28:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b2UNbaF3;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783006117;
	b=nTKG6NtOP8gNAqJKeH3g2mHm9Nm2/GPxKTFiPS83Yv2AhZKZjUo0YUdyRgniECGIcIG1j4
	4F6h/gp5rKFcFCOFwMFCat55e1snPJYiVqToZ33Y1atFwoApiYXsnx+TFlulFT3E8Tivn3
	Y00VWmtjb6fAo59n8dQbQBQUg43WVsk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783006117;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fxXhck2nCzeMzLvm9K6L7ngfJTEEd79JFyjVImCQDM=;
	b=mRpwURV6j2Cpy2JCAy3DUUY26lMc07q9KNjtb4X66hKQ93lts/T096SDTtqr8CwsrrqAMu
	c5OALnux5RMRnKZ1iqjBHWErCUNlA2MYu1kubAXHTQcxJeI7Gj+MjZG3qQgGMGX4N/JqU8
	aLkus5IlX9NsY5VyjffoNxmlEw1VhKU=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=b2UNbaF3;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A18EF40B69;
	Thu,  2 Jul 2026 15:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 909DE1F000E9;
	Thu,  2 Jul 2026 15:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783006116;
	bh=1fxXhck2nCzeMzLvm9K6L7ngfJTEEd79JFyjVImCQDM=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b2UNbaF3r1hljIWsq+U3j/11VVe9K2mDfW8ITR+HjohsDjn4ssvCJs9AFVheLFUgy
	 YutZV+6PpHeF6xFcTE3aP1wgob9+1JJiCuA/RUVFz2dvVYiCt029oTNRLVLNIirVwd
	 ZJRN/llZI+zewvXG8n2DgpVZTw4maIPQ94/3bo8QOtoi+JTqEKFtFV6CASOrxfXduo
	 qTdXAdcCH6byaDW+HoajP2kUzTHaMjHIVEEpuN8pRkkUTl53dMnB2eSPLJRIlyVlw7
	 fxKtmvq5cuKuBvDlq8x+OvxC7zoRN102vKdIlK8yykc6GDFwRBmyrZt2fzUDpQl6OJ
	 HSXqnKeJZSz7Q==
Message-ID: <d6544525-5dfd-40c0-9c9a-2423f21d8034@kernel.org>
Date: Thu, 2 Jul 2026 17:28:25 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 1/6] arm64: make huge_ptep_get handled unaligned
 addresses
To: Dev Jain <dev.jain@arm.com>, muchun.song@linux.dev, osalvador@suse.de,
 akpm@linux-foundation.org, ljs@kernel.org, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 lance.yang@linux.dev, kas@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, rcampbell@nvidia.com, apopple@nvidia.com,
 ziy@nvidia.com, matthew.brost@intel.com, joshua.hahnjy@gmail.com,
 rakie.kim@sk.com, byungchul@sk.com, gourry@gourry.net,
 ying.huang@linux.alibaba.com, j-nomura@ce.jp.nec.com,
 nao.horiguchi@gmail.com, ak@linux.intel.com, mel@csn.ul.ie,
 pfalcato@suse.de, jpoimboe@kernel.org, dave.hansen@intel.com,
 tglx@kernel.org, catalin.marinas@arm.com, will@kernel.org,
 linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
 anshuman.khandual@arm.com, stable@vger.kernel.org
References: <20260702051341.126509-1-dev.jain@arm.com>
 <20260702051341.126509-2-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260702051341.126509-2-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 69AAF1C000D
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: fphbjktuyk6snty3foaq5usmdhkmumyh
X-HE-Tag: 1783006117-797315
X-HE-Meta: U2FsdGVkX1801dEp+TjsnxaUreDnwG164WGGYJb5BeOpTzEZaSC8Q9GPTAn8VDSTxnqa25tChWIxQLZh3fK9OhWH3M476TKxvmB6TzVJ4AZhXhu3qXpNjRmh3U1MWpSyb34+h+4WhYqbRv6Q2mVl3TtKtEZ2J4+sFNZS5IcRm4/jIBWimoNikB3UQgwOgZ/lUesyw3yAQgM3Hso+EPd19d3WTa2Fq6NaFsKvAaGtaWztzfo3LRo3D2luX1fd5Pkdx+mKIapDGBRx/gYuEPIPKR3Wta+eeOIVDSzZBeR5jGvc9eqt8fDWYVCVsfHutUlJ9mBuhcMR4VvRvQtm8SrNGUmVT8tbfpj3OP7f86EFhXcGKlbx6ifD9A8k24W+wb1vN/DRaDSGGk7ZC4B1YLNBTSxrah0mw/VElpyg+Tuj1iq910+be6N/2+6AsHwM1Fa3ONhXq9awmBvHfSqowlqBnsMSrhco54CvU/loXJ6OOW4aIVDM/L9y6nNxqWcqMHUsDO7BMxv1142nVqF3wAbfcOtsptL3WUC1Y+TuJHQ5Rn6AmzfCN/AwnsaVNbp+3IQjCBnbniXf4vjnVpOyeG5NydFeL5zItcyo6hcE6xBo7h9LbLaBKk3vkDqtsSHDD/3/qoDNwJr5fu4omHMvbDvTyGl+zl4rlYUhZvl/mDn9HfbjAfXTOLzck1EhQDVYrB59auvHIgwYlBeP+eNXDPHYbhISXvXq6FaJSRNGeC67boBSMlj285dkQHn0939AwfIN4GfOYLmtkjThHg8w3eLn8DT5JU7dvIPW7Dv5ZCs3uF2gY/UgbJDS8JGUDYb/QqIMCweqBEEOUMP2MAiGwkOJKyEuwlDBfhcdBgGnbM7TvaB1F583nAwEXS5eHH+LFSWRxGASApEu0h6lIy/NAexl0b6eV+bjRPC470fzubTQlGPL7jguCfMPANkpYzmKfwioLLEvqkcEko/ln0xEBQY
 HrKwe0XI
 JjBIqmxQTOeq2TM+mz+8+qz9nRMNBX1beOQPLhWwOf4rJYlxziVGoert+8XckRYzXHIgaYc3C1HrKHX9vpuzR1jjquRQXlmFlsp1qz9li/j+ecBOjjToiXO8Itb8vnZsm8KIfT3KzWcz33PxhKT9JVLNErpReL3lKDDHeyhp3ZyW8k+YMcGgpxd5GnA8NiX1STSt7zSis57cp3XhdRzNaAVdV7tXATXqTJKes8vyChwZ63sEcEgKh47z6QNM0irxp5JMHObpdjfCHQeeuNwVs1pAZh1V7uOUlgyAqeQ5Ld0mYXj68RdlUFIz5gn4F6qVA381CGPa1829WQvXxvcF62O6z+dYOnNwhNKZxFW6/V08iLxWKozTbklE1HNQzj5KtQNsJhRlcM/n/Qu3kNPHtQd1dGZjJg6yMTNTUkV60j0+gtPC8Q/Cij0dG+DiY7z1h7TkJfSHF4oN2FxBcuxvu1cVdNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 7/2/26 07:13, Dev Jain wrote:
> huge_ptep_get() can be handed a virtual address pointing to the middle of
> a contpmd/contpte mapped hugetlb folio (examples of callers are
> pagemap_hugetlb_range, page_mapped_in_vma).
> 
> The arm64 helper rewalks the pgtables in find_num_contig to answer whether
> the huge pte we have maps a contpmd or a contpte hugetlb folio, and
> returns CONT_PMDS or CONT_PTES, so that it can collect a/d bits over the
> contiguous ptes. We can falsely return CONT_PTES instead of CONT_PMDS
> if the addr is not aligned.
> 
> Fix this by aligning the pmdp pointer down to a contpmd base before
> checking equality with the passed huge pte pointer, to correctly answer
> whether the huge pte is the base of a contpmd block.
> 
> Fixes: 29cb80519689 ("arm64: hugetlb: Cleanup huge_pte size discovery mechanisms")
> Cc: stable@vger.kernel.org
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  arch/arm64/mm/hugetlbpage.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
> index 30772a909aea3..8e799c1fe0aa6 100644
> --- a/arch/arm64/mm/hugetlbpage.c
> +++ b/arch/arm64/mm/hugetlbpage.c
> @@ -87,7 +87,7 @@ static int find_num_contig(struct mm_struct *mm, unsigned long addr,
>  	p4dp = p4d_offset(pgdp, addr);
>  	pudp = pud_offset(p4dp, addr);
>  	pmdp = pmd_offset(pudp, addr);
> -	if ((pte_t *)pmdp == ptep) {
> +	if ((pte_t *)PTR_ALIGN_DOWN(pmdp, sizeof(*pmdp) * CONT_PMDS) == ptep) {
>  		*pgsize = PMD_SIZE;
>  		return CONT_PMDS;
>  	}


Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

