Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8168DCCA462
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 22:06:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 965346B0098; Thu, 15 Oct 2026 18:06:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8F7696B0099; Thu, 15 Oct 2026 18:06:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B6766B009B; Thu, 15 Oct 2026 18:06:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4B7736B0098
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 18:06:27 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7590E401E0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:06:26 +0000 (UTC)
X-FDA: 85326245172.15.99D35F9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 7304EC000C
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:06:24 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="itmch/aA";
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792101984;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mJbsb6dU/XznSRrcG1GSuxTRuvW4/61fnYkUcg+ByiM=;
	b=XwNySVF6WjZ8X8wqUzBIGYipcvJKMopOsEjc8zQiDdmSib1ucMurNHnwlZ36e8otucppn/
	tPTYGgrv9+FBQvECq5uBRiNpB5lDbzrqaXsy6SBUWb+aslHTzMRs2u/I2CEkFlJoHtGm8K
	fMAe6C+y7qmOzrXNXDHNCGb+wEs9MlY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="itmch/aA";
	spf=pass (imf10.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792101984;
	b=ReWV0D6MnXvFUKv0L9KklXOucqTr/DWLCRMJB0OPhK29Lg2UVB5B+pPN6s7eTazAxyjig+
	SbhXN8zD0x05b1S0Iw8TDKdEIbQNstjgQFk5aCBXXjQ9wb3ec1ecZQ4rj5OEmyZmhhht3l
	/Q8IqTsNJtjsBe6TtBAoUgpUdueS1+8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0108243455
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:06:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC4F1F000D0
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 22:06:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792101982;
	bh=mJbsb6dU/XznSRrcG1GSuxTRuvW4/61fnYkUcg+ByiM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=itmch/aArHNeBR/ur+BnCI+m882cF1KxHAM9x0OT8uMYRvdLvVM1x0/qIeS151x5L
	 Fyoo6cz7VRpbhDZKe915EUj0SEQmP9ybIJeRc0PFePcvDsOkr9Vp4CPO3d1xGYscXF
	 dbfazzin059JqRPz3VadX8oAMj3XjSxudqglgs1/2e6P8WvVvJUi1DsKmNkiwdEjty
	 NEouf7vKm/ktaNHDjyjQ3SOVQcRcHQ8iW/KPBaddWhbyemcvbzDeVFV419KEhJ1KeS
	 M8ntuHWI6hkqyNPOCcAOVXFVhrJO4TJWxjMZt75aEm0U7ve0+2/aJE4ClWgWI3zSip
	 MKTC1HRN8MPYQ==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c2055573c8cso749198666b.3
        for <linux-mm@kvack.org>; Thu, 15 Oct 2026 15:06:22 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBwJU6mseuTf5hdm5AQ9+Ufr/gaXAW/LWD0AfpwP4vTSzWaTaYxcgbGvC5/K/VU6saOSU64hZB9bdw==@kvack.org
X-Gm-Message-State: AFq9FYJbyicekEGEM7lDpo2pVYhu54zjvfhVvgfsLrHfnWJ1tPZIJSJR
	ITgio8xqA/BpoCuCB0mdUFI8cA2BRjl/XNYDsLsnnBuoeU5XozfMPBEMLkwm/4NmCkH0MGk8qkB
	M0+LLygjJ+AR1laQyzuIWD0aJUDDHFfI=
X-Received: by 2002:a17:907:8692:b0:c2e:2720:8f68 with SMTP id
 a640c23a62f3a-c31aa01b41fmr1817223366b.46.1792101981739; Thu, 15 Oct 2026
 15:06:21 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com>
 <20261008182814.27450-8-kanchanapsridhar2026@gmail.com> <as-izeIj5bP01bna@google.com>
 <CACpmpof++tM9MUYgqgenwEBfaaJ60VsDwptK7Ne_-b+-DKMRZg@mail.gmail.com>
In-Reply-To: <CACpmpof++tM9MUYgqgenwEBfaaJ60VsDwptK7Ne_-b+-DKMRZg@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 15 Oct 2026 15:06:09 -0700
X-Gmail-Original-Message-ID: <CAO9r8zPpmLyMHF+yDb2ZHRmSdAHFTNvsu8PZsQ2Z-EVvF-dc3g@mail.gmail.com>
X-Gm-Features: AclHuK-S4zsk6EqmhjsVui6ifjRKos1ouVvuuztrm3peIKBuRi4LD8-5u9AW2Mg
Message-ID: <CAO9r8zPpmLyMHF+yDb2ZHRmSdAHFTNvsu8PZsQ2Z-EVvF-dc3g@mail.gmail.com>
Subject: Re: [PATCH v1 7/8] mm: zswap: Optimally place members of struct
 zswap_pool, struct zswap_entry.
To: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 7304EC000C
X-Stat-Signature: 886u76juwg1x1bc75fr89rjsxb1texoy
X-HE-Tag: 1792101984-37819
X-HE-Meta: U2FsdGVkX18FZ2fenyK6aZoFgZZu45KssBhRxpaJ+mwYKNx8G8/NZw0MPbasTxBLz/zSAwiCwcIXzdfPnhd9GLCYDXgXVFTXsbpRQjhRpkDsr5uJDYOJXnHUgPWhmBkIhdND3reKapq3HzE7ulz6Cf7JMuAB6sg4jDxT6/o4yiYJx0cFQOscZiqfUnp6UWw2toatO4Rin/+UKdN/m9C0W3D+/6u3rBA2eQb3JHsIb8fgnNHa4I0jHYKW4Qm5PStHOfAHxOkiLiKFrxkBycmcaEBBxZWF6XqKm00pTBxjTvjaiENkcT2SDrkyCSo0Cj8zq2CYgVKfuWcFBxafYl9rk9RWnE/kWUiUV241iFmKKkWfTfv+3mynd3aaHFi7Lh0Vx3cFQJZtq9zjeDcx4nTQpcvVcDnfBWOHVnLAWql1yW7fEqBarj7sG4arkEH3y7oR5qaWo5uZxNEQlUIUXSUjQ7aYJ8MnCSFa46SeMU01ypNZkR2F2LOe9D4mMm6q3reLeGsmzZYRoCqUYTBj5XcyiQHR57C3glo+nSLNx3lGq4yiDmK03MEESmzZ3FqWRaGKn42CTO0ZwoMpsOm4NDrLpNdOv0eOC94HY5CMKgctY2/DliU9OMYPpxaJ6GWWpAaxumH33IdoxYrs6aH1I0h9ihmHxI4Usqk9ljFFMcY4RAOX8JPUMN0P8wSl9tjs7XMIJhOzsnIrlL76ZthYiIhcVZQgWRs94ESYsc5Tg7KI4WS0zlg4Au1e7rFbgTVEjaY4u7fFTOF6jueiLPx8TmDVOSsUhqTlBJ01YoxK7sEx3U2GZUgVvgip9UCljgUkxAVyktM6UDioriBp1Pg5OYbsXif4LpfOI43Btb60B4lFryhVY8xkZPRfj9di9D/xWId1Jp5/0/O6FVgMbv3Y+2vzkLl0Rg6WBdAdiFM3vfP2Q6n6FCUWf9VAWA94yMdFPTJHP4ZA6bzHCI1HzSJPv+c
 772/B2tr
 GgnA25eRS+FXygK/nViqMQRmeEF8Z6iMSLm53juJHR/cPKgr3G/6F8yJ9hS4gHSj2p4MDjnE7MzlLrL2DyZxUV+PjIAR80RwfeHDsowuK3P65gKLPN86H0OLZXvBERKTyQ+daDQojf+YtLIw4uqOFnQfUbX8+nwVLIWrC1BcuWx4qjTZ/Go0r/h/Vw/fZnHnxMdOg66k6oC+BtJEHOw6TjCOfRgkTO+I7uUkf8gDuOap6tWZJgi69V6vk9Le+X8nsMgM0J5HkK6mAmbg3CqrOc3Rs87p5jJodTrs8OarSstsdJPFCQJvoTYa9i9ldRZxP7rINpY2EJOnsyhbPpMY74FLSQ/N+rYBIeWc+PULk65IZtYGP6ZPow+o2Kv3WJc8hyNLp
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 2:49=E2=80=AFPM Kanchana P. Sridhar
<kanchanapsridhar2026@gmail.com> wrote:
>
> On Wed, Oct 14, 2026 at 8:43=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wr=
ote:
> >
> > On Thu, Oct 08, 2026 at 11:28:13AM -0700, Kanchana P. Sridhar wrote:
> > > Place and align the members of struct zswap_pool and struct zswap_ent=
ry
> > > such that members used together in compress/decompress hot paths are
> > > able to share the same cacheline. Minimize holes within these structs
> > > while doing so.
> > >
> > > Signed-off-by: Kanchana P. Sridhar <kanchanapsridhar2026@gmail.com>
> > > ---
> > >  mm/zswap.c | 10 +++++-----
> > >  1 file changed, 5 insertions(+), 5 deletions(-)
> > >
> > > diff --git a/mm/zswap.c b/mm/zswap.c
> > > index 8ae67fd10522..ade84ac4076e 100644
> > > --- a/mm/zswap.c
> > > +++ b/mm/zswap.c
> > > @@ -160,11 +160,11 @@ struct crypto_acomp_ctx {
> > >  struct zswap_pool {
> > >       struct zs_pool *zs_pool;
> > >       struct crypto_acomp_ctx __percpu *acomp_ctx;
> > > -     u8 compr_batch_size;
> > >       struct percpu_ref ref;
> > > -     struct rcu_work release_rwork;
> > > -     struct hlist_node node;
> > >       u8 idx;
> > > +     u8 compr_batch_size;
> > > +     struct hlist_node node;
> > > +     struct rcu_work release_rwork;
> >
> > compr_batch_size is added by this series, why not just add it before id=
x
> > to begin with?
>
> In patch 0006, where compr_batch_size is introduced, I was attempting
> to place it in the same cacheline as the acomp_ctx. This increased the
> size of struct zswap_pool to 248 bytes. I later optimized this in
> patch 0007, bringing back the size to 240 with the addition of
> compr_batch_size.

This doesn't make much sense, and the size of zswap_pool is not that
important (usually only one globally). I would drop the patch and add
compr_batch_size directly where it needs to end up.

