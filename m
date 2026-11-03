Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E9EE7606A324
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:32:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JI2+xBhs
Received: by kanga.kvack.org (Postfix)
	id B7D106B05B8; Tue,  3 Nov 2026 14:31:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B50EA6B05B9; Tue,  3 Nov 2026 14:31:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A67376B05BA; Tue,  3 Nov 2026 14:31:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7090D6B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:31:56 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id C3546120532
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:31:55 +0000 (UTC)
X-FDA: 85394802990.19.4885CC9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 10609A0005
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:31:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JI2+xBhs;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793734314;
	b=pdlDREEf4JFR4GE7ChnLZVvnXSoHsfCceldILswGOYRncFyDo9COs32lapV5ULJzU+8TKj
	QJUfI4dRr8pU1LjsRFPQIYrXdAiuXeR15JWeGC2ynYEBMjbCrZnOWHdzaoOkkJnmmwgnUO
	ZpudgvIv5IizTBHG/Tf9BP/yK1pjTDQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JI2+xBhs;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793734314;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2P+aanhSIUjt/CtBwxlP0d6KuP3pv3GDanOSfY1jmtQ=;
	b=SDhCBbOhHEWb8rjUUtJr3W+1AbwfUPv7RgnWGtfFnAc9ylKYOLAiNGqBEm1F5uYcDAAlCw
	FAvyV51EFpw+vPW0q/KIkNUYOciPdVCeYsfe4I0EAfkl7Olns15fxh4WK/+XmGc/clbxGt
	yA/uH/TqDbNB6gkTHJAjWwX50sXS6jg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3C46E40B36;
	Tue,  3 Nov 2026 19:31:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6612E1F00919;
	Tue,  3 Nov 2026 19:31:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793734313;
	bh=2P+aanhSIUjt/CtBwxlP0d6KuP3pv3GDanOSfY1jmtQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=JI2+xBhsoxFWRAQz4Bp9VqTbhTodASeY0tjiCJ3N2JGDMTP28qVYZdFvkJaNEqdJS
	 3bjo4LFJH3RhJzcOAbbs2hUSF7aR/0/du70opNrsHePmcf+PRD12q1fkBqHYVR+8wr
	 u9eADHO8TzqeGevKcgErAzBVrOvQcJqFmk3qemdmWTBRHm5BDiZPIrAq9EiWtUpS3+
	 S9/4feJGiFQfzRTyvcIl/Lw+VE5UxnN4Ntk2as8ScE4rKE4ZUay/aoEzWUWhF/tIK5
	 D6FglWgeL/q93Htbl9+sPFN/+GyUQ03oYlOaNqe+KPshHDF7vZ+3FPG2wczc6bhiyS
	 GenO30EEBmooA==
Message-ID: <sashiko-outbox-195926@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 8/8] mm/gup: batch contiguous same-folio PTEs into one
 refcount grab
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rik van Riel" <riel@surriel.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu" <peterx@redhat.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Yuan-Hao Hsu" <aa9736195201@gmail.com>, "Christoph
 Hellwig" <hch@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261102193026.3860700-9-riel@surriel.com>
References: <20261102193026.3860700-1-riel@surriel.com>
 <20261102193026.3860700-9-riel@surriel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 19:31:52 +0000
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 10609A0005
X-Stat-Signature: 3ie7yc9umhxx4txnkamfeiadpou8xr7o
X-Rspam-User: 
X-HE-Tag: 1793734313-121776
X-HE-Meta: U2FsdGVkX193cX5UOvYoWLa0JLxMz9NkF6yTyuclLBlXb7nqn2I5lnlsNc2D51XGFeihkYCOaN4MmeoQyriXL0SYf4aCOtZrWZhGtq2vM/Ur3ktObTckR7qPedKZjQ9GHYQ7SyNGM88cRI/ixNdbC4X6jgx46uc2zq62zN4u5Ub9vlE5Yq13rLwqTfRqOOy6PMmLgg0fepfpr/vl+czcxbWL14/CdHw8iNcHyZTvGRxSpS9+yweq3uQ1587nS+UIn3A6wSo9AiAl6Bl66aj3RTD91aajyjAkUDjAsGQ7FhHyAe8Gs4OwRBmc6+Ti3z3F8YHN961/43GGjhEYnJRJahn7A36wtLwOLcva+YrjdTEPvQVp6GebfHeH0YTKrpYrTLRwLUJxfRBOjUU/k5llaFin08ekAD5TRP7Z2WoaQoOXoHORSdG6+m6GJ6pCDbKwZ8kh8IbNmG15QBuy6Vob1GKehd7ymLWsLlXnaVLjFuz6HywCM7DK2/xM0ktm3Pbc5JJxQMpXvc0HkYC0Sq7XcX6+TtoqnqBDp+JXH+yZvYugaR7hZC9zxwczUqnXSjy+uA9Sf08oG1BXnk6GBw0syJRGMoHvDdA0yq9GlmthgEfn+7RZJE2zzqEdo3seMQmkP4QALCw+EEsxkaVG2f+pU2XwssvJdWM8Qfv/N64oCxphsvNc27zRse+dAiObt15aN/xAQSa5vvPAkNi1ln4zoveA+uf2Ot2AWQe/+SqV33naiMfd5hcPW7e5EXEtX7GbuxlYx8MTq7OnRzzKZijqSYBLSNnXmvsnpqLNhcG65qIbclRdjg9V73JDoZTddszoDELlDWyfTeQSGRhiG8T5B6y/++hRX6yeuMKfur4e8SaxrK4RFpJdImA1Rfc9+nQ9v7WkSaykiFrEQ4p7VaPBB8B2I/s+4pqd9Oh4f9XkkJjLhjpjPIYJKX3l8C7eSpiSI7ltJzyD1EzEz+XIqkH
 pEZNyUkn
 9fXZvkcZq/fZn6l5/RxIldRGWxFoEwGJVOKgtfX0yPSxiGJM8quX88GgQEtfNMd5CwIqyJdVbg2PqrU81rvFrMQSDsQ2VaE8FHAO0fVGoE797RfdqszZy91E6jvZbf7NXP/4r4Ggvw62YUeVSzsGmmRC/B4dbxAXCSMjZ4LjZI/SxutC5VRBw96Eac6Svg//QGr3TYuOFIN3r9gdZfsvZSqJR1kbg9D/WrY/EM1wtuqnsPG4//sYkkL2xTZ3YWDzBxrccs4IGUMRf3jGbXtiCf7FDNpXiosOWsDAeL71Q+7GOtE9Tf/0AEMOZG/AHsQ2mwlIhAmJL+mV79tv0IQz7M6xqx48N1L987KQmjgesKkg+/n61Ace5nIEZ14BXU99pW0yoLkeRShgSs/rOBrCHjnl3uJnubW9Lg9PemaacDv0vpFRfURHWKunW/z6BgnC+Qn7BHH0Uu3awP++k8kAj4nXixJNCLPBf1RWicDkFbcCO8/j6xWefrVGANJPbn+VvYQ+3u+B/lPz2sR/2eqocLqGouPrNCDhA+ExABJ3yvQDJ7DInK5K2M+drx76b1BECBw46Fpj0fGsu0UdJAxUa2WDyGHFVJS6mN1dkt7fir0lQUsYWB/BRxKyrnt8FmKGm6ZR7uOiD2J4bI24=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] mm/gup: inverted dirty merge in gup_pte_batch_len() skips folio_ma=
rk_dirty()
--

commit 67f7a0d0fa0dd1ef10a67f56f3a836ca56f23a7f
Author: Rik van Riel <riel@surriel.com>

mm/gup: batch contiguous same-folio PTEs into one refcount grab

This commit introduces gup_pte_batch_len() in mm/gup.c to batch contiguous
PTEs mapping the same large folio in follow_page_pte(), committing each run
with a single refcount grab and folio_mark_accessed() call.

> diff --git a/mm/gup.c b/mm/gup.c
> index 67e20b326be6e..47f204e21a3a7 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
> @@ -937,6 +937,35 @@ static long gup_lookup_pte(struct vm_area_struct *vm=
a, unsigned long address,
>  	return 0;
>  }
> =20
> +/*
> + * Return how many PTEs map consecutive pages of the same folio and can =
be
> + * committed as one run. Always at least 1.
> + *
> + * The write-fault and unshare checks in gup_lookup_pte() are per PTE, b=
ut a
> + * writable run needs no repeat: a writable anon page is exclusive. A re=
ad-only
> + * run under FOLL_WRITE or FOLL_PIN does need the per-page check, so it =
stays
> + * one page at a time.
> + */
> +static unsigned long gup_pte_batch_len(struct vm_area_struct *vma,
> +		unsigned long address, unsigned long walk_end,
> +		struct folio *folio, pte_t *ptep, pte_t *batch_pte, unsigned int flags)
> +{
> +	unsigned long max;
> +
> +	if (!folio_test_large(folio))
> +		return 1;
> +	if (!pte_write(*batch_pte) && (flags & (FOLL_WRITE | FOLL_PIN)))
> +		return 1;
> +
> +	max =3D (walk_end - address) >> PAGE_SHIFT;
> +	if (max <=3D 1)
> +		return 1;
> +
> +	/* Merge young/dirty across batch so folio_mark_dirty sees any dirty. */
> +	return folio_pte_batch_flags(folio, vma, ptep, batch_pte, max,
> +				     FPB_RESPECT_WRITE | FPB_MERGE_YOUNG_DIRTY);
> +}
> +
>  /*
>   * Walk the PTEs from the start address to the end of this page table or=
 VMA,
>   * whichever comes first, and commit every page found.
> @@ -968,7 +997,10 @@ static long follow_page_pte(struct vm_area_struct *v=
ma,
> =20
>  	for (; address < walk_end; address +=3D PAGE_SIZE, ptep++) {
>  		pte_t pte =3D ptep_get(ptep);
> +		struct folio *folio;
>  		struct page *page;
> +		unsigned long batch;
> +		pte_t batch_pte;
> =20
>  		ret =3D gup_lookup_pte(vma, address, ptep, pte, flags, &page);
>  		if (ret || !page) {
> @@ -983,12 +1015,23 @@ static long follow_page_pte(struct vm_area_struct =
*vma,
>  				need_no_page_table =3D true;
>  			break;
>  		}
> -		ret =3D gup_grab_folio_pages(page_folio(page), page,
> -						     1, pte_dirty(pte), flags,
> +		folio =3D page_folio(page);
> +		batch_pte =3D pte;
> +
> +		batch =3D gup_pte_batch_len(vma, address, walk_end, folio,
> +					 ptep, &batch_pte, flags);
> +		ret =3D gup_grab_folio_pages(folio, page, batch,
> +						     pte_dirty(batch_pte), flags,
>  						     pages ? pages + nr : NULL);

[Severity: High]
As reported by Sashiko on RFC v3 [1], is the dirty bit merging in
gup_pte_batch_len() inverted relative to what gup_grab_folio_pages() expect=
s?

In mm/gup.c:gup_grab_folio_pages(), the folio is marked dirty when the
passed-in dirty argument is false:

	if (flags & FOLL_TOUCH) {
		if ((flags & FOLL_WRITE) && !dirty && !folio_test_dirty(folio))
			folio_mark_dirty(folio);

Because GUP does not set the dirty bit in the PTE itself, a clean PTE
(!pte_dirty(pte)) requires calling folio_mark_dirty(folio) directly, whereas
an already-dirty PTE only avoids that call because the page table already
tracks its dirtiness.

Prior to this change, follow_page_pte() called gup_grab_folio_pages() for
each PTE individually, so folio_mark_dirty(folio) was called whenever any P=
TE
in the walked range was clean, and was only skipped if all PTEs in the range
were already dirty.

With FPB_MERGE_YOUNG_DIRTY in gup_pte_batch_len(), folio_pte_batch_flags()
sets the dirty bit on batch_pte if any PTE in the batch is dirty (and even
without FPB_MERGE_YOUNG_DIRTY, batch_pte starts with the first PTE's dirty
bit rather than the logical AND across the batch). When a batch contains at
least one dirty PTE alongside one or more clean PTEs, pte_dirty(batch_pte) =
is
true, so gup_grab_folio_pages() sees !dirty as false and skips
folio_mark_dirty(folio).

For example, if a PTE-mapped large anonymous folio has been marked MADV_FREE
(leaving PTEs writable and clean with PG_dirty and PG_swapbacked clear), a
CPU write to a single subpage sets pte_dirty() on that one PTE. If the range
is then walked with FOLL_WRITE | FOLL_TOUCH (such as via MADV_POPULATE_WRIT=
E,
process_vm_writev(), or O_DIRECT), gup_grab_folio_pages() will skip
folio_mark_dirty(folio) while the remaining PTEs stay clean. If the single
dirty subpage is later unmapped via MADV_DONTNEED or munmap(), the remaining
PTEs and the folio are still clean and lazyfree, allowing reclaim to discard
the modified folio.

Should follow_page_pte() and gup_pte_batch_len() pass dirty =3D true to
gup_grab_folio_pages() only when all PTEs in the batch are dirty, rather th=
an
when any PTE in the batch is dirty?

[1] https://lore.kernel.org/r/20260811025157.1632867-9-riel@surriel.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102193026.3860=
700-1-riel@surriel.com?part=3D8

