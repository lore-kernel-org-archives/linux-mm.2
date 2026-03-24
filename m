Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D60CFEC107
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 20:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CEBBC6B0005; Tue, 24 Mar 2026 16:18:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC31C6B0088; Tue, 24 Mar 2026 16:18:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD9756B008A; Tue, 24 Mar 2026 16:18:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A9D5F6B0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 16:18:50 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C37E140428
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:18:50 +0000 (UTC)
X-FDA: 84582070020.09.54367BD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 87B7418000B
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 20:18:48 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SdldKbSS;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774383528;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gxYiaYsV7gh76G6uqw8dzQbtisveI4MRc3rXKXF1OTw=;
	b=7UwMDXrzCyJ0go2gHCuAwUj/lfjlVFkcg0v8/JhAX/hJwISJUdu21ncBebIdjnhfhrOes1
	/jRMgVGbSMLU0d8WqoRanr0r6m0MGXvhouJMZKTNbV+GaIyntSGP2Vo+pdPdkR10QCfPkZ
	yEOkyLsiv81vKT9Pnsay2lDV5zj9wlk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=SdldKbSS;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774383528; a=rsa-sha256;
	cv=none;
	b=xfWUc5fvEumfyFdbhtnyuzPMcT/X65RMmggGiIETGeZ7r9URt7QsRn4yjm4lzOQ6jqKkOI
	5P1Roh5p4WOX/KEia9ghddhUXctlR0GdJZSJWXwLg7UlLqQP+jHnGthoGVH3zIayijQ0yo
	y7nFenRUd0qLEDf3Tn71iK8iS5Eo8nc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E0F5D600C4;
	Tue, 24 Mar 2026 20:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4C9FC19424;
	Tue, 24 Mar 2026 20:18:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774383527;
	bh=2GrqK9MneUqy449HN5/L1NGipzkVz9f/l+pLfKUHnQs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=SdldKbSS7hGXri+mMwXCDJo1YEQt/R3eshdwxETf51P9UFpH00ilZaW+8ug2ZfHEa
	 eGXTmUzgJ8+RuKXecdbuR7cFUEnEGVYrKtNonyxUj0txcCuHWbGwBC9LW7ftDaFaoZ
	 s5y0mEOEo74odLEK97UmLzinwbhEk2AoZgtxNx7ka2FpgY/P7AY7i23svpTAAbY+EV
	 Ds63HxytIlBJpb4Tt+Yu8q3UClHwniJ6FqyOU6y38fzGVc34T2qytjZbNXYPS5z5f6
	 IeMTX+4wJ0ukDjD79gkfp4wTRb8WJVyRP5sAQxbNVuZmsW4JeAa1rNvL+buoDTu6sh
	 S0nhPPqH/RG+g==
Message-ID: <fbabc728-a87b-48e2-87dc-68ac21eb02d4@kernel.org>
Date: Tue, 24 Mar 2026 21:18:42 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/2] mm/mprotect: special-case small folios when
 applying write permissions
To: Pedro Falcato <pfalcato@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Dev Jain <dev.jain@arm.com>, Luke Yang <luyang@redhat.com>,
 jhladky@redhat.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260324154342.156640-1-pfalcato@suse.de>
 <20260324154342.156640-3-pfalcato@suse.de>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260324154342.156640-3-pfalcato@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 4r3yx8mqmgi9nxzpdykuwgy34m1ywnx5
X-Rspamd-Queue-Id: 87B7418000B
X-Rspamd-Server: rspam09
X-HE-Tag: 1774383528-624421
X-HE-Meta: U2FsdGVkX18zZYpUZ/gxlv1uCRykDIFJHqlLU4OvAwulxD8c6ScFVCMExE11Kh058mjNzvYlZnHtTzWfF5B8MZP/o/SjftJOx2wQVY0Lz2xc1TFTwIxGxCEGcziQ+XPbcp/zrOu/FulocLsuPbCPwrlJnsKTHAlDqTvfWkvKLGyzcHvid0lGalcE9I2oNCvshhbGZnWtrjZjz/YV3YIfxZHFtfsTUVMZDRATdTdh1CUvfJ0jTWbdtSs6L20p2qFEv/PxQ9f+xkYnf0u6byE7M81V2Vki/VDtLYjV0CrnOnqGZGpq5jdOdo5Vli++/azACGUiSv86s8X7yd0HOmNW/3B6DqnWYo7FByf7rEcGOduQTl48ApnnCAiS4sU6rgObPqngP97khtIXkLOifFadTVvGKDMsAhOOYgzcg9gCRYxOPGUlKDHcDJqfVYStpwDFoBQF0LcljO3szBMcCCNz9EUweH5aSBBE6Ltjvhndx//BOXLmKnhoQCJIKjrSfqdxYvwEEgfSQuVGPHa8HXVxgj97xQZuzn1STSe11iDkQTW7eDKSbJxtquvtvjmRKFyTfHghZr3kXQCNA833j8UY+ye4fWPf8XOwB9ilgyUUVZfdOG7fcEXV25qJZDe07Ki39ysj21aTeAxbEehTpgiN5lHHu93Pyqj9wfklAJUzPBV/iapEkpSujqZQ2bH1ESAH9Z3FkQChdPfGZoQ9JIJ7k9CeiQ+MZl35+HQ5f8hJdlFEhI9JYr0K9AUIUNmsJx9iyCJJqwg8pgBMsbaKzxIzkxBuaVR5w7mSb4EFWgunaEm9xTxoBusgT9Z1GzF7ZuqMkswGGtRM8aULSsDqWQzWXBwsvR1s2I6ehny4pJQ7b5unikN4CyLnQUKu4v6Cf4MKONfCAZld1WgoYV7+gPofhfj5HXz9wnp4Xui1A2CwAFYNrSI17YbUCSQhTwxRB/BYIUlqFlfK+9E7eZsE8T1
 8ZVFmdYO
 lkl2YhXnXiR7J16QOgk6xbSMn35qOnVpDvdbDermOwq/BBF603JiOdWwZMx6D/sOQpmBvhwM+YAHVG0zEdzVTaLHAL9FUg8uYNNGJSRfBPMEyvF/cGL3H8xRMkpKPXimmV9xeR174zfHlUaTFH6a4saHDDv6muGPGRnOso5j34oDRb6+iTB5kGjJtzqqkNbnVJevLYMM4R7KC5E4TS2AsTHdOpXlUL1tTBidJaZmxybrVMvdWmK/TvqXd/VUGLiQjN1KJaCjTFMxTNPcpdNKZ/jjm+w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/24/26 16:43, Pedro Falcato wrote:
> The common order-0 case is important enough to want its own branch, and
> avoids the hairy, large loop logic that the CPU does not seem to handle
> particularly well.
> 
> While at it, encourage the compiler to inline batch PTE logic and resolve
> constant branches by adding __always_inline strategically.
> 
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> ---
>  mm/mprotect.c | 17 ++++++++++++-----
>  1 file changed, 12 insertions(+), 5 deletions(-)
> 
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 2eaf862e5734..2fda26107066 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -103,7 +103,7 @@ bool can_change_pte_writable(struct vm_area_struct *vma, unsigned long addr,
>  	return can_change_shared_pte_writable(vma, pte);
>  }
>  
> -static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
> +static __always_inline int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>  				    pte_t pte, int max_nr_ptes, fpb_t flags)
>  {
>  	/* No underlying folio, so cannot batch */
> @@ -117,9 +117,9 @@ static int mprotect_folio_pte_batch(struct folio *folio, pte_t *ptep,
>  }
>  
>  /* Set nr_ptes number of ptes, starting from idx */
> -static void prot_commit_flush_ptes(struct vm_area_struct *vma, unsigned long addr,
> -		pte_t *ptep, pte_t oldpte, pte_t ptent, int nr_ptes,
> -		int idx, bool set_write, struct mmu_gather *tlb)
> +static __always_inline void prot_commit_flush_ptes(struct vm_area_struct *vma,
> +		unsigned long addr, pte_t *ptep, pte_t oldpte, pte_t ptent,
> +		int nr_ptes, int idx, bool set_write, struct mmu_gather *tlb)
>  {
>  	/*
>  	 * Advance the position in the batch by idx; note that if idx > 0,
> @@ -169,7 +169,7 @@ static int page_anon_exclusive_sub_batch(int start_idx, int max_len,
>   * pte of the batch. Therefore, we must individually check all pages and
>   * retrieve sub-batches.
>   */
> -static void commit_anon_folio_batch(struct vm_area_struct *vma,
> +static __always_inline void commit_anon_folio_batch(struct vm_area_struct *vma,
>  		struct folio *folio, struct page *first_page, unsigned long addr, pte_t *ptep,
>  		pte_t oldpte, pte_t ptent, int nr_ptes, struct mmu_gather *tlb)
>  {
> @@ -177,6 +177,13 @@ static void commit_anon_folio_batch(struct vm_area_struct *vma,
>  	int sub_batch_idx = 0;
>  	int len;
>  
> +	/* Optimize for the common order-0 case. */
> +	if (likely(nr_ptes == 1)) {
> +		prot_commit_flush_ptes(vma, addr, ptep, oldpte, ptent, 1,
> +				       0, PageAnonExclusive(first_page), tlb);

To optimize that one, inlining prot_commit_flush_ptes() would be
sufficient. Does inlining the other two really help? I don't think we
can optimize out loops etc. for them?

I would have thought that specializing on nr_ptes==0 on an even higher
level--where we call
set_write_prot_commit_flush_ptes/prot_commit_flush_ptes() would allow
for optimizing the loops entirely for nr_ptes==0?

-- 
Cheers,

David

