Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7C091093168
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 00:35:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B75CB6B0467; Thu, 19 Mar 2026 20:35:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4DBC6B0468; Thu, 19 Mar 2026 20:35:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A63786B0469; Thu, 19 Mar 2026 20:35:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 95BFA6B0467
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 20:35:30 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E01CA13BA7B
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:35:29 +0000 (UTC)
X-FDA: 84564572778.17.36D8113
Received: from fout-a7-smtp.messagingengine.com (fout-a7-smtp.messagingengine.com [103.168.172.150])
	by imf20.hostedemail.com (Postfix) with ESMTP id C83031C0004
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 00:35:27 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=invisiblethingslab.com header.s=fm1 header.b=o9iRXE22;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=aHcOmJ7z;
	spf=pass (imf20.hostedemail.com: domain of marmarek@invisiblethingslab.com designates 103.168.172.150 as permitted sender) smtp.mailfrom=marmarek@invisiblethingslab.com;
	dmarc=pass (policy=none) header.from=invisiblethingslab.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773966927;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JcONGwatR7I2a2nbnBcn4nDdjiD848qctkczcd/135I=;
	b=Gn9oGSacJEeEnQN+jk44fsm3Tut7b6vYpGaD2x0SqmX82HKbqJj9nJ0UTUmD3J0PjI569E
	hiwggDiWne1gr6qX4bZFhvQU/2Y7RQ+6YfjBrUB4HTwdiKX/xiLRZVflv89Jvvl931dlWr
	y/cqG/CJ0sMGYOeLfw37mNJoPjoo3tQ=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=invisiblethingslab.com header.s=fm1 header.b=o9iRXE22;
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=aHcOmJ7z;
	spf=pass (imf20.hostedemail.com: domain of marmarek@invisiblethingslab.com designates 103.168.172.150 as permitted sender) smtp.mailfrom=marmarek@invisiblethingslab.com;
	dmarc=pass (policy=none) header.from=invisiblethingslab.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773966927; a=rsa-sha256;
	cv=none;
	b=cl2VdfPw/fjYIOBAbS2+5iMV9rPNe8RDerckm8dX/adw3MsdNu5PRWg/PCAe5SlrRyM0yo
	Gpp7yuK53fOwBtFXFVfmnWU5sFYBUf67py3uAZPd52T4/Vsy2fIi5ms8+dpt0FD1yST+wH
	Mv3KnEtsrdjAqEopSzVHqccDfX9xtl8=
Received: from phl-compute-02.internal (phl-compute-02.internal [10.202.2.42])
	by mailfout.phl.internal (Postfix) with ESMTP id 3405DEC01DD;
	Thu, 19 Mar 2026 20:35:27 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-02.internal (MEProxy); Thu, 19 Mar 2026 20:35:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	invisiblethingslab.com; h=cc:cc:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm1; t=1773966927;
	 x=1774053327; bh=JcONGwatR7I2a2nbnBcn4nDdjiD848qctkczcd/135I=; b=
	o9iRXE22s4v3SibxaC9hpc6A6uyuS+CaFY0enqTN+htegyVqj9n4jY5e5KjzSG/5
	G8AKSWMNKCAY2RX93lNRZl+5LG571pYpQVGaJpFkAu3ySjaw0bz/DuyeMqW25II5
	+JnoI+tVg1jrLTQsvPaejhxeMcfOzZ1bU7Ei6PSyUBv7zWHaxDEK3MBadIjBCaYc
	YmIhF8FFm7OqTwiGsZtKQiwekGCxX+Z+BkSC10ATaHxLlHVKz9BNevbCGHWld8cI
	yM9hx1+U0Nxpg9Z92ADffOiOWsl5EVyYODmLjpIAAxht/kFB8afE+QUHCIBAnOe5
	SqCQy42dAKMPD5dPXJSzPg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-type:content-type:date:date
	:feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
	:message-id:mime-version:references:reply-to:subject:subject:to
	:to:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
	1773966927; x=1774053327; bh=JcONGwatR7I2a2nbnBcn4nDdjiD848qctkc
	zcd/135I=; b=aHcOmJ7z78hfcHqG88kU0UoJ7OiJ9gSWCciMgCIW9Oe1aj12F/w
	sz4BhUijpJi+6Mg9B1QwFNMMzEKP2cVL2kbQj5Pq4tKtN8FM1Cu5v92XtOTg3JNa
	tWKrdTWaNuqBOz+SCl1u3UUQKUAPUfD35ZL/39vqFJgWyW/heuXiy6TRPAVqP6K8
	x7W66zvshvDLNJS4acOdSpgnBFzYrf4jBv+j2BT1gRRA+eMZDs3+KDYrdw87hG9V
	OjUbXXwg/rVUvx53/ZYdfeKBPoK3CkRKbuOjTgqAubXzd9dO/18dquC0xtHXn02k
	7rxxDr234hGp/90mGkDCgWrmwRLgsZAcvfg==
X-ME-Sender: <xms:Tpa8abB1Mh9xKU831dYLGOf9C6-gOg3F4gGiSC4ZzPJNsq8ASPu5qA>
    <xme:Tpa8aYYipdefJhwZUgg9VnTbVPWFfnPSk6QjTER9tU9__Mq2UEftTwVH_7J_UgB3f
    PJqfs-Ta6za4abhtRdeCEahiaKWzty_68_7KWMSCQPdFHo2ADQ>
X-ME-Received: <xmr:Tpa8ae6p7thI7tVHbo1jUP2kbaB1sUfFzAOQy_SIsWpkmyeIxlZyTilAutZTMnAGKVg33a5wSwW7bdXNe9I5M6V0vhKr0Ycitbw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefgedrtddtgdeftdekgeeiucetufdoteggodetrf
    dotffvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfurfetoffkrfgpnffqhgenuceu
    rghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmnecujf
    gurhepfffhvfevuffkfhggtggujgesghdtreertddtjeenucfhrhhomhepofgrrhgvkhcu
    ofgrrhgtiiihkhhofihskhhiqdfikphrvggtkhhiuceomhgrrhhmrghrvghksehinhhvih
    hsihgslhgvthhhihhnghhslhgrsgdrtghomheqnecuggftrfgrthhtvghrnhepgfduleet
    feevhfefheeiteeliefhjefhleduveetteekveettddvgeeuteefjedunecuvehluhhsth
    gvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepmhgrrhhmrghrvghksehi
    nhhvihhsihgslhgvthhhihhnghhslhgrsgdrtghomhdpnhgspghrtghpthhtohephedpmh
    houggvpehsmhhtphhouhhtpdhrtghpthhtoheprhhisggrlhgurgestghhrhhomhhiuhhm
    rdhorhhgpdhrtghpthhtoheplhgruhhrvghnthdrphhinhgthhgrrhhtsehiuggvrghsoh
    hnsghorghrugdrtghomhdprhgtphhtthhopehhrghnshhgsehkvghrnhgvlhdrohhrghdp
    rhgtphhtthhopehlihhnuhigqdhmvgguihgrsehvghgvrhdrkhgvrhhnvghlrdhorhhgpd
    hrtghpthhtoheplhhinhhugidqmhhmsehkvhgrtghkrdhorhhg
X-ME-Proxy: <xmx:Tpa8aZZYU1sq9eJFrSdXRSVwLvv9Ra_1e_pgcZJaGC8RxTbeXsJ04w>
    <xmx:Tpa8adg4cbdZ8QxKyglo3HzlpH5EOEdSMvXAnAihPwcPjYQJw_bFtQ>
    <xmx:Tpa8aa-dY4_QFgHrmps0ESRVoKKZUWVqM_oaffD2gPFbo3vYCPqwAA>
    <xmx:Tpa8aYqlogKH7xeGqaaxibNI2Ay9Wa3qsF9MWY-piWy6YG2cSpx8Uw>
    <xmx:T5a8aaK5f7tdsb7Fqw207TKEnVi7mG-7YR-leIYSvDsFGigO3TratenH>
Feedback-ID: i1568416f:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 19 Mar 2026 20:35:25 -0400 (EDT)
Date: Fri, 20 Mar 2026 01:35:24 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Ricardo Ribalda <ribalda@chromium.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>, linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: Linux 7.0-rc4: v4l2src0:src: page allocation failure - increased
 memory usage in 7.0?
Message-ID: <abyWTGIlD_rncMds@mail-itl>
References: <abtAylIlW3I8s1T-@mail-itl>
 <CANiDSCvqt574XbMAz0qUunu7xDY=oScL+sx533X6ke=fcEdr+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
	protocol="application/pgp-signature"; boundary="3Wmh7zzAptM1+3iD"
Content-Disposition: inline
In-Reply-To: <CANiDSCvqt574XbMAz0qUunu7xDY=oScL+sx533X6ke=fcEdr+g@mail.gmail.com>
X-Stat-Signature: tpsesaom1wkru6j4fouany898t6gsk7f
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C83031C0004
X-HE-Tag: 1773966927-490401
X-HE-Meta: U2FsdGVkX1+HGJj5uqzFQfnxzYdWvLm8bXXl/GGOLiySLtaVmd/wSK8IeHCC4LpeVEM2uYmvPPTGvlLJCDe47+ySNkeDraJHO6+CXxkW9vC9WBsBdswcduEfHVMO8yAUZpO4EBHGbyf+I9BGzFYXpbPfJPea5HscrONvo48HGgxXV8nR2owFzhAtoDP8bWNb/yTZR5kIemz6PKB2yuI3nTiCcPUMNEoo2VyJluGlsVni1zb0/2K4HI/6i7AM53/Uj2UadOyEtfuW8M/8veR6vElIZgPeTKWPwa9zD8lGP3zmrqwefUx1LKSpuhq06xLKXDslhRnfY8FPhn1i26EP4ly6qYFpbslyX7u98tZ58Hc0QoAtnFJInTNFGGUHB+W61P8l4p5wLYcEcoLzSS2+Zoxfd8Y6tmcZPas47t/da9EXuhXuRle8ILSCUmdcbkDH/+EwDBEJ7oa1K31G9b6e787yWkVO5H9rPCWLKBRhQw0XRKqRAiRGM1epFfhehSTlNCsIwmIv5gwOXaG9fnQ73QlhJkNJet4ivJYyON+ln5HB9W8Kyt/O5EeDKpWc0XLWwmGqSyLsZngxCCVzOqAfjucOWFZIAKDvoY0VPkGsmBntbvQnYTbdL2/nhrbo9uY7QnLbOuryteMWF5nVhNeX9gI6BzkuB4LYQscdPLRZJvYbtC726c7O/wWymYGrCp3r2i7HoH6N4jJyd0ysezmUY3m49kNXoi9vVMIeHBXudjcSov90se4+Jd9o4svzqQZ0OKopcNbGd5MdwmhiniM+BeewtPhab60L026ilBybaf4k7PlgwHX4dZbbNWr+ALm5kjL7CbPd4IwwF4YjconVQq21n2uUoONHurf1z/7JKR8jTq7GWKmy7nmezgLLm/d3f32d4OREmrQxK9B2ZgAaQUHPo5B4+dZfZbH0zwRuw2iTD27tuni8wakXrp6VqCtj6f8PASfaj4ZUZaJjrjN
 dj9jnImi
 3MObnOrlFVhKntW16nn4SDD20LiQ/8qY0gXBOYFIrQX13CQm8gHBPQq1f4sbg20uH0Ez19QKgYLM85RZNCq90XsD3OKuwbBwddEj+KQq6txof9BqEfZXmlf7YeCK0j/gZUfcN7zLph1R0rjVtrI4MGvKY+GjhKfcEL0zmofJTehcU+mPquq/odmbGmlq4tItWEASwPZ4YEuxOAb0guhSealpzUfbe6H3tvvqJPqs+JE7HER03oJ8P9TPaYiSj0zqRG3oc75hQHwN3BVZypypaXgca3Ruw/iZQOPtCqGmw9QEPTOLWqsbdaud2xCg/9d0k6O8r9D6/3844bKQvAwVP5a418hi9/YI9hvjJBdaRfQ1yX8pCqIgzTsk0p/wrqtOGUa+oF1LGAsnCcd5XDOs+OMK06GnXgVDobCDIge+Xkkv4O3qPZiHf1OeGdj8AM2FmmOqd5jY5NKhGeC3PySc2eXYD+D1KKtK7NcD5vBXbd7tVOz03BLBZSGd7LqtTlfp/vX/my9mCCqcYucf0jHkciSvsxyUmI4qnhj97TEWyHI5HHAQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--3Wmh7zzAptM1+3iD
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Date: Fri, 20 Mar 2026 01:35:24 +0100
From: Marek =?utf-8?Q?Marczykowski-G=C3=B3recki?= <marmarek@invisiblethingslab.com>
To: Ricardo Ribalda <ribalda@chromium.org>
Cc: Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Hans de Goede <hansg@kernel.org>, linux-media@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: Linux 7.0-rc4: v4l2src0:src: page allocation failure - increased
 memory usage in 7.0?

On Thu, Mar 19, 2026 at 11:19:38AM +0100, Ricardo Ribalda wrote:
> On Thu, 19 Mar 2026 at 01:18, Marek Marczykowski-G=C3=B3recki
> > Additionally, this failure isn't handled gracefully, it's followed with:
>=20
> That should not happen.... Could you check if this fixes it:

Yes, while the page allocation failure still happens, it doesn't result
in follow up errors anymore.

--=20
Best Regards,
Marek Marczykowski-G=C3=B3recki
Invisible Things Lab

--3Wmh7zzAptM1+3iD
Content-Type: application/pgp-signature; name=signature.asc

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCAAdFiEEhrpukzGPukRmQqkK24/THMrX1ywFAmm8lkwACgkQ24/THMrX
1yzZqgf6A1X1/vuRf+H4NNzBAsVYrRbNQzGgQKlEkx/IG/lvr3pV3QaNCxsgpHyi
rMbm1sd7/PSW5kmL4TcqeozhJcH+RSE26nGL2PfTsGu9vG+u1C3J3x4EszM86Via
7P8rj9uc4bESWCDsIvPevH5o6f7YRN2idp4YpOfm2e5iVMDFclSN/N3PAT/TZEmM
Jir4SEiuu1C1tXlrsB5FTzipvS2oJUpOTD+A0f6PEhqzKVaCbnFYvSz38IVmk1Kz
voPL8FtD1fopAWdFIuDCF1Y+oJLSPbz4AAxVt818xMmcIzXi35NgdGX8th+9Tv0G
9gBAr80v3xSVPv7peCA742lU1bUsww==
=uE5Z
-----END PGP SIGNATURE-----

--3Wmh7zzAptM1+3iD--

