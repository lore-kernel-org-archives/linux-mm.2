Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50485CCF2C4
	for <linux-mm@archiver.kernel.org>; Sat, 17 Oct 2026 12:19:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A9426B0088; Sat, 17 Oct 2026 08:19:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 180636B008A; Sat, 17 Oct 2026 08:19:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0961E6B008C; Sat, 17 Oct 2026 08:19:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D1DF46B0088
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 08:19:19 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E0B1C8028B
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:19:18 +0000 (UTC)
X-FDA: 85332023196.27.4E01349
Received: from mail-qt1-f171.google.com (mail-qt1-f171.google.com [209.85.160.171])
	by imf09.hostedemail.com (Postfix) with ESMTP id E16AC14000A
	for <linux-mm@kvack.org>; Sat, 17 Oct 2026 12:19:16 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xmo+H8Ik;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792239556;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wzjdQ8KeLOKPpUHygxBJ7WOEjFu6Ph8LRE3nzk8raOA=;
	b=D+L3fgITwJT+NYC6VdmGBr10ziBDBD23e8qeaENdgrfVqQ8xxI+Y/L9RbPfKu2OBkVuxkn
	AbOP0JHyUpOVVkWZhBzLhwb3E8u3YnH5pVVQ92r7atuIB04Ue+F5+f3hl5JQsypjhPuC6u
	Gay1Yg7ITRCFiFj29Zpmm9eboZ1nR7s=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Xmo+H8Ik;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf09.hostedemail.com: domain of surenb@google.com designates 209.85.160.171 as permitted sender) smtp.mailfrom=surenb@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792239556;
	b=2x+ybvcYStPBpl6p/EJD1C3OHIR+4+vFBa/erElfF/pXpelK8+zdQ1kMg6sc9RhqOrRhGx
	U6ZM0ZYTCwY6YkszsiwtGN6yQDYe0WvmTg28OlBLfGsauAZmc7U1Tqcq8QomlIbyXqsCr6
	1edg6woXy7xr6BVrSTzugUz2QQD6SJk=
Received: by mail-qt1-f171.google.com with SMTP id d75a77b69052e-535f598d126so102331cf.1
        for <linux-mm@kvack.org>; Sat, 17 Oct 2026 05:19:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792239556; cv=none;
        d=google.com; s=arc-20260327;
        b=dNRgPEk0GGtSL76wvJHz1x9vpvJm7BJujIoxVUJadwRGQ0Mp6m6r5hbOM+f1klKL4l
         YBPrwTVVZDKQR5mV06p/ZmMN8vLWqZchH95SKVm9DVKOJm/HASxtaRjxcAJ++fsxuImj
         tgBlAxj72YfpYm1//ujcjPVMf0sD9kTutg+3WBnlVH7IHtamV4hd8CBQFGsf9gANYivo
         i3ZbQiOVEphBSC9GYFpleM8W6JxcfHz+1XCcXwe5Hw6ThOA/XNmlcSDFeaz5rc03Qr2J
         yshBS1raM0DKsPZ3KXmvqdmdO7f+Q6/V+3U0sNubsNff0tH5t8bojHQ79Si3AfKsQSH0
         dEYA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wzjdQ8KeLOKPpUHygxBJ7WOEjFu6Ph8LRE3nzk8raOA=;
        fh=w40Bqh9g6pLEHsYYYY6YdCIkv/mzLTFdGMnYj06ZpCo=;
        b=C3/ysLPVFSyhER29M9ga/ZVC+xXW/kODKa9+eGmzEwcErULe7/txR8I/RZmK5ecvgT
         Yn7QeWV994HKM+z9xEscr+mWgFy8jLvtBJeFzsonA6Mf9q4j3XfRv0xHZkagopda6edt
         gJUz8VTl/Y13nI0oisxd/99UUh4s4BWC1UxAvsO0wGjbDbzllxAvlHYNLsPvHeHBW/AA
         4HJ3VxedNzEeXsINqV/Hma2dKvFIVSAnIlW01Gek4bICABMIsJ35tI9/j9ZUg9LmenJ6
         a8GB6oM1Y90hOo28STfL+f27rTapG+MRTZ+uzJ7gLe0TwvfH0oase4PvLC/ZDkGcc75P
         4hjg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792239556; x=1792844356; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wzjdQ8KeLOKPpUHygxBJ7WOEjFu6Ph8LRE3nzk8raOA=;
        b=Xmo+H8Iko53abCB3NVEgS7gQFQ7uSjMa5j2/EyIfgHSxVHWQrJmd+8Vcl1fKhSzl0u
         oI5vpTdph7yQtndFFf0F9VAyq/naTwxy1DxxDS6/3lp4V1t4JAiRAvaBOb2XzYpeje6+
         edd8OUqifzVmBMXCVSiCnNI0AVG9ibqrK9sgG+WFxwqYgEi6P78PmUnX9estm0DgAQRX
         qk5ce+Hk6xB6vpO9hd9tbGkX1DKjl0i89eoq1qoBY9uCX8IWrQ+/vNSj9OhK0hXOZ7gd
         RPP/LALKjPjQIryzOEybxEtDAbmz4hMUoKAnKIhDOK87ZlfbZ++DMrc5vEl6Q+AZVSgc
         1Ahw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792239556; x=1792844356;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wzjdQ8KeLOKPpUHygxBJ7WOEjFu6Ph8LRE3nzk8raOA=;
        b=LxIb+snUTCg6pENSqLkxrT2HDf/ZMd/4s0LWEVMQx09RllCU7+aX6yLkKdHEMh/h60
         w//IvNnoPjn7VQ3R+yOIXIGO8h+vx+dJ0q01ql98lfYGWP90dctCwiPTlvNt+qKMIBd4
         m4QztjUbwP37NJTe9oI3T0IDQQprre8Gu138N4NWYU1uK6LpYt4G04ezPxrgiKSIJ4qR
         IfzOejWNyjxmm3FWV4G0kHR987gTVe+sV3YeapoHIyHUoVo3mJu5KUb2mnOhuxSQMFp7
         m49AWPue4Fh6RJ/gi7JVlqwpg6qRMvyjfD9eLVh76VQvlPXxejTEc7+nUSmOZSNPY5ds
         B1Ag==
X-Forwarded-Encrypted: i=1; AKwUvBwoecIRGPJ8hHLQC6H2PCCr3oHUB4STYZkcbeXDiQUL1hyZdFSgiab1cL0SdYKeuAV9RFsZcKFMsg==@kvack.org
X-Gm-Message-State: AFq9FYLAaYByBAPR6sOAPbo+qM1WaCFBaYzdkJz/X4DL9HDl2u8brjFI
	gZaaXZFiMrH07KZGw1BUSnGEZP0a7Q3MT7uopj59vwo0vIfpaMdNIeHZcm8EJoH48AUXlkIqi4Y
	Lpupw6h9y8kWRcA4mvP9ArFo4qOiRGnrZGY9dfTnm
X-Gm-Gg: AYBFou3Zzb4cwRSX4gP/WZh+yt4zS6Bn4YiLO75SeXSSlccHPHugSzaL2GGX1X/vmvS
	SrcpOihAGsBENkkJg0tINGjLAf7YhXkIfWHCVP6ou3e6DJ0TdmZXrl0ptzZb1Y6BJwchbopZ9CF
	B6TpvO7BGWfOssRwS7lvtcgLvHdvqmYjfZlznT+0eKx/X4p7K6g365Fk49HD9lrqjTuBRVP8ufR
	AqV6Fr0xTozk/FWGuxO+c866euwos58ZAxu629hP2144JrdtSC9qbit/5Q/uMm0nzf1/fCVtQPQ
	uCHJOreJU8m4P+oP/gye38SC2A/TNGFjsUA2JIGSkuJyejjsI7mV3rKT
X-Received: by 2002:a05:622a:aad1:10b0:533:9746:9a86 with SMTP id
 d75a77b69052e-536499e8967mr8164001cf.5.1792239555029; Sat, 17 Oct 2026
 05:19:15 -0700 (PDT)
MIME-Version: 1.0
References: <20261009063619.112313-1-hao.ge@linux.dev> <20261009063619.112313-3-hao.ge@linux.dev>
 <CAJuCfpE9VfgTw2ZNMJTEVh41H_R+1RY_MtzeMuZNCD3BFm-Piw@mail.gmail.com>
 <as5epHFQF4iE_VQK@pc636> <bdcf2425-c0cf-48df-96a8-7ee1d23125d7@linux.dev>
In-Reply-To: <bdcf2425-c0cf-48df-96a8-7ee1d23125d7@linux.dev>
From: Suren Baghdasaryan <surenb@google.com>
Date: Sat, 17 Oct 2026 16:19:02 +0400
X-Gm-Features: AclHuK_ldkostR4vqZE29fcaoDnWO3b8rAtih31hbuFNFSoBo5VC0b-tINCA_80
Message-ID: <CAJuCfpFWbtBD5K5S49oCPQYTxv0ZvtBio04nNyV9Sj1KRCbiwg@mail.gmail.com>
Subject: Re: [RFC PATCH 2/4] mm/vmalloc: undo partial mappings inside the
 mapping functions
To: Hao Ge <hao.ge@linux.dev>
Cc: Uladzislau Rezki <urezki@gmail.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
	Christoph Lameter <cl@gentwo.org>, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	Sashiko <sashiko-bot@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: E16AC14000A
X-Stat-Signature: fijsqw3yey5w94m9m8az8z7wri8pnx87
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1792239556-993782
X-HE-Meta: U2FsdGVkX18esT4q/a8ZurD0xbAC8VncbtxoV8VSKMVDZGRneR6i30qp6hAEI/gw839SwwRAw5JPEE5CkW/VgFKaskfSgguFctoCXbgY10LmrctgBk7xICkUjJcXoqLtK3SrNMrewF78Gpzx2ub/zY1jaEqmS2evPqEz2rQyb0hR074bk7ZDUEburE3iaZC+rXBRc5J9d0cqs7wEh+HPAL+dOD9/iH56f9HfAEhqk+9HTyZSILuNRxjawC+NhbGOdKYgARTG5u/Dkvh3j7Wkla3pqN3ghYomK6Qpy9tG7MjPxQrQY/0flsVElhmdZyoGhunJVPgvKcijPTfwS1m/5Rehdh/5DPzfYi1rPA0pCuZR7Cjz4HNvS6DWxEwTYeL2NuRnl5y18ldwgoxbEUw6sJoSe9h0niDUt/U8ZHGYGE7g0v3pv3wyqKYfEEuSNanKw7YqT0R2I0JX0kR+YWlinOsdnKjaKeFhYYEWty9e8rzR3Ucv0I2hdxzOhyyNi98KgE2k2g04fv99PcAuUatabdi/xrryjnIb9FiEqJWYzk0hwU0+oRXSpfodq0Juc5lriTF8rcR43OnU3ybcCLMH6LzObmdqpGpb0I97H7O947HZrADg47zE3jxdBZRnXYxZkpRidBfIfM3cdfc+kYl6yWGvcTg+HXDy8HzJAm4t8UGw0dJdxp7c4FYE/e0vr2QBeCSwb4S92gegNFwRGcQS0SU77jYysPrQXwqf1P14OfWlcbMAJEjvHkV9qggsCsLaOfZUC32msmXg9glVWCNq8swb8ms5HvyB5kIBEL10oouu1RFvkqXLGpl08T9Vf9A0s/h5Gck1Ha/O0roE7Hr/2SxByJText3Mj8wfMSeakExylUtK+bYvwV3E+mh6B3fOw9TR5S/UNUSyDvXywfOKnleuHKvjL8MxKCaAeoTxkRS6Zsd18ybWlkRZR1RdOFmgyiQ5inen1tbk9IyGgFv
 V4n7ft0p
 1kLL6TQpI1bh7eYQa4wd5gzWYM/wkb0rdmKKrJujWB8TeqTOC2unX1XwH6efxhKO6QJ+XtIgFfS0LRRGpfq23F4K5qULJsoYwzCZMPdDfUPlNmQ/3E40z1kc9GIjOyF2issDCsQIdkUGIFIQpIP0SsWNh2KhLKoa3li2IWXlYA4d6kUrFjBWZn2A7M4nLGwICMHSaH41UoIZnOo5vDqWqon4LPlZhbOQhr+TskVcQlnWuRGPDhykqJyDXJbU67P24ormnt6b18bRevXesqxH3dtbSwPrP0FPFuRCilNVeyifOI6zPhGi3qd1+LDf/2imXJg/ynjHEAEdJUCqN0G07gD4Sa4WPbknZlWuz0MIPHLS+liI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 14, 2026 at 11:28=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrote:
>
> Hi Uladzislau and Suren
>
> On 2026/10/14 00:39, Uladzislau Rezki wrote:
> > On Tue, Oct 13, 2026 at 03:23:14PM +0400, Suren Baghdasaryan wrote:
> >> On Fri, Oct 9, 2026 at 10:36=E2=80=AFAM Hao Ge <hao.ge@linux.dev> wrot=
e:
> >>>
> >>> __vmap_pages_range_noflush() and friends can install some PTEs before
> >>> failing and leave them mapped, and the kernel callers do not agree on
> >>> who cleans them up. pcpu_map_pages() and kmsan_ioremap_page_range()
> >>> roll back what they mapped before the failure, while
> >>> vm_module_tags_populate() and the __GFP_NOFAIL retry loop in
> >>> __vmalloc_area_node() rely on the mapping functions cleaning up and
> >>> do not call anything like vunmap_range() themselves. When the same
> >>> range is mapped again, the attempt hits the leftovers and fails, with
> >>> a BUG() in vmap_pte_range() for huge mappings and a warning on the
> >>> small-page path.
> >>>
> >>> After discussing with Suren and Ulad, we decided to put the rollback
> >>> into the entry points of the vmap API rather than into every low-leve=
l
> >>> helper. __vmap_pages_range_noflush() undoes the whole range it was
> >>> asked to map when it fails, and vmap_page_range() undoes its range
> >>> for the ioremap-style mappings.
> >>>
> >>> The rollback is __vunmap_range_noflush(), it only clears the PTEs,
> >>> no TLB flush, nothing has touched these mappings.
> >>> vmap_pages_range_noflush() drops the KMSAN metadata when the data
> >>> mapping fails, and an empty range bails out with -EINVAL now, which
> >>> used to BUG_ON() on the small-page path and map nothing at all on
> >>> the huge-page one.
> >>>
> >>> Reported-by: Sashiko <sashiko-bot@kernel.org>
> >>> Suggested-by: Uladyslau Rezki <urezki@gmail.com>
> >>> Signed-off-by: Hao Ge <hao.ge@linux.dev>
> >>> ---
> >>>  mm/vmalloc.c | 44 ++++++++++++++++++++++++++++++++------------
> >>>  1 file changed, 32 insertions(+), 12 deletions(-)
> >>>
> >>> diff --git a/mm/vmalloc.c b/mm/vmalloc.c
> >>> index db669103dc66..e1b376f57dd2 100644
> >>> --- a/mm/vmalloc.c
> >>> +++ b/mm/vmalloc.c
> >>> @@ -363,6 +363,9 @@ int vmap_page_range(unsigned long addr, unsigned =
long end,
> >>>         if (!err)
> >>>                 err =3D kmsan_ioremap_page_range(addr, end, phys_addr=
, prot,
> >>>                                                ioremap_max_page_shift=
);
> >>> +       if (err)
> >>> +               __vunmap_range_noflush(addr, end);
> >>> +
> >>>         return err;
> >>>  }
> >>>
> >>> @@ -683,27 +686,35 @@ int __vmap_pages_range_noflush(unsigned long ad=
dr, unsigned long end,
> >>>                 pgprot_t prot, struct page **pages, unsigned int page=
_shift)
> >>>  {
> >>>         unsigned int i, nr =3D (end - addr) >> PAGE_SHIFT;
> >>> +       unsigned long start =3D addr;
> >>> +       int err =3D 0;
> >>> +
> >>> +       if (WARN_ON_ONCE(addr >=3D end))
> >>> +               return -EINVAL;
> >>>
> >>>         if (WARN_ON_ONCE(page_shift < PAGE_SHIFT))
> >>>                 return -EINVAL;
> >>>
> >>>         if (!IS_ENABLED(CONFIG_HAVE_ARCH_HUGE_VMALLOC) ||
> >>> -                       page_shift =3D=3D PAGE_SHIFT)
> >>> -               return vmap_small_pages_range_noflush(addr, end, prot=
, pages);
> >>> -
> >>> -       for (i =3D 0; i < nr; i +=3D 1U << (page_shift - PAGE_SHIFT))=
 {
> >>> -               int err;
> >>> -
> >>> -               err =3D vmap_range_noflush(addr, addr + (1UL << page_=
shift),
> >>> +                       page_shift =3D=3D PAGE_SHIFT) {
> >>> +               err =3D vmap_small_pages_range_noflush(addr, end, pro=
t, pages);
> >>> +       } else {
> >>> +               for (i =3D 0; i < nr; i +=3D 1U << (page_shift - PAGE=
_SHIFT)) {
> >>> +                       err =3D vmap_range_noflush(addr, addr + (1UL =
<< page_shift),
> >>>                                         page_to_phys(pages[i]), prot,
> >>>                                         page_shift);
> >>> -               if (err)
> >>> -                       return err;
> >>> +                       if (err)
> >>> +                               break;
> >>>
> >>> -               addr +=3D 1UL << page_shift;
> >>> +                       addr +=3D 1UL << page_shift;
> >>> +               }
> >>>         }
> >>>
> >>> -       return 0;
> >>> +       /* Undo the PTEs installed before the failure. */
> >>> +       if (err)
> >>> +               __vunmap_range_noflush(start, end);
> >>
> >> Would it be too complicated to track how much was actually mapped and
> >> unmap only that portion?
> >>
> > I think it is possible to vunmap the range which is already unmapped.
> > i.e. in this case it is better to no to track anything as soon as a
> > mapping failure is a corner case. Also it is more reliable without
> > extra track logic.
>
> Thank you both.
> I take note of Suren's concerns. The worst case is a single PMD where onl=
y
> the first page was installed, __vunmap_range_noflush() then loops 512 tim=
es
> to undo one PTE, plus 511 empty ones.
>
> And tracking the exact progress would require vmap_pages_p4d/pud/pmd_rang=
e()
> to report how far they got. That also puts counting instructions on the s=
uccessful
> mapping path, while the saving only pays off on the failure one.
>
> So I agree with Ulad.

Got it. Makes sense.

>
> Thanks
> Best Regards
> Hao
>
> >
> > --
> > Uladzislau Rezki

