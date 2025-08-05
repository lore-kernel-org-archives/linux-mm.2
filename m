Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0536C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 16:46:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7244A6B00AD; Tue,  5 Aug 2025 12:46:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6D3366B00AE; Tue,  5 Aug 2025 12:46:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59BA96B00AF; Tue,  5 Aug 2025 12:46:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 454566B00AD
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:46:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E79B056977
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:46:45 +0000 (UTC)
X-FDA: 83743282770.02.51FD1D0
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1486480009
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 16:46:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r7UKUOEe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of jyescas@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754412404; a=rsa-sha256;
	cv=none;
	b=UNSs1R7hki+Vy1gBW4fRBWr8NgMHqIKtdUlNuuv/bS8JTxWbX7dudVMcsNbEsHH4ltWjyP
	cmwc/SfUShqAG/kPf+yTmhxujY/fSUKdbFnD4u1ZFDtNwTl4+aDyeEomusM5cWh1pCU+mW
	zuwTlH+Zu29sLnJw6u92jQxxJjeyLfs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=r7UKUOEe;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of jyescas@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=jyescas@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754412404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l0RxCTsXFF8391IAhRwoPNmaelsxs5V8yAF1l14fxkk=;
	b=KWi/Zo0lAKU3nKuaWD3UolVeHofpBLdnLpkcE/t1fJhRqMGlP43TNHsHigJdVk3/VePQyx
	Pqv7DLOikVxy44Ano5k4rzoMPVii/cMGB//bC7SRbQ6KC5SF5oricbBUZuc3mYY5I7sOdr
	Iqns/0J2oUN+pupI+ElKjSHE500+RCI=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-240708ba498so2565ad.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 09:46:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754412403; x=1755017203; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=l0RxCTsXFF8391IAhRwoPNmaelsxs5V8yAF1l14fxkk=;
        b=r7UKUOEeJXA5rDRugBIx8ymrrwaggjrnKT/Q6rK8nfDicidu/xzTjDnF17qWEOnDcC
         KHa2F6+yqvmABqar3Dn9kXdqR/62qH2o1PoPsU+DtYn7VYfYTTf+RdDW9DW1ibU8bfbf
         MGH92DmEP0MZ2ICPBwX4tqNdEhgv53EL4OXSZPZwSoXLSWXiFUX55klUMy+1IdIWA4kA
         tfJ3E0YIVU7Au05rHtoPFTChaxJJOlOXlTYS20JL+qdaT/iV8AYrA5EWeBL+snYL0Nux
         SoL5Oq1wKnl9bUOJLXxCN+TK1KY6vf4/AogtU9/YhSFW9e8ZnSBoiwrGph7V72eEywZX
         aNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754412403; x=1755017203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=l0RxCTsXFF8391IAhRwoPNmaelsxs5V8yAF1l14fxkk=;
        b=MrLmjbUmULHmhmbYIka/KfeiVGJsMlqyT2cUJIQnI9oyWKMuxpkUG9xo8eOMBq4yV2
         N2xOX3xbSwZTG6c9ZLRKzWSbqb4yVJzvWQqANbgzP7Vo8PTogWpxne+r07J/8ewwa+ZC
         B9f1QNk3FgktqcgfRNcFealRnJMOGUhZg3+UI47/F3AufJwNObma5+NRieaRxhYM6+O/
         RtO8MDZDuxPITCndvKzybhtitQ+ggQAiClX75/SjpvKEhWByT+Djii3d2ht+pB2QYKL3
         fOHnU+jA7eqVqlsf3NHzOEwUdbAa4aJsIVIbv59kHzW17uyW9krlCXgxEIr19iXichNS
         jDZA==
X-Forwarded-Encrypted: i=1; AJvYcCWLqrotA8xMQlrN5QHUUpF/I6QRx11KZX02CxRcgwLGQmhQLSDniQAoVM++MgV41ZaRyDAlh71mZg==@kvack.org
X-Gm-Message-State: AOJu0YyWFoFZyD+vKRU2K0VPehVs7/6efcS9JPr0sxlB+FBS2h1Q8GlC
	c0sDCNPlLm/ELJbypvlsg5ZbYSjBOf0wnDo+781oIxlqmjvDZKB0chrksK0sCgHUbND6ZGuxh3N
	qDE1dvwQDUIi7D6a7XuHQ8jhN1QEtN4fTYdnnCWlF
X-Gm-Gg: ASbGnct0QsXQ3R0ZNwy0PS6WVhXgR+VPXAC++UjqYKBxcaFLybowF6iQfEHO5xEcvWW
	EApE+aoTSPChV1SrXipk+F+5jEKMrbjJW9xvFd8VPnUZZxssPfilwKVo212ChUAtFfprVvj3ggm
	aLiOk9oZ4GCmfPOQXzi/loYHcje84a6QX5CqrqhENlyYxuoQZO3MLGk2SDm9Z8gGGVHb/skZE1X
	Gqsw+S/Pyh6wcFTZdAo16b88GKLM/GPrOj55yAm
X-Google-Smtp-Source: AGHT+IFbtH6J0AjO4QU4T/tefsfeSE0rL1OzSJr1N/DUHjvBaYU77HeoyM1+WKB2X0d+93TslMU104SV+ZAQGFLorx8=
X-Received: by 2002:a17:902:ea02:b0:234:afcf:d9e8 with SMTP id
 d9443c01a7336-2428e9ca60bmr3484235ad.7.1754412402595; Tue, 05 Aug 2025
 09:46:42 -0700 (PDT)
MIME-Version: 1.0
References: <CAJDx_rgzkZognxWzOXJ-ZxdTtUaM3FT6bmpkwxMz03XiX3fKAQ@mail.gmail.com>
 <d395b14a-9a84-4f25-b4f0-45e8500fc5fe@redhat.com> <CAJDx_rgrp1TpOt-iDcsSGRTL=qZZsK_dpKL1bSkyunPGcGXt5g@mail.gmail.com>
 <4566222d-6b91-4789-bdd6-61e3769f5dbf@suse.cz>
In-Reply-To: <4566222d-6b91-4789-bdd6-61e3769f5dbf@suse.cz>
From: Juan Yescas <jyescas@google.com>
Date: Tue, 5 Aug 2025 09:46:30 -0700
X-Gm-Features: Ac12FXy4BT6ZbkseE6fl0wteJa2HqcPFNTVMsUS4ZZOo4qkH5jwtMaLF9Pp-ohE
Message-ID: <CAJDx_rjxGff38aS_MBwgh6LpDqp6G4zjUvg6tr73KU0HYfGvXA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: Add PCP list for THP CMA
To: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>, akash.tyagi@mediatek.com, 
	Andrew Morton <akpm@linux-foundation.org>, angelogioacchino.delregno@collabora.com, 
	hannes@cmpxchg.org, Brendan Jackman <jackmanb@google.com>, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mediatek@lists.infradead.org, 
	Linux Memory Management List <linux-mm@kvack.org>, matthias.bgg@gmail.com, Michal Hocko <mhocko@suse.com>, 
	Suren Baghdasaryan <surenb@google.com>, wsd_upstream@mediatek.com, Zi Yan <ziy@nvidia.com>, 
	Kalesh Singh <kaleshsingh@google.com>, "T.J. Mercier" <tjmercier@google.com>, 
	Isaac Manjarres <isaacmanjarres@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 15i8nubx4dmracngq9x1q37wmmit9idr
X-Rspam-User: 
X-Rspamd-Queue-Id: 1486480009
X-Rspamd-Server: rspam02
X-HE-Tag: 1754412403-659365
X-HE-Meta: U2FsdGVkX1+HbUGiK9i+nH025vHsX2H7zik0n1LyOX2BPu/T9OX9wVvg6RIGLw0kAtDn9DTHL6CTc7DIhgDWZlq4jo3hcn6kTHhPxntsSsfNX18goHuWHXoM7YtkRKUGqRln+lcp15JjQrGmJq3u8Zl01OYZq5N/Yvyc9M+/X+WcaJUNWXrTc748SrA7/8Za6YRebk+/t28ylVoycILToq4uziQBkj5vxwH/Zn+fiIQ42SLTlNbJrvW1QeOCQ0BV1cmqIFPHUG/O7mGJDYKqos/SYr96e5IHB2d6CSNj6FPgep91dUN0K4aGzokWMMnz4o3Hv9jTRG8K4ils1OR6yL84XobpHKQGooeeyTfRnszFswosAoNDJxtrGnTsiRC9T/1haZr93Gz0dyHW2nQoGN0ojG6AscCAFdEgpAaSbFgfoSZSjeHFfJNYpuLm98eh649zM7xYUb6PxF6lE/Z6nIVS9OISlRdIcVzqZOipbnmmtEFbhC9hTnoixCIgGLi9DHfHI6cgotqLBTTQFd+WJS9J5dUOPkXsB6joOH/HUmx1b1TS57SFA0QDPpau/tIhBSbFbLrCtmRdXveTOO9tLM84uqjnz5DA2NerewKuvy+CYtGw/+ZKJDYp9QxOGzJelXOfAwP5lSCxLkkAqsxABQSnD08YJa7SaYLxuS/dZoWxyxnpeEZh9uXiF2P59Z8RYVKdT/+OwPctIiLWB1FUCSkyMxATs/AluiChElfYVuN/6OUiu4mQIwZF1J7/9n83DW6nddo6ojZOPsLW8XrIXZFNWGCiXS2w9iGditbDtbtbRHZscr50m1Ns+hieORRQg6aIfpoQtA9EIMKaETDv2C31G/wpZF+5V6KEakg0sySTxeydmNr061I5LkyPyNYA8Jyd7eqLWj6ZHYlX10CFhXCTh2mNEgUi88ipWjARZUWnpBGIthCn0kDoKVxxOwKi2rnulAP79v8QKEbx/hd
 IyrKIcgN
 +0KmlPfi5QSESD3h7da7nj0CEVfutrYQpFH0Kimar+fmAUQa0fxjrcB8R3DcYsoY0e/PyfxIRx5xrTeYqaztSl5VbnKZNZQY/47LOdEq0iG1CmuxP3gG9DWlkjrbUZ6LxCCdl0VR4aREmBY8jzsuDBWdY96d+dqx6/X+sfBtFq9zstMdsgqlwuL5oa69I5qj+sWDxZ0+f8+p/vRmGl2XVDw5ORFF6uE9FByAgyexayqlGhao7FEutSGActeuIE5hvGEOAvy1DWaA4bCD3mwHnDJwiCtKxXiN0/GdIe4B7nVD83fxMl+nCSX3Ilf5voz6OCkYQP3QU+CqsazyTJm3A7wb+N85k6NKLPx9P/zdVR3lYfGIxy3y1lf0swyNAN3Ek54ebO45QZLWQdBpyb8r/NHqTaMzhjuPB2iBY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 2:52=E2=80=AFAM Vlastimil Babka <vbabka@suse.cz> wro=
te:
>
> On 8/5/25 3:22 AM, Juan Yescas wrote:
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
> > or MIGRATE_CMA.
>
> What kinds of allocations would then use __GFP_CMA? (let me try guess
> one - zswap backend?)
>
> > What it happens then, it is that the MIGRATE_MOVABLE
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
> If you don't want THP's to use the large (THP-sized) MIGRATE_CMA pages,
> what kind of such large allocations would be ok to use MIGRATE_CMA then?

The large THP MIGRATE_CMA allocs are used by GPUs or devices that require
large chunks of memory (have many cameras for example).


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
> >
> > Thanks
> > Juan
> >
> >
> >
> >
> >
> >> --
> >> Cheers,
> >>
> >> David / dhildenb
> >>
>

