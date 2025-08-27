Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E828CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 13:44:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D44D08E0005; Wed, 27 Aug 2025 09:44:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF5698E0001; Wed, 27 Aug 2025 09:44:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0B908E0005; Wed, 27 Aug 2025 09:44:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC8FA8E0001
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 09:44:45 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 549E7119255
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:44:45 +0000 (UTC)
X-FDA: 83822657730.10.AE0F8BF
Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id 62F5B40013
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 13:44:43 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YF2V8BsV;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756302283;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7xwolI3JL6HatAKk8RXMI3q1JurvvPS3JqRohVosR4A=;
	b=iRN0p0dYgz6yfDZkrjHgFCCqDch+zlcEiJeZFehHCQ4z9Z+WieyOesGIFa1xdJL5Li9vcZ
	Fwl+sr4+WEWNCzHxhy63Yg5Va9YYAcmePWmMKmB21kswe/JFl1z7g0f6Hq+u8iSxX/xdR9
	iFPa3TrKkYorGwpZoEH06rHPQ6sJ3Fo=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=YF2V8BsV;
	spf=pass (imf01.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.208.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756302283; a=rsa-sha256;
	cv=none;
	b=zd4VNiLQy80YQQ/5kuljjg+4/fMCgvT2/c9dzgU/j/qVnt46eLfUvHaXyvtsf+/bwcCiY1
	lieJf4dsk22VDNK4JkvopcIzdFxGfldEZWY9ZRktm1U4ssK7NCe/pI4ISMG44IaZv8drMh
	Z5unp6B2LlUqekTPTvYaPTjUVPuLQ+w=
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-3367144d19cso33067271fa.2
        for <linux-mm@kvack.org>; Wed, 27 Aug 2025 06:44:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1756302281; x=1756907081; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7xwolI3JL6HatAKk8RXMI3q1JurvvPS3JqRohVosR4A=;
        b=YF2V8BsVZo1t/6rNTTKgad/Rl0TjKsDWO2k/Ix3NC0udN3cfMVilU2+wvEmuGSNNb9
         +80+jdivkTC7tIiah/PcT4SntWXibDtE2RPmfqzKwvuPhhwaVfvMql1B4r+zsuLl/rt2
         zdxWXhr4NTzgA5/TUmFM7QDErx99ep7Dk8iTDpzRDLXP3wdygOaAc0NE88DjhSub6KHV
         0M+Fa/GXWwlPk2iS6WMgA6oG2CUD3hBVk4YVo33Vz5bJA/M58NfoWNCnxc6Tu885RDAn
         Ke0NqX3jo0HPcuH7MSdoGJYSNzVLXc0VPFhsR33LD+ywtW8pk2CYKsJ8nKIbEIBhwrLl
         21sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756302281; x=1756907081;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7xwolI3JL6HatAKk8RXMI3q1JurvvPS3JqRohVosR4A=;
        b=AAO3L5Hf5LBduc9HsxhMI9zL/3/d18BnotiQfo17Is3MB80L2adCCJhwdg6jFty89L
         M91iHJU8PXeHNiRdVvgcqMbim/hala/9hECWD2Ouxadq8r0eWqld9LvczYZevoZxxzCr
         YNpbCEMI3jzL5aSF9pHeviJLTH7odyHmStE+m7FFdniKl0EPcyU7Goaw55QhWvdKC13N
         JqbexCxJkh4PDRh4Qui+NBUlsP49vjAu87avQ7dDdPI7PeWauyBfd6DHEqUQGuNq1mz8
         oaD4MZ7cZUPGyw6IFQYvIc6POO64cpcC5naZoic4AwwCQp8L425aWjngOp4o6nnBHRb/
         d4Ng==
X-Gm-Message-State: AOJu0YwsJ0B5PonI/iwK05zYFcYQIl/f9J5pJ1MIT8Gxsu471ElQsohf
	gdDlpcxvd4E0o+5Bj8m9yicM3VZsr7fV2Uz60g+h1MTd4fE9yVbZ7yxGcF1Bjkeg0UuyzeTVhiM
	ZLrE3hGMLSxqj653kjtV3Rce1DyFTb2A=
X-Gm-Gg: ASbGncvkLKpkdUmfYDRqi5tsjUkCLCBqiyzE5IS1XNKBbgic+Etiy4taK+Zzk8/LuBh
	OuRg6RNbxqrBR1qzScP3l55Z6ZiBngA3GE+nzZ6j3QgPUH7G3DGmPqdiERIBR1VfEQ0n+5wZ/5K
	av+tJ57LbV0bXVlIBOWIZT2uU3r0IqO1bww2SphhX7+zOzNYe5L1xjyHZEJTeMlmNb5IwP0jcan
	eQidJc=
X-Google-Smtp-Source: AGHT+IGmYpQbpfuydC8NCsfBCwp183Em8dNqxVVVzvuFWJmjtTKiVrVr8p0Yg43IfJSD/pG8ONjOD4NvS6tNvLVFCHs=
X-Received: by 2002:a2e:ae0c:0:b0:336:4eee:6ea8 with SMTP id
 38308e7fff4ca-33695ac4dcfmr4568601fa.24.1756302281118; Wed, 27 Aug 2025
 06:44:41 -0700 (PDT)
MIME-Version: 1.0
References: <20250822192023.13477-1-ryncsn@gmail.com> <20250822192023.13477-3-ryncsn@gmail.com>
 <CAF8kJuMX_WTg7vyACBxskNmDHB4C-ZkowuKYP71gQ8qyKuwAaA@mail.gmail.com>
In-Reply-To: <CAF8kJuMX_WTg7vyACBxskNmDHB4C-ZkowuKYP71gQ8qyKuwAaA@mail.gmail.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Wed, 27 Aug 2025 21:44:04 +0800
X-Gm-Features: Ac12FXwvwDbIY__kyety6f-KXf8kie0xuSwLrgJfJB1wSgJirCCr99XWfP12D7U
Message-ID: <CAMgjq7D3EiLOyEQiR+Uq6mTdXajMCg4+A+KRZajE91kbTw=tHg@mail.gmail.com>
Subject: Re: [PATCH 2/9] mm, swap: always lock and check the swap cache folio
 before use
To: Chris Li <chrisl@kernel.org>
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
X-Rspamd-Queue-Id: 62F5B40013
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: tip78fmujq717fszuwjt8cehnsg7nsdj
X-HE-Tag: 1756302283-822430
X-HE-Meta: U2FsdGVkX1+QTn9oh1u4yQGrs+MZu3MaMy+mPT4WiFf9QzDwgqp5ncfySVxXX5CHqebM3kIIS/CByFxmNqVNo+dFY3H2Pc+YOGd/f2vrntbr0Hvl9VtRF+qSDAKn12m9V4nLJ9/yxveo3TRwSyjobx2feuZVzpK0ySJYHGVj153ftYqYxve5lI9yLSXYpsPLYalYQCrYz/BATCnShD88T+vI/YrJD93xjoiBmOtjY4yuKEXl8J05iEQnIU3+9witQAPWnJuSLlTTavjX07QbFkPT//UJ1CGxdT0cBmvEtx9DQoGOLzo3OesyyAEk/YeGgYaPtXY3sYTrFrT3AN7HiLccbCilbfiyrnJb91ulF6XbvZ9NdHzHCucHwm42NTrhe87SRaRqzK58tqtrfIRjp4CtwvGak9luz8yXza2agceAx03lmLOP0gWoeliUt4l5SUy3mDFf41JgDD0dHD0ATplvl9EGgXtmiYdiR4+dKPgLp8qsr+Vfbe4d6yJynEEnyrrLYQVYKDsawOvC49Fg0QanPaLA345jxF3a1xPynVw4MB03ZhkrhIw64qmHvOEUB0pCHFV9G1IrhvMdY6vYPmRqWtxrvDW8G2o/AGudFkIizar3y1w6qFPvlBuBPzENiqgrbGdxwIwzNzpTE+oo81Q6/ZYnowI6ZaVX0Y5wYULl6SrhCRD121kfZNWB0wkTLay0RRz7RcD1YNdk4TWirfpcXu63em9c7CoeG+rO1dEk3slk6fhZbNuKZc+96sYKUgzwpTqtL9ZUdu2U9l7JNizzxRjPYlfWprwTG6tlDVu0Pjz3IirT12cAffsQs8MKRqL9sp8NVRNF7RE+LnQlc8hHwW0rQDh/kRtjjQFDgvE7yzkGRN0ZyJ0jVno0IHTC495gm9/ifIbkA/9CWZItthuvFkiZCX2/YGPyIoOP0bH5oEWsoGIYcMQBIqDjRn4z4tzaAuzMVAyZxwhEN8I
 XrjUmHRO
 8HUak+EVoOHuKpK8Yb+Q4JABLLytl6SdrbdApdy8PNf8RCog3bDW3dnnloi3oirK537dwa2bLh0+ntzHpzaIxen3UBNUIjDPEUwc3hehWvbrfmffnRd3wpwUAT/S/+8mHkI1v8UYHMCC3AodkdgTW4daOqSADvt+mWvIWaKAXBgwUaX3IHshWKrAFBhD8cN0pGuaUBhOt8ClgFtrn+fSrFc/kIxNzjt5q25JXZjg7vHma1u9u4SdjHJ22AnFuNKmE+KT+eERvX5embJ4CQsrMNe371isVmzuKN7T32pa+gEL5XH70bEkPCfRl4wnbZi3ZVBZEawMddhwFjOS9f60vo/ZvkGYJAyS++xKfrRxlADIA4+NVZlaB+GHGjeTc55f+OxJYt885rsH/hxw1TQFp3VsZzgHxjGvL92J6WyV4nKfCpLU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 27, 2025 at 4:06=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Fri, Aug 22, 2025 at 12:21=E2=80=AFPM Kairui Song <ryncsn@gmail.com> w=
rote:
> >
> > From: Kairui Song <kasong@tencent.com>
> >
> > Swap cache lookup is lockless, it only increases the reference count
> > of the returned folio. That's not enough to ensure a folio is stable in
> > the swap cache, so the folio could be removed from the swap cache at an=
y
> > time. The caller always has to lock and check the folio before use.
> >
> > Document this as a comment, and introduce a helper for swap cache folio
> > verification with proper sanity checks.
> >
> > Also, sanitize all current users to use this convention, and use the ne=
w
> > helper when possible for easier debugging. Some existing callers won't
> > cause any major problem right now, only trivial issues like incorrect
> > readahead statistic (swapin) or wasted loop (swapoff). It's better to
> > always follow this convention to make things robust.
> >
> > Signed-off-by: Kairui Song <kasong@tencent.com>
> > ---
> >  mm/memory.c     | 28 +++++++++++++---------------
> >  mm/shmem.c      |  4 ++--
> >  mm/swap.h       | 28 ++++++++++++++++++++++++++++
> >  mm/swap_state.c | 13 +++++++++----
> >  mm/swapfile.c   | 10 ++++++++--
> >  5 files changed, 60 insertions(+), 23 deletions(-)
> >
> > diff --git a/mm/memory.c b/mm/memory.c
> > index 10ef528a5f44..9ca8e1873c6e 100644
> > --- a/mm/memory.c
> > +++ b/mm/memory.c
> > @@ -4661,12 +4661,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >                 goto out;
> >
> >         folio =3D swap_cache_get_folio(entry);
> > -       if (folio) {
> > -               swap_update_readahead(folio, vma, vmf->address);
> > -               page =3D folio_file_page(folio, swp_offset(entry));
> > -       }
> >         swapcache =3D folio;
> > -
>
> Can simplify as:
>            folio =3D swapcache =3D swap_cache_get_folio(entry);

checkpatch.pl is unhappy about it:

checkpatch: multiple assignments should be avoided

>
> >         if (!folio) {
> >                 if (data_race(si->flags & SWP_SYNCHRONOUS_IO) &&
> >                     __swap_count(entry) =3D=3D 1) {
> > @@ -4735,20 +4730,13 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >                 ret =3D VM_FAULT_MAJOR;
> >                 count_vm_event(PGMAJFAULT);
> >                 count_memcg_event_mm(vma->vm_mm, PGMAJFAULT);
> > -               page =3D folio_file_page(folio, swp_offset(entry));
> > -       } else if (PageHWPoison(page)) {
> > -               /*
> > -                * hwpoisoned dirty swapcache pages are kept for killin=
g
> > -                * owner processes (which may be unknown at hwpoison ti=
me)
> > -                */
> > -               ret =3D VM_FAULT_HWPOISON;
> > -               goto out_release;
>
> Here you move the HWPosion(page) bail out from before taking the page
> lock to after the page lock. The HWPosion page should be able to bail
> out without taking the lock.
>
>
> >         }
> >
> >         ret |=3D folio_lock_or_retry(folio, vmf);
> >         if (ret & VM_FAULT_RETRY)
> >                 goto out_release;
> >
> > +       page =3D folio_file_page(folio, swp_offset(entry));
> >         if (swapcache) {
> >                 /*
> >                  * Make sure folio_free_swap() or swapoff did not relea=
se the
> > @@ -4757,10 +4745,20 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
> >                  * swapcache, we need to check that the page's swap has=
 not
> >                  * changed.
> >                  */
> > -               if (unlikely(!folio_test_swapcache(folio) ||
> > -                            page_swap_entry(page).val !=3D entry.val))
> > +               if (!folio_contains_swap(folio, entry))
> >                         goto out_page;
> >
> > +               if (PageHWPoison(page)) {
> > +                       /*
> > +                        * hwpoisoned dirty swapcache pages are kept fo=
r killing
> > +                        * owner processes (which may be unknown at hwp=
oison time)
> > +                        */
> > +                       ret =3D VM_FAULT_HWPOISON;
> > +                       goto out_page;
>
> It seems you bail out with the page still locked, that seems like a bug t=
o me.

I think it's the original behaviour that is kind of fragile. The
returned folio of swap_cache_get_folio is unstable unless locked, so
the folio could have been removed from swap cache or marked by some
other threads as Poisoned. So the PageHWPoison here could be tested
against an unrelated page, which leads to false positive PageHWPoison
results. We have encountered several similar bugs due to using folios
returned by swap cache lookup without lock & checking first.

So checking HWPoison after locking is actually safer.

>
> I think this HWPoision() check move order with the page lock is problemat=
ic.
>
> Can you double check?
>
> To be continued.
>
> Chris
>
> > +               }
> > +
> > +               swap_update_readahead(folio, vma, vmf->address);
> > +
> >                 /*
> >                  * KSM sometimes has to copy on read faults, for exampl=
e, if
> >                  * folio->index of non-ksm folios would be nonlinear in=
side the
> > diff --git a/mm/shmem.c b/mm/shmem.c
> > index e9d0d2784cd5..b4d39f2a1e0a 100644
> > --- a/mm/shmem.c
> > +++ b/mm/shmem.c
> > @@ -2379,8 +2379,6 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
> >                         count_vm_event(PGMAJFAULT);
> >                         count_memcg_event_mm(fault_mm, PGMAJFAULT);
> >                 }
> > -       } else {
> > -               swap_update_readahead(folio, NULL, 0);
> >         }
> >
> >         if (order > folio_order(folio)) {
> > @@ -2431,6 +2429,8 @@ static int shmem_swapin_folio(struct inode *inode=
, pgoff_t index,
> >                 error =3D -EIO;
> >                 goto failed;
> >         }
> > +       if (!skip_swapcache)
> > +               swap_update_readahead(folio, NULL, 0);
> >         folio_wait_writeback(folio);
> >         nr_pages =3D folio_nr_pages(folio);
> >
> > diff --git a/mm/swap.h b/mm/swap.h
> > index efb6d7ff9f30..bb2adbfd64a9 100644
> > --- a/mm/swap.h
> > +++ b/mm/swap.h
> > @@ -52,6 +52,29 @@ static inline pgoff_t swap_cache_index(swp_entry_t e=
ntry)
> >         return swp_offset(entry) & SWAP_ADDRESS_SPACE_MASK;
> >  }
> >
> > +/**
> > + * folio_contains_swap - Does this folio contain this swap entry?
> > + * @folio: The folio.
> > + * @entry: The swap entry to check against.
> > + *
> > + * Swap version of folio_contains()
> > + *
> > + * Context: The caller should have the folio locked to ensure
> > + * nothing will move it out of the swap cache.
> > + * Return: true or false.
> > + */
> > +static inline bool folio_contains_swap(struct folio *folio, swp_entry_=
t entry)
> > +{
> > +       pgoff_t offset =3D swp_offset(entry);
> > +
> > +       VM_WARN_ON_ONCE(!folio_test_locked(folio));
> > +       if (unlikely(!folio_test_swapcache(folio)))
> > +               return false;
> > +       if (unlikely(swp_type(entry) !=3D swp_type(folio->swap)))
> > +               return false;
> > +       return offset - swp_offset(folio->swap) < folio_nr_pages(folio)=
;
> > +}
> > +
> >  void show_swap_cache_info(void);
> >  void *get_shadow_from_swap_cache(swp_entry_t entry);
> >  int add_to_swap_cache(struct folio *folio, swp_entry_t entry,
> > @@ -144,6 +167,11 @@ static inline pgoff_t swap_cache_index(swp_entry_t=
 entry)
> >         return 0;
> >  }
> >
> > +static inline bool folio_contains_swap(struct folio *folio, swp_entry_=
t entry)
> > +{
> > +       return false;
> > +}
> > +
> >  static inline void show_swap_cache_info(void)
> >  {
> >  }
> > diff --git a/mm/swap_state.c b/mm/swap_state.c
> > index ff9eb761a103..be0d96494dc1 100644
> > --- a/mm/swap_state.c
> > +++ b/mm/swap_state.c
> > @@ -70,10 +70,12 @@ void show_swap_cache_info(void)
> >  }
> >
> >  /*
> > - * Lookup a swap entry in the swap cache. A found folio will be return=
ed
> > - * unlocked and with its refcount incremented.
> > + * swap_cache_get_folio - Lookup a swap entry in the swap cache.
> >   *
> > - * Caller must lock the swap device or hold a reference to keep it val=
id.
> > + * A found folio will be returned unlocked and with its refcount incre=
ased.
> > + *
> > + * Context: Caller must ensure @entry is valid and pin the swap device=
, also
> > + * check the returned folio after locking it (e.g. folio_swap_contains=
).
> >   */
> >  struct folio *swap_cache_get_folio(swp_entry_t entry)
> >  {
> > @@ -338,7 +340,10 @@ struct folio *__read_swap_cache_async(swp_entry_t =
entry, gfp_t gfp_mask,
> >         for (;;) {
> >                 int err;
> >
> > -               /* Check the swap cache in case the folio is already th=
ere */
> > +               /*
> > +                * Check the swap cache first, if a cached folio is fou=
nd,
> > +                * return it unlocked. The caller will lock and check i=
t.
> > +                */
> >                 folio =3D swap_cache_get_folio(entry);
> >                 if (folio)
> >                         goto got_folio;
> > diff --git a/mm/swapfile.c b/mm/swapfile.c
> > index 4b8ab2cb49ca..12f2580ebe8d 100644
> > --- a/mm/swapfile.c
> > +++ b/mm/swapfile.c
> > @@ -240,12 +240,12 @@ static int __try_to_reclaim_swap(struct swap_info=
_struct *si,
> >          * Offset could point to the middle of a large folio, or folio
> >          * may no longer point to the expected offset before it's locke=
d.
> >          */
> > -       entry =3D folio->swap;
> > -       if (offset < swp_offset(entry) || offset >=3D swp_offset(entry)=
 + nr_pages) {
> > +       if (!folio_contains_swap(folio, entry)) {
> >                 folio_unlock(folio);
> >                 folio_put(folio);
> >                 goto again;
> >         }
> > +       entry =3D folio->swap;
> >         offset =3D swp_offset(entry);
> >
> >         need_reclaim =3D ((flags & TTRS_ANYWAY) ||
> > @@ -2150,6 +2150,12 @@ static int unuse_pte_range(struct vm_area_struct=
 *vma, pmd_t *pmd,
> >                 }
> >
> >                 folio_lock(folio);
> > +               if (!folio_contains_swap(folio, entry)) {
> > +                       folio_unlock(folio);
> > +                       folio_put(folio);
> > +                       continue;
> > +               }
> > +
> >                 folio_wait_writeback(folio);
> >                 ret =3D unuse_pte(vma, pmd, addr, entry, folio);
> >                 if (ret < 0) {
> > --
> > 2.51.0
> >
> >
>

