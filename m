Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD3FCC531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 04:53:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A78C46B007B; Sat, 25 Jul 2026 00:53:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29AD6B0088; Sat, 25 Jul 2026 00:53:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 918A16B008A; Sat, 25 Jul 2026 00:53:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 64D7D6B007B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 00:53:54 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C4B7F16025B
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 04:53:53 +0000 (UTC)
X-FDA: 85026081546.05.655E614
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id DFEC7100006
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 04:53:51 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fOol+PTD;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784955232;
	b=cnW8wpxO3+cHMYBDizdLliFRls2MyqbTjOpf3sEeKIzlfHcT4zqXj7tymEuD7RZwS3gcJF
	NUPDJQYxJ597M44wQYXYA7mNS5Uq16S0w4+UQW7rn1E3XFPbaMlg4zrKdfGyiVWZcrQMSH
	69Rd+k5eFP72b9EmY/Tg20CYM2fq498=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=fOol+PTD;
	spf=pass (imf05.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784955232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xWbpivyLXZlohbWMfmwnRYCrPycX5fwAfGOSGHId/48=;
	b=2HYUB/6d6vAy02zGG0iS69w3KwFa0zVZd4DWkCxgs69RrP3D4AFHIFkK3mnoJUJAdfgr0l
	G/LEqyxldYs02ohFahfF/faFWtZPJW8Bn5tUey0/WGp/f72MFVEg5OMb1XK6OG0rO8FfxZ
	8wiJC0pXT6kWSZ+f3czK2iz+MVzIwxc=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5FAE44FE3
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 04:53:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB411F01561
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 04:53:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784955230;
	bh=xWbpivyLXZlohbWMfmwnRYCrPycX5fwAfGOSGHId/48=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=fOol+PTD9EFVhyDlfoVIQLNeQWU6WC51E8aQ7lXY3+NO77u9JkbtSFGfBeuImUxSX
	 FaOnwAtGgCNx6kKsFoUAuzIBg9nN3L1DB1CyniwPiFSc0rbVI3HIIYQgRcX5er3JSH
	 hqTWAT+txVS+U/J4lS8YjeFEYX51sCTzXwWQWsbXqonz1U06iGzkIJuOEi90abZJ3t
	 sTPT/4NqsYv+G2D4m8I/k4wHHSYaJhSs2skOC3UIC8gQJ3tUxsyE28MKS6yjlbEAi2
	 JCJ8uKODJjhzVmuzS5zDm1RwnBN/6oy8KqgTVsgpxokzkLOkljY9VVDSTcEaMpSWTf
	 b62NyLmF8xLlg==
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-92ed19f4d60so91604685a.0
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 21:53:50 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Ro25fWoN1NwJklGUS3HJDn+tL87rKvPA3CcuS3tz/7DZLgIEZPiqG9p7q1c/xkvraPe0/oP3obNgQ==@kvack.org
X-Gm-Message-State: AOJu0Yx0U8ToMx06xxTZc2+ODxZ4SrXD3/KMYbyKsIGTdq7a6fQv/RC4
	q2KbsVnx7QS5zDTyU1l5xobonZrmjzDUlfXVCKV29ZQXwwlPRt7YESfT7fwH/5XFVYlAow4q2SS
	aJmQOeH4PGXvB4gTuzrNhSRmYHvD2xQo=
X-Received: by 2002:a05:620a:25d2:b0:927:efb0:3ad1 with SMTP id
 af79cd13be357-932defc8055mr95072885a.26.1784955229891; Fri, 24 Jul 2026
 21:53:49 -0700 (PDT)
MIME-Version: 1.0
References: <20260723070905.3422276-1-dev.jain@arm.com> <20260723070905.3422276-3-dev.jain@arm.com>
In-Reply-To: <20260723070905.3422276-3-dev.jain@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 25 Jul 2026 12:53:37 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wyRz01Z+Zv6RdiRJabsBm+0+obsqOW7v-h03OOzHcx+g@mail.gmail.com>
X-Gm-Features: AUfX_my0lYFE8qCC8whqWjpiitY8Sh-B9MckMlLBj30ED_W3sXbpfyRb_w2Mj2A
Message-ID: <CAGsJ_4wyRz01Z+Zv6RdiRJabsBm+0+obsqOW7v-h03OOzHcx+g@mail.gmail.com>
Subject: Re: [PATCH 2/8] mm/swapfile: add batched version of folio_put_swap
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: DFEC7100006
X-Stat-Signature: dsypqyhab9n1cs6d3cpng5fh5zy3n4od
X-Rspam-User: 
X-HE-Tag: 1784955231-2094
X-HE-Meta: U2FsdGVkX19vTwbNiQIdFvGDfyCCAwJT6rrXXvKqaXHSNGu2MUAezQFLmtedyUGsQSAu1e5uOUBfCrAyfiKT5qPTEjjUjqmi9dFN8u/r470mgmhAM5xXBjDP+Hrr3xaZRpAYxJQ6yqYj0lH3RcALKHTcfDiR+FV7PiHolUU3wWray0NkyJ0Yg7mgZRQ6shN7HlARqe2xXpqsCfR4UO2ydJIOo7pI3gNm7Q2ESvYgp1pkXWqvQuQ81ueJfJrLt5TQ+int4aUEEvYKo6ZgLv/wg+pZzKrc61w+p6oMXGY5/yj728P7p5C++vMIT5SjhkRovhVShDPLMje0fpfMxU18WU6XyL1T71Sp0u9mxo04LKBAR7HPteLGIL4Or0D43KY7YBd5i5KRT6GJwR6jMCpoxhMlRZocG8v4v3Atm13zsH10vc8o1VhxkHQv8zcrQUcqWy2SQA6xVotApzUs5Kfedk0ucyNYZric1ZfaBe8bl/4dPvQ+9BFR354ZjjQbCs9xnjR3fF17k+VEEJMc6waOmwkKwP5iOkw5dpX87vWdADLKyCvhotW7grIOenDmJ8VO5xm7bFWdP7fWeJ1MM34ifFLRNbJZsacu1hZG9TFxfK6qb6z7ZMW6vZfx7SCsfCxj1NBYScc32um1iZlH1IDKtARV4iC0qWUaA1zbilSdzKXDH2AOwt/VzmyJ0ow6GW85Ri4L0o+xoKaWiLKuvlXbQcNNeDP7v1vFB8um9csfcdndH85fg5SkMRthBPeaUqyUeT82xIwjtica8ufPAJcypflxrNZQVPRh2aIP/xMKIF03GPiJlnMbEQ0gmmNEEb8ZJa9SmJjLTI+RYeDIOitfmTERHYGB1OUtfixbct647/WbNFLsjtVguTBzHPrEZ/QV9xlZrZ3e07osLhmcVA/1XzUw8ZLJ00uZR1kBAlo2FEK0kejuTDmLrEEiGrH/kjQFWAR/2L3BZMokV35qWa0
 ItQqFT0o
 1o3EK6GTlg9GEzBnClOsmXxXtFvEzU60ym7g7t5BTgFmkaZMSLEnQZrk6T5oM7zMDaIpxN7HYtLYKEM4tpJnWMrUho9D35s4moL7aJsTAgQegXLH175Hf2cbDkEkGhzKzIhBOjzOP8sZU/RF/aDBZo3/BS822DiPhyp4o7BjSBlWrweZBf6VkeTqgsJq07qlGhhRKCGb4YGQCUWuXtXf3pIFIz/Dc8RVh3odUcuuT2c1bqpWU5oSrXj1E4XZNq4uFjeaaF2AMsGyQNwiHX2ewKxAVmwaeF2Hhm3XYS4FX1Z5Rog0jnLtKHZf75KObAyOImYupzX44eRMrAddM/FFu6eyThnId8bXwfc/fQptzzvdecO+JuhCPWiCA9or4HU4BWDJUIGa+A5F4+LKn5GE/dnN877hWoewn0GBM
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 3:09=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Add folio_put_swap_pages to handle a batch of consecutive pages. Note
> that folio_put_swap already can handle a subset of this: nr_pages =3D=3D =
1 and
> nr_pages =3D=3D folio_nr_pages(folio). Generalize this to any nr_pages.
>
> Currently we have a not-so-nice logic of passing in subpage =3D=3D NULL i=
f
> we mean to exercise the logic on the entire folio, and subpage !=3D NULL =
if
> we want to exercise the logic on only that subpage. Remove this
> indirection: the caller invokes folio_put_swap_pages() if it wants to
> operate on a range of pages in the folio (i.e nr_pages may be anything
> between 1 and folio_nr_pages()), and invokes folio_put_swap() if it
> wants to operate on the entire folio.
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Dev Jain <dev.jain@arm.com>

Reviewed-by: Barry Song <baohua@kernel.org>

[...]
>
> diff --git a/mm/memory.c b/mm/memory.c
> index a620d425ec95e..d88df15018268 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -5198,7 +5198,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         if (unlikely(folio !=3D swapcache)) {
>                 folio_add_new_anon_rmap(folio, vma, address, RMAP_EXCLUSI=
VE);
>                 folio_add_lru_vma(folio, vma);
> -               folio_put_swap(swapcache, NULL);
> +               folio_put_swap(swapcache);
>         } else if (!folio_test_anon(folio)) {
>                 /*
>                  * We currently only expect !anon folios that are fully
> @@ -5207,12 +5207,12 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>                 VM_WARN_ON_ONCE_FOLIO(folio_nr_pages(folio) !=3D nr_pages=
, folio);
>                 VM_WARN_ON_ONCE_FOLIO(folio_mapped(folio), folio);
>                 folio_add_new_anon_rmap(folio, vma, address, rmap_flags);
> -               folio_put_swap(folio, NULL);
> +               folio_put_swap(folio);
>         } else {
>                 VM_WARN_ON_ONCE(nr_pages !=3D 1 && nr_pages !=3D folio_nr=
_pages(folio));
>                 folio_add_anon_rmap_ptes(folio, page, nr_pages, vma, addr=
ess,
>                                          rmap_flags);
> -               folio_put_swap(folio, nr_pages =3D=3D 1 ? page : NULL);
> +               folio_put_swap_pages(folio, page, nr_pages);

Yes. In do_swap_page(), `page` points to the first page of the
large folio.
        if (folio_test_large(folio) && folio_test_swapcache(folio)) {
                ...
                page =3D &folio->page;
        }

> --- a/mm/swapfile.c
> +++ b/mm/swapfile.c
> @@ -1817,27 +1817,25 @@ int folio_dup_swap_pages(struct folio *folio, str=
uct page *page,
>  }
>
>  /**
> - * folio_put_swap() - Decrease swap count of swap entries of a folio.
> + * folio_put_swap_pages() - Decrease swap count of swap entries of a fol=
io.
>   * @folio: folio with swap entries bounded, must be in swap cache and lo=
cked.
> - * @page: if not NULL, only decrease the swap count of this page.
> + * @page: the first page in the folio to decrease the swap count for.
> + * @nr_pages: the number of pages in the folio to decrease the swap coun=
t for.
>   *
>   * This won't free the swap slots even if swap count drops to zero, they=
 are
>   * still pinned by the swap cache. User may call folio_free_swap to free=
 them.
>   * Context: Caller must ensure the folio is locked and in the swap cache=
.
>   */
> -void folio_put_swap(struct folio *folio, struct page *page)
> +void folio_put_swap_pages(struct folio *folio, struct page *page,
> +               unsigned long nr_pages)
>  {
>         swp_entry_t entry =3D folio->swap;
> -       unsigned long nr_pages =3D folio_nr_pages(folio);
>         struct swap_info_struct *si =3D __swap_entry_to_info(entry);
>
>         VM_WARN_ON_FOLIO(!folio_test_locked(folio), folio);
>         VM_WARN_ON_FOLIO(!folio_test_swapcache(folio), folio);
>
> -       if (page) {
> -               entry.val +=3D folio_page_idx(folio, page);
> -               nr_pages =3D 1;
> -       }
> +       entry.val +=3D folio_page_idx(folio, page);
>
>         swap_put_entries_cluster(si, swp_offset(entry), nr_pages, false);

Maybe a guard against potential overflow would help? also in patch 1?

idx =3D folio_page_idx(folio, page);

VM_WARN_ON_FOLIO(idx + nr_pages > folio_nr_pages(folio), folio);

Best Regards
Barry

