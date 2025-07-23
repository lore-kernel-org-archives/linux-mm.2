Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 500C8C83F1A
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 18:06:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E341C8E0039; Wed, 23 Jul 2025 14:06:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DDD858E0002; Wed, 23 Jul 2025 14:06:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCCBC8E0039; Wed, 23 Jul 2025 14:06:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC5D68E0002
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 14:06:29 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5E2C48013B
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:06:29 +0000 (UTC)
X-FDA: 83696309298.26.CFCD4F0
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 96262A0009
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 18:06:27 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jDYsP7Wq;
	spf=pass (imf25.hostedemail.com: domain of kuniyu@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753293987;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nRVhbn5cd2Y+Qqs2piA5lEzyVD0l4Fs2Eu31USQDCPI=;
	b=ittqca02p/O9bt04rS5201qsyKoOzegMhLmg4InWECv4PUEf6Dymd0yytKpMhNcH2BviRN
	iScx/fAB3Bvn8X9aS8OpmsTO3rsQ9sWC5KPPzD/Ibjt+Ts7AerHnEjskCMaDWTEYrrhVov
	fqk+P0HE6p+2nqVL/oPMavUB1y0AE0Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753293987; a=rsa-sha256;
	cv=none;
	b=lKvBQznR5qXha6gXV/8gmoqleMFgdb4I9gDCd5xnRzIvQZRjuXBIy7GMZWmi7NE69eMOLk
	0d1kCOJsXF2GwR3L+txoOc3AnXBQzSgtzRlLwijIeRHRY6iUa/6cAYdRrBK8MHgS+ZIOwD
	SN6u9ezRVdL04V0CTOcG/LX3AtE9R8o=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jDYsP7Wq;
	spf=pass (imf25.hostedemail.com: domain of kuniyu@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-23649faf69fso989615ad.0
        for <linux-mm@kvack.org>; Wed, 23 Jul 2025 11:06:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753293986; x=1753898786; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nRVhbn5cd2Y+Qqs2piA5lEzyVD0l4Fs2Eu31USQDCPI=;
        b=jDYsP7WqxMB/BgYHVaGsA/DXbdSgEUSHwZSBZ58w624LvP2577fctEsIF9p6mDqjTT
         gOqIX3LpQk2MJVatY3m9eb8bKTl1nThHuvXQaup1cMJS9mhYMs2RNj9rFg2UbH0+MnKE
         BExf3HxR1p5t0YgU1m8W8SH4yo9RgWcLrHdVFJIHAXSgp17ltfqThOskRgNOhOa7zthv
         74h5WbzT1DRHy5voE0xatD0rjOZ+vw8rLyW9LWC+girk8tlZRxrRDfgu8Cwf/WHLt1To
         0oyvtUF/372bHFz4Rkwf75VuKqwmIT05r7YsbMkqnMzMT1yhkZuTFEXBDKjHOt/fR14P
         QSqg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753293986; x=1753898786;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nRVhbn5cd2Y+Qqs2piA5lEzyVD0l4Fs2Eu31USQDCPI=;
        b=Pm4Wz5gfd9K81SWcHdwvoBw4uruB91R66xjiw2vwAxBUt66CwYk9Lcumzdj85jleGn
         /Ej1RGY2y6jj5exEw48003Bp77g7X8KnyRaITrae7TDWwRUF/g6DO39SdFOz1cRkDQWa
         taEkcSV/zTT3OH2JW0TI3OhegO2XUMkPxeUR/MglHmdsy1QDVUJDrRILprkYb6wnjjpJ
         RG7mZVDerAvumqfejMhdnPp5kCDv5eVzRFFFF6BTfV+STZ/SlThQJeRUVyg83lUULTEs
         oSTtKnh6BWyRlKraL7rq//LhsMuZZZQ8lE+VQBHzNF9Nz6DNT0ZdOoCgsWca8MJ7vLSt
         EIGQ==
X-Forwarded-Encrypted: i=1; AJvYcCWm1KZQkDj3jMLneEothWRuEkJkAzlMAt3UchvkF+auemMenznR8iSh6PybFnPD5LXOCFvRcHr9+Q==@kvack.org
X-Gm-Message-State: AOJu0Yzxw6+b9LFmQNVPMWArMuiI7lWIAn1UJ0EbSV0tzl7guP1KXVnd
	/o/t0iOaeQgj6drDCm/bPLfT6gX++sr+hiMFYJ1n+5BirU+p0EBU8Xxaq+RXEYXAvRBuUH7tssG
	q+BfHS1KYHqWgSXWuUVyhcA0dAKkKCxPJ2fgVqIFkesc1Uplh92efg/2ouoA=
X-Gm-Gg: ASbGncsp8ZU8KSyBH3GCgxHdDi8JTVRrrZLkGrp4zI/E0NwqNn/flUuXo1YIyuxY0Lp
	Yzbs4B+8AeUpw9oN65hVzBp5IkGYdXeLBljRUP4DnFyI+v5uaq5E6v0zcp9ptWIoZUIsXOHMEAT
	Abua2NW4h9hgUSwnxaZ4juLrkEirMhehvYK5vlaFPhH2JqZejmQVrgwwxK5V6jTqWvXAvPifgDa
	NYjiXKhGpkPMMyNyUrv4wcWevYd2sN1p0gfcA==
X-Google-Smtp-Source: AGHT+IGAS9GFi3JlMJlvgpwfxagLVOLIDfr/dpIzxSNzxoDY3Xq3bIbZBTFy9IfSvS1aU0XN3So/jgdBQSoP4rQIooc=
X-Received: by 2002:a17:903:fab:b0:23c:7b65:9b08 with SMTP id
 d9443c01a7336-23f9813aa74mr61580225ad.1.1753293986127; Wed, 23 Jul 2025
 11:06:26 -0700 (PDT)
MIME-Version: 1.0
References: <z7kkbenhkndwyghwenwk6c4egq3ky4zl36qh3gfiflfynzzojv@qpcazlpe3l7b>
 <CANn89iLg-VVWqbWvLg__Zz=HqHpQzk++61dbOyuazSah7kWcDg@mail.gmail.com>
 <jc6z5d7d26zunaf6b4qtwegdoljz665jjcigb4glkb6hdy6ap2@2gn6s52s6vfw>
 <CAAVpQUAJCLaOr7DnOH9op8ySFN_9Ky__easoV-6E=scpRaUiJQ@mail.gmail.com>
 <p4fcser5zrjm4ut6lw4ejdr7gn2gejrlhy2u2btmhajiiheoax@ptacajypnvlw>
 <CAAVpQUAk4F__D7xdWpt0SEE4WEM_-6V1P7DUw9TGaV=pxZ+tgw@mail.gmail.com>
 <xjtbk6g2a3x26sqqrdxbm2vxgxmm3nfaryxlxwipwohsscg7qg@64ueif57zont>
 <CAAVpQUAL09OGKZmf3HkjqqkknaytQ59EXozAVqJuwOZZucLR0Q@mail.gmail.com>
 <jmbszz4m7xkw7fzolpusjesbreaczmr4i64kynbs3zcoehrkpj@lwso5soc4dh3>
 <CAAVpQUCv+CpKkX9Ryxa5ATG3CC0TGGE4EFeGt4Xnu+0kV7TMZg@mail.gmail.com> <e6qunyonbd4yxgf3g7gyc4435ueez6ledshde6lfdq7j5nslsh@xl7mcmaczfmk>
In-Reply-To: <e6qunyonbd4yxgf3g7gyc4435ueez6ledshde6lfdq7j5nslsh@xl7mcmaczfmk>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 23 Jul 2025 11:06:14 -0700
X-Gm-Features: Ac12FXw7kOY6uM_dMo2JVrN3O4hsJfpqzeP9Oi1ZMcHl-QMNLbwpvpTS0-tYcwk
Message-ID: <CAAVpQUDMj_1p6sVeo=bZ_u34HSX7V3WM6hYG3wHyyCACKrTKmQ@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Eric Dumazet <edumazet@google.com>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 96262A0009
X-Stat-Signature: s7feddur5o1um193m4sdhs8tn4ma311e
X-Rspam-User: 
X-HE-Tag: 1753293987-342018
X-HE-Meta: U2FsdGVkX1+Preh+/27Y9JrDIGp/BskfWWhI2+H1QJVYvOSmyr45LpK5Xq8vo8IhBIkEulSi79fKbtoOZ6KHMqg+OnU0dlv/Z6bh0f0K5r73CoD3h7VCS27nx1HunReisRo3S+s79HRLFxR36mvn+MO4iNogQu9T12ifW/wghh8wt8GNgo2tT8SVWW1qLSpfhLGZc3jHVtIiQU1QsqwA4zaTCg45gGh+vRcuKkPdG6lONqNTld8HGQN2rl78+OaWRzIfh/YjA8dgKvUZFi5qqh4tHG4ErAFJCcK1958QwgwmpblOC7s08aQH6b/TLzqBz4KMloBsx8QQ9iIHMuG6UM/wnUenzlcbuhngbBcbrMy4FjJrswzW1xTNRXoQUftbCCsv6ZRLNyb/4QQLOdMw74HcGoWFO5gHXEMACCHKKhxXj2q4EA3K3K4oZgUJ4BtP3WCgadRuzpCZg65uPp36ze9AqCWEJy2ehxk5mTXwLkimYMJ3Sx8AqU0Yp31NJJ5SgyBIX6XjxlCfRazANxAMs1my8Iev6YLS9T3PUAvC2ysyiKj4H9PvlpVnjf9v6OzBFmp/8JSLaGLVXYBUJeEiVWmE9ACs/ehphfen40GEGFZJv+U5r9RQC1ecT5BgTRQWOeH97c6J1/MvGjTfLps5g+zn4vRzJCVX9qPipQa1RixK7895kXCTtd0wF7p/0be0p/y2gheovHFz2dufvS/VH/+demd840QN+lL25kpSueJ7vFYyOEfxhsGj4Oi0OxbLMT2ksnvzBYDcYbD3cxXrI5RZyIYyJ8YO0S4DO5LarjIbNDIRfrLTE2rrWSOxt1a57R7CnXFOrhpH0a+kI0nWkPV65dO4mrocsXLIKprBmGuEkKRVbLxgpEXfRvCjtHsR0o7CMNLafjIdINDBU/fit3eUv+HBTMY9
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 23, 2025 at 10:28=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> Cc Tejun & Michal to get their opinion on memcg vs cgroup vs BPF
> options.
>
> On Tue, Jul 22, 2025 at 07:35:52PM -0700, Kuniyuki Iwashima wrote:
> [...]
> > >
> > > Running workloads in root cgroup is not normal and comes with a warni=
ng
> > > of no isolation provided.
> > >
> > > I looked at the patch again to understand the modes you are introduci=
ng.
> > > Initially, I thought the series introduced multiple modes, including =
an
> > > option to exclude network memory from memcg accounting. However, if I
> > > understand correctly, that is not the case=E2=80=94the opt-out applie=
s only to
> > > the global TCP/UDP accounting. That=E2=80=99s a relief, and I apologi=
ze for the
> > > misunderstanding.
> > >
> > > If I=E2=80=99m correct, you need a way to exclude a workload from the=
 global
> > > TCP/UDP accounting, and currently, memcg serves as a convenient
> > > abstraction for the workload. Please let me know if I misunderstood.
> >
> > Correct.
> >
> > Currently, memcg by itself cannot guarantee that memory allocation for
> > socket buffer does not fail even when memory.current < memory.max
> > due to the global protocol limits.
> >
> > It means we need to increase the global limits to
> >
> > (bytes of TCP socket buffer in each cgroup) * (number of cgroup)
> >
> > , which is hard to predict, and I guess that's the reason why you
> > or Wei set tcp_mem[] to UINT_MAX so that we can ignore the global
> > limit.
>
> No that was not the reason. The main reason behind max tcp_mem global
> limit was it was not needed

but the global limit did take place thus you had to set tcp_mem
to unlimited.

> as memcg should account and limit the
> network memory.
> I think the reason you don't want tcp_mem global limit
> unlimited now is

memcg has been subject to the global limit from day 0.

And note that not every process is under memcg with memory.max
configured.


> you have internal feature to let workloads opt out of
> the memcg accounting of network memory which is causing isolation
> issues.
>
> >
> > But we should keep tcp_mem[] within a sane range in the first place.
> >
> > This series allows us to configure memcg limits only and let memcg
> > guarantee no failure until it fully consumes memory.max.
> >
> > The point is that memcg should not be affected by the global limits,
> > and this is orthogonal with the assumption that every workload should
> > be running under memcg.
> >
> >
> > >
> > > Now memcg is one way to represent the workload. Another more natural,=
 at
> > > least to me, is the core cgroup. Basically cgroup.something interface=
.
> > > BPF is yet another option.
> > >
> > > To me cgroup seems preferrable but let's see what other memcg & cgrou=
p
> > > folks think. Also note that for cgroup and memcg the interface will n=
eed
> > > to be hierarchical.
> >
> > As the root cgroup doesn't have the knob, these combinations are
> > considered hierarchical:
> >
> > (parent, child) =3D (0, 0), (0, 1), (1, 1)
> >
> > and only the pattern below is not considered hierarchical
> >
> > (parent, child) =3D (1, 0)
> >
> > Let's say we lock the knob at the first socket creation like your
> > idea above.
> >
> > If a parent and its child' knobs are (0, 0) and the child creates a
> > socket, the child memcg is locked as 0.  When the parent enables
> > the knob, we must check all child cgroups as well.  Or, we lock
> > the all parents' knobs when a socket is created in a child cgroup
> > with knob=3D0 ?  In any cases we need a global lock.
> >
> > Well, I understand that the hierarchical semantics is preferable
> > for cgroup but I think it does not resolve any real issue and rather
> > churns the code unnecessarily.
>
> All this is implementation detail and I am asking about semantics. More
> specifically:
>
> 1. Will the root be non-isolated always?

Yes, because the root cgroup doesn't have memcg.
Also, the knob has CFTYPE_NOT_ON_ROOT.


> 2. If a cgroup is isolated, does it mean all its desendants are
>    isolated?

No, but this is because we MUST think about how we handle
the scenario above that (parent, child) =3D (0,0) becomes (1, 0).

We cannot think about the semantics without implementation
detail.  And if we allow such scenario, the hierarchical semantics
is fake and has no meaning.


> 3. Will there ever be a reasonable use-case where there is non-isolated
>    sub-tree under an isolated ancestor?

I think no, but again, we need to think about the scenario above,
otherwise, your ideal semantics is just broken.

Also, "no reasonable scenario" does not always mean "we must
prevent the scenario".

If there's nothing harmful, we can just let it be, especially if such
restriction gives nothing andrather hurts performance with no
good reason.


>
> Please give some thought to the above (and related) questions.

Please think about the implementation detail and if its trade-off
(just keeping semantics vs code churn & perf regression) makes
really sense.


>
> I am still not convinced that memcg is the right home for this opt-out
> feature. I have CCed cgroup folks to get their opinion as well.

