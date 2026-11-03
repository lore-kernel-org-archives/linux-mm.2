Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BA64F606A31B
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 19:31:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gIOvhc3s
Received: by kanga.kvack.org (Postfix)
	id 957C86B05B6; Tue,  3 Nov 2026 14:31:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 92EBF6B05B7; Tue,  3 Nov 2026 14:31:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 845AE6B05B8; Tue,  3 Nov 2026 14:31:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5CD076B05B6
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 14:31:54 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B5B6F80577
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:31:53 +0000 (UTC)
X-FDA: 85394802906.20.F78D17D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 16F2D1A000A
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 19:31:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gIOvhc3s;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793734312;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6qQFBKplrMSRNBunchKBBaYbRmsAxxxZuLJWAbpYJWI=;
	b=FmFDWjfeV5ZcG9HBhj4N0vpSliLQMN0gB67SjHcJ2IfNxG7DmTaWACsyred7YBb52aaJDx
	6Ksl3+2BMzO04j0J6VIUR6Oy34TKnL9LvDgMEsJXzEISyk2jC8nRNwiUv8JHwQvo6oTQPG
	yvLT2KFGcLaowjpZGETo6hJmMHW+NOI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793734312;
	b=lnCATazLt6vHx9poipe7y8JDcpuGtNFNWEuAije/CGoFF7akJyiO9oPgBeaYSw1huOQ90l
	PdEQKK393y8Uwf9jYq+7e5U8WzLEWW+dRuXeg13X3LEnXYxbK0CPktduWq7lYidBVAQzOd
	HLz8I5bA5gjxuctJypyL4qCMGt49rUA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gIOvhc3s;
	spf=pass (imf19.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1424D41AD3;
	Tue,  3 Nov 2026 19:31:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70DAE1F00919;
	Tue,  3 Nov 2026 19:31:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793734311;
	bh=6qQFBKplrMSRNBunchKBBaYbRmsAxxxZuLJWAbpYJWI=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=gIOvhc3sHW4Mz+FyDlGBdAfeqkaIOF0YVwb7ktC45uye+DIulC4ALgE0DrfEQ0nUN
	 Ihc6KGa/FKcE85F2OI5ShvW7kwLSM7ZmZplXKmhm6zJ4Srhf6ODdIPMF0E4Qog0FzB
	 +YiyuLAuSXl1Emb5Q/g/lpXzQITdRB/qFyQgckjojd0zQe65HKOw3d6+6Csc0+TjX+
	 hYRIO8aewf6iGnb+PfjsYhchqWuIDvoTiTWEhX/HPUw0yhO300d2m3vfcmyS+EObqk
	 nQQwWQiA2684ljEfWlJ9wtU/TaL7FOYGN0LsseR4RhHWpEp/eYhmulEn693pHOo7VT
	 Pvx5a6oOTDrwA==
Message-ID: <sashiko-outbox-195920@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 2/8] mm/gup: convert follow_page_mask() to return a long
Reply-To: sashiko-reviews@lists.linux.dev
To: "Rik van Riel" <riel@surriel.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Jason
 Gunthorpe" <jgg@ziepe.ca>, "John Hubbard" <jhubbard@nvidia.com>, "Peter Xu" <peterx@redhat.com>, "Suren
 Baghdasaryan" <surenb@google.com>, "Yuan-Hao Hsu" <aa9736195201@gmail.com>, "Christoph
 Hellwig" <hch@infradead.org>, linux-mm@kvack.org
In-Reply-To: <20261102193026.3860700-3-riel@surriel.com>
References: <20261102193026.3860700-1-riel@surriel.com>
 <20261102193026.3860700-3-riel@surriel.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 03 Nov 2026 19:31:49 +0000
X-Stat-Signature: cxaf5op8peyn5mnptcsxuakfp6s55zxo
X-Rspamd-Queue-Id: 16F2D1A000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793734311-490241
X-HE-Meta: U2FsdGVkX1+mLbaVgVLXXPtLTsW41K60SQ/ZxlzEmObbizXD+YiXjOJDmBmn9IP69H4ys4zpyqUFDqjUt3jek/g4v3FwTAdL66zC1IZNr3Nd9OS7JuQOxASSQIb2pGa2iu25dlL3NdGlu/vI3eLhXdKNZNb0q0mdcEOFM1s7qb0WiFWZ8IkNBPtEMPkCSU6cnfujYRZts+KjWgvT9QEF6/hDCIicPS93qlrzjRaFZDwhNfGLcgOsh7NIGFpV9ehA5iS3oMlsXdr9X9gdHe8lwlpyace4BMrvb/edCWUNhk7pp0Vv2vU12AE2RUwlS5t85teYmC60oIKbyTh0vTQXhXoZw/j8fY8USpw04JKAz6azIFOaa1QV2Kt2Tho9peLTs5bhnmOo3dP3ISq9125gKzMmhb2YBbnjxI6tV6oNCIJwQ6p8cUKbZgzCKaacvnBNp0w+JTrcmEpDPQuRAErYv6MGLYGvxVj/dTijpP/mAuo3TkdFac0fiPXEYovkrLP9H/rM+d5+iOmKpoFDatSHUO1/9J4kiB+wXi6KT1RhGeFGzVIW0Sx8O+T1F1IifdTZVlyjU+RT4hc7x4hfN68LX3O4Nk0AX/eTZsMNm/nnfeEOrlXhVhIhEWNF5oBkAwuAiwM9nzpFwRB2rRJk7tdtqrZjUYK14tpYRDvnRFIipHVNCzaykr61EvI1fPVtOB/2rQWp8cLy0qrQ601U9NU5fMxgaT9klKJehZvGWHZN5yF0MGO75MhJ3VPlq8v20jRYSfJE+aVetCRhrP9YsNBvuYltFqHmBAJukZHXwtPVCXVko73f9vbjSUSQZhm4Ox1nv+J8a732+t/yKsvBx5lE+nok1M8aux4JPSD2z8xN4kU0P6qTPz4jPr1pAUiNV1lUUkqGzt6jaQEhOVSIBBj6u1cn1IWfRffiPFekYb1zgRJMM8HsTivUQffte13t07/+H4M+/8DUK4iIbWGpaTP
 83WWVqv3
 EIrvTF7Nzm8o6g1xM2bYPScjOjVzlwG5jwu9Z8L4au6wBGpdIniMwBiu3EwtHVp4UA94+yIUXD8fmJYtoVjcBsqiwrLvwLLEHqzqWH26adW2033N9PdzNxNt6xzFo+LpUYb7OjD86Ww2+efiFxn0ehATG6DxGEFwkEC4w9iOGj0MexyDZYlX3xhpX4IL2z41G4fyy9hHXcZR0dZLMpA3NZ6dDxCYrB2p1DAKH4G4ZHthanaXGwzVXn5q9GGprOXboFXbMeaBGyXnP5TzrwONafQ+//uDayTFe0GZ0YAteJ8+SeAq98wONY3SUoKCs0PWql0JAHyxwIawdtUJ7ua7uAlN/lmp/2h2k3TYuSq5oCaQxPsxZ42q+999II61fLLNElb/4VK2uGct0LzaKqllZXmM9OKXVHge+qW9j7RepxTyDMPcXil0b1lGoQkYWTlNZHyrUBicktS2NOJEyiRGfGzHh8HL3L1mHaXSIolRObjdFyC10iqjdHjZsVZEzQ40fa1TaSCkVo2i4qzL/D+47Nt35v8npFz2EkungTaPeNrX9gvK5a1l6oFvPh+VXJTyg2Ntj+3hh/O9zjHKJCgUVXiNYyEVHMUoSQnqQ7Yh2sW1Ka1GU5MIJnOhiFS8/VfjFhElPElbSeEPyyfUNBMH63AG+D+dQcCJ7Kh9mdu/MGpUcEK3WvgbmaoGO9XGltlLS7CU2
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
- [Low] mm/gup: uninitialized page passed to gup_fill_pages() in __get_user=
_pages()
--

commit 125cbbdedc195fa32def929c325e903ddc88a720
Author: Rik van Riel <riel@surriel.com>

mm/gup: convert follow_page_mask() to return a long

This commit converts follow_page_mask() and its helpers to return a long
page count or negative errno instead of a struct page pointer, storing the
found page in pages[0].

> diff --git a/mm/gup.c b/mm/gup.c
> index cdbe2ed3e6442..f7d940e7e5ffb 100644
> --- a/mm/gup.c
> +++ b/mm/gup.c
[ ... ]
> @@ -1391,6 +1400,7 @@ static long __get_user_pages(struct mm_struct *mm,
>  	do {
>  		struct page *page;
>  		unsigned int page_increm;
> +		long nr;
> =20
>  		/* first iteration or cross vma bound */
>  		if (!vma || start >=3D vma->vm_end) {
> @@ -1417,8 +1427,12 @@ static long __get_user_pages(struct mm_struct *mm,
>  						pages ? &page : NULL);
>  				if (ret)
>  					goto out;
> -				page_mask =3D 0;
> -				goto next_page;
> +				gup_fill_pages(vma, start, page, 1,
> +					       pages ? pages + i : NULL);

[Severity: Low]
As reported by Sashiko on RFC v3 [1], does this pass an uninitialized page
pointer to gup_fill_pages() when pages is NULL?

In __get_user_pages(), struct page *page is declared without an initializer
at the start of the loop. When pages is NULL in the gate area path,
get_gate_page() is called with NULL for its page argument and returns 0
without initializing page:

mm/gup.c:get_gate_page() {
    ...
	*vma =3D get_gate_vma(mm);
	if (!page)
		goto out;
	*page =3D vm_normal_page(*vma, address, entry);
    ...
out:
	ret =3D 0;
unmap:
	pte_unmap(pte);
	return ret;
}

Previously, jumping to next_page guarded the gup_fill_pages() call with
if (pages). Calling gup_fill_pages(vma, start, page, 1, ...) unconditionally
evaluates the uninitialized page variable to pass it by value when pages is
NULL.

[1] https://lore.kernel.org/r/20260811025157.1632867-3-riel@surriel.com

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261102193026.3860=
700-1-riel@surriel.com?part=3D2

