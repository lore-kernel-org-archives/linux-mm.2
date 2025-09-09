Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECAC3CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:07:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F060C8E0003; Tue,  9 Sep 2025 16:07:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB6418E0001; Tue,  9 Sep 2025 16:07:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA4708E0003; Tue,  9 Sep 2025 16:07:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BEFCA8E0001
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:07:35 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 7A22916075A
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:07:35 +0000 (UTC)
X-FDA: 83870796870.02.8F91EE8
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf27.hostedemail.com (Postfix) with ESMTP id AEB7B40007
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:07:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="IEY//LHD";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of jyescas@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448453; a=rsa-sha256;
	cv=none;
	b=FynyvXCnyKIfV+l/Z1MGLARTDGfWTtycQy5Lq+0j/g82j+3a+q9NO2kwPqYUWm6X0VKF4/
	SI9my6WWkw/dKGXF3GRVziT2HIA3N7Cc3BPHtR09J5auBCGf6lPKggYyuHVaECgavcHeNf
	2acs0mNhInvKjO3YJzo0uYPmUuAyMaM=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="IEY//LHD";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of jyescas@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GJGSId8xZGClXTTL3PjAabP3O/IwmDMLJ48Vb9IC160=;
	b=E5FaX42o0DDqc6Bp6YCx7AOJ7HL6KRc0+Vl9oFMOIriec74LT9FQTuM9auE9PctMu1of2H
	gYTQnXxObox1m6yR8BF2pMLuJP6lfbo1RRB30RuzkYgzbixleKqVoVMeyHkAS67fz34bxJ
	pNpBF+2pG70VvhfmNJSX+WkTSGFVClc=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-24b2d018f92so8785ad.1
        for <linux-mm@kvack.org>; Tue, 09 Sep 2025 13:07:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757448452; x=1758053252; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GJGSId8xZGClXTTL3PjAabP3O/IwmDMLJ48Vb9IC160=;
        b=IEY//LHD+S7D/n+Ykxlo8qzeqMXUirJK5N2iU3rH5lbs+ZQKHSTC6hkU4kCG0onbVj
         Yqp9TzrCDmpuKGA3p2l5yrd7C1lp6wAukrsbJnZh4ZyWpf+UVe6Ar+eH57Ncmq2cgcEy
         yW4MLnuK6iNF2f3JkrJcpNFbjNi4WBhvr/y1SNsgW++Mq1pETxB70mPyvI5kNUMFZR0K
         mX4TMb3D8+rOLkGt+0Z298EpFAejhjY+nHtgKjJZde1XJnaRdxHZBieG/Upa06NXjoQc
         WNQL1s+2xZnz7rzR2LbOljYo/cFhRmNZrgdWd35wLxVA0eEDmh5xlk4b7JhHM0m5lqaM
         9biw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757448452; x=1758053252;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GJGSId8xZGClXTTL3PjAabP3O/IwmDMLJ48Vb9IC160=;
        b=QgOix6tt25RLGjaxU3jAMyETJU8Bk3tCca/E9KTf2gfIpeL969HsYRSYN0ZMsw0Vm4
         cQmjtdZo0EMIds8luVhZUYXfjSq6vcF2ScqPLp6cilo3xm7XZMJmtsDq+UQRf+7/9+Zt
         /kFLcHz1RVB4+HjvsGcD3SPoDQW3F5IwLJysU/ix4YwWseU5eZNByBQ5ym5kXdIMobdu
         IeE7TRbVU2chcRN/3TYUwVJqBfagPxfnHp/DlO18RkVRevZ4h4L6i6uHk1MB2/ByGf3s
         5KQnCmAeq5Jc1eYjh8lhXPSR+xdaRRsGf94/tS4eJ9JhuqZlD2FRRBgO49qAKPRr0YZL
         FNPQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJBhu3rub0nwFqTh5CE8yJxTLeH0mVxoTx8ijoi06jVHHUEoI/DoFTR9X2yDmqytan/vYB7mUX8w==@kvack.org
X-Gm-Message-State: AOJu0YzHpwR25tguNYUSJYrCz0M1m6Ws0hpsH3kkY6ULk3aKzHqgg465
	nYHAKjZ2QjV3CCdo2mcdSCP/BpRdi3yEXR5SwhJhN2gNXRQ+MFfZlVLWigyOMW1j5qH1xUrUGj7
	Uhc5T8uQZ7/jKSSHxojZCxj6OlI9uk0DavvPTgLvh
X-Gm-Gg: ASbGncuSph/AuLd0bwPk+3OkwQ7PyR5KQN9zfu75WpmmS7F16qs8IGF4b2HeO7QDxuW
	7KVDNN3EaKHxHz6PvlFu5+yyu7eRJBnvQX8VnbtSYEuqNf/Rh98hN3U/Z3VyxTLNIPeW9d9Tjul
	Gnu1m6BGAoo9A7TjSMRpMeyL1I38rUAH1KjazgPSbBZ1Mg4+NA8PSwJMqHE6wg8lDsgJRBNbR34
	41bzFKwtXgaqJ5V2czn/ltSqXEHKFm6guzoRJHsi9g=
X-Google-Smtp-Source: AGHT+IEhjbN+9tvrD+zszW+/7dIiUSph/hnrO8562d7Hw5weQdGqLDDKswFsLQj+Gdp+QQZb780o7qkHno+U2EtpwOw=
X-Received: by 2002:a17:902:a715:b0:251:a3b3:1565 with SMTP id
 d9443c01a7336-25a5ae3a71dmr620765ad.11.1757448451998; Tue, 09 Sep 2025
 13:07:31 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com> <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
 <486c5773-c7fa-4e19-b429-90823ed2f7d5@redhat.com> <CAJDx_ri==3SxFcuKXHpNjrtxbp0hLyhM+zXeJ-LQX38rfbUChw@mail.gmail.com>
 <6dee6cd9-c67f-480f-b728-21c3a7b72004@redhat.com>
In-Reply-To: <6dee6cd9-c67f-480f-b728-21c3a7b72004@redhat.com>
From: Juan Yescas <jyescas@google.com>
Date: Tue, 9 Sep 2025 13:07:17 -0700
X-Gm-Features: Ac12FXyqJk95BzMsBAXQbxuk4y3BxEVHd4SQLHyRVgKfv8bcP2fe-zsqgx1zwvI
Message-ID: <CAJDx_rjg9LJ6BcgKvLeY+fpPpP41yC=Ru9oEYcXEA8b5AT=E1w@mail.gmail.com>
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
Content-Type: multipart/alternative; boundary="000000000000b22515063e63dad7"
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AEB7B40007
X-Stat-Signature: 34h5nk6jzasn4re8de5ooagbbdhmdsfi
X-Rspam-User: 
X-HE-Tag: 1757448453-849877
X-HE-Meta: U2FsdGVkX19fvx6l0Gwm99yPqVvyaXM7NnjeevawgEnLNDlQB0HI+kKVS4dIca84fdhELQYYiKL4rOvsSpqzmFydYOlftfB4XrgsW5ra3D0zJ5gtlMQ28oESVd1Co1/wX5chbK5Fo6+s1h8GgO9XFA0nPyOGq7qyJP+MtYJJeEt9I/vI5Q8732aadAlKW29Tdw7w+Ek3ne5UIBIBOYPqQVhe1MrvXzAHAbfMInYOBFOJV91svbj4JQL8vntJhldz9Jz2YjCGRgaLV1fGvOWzYVBRyTlpfKhvzw5SilBipf1g/dGnd7eIPJ17eaBAnIzhd1eztuOZI35MCv6VtDP7bH/idZpFVKNUM6rYZj3jYLHaTpzsdGbcNKF7Iv4DstmPLfVNP4nQ7uHS2jwxkKOjky8UypXzPxSZYt8/j+oPU3Y+bKtoyc8LmmfINgTAq0RRbQHb3wBzC9v8x2OSEcWyrpHrkk+DDL6mUVwE8XVuHPSlY2hW1rI06cPkEdKTXLkYOS4VRIxwRGSLKQiM8lCWEq82myvKckJp1dOvgJgkHCAsBpnaLl5YmeTGJN4Drj0eFAZ5Ta4/F3BzOJG5FL8PiILgeBXG/k65avh/h4KMM7GLf0AIAWsh9++XGKdR397/740e/SXnNHKoC4jxaywVHDcrcyTK1LW/TSDCA19FR14ZbxyHx87/FooUkxNrRoiL6JNTQLXxJT/LIvqKDfDrd0qtPCWo9UMwjTE6uvqqKSwKSeeynLhcsY/dQhAAgii1dMm3UP9S+71HWgwDlugul0B5zDt8Yz9WHWyRC6UzzsJ3QEgqxBlHrHC1ct5uwOFKUoKH9MjhWGGfacD+vBMW5DN80HvcuTl1Q6wmZrKkFPQAdQz82lsFOvkFBHI8ttllk9EtI61F0/2FV/guyXdJUWUpSEiGdqzjb5DKJY31ObeaIJAcaif+KJTip2W9rDE8iesaKt8fa5BLHf0dCe7
 D5lbmLSm
 lzw4fq7EDL/aDo7JYuYa846QJPMDiO5H1JN4NhBg2TU5y5f5An6A25893Ywcmw9BajeAotdpXLVNCA3/J5T016yQlEB2uSXrsClug
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--000000000000b22515063e63dad7
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
> The topic has been proposed in the Kernel Memory Management track.

https://lpc.events/event/19/abstracts/2397/

Thanks
Juan


> --
> Cheers,
>
> David / dhildenb
>
>

--000000000000b22515063e63dad7
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr"><div dir=3D"ltr"><br></div><br><br><div class=3D"gmail_quo=
te gmail_quote_container"><div dir=3D"ltr" class=3D"gmail_attr">On Tue, Aug=
 5, 2025 at 2:08=E2=80=AFPM David Hildenbrand &lt;<a href=3D"mailto:david@r=
edhat.com">david@redhat.com</a>&gt; wrote:<br></div><blockquote class=3D"gm=
ail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px solid rgb(204,=
204,204);padding-left:1ex">On 05.08.25 18:57, Juan Yescas wrote:<br>
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
Do you (or one of your colleagues) have capacity to work on that? One <br>
idea was to flag folios as &quot;pending on migration&quot; and disallow an=
y <br>
further short-term pins until migration is done. IIRC, there were other <br=
>
ideas (e.g., isolated pageblock).<br>
<br>
&gt; Maybe<br>
&gt; a topic we can discuss in LPC Japan?<br>
<br>
Sounds good, feel free to propose this as a topic. I wills end out the <br>
announcement of the MM MC probably next week.<br>
<br></blockquote><div>The topic has been proposed in the Kernel Memory Mana=
gement track.</div><div><br></div><div><a href=3D"https://lpc.events/event/=
19/abstracts/2397/">https://lpc.events/event/19/abstracts/2397/</a></div><d=
iv><br></div><div>Thanks</div><div>Juan</div><div>=C2=A0</div><blockquote c=
lass=3D"gmail_quote" style=3D"margin:0px 0px 0px 0.8ex;border-left:1px soli=
d rgb(204,204,204);padding-left:1ex">
-- <br>
Cheers,<br>
<br>
David / dhildenb<br>
<br>
</blockquote></div></div>

--000000000000b22515063e63dad7--

