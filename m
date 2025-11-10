Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72E7ACCFA13
	for <linux-mm@archiver.kernel.org>; Mon, 10 Nov 2025 13:50:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D28FE8E0007; Mon, 10 Nov 2025 08:50:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CB23B8E0002; Mon, 10 Nov 2025 08:50:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B7A1D8E0007; Mon, 10 Nov 2025 08:50:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9EA308E0002
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 08:50:17 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6A4811A0D85
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:50:17 +0000 (UTC)
X-FDA: 84094831674.07.81B6EE3
Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	by imf25.hostedemail.com (Postfix) with ESMTP id 5515AA000B
	for <linux-mm@kvack.org>; Mon, 10 Nov 2025 13:50:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Uvflz5YX;
	spf=pass (imf25.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1762782615;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tCs1YwS37zjMEsWnDzmEV/JMvwyL1fiKF8eAfxcvVZM=;
	b=WFcvwndl4Umk/AV2MOAYeQRHUfCY6s2RfO2AOWVF6WxW4T2j0vw7SIJ3DCGK1SVQYZtLcE
	pgsMVrvqjwc8VvUGvOFEzqaTiCPUZ7MR5AOlIi+Ckq1zN6jlJxCrZlsRWBnrCiezqEzoBq
	i04GHQ3pv7w2u7cWaQXFs3Bqx6iZ3XQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=Uvflz5YX;
	spf=pass (imf25.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.47 as permitted sender) smtp.mailfrom=mkoutny@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1762782615; a=rsa-sha256;
	cv=none;
	b=tLkYjJ8kWbXxaswzIc70T0lRWCsiwofnHC+V4g4sKvf2ZXC48dAyoCYWDGXLYrGMXuIG53
	owGP+mwyeFFjvVG8O8Qy2fOMixpADcrG6mU1yzJ1xHTd9y4ZXUuV9iu7wDoriK43sWV0os
	okj22n/zhZ1kLlwYXve8iS8ovVaU3MU=
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-47755a7652eso20250755e9.0
        for <linux-mm@kvack.org>; Mon, 10 Nov 2025 05:50:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1762782614; x=1763387414; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=tCs1YwS37zjMEsWnDzmEV/JMvwyL1fiKF8eAfxcvVZM=;
        b=Uvflz5YXiVyeOmO6D6fI95Ib5mbQUasvqQ22DHAnzMREC2zHmA9RCBW2pYe645A3Vy
         8OvfqkoHrFnBEXMwWvZNPLOwW+RJiVzFIxN+Pqj/sQpp0/2q0OQEJgyYwp+B7hcdf5fT
         /ly7ZayelQg8oCx95roXqWptMT6K6bF7TYL+tGDrI6Vf1m2XdsAdarCHt6ojITWmV9L2
         mA0RkYvK6URPrzKhTYhYTTHtHykgz73rLtIMG95AXah2fiGtNG5jdROW4SQs3cODL9T0
         ElgsApbzk+p9PF7/5YSSh5CIpA6nPeANoNek+EsAmCzCMZP6Ctr2CM3XlEHXYbQ1sK5E
         lgng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762782614; x=1763387414;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tCs1YwS37zjMEsWnDzmEV/JMvwyL1fiKF8eAfxcvVZM=;
        b=pg4edIDrYIaDr5p/WJAC53JyiV1OxfJt2mYb1BznCzkxYDndyvK6vvh8lgzywRRCuD
         lNguiUNgYtauaJ2UrOi/i3fCaHJd6TD0qQKvSQAxNBTTBoGQem6LmFRvs+egeBAW42Px
         8gIOdVNAezn5doWMu321xyL+1GxHCoGC+mKLDfGUy8qV2JZYjJtICCkTuSuIJa+9bhqq
         MBZ4UzFN5hEhykeZFRQkmqKs5MwRGWa3fGoxlNrAsgTcwbRJY/f88mwwh8aoLxOeNHvs
         TPZkG82bHlh6JKdLuTJn1ueQRnTqX7m+57PQcIhcgXwKrnflr5x9wZq17JcWPRiYyFC5
         dViQ==
X-Gm-Message-State: AOJu0Ywg470gFOpgbnxw/hMeO1dJyvxbuCT/LshyWLjjH7WEl3fB1lns
	Q96lqKfTetXmBn/yXFKej12hmz8GWlUm5CFVNe7L0H8QqPGXDh0zckki5yMjPyII0sQ=
X-Gm-Gg: ASbGncsv0RGfylOwHmLGMYJgmKCCkGmvtIl0+Sua+ddRGDbMT4pdd0zv70UGFg4L/uz
	727kpp9BVZxykwc6VWurw/0wXkbkQHvKP7gGwZ6K+rLitq3EWJRn9EzgVZNe/DOF4qjCaNchY5G
	53My7NFFIXKgV07Y4IzDMKfjcvaWoA4B972XoTHT8OwkcTMNthGhhLwVJ1PrSJ+yKaQuHInevJc
	EhJg22SFfytSRolM1ZAb7Dnb6Qbf/dA5pG7sDxNJXKMhapPKgoLTKcmFeQhz+WA0g1ecAek+D/d
	ceQFJ800kjiNpveTXZO2fauWkCYHS1eQeClTFdwQEVm5zWdb5qesX2LOvFz2L91YgOQQodbl04a
	zQQa/rGbPhrNG3wfK4rhvv4ILOPmDKx7azxXXhYfKc1JiCJZk46q09aChR8tmaNUilePPNDT7dl
	JuPpe8vmuem7aDqlLSy7pde+4JWbsU//Y=
X-Google-Smtp-Source: AGHT+IFbwuDPMH0i3HrzOH4fQgag2ujLMbEc53k+8Ky8ZYKaeuvXAQUWa6E5cujElbmdZf149UMenA==
X-Received: by 2002:a05:600c:3511:b0:475:e007:bae0 with SMTP id 5b1f17b1804b1-4777323ec8fmr52334305e9.16.1762782613605;
        Mon, 10 Nov 2025 05:50:13 -0800 (PST)
Received: from blackdock.suse.cz (nat2.prg.suse.com. [195.250.132.146])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-42b2dd927c9sm15613706f8f.27.2025.11.10.05.50.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Nov 2025 05:50:13 -0800 (PST)
Date: Mon, 10 Nov 2025 14:50:11 +0100
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Leon Huang Fu <leon.huangfu@shopee.com>
Cc: linux-mm@kvack.org, tj@kernel.org, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, shakeel.butt@linux.dev, 
	muchun.song@linux.dev, akpm@linux-foundation.org, joel.granados@kernel.org, 
	jack@suse.cz, laoar.shao@gmail.com, mclapinski@google.com, kyle.meyer@hpe.com, 
	corbet@lwn.net, lance.yang@linux.dev, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
Message-ID: <ewcsz3553cd6ooslgzwbubnbaxwmpd23d2k7pw5s4ckfvbb7sp@dffffjvohz5b>
References: <20251110101948.19277-1-leon.huangfu@shopee.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="elrbjxmejfczykla"
Content-Disposition: inline
In-Reply-To: <20251110101948.19277-1-leon.huangfu@shopee.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5515AA000B
X-Stat-Signature: ipb8k5pd13tyyu43w3xsx7wgnffz1wm5
X-Rspam-User: 
X-HE-Tag: 1762782615-754328
X-HE-Meta: U2FsdGVkX1+ZkhQ/yikojg03OyvYoHMFi+yy7QLok1fa8I1Lcz+PjExKEW4CfzgiM1fXI/Q70rtwuLH+Gb95REcOjsY4TSxfXBWGk7R++AgvdSwALk8eSX3rLjqp1S+MOM6lF2L6KU4Kok3ewIgqgq5a7+UEtK1oGP4KGw/MeMYCMUXFYNChPR4yE7fxYRdGqWWWsqB/zdwNHnv1XKXh1bSXdTzTGdlSr2MPlimnMqbt14TiucbLG/yw5hbKGIT1pzv+ZJu3Ql6RjeACqokmEgPbuyTWJjhK837qS7eH6M2Tks1HXc6baJZmiRjmUOXk1NjdQgMuXk5ow3NgH8GY2vtQE6WR+EhDl3KztHlID5Hg6/afDei3RsKFxcpwOpnp3uINxPIoWkQT7RBaLdP9sWIwG0CczQNLg53bGi2LbvPobiNvyuMkjFral7cgOnF4pgmIFjSvTnRCIatpo7ZxNEii27BcxcA2eQAChw89LXHosSoNBr6BbZtxyctFmi2T3zQ2Q+QTl80FZclNMtAFxO/dJHkbwtORZG1qxDd/F9LIVRB5R3vzphK0a0MK58ieQEvb+UFVWf/MDfk0J6DiE0ARp1qSaOSj7L/pW+BYm0w983DUG9vIlfy4/EcXMukccaTfY3fwdhcaC1M6lF5oAvOGS7Y0qQtV93/7/tfM8b4/sQfkIcHvqM1NmEzIlfNexBjJhckS5QhiuyhKSECfGWcnczZ1CboMPqKWNgj7wK+4FBLjs6QiGzYm8PUTnrSCUXUC5/RNBFoLle4QMgpf09Wn9JBuqb5Ty9nf6zNv3hv58pX3UQe1oC7G0pEIUhbzj0yfNsEtA/vrqLdXYqkYwkK7jOwH5oX8NV+TpIkbzMETW+QMQ4oDLtUadJGzTIZYTunETswt5DMXS85xqUQj0R9u/lnDAlI0jY8nVwxETNhsgfdqiCCpW5yTpHlQrvFbt3l+j874xvhLIBnxZ0S
 fpHgzH2D
 oDdcIMfFw3wTedzLU2+HeoSC3rRLM6ZICKJ8dWdOFafRxKaZE4lPHsP+i8FJIjHtnSrK3khIrHJBYXOZCI3KOWoU7liNppf786wNaQAJCCtZF7QvCI3wt+l1HvjTEqu7Z9rbfLqrDqh6SDI/zLurkS2axADJ53vbufSOElHrbhVrEk7JrZndk9AoXqH3vq+UTxCirO6IY/8l1gd94U22kayWJIVo/BUtC97lj/8wvkOFe2d1kPjzgjglV9oSUnGwTrXqJoXKvQvlIgsMsRI7DT2NgsSANuzTEBQgfN86dQAT+X/qgXU+DSfAretojvkZ4gGWQ/ZmMLosJkO6jci2R8rvRh2vN5zpmsHrJt7YvgHtOmcl4X8qfBcnocH0xZOlsSlf2ic75FMmBBy5mpBAATLgbBQdlJlenHnVRX/e/HP1hTw6YQOTcx60NNEwxwa5AIHOxEWAl+Lbh02Rv9fb19WE3VbYhajgEx5VcQ1rMK/YjLqd9vNvkEIOqwtIYE8YTApLWd3kQzu7TGD8JTHt3YVMD11TD7a/sIgRopY3QnJu09r1vg7PN5uSf3hIBgKpQjEXpjagQqiuyPqExqlrQT9u5XYAeawHQcApKKIwBr9MKQfs=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--elrbjxmejfczykla
Content-Type: text/plain; protected-headers=v1; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH mm-new v3] mm/memcontrol: Add memory.stat_refresh for
 on-demand stats flushing
MIME-Version: 1.0

Hello Leon.

On Mon, Nov 10, 2025 at 06:19:48PM +0800, Leon Huang Fu <leon.huangfu@shope=
e.com> wrote:
> Memory cgroup statistics are updated asynchronously with periodic
> flushing to reduce overhead. The current implementation uses a flush
> threshold calculated as MEMCG_CHARGE_BATCH * num_online_cpus() for
> determining when to aggregate per-CPU memory cgroup statistics. On
> systems with high core counts, this threshold can become very large
> (e.g., 64 * 256 =3D 16,384 on a 256-core system), leading to stale
> statistics when userspace reads memory.stat files.
>=20
> This is particularly problematic for monitoring and management tools
> that rely on reasonably fresh statistics, as they may observe data
> that is thousands of updates out of date.
>=20
> Introduce a new write-only file, memory.stat_refresh, that allows
> userspace to explicitly trigger an immediate flush of memory statistics.

I think it's worth thinking twice when introducing a new file like
this...

> Writing any value to this file forces a synchronous flush via
> __mem_cgroup_flush_stats(memcg, true) for the cgroup and all its
> descendants, ensuring that subsequent reads of memory.stat and
> memory.numa_stat reflect current data.
>=20
> This approach follows the pattern established by /proc/sys/vm/stat_refresh
> and memory.peak, where the written value is ignored, keeping the
> interface simple and consistent with existing kernel APIs.
>=20
> Usage example:
>   echo 1 > /sys/fs/cgroup/mygroup/memory.stat_refresh
>   cat /sys/fs/cgroup/mygroup/memory.stat
>=20
> The feature is available in both cgroup v1 and v2 for consistency.

First, I find the motivation by the testcase (not real world) weak when
considering such an API change (e.g. real world would be confined to
fewer CPUs or there'd be other "traffic" causing flushes making this a
non-issue, we don't know here).

Second, this is open to everyone (non-root) who mkdir's their cgroups.
Then why not make it the default memory.stat behavior? (Tongue-in-cheek,
but [*].)

With this change, we admit the implementation (async flushing) and leak
it to the users which is hard to take back. Why should we continue doing
any implicit in-kernel flushing afterwards?

Next, v1 and v2 haven't been consistent since introduction of v2 (unlike
some other controllers that share code or even cftypes between v1 and
v2). So I'd avoid introducing a new file to V1 API.

When looking for analogies, I admittedly like memory.reclaim's
O_NONBLOCK better (than /proc/sys/vm/stat_refresh). That would be an
argument for flushing by default mentioned abovee [*]).

Also, this undercuts the hooking of rstat flushing into BPF. I think the
attempts were given up too early (I read about the verifier vs
seq_file). Have you tried bypassing bailout from
__mem_cgroup_flush_stats via trace_memcg_flush_stats?


All in all, I'd like to have more backing data on insufficiency of (all
the) rstat optimizations before opening explicit flushes like this
(especially when it's meant to be exposed by BPF already).

Thanks,
Michal



--elrbjxmejfczykla
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCaRHthRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMSwyLDIACgkQfj0C55Tb+AjIDgD8D7HBEqfD01sGDIReAADc
4pTJ2AD2pY2UoeiHwekZY7MA/0iGiNuZJTf1Sq2EA+RVWF9MNs3x64m7LutLmfib
iBcM
=PZ8F
-----END PGP SIGNATURE-----

--elrbjxmejfczykla--

