Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1FB70C83F1A
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 18:49:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 972D98E0002; Tue, 22 Jul 2025 14:49:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94AAE8E0001; Tue, 22 Jul 2025 14:49:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887028E0002; Tue, 22 Jul 2025 14:49:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7B0928E0001
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 14:49:54 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1793D112D78
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:49:54 +0000 (UTC)
X-FDA: 83692789908.16.E04E1F8
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2D348A0009
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 18:49:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="2KTtQ/cL";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of kuniyu@google.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753210192; a=rsa-sha256;
	cv=none;
	b=lF+/5XECKRxE0vO5lBlpws9/c1ORqkcwsbR6ipzMj0zjlr71XIt2ZfyyBs8a7kBnf1FbBn
	WWw3IV5ZXkhBsiuD2cRkYpLLPL6vAdyOmLb3klNwBdTH4sh8ddl7DNGhyB8uYldPLCXkIr
	V3dTQ5uwqgA95emMWOupGOLp7rdWU9U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="2KTtQ/cL";
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf15.hostedemail.com: domain of kuniyu@google.com designates 209.85.210.173 as permitted sender) smtp.mailfrom=kuniyu@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753210192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TbmC//gG5YMMT+YnkzJjaAohtCxkf2risib+NKHtOrg=;
	b=3mHrnTk6kDdaZzXG7mmbl7IDq1VuPVRGfpXvdmeN0hxiR6q3+NcSGab0vvkD5UVyky1Tj8
	6DeuxdpVKsq2hhx4fxpIRfOoEjdmF2aLp4vArOsXjo9DsxQFV4I7Wi6bcTIAUb/UroEMNH
	1krsQ/fiPcqtdwUNrTPxZF1DSE0Z8qc=
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-74b54cead6cso3802932b3a.1
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 11:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753210191; x=1753814991; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=TbmC//gG5YMMT+YnkzJjaAohtCxkf2risib+NKHtOrg=;
        b=2KTtQ/cLyVpbQiPYP38wFSMN0D7xO3au3tuQkn76S1Hk81ylkgK9IFi4yqhge/zCpd
         GHYGoa4Fdiq68GNbr6IE5HCTZSq7LlNUflpNldv8cTGXStU/UnZLq7Kg/v0VE2X15tTY
         Ux1K6y71Yyfa/LgtWJKWPecgE2KWORfbeSOFOT8vK1a2e0JwdUL/xVqEsGVgiyJUDMr2
         qClngodJr4hINraOOM2tu8HPWeMP2xwzo0uqEbRhi+cvxg3Kqi3+EK2ZH5yxG2iZoI77
         L6tbhTo3PSPGF4FzSABoaFosCe3hb0hSeKzewRlYJNsQrVjMIGUV2LPQ/yIHZjuCTvVa
         IftQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753210191; x=1753814991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TbmC//gG5YMMT+YnkzJjaAohtCxkf2risib+NKHtOrg=;
        b=Ww1eTe4kV+acQiXyyr4yoglE0AMev2xCGpt7qD5/U/aCaJyrZtMXVVGzb4DPgWaOVp
         MSB5VpRC0eZfJG52DbGLnNJ3SvM8gupFyA6GFBAYvvjmXNEioJtnYa/GhqKrTr4TzgyJ
         goPPSrBzp8cyn8p1T8wEVIbGDpU1AsjKGp81q2qeWJ21xSWPmWcy797nFQO/1gp+1RQB
         7Pg42aEEO2nNrGzKF3C96q2aSkRq1kT4G/iFunbXbxeZqsMAilxe098oYI7ZIeNrk5Ba
         wvvgSzUlXVI17Sz0TRWPsgVmwqqNWYyNCgrYcGE/5eFofFjF+tdSgoJoymNwD5tyyPZc
         Ilsw==
X-Forwarded-Encrypted: i=1; AJvYcCXoqIad5qkFqxUPv99duYvzSY7GaIZk7AIbwmNNaxy7exMvBjGlwXq6LgCao/qnTcVAUGtYzlRlpQ==@kvack.org
X-Gm-Message-State: AOJu0Ywr6jvpW2ERm+FoQTWRmv/x1UBUhKJFWv+QfHn3FM6wBnbLCQxn
	RAh19qyERZyd1IWZWwVbIod5Oq/K9Ek1qS6Gc0rCjxCg2BxHu/EAQVa4bMignVoRYdjGUskzbyD
	/sanllD4pkshUvBXF4NppNpqlnPrnV3yyc6kww9BN
X-Gm-Gg: ASbGnctrsMYmltqLWP8dUxqtsvEYekBYaUttlaWQie4D0o5if3OKSlGjtnpkLdSeb+/
	B/+ctokdsNEcYwW8IJFa/zv/E3kVqze4/D/dPP1bVZSWIo6Hxfvv28nK3MNpI0vdSVZfV4rxlzU
	Fl5+PRHamkDXlpSNH5YjOqpQrJ3DgoM71SGL4Ju7Qq3iOU80rmxBdt9W03gp9Pg+Xb+3cNIk1k2
	wX/UMNzAfHfNVipv84aqkk4o/ytjgd5cpIKSKkqz2wLC+WU
X-Google-Smtp-Source: AGHT+IEg4W97E07D/JlFeehtaiwxPWUF4AnFa19XV+i75fU3XCe4tqE6HcJMrlHWpbyEhBQz5BtcSmGxO+C8g2IB2zw=
X-Received: by 2002:a17:90b:388b:b0:312:ec:412f with SMTP id
 98e67ed59e1d1-31e506ef9afmr612863a91.14.1753210190763; Tue, 22 Jul 2025
 11:49:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250722071146.48616-1-daniel.sedlak@cdn77.com>
 <ni4axiks6hvap3ixl6i23q7grjbki3akeea2xxzhdlkmrj5hpb@qt3vtmiayvpz>
 <telhuoj5bj5eskhicysxkblc4vr6qlcq3vx7pgi6p34g4zfwxw@6vm2r2hg3my4>
 <CAAVpQUBwS3DFs9BENNNgkKFcMtc7tjZBA0PZ-EZ0WY+dCw8hrA@mail.gmail.com> <3db01bc9-f6ea-41f7-8cbf-fb33e522694a@redhat.com>
In-Reply-To: <3db01bc9-f6ea-41f7-8cbf-fb33e522694a@redhat.com>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 22 Jul 2025 11:49:39 -0700
X-Gm-Features: Ac12FXyhexe6ErD4K44AhQAu2qUuwklTJsSiRV2SdD5og77T3xQkMML2F4JwTjY
Message-ID: <CAAVpQUBgDVHwCzw_UJBeh_SLf=w547fKy9v-ke_Rw7Q-C4rhhg@mail.gmail.com>
Subject: Re: [PATCH v3] memcg: expose socket memory pressure in a cgroup
To: Waiman Long <llong@redhat.com>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Daniel Sedlak <daniel.sedlak@cdn77.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	cgroups@vger.kernel.org, Matyas Hurtik <matyas.hurtik@cdn77.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2D348A0009
X-Stat-Signature: 85mu5z6icjhgkgzn3956kfy697c74oy8
X-Rspam-User: 
X-HE-Tag: 1753210191-336561
X-HE-Meta: U2FsdGVkX1/69cjXuhMtMX+TeNjhE+UIhyQzcHp+dNIoiOFMx4smF03cDwaeqfQsPtmjD7OZGuxz6yzdRzTmGGmiC5s3grI9EJfpj7GlcCh2KfvFKurQsUmMOGwn7kG8Eejmj4Tr88f6uITbdN4MyMaVckUdqHdcQop7zkpEVj16nMhppokR+gBYNDTh3AT8TchMVwi6LCibJH+VQwZMSNpOJjIeYBAd6WblKrs2kgexvAjhmVcJW/SMR8xx0dfDCULgNUhIlSnBTvUjl9Us+GduRuaRNqSdq5VGtBZJTwNSgikMycY4SgwHY9rDlCzc9VbeuM/qfFUTFYYkPllYbnvXmNqLZOzIDSo5pTclhxcTm1YmFaOcTK+O7bW+PHOJvbnddmAMmnBIgfYKPPPdHw8bMi/ozADIfHTBar83Fm70TyyZAdSX7CNRQ8xSNLEj9kiuRJGg4JzDXmEZ22TzIROijVKA+1XdvlbKjxDoAAT7KU17ehkO9G1cJclKc15lqtGEd8kVbT4fhvHiO6PEcH0LFl40LcxXMwO53FPHDPqU8g8+JaLk7va03pFwJNdg260TXdJMcOvPz8mTxSMXjrhocyX1mz+ePRpufEYDht+e4tgwRBAT6AcDQKVN3tAVaQh76px2+BKncFDh6cwKvjvDUzLkl4Bbu2U3BSISoSn7pd8hX70kpRo6C+Vx9oDDnmYdqJEdCOPl7TIBZwGaM7l454Y3z0qjq/wqNigXKnTRB64QJJ9AxbbX10as2+zYcgrWAPDdGFhbwDvT8qoCqAogShwR/3pTXrq7FNTxwnXAAAKHn8ke9DQ0PaC229UmjfrCiZ6CgN0iXmKLcc8+E+X4Uf74ybR7wVEiBAcdAv6EUW/IH95LdAXSL+ybd+0Ij1HPxs8MDR6uHGP2G2NKhPRIZPh3jYkDJ+mh7DatIPDuLLK+VuKh/HChvwaUf79n6Pjl+fr/IHrm/VmcPG6
 /OFoaPju
 lYGIOzRzsc0Bf1HClSeD5+oD6pZI64YVVTR1KjvghadDbIxtvm3m010ZmxU2FQvJF9v5yAr820ee8e0OFhyk62rFErIJ77p+fPaWloAwEhkw6zmOOdhBWVK3jJ78ZOe4ABYJU1xpmFoW2atZDG3g4oi3plr/99J914Ai6oiHeMyJcAmzWub8585A1u6m+2DX0ENLBs66Cg2JtA1dvwZUq3jVYkdnpawJKF8Qm7FIK9biqjmEuEfX+mmli5ODTUgTUsWojRTBkBySM/TJg3jiGYbctcO5I1KnIybLGaUpPFnTek5Zy5/2PbfpNNs4qhYu22aKH3us0LSm0uU20/NOxraQE1g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 11:41=E2=80=AFAM Waiman Long <llong@redhat.com> wro=
te:
>
>
> On 7/22/25 2:27 PM, Kuniyuki Iwashima wrote:
> > On Tue, Jul 22, 2025 at 10:50=E2=80=AFAM Shakeel Butt <shakeel.butt@lin=
ux.dev> wrote:
> >> On Tue, Jul 22, 2025 at 10:57:31AM +0200, Michal Koutn=C3=BD wrote:
> >>> Hello Daniel.
> >>>
> >>> On Tue, Jul 22, 2025 at 09:11:46AM +0200, Daniel Sedlak <daniel.sedla=
k@cdn77.com> wrote:
> >>>>    /sys/fs/cgroup/**/<cgroup name>/memory.net.socket_pressure
> >>>>
> >>>> The output value is an integer matching the internal semantics of th=
e
> >>>> struct mem_cgroup for socket_pressure. It is a periodic re-arm clock=
,
> >>>> representing the end of the said socket memory pressure, and once th=
e
> >>>> clock is re-armed it is set to jiffies + HZ.
> >>> I don't find it ideal to expose this value in its raw form that is
> >>> rather an implementation detail.
> >>>
> >>> IIUC, the information is possibly valid only during one jiffy interva=
l.
> >>> How would be the userspace consuming this?
> >>>
> >>> I'd consider exposing this as a cummulative counter in memory.stat fo=
r
> >>> simplicity (or possibly cummulative time spent in the pressure
> >>> condition).
> >>>
> >>> Shakeel, how useful is this vmpressure per-cgroup tracking nowadays? =
I
> >>> thought it's kind of legacy.
> >>
> >> Yes vmpressure is legacy and we should not expose raw underlying numbe=
r
> >> to the userspace. How about just 0 or 1 and use
> >> mem_cgroup_under_socket_pressure() underlying? In future if we change
> >> the underlying implementation, the output of this interface should be
> >> consistent.
> > But this is available only for 1 second, and it will not be useful
> > except for live debugging ?
>
> If the new interface is used mainly for debugging purpose, I will
> suggest adding the CFTYPE_DEBUG flag so that it will only show up when
> "cgroup_debug" is specified in the kernel command line.

Sorry, I meant the signal that is available only for 1 second does not
help troubleshooting and we cannot get any hint from 0 _after_
something bad happens.

The flag works if the issue is more consistent or can be reproduced
and we can reboot, but it does not fit here.  I guess the flag is for a
different use case ?

