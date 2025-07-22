Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4F22C83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 07:17:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 808898E0002; Tue, 22 Jul 2025 03:17:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B8988E0001; Tue, 22 Jul 2025 03:17:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6A73F8E0002; Tue, 22 Jul 2025 03:17:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 55E658E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 03:17:25 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CA6BE12FA9C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:17:24 +0000 (UTC)
X-FDA: 83691044808.28.7A518C4
Received: from mail-qt1-f170.google.com (mail-qt1-f170.google.com [209.85.160.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id E6B781C0008
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 07:17:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Y9mpMUWB;
	spf=pass (imf21.hostedemail.com: domain of edumazet@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753168643;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k18tpt6MzY4+EfMPJ8+KaJPrYaWfsW1gfyLbK9RchSQ=;
	b=S0ob9qR90pmzaiIq6t7VPknArtnkpz1gcWmB3rlpHuD0MiVTr0IGMqJV3o8gdxQgyDCxK3
	q0BBU86Ta/kIuooMq+5j588jrS47zZGoLjVrX4mLWVPQJdiV3dnt0FnQUfpIWWwRqSp2mv
	ILBUHK+0Wz4KfMa/8A2JlYb55i1CxBI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753168643; a=rsa-sha256;
	cv=none;
	b=IUBQ5A5D4EVcNHV4akV3avsFZJ+RkECLkt97c/lKF6flioLi2z40hhrHbmF+QgNHCrl0+P
	EXQx1kbjvn2AOkGEVAD7VSPYhfG4xH5iOPv6WOSgJEyZhsklGiNQv5cHIDL2A1TiF7CULZ
	EfIlBm6676a0lpcfr07iKUC+NAuYqmg=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Y9mpMUWB;
	spf=pass (imf21.hostedemail.com: domain of edumazet@google.com designates 209.85.160.170 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f170.google.com with SMTP id d75a77b69052e-4ab5e2ae630so61689131cf.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 00:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753168642; x=1753773442; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k18tpt6MzY4+EfMPJ8+KaJPrYaWfsW1gfyLbK9RchSQ=;
        b=Y9mpMUWBEpF3i6AwwxfNVOd07F++hhyq9HvZ6wz6MESNlIfpcVdGgLoLudfYOBmYFr
         l+ax3nvg+pLgsuROcnB1WC5wvCcz5+262EmlGK+6zMhp1CnTzy4VabecRWvMSMB6RC+O
         gyLUpHLXHGaugG/VLKWGioazbk1YckBNrZiaNci/t6l+7lEo9wDAYaKaznA8sRVVvXl9
         Dg6bpKTdgmWK1hxr3vVE1Pb9F/pn/OphPZxOaxrGCN7FnoOL3T1N5Nh0NgrYycltIzdX
         eaAoDRQLo8qBey28B4Z1KUg0UeUyQR/hZbsYpmn1FMurZ8eK2h3cw6QllYzo5GFiK/Wt
         wFdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753168642; x=1753773442;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k18tpt6MzY4+EfMPJ8+KaJPrYaWfsW1gfyLbK9RchSQ=;
        b=K0YGMQV2YLLh0skiU+9A1iwxaxEWkUWhQNOmAjKtfK9jihQqvNq4V6OPRndqURrhQ9
         KG7Um49wvixpeZiBxvqZONTVivuxqSsVfQa9Ye5GNltVFWfqqKXgT2Dm2XUffj6rFbTM
         iPihHnassuEnKr6Ijv42DLQPOVndfEJ7woV+UR+BGuTlMTlAEEltGLw9JTC1ADkIfaaM
         P+vIjA4qC+X55xqjZ9+UnsRa2R6xZ/gdjLJqxajonb95cIYIaVYYtuw5P9hrd7AcQOEs
         D7WkRXuBsZovTcWyvCSjIXmu0AtDbW5sbGd5pFTy78cBvL59URuUJwCoHH8jrSSerGyL
         zvSg==
X-Forwarded-Encrypted: i=1; AJvYcCVVhxX7XkAkGZRWTMEFXVJtpB49vAkClCD8yhqQu+nUBsQTu4MWkgxninYhaPPCKvUCXRq0PwJDfg==@kvack.org
X-Gm-Message-State: AOJu0YxR8SMJ3BImGC+od9EOeI+bwzRhCmV1hzEkHhQMmOJIRs2N9EMH
	TnT8vjwcpBO/JAVxDWnHPF8/IYyZCYxhCCBoJF4qunXqWNB2e8yjqxSEXQfjcLr9PQHvPZk4EaP
	e0LbhA+uRYxrmKXuwY5vkoXJOkQa/9FxWY7dWh4hf
X-Gm-Gg: ASbGnctH7ulEj2DuwGq1ePndKKaW8IBXc6fhQ0gjalV2CGpBClXh7HVsDSLgYwKapIk
	9OC6bE2OLDR8mSSWBsMoBKF86XOVWQn/ONz8IcVBcfQLXXNVUbOowZU2uUjMNsyGd1RjvHb8D7X
	72FuBMQ/25QBiPGd86LoQgr6Fk+0MhOq4uW6iFMw8CtVKfTc8QfKsEA4X4O9EFT6N3iMaFvQELq
	mD2pQ==
X-Google-Smtp-Source: AGHT+IEJqjlyXu7R2eB3u1viFPNlH5wWs/bl/JODZ7kqSRD8a+WDvay6gqWxv9EQQNnkoM6Gc34A9c4Zmm1eApzt1xc=
X-Received: by 2002:a05:622a:1999:b0:4a9:a2e6:da94 with SMTP id
 d75a77b69052e-4ab93ded0c2mr349747361cf.47.1753168641626; Tue, 22 Jul 2025
 00:17:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
In-Reply-To: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 22 Jul 2025 00:17:10 -0700
X-Gm-Features: Ac12FXxLrRoFnAV1nQaQbqwzGzX2Lv_Mk1B6brAV1S6ScCbjXeF5WMlq0NtjP-U
Message-ID: <CANn89i+sAgVOOoowNfqxv7+NrAa+8EzkWTVMP8LeGDJ23sFQpg@mail.gmail.com>
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
	Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, 
	Neal Cardwell <ncardwell@google.com>, Kuniyuki Iwashima <kuniyu@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, 
	netdev@vger.kernel.org, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, cgroups@vger.kernel.org, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E6B781C0008
X-Stat-Signature: kuyqk1y63szouw5edwoczgckxxuz6531
X-Rspam-User: 
X-HE-Tag: 1753168642-200907
X-HE-Meta: U2FsdGVkX19NA6wWTjvYIHFpJto4CL2XWWSpM0oDTOLzaM1jgt08D6geNUrDHGTHRFf9ZFR0o8CTdSiNDYfiF4whex2dQcxXvYIggtonTscIaIBASOy8fHZ81xA2BL++3B4hebLRFjelDR+LP/2a5jInCy6Ff+B2adrXaddIXdoMNsTpWU2ZzEjHtIMl+i1M4GCromTRWGkzDrUD8r9kvcfUckbgePqWdVHBvXHXqOgb178dT14+K840Rl8aLXSVw4yovDYf35P6egtJZjuX8J3UO+Y5gbyu4ZJgz+BmnhGyTly/+CUtUaZgL9rcMTrHYDhOFO1GtPFREiSrDIMYNpi3Xw82jGuErOu0pPBFJClB/ktWJPAm5I4DifgXj1NrAfwFk1C0+Hd7e6XEIxloYRGdb+mAWfwGOrDm3ptDIK7n/sPBf1EqoukCz07TsENDVZkx2LnHcF750Vy6k9p37Fy8zNsXz4EMaSW9kukItdaqMko8aRyhpy45b3QXh7+dVPDa7HDFHnK+8RIVxyAJIiODnkqt1/GD9mZ01Qi3zotuElaVY+a3hK38g1mvTK/Yx0O8sRHXlVsHjP8nMz70WFVNblaSoj+W+kG/eHHGWtwCsSDRR1sdmiG9QOTJ+4kjr4FSpMMhnPrh2AY8Umu4xcilTBPG4fNVbJDhZukwzPz3F1FjhST7LQRwTozU7/5Bx0gar1cDytD1O4iB4mloe03dSL39oqdKiuFQxbMhUZ1sp1NcSbWNuw194pqKd3XIZeVAA4mp+WHEPnXlSxXydrWfhy+R0y/PiY35AfX2bUX0I1x6GiDCQkEgHMIYQUiyi9BBHWjslgXATOfMdTu8kzHyql+WsMHH5mSER1e9G3g3Oph051Laefa53l2C6yF3BcS5v0eXgN6OXKMxJSTVDJe3elk3v7NsT2I63xHJ038VTsIG+pKjG0HoKkPzbCUOgbrj71GTc3UVQDtdizs
 a7RrudZJ
 oyXTs5y1g53eYCePPItvo73/QYp1LRvVYGs/TBt4z9cwh8iG835mHNxDuGN+fL9iWXqMvADYdBgvnhQ982RuiBd2Tuol4mA8CnHcZdmDSTau5OVy+rDcbwBmxdg5rFiMLJD2YX5ho1oxVUUiOtp3v5YW3MtNPGFy4918RQFyaB6oCHc+Qx/PNag64nKZy7tziCVRRYu20oweZfvjmbI0sEWJtqcso3/gEZeAFa1SC59nc+O62h0h+57nYmiGbFXXWfHEE/BDGEci3dW2o4otfV4Gz5ncu79nUnsKbc3PCVMPBX1ZN18THIn6tMbYDJyicyS9APYjuDmCQ8c40oZAGhCj6GHfDPscLS3nzdWBE6MHdBC9yQW4sdAapXcptbGM0L+WQZd6MQIwPMLM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 12:12=E2=80=AFAM Daniel Sedlak <daniel.sedlak@cdn77=
.com> wrote:
>
> This patch is a result of our long-standing debug sessions, where it all
> started as "networking is slow", and TCP network throughput suddenly
> dropped from tens of Gbps to few Mbps, and we could not see anything in
> the kernel log or netstat counters.
>
> Currently, we have two memory pressure counters for TCP sockets [1],
> which we manipulate only when the memory pressure is signalled through
> the proto struct [2]. However, the memory pressure can also be signaled
> through the cgroup memory subsystem, which we do not reflect in the
> netstat counters. In the end, when the cgroup memory subsystem signals
> that it is under pressure, we silently reduce the advertised TCP window
> with tcp_adjust_rcv_ssthresh() to 4*advmss, which causes a significant
> throughput reduction.
>
> Keep in mind that when the cgroup memory subsystem signals the socket
> memory pressure, it affects all sockets used in that cgroup.
>
> This patch exposes a new file for each cgroup in sysfs which signals
> the cgroup socket memory pressure. The file is accessible in
> the following path.
>
>   /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
>
> The output value is an integer matching the internal semantics of the
> struct mem_cgroup for socket_pressure. It is a periodic re-arm clock,
> representing the end of the said socket memory pressure, and once the
> clock is re-armed it is set to jiffies + HZ.
>
> Link: https://elixir.bootlin.com/linux/v6.15.4/source/include/uapi/linux/=
snmp.h#L231-L232 [1]
> Link: https://elixir.bootlin.com/linux/v6.15.4/source/include/net/sock.h#=
L1300-L1301 [2]
> Co-developed-by: Matyas Hurtik <matyas.hurtik@cdn77.com>
> Signed-off-by: Matyas Hurtik <matyas.hurtik@cdn77.com>
> Signed-off-by: Daniel Sedlak <daniel.sedlak@cdn77.com>
> ---
> Changes:
> v2 -> v3:
> - Expose the socket memory pressure on the cgroups instead of netstat
> - Split patch
> - Link: https://lore.kernel.org/netdev/20250714143613.42184-1-daniel.sedl=
ak@cdn77.com/
>
> v1 -> v2:
> - Add tracepoint
> - Link: https://lore.kernel.org/netdev/20250707105205.222558-1-daniel.sed=
lak@cdn77.com/
>
>
>  mm/memcontrol.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
>
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 902da8a9c643..8e8808fb2d7a 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -4647,6 +4647,15 @@ static ssize_t memory_reclaim(struct kernfs_open_f=
ile *of, char *buf,
>         return nbytes;
>  }
>
> +static int memory_socket_pressure_show(struct seq_file *m, void *v)
> +{
> +       struct mem_cgroup *memcg =3D mem_cgroup_from_seq(m);
> +
> +       seq_printf(m, "%lu\n", READ_ONCE(memcg->socket_pressure));
> +
> +       return 0;
> +}
> +
>  static struct cftype memory_files[] =3D {
>         {
>                 .name =3D "current",
> @@ -4718,6 +4727,11 @@ static struct cftype memory_files[] =3D {
>                 .flags =3D CFTYPE_NS_DELEGATABLE,
>                 .write =3D memory_reclaim,
>         },
> +       {
> +               .name =3D "net.socket_pressure",
> +               .flags =3D CFTYPE_NOT_ON_ROOT,
> +               .seq_show =3D memory_socket_pressure_show,
> +       },
>         { }     /* terminate */
>  };
>

It seems you forgot to update Documentation/admin-guide/cgroup-v2.rst

