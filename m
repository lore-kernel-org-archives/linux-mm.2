Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 28BDDCCF9E3
	for <linux-mm@archiver.kernel.org>; Tue,  4 Nov 2025 10:45:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 775168E012C; Tue,  4 Nov 2025 05:45:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 725208E0124; Tue,  4 Nov 2025 05:45:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 613F08E012C; Tue,  4 Nov 2025 05:45:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4DF478E0124
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 05:45:31 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C0C7E16048B
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:45:30 +0000 (UTC)
X-FDA: 84072593220.19.9EA2D11
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf08.hostedemail.com (Postfix) with ESMTP id DA380160004
	for <linux-mm@kvack.org>; Tue,  4 Nov 2025 10:45:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RQoeg4wY;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762253129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OrAQ1tstwLJDUUq1JtEKI2ptLUx1UO5CNRJ0YwBBWYg=;
	b=jFZd5AEhogVXwLHKZl/7V5pRuLwrr+2VbGu6uPp2FI0zyn5nmv9jNevfmni112gQv/H9zf
	huePpswglgwH8jqvkonUXFd4cEskkpNWN2QPOAAx3CagLRMZVQh7+nIHKFK3lDY/vHUvxl
	W++IpNKWs1QDgWZ4D5Z9ywjaL+tL4fE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762253129; a=rsa-sha256;
	cv=none;
	b=gQiBqISmJhENVIeQ7juW/dltC5sdH/QSYzAdMR0toLPl1FiIcH+zrbD4CQwj0lB8TTwAd3
	n99PWqKBosmttUQ4SXCOHxYyaRAKLwPBbLPGus72bNcl1mGV/35E1nHqafhWmiFnyhiGr5
	4xj5l9w+AUgjJBwNrCcgGY22C6an3Ns=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=RQoeg4wY;
	spf=pass (imf08.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b70fb7b531cso313476666b.2
        for <linux-mm@kvack.org>; Tue, 04 Nov 2025 02:45:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1762253127; x=1762857927; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OrAQ1tstwLJDUUq1JtEKI2ptLUx1UO5CNRJ0YwBBWYg=;
        b=RQoeg4wY4O+Sg5stPsxIqTw1DvFGvj3AAtJcxbhZVT50uyvTiPNQAwCKk5FnsEb/eB
         bYh6Z2+dmpUkFZL91V+xLxolo4sgcImCu3YxDa5DXKdJy4by/VcwxHrMV7dRzG4JVyHd
         GnjOV5f9e/IMpNOvVTvyIHSZHKVFejfSo9YKQAMWmy7o1K+0zob+wR25RUL+WZQIuHuG
         PJW0H5f61RCHvJR8C+AQZdwxu6+oG/OUvD5Az2R1lJebASNSL+ahSEVIx9F9Qj29AbaB
         VE5r1l56GkM4DxrGJG4VigA/1mdJoOkHRFg/sIpb9P1ncTvYAgs76lV7sqtxnmaH/eDj
         rQbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762253127; x=1762857927;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OrAQ1tstwLJDUUq1JtEKI2ptLUx1UO5CNRJ0YwBBWYg=;
        b=Y9MyAdP/Y5B1BNfBrECeLCO0+b1NWv3rkV7A1FBfxyEHmbE6InHvyub7OcRKS6zXPN
         D179GTj/L923fignB/Iuy+HZ53XREPhT+cgK86T9iKGMXP05eGVVfaQuWMA5Fia+ohqg
         qOeFwQ4Jq+0egKFpXW0ByJUlX6yIbVfESl0AKmaDZ6oBnjPYwKBbZ4wA1451AlngdQJT
         lKQs2rDDRdTmPhzBaFy7Kxy9C+05tq+2DnHqLCqHnYdBqXLMnr7LqDfc2puLq5DqIrQ4
         WP8CT4fk3y19ZLmtVOyOHZrHBQv8dITAWgB7lwzM/ItiZdPMO7P/o3ibKbj3ZwwBIwY2
         Z+nQ==
X-Gm-Message-State: AOJu0YxAB2trkLaeweGgggLD+vfCl2aYNNe7n8MImhnx70PyUiOHZgz5
	Jg9ParHJGB8i0I+zcmnWhaf/9IA1Sed+83RHX/m4toyXkFWemi8OAZs3LyWaJJeWXxUvTIFJlQf
	dxWuA3guYJ0zJul9wDoS/NZ3mSlszz20=
X-Gm-Gg: ASbGncuJU/iykO0nZCn4w5OAbTwIxsCT2Zi/YL+2QDJWSJdKMLvWkgVIGpBO+WbL69Z
	+cQZVN6zU899LsvKqmbcvHz+nACDp+TC9Elf6YzIxT9rP+uQvYxWzmJs9+3siScyfHoZjZ1RAF+
	XsiFppkqoWVTEMD5rHLYaKbvqeMqXX60a5snXzN0UC8HLAliqtNJmcEtQYiim+52SBx/ZRBhKXQ
	E6MblfXIAscxNT/QzEG9I/6j8c69UKNW6CDQXLlTghaCEiHve+5m+LOYko4xN2u
X-Google-Smtp-Source: AGHT+IEaCuYtWsLBUaCT9EKWFYKNWcQu6GTVXqPxrrHWQ7DA5N/s8CqAY4lUgmi5MjTuQPv3/sxjqCOfDtZbqoQ1cXY=
X-Received: by 2002:a17:907:3ea0:b0:b72:5380:f645 with SMTP id
 a640c23a62f3a-b725380fcc6mr140955866b.3.1762253126839; Tue, 04 Nov 2025
 02:45:26 -0800 (PST)
MIME-Version: 1.0
References: <20251029-swap-table-p2-v1-0-3d43f3b6ec32@tencent.com>
 <20251029-swap-table-p2-v1-3-3d43f3b6ec32@tencent.com> <CAGsJ_4xsUwUH_VyeYaXHURqTS66Fbuxa00GTM5izwK-=Vg_20g@mail.gmail.com>
In-Reply-To: <CAGsJ_4xsUwUH_VyeYaXHURqTS66Fbuxa00GTM5izwK-=Vg_20g@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 4 Nov 2025 18:44:50 +0800
X-Gm-Features: AWmQ_bkH1skkIY2XCclQdBdauODDo9nzt-9MwbugyftrD-jN4_dDbPmfi1759Fg
Message-ID: <CAMgjq7DR9o+MmczWoT-p0=q6X-Ed3+qXe=fxj7_CKB77QLxsog@mail.gmail.com>
Subject: Re: [PATCH 03/19] mm, swap: never bypass the swap cache even for SWP_SYNCHRONOUS_IO
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
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DA380160004
X-Stat-Signature: c51zzstxjqhaqtwginp391s7ijeagzcf
X-Rspam-User: 
X-HE-Tag: 1762253128-331532
X-HE-Meta: U2FsdGVkX18Il8G/1FzTs1fLEinFh1WzIXd+26bTob/G/e8RPjOVTnlRtKItipZqC8MdauW4Iqfg4+KlOekmHjgTdrNBJ/jHbkg+UC5x1mTkWTaKv3ZleFNIRULmMKSPqKCEvjipre0+lPFAFxiH+e/xzmuEPKwXtpm0/25a5oNxAGscHHSNTvtFfT9t4GcxO1w8khFKhoG1SOi6YF2TEb7NjJxVE5nbLjpeMJ31l+IE+P8SUgnxHWjd7H5LNs5UtqB7Pn3Hgsjf3N58GOAZNzyk9DYyITg8wy+VpiAu6Cdkz7bYYfKs8wOOFLEqLN62SY7AD5elIyRHXsC8DYRw2pSj3PGxwpvTUQAdtTyt3WptgEODTN0l8YUoS2kvnqfSXyeZ+TgRK69hyFSGlVY49qqHly6AaUf/3r27xfS0nE/E2KW4zwk/QbzdyCB9hdlmR9pLzJIbzUGNlmz22sMK6eCRU9g8xJfK8VgjXFC/X17jwVk/NiYnu6WzJI46R3KyVwcY8WMbCthsxpNog4+eiCeHFm62zm+9a4gf3bA/jqqbfhHzhmI30LKqgPTD+OWoGLum2nvI2P/Ak+Rubs7gMeju1ERhTlfettq+oQZRLpNltNFA9fHQR6F06voCA86q9as/SvhqqVJfWQhgN3Wt6ODCJokaw58lXUP5gZPZUfIjuhH/MHazc7bqlA+DzAWT0N/N50B5aIE9zAMuZ7XKa3JzQ7PulgZJEjW04iApIJyoMGe9c8n1l2fzCDLLkPGh81w3elvZAByXhHwCgz+BetBaVd6hAiE+BxBy2xu7JBivyB6pe9hBXRNAZbGtAwc1CjAyCBPljmlGLBrnoF2xR6J+zhrF5WfBbCr5YAUWLrjcSCCFhpt5k+reM24qJSqyxGP1mWSXk8bgbEJ47ScaJFWGLP5d1BgG6CapJSkYacfGTUYoxY7rG0sY4RU3f1Y8ZXN3hjGYq5qRcId7CXL
 govzjrnM
 hZUszJGDMnHbVwxRiCUGSyVrs2ibFnQbL60CqirtUuAZxGsrZmEiocshMZ5CJL+29F2ehQ+uigLv7MHF4NYjTCgSqc4Hnr9JWYdw3wKamvA/w74kH+wsaEIwFH9siUd0F9ywURyegAykoRWNOdodJ8oUCQchb/3rseBbzb6ba0j/09JDkJBtdudjju7h5ddnPU+/6uyv8aHrwEMV77fXMMdroTYG11yad3a2K0JmH/oaGbreKoqgXV7E3tC7vKzo49ZauDb3P1+4UMpqZowmoGwYq59igeAHU+Gxf8aLdXK+fCkGxk/bBt5d8LWJzeqgatEk75TAup7sgymeoCK84WKq31s/fL4/p6TmP60r+Fnk5HjYa0XI94OmrFqR02CGcQ1q35UaIMp9EZoH+Rh1/pio2IhiCgHw8L/cvMIu+IShOnW3w1rRmUbUSKqBl34TRI+ZZIDNBud64GkQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Nov 4, 2025 at 11:47=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Wed, Oct 29, 2025 at 11:59=E2=80=AFPM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Now the overhead of the swap cache is trivial, bypassing the swap
> > cache is no longer a valid optimization. So unify the swapin path using
> > the swap cache. This changes the swap in behavior in multiple ways:
> >
> > We used to rely on `SWP_SYNCHRONOUS_IO && __swap_count(entry) =3D=3D 1`=
 as
> > the indicator to bypass both the swap cache and readahead. The swap
> > count check is not a good indicator for readahead. It existed because
> > the previously swap design made readahead strictly coupled with swap
> > cache bypassing. We actually want to always bypass readahead for
> > SWP_SYNCHRONOUS_IO devices even if swap count > 1, But bypassing the
> > swap cache will cause redundant IO.
>
> I suppose it=E2=80=99s not only redundant I/O, but also causes additional=
 memory
> copies, as each swap-in allocates a new folio. Using swapcache allows the
> folio to be shared instead?

Thanks for the review!

Right, one thing I forgot to mention is after this change, workloads
involving mTHP swapin are less likely to OOM, that's related.

>
> >
> > Now that limitation is gone, with the new introduced helpers and design=
,
> > we will always swap cache, so this check can be simplified to check
> > SWP_SYNCHRONOUS_IO only, effectively disabling readahead for all
> > SWP_SYNCHRONOUS_IO cases, this is a huge win for many workloads.
> >
> > The second thing here is that this enabled a large swap for all swap
> > entries on SWP_SYNCHRONOUS_IO devices. Previously, the large swap in is
> > also coupled with swap cache bypassing, and so the count checking side
> > effect also makes large swap in less effective. Now this is also fixed.
> > We will always have a large swap in support for all SWP_SYNCHRONOUS_IO
> > cases.
> >
>
> In your cover letter, you mentioned: =E2=80=9Cit=E2=80=99s especially bet=
ter for workloads
> with swap count > 1 on SYNC_IO devices, about ~20% gain in the above test=
.=E2=80=9D
> Is this improvement mainly from mTHP swap-in?

Mainly from bypassing readahead I think. mTHP swap-in might also help thoug=
h.

> > And to catch potential issues with large swap in, especially with page
> > exclusiveness and swap cache, more debug sanity checks and comments are
> > added. But overall, the code is simpler. And new helper and routines
> > will be used by other components in later commits too. And now it's
> > possible to rely on the swap cache layer for resolving synchronization
> > issues, which will also be done by a later commit.
> >
> > Worth mentioning that for a large folio workload, this may cause more
> > serious thrashing. This isn't a problem with this commit, but a generic
> > large folio issue. For a 4K workload, this commit increases the
> > performance.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/memory.c     | 136 +++++++++++++++++++++---------------------------=
--------
> >  mm/swap.h       |   6 +++
> >  mm/swap_state.c |  27 +++++++++++
> >  3 files changed, 84 insertions(+), 85 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 4c3a7e09a159..9a43d4811781 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4613,7 +4613,15 @@ static struct folio *alloc_swap_folio(struct vm_=
fault *vmf)
> >  }
> >  #endif /* CONFIG_TRANSPARENT_HUGEPAGE */
> >
> > -static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
> > +/* Sanity check that a folio is fully exclusive */
> > +static void check_swap_exclusive(struct folio *folio, swp_entry_t entr=
y,
> > +                                unsigned int nr_pages)
> > +{
> > +       do {
> > +               VM_WARN_ON_ONCE_FOLIO(__swap_count(entry) !=3D 1, folio=
);
> > +               entry.val++;
> > +       } while (--nr_pages);
> > +}
> >
> >  /*
> >   * We enter with non-exclusive mmap_lock (to exclude vma changes,
> > @@ -4626,17 +4634,14 @@ static DECLARE_WAIT_QUEUE_HEAD(swapcache_wq);
> >  vm_fault_t do_swap_page(struct vm_fault *vmf)
> >  {
> >         struct vm_area_struct *vma =3D vmf->vma;
> > -       struct folio *swapcache, *folio =3D NULL;
> > -       DECLARE_WAITQUEUE(wait, current);
> > +       struct folio *swapcache =3D NULL, *folio;
> >         struct page *page;
> >         struct swap_info_struct *si =3D NULL;
> >         rmap_t rmap_flags =3D RMAP_NONE;
> > -       bool need_clear_cache =3D false;
> >         bool exclusive =3D false;
> >         swp_entry_t entry;
> >         pte_t pte;
> >         vm_fault_t ret =3D 0;
> > -       void *shadow =3D NULL;
> >         int nr_pages;
> >         unsigned long page_idx;
> >         unsigned long address;
> > @@ -4707,57 +4712,21 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >         folio =3D swap_cache_get_folio(entry);
> >         if (folio)
> >                 swap_update_readahead(folio, vma, vmf->address);
> > -       swapcache =3D folio;
> > -
>
> I wonder if we should move swap_update_readahead() elsewhere. Since for
> sync IO you=E2=80=99ve completely dropped readahead, why do we still need=
 to call
> update_readahead()?

That's a very good suggestion, the overhead will be smaller too.

I'm not sure if the code will be messy if we move this right now, let
me try, or maybe this optimization can be done later.

I do plan to defer swap cache lookup inside swapin_reahahead /
swapin_folio. We can do that now because swapin_folio requires the
caller to alloc a folio for THP swapin, so doing swap cache lookup
early helps to reduce memory overhead.

Once we unify swapin folio allocation for shmem / anon and always do
folio allocation with swap_cache_alloc_folio, everything will be
arranged in a nice way I think.

