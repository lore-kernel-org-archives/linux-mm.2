Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA0BCCA0FED
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:12:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 216AF8E0016; Tue,  9 Sep 2025 16:12:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C79A8E0001; Tue,  9 Sep 2025 16:12:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B6678E0016; Tue,  9 Sep 2025 16:12:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF1478E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:12:00 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BAC0313B4E2
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:12:00 +0000 (UTC)
X-FDA: 83870808000.13.BE863FD
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf17.hostedemail.com (Postfix) with ESMTP id D9B454000B
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:11:58 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VEGI1MHe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of jyescas@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448718; a=rsa-sha256;
	cv=none;
	b=Bg8A2kHM6CY2AhkVm/9bCDb5ngm7qyJ63hj3wfOAP95WXjSAMj3SGDtW5x6AvxNU3CSZZb
	pMrCpCU4gxT4cYb/EqpyhcFKxLq4+uoe+37ywTbTYPaWLhiS882i9CLcbc+1YleH7/r1Qv
	Q5W1ixtDh88ovhwzejNWXdfw4s2XAUo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VEGI1MHe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf17.hostedemail.com: domain of jyescas@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RMqutGN+yLrgM+NB4+zfhtscJz9Ec3G94PrW8rPDTWY=;
	b=yeV6i7DQIFbkNlUaNQ0uNoEvoAutXxnRUpGj7l6fIsFie9OByM/WVZL1DzGK4cyJD37XaZ
	RdcGMvOhPDv9a5WUpwcXF7TjOMKdl+yikYJAKSTbSpPngkXLXvR1x7dCsnaes7dCY/iQ3w
	7nIbAGN4CdK2HaeeHZaQ9yN1lTeJXbA=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24cca557085so9645ad.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 13:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757448718; x=1758053518; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RMqutGN+yLrgM+NB4+zfhtscJz9Ec3G94PrW8rPDTWY=;
        b=VEGI1MHeTblqvo2+rPecsU0xA0p3E+UJ+//cZ/wra2ZDD3W87gGly/5GCYc3RO6u35
         udsiOrv0WGASvcXgCTy3DbJXMDqDCqvIsAZ17NJ7EEunUwbIvvxbPLfE/AxS8nXzIkAK
         mr+4FEOv9Ii3TewHTJ4JsNAypzoCFiGqusKwRctjRCY445xBtuBKsQSXpF09l2v88Hvl
         k0Blv5yf0HkllAunO8xkXJG7t+xgre4lGU36kTVk6bcuioxxnjO8gQ9+cTZuLZ4xVfKO
         YBXvB0MN6K+VegsAxkD+KedabhP7DPINU5eszS2nJVsNYDfDk3rhe0oDaRl3wmy8k62y
         zPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757448718; x=1758053518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=RMqutGN+yLrgM+NB4+zfhtscJz9Ec3G94PrW8rPDTWY=;
        b=bUcIfWCwKFseuCtnTLimXWUEs37eqo3kx1bx04MHYBiDvPH8/q2in6BOsz/vZ86hMe
         /Fk5ds8neOEYLzJaXOHQ2Dxp/4BwPDmnsdnFbT2P3PbkIaOKgEMsxT6YluA+GHTFMBnd
         YEni/DpopeTfmO0G1ba7in21OU0xit1rFZtclbsRLvN1icHUx0Y4aaXgepXwNHY7opTI
         lyaAru902EIB+KINIwC1vr3X6JJPK8UjfyWMYay9NKh3Xq5BVGmWQCSGc6Rpc51cSJWv
         /Ud14Ga4r7c3mSFzNLkEqTtVEfbScujoZKmodJS3mAHQgit6Ete1daT9AY1umthsrnsl
         o6GA==
X-Forwarded-Encrypted: i=1; AJvYcCXZSPogGtzcGY8b92+XRtUWD4lc59jJNk/clfKz7S+y5Uqkgi92H/htfG5XVSNRf73yEz9sMviygA==@kvack.org
X-Gm-Message-State: AOJu0Yxv5hgd9NMFhnhD+0xASki+wCAzBSfcDVuVOnU6ZjozS3B7VaQE
	LZE1XyIFqi1jSQ0nvrjzZoM/bk5hXRo+HYsH/+q5zrNx7pEADLrzxcaiA7+NSCrthVohpf2fsdU
	wb1s4HjEX1WPhUt/4NMOuc7CXfij7YEg4JcKw4yql
X-Gm-Gg: ASbGncsJXCvhFhHVNEsGsS0gsYEkQ3lSWwpu0n5KORDBQUoLFSrYIgx6EYHTuzXXEZx
	Xhs4nGESdJvKL2MlGpGtAJ43sRL1szovwbizdLmlX1hfHw7v+G7R+Ls3dDPZTTs8T5/fjXbfNaX
	EJ0SWyfLklLCggwpZj2DlCjbl4m7VJ3JocMmadGCImYp1eNm7J15g6DMWFsatbdjyWFlImo8709
	jlHC7FxWw7gG/itR2OnJ1fvmFKgvf4ZL5SSRQbDulg=
X-Google-Smtp-Source: AGHT+IFX3Yblf4ZODycC555w3xs5DUtNy1StojhqIRO/qAVf35qb6Qt4MYDTGQXUSZ6pqO5kIY7S+3D62K27CD/FW6s=
X-Received: by 2002:a17:902:e5d0:b0:24c:f4b1:baaf with SMTP id
 d9443c01a7336-25a7d989bb5mr37875ad.1.1757448717349; Tue, 09 Sep 2025 13:11:57
 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com> <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
 <486c5773-c7fa-4e19-b429-90823ed2f7d5@redhat.com> <CAJDx_ri==3SxFcuKXHpNjrtxbp0hLyhM+zXeJ-LQX38rfbUChw@mail.gmail.com>
 <6dee6cd9-c67f-480f-b728-21c3a7b72004@redhat.com>
In-Reply-To: <6dee6cd9-c67f-480f-b728-21c3a7b72004@redhat.com>
From: Juan Yescas <jyescas@google.com>
Date: Tue, 9 Sep 2025 13:11:44 -0700
X-Gm-Features: Ac12FXy9H8LSTetHGcFYnz6pqWAly0dnCfLL-mWF9ljJktwSF-hLAn2umBneJkE
Message-ID: <CAJDx_rh_bTC5EY=qMSda5GuNLzZMZg8nM8_hfUea3Y8oGJMfNw@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: David Hildenbrand <david@redhat.com>
Cc: akash.tyagi@mediatek.com, Andrew Morton <akpm@linux-foundation.org>, 
	angelogioacchino.delregno@collabora.com, hannes@cmpxchg.org, 
	Brendan Jackman <jackmanb@google.com>, linux-arm-kernel@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org, 
	Linux Memory Management List <linux-mm@kvack.org>, matthias.bgg@gmail.com, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>, wsd_upstream@mediatek.com, 
	Zi Yan <ziy@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>, 
	"T.J. Mercier" <tjmercier@google.com>, Isaac Manjarres <isaacmanjarres@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: D9B454000B
X-Stat-Signature: fc7ghzm5b7d8ga4ge9w87wq9hbhgefd1
X-Rspam-User: 
X-HE-Tag: 1757448718-320543
X-HE-Meta: U2FsdGVkX1879Uhvl9JkPDMl2rIOuE75rzwkm+CfZJIgN9L1fwTQ/tUfLSkdozKis+jkSoXfhE550dAQy974uS+/YSFd5Q2y0WNNfb6IhawpPblbauZXdm9G1UqThMVK5IZfx5VHapQd78hOtRofNFJoZL/Mt1Yns/EtsbUmkHMebLcAaURA2ULat+8gsjsMvWm6KOcql86io0p7FJWgoG6kvS0WUsSNdmRjXg3S6RmHmmpWDIbDoZZc8lTRuV5c0/6DBGiE4R/bAI+6nA4h44VIh1w8xvKZBhiTxZ2GYVvQ9TVdE9uAdS9EjjIU61vkJe+jSGIpetUjyR2W2SnbjrRptLPuZd62Qmfh7WV6DnqHVfdnqYjWGBb90VTTj91Xmrkk2MsPJt6XRuMtnM3kdSXXBz4gb3hWAnVWzr4OFmVdRx/41PikeZfbrKdb4Qf2fniuc7HEFPteJT6TZYfiruAOWiBLD5l/qFZJ8VoydSqfCygsZtnf1anPg0xceL4KZzqejlE/R9huMCOgiIewf2UUgZpIqFWmQNhyL/SGQmWnV8113xfa+6GaAQPxiIM9oBGcdnvLanrNaZt1ZWUS073idSuA1r71stBL18cYt6lYGnTD5+KVGVSA89GdFyt5xedudLAMlSEB+ClFYec+nySCXnhd4LW/rUhUjorCsWto+g+0lzjhHJoSL4W0VQ+tNQsirUt6Y2/k88QD6Yl7pDAgS5JLhldXuXvs1odPMmQAN2xeVeqBeGynHLX6PsnY7D7N6tSEFoOnXzbBYsp/gq+RRdkJXrpyWIfVgNNuLP5jnr0FdATIKlM1lp+Zj4Q4ri2ZEwlObP+m3akY5+qRlWWquJ4XDVUozodEOwFghAus3TSeE+oTgYehqrnwYOqwc4dutrUd27P+LhOPzcbLsiQqUOD/80Y3KuEudlCOWFNE5krkxtI9mJ+5HawGVvzSjsL3H93xUSPr4PUyv+i
 DNlJColc
 9dRsUzb/2lRrBGfgclqk1dtwa10ijaU+nhWCZRPNhO1coy+bF3w0EV18cdKwL7cROYWIOVmqJH6UUXcEk+8vwfAuki8Z5H3P1tMN+R1u79LttAgQaGQbLvkbVYOo2Yy9Jo0Bysy4CZC412PYJi+TdQTVvgER1mvzN3hhF3wZxya4GkyW08SFSOBGsr4SBECA/UrnEzs1bxpL/9ldqnJNbUeaC8FIe4UTIoSB1Vg24CQNk6oBx3vvUjqgA58idviT7lYXg4LZBRlKumuYWEDYeTg3K8kAybnQcBxxNszXqkNce4WwZKArs05got/ggzqJ8tDX7eNDYh6S/GQ9OGmgI+dfKRdOMxA8DGI6/DiOqd9LJSDqMEomu1xZbXN2IEb775gdGN85NyKGezRnAn7KUe+X8OsRkgdTSbuemd8yJ9Euhxh29BDsdFZO3ENWFZVqv0htQA2OigFxAKJ3rmAdu+MHkFmRngAfZCvx2DBwNLe5SFvT9NS83OkFzAw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 2:08=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 05.08.25 18:57, Juan Yescas wrote:
> > On Tue, Aug 5, 2025 at 2:58=E2=80=AFAM David Hildenbrand <david@redhat.=
com> wrote:
> >>
> >> On 05.08.25 03:22, Juan Yescas wrote:
> >>> On Mon, Aug 4, 2025 at 11:50=E2=80=AFAM David Hildenbrand <david@redh=
at.com> wrote:
> >>>>
> >>>> On 04.08.25 20:20, Juan Yescas wrote:
> >>>>> Hi David/Zi,
> >>>>>
> >>>>> Is there any reason why the MIGRATE_CMA pages are not in the PCP li=
sts?
> >>>>>
> >>>>> There are many devices that need fast allocation of MIGRATE_CMA pag=
es,
> >>>>> and they have to get them from the buddy allocator, which is a bit
> >>>>> slower in comparison to the PCP lists.
> >>>>>
> >>>>> We also have cases where the MIGRATE_CMA memory requirements are bi=
g.
> >>>>> For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to=
 500MiBs.
> >>>>> These cases would benefit if we have THPs for CMAs.
> >>>>>
> >>>>> Could we add the support for MIGRATE_CMA pages on the PCP and THP l=
ists?
> >>>>
> >>>> Remember how CMA memory is used:
> >>>>
> >>>> The owner allocates it through cma_alloc() and friends, where the CM=
A
> >>>> allocator will try allocating *specific physical memory regions* usi=
ng
> >>>> alloc_contig_range(). It doesn't just go ahead and pick a random CMA
> >>>> page from the buddy (or PCP) lists. Doesn't work (just imagine havin=
g
> >>>> different CMA areas etc).
> >>>>
> >>>> Anybody else is free to use CMA pages for MOVABLE allocations. So we
> >>>> treat them as being MOVABLE on the PCP.
> >>>>
> >>>> Having a separate CMA PCP list doesn't solve or speedup anything, re=
ally.
> >>>>
> >>>
> >>> Thanks David for the quick overview.
> >>>
> >>>> I still have no clue what this patch here tried to solve: it doesn't
> >>>> make any sense.
> >>>>
> >>>
> >>> The story started with this out of tree patch that is part of Android=
.
> >>>
> >>> https://lore.kernel.org/lkml/cover.1604282969.git.cgoldswo@codeaurora=
.org/T/#u
> >>>
> >>> This patch introduced the __GFP_CMA flag that allocates pages from
> >>> MIGRATE_MOVABLE
> >>> or MIGRATE_CMA. What it happens then, it is that the MIGRATE_MOVABLE
> >>> pages in the
> >>> PCP lists were consumed pretty fast. To solve this issue, the PCP
> >>> MIGRATE_CMA list was added.
> >>> This list is initialized by rmqueue_bulk() when it is empty. That's
> >>> how we end up with the PCP MIGRATE_CMA list
> >>> in Android. In addition to this, the THP list for MIGRATE_MOVABLE was
> >>> allowed to contain
> >>> MIGRATE_CMA pages. This is causing THP MIGRATE_CMA pages to be used
> >>> for THP MIGRATE_MOVABLE
> >>> making later allocations from THP MIGRATE_CMA to fail.
> >>
> >> Okay, so this patch here really is not suitable for the upstream kerne=
l
> >> as is. It's purely targeted at the OOT Android patch.
> >>
> > Right, it is a temporary solution for the pinned MIGRATE_CMA pages.
> >
> >>>
> >>> These workarounds are mainly because we need to solve this issue upst=
ream:
> >>>
> >>> - When devices reserve big blocks of MIGRATE_CMA pages, the
> >>> underutilized MIGRATE_CMA
> >>> can fall back to MIGRATE_MOVABLE and these pages can be pinned, so if
> >>> we require MIGRATE_CMA
> >>> pages, the allocations might fail.
> >>>
> >>> I remember that you presented the problem in LPC. Were you able to
> >>> make some progress on that?
> >>
> >> There is the problem of CMA pages getting allocated by someone for a
> >> MOVABLE allocation, to then short-term pin it for DMA. Long-term
> >> pinnings are disallowed (we just recently fixed a bug where we
> >> accidentally allowed it).
> >>
> > Nice, it is great the issue got caught and fixed upstream :)
> >
> >> One concern is that a steady stream of short-term pinnings can turn su=
ch
> >> pages unmovable. We discussed ideas on how to handle that, but there i=
s
> >> no solution upstream yet.
> >
> > Are there any plans to continue the discussion? Is it in the priority
> > list?
>
> Ohh, it's somewheeeeeere on the todo list :)
>
> Do you (or one of your colleagues) have capacity to work on that? One
> idea was to flag folios as "pending on migration" and disallow any
> further short-term pins until migration is done. IIRC, there were other
> ideas (e.g., isolated pageblock).
>
> > Maybe
> > a topic we can discuss in LPC Japan?
>
> Sounds good, feel free to propose this as a topic. I wills end out the
> announcement of the MM MC probably next week.
>

The topic has been proposed in the Kernel Memory Management track.

https://lpc.events/event/19/abstracts/2397/

Thanks
Juan

>
> --
> Cheers,
>
> David / dhildenb
>

