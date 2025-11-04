Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 62703CCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 10:51:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A63758E012D; Tue,  4 Nov 2025 05:51:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A140A8E0124; Tue,  4 Nov 2025 05:51:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 903838E012D; Tue,  4 Nov 2025 05:51:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D6B18E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 05:51:10 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B96901A049C
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:51:09 +0000 (UTC)
X-FDA: 84072607458.30.4CD0ACB
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	by imf11.hostedemail.com (Postfix) with ESMTP id D039C40003
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:51:07 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FxK9Jn+o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762253467; a=rsa-sha256;
	cv=none;
	b=cTnfxKzEAyzHFGLX/cyJ55e/uO4yoo6J3IwSKcc5hCPhtuBK1CTK99pUnytABkROv/CSzp
	jCgbAGfD5oddEtCgL30K402dYnBijNZklSs1H4CNNRxfx5syJ2t0W4vM5TRG6+rXkbiHFP
	kKK64KpLwjMNGHLgbiuPuTP4ctFeIYI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FxK9Jn+o;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.50 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762253467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8XiemDZsGarCr+FYxcjdOuySyiUPWndA+UfF0ZPw3VQ=;
	b=xJO1BER0/8syBCKs2sgMEMwdKBfdtiaRRbdLBn5AJATCn3kjTnrnHpD5jyQ53jTlPPjLoe
	Tn9j4L5XO+YejBLzP44H+kXzgB1NYIfeMVwig/reN3mnWJ+Bl+1LwEouri2FIDis/VuWUF
	OAqYa3tAwyKo5cq5KhjVYlLUHyLqvIs=
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-640a3317b89so3386835a12.0
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 02:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762253466; x=1762858266; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8XiemDZsGarCr+FYxcjdOuySyiUPWndA+UfF0ZPw3VQ=;
        b=FxK9Jn+oxtBzqVqCMUerThFsRZill7WuhWAO8aeWHTpmJauHgCzwCIMpcxhEKAmPGY
         LofmgbxM1npKF5DYs1FWRQcyyrM2PT3haB1ol/JN2JB9lfPB290VYE0/lHS1TKYKNBQ8
         ANVgz89ZDltDFRcqq8o282koxSJEhkGxaUrXS5hjFBYBze1PPdXbQBxT+P4PQ98Lif2J
         LuIbhSV6Bj12HPWhB10nLS4GZXLQTbrQlU544DcfOZVQUJpPjxItzq4XopRnPk/Nul4E
         gT0wvJabKigNUJnw4fVoaXLmmrc85U8EGYpuHx0OPKDnBAmSECZMHwA5JuVQIDPKWrfc
         KaXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762253466; x=1762858266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8XiemDZsGarCr+FYxcjdOuySyiUPWndA+UfF0ZPw3VQ=;
        b=o802/oLK+N8wcjkKqjcbNMveACDmrjMTaI+tadfQcXkYFHoBPjkgWlpE1Raq1Zn1Gc
         ntYAX+1xtZpN+DUKZMBIUIm1BHV5Eh4aDGfr/XFFG7zlBAMtFFsQzMd36FFh2n+MJlxk
         CmIYy0K0YnR2sAO3fAVgPEKJcWfl9Vk1C7iEapvRGBxcL7uAgGw4YzOS8I6tjzxVNggf
         PVkeo7LeMIxYzg8rgFPtan517p7/Qtk2dNu/SjHqxI+usDR6Vt3uJVIYgS6BH1y96fJs
         sEiBYReM4lm6TkHacfKkSHgNaNkwt94AKbTbvyAKSeRTWVFoow539HIbVa8Uo/d2FsLL
         2WVg==
X-Gm-Message-State: AOJu0YzDh345svbp3aftmWXARhsU2YxxyEEQsZR4KXEbQdSN/dPL8r96
	h/srNiaZsfAGVOI4HGqBrLT8CBU6NkMdYIH8ReLew0Yry6116kWCXibrRPmCiK5BOwClQueW3DZ
	tODfnEINsoI1xeMlg7thGodUshj9Nof8=
X-Gm-Gg: ASbGncsY7FmUr4zF+NUgHwT7uiKXaaqplGe9VTDzbe8rnyCFCoonUhyvHuLAu973f41
	vgBNaa3Rbk0OpIKS8nlQ0l/lPAmDi6i/KdpCDKsd84uNCeBCNiWxKaZCqT7j8doWTMeqBhIPj4K
	z04Y1L6rbSceuqhbYeR/NuvqKV1/rJgIBHun/hJnjDYaFjTgo1N2r2rOCI0ju16Gr1/zs30Oz5y
	nVs6tMsjgcCtQB4pO7iN+pzAehdVJJIPiHQV/Et6HjJ6TuU17Efk9fK9Hwn06FH
X-Google-Smtp-Source: AGHT+IE/p5D3gS5t+TqdhOZRazOjQZJIEZ65iHHwqiCBldoZ805RKHdn+V1p8ktx94/L4MI6LtIrE5XsKt0nm0HgDtI=
X-Received: by 2002:a17:907:3f0c:b0:b3e:580a:184f with SMTP id
 a640c23a62f3a-b70700d6d5bmr1790279066b.4.1762253466001; Tue, 04 Nov 2025
 02:51:06 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-6-3d43f3b6ec32@tencent.com> <CAGsJ_4z1gB8x7GNUL4THdC7G9ZGMqbM3UtWM2LXPoT0xcLAQ3A@mail.gmail.com>
In-Reply-To: <CAGsJ_4z1gB8x7GNUL4THdC7G9ZGMqbM3UtWM2LXPoT0xcLAQ3A@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 4 Nov 2025 18:50:29 +0800
X-Gm-Features: AWmQ_bmV_iSb2dhNQMpuo5p-nozPoqBQfWGGMMVyrMWRZ9AARK8AV3WAKMhbzYg
Message-ID: <CAMgjq7CV14FdHvgGtXwWQPqXKwy4W-5vfR=-hUYkBemeMP=Srw@mail.gmail.com>
Subject: Re: [PATCH 06/19] mm, swap: free the swap cache after folio is mapped
To: Barry Song <21cnbao@gmail.com>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>, 
	Baoquan He <bhe@redhat.com>, Chris Li <chrisl@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Youngjun Park <youngjun.park@lge.com>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Huang, Ying" <ying.huang@linux.alibaba.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D039C40003
X-Stat-Signature: 6cac6ic3zcg6znjit1rif55ajwfxjuc9
X-HE-Tag: 1762253467-157234
X-HE-Meta: U2FsdGVkX1+KvZXlCi/TLN5x96FJ8+oedDfuwZF62EknbWy0A+DbrWj8FVPXuvk5SStipQ0oAXcAvoDUXp4dI0IXjENmj04zb85swKLb/CAkxkKEP49yhuIltxNHU/rnaGEaNQFOfSbo4EAZe1lMkzGBwjiaLOa7vG9M/Bd1JRGTU/UiLEbDfkVCB28NkBeLJ9gOXzV0f9hnM4yRlRXaEgNbTmUmc5V/j+xyuH4OYO3LewPEPpnqmI3xZn8OXg0Ep7V//+Vu/upC/c5rgGw9tom3a/k/9SeJyAQ2r41joBR2HJ6DQPsvzi4ovNYDyweIKpvW/4JfCnuuZq4FXe/PnLEY8LH5FAWg3HTwD5mq3/ifCxOpotFm1NIkJgi8ckxYR0uvCBDOu92hys1RVC12FurwvtlpzPwdEwkKTbt6zrOiuTHpw5WXVEU+b1VpkzY8bbcpmHdB6B9IfcBcTdGdxqrlLKL453J4a9+sl9DFb1PvcVlubmfUMJTH5oQhfQ462dwVi9V8367rUXusOuPc3I4lXYxgBWB0PVOW4B6NfLlRx8IC9yEGH9kW44C3yX0erphnwBC45t+DyboKZPoY7oRbFnxbP8F8HMCKjr2PuF0uASLILFkQnZ2emAQranvH9wfMid6+scvldFEvZRPfq3WxaVXOm4sw8uOHOeEJYJJsjJAFcIbu3C2R1WPomaLfCpIvY4zaOLAtlGGxIx4PhJ+GjSjcHU7e9YoyVSdYWCSK21OAP34AKyfPalLgqkK/9G+lsIQzZgENajgYqEz20apYM/TJ7Rrh5fFzzERSnhBhYa8/kKNBcUgYC/OuF5F34QTp79PZKsz9K+xqVW5KIIEGHQQT5pALzq3RTXMuIG76a+mwqEDvo4d8jZmpXnWzBWLhw/FHJB6hk8wTDcDxjV6ouv4ZwWM0qE6UsfPXHJP4vBRzFkTOoRn0aCCNdcNrKzKB1liaYukqI3b2EPV
 V3/fg/IX
 z+3whXmgdcok4v/OQnRJEdIhFvweFj3QCjGCmYiivb8jSvxPIQnAX4SU5EIBJbGINuyZilm4UxM7vwEeCXMrK/vD6nUmar60sFVs9Iw+Z6sOm1LJ2LRXEiK3P8KKKIN2SOnJP3gJHaUKC0ooqxQjSsaWmUCOMDFn9B0Syukj7/nwa6MeF5RR0+s3vZqaQWfYfbERvma+w1PZUUoqWJtDBX3iL7tsHgKMiW4sAVtLcdZzUW9LtQ6InAXjc6m+vlU/iH7RLRACSVIYuK/uCD6GgU/bhWLXHwMoj9Lju1USKfDSjPqsfj+KnMJzlsfzDkFtmHnEZDUS9G4wqSj6sx9cX+0GfIn+Q+0KDXGAVZg0XSbbEnv7ndQcTfAYdPBxtwIG3Rf5nuv7gxSRrB8a4f0i1WZ1fkEePAE0pL8BRu/K7nvfvyAblKPJDRtl7vaM/Tb8/P3bvmpQKEOTnl3k=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 4, 2025 at 5:15=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrote=
:
>
> On Wed, Oct 29, 2025 at 11:59=E2=80=AFPM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > To prevent repeated faults of parallel swapin of the same PTE, remove
> > the folio from the swap cache after the folio is mapped. So any user
> > faulting from the swap PTE should see the folio in the swap cache and
> > wait on it.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/memory.c | 21 +++++++++++----------
> >  1 file changed, 11 insertions(+), 10 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 6c5cd86c4a66..589d6fc3d424 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4362,6 +4362,7 @@ static vm_fault_t remove_device_exclusive_entry(s=
truct vm_fault *vmf)
> >  static inline bool should_try_to_free_swap(struct swap_info_struct *si=
,
> >                                            struct folio *folio,
> >                                            struct vm_area_struct *vma,
> > +                                          unsigned int extra_refs,
> >                                            unsigned int fault_flags)
> >  {
> >         if (!folio_test_swapcache(folio))
> > @@ -4384,7 +4385,7 @@ static inline bool should_try_to_free_swap(struct=
 swap_info_struct *si,
> >          * reference only in case it's likely that we'll be the exclusi=
ve user.
> >          */
> >         return (fault_flags & FAULT_FLAG_WRITE) && !folio_test_ksm(foli=
o) &&
> > -               folio_ref_count(folio) =3D=3D (1 + folio_nr_pages(folio=
));
> > +               folio_ref_count(folio) =3D=3D (extra_refs + folio_nr_pa=
ges(folio));
> >  }
> >
> >  static vm_fault_t pte_marker_clear(struct vm_fault *vmf)
> > @@ -4935,15 +4936,6 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >          */
> >         arch_swap_restore(folio_swap(entry, folio), folio);
> >
> > -       /*
> > -        * Remove the swap entry and conditionally try to free up the s=
wapcache.
> > -        * We're already holding a reference on the page but haven't ma=
pped it
> > -        * yet.
> > -        */
> > -       swap_free_nr(entry, nr_pages);
> > -       if (should_try_to_free_swap(si, folio, vma, vmf->flags))
> > -               folio_free_swap(folio);
> > -
> >         add_mm_counter(vma->vm_mm, MM_ANONPAGES, nr_pages);
> >         add_mm_counter(vma->vm_mm, MM_SWAPENTS, -nr_pages);
> >         pte =3D mk_pte(page, vma->vm_page_prot);
> > @@ -4997,6 +4989,15 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >         arch_do_swap_page_nr(vma->vm_mm, vma, address,
> >                         pte, pte, nr_pages);
> >
> > +       /*
> > +        * Remove the swap entry and conditionally try to free up the
> > +        * swapcache. Do it after mapping so any raced page fault will
> > +        * see the folio in swap cache and wait for us.
>
> This seems like the right optimization=E2=80=94it reduces the race window=
 where we might
> allocate a folio, perform the read, and then attempt to map it, only
> to find after
> taking the PTL that the PTE has already changed.
>
> Although I am not entirely sure that =E2=80=9Cany raced page fault will s=
ee the folio in
> swapcache,=E2=80=9D it seems there could still be cases where a fault occ=
urs after
> folio_free_swap(), and thus can=E2=80=99t see the swapcache entry.
>
> T1:
> swap in PF, allocate and add swapcache, map PTE, delete swapcache
>
> T2:
> swap in PF before PTE is changed;
> ...........................................................;
> check swapcache after T1 deletes swapcache -> no swapcache found.

Right, that's true. But we will at most only have one repeated fault,
and the time window is much smaller. T2 will PTE !=3D orig_pte and then
return just fine.

So this patch is only reducing the race time window for a potentially
better performance, and this race is basically harmless anyway. I
think it's good enough.

