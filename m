Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F1ECCD185
	for <linux-mm@archiver.kernel.org>; Wed, 15 Oct 2025 21:50:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF3168E0093; Wed, 15 Oct 2025 17:50:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3EA8E0027; Wed, 15 Oct 2025 17:50:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A924E8E0093; Wed, 15 Oct 2025 17:50:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 91B378E0027
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 17:50:57 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E10161604D6
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:50:56 +0000 (UTC)
X-FDA: 84001694112.18.EC2F352
Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0E0D58000F
	for <linux-mm@kvack.org>; Wed, 15 Oct 2025 21:50:54 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=mojatatu-com.20230601.gappssmtp.com header.s=20230601 header.b=cBuDvpuK
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760565055;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iduM9BCUy9A1PPFJTP7NoUXJkN4FJL3UKtirvC6QjRM=;
	b=DhBTAuSQn4DCAwHjFVWf+1GeEN2RgFCMJIG+cc30JkJ64orMdA1/tJN3ZUfgkUAjkuPr49
	WX2HU3OSlrB5no4yIQ0kJl9/5wDvmW+iR8DsrMDF+koAD5GynpRVk0/tjbqPvJt+S5SoVL
	nfkd9XSCYSnWhgef58egq8ri9U+A63U=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=mojatatu-com.20230601.gappssmtp.com header.s=20230601 header.b=cBuDvpuK;
	spf=none (imf02.hostedemail.com: domain of jhs@mojatatu.com has no SPF policy when checking 209.85.210.181) smtp.mailfrom=jhs@mojatatu.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760565055; a=rsa-sha256;
	cv=none;
	b=icXNNca4caxo+Vk1v6ZfXw4v2qRm/0AC/zxbS4vk3qrmjK7A5C4wRVVggd35fyDeU977Mk
	p0yS1PFuCgMdW0CTcC1PWd9F9jDF6sexQIx/cB7EBHW00uyk6Lty4HKGtbcSoDwlPjojxq
	S9JNrF9K4KSYcDg3n+Q0ZOp7KMLJifM=
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-7833765433cso152638b3a.0
        for <linux-mm@kvack.org>; Wed, 15 Oct 2025 14:50:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20230601.gappssmtp.com; s=20230601; t=1760565054; x=1761169854; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iduM9BCUy9A1PPFJTP7NoUXJkN4FJL3UKtirvC6QjRM=;
        b=cBuDvpuKgvuwxscVYzAXEbOBOpRzOVcDKMm+ohrYwZPP9pp5w50RaVrTkrYUmRfikj
         sbJ6h3Qqc39wdHyYtZ9RcghajgjYbQJMhUtv1S+HTMRkGXkmgSz/UOxgh2lSUa7dEE22
         rRP/ZW6JRKn0bzsTxubPlftPtxsMlY2D5VPSrTbPwa6d0sI/Pspr+Seubt75Us7D2LbY
         oXmbwifER/eA2ly/gcJVojq0A4BkA0cNRVBP0Vj8l00fdu5f6K5wqnPpm1d3BmLtOz5n
         zzb2a27Gdlv+tUfFj8pZu2GmtyY2BWHLQtk6ghqh48xokRomZFoPYl+ek4ndJXuT843Q
         oQCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760565054; x=1761169854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iduM9BCUy9A1PPFJTP7NoUXJkN4FJL3UKtirvC6QjRM=;
        b=ckRxyg1JteYRiBtyszNjOmhHn35rQMqPGgMYMh5lIAqkCRQrja/ln46mm5PuMrebW9
         3a1kMUpaTnyFNvANptteg3ZNn4b58L8m8p/STo0JQTo7T4xFiGsBbQcmZwQ8rRgpXK4V
         tpi8D+bWe6rGi55MRos+MLnaiYT8jZMJqhHrxpGUdUWMbX0ld+/i0vLsyfLSczuphcfO
         pOxi85+CyUUvSFBoII01iUqx04V1lcjjyfrD3N68CcsPip5xKLuQurSAHV7ZQXDzn7/M
         HYq9BLxNziBIcKjjuKsa7MmiiW1fClQiv25QbdGxohq8cUozqwchLKXVLY8u4x39Hfqs
         /6fA==
X-Forwarded-Encrypted: i=1; AJvYcCWDYPIk0Lw4hatEd9x8hC8x72NRoUKQXIbo3ex9/D8apcxaPonG5uI814ZYUkA74u2dslwWRD/vcQ==@kvack.org
X-Gm-Message-State: AOJu0YzjXtphJg1U9nO5XZrWeEC8mGGUPWV6Yaep8FIGQegKQr/lz6dG
	Gv4T7Rdx1n4ne2JuJDQJO6L315x/bNZ7WM0aOAEOpOS6K0Il4WnNw2yqqis9UN/4Zw8+Ay60Rcq
	SxbMAa8oxvGlRnUIjuLOo7KhV6bv6tp6bbmrlgwg1
X-Gm-Gg: ASbGnct/8+/GtyW/hHWQYd7D4v4cMb7eIIqi2BpoPF0oPDtkE1mWcuDuye2XtjlLmR7
	YNuS+hwXpYkvVgGDaMku5lTcnBmAWlMWjN7Q/Hjv4tkpGlbXibJV4SEWSI3y2PhNnCZVr8cVt8b
	V9fyUpK3HYuUGIT9TnalDRRIoGHjLEtvOy7OTdhvOGNBatkQI/651L92ingvTgI3MMXNkMgohyo
	+gN7qFFYD6vImI4ASxgLSHft5RoYlpkZZS7Vmxc7O01RLENf9pmPMoqm7GjoqfQlY9g/z/1a0r0
	reoGXDRrKeWfnm3a/p8H18mreZ+xC88IYcNX
X-Google-Smtp-Source: AGHT+IFwZrRh7ZKAhbIlR4D12tk51kY/fRatZwY2OQID0vS3YYNT414SduS1rI4gvIe3Me4Ogb4ysXIQ+xiEjdpPLrE=
X-Received: by 2002:a05:6a20:3ca7:b0:2e5:c9ee:96fb with SMTP id
 adf61e73a8af0-32da84ed584mr41211395637.59.1760565053849; Wed, 15 Oct 2025
 14:50:53 -0700 (PDT)
MIME-Version: 1.0
References: <681a1770.050a0220.a19a9.000d.GAE@google.com> <68ea0a24.050a0220.91a22.01ca.GAE@google.com>
 <CANn89iLjjtXV3ZMxfQDb1bbsVJ6a_Chexu4FwqeejxGTwsR_kg@mail.gmail.com>
 <CAM0EoMnGLqKU7AnsgS00SEgU0eq71f-kiqNniCNyfiyAfNm8og@mail.gmail.com>
 <CAM0EoMmK7TJ4w_heeMuD+YmUdMyEz7VWKY+a+qMO2UN4GYZ5jQ@mail.gmail.com> <20251014201149.ckkw7okat3cv55qk@skbuf>
In-Reply-To: <20251014201149.ckkw7okat3cv55qk@skbuf>
From: Jamal Hadi Salim <jhs@mojatatu.com>
Date: Wed, 15 Oct 2025 17:50:41 -0400
X-Gm-Features: AS18NWBoDDX5v9apL36RaGrCWfEkUt2MPnhglXFLB138k75uT3ov8ARY2TM2AaI
Message-ID: <CAM0EoM=1swUNW5F2Ha4JCf3VW309m1S0JEpSqiyR5wH7e=YyJw@mail.gmail.com>
Subject: Re: [syzbot] [net?] [mm?] INFO: rcu detected stall in
 inet_rtm_newaddr (2)
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: Eric Dumazet <edumazet@google.com>, 
	syzbot <syzbot+51cd74c5dfeafd65e488@syzkaller.appspotmail.com>, 
	Vinicius Costa Gomes <vinicius.gomes@intel.com>, davem@davemloft.net, dsahern@kernel.org, 
	hdanton@sina.com, horms@kernel.org, kuba@kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzkaller-bugs@googlegroups.com, tglx@linutronix.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: bndyefud454accte4j9gxhdngjyznmsx
X-Rspamd-Queue-Id: 0E0D58000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1760565054-817448
X-HE-Meta: U2FsdGVkX189K5rgGod7lhovbGPGdsikq2UXUAl9klWiUN3k1EqJurCqTIsSytUvldVvjxC5nd6nb5sCdlbYgT/LSdbx4eJe1ny1dxz4FfrlQ9vMzFLvDj9QubbS8kiLRcFDiXRUzO8SCxJFSQMG2MZf+cTuHgmY6J7Fruy5mOvL9F8nMLDEHGMmZTTYCvCIHNEoTnYshkFOq1Fry9qpLk92m3PLpHiscWZZls3NmCDVTOiVocXEgOVR39tfZfPAkdgL8ShKKVz+3Tqqlw8bcoImJ494vjVeZJzlqi/Wc0jnAoztQtiC6zJUEWqu4kSNDVbyaaRrXsJct6rCLdY/7WZNGFXROlBgl1UjhHO8HWQVV7db4gVha9PHE6ea7HtqAJewwM1YkcnRNX3polJ3U1faQVDPyGnLgf3EmrXvFLpd8XwJ/nYUlLuPC4UTAavVmkxhNAoQ0512DmdPTjrRtDkbIDtW23DyMMeHMjYSjphboyK9fguP4ZKQ1vF4K5Of+Dnpeu/i5Riz9NUWQ6K711kt9RbaSKH8Ba4InpE1HDSgA6/6V6UDDzgOD36tU43cM9BKepK7TD5zC0g7QWzBNDoofVrtqrhrAiRTGH0M3TpsPl3GCSmmHmCyGVfnEZpChfVO7A0xE+U2afz0ODXqVdABaeO6FJB38vJCKWIkEUGLevdhiRz6U6Clgl6+9T/thP69CS46kx7g3Q01cbb9tKA/3Mg6E6JdCNpLbqGc7kEPbo9jTri+Qm0fU2lIQXx2aBGWbt6Ly97zUkmoNRPVPrOJqJnXVTttra1rg9gU3y9PmJz/t2IXObqAIAfXsJEMEU3OO9qeXvAxDCBB37y4FT3O2U9rBRRlpOyHT6ynCUlFitNqHPG9rc1Kdzdt/2tLHvjBjyQQdMGJctbW6OVQW3MywGs9utqEmajfOSUGt70OPW3+SmS+k2Mx+OiaKncF7iZoH5Tm3yiutUIENnF
 ZmmlIc4u
 xwplswPLX9vPr/bBvoUgMKKLBJZeOpJTBAwEVFclb2XuBgASRtREJTYcGX149n5RcFkQ64uBGP7wJMnyaF0++4kogn63Uglw4M3U9ms9TgqtCz1QlQ9eCdTg4PLiJd/R2mnL6ENOechSoqYL9OX/vgpkaIkqcjYFxn/aJmBFYTSJlGv1/VCE1eHfiIm1El3Hllouwf+DnHpXcX4JhEiqUVzXlcvufMhqZ5YuIb3Dpy11on+EmrXbyZoIUBj39vt4MtFH+WXXFdZ13ArDBHK76hdyttiep7FebZD6R0rqzQi3mQVguWKkhrzDUhiRe3jnZ3mgSrMi87QTVAoxCCPSCBy9MFNGwEjXO3f1tS6NHQhsI9hl5OdX+1gOdlllZszKOB7neH0O6YEyoS0asf5eneHYzEnMRl2k2enXDrQvRNJjoFcbLjQiH6KCnui5UAtMa7iY4qzsfq8GN5+odPYIWTMtQDA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 4:11=E2=80=AFPM Vladimir Oltean <vladimir.oltean@nx=
p.com> wrote:
>
> Hi Jamal,
>
> On Sun, Oct 12, 2025 at 11:52:54AM -0400, Jamal Hadi Salim wrote:
> > > > Yet another taprio report.
> > > >
> > > > If taprio can not be fixed, perhaps we should remove it from the
> > > > kernel, or clearly marked as broken.
> > > > (Then ask syzbot to no longer include it)
> > >
> > > Agreed on the challenge with taprio.
> > > We need the stakeholders input: Vinicius - are you still working in
> > > this space? Vladimir you also seem to have interest (or maybe nxp
> > > does) in this?
> >
> > + Vladmir..
> >
> > > At a minimum, we should mark it as broken unless the stakeholders wan=
t
> > > to actively fix these issues.
> > > Would syzbot still look at it if it was marked broken?
>
> I still have interest in taprio, but at the moment I can't look at this
> any sooner than the second half of next week (unless someone else beats
> me to it). I've added a note not to lose track.
>

Thanks!

> What is the situation with syzbot reports? I don't actively monitor them,
> only if somebody happens to email me.

These issues have been lingering forever..
They do get posted on the list. Here are samples:
https://lore.kernel.org/netdev/676d25b2.050a0220.2f3838.0464.GAE@google.com=
/#r
https://lore.kernel.org/netdev/67d2a576.050a0220.14e108.0030.GAE@google.com=
/
https://lore.kernel.org/netdev/67946a0c.050a0220.3ab881.0010.GAE@google.com=
/
https://lore.kernel.org/netdev/66e96979.050a0220.252d9a.000a.GAE@google.com=
/
https://lore.kernel.org/netdev/6777334a.050a0220.3a8527.0058.GAE@google.com=
/#t

They all point to the same bisected commit, but am not sure whether
they are the same issue

To get you on Cc from syzbot - i think we'll have to add you as a
maintainer for taprio if you'd be okk with that..

cheers,
jamal

