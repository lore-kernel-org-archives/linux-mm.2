Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 308FECA0EC0
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 21:44:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7D308E0003; Wed,  6 Aug 2025 17:44:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C546E8E0002; Wed,  6 Aug 2025 17:44:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6A558E0003; Wed,  6 Aug 2025 17:44:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A4B288E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:44:56 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 2E54113611C
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:44:56 +0000 (UTC)
X-FDA: 83747662992.03.0957554
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf29.hostedemail.com (Postfix) with ESMTP id 76BC212000D
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:44:54 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mXyKxzv0;
	spf=pass (imf29.hostedemail.com: domain of jyescas@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754516694;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ExirjJSM/csYCG9EmPc30PfgAnDwOd41cOSuXn8PQ6U=;
	b=bq7IJTzyPRk1+ExJyAV0fMxQwmtEtVzSx9xlshfUY1BPag9jFh7UySZlH6DlV+M5qxHWJf
	R41SChrZ2/JK7eIqbhdyd90zeJKGQyQW2FyvuAEfjkiZucM0ef2LZhS28clDs2bgq3bSfC
	vw9qdCcAxw93/bgWxkiUGF3JT8EAb6I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754516694; a=rsa-sha256;
	cv=none;
	b=KfFDVMfougAAgZTTFUr7410Yck4xEIMrdmE+aGQXCIXQe3y5CpPnPYSo8+EVD77f6qY3AL
	zlYui3+Vq5Nk6iX/GeOC6odiKCmEz85HnqHzzjTtHjo/JcFaj0/dukBebHrAHMhhDaTkJt
	m5mCIucy8umPlm48tRD8GfH2Vk2/cPw=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=mXyKxzv0;
	spf=pass (imf29.hostedemail.com: domain of jyescas@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=jyescas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24070dd87e4so49735ad.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 14:44:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754516693; x=1755121493; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ExirjJSM/csYCG9EmPc30PfgAnDwOd41cOSuXn8PQ6U=;
        b=mXyKxzv0FlfSEbDClevPQH1ZfvZ07RulhxPIgHsq+5g7aZd64f4zDkApQ6zRiOLU1R
         AsfNg5xT2fxeyplWHR0uV++dC36nEwtrrWl3bOIJ6usqBeGpLWH5MHAgYaMZjsWrHLa9
         tgkFQBLzE0XK+4nGeEyBxwGsd6Iia1OzENLpk7bnPLMrJzgQ7z39ry4M1yhhFna4LCFV
         dXg+YXDYfAwZJF/glyTvt7tK30znTbKPuj6OFrIQ4ESnbw96lHWLzq3baE3WG/kZiH6F
         TO7ybMxHLWsrnNY5/2U8tJlmS6lb4HPbTVN9MCIhffYZIWEhJlHcBjgDON7leWDvegIs
         /dZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754516693; x=1755121493;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ExirjJSM/csYCG9EmPc30PfgAnDwOd41cOSuXn8PQ6U=;
        b=dVh+n5XimYw99C7sGqSB0QQfQR1eYinetFIuwRMN4by0/TXHem8oP31SwpNh4XCXrx
         6Eg8YK7qFHDVdUzgIZtT9PKd70O7gw8eSo46AdL0jdt0wId+RtxKMSQ/MOjTtn5VPT6J
         RjE6wwiT8I0d4hRn57d/+JqlhizswgdXg/86oMZyW+hAzPxoSZJo8DT5/bKI6R6GI/cQ
         KdD6KeOqe3pESMGpOK9V1xPPPf7iLjOxki9Uv0Gn5oU9af0WldgRqZ71cT1y1sPl3KT4
         sPYiSIv5afYil+VcOHulOG/i/Zwr6p4ZQSAvvBY8NmL/pAD5zx9M4klvIzZplb87htGS
         HFaA==
X-Forwarded-Encrypted: i=1; AJvYcCX4VEAwNLJ87+99xJbhNx/CO0gJ/AsjEjx4s2FRZK9UjoluoWji/GwOzLYV07rA3oDxcQY5qlzG5g==@kvack.org
X-Gm-Message-State: AOJu0Yy7lYMUTZdSTj2l8wH4WJ+Mg3eRXmh+QFxELdyMh+DIpPSDNcWU
	1efGAc2F5bc2oKss6oAoItjmMN8fByMS2VPyOFIBaa7jCTMbeFOn5iD/7my8lt1vhvH2yKJhtg0
	0bTyhxX8zw4nsw+41giWqUsYfHbJe+BDTIEb9bzkH
X-Gm-Gg: ASbGncu3YgWLV39jkBndbim2Z5iVn6qKeQmOgzgLS1TQqyT6KRv0+FjQqNOktxT5TSL
	VX86gx7lWT2dLY4ja0+CfetfOTfykpVZsFu8cqAOzsJGdbk7mwtGldBtaoQs8SErxiwKoHufh4x
	wpVaSJj2zKiZ/ozNo0pQMB2nLqELh0exCH7nFIJSgfTXM140BjXTyZ6ZmrI1hfacZkRFJ2XpXV6
	ih7Q441qB8DNPLQRHWOunNJD/H+pVCFV014dg==
X-Google-Smtp-Source: AGHT+IGN6jPVx/xKriPYLrcCMwGgdq1S4mGL9tfjx+eQtFfuUZjh5qmVYhD4H/cg3UBYdQmSwMbOsNdJyZ6JkLtTXaE=
X-Received: by 2002:a17:903:234e:b0:240:4464:d48b with SMTP id
 d9443c01a7336-242b1b11c2amr1198725ad.16.1754516692844; Wed, 06 Aug 2025
 14:44:52 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com> <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
 <486c5773-c7fa-4e19-b429-90823ed2f7d5@redhat.com> <CAJDx_ri==3SxFcuKXHpNjrtxbp0hLyhM+zXeJ-LQX38rfbUChw@mail.gmail.com>
 <6dee6cd9-c67f-480f-b728-21c3a7b72004@redhat.com>
In-Reply-To: <6dee6cd9-c67f-480f-b728-21c3a7b72004@redhat.com>
From: Juan Yescas <jyescas@google.com>
Date: Wed, 6 Aug 2025 14:44:39 -0700
X-Gm-Features: Ac12FXz0ztgwDhHSWf7ryVCMmjiHYTsStUeyw4tReXo_moA4XvrPjonq58HDs_M
Message-ID: <CAJDx_ripauyGX_KUvApWWZNPuYsyyr8ux6v=nyccAX4zp0w9MQ@mail.gmail.com>
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
Content-Type: multipart/alternative; boundary="0000000000003b5dc5063bb94000"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 76BC212000D
X-Stat-Signature: fz3akodn536er86ecmj6rq9rpromb83y
X-Rspam-User: 
X-HE-Tag: 1754516694-305850
X-HE-Meta: U2FsdGVkX1/MZpz6VeMFpmVKWIm1JirCH0H+D+InLOfDWA0zyrdplUcE7+Cbbd7e89zvIgXjH7CNoZmHAG2lV2qlWeX/K5wqD3Vmc9JSR7ei3yU/hX9ZXEuRiFIFRI756O0BhbDOv337+TaleU97KGJeBmD9F/xLat95xIg5+rvpKCwafr0YysYBudun7Ptjivj4VJKtYJcLpgPAUOM5nC7X+wfnXke+MsQFpJtOKQOn8WGFEyT11hOTPvXok5Lh/oJjdktt9USoE8iqRpWoqq1N2hGbDQd/0s/W14r3vpySNrmwwGwMh3xZRhtaDpNPXy8udtQyVvBYyyLOCfXGsm8+5ofka/S59/t3n3wHb2ivwbiuE9ybB9RXSfOsYzcDcw0fVWvIUk3tUVK5ATgQWeQUAlwPPoe0MuCXUDYccYwVsil7E/JP7Ie7jGEiOdBe3S5KqXCvfeunSgFABONqNKcn4h0E87juKf7FMSkdRMlX+beOUDizhaERl3B/Ni3gwoYhdxLf6LhuKyfBQP+c0eBVQzkH7trFt6sfsUFvCAzXRbpwQGo1fR2InrSJTqVHRQ0uao520NxFzJURq/7f5E4rqWF2RqRDyPPoMXxnuSOSlP9hFLCeI0Dnrc6+fHUvEW5evkKH3Hj9bwBCmWzks6FbhQKN95wJo1W3mD1WWOzEbtAS6WpDstpfEDugAnFW4utssTfzOyShA6oeYWXqMMet2Q43pEd9rvXawvjdEBebgpGXI+2TMEzK2kIWJAw2k9yEd0pZXs/u2WSvyd0eeHc1udjtiMFDAIbhtf5CVCZu+5F6H9Gv7ckmAibNJwwfmycYMX8MtdrM8uYPs3g8CnDMwNwZam7jNt83PHOWQ+JL/CIYbVwmWrBOLOfhUqJnmU126xW+uPTMCODoHXaFXdLmeCS4KGXJRxuFNdibcEncLg3rfr7POPtWBujGA8gLXdHSopACVlIEZEClBCp
 WI8iYbdL
 FgrgwnPAh7q8gpLSz+CZJZfEXKNwe/fYLvX/wuSyR4Cyd2QpZKnWdaPbWBfxSJ+9s5SixVus8WmAcEiZ5U63YLLTCjtVfV0+X1k0R
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000003b5dc5063bb94000
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 5, 2025 at 2:08=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:

> On 05.08.25 18:57, Juan Yescas wrote:
> > On Tue, Aug 5, 2025 at 2:58=E2=80=AFAM David Hildenbrand <david@redhat.=
com>
> wrote:
> >>
> >> On 05.08.25 03:22, Juan Yescas wrote:
> >>> On Mon, Aug 4, 2025 at 11:50=E2=80=AFAM David Hildenbrand <david@redh=
at.com>
> wrote:
> >>>>
> >>>> On 04.08.25 20:20, Juan Yescas wrote:
> >>>>> Hi David/Zi,
> >>>>>
> >>>>> Is there any reason why the MIGRATE_CMA pages are not in the PCP
> lists?
> >>>>>
> >>>>> There are many devices that need fast allocation of MIGRATE_CMA
> pages,
> >>>>> and they have to get them from the buddy allocator, which is a bit
> >>>>> slower in comparison to the PCP lists.
> >>>>>
> >>>>> We also have cases where the MIGRATE_CMA memory requirements are bi=
g.
> >>>>> For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to
> 500MiBs.
> >>>>> These cases would benefit if we have THPs for CMAs.
> >>>>>
> >>>>> Could we add the support for MIGRATE_CMA pages on the PCP and THP
> lists?
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
> >>>> Having a separate CMA PCP list doesn't solve or speedup anything,
> really.
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
> >>>
> https://lore.kernel.org/lkml/cover.1604282969.git.cgoldswo@codeaurora.org=
/T/#u
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
> >>> These workarounds are mainly because we need to solve this issue
> upstream:
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
> Do you (or one of your colleagues) have capacity to work on that?


We are interested in fixing it. My team can begin work on the solution in
early November.

One
> idea was to flag folios as "pending on migration" and disallow any
> further short-term pins until migration is done. IIRC, there were other
> ideas (e.g., isolated pageblock).
>

Thanks for the pointers, I'll take a look at that.


> > Maybe
> > a topic we can discuss in LPC Japan?
>
> Sounds good, feel free to propose this as a topic. I wills end out the
> announcement of the MM MC probably next week.
>
> Thanks David, we'll do.

> --
> Cheers,
>
> David / dhildenb
>
>

--0000000000003b5dc5063bb94000
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><div class=3D"gmail_quote g=
mail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Aug 5, =
2025 at 2:08=E2=80=AFPM David Hildenbrand &lt;<a href=3D"mailto:david@redha=
t.com">david@redhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gmail_=
quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,204,=
204);padding-left:1ex">On 05.08.25 18:57, Juan Yescas wrote:<br>
&gt; On Tue, Aug 5, 2025 at 2:58=E2=80=AFAM David Hildenbrand &lt;<a href=
=3D"mailto:david@redhat.com" target=3D"_blank">david@redhat.com</a>&gt; wro=
te:<br>
&gt;&gt;<br>
&gt;&gt; On 05.08.25 03:22, Juan Yescas wrote:<br>
&gt;&gt;&gt; On Mon, Aug 4, 2025 at 11:50=E2=80=AFAM David Hildenbrand &lt;=
<a href=3D"mailto:david@redhat.com" target=3D"_blank">david@redhat.com</a>&=
gt; wrote:<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; On 04.08.25 20:20, Juan Yescas wrote:<br>
&gt;&gt;&gt;&gt;&gt; Hi David/Zi,<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; Is there any reason why the MIGRATE_CMA pages are not =
in the PCP lists?<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; There are many devices that need fast allocation of MI=
GRATE_CMA pages,<br>
&gt;&gt;&gt;&gt;&gt; and they have to get them from the buddy allocator, wh=
ich is a bit<br>
&gt;&gt;&gt;&gt;&gt; slower in comparison to the PCP lists.<br>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; We also have cases where the MIGRATE_CMA memory requir=
ements are big.<br>
&gt;&gt;&gt;&gt;&gt; For example, GPUs need MIGRATE_CMA memory in the range=
s of 30MiB to 500MiBs.<br>
&gt;&gt;&gt;&gt;&gt; These cases would benefit if we have THPs for CMAs.<br=
>
&gt;&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt;&gt; Could we add the support for MIGRATE_CMA pages on the =
PCP and THP lists?<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Remember how CMA memory is used:<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; The owner allocates it through cma_alloc() and friends, wh=
ere the CMA<br>
&gt;&gt;&gt;&gt; allocator will try allocating *specific physical memory re=
gions* using<br>
&gt;&gt;&gt;&gt; alloc_contig_range(). It doesn&#39;t just go ahead and pic=
k a random CMA<br>
&gt;&gt;&gt;&gt; page from the buddy (or PCP) lists. Doesn&#39;t work (just=
 imagine having<br>
&gt;&gt;&gt;&gt; different CMA areas etc).<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Anybody else is free to use CMA pages for MOVABLE allocati=
ons. So we<br>
&gt;&gt;&gt;&gt; treat them as being MOVABLE on the PCP.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; Having a separate CMA PCP list doesn&#39;t solve or speedu=
p anything, really.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; Thanks David for the quick overview.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt;&gt; I still have no clue what this patch here tried to solve: =
it doesn&#39;t<br>
&gt;&gt;&gt;&gt; make any sense.<br>
&gt;&gt;&gt;&gt;<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; The story started with this out of tree patch that is part of =
Android.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; <a href=3D"https://lore.kernel.org/lkml/cover.1604282969.git.c=
goldswo@codeaurora.org/T/#u" rel=3D"noreferrer" target=3D"_blank">https://l=
ore.kernel.org/lkml/cover.1604282969.git.cgoldswo@codeaurora.org/T/#u</a><b=
r>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; This patch introduced the __GFP_CMA flag that allocates pages =
from<br>
&gt;&gt;&gt; MIGRATE_MOVABLE<br>
&gt;&gt;&gt; or MIGRATE_CMA. What it happens then, it is that the MIGRATE_M=
OVABLE<br>
&gt;&gt;&gt; pages in the<br>
&gt;&gt;&gt; PCP lists were consumed pretty fast. To solve this issue, the =
PCP<br>
&gt;&gt;&gt; MIGRATE_CMA list was added.<br>
&gt;&gt;&gt; This list is initialized by rmqueue_bulk() when it is empty. T=
hat&#39;s<br>
&gt;&gt;&gt; how we end up with the PCP MIGRATE_CMA list<br>
&gt;&gt;&gt; in Android. In addition to this, the THP list for MIGRATE_MOVA=
BLE was<br>
&gt;&gt;&gt; allowed to contain<br>
&gt;&gt;&gt; MIGRATE_CMA pages. This is causing THP MIGRATE_CMA pages to be=
 used<br>
&gt;&gt;&gt; for THP MIGRATE_MOVABLE<br>
&gt;&gt;&gt; making later allocations from THP MIGRATE_CMA to fail.<br>
&gt;&gt;<br>
&gt;&gt; Okay, so this patch here really is not suitable for the upstream k=
ernel<br>
&gt;&gt; as is. It&#39;s purely targeted at the OOT Android patch.<br>
&gt;&gt;<br>
&gt; Right, it is a temporary solution for the pinned MIGRATE_CMA pages.<br=
>
&gt; <br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; These workarounds are mainly because we need to solve this iss=
ue upstream:<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; - When devices reserve big blocks of MIGRATE_CMA pages, the<br=
>
&gt;&gt;&gt; underutilized MIGRATE_CMA<br>
&gt;&gt;&gt; can fall back to MIGRATE_MOVABLE and these pages can be pinned=
, so if<br>
&gt;&gt;&gt; we require MIGRATE_CMA<br>
&gt;&gt;&gt; pages, the allocations might fail.<br>
&gt;&gt;&gt;<br>
&gt;&gt;&gt; I remember that you presented the problem in LPC. Were you abl=
e to<br>
&gt;&gt;&gt; make some progress on that?<br>
&gt;&gt;<br>
&gt;&gt; There is the problem of CMA pages getting allocated by someone for=
 a<br>
&gt;&gt; MOVABLE allocation, to then short-term pin it for DMA. Long-term<b=
r>
&gt;&gt; pinnings are disallowed (we just recently fixed a bug where we<br>
&gt;&gt; accidentally allowed it).<br>
&gt;&gt;<br>
&gt; Nice, it is great the issue got caught and fixed upstream :)<br>
&gt; <br>
&gt;&gt; One concern is that a steady stream of short-term pinnings can tur=
n such<br>
&gt;&gt; pages unmovable. We discussed ideas on how to handle that, but the=
re is<br>
&gt;&gt; no solution upstream yet.<br>
&gt; <br>
&gt; Are there any plans to continue the discussion? Is it in the priority<=
br>
&gt; list?<br>
<br>
Ohh, it&#39;s somewheeeeeere on the todo list :)<br>
<br>
Do you (or one of your colleagues) have capacity to work on that?</blockquo=
te><div><br></div><div><div>We are interested in fixing=C2=A0it. My team ca=
n begin work on the solution in early November.</div></div><div><br></div><=
blockquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-l=
eft:1px solid rgb(204,204,204);padding-left:1ex">One <br>
idea was to flag folios as &quot;pending on migration&quot; and disallow an=
y <br>
further short-term pins until migration is done. IIRC, there were other <br=
>
ideas (e.g., isolated pageblock).<br></blockquote><div><br></div><div>Thank=
s for the pointers, I&#39;ll take a look at that.</div><div><br></div><bloc=
kquote class=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:=
1px solid rgb(204,204,204);padding-left:1ex">
<br>
&gt; Maybe<br>
&gt; a topic we can discuss in LPC Japan?<br>
<br>
Sounds good, feel free to propose this as a topic. I wills end out the <br>
announcement of the MM MC probably next week.<br>
<br></blockquote><div>Thanks David, we&#39;ll do.=C2=A0</div><blockquote cl=
ass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid=
 rgb(204,204,204);padding-left:1ex">
-- <br>
Cheers,<br>
<br>
David / dhildenb<br>
<br>
</blockquote></div></div>

--0000000000003b5dc5063bb94000--

