Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 536DA10AB83F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 01:51:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 906B96B008A; Thu, 26 Mar 2026 21:51:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DE956B008C; Thu, 26 Mar 2026 21:51:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F40E6B0092; Thu, 26 Mar 2026 21:51:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 691A46B008A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 21:51:01 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 181945DB36
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:51:01 +0000 (UTC)
X-FDA: 84590164722.24.1DDC0F8
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf08.hostedemail.com (Postfix) with ESMTP id 27FAF160006
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 01:50:58 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hXK3pMqS;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774576259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqMSFzWiCTfCzKswaoXydiZLc4q8EHLRdY6HRH3YiOI=;
	b=IoUyuqAy3EDx0WtY+mO/U7K2a+wsr9ZUivKqVmJE3j6m80HejImyZ7OG4Yq6vmn64JR+F3
	NvoN3kIuKGT2txB5RV8Eqc6CiXfRzEuqyI2nBZ8tfNxorQs71qZRkYOjutq7gWgw1i9RXy
	phOEFehL6GCtdilo7DV6nNggioNOnK4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774576259; a=rsa-sha256;
	cv=pass;
	b=GnUqp6nZeoxhdvSmvOZb0o/zeZhX+/njWVeoIW6Liy/41lojR9XUTI4eFVjhy+RyHD2HtG
	s2PFYJKnvefHS91TCkElHPBPlwL39QrjFsqdwKSKXyUwaQAE6WzCpryQVz1S8QMndpqrQK
	edS3t5F3vRsMgyQf/70ID0Fc6GCuVqI=
ARC-Authentication-Results: i=2;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=hXK3pMqS;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf08.hostedemail.com: domain of surenb@google.com designates 209.85.160.180 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-509069a7a7fso282571cf.0
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:50:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774576258; cv=none;
        d=google.com; s=arc-20240605;
        b=SikpdcF1DeytihImL7qhISgEuSQNGbyQk87dtiKPW0DvAhTpwQiCyNUdsxTJ/WgUHH
         ZKjT9bm48FI/JeFQWp/JGdi+MsK+je+IsQ3GkXVYWHoJKHvr0F/09MY+TCGYPZpCIO6R
         6yoCVW/p2rj/uF8dCX2rsQfoYXzUB1Prvs+xgU7AUtUhSVCea8HsLY3ECa1Hg42fqJxK
         FooTpJFVbhP95YLgYR24Qhzs/iZOXlI6JkSqylTjDADzep/J9qFzeYvwHRHkUu/U1oPJ
         JrtkOzygy+pbhD4L4pEjtSnlEFWXZ3+dswMSkC9GSshop5MT6Ti/Ul+Qa5PRqF7jQxbO
         RX4g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BqMSFzWiCTfCzKswaoXydiZLc4q8EHLRdY6HRH3YiOI=;
        fh=ydC5wH+pFBaDPdwLMF6M1eH/T7e/xz/60rlVUtAHSyY=;
        b=gQTUvHkNF3EzpoYE8ZI7VAdyB7faH0fOby9Qy3Tevw2OS2Z0FnPXUmfp0UCfu9USvo
         Q5sAqOd9+yydoxLhnIFzZ0dyuANhmcySRclxmpF3kJmjLzq0+IeKxudOdlU009BfK9fu
         gg+eGqmw0TxYrWtGHlGcNENV5TMFIlf/v9MSEqCzlKQvaepriz40hq7Sq/dkEN2leo1E
         6CjrfNCHGQAOpnBSnR3qmsPtaZ0ZFq7T0MDfb0nPAZEjFQ3glPdH5J5pGKkOd89pucR7
         WrniXujuIrYS8ZVZ+ZNdKycvAGZwVuxUeoTsUJVF4Fva1+Djubzi6NFByXh24eHeOtjL
         XeoQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774576258; x=1775181058; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BqMSFzWiCTfCzKswaoXydiZLc4q8EHLRdY6HRH3YiOI=;
        b=hXK3pMqSLqPVXpKaWJNoDTJV9Prs5lzjMNqOSyKl4dzyr0BhPnPgLrb/v3ZSRLCwaX
         7cmO2a8uhK8zwk2ytoXNY8Nf8GBokHR2mEWcIY51+b7HJkR3FJ/URfZypED/NDjIhzqu
         VdbWURUmYXlgsn7QoQWESQHpJszZeqEWZW+0cM6aFf1BSKtISIF/DkYNb/Gv46Qf90WZ
         r8EFW68PKuq32NFV1e3k+BZavUsxycbf3h75SGnIK5U4ae6KRrIIOo48n6kRwPceS8rB
         ZHNX9eWVIewQcAx0ELFPbR0mA4lg8w45/3SRQTIPOMLJ90HxHnxfJ8/Kypm8R1YCe9O5
         DwZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774576258; x=1775181058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BqMSFzWiCTfCzKswaoXydiZLc4q8EHLRdY6HRH3YiOI=;
        b=rNMQx7Wcw+NAYwEbgXXNRE3FtOXLYwtb4m2IeTZSfVv+TwwN1vMS7xuPzX6VQ5RGfl
         mGA26ZsBichzEw4SgDxXpvywvi/XxtsIZPN+PjHr9n3lxUStCim7mTnGh4SceU9aTxO/
         EzdDBqogFqCt7c/TcnQ3OEGsmcYPXQTpi8h7cAlRiwvE/58IZa9a751Yfq0dbLjrf829
         EkL7RfXp29wXsLDvcOF5l0AX3U9csXzoNWwJks1t29b6zRGeJ0RxSs2Sd0nBZFrfblQ2
         p3bcRZwMRFRsw1fFRZHnt+ReNQY6M2QRQP3oKR7NiQQKWIb0fgzd9QkJjnaJJ9Uqbuy8
         ZI9g==
X-Forwarded-Encrypted: i=1; AJvYcCUEXjkaARWinj8GjhI7xgl7NBmoBVWvyVHTjwTV2R+zdtvWk0K3mjCtCoK1xXB5Y62igCXgeb3J2g==@kvack.org
X-Gm-Message-State: AOJu0YzG3DGVzt86n1RgAPIQh5HJ/KfGcQXEnGHDule1QcCvt8WawFu6
	5pWR7np+FvIdMD/sdGUCum/xDuMxOSPTFZKGpDiYicX0o1tUlXAFaNs1UIvP//ltcscMKcrvvBF
	wm23+t0AhNHRHKE0nCqEkgGnVa6dLoOe0tgzh0pJK
X-Gm-Gg: ATEYQzzc73BgS6OKyH2Rvy9k3mso3gaeayFIFg4aWxLKOJ9s+kx9TSeHpNqfrNYtU7N
	HisC3jKxHmMiR4gOU6dYVME3uO9nvrqzHF6nqCasJJNuGtLWO6DDZENnbgLmTr7CHDy5+pUmHjp
	aXtAJbPyexQuiw90dHUrmGvsyRe27EvbFC0U4z/TfgPFGDfWkGoMffYn3OEGCsJZsJfCNBcM42f
	hPcgDyxxuTeeVc/PvtJi7OQWYdOtB0kIvY9O6r9z1GpF7XT3s+U0ZQkvCCmeXYUjGNFhjvU0QQc
	8lKu7g==
X-Received: by 2002:a05:622a:2449:b0:50b:8d3c:5bd7 with SMTP id
 d75a77b69052e-50ba3262ademr4949921cf.9.1774576257675; Thu, 26 Mar 2026
 18:50:57 -0700 (PDT)
MIME-Version: 1.0
References: <20260326140554.191996-1-hao.ge@linux.dev> <20260326181145.35b559956a45b0efdc9c0450@linux-foundation.org>
 <CAJuCfpHddCffwF6uid_nW8sMAMpJcOiB62BCeGEtoiDYY6rP4g@mail.gmail.com> <20260326183420.bbcbef02b8d2f3dedc4c4980@linux-foundation.org>
In-Reply-To: <20260326183420.bbcbef02b8d2f3dedc4c4980@linux-foundation.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Thu, 26 Mar 2026 18:50:46 -0700
X-Gm-Features: AQROBzCP8BlRhhoQzajGaOj3_f-ZeZTnp7vIy22wo3F4-gydOIQVnTZe_yyrMlA
Message-ID: <CAJuCfpFLM4G5XtdRgXDbB24x3XqP1BCtbfafy0HeOvRcyvgPWA@mail.gmail.com>
Subject: Re: [PATCH v2] mm/alloc_tag: clear codetag for pages allocated before
 page_ext initialization
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Ge <hao.ge@linux.dev>, Kent Overstreet <kent.overstreet@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: hoytif3i8zdt9chwarxuwq47x8rstogc
X-Rspamd-Queue-Id: 27FAF160006
X-Rspam-User: 
X-HE-Tag: 1774576258-21522
X-HE-Meta: U2FsdGVkX19mMotkEYLD7ZN7xH9ZIVD9FzgOfedhMVlFYkStULpXT2ldw9dxs7qvO95b3vvpdpHubCnySfn1l2GLzBE8JKE2TSSAT6McVea5A7ZshH9eBcoxP0rxE0Xj79tyBDVwvRIOrJ402Dm7D25vynPZ/IewxpEeaK6LC+5f6H3DFPIoShUv4GxaCIgvl7yn6oMZYmt3HXCBEn0+0j7dG+s4R4MUFB0KX5FV/ZOl80/uC3RPG8s5z57NylTGo4gqDWp8NChS/40vFovclb8RpCMiOoA6YcWWnJJAXJEQYc69gznjTIDOOWsyeBBYfmmtgzOVq007ALvjC4Hb034TSUL+i4kUQISP7cJ0NkjUmknndOaSPLPbPQezZH4Z0SoUgPwGrUmTd2/H+3XN4O73vekYoAOSTahi6Xa7bmaTVCVRuF91tmarHaHe6CRl6qJwBxFcBpkVXJy9anmCdFKby908QhXQ/AZGiimnvUeWXNwwxsLdhcN6/2vuNod2iancWjL0M+l8vOitut5bcKB9wwlhzo8UuyJUSlD3uCPSbC39Z0+g/joIKFU5jSA9VbgAGlhOCog/sr/x0uEY5+DiWnLGXyXomDX68wpJ+12HBActwxDINGH/vNM1OUTlSKQq4cRMBYCeRlb7A6Z+IYU8hxvlFZoONGQaWcAF9Tuyx/9VgfVYI6OBO81HyfIOCfq69ZNgOwDEsG28YbASdzE8FoL21Gh7zCjlIwg3zkakR63jYjPP5bYS5zZBvq7kWgxNdJu57jk8WinlnYJK2j2Sq0CaZ8aAq4hBXYWyUagxSESVOW45Sd7DrCe63ldo2IdKJKXU0XsJZbMSYESj0w9U2C+/kb/STwJXvHOvGtnyDS+5Ou5dJFhSQPSfDvX0sA/3Ob4h+5eRrLA0qNF9ufoboY3PRKc8sQ6rsvTCJhQIYDOPRbsVVIeOkAz/99WvAmnIIrZSgTvla372VFh
 JpHU2Kb0
 AGB/BhWH2QQTiOMAKeBNKMuhbeVREEhBOEv8dMq1PqZLkCHF2tuuYLWAmP/46rSzDSdKP/xNYPcipQqizGAym3hY+OySWsuAnZDIqdtkogO3HPq02sctsrgmkrnhDcql7CeEFXOpp8GIFWSsak8Hf9grcdsAGDbxVyGB9j2fEZcEX7VlU/kFrlDRENgZe9gwDT6M6N3fNA6eRKd/oSzcJv8TGXSjiNWuABm3S7Gg91fxQPrgxNiecjk5vJcYOOo1vTXVvNaiBH+E7HGVpIWbRetkFdy6SFX2JerMQ17VB+naWJM5L2jxhp3Nn+B0EJ44bbLHIuvpQ+wPrkFjPbxHCFKKqLHoQI8OFGyQZv2S5VtswhofZHkzZClkAVWQlsoCjasU3PJwcxt8nVqaPgK5xQyC4wNQZtvbHRHzX4pk6FZR02FshYb5GkDpbhy6SNWvtyzqi/QG38ukOs3js1OpGrfR4cpVIDosQQItwQ7IFHNSac24rEH1WAhH2J/TUCiXd1XLn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 26, 2026 at 6:34=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Thu, 26 Mar 2026 18:19:56 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > >
> > > Do people use CONFIG_MEM_ALLOC_PROFILING_DEBUG much?  Is a backport
> > > really needed?
> >
> > IMO backport would be good.
>
> OK, thanks, I'll slap a cc:stable on it and keep it in the 7.1.rc1 queue.
>
> I added
>
> "This bug occurs when CONFIG_MEM_ALLOC_PROFILING_DEBUG=3Dy."
>
> somewhere in the changelog but that's pretty lame and could be expanded
> upon in a respin.
>
> > >
> > > Either way, it seems that this isn't a very urgent issue so I'm
> > > inclined to add it to the 7.1-rc1 pile, perhaps with a cc:stable.
> > >
> > > Please all share your thoughts with me, thanks.
> >
> > I'm reviewing and testing the patch and there is a race and a couple
> > of smaller issues. I'll post a reply later today.
>
> Cool.  I was going to keep it in there for mm-new testing (which is
> light).  But I guess there isn't much value in this so I'll drop v2.
>
> Sashiko had a bunch of nags, but I think you're checking that routinely?
> https://sashiko.dev/#/patchset/20260326140554.191996-1-hao.ge%40linux.dev

Yep. Plus I finally got Sashiko to run on my local machine, so I will
give it a spin on my fixes before posting my reply.

