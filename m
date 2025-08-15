Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3D3B7CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 17:24:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A22FC8E0200; Fri, 15 Aug 2025 13:24:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9FA658E0001; Fri, 15 Aug 2025 13:24:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 910048E0200; Fri, 15 Aug 2025 13:24:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 803998E0001
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 13:24:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3AB65160214
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:24:27 +0000 (UTC)
X-FDA: 83779665774.09.19AEEB5
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf30.hostedemail.com (Postfix) with ESMTP id 70A2180004
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 17:24:25 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aU8Sajkw;
	spf=pass (imf30.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755278665;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hzg1sXt30P5Z9/BfPnmiaFGjEcn/JQQ0ZCMOCPQMKE4=;
	b=d/jlWzVfLP/G4Q65KrynN8le5+9yTwFGM2zPwA7Q5YyfYsaG5eGFCFzUh49h9H4rBrhyB5
	ZwI5zDyhoUwAwrjeEhKdcAUqXeVldsejc+1aXU2AsEqtZVVwu4/V5xLQV0IoNJJAvZqKoB
	hJd7KNTiEv5vNjmEJzsrO02PNFzIJuI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755278665; a=rsa-sha256;
	cv=none;
	b=wEvkxv3Ixn45o2DXjpDYHBqL22sRVCgSKGNdWo6a/G/zqgHwLVI7E7St5MxzXs/jLg8xV+
	oUBZQY9kbIp1FtnosginhxY/k7fOzRanF4mD4CixdtGQu4p6e1Opz6pHNNa+iemdbZj9B1
	jsSdpbK5ZqHfA+4ru82lm+svt3tUNng=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=aU8Sajkw;
	spf=pass (imf30.hostedemail.com: domain of kuniyu@google.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-323266b2368so1537363a91.0
        for <linux-mm@kvack.org>; Fri, 15 Aug 2025 10:24:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755278664; x=1755883464; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hzg1sXt30P5Z9/BfPnmiaFGjEcn/JQQ0ZCMOCPQMKE4=;
        b=aU8SajkwsiiOEDIJch4RdwNRQFKEv1jbKRdJCTrLLBRhf3i4WoITrhnkHDrleqDvc4
         vs8iQTYSArte2pVyJa4ejqqonZGPuiZHFA6dmW495K/wY5xSKk6fCVDpSx2pLszSOhZy
         n41LHfHSkwb61181CxpxNX9bl4CzsnE9ti/bSCrydvJo7x22mN8uYgzLFx0iOHrGIE41
         jbKSFZk+qJcfiIY5UZ4FQ9caU5+8vDzB2KyZeL0D6I7CueyRTt9qf3g6MIeaC/8U7aGb
         jyCd/jJBHBmiljDOjg+gh82/L8wVi0YO50jor6B7ZzVTYlCWw7BwE003jOABjdXFpyIb
         D9ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755278664; x=1755883464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hzg1sXt30P5Z9/BfPnmiaFGjEcn/JQQ0ZCMOCPQMKE4=;
        b=CJQMAHMJ/TLiiwdCr9W1s4ynS6bTBDa8jRsd4WvLA7AFVvp1ErAQe9zevEMCfS6utD
         BipHLU+L7IWkscC8TVt08T69jj489QhfNoPQmz6DPIdo9K4N0NDpK+kk4VTNqeqnKGN7
         +9Z5m92b39Kx5UGt+mJGnuRBNLDPPumFCxHPzRlCxGMxHQbqVNR80wlKoc08qxBFNMli
         SmwSSP61v55u8P8Id8Y0dPNzDVylc/NBjT/d3ZfzSZDt/ICWi4PXUSyan2Ri6pPoMF3k
         UmPjB+hRFpVnMctRGd3xBwIAJJLjb/6GAeZ572QiOTsWUH65tRV5Mka8GeGQnHH1Qqaw
         h4dA==
X-Forwarded-Encrypted: i=1; AJvYcCWhxXWlMcXr/UTlJp5JK+dLYr94mvNGSzcCkSfKxydDUcNwfQZWT/xiQVtO2bzvRthvTIu32UNjYA==@kvack.org
X-Gm-Message-State: AOJu0Yzh68oN+jWpptcwae5jEuPYzQVzkqWaOf0MhNKeROyKagjWRi7l
	mGzCoy6kq/NtTrlIRCqGaS2CAsZwPOpJ16Y3j+kfyl5/wYjQGPBPH/o1F7odd0YNNh3UShBvsSZ
	85nasgh+OKpg2e3TtyRWfl5UtOon0y1y22dmcLQou
X-Gm-Gg: ASbGncvlUD8KnyB2Dmy6gAVcek02HuCt6ORPqoczN8hi3ooDQdsagGP3UqhoM1Vmd2n
	PHOjF63cak+8OFLhjVFBii103YlFZnrzR38kgNX51yD+QLBx0TESNdMguWjJqGhhCQ2I63rW/II
	6TAu6pcA7XvvWsZNGDBVdm9ucNmePjV3z0zuUk4bVNaJe099DSpYj9ib+zrisNMm2jnO17A/4rB
	rwgATk96r0JvKeaXQbxaytX8lVac+Fn5sZrITyeRy+ulU4yCDJlNRlrnA==
X-Google-Smtp-Source: AGHT+IGOeHzguq0H49KnfwRNBN4KHk/rEdxFjz1gBmVI9CUvhaLBILRetMCU8KSgGN+j2f2hFkx+G5OoFKZhh3FV0pc=
X-Received: by 2002:a17:90a:d00c:b0:321:7528:ab43 with SMTP id
 98e67ed59e1d1-32342159927mr4699112a91.24.1755278663907; Fri, 15 Aug 2025
 10:24:23 -0700 (PDT)
MIME-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com> <20250814200912.1040628-2-kuniyu@google.com>
 <cs5uvm72eyzqljcxtmienkmmth54pqqjmlyya5vf3twncbp7u5@jfnktl43r5se>
 <CAAVpQUDyy9f7=LNZc2ka2RiOhR3_eOhEb+Nih37HnF0_cdrJqA@mail.gmail.com>
 <r3czpatkdegf7aoo3ezvrvzuqkixsb557okybueig4fcuknku3@jkgzexpt7dnq>
 <CAAVpQUAx9SyA96b_UYofbhM2TPgAGSqq_=-g6ERqmbCZP04-PA@mail.gmail.com>
 <kr6cv3njfdjzc2wcrixudszd2szzcso7ikpm6d5xsxe7rfppjs@5bvfwpelgj6f> <CAAVpQUCMcm8sKbNqW9o6Ov1MtC67Z--NTv9me1xcYgCkbJxK5g@mail.gmail.com>
In-Reply-To: <CAAVpQUCMcm8sKbNqW9o6Ov1MtC67Z--NTv9me1xcYgCkbJxK5g@mail.gmail.com>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Fri, 15 Aug 2025 10:24:12 -0700
X-Gm-Features: Ac12FXwIRxgeuD6PT09lmdII8NjN1ufyiLIBuu7fCCCW8-jhnwo582zSPLhZK3E
Message-ID: <CAAVpQUBO8TXjjtt++kF0R-qs-Utn-eY5o321NyAALEYTfq0xGw@mail.gmail.com>
Subject: Re: [PATCH v4 net-next 01/10] mptcp: Fix up subflow's memcg when CONFIG_SOCK_CGROUP_DATA=n.
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
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 70A2180004
X-Stat-Signature: qsbks1xn7zbsrqpqwdmkjpcb3pxicciy
X-Rspam-User: 
X-HE-Tag: 1755278665-640620
X-HE-Meta: U2FsdGVkX1827rf0it64QfVcShu1U1tMNiySBtvnIfyvMaQbDOROYOVbg57p3L62gAxdV4uR4LfOqqE0QiC63e97ugFr0kd1jU0Fyy2sSrnIZ3s7H/oT8DMSDVVU8IrJQ/+Zbx1GjVQD1ab1veIoxk5U7LWc+Rrtl7qug4JC3jE+VAaff1AWtSvxNU6wodUMPXPpIYhadoFoier/0/hZWCUOEvVcKkUUIhlvGyBgYp5pNRaP+oDoj04ZOCZGbu0WDbsV0Jr7jFBeUZvmHM+5piOWt75BEHnunH0MHYkxCpWXiGGL5QcSZxUykzCoCwqrTSiUysa8Sl0edt3qlyGg9SDV0i/nYsrPI5TxRZPcyhFsasyD0PB1hIPKe5vt+YwyHitIsr5N/Gtq8QzuHrdtYboPH2UgZhXqXa7F95ka5IFNe3vOBio4CDSzvXVE62QlGi4/Vt/ZlmQPWxHT1NOkmiNJqPZEdkBd4xDp5zNVK6BhKEhjtq5+8Rf2zWBvEHilXhFlb74ME6+QcMTtZV7EeO6Yi9FigvxdWDpalNE5YmHd0JYCeafZ29EBhMfagHFA3dooATL1z02s/TbiB9tGMWWm4FMcJMUnMPmH4Auw5JjeUeqKqwnrNwOf9tRJObEiUUQdaUfrc/KvWrFzMC8S5Hj4dfjLnAXIBaBMj3wWEMxEZNE0YYH4QNSAAWjaxKYqpzH7j3TqwTHQmgl2+etJmLpYKuBoZ3GE+seSiGRvr65uT0T0cHh/D9nV0wwJUNYPkbPAXs0VS/OaJbVQioZjf2Xlh/Ox1Gux/xuBpFqbCPXNvnXndzf5Bhn81FBrnQ3MuN+cY+7vAXN3HRRSyXEhJ2ZfMAhAQfE+0wyx1VeCFB4GgtZ4KE+v2nS8sAICcr4IkmF3O0HO9zZGNNmexiUoSChTe8ujoTS/vmAInvqG9vuvjFpe60Tt/OI/B81IDDSuIDGZqSfQmtk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 7:31=E2=80=AFPM Kuniyuki Iwashima <kuniyu@google.co=
m> wrote:
>
> On Thu, Aug 14, 2025 at 6:06=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.=
dev> wrote:
> >
> > On Thu, Aug 14, 2025 at 05:05:56PM -0700, Kuniyuki Iwashima wrote:
> > > On Thu, Aug 14, 2025 at 4:46=E2=80=AFPM Shakeel Butt <shakeel.butt@li=
nux.dev> wrote:
> > > >
> > > > On Thu, Aug 14, 2025 at 04:27:31PM -0700, Kuniyuki Iwashima wrote:
> > > > > On Thu, Aug 14, 2025 at 2:44=E2=80=AFPM Shakeel Butt <shakeel.but=
t@linux.dev> wrote:
> > > > > >
> > > > > > On Thu, Aug 14, 2025 at 08:08:33PM +0000, Kuniyuki Iwashima wro=
te:
> > > > > > > When sk_alloc() allocates a socket, mem_cgroup_sk_alloc() set=
s
> > > > > > > sk->sk_memcg based on the current task.
> > > > > > >
> > > > > > > MPTCP subflow socket creation is triggered from userspace or
> > > > > > > an in-kernel worker.
> > > > > > >
> > > > > > > In the latter case, sk->sk_memcg is not what we want.  So, we=
 fix
> > > > > > > it up from the parent socket's sk->sk_memcg in mptcp_attach_c=
group().
> > > > > > >
> > > > > > > Although the code is placed under #ifdef CONFIG_MEMCG, it is =
buried
> > > > > > > under #ifdef CONFIG_SOCK_CGROUP_DATA.
> > > > > > >
> > > > > > > The two configs are orthogonal.  If CONFIG_MEMCG is enabled w=
ithout
> > > > > > > CONFIG_SOCK_CGROUP_DATA, the subflow's memory usage is not ch=
arged
> > > > > > > correctly.
> > > > > > >
> > > > > > > Let's wrap sock_create_kern() for subflow with set_active_mem=
cg()
> > > > > > > using the parent sk->sk_memcg.
> > > > > > >
> > > > > > > Fixes: 3764b0c5651e3 ("mptcp: attach subflow socket to parent=
 cgroup")
> > > > > > > Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> > > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> > > > > > > ---
> > > > > > >  mm/memcontrol.c     |  5 ++++-
> > > > > > >  net/mptcp/subflow.c | 11 +++--------
> > > > > > >  2 files changed, 7 insertions(+), 9 deletions(-)
> > > > > > >
> > > > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > > > index 8dd7fbed5a94..450862e7fd7a 100644
> > > > > > > --- a/mm/memcontrol.c
> > > > > > > +++ b/mm/memcontrol.c
> > > > > > > @@ -5006,8 +5006,11 @@ void mem_cgroup_sk_alloc(struct sock *=
sk)
> > > > > > >       if (!in_task())
> > > > > > >               return;
> > > > > > >
> > > > > > > +     memcg =3D current->active_memcg;
> > > > > > > +
> > > > > >
> > > > > > Use active_memcg() instead of current->active_memcg and do befo=
re the
> > > > > > !in_task() check.
> > > > >
> > > > > Why not reuse the !in_task() check here ?
> > > > > We never use int_active_memcg for socket and also
> > > > > know int_active_memcg is always NULL here.
> > > > >
> > > >
> > > > If we are making mem_cgroup_sk_alloc() work with set_active_memcg()
> > > > infra then make it work for both in_task() and !in_task() contexts.
> > >
> > > Considering e876ecc67db80, then I think we should add
> > > set_active_memcg_in_task() and active_memcg_in_task().
> > >
> > > or at least we need WARN_ON() if we want to place active_memcg()
> > > before the in_task() check, but this looks ugly.
> > >
> > >         memcg =3D active_memcg();
> > >         if (!in_task() && !memcg)
> > >                 return;
> > >         DEBUG_NET_WARN_ON_ONCE(!in_task() && memcg))
> >
> > You don't have to use the code as is. It is just an example. Basically =
I
> > am asking if in future someone does the following:
> >
> >         // in !in_task() context
> >         old_memcg =3D set_active_memcg(new_memcg);
> >         sk =3D sk_alloc();
> >         set_active_memcg(old_memcg);
> >
> > mem_cgroup_sk_alloc() should work and associate the sk with the
> > new_memcg.
> >
> > You can manually inline active_memcg() function to avoid multiple
> > in_task() checks like below:
>
> Will do so, thanks!

I noticed this won't work with the bpf approach as the
hook is only called for !sk_kern socket (MPTCP subflow
is sk_kern =3D=3D 1) and we need to manually copy the
memcg anyway.. so I'll use the original patch 1 in the
next version.


> >
> > void mem_cgroup_sk_alloc(struct sock *sk)
> > {
> >         struct mem_cgroup *memcg;
> >
> >         if (!mem_cgroup_sockets_enabled)
> >                 return;
> >
> >         if (!in_task()) {
> >                 memcg =3D this_cpu_read(int_active_memcg);
> >
> >                 /*
> >                  * Do not associate the sock with unrelated interrupted
> >                  * task's memcg.
> >                  */
> >                 if (!memcg)
> >                         return;
> >         } else {
> >                 memcg =3D current->active_memcg;
> >         }
> >
> >         rcu_read_lock();
> >         if (likely(!memcg))
> >                 memcg =3D mem_cgroup_from_task(current);
> >         if (mem_cgroup_is_root(memcg))
> >                 goto out;
> >         if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg1_tcpmem=
_active(memcg))
> >                 goto out;
> >         if (css_tryget(&memcg->css))
> >                 sk->sk_memcg =3D memcg;
> > out:
> >         rcu_read_unlock();
> > }
> >

