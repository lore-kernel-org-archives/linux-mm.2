Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2565CA0FF0
	for <linux-mm@archiver.kernel.org>; Sat, 30 Aug 2025 01:42:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D03B38E0005; Fri, 29 Aug 2025 21:42:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CDAF28E0001; Fri, 29 Aug 2025 21:42:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C17A58E0005; Fri, 29 Aug 2025 21:42:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B0BA98E0001
	for <linux-mm@kvack.org>; Fri, 29 Aug 2025 21:42:36 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 21BBDC0A95
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:42:36 +0000 (UTC)
X-FDA: 83831724312.07.00AEAB2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 4F27D140004
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:42:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dLSQk+gh;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756518154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vRxu4hhAzlJxktpfSsEWZDIQPkOFEvUFiEGylTRBpfc=;
	b=t9tE6V5dxcg8dxwH3dW1H1gfUzq8AcoFqkrh99zmZlbgRhS5+iEdSTEzvFs6/eBTQLsktJ
	leVf0bbUdP93WSBB3nrEuDuE8FLjKOgyfpBSzqJONVl0wPsGswH6NubuZD/OzYumPaEJh5
	1CxHd2XWCcdaGGAw7JiMywgfeNuT0Do=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dLSQk+gh;
	spf=pass (imf09.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756518154; a=rsa-sha256;
	cv=none;
	b=X3bKqZtqDYlCGI7uRPedxuZBv421waEjdVPIhAa3Y4ml60YOZ1A9f6ZgKyY2fUyWL4r76o
	nuZDo16rTMqNr+xaWVCc2JrfH/pgJA7YWgTUbWv35CaT9A+VS+vZRnfII7RAcH/D6aeq15
	Lok1K8HlnUS6HR0Q1zCV3lTNLRtVHm4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 75BEF60191
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:42:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B429C4CEF7
	for <linux-mm@kvack.org>; Sat, 30 Aug 2025 01:42:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756518153;
	bh=1BdOkDsxUViW8TkDK+QZwdvtemhOptK1QYTppmdS15w=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dLSQk+ghgYBTuTx/kf1oHly3EU51ydMwzoisWx3mOhtis2b6l2H3YwcubVAwunJY1
	 Pmxy7bpUBUOpwGWKbNewYVfZYaP+c+AOEn6yLv91JN6k2l9ObFS6HcV/bHxkT6GS/C
	 b8facSsn8bePGIXZe3UazGbvPcKOGWz8+H4VJk4QMCwXjP6kDH7OpBzV1tntcXa+v9
	 9xji8RgQldK7wGhxIagfIcnctXvM36oriOY3hJOhCgV0Cy4PofQl5Tabw4fO9nL/8D
	 ZX1yHVRqoEYG/ywHJJO3EeKkDIbLvqCG1FhtFeNnl3tanZIXlQvcYOHK22GFNZfwMD
	 QU3ZZSr/3/2Mg==
Received: by mail-yw1-f172.google.com with SMTP id 00721157ae682-71d71bcab6fso22551547b3.0
        for <linux-mm@kvack.org>; Fri, 29 Aug 2025 18:42:33 -0700 (PDT)
X-Gm-Message-State: AOJu0YzmdKXbNL6Rr/cEQvQOnY0usriW38YKuEk6s8c3i8QifJGKY8Wm
	lNmyat6o8R0v35YqD8/pZncm3K3h9hhCvk/SeVPzfZPtVZpgBy21/bjq/n0pqdzfCgNMDJdlBAI
	mNCKx62L3eNo6NzL/OIL230bodTcYRE/oeruLjL8hDg==
X-Google-Smtp-Source: AGHT+IHF6KxVOHS3kToYOuE6Kd/lPQ/gBnZx1Kg68zofo0+ra/ynZ0uZP+ZHCp18rV6vFNpvM39l7s2nZtXQUnYJhMg=
X-Received: by 2002:a05:690c:4803:b0:71f:b944:ffc with SMTP id
 00721157ae682-7227657ee6cmr6792617b3.47.1756518152404; Fri, 29 Aug 2025
 18:42:32 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-3-ryncsn@gmail.com>
 <CAF8kJuMX_WTg7vyACBxskNmDHB4C-ZkowuKYP71gQ8qyKuwAaA@mail.gmail.com> <CAMgjq7D3EiLOyEQiR+Uq6mTdXajMCg4+A+KRZajE91kbTw=tHg@mail.gmail.com>
In-Reply-To: <CAMgjq7D3EiLOyEQiR+Uq6mTdXajMCg4+A+KRZajE91kbTw=tHg@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Fri, 29 Aug 2025 18:42:20 -0700
X-Gmail-Original-Message-ID: <CACePvbUYDfne6mZ32c3YzxcwH16u-G3YXoYoGaXL5EtxjDH8mw@mail.gmail.com>
X-Gm-Features: Ac12FXzMEbrDM4n3UP1sqECYx8QlPnei49nlNt0dz5bDLhFiqVQ13GZT36zH2fw
Message-ID: <CACePvbUYDfne6mZ32c3YzxcwH16u-G3YXoYoGaXL5EtxjDH8mw@mail.gmail.com>
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
To: Kairui Song <ryncsn@gmail.com>
Cc: linux-mm <linux-mm@kvack.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Matthew Wilcox <willy@infradead.org>, Hugh Dickins <hughd@google.com>, Barry Song <baohua@kernel.org>, 
	Baoquan He <bhe@redhat.com>, Nhat Pham <nphamcs@gmail.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@redhat.com>, Yosry Ahmed <yosryahmed@google.com>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4F27D140004
X-Stat-Signature: adx1z6a7nyd6btsafjuuhsusnuz39sw6
X-Rspam-User: 
X-HE-Tag: 1756518154-995346
X-HE-Meta: U2FsdGVkX18IJx0UVN19CT2OC682JRmcIlbLuDAJGDTeb+Bk7kMWsZh031fjYtM9PuB0E58As40HJEQz/XQ9iJ6yq+gUZsxRuTGxB//03lUfsJWgPJqzzdJ9UsurawLh4c+O18zTny9lz/dUvf+TAAKaB0GY4MRkbYcPaJRfuppqFi7t7zC6OX2T/lzlPYDa1xG3THQC8eafTNaiy2YeNSJglxC2hlYOMQHmS+Eeo+zTYmRBjhBIHu014H7zQ2zvqyL04fltcXlwW+jxx4/Erk9E1A7GIf7eIQvOymc6hmF0UvglZUGi0CEZ5BaAavbw8r2irXAu9M2dDOCZyAQxulH99QwUqXfB/Z6/wsPDqY8/UWjHE0H7mW2l0aC8osOtTxzA1cBLtZW+gu4blZj/5llXdoalHhN+upqtg/wwoOa6Z+5cTARRQhezHm9xGSb2UfU+FyuVd/xnunFM3aYKjLksK2dn9Y9FF97sptoeK5EyDupyJvupLxdF7/Oi1iZ6d4aUp8F2x1ldTUYexpTp0KEaKiul9j9UEMe9Kyi/ZDrDERaqOrJK4GxxZZmeKJ80tOLc6nj1JwqG5Z6O/JU0wvScEZ7bZn3PD2g+EvXqV7AVcHgURuwr/X/5B0si1JL0uctI87A8Y+JldeOVChRJXbRLTKLKlzaV8wwEBfffTo2v96bhKt0XbBnOfatTQhyp4TlDV6345qD3feMLsZJzcFP2buqS8hQ/Mc70vykxjtuyezvzHlVtALczm4u1Uv1J/Lh/TWG/JWshjI8Ifyr1jqEE3vpYA23VXD5f7UtIvZWzJc4rGnTpenT9mCQHrEQ+LrboZITaPwm5neYIZpZq+oFWFB9nBBKb2mjNcO/bFa6dS9HkMmd+ALE1YW21BLgOf0lTKmfWTLGWjIzH7YQ+q2Qsy9z3p93rcDDpqLQ8uh7t+DtBnM0tQpQXBI3Bv8b+l4dawJXGtNa9qeqCVOX
 7wYdkFmV
 Vfs7EkZg4OhS8NVhA1cFwSIPmfpNxVrqOVXYgPvvYCkDb1UKe13WOqcNVVrPnMWMOXF1OZxiP83vMyt5LL+LiOhQINjSswIF51Fgc+63afb9Ess6DGBNTUdCAll4xaANfc9Zkdjvek0VDAI6aWCHtCQINDbYValouWGai5iiZrKQr4q11wOOnGhHLIb3xVIvyoVGAevx+/reSr88OD7Ak2xdpaR6hMNX2fTsbOlww+ahoNgULZ8nPDMgEe+ugOf9XBhvPUDCs0n8Zwrpp0XRIfudSQpl92FfSF3N7GdvYxV8qvDGlG4iQQLtyxd2bNM38hw++UGQ1iYCxvCA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Kairui,

Sorry for the late reply. I have been super busy this week.

On Wed, Aug 27, 2025 at 6:44=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Wed, Aug 27, 2025 at 4:06=E2=80=AFPM Chris Li <chrisl@kernel.org> wrot=
e:
> >
> > On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com>=
 wrote:
> > >
> > > diff --git a/mm/memory.c b/mm/memory.c
> > > index 10ef528a5f44..9ca8e1873c6e 100644
> > > --- a/mm/memory.c
> > > +++ b/mm/memory.c
> > > @@ -4661,12 +4661,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > >                 goto out;
> > >
> > >         folio =3D swap_cache_get_folio(entry);
> > > -       if (folio) {
> > > -               swap_update_readahead(folio, vma, vmf->address);
> > > -               page =3D folio_file_page(folio, swp_offset(entry));
> > > -       }
> > >         swapcache =3D folio;
> > > -
> >
> > Can simplify as:
> >            folio =3D swapcache =3D swap_cache_get_folio(entry);
>
> checkpatch.pl is unhappy about it:
>
> checkpatch: multiple assignments should be avoided

Ah, never mind then. I actually like multiple assignments but I can
see checkpatch wants to ban it.

>
> >
> > >         if (!folio) {
> > >                 if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
> > >                     __swap_count(entry) =3D=3D 1) {
> > > @@ -4735,20 +4730,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > >                 ret =3D VM_FAULT_MAJOR;
> > >                 count_vm_event(PGMAJFAULT);
> > >                 count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
> > > -               page =3D folio_file_page(folio, swp_offset(entry));
> > > -       } else if (PageHWPoison(page)) {
> > > -               /*
> > > -                * hwpoisoned dirty swapcache pages are kept for kill=
ing
> > > -                * owner processes (which may be unknown at hwpoison =
time)
> > > -                */
> > > -               ret =3D VM_FAULT_HWPOISON;
> > > -               goto out_release;
> >
> > Here you move the HWPosion(page) bail out from before taking the page
> > lock to after the page lock. The HWPosion page should be able to bail
> > out without taking the lock.
> >
> >
> > >         }
> > >
> > >         ret |=3D folio_lock_or_retry(folio, vmf);
> > >         if (ret & VM_FAULT_RETRY)
> > >                 goto out_release;
> > >
> > > +       page =3D folio_file_page(folio, swp_offset(entry));
> > >         if (swapcache) {
> > >                 /*
> > >                  * Make sure folio_free_swap() or swapoff did not rel=
ease the
> > > @@ -4757,10 +4745,20 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> > >                  * swapcache, we need to check that the page's swap h=
as not
> > >                  * changed.
> > >                  */
> > > -               if (unlikely(!folio_test_swapcache(folio) ||
> > > -                            page_swap_entry(page).val !=3D entry.val=
))
> > > +               if (!folio_contains_swap(folio, entry))
> > >                         goto out_page;
> > >
> > > +               if (PageHWPoison(page)) {
> > > +                       /*
> > > +                        * hwpoisoned dirty swapcache pages are kept =
for killing
> > > +                        * owner processes (which may be unknown at h=
wpoison time)
> > > +                        */
> > > +                       ret =3D VM_FAULT_HWPOISON;
> > > +                       goto out_page;
> >
> > It seems you bail out with the page still locked, that seems like a bug=
 to me.
>
> I think it's the original behaviour that is kind of fragile. The
> returned folio of swap_cache_get_folio is unstable unless locked, so
> the folio could have been removed from swap cache or marked by some
> other threads as Poisoned. So the PageHWPoison here could be tested
> against an unrelated page, which leads to false positive PageHWPoison
> results. We have encountered several similar bugs due to using folios
> returned by swap cache lookup without lock & checking first.
>
> So checking HWPoison after locking is actually safer.

How do I verify the code can handle HWPoison from unlock to lock page?
I haven't followed the HWPoison path very much. I am still wondering
how does the HWPoison code handle the page previously unlocked, now
become locked and without any additional code change?

If you want this behavior, I strongly suggest you split this portion
of the change out, ideally outside this 9 series if you can afford to
do so.

This patch description has nothing mentioning this kind of subtle
behavior change, as a reviewer I am caught off guard by this. At the
very least the commit should mention this. Talk explains why this
change is needed and why it is safe to do so.

Having very subtle behavior changes buried in a large code restructure
change is the worst. Splitting it out will reduce the reviewer's
workload to reason this behavior change, and makes your series easier
to review.

Does it make sense?

Chris

