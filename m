Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84A4EC87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:57:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 147D46B00AE; Tue,  5 Aug 2025 12:57:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F93B6B00B5; Tue,  5 Aug 2025 12:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 00EFA6B00B6; Tue,  5 Aug 2025 12:57:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E87206B00AE
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:57:55 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A2B5C11481A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:57:55 +0000 (UTC)
X-FDA: 83743310910.09.22D2664
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id E911B4000A
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:57:53 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FqoJAqU7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of jyescas@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754413074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GEnVU5KAskdWYUBQ/kSGgyrV9wf/VcctSOFlUiJlPrU=;
	b=LG5JnQhFmZrtlX4u+fxrwSssnKoVBSDxNw2Pc6eE5kTTqzkxuV4MPwCtWQKm4eQfoIq69Q
	4VGc8nnZhWIE5dJECaHjN4KJpDwM2G2lmuWvqoQZRsjkmUww4cF7BWH5/YXwmpkhXr3djs
	6zrydiFVcexAPzVP92leJxsKnQA6EYw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754413074; a=rsa-sha256;
	cv=none;
	b=8IO7MvoolFejXcpjKTqTGdsjXYmn9r56wyW4zJOgOKGfxTuJ4WLQ3fjTU8IOc1uzI6sHud
	J/uyGRiElEGnVRPyczWRmJt9fjUUA/vmONXpVU2z+JrgHkHAy5wiDECoGnJzb4HKsLXnQp
	idl0xymCJcKmOGrIB6Fo2CLwJ0mEL6s=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=FqoJAqU7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of jyescas@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=jyescas@google.com
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-240718d5920so6815ad.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 09:57:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754413073; x=1755017873; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GEnVU5KAskdWYUBQ/kSGgyrV9wf/VcctSOFlUiJlPrU=;
        b=FqoJAqU74XIb6my4tObbVAvNn0vVaXAMOGt8GzARKXxGELsG3KXPpPfDI1arG6v6cR
         NeS/9tHKrYpxzhUfRH/2PwwlQglHuhWtnM20n4/DKb5wjzZvc+EyKYcD8cYswm3LAnn0
         12sB7F4bY99HmCSM4CG4faQoftsSh2hXpTRJ3zcy0dMQOYbHWetn/FMoHMKYDE5ufB5b
         f/GpvyG6SMnq306CxQ6kJa7y05z+K55nkhtiHXismBNeAWadYCU/jTyYt2GSVGE7Ecox
         4mVvE+XwvzB41ZOEwRArb+QHfWmVzKdcmNveuZHCOWJAYNi1YKdntLCoaNBri1shZMDb
         QIwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754413073; x=1755017873;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GEnVU5KAskdWYUBQ/kSGgyrV9wf/VcctSOFlUiJlPrU=;
        b=E0nnc220wUOpkfHeMu7HBVCyqxEfr8jHVvgCm5G7dpSeXEiaTAjwLXu650uQvCQyVm
         Pre8Jg3uthEEP4DWG4j1BHcQFBHNCf8/rU6l1R52AXdi2IlUagoxdftSEpOP2pEbUwpO
         FBJO6Z636P5i5c2D3wU+dkKHugHI6DToponqYn0nNwSU4c9Nvzkbn00utP+AFCVvrQP6
         cqk1VSdy5b9ZWZE3zTRyH+dtXTo364pK6DiahHhYe0VdcijfrS2ZQ41vFnv4kTPm8gAJ
         EJt0O08Qix9h26TOU+mfeEar++oKiXHBUKbauXyz/inkTsOm7oYQ0GLvWHNvb0RazkNA
         lVpQ==
X-Forwarded-Encrypted: i=1; AJvYcCVTPXzqf3bxCPditykPqbz+Afpa57WHldsFztYyuUsrjU4W1+v0LntFnUuhMsE+h68pzDm29w5WEA==@kvack.org
X-Gm-Message-State: AOJu0YwBJGXPRS3CeEZdpQ70ycFa/LQ9qB25yGPPiSO6CrbsSpniFOx2
	lvyCFezvBohmhC1YqUr/Zp6ywmxoCNNzd8lchFYRUl8ZbODgr2johb7533o2/C8ZC7TkB6+QF07
	nUtmWaB0OQaRzhF324vu5YN93AoRClyLPbhmHJsyz
X-Gm-Gg: ASbGncuZI+FVXix68vHgCq8A6k0y/psbS1yOF/Napq1gI4YFRSCt2snNAGEJTuB0wGi
	ULiuLz8PVhFwDakOo0o2gEf/NPhpyKaYSvq7H9ubaJ0hpQLqKCifFWHdT2RrkpYdjpgE6Ia5tcq
	6vvKUpqh+JeXY+naH+71+56BsKRAVWHuvzmIsl+HMZ8eNwYB8XKB6mxYpVW6Bd33iEoH4mXUWbS
	WgIdpJqP3CtKeJ4vd5WOg3CImI8t2qS2OqWPoqO
X-Google-Smtp-Source: AGHT+IFHALxRLkmhDed/lnhoMX9pMKBECdTY93R6Sdw6v3eSIKnTQjB+1XTGHNMoRl1Mtb+hpgpseJBwvLL9afKRuuU=
X-Received: by 2002:a17:903:41c9:b0:240:a4b5:fe0d with SMTP id
 d9443c01a7336-2428e9d9866mr3490245ad.6.1754413072472; Tue, 05 Aug 2025
 09:57:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com> <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
 <486c5773-c7fa-4e19-b429-90823ed2f7d5@redhat.com>
In-Reply-To: <486c5773-c7fa-4e19-b429-90823ed2f7d5@redhat.com>
From: Juan Yescas <jyescas@google.com>
Date: Tue, 5 Aug 2025 09:57:39 -0700
X-Gm-Features: Ac12FXwewq6mHJ3iXKimK9YdL07pdhlid5gd2fFisX11Nn-jXdYL26T35WBbNug
Message-ID: <CAJDx_ri==3SxFcuKXHpNjrtxbp0hLyhM+zXeJ-LQX38rfbUChw@mail.gmail.com>
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
X-Stat-Signature: 4ddxm5nofantrg4qqm3p6y88atsyyah1
X-Rspamd-Queue-Id: E911B4000A
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1754413073-342226
X-HE-Meta: U2FsdGVkX19Wvl8nwabC5F58X4wHcD1IcPNb16E3w0qeOo8eBqN2cTf61j/ZPuTH/zQQzU2X6qPuiAQQB2ITqIMcQsLZJ/0vnbQd9MxMfVJuc5jQY/oFH8kEaFVp9nqOICsdWLxscxbZtlUHwv9wQOMJggQwry+eH/9S9PEmb/fcpanFbAltpCmOtmTQmh3GM8IWfT5eIuuA1zw6H+V3xYyIM81bBjITCqnDx7jiqiLpb8MZyScLQbDFenpPHpaZZdgRV33HSrmerhAqmDb7kOK/z7eQ/yvb+b7awpuWP4K1+1OedrvkDGXVkXM2Y+zQKxm/glTbGTK5EUgzD0f/plEAK0qeYoUbVsuUahaS/9qgMaZdMu94VFtzQ/wpFD9zX9d0f3zIXoVfRRidJMwpgmX+/4OTXaEgzljTz6hZ/KSWaRWS+vur133aObgPi5Lf833jGBAFayfFMUbGxOR0s2o5K0Edm7zzEZdHfwrpgbnGP+a28HBAPtTyg1C3e5Cr+dcTi+rMlKLq5t7/f6cqdGJNpW9KraIKFc2bTKXtROPF6+2g61+0Z02hKOprnqe/SijutvwbJMMdUVxeVkj2v7q4KitVJAr+nQELWXC/1ZiPdPLmcydrrjtDUeIv1EKsK9xMuT3q+lMZcnOcBac82hiMy8hwF3bbn3rJE1ebyQtXJ2kfvsbPaA+YU98ZPU5pRfLdp6d+VQnmydbLgfvJPsM5nCZY0HeYcDlsoK2PPysm4iJgyWtYVgMDaeXiJJA1NCaWksj1e9PUxu5iScUhuRUL6qtTs3xpFBnvx9t+cWuWnLQu3KvUcHmZFe+zjE4L6JsobFXSA+2zAwD3XSZubuR567Frq9fCAbbItM1aItaAU+iXo8UHw5Nn+efrVY+lQ50UBWnNzZxczOSBR0SOkF6qKOVWjgjXkgXtV7xBDsbNHVn5Tv7PMVfmp747T2hMg3Wamc+bn4nIyhdDJ2s
 tvi7PdX+
 Z1bWZmWUd92yzHbOuEGKiUU8KHd+Mi/G1UnztU5DVa3svl5QWkLpkBgroAg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 2:58=E2=80=AFAM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 05.08.25 03:22, Juan Yescas wrote:
> > On Mon, Aug 4, 2025 at 11:50=E2=80=AFAM David Hildenbrand <david@redhat=
.com> wrote:
> >>
> >> On 04.08.25 20:20, Juan Yescas wrote:
> >>> Hi David/Zi,
> >>>
> >>> Is there any reason why the MIGRATE_CMA pages are not in the PCP list=
s?
> >>>
> >>> There are many devices that need fast allocation of MIGRATE_CMA pages=
,
> >>> and they have to get them from the buddy allocator, which is a bit
> >>> slower in comparison to the PCP lists.
> >>>
> >>> We also have cases where the MIGRATE_CMA memory requirements are big.
> >>> For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to 5=
00MiBs.
> >>> These cases would benefit if we have THPs for CMAs.
> >>>
> >>> Could we add the support for MIGRATE_CMA pages on the PCP and THP lis=
ts?
> >>
> >> Remember how CMA memory is used:
> >>
> >> The owner allocates it through cma_alloc() and friends, where the CMA
> >> allocator will try allocating *specific physical memory regions* using
> >> alloc_contig_range(). It doesn't just go ahead and pick a random CMA
> >> page from the buddy (or PCP) lists. Doesn't work (just imagine having
> >> different CMA areas etc).
> >>
> >> Anybody else is free to use CMA pages for MOVABLE allocations. So we
> >> treat them as being MOVABLE on the PCP.
> >>
> >> Having a separate CMA PCP list doesn't solve or speedup anything, real=
ly.
> >>
> >
> > Thanks David for the quick overview.
> >
> >> I still have no clue what this patch here tried to solve: it doesn't
> >> make any sense.
> >>
> >
> > The story started with this out of tree patch that is part of Android.
> >
> > https://lore.kernel.org/lkml/cover.1604282969.git.cgoldswo@codeaurora.o=
rg/T/#u
> >
> > This patch introduced the __GFP_CMA flag that allocates pages from
> > MIGRATE_MOVABLE
> > or MIGRATE_CMA. What it happens then, it is that the MIGRATE_MOVABLE
> > pages in the
> > PCP lists were consumed pretty fast. To solve this issue, the PCP
> > MIGRATE_CMA list was added.
> > This list is initialized by rmqueue_bulk() when it is empty. That's
> > how we end up with the PCP MIGRATE_CMA list
> > in Android. In addition to this, the THP list for MIGRATE_MOVABLE was
> > allowed to contain
> > MIGRATE_CMA pages. This is causing THP MIGRATE_CMA pages to be used
> > for THP MIGRATE_MOVABLE
> > making later allocations from THP MIGRATE_CMA to fail.
>
> Okay, so this patch here really is not suitable for the upstream kernel
> as is. It's purely targeted at the OOT Android patch.
>
Right, it is a temporary solution for the pinned MIGRATE_CMA pages.

> >
> > These workarounds are mainly because we need to solve this issue upstre=
am:
> >
> > - When devices reserve big blocks of MIGRATE_CMA pages, the
> > underutilized MIGRATE_CMA
> > can fall back to MIGRATE_MOVABLE and these pages can be pinned, so if
> > we require MIGRATE_CMA
> > pages, the allocations might fail.
> >
> > I remember that you presented the problem in LPC. Were you able to
> > make some progress on that?
>
> There is the problem of CMA pages getting allocated by someone for a
> MOVABLE allocation, to then short-term pin it for DMA. Long-term
> pinnings are disallowed (we just recently fixed a bug where we
> accidentally allowed it).
>
Nice, it is great the issue got caught and fixed upstream :)

> One concern is that a steady stream of short-term pinnings can turn such
> pages unmovable. We discussed ideas on how to handle that, but there is
> no solution upstream yet.

Are there any plans to continue the discussion? Is it in the priority
list? Maybe
a topic we can discuss in LPC Japan?

Thanks
Juan

>
> --
> Cheers,
>
> David / dhildenb
>

