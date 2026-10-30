Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 142D9606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 02:14:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Uk/e2aY6
Received: by kanga.kvack.org (Postfix)
	id 1619A6B05B9; Thu, 29 Oct 2026 22:14:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1144F6B05BA; Thu, 29 Oct 2026 22:14:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 029526B05BB; Thu, 29 Oct 2026 22:14:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C36BC6B05B9
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 22:14:01 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 461BA120577
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:14:01 +0000 (UTC)
X-FDA: 85377672282.19.EC7B4FF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 9459DA0005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 02:13:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Uk/e2aY6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793326439;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ghcOx6/ELd5FKPj91MeOWFNCOb9edDgRexM549ZCl6Q=;
	b=DMSyeEHVUsUTOhrsYC2zVLJBtAJcqMEwLMxE1/KYiJbodxZtZkk/GTFgofnE+xF7vlwQmU
	bZArPEIiBp731QmySYx5dbBHqP7g41pOglGo1Q6VCmzm9C+yrokJfPSmV8z5ptVMUnKDeP
	I7OQqCN7YSHUfWcvMXHAQIFp7YnJiio=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="Uk/e2aY6";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793326439;
	b=Uhk2K/SvyGDsISlp7BV27kYenROwCUjslcM18FR3mb1S/4AHn5aGJww48KfAfJ3gckPuou
	NfAcj7m9htKNRLkVKCtU+gNbmhqko90P5qYk2q6zlIj8SDvFpWz5VwdcGq28y/tACcy+Zd
	wbepgTnWezvGi1RxkJ9rN6xi3lMFy0k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFC6F40A95;
	Fri, 30 Oct 2026 02:13:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 692AD1F000C1;
	Fri, 30 Oct 2026 02:13:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793326438;
	bh=ghcOx6/ELd5FKPj91MeOWFNCOb9edDgRexM549ZCl6Q=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=Uk/e2aY6BHMy22KnLxIUiRUP19Sz9fT9gN7EmAZAF1ysfiuS4tL3zxo5J/K+629w8
	 RUhnIoBErmrZFvUMua1hJRXaHfQrxPe3lmwJDM+ddbqg4tZPb94Co4Ay9DfPWVPyRu
	 XTWsqSViVABwjVS9vrIL1EHcl0H8YTeQzviORivajEZbHU0oc2B3BiFMseN4QGBx6k
	 HYchOztE0MWIHogMgfCI2AXsYZJ1tCuidIIJJJ+s2083MX5GePW6eVV8oQ2u7E7ymY
	 dxedU4SbpsRtzKqjZ6N6xhHolpf0sOtQY2t9pRSN9Nxy5pMNJV1+y80ab1ZccE6Bm5
	 6pMruc4lGxjKg==
Message-ID: <sashiko-outbox-190168@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4] tools/mm: rewrite show_page_info.py with modular
 design and new features
Reply-To: sashiko-reviews@lists.linux.dev
To: "Ye Liu" <ye.liu@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>
Cc: "SeongJae Park" <sj@kernel.org>, "Stephen Brennan" <stephen.s.brennan@oracle.com>, linux-mm@kvack.org, "Ye
 Liu" <liuye@kylinos.cn>
In-Reply-To: <20261029-show_page_info_refactor-v4-1-f28c8176e2d8@linux.dev>
References: <20261029-show_page_info_refactor-v4-1-f28c8176e2d8@linux.dev>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 30 Oct 2026 02:13:57 +0000
X-Rspamd-Queue-Id: 9459DA0005
X-Stat-Signature: wq1ngi5uicxcpizuz8btyt5rrtt4mzep
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793326439-728642
X-HE-Meta: U2FsdGVkX18sIHNmV1Ugr2WrkaBscwLhrbJJ8z4XLcKpFyfB3UFbznyi5d0Ge5vdenI3n1KXiLY1i0l7xrrG5atMrKMtlsc5gq2xVAOiNBgTkReiECEVY2n0C/buKK7XgEH+KELrtPLb0a6N12bPhWiuxd97ypvTfUJSB+mrzsGuiBo2E1xDaa65maEXciT8Dex6HU4xxVjR5yAV6fkXmS1/ekSCRlt/yAT33rXHI0uk8Uve5pZQyvp9AXvclW4EjH3P1+x0fvgGCQjYviRNHp5PsTuiYgNalo0gBgxVGUIjLSDhV13OSe0lr9cdrk8440YF4SRp4CfMCseN0xrbm35qseN6vlrGmcwN+tI+ubVyHjWb7NYPAia3zGwhb15xbyS0j/53T1RgDotaBjGOJfHrIkiOwgs8BovQYw9QCIm2iumYB0QcQUOLeX0UJuwxeU98Dy2PwRwiEvmBldjQusyXUnAkRnMgc7u+IujyRSAGbBMXzkBeVQKvp87gEpOj7oPAkEAbEoNOxGKWTiyTW2GCrpb+kgUcSmy4KzJIyboXo3UpBDy8E+qYTqNr0aYTOhIRyvzOmr039qG+pz4nfDTdtUbOh4e+H7TNoLvpi8Xh+msgA7voG/WAlJDCLekWOUjD9aPJDieeDBEsnZ0cXcqF0XMh/r29KQd7e6m0ovhczuUS73fFq8TwSV5Q0q+i/ZrOVWJEAxLxf5y1nXHqLXtnV57YEdwMth32HevAKMH5C8B07oZ0wgMfbuiateOnIlGPwS0/rsSkhHm0ODbyFmWOpWmcQ/G6/ojB0w39C9EAdK6sgjWUZvfyfzpYatUReB8Vkhz7FvfTxznJ1NKuYL2clQKH3RVb2xd9B6oAjTKW1UgHTvdpRveQN2e7aH8XxpxA13E0t0TF/nUKqJxDuSbPKbDsOACvKjYTa6tvaO4JR3/fNII9KQ9gHyLjBIIL4vzcHJR+jctyvj1Z3p9
 Tgt2Q5Yt
 G6k0vKJa62rOrjPG+nYRc91RIN0A/A/gCJtqmB+hI7fXtm6t73OC2SSzLMR1MYT9njG6VB8pklZWkk4BjXSpI9kIIOCki+NgRxVzlrQ5nh5JKBr0qZTqY19ONOFlOSPXqj9UCp8b74/ZqR6Nv4meHKVX7DxzmTgA9qrNoYOZ+Izfi45aG0hCXOPL23l4WWd/Gux5qMqTfmzXaViufUinSWgpQahiOC8kQ2HZOEaEYdy7OwFoXYRBFBjYp6Kbpap6IE/nOw1ciMlRdvXXWf23m17FnpZKBAkGYn/+G9AhFoyzJpsatSMsB2QtdcTpijFUv6wBIytOkbsU5vyTLxCV0Bg7NhH9+oOUJtTNDMWHHEbDeT/kV5yj6sIXMBXBDaWZ8Nu++q6yviFaXZKRuxCuSWBdWCu3qDUAFJgadVwDOHNyWhuJ4Yow52jBRu+7+znR+1wIu1fPCxBzmthM5J+iAavzLKhpc41STIRg56XnAZSFryNudSPcEMUqoua4aJfij+r0GIXB3qkoaOnH1tv/euRD+PF2b1hrrxp/j0t8RbAUjxX+hIjstYL3WP76Jq1fmLsS9nBc7sbGctCqmzFaFk42Btd97f61PyxLgp8lUY3bDIq4=
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
- [Medium] tools/mm: _page_fields() reads head._mapcount on typed and compo=
und pages
- [Medium] tools/mm: unhandled AttributeError in _scan_page_types() for sla=
b pages
--

commit 6fb0388630d5dc0fef903fe1ea732b1f50562c48
Author: Ye Liu <liuye@kylinos.cn>

tools/mm: rewrite show_page_info.py with modular design and new features

This commit rewrites show_page_info.py into a modular field-collector
architecture, adds new input modes (--pfn, --page, --user, --selftest), and
introduces reverse mapping, page table walking, and additional page state
reporting.

> diff --git a/tools/mm/show_page_info.py b/tools/mm/show_page_info.py
> index c46d8ea283d7d..2202be56465c4 100644
> --- a/tools/mm/show_page_info.py
> +++ b/tools/mm/show_page_info.py
> @@ -4,166 +4,918 @@

[ ... ]

> +def _page_fields(head, fields):
> +    """Collect non-slab page fields (refcount, mapping, anon/file, etc.)=
."""
> +    mapping =3D head.mapping.value_()
> +    fields["Page Mapping"] =3D hex(mapping)
> +
> +    if mapping =3D=3D 0:
> +        fields["Page Anon/File"] =3D "Unmapped"
> +        refcount =3D head._refcount.counter.value_()
> +        if refcount > 0:
> +            fields["Page Refcount"] =3D refcount
> +            # page_type and _mapcount share a union: for typed pages
> +            # (reported as "Page Type"), _mapcount holds the raw page
> +            # type value, not a mapcount.
> +            if _page_type(head) is None:
> +                fields["Page Mapcount"] =3D head._mapcount.counter.value=
_()
> +        lru =3D _lru_type(head)
> +        if lru:
> +            fields["LRU"] =3D lru
> +        swap =3D _swapcache_info(head)
> +        if swap:
> +            fields["Swap Entry"] =3D swap
> +        return
> +
> +    fields["Page Refcount"] =3D head._refcount.counter.value_()
> +    fields["Page Mapcount"] =3D head._mapcount.counter.value_()

[Severity: Medium]
Should this path also check whether _page_type(head) is None, and pass page
into _page_fields() for compound pages?

In struct page (include/linux/mm_types.h), page_type and _mapcount share a
union. While the mapping =3D=3D 0 branch above skips Page Mapcount when
_page_type(head) is set, typed pages such as PGTY_hugetlb (which sets
head.mapping to the hugetlbfs address_space or anon_vma) and PGTY_zsmalloc
(where struct zpdesc overlays mapping with movable_ops) have mapping !=3D 0.
When show_page_state() calls _page_fields(head, fields) on these pages, it
unconditionally prints the raw page_type union bits (such as a large negati=
ve
number around 0xf4000000) as Page Mapcount.

In addition, show_page_state() only passes head to _page_fields(head, field=
s)
and reads head._mapcount:

show_page_state()
    if PageSlab(head):
        _slab_fields(head, fields)
    else:
        _page_fields(head, fields)

For non-hugetlb compound pages (large folios), per-page PTE mapcounts are
stored in each subpage's page._mapcount, while folio-wide/PMD mapcounts live
on the first tail page (_large_mapcount and _entire_mapcount). Reading only
head._mapcount loses tail-subpage PTE mapcount reporting when inspecting a
tail page and reports -1 for PMD-mapped compound folios.

[ ... ]

> +def _scan_page_types():
> +    """Scan all pages and categorize by type. Returns {type: page} dict.=
"""
> +    from drgn.helpers.linux.mm import for_each_page
> +
> +    objexts_flag =3D prog.constant("MEMCG_DATA_OBJEXTS").value_()
> +    mask =3D prog.constant('__NR_MEMCG_DATA_FLAGS').value_() - 1
> +
> +    found =3D {}
> +    needed =3D ["anon", "file", "compound_anon", "compound_file",
> +              "slab_multi", "slab_single", "slab_no_objcg", "uncharged"]
> +
> +    for page in for_each_page(prog):
> +        try:
> +            head =3D compound_head(page) if PageCompound(page) else page
> +
> +            if PageSlab(head):
> +                if head.memcg_data.read_() & objexts_flag:
> +                    try:
> +                        slab =3D cast("struct slab *", head)
> +                        if slab.obj_exts_needs_objcg.value_():
> +                            slab_stride =3D _slab_obj_ext_stride(slab)
> +                            n =3D _count_distinct_memcg(head, slab_strid=
e, mask)
> +                            if n >=3D 2 and "slab_multi" not in found:
> +                                found["slab_multi"] =3D page
> +                            elif n =3D=3D 1 and "slab_single" not in fou=
nd:
> +                                found["slab_single"] =3D page
> +                        elif "slab_no_objcg" not in found:
> +                            found["slab_no_objcg"] =3D page
> +                    except (AttributeError, FaultError):
> +                        pass
> +                continue

[Severity: Medium]
What happens in _scan_page_types() during --selftest on 32-bit kernels or
kernels without slab.obj_exts_needs_objcg?

In mm/slab.h, obj_exts_needs_objcg in struct freelist_counters (embedded in
struct slab) is only defined under #ifdef CONFIG_64BIT (added in commit
7def2e8549e5 ("mm/slab: introduce crimson_flag and obj_exts_needs_objcg")).

Earlier in _slab_memcg_info(), the access to slab.obj_exts_needs_objcg is
wrapped in its own try/except AttributeError block so that if the field does
not exist, execution falls through to _collect_memcg_ptrs():

    slab =3D cast("struct slab *", page)
    try:
        if not slab.obj_exts_needs_objcg.value_():
            return "none", "/sys/fs/cgroup/memory/"
    except AttributeError:
        pass

Here in _scan_page_types(), slab.obj_exts_needs_objcg.value_() is at the top
of the single try/except block covering the whole slab classification. When
it raises AttributeError, the entire block is skipped, so none of slab_mult=
i,
slab_single, or slab_no_objcg can be populated and the loop can never satis=
fy
all(k in found for k in needed) to terminate the full page scan early.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261029-show_page_=
info_refactor-v4-1-f28c8176e2d8@linux.dev?part=3D1

