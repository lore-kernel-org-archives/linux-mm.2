Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DC9C6CCD18E
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 20:18:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29C8F8E010F; Tue, 14 Oct 2025 16:18:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24CD38E0090; Tue, 14 Oct 2025 16:18:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 13C498E010F; Tue, 14 Oct 2025 16:18:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F07A68E0090
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 16:18:01 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8D0D7C0A64
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:18:01 +0000 (UTC)
X-FDA: 83997831162.30.E60E408
Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	by imf26.hostedemail.com (Postfix) with ESMTP id B7558140007
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 20:17:59 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FyafMBAN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760473079;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bT/7SpttvoyPFfDZkD0MSIyAHcwC7WHYJHOJLI1G790=;
	b=bloBuKh+lvsYWYlyAY9tmnJijC+cX5oiKXJdp/qYNxNw0FDRz0IQxhubsM6Ekgvo8Wy1Gz
	irHmU59tTxlxP/A2xJw0gqSv3dQAAT6a9UxsSCoP8qeedJn/f93u3nI3cCt4iOLIyAjqPx
	jBMN/BHLfQFukbfFa2bQrUV+HmWW71Q=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760473079; a=rsa-sha256;
	cv=none;
	b=CYce/w74wH7BNdFV5oDaoDG2YtO59s7veeuGfjJf08lnsUx2G6PtVNigqMSEN4a9hLU1Z2
	xNpjB52u4X0iran1P/vjDAu91eWZjHYSJYU1mPpMoFnP25HjC6h1rh3FHT/E11lnck4VwX
	IzMSi2xdjJSKrklnAMzQgdzmfsB+ti8=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=FyafMBAN;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of 21cnbao@gmail.com designates 209.85.222.175 as permitted sender) smtp.mailfrom=21cnbao@gmail.com
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-87db3aa478fso623946385a.2
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 13:17:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760473079; x=1761077879; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bT/7SpttvoyPFfDZkD0MSIyAHcwC7WHYJHOJLI1G790=;
        b=FyafMBANFlIWZm+rKCBgOSHsCLKO9GqPYbFTe6WRXlv8as+9Syuv+AeuEsAHwhN2Yq
         LzEL9JScT6vM4SssDUKmXPtBFEPhdyC0yfMGk9YZyWV8nEZo3ubpXD4jyK4MKkvdQW7p
         uL4fk/4hxtDZE0h6W0R+6IIpkcICfQGsDKXwDwWHrylQ2RyQYGYi0/CmyyM6nwKQCis7
         PJcgj9gelSGhrPDoxfC4/cyt/emq1MXzAB8PFvTIj7bVL+Sf1SvwkSQx6S2KfTc067M3
         OX2bpVdOH1M8Lz6to5ZgQH65zL7RCVlZV8xYSB7ZdCmQd2T70jst3ZvNYfKFjw0z7a1h
         wCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760473079; x=1761077879;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bT/7SpttvoyPFfDZkD0MSIyAHcwC7WHYJHOJLI1G790=;
        b=J+m5wWF2h5dh8Zm8ofrBAeDICOYeUQMdRS5Z0YPdJRaoyjDSHSPR4202jKBEiIv796
         4FDdr2I2f2TXrdmUunY1VJGoin3uAZOXVpw7S4zTU3tyKGJkItKDiZVJXOaQmDIq2A1s
         9ulxn+8KmYrLM2TFOKNODsnWNQ8BNHvRO3gxgNexRGAKE5GYKn89ZmGM6BJzmXkccLWh
         0ToK8SigLlk5i3NA1KWW108g0YfgQDKjuJv+YafrbdZNH9W1OqRgvXcl5QXYuyHdycbo
         4ryPkdJ6JEFGc0TSL460qEBIYfG/ZTOAe+HjoS2b3MV6wnNdztKAFncn6CDcFtKc0FC5
         jWmw==
X-Forwarded-Encrypted: i=1; AJvYcCVOGM0ngd72eC2uHVwyKs9fhbUqdb7Qbc4hsykAkaeCeXTO882lTLVBCAy0ZArPI/h/AObNhmfh6g==@kvack.org
X-Gm-Message-State: AOJu0Yx+dchgC/n0qF4Vz+TZbUaE8ZqFlG6tpPjPzfVTivqwCwiQtuVP
	/GLUJw2p107oQB3ydvZBYTACkZGLqwPcnBkMFkyVhc0eWJKdvryKrpfdpAZPdmrcC9Cp5MMvdMN
	Zt9yFFmpadxfmQxHEoPHRaBaVIxe+EmE=
X-Gm-Gg: ASbGncu3W3XbZhog68uLNz5HcPBS0qhXzWAAyycAnvezo94OeriQKb8YFa6tDRZCfUd
	cC922eDReoKBuPeyGcDlxcMTbnereBKgNB5pb09XmqnXQ9Q3lGyp48z2gessA4vDlhK61jy4Dnu
	AMRYPYmnpXej2oYLjhBHjkW+unpOIWEcUlNhraFBneaQ5CtMKcFSSS4LRBPp7KTi21f5UYZ3TVy
	iBoC6kAkW7viOiK2a4kdC72yE1xEnFyqK2Q80nW8xvL54+f6S4RyXagFuJ7kqc+e6iR
X-Google-Smtp-Source: AGHT+IFH4oKwfJUV2I14NgjtJXb6mfnAhJ8zEp3LCF9Bae6duG9Q+7fuIKrLdNF8ldj1eCYSNIUxprx9xOI5hm+x8qg=
X-Received: by 2002:a05:620a:1aa7:b0:863:42ea:d687 with SMTP id
 af79cd13be357-88352d9a142mr3213016685a.78.1760473078522; Tue, 14 Oct 2025
 13:17:58 -0700 (PDT)
MIME-Version: 1.0
References: <20251013101636.69220-1-21cnbao@gmail.com> <aO11jqD6jgNs5h8K@casper.infradead.org>
 <CAGsJ_4x9=Be2Prbjia8-p97zAsoqjsPHkZOfXwz74Z_T=RjKAA@mail.gmail.com>
 <CANn89iJpNqZJwA0qKMNB41gKDrWBCaS+CashB9=v1omhJncGBw@mail.gmail.com>
 <CAGsJ_4xGSrfori6RvC9qYEgRhVe3bJKYfgUM6fZ0bX3cjfe74Q@mail.gmail.com>
 <CANn89iKSW-kk-h-B0f1oijwYiCWYOAO0jDrf+Z+fbOfAMJMUbA@mail.gmail.com>
 <CAGsJ_4wJHpD10ECtWJtEWHkEyP67sNxHeivkWoA5k5++BCfccA@mail.gmail.com> <CANn89iKC_y6Fae9E5ETOE46y-RCqD6cLHnp=7GynL_=sh3noKg@mail.gmail.com>
In-Reply-To: <CANn89iKC_y6Fae9E5ETOE46y-RCqD6cLHnp=7GynL_=sh3noKg@mail.gmail.com>
From: Barry Song <21cnbao@gmail.com>
Date: Wed, 15 Oct 2025 04:17:44 +0800
X-Gm-Features: AS18NWA_1i8a6vTg05EcWS4a7WFXDki8J6oo80AKS6W-CO7YvxmVpyAKLiA8th8
Message-ID: <CAGsJ_4x5v=M0=jYGOqy1rHL9aVg-76OgiE0qQMdEu70FhZcmUg@mail.gmail.com>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network buffer allocation
To: Eric Dumazet <edumazet@google.com>
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
X-Rspamd-Server: rspam01
X-Stat-Signature: ruo5e6e1omsnbpdr94gjjwqbksif331e
X-Rspam-User: 
X-Rspamd-Queue-Id: B7558140007
X-HE-Tag: 1760473079-51630
X-HE-Meta: U2FsdGVkX1+SdTGtM+VPEGYX5IQOFgEKXOKJ0wU9p3cX4fCzW6PZOaYP+3dSb73CnvUGCf5aWyYRBSDdLZLEYM0TWtFFaciNfw+Y6ZRmG6O4KLfpA29aPgtyxktfG0hlaH7T0yVMCvTfDoLowwV+OG+T6smAkBXZJPTRjh9f/zpV3UQH7ehZ5KMm6M08QQBLOBtI8C+ZvVFlvIBbCA4f4QYuhxXG615mfYRiP2GrPvBPyhWu4k/Ing7ZsecJ6qdlE/anJ78SiNv234+hBa30wBcBYWYNiTYvL5CQdTa/croc4EbAWay5AdQPQS9X22jI3PV2jszseeBEYzSx2kYYAn5ILA3554x8aYhafbCozFe6BWB+8aYgzyxLM+pZKyqsu+m/hMqo1cdfdzDStfi3WPjlvdjXn9aJe3Rv6asMo7nSiwRcBYgCVdS6+hzq/l9x0XxKya4Ghgyl8uo//juPirTWqCPk/zOmf5OU2w6if5o0+/4LdSAHzwT1GhZEQnYiB9PpdODzAQ2ewh+nM6TljCvMHK8mIG/4GBvY8mPFzqAMRUp1nyhN/SR+bA/pjblbk8yvUuU+o1FcYkeRBgxJsh2XLs8+0Vj0kHPTCXj7qlM7mtHVUG7m1nWsT1vxaeXvgcYGLEPgiUPh0cm1BBqD0Ufn7R+d1yK+xZdASSDtK8fPSWLoUZl/YWh2qcw1aTOMhqNA+/uf0I2adBqITYR6+wS+hKv9OmujAOsOsPsiC2ZaQBbYSgSLIhYh2lfo0fYzeMXfpdQD9fIskC63ADNzWNr4R1tGTxB4x7H7ZasFst+83cf0nvNt85wI76/CQ4SFZGGAQwoO2eR1gt7Ar4MFOoxXWFBdBugZOfLCN7Tnn6qc6EaTFNkMYY9GqYSV3U6ewrBL2SOFv8uD11cqNFS1j0DM81olAuXlRLhVK62q6NO40peNKhXvbwJldRfobuWnRW5Ne/ZUdSd6FEjq6+p
 XcbnI0SW
 Udaf8yxh84QbmWvnfSLFCT43Z1wh5NvbtCCx5JdL3AsGvYv3AhY9LJ01NWeZK9SchH40STTy+dbv0gr3uyqM4yfoleBAuR0ihw4gI0V9BDdaEhnPd8Lu4UO2qr253ea//Yy6fODBT2h6dXWTwoiLUKHmKCp+Et4w7sJSAAyKgH/T4x6gbB0FzPCUSg6lw1z5IYbtGxxVTCwlHwnih1HAefT7i43xxsp/BvQKEMVV56HMjKva0ibKzzvIgblv1j1Gprc6gJgiX/ITW67xSuEck5NOK5EkU35rVzFIINZQBm8NbC6UdYY+lCFP12MqMsRS2ncpzp/sWqYRbhryCSEUFsPg3YantUkyXTnlIRY5hFf+jksZr6CuhKEPw1AlEglNXjUEN6lhP4xgsbVM1oi3UTIz5h3qtsO/oArr8oV/RSynrEoI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 6:39=E2=80=AFPM Eric Dumazet <edumazet@google.com> =
wrote:
>
> On Tue, Oct 14, 2025 at 3:19=E2=80=AFAM Barry Song <21cnbao@gmail.com> wr=
ote:
> >
> > > >
> > > > >
> > > > > I think you are missing something to control how much memory  can=
 be
> > > > > pushed on each TCP socket ?
> > > > >
> > > > > What is tcp_wmem on your phones ? What about tcp_mem ?
> > > > >
> > > > > Have you looked at /proc/sys/net/ipv4/tcp_notsent_lowat
> > > >
> > > > # cat /proc/sys/net/ipv4/tcp_wmem
> > > > 524288  1048576 6710886
> > >
> > > Ouch. That is insane tcp_wmem[0] .
> > >
> > > Please stick to 4096, or risk OOM of various sorts.
> > >
> > > >
> > > > # cat /proc/sys/net/ipv4/tcp_notsent_lowat
> > > > 4294967295
> > > >
> > > > Any thoughts on these settings?
> > >
> > > Please look at
> > > https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt
> > >
> > > tcp_notsent_lowat - UNSIGNED INTEGER
> > > A TCP socket can control the amount of unsent bytes in its write queu=
e,
> > > thanks to TCP_NOTSENT_LOWAT socket option. poll()/select()/epoll()
> > > reports POLLOUT events if the amount of unsent bytes is below a per
> > > socket value, and if the write queue is not full. sendmsg() will
> > > also not add new buffers if the limit is hit.
> > >
> > > This global variable controls the amount of unsent data for
> > > sockets not using TCP_NOTSENT_LOWAT. For these sockets, a change
> > > to the global variable has immediate effect.
> > >
> > >
> > > Setting this sysctl to 2MB can effectively reduce the amount of memor=
y
> > > in TCP write queues by 66 %,
> > > or allow you to increase tcp_wmem[2] so that only flows needing big
> > > BDP can get it.
> >
> > We obtained these settings from our hardware vendors.
>
> Tell them they are wrong.

Well, we checked Qualcomm and MTK, and it seems both set these values
relatively high. In other words, all the AOSP products we examined also
use high values for these settings. Nobody is using tcp_wmem[0]=3D4096.

We=E2=80=99ll need some time to understand why these are configured this wa=
y in
AOSP hardware.

>
> >
> > It might be worth exploring these settings further, but I can=E2=80=99t=
 quite see
> > their connection to high-order allocations, since high-order allocation=
s are
> > kernel macros.
> >
> > #define SKB_FRAG_PAGE_ORDER     get_order(32768)
> > #define PAGE_FRAG_CACHE_MAX_SIZE        __ALIGN_MASK(32768, ~PAGE_MASK)
> > #define PAGE_FRAG_CACHE_MAX_ORDER       get_order(PAGE_FRAG_CACHE_MAX_S=
IZE)
> >
> > Is there anything I=E2=80=99m missing?
>
> What is your question exactly ? You read these macros just fine. What
> is your point ?

My question is whether these settings influence how often high-order
allocations occur. In other words, would lowering these values make
high-order allocations less frequent? If so, why?
I=E2=80=99m not a network expert, apologies if the question sounds naive.

>
> We had in the past something dynamic that we removed
>
> commit d9b2938aabf757da2d40153489b251d4fc3fdd18
> Author: Eric Dumazet <edumazet@google.com>
> Date:   Wed Aug 27 20:49:34 2014 -0700
>
>     net: attempt a single high order allocation

Thanks
Barry

