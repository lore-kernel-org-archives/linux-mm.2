Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B169D116E3
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 02:40:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F5486B000E; Wed, 26 Nov 2025 21:40:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC5E6B0010; Wed, 26 Nov 2025 21:40:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E2586B0022; Wed, 26 Nov 2025 21:40:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 47FF86B000E
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:40:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0D9FDBB9B0
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:40:50 +0000 (UTC)
X-FDA: 84154834260.02.7D61C07
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf29.hostedemail.com (Postfix) with ESMTP id 5F14612000D
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:40:48 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Htknuk3x;
	spf=pass (imf29.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764211248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zySDNhZhEUrvvU9fuLi2ZDzsJJDwlWwhZlzsoMf9P7E=;
	b=Kfrv0+R3/Ens0TBTz9FB5NcmVoqIik9aV4nYVSRY/j9Hx2FJvsNRPWEH5aGRl/jsW4W71k
	W5tKEfr6PdRZ9lYgrVw1zJt5vsj/2YC+gkCqTwhXUcGtuuL88fQa5Y0b9+jTL6EfB0al5M
	JMVbwEyOFeiVgHzvlNAVgbQKJ+iM2wc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764211248; a=rsa-sha256;
	cv=none;
	b=JQTXHRldwWjOvhmB2O/ZwdDdgTRZfMC/8/anfJnteHcpdhOqstwQRxi16y1Qx9OWz+BA7J
	2Ayer/sCC3Qy3gR4qQ3Uf1ix69Wo10YvpoYGPR+OwTvOquSdQ0o2q3gcbCXQcUeCSGXio8
	E2v8lF9W56dT6EiGkdSJ9sWVSKUxA6w=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=Htknuk3x;
	spf=pass (imf29.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=zySDNhZhEUrvvU9fuLi2ZDzsJJDwlWwhZlzsoMf9P7E=; b=Htknuk3xfI0Xg7jAMB5TKCeWwS
	jrAVSEnRQTjIvtEDrZC7bSRARc/5zdA1yQXJf9saodz85fGdYxJt6nvVc/VJEY7+SlH7izRyPIp/U
	GzENtRngYheNQvxV9ocw9qDezjFAQrhuowDgBT+gLJ1/l7tJrHnrIp/WWvUGt8WB018+iDYaMFMF1
	VMvrtmmNJjuMs1FNOBJYpkigv41T7sScMhMUAxL8hJZ5jkRgz5xrKd6wBUjNZAOGUXWkjpu2VOOHD
	6xTPHZ6Muccj8ngj/n16BOAwTqXmUWw7YjNV4+OFes7s66B2RUoOTkEuROb6p4Hw1Qyl0ORxBEs77
	Y+6czb0w==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vORpo-000000004yE-3Cjm;
	Wed, 26 Nov 2025 21:34:17 -0500
Message-ID: <56507d9b9210ef5f67715b81efd96fd809021a44.camel@surriel.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>
Cc: Yosry Ahmed <yosry.ahmed@linux.dev>, Johannes Weiner
 <hannes@cmpxchg.org>,  Andrew Morton <akpm@linux-foundation.org>, Kairui
 Song <kasong@tencent.com>, Kemeng Shi	 <shikemeng@huaweicloud.com>, Nhat
 Pham <nphamcs@gmail.com>, Baoquan He	 <bhe@redhat.com>, Barry Song
 <baohua@kernel.org>, Chengming Zhou	 <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, 	pratmal@google.com,
 sweettea@google.com, gthelen@google.com, weixugc@google.com
Date: Wed, 26 Nov 2025 21:34:17 -0500
In-Reply-To: <CACePvbUCeEu3dkq-M5fL-k-bca2c_h8A4HTCmLvRaV1aFW5qnw@mail.gmail.com>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
	 <20251121114011.GA71307@cmpxchg.org>
	 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
	 <20251124172717.GA476776@cmpxchg.org>
	 <2a8fd7bd35939b9aa4a7267c93e1fda995137966@linux.dev>
	 <CACePvbUB8wjEH1rsaRs+LwX4RKGrjLFSGzjhgrdS3e7Lcz6BeQ@mail.gmail.com>
	 <3e90ccb0a3fd20e9b2d6e2cf19db9590394f7edc.camel@surriel.com>
	 <CACePvbUCeEu3dkq-M5fL-k-bca2c_h8A4HTCmLvRaV1aFW5qnw@mail.gmail.com>
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
User-Agent: Evolution 3.54.3 (3.54.3-2.fc41) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 5F14612000D
X-Rspamd-Server: rspam06
X-Rspam-User: 
X-Stat-Signature: zjrdq7w3bahwnhaq6bfg65qcymricnhf
X-HE-Tag: 1764211248-81171
X-HE-Meta: U2FsdGVkX19Mr1ipIY2ByXqRMz88uLH1IkBCqcciWrdmswUUtifk/S0Hy4iBl9fyD2ndLHUC6DO8TfJyN7U3ypa+XJjOAGiiaakk0o0POZeu7lyddckhEAU2lVwmBVJL1i7PxZMQZ3y/P5U+5Gw5rU8cmUZ5EThYkeUdjTMYronGvEpZYs47j3q0WBwuC4gBu9z/hG86eTgiyQzZa5NM44b+hNfRmzdKrXBMhQae3PjdmapG4IMo3Jqjco7eIL7UEOmV4pdsB0g3BZi7oNwFtt87XIej5crYoz3VDgZFV8uzhcwO0QiPG6AAj1psqCV/o28qHgpJmjNd5se3T4Io4gnbDVZIVYSExtrQneUJuvfddg+wUlrFhGbIvmOQ0H9E/JQj3EkppATbwb7E1sUI65GYSjbBt5zmY6730gI1CmTH7L12KfvurLq0ICJ0Pr+XOkswf+nCrRSf1n2MJMa0GOCRMzv4lrS7X6oClofOoXQtUSY0OZwu4/7pUrVSBfPHAG47BrFXvGBEUuFarf44c8kibbVGO22+G/q9sPzUZKKmexxnGuXWIAqgOZN+evsaIhokt/Xu2ObTq+aoyXbDUjmL/MrN2+jPQDRs2t1V2iNsw2ZenrbrSUOQb2z/7kVppZZ4h63cJEW8r5R9F3LTXvrouWumFoH2heqLpKFUURt3Tsle5DER2oHcEnW8TDHilXYvwJYblNhByhR8jPu+4lc0503w8MpgKFxQfnvlEdv+Ia8mgfSlbvlCmMwWrGH0j8hlhksw9VKcVhhMIQ6V40VjSwjksXabtKCdLRRbu+a5hjDMx4oJ0fQH/d+ZJkPceDmSbjNJDQINV1c8WWReLTtpAw/QIX/abRIu7MGqiYKHsN6qEVVoGmZGc0HHXgoFz5rOnJcZUvx/Mpt9/jdDVw1DKKg4cRihhzzMUkSf+1IyKG3XoZTRgWDxtJxAgM9YlrakLyB5qwocjt9VVd3
 Eq+gc2xe
 ci17sZzBQcU3fCYwhd/ET85k6xAV32I7scSoBFYZVI0bRIgV+KQD3hUgoASgs3DzTPwpXzajxfgbppw3j1lv/SLAxw9N7H0jaX7mkEg3J2i0AIgckClfu6gyr7SyW6JdDFxkRqXCMsQOplvQJr1G6JIjkKoTnou21dYH25FrGIgRwwREyCUNjdXh3zcef6BvZnRQ1LfXmpALwN3pLCprWZcpd+ixhaWGcFgi5hszOftOzAv4P+YpaxgSyY8AS1AEeHDaPKxA5rsZAaBs+DGgBFiKRvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2025-11-27 at 06:07 +0400, Chris Li wrote:
> On Thu, Nov 27, 2025 at 1:59=E2=80=AFAM Rik van Riel <riel@surriel.com>
> wrote:
> >=20
> > On Tue, 2025-11-25 at 22:50 +0400, Chris Li wrote:
> > >=20
> > > > - We still cannot do swapoff efficiently as we need to walk the
> > > > page
> > > > =C2=A0 tables (and some swap tables) to find and swapin all entries
> > > > in a
> > > > =C2=A0 swapfile. Not as important as other things, but worth
> > > > mentioning.
> > >=20
> > > That need rmap for swap entries. It It is an independent issue.
> > >=20
> >=20
> > Wouldn't rmap for swap entries be more expensive than
> > simply always having indirection for swap entries that
> > are in use?
>=20
> It might be, to be frank. I consider this pretty far and late in the
> stage of the game to evaluate the rmap and its alternatives. Do you
> agree?
>=20
> I might or might not try the rmap for swap entry. Right now I don't
> have many data points nor insights.

On the contrary. I think we should at least do some
back of the envelope calculations to estimate the
overhead of the different proposed solutions.

With both Nhat's vswap, and your proposal to always
have swap indirection with a separate front end, and
several back ends, there is no need for swap rmap.

This is a good thing, because a single swap slot
could be referenced by dozens, hundreds, or even
thousands of page table entries, in the case of
forking servers. This creates complexity which is
probably best avoided.

Conceptually, Nhat's vswap, and your idea of having
always-on swap indirection seem to be the same thing.
>=20
> > This sounds like an uncommon scenario, but it is
> > functionally identical to what is done to pages
> > during zswap writeback, where the page table entries
> > stay unchanged, and the swap page is simply moved
> > to another backend location.
> >=20
> > Why implement two things, when we can have one
> > thing that does both, with no extra complexity
> > over what zswap writeback needs?
>=20
> Let me ask you a clarifying question, then.
>=20
> 1) What exactly are you trying to propose here in what project? VS or
> swap the pony?

In the past, when faced with competing code bases
like this, one thing that has worked well is for both
developers to send their code to the list, and then
for both developers to send each other suggestions
(or diffs) to improve each other's code.

Vswap and your always-on indirection seem to do
exactly the same thing. This seems like a good
opportunity to work together, and come up with
code that is better than any one person's code.

> 2) What stage of the code change do you have in mind should this
> change apply to?

I think it makes sense to get the hard design
problems resolved before committing to one
particular code design.

Spending months to resolve subtle bugs in a
code base, only to discover later that it does
not do exactly what is needed, is not the
greatest way to make progress.

>=20
> I can't speak for VS,=C2=A0 I am open to embrace what you suggest in orde=
r
> to swap the pony project, that is after I understand it first.
>=20
Once both Nhat and you understand each other's code,
and have suggestions for each other on how to improve
it, we will likely end up with a code base that looks
nicer than either of you would have done by yourselves.

The more perspectives, the better.


--=20
All Rights Reversed.

