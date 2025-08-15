Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFAD3CA0EE4
	for <linux-mm@archiver.kernel.org>; Fri, 15 Aug 2025 02:31:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 779C18E01CC; Thu, 14 Aug 2025 22:31:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 729858E0002; Thu, 14 Aug 2025 22:31:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6193C8E01CC; Thu, 14 Aug 2025 22:31:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4C4588E0002
	for <linux-mm@kvack.org>; Thu, 14 Aug 2025 22:31:23 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CADF5B827
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:31:22 +0000 (UTC)
X-FDA: 83777415204.21.7977631
Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	by imf13.hostedemail.com (Postfix) with ESMTP id ACE7B20006
	for <linux-mm@kvack.org>; Fri, 15 Aug 2025 02:31:20 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=v4YU9fmP;
	spf=pass (imf13.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755225080;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hwJrICMvn5YZZg5OvFRoWR/jD5Y72+/VemdMMNlTNAY=;
	b=bb5fXNQdZWcxa+Wz84yysWedMbkatLxn9KR2l70dyWEDPVhn7qzSqyBcxgOsGR15BYWO4w
	6DAuF1N5CRIrXlAAVWEoEsT3c7pWiWwV6pcEo9arBfz2gWxDyzEmpw5awd3rcbdNeoLhN2
	QBwbNF4WqrXPZxGC74EOLzihRktzr80=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=v4YU9fmP;
	spf=pass (imf13.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.180 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755225080; a=rsa-sha256;
	cv=none;
	b=S+vJySfJWEVmiYyUuIgbcH8zWwdQJkfslvUqBNftFPbfYg+2re2xSBjpBG8Bjzoi9UN/j6
	nShunSR0up6Qb7hGfJtTMPdYmN/+z4Bi0gkbt8hjbKGEMTarjAxksPavdobGekBxnWvgIW
	pkppVVDFINDGRagDTjZtUWBJ63EXNBQ=
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b4716fb2295so1025188a12.0
        for <linux-mm@kvack.org>; Thu, 14 Aug 2025 19:31:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755225079; x=1755829879; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hwJrICMvn5YZZg5OvFRoWR/jD5Y72+/VemdMMNlTNAY=;
        b=v4YU9fmPTygLgN13WFQmYYoe18o/+1+0HS6Bquh8kVEQdGyiqMlRLOLOMF1Lc+c2Iv
         s/bcvBjFv3/KsMDJR40znKD24kzDxWQsBvqwGTL76/C8AqifcthB0pOxivHRNhLwp3QU
         4snN+Hc5yQqooqANbSFyGs9iZidLkRmsEoSFaZSUtd2jTrOACxMGUnFuQ6WOdx9YQakz
         8SSyZ/HJ2LwKBxZyFjMx80iNqNDy8JJ5aDF3boG9Wm+9mkhzRjzlfFR7DilESTDuuJXT
         SPgrLb7UezY6uLHTiEAJa6XRRpmG3VTPnZFJm7Je77Nqs3u1h58PmjVbfX6Yw1nLA0sY
         C0jQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755225079; x=1755829879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hwJrICMvn5YZZg5OvFRoWR/jD5Y72+/VemdMMNlTNAY=;
        b=eIMbDNXryJBTe6b3zG61GSdE2yuF1xsw7TdTLMwdQR5FPyvtNkuV9bHYz+0SQ4Ii48
         8cre0HbOVIG3EjJuWv35wnTKsIczknjTWHCeGOGcqiNFD8JMgrYX1CXuQHQXuPf7/wzR
         1nn5d1cm6gI1PZjtizMnU9vT/ioXNTOQIh3FVCa44Oj00F8Ty4u0SpdwNCavL1c6xNUV
         0Ho+bkseReYq3WPKQX4RCNbuVvO9iM1uwVjyxzS0H9IGVf+eB3Uqv7DWmFwG8NyeZZB+
         RfuBwQTl97Fk5BmLtA3hxfxcyh8Bmv6S20iuGttGnv71afn6mg7KaZ5uOXDVWZyKBt+h
         727w==
X-Forwarded-Encrypted: i=1; AJvYcCV4oZe0LDZPUJzNm2TbsAOODGN6A1WbbEZxUjmuR+13AgnQL6m6MUNCYQV3MqXIXIeAcRmKPXDNuA==@kvack.org
X-Gm-Message-State: AOJu0YyWrLy2KIBTki+2wqJbUmPaasS1MU9LFVXbp/ar3yPgSqwwQ/Cs
	s1uQWQHrwZivPvFShh/g09HZPsVpQIGFdJAUrA0lzLQQF0HcEq/D8fS+UTr64E1PtbcOAsYkFfy
	HYbumCp+qpb2jds5RAHDGIUBUBVhjib9xx/OquaC3
X-Gm-Gg: ASbGncubFaORPi1iQKg2plgpajov7zmW71o6O5ycNkJBVNqtdAwxvBRm0zSfUW0CieA
	aHZm+MKgS/l+yBPeOvSPwbclGU9bXjiz0H9qRm2wyclcjt4n5D4QiofzSrZq0Nco8QaMa1fRy16
	gXx4e8lLMJy9uRGSessmZ6usBGTNZTIsaMvfJv4d79Y7zaeaJJzi2CfIdWnc/q6h4iVaZ0MQQUY
	u3accrJ2+f6/iXelBFVPuVegB1BTVCyPAMGenyov6LzyuCFL0cg1zM9
X-Google-Smtp-Source: AGHT+IEwYQ5eDN0UwWpz8ZWif2tlMoHHE0vvfDGyA+lewx7O9B0FGbBkW3rn66Hd2jfvfyy3r38VK778LZowgwK8wBM=
X-Received: by 2002:a17:902:cec4:b0:235:c9a7:d5f5 with SMTP id
 d9443c01a7336-2446d71ea77mr6091625ad.13.1755225079199; Thu, 14 Aug 2025
 19:31:19 -0700 (PDT)
MIME-Version: 1.0
References: <20250814200912.1040628-1-kuniyu@google.com> <20250814200912.1040628-2-kuniyu@google.com>
 <cs5uvm72eyzqljcxtmienkmmth54pqqjmlyya5vf3twncbp7u5@jfnktl43r5se>
 <CAAVpQUDyy9f7=LNZc2ka2RiOhR3_eOhEb+Nih37HnF0_cdrJqA@mail.gmail.com>
 <r3czpatkdegf7aoo3ezvrvzuqkixsb557okybueig4fcuknku3@jkgzexpt7dnq>
 <CAAVpQUAx9SyA96b_UYofbhM2TPgAGSqq_=-g6ERqmbCZP04-PA@mail.gmail.com> <kr6cv3njfdjzc2wcrixudszd2szzcso7ikpm6d5xsxe7rfppjs@5bvfwpelgj6f>
In-Reply-To: <kr6cv3njfdjzc2wcrixudszd2szzcso7ikpm6d5xsxe7rfppjs@5bvfwpelgj6f>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Thu, 14 Aug 2025 19:31:08 -0700
X-Gm-Features: Ac12FXx0oP3F9dx8jnlPn8DV0XXtg4bMkD2eiCckKKtAFl_RyUY4z0YgVFHXtPQ
Message-ID: <CAAVpQUCMcm8sKbNqW9o6Ov1MtC67Z--NTv9me1xcYgCkbJxK5g@mail.gmail.com>
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
X-Rspamd-Queue-Id: ACE7B20006
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: tntjarpwey56djdwa3zk48m9dzgofkkg
X-HE-Tag: 1755225080-332173
X-HE-Meta: U2FsdGVkX1/cqMsTSrkRHxKpJJydSVqwkJGEO3gOPVRL0I4YSycogIGL/S/THjPQRgi4M+A4XM6WHKJiHKwhbfiiW4ou5qG/ovwjzsSLZe8uzOHVBaGe3cAZmDtTJ1MU4aRA2ogLHN6EO+7HH5l2M5rxnEZKPIV7JwvRhgDPbucFXp1zZvZVVAUKdpRddOlwGWKCkqKa/WoIBDOCkLW/32Sr/TyjTZ7B0cbdJOpFE4oeFQE1s9wCNwfWFR8g2kQCWdt3Paw8/5MH1K2gCeR1ni/0yHnfkmLIEqp8JpQS4S3eXUOP2cnNtPqWxSEgmyqt6iexEmVrj7ZApu+1ECkGEdh+I+hcmaxfZT8gFjfvjiwCQCEiM/ktU8pBjRvxD22xmaiEp3KJEaZZnlT/kaFmDiP540TgmLyDn41vq9P/KQCaPYqZi6PTLblvUNOcwNNuCbMuQqhk9Uq8AaDFCpK+QZoEYPxMAxxvzQBHQx7wD5NSFRm3YR+E/+Ozk+y//WfkmneWM6U85CAZv9ox32A5WMSQ25Pg4sFj14LtgvL/eOylvCeRUssVWRn2NmRXqSIZ6iwIj4npxU+4UrMvYj2hMt6CV9H9jz7t2roPFvmKi3bAmy0Xb3ccEoyXunztqUlqd1B3xmr4mDeyvr9jgip3y+C+ItWzqc2MLqoP8E9IzuGVjgsbQ9Pnh6qi8Cmc2jx/Eba7y1PE3YScLsfWjnpLS6I+JhJeGZ6WwjVa4LiRNaur2F/aEJR0L/i0GKjg8swlVSwtiVmXGnJNPWDP2KOSLLnqVyOLEpTO8EqUUW5YspbgvJTJ0JAWHda5zU799238Lp33MsRZGrFymHlaW6Hxur8UgS61Q9Tl8BXj/wel0lxOaG3XlDSWiQi4U8vOu1A7DBSpfA7mPB4Z/E1qZ8XyqfQMBo41xTVjecHvtAU0bED/5Hy76KCPzGCA+4Y5FpUf8ZL/siX1aFL4QZg4Pdp
 4wUYbMJf
 dDvert3EUaUBklexSoLAjVm98pniM26xLnzlj5+jiCtzy+oJDgXsGuqUpjyIUFUchQ1FfSaVaLLmQwO4gtSE8CdxqmTDC5s6dFrMicZJc2hkEWVEcROjpK6FcSEA9C1tJmbwTYXtahm0ob73DoQ2Sknx7W/Okja8xSRBpTU5EfhjyldZTh8gOXb4jb6L2BIJ6BJqskCsOUlfv0WFeFklaBYz88QhAOgJFE5kpHwzUQbOXzvkNkJoHOkOrjxfl8qFxFy0IelmkDntcNBJSEtgsUhUQ1qzXAqfkgXD9ZIVU0aQYGifLLDJ4zGftLuWKUVV0YA78
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 14, 2025 at 6:06=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Thu, Aug 14, 2025 at 05:05:56PM -0700, Kuniyuki Iwashima wrote:
> > On Thu, Aug 14, 2025 at 4:46=E2=80=AFPM Shakeel Butt <shakeel.butt@linu=
x.dev> wrote:
> > >
> > > On Thu, Aug 14, 2025 at 04:27:31PM -0700, Kuniyuki Iwashima wrote:
> > > > On Thu, Aug 14, 2025 at 2:44=E2=80=AFPM Shakeel Butt <shakeel.butt@=
linux.dev> wrote:
> > > > >
> > > > > On Thu, Aug 14, 2025 at 08:08:33PM +0000, Kuniyuki Iwashima wrote=
:
> > > > > > When sk_alloc() allocates a socket, mem_cgroup_sk_alloc() sets
> > > > > > sk->sk_memcg based on the current task.
> > > > > >
> > > > > > MPTCP subflow socket creation is triggered from userspace or
> > > > > > an in-kernel worker.
> > > > > >
> > > > > > In the latter case, sk->sk_memcg is not what we want.  So, we f=
ix
> > > > > > it up from the parent socket's sk->sk_memcg in mptcp_attach_cgr=
oup().
> > > > > >
> > > > > > Although the code is placed under #ifdef CONFIG_MEMCG, it is bu=
ried
> > > > > > under #ifdef CONFIG_SOCK_CGROUP_DATA.
> > > > > >
> > > > > > The two configs are orthogonal.  If CONFIG_MEMCG is enabled wit=
hout
> > > > > > CONFIG_SOCK_CGROUP_DATA, the subflow's memory usage is not char=
ged
> > > > > > correctly.
> > > > > >
> > > > > > Let's wrap sock_create_kern() for subflow with set_active_memcg=
()
> > > > > > using the parent sk->sk_memcg.
> > > > > >
> > > > > > Fixes: 3764b0c5651e3 ("mptcp: attach subflow socket to parent c=
group")
> > > > > > Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> > > > > > Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
> > > > > > ---
> > > > > >  mm/memcontrol.c     |  5 ++++-
> > > > > >  net/mptcp/subflow.c | 11 +++--------
> > > > > >  2 files changed, 7 insertions(+), 9 deletions(-)
> > > > > >
> > > > > > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > > > > > index 8dd7fbed5a94..450862e7fd7a 100644
> > > > > > --- a/mm/memcontrol.c
> > > > > > +++ b/mm/memcontrol.c
> > > > > > @@ -5006,8 +5006,11 @@ void mem_cgroup_sk_alloc(struct sock *sk=
)
> > > > > >       if (!in_task())
> > > > > >               return;
> > > > > >
> > > > > > +     memcg =3D current->active_memcg;
> > > > > > +
> > > > >
> > > > > Use active_memcg() instead of current->active_memcg and do before=
 the
> > > > > !in_task() check.
> > > >
> > > > Why not reuse the !in_task() check here ?
> > > > We never use int_active_memcg for socket and also
> > > > know int_active_memcg is always NULL here.
> > > >
> > >
> > > If we are making mem_cgroup_sk_alloc() work with set_active_memcg()
> > > infra then make it work for both in_task() and !in_task() contexts.
> >
> > Considering e876ecc67db80, then I think we should add
> > set_active_memcg_in_task() and active_memcg_in_task().
> >
> > or at least we need WARN_ON() if we want to place active_memcg()
> > before the in_task() check, but this looks ugly.
> >
> >         memcg =3D active_memcg();
> >         if (!in_task() && !memcg)
> >                 return;
> >         DEBUG_NET_WARN_ON_ONCE(!in_task() && memcg))
>
> You don't have to use the code as is. It is just an example. Basically I
> am asking if in future someone does the following:
>
>         // in !in_task() context
>         old_memcg =3D set_active_memcg(new_memcg);
>         sk =3D sk_alloc();
>         set_active_memcg(old_memcg);
>
> mem_cgroup_sk_alloc() should work and associate the sk with the
> new_memcg.
>
> You can manually inline active_memcg() function to avoid multiple
> in_task() checks like below:

Will do so, thanks!


>
> void mem_cgroup_sk_alloc(struct sock *sk)
> {
>         struct mem_cgroup *memcg;
>
>         if (!mem_cgroup_sockets_enabled)
>                 return;
>
>         if (!in_task()) {
>                 memcg =3D this_cpu_read(int_active_memcg);
>
>                 /*
>                  * Do not associate the sock with unrelated interrupted
>                  * task's memcg.
>                  */
>                 if (!memcg)
>                         return;
>         } else {
>                 memcg =3D current->active_memcg;
>         }
>
>         rcu_read_lock();
>         if (likely(!memcg))
>                 memcg =3D mem_cgroup_from_task(current);
>         if (mem_cgroup_is_root(memcg))
>                 goto out;
>         if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && !memcg1_tcpmem_a=
ctive(memcg))
>                 goto out;
>         if (css_tryget(&memcg->css))
>                 sk->sk_memcg =3D memcg;
> out:
>         rcu_read_unlock();
> }
>

