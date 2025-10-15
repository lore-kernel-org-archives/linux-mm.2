Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 54C9CCCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 06:39:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1BE18E0003; Wed, 15 Oct 2025 02:39:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF3EE8E0002; Wed, 15 Oct 2025 02:39:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A0A578E0003; Wed, 15 Oct 2025 02:39:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8E6958E0002
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 02:39:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4A4C45C931
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:39:14 +0000 (UTC)
X-FDA: 83999396628.19.411301B
Received: from mail-qk1-f173.google.com (mail-qk1-f173.google.com [209.85.222.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5E1B2A0007
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 06:39:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UDsqyGlZ;
	spf=pass (imf15.hostedemail.com: domain of edumazet@google.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760510352;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bsukMYa0AUCqYEvcLXRhuapsU2hd6Y80454Ux1AAjL4=;
	b=1rjbySQIYljWr0giuvL1QGeiM2vyBg7BzCt+jtnZzyZ3vZ595Ykq8BoDvZ7hwjKStPNHNt
	ecZO1fLvJz3NtznyDw0vqMnCNcvRO+PThIV2mMk0Ydteum2Uee20ZDapIvvrIpKrlYkWK/
	K2V5iy81Vd/awDY3vZrzJPG8P3KrV0Q=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UDsqyGlZ;
	spf=pass (imf15.hostedemail.com: domain of edumazet@google.com designates 209.85.222.173 as permitted sender) smtp.mailfrom=edumazet@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760510352; a=rsa-sha256;
	cv=none;
	b=wdN6Zzad7QHLVDQ7SPoSsno5p9PwEgrNhNlp6f5iUW8ilQQbfEr/tyIxe0G7i3bowNWn2+
	89dgqqfFahJC067k7vWFqY72C0bX6Pg0rawQz2qavCymZ4hJZ1y2seRn/lnOHpw1diOteX
	NcBZA7KkJZoMEMixqYgndwfZNTFW9Zs=
Received: by mail-qk1-f173.google.com with SMTP id af79cd13be357-85d02580a07so73665285a.0
        for <linux-mm@kvack.org>; Tue, 14 Oct 2025 23:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760510351; x=1761115151; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bsukMYa0AUCqYEvcLXRhuapsU2hd6Y80454Ux1AAjL4=;
        b=UDsqyGlZ1QoVVAwIVs4fz4/ABi7Y8etQR0pbbV3uMwTeI5sz90J/2H5WMJ1AWHDs1o
         J+qDODygFKjANm42pYLiMVu5t7FMWW3Zpce4OVU2wZF77UfFxgJqvpxeF3oLH6FbOZoW
         zV/SQsBh7/0flC50CgZ5+eu9KXwO9+ycuTSOy8gHO/loduFm+EgvSKJS7s4wvlKEUIkB
         60xbUhTxWmlYg8jfMpoAr2d5iMLy8NSQSj7BNwvun41diylrrSdJG54m0eemgHfZN+9D
         rh6clrFE1Bmc/DvGuFIK1hlVClTKQOX+mjM/O7rO2rN7DyNrwucHLjvolVkBn9eMyLiF
         aw6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760510351; x=1761115151;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=bsukMYa0AUCqYEvcLXRhuapsU2hd6Y80454Ux1AAjL4=;
        b=Zr8UO6Dl3ibC+zUCkfZAafPd0m6EjfrNbNKyUigsZ6mfT55MNhkeBcDTXb2qxd5Eb6
         GZXfwc08AYdU0Vejdi6vvdxSMVcpU7mIwf+JKSWsdKUhZP76B0mD4dtCOHHg0bb2HwHC
         ny+XHuKyTMa42XBdNDfAOtWCAUCUCaybCyF2ayNEKXvlYhnGiEi/VO0Cm6anSdaYbSu7
         V4XUm7+1zx2MzqnsTPxZcpR6lvXKiNX9NZYoSUZVxQSrRpyDRI0OFTdwDO4sunHzggev
         NgRmt+2WW1AxTWcNcfJWRKuyIuklLmqHyw43/CafxKZi7lk7Hgh7gkVaQ2m1Yn+A2X6J
         OBPQ==
X-Forwarded-Encrypted: i=1; AJvYcCVKhTVWmx9CxYW1ShtP+POcrrShQe5Dd9Ru/gmX5K+Os1e7ItNIP6EMfbaHXnu486G+dkQ7W9zQ4Q==@kvack.org
X-Gm-Message-State: AOJu0Yyaw4OmWGjdounBjUJ99ZZ4AULnzu8c4WgXe37YoxgMQBup0hfi
	P41qwfQa95vT3qdcp92x8c8o7LtTj3GUrpWwke3DCjl9bZ7oz85oQCtcyE8nReEKnv+Ss2blCbE
	dYUOn6M4NIvmGPWANxo2r6tzq90ZiL9dY9j5leP1y
X-Gm-Gg: ASbGncuyGmmoQDRrFOlQiSOoqii83096Ns7bVlMCMxkmwC+Nypl0HUWfu6OJzQzKqK2
	JQGu5zEU+l5IdEA7lRHcmIa0olsm+ooS6X3IY1RsEWKvdqiozbSPciF+yhwIfjRBDHGKKvHaqzc
	QjuObaT66Yf6vkxTvS7AxXwMPRbcXk2/j/sf5tXZe8m7kzOXf0fmukBshz8BZqLuA5zYWsp8aP2
	U4lJUqTYvLMeLy3SrknZ1dVIatOqTa7mA==
X-Google-Smtp-Source: AGHT+IFK/RWWMbmryZERBFoMRzd6/kz9EwXNSWCusWT0Lc+3vQtZfacIx3bleY22OD0BqECfDUYhjeSl5kCs+LlgdPM=
X-Received: by 2002:ac8:4799:0:b0:4d1:212f:6689 with SMTP id
 d75a77b69052e-4e6eb068d71mr314051311cf.41.1760510351122; Tue, 14 Oct 2025
 23:39:11 -0700 (PDT)
MIME-Version: 1.0
References: <20251013101636.69220-1-21cnbao@gmail.com> <aO11jqD6jgNs5h8K@casper.infradead.org>
 <CAGsJ_4x9=Be2Prbjia8-p97zAsoqjsPHkZOfXwz74Z_T=RjKAA@mail.gmail.com>
 <CANn89iJpNqZJwA0qKMNB41gKDrWBCaS+CashB9=v1omhJncGBw@mail.gmail.com>
 <CAGsJ_4xGSrfori6RvC9qYEgRhVe3bJKYfgUM6fZ0bX3cjfe74Q@mail.gmail.com>
 <CANn89iKSW-kk-h-B0f1oijwYiCWYOAO0jDrf+Z+fbOfAMJMUbA@mail.gmail.com>
 <CAGsJ_4wJHpD10ECtWJtEWHkEyP67sNxHeivkWoA5k5++BCfccA@mail.gmail.com>
 <CANn89iKC_y6Fae9E5ETOE46y-RCqD6cLHnp=7GynL_=sh3noKg@mail.gmail.com> <CAGsJ_4x5v=M0=jYGOqy1rHL9aVg-76OgiE0qQMdEu70FhZcmUg@mail.gmail.com>
In-Reply-To: <CAGsJ_4x5v=M0=jYGOqy1rHL9aVg-76OgiE0qQMdEu70FhZcmUg@mail.gmail.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 14 Oct 2025 23:39:00 -0700
X-Gm-Features: AS18NWDMOlh0tBS4TlU64c6PgouY_kRH71v_bFl3FqJI9-6cAzN_kZLryiaCnBA
Message-ID: <CANn89iJYaNZ+fkKosRVx+8i17HJAB4th645ySMWQEAo6WoCg3w@mail.gmail.com>
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
X-Rspamd-Queue-Id: 5E1B2A0007
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: y75imyzywzzaponxxi7gtgd9d35yjzy1
X-HE-Tag: 1760510352-222787
X-HE-Meta: U2FsdGVkX19xef8pJwtSwIxkm3rsgnLXXX8FA28QWVP6CRnx/ewP7TjCz9rSi0Zblmd4MpRZ24CEKlfogJ2CdIrKN+o8DMQ7G/RqrPsdkRoFbA/nY9VFquhP5XKeB5XjmFx3MRaw+CFWOq3a7AYraEs35sc5sJIcN5+sgPstdAwBsMm9EFqwZAHWTNUPLgJ1c/tq63BOmpSbqgDa4M+Snw7LEPggR5M6CKY7GLcrba8mFC+XkXPHA8oVJRE7rq6/A9KMYfSE+x5D8+pbeqLjbtJ+i/MLnWyqSSM2yFw46RVDmHJTEC/bHNf4qP2g32AkcMUbVpWmb9s5VDIFBOTbGq19G9h0fgeY1okU0QwHmuYQvcoP+BoW42BmxlClNtlcDM+2vIdRV64RShusspkz1r/sl3/vSfERW0fV0xATbb3K1Kz54MgMfzSb9lTEpAak30sqMngtqNaSwPhWfbOmk5wpngzeI5aa0hpW64e8Ns7vF1HfXTL1+KM+z8d/AzqDk31wlAJ7FPdmpw1uxJFd8xxZuS0xzMYhniq6lI6mntWfwDQ+Axvu4WjNEFyDNAh+eGj1gNccgMRs7DrKTmMyqYg9oWWyjaeZQg6Zyj35FHDqIbL/ZZ/OwkhI8xgzw+q8FL0JvWtgwyETyA766ZvgNkcpqGpE+AFIv8iBrHK5AeguuXGKmCuoOmWIZhgWrliUy6GJkjssVH/mwWMMXv5hIYkwlUge5dhteFVJmkvz62o6ieO93zpvpJVtdX8DyTZtQOdPfEQgF4g04q73lVxuNcXfhws9dRgUTqns3TjKTM/RSiMmTj+nj32Pex9QdoRWvFTa7ttiHVFc7bJWc1cY6XGQZPfbhbCeW1GoyEYcG+UNHvxk7cobe0O6HKFbtMIGcdSfDoGYFN7gXiwdrEoJtNm6noHeqCpuOIcEbg/uX8oLTslswaul4iyxSigFV8WyhQzCJd95LoMbry/iYok
 svfW21FH
 LBKgD058eHRz54wQpbi+wENBo1bdG93M7XdVeR/nTk/qgUr6WOhFfylQ4gdWOb/Bx31++3TDZDVNxUVaSMaieEVTr1ifoWeN/Ik4OWyuXyZ216k2ZP2aOPMQFo0mZ094RGzKaMNLaFXMGVWGP/V6xN2XVs4l7r5nUpe3HtRbBJLC4XOEiiD2jevJVB9fQ/gsdik3QdHxZwTOubTELaYIH37L2Iwgogs7pE9hmfazRtEJNnLtIB0HkQPe4DM/15mAWObFUlrBNWGj27zM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 1:17=E2=80=AFPM Barry Song <21cnbao@gmail.com> wrot=
e:
>
> On Tue, Oct 14, 2025 at 6:39=E2=80=AFPM Eric Dumazet <edumazet@google.com=
> wrote:
> >
> > On Tue, Oct 14, 2025 at 3:19=E2=80=AFAM Barry Song <21cnbao@gmail.com> =
wrote:
> > >
> > > > >
> > > > > >
> > > > > > I think you are missing something to control how much memory  c=
an be
> > > > > > pushed on each TCP socket ?
> > > > > >
> > > > > > What is tcp_wmem on your phones ? What about tcp_mem ?
> > > > > >
> > > > > > Have you looked at /proc/sys/net/ipv4/tcp_notsent_lowat
> > > > >
> > > > > # cat /proc/sys/net/ipv4/tcp_wmem
> > > > > 524288  1048576 6710886
> > > >
> > > > Ouch. That is insane tcp_wmem[0] .
> > > >
> > > > Please stick to 4096, or risk OOM of various sorts.
> > > >
> > > > >
> > > > > # cat /proc/sys/net/ipv4/tcp_notsent_lowat
> > > > > 4294967295
> > > > >
> > > > > Any thoughts on these settings?
> > > >
> > > > Please look at
> > > > https://www.kernel.org/doc/Documentation/networking/ip-sysctl.txt
> > > >
> > > > tcp_notsent_lowat - UNSIGNED INTEGER
> > > > A TCP socket can control the amount of unsent bytes in its write qu=
eue,
> > > > thanks to TCP_NOTSENT_LOWAT socket option. poll()/select()/epoll()
> > > > reports POLLOUT events if the amount of unsent bytes is below a per
> > > > socket value, and if the write queue is not full. sendmsg() will
> > > > also not add new buffers if the limit is hit.
> > > >
> > > > This global variable controls the amount of unsent data for
> > > > sockets not using TCP_NOTSENT_LOWAT. For these sockets, a change
> > > > to the global variable has immediate effect.
> > > >
> > > >
> > > > Setting this sysctl to 2MB can effectively reduce the amount of mem=
ory
> > > > in TCP write queues by 66 %,
> > > > or allow you to increase tcp_wmem[2] so that only flows needing big
> > > > BDP can get it.
> > >
> > > We obtained these settings from our hardware vendors.
> >
> > Tell them they are wrong.
>
> Well, we checked Qualcomm and MTK, and it seems both set these values
> relatively high. In other words, all the AOSP products we examined also
> use high values for these settings. Nobody is using tcp_wmem[0]=3D4096.
>

The (fine and safe) default should be PAGE_SIZE.

Perhaps they are dealing with systems with PAGE_SIZE=3D65536, but then
the skb_page_frag_refill() would be a non issue there, because it would
only allocate order-0 pages.

> We=E2=80=99ll need some time to understand why these are configured this =
way in
> AOSP hardware.
>
> >
> > >
> > > It might be worth exploring these settings further, but I can=E2=80=
=99t quite see
> > > their connection to high-order allocations, since high-order allocati=
ons are
> > > kernel macros.
> > >
> > > #define SKB_FRAG_PAGE_ORDER     get_order(32768)
> > > #define PAGE_FRAG_CACHE_MAX_SIZE        __ALIGN_MASK(32768, ~PAGE_MAS=
K)
> > > #define PAGE_FRAG_CACHE_MAX_ORDER       get_order(PAGE_FRAG_CACHE_MAX=
_SIZE)
> > >
> > > Is there anything I=E2=80=99m missing?
> >
> > What is your question exactly ? You read these macros just fine. What
> > is your point ?
>
> My question is whether these settings influence how often high-order
> allocations occur. In other words, would lowering these values make
> high-order allocations less frequent? If so, why?

Because almost all of the buffers stored in TCP write queues are using
order-3 pages
on arches with 4K pages.

I am a bit confused because you posted a patch changing skb_page_frag_refil=
l()
without realizing its first user is TCP.

Look for sk_page_frag_refill() in tcp_sendmsg_locked()

> I=E2=80=99m not a network expert, apologies if the question sounds naive.
>
> >
> > We had in the past something dynamic that we removed
> >
> > commit d9b2938aabf757da2d40153489b251d4fc3fdd18
> > Author: Eric Dumazet <edumazet@google.com>
> > Date:   Wed Aug 27 20:49:34 2014 -0700
> >
> >     net: attempt a single high order allocation
>
> Thanks
> Barry

