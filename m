Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 740A2CCD187
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 10:39:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A79C78E00DF; Tue, 14 Oct 2025 06:39:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A2A808E000D; Tue, 14 Oct 2025 06:39:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 919608E00DF; Tue, 14 Oct 2025 06:39:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7996F8E000D
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 06:39:22 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CEDB713BD41
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:39:21 +0000 (UTC)
X-FDA: 83996372922.17.863AD98
Received: from mail-qv1-f45.google.com (mail-qv1-f45.google.com [209.85.219.45])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0F93C180008
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:39:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Wu7Jto0L;
	spf=pass (imf16.hostedemail.com: domain of edumazet@google.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760438360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8i8HbdVZPfionD4pRoeQJ/6YsnBufC3F7NgJEHPSzVE=;
	b=IDkmC+n2Pe1Wtd0NhySeuveRlLDFd1UeUFVEcEp1wGwknqBvnKfcWPGb3S/AENfdb3NDGq
	9lA6pjdvmzoTfP4UwChcUdHp2L9c0neR6eY5hh5nRf8SEicB8Zs1Pq/mDaz/tAr3j4LXLW
	/8JepA5kA8HK4Od60JdUijId12Q4Ab4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Wu7Jto0L;
	spf=pass (imf16.hostedemail.com: domain of edumazet@google.com designates 209.85.219.45 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760438360; a=rsa-sha256;
	cv=none;
	b=T40AdCGVUHuhYBe20vlm4Qp3O+2gPHIcp7j+G9evAUJMkdJvORACoPA7+bX5Ki/teJvLEa
	qtWo/ImBfMjWy32d/8cISx6sn8484YRjeq/cp/jiF/Fh9V9VWptURn1PatmjQz1kCOf0el
	kfGXyTDEOAsERBHtNmxbd90+Odj4QYE=
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-87499a3cd37so46410206d6.3
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 03:39:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760438359; x=1761043159; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8i8HbdVZPfionD4pRoeQJ/6YsnBufC3F7NgJEHPSzVE=;
        b=Wu7Jto0L8dghi9mrpwAr9wnvhqCFgZH1avsnRDWpPq077oCYsNOUTrLVSfVuvhAnUT
         5GNR+a7vnIpYx3B73OX8+nXFRqyufJGgYdAi7yoPup4OS8xIqDebubchpPenOrxqlzAG
         gQK0n9bmBL71iK5KqSt0QAxmhtKHmp8Tlt07G6MJJofu26sRkERmjeWzUMY9bZ+m0z1F
         ze6uIduleHP7giRkQ2yW7yoLGhCjk73YySJR3ZXqQE1/DFqsXCnLITHFNH38ZBZlVVog
         IU9c1kqU0qiLxYnferBf3PJZ0l+FApgHPAlNSQEg1Oz6KzHqkADKx3nimZo0ISct8Ian
         eVkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760438359; x=1761043159;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8i8HbdVZPfionD4pRoeQJ/6YsnBufC3F7NgJEHPSzVE=;
        b=gQqMhJqmZngNmni7YldGWeU3N3MZ75qjzJF7XboGdrgvfPddXZPOA7BS8pV7Tgg9UN
         0UNbEwswDX1cenchrxcUlMFlilpHs0IZgR93cJDLEPDuJ2AuHB5TA5y+xHbeHJj9qwMg
         YLvAa/yBp1N2Ft51jNELdoChs1G0GLkdytWaUvv9qoJDc40c11jPo8Mw0Au+8U5sZS5D
         xl+nMDh7wSejGtgL9WhlC4rOjSPXTnkLd7IseoucwFgwxD9Qsym20r4V3O6pRL2sde9j
         FjJ7YI0KDwMMGhqxsE/QmBhI59K4vxCk82f3slQnGEi3CBmDgfYWoo2IvbiuxOXMr+hp
         g1vQ==
X-Forwarded-Encrypted: i=1; AJvYcCUP5Ls4dPzp62ii/bhSObVOxfJ2by7cYYnJA8ie9aDsl52G2skvKtO5SkoF7AHfFhRZQd3dfkGtCQ==@kvack.org
X-Gm-Message-State: AOJu0YzkZq3HrfSdNV1lT7luIGNF3q40t7JLfxGM775hpmN/qZ1195Kb
	cqDQ6kMB5iyxb7mGFMSnmUqD0X0uC5UkVqvMLeR4yZ1ZeTS48+iKac/+qWqkln23daPkN/p+9xR
	WGeeWCikf8ci0mMayE2DIihCmSf/9Apw5K8TKlp66
X-Gm-Gg: ASbGncsY1cGQ51pAjoczixFJ4VBwAIU9xA2sUCJjTd7CYDSO3zcRO7sSOe4qloJgwAJ
	IBODZ4IFqGnmRg5bYdC7ZDW66EkOaoYVKN8s+DCIqWNf/lu2bOVQKmUjAOlnxh9Ng9E9C/q1EzE
	MZZckI65NsH3A22oxLgU/3jBfMlb46JRyNd3TuNUv70c0x/yK8NTbVR6vXQJ+lscXaSJplJUGRL
	D3dZUu3AB/sDyJbg4HlXCb6LNPjvm8M
X-Google-Smtp-Source: AGHT+IEFzNXw/v6xZVTk0phPdvVBFB9EdAErZ6ksdm/dcjAu+K9F+ebHYFJ1AyXwmjljbbFPU7Tg80KyboEacHc3cFc=
X-Received: by 2002:ac8:5d05:0:b0:4e4:2006:b009 with SMTP id
 d75a77b69052e-4e6eaccc55cmr307481031cf.17.1760438358741; Tue, 14 Oct 2025
 03:39:18 -0700 (PDT)
MIME-Version: 1.0
References: <20251013101636.69220-1-21cnbao@gmail.com> <aO11jqD6jgNs5h8K@casper.infradead.org>
 <CAGsJ_4x9=Be2Prbjia8-p97zAsoqjsPHkZOfXwz74Z_T=RjKAA@mail.gmail.com>
 <CANn89iJpNqZJwA0qKMNB41gKDrWBCaS+CashB9=v1omhJncGBw@mail.gmail.com>
 <CAGsJ_4xGSrfori6RvC9qYEgRhVe3bJKYfgUM6fZ0bX3cjfe74Q@mail.gmail.com>
 <CANn89iKSW-kk-h-B0f1oijwYiCWYOAO0jDrf+Z+fbOfAMJMUbA@mail.gmail.com> <CAGsJ_4wJHpD10ECtWJtEWHkEyP67sNxHeivkWoA5k5++BCfccA@mail.gmail.com>
In-Reply-To: <CAGsJ_4wJHpD10ECtWJtEWHkEyP67sNxHeivkWoA5k5++BCfccA@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 14 Oct 2025 03:39:07 -0700
X-Gm-Features: AS18NWC6tSD-2fPgi67vs3tdqcGs5ZT4phYwNUo9MOM_IOY7jeMq3pOnwQALTO4
Message-ID: <CANn89iKC_y6Fae9E5ETOE46y-RCqD6cLHnp=7GynL_=sh3noKg@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Barry Song <21cnbao@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, netdev@vger.kernel.org, linux-mm@kvack.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Barry Song <v-songbaohua@oppo.com>, Jonathan Corbet <corbet@lwn.net>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Yunsheng Lin <linyunsheng@huawei.com>, Huacai Zhou <zhouhuacai@oppo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 0F93C180008
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: tt1fw8gjktxb15btsbnsogs814fp6zgn
X-HE-Tag: 1760438359-340366
X-HE-Meta: U2FsdGVkX19SQxxCi9e5rV9N3rxXsH3Soc2mEkqGpDdYPIXj+DKqhR8lSNM85/IioIMl0VXix+l0mgM5+Q5WyYmso4xcLtZ8l3hctCBUjjzqeIFCLiczleNE3AuknRaxd2tR2FEVCNHCk1W1jXJrXxiJcJIuCdJglpSEFcSyET7QPZGw6ui76g33x9UDyOw3JcripTKGK1HuhdaC+7kwRDfj3MbLaQM4I3+NS4N9SsNUzTqbrrGCPk4RIt9EShj9iNQ9BWpNQ72f33x7CNYtEx6FPy3jZjeF0eNSLZ7s6KNMniEF3YQW7cbnhnATkIyUUwy3oUD1u5P6Lr/0xu7ui6K4Nhvdx595rzPb/DsT/f1A3wnpzJsqclZB+DdwBShAuPqRWNLi/rPheKTfLUv1EverZO19lPpceNgXxXK/rS5aJnNTQlMf/B03ZA8bS7Z0CXmPLTvH1y4LkeiQAvSknkuWXtyUX7ozz3uXCdIUskq3JPw+0NT6sE2tfX7eOqtdMYl3wpLpwOpcObhVV1xtoXapC5ZxkrNw5cRwp4/pNQC+GePuznwMXDNFEK/t4stP3+7MrkwBaf+YLxLB4cHbddgjeTM5k6P8/9bcBMgINy6CK4JeSjQpxelWj62bTITfVKGvuTAg56IuI7pdKgT4kmWmzZi9KCkvRw10Dkp6hj4wjM7z8wQksZe/tFuwocDVDqpC8qcy4F3fnEYU9U+fIYskXVmeCmev91OnMgk00tKXSKRlJPGDnLg2K+yoNdFsFDAWIHfx0yYHjA8b4PJOQe/JT2dX7qmtAaWH/1kelSmlmMzdlu5Kxppd2gqvhrXnDoR2py/mi7mdJ5uGsrFjebhK5AKvJCLCIwQWAgx1fqsv+ea7fQ8MgkZ70GG5NZauppQbTeMPr4qkUzOPUuxEtXlcWGX73+5wq9+WLmDky6eWJfQv7cDA2DZLc0HtgLCP1h4UrBM0ifiriUW7SQN
 s1S1MeCR
 0fy8cMZLIp2fcMoQY8DI46Of3pGfy3DUaHvbb7EB5BjRZnSZ8hIGy6Oj/XQEMXdYnNO2JOG6Ab9tEXNZngZ9NlIgTEAMUxKmK8tGiyFVnqIVxj4HaxwtIzt7Okvai6w58B4vefwVWNx1t4fGYTxNx/Jl5BTuPaYxl8ua1ERylyCP+Zrv9VyBZaQlctezhKw3XDKisD6EJBt9vp2ipCo2dyXsd7GDCy1vwq3DTvSinub1DgqO8O+gRvGRdN9+zf9lPwWKcg80MKmZV0t8=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 3:19=E2=80=AFAM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> > >
> > > >
> > > > I think you are missing something to control how much memory  can b=
e
> > > > pushed on each TCP socket ?
> > > >
> > > > What is tcp_wmem on your phones ? What about tcp_mem ?
> > > >
> > > > Have you looked at /proc/sys/net/ipv4/tcp_notsent_lowat
> > >
> > > # cat /proc/sys/net/ipv4/tcp_wmem
> > > 524288  1048576 6710886
> >
> > Ouch. That is insane tcp_wmem[0] .
> >
> > Please stick to 4096, or risk OOM of various sorts.
> >
> > >
> > > # cat /proc/sys/net/ipv4/tcp_notsent_lowat
> > > 4294967295
> > >
> > > Any thoughts on these settings?
> >
> > Please look at
> > https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt
> >
> > tcp_notsent_lowat - UNSIGNED INTEGER
> > A TCP socket can control the amount of unsent bytes in its write queue,
> > thanks to TCP_NOTSENT_LOWAT socket option. poll()/select()/epoll()
> > reports POLLOUT events if the amount of unsent bytes is below a per
> > socket value, and if the write queue is not full. sendmsg() will
> > also not add new buffers if the limit is hit.
> >
> > This global variable controls the amount of unsent data for
> > sockets not using TCP_NOTSENT_LOWAT. For these sockets, a change
> > to the global variable has immediate effect.
> >
> >
> > Setting this sysctl to 2MB can effectively reduce the amount of memory
> > in TCP write queues by 66 %,
> > or allow you to increase tcp_wmem[2] so that only flows needing big
> > BDP can get it.
>
> We obtained these settings from our hardware vendors.

Tell them they are wrong.

>
> It might be worth exploring these settings further, but I can=E2=80=99t q=
uite see
> their connection to high-order allocations, since high-order allocations =
are
> kernel macros.
>
> #define SKB_FRAG_PAGE_ORDER     get_order(32768)
> #define PAGE_FRAG_CACHE_MAX_SIZE        __ALIGN_MASK(32768, ~PAGE_MASK)
> #define PAGE_FRAG_CACHE_MAX_ORDER       get_order(PAGE_FRAG_CACHE_MAX_SIZ=
E)
>
> Is there anything I=E2=80=99m missing?

What is your question exactly ? You read these macros just fine. What
is your point ?

We had in the past something dynamic that we removed

commit d9b2938aabf757da2d40153489b251d4fc3fdd18
Author: Eric Dumazet <edumazet@google.com>
Date:   Wed Aug 27 20:49:34 2014 -0700

    net: attempt a single high order allocation

