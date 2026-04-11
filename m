Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1997F44879
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 08:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B24546B0089; Sat, 11 Apr 2026 04:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD5376B008A; Sat, 11 Apr 2026 04:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9EB4C6B0092; Sat, 11 Apr 2026 04:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA756B0089
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 04:56:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 411761B7D5F
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 08:56:14 +0000 (UTC)
X-FDA: 84645668268.09.A42770B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 4A38E1C0009
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 08:56:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WHX3Imcl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775897772;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EBvnIfCQ9NBEvh/gdYjGzQ0jYzjwOD3bhFRa1cE2ktc=;
	b=Da81iWLTnS6SKUwwZ+brIWSuSzxSf0tqbe/FaOw0AwXZ+CXbcksYWcNgmTJnK2sbeCCNAG
	e3Zzy0moCWY6ZBwT8yTvhBsVWzy78Yv4432kaRGRWmCw1OyJ/otfGcNq8x7xyQhCdS7fPv
	Ns5z1aZLC/AJNX7XZejpL97C0U1ukeM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775897772; a=rsa-sha256;
	cv=none;
	b=DvnNJ1JogM+W5GKDcgCUYPF7qVzqCueXq7lctP5DpbLqwSNOzL4NC4AHAyv2RZASdfZl8g
	NXC2wM+U2r154C9x8+NI1YYv27nexY9hNUERJfuPDFHCM5AwEIOAjdbRVE7/uyPgfbhblF
	2NXcqoAftewC8lp5Qd1ipzzdIfI0Blo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WHX3Imcl;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 4613E444D4
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 08:56:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DCCC2BCC9
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 08:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775897771;
	bh=YywOpM7IN4lQ5kIAgd6HF7Gg64mb8PV9Z7KFjj8isaQ=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=WHX3ImclpYmdoj5iW0K/F0mEWZ6Mil3VVB6bnK1Q2Vq08o0AHTrYvw1U9t3nM3mKy
	 iXe1hQT+yBziWs53kmGjlRnmzUGDr+hlBRtvGIVprt8AS0OPMKllT5YWerTBt+2ONL
	 38QoMpJQqdcaP+NNvRpxT5VKEhAg+VwY8JSxOUh+hzKhLZ1RvJZafBUKSILdmRuq8x
	 GRWkwo9p3JkoQxpofZUGpHP+5ZzCOrjoT1QFPMzZDnX+AV8XHwQnRP8bh57crLgbvj
	 EH6JxGblRjpZRMBkmi8qr7mrhDOOnsiq8Q7kJZAsG3YWhroLQJUsH8DsXj08Rto+Ck
	 vjcsnPwTDTjvw==
Received: by mail-qv1-f49.google.com with SMTP id 6a1803df08f44-8a56ca653ceso35156926d6.2
        for <linux-mm@kvack.org>; Sat, 11 Apr 2026 01:56:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCVnuKnUIRkPdbRzCA/sDDXd4KjXZ8t7L+9OkvFRDSaOGrQnWpsYTKHU6rvfPU9ymMhmlJu6DQeQgA==@kvack.org
X-Gm-Message-State: AOJu0YznRzib0Q1rUYFKq/gBQhY/VellggVvNYhHkbP04s6X8tBObkxK
	0DFDRgBt19j7zb7L/0CFFOWcHiiCOOFLk0JNYzX0Bh1PiFhYX2Pko7YGi4tKPq+wXWSLULEQva0
	eKf153Y7n0oNGKI84tYGbQdeyCq3gfo0=
X-Received: by 2002:a05:6214:3101:b0:89f:2ae0:3a02 with SMTP id
 6a1803df08f44-8ac8617f375mr82998306d6.19.1775897770204; Sat, 11 Apr 2026
 01:56:10 -0700 (PDT)
MIME-Version: 1.0
References: <20260410103204.120409-1-dev.jain@arm.com> <20260410103204.120409-3-dev.jain@arm.com>
In-Reply-To: <20260410103204.120409-3-dev.jain@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 11 Apr 2026 16:55:58 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zK1W71iSP14gi=8yWSg80EjgYiBXqLChB2i+X+RSTWcw@mail.gmail.com>
X-Gm-Features: AQROBzBT4p3TkI-zntWD7TAz5bcjDOd-bXqlgTLsx7BMmxNFn08oNIiGqdnB9XY
Message-ID: <CAGsJ_4zK1W71iSP14gi=8yWSg80EjgYiBXqLChB2i+X+RSTWcw@mail.gmail.com>
Subject: Re: [PATCH v2 2/9] mm/rmap: refactor hugetlb pte clearing in try_to_unmap_one
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, hughd@google.com, 
	chrisl@kernel.org, ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, kasong@tencent.com, 
	qi.zheng@linux.dev, shakeel.butt@linux.dev, axelrasmussen@google.com, 
	yuanchu@google.com, weixugc@google.com, riel@surriel.com, harry@kernel.org, 
	jannh@google.com, pfalcato@suse.de, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, bhe@redhat.com, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 4A38E1C0009
X-Stat-Signature: aq17aqudwxgr4zf54o9i689fbdqwaj1h
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1775897772-868669
X-HE-Meta: U2FsdGVkX1/RSkKC8jmMlSCMbRJpbTAU9t++Lm4S82We0DqcIjyC+EYK3EmMt8PjX5q70tku2tFl0qyd06jOm5vJbWSaIUKYwfe4lszZD2I+8If0Po7n1tJ5BfTtT98ANaQo1WG5lfz4i0sjsh9XGQlP7CPYLaFawXnVQhWl+x7+7QoyKkvJo7rMc5zQ46gf9Jpzkzzuf6n1Kx5MW393mumagp4c+e2lw/DInNINixexXlYMzH2S4U1e2UIJUnvdy58dMKWFxiYJ+Nrkd4MbMRCNkoZJgSZbtBXWYpMiwoRrcaROyVwpoY0jtPxcXCrGGMGFWCggoGkCzUjUQq8oOl/uMvb35GargR1BpvEL17S17+RiN/VruxIKmaEsDr+p9UTM9z1YPUvdQ3doKF6tcP/8MC2FLW5I5rEqg8qrA2GAN8ICtxXfPES/8m2G9bDH5XK5NVmF4shNVizXXXO+hkYQ6F6E49QUA9zCq+q0gj4IghIk54hV+40MQ9UuiAJE4CJ2FxzvWKUKPNBV7SMg9aIECMJPNcN6EqHIjnfTSbGyQLMGc4iRSvFabsq6J5EdTx5upoUQCIF+rzoXryOI4DTJcWJWcIlbkIRM+8w83E7tS1f9FpdhhD+FwsyhsnLtba9cvKA/z1wgMSZxJDVhQiB3950IRPMnLU2+YNCNz+1LESj2PaduOlBrXsHkE/xIDIWmpPWqnBi7E81JpiF/bCSUCUrWhaC2yj/3FWqAXK2FCcAKItmxUrmJUK1cbYWChUNMDdDT/N69S8MeEdH/s6GF4r/g0bfGLHBPBhEo1bdCcXEUjm71hd9rjIbZdKy5h2HEaVZDwcq8/pdPPL+HjXpqRUZ8rJ9saAf6hvcy4LnDYg2Hi14IFR002tzVQjBrsa6GcN511oAcym2vgaMjNivI8fFE1kW0Qi3cQITyAjz4ZxYx4kdG0m5QqEPqndu59GiqG/0kJw5WFxmPT6q
 a/MJJTVU
 mkpY5sLNTVIe82XRU61tUUvIu4eQ7XjulYB69XwYJKejH5k2S/Qzi7ZEwC7kpVVinhn++VKQUyJBHyF4Cv+QLUo0qZoTpnUqFYBvPVhjEYeAdjUJSE9B2AP7vsDFKDKjEFr3kjdGZLVzcZkBdYVPFyIE5J1ELya+6zzRg4tfn+ztQ5Zp6tYbBwgugFTCNMs70HVz2JXgUtV7Ipobc13zCkmOjA8qA1oapVOMzqwswHrJHvRRkvYPdqVMNnnoHG5BBzY2RGCJhvVfNyGAnhm/bnCi6EVH2uvnYJRBDP6p5+r7CPZvBaxLuSUS4DT2sgSIXusKozEU9rsRc1Obaohf0PW/GcvTHAGwTqU4E48XUW7Pm1Qeho9O5YPevhotmKsYfvkCv+E1slUWvC70=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 10, 2026 at 6:32=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Simplify the code by refactoring the folio_test_hugetlb() branch into
> a new function.
>
> No functional change is intended.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---
>  mm/rmap.c | 116 +++++++++++++++++++++++++++++++-----------------------
>  1 file changed, 67 insertions(+), 49 deletions(-)
>
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 62a8c912fd788..a9c43e2f6e695 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1978,6 +1978,67 @@ static inline unsigned int folio_unmap_pte_batch(s=
truct folio *folio,
>                                      FPB_RESPECT_WRITE | FPB_RESPECT_SOFT=
_DIRTY);
>  }
>
> +static inline bool unmap_hugetlb_folio(struct vm_area_struct *vma,
> +               struct folio *folio, struct page_vma_mapped_walk *pvmw,
> +               struct page *page, enum ttu_flags flags, pte_t *pteval,
> +               struct mmu_notifier_range *range, bool *walk_done)
> +{

Can we add a comment before the function explaining what
the return value means?

> +       /*
> +        * The try_to_unmap() is only passed a hugetlb page
> +        * in the case where the hugetlb page is poisoned.
> +        */
> +       VM_WARN_ON_PAGE(!PageHWPoison(page), page);
> +       /*
> +        * huge_pmd_unshare may unmap an entire PMD page.
> +        * There is no way of knowing exactly which PMDs may
> +        * be cached for this mm, so we must flush them all.
> +        * start/end were already adjusted above to cover this
> +        * range.
> +        */
> +       flush_cache_range(vma, range->start, range->end);
> +
> +       /*
> +        * To call huge_pmd_unshare, i_mmap_rwsem must be
> +        * held in write mode.  Caller needs to explicitly
> +        * do this outside rmap routines.
> +        *
> +        * We also must hold hugetlb vma_lock in write mode.
> +        * Lock order dictates acquiring vma_lock BEFORE
> +        * i_mmap_rwsem.  We can only try lock here and fail
> +        * if unsuccessful.
> +        */
> +       if (!folio_test_anon(folio)) {
> +               struct mmu_gather tlb;
> +
> +               VM_WARN_ON(!(flags & TTU_RMAP_LOCKED));
> +               if (!hugetlb_vma_trylock_write(vma)) {
> +                       *walk_done =3D true;
> +                       return false;
> +               }
> +

Sometimes I feel walk_done is misleading, since walk_done with
ret =3D false actually means walk_abort.

So another option is to make this function return a tristate:
WALK_DONE, WALK_ABORT, WALK_CONT. Then we could drop the
walk_done argument entirely.

Thanks
Barry

