Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87E45C87FD3
	for <linux-mm@archiver.kernel.org>; Thu, 31 Jul 2025 23:51:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F32F56B009F; Thu, 31 Jul 2025 19:51:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE1896B00A1; Thu, 31 Jul 2025 19:51:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA9346B00A2; Thu, 31 Jul 2025 19:51:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 699D46B009F
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 19:51:58 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1EA1E80FCA
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:51:58 +0000 (UTC)
X-FDA: 83726210316.17.C25BD7B
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf20.hostedemail.com (Postfix) with ESMTP id 3C8E31C0003
	for <linux-mm@kvack.org>; Thu, 31 Jul 2025 23:51:56 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UDmXuaK7;
	spf=pass (imf20.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754005916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x1pY4t9vVS5jlHwuXly55Cv9xSzwUaUm6zW230XbJ2A=;
	b=t1WvpS7I5AVTYNYEqMr/751xLTxibsT+/rT5vWySpu64rWQuKAQXkpZcyaRbOdiN0LwsSr
	QF9XyqVZgkmPihgTgi/a/bNCjIGYuobAKOaJjX4eKISiKZv5uE3gTLfOCpp49ytjHjfwrj
	RRX6RYgezdVCBpi3j8i7TSE4kriiGm4=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UDmXuaK7;
	spf=pass (imf20.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754005916; a=rsa-sha256;
	cv=none;
	b=Nwakw+cRoPnFKFJYmwuiPVOQvlk4bbZUyomIrHCBIZu9k9Rp7mpe+ahwJOWrfjaHFa3UL7
	YerDrmKcSsRQz/Wxxhj2knvrZAKUA880sE8Ng7mXZd78He0xj3AwiGF41L9+NYSVAZ2Ike
	vIgrIj39GXtKgzCX11qBdSSq3O6akdc=
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b391ca6146eso1232771a12.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 16:51:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754005915; x=1754610715; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x1pY4t9vVS5jlHwuXly55Cv9xSzwUaUm6zW230XbJ2A=;
        b=UDmXuaK7cHLoF5EaX31TPbhENz0sIvUGy2uMRU0Oa9RHOQ4KNikMYnbBJlQJy5WzU2
         zIG/i9B+6jn8XXE8DXacKm41jpn6bwJGsNp9iMLG0il2Qk9okdRKQLxmsetp2hXAvjpr
         UtMQeVMa2RKXv+Wf7Zfg8wIh4/Porodu/S6PTiUF+dDxHg4mdDagbUZJ/THhJh6TBiEx
         Bydi3rAu4ypwFvzQgCzedmATOXg9SSrtcXkBckKYdrC2cVTwX0wFalhPdOJgSr2cwlR+
         7jMJN7thJeF85TcTLRFhmqCrSL/QSZc4+fVgL3ZuWinH5gUER9CVsd9Hi9GSsqCyrFn0
         l/5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754005915; x=1754610715;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x1pY4t9vVS5jlHwuXly55Cv9xSzwUaUm6zW230XbJ2A=;
        b=VENFdzRHIPjW/mmozOm3g5toCrqU/zgFXaG775w18niHORaW8jMGNbBK8VdVZYycfx
         4+G20IQ1yn545Z4mE17+94N1P5E/+b/y5VJWWfgAL29oRp9XNhIhKNUKkgU6fR4kpxw0
         1eZ0GjyQTtf77Sdfz0pwE7BJ5/zS2flrzdgiHPY4ncw1PCMpOOFtAQ1e3bq3mMfFq7tP
         implQJ3VAX1RBcS6Z0PD2KslZsJ+3crKlPz/wNWvZJQd2t/eU/6qmnCNfJPhzqz9VN7K
         MQSPNZPdEBCj/w0iXSlQ2L5BIkkItXRJf5rsz1+tmdDRN6dW4eiRcZIlw5w+DA0CFOfu
         LgWw==
X-Forwarded-Encrypted: i=1; AJvYcCVR56NbLz9PDWaRylruK5hrenmPr/zBLTIpg2ho/bBXa7qiToeD9L9hgCDmAMlDxNSrVAw3LzIYbg==@kvack.org
X-Gm-Message-State: AOJu0Yyb/0Jg2g0fIw7+Fu2P/LZZRBwEAk0adpwDRJFzSjoB/lA8kE2f
	sJ17y6IBhY15U4GWWEOy9d/FQJk4cCWsziGI8LtSnSQD4uwbpitsf3sBSam15wt0HiDbdIqjIKf
	TAPOPCMu7Yb+KfBE+0G3fogmr5mfz8vgjaX0YRndN
X-Gm-Gg: ASbGncusxXQUpTI6bFLLxBr5JW/eShFPho4CgmbWCtVdICH61KO2WfO7MbfWOZ+TKkF
	927XqNX/zBxVVBvOq2FV8iCrdQmDoX+azDNmyrCH81EMDNpmKSvVkVMDH/oashXpuOVQVezMUPU
	SKgY7MlCdcmyL4ve+Kl8UrcBIChrOU4W+4hVBu6tth6K87Lxrab6cO1/qZ8zvggwxxRnis6oXE/
	pzVkeXP5u4dprvCBFujgLEAtsg2s/N8dpF6YhE0eM5fTeDt
X-Google-Smtp-Source: AGHT+IGMdr5+ZltYc/B0msRqSn8S05vopIUSrPrZpbCyE1ibrXKKkFxzUCv9+aOryf0B15tqU6r7DGOpYwl+1TOpJ8U=
X-Received: by 2002:a17:90b:3952:b0:31e:ec58:62e2 with SMTP id
 98e67ed59e1d1-31f5de4197dmr12628654a91.19.1754005914820; Thu, 31 Jul 2025
 16:51:54 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-14-kuniyu@google.com>
 <fq3wlkkedbv6ijj7pgc7haopgafoovd7qem7myccqg2ot43kzk@dui4war55ufk>
In-Reply-To: <fq3wlkkedbv6ijj7pgc7haopgafoovd7qem7myccqg2ot43kzk@dui4war55ufk>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Thu, 31 Jul 2025 16:51:43 -0700
X-Gm-Features: Ac12FXyRo64aj2tAOXgVRHN2Olp9-pPfFQKxGBKy5bgLlQjCQOCZQOdKisc5o28
Message-ID: <CAAVpQUAFAsmPPF0gRMqDNWJmktegk6w=s1TPS9hGJpHQzXT-sg@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
To: =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc: "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Simon Horman <horms@kernel.org>, Geliang Tang <geliang@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, 
	mptcp@lists.linux.dev, cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: j7zj4jjbsxibfcwnga4p3kcoqixcuqff
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3C8E31C0003
X-Rspam-User: 
X-HE-Tag: 1754005916-196578
X-HE-Meta: U2FsdGVkX18SjG7DAecwf7WEhW0NFe/j0sSNNyuwPYfW0Q8jAYMZv/QXBANo+YQzuH1Slf3deDwCXX/qhzEnj/4j8G6vqEQUh0p3WMeruEiEJCy5eYzafZtG2vGYg15+RH2ATJrPevpzFJmO0TqcE1Wp1p0P/6ZVJJ2i3px09xjHOFTA4P7eOAE1PCVmaeoCqzTunKC336mJ6ODBaQUZ/SpEOu2QpkCEf9UL1mQl5hTxoG508vScnvjb/1UzT/zWLzcZYdrtB3AJ1/0iS5ANsSKm/8GdmG92s3FIEIsB8mLJPL0EgwFHVqZUj03OWqGnTRFyLMDSQtYFMwSFctJ0vyQiIzDG39WTvnupJxoBFicSkOWS0JSKnCRItLidzg6muOnn2Y7zFh3ePO+12AcyRmJiMEV/v8yMrOrOxo9zoO/6BzTA8XNySQ755eoEES713EDFIAk6P84oXgbkOQODOG1lcAhrUjuZtyg13MvdtLmjoJmEihiK66DcqZsQHvgRn9HJO3qIkPrrghwMjstqZIhpFqnx8PTFBw+pCC/JeXqA4QNJAoPVPHQ37rYCnlZpIOxyJF8IVvot6BpUksreZldtFSTiA481xorCEmeSGZ7jLsW28muQ1awkJd9TxEbYPZsmLPErJJHct0xo5LR/mSD50VG2Fc/pc8GqEFO3JqWHFw9pE3DoTYtRWG7AC9rj/sVPe4Vg5SVu5RY9E/OhkC7YdQFzr5vi6TZKB8R+NhR7h4xl8JqNLtwwl3iKKHLn73yXWz2RoWGm01KPvHcxeRZl6B3KNwykZQvThDGLaC4Z1Y8XEcX5b+WB2ooKTjYIfPiy//apc/PoUcLSiju+s50FpsJw1ii/9AI4FYwGznB3L+EVJny9lDbscesJqiTVtuEA7AEQBkz9jd2t4t68pqJgk2Ua8yZcoHlD67Kyj5pZicHz8mUjdZRxTpktvZRtoATF7jLZ3DZnyT6XEQd
 C7pdHVZ6
 Bg8iuO81Mda2W8wWD2UEFRHlTjDILoCFBqhwd3T/g21VJ1dBTZbXEA8DxPXkliL1ZVKomVvZ48ZpOK+7oXeuTAmBnrFPojZnLoNz3LGRm61X+zk0yOtQsNP7HumHEqWOx7vwtT77IQdMrYM1QFbrs10fdjJYxMvgaT9nXYwMm4t0KAMP0zV39qLpTYl7x2/Sd1Q+gQaZNngSdK9tc13cmRHd3+GDtx1IC3dfqVxtCNKDEy9j3pVeToxSrqfr0Bs0akZH/rmk0D8aYZvXDrUmsKoeUKA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 31, 2025 at 6:39=E2=80=AFAM Michal Koutn=C3=BD <mkoutny@suse.co=
m> wrote:
>
> On Mon, Jul 21, 2025 at 08:35:32PM +0000, Kuniyuki Iwashima <kuniyu@googl=
e.com> wrote:
> > Some protocols (e.g., TCP, UDP) implement memory accounting for socket
> > buffers and charge memory to per-protocol global counters pointed to by
> > sk->sk_proto->memory_allocated.
> >
> > When running under a non-root cgroup, this memory is also charged to th=
e
> > memcg as sock in memory.stat.
> >
> > Even when memory usage is controlled by memcg, sockets using such proto=
cols
> > are still subject to global limits (e.g., /proc/sys/net/ipv4/tcp_mem).
>
> IIUC the envisioned use case is that some cgroups feed from global
> resource and some from their own limit.
> It means the admin knows both:
>   a) how to configure individual cgroup,
>   b) how to configure global limit (for the rest).
> So why cannot they stick to a single model only?
>
> > This makes it difficult to accurately estimate and configure appropriat=
e
> > global limits, especially in multi-tenant environments.
> >
> > If all workloads were guaranteed to be controlled under memcg, the issu=
e
> > could be worked around by setting tcp_mem[0~2] to UINT_MAX.
> >
> > In reality, this assumption does not always hold, and a single workload
> > that opts out of memcg can consume memory up to the global limit,
> > becoming a noisy neighbour.
>
> That doesn't like a good idea to remove limits from possibly noisy
> units.
>
> > Let's decouple memcg from the global per-protocol memory accounting.
> >
> > This simplifies memcg configuration while keeping the global limits
> > within a reasonable range.
>
> I think this is a configuration issue only, i.e. instead of preserving
> the global limit because of _some_ memcgs, the configuration management
> could have a default memcg limit that is substituted to those memcgs so
> that there's no risk of runaways even in absence of global limit.

Doesn't that end up implementing another tcp_mem[] which now
enforce limits on uncontrolled cgroups (memory.max =3D=3D max) ?
Or it will simply end up with the system-wide OOM killer ?

