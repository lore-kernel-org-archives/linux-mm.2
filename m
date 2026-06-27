Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72231C43458
	for <linux-mm@archiver.kernel.org>; Sat, 27 Jun 2026 13:37:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0980F6B008A; Sat, 27 Jun 2026 09:37:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 048016B0092; Sat, 27 Jun 2026 09:37:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E78CD6B0093; Sat, 27 Jun 2026 09:37:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A656F6B008A
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 09:37:11 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EE01187871
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 13:37:10 +0000 (UTC)
X-FDA: 84925793820.02.FA3B8C2
Received: from shelob.surriel.com (shelob.surriel.com [96.67.55.147])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4C36A4000C
	for <linux-mm@kvack.org>; Sat, 27 Jun 2026 13:37:08 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=YJaTGbBC;
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782567428;
	b=d9HO3Dm8by88cPSuzW2ogmPbpDmAlkUnwxD1HSoi4oi6JpXLCVDeFcACsC5jwd8g96j1DI
	LtyqIkD7thJKx+dQ6ztk5SX1CTwiM/ldoeUK1rQUKDdqUib+fz76rSibQhEqxJ71aV6NNh
	8OyelJY7ofHVLenyaG71Wk8AooktUFI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782567428;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUTYL+XiY6nbZ0YUir4XMg22YbfTVMU7jfHFV+vOYwc=;
	b=hDOOv4p+/t0c7eLlUCeiQk0Mku61DUEBQV9juLAQHXxCWQ7ILs+Lwi1qrqWWddcE6yRybu
	ZnAbvca+3s7bXR8NPfC+IxqA9qTRek2QiMNkQB68+Tuv83S2m13n4tKjZeDR4Uz6laZ+o+
	F13NAmJ3Qp1FXm5m26zCD7QXg0TOmyo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=surriel.com header.s=mail header.b=YJaTGbBC;
	spf=pass (imf27.hostedemail.com: domain of riel@surriel.com designates 96.67.55.147 as permitted sender) smtp.mailfrom=riel@surriel.com;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=surriel.com
	; s=mail; h=MIME-Version:Content-Transfer-Encoding:Content-Type:References:
	In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender:Reply-To:Content-ID:
	Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
	:Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
	List-Post:List-Owner:List-Archive;
	bh=uUTYL+XiY6nbZ0YUir4XMg22YbfTVMU7jfHFV+vOYwc=; b=YJaTGbBCAVkVuPVOSxUJ2kyeYa
	46ME1ttXik+l5W/4OaXgsFFRgNxoTXOJSK9N8VJ+c/+QrIfMDCzUE2fJ4GAkPb7p3H0fc8JDQdYcf
	kxGge3hiO4PZ6LpBE3ofT5oqUu/Rnnwn/foxEhnSgeZM4nVCrVAWDZqJZaiUAfsiA8a5CX3uLPzBN
	r+DZp2wjEQcTBiLwDbHh0eDvbOH4wBM0AmEQmchQpavFxPzudC489W+mjUYDlbAoiI0e0dfdnBKI/
	rrqtnG+L8Vvh2CgwhahdXjZDSVs5uXIiefETS5PJUZeHRreYtb4s5n1eh9ab5nIEMB80rdg6igmk4
	ZhzQ7/9w==;
Received: from fangorn.home.surriel.com ([10.0.13.7])
	by shelob.surriel.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.97.1)
	(envelope-from <riel@surriel.com>)
	id 1wdTDI-000000001nG-0Ciu;
	Sat, 27 Jun 2026 09:36:52 -0400
Message-ID: <528e3a5fbc27c9dc7a098121c32b7679b4c9962a.camel@surriel.com>
Subject: Re: [RFC PATCH 00/40] mm: reliable 1GB page allocation
From: Rik van Riel <riel@surriel.com>
To: Lorenzo Stoakes <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com, linux-mm@kvack.org, 
	david@kernel.org, willy@infradead.org, surenb@google.com,
 hannes@cmpxchg.org, 	ziy@nvidia.com, usama.arif@linux.dev, fvdl@google.com,
 Andrew Morton	 <akpm@linux-foundation.org>, Jonathan Corbet
 <corbet@lwn.net>, Chris Mason	 <clm@fb.com>, David Sterba
 <dsterba@suse.com>, Vlastimil Babka <vbabka@kernel.org>,  Steven Rostedt
 <rostedt@goodmis.org>, Masami Hiramatsu <mhiramat@kernel.org>, "Rafael J.
 Wysocki"	 <rafael@kernel.org>, Oscar Salvador <osalvador@suse.de>, Mike
 Rapoport	 <rppt@kernel.org>, linux-doc@vger.kernel.org,
 linux-btrfs@vger.kernel.org, 	linux-trace-kernel@vger.kernel.org,
 linux-pm@vger.kernel.org, 	linux-cxl@vger.kernel.org, Linus Torvalds
 <torvalds@linux-foundation.org>
Date: Sat, 27 Jun 2026 09:36:51 -0400
In-Reply-To: <aj9yrlB0TrlYCLlf@lucifer>
References: <20260520150018.2491267-1-riel@surriel.com>
	 <aj9yrlB0TrlYCLlf@lucifer>
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
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4C36A4000C
X-Stat-Signature: hpath6hsq9fzuxepsf3d6zmkx5ocs4e3
X-HE-Tag: 1782567428-758977
X-HE-Meta: U2FsdGVkX1/bG3zWXnNWAMfnnJG6zRZkNjkY18bPFlvMcEXOsyaYgarF5BkBZVMcWr4GLlGEggwDhIG5Teg7P9D3oVcNn36yw8z5JKVc1okwTUNylXaI47bRWcIcw4L8hUX61hLyxoyE/hR7XDZ+OUB3VN2Dv8rKaqeNjo+3/7y8Ys5W/G+9jrUzM1a7+6p4dIFUAzycay7rnGgSE4NHt5Q87LkPk5frUxM4vNOXxjMBB4BuHSZgQfx/hC7nzRqPU9plm6GoPEPe1ZtMmopofU3rNS3W9nPBtf+i9ySPitkvLgUVBOB6ttQLouolqsaMeADqPL+NRuY+GiWU7Kj8E5F8mWn7mrCCP91JrRLe5AuJRQxmURLZzgWdu7Pf9o78gToKUE4TUbvbUw7qPP+31lttYtaGMipR/DAM3BMnHDcHFvWiaHgqIfnd4xLTDijjLwaAA5OtMDn0tJruIRxmdyO1edR+3uF4dnsV7YK9401rOCG0PUIkIyJpo0Q665Rmm+x2WK4QlKY9ix65L5C34cVEFu/Wh8XN6KbnKxXqMeE99tvKTEb2ZUAyE8shjNkQ2Xnt9iQPg7Nfc86zLKqCZMMCUhS4JUxspqZlY5iwIKSCw9whc0KUzemBFgmmDbSaKeyU/mEdKNOxbGAsqSzW4NCiiFaGE3grTYJExqq5MsqCO8DxOdy1HIFP/ZAYj1b/PoOyKoucndpyy83l7WGBeTuSfMgN7ZQnhcjatNuXowkYqevNqpQba2NCLsmX92aSwIT/3ZXTSHPcvEdGRpT0ryVaQmcCCKm5gcYozgQbEGxVQUGu5RjuZj2/CSijGR2oA+UNxB433aGK5NUFiG+6mBL7bnvmCCYGj3REuOxFYT4LcrIUVIq3dAgHPpvLkKhdoN8GKV3ftHPX+jA8UsLddbeEl4DmShY0Au/1LlIH3ugPuUNfNNZmLDQjis/v8z207VwHi1tvF2FdxrD9w/K
 TdMtbpIX
 rJy8kumLgs6zzMqDqtG0PXk4blmIvz5j2pVseKG/uP9YyRWyXPxTpqY983fjbYJzQP5UU+Am5bPmDsF08IXA9AAvxyK5cf/bJbe0fFG7hAG88j2cfXK1M/fQS/uxeLkAHn7BZ01RVnW6tWVHSo0rowJj6W24+GJcbXom1PerVAaMKSi8bqxkFamDaMKri6bbzdWDlkPuguVI4uIFZ92bY3DruIttv64m1fQn5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 2026-06-27 at 10:28 +0100, Lorenzo Stoakes wrote:
>=20
> So really, you need to start again, from scratch, and without the use
> of an
> LLM for generating code, or at least with it kept on a (very very
> short)
> leash.
>=20
> And to be clear, I _want_ this concept of GB superpageblocks to land.
> It's
> a really exciting concept.

That is the one reason I sent out RFC code before it
is ready. I am looking for feedback on the concepts
in this series.

How do people feel about splitting up the free lists,
so each gigabyte (well, PUD sized) chunk of memory
has its own free lists?

How can we balance the desire for higher-order kernel
allocations, against the desire to preserve gigabyte
sized chunks of memory that can be used for user space?

>=20
> Pulling compaction kicking and screaming into 2026 stands to
> significantly
> benefit linux users and developers.

That's another big question. How do we balance the
desire to keep compaction overhead low with the desire
to do higher order allocations almost everywhere?

>=20
> But the execution has to be _completely_ rethought.

There's no argument there.

I am just hoping to figure out what I should be
doing on a conceptual level, before figuring out
how to do it cleanly.

The mess in the RFC is the result of trying something
that seemed right, watching it fail in some subtle
way, and trying to fix it up.

Once I know what I need to do, coming up with a
cleaner implementation is very doable.

>=20
> IOW I say we take off and nuke the entire site from orbit. It's the
> only
> way to be sure :)
>=20
BOOM?

> Another issue here is maintainer time - even this _extremely_ light-
> touch
> review has taken me a few hours (of my weekend :). To review it in
> detail
> would take probably DAYS of dedicated work.

I suspect there is a mismatch in expectations here.

I already knew this code has to be totally redone.

I was looking for feedback on the basic concepts
and design in the patch series, but failed to
clearly communicate that.

You provided some detailed feedback on the code,
but as of yet nobody has really provided any
opinions on things like whether it is desirable
at all to have the free lists per gigablock,
or whether we need to come up with some totally
different approach.

How do we better communicate that kind of thing
in the future?

Is that something to spell out more clearly in
the cover letter?

Is that kind of feedback something developers
could even reasonably ask for? (if not, how do
we figure out what maintainers want?)


--=20
All Rights Reversed.

