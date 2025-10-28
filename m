Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5235FCCF9F2
	for <linux-mm@archiver.kernel.org>; Tue, 28 Oct 2025 04:17:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 974B68010F; Tue, 28 Oct 2025 00:17:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 925B1800E4; Tue, 28 Oct 2025 00:17:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 862F58010F; Tue, 28 Oct 2025 00:17:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 74F73800E4
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 00:17:46 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 157EA58B34
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:17:46 +0000 (UTC)
X-FDA: 84046214532.22.9B9AEB0
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf07.hostedemail.com (Postfix) with ESMTP id 269B240004
	for <linux-mm@kvack.org>; Tue, 28 Oct 2025 04:17:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IhS9Vl3n;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761625064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EafH425e5ZdVyi0FV+yegWkfn9dVJGmMSMrvuISBCM4=;
	b=CI346XdK2yMJ3vGM+9m2N75v6ScJmaOFg8O/1A+FOufrJ51RuQMuGwnXk1+KRm1i4Gfnq5
	qVZzQzL+MRFihlRsqug2YeeOFjlconJohSHSWKNn9Jrx9M/uHx1XfijP6m0nTy8MH/jAim
	eS/bUEAfHntCQVXyA+Sltx4Rtup7wpI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761625064; a=rsa-sha256;
	cv=none;
	b=IhWFhxkJbIu41UsjmPCa8v3ZRgPWu+8u67G1gsy4XjFNbgFbae6S8w52srT0OdUlDatgxz
	zC4uZ6IsKmjiOhQnqG7rT1Sj9mYCwtoYTsGoHa1djtwPStX4YJ++nW7jzexy1g/xf7XPm3
	pef1Xre7Gvix7rclDhv6jUE/xB1ADko=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IhS9Vl3n;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf07.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-47105bbb8d9so26995e9.1
        for <linux-mm@kvack.org>; Mon, 27 Oct 2025 21:17:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761625063; x=1762229863; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EafH425e5ZdVyi0FV+yegWkfn9dVJGmMSMrvuISBCM4=;
        b=IhS9Vl3nQHw6fMQITiIoLHY6P1RJX6+f/st4j0Jg3e176u2bZbYoCQesEUZAQ6Aey1
         ZD85pSZsXTHtnwZ2DuAxh0I1MY9Tc40mLq6vHrgnl3wDxXws8usnRikk54FmMyzKFUTW
         +2B9cwo6Ecn6LhBSEMPwCk0YfVVZ4kqm90QH1wr93pctAq5BCdnRwQQkP7srKAvx7JQQ
         tvtHkAZfWh0mBYSTC+mJrcT8lUQ31qPYOOP6+kY3AEmGi/kzhkm4b5M6f82DUmUscCgA
         vMZ82jwM6PciQP2nvcU6OcQjUUzCNUT/cBo4oZGPl2UqmqageTZ8fFlP7hz1YACpjYlC
         LdKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761625063; x=1762229863;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EafH425e5ZdVyi0FV+yegWkfn9dVJGmMSMrvuISBCM4=;
        b=IgwURMZAnDxhWd0GX69vZgYKPQYMOq2kVkpZNTV0Q9F5T2adMuBLGWPzTnZR+36B8r
         hKjUty0EXaDmzHu/JhRUZqQPztxZtOaRkMcZrqQ4q9IKufUqlfdxbKR0S9koROcgoSw3
         I0+Ir3ie6Rfw933eNuXltY7HkSPv6/kNzeHs0aEmGxQVpSkM1O8QkrKPaa39wglHfcQu
         dJ9YpzBEylheFftK4h0LrMr/mvP0fBksLU9+xyLE8Onlpkvkob/MgKhv+YIo5LzYczoU
         GG3i0U4Fl86kCeA0bgCh0pezPmnhEQkpZET80H1p9ZPSi5t0UYQOE9VI4Q1k7bQG2P5p
         NBEg==
X-Forwarded-Encrypted: i=1; AJvYcCVZvcZtkQXqsvRhNLEe23LKIUWFkKQE1dKCjG8aiLavv3nz0tcKcNU8zXeUIbFcVA4ipNDjA0zPFQ==@kvack.org
X-Gm-Message-State: AOJu0YzMTmHGZ4Am/7/WWT3DaXVl5edC3Cdh11W/7ltWUncoOjb217H5
	DOBrS84m66VWkkbM1+dJDyxtVnf2zzt6R3XHZGdETXkt41g1yt5ybnowVKNJ5ikMv8PvIOVYseh
	zTP5udTYHqYKwg5uPIgBwzWenriFDuWEMosT1sKZ8
X-Gm-Gg: ASbGncuMZsMLdsjAOlNmUu7zGDRo1PnkxtY4BlZt9BncU+ywAIwDorakbS8WDiSb/Ym
	T/ptwyZwHCsJnBMWJ6tyETZ2LjJSJrCcCIVOb/F9JxHAJ+6hLPGalMiWThHmBNJPJhLtuO3pONM
	Tv82SyWcDSCZFBA0iBOL+mfkJw2Hu/a8evj0ePsVsfviUp+IhfGfs1gWtrDxKJmuPVkz4o8MRMr
	3SkbMA1ocElW7bq2WIyyxEWvqh9ibvX9KFW5yDIuyHZ+kZe7E4b+mPCooONSP2KFD3IrmUKQLz3
	jXBsfVS8X5bRO0rLfA==
X-Google-Smtp-Source: AGHT+IEhtd6FMoBD9oW9VTHPjTNuAKD4LI9Bm+L8vr/ZIvRemEu0gME+w1twwea2P3HAp+5Fi55N6fK3//NhVxDsmnM=
X-Received: by 2002:a05:600c:1791:b0:45b:74f7:9d30 with SMTP id
 5b1f17b1804b1-477191e0eabmr589665e9.1.1761625062640; Mon, 27 Oct 2025
 21:17:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250118231549.1652825-1-jiaqiyan@google.com> <20250919155832.1084091-1-william.roche@oracle.com>
 <CACw3F521fi5HWhCKi_KrkNLXkw668HO4h8+DjkP2+vBuK-=org@mail.gmail.com> <aPjXdP63T1yYtvkq@hyeyoo>
In-Reply-To: <aPjXdP63T1yYtvkq@hyeyoo>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Mon, 27 Oct 2025 21:17:31 -0700
X-Gm-Features: AWmQ_bm9R7TnoGST5GcqG6bwJmlJM5TYefCTLaciqwqQYwwTV1Gje_wcNqRiI_k
Message-ID: <CACw3F50As2jPzy1rRjzpm3uKOALjX_9WmKxMPGnQcok96OfQkA@mail.gmail.com>
Subject: Re: [RFC PATCH v1 0/3] Userspace MFR Policy via memfd
To: Harry Yoo <harry.yoo@oracle.com>, =?UTF-8?Q?=E2=80=9CWilliam_Roche?= <william.roche@oracle.com>
Cc: Ackerley Tng <ackerleytng@google.com>, jgg@nvidia.com, akpm@linux-foundation.org, 
	ankita@nvidia.com, dave.hansen@linux.intel.com, david@redhat.com, 
	duenwen@google.com, jane.chu@oracle.com, jthoughton@google.com, 
	linmiaohe@huawei.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	nao.horiguchi@gmail.com, osalvador@suse.de, peterx@redhat.com, 
	rientjes@google.com, sidhartha.kumar@oracle.com, tony.luck@intel.com, 
	wangkefeng.wang@huawei.com, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Stat-Signature: xpzy64yk695tkkxmeamny4przw7t58ju
X-Rspam-User: 
X-Rspamd-Queue-Id: 269B240004
X-HE-Tag: 1761625063-227707
X-HE-Meta: U2FsdGVkX19tbF8eH8dxkHDE4KL33C/rSyoG34DMJJ0IDmgY0ijLz+2xR/uKNEp7yfsHz+OrDTR2Wompc4QkEeITM22Kr4BsU+jh6erCmZko9w2i0/lkhUx0vS7KSCZt1cSwEfouFS+fCsqqnY8S7Do/R8ulJU0CSxpBLD5q7sRqfojRo7V7tp1YZZI/X4Rp68+mYpcevUYSfKz+8ZEJNeBa0dPU2hx0wOkBIDqqqHX2fD3IDKNSexTaXbvX3EE5vrgkZWBcWDrf3EPOWuUMqnFVPfhHom72eapI1d7b6/M4u7ZeWWMJVfwi3P3nMDkfNcPU4Qe26UTz5YpwF7yDNSWuF8vvzo+nbnFmwE020dbBPjT7nY1DzyHpKFY4p6j5xBphcXMt8JK9iY54w2tjGxOZQsIrvRm+b8WqyDu/nd28dmg0TBrzCUKrpo4QmS4aU3YN+YP/0WdLOKl48U8RBOl3/HQzbGwZiTJDvZDMm78pUfWtU/lkWHELWXyUa68HmMbHdFuhoyCLE3dmN4GQIzK+OqwclyOEeo3S5cklY6v7QVXaV93q+0TaBNvA0qgsBNs5YGyO6nIaTyLQV4tVRb5CEz5PuF+foI0eFGnEQs95pe3YhpgjdWtqdDl1Y5H0mgt9zElc50bg8Z0clLF70hiB2ihwO6ZP5dNH7p4fleuoWod2o2vktOiwxDgqY3lvXeaLQ5GTmLNgg1SCrUJNfCCPm3ne1Orhz983iVQ3PF3ouLSISC21xhNc6UAef+gtILZ/FiIbKm0kVFmiUm5Uhu/ZsGIa9rhb/t6lEeg4yuKNCTiewuFJtUze7tle+BYoxGOg6nS/ye40cNf71/SFsCURGZ1luvAYPhz2IkQ/7bFAK2uv0iMhBX0IrCoOh/fcPXD57rB6OFOYcrbAUxxgYWPMaS7hRaTuGaKQXGnCY5HIEKAV7Bh0vb4CszvlGJ6oSQWUGklLFmJrVsYuKgp
 S2OpTNbn
 DkpMijA9ybiXPXmOns/WkGWkP9xCrRwYhabTLTrpsIgH+rgW5R7bnCI7Ocp4HuWss2b5zAEQWS8uYmYAG3AMmN9SfOswcPfe9gypsdBq+B4aHvQh6wfFtg1BbAkW/iT+D2Lbn47ELBqegiQ6EnW55hAdFBAndpBUkczBHxi6kMPGWGYPYcScXai1PDFYBL7qFtW/03lnPj3C/Kfv0RnhGKZnOQRdAi+YBuFdo7QBQoq7EDmC5v3bB3MRFsqFz6EU/AB6yhYoFKPmLegRjo8VjAAM9z/H6JypRhfBTmQ+vgbKsz4MYPzCT1kiS/guquMtYMotfEFdwDj25h3c=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 22, 2025 at 6:09=E2=80=AFAM Harry Yoo <harry.yoo@oracle.com> wr=
ote:
>
> On Mon, Oct 13, 2025 at 03:14:32PM -0700, Jiaqi Yan wrote:
> > On Fri, Sep 19, 2025 at 8:58=E2=80=AFAM =E2=80=9CWilliam Roche <william=
.roche@oracle.com> wrote:
> > >
> > > From: William Roche <william.roche@oracle.com>
> > >
> > > Hello,
> > >
> > > The possibility to keep a VM using large hugetlbfs pages running afte=
r a memory
> > > error is very important, and the possibility described here could be =
a good
> > > candidate to address this issue.
> >
> > Thanks for expressing interest, William, and sorry for getting back to
> > you so late.
> >
> > >
> > > So I would like to provide my feedback after testing this code with t=
he
> > > introduction of persistent errors in the address space: My tests used=
 a VM
> > > running a kernel able to provide MFD_MF_KEEP_UE_MAPPED memfd segments=
 to the
> > > test program provided with this project. But instead of injecting the=
 errors
> > > with madvise calls from this program, I get the guest physical addres=
s of a
> > > location and inject the error from the hypervisor into the VM, so tha=
t any
> > > subsequent access to the location is prevented directly from the hype=
rvisor
> > > level.
> >
> > This is exactly what VMM should do: when it owns or manages the VM
> > memory with MFD_MF_KEEP_UE_MAPPED, it is then VMM's responsibility to
> > isolate guest/VCPUs from poisoned memory pages, e.g. by intercepting
> > such memory accesses.
> >
> > >
> > > Using this framework, I realized that the code provided here has a pr=
oblem:
> > > When the error impacts a large folio, the release of this folio doesn=
't isolate
> > > the sub-page(s) actually impacted by the poison. __rmqueue_pcplist() =
can return
> > > a known poisoned page to get_page_from_freelist().
> >
> > Just curious, how exactly you can repro this leaking of a known poison
> > page? It may help me debug my patch.
> >
> > >
> > > This revealed some mm limitations, as I would have expected that the
> > > check_new_pages() mechanism used by the __rmqueue functions would fil=
ter these
> > > pages out, but I noticed that this has been disabled by default in 20=
23 with:
> > > [PATCH] mm, page_alloc: reduce page alloc/free sanity checks
> > > https://lore.kernel.org/all/20230216095131.17336-1-vbabka@suse.cz
> >
> > Thanks for the reference. I did turned on CONFIG_DEBUG_VM=3Dy during de=
v
> > and testing but didn't notice any WARNING on "bad page"; It is very
> > likely I was just lucky.
> >
> > >
> > >
> > > This problem seems to be avoided if we call take_page_off_buddy(page)=
 in the
> > > filemap_offline_hwpoison_folio_hugetlb() function without testing if
> > > PageBuddy(page) is true first.
> >
> > Oh, I think you are right, filemap_offline_hwpoison_folio_hugetlb
> > shouldn't call take_page_off_buddy(page) depend on PageBuddy(page) or
> > not. take_page_off_buddy will check PageBuddy or not, on the page_head
> > of different page orders. So maybe somehow a known poisoned page is
> > not taken off from buddy allocator due to this?
>
> Maybe it's the case where the poisoned page is merged to a larger page,
> and the PGTY_buddy flag is set on its buddy of the poisoned page, so
> PageBuddy() returns false?:
>
>   [ free page A ][ free page B (poisoned) ]
>
> When these two are merged, then we set PGTY_buddy on page A but not on B.

Thanks Harry!

It is indeed this case. I validate by adding some debug prints in
take_page_off_buddy:

[ 193.029423] Memory failure: 0x2800200: [yjq] PageBuddy=3D0 after drain_al=
l_pages
[ 193.029426] 0x2800200: [yjq] order=3D0, page_order=3D0, PageBuddy(page_he=
ad)=3D0
[ 193.029428] 0x2800200: [yjq] order=3D1, page_order=3D0, PageBuddy(page_he=
ad)=3D0
[ 193.029429] 0x2800200: [yjq] order=3D2, page_order=3D0, PageBuddy(page_he=
ad)=3D0
[ 193.029430] 0x2800200: [yjq] order=3D3, page_order=3D0, PageBuddy(page_he=
ad)=3D0
[ 193.029431] 0x2800200: [yjq] order=3D4, page_order=3D0, PageBuddy(page_he=
ad)=3D0
[ 193.029432] 0x2800200: [yjq] order=3D5, page_order=3D0, PageBuddy(page_he=
ad)=3D0
[ 193.029434] 0x2800200: [yjq] order=3D6, page_order=3D0, PageBuddy(page_he=
ad)=3D0
[ 193.029435] 0x2800200: [yjq] order=3D7, page_order=3D0, PageBuddy(page_he=
ad)=3D0
[ 193.029436] 0x2800200: [yjq] order=3D8, page_order=3D0, PageBuddy(page_he=
ad)=3D0
[ 193.029437] 0x2800200: [yjq] order=3D9, page_order=3D0, PageBuddy(page_he=
ad)=3D0
[ 193.029438] 0x2800200: [yjq] order=3D10, page_order=3D10, PageBuddy(page_=
head)=3D1

In this case, page for 0x2800200 is hwpoisoned, and its buddy page is
0x2800000 with order 10.

>
> But even after fixing that we need to fix the race condition.

What exactly is the race condition you are referring to?

>
> > Let me try to fix it in v2, by the end of the week. If you could test
> > with your way of repro as well, that will be very helpful!
> >
> > > But according to me it leaves a (small) race condition where a new pa=
ge
> > > allocation could get a poisoned sub-page between the dissolve phase a=
nd the
> > > attempt to remove it from the buddy allocator.
> > >
> > > I do have the impression that a correct behavior (isolating an impact=
ed
> > > sub-page and remapping the valid memory content) using large pages is
> > > currently only achieved with Transparent Huge Pages.
> > > If performance requires using Hugetlb pages, than maybe we could acce=
pt to
> > > loose a huge page after a memory impacted MFD_MF_KEEP_UE_MAPPED memfd=
 segment
> > > is released ? If it can easily avoid some other corruption.
> > >
> > > I'm very interested in finding an appropriate way to deal with memory=
 errors on
> > > hugetlbfs pages, and willing to help to build a valid solution. This =
project
> > > showed a real possibility to do so, even in cases where pinned memory=
 is used -
> > > with VFIO for example.
> > >
> > > I would really be interested in knowing your feedback about this proj=
ect, and
> > > if another solution is considered more adapted to deal with errors on=
 hugetlbfs
> > > pages, please let us know.
> >
> > There is also another possible path if VMM can change to back VM
> > memory with *1G guest_memfd*, which wraps 1G hugetlbfs. In Ackerley's
> > work [1], guest_memfd can split the 1G page for conversions. If we
> > re-use the splitting for memory failure recovery, we can probably
> > achieve something generally similar to THP's memory failure recovery:
> > split 1G to 2M and 4k chunks, then unmap only 4k of poisoned page. We
> > still lose the 1G TLB size so VM may be subject to some performance
> > sacrifice.
> > [1] https://lore.kernel.org/linux-mm/2ae41e0d80339da2b57011622ac2288fed=
65cd01.1747264138.git.ackerleytng@google.com
>
> I want to take a closer look at the actual patches but either way sounds
> good to me.
>
> By the way, please Cc me in future revisions :)

For sure!

>
> Thanks!
>
> --
> Cheers,
> Harry / Hyeonggon

