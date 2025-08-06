Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 25FB7C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 21:51:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB71E6B0095; Wed,  6 Aug 2025 17:51:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A40CE6B0096; Wed,  6 Aug 2025 17:51:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 92FAF6B0098; Wed,  6 Aug 2025 17:51:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7CF666B0095
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 17:51:36 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F10131406DF
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:51:35 +0000 (UTC)
X-FDA: 83747679750.06.DC52C28
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf27.hostedemail.com (Postfix) with ESMTP id 16DD840008
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 21:51:33 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BzdI2eUW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of jyescas@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754517094;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QRMQIBsMA+l9KZfl04i5PXSxssKIDI0W0QjLn2PUAqI=;
	b=M59JthoBTmABxKbC4uzM4Gf4N2E/zu+qjTIN9gLqplMwYRoRwmZE+pzBZrf8Jd/VgnXshN
	iMBWvOkAewkUoSPnJe4zl+lGhFuX4F7m+u9N64dsqG6UjtQVuMAb//Wrrvznhotj0f9734
	EZYud1Gaqvt3fFTjzHq8bLGJUnZnvKQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754517094; a=rsa-sha256;
	cv=none;
	b=cS811KKI4jg6OJolAEmMjZfKHK8TvQtDRTvEqWn6UsR/83XHpnY54aRSiwZcsdxq2qhzvR
	5zW4uzedaJynDT13An3bRSMxFJhDy5lta+dl/EV5S273ylzsslm6iuu/RlKIVMujmGZYXo
	/BT1RtNuBnMIF9ihF1wSu7+xaWVDvNc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=BzdI2eUW;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf27.hostedemail.com: domain of jyescas@google.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=jyescas@google.com
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-24070dd87e4so50865ad.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 14:51:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754517093; x=1755121893; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QRMQIBsMA+l9KZfl04i5PXSxssKIDI0W0QjLn2PUAqI=;
        b=BzdI2eUWgg1fujQ1B2CPLRuVoJ/OV8ro/2X0Fm4hC6h1ZgM8xf0y3z/U8BeJKZcjZW
         OKRaEdg83Hs1rQfmJ+D6nPxwaRN+ODGzMaUJeUQh1GBGYAi2oY9CMOwMT8HgUtl7J2Fw
         hQn4Vtww8MXMMrk0tKaLvh5MDD3GO85WVlpaViRh7AsQrSWHL0SelqnESWAN8lrq4Duz
         73Ai431fADJD5eMZrSL/nQmauIJr59x6lQ/oXR3I/joiyVgU5otFzLQQJfh9EZwgA/bl
         V3kAnsb4Sz9/rdk6GHWdA/JbfjxNxVPw9zyr1ZIhde3funkgAF7PXwN7bOORsrS4HYqL
         C02w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754517093; x=1755121893;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QRMQIBsMA+l9KZfl04i5PXSxssKIDI0W0QjLn2PUAqI=;
        b=Jzjx5UEDg+o4snTK3ZHG6CP3Kkz5/EYZ5DJowpAC1OnZTKRmQfcZb1KEpg89C7+O+E
         twoMmRb1nR4pk9+Z6iHqVC1QMQpb6qmuzF6atUxLVdEzSDq05S4J6faALXlIH5rtRg3c
         u6Eqxra5/v8ifcdlgiKxJmT9Yuc2RFoYi6jy78EHDSzezxDeBPX5TDN7nhSCavVr7WkZ
         o/WjDEWUs3kwWciTAwxJ+CscNquabz/FA/V2dyyiWwxHbkYjX16FCp5FFnsS6O9oN3ok
         rCF/CQzGohp31Y9vMJNoM1KgF88riaDQcmwhegBk2MZ12MIMrI8tlGc5TxQD1RF1xCFN
         ybAQ==
X-Forwarded-Encrypted: i=1; AJvYcCVSEBKO78ahmOJ0r9CnCjKoN21jJ2Z5oIMvhKYaV0fIQ7KvIIBmpj8kLR9svDnhof/JTfyf+1ixLA==@kvack.org
X-Gm-Message-State: AOJu0Yyjjr3BMewUSY42IkKk0zfcw4PzQItS70LpD+0ivPMWPMpZAD/l
	DpnuzLj7SZTFTyyE1nEXZE25cgnawMFeloimRI7pWYlU6a2oaeCBge3hcVFqno7wGM+nCzAsWjH
	sjjCt4LqDdz50dod6FY9AooosvZApagdxULA0XdYf
X-Gm-Gg: ASbGncvkuummV56+gS2k8qrk7yq0Y0jcKIeqpbR57yk0IZ9xCjkS/Jws82mQ8/IFj68
	laicuK7C6J1Yfugn/q5sKicLr5YB6OYvpphtzgJpquvVXuZgNXuIEGMtUCubcPPpRj2lRb9UKxR
	nS+TqLqlugGYUPuuC+9BSyTIrE9KKszVK3dIFbYNEUhyCU29+sDSolPhmJuAuy/gWFZUF0vyGlF
	QzPM7KQZ7L0W9FAlyx7QlaMoqq2mH5Q7tBHCw==
X-Google-Smtp-Source: AGHT+IHKc34LlGijqXdxaeMsO9nuRAyqkTINIhsqzhs9P124AyuzhupyI5XJ/p3u2q1V2zX2OzV8A4nB/RbEGF8qRlU=
X-Received: by 2002:a17:902:f602:b0:242:abac:2aae with SMTP id
 d9443c01a7336-242b1b1395cmr1034875ad.12.1754517092321; Wed, 06 Aug 2025
 14:51:32 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com> <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
 <486c5773-c7fa-4e19-b429-90823ed2f7d5@redhat.com> <CAJDx_ri==3SxFcuKXHpNjrtxbp0hLyhM+zXeJ-LQX38rfbUChw@mail.gmail.com>
 <6dee6cd9-c67f-480f-b728-21c3a7b72004@redhat.com>
In-Reply-To: <6dee6cd9-c67f-480f-b728-21c3a7b72004@redhat.com>
From: Juan Yescas <jyescas@google.com>
Date: Wed, 6 Aug 2025 14:51:19 -0700
X-Gm-Features: Ac12FXz6SCFqNYExBa3l8UXCWP_BB22FRlCztQrA9R7hy7kaz6uZpruEqkMkYDs
Message-ID: <CAJDx_rhu5jj6EEhnPQGa6qDDWTDm-6Ac0ucUA2HVT-9yRvCNhQ@mail.gmail.com>
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
Content-Type: multipart/alternative; boundary="0000000000000af317063bb95818"
X-Rspamd-Queue-Id: 16DD840008
X-Stat-Signature: spx95frm6fkzcspmqbrhfbonphbqz979
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754517093-379359
X-HE-Meta: U2FsdGVkX18xiJfT332u+/V2z0j+ViHbnwIK6awmFnrvwvdidfBIIF17wLSc4Cvm4xGiaRxyf6Qjaks/V7dr4UnSQWrVx3VBMkshkLAh8ykoXWCIOxvPqQ9ROJkONt9kDb3BK4zGd25Dugg8nZilwTdySwgTuJfN691CTJ4pqdL234BeUetSWBcMGf1ZdQW15LhoqW3w6dI1b/1jZUIBvckpz6K8Jat/PVeRvXZdqB/0T/JA1Rl+K/eRDUCB0odit1sWLBiK0RdPpiZKnygVcWnpEZ/XzBad7m0UqsGOZ+anqg4L52MqUMKmRVHLrI9za8IvdhtVuEJAmUcpYLBZfz/VjnnZCHk302Tg1B8cx4KoTi1LKDJsvF0xInu89F1Okl2Z/kptlGXnl9f4XuVVnOgjVy3E8C43GBtyApjARTOWZXYAax4sS4idLDuEcs1jbrJ/+MiVNhYkYyh13lmuPLPdrlvuuWq+uPt4CdDs2QrjLNWhlxcq1HxEYWf2szgBlYvzSUi5OuqVGu9H87jXuQdDB9+UnHMG7t61n2qh7dHY1XFG+suA/vMhgETMqisjJzUFnbpF3lCnvRNDa/oeuNmsxJzXEUY4NICGA217DIKYzRBvaNQ6XJN7PqXq4eiWVP6WCNCPcjFFqK0++XXPSbgXsEq1XJxpjN5NhBUc6bfemNu7n5qOyW31M3xmHKIqS9/zIQ8aFyrmcEcb8uSI12yoRtGRa7IwC4DZ775fJYmOELBJO6bgN+6ZD2h4vUhp7RKj+tuWv2fo0CgM0581+gQJaisQwEjX3NQpz/EF6KWQx59uYLLgR4LXoVo2c48TVegn/SgJKZu6LtIMjvz8tUAKZ+8zqCW9ONnq1GxLAmbWSq6qrULmd+zrZnF+JD5op86CJsOZZf4vSpxwN+rEVDlgSN9l0pUfdiEu36Leib/Wp1kTmp2VldINdt/VBZp6BftkJnEc13gwv+O1a3F
 FRsCOv+7
 53k4051biFtDjgbrJvPh0Fw4kWgdUUOl3YZIn41T6ssqBuUYH4HlexvbsxlFE5U8h4yV1ImucTZGrdaTugY9A1czpMMI/hmZ3lmz2r8czWtgjOBl/t5LgXZsiBkGsZ6hfK48RxU9cK/M2wb0G8w+MkWPYHw+s3ypNIcRbSE0ZE3MHpjY7KBNXdgtb/f9j2C/C7ooGoWe346jCWw+5ihFWKPRf0iQvQFTmn+etDRbe08pthvifFuIaV48ey5DCN/5i0/vpu8/2mhR3NbqIxKWr+IlCjD900w3UU74bK0zUfgUu5W/JWBL5Hyh3+fvkfq7yGhJbEWTm+3+3uUKAbtFpPviMrd415/PuJLB1+AZ+43QkQK2nkXta/c/ZGhWKgJeClAwTFYJUFAivsmxezb2ygcz6n86uEspJJ6bQm6jpqgSqwvl2GF0yW5O8UZAGg9PBDmUqdvzWa8II/Bg7vqsvic9tuUzINIYo64a8tIq2Q3BjaNyuo3FnYSb3N0BI+djZTC2Y/BygF/Ndw0M=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

--0000000000000af317063bb95818
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Aug 5, 2025 at 2:08=E2=80=AFPM David Hildenbrand <david@redhat.com>=
 wrote:
>
> On 05.08.25 18:57, Juan Yescas wrote:
> > On Tue, Aug 5, 2025 at 2:58=E2=80=AFAM David Hildenbrand <david@redhat.=
com>
wrote:
> >>
> >> On 05.08.25 03:22, Juan Yescas wrote:
> >>> On Mon, Aug 4, 2025 at 11:50=E2=80=AFAM David Hildenbrand <david@redh=
at.com>
wrote:
> >>>>
> >>>> On 04.08.25 20:20, Juan Yescas wrote:
> >>>>> Hi David/Zi,
> >>>>>
> >>>>> Is there any reason why the MIGRATE_CMA pages are not in the PCP
lists?
> >>>>>
> >>>>> There are many devices that need fast allocation of MIGRATE_CMA
pages,
> >>>>> and they have to get them from the buddy allocator, which is a bit
> >>>>> slower in comparison to the PCP lists.
> >>>>>
> >>>>> We also have cases where the MIGRATE_CMA memory requirements are
big.
> >>>>> For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to
500MiBs.
> >>>>> These cases would benefit if we have THPs for CMAs.
> >>>>>
> >>>>> Could we add the support for MIGRATE_CMA pages on the PCP and THP
lists?
> >>>>
> >>>> Remember how CMA memory is used:
> >>>>
> >>>> The owner allocates it through cma_alloc() and friends, where the CM=
A
> >>>> allocator will try allocating *specific physical memory regions*
using
> >>>> alloc_contig_range(). It doesn't just go ahead and pick a random CMA
> >>>> page from the buddy (or PCP) lists. Doesn't work (just imagine havin=
g
> >>>> different CMA areas etc).
> >>>>
> >>>> Anybody else is free to use CMA pages for MOVABLE allocations. So we
> >>>> treat them as being MOVABLE on the PCP.
> >>>>
> >>>> Having a separate CMA PCP list doesn't solve or speedup anything,
really.
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
https://lore.kernel.org/lkml/cover.1604282969.git.cgoldswo@codeaurora.org/T=
/#u
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
upstream:
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
> >> One concern is that a steady stream of short-term pinnings can turn
such
> >> pages unmovable. We discussed ideas on how to handle that, but there i=
s
> >> no solution upstream yet.
> >
> > Are there any plans to continue the discussion? Is it in the priority
> > list?
>
(Resending, sorry, I forgot to send it as Plain text)

> Ohh, it's somewheeeeeere on the todo list :)
>
> Do you (or one of your colleagues) have capacity to work on that?

We are interested in fixing it. My team can begin work on the solution in
early November.

> One
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

Thanks David, we'll do.

> --
> Cheers,
>
> David / dhildenb
>

--0000000000000af317063bb95818
Content-Type: text/html; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

<div dir=3D"ltr">On Tue, Aug 5, 2025 at 2:08=E2=80=AFPM David Hildenbrand &=
lt;<a href=3D"mailto:david@redhat.com">david@redhat.com</a>&gt; wrote:<br>&=
gt;<br>&gt; On 05.08.25 18:57, Juan Yescas wrote:<br>&gt; &gt; On Tue, Aug =
5, 2025 at 2:58=E2=80=AFAM David Hildenbrand &lt;<a href=3D"mailto:david@re=
dhat.com">david@redhat.com</a>&gt; wrote:<br>&gt; &gt;&gt;<br>&gt; &gt;&gt;=
 On 05.08.25 03:22, Juan Yescas wrote:<br>&gt; &gt;&gt;&gt; On Mon, Aug 4, =
2025 at 11:50=E2=80=AFAM David Hildenbrand &lt;<a href=3D"mailto:david@redh=
at.com">david@redhat.com</a>&gt; wrote:<br>&gt; &gt;&gt;&gt;&gt;<br>&gt; &g=
t;&gt;&gt;&gt; On 04.08.25 20:20, Juan Yescas wrote:<br>&gt; &gt;&gt;&gt;&g=
t;&gt; Hi David/Zi,<br>&gt; &gt;&gt;&gt;&gt;&gt;<br>&gt; &gt;&gt;&gt;&gt;&g=
t; Is there any reason why the MIGRATE_CMA pages are not in the PCP lists?<=
br>&gt; &gt;&gt;&gt;&gt;&gt;<br>&gt; &gt;&gt;&gt;&gt;&gt; There are many de=
vices that need fast allocation of MIGRATE_CMA pages,<br>&gt; &gt;&gt;&gt;&=
gt;&gt; and they have to get them from the buddy allocator, which is a bit<=
br>&gt; &gt;&gt;&gt;&gt;&gt; slower in comparison to the PCP lists.<br>&gt;=
 &gt;&gt;&gt;&gt;&gt;<br>&gt; &gt;&gt;&gt;&gt;&gt; We also have cases where=
 the MIGRATE_CMA memory requirements are big.<br>&gt; &gt;&gt;&gt;&gt;&gt; =
For example, GPUs need MIGRATE_CMA memory in the ranges of 30MiB to 500MiBs=
.<br>&gt; &gt;&gt;&gt;&gt;&gt; These cases would benefit if we have THPs fo=
r CMAs.<br>&gt; &gt;&gt;&gt;&gt;&gt;<br>&gt; &gt;&gt;&gt;&gt;&gt; Could we =
add the support for MIGRATE_CMA pages on the PCP and THP lists?<br>&gt; &gt=
;&gt;&gt;&gt;<br>&gt; &gt;&gt;&gt;&gt; Remember how CMA memory is used:<br>=
&gt; &gt;&gt;&gt;&gt;<br>&gt; &gt;&gt;&gt;&gt; The owner allocates it throu=
gh cma_alloc() and friends, where the CMA<br>&gt; &gt;&gt;&gt;&gt; allocato=
r will try allocating *specific physical memory regions* using<br>&gt; &gt;=
&gt;&gt;&gt; alloc_contig_range(). It doesn&#39;t just go ahead and pick a =
random CMA<br>&gt; &gt;&gt;&gt;&gt; page from the buddy (or PCP) lists. Doe=
sn&#39;t work (just imagine having<br>&gt; &gt;&gt;&gt;&gt; different CMA a=
reas etc).<br>&gt; &gt;&gt;&gt;&gt;<br>&gt; &gt;&gt;&gt;&gt; Anybody else i=
s free to use CMA pages for MOVABLE allocations. So we<br>&gt; &gt;&gt;&gt;=
&gt; treat them as being MOVABLE on the PCP.<br>&gt; &gt;&gt;&gt;&gt;<br>&g=
t; &gt;&gt;&gt;&gt; Having a separate CMA PCP list doesn&#39;t solve or spe=
edup anything, really.<br>&gt; &gt;&gt;&gt;&gt;<br>&gt; &gt;&gt;&gt;<br>&gt=
; &gt;&gt;&gt; Thanks David for the quick overview.<br>&gt; &gt;&gt;&gt;<br=
>&gt; &gt;&gt;&gt;&gt; I still have no clue what this patch here tried to s=
olve: it doesn&#39;t<br>&gt; &gt;&gt;&gt;&gt; make any sense.<br>&gt; &gt;&=
gt;&gt;&gt;<br>&gt; &gt;&gt;&gt;<br>&gt; &gt;&gt;&gt; The story started wit=
h this out of tree patch that is part of Android.<br>&gt; &gt;&gt;&gt;<br>&=
gt; &gt;&gt;&gt; <a href=3D"https://lore.kernel.org/lkml/cover.1604282969.g=
it.cgoldswo@codeaurora.org/T/#u">https://lore.kernel.org/lkml/cover.1604282=
969.git.cgoldswo@codeaurora.org/T/#u</a><br>&gt; &gt;&gt;&gt;<br>&gt; &gt;&=
gt;&gt; This patch introduced the __GFP_CMA flag that allocates pages from<=
br>&gt; &gt;&gt;&gt; MIGRATE_MOVABLE<br>&gt; &gt;&gt;&gt; or MIGRATE_CMA. W=
hat it happens then, it is that the MIGRATE_MOVABLE<br>&gt; &gt;&gt;&gt; pa=
ges in the<br>&gt; &gt;&gt;&gt; PCP lists were consumed pretty fast. To sol=
ve this issue, the PCP<br>&gt; &gt;&gt;&gt; MIGRATE_CMA list was added.<br>=
&gt; &gt;&gt;&gt; This list is initialized by rmqueue_bulk() when it is emp=
ty. That&#39;s<br>&gt; &gt;&gt;&gt; how we end up with the PCP MIGRATE_CMA =
list<br>&gt; &gt;&gt;&gt; in Android. In addition to this, the THP list for=
 MIGRATE_MOVABLE was<br>&gt; &gt;&gt;&gt; allowed to contain<br>&gt; &gt;&g=
t;&gt; MIGRATE_CMA pages. This is causing THP MIGRATE_CMA pages to be used<=
br>&gt; &gt;&gt;&gt; for THP MIGRATE_MOVABLE<br>&gt; &gt;&gt;&gt; making la=
ter allocations from THP MIGRATE_CMA to fail.<br>&gt; &gt;&gt;<br>&gt; &gt;=
&gt; Okay, so this patch here really is not suitable for the upstream kerne=
l<br>&gt; &gt;&gt; as is. It&#39;s purely targeted at the OOT Android patch=
.<br>&gt; &gt;&gt;<br>&gt; &gt; Right, it is a temporary solution for the p=
inned MIGRATE_CMA pages.<br>&gt; &gt;<br>&gt; &gt;&gt;&gt;<br>&gt; &gt;&gt;=
&gt; These workarounds are mainly because we need to solve this issue upstr=
eam:<br>&gt; &gt;&gt;&gt;<br>&gt; &gt;&gt;&gt; - When devices reserve big b=
locks of MIGRATE_CMA pages, the<br>&gt; &gt;&gt;&gt; underutilized MIGRATE_=
CMA<br>&gt; &gt;&gt;&gt; can fall back to MIGRATE_MOVABLE and these pages c=
an be pinned, so if<br>&gt; &gt;&gt;&gt; we require MIGRATE_CMA<br>&gt; &gt=
;&gt;&gt; pages, the allocations might fail.<br>&gt; &gt;&gt;&gt;<br>&gt; &=
gt;&gt;&gt; I remember that you presented the problem in LPC. Were you able=
 to<br>&gt; &gt;&gt;&gt; make some progress on that?<br>&gt; &gt;&gt;<br>&g=
t; &gt;&gt; There is the problem of CMA pages getting allocated by someone =
for a<br>&gt; &gt;&gt; MOVABLE allocation, to then short-term pin it for DM=
A. Long-term<br>&gt; &gt;&gt; pinnings are disallowed (we just recently fix=
ed a bug where we<br>&gt; &gt;&gt; accidentally allowed it).<br>&gt; &gt;&g=
t;<br>&gt; &gt; Nice, it is great the issue got caught and fixed upstream :=
)<br>&gt; &gt;<br>&gt; &gt;&gt; One concern is that a steady stream of shor=
t-term pinnings can turn such<br>&gt; &gt;&gt; pages unmovable. We discusse=
d ideas on how to handle that, but there is<br>&gt; &gt;&gt; no solution up=
stream yet.<br>&gt; &gt;<br>&gt; &gt; Are there any plans to continue the d=
iscussion? Is it in the priority<br>&gt; &gt; list?<br>&gt;<div>(Resending,=
 sorry, I forgot to send it as Plain text)</div><div><br>&gt; Ohh, it&#39;s=
 somewheeeeeere on the todo list :)<br>&gt;<br>&gt; Do you (or one of your =
colleagues) have capacity to work on that?</div><div><br></div><div>We are =
interested in fixing=C2=A0it. My team can begin work on the solution in ear=
ly November.</div><div><br></div><div>&gt; One<br>&gt; idea was to flag fol=
ios as &quot;pending on migration&quot; and disallow any<br>&gt; further sh=
ort-term pins until migration is done. IIRC, there were other<br>&gt; ideas=
 (e.g., isolated pageblock).<br>&gt;</div><div><br></div><div><div>Thanks f=
or the pointers, I&#39;ll take a look at that.</div><span class=3D"gmail-im=
" style=3D"color:rgb(80,0,80)"><div><br></div></span></div><div>&gt; &gt; M=
aybe<br>&gt; &gt; a topic we can discuss in LPC Japan?<br>&gt;<br>&gt; Soun=
ds good, feel free to propose this as a topic. I wills end out the<br>&gt; =
announcement of the MM MC probably next week.<br>&gt;</div><div><br></div><=
div>Thanks David, we&#39;ll do.=C2=A0</div><div><br>&gt; --<br>&gt; Cheers,=
<br>&gt;<br>&gt; David / dhildenb<br>&gt;<br></div></div>

--0000000000000af317063bb95818--

