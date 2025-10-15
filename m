Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCFEBCCD199
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 18:21:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 254668E0081; Wed, 15 Oct 2025 14:21:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22C218E006F; Wed, 15 Oct 2025 14:21:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 11B1E8E0081; Wed, 15 Oct 2025 14:21:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id ECFEB8E006F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:21:32 -0400 (EDT)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A45CE86213
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:21:32 +0000 (UTC)
X-FDA: 84001166424.11.C1E5F22
Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	by imf01.hostedemail.com (Postfix) with ESMTP id BAA8740005
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 18:21:30 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fmgknhnT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760552490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vp64OOTDMMU/j1+qMmwGSQ8xybomTCKVWDp1nxfRYIs=;
	b=2J/+VVuPU0WtvZp+VF12Rw/wkVG9NIb4jmFjGLQFi78NaN/kS5c7foBwGBx6Z97vB/I9Oz
	9fDuie1miMUlHu7CD6De2l7rcusfIl4S01pkKQCaHPCuuBPpIrKWMyyRanyysOBYXlVZcv
	JSuAy6sAlL7P8XLRXeSFhMFmZDc+vs4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fmgknhnT;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.174 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760552490; a=rsa-sha256;
	cv=none;
	b=XY2ubH0jfGHmzXBdgjmHzvSMznhVGCWLGYNivyN6KaJa6N7zAlnanwVrnHJjqntNJEXZ+e
	R66YNbPpQlx+SAAN9rC4ki5zL7xfU8O8uHsnDKWSPuXtAE6P3OSRYllzLDZ/0yos3oDcpu
	rw6CO45kZnHYwkTw8SJeCXPqxZHDHWY=
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b5526b7c54eso4228200a12.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 11:21:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760552489; x=1761157289; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vp64OOTDMMU/j1+qMmwGSQ8xybomTCKVWDp1nxfRYIs=;
        b=fmgknhnT6PW1vRH/gFy7LgqNGC9kjUV2G7FNccC8Py86TUy4FkwImEGoLGs7K7YJkX
         XoFVOU4F9MwLLSttWdQnGrnPJS5VRHNwHxgyZu5ze9IGKH8ckjlTy+HQAMa62dlNMLZc
         nMWCdh0wjyQVZ7p/xrcT7789LOM1VWrYwzRLIEg70sZrUU5DyQQQRQF/eQIkidQ0LDp8
         0DEXU4QkrlM8pQamKk/XZNI5eXybEhRJ0DZWP4O+PXNao5BE+0/n6gi6Ct/V2Na/UoQI
         bBmKcpNSTSZbD1AHWfT8es33aqPZbYsW9ZZCPk4rPi84r0rzR8EAwDZ54A7t8kjLyr3R
         jLNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760552489; x=1761157289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vp64OOTDMMU/j1+qMmwGSQ8xybomTCKVWDp1nxfRYIs=;
        b=wKq1CgCjbynybUXWN/30mgpn5F2wGqBmVTNnjSBLtfeF41OlvYz+3rHsQm2t7tEVpW
         7L6E4OQpkWj9cDWMWc0FwwSj1bYSgVYwcS6n4UHY4sZD6CrLHYeU/eg0MNLN2nMtsvpV
         I54Rbl8IdjPae99qVB+MslHY+hO53SIdebNlnM4TSVGYIgJri3Utwhq0zblpMN4S5pqS
         JhaDFhYvEAowzrSxsCraDkG99Huph/ahyQInebeiRXFt8nJ0B54uSI8fg5OyrXOKNNS4
         GR5ul6GaMJtbo0G5suQ3oq11KFbtyo7/CGv6XQUYowFhAQz7SCFBERYgvdlqaQpbvvJH
         b3hQ==
X-Forwarded-Encrypted: i=1; AJvYcCVXjrKnXQgf6GPTGoo8F7JzpTH3O8kvyTuUzcj0GNfjnsBB/7D5ROD8OR1wa5QPX4KuE9HlKO+5Cw==@kvack.org
X-Gm-Message-State: AOJu0Yxasy1tkJcpNSSAhmRfoeq8KdKbbdEascmVwXwWJUSVMfuiB6t8
	a8SWldc82uCMxqRsJWap3qCcsRYDakvrg3GVy58+MkWtcKNdAH9OCXR7LFjxk1haefTtxmTkKYY
	9SSdCdfD50RysQHyPEjWMO7KnqdPSfFC9kUgL10lE
X-Gm-Gg: ASbGncsk4c/9x2yz6CkNRTMSnhwe6jfcUHb5TDD/PkN6iGDwew3Bmad0zHI0iZGpzCf
	UaxVaFZ3LqR5HgfhB6Ao5z+NF6SolSk+JE9O1AwfjAb2P4pCfnPHYvgDk0knd6XfP0us8bdAigd
	JZASTAUf8jbbRMXXXAEASrJuxRHz0i73LYQV++YNVyzRTvdv14JA5NQlzKS4qMYViUhVejS8k76
	5+ZW0Mlq90j9iMuFehbtpiD5sp/3kXezLfL9O1lrX+spVt8/eIpSGCxAKJf/0rtAn26Dx08RQ==
X-Google-Smtp-Source: AGHT+IFv6ZDTbnlyEa7PGKtiy3BHZqh5Atg4snl51qJOvPQs/NM5tOMV7CkHZGYdvUsd7R4gGq+3ZXyx9BwkDCSqhj0=
X-Received: by 2002:a17:902:e841:b0:273:59ef:4c30 with SMTP id
 d9443c01a7336-2902723a7ffmr425859825ad.15.1760552489053; Wed, 15 Oct 2025
 11:21:29 -0700 (PDT)
MIME-Version: 1.0
References: <20251007125056.115379-1-daniel.sedlak@cdn77.com>
 <87qzvdqkyh.fsf@linux.dev> <13b5aeb6-ee0a-4b5b-a33a-e1d1d6f7f60e@cdn77.com>
 <87o6qgnl9w.fsf@linux.dev> <tr7hsmxqqwpwconofyr2a6czorimltte5zp34sp6tasept3t4j@ij7acnr6dpjp>
 <87a5205544.fsf@linux.dev> <qdblzbalf3xqohvw2az3iogevzvgn3c3k64nsmyv2hsxyhw7r4@oo7yrgsume2h>
 <875xcn526v.fsf@linux.dev> <89618dcb-7fe3-4f15-931b-17929287c323@cdn77.com> <6ras4hgv32qkkbh6e6btnnwfh2xnpmoftanw4xlbfrekhskpkk@frz4uyuh64eq>
In-Reply-To: <6ras4hgv32qkkbh6e6btnnwfh2xnpmoftanw4xlbfrekhskpkk@frz4uyuh64eq>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 15 Oct 2025 11:21:17 -0700
X-Gm-Features: AS18NWBl8DBuSyVQ5CvtXUGkTQXtnvm6oLLrRN_Q_tBNBRmemTwaIbj89yQ-PKI
Message-ID: <CAAVpQUDWKaB6jH3Ouyx35z5eUb9GKfgHS0H7ngcPEFeBdtPjRw@mail.gmail.com>
Subject: Re: [PATCH v5] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	"David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, David Ahern <dsahern@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, 
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Tejun Heo <tj@kernel.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: BAA8740005
X-Rspamd-Server: rspam03
X-Stat-Signature: 97mkxiitp3ncdaaaphmryuxim7i8oe3p
X-HE-Tag: 1760552490-966882
X-HE-Meta: U2FsdGVkX19tHPnU40ESVIg+5ELlV2nZyNSsVQcwRJhbYDxajPHAss0AvpQLMwWB1nnSm4XZC4cWUzsdSw2EIR/Y4+q8Qr6n1GIBYvtmf274/1H5ze5Qk/pNrOSpOg2m8S4ccFgfS6vV+uJoX2xUu7PSP7CwjBp4FjKqCpJjTpWjBmFOFyzNMP4u+GDeGkhxnqRfsLULS8UGt793/fBxsQYZBzIbgjqa70bwKdYx/RdoS6xJeYiG1ron+bTnYPcn98RzkD0hW7C6ZPoZNexhk4J11ucc3i8Ov1Zkq5BLIi0OYuK9RgJjcaaNdkS/hsftApvVyJ6f3ESl+4pDWyVp5qggN7yYDNk2hWSFTfK8lVNzreBN3JHLSKOr8konQWb/B2egLhZ9dIlK0CTrIm8zl7bv9PEFY7ZuOnELwXerlGxCZJz9NyN2L0239IpXInRNeskoTS0NLHBZAZiZRQ5iuJEhH0LhOYXVxqUeDj5iGw/kgQRhdWWKxnMUlCjFM1zSi37KY3zuVQsZGK3eLNmr5X06VVMICwWrdK0QIrHQrL67SEJjdiiN3pgfoWiA6pikxCXabsvoXHMEMrJBl9kIgZ5RhL4HbVpwrIry1KovE0f18ySY0qC+zzJcHsbuN9cw5VoSFl0JeJHrJB0cz/y/CxipV/uv1vOgCva7qb8okxScD2nTduQ7bpHu2BYrlHR/b8Fo72wdwjANRviNL6Ls9WcpfyxXrXv/MVmKTNqDFo9+KlTbCf+kaDzPyXEIHz2p6us4GP5ddLYQXNG+0Njes7V5Feaa6tEJ0uQrOV/yUfN8Y3gNYjFsFPf3+u9XkK5kdxJ1Rxx08sqxoxp+nlU2ehrQFbtfh7BAqpo/AZ8ZS+uNjJNyzhzycUnR26DzT0QadPsYWAaUCQqPlepy5exnrekhxnrfeI7Jek+eGHTDL0Jz7e1InQ/8X0RV3MSZtKrq+wNCLHC7ykGIZg781xe
 VfLtQtcy
 SNNgiwaGJj/u5KOolTjGJuFN6v9/hCxMbhIdgTQCbOPUeS4hJacTP57S2AE7d6jeUN81JHM7YOuBCZHQwXhnBWX8teAFblWYT2zUfZHgeNZd/EgqM7zHW0Dbv5ICJqafo54Bgrb4qYByxhawAufLbsZ+PT4TjNZlBKcB1VtHByXY1yaHZFU7ZppkVWitc1d0vkdP7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 1:33=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.de=
v> wrote:
>
> On Mon, Oct 13, 2025 at 04:30:53PM +0200, Daniel Sedlak wrote:
> [...]
> > > > > > How about we track the actions taken by the callers of
> > > > > > mem_cgroup_sk_under_memory_pressure()? Basically if network sta=
ck
> > > > > > reduces the buffer size or whatever the other actions it may ta=
ke when
> > > > > > mem_cgroup_sk_under_memory_pressure() returns, tracking those a=
ctions
> > > > > > is what I think is needed here, at least for the debugging use-=
case.
> >
> > I am not against it, but I feel that conveying those tracked actions (o=
r how
> > to represent them) to the user will be much harder. Are there already
> > existing APIs to push this information to the user?
> >
>
> I discussed with Wei Wang and she suggested we should start tracking the
> calls to tcp_adjust_rcv_ssthresh() first. So, something like the
> following. I would like feedback frm networking folks as well:

I think we could simply put memcg_memory_event() in
mem_cgroup_sk_under_memory_pressure() when it returns
true.

Other than tcp_adjust_rcv_ssthresh(), if tcp_under_memory_pressure()
returns true, it indicates something bad will happen, failure to expand
rcvbuf and sndbuf, need to prune out-of-order queue more aggressively,
FIN deferred to a retransmitted packet.

Also, we could cover mptcp and sctp too.



>
>
> From 54bd2bf6681c1c694295646532f2a62a205ee41a Mon Sep 17 00:00:00 2001
> From: Shakeel Butt <shakeel.butt@linux.dev>
> Date: Tue, 14 Oct 2025 13:27:36 -0700
> Subject: [PATCH] memcg: track network throttling due to memcg memory pres=
sure
>
> Signed-off-by: Shakeel Butt <shakeel.butt@linux.dev>
> ---
>  include/linux/memcontrol.h | 1 +
>  mm/memcontrol.c            | 2 ++
>  net/ipv4/tcp_input.c       | 5 ++++-
>  net/ipv4/tcp_output.c      | 8 ++++++--
>  4 files changed, 13 insertions(+), 3 deletions(-)
>
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 873e510d6f8d..5fe254813123 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -52,6 +52,7 @@ enum memcg_memory_event {
>         MEMCG_SWAP_HIGH,
>         MEMCG_SWAP_MAX,
>         MEMCG_SWAP_FAIL,
> +       MEMCG_SOCK_THROTTLED,
>         MEMCG_NR_MEMORY_EVENTS,
>  };
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 4deda33625f4..9207bba34e2e 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4463,6 +4463,8 @@ static void __memory_events_show(struct seq_file *m=
, atomic_long_t *events)
>                    atomic_long_read(&events[MEMCG_OOM_KILL]));
>         seq_printf(m, "oom_group_kill %lu\n",
>                    atomic_long_read(&events[MEMCG_OOM_GROUP_KILL]));
> +       seq_printf(m, "sock_throttled %lu\n",
> +                  atomic_long_read(&events[MEMCG_SOCK_THROTTLED]));
>  }
>
>  static int memory_events_show(struct seq_file *m, void *v)
> diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
> index 31ea5af49f2d..2206968fb505 100644
> --- a/net/ipv4/tcp_input.c
> +++ b/net/ipv4/tcp_input.c
> @@ -713,6 +713,7 @@ static void tcp_grow_window(struct sock *sk, const st=
ruct sk_buff *skb,
>                  * Adjust rcv_ssthresh according to reserved mem
>                  */
>                 tcp_adjust_rcv_ssthresh(sk);
> +               memcg_memory_event(sk->sk_memcg, MEMCG_SOCK_THROTTLED);
>         }
>  }
>
> @@ -5764,8 +5765,10 @@ static int tcp_prune_queue(struct sock *sk, const =
struct sk_buff *in_skb)
>
>         if (!tcp_can_ingest(sk, in_skb))
>                 tcp_clamp_window(sk);
> -       else if (tcp_under_memory_pressure(sk))
> +       else if (tcp_under_memory_pressure(sk)) {
>                 tcp_adjust_rcv_ssthresh(sk);
> +               memcg_memory_event(sk->sk_memcg, MEMCG_SOCK_THROTTLED);
> +       }
>
>         if (tcp_can_ingest(sk, in_skb))
>                 return 0;
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index bb3576ac0ad7..8fe8d973d7ac 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -3275,8 +3275,10 @@ u32 __tcp_select_window(struct sock *sk)
>         if (free_space < (full_space >> 1)) {
>                 icsk->icsk_ack.quick =3D 0;
>
> -               if (tcp_under_memory_pressure(sk))
> +               if (tcp_under_memory_pressure(sk)) {
>                         tcp_adjust_rcv_ssthresh(sk);
> +                       memcg_memory_event(sk->sk_memcg, MEMCG_SOCK_THROT=
TLED);
> +               }
>
>                 /* free_space might become our new window, make sure we d=
on't
>                  * increase it due to wscale.
> @@ -3334,8 +3336,10 @@ u32 __tcp_select_window(struct sock *sk)
>         if (free_space < (full_space >> 1)) {
>                 icsk->icsk_ack.quick =3D 0;
>
> -               if (tcp_under_memory_pressure(sk))
> +               if (tcp_under_memory_pressure(sk)) {
>                         tcp_adjust_rcv_ssthresh(sk);
> +                       memcg_memory_event(sk->sk_memcg, MEMCG_SOCK_THROT=
TLED);
> +               }
>
>                 /* if free space is too low, return a zero window */
>                 if (free_space < (allowed_space >> 4) || free_space < mss=
 ||
> --
> 2.47.3
>

