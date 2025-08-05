Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A369C87FCB
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 15:54:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06D328E0005; Tue,  5 Aug 2025 11:54:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F39AC8E0001; Tue,  5 Aug 2025 11:54:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E27A98E0005; Tue,  5 Aug 2025 11:54:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CFA4E8E0001
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 11:54:24 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8006880112
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:54:24 +0000 (UTC)
X-FDA: 83743150848.21.408D22E
Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id 9AEC78000E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 15:54:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VhCUjTLF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754409262;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXmcYBuTBSIC3cXLyf6AFT7dpi3YTNsScaWP3ZbN8Fs=;
	b=JjwXlla3ZeCsYJg43xBT55c9k69v8LLSPKstqL+KXH+ZORWtNG0Ao/5m/Yg+NsSQ9lp/n6
	rlWjva+0GIVF2b9yP77nftv0ccF8pr9C2+Ctdr91VnvvmFp+Cv/ZTfU9dpITP4KxwhTn1C
	7VKS/GwxOpwTg7C0WQ32XYJ1PnMaGsU=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754409262; a=rsa-sha256;
	cv=none;
	b=c5egimmx130t48NGynQzGHek9/ah4DEkv+A/Ve5MINRii/glBVgZNhZcRdYm2o5uoa9olj
	ia+KRCPXGAmHz67LMnIzM09QViFUJNwcugM+nSURIc6powtrhLU69Q1HjlW+/4sh8cI2gr
	KDhIdtupNz8/C/wa/cW+P6TYvnr0DQk=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VhCUjTLF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf02.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.179 as permitted sender) smtp.mailfrom=kuniyu@google.com
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b170c99aa49so3762794a12.1
        for <linux-mm@kvack.org>; Tue, 05 Aug 2025 08:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754409261; x=1755014061; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXmcYBuTBSIC3cXLyf6AFT7dpi3YTNsScaWP3ZbN8Fs=;
        b=VhCUjTLFK4Y8PiFlH1yF77BbG/qkbqzUuYt3OHXh/ZfctVvCz3i20MwT1yGcO6cPLO
         FWNhZ+0JEJMHN4LOnxkyTVptew2PvAtVPPkEe9QOmTh7hh8Nr0UbUGneR0k5GXrX1lea
         l7ispILF/lpvYcArvCOwgLA67+Y7D/NxxQOr1xho/xfyi5C3Q5Sa74Qqf3235GLdM030
         IJZ9NKOT42/XcM+SIXJK2ZQBgak6ZCqzuMNuJF3TsII+x+lhXmxaRqvU2aTndB0pG9ms
         ipqZ5czUaK3AaEadWa2KE2uYmbnyoy080bgMa4nJAkyvn1gq7/AoQTqqNCVPqL0hb587
         f54w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754409261; x=1755014061;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DXmcYBuTBSIC3cXLyf6AFT7dpi3YTNsScaWP3ZbN8Fs=;
        b=QnMwnkjYrirTMAREHjpOvfV3B/xGBBFs5kPcm+1roaJuD3EiNUIfFGJt2d9nFqSivD
         o1DghVogq7i5ki75NMS9IWSwIMvA50Fhdg5BHPLA6DHkfr13G4SXh3TwkVnXxQFCHB2V
         lkKx8e/MxN2g3pr33nlw4hzf/LH5yatRXLGiR02QMBc9WT5+UF4iHaqkqyeo56+wa44P
         f9hND5dTcPwA+ML2h7YqnSxXI6lcwfD+pEyest8y6UwKAa/X3nNIY+RTgGc3FpAqZa8z
         XiWRA8NxbiYW1pOKhHwzLTLYlriRfXFCNwPPY/L6WCJUAFP3O0WTZNSZbNoU2B1p1u7E
         jjCw==
X-Forwarded-Encrypted: i=1; AJvYcCVhaxsFrTcAxAcAA5rafkUgfsbQrQUN2NpMF6sRI/1n8eZEDYagTe85QyoWudjsAHtpxVJ3faSWEg==@kvack.org
X-Gm-Message-State: AOJu0YyyAOMn6RZOuoLD0cTkHa8b1WjB8e/WQy2JFMHDPtUDbkXqW1gX
	FnhYziseHPxSvivgkqQ6wzLwfDRjcZRhlwiHleIrVvAp7OXw7N31yeWbJnErFSi84XZnjRIKfKB
	YUwpXLm7Iu+12NQVQtmOp+b0iVVWd8uwYkxvVWpq+
X-Gm-Gg: ASbGncuHVah6W1Fed1JvhRG11xH79DjLXxccg+FqLUdMm9heVpyebGPff0cnmJ/KT/+
	B9FIAmJf8p6MB4ZA5Sv6Jvu1uXqKH4ljSNZjmgwFUYLJaOj8O862rWHq8nB8QNNTHAQsWWEJsCm
	fkXOIRj57PPpLookFatDgUOYjg6e7PT9G5CjjYNLuT6aR5gBJDg2QKTyX6o9sti310uaSviZnsT
	8x8GdQ=
X-Google-Smtp-Source: AGHT+IGDJF1zGd354VGsk1JYD0WGO/qVAFK/iq6mSfdssGAQaDT7Q3MQvezrFrpqbdBymBKwtXs9Ld7000cDegyNrxQ=
X-Received: by 2002:a17:90b:224e:b0:31f:1739:b541 with SMTP id
 98e67ed59e1d1-321162cbc80mr19242734a91.29.1754409261039; Tue, 05 Aug 2025
 08:54:21 -0700 (PDT)
MIME-Version: 1.0
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
In-Reply-To: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 5 Aug 2025 08:54:08 -0700
X-Gm-Features: Ac12FXwC7xFTjCLjGN458qKNnLIHpU-rBIAK63QMImo5RiuLdxc4hroNKGTATNY
Message-ID: <CAAVpQUCyM2x5a=w5MG9c5GDsHWX=Vse9qDP0URu6q9mSP0PD3Q@mail.gmail.com>
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
To: Daniel Sedlak <daniel.sedlak@cdn77.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, 
	Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, David Ahern <dsahern@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9AEC78000E
X-Stat-Signature: 51atom55jn63x3ajjpocu77g3tz465w7
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1754409262-247709
X-HE-Meta: U2FsdGVkX19SbRCXbUwK4YfvtWFcb6SCw0lB8pp2FmQaAenGsdor4uyIiAiIy2LIIpKEKD/C3OnBSxLpg4xrXWEGWiF6+MlSh0/Hzt7HyO+8umJRcPOsNTpxuH0hKc5GJdg8M4p2ALRU23bEjeg3jLjIYZ0NbTQOE47KfCTx0zQ7ky5BAU+5PhUapoU5PEgw3BvmEQ459ry8LcUH+J/eTOA4xL0gomcd91orS4sNeNJUbfJCqlxTeZuBrrlMeTJqzQyAGvlH0ypPvyZ6gjqrZ2v41qq938hxEkFCkVX7RHBb54Ffjrv9Nitm/nUuRAaH0/kllAe7UcYJAevdt5Mo5BDiv/BBM+iP0JUHbdRg+WFhYIp8yKOZbmZikSSdxwli5wsAGDJOlMccVmOOhiHv7L/vdmMtgOqBDrcfOo62/mpKXFIsymIN7Hr3l9MiMxrk8Bbg+lo/mUaVOeoOdYrivskfFgwBL6aDH67tkv/oSre75grrRqaPVDo7yLjZn0W6vlZC2s4QQqLw7XpabchXwN5x/7Z2UR+dX6rH06kuFctFnu8ddW96dBZaV0MYDUoEkx58kcxk870WQRzTdQD63qwkP6RzEBJ+lTpS0aHOGKz4xL9W0dDA2eq4ruuNxbMrVja8G6Uq7DmjXjLGn08++PMyH4DmWRkAihZcd0e+pNlOJusapiJzbzySz51R1bAEQMsWpgG9ovqIvdXuWmICm8o9/z66tM8xSeemXt2sQdVk7Dx8HfZ55DhoH/mER8BYa0g1gIQR+5rX9AzLVpJ7qmYImWOaIS/rwxbgEpwZnJ4WO9KPmGZ2NMZgcyFEJN0H0QcIrE1WnX8uEPNmGg1J8zkcvIeUVdK8KVFbioKRRL5Skveyt5FHFcL52835bbJXVqSVT4jZJDGaEWg4INdgIVab0MWCiTQrgygXZ35gvSKsVUs9+2ckxj7QQxTnz4l+bzskcN+Uu9xA6sJFG7z
 ow+IuWVw
 9JIScie7mlIaPodl9kuJjiLsdBagRVdWoCrI08vXhWgru6CrF7DLW4oZ9VD8xOBr1XQmrgTmzk/2PYKyeGaPhTimjd67ofMoU9OEy0I6Sz864iJsjteCJdsWnA8+WGo0sGcbcStxuSUzwwa2EslB9Mu+DbcuAOXs6fgWERhTDI6kax067ok0xnDzR+l+pkMx7vGAZBrwLUuCQ0R2awbNvEt4eAETrWkhuSYEA1Bley9eHXmoxg3LKdjvwi2wsI7tgKbiIg0707IUCyXwH519dOccz9huxGML5CUFM9QkRYeUic7Diyc1+VtdLkI0hiw41kQuka2NCeRLdKSOr0U9/YXdPevjImjYPyAYHaYsgE0QI1HAtBva4CHbXbuCcG149O19IXcTp9n1ThN5GBWBov0Xh561hX3MLEpYON3hV11wyuU09Unfx+C8e3Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 4, 2025 at 11:50=E2=80=AFPM Daniel Sedlak <daniel.sedlak@cdn77.=
com> wrote:
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
> The output value is a cumulative sum of microseconds spent
> under pressure for that particular cgroup.
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
> v3 -> v4:
> - Add documentation
> - Expose pressure as cummulative counter in microseconds
> - Link to v3: https://lore.kernel.org/netdev/20250722071146.48616-1-danie=
l.sedlak@cdn77.com/
>
> v2 -> v3:
> - Expose the socket memory pressure on the cgroups instead of netstat
> - Split patch
> - Link to v2: https://lore.kernel.org/netdev/20250714143613.42184-1-danie=
l.sedlak@cdn77.com/
>
> v1 -> v2:
> - Add tracepoint
> - Link to v1: https://lore.kernel.org/netdev/20250707105205.222558-1-dani=
el.sedlak@cdn77.com/
>
>  Documentation/admin-guide/cgroup-v2.rst |  7 +++++++
>  include/linux/memcontrol.h              |  2 ++
>  mm/memcontrol.c                         | 15 +++++++++++++++
>  mm/vmpressure.c                         |  9 ++++++++-
>  4 files changed, 32 insertions(+), 1 deletion(-)
>
> diff --git a/Documentation/admin-guide/cgroup-v2.rst b/Documentation/admi=
n-guide/cgroup-v2.rst
> index 0cc35a14afbe..c810b449fb3d 100644
> --- a/Documentation/admin-guide/cgroup-v2.rst
> +++ b/Documentation/admin-guide/cgroup-v2.rst
> @@ -1884,6 +1884,13 @@ The following nested keys are defined.
>         Shows pressure stall information for memory. See
>         :ref:`Documentation/accounting/psi.rst <psi>` for details.
>
> +  memory.net.socket_pressure
> +       A read-only single value file showing how many microseconds
> +       all sockets within that cgroup spent under pressure.
> +
> +       Note that when the sockets are under pressure, the networking
> +       throughput can be significantly degraded.
> +
>
>  Usage Guidelines
>  ~~~~~~~~~~~~~~~~
> diff --git a/include/linux/memcontrol.h b/include/linux/memcontrol.h
> index 87b6688f124a..6a1cb9a99b88 100644
> --- a/include/linux/memcontrol.h
> +++ b/include/linux/memcontrol.h
> @@ -252,6 +252,8 @@ struct mem_cgroup {
>          * where socket memory is accounted/charged separately.
>          */
>         unsigned long           socket_pressure;
> +       /* exported statistic for memory.net.socket_pressure */
> +       unsigned long           socket_pressure_duration;
>
>         int kmemcg_id;
>         /*
> diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> index 902da8a9c643..8e299d94c073 100644
> --- a/mm/memcontrol.c
> +++ b/mm/memcontrol.c
> @@ -3758,6 +3758,7 @@ static struct mem_cgroup *mem_cgroup_alloc(struct m=
em_cgroup *parent)
>         INIT_LIST_HEAD(&memcg->swap_peaks);
>         spin_lock_init(&memcg->peaks_lock);
>         memcg->socket_pressure =3D jiffies;
> +       memcg->socket_pressure_duration =3D 0;
>         memcg1_memcg_init(memcg);
>         memcg->kmemcg_id =3D -1;
>         INIT_LIST_HEAD(&memcg->objcg_list);
> @@ -4647,6 +4648,15 @@ static ssize_t memory_reclaim(struct kernfs_open_f=
ile *of, char *buf,
>         return nbytes;
>  }
>
> +static int memory_socket_pressure_show(struct seq_file *m, void *v)
> +{
> +       struct mem_cgroup *memcg =3D mem_cgroup_from_seq(m);
> +
> +       seq_printf(m, "%lu\n", READ_ONCE(memcg->socket_pressure_duration)=
);
> +
> +       return 0;
> +}
> +
>  static struct cftype memory_files[] =3D {
>         {
>                 .name =3D "current",
> @@ -4718,6 +4728,11 @@ static struct cftype memory_files[] =3D {
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
> diff --git a/mm/vmpressure.c b/mm/vmpressure.c
> index bd5183dfd879..1e767cd8aa08 100644
> --- a/mm/vmpressure.c
> +++ b/mm/vmpressure.c
> @@ -308,6 +308,8 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg, =
bool tree,
>                 level =3D vmpressure_calc_level(scanned, reclaimed);
>
>                 if (level > VMPRESSURE_LOW) {
> +                       unsigned long socket_pressure;
> +                       unsigned long jiffies_diff;
>                         /*
>                          * Let the socket buffer allocator know that
>                          * we are having trouble reclaiming LRU pages.
> @@ -316,7 +318,12 @@ void vmpressure(gfp_t gfp, struct mem_cgroup *memcg,=
 bool tree,
>                          * asserted for a second in which subsequent
>                          * pressure events can occur.
>                          */
> -                       WRITE_ONCE(memcg->socket_pressure, jiffies + HZ);
> +                       socket_pressure =3D jiffies + HZ;
> +
> +                       jiffies_diff =3D min(socket_pressure - READ_ONCE(=
memcg->socket_pressure), HZ);
> +                       memcg->socket_pressure_duration +=3D jiffies_to_u=
secs(jiffies_diff);

WRITE_ONCE() is needed here.


> +
> +                       WRITE_ONCE(memcg->socket_pressure, socket_pressur=
e);
>                 }
>         }
>  }
>
> base-commit: e96ee511c906c59b7c4e6efd9d9b33917730e000
> --
> 2.39.5
>

