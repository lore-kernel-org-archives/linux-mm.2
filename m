Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 850B9606A324
	for <linux-mm@archiver.kernel.org>; Sun,  1 Nov 2026 17:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KtPJYDIE
Received: by kanga.kvack.org (Postfix)
	id 6A4396B05B1; Sun,  1 Nov 2026 12:27:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 655826B05B2; Sun,  1 Nov 2026 12:27:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51F8B6B05B9; Sun,  1 Nov 2026 12:27:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 209946B05B1
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 12:27:07 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AA124120A3D
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:27:06 +0000 (UTC)
X-FDA: 85387230852.17.CFD9102
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id 114931C000B
	for <linux-mm@kvack.org>; Sun,  1 Nov 2026 17:27:04 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KtPJYDIE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793554025;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCvl4GH3y9uU8cU83n0Aqgbp55NBVPifWHgCr4BLTPY=;
	b=RfYXPeWE9DOmlGF9oofl+Wlx58b8XpiK/l7mYDwqvjBkVUdiIYeJodHYJckKwevxDZ+Eil
	ELKtre2KlIwapeVmDUgUDwjOP6DOr3g5HzIBy3TVSEyzf8bLO6ZeRzIR8jQH+lDaNPPr96
	fxDkUb03MCwOXky5nMI0lJMOcFy7Y9s=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KtPJYDIE;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf21.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793554025;
	b=QQtEBhxGr3Nced3dRUS6wBlvBeJKW4xkJsV48UqqC2+AtvofA1JPghupiDHSiTbFFYrEbP
	xBYkPJd5hejhQKdQUWPo1lHZ5U1KtgpxQ64WAn6yPLRpq6Ig9TNs17yJK/4c6Sl0euVUCX
	bIgoC9vrq6jfI6Ca9Mg7EviLR2A2274=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 37E8A43667;
	Sun,  1 Nov 2026 17:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5CEA1F000C1;
	Sun,  1 Nov 2026 17:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793554024;
	bh=GCvl4GH3y9uU8cU83n0Aqgbp55NBVPifWHgCr4BLTPY=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=KtPJYDIEFnbveDyEft5FlkpvOHSj4BW2FOlUAthD34fg4TDyUwklta8wENFeI5ZKe
	 lSLS3WMCK55J+q/QHY3dOiIjXffwIYz5Fwco5Tpr0v/COlFbpcIX7YHfZX8ML4VxE/
	 7qOm4+Wlt5+HzdNBB+Ujj+eDuwKaxZJxb2VFfIqOfrzhdNt1i3GBuo5bfDYK8/49w3
	 fEMTGU4X2ka78VMVFdPDDLGKZ4fomFFj79Lh7xCW58imHvrIa4M8wab7KH8kP/tbcZ
	 9EIYEJVsG5y15pMbPi7kJAfI1X7kdc5SQ9r1/gFPmu0F5sEF/mY7oZGqGTzu5p30ow
	 QRFpcw8iXIQRw==
Message-ID: <sashiko-outbox-192531@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH v2 2/6] mm/damon/vaddr: use damos->last_applied for
 migrate action
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261101171630.81477-3-sj@kernel.org>
References: <20261101171630.81477-1-sj@kernel.org>
 <20261101171630.81477-3-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 01 Nov 2026 17:27:03 +0000
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 114931C000B
X-Stat-Signature: ogksz95mfb15zom517rg5nckiwhpybhb
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793554024-925474
X-HE-Meta: U2FsdGVkX19MNyx7xHcbqqy6gf1xZ9+FucolXZ8uONvzV7QjI6bGwLY4+KvIQFcr762tdvSrMk7UhALx9GTll2HL5ZXmAkw+oKA/AujUuoPG7t+SuhlpBZGw7Lm59pe3uhNbd4n/u8A5LVuYmNVyqmNiMInpQorb2xupf8TJw3U/0L91yLVbU78+z5OJxJPvXqRS4BkPIbBZCSNUHvdg82GWJva5IoeplIj3OGVjIvvDk6Ufu5FNEZQJ/AYRuXSAEEd/xOVYl7oHSfoX/FRoYknILvqCPNeJ/c+pqLmp0C+2VxomVhuDairGp5ut8jMjrMGbEKmulgvmlrgdaJVdreZdmoc9JShmU/mqOQc62CCKOyjtGrp+bPisvBUsVKsN6aALzTlRBG737rkOKYTgetOcr4qNfU9TuMaSAe3EOX5ifZ+r62qCe5HHJoxhKu8mrarckGzKhFM2YU24wUnt7BQFykyeqDRWlmc6LKVsMfzJKWNR1wQArxI/bZO0+TcgWPzAhqZzDBCywIn26n2qpdonQrsxT4+PD6V9EROFbUIjAJHQfqPrzIdpwXa04Ws+0bXbvnGW3p49NBXZTwpyLTiC6nY5ImFbaO96oNnoABCP19ZVPFaY0VN+KWzPVb6DkcwD+qdYaAQ2K5a9gcqhU96Iw+3ZKxpZeJ+B5sGlEBFvdHF1VeedbJ+Gu1J28ZYb7mq85RDEu1WHj7hoOUx15ydeci6GX2dvBXhSiNEoiw7ie9LLLqWDHnPqnzA2f3VUC5FshpaAm/8IqyQy7pbKu59nc0woWnWs2JO0uxTnXJ9pLw5STK9MC9EGSjg43Hv9Daxo87eoZq/Ob36YZ6tgiDIB9IyknZgHU99+4e0PoieQOxVSYEwMS/sAI/5/SVpAA/S6WTH2l+ISPaHcs++NFm13nW42Pb+mLrJm44hEVMwuoRwyLZtmZBT6OYYzm9b4VK8rl82XHB9Zm7jFNxw
 3ATTarjZ
 +l6mDIXw9Zw4bZJ8IvktJit0eu0XNlU3Ruu7YGCNFnZPuQsjCAPgihoCIaGcEfLrVt2ZYFF6aepRYcK8rI3vmpVkNPm2dfVZM+VxPTUjMZFkvWFzocg1YTuws8T9wYFUl/4YOKQwDFl6qBPzS1t5SU0F3Fh/3AXzXoD0760JjK91USLdO5AbSKrVW1gK/VTCbva/G5jVc3j8Izh0CRRyTc0l9yWsm68rSnXj4HX9/TeZxrVIQiavCaRAkkBYwyqFs+GrY3Vcswz3K0Z6HaDAKAdYCeeURPvdsxBaEVOYUUsWpzjKBtSC52AiMj+qwT/Bu+e4kagPlq6lYjO/RMsfVNGBsGk1ovbz4NZ5BL27fLFDVIkqsXshCJhrGe11Kx54kJe/VNDJbdL3eaiKYDSaePgvL6dtwQfw/9EJivW5PfWvyrc/MR+4Z1ZMz8n+W3ylcUG+tpcZQA9S/36W4mVF8ALKPJby5qQAhe/ZSzetpSKonlKbptXH/ErIbP8uAVmCTTAcdo8plZrZZHF5lun+DNvK3xeXKrjJ1S7qPJrlUAieKq7nRIDxenLWkqWoeEHPotD6nj1WobGNxtM5FEqj1ivke5ImotsbM99+hxFGQIktM4/aLmQ6VGf11xIOsCdqX1EwR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [Medium] mm/damon/vaddr: last_applied not updated when damos_va_filter_ou=
t() rejects
- [Medium] mm/damon/vaddr: stale folio in last_applied after damos_va_migra=
te()
- [Low] mm/damon/vaddr: single-page PTE step in damos_va_migrate_pmd_entry()
--

commit af5ba00f84f8ca12cd15e44abbd02f8e8e38b95b
Author: SJ Park <sj@kernel.org>

mm/damon/vaddr: use damos->last_applied for migrate action

This patch updates damos_va_migrate_pmd_entry() to check and record
s->last_applied via damos_va_invalid_folio() so that DAMOS_MIGRATE_HOT and
DAMOS_MIGRATE_COLD actions are not applied multiple times to folios spanning
adjacent virtual address regions.

> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index c271b6d63c027..b1d7bcf7305bb 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -834,6 +834,12 @@ static void damos_va_migrate_dests_add(struct folio =
*folio,
>  	list_add(&folio->lru, &migration_lists[i]);
>  }
> =20
> +static inline bool damos_va_invalid_folio(struct folio *folio,
> +		struct damos *s)
> +{
> +	return !folio || folio =3D=3D s->last_applied;
> +}
> +
>  static int damos_va_migrate_pmd_entry(pmd_t *pmd, unsigned long addr,
>  		unsigned long next, struct mm_walk *walk)
>  {
> @@ -854,10 +860,11 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, u=
nsigned long addr,
>  		if (!pmd_present(pmde))
>  			goto huge_out;
>  		folio =3D vm_normal_folio_pmd(walk->vma, addr, pmde);
> -		if (!folio)
> +		if (damos_va_invalid_folio(folio, s))
>  			goto huge_out;
>  		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
>  			goto huge_out;
> +		s->last_applied =3D folio;
>  		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
>  				migration_lists);
>  huge_out:
> @@ -879,12 +886,13 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, u=
nsigned long addr,
>  		if (pte_none(ptent) || !pte_present(ptent))
>  			continue;
>  		folio =3D vm_normal_folio(walk->vma, addr, ptent);
> -		if (!folio)
> +		if (damos_va_invalid_folio(folio, s))
>  			continue;

[Severity: Low]
In damos_va_migrate_pmd_entry(), when damos_va_invalid_folio(folio, s) retu=
rns
true because folio =3D=3D s->last_applied for a PTE-mapped large folio at t=
he
start of the next region, the loop continues before computing page_idx and =
nr:

	nr =3D 1;
	ptent =3D ptep_get(pte);

	if (pte_none(ptent) || !pte_present(ptent))
		continue;
	folio =3D vm_normal_folio(walk->vma, addr, ptent);
	if (damos_va_invalid_folio(folio, s))
		continue;
	page_idx =3D folio_page_idx(folio, pte_page(ptent));
	nr =3D folio_nr_pages(folio) - page_idx;

Doesn't this leave nr at 1 and step through all remaining tail PTEs of that
large folio one page at a time instead of advancing by folio_nr_pages(folio=
) -
page_idx?

>  		page_idx =3D folio_page_idx(folio, pte_page(ptent));
>  		nr =3D folio_nr_pages(folio) - page_idx;
>  		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
>  			continue;
> +		s->last_applied =3D folio;
>  		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
>  				migration_lists);
>  	}

[Severity: Medium]
Should s->last_applied be updated even when damos_va_filter_out() rejects t=
he
folio in both the PMD and PTE paths of damos_va_migrate_pmd_entry(), matchi=
ng
damos_va_stat_pmd_entry() and damon_pa_migrate()?

When a PMD-mapped THP or PTE-mapped large folio spans two adjacent regions =
and
is rejected by damos_va_filter_out() in the first region, jumping to huge_o=
ut
or continuing before setting s->last_applied =3D folio leaves s->last_appli=
ed
unchanged. When the second region is walked, damos_va_filter_out() is called
a second time on the same folio.

If an ops filter such as DAMOS_FILTER_TYPE_YOUNG is used to exclude young
folios (for example with DAMOS_MIGRATE_COLD), evaluating
damos_va_filter_young_match() in the first region clears the page table you=
ng
bit and marks the folio idle as a side effect:

mm/damon/vaddr.c:damos_va_filter_young_match() {
	...
	if (young && ptep)
		damon_ptep_mkold(ptep, vma, addr);
	else if (young && pmdp)
		damon_pmdp_mkold(pmdp, vma, addr);
	...
}

Wouldn't re-running damos_va_filter_out() on the same folio in the adjacent
region then observe the folio as old, pass the filter, and migrate the young
folio that was just rejected in the first region?

[Severity: Medium]
Also, how does s->last_applied deduplicate a folio across adjacent regions
once damos_va_migrate() has migrated it in the first region?

In damos_va_migrate(), damon_migrate_pages() runs at the end of each region
before the next region is walked:

mm/damon/vaddr.c:damos_va_migrate() {
	...
	damon_va_walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
	mmput(mm);

	for (int i =3D 0; i < nr_dests; i++) {
		nid =3D use_target_nid ? s->target_nid : dests->node_id_arr[i];
		applied +=3D damon_migrate_pages(&priv.migration_lists[i], nid);
		cond_resched();
	}
	...
}

When a large folio spanning two adjacent regions is migrated during the fir=
st
region, migrate_pages() allocates a new destination folio, remaps all PTEs =
or
PMDs across the VMA (including those in the second region) to the new folio,
and frees the source folio.

When damos_va_migrate_pmd_entry() then walks the second region,
vm_normal_folio() or vm_normal_folio_pmd() returns the newly allocated
destination folio while s->last_applied still holds the old source folio
pointer. Since the pointers do not match, won't damos_va_invalid_folio()
return false in the second region, causing damos_va_filter_out() and
damos_va_migrate_dests_add() to be evaluated again on the already-migrated
folio?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261101171630.8147=
7-1-sj@kernel.org?part=3D2

