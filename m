Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 761BEC43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 14:39:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 492CD6B0088; Mon, 29 Jun 2026 10:39:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46A2C6B008A; Mon, 29 Jun 2026 10:39:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 380436B0092; Mon, 29 Jun 2026 10:39:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DD1D6B0088
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 10:39:39 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 03D4240149
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:39:37 +0000 (UTC)
X-FDA: 84933208836.04.A4EC5F4
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf01.hostedemail.com (Postfix) with ESMTP id 21B284000C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 14:39:35 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=BlIR7eoq;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782743975;
	b=MJtzlRhM4m+2xWN4msKiIWXpBkVczLhYk36K5JySY+8H8+lActwItYB+bzYV3gG1FtMus+
	2ckQlcLUq8qGMsgHQi5NNFuo8ac6yVsuhszw88WsV6i87lI7pDt2WNDH5bOueQ2sT8bH9N
	K8opRMXJje7E9E4clYPYsWvsKVk6648=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782743975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tIgmvkbVGgsAFw9O5XEwFGKEfBQkgY3RT+doQ9R/e5A=;
	b=UnYNDg8r69/O2LtVcTAXhvT2NhK7H+BBWXeARCgXAYGikoHxnN8Y9psIgD7z/dDpLfFYf3
	6PJsCybLELA5ledAUwIlpuFdRuTUQC7aA0kAUIWtxp2j87cQ6CRV1Dzr1ulAhZTtW/Z2Ju
	Vza9dRxU/VHIVrOxceFABzf7X2HUfa4=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=BlIR7eoq;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=tIgmvkbVGgsAFw9O5XEwFGKEfBQkgY3RT+doQ9R/e5A=; b=BlIR7eoqUhI1rLk2ZjKvXK65XF
	ul1b3Jicl/kzWBqFFYfTW2921ScvcTwoLQ7D7BoW0xono/v0ezOQgDtoxXPq8xKg9MqyJQHmaTZhG
	3N1FL0vYN2X8TFLjAVPYDdDvGPGx1uft0Pa7GoBvSEuiVgDaK3EgcJG8dImxaUrlrgvLYWMIxQyn1
	mqWkLM7qeLR9Typ4qRZCwCK3lq9Oq4RFiCgyZ2raRaTMiE9Vts5062yaD5qjjHcCL8sVUyeLo3GWz
	+cuYSucxEx9Gj/nM3pCzyJgsqsJA+OZVuo9vlhAoQJX3s1SIwfIZUWajLmBCV7g8w4yjJ5+x20fez
	cWgAlFmw==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1weD8d-000000007rY-1v7G;
	Mon, 29 Jun 2026 10:39:07 -0400
Message-ID: <ec4d1acc0d01cd9d9b6f4c9da4033f8591f9436a.camel@surriel.com>
Subject: Re: [RFC PATCH 00/40] mm: reliable 1GB page allocation
From: Rik van Riel <riel@surriel.com>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Lorenzo Stoakes
	 <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org, 
	david@kernel.org, willy@infradead.org, surenb@google.com,
 hannes@cmpxchg.org, 	ziy@nvidia.com, usama.arif@linux.dev, fvdl@google.com,
 Andrew Morton	 <akpm@linux-foundation.org>, Jonathan Corbet
 <corbet@lwn.net>, Chris Mason	 <clm@fb.com>, David Sterba
 <dsterba@suse.com>, Steven Rostedt	 <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Oscar
 Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>, 
	linux-doc@vger.kernel.org, linux-btrfs@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-pm@vger.kernel.org, 
	linux-cxl@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 29 Jun 2026 10:39:07 -0400
In-Reply-To: <361fd2e5-a5f9-42fe-90fc-bc0af109553e@kernel.org>
References: <20260520150018.2491267-1-riel@surriel.com>
	 <aj9yrlB0TrlYCLlf@lucifer>
	 <528e3a5fbc27c9dc7a098121c32b7679b4c9962a.camel@surriel.com>
	 <akIjA_dqh4OHAYo4@lucifer>
	 <361fd2e5-a5f9-42fe-90fc-bc0af109553e@kernel.org>
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
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 21B284000C
X-Rspam-User: 
X-Stat-Signature: wqkt911jutit1jh8xs1hy7wqjyux6euw
X-HE-Tag: 1782743975-800556
X-HE-Meta: U2FsdGVkX18dbfHCVD2xEsGrA8La1ZqfnhnegmWgnEWfFYExrjfFI5SWGlyjoY4QVXHKlWiY7gEmT9ekc3OypcJ0m9pz8e1wVQ5doust16RTfIXyzEU4idKs/+VWgu3GbX3Fz8kiegVF0d50zWF9yyjMpMBQiTKG0eo2D2pVxLwMrAVczSkjoKKhxYYlzmewfF8CnL1+PraTVDDimGrmpgXIuPTWg8g+TqX9UgRtkiSfaBCBCmq9++M1P1K2CwyuLHXMXJNqc5HurKkv6vSbDsR6cocFNiSkOU0kkgmmFDqHMw/6ldJQyyWP6gG0j7CsV9SYkshqftXNot+DcYV66rTquNSlIU5CpMP8c44ElGXXnStMlaaHHtE0JlEDNpjvAAe8wslJ1QPWim7aHLQCwtMF3civv+XnhhGKXNn9O9xcEqxNcA7TKYcd4y72b1K31vTM+72SgcKRXFDcOBhGQrdih+HSC8dnNaQsciIMmgzdyFuZ76zSJJpgj+mVE47aJ3TUuCgUq4cOisFaOSwM5Nc/0nVFXnHGC6iCg53VP3Aatu4XPW/LbRz3k5Uh0rEAZsQIDl+/t/bjqzsmqKXIyjbQRVCgN9z68SLE5PuuoVlKEiDBl0udAwrG15DbG3SrPhPssUkwnnFWKuG08F9cjQMMJ8Tbc1vuNhMhfDODWUSWhr5lCF5/nkv/CJoRhHi8qkKbp2FKjtzfNQnP+bFgRVd34Yzca+4/5WSzTGHmoYYUl7OrPkuJwaAnQL1Gt7El7plczfi4uEWR1LDnC+HVs11gNJUaDUTpGR7LiauPrltueWYfHlI/1hLgqC9KXgsm5fP1klsXvic7W59ytA3u/E8YegFqf0TtokWgba3hXKormNtTofakYI0G3cx6OEs4yvAtkD+aX2A5fT0Efo6+2U+KUiFjjC0LsA8+vU3EdrsmMaze/WdXUwJ5803AhHCGxjPD41JR4YubnZsdlbj
 wvRKjdy/
 APbzaIjbm+mFsGFg5+jdA7cw/u7Dp0fAB0jNpuLZCAXn1xaDne1jpQUu7UlbGz81ClGPterNBrvhGLEDtzS6dAPsFOe8Cvnws+eh4503AnjwBQEKBqHsaSeyGxjWgBlqQUppURu4f57wKVkFe4QeoZELUDd4EleJf4ix8t81Sg08uRO4dy5sQhcDqGD4fdgbFHVB2jwWgYoacYTVYyBc/aAv9Hvzmgkk+uSqo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 2026-06-29 at 12:03 +0200, Vlastimil Babka (SUSE) wrote:
> On 6/29/26 11:29, Lorenzo Stoakes wrote:
> >=20
> > So to be concrete, if you send really rough code, Use [pre-RFC] or
> > [DO NOT
> > MERGE] (on the series as a whole) to make that clear and say so in
> > the
> > cover letter VERY VERY clearly.
>=20
> Yes please. [POC NOT-FOR-MERGE] perhaps?
>=20
> > Or, you can put it in a repo somewhere and link it in an email
> > discussing
> > the concepts (like I did with scalable CoW for instance).
>=20
> Indeed.

I'll do that for the next version.

I suspect it will take a while to beat this thing
into shape.
>=20
> > And _you have already done this_ in your reply here:
> >=20
> > * "How do people feel about splitting up the free lists, so each
> > gigabyte
> > =C2=A0=C2=A0 (well, PUD sized) chunk of memory has its own free lists?"
>=20
> My immediate response is that now we'd need to search multiple sets
> of lists
> instead of a single one? What about the overhead?

The current code is clearly not good enough. It
has to try several gigablocks almost blindly,
because there is no efficient way to find the
right gigablock.

I have an idea on how to fix that with bitmaps.

We could have one bitmap per order, indicating which
gigablocks have order 0 pages, order 1 pages, etc

Then a second set of bitmaps indicating which gigablocks
have unmovable / reclaimable pages.

At that point, finding a good gigablock to allocate
from can be done with a bitmap_and and a search.

These bitmaps would only need to be changed when the
status of a gigablock changes, eg. going from having
order 0 pages free, to not having any order 0 pages
free.

Does that seem like a workable approach?

Once we can quickly pinpoint a gigablock for the
page allocator to grab pages from, we can also
split out the "pick a gigablock" code from the
"allocate a page" code.

>=20
> > * "How can we balance the desire for higher-order kernel
> > allocations,
> > =C2=A0 against the desire to preserve gigabyte sized chunks of memory
> > that can
> > =C2=A0 be used for user space?"
> >=20
> > * "How do we balance the desire to keep compaction overhead low
> > with the
> > =C2=A0=C2=A0 desire to do higher order allocations almost everywhere?"
>=20
> How can we have a cake and eat it too? :)

Pretty much :/

I suspect it's going to require some fun interactions=C2=A0
between allocation, reclaim, and compaction.

However, with everybody from networking, to filesystems,
to anonymous memory wanting to use higher order allocations
of differing sizes, it seems like we're going to have to=C2=A0
tackle this somehow.

>=20
> > I'd also very strongly suggest (as I did in my original reply)
> > breaking out
> > parts that can be broken out as prerequisite series.
> >=20
> > If you're doing something good or useful _anyway_ then just send
> > that
> > separately first, and have later work rely on the earlier work.
>=20
That becomes cleaner with the "post a link to
a tree" thing, as well.

The pcpbuddy stuff is likely to go in separately.
Johannes is still working on that code.

The "make btrfs inode cache pages movable" thing
already went in.

I think I have a few more things in the tree that
can go in separately, but hopefully that will grow
as this code solidifies.

On the flip side, things like "making compaction
scale" may well end up depending on the gigablock
stuff, because lack of targeting data seems like a
likely cause for why compaction has to try so hard.

I'll make sure to go over every point raised by
you guys before writing the next version of the
code, and again before posting a link to the
tree.

--=20
All Rights Reversed.

