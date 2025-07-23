Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1595AC83F27
	for <linux-mm@archiver.kernel.org>; Wed, 23 Jul 2025 02:36:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FFAF6B0093; Tue, 22 Jul 2025 22:36:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B0E96B0095; Tue, 22 Jul 2025 22:36:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49F916B0096; Tue, 22 Jul 2025 22:36:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 375096B0093
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 22:36:08 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9A5DC1128E3
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 02:36:07 +0000 (UTC)
X-FDA: 83693964774.14.B488532
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf12.hostedemail.com (Postfix) with ESMTP id C8F264000A
	for <linux-mm@kvack.org>; Wed, 23 Jul 2025 02:36:04 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yYeu7208;
	spf=pass (imf12.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753238164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I6IlyFOsklORK9gDxVwJBZ59bc5C+izWBIvmcxqDgPc=;
	b=sFz/J5st43ArTTxuQFdME6BPSVlICj18Ar+cpGbjHAvg+QqhTmLcOssbWyTaIPbTBsfJST
	KHKXSn55k5HgdaB809n4WdKc+DvoKf2dygj9DYYdh9xaahSSgtWEHjXCZfDvDlziqqZlPX
	BT9M460UIieSSa7BARW46X5OmYlJCwI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753238164; a=rsa-sha256;
	cv=none;
	b=7Z9cLG3cmyEqcT3ybyuvRPmsZRZ0yzg+4NtOD9N5DXpqMyF6YSAHsqhEZYfMQNhABQ1IQa
	qODGvZ92DsuGnGI3ydbfZcThPO7HWOQTs8tHDk7Thv9PzfzmsoReU+Brd4x9lp/QccWcJ/
	lwC6DAVPSnfA3NIcJ9iMkkY3Pk2MHG8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=yYeu7208;
	spf=pass (imf12.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3122368d7c4so5240536a91.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:36:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753238163; x=1753842963; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=I6IlyFOsklORK9gDxVwJBZ59bc5C+izWBIvmcxqDgPc=;
        b=yYeu7208/E+qjB4HJ7AWYS2yePwSdaUZkpqyz+df6Dj/D8YMuSzwWuTkI4iCfBTnYb
         xX8s5vNWsOsEYcDvbXmfu04ambFL1EGNqd344I76ZbaK+kqgYJGVch1nvMfPtXVIiTDD
         W/VEzUSnAV0bMa+JPg/um8Dhi845k8R9Oj7TCVc78t0ubVlpFMPZ5lWxQaT5dEBElUwL
         CBISh+Gm4utUkMNF3mDgsyMBNo5JPcKNgQk2vW1V4X35E/dqW/rn5Ci6HuNP1c0kJaxu
         nvmlY7mlfesqFEDt/fpdqyP6Gj4KrBU0Mg4IJXNi27IcRns/CAd3I1DWaDIERQ6Pih0n
         dOeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753238163; x=1753842963;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=I6IlyFOsklORK9gDxVwJBZ59bc5C+izWBIvmcxqDgPc=;
        b=piP6+cHXzTwM5S/ERUUL1LNCwq959qM78Z4mN4F+BNnkNDnDeVET5Y0bndoA0LfOx4
         Vbk0L744L3EbZ9pdMHBggPjsobbmQTG7PiiQ5cQBhxdquxj82IoevmmQuhVNxK6uACck
         M37+nLyEDRHn7FwqyeHHPzmf7VwTEyYeX+D2bEA1cX1s4K3f0F9pFKM1HtC7wYDCcV/f
         uI5E0Dvgi5+aHOWfftbZAszwNW0WCUxQDh8lYFxCUq0wVH+4nauGjXvQD7M3UYHCZOQj
         CWqlkIkzxH9wlSc1YAuQSBz/ZL5a42S3zWV4y1qqvhMdOADyIvIDqx6I9YV2vMuklTzS
         V9FQ==
X-Forwarded-Encrypted: i=1; AJvYcCUpJJPebYAGhWSBr6G0lmX4HU8MEwWLRLT8bOVdZRqY2FFAV8dAFTZ1Im7PcWAKUGYHyvJd8moovg==@kvack.org
X-Gm-Message-State: AOJu0Yz2hQdnziNtc32YyPag7xPOWc1LPXaV6tS9xuZAYHEm4bbwq1m+
	JFVlhgegqwBn1lMlrbyR6sAOBidFntW0enPY0BYdXO+QI5DyQ5JS1Dosa/BDdgYsvZtEKftkdxL
	i9Oh7XKpJoeEQQaMLCXmsTnMgZ606S+j6OE4fptgG
X-Gm-Gg: ASbGncv/H0WYYATXQGKb6iiVrfeeOAJNj4UbCYX3Jk8EC51/Mg3e+FAo+76mPezp8v8
	k+Y/7BdHFyG28r+xnAhqorue8OqqRH+vcoIFcHLsm6WpeX1m+fjQ6iKZ3Jq2RDDFzlE+nv4UUVp
	lm9C4IEpnFJSXEnJz2vjpuEzeQ6Yk45/SSL3Fg3JIUeO1xwtvemdn1Ig+kFF7s+pOHpOAr9dmHo
	N5IdLMv0w65fxf/F47xGccgHo0hEfi3M2HxiDde
X-Google-Smtp-Source: AGHT+IE/TvRzCIs9asOKjtXzPvSStPkY4vcjrq1vIuSRcDBkm4TXvsIuOsDApjUEP3e2xctvHjG7Ts5ac40QWu8hWJ0=
X-Received: by 2002:a17:90a:e183:b0:316:d69d:49fb with SMTP id
 98e67ed59e1d1-31e5076a6f7mr2538202a91.14.1753238163400; Tue, 22 Jul 2025
 19:36:03 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-14-kuniyu@google.com>
 <z7kkbenhkndwyghwenwk6c4egq3ky4zl36qh3gfiflfynzzojv@qpcazlpe3l7b>
 <CANn89iLg-VVWqbWvLg__Zz=HqHpQzk++61dbOyuazSah7kWcDg@mail.gmail.com>
 <jc6z5d7d26zunaf6b4qtwegdoljz665jjcigb4glkb6hdy6ap2@2gn6s52s6vfw>
 <CAAVpQUAJCLaOr7DnOH9op8ySFN_9Ky__easoV-6E=scpRaUiJQ@mail.gmail.com>
 <p4fcser5zrjm4ut6lw4ejdr7gn2gejrlhy2u2btmhajiiheoax@ptacajypnvlw>
 <CAAVpQUAk4F__D7xdWpt0SEE4WEM_-6V1P7DUw9TGaV=pxZ+tgw@mail.gmail.com>
 <xjtbk6g2a3x26sqqrdxbm2vxgxmm3nfaryxlxwipwohsscg7qg@64ueif57zont>
 <CAAVpQUAL09OGKZmf3HkjqqkknaytQ59EXozAVqJuwOZZucLR0Q@mail.gmail.com> <jmbszz4m7xkw7fzolpusjesbreaczmr4i64kynbs3zcoehrkpj@lwso5soc4dh3>
In-Reply-To: <jmbszz4m7xkw7fzolpusjesbreaczmr4i64kynbs3zcoehrkpj@lwso5soc4dh3>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 22 Jul 2025 19:35:52 -0700
X-Gm-Features: Ac12FXwhtXeBUII0bX8ILz_qr1B1fIfpOOkBNseRwEy-StMeZ8GsbYQQA6nLq7M
Message-ID: <CAAVpQUCv+CpKkX9Ryxa5ATG3CC0TGGE4EFeGt4Xnu+0kV7TMZg@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C8F264000A
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: jxq9dpmaic5w6frxchqyi9hhhe5c9i63
X-HE-Tag: 1753238164-655096
X-HE-Meta: U2FsdGVkX18UfbIn6cNc4Bas/f9Juev1wHuZTz6st3Rffj/8atLOHHuXHCw/Rf51cdUB9Ji2Qk4wzujaqkULi5vXpX9EjsSaLFiDoLWmpQIxnDqOS/MxORSMgQ1orTeWVxKUudIc89jJ85ExjxE30E+h3LP58xx5y8TjAKNb4UUYXZuVDdGXlxBd/+OtgFZTh/yZwIAHX2L9nEFodJcimOygCUft9h6AogAsYIwhIENZLRf5CHKUPPZzP1guRbLM6Cic8rxsbQdq1vAdUWsrZSBRi7WO0gX7gK9yyHJWWjd5e1dKAqerugDTjCGMFdUoVEu++PZeuG10CMC6q3Xm7bu4LRPAUVwbqYI7WyjuQ8u9bKwRTZWpG5XklYfHLx3TitGJe0ttsDLMWPgOXbj9uWvgyeR0bUyotHoU3mjFqOTj8WZGxtfFW6QTMyicTPM0sRLvHdRmZpjS8ur5g3dwf8Qc1VBhjyyOY0EwuR/oCH2M5lbaYflUsdWtcvP1bKeuUGUTph4K9eT/3m2Fg5MnEX5knTxid5wTpijcfw0bfvISUh771Dn3m9WbQzV2lTuv9fR8C+C+azbGAralqy6D75FT/H26KkOtMWdsNoB7pG25UOgKjbKh8reXEYKB6w8ME4IPkdlmoSLSSPCVx+lMHPd1I9/Jcspn9DpZHKuulCDvfTCOqbZJE1Ivy+E8hbvi37LU19v4dCHWP180mJThONqm/jb5qbJw+J9IHpNQnG5NOhBy8Fi1kGQrv14WUi+JUUuvVMUBpzAspCTr9JN0CNDyBwNOXsJ/XaGkQfcURNFgcoVzRZqrC7MgNu4pKP2mBIC9OCtuXrzooYfCz/NxrSY3syoOIZLlBkHe8IgiT0LhQrFboEHwOzZFbdZIl8p8Oyo3E9xeZedEFSGk5qyqRyPaRNAjovNB
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 5:29=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Jul 22, 2025 at 02:59:33PM -0700, Kuniyuki Iwashima wrote:
> > On Tue, Jul 22, 2025 at 12:56=E2=80=AFPM Shakeel Butt <shakeel.butt@lin=
ux.dev> wrote:
> > >
> > > On Tue, Jul 22, 2025 at 12:03:48PM -0700, Kuniyuki Iwashima wrote:
> > > > On Tue, Jul 22, 2025 at 11:48=E2=80=AFAM Shakeel Butt <shakeel.butt=
@linux.dev> wrote:
> > > > >
> > > > > On Tue, Jul 22, 2025 at 11:18:40AM -0700, Kuniyuki Iwashima wrote=
:
> > > > > > >
> > > > > > > I expect this state of jobs with different network accounting=
 config
> > > > > > > running concurrently is temporary while the migrationg from o=
ne to other
> > > > > > > is happening. Please correct me if I am wrong.
> > > > > >
> > > > > > We need to migrate workload gradually and the system-wide confi=
g
> > > > > > does not work at all.  AFAIU, there are already years of effort=
 spent
> > > > > > on the migration but it's not yet completed at Google.  So, I d=
on't think
> > > > > > the need is temporary.
> > > > > >
> > > > >
> > > > > From what I remembered shared borg had completely moved to memcg
> > > > > accounting of network memory (with sys container as an exception)=
 years
> > > > > ago. Did something change there?
> > > >
> > > > AFAICS, there are some workloads that opted out from memcg and
> > > > consumed too much tcp memory due to tcp_mem=3DUINT_MAX, triggering
> > > > OOM and disrupting other workloads.
> > > >
> > >
> > > What were the reasons behind opting out? We should fix those
> > > instead of a permanent opt-out option.
> > >
>
> Any response to the above?

I'm just checking with internal folks, not sure if I will follow up on
this though, see below.

>
> > > > >
> > > > > > >
> > > > > > > My main concern with the memcg knob is that it is permanent a=
nd it
> > > > > > > requires a hierarchical semantics. No need to add a permanent=
 interface
> > > > > > > for a temporary need and I don't see a clear hierarchical sem=
antic for
> > > > > > > this interface.
> > > > > >
> > > > > > I don't see merits of having hierarchical semantics for this kn=
ob.
> > > > > > Regardless of this knob, hierarchical semantics is guaranteed
> > > > > > by other knobs.  I think such semantics for this knob just comp=
licates
> > > > > > the code with no gain.
> > > > > >
> > > > >
> > > > > Cgroup interfaces are hierarchical and we want to keep it that wa=
y.
> > > > > Putting non-hierarchical interfaces just makes configuration and =
setup
> > > > > hard to reason about.
> > > >
> > > > Actually, I tried that way in the initial draft version, but even i=
f the
> > > > parent's knob is 1 and child one is 0, a harmful scenario didn't co=
me
> > > > to my mind.
> > > >
> > >
> > > It is not just about harmful scenario but more about clear semantics.
> > > Check memory.zswap.writeback semantics.
> >
> > zswap checks all parent cgroups when evaluating the knob, but
> > this is not an option for the networking fast path as we cannot
> > check them for every skb, which will degrade the performance.
>
> That's an implementation detail and you can definitely optimize it. One
> possible way might be caching the state in socket at creation time which
> puts some restrictions like to change the config, workload needs to be
> restarted.
>
> >
> > Also, we don't track which sockets were created with the knob
> > enabled and how many such sockets are still left under the cgroup,
> > there is no way to keep options consistent throughout the hierarchy
> > and no need to try hard to make the option pretend to be consistent
> > if there's no real issue.
> >
> >
> > >
> > > >
> > > > >
> > > > > >
> > > > > > >
> > > > > > > I am wondering if alternative approches for per-workload sett=
ings are
> > > > > > > explore starting with BPF.
> > > > > > >
> > > > >
> > > > > Any response on the above? Any alternative approaches explored?
> > > >
> > > > Do you mean flagging each socket by BPF at cgroup hook ?
> > >
> > > Not sure. Will it not be very similar to your current approach? Each
> > > socket is associated with a memcg and the at the place where you need=
 to
> > > check which accounting method to use, just check that memcg setting i=
n
> > > bpf and you can cache the result in socket as well.
> >
> > The socket pointer is not writable by default, thus we need to add
> > a bpf helper or kfunc just for flipping a single bit.  As said, this is
> > overkill, and per-memcg knob is much simpler.
> >
>
> Your simple solution is exposing a stable permanent user facing API
> which I suspect is temporary situation. Let's discuss it at the end.
>
> >
> > >
> > > >
> > > > I think it's overkill and we don't need such finer granularity.
> > > >
> > > > Also it sounds way too hacky to use BPF to correct the weird
> > > > behaviour from day0.
> > >
> > > What weird behavior? Two accounting mechanisms. Yes I agree but memcg=
s
> > > with different accounting mechanisms concurrently is also weird.
> >
> > Not that weird given the root cgroup does not allocate sk->sk_memcg
> > and are subject to the global tcp memory accounting.  We already have
> > a mixed set of memcgs.
>
> Running workloads in root cgroup is not normal and comes with a warning
> of no isolation provided.
>
> I looked at the patch again to understand the modes you are introducing.
> Initially, I thought the series introduced multiple modes, including an
> option to exclude network memory from memcg accounting. However, if I
> understand correctly, that is not the case=E2=80=94the opt-out applies on=
ly to
> the global TCP/UDP accounting. That=E2=80=99s a relief, and I apologize f=
or the
> misunderstanding.
>
> If I=E2=80=99m correct, you need a way to exclude a workload from the glo=
bal
> TCP/UDP accounting, and currently, memcg serves as a convenient
> abstraction for the workload. Please let me know if I misunderstood.

Correct.

Currently, memcg by itself cannot guarantee that memory allocation for
socket buffer does not fail even when memory.current < memory.max
due to the global protocol limits.

It means we need to increase the global limits to

(bytes of TCP socket buffer in each cgroup) * (number of cgroup)

, which is hard to predict, and I guess that's the reason why you
or Wei set tcp_mem[] to UINT_MAX so that we can ignore the global
limit.

But we should keep tcp_mem[] within a sane range in the first place.

This series allows us to configure memcg limits only and let memcg
guarantee no failure until it fully consumes memory.max.

The point is that memcg should not be affected by the global limits,
and this is orthogonal with the assumption that every workload should
be running under memcg.


>
> Now memcg is one way to represent the workload. Another more natural, at
> least to me, is the core cgroup. Basically cgroup.something interface.
> BPF is yet another option.
>
> To me cgroup seems preferrable but let's see what other memcg & cgroup
> folks think. Also note that for cgroup and memcg the interface will need
> to be hierarchical.

As the root cgroup doesn't have the knob, these combinations are
considered hierarchical:

(parent, child) =3D (0, 0), (0, 1), (1, 1)

and only the pattern below is not considered hierarchical

(parent, child) =3D (1, 0)

Let's say we lock the knob at the first socket creation like your
idea above.

If a parent and its child' knobs are (0, 0) and the child creates a
socket, the child memcg is locked as 0.  When the parent enables
the knob, we must check all child cgroups as well.  Or, we lock
the all parents' knobs when a socket is created in a child cgroup
with knob=3D0 ?  In any cases we need a global lock.

Well, I understand that the hierarchical semantics is preferable
for cgroup but I think it does not resolve any real issue and rather
churns the code unnecessarily.

