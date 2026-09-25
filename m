Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD540C98318
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 01:24:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2EDC6B0088; Thu, 24 Sep 2026 21:24:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BB8836B008A; Thu, 24 Sep 2026 21:24:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A80A66B008C; Thu, 24 Sep 2026 21:24:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7A4FD6B0088
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 21:24:52 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 0A9E080491
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:24:52 +0000 (UTC)
X-FDA: 85250540424.26.BF16DFF
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf19.hostedemail.com (Postfix) with ESMTP id 622531A0003
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:24:49 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="KQV7Ee 7";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790299489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+QJhA9zddl3SAwvYptEXzT6UeU8NIqwXH98v6Wc6pJI=;
	b=rPD/a4ekMkrDwM77W1vKMr/VYSkYc6S15VyQhm3yk5ZjGgt5HGcZjfLYOBeDZtQNkm4fVy
	BTUFznUzeWid+NJRAC5nKWDm3XYr7pOpej+9FQ3NPh+C53c0Cl9BaIPFCJNEy+rzvEsQFC
	WtP+Kr46cUihu/61cVqOczzDtdJN5eI=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b="KQV7Ee 7";
	dmarc=pass (policy=quarantine) header.from=surriel.com;
	spf=pass (imf19.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790299489;
	b=SkM7AruippVkSMTiMoTD6KxbDQHNcbuLs+nh4GeU0N1N7rkKROYxoiibCNdnKNCJGPEO0L
	81naQIZ8IXkxca0/jq7AGQ/BQZQCHMp7HqlvrZxQJXTh/YjSTrBGKl7BD3Jm7P/A2x59FZ
	xySakb9uKKXRs0ut0UZpjLuQiO7f8GE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID; bh=+QJhA9zddl3SAwvYptEXzT6UeU8NIqwXH98v6Wc6pJI=; b=KQV7Ee
	7t4+XAuk0sJ44jy3lpdCzNfmWKKj0qS8voqY66n2cj9tDXdlyk4eF0mrKIjaQmaDqpo5tLMXwIz62
	u12mbSS5h3qOLLW4uIu9214aO4z5bG+WkrVpolUmyxWBphu7M79V7g5dYGuLNxuCg4gPTgxEUpJnX
	Uri96RESR3bCk0lHHC6dGT0n9Ay3RvoY4b6BuAOroOUZDwbb0hoDiA2O3kXwXz5aEq/6aQqSdpSiW
	hPP52M7cfnDYfrBpPMjf6D9f0BG3nH16V9MU5AXzGIw9cf0ec6caCiZahPN20Q/Ud71BPecafCSPv
	gDVWxEp0O/Tu+GzkRerK10oswhUg==;
Received: from [2601:18c:8100:a0e0:5a47:caff:fe78:8708]
	by shelob.surriel.com with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
	(Exim 4.99.5)
	(envelope-from <riel@surriel.com>)
	id 1x9ufC-0000000577C-3RjT;
	Fri, 25 Sep 2026 01:23:46 +0000
Message-ID: <a30eb60221cda2fe726a86c2c6f859f71fc7a46d.camel@surriel.com>
Subject: Re: [PATCH v5 01/11] mm, swap: add virtual swap device
 infrastructure
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>
Cc: Nhat Pham <nphamcs@gmail.com>, akpm@linux-foundation.org, 
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	roman.gushchin@linux.dev, shakeel.butt@linux.dev, yosry@kernel.org, 
	david@kernel.org, muchun.song@linux.dev, shikemeng@huaweicloud.com, 
	baoquan.he@linux.dev, baohua@kernel.org, youngjun.park@lge.com, 
	chengming.zhou@linux.dev, ljs@kernel.org, liam@infradead.org,
 vbabka@kernel.org, 	rppt@kernel.org, surenb@google.com, qi.zheng@linux.dev,
 axelrasmussen@google.com, 	yuanchu@google.com, weixugc@google.com,
 gourry@gourry.net, haowenchao22@gmail.com, 	corbet@lwn.net,
 hughd@google.com, baolin.wang@linux.alibaba.com, tj@kernel.org, 
	mkoutny@suse.com, skhan@linuxfoundation.org, kunwu.chan@linux.dev, 
	kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, cgroups@vger.kernel.org
Date: Thu, 24 Sep 2026 21:23:46 -0400
In-Reply-To: <CACePvbV-tazW=LmsbUtAhHzR2d6JwFT5R1jYZ9_NTp1hxXH=bw@mail.gmail.com>
References: <20260918180241.3424851-1-nphamcs@gmail.com>
	 <20260918180241.3424851-2-nphamcs@gmail.com>
	 <CACePvbVaDNspMDSw_qAcapKAzXj3JGV-KMYmow7aePa0POHpSg@mail.gmail.com>
	 <7571f005bca65aa4ad5e7ec89e62801ad058b689.camel@surriel.com>
	 <CACePvbV-tazW=LmsbUtAhHzR2d6JwFT5R1jYZ9_NTp1hxXH=bw@mail.gmail.com>
Autocrypt: addr=riel@surriel.com; prefer-encrypt=mutual;
 keydata=mQENBFIt3aUBCADCK0LicyCYyMa0E1lodCDUBf6G+6C5UXKG1jEYwQu49cc/gUBTTk33A
 eo2hjn4JinVaPF3zfZprnKMEGGv4dHvEOCPWiNhlz5RtqH3SKJllq2dpeMS9RqbMvDA36rlJIIo47
 Z/nl6IA8MDhSqyqdnTY8z7LnQHqq16jAqwo7Ll9qALXz4yG1ZdSCmo80VPetBZZPw7WMjo+1hByv/
 lvdFnLfiQ52tayuuC1r9x2qZ/SYWd2M4p/f5CLmvG9UcnkbYFsKWz8bwOBWKg1PQcaYHLx06sHGdY
 dIDaeVvkIfMFwAprSo5EFU+aes2VB2ZjugOTbkkW2aPSWTRsBhPHhV6dABEBAAG0HlJpayB2YW4gU
 mllbCA8cmllbEByZWRoYXQuY29tPokBHwQwAQIACQUCW5LcVgIdIAAKCRDOed6ShMTeg05SB/986o
 gEgdq4byrtaBQKFg5LWfd8e+h+QzLOg/T8mSS3dJzFXe5JBOfvYg7Bj47xXi9I5sM+I9Lu9+1XVb/
 r2rGJrU1DwA09TnmyFtK76bgMF0sBEh1ECILYNQTEIemzNFwOWLZZlEhZFRJsZyX+mtEp/WQIygHV
 WjwuP69VJw+fPQvLOGn4j8W9QXuvhha7u1QJ7mYx4dLGHrZlHdwDsqpvWsW+3rsIqs1BBe5/Itz9o
 6y9gLNtQzwmSDioV8KhF85VmYInslhv5tUtMEppfdTLyX4SUKh8ftNIVmH9mXyRCZclSoa6IMd635
 Jq1Pj2/Lp64tOzSvN5Y9zaiCc5FucXtB9SaWsgdmFuIFJpZWwgPHJpZWxAc3VycmllbC5jb20+iQE
 +BBMBAgAoBQJSLd2lAhsjBQkSzAMABgsJCAcDAgYVCAIJCgsEFgIDAQIeAQIXgAAKCRDOed6ShMTe
 g4PpB/0ZivKYFt0LaB22ssWUrBoeNWCP1NY/lkq2QbPhR3agLB7ZXI97PF2z/5QD9Fuy/FD/jddPx
 KRTvFCtHcEzTOcFjBmf52uqgt3U40H9GM++0IM0yHusd9EzlaWsbp09vsAV2DwdqS69x9RPbvE/Ne
 fO5subhocH76okcF/aQiQ+oj2j6LJZGBJBVigOHg+4zyzdDgKM+jp0bvDI51KQ4XfxV593OhvkS3z
 3FPx0CE7l62WhWrieHyBblqvkTYgJ6dq4bsYpqxxGJOkQ47WpEUx6onH+rImWmPJbSYGhwBzTo0Mm
 G1Nb1qGPG+mTrSmJjDRxrwf1zjmYqQreWVSFEt26tBpSaWsgdmFuIFJpZWwgPHJpZWxAZmIuY29tP
 okBPgQTAQIAKAUCW5LbiAIbIwUJEswDAAYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQznneko
 TE3oOUEQgAsrGxjTC1bGtZyuvyQPcXclap11Ogib6rQywGYu6/Mnkbd6hbyY3wpdyQii/cas2S44N
 cQj8HkGv91JLVE24/Wt0gITPCH3rLVJJDGQxprHTVDs1t1RAbsbp0XTksZPCNWDGYIBo2aHDwErhI
 omYQ0Xluo1WBtH/UmHgirHvclsou1Ks9jyTxiPyUKRfae7GNOFiX99+ZlB27P3t8CjtSO831Ij0Ip
 QrfooZ21YVlUKw0Wy6Ll8EyefyrEYSh8KTm8dQj4O7xxvdg865TLeLpho5PwDRF+/mR3qi8CdGbkE
 c4pYZQO8UDXUN4S+pe0aTeTqlYw8rRHWF9TnvtpcNzZw==
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.60.2 (3.60.2-1.fc44) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 622531A0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 3bbybjqnzepn8g9b573fu65fhyrajt9t
X-HE-Tag: 1790299489-839359
X-HE-Meta: U2FsdGVkX1+sa7DK80y9Sbrhq+DpKBHc9/pVns6OCQENuWkuT4z41XuNI0eM8B9FluvDxmDWHsYTtFboBnpJozOOwzu30UttioOjgb/1aTyPvStj6Crd4USzqDK5vX3G0PSs/eAqYDd80shM1HSYmx/eX734omHBnKTgBqiPnp1zCbRtvbgpzDKK/TqrXcduQqhYaSX9+EYCXBXSNdXtbreioVjvr5yM1A+ai+c1o5lfH0Omvw+IHMsRep7/ouVwPMbKErkINKHUnrFuVYjGqdJIdewrQ5L/2bCucLG/1TcEYxRgf9hm9s0lOXj8gUIUDDyCTCJeGIJh/isNo452tFzImhJqFabLyQdvqAYsoisNKJtY3ZbQDWnIkgOnwGbzqM0g8w6L4lNBFIaw+ot87Er5zEJEviGom4iEoTSNhKTbx8A/3idxDfyq6Jn89ARR5uXPmKSb0Ejjd33pt495/yZ87fWUdAKmigfgtpEOTk2MbtgZVR2U7Ziq8ICnZ3bp3O7Z1KK1F6VNZNMIeAkc8P7pk+CsvWIDlppv3/CPowurMPZkV+yT9gTidWjyicWAhyuDYJITzoUADwtks3bd9J5xI12sJEnTi4mYxwHOT4Gx1ARoSqn47EoLgyA87clqE6OXuq6fv7vU8wEP5xGFVBZ9BxOPa26Ehu+A3gYSMMALMHVHrYm6ur5eMSpivpzH0AiseJBnWCqA3f4BHci01mIM5pY+YgiDapW/I1+waYSI+DktciveqOcoPzRbgCUXSHywdsyD2kihkftysuDniY5GOGFHw0f0Vn6CY56XgMrgEYRXyMUWhD/hlgjEL9uEoz2R5aaHiBOtv6Xk97MHhGQSdERHb8BL+UYGcGc9YLuiVhh7etv7K1BSut8I27pvPc2rLe3P/mku29NYgKGDp41MUcv6oC3wIVWf05DyxM0jaPr6/olOTHBLkjJlVtaXqnExJurkpLW74iq8Yzb
 Uj53H6BD
 P6UBs5XJkPKvTZPTHH1enH3b7Uf4iT+Yd4G95rzApP+oIHMZAx0Cj8jJS7OV19iAz2arcpBGLtHfHobjl8ie4AmRD0NpNPA2TGdkPEOCLbnpGV4e9NngGjt7dwPhZqKa29GmySMFy3F620sB/LPSvJjxUT3KQUeu01TlMrTjFzOqgScrbsAWgeEVNZWIl8fci938t6VeLp8W4rcakuKi5SpbounhFP+nLJHLN3c+k/QjgrcUHorSeHAAZKqJQLiSZ+Tl3pLGsiW0Pg5WO1j4w0YBymsD7u45HI2TxRLSVawJKsQRztzpN5JxGGeZXxSkSSxLBuEhaf+15Tk+Wb4npaQFzIAUcxdGTI307LgK7Nq+7ep4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2026-09-24 at 15:17 -1000, Chris Li wrote:
> On Thu, Sep 24, 2026 at 8:13=E2=80=AFAM Rik van Riel <riel@surriel.com>
> wrote:
> >=20
> > On Tue, 2026-09-22 at 23:18 -1000, Chris Li wrote:
> > > On Fri, Sep 18, 2026 at 1:03=E2=80=AFPM Nhat Pham <nphamcs@gmail.com>
> > > wrote:
> > > >=20
> > > >=20
> > > > @@ -482,6 +491,11 @@ void swap_read_folio(struct swap_io_ctx
> > > > *ctx,
> > > > struct folio *folio)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (zswap_load(folio) !=
=3D -ENOENT)
> > > > =C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0 goto finish;
> > > >=20
> > > > +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if (unlikely(swap_is_vswap(si=
s))) {
> > >=20
> > > There are too many swap_is_vswap() in this series. It fragments
> > > the
> > > code path, making things harder to reason about. Esepcially
> > > around
> > > locks. I count 22 in this patch alone.
> > >=20
> > > I consider this the biggest drawback of this series. This
> > > fragmentation of the code path.
> >=20
> > Could we avoid that by simply always having everything
> > go through the vswap abstraction layer?
>=20
> Yes, but it will pay the price for going through the unnecessary
> redirection layer always. It incurs performance and meta data
> overhead. That was one of my previous objections to the earlier vswap
> version. Sorry I enjoy micro optimization too much, that is both my
> strength and weakness.

We really only have two cases here, don't we?

Either the data is in the swap cache, and
the vswap layer can directly look up the
swap cache page.

Or the data is in some slower back-end,
and doing a second lookup is not going to
introduce noticeable overhead.

If the micro optimization come at the cost
of less flexibility, and harder to maintain
code, are they really worth it?

>=20
> > Handling the details of what's behind the vswap would
> > be handled one layer down.
> >=20
> > Chris, do you think that would be cleaner?
>=20
> If it can wrap below the swap_ops, it is just priviate inernal dedail
> of implementing its own indirections. That would be much cleaner.
> That
> is what I am trying to pitch to Nhat in prevoius email but does not
> have following actions.
>=20
Can you sketch out the details of what you
think that should look like?

What would the data structures look like?

What operations should there be at the
abstraction layer, and at the swap layers
below?

How should migration of data from one swap
backend to another be handled?

At this point the best way to make progress
would be to hash out those details.

If you are unhappy with what you have seen
from others, what does your ideal design
look like?

--=20
All Rights Reversed.

