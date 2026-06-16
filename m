Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA147CD98E1
	for <linux-mm@archiver.kernel.org>; Tue, 16 Jun 2026 20:43:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5D606B00A5; Tue, 16 Jun 2026 16:43:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0EDA6B00A7; Tue, 16 Jun 2026 16:43:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FDAD6B00A6; Tue, 16 Jun 2026 16:43:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6AE9B6B00A3
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 16:43:07 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DADE012020F
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:27:15 +0000 (UTC)
X-FDA: 84886910430.17.297CD20
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id E9EF7C0007
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:27:13 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JuHuu832;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781641634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e6nRZUUDaqrNRBspLG7ihU4cunwzWB+iNdq0zIyl7ds=;
	b=LJvqFSg/e5Ud4pFzg2ROvBpffHDTU4GLtsJzCfq5tqyvI2QXjvFnzfyMFuQhNH8zI4XHlp
	rJCEK2YjabUx4g8fTD8E6FJkXyuJ83ILsreB3AgPMTtmfVP49setyMIgi5WmUVPLZFX5cF
	7g9j6RzBPM1FH9s7iOrqPIXiAboLa6s=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JuHuu832;
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781641634;
	b=JWDceE7j/pwITIZipeGE3SMT7oLMWWg4NS3g5/OTNp0Wn5MiIWX15GNiLtJ/ILYaKDW7Fn
	PNrv6VuhDC3P79tgKTAE4OpXAoYzHCQjdiFzoRlWCIcHBn1iYb8nH5oHxlD8ibRUnsl7yi
	riIUiIlJrXTgRPczhC57sB5f/2zrFHA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4759D60120
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:27:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFD291F00ADB
	for <linux-mm@kvack.org>; Tue, 16 Jun 2026 20:27:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781641631;
	bh=e6nRZUUDaqrNRBspLG7ihU4cunwzWB+iNdq0zIyl7ds=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=JuHuu832ps/PLAv/yjPk05o0j/bNWU+8RQEPpNUm12No95UDH4ydA/RnpaX0vKxOQ
	 bMOKWuENOMqiq1ZmHfZX+tyYpmRZ9jbR68Pg3GXPiEttCHCBNkxjoMgusSYAlxxYIp
	 WPhsjHYJEnkYmhJKTJr1bXIKaR0p6jN58Lhm7zYuK33zmj5lsaUfEZt+e46Dn7jl75
	 /+WkL8VWfs/4p8OfhmRkeXMULgoi3L4ZBvUPuQaM08r/kNEaJrXPY2h5R40+Nhy11A
	 jkLT/8QkQNdzPa+BTmgWkAR5Zvdyb0a/AIBtFGYFWwJHx4DPDZ493iuwCyO5hyI1cs
	 SFULSDoPg8t/g==
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bf0170c80f7so851986066b.3
        for <linux-mm@kvack.org>; Tue, 16 Jun 2026 13:27:10 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ+/c0WTZrG5F01TWr6CxZ7rjkSyMQrp8puvX+a72+HUKrsBM4Y0QOuCmsGTb+2C23YFvte40RnOtg==@kvack.org
X-Gm-Message-State: AOJu0YxBdNjjxP0IkNrGqV/FFyKqCjWvacm2P2n0CoK+VsGRtMho7pDr
	e/lv0wpzxjONeyw+InALQK/oaxXlnZ6lT8L71qrr/HEVoDGpzrJuYNqmDElJmSWaKpzTnG8TGti
	1LC1HwmWgS3Cc/t106EkVclfaGpTBc5Q=
X-Received: by 2002:a17:907:3f0a:b0:bec:6c5c:cced with SMTP id
 a640c23a62f3a-c05a69ec26dmr89257366b.28.1781641629909; Tue, 16 Jun 2026
 13:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <aictKA0XWMWbxFdN@linux.dev> <CAO9r8zPvCaCqvoUhPdAN5Oi_Sj0mK-t7DJhOOz3Xf1DT-Wrgcw@mail.gmail.com>
 <aieUQUBHI+E3uNPW@yjaykim-PowerEdge-T330> <airzE7jD9UtyR17J@google.com>
 <aisEWnb3pzmVC4dl@linux.dev> <aiu06fbV7rWqY0Bm@yjaykim-PowerEdge-T330>
 <aiw2p5ANjsQUCIHA@linux.dev> <ai5y923elCSZp41j@yjaykim-PowerEdge-T330>
 <CAO9r8zOVqbJEaBqTHw=r2bYw7Lm1tO0TU9QuG+eH1rfqcTAJJQ@mail.gmail.com>
 <ajCgzNIPLhjTRSXR@yjaykim-PowerEdge-T330> <ajC+FNpkVpI4pbBz@yjaykim-PowerEdge-T330>
 <CAO9r8zMimM8n54BL1viuX3pYzO=wzQU89LhCF1HW0bAv97ZQtg@mail.gmail.com>
 <CAKEwX=Nz9SWcEVQGQjHN8P8OANJY4BG0w+iQOzoNOWuteoVjAg@mail.gmail.com>
 <CAO9r8zOD7XaJ0Uo_LLLDTRKbeTOmAwmM3q8q6rUyH3oS-X3Csw@mail.gmail.com>
 <CAKEwX=N=Umi94wdKcLxEWOqUwhz6=Lj909pc1Pr_5ivVnZmdPQ@mail.gmail.com>
 <CAO9r8zMHGFG_jcVeDPgowaQ2RNntp3KankwzQdgrJb9PrWu8_w@mail.gmail.com> <CAKEwX=NyfxfXhHESTLyirAgdVA6QaYAcam792-vSZdmo0Pz+bA@mail.gmail.com>
In-Reply-To: <CAKEwX=NyfxfXhHESTLyirAgdVA6QaYAcam792-vSZdmo0Pz+bA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 16 Jun 2026 13:26:58 -0700
X-Gmail-Original-Message-ID: <CAO9r8zOg0OP1Ak1v7CRzSfQq0D8b4Dw+_T0Jui6YTM_KwQQNOA@mail.gmail.com>
X-Gm-Features: AVVi8Cef9RFgkBD4H21fnyl2aKEeUxi6JgJdg1HlDVnffa50e_DqpC4LMfTVVho
Message-ID: <CAO9r8zOg0OP1Ak1v7CRzSfQq0D8b4Dw+_T0Jui6YTM_KwQQNOA@mail.gmail.com>
Subject: Re: [swap tier discussion] Re: [PATCH v3 2/4] mm/zswap: Implement
 proactive writeback
To: Nhat Pham <nphamcs@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Hao Jia <jiahao.kernel@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, mhocko@kernel.org, 
	tj@kernel.org, mkoutny@suse.com, roman.gushchin@linux.dev, 
	akpm@linux-foundation.org, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>, chrisl@kernel.org, 
	kasong@tencent.com, baoquan.he@linux.dev, joshua.hahnjy@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E9EF7C0007
X-Stat-Signature: ybojrx3cuaqs66km7a7oibn9pqou8hab
X-Rspam-User: 
X-HE-Tag: 1781641633-329310
X-HE-Meta: U2FsdGVkX1+5m3jJsTNDYXC7D3qNlO5uBOJusc8TbamqVPd30GeZRsXOZD27Z/7slRXhPhGsj3JLa/tFwcOCcHRMccDqftcYWaB5RUV6nodRf1TIrFpURtIukdimXofgENqcC+wYNnOGUGmWu6Izs5dVfSJoYyTr3cOl6DYR1jm0/13WeoTblJwrB4Ac8EgXGsPhqRVtc/DEOuEmfKspLnXt/oOZQmf8DjA3Min7iIQrMfsA3eRDrpkvoNKSJENmt4kIgApsLmRKDSQEI2AGSDQ27QD5SCcIeQi2OLwrNMJNCD3bEQvX2NfACRblay7vjoJXhXNQZt6IopcI2V9ZzbYKXPk+7mmo+XMD5NDLG3tScw5zjdWMBrEDprlJyxDmDf7StIbsrGaRJhfPDHjFVN1aqvkzHV7Myw3BzjC6krDhXVA1iklCkk1+jkAG/lwyerh0yDFlHCjOi5kT4uzHFjplf/K+jAY9W1wvKBVbz8zITOc+txwWPlO6tRzBGpF9vMBZHnjOAkXKvoBak2j8DpuqX95AyrePc51+BSWtrbKQNEF1BHoJlS4B2edbYuEWsc283d4pO/ZYUVbgySyhvREEM+Kb8IeXGPcYFBjdFgt+Fb/XQFB6Y81FDI3Kafv6ptA8mCgLcRzCHKxylmzL2dwjfi3G4jb7Uqpgli6ctftSlltNXL/CGObfWMbGCuio7uTGzfIsWi88siL2MOf3eBU3NfTQmPW53OJqsGfDF1PM4UREinbuaRb4LFr83yKqX2HBeA5kCbeqx5UauAU/9CSiog7mSghjXf56q1UxslJNwh9jbtgMK7O7gJsMXJJYmNKm6IBLXV54neNv33PWgPvBROntyFkVAiLgJ9ZhyPGKsXLM4LinVxSyiWfVKSwF7d2q7YModg7LglP3xtT6ITgk9paDbNJx6nOqx9YY8edRhoXVH2opFtudaIU78x+pNXoxXBVOb7Qr0uoOcCC
 gS9PGuJw
 Smiu82GTlP70NxF797X8wZTYWW7W615Eix/383kk0I2z5xb7fPQ1t5yjJa4B3/zSzWJLcfY+4/9qAuz8MXUYJNIc/quYPd4IC0EgcjEghNBHCNwhmZXPh1sVb0IxBei2nqvxLshUcyZm7/8H8e8FDnTK42j6gZMmO2ShBUnZ+k1a+6WUfUW6B97cEZXjNgaAZcAq7XkmHxvd+HuevKROgnI+4YUt3E6GRddavPg8zg1SOEsmDVLA3E4Ctu6Z06LdE9Nk3WNmYlk8AKWHsIavAHC1vzS+aPV5zD18AmRIlSHdKGjL/UHzCSbzw8aru4AbCN26KDwG5xCc/dEI9ldlgDHYm1fz6j+X5iJkg4epcefUhDWpLbyN5f7h9fLyD9O17+PSVKRmSGY/HpOkm0plVN8g11Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 16, 2026 at 1:24=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> wrote=
:
>
> On Tue, Jun 16, 2026 at 4:10=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Tue, Jun 16, 2026 at 1:09=E2=80=AFPM Nhat Pham <nphamcs@gmail.com> w=
rote:
> > >
> > > On Tue, Jun 16, 2026 at 3:54=E2=80=AFPM Yosry Ahmed <yosry@kernel.org=
> wrote:
> > > >
> > > > On Tue, Jun 16, 2026 at 11:33=E2=80=AFAM Nhat Pham <nphamcs@gmail.c=
om> wrote:
> > > > >
> > > > > TBH, without vswap, we should not allow setting zswap as its own =
tier.
> > > > > It's meaningless. Maybe makes it a no-op, and warn users what the=
y're
> > > > > setting is gibberish?
> > > >
> > > > Why? vswap is transparent to the user. Why can't zswap be its own t=
ier?
> > >
> > > Without vswap, if you set zswap as its own tier, which phys swap
> > > device should we allocate from for the backing slot? :)
> >
> > Today we just allocate a swap slot in a swapfile during reclaim,
> > before swapout, and zswap will just writeback to that one. I assume
> > the same will work with swap tiering, except that maybe the way that
> > swap slot will respect the allowed swap tiers?
>
> Yep! So if we set zswap as the only tier, then it wouldn't be able to
> allocate a swap slot in swapfile right?

Ohh I thought you meant we shouldn't allow zswap to be a tier at all,
not the *only* tier.

> Or are you suggesting that if we set zswap as the only tier then we
> can allocate from any swapfile (since we're not doing any IO anyway)?

Hmm, technically having zswap as the only tier should be equivalent to
disabling writeback, but you're right that if zswap is the only tier
than the memcg is not allowed to use swap slots from any swapfile, so
zswap cannot be used. Very good point :)

In this case I think yes, we need vswap to be enabled to allow making
zswap the only tier. That's one gap between zswap being the only tier
and disabling zswap writeback, the former requires vswap while the
latter doesn't.

