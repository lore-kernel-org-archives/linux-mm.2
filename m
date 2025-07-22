Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D7C73C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 18:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73E738E0008; Tue, 22 Jul 2025 14:18:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 715038E0001; Tue, 22 Jul 2025 14:18:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 62B668E0008; Tue, 22 Jul 2025 14:18:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 52AA38E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:18:56 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BF5E359163
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:18:55 +0000 (UTC)
X-FDA: 83692711830.07.F0FAAD4
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf25.hostedemail.com (Postfix) with ESMTP id D3D3BA0003
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:18:53 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dbvlGwn7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753208333; a=rsa-sha256;
	cv=none;
	b=q9O6s+lJN3NvB+vUP0kCRzVVMEboWP1Kjo4whtGtSoM61ut00XmvpBev60IFU0doXMVHy3
	Q23WPTC/YVxHjQz8vw5MuWWm3JjaLO8/Ft+y5rloj4rDW6WztcmMvh4XpD289ABsFbDUgy
	AZPtHjzhOStIJZEbN39Xs9+7m5iwNeI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=dbvlGwn7;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf25.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753208333;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IMYTSLLBkiKddq/FquIPU9bbzQYOdbjhg+lBLqMyOag=;
	b=VUWO6VsT9qh4KG/FXOQXwxydcUeo6pqpFm2IuuZuGj1D0GQ4jPp0V/0SyeNkvUbpaG5cTe
	vUKkfY/jNfgYlfraDJXrluHbwpsawiemdb+EmZS93n6rw5lFjH02Yvn86rXhlYUpJitoPE
	sCSnQrRyZTi4L5P3pSSEvkrZ7ildYaM=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-31332cff2d5so4951073a91.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:18:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753208333; x=1753813133; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IMYTSLLBkiKddq/FquIPU9bbzQYOdbjhg+lBLqMyOag=;
        b=dbvlGwn7cuBu837a1Xz7hxjrQuhKDn6hv8aWqgiV2egVUuLsbBNQj1apiebkP8ag2y
         9qQCJEvhOwa3WfiswW11/nFM/vO+xBrdqgqJ/q6KbbSMTjXFSNm0b5m8Rc000FFMnRgO
         5HaRAVP1aDTK4nZSVtrOaG+pyyAgpKYHFBA41ceo6YLI+L6ddI9SJfyFvEm5lyZWwif8
         3gUuBsn49Dj1Nj5UiiYm3cBOLF1mOJeBtYSaLnY+Dkp3HZWlIX67bQsVtAu3etl+VBQc
         C4l3hziSAYioV1jti9oJsK9F3YteE4e4kTIZt90WHGFoZxM8fv1nvi+N1Zz8l4GeTowQ
         njYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753208333; x=1753813133;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IMYTSLLBkiKddq/FquIPU9bbzQYOdbjhg+lBLqMyOag=;
        b=oxru5Ko+ByEPTVYd9Rd9xjZXCNEKIBQW2sn3lXVh/K0XczjQdaFZFF1fTkYR5S+OYI
         e03ThgZVgo/DUE8eTMsBMFZqZwUDBS+lkDS4qCqyKV7h+CNm/JjRv/k+yuU5omxqqyl4
         UwQzVRmrvGl7fVRtpEhe0bMowwQi2Kx8kSlI/PjSoHXu+HSO5iqKZQHqIKCyz186PM6i
         gKfBgonyArHcCTPvHQ8dqcpfMSQPHt85fBXjVg1FmaPxqGK9eNo8I86pwXpDJjBtvKtT
         GPn6kDbt/1yqusb5JA2U2Kj+uQnqfLS4gZX8KBAaVWVW4vHkY7JLQQAMHbz4CTKEo97s
         Ghhw==
X-Forwarded-Encrypted: i=1; AJvYcCUHD0/IAiwMfyzMf5OCsBbP6kjlmhHwPU0fvzBgnhhXdTRTH1+TxQ6gtU+qVSLzApwaGdSmmu5I8w==@kvack.org
X-Gm-Message-State: AOJu0YwIJFOVN1pdjQP3cDYsmdUKBfUHor8zf1vkGGr7BaRmpw4vOHa6
	uj/+pjAjetklUqB3KFYcx88MxEXb6+UnMm9iA4dVOFfTet83FTMVWyyk4V76p/dWmYJg9Q1r6Ty
	C1GGkgq3GiYk8XQIXW/QTcw5SB+V1PhFa21Z1kz0B
X-Gm-Gg: ASbGncv7JjebkxZmYtDuKLADr+/fXzmtNrRAThDXdfqrylscBHjiUz2NgGq7X9dRH9j
	7ygwgh69ULDhS0MtS1aqTEYcNs7Euz8DAhMGe0zP7SJOLhjdJGDemghQ0m0ehBSov677S7Fhl+H
	zGA3+HsYCCOsg05ldnSTy5/DavkH7nqpAA8Z2pSTyToHkyv/eMYacVflRjkuwa96SgcY3aqVcy8
	DBkyu6TShk4SW7kQJwv7x3Giyr5ySfn8JtKtQ==
X-Google-Smtp-Source: AGHT+IElD1kikSWPb5qZUh/ZHziKPEue1huHVJC1qTZlxH2csGDvjAg3/+9RMCHo3B1QUGheaFDPmjpYlxgxHDS4A9I=
X-Received: by 2002:a17:90b:2f8b:b0:312:db8:dbd2 with SMTP id
 98e67ed59e1d1-31e507c49c4mr448802a91.19.1753208332393; Tue, 22 Jul 2025
 11:18:52 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-14-kuniyu@google.com>
 <z7kkbenhkndwyghwenwk6c4egq3ky4zl36qh3gfiflfynzzojv@qpcazlpe3l7b>
 <CANn89iLg-VVWqbWvLg__Zz=HqHpQzk++61dbOyuazSah7kWcDg@mail.gmail.com> <jc6z5d7d26zunaf6b4qtwegdoljz665jjcigb4glkb6hdy6ap2@2gn6s52s6vfw>
In-Reply-To: <jc6z5d7d26zunaf6b4qtwegdoljz665jjcigb4glkb6hdy6ap2@2gn6s52s6vfw>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 22 Jul 2025 11:18:40 -0700
X-Gm-Features: Ac12FXzC5_as3QVdk60aGP4lct3yePOviOeUXVs_xi0EDMGbnYX0I8xvyKuP3Lc
Message-ID: <CAAVpQUAJCLaOr7DnOH9op8ySFN_9Ky__easoV-6E=scpRaUiJQ@mail.gmail.com>
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
X-Stat-Signature: 83dmitj9oiyg1o6ffom4irihybwut83x
X-Rspam-User: 
X-Rspamd-Queue-Id: D3D3BA0003
X-Rspamd-Server: rspam02
X-HE-Tag: 1753208333-149749
X-HE-Meta: U2FsdGVkX18e7FyukUinqq5m89rfXp6/hgRhWTb6T3uabS06ot+u63TBCfoispF6h1GzS3TR7ajefUh4RaRuSObqobzz/GmgmO2UA7qeijEMGdt60wUPpMK79ZGH33WjlzUtiOiBY3Ewc4tN6iWYGM5AZ3t+Jsq4ulxfua60HbVGX02uPTXokKvN5FDs70TlqR29wXJzLdECeyBaC7gJEKqDyVyUPoGnKHvpIi4Uz1syiY5T45p9r8lxeakI+9Zi8IIwVTiE5W2Fpa6MjDv8F/aZnTJ7eBSFUUOPiK8wtpbSe7XRvm+/ukI0XP2EiMzT0D9SIf049drv3kXKCCP1wTuCB77EDiEQLDyna9cW5eoCvL5ewqFaHDqBEakjwZDzlkKmi/c1jwjmZfT6euumlLScb4J0sAi+YmS5imSOUf0zuFVVW7SNZDwHCDN0A3tPrUn9kHJIZMu4R0RgxjZz9XtjHFuA7o9xl2QL4F28doUENPlgVRQsB74yJGDeRkRus8GRtJX25sHhG5VlbT3dA98s+4rTbh8kryI68xWI/CX2ySizhj8U6k4AwCFfm7ULUWN07rkbcaOuA2uae0+0hAKPzO5mPgsrr/64d2fX5WeyParVQVVJJQ3F3R5BsL1fDvZoJdi+YsP0SUatju4k51AUkAhNhbhV8LphKQruZyaBISb+pC5mNkYmeNda7LbZEA/7NeIrgWQAU7rsDUwY+T0ugKuQfzXj0hTmWK9kkzx6rD9ydqq5+OeFroSPNPrzaWOS/zO/JdnAGEbg4rQRkRfUzlgYULrHoYsJl0FgQH9MYfgGezCUeFtDoxRNMTwYSWONVzZV31Bs/1+V847d9/8YGFBh9ja8KhFp9XXY6jY4gx5MOZ7cLHHRP03jFEhdjef5OWHj8wbOn6/nbVA96hYjeO8wexdjjyLqLqT4n1bCFwDK7II5GYjjbzzooWSDW30kZMKQRR7DNfl7dhZ
 TqQ/2jEa
 zz0pVWt+M2TfksE3FC6I1GuP7fqK3nVw9Ts2NjK1Ld3qf2m1OotPOkV0UeZLicYJSYEiBfC1ZOoYPceDr4aM91tcGEBUPhX/ppO6BKw+4jb4u7fOsw7GM60AnuhTppAfUBMoCORSl9DZeprh9ZkG0W6+OHl1Z3Rwbd5u/nA5tpyVO9zB05feyVOcQYuqx421YcQVZ
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 8:52=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Tue, Jul 22, 2025 at 08:24:23AM -0700, Eric Dumazet wrote:
> > On Tue, Jul 22, 2025 at 8:14=E2=80=AFAM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > On Mon, Jul 21, 2025 at 08:35:32PM +0000, Kuniyuki Iwashima wrote:
> > > > Some protocols (e.g., TCP, UDP) implement memory accounting for soc=
ket
> > > > buffers and charge memory to per-protocol global counters pointed t=
o by
> > > > sk->sk_proto->memory_allocated.
> > > >
> > > > When running under a non-root cgroup, this memory is also charged t=
o the
> > > > memcg as sock in memory.stat.
> > > >
> > > > Even when memory usage is controlled by memcg, sockets using such p=
rotocols
> > > > are still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_me=
m).
> > > >
> > > > This makes it difficult to accurately estimate and configure approp=
riate
> > > > global limits, especially in multi-tenant environments.
> > > >
> > > > If all workloads were guaranteed to be controlled under memcg, the =
issue
> > > > could be worked around by setting tcp_mem[0~2] to UINT_MAX.
> > > >
> > > > In reality, this assumption does not always hold, and a single work=
load
> > > > that opts out of memcg can consume memory up to the global limit,
> > > > becoming a noisy neighbour.
> > > >
> > >
> > > Sorry but the above is not reasonable. On a multi-tenant system no
> > > workload should be able to opt out of memcg accounting if isolation i=
s
> > > needed. If a workload can opt out then there is no guarantee.
> >
> > Deployment issue ?
> >
> > In a multi-tenant system you can not suddenly force all workloads to
> > be TCP memcg charged. This has caused many OMG.
>
> Let's discuss the above at the end.
>
> >
> > Also, the current situation of maintaining two limits (memcg one, plus
> > global tcp_memory_allocated) is very inefficient.
>
> Agree.
>
> >
> > If we trust memcg, then why have an expensive safety belt ?
> >
> > With this series, we can finally use one or the other limit. This
> > should have been done from day-0 really.
>
> Same, I agree.
>
> >
> > >
> > > In addition please avoid adding a per-memcg knob. Why not have system
> > > level setting for the decoupling. I would say start with a build time
> > > config setting or boot parameter then if really needed we can discuss=
 if
> > > system level setting is needed which can be toggled at runtime though
> > > there might be challenges there.
> >
> > Built time or boot parameter ? I fail to see how it can be more conveni=
ent.
>
> I think we agree on decoupling the global and memcg accounting of
> network memory. I am still not clear on the need of per-memcg knob. From
> the earlier comment, it seems like you want mix of jobs with memcg
> limited network memory accounting and with global network accounting
> running concurrently on a system. Is that correct?

Correct.


>
> I expect this state of jobs with different network accounting config
> running concurrently is temporary while the migrationg from one to other
> is happening. Please correct me if I am wrong.

We need to migrate workload gradually and the system-wide config
does not work at all.  AFAIU, there are already years of effort spent
on the migration but it's not yet completed at Google.  So, I don't think
the need is temporary.

>
> My main concern with the memcg knob is that it is permanent and it
> requires a hierarchical semantics. No need to add a permanent interface
> for a temporary need and I don't see a clear hierarchical semantic for
> this interface.

I don't see merits of having hierarchical semantics for this knob.
Regardless of this knob, hierarchical semantics is guaranteed
by other knobs.  I think such semantics for this knob just complicates
the code with no gain.


>
> I am wondering if alternative approches for per-workload settings are
> explore starting with BPF.
>
>
>

