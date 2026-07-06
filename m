Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81C66C43458
	for <linux-mm@archiver.kernel.org>; Mon,  6 Jul 2026 06:55:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 379506B00F0; Mon,  6 Jul 2026 02:55:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3295B6B00FC; Mon,  6 Jul 2026 02:55:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 241D46B0105; Mon,  6 Jul 2026 02:55:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id F11146B00F0
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 02:55:47 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 738AE12030B
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:55:47 +0000 (UTC)
X-FDA: 84957441534.13.4EB25A1
Received: from mail-lf1-f49.google.com (mail-lf1-f49.google.com [209.85.167.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 81FE31A0002
	for <linux-mm@kvack.org>; Mon,  6 Jul 2026 06:55:45 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tIUftRav;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=souravpanda@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783320945;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wwmFUY8brw4r/I6IiR1qRjx8RhY2uc7/+JYH9RaJI/k=;
	b=6viRAQcgc7I/+4AmDvEQgvluRqZ05XXNoPY1nL2oiPGw5QeaakDjy2kBMXL87mEVMYQDMG
	x5P971V5zNURylK/faZawwo80hsAzQH3EX7Ky956lciV+Y69UNLk+gL+DCO5u7s/gaA42R
	KPxtVNXLKn3d1iLK5a6GXzj91nZaWRc=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tIUftRav;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf19.hostedemail.com: domain of souravpanda@google.com designates 209.85.167.49 as permitted sender) smtp.mailfrom=souravpanda@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783320945;
	b=5Y6TNPJ5j2N38JrWbjV9wlKcdAdA5V1l+2RdPIqmjS8DvHfh7KiNGyj0UESpxKHjN5pWS0
	NW9TldtaMTNX/quaMvnpk30GNiaRBykgJDckjlXU7c4msH5ECZeH0CP4TkxHCTd+Me0U5N
	7/iMghQbTQuX/3ja4P3VaT2e5Opn+oE=
Received: by mail-lf1-f49.google.com with SMTP id 2adb3069b0e04-5aeb688ae83so50300e87.1
        for <linux-mm@kvack.org>; Sun, 05 Jul 2026 23:55:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783320944; cv=none;
        d=google.com; s=arc-20260327;
        b=jOFTe3WlgeCyMgMjYSQRTv6iOTrFh7O1F7y6T/WlZteUOvaamSiIyvt/fyV2DlrkmQ
         X5d1OJPFY4eF9akbdiebSFk4kAJIaICcemRlbF02pR2jQaD3F/41lBDOzso9lEl08bZB
         1Ww1NAtD1fy75AeGgkoCoOzJ+vZ7yXHV9bPLNHiuF9T5UKYAjYn2a6t3K8GahhLL52zu
         N+XRhDuZosaFHJ2MYcgFX+wSXfFoiV6MbT/0gk285m5RhJn0qH3pHfqjR4TcdMQ7B3ES
         Frl2Dj+jDK9sBy9rq54I9WAfueZPUKlziELA7SUmwgDfumCLGaPX1W3pPFpm9DeJuAkq
         9i1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wwmFUY8brw4r/I6IiR1qRjx8RhY2uc7/+JYH9RaJI/k=;
        fh=6iyKwIUOytQmJ7Y4FiYOYgWkWS4XCqOCF1Ok4ZdfBdk=;
        b=AcYPENGJG9GmdqVWHWuGWofDhwHu6ms6gxwpQaJ4/5qFs/USan81GA6n6tm1eoilmu
         N6UBLEP9tb3rBgyldHM9HL4TxOQosqOwadDflkb8m7o67xZapV+LI/09QWw3rG0pXdW/
         sLHJlJjOBn9anvlSl8ltaf+CT6ldH/x2TmgcZ0ChElhkgU25rMGOrAsXukz3Q/eya8Ua
         Z/KWnoA0UfdLhMsu2Sr3u+USJygBBFxAROZsWqewu8FiqbH8t3Z3lhrNPuhyotVkoGYk
         WcEVpy2c5W8V8Rq2OsfuYyrdnI5HkTtGp1Eo0xAzC1hpAWDbCU9KhDMo1lRtDxRSRkFM
         7TGg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783320944; x=1783925744; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=wwmFUY8brw4r/I6IiR1qRjx8RhY2uc7/+JYH9RaJI/k=;
        b=tIUftRavfHROdB2vVr+s7G463WmH9OO1eywkbhA8O1+FeLai33FDnymuuW/gz0PTQW
         WfnHdjkKv1DUcuyBisnSS7Jz4IEXGfAJrCUorpOM0XVyWsFRbJx5CI/A2AN/osJUzFa8
         mTBsub59IE7OEi9JIEIue3wz8bEG54x2Y9ulz+PWdLZAzlFwZiVTeMJaKroFpJQWsC9z
         5zJMSnZaVlgk06mnFzFZby5yEOeFs5u7EJrB9bWbWTuvY3WLcwZC8c5W0SwexQKWJJi9
         UePofjnCWg8svcAoo+VyCpNCAtEI/kHUKkqULvSNWn6MCCagRsrxuJg3ZdhmGalSIlg1
         gc9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783320944; x=1783925744;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wwmFUY8brw4r/I6IiR1qRjx8RhY2uc7/+JYH9RaJI/k=;
        b=IdZiX5lBTwXeC3ZyegmB5BkyYtQdTMRNEu97nnPV7qB8hLw0wjmM6QQEkU0CYIuq2G
         2NBGcE2zhb7fzgwArPOgskfNNUcF7RUshi5LrwS4Bi4d72CLRrnWwOuBlYJPQGZt+wfP
         k8VoRbPNDldLkyQwseI/CvCkxTvXff0G3HwpCw2CkqKwz7XleZR0VHu1z4A8zRHMpy+w
         izqz16B/O58QvLzk5AOSIHarhi/lQ2RDUNRdqXA/EXrm15USq/9qiM3CQDK2hSAUDz8I
         ooJzHW8ZrFdGWq2h5jds9ddtT4UOSdl+KGhDpqV/24RePdEoAFk91i61l05rOvnRpBXj
         lchg==
X-Forwarded-Encrypted: i=1; AHgh+RqxIpe/O42/jT8fPW94DomeOpHJR0YbnbzvDAeZW5TMhaGNrqw9pGGlA4Q30otoRjWsEpBNMpT7bA==@kvack.org
X-Gm-Message-State: AOJu0YxEyTxpYrK31OYi6yuZE2tNgGCIXqYdwNioU8j3cCMi5ggwP6+U
	u+bqtCTtr8ogF2l6s/rVHbn2dVWd8SZjyKoxRrrBuR7MTDaC2ep/i11WdDRc9NlrQncGYmIvtW9
	6dxQRDobpJNrUo7J0L6aBBeMdbltrgIKBOcH9f7p8
X-Gm-Gg: AfdE7ckJrSuo1M+e3GvZ0RD/N7T9GtmUBr7k/Idj2px0LhoQRXJibYQfbzHokQ4Gh+h
	aH7QDj4QApIWwCLlohO+/96VQZlDOhxcGfytKNuaXEQFUlSK3F1v9OwR8dBsuHCvLl4W6vQm8+y
	Hex7qaY9xxDi9F902gxEuh0BOzBlCHnQlByWi0E9kZ1IgpDHvG5x9IVaL85xdJ0FmpX0KiISOjf
	Y9BI/XQ20rm89vcbG4/Btl/kH0tTcRG5i6H5yKSZYSKmpOGnq+Sb3+nv63bDpZpnfiXbM7nn2D5
	6+pu5/NcJ2jfjHcvx/ESiwNwY7cfUepQevCVm24BHPpMcGRiI0xnbb1z/6RNiA==
X-Received: by 2002:a05:6512:239a:b0:5ad:4a8f:58ed with SMTP id
 2adb3069b0e04-5aed45e5a18mr93488e87.7.1783320943205; Sun, 05 Jul 2026
 23:55:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260705175119.440599-1-souravpanda@google.com> <B8DC1E3C-24B1-4608-86B1-5F12B2FF4DBE@linux.dev>
In-Reply-To: <B8DC1E3C-24B1-4608-86B1-5F12B2FF4DBE@linux.dev>
From: Sourav Panda <souravpanda@google.com>
Date: Sun, 5 Jul 2026 23:55:31 -0700
X-Gm-Features: AVVi8CcI0HPanfQKlxlArDg6XV8q8368wCGKsqn-FteoJb6J0pRYrU5P6KOv18g
Message-ID: <CANruzcTi8+37K=YQwpZ51MxzDUKiX-gF6BdFMXax=ozzZw86eg@mail.gmail.com>
Subject: Re: [PATCH v3] mm/hugetlb: Fix null nodemask in alloc_fresh_hugetlb_folio
To: Muchun Song <muchun.song@linux.dev>
Cc: osalvador@suse.de, akpm@linux-foundation.org, david@kernel.org, 
	fvdl@google.com, gthelen@google.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 81FE31A0002
X-Stat-Signature: m51x7ebap8d3ichwt5ynsijsw8ny715z
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783320945-781983
X-HE-Meta: U2FsdGVkX1+K1m/YXgCtn/s06Eo5+BB3mEiN2POK5s/0+/zlwQ1ql8MVGnrXl8ILMpkU+/oiaHb7hSh4Fr2+FEzCMKvu6F5Oz2BNnTXObCoPoNU/b3p3sh8Pex7Xf7uQGZbm+yurSTpQTvfii8bNB96uhF5+K1KMzsNph8JBtx3LmsUt7z6KEa+c4Bar9JjSET3K5F+auhfAYttZM7TPv2N9GfOO9WntlgWxwEpWpH2h0K2OPoICVOeAGW0KHD7NqbD+mGq3nz7IiHQNS07dGDtYfg8UP/p6j/Shnzgd11b6Pxft/BaXIeR1FEJzZHkubmtjno+PiwG5ZAVu3e72pKVg5rJBL4KgV0ioI1LGP/F0uRgDnQZCH8IlrOdrlCB5yCDj7IzxyOegK5VvljnsqmW69UVRq/CHc/oXoPZ2oEr8Yr0Jxtrf5sqiiQXrhG0GwFKIiAdTkcu7EtSEJ3VVh+QaPIAZDGSf8hB1TBk8tQk59GvjUyWwDMAjIqmhxLYmmu8MNjOYWe2ebLFf85YZ8i58k62ZzTffXNiJU8RtNcGFjaeP7oO/UXO17zdBde3p+bQWD9mmjdCCcDfje1FCeGcKiNr3Ty6clmjisJth9c9637FJbzSq7xlW5HxNXHHiPHWscsnqfE221qMyQUyrEvEE2YW/H5jtrKDR2F8fPOJhNBEVnDOoW90rPiGURT246KzdScbQDSKlUdJouWrfcHa1XZa9fzN3tfU7ke2hrCnZR9PMmafIGG8sT3WIhNpp5r/030yyi05DkZF/xGqQJj+8EyUGTrLYQ5WWbCO2yuZ1LL72BXCQFm1pkfq3sQuDLQqJSii+54xvHBWOFeQ5HlST+9Hds1SWmR9jzbtfZ+cTplfoEPe63hd2Qq9EA/uNeeWn3hS8JmrWkAarsBPfwgprIotr/3HdajXyJtVpRhoT++90TQo3MUzrY0ED5+kzMLuEd9km1G4/sm1aN+V
 I9NkrN8c
 2x8UemNLRXSZrPEFUVOnHmtng8SZ26TP1tOToEJLRcdqTIl6QrqmLvWSilf1j4jvP4tYtPOoMbSG4qJm1UhtjQ/uckb9LiG5J3IMgKvXMgKOoGqDkwgY2YywyaGrJnwveaBi413SdRMNcc5pwv+keLgOzYW5fIbW4Ickkvseg+ml+8TMd8JUaWdG91RbTl975bAi8RrB8iYWjnbpqR/szVQ+DL6qPxknmveZo2V8FiRlsCmOP2TmhLdJCdY7T46OPyR1JRzusfh9izeyfJlcg/ggu9jIszrem4vdAALRrIygtMyfOTbQzj7VpQb6AK3Yhv+V3vPB7PuzcLns=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 5, 2026 at 11:18=E2=80=AFPM Muchun Song <muchun.song@linux.dev>=
 wrote:
>
>
>
> > On Jul 6, 2026, at 01:51, Sourav Panda <souravpanda@google.com> wrote:
> >
> > alloc_buddy_hugetlb_folio_with_mpol() can pass a NULL nodemask to
> > alloc_fresh_hugetlb_folio() as a fallback to allocate from all
> > nodes. If order is gigantic, alloc_fresh_hugetlb_folio() propagates
> > the NULL nodemask down to hugetlb_cma_alloc_frozen_folio() which blindl=
y
> > dereferences it in for_each_node_mask(), leading to a null pointer
> > dereference.
> >
> > Similarly, if the CMA allocation fails, the fallback
> > alloc_contig_frozen_pages() is also called with a NULL nodemask,
> > which may cause issues.
> >
> > Fix this by explicitly checking if nodemask is NULL in
> > alloc_fresh_hugetlb_folio() and defaulting to
> > cpuset_current_mems_allowed. This ensures that both the CMA and
> > contiguous allocators receive a valid nodemask safely using a seqcount
> > loop to prevent torn reads.
> >
> > From a userspace perspective, this bug allows an unprivileged user to
> > crash the kernel (trigger a panic) by requesting a gigantic hugepage
> > allocation with MPOL_PREFERRED_MANY on a system where CMA is only
> > configured on a subset of NUMA nodes.
> >
> > This can be reproduced by booting a VM with two NUMA nodes, restricting
> > CMA to Node 1 (e.g., hugetlb_cma=3D1:1G default_hugepagesz=3D1G hugepag=
esz=3D1G
> > hugepages=3D0), and running a program that allocates a 1GB hugepage are=
a
> > without reserving, restricts allocation to Node 0 using mbind() with
> > MPOL_PREFERRED_MANY, and triggers a page fault:
> >
> >  void *ptr =3D mmap(NULL, 1UL << 30, PROT_READ | PROT_WRITE,
> >                   MAP_PRIVATE | MAP_ANONYMOUS | MAP_HUGETLB |
> >                   MAP_HUGE_1GB | MAP_NORESERVE, -1, 0);
> >  unsigned long nodemask =3D 1; /* Node 0 */
> >  mbind(ptr, 1UL << 30, MPOL_PREFERRED_MANY, &nodemask,
> >        sizeof(nodemask) * 8, 0);
> >  memset(ptr, 0, 1UL << 30); /* Trigger fault */
> >
> > This results in a NULL pointer dereference:
> >
> >  BUG: kernel NULL pointer dereference, address: 0000000000000000
> >  #PF: supervisor read access in kernel mode
> >  #PF: error_code(0x0000) - not-present page
> >  Oops: Oops: 0000 [#1] SMP NOPTI
> >  RIP: 0010:hugetlb_cma_alloc_frozen_folio+0x75/0x120
> >  Call Trace:
> >   <TASK>
> >   only_alloc_fresh_hugetlb_folio.isra.0+0x2c/0x160
> >   alloc_surplus_hugetlb_folio+0x6d/0x100
> >   alloc_hugetlb_folio+0x3c5/0x660
> >   hugetlb_no_page+0x3d9/0x650
> >
> > Additionally, this patch adds a missing node_isset(nid, *nodemask) chec=
k
> > in hugetlb_cma_alloc_frozen_folio() to ensure the initial node allocati=
on
> > attempt respects the memory policy.
> >
> > Fixes: eb02f14c4a2b ("mm/hugetlb: allow overcommitting gigantic hugepag=
es")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Sourav Panda <souravpanda@google.com>
> > ---
> > Changes in v3:
> > - Condensed the reproducer and QEMU setup from v1 discussion into a rea=
dable summary per Andrew Morton.
> > - Safely read cpuset_current_mems_allowed using a seqcount loop to prev=
ent torn reads.
> > - v2: https://lore.kernel.org/linux-mm/20260704174930.2885785-1-souravp=
anda@google.com/
> > - v1: https://lore.kernel.org/linux-mm/20260702215713.627941-1-souravpa=
nda@google.com/
> > mm/hugetlb.c     | 12 ++++++++++++
> > mm/hugetlb_cma.c |  2 +-
> > 2 files changed, 13 insertions(+), 1 deletion(-)
> >
> > diff --git a/mm/hugetlb.c b/mm/hugetlb.c
> > index 571212b80835..ee67ea29c003 100644
> > --- a/mm/hugetlb.c
> > +++ b/mm/hugetlb.c
> > @@ -1864,6 +1864,18 @@ static struct folio *alloc_fresh_hugetlb_folio(s=
truct hstate *h,
> > gfp_t gfp_mask, int nid, nodemask_t *nmask)
> > {
> >       struct folio *folio;
> > +     nodemask_t local_node_mask;
> > +
> > +     if (!nmask) {
> > +             unsigned int cpuset_mems_cookie;
> > +
> > +             do {
> > +                     cpuset_mems_cookie =3D read_mems_allowed_begin();
> > +                     local_node_mask =3D cpuset_current_mems_allowed;
> > +             } while (read_mems_allowed_retry(cpuset_mems_cookie));
> > +
> > +             nmask =3D &local_node_mask;
> > +     }
>
> As Andrew pointed it out, it is not helpful to prevent any false-positive
> allocation failures. We need something like the following:
>
>   seq =3D read_mems_allowed_begin();
>
>   alloc_nodemask =3D nodemask;
>   if (cpusets_enabled() && !alloc_nodemask)
>         alloc_nodemask =3D &cpuset_current_mems_allowed;
>
>   for_each_node_mask(node, alloc_nodemask) {
>         if (cpusets_enabled() && nodemask &&
>             !cpuset_zone_allowed(zone, gfp_mask))
>                 continue;
>
>         ...
>   }
>
>   if (!page && read_mems_allowed_retry(seq))
>         goto retry;
>
>
> After further consideration, I believe we only need to fix
> alloc_gigantic_frozen_folio(), as alloc_buddy_frozen_folio() already
> handles the NULL nodemask properly via prepare_alloc_pages().
>
> To address the issue in alloc_gigantic_frozen_folio(), we have two
> potential options:
>
> - Option 1: Fix it directly within alloc_gigantic_frozen_folio().
>   This would centrally cover both of its underlying allocation paths:
>   hugetlb_cma_alloc_frozen_folio() and alloc_contig_frozen_pages().
>
> - Option 2: Fix hugetlb_cma_alloc_frozen_folio() and alloc_contig_frozen_=
pages()
>   separately. The rationale here is that since the buddy allocator
>   already handles this case internally, and alloc_contig_frozen_pages()
>   is also a low-level allocator, it would be better to keep their behavio=
rs
>   consistent.
>
> Both approaches are viable from my perspective. I'm CCing more MM maintai=
ners
> and reviewers to gather your insights and decide on the best path forward=
.
>
> Muchun,
> Thanks.

Gotcha! Thanks Andrew and Muchun!

I shall wait for the decision and then send the subsequent version :)

With regards,
Sourav Panda

>
> >
> >       folio =3D only_alloc_fresh_hugetlb_folio(h, gfp_mask, nid, nmask,=
 NULL);
> >       if (folio)
> > diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
> > index 39344d6c78d8..79dbd0baafa3 100644
> > --- a/mm/hugetlb_cma.c
> > +++ b/mm/hugetlb_cma.c
> > @@ -34,7 +34,7 @@ struct folio *hugetlb_cma_alloc_frozen_folio(int orde=
r, gfp_t gfp_mask,
> >       if (!hugetlb_cma_size)
> >               return NULL;
> >
> > -     if (hugetlb_cma[nid])
> > +     if (hugetlb_cma[nid] && node_isset(nid, *nodemask))
> >               page =3D cma_alloc_frozen_compound(hugetlb_cma[nid], orde=
r);
> >
> >       if (!page && !(gfp_mask & __GFP_THISNODE)) {
> > --
> > 2.55.0.rc0.799.gd6f94ed593-goog
> >
>

