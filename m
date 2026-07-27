Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6BD0BC531FC
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 14:58:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 508FD6B007B; Mon, 27 Jul 2026 10:58:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B8456B009B; Mon, 27 Jul 2026 10:58:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35CA66B00A2; Mon, 27 Jul 2026 10:58:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ED45D6B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 10:58:33 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 6919F160725
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:58:33 +0000 (UTC)
X-FDA: 85034862906.17.84DF8C9
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf05.hostedemail.com (Postfix) with ESMTP id 87DD1100006
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:58:31 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XuReXscy;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785164311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HdV/tdQspG4IJMEgA5ul46Qg1OBakRGkf1HYdrRgQRg=;
	b=Loc/C+FXdEGxLFMmoayLL8x801ZzK3IqB9+e7pR1HO3tybZw2W4WZ2Y9SaFOsWsd2u45bg
	AwBPJUTfuGhNzrXOtJBcyq7YEUAuK5+S2yRVYJYcR/eF2uglS5tTHjE2I0bJwdimzkCNOj
	ShOajuxUK0Y+P2qa/BM1N4yDWiFFP04=
ARC-Authentication-Results: i=2;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=XuReXscy;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf05.hostedemail.com: domain of surenb@google.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1785164311;
	b=372kIqmvtnuDW/wyIwHt7vpkXJL7KI/S/wckkO7KixXeQ1uBXlVeifY11QTObGpHifxirO
	c3zVIm/fhIZ9ZpuC3DoUMautC0ExVChZDupU+2lGxBkQ/1p+TbiYjqpMXLasVBIGpK/Mfs
	qWd6NzVOWJxsAxbKP76mGC3ug9BwwQE=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-51c15a5b265so474261cf.0
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 07:58:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785164310; cv=none;
        d=google.com; s=arc-20260327;
        b=cst2476YGrG7bY+lTFrbpiHXX4aSlDvbUcni/WeQNZElD0naGQZw1d1yao6Xkqlaba
         F4DhHtBOJLjZNdSTpQh0BVZfv3zn6eIjjbz0WyYenXdE9F+tOVCtFTRa/HGBaRV7iVRH
         alqiOnTK+2xcIVW7JWuV6fYRLiUIM7cQ/s7mqlrHBQTdJLoiXjrUzg70u3/GOdWjm++u
         GMjD5LM4QmI0bToby89PvTyzs50bPjN4SHG0QbrrTv+61Ba1fI/uhZ4SPn0oWtXFmZT6
         gblYD62LxMxvc06e/C/KGIExkVnNDWGCfWJG2PRO9rF8ZIR5wuD7XCPxesjla60Wd4wR
         ATCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HdV/tdQspG4IJMEgA5ul46Qg1OBakRGkf1HYdrRgQRg=;
        fh=TkZtauTog2HOTObqxOFRxnXeGnExJID9KucP4018sLE=;
        b=a+scAYNOWTbN4TbR0Ias3Y/zxq8Htf5vu0KPiwvQ8CUxGTjbxJizn1Jjt4u9SU3+qU
         XqA0SDTnkuQSzCzEVG5T7dSKz6YAxKbnsMLwlQMB200RWH/o0Iu7baL64i6UIV2Ryrrp
         1O3AlvpB4gdQRCip2rju5zewQlPdiaEZg1FQ8VrVIAJ2VYpBfebMtcTuDs4MpnXogAhS
         PXUD5QWtbCQK2hC0CZwAfSDeW8F/3WsHkTbU93yLJ0/aBW6wbTLn+vRJTz0NV+ecVTlb
         tTKnTs9/7gbsiwGhLsBcRCiIb4TS2wOysZ+b1uEUwF/wfThSa9Uzxl4KPSr9jXb6WjJz
         p+Sg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785164310; x=1785769110; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=HdV/tdQspG4IJMEgA5ul46Qg1OBakRGkf1HYdrRgQRg=;
        b=XuReXscyqv/jTVC1yutMdTRq1AxtsrOupxMC+sFKW/nskk2pJn/jox/eqq8nzt41GM
         bMspLLfFNdAZ+UGK0GRxGTiG/Y+Au1wAhXKSly2bVjIzxmGfKbX8F0FYDC8UiqudFe/m
         HeDB0/UMmd4d4Z6afNd1EiUtI5SJSPv/M94V7s69MhTU3wOGOfAIAvIy6xTdI77cPavV
         EZ2e5f9di4sC1RJj0qeZg1yVsdMjdpVW1M2SV08ztZdgxvGVOClGJcvZN6KXEoC8mW1i
         MTlEFK62pFXUl1pxn7Wyb9j1OlJK4gFKBKnpXHM5V63AmWI7X6SGdPU9Zv/lLW22h6OM
         uMaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785164310; x=1785769110;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HdV/tdQspG4IJMEgA5ul46Qg1OBakRGkf1HYdrRgQRg=;
        b=SMbx2dCNzYcgg2M7A9BaFH/0yb9riWpu8IFUPvtdxchKpU48QR76Uiw82N2x/HDYfa
         x1Vg4fYfmmaJiJmTBBtauSZZmRGDKZCGoo9LMjm4aV7eRm+06Rar0ggpqaxAJ6khN1TD
         Qx3CoRxhs+h0Cch3VpVFrtYO961bqnNCIX1uOqncjpsvRZOg34gfPekxUy6fpvAB29KR
         7bUqflE97rMCYuFvOC8XTi40UTrEZ/TCdw2AA7U/rUdm/Kw5im9nPdTpRB1UpYbkuMtn
         8JZ3KcGT1wxMZOMUpSKCE5nJWA1bguvohmCYvynzdXR5HtcdheSmharJYHTdTcG3khJx
         fsQQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpy8+yF/wVGFJcsFt1OgsNCHHOUQsA1E1S1qHQcZce2vJaHbrCuSFl9oqPcyi0Y7k38nTuP+sOpCQ==@kvack.org
X-Gm-Message-State: AOJu0YyMZ7SFfhw5cfjIaMWJ9vsWiBVs3Yqs4Hdh3mW4nykTTVgDQG+i
	BsQrc6VT1e8nsZxpvTQk769txJvyEjwAAhEr3oHHce3qgjLyWr6xyVp190id9y5Wa8/A1D7tA5z
	xlSf/UdLk4b/VFCvBlO8cAzafnwZGRKD6jLV4l35R
X-Gm-Gg: AR+sD11+r2Avl5lwn5ZdcyOhtEY/1gxHBpGcZUW1N9UMoFjXwBoSUSNEMRua9dUz1Gt
	dbXY8EN+kb0smEF6zLimSf02qipddFqWalZ35fkqsq8nMMiKFJ+oJ8Ak4X/SfKZ3DWe8juaizuI
	gpOEo3wGOLUXVky3CIs66/f47w4H8y2Wga1jw82WwId5Jeyg4XuArramI5ZLUDHEp2Q5ldp2uNY
	0DKukb2bnhmehRpJ7iltq9ry4Pz16hk+hCHywasCclUrUxtH3+ZsTTMwI4tfOJSs/qsby/mrw0s
	SZMbYw==
X-Received: by 2002:ac8:7dcf:0:b0:528:3186:5781 with SMTP id
 d75a77b69052e-529a5f158a7mr36339991cf.6.1785164309856; Mon, 27 Jul 2026
 07:58:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260724222934.1463812-1-riel@surriel.com> <20260724222934.1463812-4-riel@surriel.com>
In-Reply-To: <20260724222934.1463812-4-riel@surriel.com>
From: Suren Baghdasaryan <surenb@google.com>
Date: Mon, 27 Jul 2026 07:58:18 -0700
X-Gm-Features: AUfX_mzxNfG3avju6LxEy4p22U_xIz6TPcKe25YvyW5akGfhtZSIh5B3OYp7U2E
Message-ID: <CAJuCfpF8S1=S7TkAuQ58OWiUhnf481YvwsamwvVfa7tfVNH3JA@mail.gmail.com>
Subject: Re: [PATCH RFC v4 03/12] mm: rename get_user_page_vma_remote() to get_user_page_lookup_vma()
To: Rik van Riel <riel@surriel.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, kernel-team@meta.com, 
	Dave Hansen <dave.hansen@linux.intel.com>, Peter Zijlstra <peterz@infradead.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, David Hildenbrand <david@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Usama Arif <usamaarif642@gmail.com>, 
	Catalin Marinas <catalin.marinas@arm.com>, Will Deacon <will@kernel.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, 
	Lance Yang <lance.yang@linux.dev>, linux-arm-kernel@lists.infradead.org, 
	linux-trace-kernel@vger.kernel.org, Usama Arif <usama.arif@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 87DD1100006
X-Rspamd-Server: rspam01
X-Stat-Signature: im5do64n5yx6j135536wta3g6mqr5qrc
X-HE-Tag: 1785164311-144752
X-HE-Meta: U2FsdGVkX1+uUuoa9Km5+C4vHROvdGcIMnyYTBFfL8EYsMwxHeAN/2FrxR9SKp74A3QuKOL8YLOT796T26m7i1ErxPyy/l1xME9wgDKVoBc/QuWZVclAHTzzhQwCZR5Ilb2KX8pbMh/VorY/Vpqrrt953QeppiLtu1YMb7F5/wvhDFryFv/mWuUP74MtIY95YrT6nlawme3nyJMoDnS1tbi6t+Nd9wNR1bZMSFJEINm3loa3GAeio72qzR46QQhVYIjIfdg/Sw+1Y85vmCP5fh5tbDeZ7PPaNkJoM5GmqiAvScYh87nY00gDizMYi2A6pZVu/+HeON46gS/JdqRJxyLgFPxIlJtLzJmE8nlTCyCrjXyP4PDKL9SzVUZt/LlSspfcI5x/wsuCxl1adgHITI7UXs3R/8gCN3hI8HkPrgMpX5YrEEpjuvCkQTuIFPKzmVlGwxSrN8PCHMbAPX8HLcdPr4o448uArU2FeDESsc326QzGh2JmhbkbpW9YEaM4WHVf310HVZ8MWbQfKu9Tu/jEriarERW5faloVsH92GvwLeVRWwePuQChspoLb9IYSLw6GabiK2vy5fVhHFNazBLYBOPxTlBvzLQ+lM7K/wxHfOEu2zYLABEc1lPav53Iwx9CQRKZjqssAKTbYORK7XZ1sg4MKo86kyO4Qdx0Te/vqnW9QD3ybLB8cuNOKa7abQ6I1F434zgEGXhnX/BquBQx30zpT9iQmaSlkAjpUYPJaFFsv0lb5tz7CHa7V7z88/tQxvc1JcMPZBWlW7rNLAY78LgapraDUDz/dFP1e7MJOSwUEpYB0ruQpVwcXge7AFKcXLKhz0QyNQbTHnypWCKvZ4siBRmU/4aZFwh8hYrDwZOlf9bDpd0BwSFiMUHgyE7ticqLY9MbPYAwEqbAZQyQ5WbbG7QwrpJLplQWYWJssbAwEes5QbJUzHSiMi+tq8XKS5H56D9CB1jlech
 KwwzYplW
 BtnNppJl4wMOF89ttBs2AX+RfkAPXgkv/QsR9o+NiphIjdLBOm3NNN/pV+G+L6fkheBpBeCUV1mgFXE829Cpw0wKPMldz5/BA223EXlwUZRSPnwInyRNCR4imx84r2JiC6HtiSEiuQ9nQRsqdtKJfiXhJviKlb/ieWI/fQBXvyVKRJ2zt9/MKE+Mm2awnd62F0Pi8MiPwaPHa9OU5A7q1fSwKchLda2tSIeZs9TCBFYb0Zcbg73AFiV0WW6Q/E9rLwpQ6D6qyBWiJKUwLCMDwV00H6mk56bI/wsp0aBlA0sDcOqMNHWu+poaueimj9JslwijJeWAr/SOyxGYYHseUzLV992HoHG4nMlvoxxmvkM7rwzxJEYQq0neIdg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 3:31=E2=80=AFPM Rik van Riel <riel@surriel.com> wro=
te:
>
> get_user_page_vma_remote() faults in the page at @addr in a remote mm and
> also looks up the VMA that covers it, handing both back to the caller.
>
> This cleans up the namespace for adding a get_user_page_vma() variant whe=
re
> the caller already has the vma.

nit: Before explaining the results we usually state what this patch is
doing. I know the title alread says "rename get_user_page_vma_remote()
to get_user_page_lookup_vma()" but it seems appropriate to say that
here too.

>
> No functional change intended.
>
> Assisted-by: Claude:claude-opus-4.8
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Rik van Riel <riel@surriel.com>

Reviewed-by: Suren Baghdasaryan <surenb@google.com>

> ---
>  arch/arm64/kernel/mte.c   | 2 +-
>  arch/x86/kernel/uprobes.c | 2 +-
>  include/linux/mm.h        | 2 +-
>  mm/memory.c               | 4 ++--
>  mm/rmap.c                 | 2 +-
>  5 files changed, 6 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm64/kernel/mte.c b/arch/arm64/kernel/mte.c
> index 1a9aad6ef22a..7a6ecc3d9294 100644
> --- a/arch/arm64/kernel/mte.c
> +++ b/arch/arm64/kernel/mte.c
> @@ -459,7 +459,7 @@ static int __access_remote_tags(struct mm_struct *mm,=
 unsigned long addr,
>                 struct vm_area_struct *vma;
>                 unsigned long tags, offset;
>                 void *maddr;
> -               struct page *page =3D get_user_page_vma_remote(mm, addr,
> +               struct page *page =3D get_user_page_lookup_vma(mm, addr,
>                                                              gup_flags, &=
vma);
>                 struct folio *folio;
>
> diff --git a/arch/x86/kernel/uprobes.c b/arch/x86/kernel/uprobes.c
> index 3af979fb41d3..329efac0cfb3 100644
> --- a/arch/x86/kernel/uprobes.c
> +++ b/arch/x86/kernel/uprobes.c
> @@ -1036,7 +1036,7 @@ static int copy_from_vaddr(struct mm_struct *mm, un=
signed long vaddr, void *dst,
>         struct vm_area_struct *vma;
>         struct page *page;
>
> -       page =3D get_user_page_vma_remote(mm, vaddr, gup_flags, &vma);
> +       page =3D get_user_page_lookup_vma(mm, vaddr, gup_flags, &vma);
>         if (IS_ERR(page))
>                 return PTR_ERR(page);
>         uprobe_copy_from_page(page, vaddr, dst, len);
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 485df9c2dbdd..24ead14b4790 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3238,7 +3238,7 @@ long pin_user_pages_remote(struct mm_struct *mm,
>  /*
>   * Retrieves a single page alongside its VMA. Does not support FOLL_NOWA=
IT.
>   */
> -static inline struct page *get_user_page_vma_remote(struct mm_struct *mm=
,
> +static inline struct page *get_user_page_lookup_vma(struct mm_struct *mm=
,
>                                                     unsigned long addr,
>                                                     int gup_flags,
>                                                     struct vm_area_struct=
 **vmap)
> diff --git a/mm/memory.c b/mm/memory.c
> index ff338c2abe92..3b86eeaf084f 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -7039,7 +7039,7 @@ static int __access_remote_vm(struct mm_struct *mm,=
 unsigned long addr,
>                 void *maddr;
>                 struct folio *folio;
>                 struct vm_area_struct *vma =3D NULL;
> -               struct page *page =3D get_user_page_vma_remote(mm, addr,
> +               struct page *page =3D get_user_page_lookup_vma(mm, addr,
>                                                              gup_flags, &=
vma);
>
>                 if (IS_ERR(page)) {
> @@ -7167,7 +7167,7 @@ static int __copy_remote_vm_str(struct mm_struct *m=
m, unsigned long addr,
>                 struct page *page;
>                 struct vm_area_struct *vma =3D NULL;
>
> -               page =3D get_user_page_vma_remote(mm, addr, gup_flags, &v=
ma);
> +               page =3D get_user_page_lookup_vma(mm, addr, gup_flags, &v=
ma);
>                 if (IS_ERR(page)) {
>                         /*
>                          * Treat as a total failure for now until we deci=
de how
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 1c77d5dc06e9..b36f2e219b8f 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -2838,7 +2838,7 @@ struct page *make_device_exclusive(struct mm_struct=
 *mm, unsigned long addr,
>          * (non-device-exclusive) PTE and issue a MMU_NOTIFY_EXCLUSIVE.
>          */
>  retry:
> -       page =3D get_user_page_vma_remote(mm, addr,
> +       page =3D get_user_page_lookup_vma(mm, addr,
>                                         FOLL_GET | FOLL_WRITE | FOLL_SPLI=
T_PMD,
>                                         &vma);
>         if (IS_ERR(page))
> --
> 2.53.0-Meta
>

