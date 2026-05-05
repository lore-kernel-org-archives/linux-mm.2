Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9DCF0FF885A
	for <linux-mm@archiver.kernel.org>; Tue,  5 May 2026 12:20:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10B056B0005; Tue,  5 May 2026 08:20:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BB476B00B2; Tue,  5 May 2026 08:20:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF2866B00B3; Tue,  5 May 2026 08:20:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D94096B0005
	for <linux-mm@kvack.org>; Tue,  5 May 2026 08:20:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A4D7A1C0399
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:20:47 +0000 (UTC)
X-FDA: 84733274934.03.5EC86C7
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id 0CFFB1A0002
	for <linux-mm@kvack.org>; Tue,  5 May 2026 12:20:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n6mu93jk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777983646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MpqeLpE3XDVLXkbeQLX1YsCApQ8Y9tkeuuEIr6QjAhw=;
	b=G5lTdWrerB0hP4fvW4CVRGWTO4152o1Vupfo0U6Sj5wNBHiq8t7GsGKcrdI6j6/SpQhp+R
	yCXMZs9AXUFikZFyUXyrLBDx0mtpS8oQVmEcro9t4pL/75rNpqMd2WN/twfkJEohzkIQW+
	2nNGjQYvZ4BDah0wwUQl7dlUPM3AuPU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777983646; a=rsa-sha256;
	cv=none;
	b=Kimyq8eHOGG4LitQnCA3R6NldW8mgPfGj79l8E+n2PcPuJbylpg9VfT2YKClAkWOXCxZOj
	gArd/S0D8+4eJy8M/ptBOPkdCKJSioKleqDtPjW9QEDpuKKaO63CtfliqRZYZWs+Z8vwgf
	hOlhnBGWdGeslS+5jD1FOtXzqmb35CI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=n6mu93jk;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 63B2160141;
	Tue,  5 May 2026 12:20:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08885C2BCB4;
	Tue,  5 May 2026 12:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777983645;
	bh=6BjI5eOuom5pvJYSucqP4/FaJG3jMl4E2DqfW6+FQ7U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=n6mu93jkiHjKWcy+UZvMqFimN7mzVDoyBLRyL95V6b4o0AP0bAw6fhxN3ULKsPRwg
	 d4DEf9cBYXkRqvnw/4IAU+2hsKfu9oUA3+SasOI77LbGyG7cu0App92sNzsqaGtih4
	 E0f9P/83K5tSWslQGZHbjeezvzUbHe4NBDylhZab6rIIgoRaRLshXOc6db0YLj1jT0
	 h23o6ruRrULweJvSZk/PCFBfUX9ctm/50biEqvraaOyvnzCHkV74IuQjl+6lAXOsCE
	 s4xbsljW3Bilb8vQOkRHJ0GSPgCyJCOCNCXQ8anCY4i/+k5Jac+L85aPKAqfTFKffW
	 tCvuiditQph8Q==
Date: Tue, 5 May 2026 13:20:40 +0100
From: Lorenzo Stoakes <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Oscar Salvador <osalvador@suse.de>, 
	Hugh Dickins <hughd@google.com>, Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Bibo Mao <maobibo@loongson.cn>, stable@vger.kernel.org
Subject: Re: [PATCH] mm: fix __vm_normal_page() to handle missing support for
 pmd_special()/pud_special()
Message-ID: <afnffbs-5cy7KGua@lucifer>
References: <20260430-pmd_special-v1-1-dbcbcfd72c20@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260430-pmd_special-v1-1-dbcbcfd72c20@kernel.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 0CFFB1A0002
X-Stat-Signature: hiwi3k96xc6pwmq6jajo38sqteaud7gp
X-Rspam-User: 
X-HE-Tag: 1777983645-251729
X-HE-Meta: U2FsdGVkX185lEbex5us1Gh2CpfITFOlwFQTcDcBUDol/KJrhD4n0cjd2z9GuN3f7yp1esIeKzpO8g7kMMH50OsDL3HSLSVOyBGiinAfpeLiXlDIT1fYRc0RbwE+dsnC4f9/2dqmH9rC1Q4Zo0v/+eNpUbutZgozFHFmszQsyOjFIVVBSiRYfWT0KYKLuvvtNDAgc3BQHW044PTKyA3rFKrkIZGzDREQl0C/6OpXV/SeRdOeuGur4pxFAH2Yt0LKywOF3WT1gbDaN2aGBK6BKOcImfbS02khwgLSkSJTs7jsg/QnH90J9nXfPNB/z6bQr0liTJQnDPsDUdFffzEMwEgq1lqtay9Zl+GgIzKJUpm0IQDPN4UPBM4TZBRP+UgJ4EXm7+cXSAegY+i5fr8oxfn/bZl5EIuO5gQ3UMQmrq2VxOwmPrZW557V4m1NOAgppIFqB85a6L7qSGdNICNJEhUcbOP6qkWX2lGhgrAHs5HjOoED+cJ1ltLg+ghdBH7BdQEUNQsCz8tww6AH3eg74HkmUaQGT799+TDLGVUOrBc4kQhzvV7Fo2iSc4AaDMeTTngemywCCJrBr9jjp6h+iYEMTxXNOY00KNhcHUCbh7Z70Dzp4reJrum0wgQLGE0dQU1+4ZMMP53quK6o/9NbFtwc91lFlXKX11iW2SZkz3UunEXMzeodSBQhFri9Xz8/PcWy0jl06SHMnIx4DBHpjDDVlJ0FjR/f49pBKlAeFiBYieQlnS1dtSpLZWcYr/25uOuhoS/m0eilBCAl2T1EkSMEpmFvW/3MiAHL5J8kQPeQ3Cx5t+kzl2yW8X8qhBWNaCTBDcE0PZFVGCZGiLcFw0reT/mMvfZOsvSASzclt+YscMIDYNQLjrJYct4yL5IET1jzaohnT4ux2oPBxqi7qQgrOQGy3Wa7qCjxYGEdhDShoYCBuRAZCuqPeu1VV8TjNOJlHcE//0rZoy3h81e
 gbVes0VT
 shvyEf91P64VbilLz0dqRNb+TU4nI/bI7aP53Yz+Fk4iEANt+poLva5uC2OGy2bVsI1UiIcW+uNlzRtZ5Bzl/MznAwsWXI10+dsE/Qfuj4HnDiOEERnv2w5saC0OflDha+ZsLXp041LFS+lwhdWqHrmS3MysSEj6h7b6dGSuXBOZ7nc4x2w3Jqe0ibFNvLQAPlLX5RPs2g3qjpGqDM7qHHiB8g0S8O4aRxrRG0E0lii0E3a/8lyoXan6Qkew699CfRkA1XpQ5bFmWDcSfichhEnEDqnIEP/R4cxtd9Rd1ysTrqEMahTO/DP2xsOz2pz5FR1bFSYSQFl2imOSGXZ+6b7QchA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 01:31:22PM +0200, David Hildenbrand (Arm) wrote:
> On x86 32-bit with THP enabled, zap_huge_pmd() is seen to generate a
> "WARNING: mm/memory.c:735 at __vm_normal_page+0x6a/0x7d", from the
> VM_WARN_ON_ONCE(is_zero_pfn(pfn) || is_huge_zero_pfn(pfn)); followed
> by "BUG: Bad rss-counter state"s, then later "BUG: Bad page state"s
> when reclaim gets to call shrink_huge_zero_folio_scan().
>
> It's as if the _PAGE_SPECIAL bit never got set in the huge_zero pmd:
> and indeed, whereas pte_special() and pte_mkspecial() are subject to a
> dedicated CONFIG_ARCH_HAS_PTE_SPECIAL, pmd_special() and pmd_mkspecial()
> are subject to CONFIG_ARCH_SUPPORTS_PMD_PFNMAP, which is never enabled
> on any 32-bit architecture.

Ah damn. I wonder if it's really a combination of 'supports THP' and 'has a
spare software defined bit free in PTE'?

In any case obviously have to fix this.

>
> While the problem was exposed through commit d80a9cb1a64a ("mm/huge_memory:
> add and use normal_or_softleaf_folio_pmd()"), it was an oversight in commit
> af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
> and would result in other problems:
> * huge zero folio accounted in smaps, pagemap (PAGE_IS_FILE) and
>   numamaps as file-backed THP
> * folio_walk_start() returning the folio even without FW_ZEROPAGE set.
>   Callers seem to tolerate that, though.
>
> ... and triggering the VM_WARN_ON_ONE(), although never reported so far.
>
> To fix it, teach vm_normal_page_pmd()/vm_normal_page_pud() to consider
> whether pmd_special/pud_special is actually implemented.
>
> Fixes: af38538801c6 ("mm/memory: factor out common code from vm_normal_page_*()")
> Reported-by: Hugh Dickins <hughd@google.com>
> Closes: https://lore.kernel.org/r/74a75b59-2e13-3985-ee99-d5521f39df2a@google.com
> Reported-by: Bibo Mao <maobibo@loongson.cn>
> Closes: https://lore.kernel.org/r/20260430041121.2839350-1-maobibo@loongson.cn
> Debugged-by: Hugh Dickins <hughd@google.com>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>
> Tested-by: Bibo Mao <maobibo@loongson.cn>
> Cc: stable@vger.kernel.org
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

This LGTM, so:

Reviewed-by: Lorenzo Stoakes <ljs@kernel.org>

> ---
> This is an alternative to Hugh's patch, whereby we leave pmd_special()
> be a NOP and instead teach __vm_normal_page() about lack of support for
> pmd_special/pud_special.
> ---
>  mm/memory.c | 22 +++++++++++++++++++---
>  1 file changed, 19 insertions(+), 3 deletions(-)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 7322a40e73b9..4d84976fc7f4 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -612,6 +612,21 @@ static void print_bad_page_map(struct vm_area_struct *vma,
>  	dump_stack();
>  	add_taint(TAINT_BAD_PAGE, LOCKDEP_NOW_UNRELIABLE);
>  }
> +
> +static inline bool pgtable_level_has_pxx_special(enum pgtable_level level)
> +{
> +	switch (level) {
> +	case PGTABLE_LEVEL_PTE:
> +		return IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL);
> +	case PGTABLE_LEVEL_PMD:
> +		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PMD_PFNMAP);
> +	case PGTABLE_LEVEL_PUD:
> +		return IS_ENABLED(CONFIG_ARCH_SUPPORTS_PUD_PFNMAP);
> +	default:
> +		return false;
> +	}
> +}
> +
>  #define print_bad_pte(vma, addr, pte, page) \
>  	print_bad_page_map(vma, addr, pte_val(pte), page, PGTABLE_LEVEL_PTE)
>
> @@ -684,7 +699,7 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
>  		unsigned long addr, unsigned long pfn, bool special,
>  		unsigned long long entry, enum pgtable_level level)
>  {
> -	if (IS_ENABLED(CONFIG_ARCH_HAS_PTE_SPECIAL)) {
> +	if (pgtable_level_has_pxx_special(level)) {
>  		if (unlikely(special)) {
>  #ifdef CONFIG_FIND_NORMAL_PAGE
>  			if (vma->vm_ops && vma->vm_ops->find_normal_page)
> @@ -699,8 +714,9 @@ static inline struct page *__vm_normal_page(struct vm_area_struct *vma,
>  			return NULL;
>  		}
>  		/*
> -		 * With CONFIG_ARCH_HAS_PTE_SPECIAL, any special page table
> -		 * mappings (incl. shared zero folios) are marked accordingly.
> +		 * With working pte_special()/pmd_special()..., any special page
> +		 * table mappings (incl. shared zero folios) are marked
> +		 * accordingly.
>  		 */
>  	} else {
>  		if (unlikely(vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))) {
>
> ---
>
> base-commit: d94322006a51b522dd361128a450bf9e75aad889
>
> change-id: 20260430-pmd_special-610dbdd8ac3c
>
> --
>
> Cheers,
>
> David
>

