Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49612C87FCB
	for <linux-mm@archiver.kernel.org>; Wed,  6 Aug 2025 23:41:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DF86D6B0089; Wed,  6 Aug 2025 19:41:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DA8D16B008A; Wed,  6 Aug 2025 19:41:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C97BB6B0093; Wed,  6 Aug 2025 19:41:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B368A6B0089
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 19:41:00 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3EC2F81C55
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:41:00 +0000 (UTC)
X-FDA: 83747955480.16.DBCC1C4
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id 5F78E140002
	for <linux-mm@kvack.org>; Wed,  6 Aug 2025 23:40:58 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fIADS8Gx;
	spf=pass (imf09.hostedemail.com: domain of kuniyu@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754523658; a=rsa-sha256;
	cv=none;
	b=xV3Sjla9M/KriZ5tqB9tpjZ9FMMmNm4JytnACQ9mWNV6/9HeNYaOaSmUXlxIxO5AEy1GER
	kFjoxD/QeLrU6vDfWGbvEas5Ta54EWTC79QF8G4HmnQ9E/6RtC5MGgRNkALc49ZGbl5HMq
	HYSexjrg/aWY0FLZ6/jY5P+WeabZ6I4=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=fIADS8Gx;
	spf=pass (imf09.hostedemail.com: domain of kuniyu@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=kuniyu@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754523658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5+V5MD6/KwNXDMRDn89IDlWGyGIpIEfb7ohjgwGr06Y=;
	b=2HrO3q72slELJUFJfvJfDu8gUaubiOxc1+Z6z4LFiiP5PLlMderYGRFge7+v1dTGzRqrgm
	bd20IDDi69No9GPTLcvWqvArvd/UqXSi5oydUutiX/ajNIhOpUzsF0CE5Uga9csQM8F4Rs
	sQtjJr/Gs5BeSj6dcxI1t9MQ4wiINAs=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24022261323so15519445ad.1
        for <linux-mm@kvack.org>; Wed, 06 Aug 2025 16:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754523657; x=1755128457; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5+V5MD6/KwNXDMRDn89IDlWGyGIpIEfb7ohjgwGr06Y=;
        b=fIADS8GxiBKtPPQKImEdqCMmHEGoyiwkbkefVkZr1Uxtp9JcyQ2TaMOCAnpc/HgVRI
         DOqG/w60ZySG+LBHi3zjqUI6BbLW0dWc17eaSK4jK3Yca7F8wvi/VfBHCuecKXkg9D2P
         A7DQuEci17BSZPWQcPif2XL2sp9aIQJFxXvSo9CB0D6fqp76X2tyOnvYJueKywBWel7U
         zNdpoSAaybKs2ujLx514bLWHzSb6gX8ESU5u0P+VShNH6XYRHE8lUol7UxxJRKLGHl9R
         +AqeplRZv5LRghXM/AIFH0ghzcvLkO5MPe+8Ghi6UEpd7LXJOx7k7AulJ/EB8VCl3S6B
         Ie0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754523657; x=1755128457;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5+V5MD6/KwNXDMRDn89IDlWGyGIpIEfb7ohjgwGr06Y=;
        b=V9p0ugw7q5Y1M4lSmuTjc1nm5gvqv0bFESXkWwSEIIRvpTxf5IbfUQg0bHzLnAuU4r
         QuMMGm13rpRDYPZGKmQ1KFRKEFVAT5g5qzLb3E+ou3dXB3lQYyfDuEzd02gCn2Gxo6UM
         C0fCcl0s/qC377jN8aBmWvD/vOlB0p129z48Pf2KHS9gsVueq8NlybYMra9zb8aezoqL
         gxP+OLVdjy//BkZpR0Z5yIumwT7j5bQulMR0H+psjgtqnbxoOkl1v7m/y2XQ8rCm5Pb2
         QQ1xUJ9hixMlX1w7SDgP/9oX/qobeyJevfPEfUIgfuJk0VDQkKHM2/3VTrmP8apBk1Es
         Kf4w==
X-Forwarded-Encrypted: i=1; AJvYcCVOjL8pE/4XRzl4lkZz0kPeLeskBhQc3Yd3/Mo1lNkAp/5saySI38D0C+5tBHPreiCOkSUwFM0FmQ==@kvack.org
X-Gm-Message-State: AOJu0YyCq0+xstITwvbA7aUnVSolDfoQNXlZd5Bn3mdIQ2mwKqm0paYf
	d/f20w5tKMhMl1jmUarBuRNeXFA//LkDcHalAGcBwiq+gP4K3K0ZxkqbNIDR0rU/d66KnQoVwSY
	0hiKnqzMar0+wqcsgUwVkCBVCWWHHuFPgvW1Wywd6
X-Gm-Gg: ASbGnctU6/BeQxrFv78aixq1JJ8m3P4K4cg2S6Y0nBI57IWoNPjtlrEqVojb90ccZdx
	Ez1214OBSQzWDwHwB3mDZ6O0aTTkz43AAHS/h1reIzjkWrsubP7h3UCDxwPe83JUt5Wr1R4Xzd/
	hve8HpjPTWRm8Xvldmdr76ONjAK2fhrgL2tjQx0KAhJGzLkR4ahkU0nCAh+fHK4j3aYSV727eY3
	n7a+JoX6Kp1PXI8W/5s9UOO4KsFt5wJc3KL8g==
X-Google-Smtp-Source: AGHT+IE9xx0BslmXdh3PX3583hJLYwZKiRHlhcVZuar+6J/aRROEdJOAGMwU1KyNvxPLk9ne8tw/T2xezEOaTvSGSQY=
X-Received: by 2002:a17:903:28f:b0:234:325:500b with SMTP id
 d9443c01a7336-242b075c43amr21436795ad.22.1754523657123; Wed, 06 Aug 2025
 16:40:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250805064429.77876-1-daniel.sedlak@cdn77.com>
 <fcnlbvljynxu5qlzmnjeagll7nf5mje7rwkimbqok6doso37gl@lwepk3ztjga7>
 <CAAVpQUBrNTFw34Kkh=b2bpa8aKd4XSnZUa6a18zkMjVrBqNHWw@mail.gmail.com>
 <nju55eqv56g6gkmxuavc2z2pcr26qhpmgrt76jt5dte5g4trxs@tjxld2iwdc5c>
 <CAAVpQUCCg-7kvzMeSSsKp3+Fu8pvvE5U-H5wkt=xMryNmnF5CA@mail.gmail.com> <chb7znbpkbsf7pftnzdzkum63gt7cajft2lqiqqfx7zol3ftre@7cdg4czr5k4j>
In-Reply-To: <chb7znbpkbsf7pftnzdzkum63gt7cajft2lqiqqfx7zol3ftre@7cdg4czr5k4j>
From: Kuniyuki Iwashima <kuniyu@google.com>
Date: Wed, 6 Aug 2025 16:40:45 -0700
X-Gm-Features: Ac12FXyPFTWmf4LzgmzsB_A4EJ6yxnsuvE00MbfxXyp9hRdFCTtZYOCeXLJDM_E
Message-ID: <CAAVpQUB_aEcbOJR==z=KbfC1FtWi2NM_wNm_p+9vL1xqfw7cEQ@mail.gmail.com>
Subject: Re: [PATCH v4] memcg: expose socket memory pressure in a cgroup
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Daniel Sedlak <daniel.sedlak@cdn77.com>, "David S. Miller" <davem@davemloft.net>, 
	Eric Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
	Simon Horman <horms@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Neal Cardwell <ncardwell@google.com>, 
	David Ahern <dsahern@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-mm@kvack.org, netdev@vger.kernel.org, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Matyas Hurtik <matyas.hurtik@cdn77.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 5F78E140002
X-Stat-Signature: naqh6etdfgm3shubeo7ykjs1s67u1s8g
X-HE-Tag: 1754523658-481742
X-HE-Meta: U2FsdGVkX1/lTmpsa7lTkKQZJ1zLhWBCyxui1vgyT0S7HKyoGDIqatHXk99TwJVH3uApd33UFTlvGlbejHjaC+5RI2UuL6mO8jbVysF8+v2XH43H1H6Sc2fi7lt1/DnxIXScYMQOznGi/SrGNF1ahqMwONnjuR+8y9s90xc7KM+Oo3eqg8u0oM9551ZzpUzfDn+8/pkgT7fu21wjRQNh/ZYIilXULf3n8gCi9ZywzKkTgGpEwUFi/hgsqw4sfUkLpknPVcIFPdhVUoKC5pC15mC62BnT1YHEEpwAufLRrcdn2TanAfqeK7rW6ga3Rl/Gcyka4YQ3bN3JY+2XCs45TUjoeKC1eGCy4nLmoozpxhzcDFR+WoaZIatDZCWwZRHgIm1/pS1LAcbGPcw+sXytQgM0WMUsenVDHJ7l/X2dyrzg+fUB3F1wzm7CsZVG4sYalc2eNgY9R0OcBTIyDzcdpxDC1+PIxz9go3tdNd/3t2I6nzedwjCLjseTEb3+IbeQMURMufihu0bMHsHKaz3hp+feHLkH+hHTbt0VGgRwFWXD3J6ok37MTvy3AVTohTfNf7tgaHejm1tDd1TGv+AvByO4s36I4msloeKDI4imd/zTGFT5YSad9KIQ7E22CmF5PEwi8hHsyPtauWXXPtEl15KEwd2x0HViCPylqceFnwX6A5PIX7VR9GGy0I7yd6XeI5f5H1HeZuh1GaUnuyrr/HgZybjBFBCL1aKRQfquCp6f+0KO5CeymizMOgNYjCBpNMMsrQl25JCwkTPsfg1eQTD1n/PBxXj08kb3KtscZb5dxu4q+yCQlFyMcYxPsbd41lhfgNPmFGPNt8puaAJr3UQS95JCruPqr3rVDcjShctjohEhtLWM/7nDqezBp3pY08DCHj16cf5gT+zPipIq/BKeSwMob6ANbZ+PWOIPAoOblUTVjH36J1wAg5CmFZ1kSUeMEimRamUQ8kyUSqg
 8YBgCLvY
 QqvIPwTdmI0u2N2tB/ZWCoeVNmE6U/QE6uA/GPsp5RSWJXilWfcqkUdnLBq9A1uy1I4rimKUkQvPoJeZ8XPieh04jT02S58FrYUcTvDUD7cK+AS4x71MiUsy5g614f3pEWJ7ka0LhVafPZ+aQTCutHO3OgSKYntGJfKLDXZMHq/GiV+jPHNAfF9x+0HHo1x58YM5Q
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 6, 2025 at 4:34=E2=80=AFPM Shakeel Butt <shakeel.butt@linux.dev=
> wrote:
>
> On Wed, Aug 06, 2025 at 03:01:44PM -0700, Kuniyuki Iwashima wrote:
> > On Wed, Aug 6, 2025 at 2:54=E2=80=AFPM Shakeel Butt <shakeel.butt@linux=
.dev> wrote:
> > >
> > > On Wed, Aug 06, 2025 at 12:20:25PM -0700, Kuniyuki Iwashima wrote:
> > > > > > -                     WRITE_ONCE(memcg->socket_pressure, jiffie=
s + HZ);
> > > > > > +                     socket_pressure =3D jiffies + HZ;
> > > > > > +
> > > > > > +                     jiffies_diff =3D min(socket_pressure - RE=
AD_ONCE(memcg->socket_pressure), HZ);
> > > > > > +                     memcg->socket_pressure_duration +=3D jiff=
ies_to_usecs(jiffies_diff);
> > > > >
> > > > > KCSAN will complain about this. I think we can use atomic_long_ad=
d() and
> > > > > don't need the one with strict ordering.
> > > >
> > > > Assuming from atomic_ that vmpressure() could be called concurrentl=
y
> > > > for the same memcg, should we protect socket_pressure and duration
> > > > within the same lock instead of mixing WRITE/READ_ONCE() and
> > > > atomic?  Otherwise jiffies_diff could be incorrect (the error is sm=
aller
> > > > than HZ though).
> > > >
> > >
> > > Yeah good point. Also this field needs to be hierarchical. So, with l=
ock
> > > something like following is needed:
> > >
> > >         if (!spin_trylock(memcg->net_pressure_lock))
> > >                 return;
> > >
> > >         socket_pressure =3D jiffies + HZ;
> > >         diff =3D min(socket_pressure - READ_ONCE(memcg->socket_pressu=
re), HZ);
> >
> > READ_ONCE() should be unnecessary here.
> >
> > >
> > >         if (diff) {
> > >                 WRITE_ONCE(memcg->socket_pressure, socket_pressure);
> > >                 // mod_memcg_state(memcg, MEMCG_NET_PRESSURE, diff);
> > >                 // OR
> > >                 // while (memcg) {
> > >                 //      memcg->sk_pressure_duration +=3D diff;
> > >                 //      memcg =3D parent_mem_cgroup(memcg);
> >
> > The parents' sk_pressure_duration is not protected by the lock
> > taken by trylock.  Maybe we need another global mutex if we want
> > the hierarchy ?
>
> We don't really need lock protection for sk_pressure_duration. The lock
> is only giving us consistent value of diff. Once we have computed the
> diff, we can add it to sk_pressure_duration of a memcg and all of its
> ancestor without lock.

Maybe I'm wrong but I was assuming two vmpressure() called
concurrently for cgroup-C and cgroup-D, and one updates
cgroup-C's duration and another updates C&D duration.

cgroup-A -> cgroup-B -> cgroup-C -> cgroup-D

Could that happen ?  Even if it's yes, we could use atomic ops.

