Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95C33C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 18:19:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C79A9000C1; Wed, 13 Aug 2025 14:19:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17836900088; Wed, 13 Aug 2025 14:19:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03FF99000C1; Wed, 13 Aug 2025 14:19:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id DF3B1900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:19:46 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6349682BD5
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:19:46 +0000 (UTC)
X-FDA: 83772547572.14.DE43F64
Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 782E58000E
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:19:44 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Gf5n9tcr;
	spf=pass (imf02.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755109184;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rspvbHj5HBwP8PT/Z2YHbQFfZn6hZPQOR0l2xh5UztM=;
	b=HnjxSqMRxF/nQFKG15jEO06dIEPDcdjrrrTwdNqtwKK2zp/tfq4nHmA06njBJr0H64SXAM
	RaKee/3fci5oakq7KnvFPyAhIzuhgoamnE1uJTnaE2Qg45IDO46sZxH70e94OvTsFcSqRU
	CUjtjbPE1zoKbCINSIGj2JG4Lat7M9c=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Gf5n9tcr;
	spf=pass (imf02.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.177 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755109184; a=rsa-sha256;
	cv=none;
	b=DqO/w83ikeXmxiTNS8WgVpYh3TbHddNnoLzDHDXg1r74eCrMAIDjKLpH301H8dm1obVurZ
	w0DlEtTfegwCWi+4Kgxd/AKo5uEfC3RrE+hLwqYzQ14sbH5NPkwQOwdgchxAll+obkIrGU
	R3soBRllonjWOoxVoqjCfgUSPQeKR/A=
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-b4717330f9eso24490a12.1
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:19:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755109183; x=1755713983; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rspvbHj5HBwP8PT/Z2YHbQFfZn6hZPQOR0l2xh5UztM=;
        b=Gf5n9tcr3WOdt7rtx46TC/P/WZJRAgCzEcwSsOMcs+Y4woDeKELnIbeC2iTwED/FG/
         vDPWXGj3rNL8cdF1+CRfwG2YzHm5QXdTHqd1ho/tc7OD7bN9OrYkPOjkMPOod3oeF7qu
         rGUnconjO3xzZD8cgF4H4Ym2E+X2mRt+iEzDhifAMQALLAZqJH1I8JB4ucMqMoNYJ90V
         i/a8F1Y6l/F/u99Rv7ClmYDCfxq6FPviGGxtpYjaviDy76nlu/Gry3cIGSefDln7rZSG
         wDM6qQ8uOk8una1wTBoqBKxcBNgHt1p7dLuF7jEb3G6/JDP7u9f3ZEc4wSN1byYTZj9R
         zM6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755109183; x=1755713983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rspvbHj5HBwP8PT/Z2YHbQFfZn6hZPQOR0l2xh5UztM=;
        b=fv+cr+UxvQKewIELgF9aWjGnEhcodDbA7tNklbokiRhZWcRNm3mXkUzer3Mgp4dEr0
         qbr3+jE3TwIZ+hpdSxbF8T+fndkt1Xk88cWmmxr2FzrhMVkhzE2Z3NKT0iITCoyru31u
         pZ60mA3Hc4RvwJfU28EkQWjokWewMxPo/eP9/bE+TwWs8RzBPeHDbdkDtSo4A7sN+K5P
         ybPHoMYQZiM3udGOiytkxpLGKSE1LcCR7e3zwdnlwnvghJeA6Ud6taJfuy5EaF27Jk7L
         yzOY6VhytHPeN6wi5jnFBX2LVWJMyF9I094fUz1QORsSExjhkIFdra6OYO2y/3Cvi3+3
         QZCg==
X-Forwarded-Encrypted: i=1; AJvYcCXbTgHSpbarxT1DdQdaG1T/q9nrgpvCljxehUL8mgTwYQwIa2TS228Kl1TClKwRq6NBmq84afh+Vg==@kvack.org
X-Gm-Message-State: AOJu0YxbBQmou7pejTdtI0naWvDQ6X5JcpQJacIokCEcGu3PDiAE8YuN
	mm9/TZjSr8mAyAy4boZpaevuf7ONBqI+ZYfpDd4Oyjz/3vYud1CPw9OHy0O0e8IrrOoRbp43ZQ2
	umB5HbI3HYR1ciSzBcQBkj+bLe3ma9Be8vJw90ZRg
X-Gm-Gg: ASbGncu1TrBzJwR0c4LnT6WdLpoT8JyMelhfgVV3zjcrA5vBFh3YyfpxtFqZ8/RA06+
	5+iS0kPCgeVBMyc9GinIn0KTGJKfD9EYS2M01qwqgadsSn1cOrmMyFlaKZDNUGl3hwGJhv37Bxr
	d1lDyizshAc44K/mAKdor2WvXH5I/B+vuWd8mkl/koRIXzyZrSaSoDFoK3QSe8RLoPgIk98iEaP
	heuYsCTzBBPmvZvM3peztfHS8tNrWXCjKReVYSNCKjdCtFeYLo=
X-Google-Smtp-Source: AGHT+IGBb76+41F2pHvydMm/JGXdMlN/mBnhrFNW+ic56J+9RYUnTBwRHsVejTU0pmtbS8GUNrvPI/xlIhdPGk+iHk0=
X-Received: by 2002:a17:903:ac7:b0:240:e9d:6c54 with SMTP id
 d9443c01a7336-244586d44bcmr733595ad.48.1755109182900; Wed, 13 Aug 2025
 11:19:42 -0700 (PDT)
MIME-Version: 1.0
References: <20250812175848.512446-1-kuniyu@google.com> <20250812175848.512446-13-kuniyu@google.com>
 <w6klr435a4rygmnifuujg6x4k77ch7cwoq6dspmyknqt24cpjz@bbz4wzmxjsfk>
In-Reply-To: <w6klr435a4rygmnifuujg6x4k77ch7cwoq6dspmyknqt24cpjz@bbz4wzmxjsfk>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 13 Aug 2025 11:19:31 -0700
X-Gm-Features: Ac12FXzLogDC6UGMQNMWDnDL9De9KnuUUW31y0FBm57RPEyjApbQulTgV6dTnyM
Message-ID: <CAAVpQUCU=VJxA6NKx+O1_zwzzZOxUEsG9mY+SNK+bzb=dj9s5w@mail.gmail.com>
Subject: Re: [PATCH v3 net-next 12/12] net-memcg: Decouple controlled memcg
 from global protocol memory accounting.
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Tejun Heo <tj@kernel.org>, Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Mina Almasry <almasrymina@google.com>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 782E58000E
X-Stat-Signature: zkzdok6gs4xawb8pgem5687oscts49mk
X-Rspam-User: 
X-HE-Tag: 1755109184-672229
X-HE-Meta: U2FsdGVkX1/vpYxFcOjzkpj6bBENUv80nZMU1uNs9uuubTH6sBWfI7PCFo50Os61f8oaNtw5Tr+IbeT79+PoYFDDKSWqRJWgiSIta/PHTalrWbsGvSHjt+rH3cM9RTVq4GqsU80geg5l+mbUOVLQ2XZmLDYOwKO2+cwclYigdnnkoSIFzRaMLaqM4PGPkYhrtuPu+IItz3DOyQuuT/HNHSFL5iCf3PwaCcllSANTXCQ/KJPS7AX+jhZSJdBevj0osxxqFiuWTF8DyGsf8F/9yOdFH0yTg1mEOO1WWPu1iCa5//bQ5W7tB1H6bSN5fYk7nu7P+Gr3mx4X1SGTGHOF1g7AI9aEsISapq/iSLriSmD+3FkOD3frhdXqjiY06KtaYTetgHgSJekvHlr1Cf7MYbP71HAc8TkgM+oPFiz7BfuvQLphCOlWQXvELQgb/YiDfxq9kqbTps7KXjPL7zwq2UNNNvxSTHjFjGTMNbFC1GRQ9lTT9RKTuNw6B5tvO9wfMnWyqxkV5tLDa+C58P4wWi4rcFBJbt3LhqbCFKoWj1ViWkRD8eRq8ifYbuVCCf+oS4HlniM5NXHXPnwIxqksKPAtPCPH6VN2asOVWApnCPDCIo0aYCQtwPNVVXIyWu+BYTv1meevd0whEhye2d2JMeIZF4wRHJRfeLpuKgg3IEggnR29HOw4SzROnk5D0GCg/q5vMUabi/RoFEYRsCQ0qcPnzRS5pLLSUfw0pZDvkBZGxtwhhbX28YxTYP6ZmKcNwY156gwGv7IBo+WgzOjlwvfrGYmsWHHJ/HGPDoyQ3Pl5g4iRDXYp687D8ELG2QAUOzJHAxjSljvIgr7u3RNF1P1bfPt2mWivcCT9sxbko+dc/ypE5rfRtnjuYeVg889UEC6JEoO64WmLsv2z4nxZLLfrTadFmy7VgMm+wKX8fS37sh2ISwqWqk64xIBDYYJUlOZPCRri8kZGUaCyKxC
 uwUJ2bIF
 5ir/cQI23DFONDLrbDgi0xrM5WJk3qmc8Ycr3A25mIExpiSAKLQXgbVg2D52bSA4PcC9al97LedxINPBz3Jv5MWRSEE/Dbs9dEF608cAMpbUSyvJGXA7hNwr88SsMVmnmKw7a7xvGH5LbYa25G47nDGKsjl7qOH127paPXwWcfSOiYaQj5Qdt3gtluWGBbg/FnGT3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 12:11=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> On Tue, Aug 12, 2025 at 05:58:30PM +0000, Kuniyuki Iwashima wrote:
> > Some protocols (e.g., TCP, UDP) implement memory accounting for socket
> > buffers and charge memory to per-protocol global counters pointed to by
> > sk->sk_proto->memory_allocated.
> >
> > When running under a non-root cgroup, this memory is also charged to th=
e
> > memcg as "sock" in memory.stat.
> >
> > Even when a memcg controls memory usage, sockets of such protocols are
> > still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_mem).
> >
> > This makes it difficult to accurately estimate and configure appropriat=
e
> > global limits, especially in multi-tenant environments.
> >
> > If all workloads were guaranteed to be controlled under memcg, the issu=
e
> > could be worked around by setting tcp_mem[0~2] to UINT_MAX.
> >
> > In reality, this assumption does not always hold, and processes that
> > belong to the root cgroup or opt out of memcg can consume memory up to
> > the global limit, becoming a noisy neighbour.
>
> Processes running in root memcg (I am not sure what does 'opt out of
> memcg means')

Sorry, I should've clarified memory.max=3D=3Dmax (and same
up to all ancestors as you pointed out below) as opt-out,
where memcg works but has no effect.


> means admin has intentionally allowed scenarios where

Not really intentionally, but rather reluctantly because the admin
cannot guarantee memory.max solely without tcp_mem=3DUINT_MAX.
We should not disregard the cause that the two mem accounting are
coupled now.


> noisy neighbour situation can happen, so I am not really following your
> argument here.

So basically here I meant with tcp_mem=3DUINT_MAX any process
can be noisy neighbour unnecessarily.


>
> >
> > Let's decouple memcg from the global per-protocol memory accounting if
> > it has a finite memory.max (!=3D "max").
>
> Why decouple only for some? (Also if you really want to check memcg
> limits, you need to check limits for all ancestors and not just the
> given memcg).

Oh, I assumed memory.max will be inherited to descendants.


>
> Why not start with just two global options (maybe start with boot
> parameter)?
>
> Option 1: Existing behavior where memcg and global TCP accounting are
> coupled.
>
> Option 2: Completely decouple memcg and global TCP accounting i.e. use
> mem_cgroup_sockets_enabled to either do global TCP accounting or memcg
> accounting.
>
> Keep the option 1 default.
>
> I assume you want third option where a mix of these options can happen
> i.e. some sockets are only accounted to a memcg and some are accounted
> to both memcg and global TCP.

Yes because usually not all memcg have memory.max configured
and we do not want to allow unlimited TCP memory for them.

Option 2 works for processes in the root cgroup but doesn't for
processes in non-root cgroup with memory.max =3D=3D max.

A good example is system processes managed by systemd where
we do not want to specify memory.max but want a global seatbelt.

Note this is how it works _now_, and we want to _preserve_ the case.
Does this make sense  ? > why decouple only for some


> I would recommend to make that a followup
> patch series. Keep this series simple and non-controversial.

I can separate the series, but I'd like to make sure the
Option 2 is a must for you or Meta configured memory.max
for all cgroups ?  I didn't think it's likely but if there's a real
use case, I'm happy to add a boot param.

The only diff would be boot param addition and the condition
change in patch 11 so simplicity won't change.

