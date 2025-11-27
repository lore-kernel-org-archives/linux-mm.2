Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3D028D116E4
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 02:29:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996036B0006; Wed, 26 Nov 2025 21:29:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96ED06B000E; Wed, 26 Nov 2025 21:29:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 883716B0010; Wed, 26 Nov 2025 21:29:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 756116B0006
	for <linux-mm@kvack.org>; Wed, 26 Nov 2025 21:29:07 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 19F745AF16
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:29:07 +0000 (UTC)
X-FDA: 84154804734.07.F175152
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf14.hostedemail.com (Postfix) with ESMTP id 5EE4B10000E
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 02:29:05 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=hlT8YR8A;
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764210545;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MyR7n+tUVYq7Gv0a4Vy6iLN5p/x1e6LQPMRtEiCm6sU=;
	b=7dkBWf+0PZnlYi8LmGSDMjB/Ytgf/n5K4YJZL9F2YYmD00nsTF8qTd/dUabZRAEec9t46n
	nwFIu4di63d8Oxn8c6cBWcViASF+lJDariRoqerMBfvEPJ6pToKxcClH/RbU6paL0Wu/j5
	WtKQMwILWjHEzCAiaDbjhXCQmgxMA0w=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=hlT8YR8A;
	spf=pass (imf14.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764210545; a=rsa-sha256;
	cv=none;
	b=0NC2Kh76ozxi/b9AbtO0kVpOpb8CfwIHdh++l0sUQQ80rWlx/QPKBC5BmCBDmxyLWf4Kb9
	rHs/3JJSRtSs4bkwT8adxnbI5QGyhSP2hklQi5NAw5Z1Vy68nU+csQ04AKLH92qlF2gtu0
	gbtsqIkazBAQwNpDko+XktDAy27ObVg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=MyR7n+tUVYq7Gv0a4Vy6iLN5p/x1e6LQPMRtEiCm6sU=; b=hlT8YR8A1yK+8hWzt9DjgpD7p7
	QrO8GyZevYtNX/02bVaG4q9TXtK5aZ0+CGEbKNzy4n3gINtOvKQpaSpQFpYK8enEogmRaxS9Wppb0
	x3iqBpABGs8U5MY2CBXAbJ2AqV9AG2pqx2GNTEKo9tUN0/jtYL/gU0eN7DLJa2Bkh1JBQ2WESZaXK
	lbhXgujPM7h+nKFhDqIobmOuQkAEF0x5MAXzgLv1xL2sPa9ELBLISJtPdzsdsykmD7k+2ItxCBuhj
	9O+hXCMbYxkqQxMOkwsb0u8kI4ma3S+qeY5SErFKE2fEr0ihW/5vWU+dWeHDomcw0RmmNGLzZKsIJ
	GvZn8MPg==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1vORhn-000000004oE-2QV6;
	Wed, 26 Nov 2025 21:26:00 -0500
Message-ID: <7e44e8654eb0ed5e0f590b3d705b258772dadb57.camel@surriel.com>
Subject: Re: [PATCH RFC] mm: ghost swapfile support for zswap
From: Rik van Riel <riel@surriel.com>
To: Chris Li <chrisl@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Andrew Morton
	 <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, Kemeng Shi
	 <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He
	 <bhe@redhat.com>, Barry Song <baohua@kernel.org>, Yosry Ahmed
	 <yosry.ahmed@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, pratmal@google.com, 
	sweettea@google.com, gthelen@google.com, weixugc@google.com
Date: Wed, 26 Nov 2025 21:26:00 -0500
In-Reply-To: <CACePvbWcYsm3WpQSkbiSKESpHOb+QybNTxtDL9mCvRd__Xj4Aw@mail.gmail.com>
References: <20251121-ghost-v1-1-cfc0efcf3855@kernel.org>
	 <20251121114011.GA71307@cmpxchg.org>
	 <CACePvbXXDaOY-E-nZ3n44w0StBc=n59+v5V-X2fw-V+roH=Qyw@mail.gmail.com>
	 <20251124172717.GA476776@cmpxchg.org>
	 <CACePvbXLdf9bC3Juj=wA4_TKeH6XUgHbbvwV5HhNQtgoT3CiBg@mail.gmail.com>
	 <20251124193258.GB476776@cmpxchg.org>
	 <CACePvbVJEWd64r-o8ezh+0QByYbWjYVKiLgxNiBJOjfRWP__sw@mail.gmail.com>
	 <20251125213126.GB135004@cmpxchg.org>
	 <CACePvbXstKtQXE+0i-KRcq5LwrCr92a_FKy2KBmqaiwZEkFxng@mail.gmail.com>
	 <7665130c511e3cd00f83e8b14de2b78e08830887.camel@surriel.com>
	 <CACePvbWcYsm3WpQSkbiSKESpHOb+QybNTxtDL9mCvRd__Xj4Aw@mail.gmail.com>
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
X-Stat-Signature: b64f3ih76g9kjn7zcz5y3fr8f9xbpw5w
X-Rspam-User: 
X-Rspamd-Queue-Id: 5EE4B10000E
X-Rspamd-Server: rspam09
X-HE-Tag: 1764210545-750400
X-HE-Meta: U2FsdGVkX1/26VNzRH2TmPzj5lY8x3sLrRrdq6qFWUgnxa2X1zeXb/P6M5e+7W7nm3ZogAdyobpj1cWx6d3mEaZEzPv21iYqjbppVU3ReYTcISeHS+UBmA+DwmYQRooLfDQ0h81/vmzSnJtMzF4dg1I7LSGsqGcR3M0ubxlvMJsjmOEcp5jHUvjQg3l34Q7aVnocLhtH81LX9j2pMB98kDDBOJb0cVC9l6ay3nrQEgfRcZxxUTrB8h3zd6DtnZeD4gUyg/8YMCvkG7kMZwjBz+eXbzADpMwJj5BzQ/VOp6Z5r89csulbfcGsNN3MgzOZ/zBK09GYlfT1+a/gXfAJIQk3SpQjwhA5fL2eDD5EN+o/Nxq/vb7/iXbet+4adj6MClRgvCmQchtiQvS/RvX/N9bHji3xYWH3F7IH9JnQ163H9AB+8fTxrY3lH/EF3wGuPEsuPdhevDOwywf+gsnxInX5/9nZ8h29JlaPxVpDkJ/qjlX64AF7W9q3dIP8UezyXsbmTTD7KKqYKZ17eA8ChBwrP5clPd7ecC6FPaiyw6p8sxjUhH960cQkfCGRKc8cx0JQhLiGWGJUkDKpgX9F9pDhU3fm2DJ1T+zqSq47W3XfDdTABhPWNARTS4KshZsGJ7rHl0vA0krd5p+WOD5Wnrnb9v7NRWRLmnTE4c4ebjlOfHAYrUs++d3GeRNCGUgwmuENI08wACBN1RNehm4nsn2AipiQoIykjfayyrbe0K4VafR5RiSrw5kVJBy13LTcy4KDZI5Hr2uwcN2i8PnnrlMYDzTEgR5D6DtrBL5Jz8vHj1Nm9nJhSkWTZib39qWN68wGRxTYsBTC0kGkAmYN9Uf+KWwDEMZf1qdVXNpm2GtORBe/Y/Hf72bejaPqX2i647XipsfSWFXwlf0K9JTs8I9IAeQCmw0VleByEWRQ6caBNV0qyN7d9k509jrMFt/gt+/gKabo+gpOS7Luu9Q
 yn+olH4O
 ELLW0p6UCZphLhljBqUfIocWoF+ubfdWc+ecPeLFCmXUPzAy7zlNQKMmTEbPHZIdI17vQjsSuFecdMkWPMdhfwbaxiiJ6czM38ixLajzl9nJc0jkiCJF9eFSydXDU3gXpfqoo8Nmw6udGuIkAaKAbdrrJd4L5TkhHERRkSDsCJQ+VQQ4GMFU5p2czjI1TtJojsKx5Fh1lQoxpJ1e36WHbmeONJz+SfzzNAqaRHAbzQWBSuZbBRqSmWJHvQZP6TCnb4Qgyn4HYQskb6L34Jwzvjvw2qg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 2025-11-27 at 05:52 +0400, Chris Li wrote:
> On Thu, Nov 27, 2025 at 1:53=E2=80=AFAM Rik van Riel <riel@surriel.com>
> wrote:
> >=20
> > On Wed, 2025-11-26 at 23:22 +0400, Chris Li wrote:
> > >=20
> > > That being said, I think I have answered enough technical
> > > questions
> > > of
> > > my approach, to let you re-consider my proposal. You should be
> > > able
> > > to
> > > realize by now my approach is more optimal compared to VS. Do you
> > > agree or not? We are just arguing how big the gap that is.
> > >=20
> >=20
> > We would have much more confidence in your
> > solution if you had told us exactly how
> > you were planning to solve things in future
> > stages of the project.
>=20
> Can you clarify who is "We",=20

Sorry, I am talking about upstream.

When one developer has code, and somebody else emails
the equivalent of "trust me, bro", the code is usually
preferred.

>=20
> Please keep in mind that I am just one person love kernel hacking and
> want to do the right things. I am doing this at my spare time, it is
> not part of my company OKR's to work on upstream swap in the last two
> years. I don't get pay to do this. I am replying this email from my
> vacation 5am in the morning.
>=20
> Again, let's stay technical. If you think I am holding any secret (I
> am not ), please just ask a clarify question.

I really appreciate anybody participating in Linux
kernel development. Linux is good because different
people bring different perspectives to the table.

Some real numbers, even if just back of the envelope=C2=A0
math to estimate the overhead of various ideas being
proposed, are often a good way to move a discussion=C2=A0
along in a productive direction.

Let me reply to your other email with some more
technical details.

--=20
All Rights Reversed.

