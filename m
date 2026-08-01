Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D56DC55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 12:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 89F5F6B0096; Sat,  1 Aug 2026 08:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 828EB6B0098; Sat,  1 Aug 2026 08:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F1246B0099; Sat,  1 Aug 2026 08:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 42EDF6B0096
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 08:26:10 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C49D9C02BE
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:26:09 +0000 (UTC)
X-FDA: 85052622858.23.D65F558
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf18.hostedemail.com (Postfix) with ESMTP id 7A2F71C0009
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 12:26:06 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=ge8yd6Os;
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785587168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6gqsKOBXgwlz/fp4G98DolG7aXkw+YyYtdxuPRvONHc=;
	b=nZkSq39vBRLnpHFjQ8TlknzulKkk5ywHRg5ARUYjJPuSE6Rs4mxdJpzqmxL/3elgRYg1jd
	AqjM7BfNtaJuaiMmB//Wk8hXMg8ddO/A1Me5gZrEgjKLG7piFSTX3BJzxvk8b9vTEvh3GR
	9ww5vFwbIk5Hc5oovGz8JmnORQ6e+ds=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=ge8yd6Os;
	spf=pass (imf18.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785587168;
	b=HrjFyjZvvWKtbkgofgw5eAaIGr6Ai+iahYqYJhGIFI44RU9mBV1o+gzxvUr9PdxvbMziMO
	IxnMY9UAh6Gran4tZgx5DkQw5NKDsp9d0JvAnRJhhDUJ0jZjJBZzcb/ihw268J0Vfpa9lH
	QbmIod0zL+9+kekcZJHZYYoMDshyEog=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=6gqsKOBXgwlz/fp4G98DolG7aXkw+YyYtdxuPRvONHc=; b=ge8yd6OsYG8R/btIAop5/hx959
	yi4BTBL4CLZPTIkxK9WI43u5zsVW4D/gB78kaod2Uhbdx//c5Q2/Hcuqh/zCJhy5tsY2AGHDvEBSe
	1rRHfgINrxP8ChGPzrdCODCJ760mu5At0ZlUzx1BK2sBXsQlQq2rrJh1VneOHWAgskvtZm8hpquVU
	S5SIyEEvOgVQdpa1P1pg91jmvxVtecBUMt79JtQumgkaYfTwnICRbFdKHHOp1kgttLDqvz5uNQMpd
	8UXVPvTtME6Yt4TpMvsApX3cQsxtz4uKxeCn8jdu+dkX5wUNrrhvpqFTb+/uWTc9jGaCYY9C917wI
	1LjkBgHA==;
Received: from [96.67.55.146]
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wq8ml-000000001xk-1L48;
	Sat, 01 Aug 2026 08:25:51 -0400
Message-ID: <517bf6a8072a6e66f28f8ec08bec4b604f29491d.camel@surriel.com>
Subject: Re: [PATCH RFC] mm/gup: batch contiguous pages in
 follow_page_mask() and return them via a pages array
From: Rik van Riel <riel@surriel.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: David Hildenbrand <david@kernel.org>, Andrew Morton
	 <akpm@linux-foundation.org>, Jason Gunthorpe <jgg@ziepe.ca>, Peter Xu
	 <peterx@redhat.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com, Aristeu Rozanski <aris@ruivo.org>
Date: Sat, 01 Aug 2026 08:25:50 -0400
In-Reply-To: <am2_dWJKZBzwd8EK@lucifer>
References: <20260730035350.1fc95dd8@fangorn> <amyUQahYOgov0z8c@lucifer>
	 <e969b38ce882b32d041b7279499fddcd00f18b35.camel@surriel.com>
	 <am2_dWJKZBzwd8EK@lucifer>
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
User-Agent: Evolution 3.56.2 (3.56.2-2.fc42) 
MIME-Version: 1.0
X-Rspamd-Queue-Id: 7A2F71C0009
X-Rspam-User: 
X-Stat-Signature: zs1i13b5qwa5r5c4a1uxmf33tesg8duy
X-Rspamd-Server: rspam04
X-HE-Tag: 1785587166-188562
X-HE-Meta: U2FsdGVkX191cDfNtb+QG9FbsJ3qPS/3kwjUIux6SUjM+8sEU8+/7alG+uDVE9ef+wdwB6pQ02sjavVZ59oYQ/wIarPNDO5kwY4WnpvNpkZKrLlRQPk1qhD7govwkbYC9xxEyBVDHMWA/4xTCq/goxLcObGDsdWrO9jmzuNSjcLGbjROs/begKNv1WlX2kGhSeGmXom06/cTfwXC4E79uyyVLayRrzMuFWDsSrQ4QGDoj3uf70J1geKqZFHQehRodOLlVPEUWTsv7q8xzaMA5dxw+rb0U3suc4wNOL/Xj/XyA+SZdiQUfmdVKcV/pUNxEgL6GjQNC4FVvqxwzBnR7ffkhLA7FZqS18BYq9kI2TZIIuZMkIIqEhj1sW4Iyn9kh2dPLrWvwmHR27dvTWvjuGo+eo0xHqOaHtxmYu5s3zCtNbUnks7PpPR3J047QXLdCAR5T42DS+MJ1rMxYlSe6vgmvzHG27EeylqyrcBX2Ao1UcqvKB0W/1JhflAioKLM3z7kK5+j9u7shojG1pQVxE+yDEiQ4V1uyd5KW4c7EGHU0Y4YxRd0XfgPeIUdKN8T1qg5/5uVUb1KzjAPmpspRp5+TXXSz3wCFraVj+dvgyQzETjdK2nLl3IuPxquga52nEZlsGGd3+EhOigMfi8u8yIj9ob3tUF/pXzS/moYBmm04zcNx6cz+bG4r8FdjIQM6N+dIjc6juNaTVg+HfUQ2nMuranSHtk5HQVbh33O07GUZazZmNaD7sOzEfh24uH5L+iZDFvodjkiF9D/8JrPPdZ2QW3sBNnpKO4QBoLui0Ozj0t50DbXTEbF8lDdNa0dF/vU4csv4/TjoqVlcBVZP6LffuP2n7qY0PBgHE7Xf6IvBtDEABpmDb7RpwbX9qVW8Hva2mAioBwiGqtoQ1TsY6ftACSz1e2M8GFHpjlfJPo7XgqBvZn4i5OTtdd5jPForwh0/MMUSGG2JaFIcm4
 ioimyYQ9
 qnIEOCh6fJ+YYy0diVtRATU8jMJ6EeBdBMXFwH1gfLlnZJog2Z+A5U8Uoj66Qq/l1WOdVq/j98bSzi30Rx8MEvBQJmqAxl6vektNqn+sioDX+smsrMc/ECul4YvW5U+UwaxV5hyefXFdFfjfg3SkXH1YqF5FyxalTo04HPGTxoaVsRs/r5WI1ZSaB76R9HRb6qPo5afMOejKZ+fiucXhyR2MXbLkc4DdCqCQpm9jNN8ftR1NykuQIlfo2IOKTXQJQ1p7LG0FzKF3s9vU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2026-08-01 at 10:54 +0100, Lorenzo Stoakes (ARM) wrote:
>=20
> Thanks for doing a human pass but it LLM's habits really carried
> through
> here. In general:
>=20
> - No walls of text please - fewer words are better, clarity is king.
>=20
> - Don't write the code in English as a comment/commit msg - redudant
> and
> =C2=A0 distracting.
>=20
> - Sensible patch separation obviously please.
>=20
> - Write as elegant/reasonable code as possible. If the code you touch
> was
> =C2=A0 some horrible mega-function, take the time to refactor it. Pay dow=
n
> =C2=A0 technical debt.
>=20
> These are all things LLMs are extremely bad at (even fable). So they
> need
> to be done by a human.

LLMs can apply those rules, when expressed in a way
that they get interpreted unambiguously by the LLM.

I'm slowly building up a collection of such rules
in the kernel-style repository.

AI can write in any style you ask it to.

/*
 * Long in the Halls of Rq the weary wait,                  =20
 * till __schedule, herald of the turning years,            =20
 * calls forth the next to walk the road of fate            =20
 * as prev fades west.               =20
 */     =20

AI can also flag such issues, once it knows to
look for them.=20

>=20
> >=20
> > In order for them to produce code that is at least a
> > good starting point for editing, they need to follow
> > rules.
> >=20
> > Once you apply the rules, Opus and Sonnet do not
> > produce results that are all that different from
> > each other.
> >=20
> > I just added a few new rules, so the tooling won't
> > even let me create too-large patches any more.
>=20
> I mean, sure, but what's needed here is human Rik :)

The 80/20 rule comes into play here.

If AI produces junk, the person starting with
LLM-produced code can spend days cleaning it
up, without getting things in a reasonable state.

If the AI produces a better starting point, the=C2=A0
remaining issues will stand out like a sore thumb,=C2=A0
and it's much easier to find and fix them.

I agree there will always be a need for human
judgment, but that doesn't mean we should not
improve our tooling.


--=20
All Rights Reversed.

