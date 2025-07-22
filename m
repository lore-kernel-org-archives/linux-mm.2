Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 84F56C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 21:59:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA8D48E0006; Tue, 22 Jul 2025 17:59:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C806B8E0001; Tue, 22 Jul 2025 17:59:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BBD558E0006; Tue, 22 Jul 2025 17:59:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id AEFDA8E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 17:59:48 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0C5D3593D2
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 21:59:48 +0000 (UTC)
X-FDA: 83693268456.24.F553BCD
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2C67220002
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 21:59:45 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eQbmiBJV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753221586;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LldVhMiyy8Uo7zeXym650NXpGCC96+eEkfNEoQyfQ7Q=;
	b=0TPP/1aBQV66VkmnLOy9eJ/v6Td69IfnzPl8esAbxSf0x9YY7GjCSIjkMol/RDzM2WvvUz
	T5Oxvs6OfWaq1FcIWIX0UI+PD78VbYJ/bdwcUzSRE9Hxooasjq0oeXiQlXFgy4guLVCM7M
	+gTe9oUTXP4Nkx6TBx8vAgcDo7JwdFw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753221586; a=rsa-sha256;
	cv=none;
	b=MeuXVuoOpDwJ7jlGqGJV1+baBRbDfNd7466kxVqZfzHSEf2RmnLUKuSPoWvp/CoREaAnUQ
	aIzq2o5AJ0YSR25YXrfmsRPNpv9JgHxXVBHJZYL1m9r/alYP1ESLQLjzjtNGwkliKPInSq
	CIF7INNKfDdrkjpqFNJZPEQ5XeKPB6g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=eQbmiBJV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.49 as permitted sender) smtp.mailfrom=kuniyu@google.com
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-31a93a4b399so327272a91.0
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:59:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753221585; x=1753826385; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LldVhMiyy8Uo7zeXym650NXpGCC96+eEkfNEoQyfQ7Q=;
        b=eQbmiBJVvxXAosfMmYtUc5d8h6CO66RXsELyjLHQZ8N4wK9aXmpJ5x/h3J29Zpa0AH
         fT8sehOGz4RBUPI3vOv0bZZXng3xnmDjXYFw0A1PhWt05Aftz6mYEbkTm3LXCTeOPaPq
         UJXXNxBE4X//40k9/MqnZP2cTFnh75VLwIedmNGSX4mmGOBFbGBKNEFJurgCE6r4wnud
         rKggBvBHyWlWg0Z+oo3Eedbu/yZ6fzHpp4mVbcuurtR+eCNcDZgJHmgmDEiFz3TYB/61
         eE9dx630kXB9q1ihvzqaIsZzoFT0427nBJHc15heOyI5hEe92UDTLpOh+hr5jycArtfk
         +7qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753221585; x=1753826385;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LldVhMiyy8Uo7zeXym650NXpGCC96+eEkfNEoQyfQ7Q=;
        b=nrpu4TN3gRnHL6BeDkuHQOGosOaZTU/Pa55IQ+tdEfz2E7nGGuwNhDnS0XTZukD8+i
         HPxGZEhl7clzawyyVmLHhSprqZv8EUUZ09A1pzucMPZkwWIw/3X3l3Lof6lRQhkvTJ6c
         YjTJBiVC1eCPQpUT6/qsH4k5aQI+BaEdhBtstUjos+rYKvXE5dRrBYifwliIQPh8SRzB
         JL5jwI2ZgZUTQPXV/GXbJl+K920I/j/a70K9SO9gKUEqrX17asqqXgWPp2VUPchS+Lz2
         pqf7mzAalWiHIFKwwTyu3eXUYiv81r48NzUHRkGTP8NLleaRURkqCVSU7tr0G+9vk0CJ
         mE3w==
X-Forwarded-Encrypted: i=1; AJvYcCUNJtSTPWJWt7MVkPs1J8Aku6B224iLUwthDgd1ESGyF4rWklr+Qg74UiwbS1bzBf1iaQjxjebf4Q==@kvack.org
X-Gm-Message-State: AOJu0YxKu1jD3v8X4vSj39Ff64dxnVES8ux7hmnwP+DKA5xUNy7hfvb6
	RpFuyTO2x+MIMeHrnjFeZLaU9mxzM4wqLz3eY32g+QhgqtK2nvlbJfaEVYfolLIdc7B+tuj8XET
	pQfN6mDsDHMfGZtgg1GKFYIVObm76aQg3CHY9qPk6
X-Gm-Gg: ASbGncvXsG69puyV630a85K1KPedQnplj9wqJCnkWoZ1bbY/dKNn/cj0p8/AHo05U6o
	q4M6WB04CRqCawDWqLdCclTWQ/o5DG1a/9dTeJSXzlXSXcS3kw4jgAyP1vuBfgT6MJwE9p/TJsB
	N0NvIqzvvT5SFgout2YjvamQI8YIznoJYqFHXhUxI5+JMCZGs8A8BHNL0LxhLd7dNDHKErLvCVT
	0gZD/uyeVLmpIH81kYkPRvEq7fj1AVscwO6ug==
X-Google-Smtp-Source: AGHT+IFnCzaQCuLRDF3T0KDY0acjrNgQBMDeia5n8p9ebzIE1pRoGMSM83/YyDyRP/0W/eit+e8D1RvW/dQ4YjOCLbk=
X-Received: by 2002:a17:90b:4c4f:b0:313:d7ec:b7b7 with SMTP id
 98e67ed59e1d1-31e3e1f0b58mr7413618a91.13.1753221584666; Tue, 22 Jul 2025
 14:59:44 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-14-kuniyu@google.com>
 <z7kkbenhkndwyghwenwk6c4egq3ky4zl36qh3gfiflfynzzojv@qpcazlpe3l7b>
 <CANn89iLg-VVWqbWvLg__Zz=HqHpQzk++61dbOyuazSah7kWcDg@mail.gmail.com>
 <jc6z5d7d26zunaf6b4qtwegdoljz665jjcigb4glkb6hdy6ap2@2gn6s52s6vfw>
 <CAAVpQUAJCLaOr7DnOH9op8ySFN_9Ky__easoV-6E=scpRaUiJQ@mail.gmail.com>
 <p4fcser5zrjm4ut6lw4ejdr7gn2gejrlhy2u2btmhajiiheoax@ptacajypnvlw>
 <CAAVpQUAk4F__D7xdWpt0SEE4WEM_-6V1P7DUw9TGaV=pxZ+tgw@mail.gmail.com> <xjtbk6g2a3x26sqqrdxbm2vxgxmm3nfaryxlxwipwohsscg7qg@64ueif57zont>
In-Reply-To: <xjtbk6g2a3x26sqqrdxbm2vxgxmm3nfaryxlxwipwohsscg7qg@64ueif57zont>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 22 Jul 2025 14:59:33 -0700
X-Gm-Features: Ac12FXzmS2q9uiW4v2Mh3ddunncGvq7rXqTatxuc1vnyDKWf2gVdVrW60Nf_-Q8
Message-ID: <CAAVpQUAL09OGKZmf3HkjqqkknaytQ59EXozAVqJuwOZZucLR0Q@mail.gmail.com>
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
X-Stat-Signature: ey5rhppwgkx6oiidcyek985k4ztgzf9g
X-Rspamd-Queue-Id: 2C67220002
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-HE-Tag: 1753221585-689539
X-HE-Meta: U2FsdGVkX1/QK2cjrQnTGpCcqNLA+6+HKgSxSEgdu5MW0NWzYMAdH2uERPnivAXuBulT5jO4STD+q8jrREt3SMmFwCUWC/H/vZxasLzAQQInrPxqpRO1wQ4kV2GmeGZiCz9U9hlrfahsI5xMdLu7fS8fmJnPzr/AO7Z9HPBZ47sGMFROLp+v5o7YENttyYu9gmAgleWk7mKAZsNkMcp2KLFGtgPUxFbeeGdSwGwfIxa4qP6JIuR2PQ2XsASmL+sUf/j7IyVSvkahauVXrqUWQDWYk0ihrE5D/QFJnjYK6603/ASihde9ltpdkNsEREPQ/KIyWk4Zwc/J+ELO+DxD/4cPzPKUPzvbyf/M3DO/wkWzFp+H1DCZRdBArBXZQofRoupK6JuJ9nXd1ipunHpZOSZBC1p9c/XXe54G50YeYBg02zc8EEua5ZOhn1d7Id1BkfnA2wSc1Y+SSzPj/ln1A6+2tM/vmbZ2wEbxvfwjB+/K3HourjJ23esI/Gl11C6okikCjvKb2TVL41rWHAEJrrYv0jCh5RLhkaIIQgElo94v80WIdXvPaSuFAXmFz0/FnWznMbZioHOIz4Jh+nxdB9sQSmdOpsszFkh8tfYuSL1n/ze5FMpRo2aemFZVKfnOcVoOZH0CSaKGHjK5U/bdi4/CBQli1s7/K2JdA7Za0BVTQeFgZIIF84puW27iaHGqKfatn0ovqr48orJL4RH6hjXNRNjnx37Io3uXh16T3mjeegZmrGhgihuXlEqWfTO6W/8usfsqD9xNKSI57ceLLeki8Wx7xXc5s2IKQLd7vGEQle/D6r5k3033Q5RCCOnY8vgPWCEROHCccVhokHVaaU11Fvhwj2xN1nMZNvxGHVt99j4jEuEZernIeFhC0SPVz2nS1FwuTGLp9UXph50BtEKaQ7lbKs7dPvYuOMxklLvEB5hrwRX8kbNthMh+pUJfpfbD9jqEhbuy95p9krK
 VKn8t+up
 19gkcsyR/ZhWZ7oEquB8M3fzNa5I1NQqc/twQtPmiXe+kcyfy9tZBNtK+lSx3U8b8BpEf7166XoJLy2YOWvA+f5fGnKnoWjCxal6P58SnFtGhWCRxB/QXkjemitr4jdAhubQFOV9YFFgY98YwQQVt4qX+KkU6UABFLTHcy6He+1NsdlP4q52T5aVnuC54PtGVLu98
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 12:56=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> On Tue, Jul 22, 2025 at 12:03:48PM -0700, Kuniyuki Iwashima wrote:
> > On Tue, Jul 22, 2025 at 11:48=E2=80=AFAM Shakeel Butt <shakeel.butt@lin=
ux.dev> wrote:
> > >
> > > On Tue, Jul 22, 2025 at 11:18:40AM -0700, Kuniyuki Iwashima wrote:
> > > > >
> > > > > I expect this state of jobs with different network accounting con=
fig
> > > > > running concurrently is temporary while the migrationg from one t=
o other
> > > > > is happening. Please correct me if I am wrong.
> > > >
> > > > We need to migrate workload gradually and the system-wide config
> > > > does not work at all.  AFAIU, there are already years of effort spe=
nt
> > > > on the migration but it's not yet completed at Google.  So, I don't=
 think
> > > > the need is temporary.
> > > >
> > >
> > > From what I remembered shared borg had completely moved to memcg
> > > accounting of network memory (with sys container as an exception) yea=
rs
> > > ago. Did something change there?
> >
> > AFAICS, there are some workloads that opted out from memcg and
> > consumed too much tcp memory due to tcp_mem=3DUINT_MAX, triggering
> > OOM and disrupting other workloads.
> >
>
> What were the reasons behind opting out? We should fix those
> instead of a permanent opt-out option.
>
> > >
> > > > >
> > > > > My main concern with the memcg knob is that it is permanent and i=
t
> > > > > requires a hierarchical semantics. No need to add a permanent int=
erface
> > > > > for a temporary need and I don't see a clear hierarchical semanti=
c for
> > > > > this interface.
> > > >
> > > > I don't see merits of having hierarchical semantics for this knob.
> > > > Regardless of this knob, hierarchical semantics is guaranteed
> > > > by other knobs.  I think such semantics for this knob just complica=
tes
> > > > the code with no gain.
> > > >
> > >
> > > Cgroup interfaces are hierarchical and we want to keep it that way.
> > > Putting non-hierarchical interfaces just makes configuration and setu=
p
> > > hard to reason about.
> >
> > Actually, I tried that way in the initial draft version, but even if th=
e
> > parent's knob is 1 and child one is 0, a harmful scenario didn't come
> > to my mind.
> >
>
> It is not just about harmful scenario but more about clear semantics.
> Check memory.zswap.writeback semantics.

zswap checks all parent cgroups when evaluating the knob, but
this is not an option for the networking fast path as we cannot
check them for every skb, which will degrade the performance.

Also, we don't track which sockets were created with the knob
enabled and how many such sockets are still left under the cgroup,
there is no way to keep options consistent throughout the hierarchy
and no need to try hard to make the option pretend to be consistent
if there's no real issue.


>
> >
> > >
> > > >
> > > > >
> > > > > I am wondering if alternative approches for per-workload settings=
 are
> > > > > explore starting with BPF.
> > > > >
> > >
> > > Any response on the above? Any alternative approaches explored?
> >
> > Do you mean flagging each socket by BPF at cgroup hook ?
>
> Not sure. Will it not be very similar to your current approach? Each
> socket is associated with a memcg and the at the place where you need to
> check which accounting method to use, just check that memcg setting in
> bpf and you can cache the result in socket as well.

The socket pointer is not writable by default, thus we need to add
a bpf helper or kfunc just for flipping a single bit.  As said, this is
overkill, and per-memcg knob is much simpler.


>
> >
> > I think it's overkill and we don't need such finer granularity.
> >
> > Also it sounds way too hacky to use BPF to correct the weird
> > behaviour from day0.
>
> What weird behavior? Two accounting mechanisms. Yes I agree but memcgs
> with different accounting mechanisms concurrently is also weird.

Not that weird given the root cgroup does not allocate sk->sk_memcg
and are subject to the global tcp memory accounting.  We already have
a mixed set of memcgs.

Also, not every cgroup sets memory limits.  systemd puts some
processes to a non-root cgroup by default without setting memory.max.
In such a case we definitely want the global memory accounting to take
place.

Having to set memory.max to every non-root cgroup is less flexible
and too restricted.

