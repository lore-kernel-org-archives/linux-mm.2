Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 212C71098781
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 13:51:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D0086B00A9; Fri, 20 Mar 2026 09:51:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A79F6B00AE; Fri, 20 Mar 2026 09:51:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7E45B6B00D4; Fri, 20 Mar 2026 09:51:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6EBDE6B00A9
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 09:51:52 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1817B89282
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:51:52 +0000 (UTC)
X-FDA: 84566579664.22.C3D1963
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf04.hostedemail.com (Postfix) with ESMTP id 86A334000F
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 13:51:50 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BOU0ESq2;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774014710;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P0wfCCiu3XCv3vesfWsdDwolEA7C9woeSe1LwRjeY4s=;
	b=nWhrtj1BH4g6m54XQ5p5ymJQKzmJ6IwJt57IdgO61hWfcS78N3x7kn5T7mZK+kq7VH0Fjl
	tcSwtJLs/wQPy+Y1hTBlgrwXrMWhU0KIM2BrRH3hkkMJFgrRbDLHsrtDxSNPKoDb8WhQBj
	bVR+IER8v2ZhlHLYkEwL4NUDGQkVdvo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BOU0ESq2;
	spf=pass (imf04.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774014710; a=rsa-sha256;
	cv=none;
	b=6ctlHe8JYwltLG39oqR2SYberB1y9UclcMx62gs/Po6J1Kc0BSBeZQpUTWPVbbxbA/SH3w
	Y9zkBDjqekwMYShD50gHomQokX++51MBU0Par1O6tNq9G7gSbFn81pvpuFygMGLh3QeOxq
	bZ7lSf8befhnNUlgAUtkARQWaSOWCf0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id EF79560121;
	Fri, 20 Mar 2026 13:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B525C4CEF7;
	Fri, 20 Mar 2026 13:51:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774014709;
	bh=DY/Y9ymbUW7WALvbKJbLZuYss/JYK8k0Yr4r14GAeKw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=BOU0ESq2BoBCSMLWatukG58yPSzBAfJh79XGmQxA5BelK8LVIK/jBi0OcIDYAwFQQ
	 Y1ZAvWIGZpiI1iodPE/C9z816vn/EFquGmvIlLkgPiFWb9CrBTynpZNMZnUOE8Mccd
	 srjMrhfABL9FnnTLCrqbwrAfu2xLzHpVzYMNpidLvkRwZGGljL/iocvRkOxyNzPgwq
	 3cWd5Nt8SR5fXvXXRrF+ZEj3tCa8BIl1iSmDLLku+a142CXWtmeXrtawjD0cSaBPaH
	 c49VxdXVwGg4BUon9n0sQTgrBZ5oArqD0JUi6mfhCTE01GzKRG9SUEumaf1wDQwa/Q
	 J6CNrJKUTFCFQ==
Date: Fri, 20 Mar 2026 13:51:44 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 8/9] mm/huge_memory: deduplicate zap_huge_pmd()
 further by tracking state
Message-ID: <a1962a7c-1638-444d-ba9c-6d60fca752c6@lucifer.local>
References: <cover.1773924928.git.ljs@kernel.org>
 <440f68edcb597c28918d89b0be279d498561c89a.1773924928.git.ljs@kernel.org>
 <d67ff262-a627-4cd3-b126-dd82eb8d3412@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d67ff262-a627-4cd3-b126-dd82eb8d3412@linux.alibaba.com>
X-Rspamd-Queue-Id: 86A334000F
X-Rspamd-Server: rspam07
X-Stat-Signature: hzt3duqk99w9qzjxb68hx16k4zhb4trs
X-Rspam-User: 
X-HE-Tag: 1774014710-579636
X-HE-Meta: U2FsdGVkX19NEtvbVXLBjI7uwQT3WS1MmodomH9W2E7WKswCeCnkkGyHUeSB+YYZ4O0IFJui4OBAUvewgVw9M/lhgPjAXK2O6hn9zOVBLfYTvRE2lLvv5LgGH8UN/yhckjmzhGo1KTnBtMfzb5ja5eR+QJB4rAC7xP2yoF0CqcwjbyVz2OLEzkVHe5VghaPXKr4VDMD0KEPWJ6tPfcQM+t9g56AxXAXn7wJZL/9/8h6M7HLzdTLNa80U+VAc5TFQmZ3+ypCDZ+UBYulLyBa1001s7rhdySqMwYWP1qsePYXrfCbbnKSOM3s0GqK8slwRf3bxc+4sROa5hhMWl5Qh1IuLq+azLNEwIF4YxAQvtaCNzGS64AwJYkqgc5mc9PTOb73aCUhdzjZK5RxMvyNfgkTb+bUvJYtYfVEQoKhp6flXGmnYtRMKMdJsFmgPCi3Ghd32X/UkXQI/bmAXUoRCxu+zw17QWY3kbItV91/2gs4K1GQrL+29PdfFdKd4VRwyqIljJsWRv31KyO3L+fcGuV8Crejzwiz6cq6RaTbvaKfi+QFUcQXhxyHQ8P/wy6P3dakgQ12wucoW0szYKEz/nkCvLWV8vaZg6456iB3bVPCT0oZB+hqi5pOKgwsPPXmTiaEzEn9RrhJW44w2Pwfqi3TsQ6Dfu9P0l3ybKWYAdInoLdi+aJ4W3zR1kQ0n8ldOBhyIHroyIdXtzLis+6cs2Ujq5GJS/A6/NtBnHNUdBJ48INNXJ/WLGStsTQla82QJieGb8Zxqrwc9vHB0Fl4I3yn3KcrakfNvxSS8sa2C15JdjzF8DALPtOnnQ63JoezRzjROBHudTlArlKMkT7k+BiZPigfebSJx1DH/1HLNjihTnyuip6rrDWfrC3BvNemwqySYXAac8OTYdMvV4MBeZrRWEDN6A04NNEYc5ezRP9xKUuceMH5rPX0pTbcgz3JgIBq4yyrAOHrhkmdTr5d
 7RlBgRXP
 do7boJUqn5rFzcuqfGyeEPhq/Oz4vOnMFYr0bL5BWGqe4bQSp8OsZF5Y7nMrPpXgK3or2zql+GiJx7R4lOzw4BTTQRrf7bkJ5/KJ9KNXcwgztyYc+Fbol6+d6bFYgMLEtAnPXvwOjnuioj1tS47y5R/kpH+arl35xn+Jchu+M+6rdcc+eV9lPbSKex0+gtl0ltvO3Wkk5MwCtm5m/9dGPPgbI1P7UipG0nmP1KdpRo3NoUYlkY4yyQvQ5/GSMWhdGZEvgjVVahJdh9xVryjf6uCF7gmHd66YHKn+M
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Mar 20, 2026 at 11:49:18AM +0800, Baolin Wang wrote:
>
>
> On 3/19/26 9:00 PM, Lorenzo Stoakes (Oracle) wrote:
> > The flush_needed boolean is really tracking whether a PMD entry is present,
> > so use it that way directly and rename it to is_present.
> >
> > Deduplicate the folio_remove_rmap_pmd() and folio map count warning between
> > present and device private by tracking where we need to remove the rmap.
> >
> > We can also remove the comment about using flush_needed to track whether a
> > PMD entry is present as it's now irrelevant.
> >
> > Signed-off-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> > ---
> >   mm/huge_memory.c | 28 +++++++++++++---------------
> >   1 file changed, 13 insertions(+), 15 deletions(-)
> >
> > diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> > index c4e00c645e58..22715027e56c 100644
> > --- a/mm/huge_memory.c
> > +++ b/mm/huge_memory.c
> > @@ -2430,9 +2430,10 @@ static inline void zap_deposited_table(struct mm_struct *mm, pmd_t *pmd)
> >   bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >   		 pmd_t *pmd, unsigned long addr)
> >   {
> > +	bool needs_remove_rmap = false;
> >   	struct folio *folio = NULL;
> >   	bool needs_deposit = false;
> > -	bool flush_needed = false;
> > +	bool is_present = false;
> >   	spinlock_t *ptl;
> >   	pmd_t orig_pmd;
> > @@ -2449,6 +2450,7 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >   	 */
> >   	orig_pmd = pmdp_huge_get_and_clear_full(vma, addr, pmd,
> >   						tlb->fullmm);
> > +
> >   	arch_check_zapped_pmd(vma, orig_pmd);
> >   	tlb_remove_pmd_tlb_entry(tlb, pmd, addr);
> >   	if (vma_is_special_huge(vma))
> > @@ -2458,17 +2460,15 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >   		goto out;
> >   	}
> > -	if (pmd_present(orig_pmd)) {
> > +	is_present = pmd_present(orig_pmd);
> > +	if (is_present) {
> >   		folio = pmd_folio(orig_pmd);
> > -
> > -		flush_needed = true;
> > -		folio_remove_rmap_pmd(folio, &folio->page, vma);
> > -		WARN_ON_ONCE(folio_mapcount(folio) < 0);
> > +		needs_remove_rmap = true;
> >   	} else if (pmd_is_valid_softleaf(orig_pmd)) {
> >   		const softleaf_t entry = softleaf_from_pmd(orig_pmd);
> >   		folio = softleaf_to_folio(entry);
> > -
> > +		needs_remove_rmap = folio_is_device_private(folio);
> >   		if (!thp_migration_supported())
> >   			WARN_ONCE(1, "Non present huge pmd without pmd migration enabled!");
> >   	} else {
> > @@ -2483,27 +2483,25 @@ bool zap_huge_pmd(struct mmu_gather *tlb, struct vm_area_struct *vma,
> >   		add_mm_counter(tlb->mm, mm_counter_file(folio),
> >   			       -HPAGE_PMD_NR);
> > -		/*
> > -		 * Use flush_needed to indicate whether the PMD entry
> > -		 * is present, instead of checking pmd_present() again.
> > -		 */
> > -		if (flush_needed && pmd_young(orig_pmd) &&
> > +		if (is_present && pmd_young(orig_pmd) &&
> >   		    likely(vma_has_recency(vma)))
> >   			folio_mark_accessed(folio);
> >   	}
> > -	if (folio_is_device_private(folio)) {
> > +	if (needs_remove_rmap) {
> >   		folio_remove_rmap_pmd(folio, &folio->page, vma);
> >   		WARN_ON_ONCE(folio_mapcount(folio) < 0);
> > -		folio_put(folio);
> >   	}
> >   out:
> >   	if (arch_needs_pgtable_deposit() || needs_deposit)
> >   		zap_deposited_table(tlb->mm, pmd);
> > +	if (needs_remove_rmap && !is_present)
> > +		folio_put(folio);
> > +
>
> This kind of deduplication splits the device folio handling into three
> places, which is not easy to understand (at least for me), since the device
> folio has some special handling.

I think open-coded the exact same thing over and over again is FAR worse.

It's also actually 2 places for softleaf, because we were duplicating #2 below:

1. how do I get a folio?

2. do I need to remove this folio from the rmap? (yes for device private)

3. Do I need to put the folio (yes for device private)

You're maybe now just seeing exactly what happens here because the code is
clearer? Because before it was an unfathomable open coded mess with no
explanation.

Now you explicitly see what's happening :)

>
> Especially here, without looking closely at the if condition, it is unclear
> why we need to call folio_put(). Maybe some comments?

I can add one, the original didn't. This is an existing issue :)

>
> Anyway, I don't have a strong opinion. Let's wait for others' preferences.

Thanks, Lorenzo

