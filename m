Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CB9B3D29FF0
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 11:38:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CFCA6B00CD; Wed, 14 Jan 2026 06:38:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B0856B00CE; Wed, 14 Jan 2026 06:38:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BCEC6B00CF; Wed, 14 Jan 2026 06:38:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 18AE96B00CD
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 06:38:54 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D269B1ADF39
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:38:53 +0000 (UTC)
X-FDA: 84330372546.08.80AB646
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 03CFA120006
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 11:38:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t8XwR8ZY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768390732; a=rsa-sha256;
	cv=none;
	b=dCiBbbTDkhbEiSpW1UM6UOAfbapLt+Q+CLv1ErO519oq5rKbqh80RrcnBrM8bV/1CSswY9
	DiM7hFc4rmRwdobavbhcjb/dsYLBq8+RiD93e5kE3cAaAYCJkaEJ7xhHYTDN9StncUerNf
	gNkGFtYrzSiP+NugeA2phOEMK43g8zI=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=t8XwR8ZY;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768390732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RYLrr/cX0UVDGT6xloQArzoWtc+De0ABukqG1A3xh5Q=;
	b=0Cg8BveX/D++UxFkpUFZDHcdblB+x3CtY5Tfz8LKFluTUUV4orlPBggU5rWuJy4TPYa8Yo
	BwH1iQynqnkQtPtoUoNcJ+KnT4CQPNKp/3PSkALeyCx0hhAGuAVziris57PbNRpHep58dC
	yaI5YU47YaKaf7rkqj2q8NLr8cxurHY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 0F6894352E;
	Wed, 14 Jan 2026 11:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96E15C4CEF7;
	Wed, 14 Jan 2026 11:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768390730;
	bh=N+JcgHrCqUlqtZ0JzAO9E354TauL4x4Xr1CJuE7QA5M=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=t8XwR8ZYw9FvGsR9lpKPKi8DZnbwTNFyy5JfSxjmWu+r6iZSuUzx9YDcoLmnfOydl
	 Psz9OKj7nVNblg11mtNrEFRtBmswAWp3WS2W8yiFPcUHz09BnpMSxhmX6hiKQCuglH
	 nGY5DxT5n4FUkYJA2JPNJCZICVSmwQNizIb26hrP8jo/b/EGRT8vMXVLdFgHOra/i7
	 UGZP38Zupkmxp1rpeCCk7lurEiU2oP1xB0mYaRaW1vRt23Ar8mPAz1O/CmKKMFP8/P
	 Dsz/wCp08YdYUsLlGlsvTkmgxPR9wTNniJqXj717FjHgScGBhtkxfr2MiH5MIJT7j8
	 hKJENpzIX4erg==
Message-ID: <da715a5d-e187-436d-b5ff-153b1f7c8106@kernel.org>
Date: Wed, 14 Jan 2026 12:38:46 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v4 2/6] mm: khugepaged: refine scan progress number
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org
Cc: lorenzo.stoakes@oracle.com, ziy@nvidia.com, dev.jain@arm.com,
 baohua@kernel.org, lance.yang@linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Vernon Yang <yanglincheng@kylinos.cn>
References: <20260111121909.8410-1-yanglincheng@kylinos.cn>
 <20260111121909.8410-3-yanglincheng@kylinos.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260111121909.8410-3-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 03CFA120006
X-Rspamd-Server: rspam06
X-Stat-Signature: 4hn7gs46191ocptamnwzd1y9uxgnxa9m
X-Rspam-User: 
X-HE-Tag: 1768390731-710832
X-HE-Meta: U2FsdGVkX18VA4ZHi22tCuzRLmr9t16U8mAJlnD7WnednDZzXBuyE5KpHSkbD9+AW5USuoezT+ktsQNICk/8t/FOAss/TDzKE0fQyElzifpmyRYru6NkHct9fScxi9MTia/9twbFv0XoBXgZegZnDK+jTrGfh8Y8rfLh+tyvLHINWZG3pX2Uko5hsybicl0Lsr0mlleX6YpwBDDf0F5uLUVrlxhFniMjpdVNwGDi19R/lMNGf9ZQZBYmvxAVQ6Pe6Uy9dFBa+GTl7kIz4x9/W0y7XNIAWQ7CSecQd9X2RobY4b+n6OfDd68rN12x4eI6LfP0TkfrGh5Z1xi5ij1egZWY1Xn7c1eZNxfDZyRa3IjWsyUiqkQdQR7z43b98m/bfTrBx6L9NNtwbgsm707poEbrlnI7/93AjjuXx7NBF8hXEyz1vcOLv/O/0eVaccPjFFGAPhLxKD+89LkDQVKQxk/vTycJNHKKXU6eXZzaU59kHHuJm45vuhLBvZZu+svre9/5OlBM3A6hCvRYPzQSadwrZeoP0iJYkFVmFGfCc8GQ27J0rc9vpjjtfXIcN8ABssFDLHX1ZpA2V/C9UYhSCLkkEJ+yH0OC/kwGT2MHjr+A5MKXu4MK0yC81w12/VYhRiVNn7l5Ho5CUjesA+bhNPmYU2wucl6f5qOTKOAj12+Q6wYbSO7JKpJhcNxgvFJzxov4YtZzswy1fykk8yJr/00W33nz7Hy5URkTf1yZBKqHptBZ1c9ap3zA808P4Y2UeJiGx3oHlzqb7ExWrayTYJPgTLLUtuTNIwISreb3+G8XAV0PwtafLYyiWDtLvBtuVCAyYB9ZHUboKobn10oNioLolG+Cmjl8QjFJcJL1XKbnsUr5Ht6DcTfWJc65IEiO+HLiX2jo3YGvhr9iXDpff4sEf9ExgUJg1ZrZWl+fFzBiSG6FAjllvLRq1df42vCHfMBjlMIt4V00YC8yx10
 CBUho4UA
 fPZo14bmkVEmIMOSbEsuYv49DIsVrP8TaPb5y1RWXoQbtAIwJT/QTHtRiU5vcEO9NEAF1Aq4tKVQH6MO2QtPYN1RHU7jKuhZ958N8AjxUHBSS+pSOpjGETeeBakCmHqZHpw9RzI2O+yNItgtd6F9O3pGJBSLmW934jIUYOMUkQueHJiG3whkb4mXZAI1EowXoELIkVnK68GvXoX6gYit3fl/IMaJ4YugKaAnBXlZ8WQRRWMI8ZSyH0DcveTISm1PJiR+wI8tzI8GlZYyHerJWTLNpCZQeLLVjcANsNpdew0wuZR0JvrJGTZQz3PEEhEFQZ4TYD6cSR9Eu0Kb8X6UpwIQ81g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/11/26 13:19, Vernon Yang wrote:
> Currently, each scan always increases "progress" by HPAGE_PMD_NR,
> even if only scanning a single pte.
> 
> This patch does not change the original semantics of "progress", it
> simply uses the exact number of PTEs counted to replace HPAGE_PMD_NR.
> 
> Let me provide a detailed example:
> 
> static int hpage_collapse_scan_pmd()
> {
> 	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
> 	     _pte++, addr += PAGE_SIZE) {
> 		pte_t pteval = ptep_get(_pte);
> 		...
> 		if (pte_uffd_wp(pteval)) { <-- first scan hit
> 			result = SCAN_PTE_UFFD_WP;
> 			goto out_unmap;
> 		}
> 	}
> }
> 
> During the first scan, if pte_uffd_wp(pteval) is true, the loop exits
> directly. In practice, only one PTE is scanned before termination.
> Here, "progress += 1" reflects the actual number of PTEs scanned, but
> previously "progress += HPAGE_PMD_NR" always.
> 
> Signed-off-by: Vernon Yang <yanglincheng@kylinos.cn>
> ---
>   mm/khugepaged.c | 28 ++++++++++++++++++++++------
>   1 file changed, 22 insertions(+), 6 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index 2e570f83778c..5c6015ac7b5e 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1249,6 +1249,7 @@ static enum scan_result collapse_huge_page(struct mm_struct *mm, unsigned long a
>   static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>   						struct vm_area_struct *vma,
>   						unsigned long start_addr, bool *mmap_locked,
> +						int *cur_progress,
>   						struct collapse_control *cc)
>   {
>   	pmd_t *pmd;
> @@ -1264,19 +1265,27 @@ static enum scan_result hpage_collapse_scan_pmd(struct mm_struct *mm,
>   	VM_BUG_ON(start_addr & ~HPAGE_PMD_MASK);
>   
>   	result = find_pmd_or_thp_or_none(mm, start_addr, &pmd);
> -	if (result != SCAN_SUCCEED)
> +	if (result != SCAN_SUCCEED) {
> +		if (cur_progress)
> +			*cur_progress = HPAGE_PMD_NR;
>   		goto out;
> +	}
>   
>   	memset(cc->node_load, 0, sizeof(cc->node_load));
>   	nodes_clear(cc->alloc_nmask);
>   	pte = pte_offset_map_lock(mm, pmd, start_addr, &ptl);
>   	if (!pte) {
> +		if (cur_progress)
> +			*cur_progress = HPAGE_PMD_NR;
>   		result = SCAN_NO_PTE_TABLE;
>   		goto out;
>   	}
>   
>   	for (addr = start_addr, _pte = pte; _pte < pte + HPAGE_PMD_NR;
>   	     _pte++, addr += PAGE_SIZE) {
> +		if (cur_progress)
> +			*cur_progress += 1;
> +
>   		pte_t pteval = ptep_get(_pte);
>   		if (pte_none_or_zero(pteval)) {
>   			++none_or_zero;
> @@ -2297,6 +2306,7 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   
>   static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned long addr,
>   						 struct file *file, pgoff_t start,
> +						 int *cur_progress,
>   						 struct collapse_control *cc)
>   {
>   	struct folio *folio = NULL;
> @@ -2337,6 +2347,9 @@ static enum scan_result hpage_collapse_scan_file(struct mm_struct *mm, unsigned
>   			continue;
>   		}
>   
> +		if (cur_progress)
> +			*cur_progress += folio_nr_pages(folio);
> +

Okay, I had another look and I think the file path is confusing. We're 
scanning xarray entries. But then, we only count some entries and not 
others.

Can we just keep that alone in this patch? That is, always indicate a 
progress of HPAGE_PMD_NR right at the start of the function?

-- 
Cheers

David

