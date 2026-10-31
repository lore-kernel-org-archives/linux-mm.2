Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ACDE5606A31A
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 20:36:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=lBkXbKm0
Received: by kanga.kvack.org (Postfix)
	id CE0FC6B05BE; Sat, 31 Oct 2026 16:36:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C91806B05BF; Sat, 31 Oct 2026 16:36:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA7246B05C0; Sat, 31 Oct 2026 16:36:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 9D79C6B05BE
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 16:36:45 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 87E7DA0A33
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:36:44 +0000 (UTC)
X-FDA: 85384079928.22.4466DC3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 01801A0002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 20:36:42 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lBkXbKm0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793479003;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q1FLDEmGnWMRgBUd/62r3WuYHm0P7ulS+ZFGuHNlRhs=;
	b=nrJbmYUbXOquTE7LmnuDI3EG1k/UClSeDwIISVQJZvrUTrjHLs6BTEdBtewrfpmG+nNBzK
	96VPvZLL5H2OhImVw6HOflPDjcpoWTDb+NAy04LAYrsPtMItZVOprSVaNaGFn3Ab73vxcH
	H0kmx5xXhmWZ4BHjgQn688DyRx7jIdU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=lBkXbKm0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793479003;
	b=QGo9c2gbUcWUnYr9ttL+y1jhZh9nxVfpTTcvcIPmSFpGS+gGRPt64pvgBk6tcJlOX5onqf
	vOt5vgRNfgXToCYhm1g9GICbrO/UbSaFQ8yrKMi3ZXTzCGL9brOsOP852uWXKymrxuuB2g
	0E9NATLvbDQuUMXRwuMV5kbnKOvcOJY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8A394600C8;
	Sat, 31 Oct 2026 20:36:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E4FE1F000C1;
	Sat, 31 Oct 2026 20:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793479002;
	bh=Q1FLDEmGnWMRgBUd/62r3WuYHm0P7ulS+ZFGuHNlRhs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=lBkXbKm0ggNaVdYj3PLU457vdE8DIw4WdjhJH7utu9m9MiI2gHhu5DoA5F2ozLy3H
	 obgcQknCpoL9hjk9AKez74ZHsER4E5uouIY2eyc4sshTDmSphMrIcesMIlqE9YmXeL
	 7tGytCPZgt/MuuJj1WdEth1PnVua4sidm6Am/rxmsb8lTze0EweEPsgi7MdyHtaYXe
	 O47UkGmOQAmL105q33xrAYpzxhRlaXdnKB/cCNqOm01S4/jPRoONubrmTgN/mHhe7A
	 HoZWfM66k+gW4Yglj+0UduQUU4ZXUJuZomdQ8AQikjm30R94Miz2StRk5BEUnn987G
	 Wl38HzVtqMBiw==
Message-ID: <sashiko-outbox-192119@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 3/6] mm/damon/vaddr: implement sz_filter_passed for
 migrate_{hot,cold} action
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261031202614.96036-4-sj@kernel.org>
References: <20261031202614.96036-1-sj@kernel.org>
 <20261031202614.96036-4-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 31 Oct 2026 20:36:41 +0000
X-Rspamd-Queue-Id: 01801A0002
X-Stat-Signature: ifzpma63sjh5se39r6tdg76d5g5h7mhq
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793479002-131714
X-HE-Meta: U2FsdGVkX1+ioUCWM7Dc3Q76jAPpYnzYICux2bJjTSnXk4fsjwq1yI3W5JRmbFatYgEkXSZpHofd3yf5ITjoFEEHXrHWBsHWGEsWwFLd2gDP8d2PG9anNmFUkKBRVk7q6WeJ3pxjV4Hy0mviktzSCkNafMCpxSD/RKxPYsbz2XGqIa6DigAit2i+ZZlne1yqXaNOqhGMtP1dE1lpW+v2aVtXb59CXVJB4njpvHRVwSOiCqQ3qJEiVcZSgtvBN5N4o0xIxfdNCy+QgcHTFs2Vjf55YlPLRzZiNPJ5hHvG1Xh7SMuRlMRSBLuFz4+8QNfYp8VtFWvkBTWneyZnalf2yc7EogCF51bs0TSZH0t4wCcriSpxR6wwxkIcOsfTS1MQbOkdksxtKfBq0ytSG09VtYpbaF2/MQvKEgnTHgJLkfQYl06AdSD1U3305DU7LXNKzTK9mv/HJ0e4oWnEDWgsWoFWCqCewbH6JQITO92caBZpo+FB6meCrYLx/OK9WPc+pH9XO+C9Pz00OlPcPapX0JO9xWJPgLHGBNCbjgoNjckeLoeSSLoymnYpZ1i1x5PmoMyD9yQUD/vl20h+hBAyV0zYR5XPi5XfI+cL9pyGqB59HOTLkPPBzzwUqTXTWMJeGuQD7TQjft+vEgUVzQSf2qkOKbkMD7Cpm+Z4+FAJn7byzMHRqhTAlKBkq6jCLeVKGNjFsntrpFsgqRMEywuRRSYlDocnEa3YIrSQ46PED7Zz+uXs5AGcOn5mP68F63sco0bMFpzN7feN7mZQ/QWaxX73N0vvjZmJL+y6KvGYrgQVTAhnvdYPoVO3W3FhmMY5F2JmjE5XHYiMnsgoCk5Gwnqs6kGSl7haAKUCGmFAqij07TUVCySxIZeKxOMwDAJnxe4C2Uo29MYPk96xcgjGN6naAubfmOPfX1uUlXus+VCPo8VPhTFitHv5qHufHmPZZtvYJ8jUklHvdoUQVmo
 fpNVrCh2
 zP/LpWytjrKmOSVB3Bi8jCkEhIao42S5zT8MEfiZO18dzNGqDhmX0a15dCtbnzbNDVmddn9BHI+v4q5PAAwkNMmhQxGkYgYiDlPo8hiJKKCX0W8ArHtWC1uTFuiLn11lAH78CMW2hoi0sMepOOdwyVGwiYEgCmoXIrP4Sq80r6oITHm/yzSUDXJM1kdKV76S54KAPVKMbzUHljGnp8o42Ufwvj+IPIrNUTdhjT7mAUwc6+BR2aPhHIxis1EaVVAPNQKywtExVUnQEZpnty8Gd99wAv8K0d1LlBZXzbSegBhfGjlK1rfzsR/k7wVDcYFldABzMfB8PYOHavq/nENT7g/fhW/N9/PabXDWehLNccarad9dDIfHPlfudfPNzZP55+W+T/WsbgesmlHEVWZkpWGiRu+G011gPG3Y5mMGeaxEx/qvGg110c4INcm1BjwdJXhk1dIhK5+XFutMTp/RslN5mk53RCWeC9oK39zeLHqaLYXzHAF15O05RiUwAdWoJpgM0Z7wWqTHgH7e2icmSxPM4dfHDLTqe9Sky/H0qJD6vyeZAv4dbhiDiQqorpIRb9nn8ZNuXtIlj+lGRTYaYqPEc5tBKiX+bS5Cchw1spz4VqsgPmHedJL/wRaUJf/eWdmb6
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential issue(=
s) to consider:
- [Critical] mm/damon/vaddr: uninitialized priv.sz_filter_passed in damos_v=
a_migrate()
- [Medium] mm/damon/vaddr: double-counted sz_filter_passed in damos_va_migr=
ate_pmd_entry()
--

commit 872d2945863aba3a6ac672128498f5d65dbc8d40
Author: SJ Park <sj@kernel.org>

mm/damon/vaddr: implement sz_filter_passed for migrate_{hot,cold} action

This commit adds sz_filter_passed accounting to the DAMON virtual address
space implementation of the migrate_hot and migrate_cold DAMOS actions by
accumulating folio sizes in damos_va_migrate_pmd_entry().

> diff --git a/mm/damon/vaddr.c b/mm/damon/vaddr.c
> index c271b6d63c027..112095c2d53fd 100644
> --- a/mm/damon/vaddr.c
> +++ b/mm/damon/vaddr.c
> @@ -776,6 +776,7 @@ static bool damos_va_filter_out(struct damos *scheme,=
 struct folio *folio,
>  struct damos_va_migrate_private {
>  	struct list_head *migration_lists;
>  	struct damos *scheme;
> +	unsigned long *sz_filter_passed;
>  };
> =20
>  /*
> @@ -840,6 +841,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, uns=
igned long addr,
>  	struct damos_va_migrate_private *priv =3D walk->private;
>  	struct list_head *migration_lists =3D priv->migration_lists;
>  	struct damos *s =3D priv->scheme;
> +	unsigned long *sz_filter_passed =3D priv->sz_filter_passed;

[Severity: Critical]
Is priv.sz_filter_passed ever initialized before the page walk runs?

In damos_va_migrate(), struct damos_va_migrate_private priv is declared on
the stack without an initializer, and only priv.scheme and
priv.migration_lists are set before calling damon_va_walk_page_range():

mm/damon/vaddr.c:damos_va_migrate() {
	...
	struct damos_va_migrate_private priv;
	...
	priv.scheme =3D s;
	priv.migration_lists =3D kmalloc_objs(*priv.migration_lists, nr_dests);
	if (!priv.migration_lists)
		return 0;

	for (int i =3D 0; i < nr_dests; i++)
		INIT_LIST_HEAD(&priv.migration_lists[i]);


	mm =3D damon_get_mm(target);
	if (!mm)
		goto free_lists;

	damon_va_walk_page_range(mm, r->ar.start, r->ar.end, &walk_ops, &priv);
	...
}

When damon_va_apply_scheme() invokes damos_va_migrate() for DAMOS_MIGRATE_H=
OT
or DAMOS_MIGRATE_COLD and damos_va_migrate_pmd_entry() encounters a present
folio that passes damos_va_filter_out(), won't *sz_filter_passed +=3D
folio_size(folio) dereference an uninitialized stack pointer?

>  	struct damos_migrate_dests *dests =3D &s->migrate_dests;
>  	struct folio *folio;
>  	spinlock_t *ptl;
> @@ -858,6 +860,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, uns=
igned long addr,
>  			goto huge_out;
>  		if (damos_va_filter_out(s, folio, walk->vma, addr, NULL, pmd))
>  			goto huge_out;
> +		*sz_filter_passed +=3D folio_size(folio);
>  		damos_va_migrate_dests_add(folio, walk->vma, addr, dests,
>  				migration_lists);
>  huge_out:
> @@ -885,6 +888,7 @@ static int damos_va_migrate_pmd_entry(pmd_t *pmd, uns=
igned long addr,
>  		nr =3D folio_nr_pages(folio) - page_idx;
>  		if (damos_va_filter_out(s, folio, walk->vma, addr, pte, NULL))
>  			continue;
> +		*sz_filter_passed +=3D folio_size(folio);

[Severity: Medium]
Can *sz_filter_passed double-count a large folio that spans across multiple
adjacent damon_region ranges?

In damos_va_stat_pmd_entry(), the walk checks damos_va_invalid_folio(folio,=
 s)
and records s->last_applied =3D folio so that a PMD-mapped THP or PTE-mapped
large folio overlapping more than one damon_region is only counted once per
scheme application pass:

mm/damon/vaddr.c:damos_va_stat_pmd_entry() {
		...
		if (damos_va_invalid_folio(folio, s))
			goto huge_unlock;

		if (!damos_va_filter_out(s, folio, vma, addr, NULL, pmd))
			*sz_filter_passed +=3D folio_size(folio);
		s->last_applied =3D folio;
		...
}

In damos_va_migrate_pmd_entry(), s->last_applied is neither checked nor
updated on either the THP path or the PTE loop path. If a large folio spans
multiple regions and is not migrated during the first region's walk (for
example, because folio_nid(folio) already matches the target node in
damos_va_migrate_dests_add(), or because isolation or migration fails),
walking the next overlapping damon_region will encounter the same folio and
add the full folio_size(folio) to *sz_filter_passed again.

Should damos_va_migrate_pmd_entry() also check damos_va_invalid_folio(folio,
s) and update s->last_applied =3D folio?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261031202614.9603=
6-1-sj@kernel.org?part=3D3

