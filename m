Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 98D0BCCA470
	for <linux-mm@archiver.kernel.org>; Tue,  7 Oct 2025 07:11:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F23758E0010; Tue,  7 Oct 2025 03:11:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED4468E0005; Tue,  7 Oct 2025 03:11:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E11048E0010; Tue,  7 Oct 2025 03:11:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CEED18E0005
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 03:11:31 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7E632160796
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:11:31 +0000 (UTC)
X-FDA: 83970447582.15.12D752E
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9F118A0009
	for <linux-mm@kvack.org>; Tue,  7 Oct 2025 07:11:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759821089;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=h4KVwKFabYir+H8bMi0D/2tWGiCX3AIv64c6aXCj5k8=;
	b=TTTMiHaPlbbqVVRhAhFP335BAUlEqfiuk5uXsiaaLMz02KlElmAv62I1yNLaX4jhx90TTw
	W6gwl+lYRAo+rPYegt1X9cbLaHoUkbleLgXQeDfUkF3tKpjU0ErxwqeqCU/min5btnt5Xn
	cMSyD4ksAGG1x6jlnO9p+NXmvvylcDI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759821089; a=rsa-sha256;
	cv=none;
	b=zZWhLwhtlquZMQtGADgEVHBNMYdzszjD1IBZ5LaGhJR4Wt+Z962EgyeQhCvtcHx8zn8VPL
	a7hNr7he5ncr+WksIXJTHprc2T/UuC/tIbd8lG7+RJAe6DbFiE8EPTyb9Z5PCeRNrjELOf
	L65J+643rcjiEt/uDp9xnEDzewdKUKA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf15.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7A79914BF;
	Tue,  7 Oct 2025 00:11:20 -0700 (PDT)
Received: from [10.163.65.24] (unknown [10.163.65.24])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 76B623F66E;
	Tue,  7 Oct 2025 00:11:26 -0700 (PDT)
Message-ID: <584fea72-e564-4cf6-9435-ce4b03f2fd65@arm.com>
Date: Tue, 7 Oct 2025 12:41:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Replace READ_ONCE() with standard page table
 accessors
To: Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@redhat.com>, linux-kernel@vger.kernel.org
References: <20251007063100.2396936-1-anshuman.khandual@arm.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20251007063100.2396936-1-anshuman.khandual@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam01
X-Stat-Signature: etbxxst5su6exncs6g9qqyd5q7t33c88
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F118A0009
X-HE-Tag: 1759821089-484713
X-HE-Meta: U2FsdGVkX19UP1CGkHEck2gx0LwORbxDuf/diKpkL2dXZV769qyEl7SLeyHzfW1l951SFsl2cHg4tSmodOWEgNw6/PyYq/cvNtrFYSDVEyDUXClZLvGumkO2qZJw/FGN0Hf+fh4pAw+/0DZUK/s8W7hr+yaDbdzCpNphfT93d5rDxGF7KUnIEeXRtgsC87ARviKV17Fr4OV91gXRvHi63k6zgOiT4FhZjOUAcndisKAADVrrntI0xcpa2LBXuOXS4koa/igQ1o40cGhbO6ugbEdl67DAJ3MpUGPE2rarxobnpOqk4F/ZV3HsuRTR3NV8vcEgGpxxlIijZzIfYplELD0gZOO26keLnHWEmTWet8o6xiN3P7HEaiHk1B5wp401SLbV+e60ZchvXfC+wJbULkkvBdx5oGgFWuiENxCyC99LsYDc+RJI+PRAbLnfL3UPtSr4unFlgRl2A+BSGmjT5ODj+5twmLJnuCpnud5JYF2qHRDI5Qi56w4v0fhnZqtZkQjH3zYKo07ef1A2MzQJUZq0aOsfbN5JmnHznl5vZ62Kzp6iaQM0xgfQhXJPTUZxVaH7pn7fX2A0XWVq5b7A8M+T5vX/7pqHcK0MYXja4XJtWtFxsOfsI0qvc2HDMNH4DG/ouEGojH8uqWRZAnTHimxwsY8YSrOtYk3YzW8Fs2OvoqiIvc4KFU30oeFzAbYBtwFyNn65Bz9ZXZBLH4wgylADKqhSdsHRO5WHYQlHqVWc2fl8JwCAnuYwSaMQKVIin9GNsLdyjmQsRD3hsQ0PDkPB5NTdhvfPgvxR6LMzGkLFE4cm/GvIX4kdZLqKNTEYCc02VIPO30eWx/XHm7O6DHQOB9Ryg5tWTXzSMWExbziNsJr+B4KUFNthf4KiQqp3TnrsUfeAsACs6/DFCxZVRJCsm6EJpYnfD0lMCLd8G28gcRXZIjjmgP2W2oOiKdhhI6iOHfEIVRWHeb+7Qoz
 NwL4RcfL
 0xB337+ZTu0uiUqNOZbI3jSjGpjQ1mTV3ppNj/KbCGR+rfQRWr0JMHgRdO/rzDqoQbAaisJV7CcWkTYedBuS2xbZgbTbDUSyeVsyvmPvU6+twWDg00V7nnCtNUh1XZ5cvK5dfmFLgq7rvi/FJ6nUpAh8aALjCiuLA1F9MFFjXRkMDSvnVkmaMxttWToUyYuYYIsKCGF3BJWstyRkIOWbmWVlcGVaRBAb2y6dROCzRObV1u0YJvQ0EUhBtfYWoB5LVCs5yaHmRmEceDZK5FmbJxdYX8m8hCns1zMVXbJf4GKv0S0Hyo2HJp0QE3mNFyhY5MJTCCzXh9hfCx3oQXrakd793cb9G7bI9PH6NbMLqfioaQIpH1UgE/mz8lqvB1LjF8TwvUPETiwtvRDeVJvw745zZgBlwFQz5CnhkQj4s+U1rTbDi0PDMMxbTVZy1dd+U36Iy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 07/10/25 12:01 pm, Anshuman Khandual wrote:
> Replace all READ_ONCE() with a standard page table accessors i.e pxdp_get()
> that defaults into READ_ONCE() in cases where platform does not override.

Does any platform override into something else currently? The way you write
the description implies that.

>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Cc: David Hildenbrand <david@redhat.com>
> Cc: linux-mm@kvack.org
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
> ---
>   mm/gup.c            | 10 +++++-----
>   mm/hmm.c            |  2 +-
>   mm/memory.c         |  4 ++--
>   mm/mprotect.c       |  2 +-
>   mm/sparse-vmemmap.c |  2 +-
>   mm/vmscan.c         |  2 +-
>   6 files changed, 11 insertions(+), 11 deletions(-)
>
> diff --git a/mm/gup.c b/mm/gup.c
> index 0bc4d140fc07..37e2af5ed96d 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -964,7 +964,7 @@ static struct page *follow_pud_mask(struct vm_area_struct *vma,
>   	struct mm_struct *mm = vma->vm_mm;
>   
>   	pudp = pud_offset(p4dp, address);
> -	pud = READ_ONCE(*pudp);
> +	pud = pudp_get(pudp);
>   	if (!pud_present(pud))
>   		return no_page_table(vma, flags, address);
>   	if (pud_leaf(pud)) {
> @@ -989,7 +989,7 @@ static struct page *follow_p4d_mask(struct vm_area_struct *vma,
>   	p4d_t *p4dp, p4d;
>   
>   	p4dp = p4d_offset(pgdp, address);
> -	p4d = READ_ONCE(*p4dp);
> +	p4d = p4dp_get(p4dp);
>   	BUILD_BUG_ON(p4d_leaf(p4d));
>   
>   	if (!p4d_present(p4d) || p4d_bad(p4d))
> @@ -3080,7 +3080,7 @@ static int gup_fast_pud_range(p4d_t *p4dp, p4d_t p4d, unsigned long addr,
>   
>   	pudp = pud_offset_lockless(p4dp, p4d, addr);
>   	do {
> -		pud_t pud = READ_ONCE(*pudp);
> +		pud_t pud = pudp_get(pudp);
>   
>   		next = pud_addr_end(addr, end);
>   		if (unlikely(!pud_present(pud)))
> @@ -3106,7 +3106,7 @@ static int gup_fast_p4d_range(pgd_t *pgdp, pgd_t pgd, unsigned long addr,
>   
>   	p4dp = p4d_offset_lockless(pgdp, pgd, addr);
>   	do {
> -		p4d_t p4d = READ_ONCE(*p4dp);
> +		p4d_t p4d = p4dp_get(p4dp);
>   
>   		next = p4d_addr_end(addr, end);
>   		if (!p4d_present(p4d))
> @@ -3128,7 +3128,7 @@ static void gup_fast_pgd_range(unsigned long addr, unsigned long end,
>   
>   	pgdp = pgd_offset(current->mm, addr);
>   	do {
> -		pgd_t pgd = READ_ONCE(*pgdp);
> +		pgd_t pgd = pgdp_get(pgdp);
>   
>   		next = pgd_addr_end(addr, end);
>   		if (pgd_none(pgd))
> diff --git a/mm/hmm.c b/mm/hmm.c
> index d545e2494994..126c3f42e525 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -431,7 +431,7 @@ static int hmm_vma_walk_pud(pud_t *pudp, unsigned long start, unsigned long end,
>   	/* Normally we don't want to split the huge page */
>   	walk->action = ACTION_CONTINUE;
>   
> -	pud = READ_ONCE(*pudp);
> +	pud = pudp_get(pudp);
>   	if (!pud_present(pud)) {
>   		spin_unlock(ptl);
>   		return hmm_vma_walk_hole(start, end, -1, walk);
> diff --git a/mm/memory.c b/mm/memory.c
> index 0ba4f6b71847..50f841ee6e84 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -6549,12 +6549,12 @@ int follow_pfnmap_start(struct follow_pfnmap_args *args)
>   		goto out;
>   
>   	p4dp = p4d_offset(pgdp, address);
> -	p4d = READ_ONCE(*p4dp);
> +	p4d = p4dp_get(p4dp);
>   	if (p4d_none(p4d) || unlikely(p4d_bad(p4d)))
>   		goto out;
>   
>   	pudp = pud_offset(p4dp, address);
> -	pud = READ_ONCE(*pudp);
> +	pud = pudp_get(pudp);
>   	if (pud_none(pud))
>   		goto out;
>   	if (pud_leaf(pud)) {
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index 113b48985834..988c366137d5 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -599,7 +599,7 @@ static inline long change_pud_range(struct mmu_gather *tlb,
>   			break;
>   		}
>   
> -		pud = READ_ONCE(*pudp);
> +		pud = pudp_get(pudp);
>   		if (pud_none(pud))
>   			continue;
>   
> diff --git a/mm/sparse-vmemmap.c b/mm/sparse-vmemmap.c
> index dbd8daccade2..37522d6cb398 100644
> --- a/mm/sparse-vmemmap.c
> +++ b/mm/sparse-vmemmap.c
> @@ -439,7 +439,7 @@ int __meminit vmemmap_populate_hugepages(unsigned long start, unsigned long end,
>   			return -ENOMEM;
>   
>   		pmd = pmd_offset(pud, addr);
> -		if (pmd_none(READ_ONCE(*pmd))) {
> +		if (pmd_none(pmdp_get(pmd))) {

I believe sparse-vmemmap is only for 64 bit arches so we are safe.

>   			void *p;
>   
>   			p = vmemmap_alloc_block_buf(PMD_SIZE, node, altmap);
> diff --git a/mm/vmscan.c b/mm/vmscan.c
> index 674999999cd0..14c2722b955b 100644
> --- a/mm/vmscan.c
> +++ b/mm/vmscan.c
> @@ -3772,7 +3772,7 @@ static int walk_pud_range(p4d_t *p4d, unsigned long start, unsigned long end,
>   	pud = pud_offset(p4d, start & P4D_MASK);
>   restart:
>   	for (i = pud_index(start), addr = start; addr != end; i++, addr = next) {
> -		pud_t val = READ_ONCE(pud[i]);
> +		pud_t val = pudp_get(pud + i);
>   
>   		next = pud_addr_end(addr, end);
>   

