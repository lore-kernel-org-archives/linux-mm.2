Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E9AAC83F27
	for <linux-mm@archiver.kernel.org>; Tue, 22 Jul 2025 19:04:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E48536B009C; Tue, 22 Jul 2025 15:04:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E1FD76B009E; Tue, 22 Jul 2025 15:04:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D5D996B009F; Tue, 22 Jul 2025 15:04:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id C6F1D6B009C
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 15:04:03 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 74660130BBB
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:04:03 +0000 (UTC)
X-FDA: 83692825566.04.977E7ED
Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	by imf01.hostedemail.com (Postfix) with ESMTP id 766F140019
	for <linux-mm@kvack.org>; Tue, 22 Jul 2025 19:04:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AhcYZiPP;
	spf=pass (imf01.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753211041;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iiA8Ffhznoaz71o6X2Lhv1DU3VKSS1u8j+C6Sx2f3R4=;
	b=QlOcVY8E3tL1+oUIxz5vJLmhrfHuCoQLtYsgkGO1yWGAsrlf4UjQ3wulW6I+f9RXhmpIIQ
	AUBhemzDmnD4IU4NandZhc/gLyursma6AWlZv3YBlVxHFxBBtbPVUNzT0Djs5gMRF+YEJD
	IgFkYxF3qd1fKxeB0L9RT8QIKT870Gw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753211041; a=rsa-sha256;
	cv=none;
	b=E4kaKxJAKi2FrEHdTNj3pwnVb7gzUYgyLNp/KgHEyJpVX3RVe9YTrC2n2EpMiAcfnCl0HQ
	/iPfchvTe55uyvwSIq5yF4FvbzMnzWEQxU1AMU/gR0q/1GNS1CNEiAxFvPMqA/GsFaAtBl
	Li9WYFgMmkdZjO5IhDMkoLKzzfuPzV4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=AhcYZiPP;
	spf=pass (imf01.hostedemail.com: domain of kuniyu@google.com designates 209.85.215.169 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b271f3ae786so4383985a12.3
        for <linux-mm@kvack.org>; Tue, 22 Jul 2025 12:04:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1753211040; x=1753815840; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iiA8Ffhznoaz71o6X2Lhv1DU3VKSS1u8j+C6Sx2f3R4=;
        b=AhcYZiPPoJzHUU1j5uj0Hqn96bDVmgLMSVSPIzFGj69WfRWhvk0uLnyUkFhK/LojX6
         r62TD/Q1V0SryouUgaocFzc/lTSI1NIO/HZDoT6w/r88ApeX40CRMWukwMLzA7Ky1QEj
         nLy7Qz7NT4lnbqOnupM/PfxDOeyy7XXfBpYb2yXvU1AprGmq+OLoowMooTUOKunVtnpn
         ZBtDnpmiWqA4bedMS8NjNSFxgTJ7siLyoiepWS2mY4xWHpg/KaRqRW4oNjMkcz+iguk6
         6RUFiBq/2j28Sp/ca2qtFz9QklyL+fMtbXIy7jLZwvHJH5jMg7MfqX+EhtYdsdQ0QFFu
         W7cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753211040; x=1753815840;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iiA8Ffhznoaz71o6X2Lhv1DU3VKSS1u8j+C6Sx2f3R4=;
        b=I58YhavgIZDzAlHcP/phVlbY5c7BGEpm0MAWcHHfIw9x09lIWJ/EMtkjQAnyS9coi+
         5vI73Xdmo0XbITymIykLDXrBMT7/sdcN9R06kYf26b2CYM5NzsO0IXr86lnr8d2efs5G
         zsZT1sicQFZO+nJKiajYD7LtGYITf9r6+ZQSFaT9Dlt46HVauk0SxIwABWt1bo5KBlU8
         4mIvXflWOk9CLc4EXsVD8hJhnnr3Z8qw7qD/B4azZSw5foxCOMY9E3Z07dXyW/2jKiGC
         rXYLPBGuMUuPdYXbMcc0dRTzCoQYjKL4aM2z4SiTgZF6XPtCMqk6erNmyruuzrs6833y
         EjEg==
X-Forwarded-Encrypted: i=1; AJvYcCWBdLSLou1rg8kuJHW1W3GOut01+AxbVg1NxjgNPjfChjCsRV5j4t1d7SjfgMdLj6IbV13UWq3UlQ==@kvack.org
X-Gm-Message-State: AOJu0YwKB4BlQifGvbKBWaVxurxzrr880bNXk0gL7SjWZR1/jo340voD
	QOx2+iFlOS1LreVb+FEsFLqj58P5dGOoXV57OCkJc8hIMlS6vYu2hOjYzaoz3D+XLvX5YM757rp
	nNGhRcf/STB/LVuzjGsCpWd5uxchl33601hkP/083
X-Gm-Gg: ASbGncv87m079bmpJ9YFcifTkvvGF8/4k3NK/njis94oQEJHzdC33FBZmw87fW+CbcO
	OMlmGg+WNgU9agX4enXd25j0BZ3ZTJeaJZCGgy+QET7i5ccFvPGY305gkiNHa+6tK2acVMnbyRd
	SqFJLFSCx4duS32xuAW3wysSEAJEeAiPzSbGtPUBRdQ65Bhpx8Hmk1BU+SUH8yA+DA9EtbCc5gM
	wEpQqNyrkhNj7LEHzXRsbX4fK0wk0eAjLojeQ==
X-Google-Smtp-Source: AGHT+IGYBGaRF4+4yiskF7ML1G3zkbt1R2dprHwARsZQ44k60mvIUIP4kGdlv2eHeVBIwzBUJ7cUV3igAXlin7CBAhg=
X-Received: by 2002:a17:90b:35d1:b0:313:176b:7384 with SMTP id
 98e67ed59e1d1-31e5076981fmr533620a91.11.1753211040076; Tue, 22 Jul 2025
 12:04:00 -0700 (PDT)
MIME-Version: 1.0
References: <20250721203624.3807041-1-kuniyu@google.com> <20250721203624.3807041-14-kuniyu@google.com>
 <z7kkbenhkndwyghwenwk6c4egq3ky4zl36qh3gfiflfynzzojv@qpcazlpe3l7b>
 <CANn89iLg-VVWqbWvLg__Zz=HqHpQzk++61dbOyuazSah7kWcDg@mail.gmail.com>
 <jc6z5d7d26zunaf6b4qtwegdoljz665jjcigb4glkb6hdy6ap2@2gn6s52s6vfw>
 <CAAVpQUAJCLaOr7DnOH9op8ySFN_9Ky__easoV-6E=scpRaUiJQ@mail.gmail.com> <p4fcser5zrjm4ut6lw4ejdr7gn2gejrlhy2u2btmhajiiheoax@ptacajypnvlw>
In-Reply-To: <p4fcser5zrjm4ut6lw4ejdr7gn2gejrlhy2u2btmhajiiheoax@ptacajypnvlw>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Tue, 22 Jul 2025 12:03:48 -0700
X-Gm-Features: Ac12FXzbgoBRyeJ7XxGUPxk-8v86WqDVVO-Vj_Jc8u00Jp12117hni6mqwz8B-U
Message-ID: <CAAVpQUAk4F__D7xdWpt0SEE4WEM_-6V1P7DUw9TGaV=pxZ+tgw@mail.gmail.com>
Subject: Re: [PATCH v1 net-next 13/13] net-memcg: Allow decoupling memcg from
 global protocol memory accounting.
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Eric Dumazet <edumazet@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Neal Cardwell <ncardwell@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, Matthieu Baerts <matttbe@kernel.org>, 
	Mat Martineau <martineau@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Simon Horman <horms@kernel.org>, 
	Geliang Tang <geliang@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kuniyuki Iwashima <kuni1840@gmail.com>, netdev@vger.kernel.org, mptcp@lists.linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 766F140019
X-Stat-Signature: onbfydjdjizh64urrpsj9brzbfnp3osm
X-Rspam-User: 
X-HE-Tag: 1753211041-909367
X-HE-Meta: U2FsdGVkX1+G9z8WwZ7RbPxK/O6Os7I9i97hVSb5z3Lxk4Qd+OxIRoiNjGJ4oy81kjxiQhwl++H7oU/RkfygRNDfxBF42cnempl0942qdeTJgKBjP7bkdNOU2m/oKZJMLUW3yUk1OVQR4r4AaAJjfE7xCqxqbEZ1QyyJqo0+m827VWuhDK9/PK0oJexagGioxBNFbeHY5aSj3UYHn0+jF6Je9Xs6vgWKzSpaHz9+T6Af71OfNXfye1lBCV3tTnbWU9bR8hkBrWOfYuAwQb9gprCyn0JR4lU9WLYzR8p/nlAAYudjEM36kJnF5bVCaMLqtvQhs1rRTM/lqJq8o+/8IstYRaFQT5/LSQropsKvo5p6X0tu+6p1oUsLoTgq+JWgInQ/lMPqkSE9syb7n3zq0zMJUniK+L5QP7uzN1xdmKPHLm2Hh0k2Fed96ahMKsHGi/qaAsaXz5J1/4ayCxj6BiAvv3NZhFudQWM5EzVCGERkJmQDNlPAHeqH7jPZMZHscf+Kc9FrBq4e8KJJ5rtRRfx+/UPgzw4PoffEypUA3B/6ysVJ0F1pcArmkYYACPYEmV+kk9sV2LRD2dVA0zT+J0Ph5QYKi9D31lOELV/pGa376RtmNESoqJysjuwCezZR/9hT8txRVawgrkHqGoJ6g8QvGzUT7+sFOiREo030ntaKWwphexC6d01mrpUqelRsrSpYApXPSYGFb7zvuJ6sCOZz7cvDgIfHkir8ZGhLtoKkTAbkonPxZAhTujbdx1i0HrwJ+NEvyDmPHkv2Ew79Batl8lYYhUzWC4PV1sq8TeS9hQLRCARirKuccjeoYECkTmh3f6FUl08JaoWbsbhIUYWmjrpSiQ5ewKaF3JFcTVhFIJwUphvJIfqa2cd00noHwHODbGcfXlazurHkkJuSlrk64Y2DpM9evhXKhiUt1rwwlzxhxEEVzDKhR1EH1xjPqL1y3g1KIS+Km1OiGk8
 pymB95Ao
 Py2cR9DSoG+Ohgn+jVEZYASwgCB7DJxkLJBU4m8jU4FP/tmXmVwZG+/vy+y48Pfh72U0fR0E/u+60M9KwXEYFeridsXqJT0VauxpseUYUZfCPtbAknM2+f30bXtlkbLNTsQkMzd4G+J8GkVYeoQFSbBPXmxM0tVuDHbj9uCQfIhx+VNspsPKGQNf9r0yjaaxqNRv/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 22, 2025 at 11:48=E2=80=AFAM Shakeel Butt <shakeel.butt@linux.d=
ev> wrote:
>
> On Tue, Jul 22, 2025 at 11:18:40AM -0700, Kuniyuki Iwashima wrote:
> > >
> > > I expect this state of jobs with different network accounting config
> > > running concurrently is temporary while the migrationg from one to ot=
her
> > > is happening. Please correct me if I am wrong.
> >
> > We need to migrate workload gradually and the system-wide config
> > does not work at all.  AFAIU, there are already years of effort spent
> > on the migration but it's not yet completed at Google.  So, I don't thi=
nk
> > the need is temporary.
> >
>
> From what I remembered shared borg had completely moved to memcg
> accounting of network memory (with sys container as an exception) years
> ago. Did something change there?

AFAICS, there are some workloads that opted out from memcg and
consumed too much tcp memory due to tcp_mem=3DUINT_MAX, triggering
OOM and disrupting other workloads.

>
> > >
> > > My main concern with the memcg knob is that it is permanent and it
> > > requires a hierarchical semantics. No need to add a permanent interfa=
ce
> > > for a temporary need and I don't see a clear hierarchical semantic fo=
r
> > > this interface.
> >
> > I don't see merits of having hierarchical semantics for this knob.
> > Regardless of this knob, hierarchical semantics is guaranteed
> > by other knobs.  I think such semantics for this knob just complicates
> > the code with no gain.
> >
>
> Cgroup interfaces are hierarchical and we want to keep it that way.
> Putting non-hierarchical interfaces just makes configuration and setup
> hard to reason about.

Actually, I tried that way in the initial draft version, but even if the
parent's knob is 1 and child one is 0, a harmful scenario didn't come
to my mind.


>
> >
> > >
> > > I am wondering if alternative approches for per-workload settings are
> > > explore starting with BPF.
> > >
>
> Any response on the above? Any alternative approaches explored?

Do you mean flagging each socket by BPF at cgroup hook ?

I think it's overkill and we don't need such finer granularity.

Also it sounds way too hacky to use BPF to correct the weird
behaviour from day0.  We should have more generic way to
control that.  I know this functionality is helpful for some workloads
at Amazon as well.

