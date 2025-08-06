Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B8B38C87FD3
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 19:20:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 432A48E0003; Wed,  6 Aug 2025 15:20:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 40A768E0002; Wed,  6 Aug 2025 15:20:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 320318E0003; Wed,  6 Aug 2025 15:20:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2249E8E0002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 15:20:40 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id C678958B9A
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:20:39 +0000 (UTC)
X-FDA: 83747299398.10.C6CE7F0
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf05.hostedemail.com (Postfix) with ESMTP id DD42510000B
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:20:37 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MoDf3wGB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of kuniyu@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754508038;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vlwSPPk3zh2CiPmdVqXCK+PGcDLcMMqnjeuzNG7VVSA=;
	b=qDnsZL7gQrKnycnMQm2eDSRuYUDHGzop+nHCdBO10+OcjbytnkF+FUgfTGfDoewt04GGmJ
	Dham94y+aMOcxPsRRCj5evQIMyQ+1Cwu495mRpMxmcbhW2nc6OYIxTXjG9qFmqLS4/mMps
	5twDnBvw6wfeN7rgJbQ/GTFaKrG0pnM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754508038; a=rsa-sha256;
	cv=none;
	b=GzWZY8fnHloxhg/NO4b2R10nfzCi857xefpn/skhbFuB2Ts0YAgHSJIHQG0NwoyRCv2PYP
	vr9gNjRFTf/Trbm9QKGarI3zQBE87k3AKa1989Ei40P3LnbYpSRZ7w0fPFAK1hchxIg3a0
	KXNa0xIclWTb3jMzqkLOOkgHNuZDGIU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=MoDf3wGB;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf05.hostedemail.com: domain of kuniyu@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=kuniyu@google.com
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2403c13cac3so10335735ad.0
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 12:20:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754508037; x=1755112837; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vlwSPPk3zh2CiPmdVqXCK+PGcDLcMMqnjeuzNG7VVSA=;
        b=MoDf3wGBWvJVdJx/HSgKVD15dTw01QaR8rL0rBWO9P8QbFuKQYX65edxxNWw7Pzm2j
         e04G7ySI11hs2IXKPy4w/Q4ah1z43iEaJJxsyo4yuoR/zpj+L3Q6QHGapX2HwNCluChV
         lB0VRfo3UjHRuxYri4YYSR+zuoGRn+A2bPJizyzb6mg0LfaDZDR37WwE6ssNFaWGzIFt
         3l8z6AJaCPQ0fEQPM2ZF+ZY14l1W4h4omwU8mdW3U19NwBTmtk0JnvYDqcbC1YNXQKfX
         deF6q1OIXHnZhodvvSRPDuQDHfmh3feNCq+XYOxoPtWpzl1/NaUwqAvNRMlpMY2FEIvn
         g9zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754508037; x=1755112837;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vlwSPPk3zh2CiPmdVqXCK+PGcDLcMMqnjeuzNG7VVSA=;
        b=bp1NADVGyWyZvxafGhZp+tWLyCfomwdW27RfyDnx1M8hU/xl568+TY3QnG/Ave0OXE
         CT6wXsOhwQdc9n04HZycIr+n6Yo++rID+nXyRy11pIVOeKirAWXc1UK2aZN/LZjUuTEf
         T9p7/Ilh4i6pRkW8R8eRgeQm9VxlR3IcsCUOhMrnVltmBwy+oOQcY/HFduc8Ru84UnOV
         YHLDrWPBWOYp8nAyXJKtI7lL2gLMdPuP9QYADHJmlMyLWzF0YbSgZ9Z/oTm5gTAlDHZ+
         iXcAa/bql2kyoqRaSk+6cyabYPF3YDu91j22rF1hqiSE30FSY30InAXenF9wwaKM6w1E
         f2OA==
X-Forwarded-Encrypted: i=1; AJvYcCVGzjHy8fK6e65pIyAiJSpLn6ZGZEm0uURIiSiaGSBE7RYSYC5s8UHrJqzPuArFM8JjM253knQUHw==@kvack.org
X-Gm-Message-State: AOJu0YyNWFRn/UlP45XgSm/8FZJsuUjq7C4Dg2Ba7rN6WHx3/h9+ucvC
	JSbyNhGxJVwRzVHMDdG5dNS1kbwpt5MGfLjKIReY6Tv8G6qsbyXTKg/J2DGwnoGoApx6+czvTp3
	LTSrp442TKHfXIk5qYqBiV2y5BxLaIn888Yg38WtpQraNPDr1HlLh07FZ
X-Gm-Gg: ASbGncv8BiyBHsHJJZVZYGhWvLJvWNo87xvrZ3WY2PqTyadsFaKuBBjSXYwjaTu45gW
	zt4pcgk6CJU3SCgI31Lj5pCyorCp4eFv6gbJZjz9657zTEXiFpE/krLZcZQjdS6tRuuGqZ0QkR0
	fu/IXkxTCE+xvmOMycr9mHt6BuRV4QxnJG3blB9BJkMgMX2pups8qDyXV5PWBa51oTpvn474wT0
	iS5681vLD0f2cGuBfQvaI3pdS9m+nwSx42JjQ==
X-Google-Smtp-Source: AGHT+IFxu1qOt0d8Ya0ox+N19/1UV6+3t1Ff6v4R83F4G2adOyfF/EwYs87dnaZxJVxmA9LvZiQKWITP/CjagDvnBGQ=
X-Received: by 2002:a17:902:e751:b0:240:417d:8166 with SMTP id
 d9443c01a7336-242b06e7164mr9555095ad.19.1754508036289; Wed, 06 Aug 2025
 12:20:36 -0700 (PDT)
MIME-Version: 1.0
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com> <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
In-Reply-To: <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 6 Aug 2025 12:20:25 -0700
X-Gm-Features: Ac12FXzJnBZFvHp4SW91p6FAcWqq_WSkdxhE_YNRj03saLxF9wSquf_4XkIv_5U
Message-ID: <CAAVpQUBrNTFw34Kkh=b2bpa8aKd4XSnZUa6a18zkMjVrBqNHWw@mail.gmail.com>
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: DD42510000B
X-Stat-Signature: caer9sfdsgfthod7ji1e8ya6rn37rfnt
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754508037-882630
X-HE-Meta: U2FsdGVkX1/PCMYE9ix8TuFFJWwXNXH87+DAGFYMU9Ta+JCW0CCpaPhpIiKFOBihl3CBxSkqBgeTWl115bxJ5qQRfl2Zon9sBOToxMJoiUZx2oVZc3Cso3JJZjWQH4bxYsIdLnMWISWz/a655HA8MaVUARNlD8J3aQhBiU0hRhscskSMraQWa/S5UJvubjLCMJu10gC77mV6YYmJTQvUIf89dPRUm+eKxpwB7B5HEERrDohhgDkAyRygNWXu0eYbT+WA0gNHLJN22zlOM429AHrfSuNJvZZGf1FC4JEHkfFKfaIYxCg7gWimuHjISFbj8W2noIeVZwbFRBLnk2Tymkal5YWfacUgooy077QPGTapjqdMVtNGZVSoxQmSTFIw51cFy5uHs2busRQIMswW+nPZkNmLHJ2rmpIIOzS1yP0pNaOeLLe+hYYf1lqlaWYBjA/Fe45aM1KXUOm4OURopf4lYMFVdF0aV101p3A1KWW0bohmHd3Be7gcUpCa2e77AUVBTnNhs4dQYVsEI4214JRCZ2m/337kKuST7a/ogTWjE0tzDLKvaC6CthYM8MbOTC97TVvotLE9YY/iKpHmpmU7D14LJAqosG2VrZaniyb7PXNrRPy+SSy3ZINZQGupu692Aj7plY7niBCKZ5L/gBGQcYoUZSqfaHyiUiYeeUrJ8EkYNFOFDBFu3J0WV7HRFdTMiRri5k6ny8h2SCGIW/oG1chzsRzGcBrFByKd71dUBHVOmwDNSzN0bXarTPKKBoVKphwkhnBdxEQSGiro5ns7JuAC5DlOkN6OLI5AlsSvX10D6y6YA/prboSjOKMcmbs6n5qB6CByuZD260GmL01rzx/qK7r6eVAIovk9eEV2bRAQM9JNfH/ut3AD/+5+q7PPrxj1TETapmKe4mPTxu7uZuXhz2P8LIKWkNscLY9LkhorbS/MF7Dwk4knRQ7o1E6byOGs7m/kogdHj8y
 WxNw8ega
 U0fxg3xbu1MLyOoQFDEhbqEAJo7ajxJ3/rjyOpI7BUsf0WH2chi3BpJS248pqoQbyma71Oac7KArUjLw3du9sa/6WIVahedK93b4qt9JQq1EhWRYn83hJw8PRQKIpDXzQcFe2zw2gxZUa2G5fMkXFJJpef9t0cAqoe1P/sLAy1nx0b42cTHoy4olmZ9DAIW09noqkHf19PbmOvWeA+4MLfe1HTR6qvjUhn5mLM+tW7gIK0x5dJ4/FbhBxAD9boY2FVNRiDKErdtr5dLQfVXwa8cIHbbuhY/GqimamxzpczIZBIjJWMJe/1fgU5hpUsvojiq3+amqSBB4xtWIfnVMxwT4OEdliIIE0sMkzF5q14lCOAL3j64hXL8IL3BPyQ1tUsquf9U9ZqmOMCs7Pw7g2VeEirLOrln9DusTJTuntX78FLOaVv5cUK0SKEg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 5, 2025 at 4:02=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.dev=
> wrote:
>
> On Tue, Aug 05, 2025 at 08:44:29AM +0200, Daniel Sedlak wrote:
> > This patch is a result of our long-standing debug sessions, where it al=
l
> > started as "networking is slow", and TCP network throughput suddenly
> > dropped from tens of Gbps to few Mbps, and we could not see anything in
> > the kernel log or netstat counters.
> >
> > Currently, we have two memory pressure counters for TCP sockets [1],
> > which we manipulate only when the memory pressure is signalled through
> > the proto struct [2]. However, the memory pressure can also be signaled
> > through the cgroup memory subsystem, which we do not reflect in the
> > netstat counters. In the end, when the cgroup memory subsystem signals
> > that it is under pressure, we silently reduce the advertised TCP window
> > with tcp_adjust_rcv_ssthresh() to 4*advmss, which causes a significant
> > throughput reduction.
> >
> > Keep in mind that when the cgroup memory subsystem signals the socket
> > memory pressure, it affects all sockets used in that cgroup.
> >
> > This patch exposes a new file for each cgroup in sysfs which signals
> > the cgroup socket memory pressure. The file is accessible in
> > the following path.
> >
> >   /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
>
> let's keep the name concise. Maybe memory.net.pressure?
>
> >
> > The output value is a cumulative sum of microseconds spent
> > under pressure for that particular cgroup.
> >
> > Link: https://elixir.bootlin.com/linux/v6.15.4/source/include/uapi/linu=
x/snmp.h#L231-L232 [1]
> > Link: https://elixir.bootlin.com/linux/v6.15.4/source/include/net/sock.=
h#L1300-L1301 [2]
> > Co-developed-by: Matyas Hurtik <matyas.hurtik@cdn77.com>
> > Signed-off-by: Matyas Hurtik <matyas.hurtik@cdn77.com>
> > Signed-off-by: Daniel Sedlak <daniel.sedlak@cdn77.com>
> > ---
> > Changes:
> > v3 -> v4:
> > - Add documentation
> > - Expose pressure as cummulative counter in microseconds
> > - Link to v3: https://lore.kernel.org/netdev/20250722071146.48616-1-dan=
iel.sedlak@cdn77.com/
> >
> > v2 -> v3:
> > - Expose the socket memory pressure on the cgroups instead of netstat
> > - Split patch
> > - Link to v2: https://lore.kernel.org/netdev/20250714143613.42184-1-dan=
iel.sedlak@cdn77.com/
> >
> > v1 -> v2:
> > - Add tracepoint
> > - Link to v1: https://lore.kernel.org/netdev/20250707105205.222558-1-da=
niel.sedlak@cdn77.com/
> >
> >  Documentation/admin-guide/cgroup-v2.rst |  7 +++++++
> >  include/linux/memcontrol.h              |  2 ++
> >  mm/memcontrol.c                         | 15 +++++++++++++++
> >  mm/vmpressure.c                         |  9 ++++++++-
> >  4 files changed, 32 insertions(+), 1 deletion(-)
> >
> > diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/ad=
min-guide/cgroup-v2.rst
> > index 0cc35a14afbe..c810b449fb3d 100644
> > --- a/Documentation/admin-guide/cgroup-v2.rst
> > +++ b/Documentation/admin-guide/cgroup-v2.rst
> > @@ -1884,6 +1884,13 @@ The following nested keys are defined.
> >       Shows pressure stall information for memory. See
> >       :ref:`Documentation/accounting/psi.rst <psi>` for details.
> >
> > +  memory.net.socket_pressure
> > +     A read-only single value file showing how many microseconds
> > +     all sockets within that cgroup spent under pressure.
> > +
> > +     Note that when the sockets are under pressure, the networking
> > +     throughput can be significantly degraded.
> > +
> >
> >  Usage Guidelines
> >  ~~~~~~~~~~~~~~~~
> > diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> > index 87b6688f124a..6a1cb9a99b88 100644
> > --- a/include/linux/memcontrol.h
> > +++ b/include/linux/memcontrol.h
> > @@ -252,6 +252,8 @@ struct mem_cgroup {
> >        * where socket memory is accounted/charged separately.
> >        */
> >       unsigned long           socket_pressure;
> > +     /* exported statistic for memory.net.socket_pressure */
> > +     unsigned long           socket_pressure_duration;
>
> I think atomic_long_t would be better.
>
> >
> >       int kmemcg_id;
> >       /*
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 902da8a9c643..8e299d94c073 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -3758,6 +3758,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct=
 mem_cgroup *parent)
> >       INIT_LIST_HEAD(&memcg->swap_peaks);
> >       spin_lock_init(&memcg->peaks_lock);
> >       memcg->socket_pressure =3D jiffies;
> > +     memcg->socket_pressure_duration =3D 0;
> >       memcg1_memcg_init(memcg);
> >       memcg->kmemcg_id =3D -1;
> >       INIT_LIST_HEAD(&memcg->objcg_list);
> > @@ -4647,6 +4648,15 @@ static ssize_t memory_reclaim(struct kernfs_open=
_file *of, char *buf,
> >       return nbytes;
> >  }
> >
> > +static int memory_socket_pressure_show(struct seq_file *m, void *v)
> > +{
> > +     struct mem_cgroup *memcg =3D mem_cgroup_from_seq(m);
> > +
> > +     seq_printf(m, "%lu\n", READ_ONCE(memcg->socket_pressure_duration)=
);
> > +
> > +     return 0;
> > +}
> > +
> >  static struct cftype memory_files[] =3D {
> >       {
> >               .name =3D "current",
> > @@ -4718,6 +4728,11 @@ static struct cftype memory_files[] =3D {
> >               .flags =3D CFTYPE_NS_DELEGATABLE,
> >               .write =3D memory_reclaim,
> >       },
> > +     {
> > +             .name =3D "net.socket_pressure",
> > +             .flags =3D CFTYPE_NOT_ON_ROOT,
> > +             .seq_show =3D memory_socket_pressure_show,
> > +     },
> >       { }     /* terminate */
> >  };
> >
> > diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> > index bd5183dfd879..1e767cd8aa08 100644
> > --- a/mm/vmpressure.c
> > +++ b/mm/vmpressure.c
> > @@ -308,6 +308,8 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg=
, bool tree,
> >               level =3D vmpressure_calc_level(scanned, reclaimed);
> >
> >               if (level > VMPRESSURE_LOW) {
> > +                     unsigned long socket_pressure;
> > +                     unsigned long jiffies_diff;
> >                       /*
> >                        * Let the socket buffer allocator know that
> >                        * we are having trouble reclaiming LRU pages.
> > @@ -316,7 +318,12 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memc=
g, bool tree,
> >                        * asserted for a second in which subsequent
> >                        * pressure events can occur.
> >                        */
> > -                     WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
> > +                     socket_pressure =3D jiffies + HZ;
> > +
> > +                     jiffies_diff =3D min(socket_pressure - READ_ONCE(=
memcg->socket_pressure), HZ);
> > +                     memcg->socket_pressure_duration +=3D jiffies_to_u=
secs(jiffies_diff);
>
> KCSAN will complain about this. I think we can use atomic_long_add() and
> don't need the one with strict ordering.

Assuming from atomic_ that vmpressure() could be called concurrently
for the same memcg, should we protect socket_pressure and duration
within the same lock instead of mixing WRITE/READ_ONCE() and
atomic?  Otherwise jiffies_diff could be incorrect (the error is smaller
than HZ though).


>
> > +
> > +                     WRITE_ONCE(memcg->socket_pressure, socket_pressur=
e);
> >               }
> >       }
> >  }
> >
> > base-commit: e96ee511c906c59b7c4e6efd9d9b33917730e000
> > --
> > 2.39.5
> >

