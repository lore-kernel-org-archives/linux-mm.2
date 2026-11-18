Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64705606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 15:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=VpWF6okg
Received: by kanga.kvack.org (Postfix)
	id 62EFD6B05BC; Wed, 18 Nov 2026 10:23:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 607A46B05C6; Wed, 18 Nov 2026 10:23:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 51E3F6B05C7; Wed, 18 Nov 2026 10:23:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2A0A86B05BC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 10:23:59 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id AA98B1C411E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:23:58 +0000 (UTC)
X-FDA: 85448610156.11.095B8AE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1CE002000A
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 15:23:56 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VpWF6okg;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795015437;
	b=5OI+CS8t4SC+BlzCNZsY+nEFmd/fpSYeIQvxOOP692pFq1s2K7hwxltdFXaAhUu4Jm4eaU
	9DBRizehnDUA/SV6FPXCoTnxkjZdD3pqptVvKfeQCi7OyBvrh5MTb5UF5zQ3KyFKVkoHYS
	+y2jcdmoioSD5ebo6IvZmUjLlmMP2qY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795015437;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/wWuoNoKhTnCurVf+R9Dm8cUyc6MlIAKk64n3z/RBEY=;
	b=w7IUdv4/ICUF5KOS13WSJYm3ACbrs7XNY83Oaakl88f3QBtHXHHN9LemDRpQQHTu8Y58R7
	xvyn9TR22HpJfkXLJNLIe06g6e+fyBIz/bHFHTOFl+UTnrk9IgY/7zzq/9nLRybqmrNiq0
	pg7eP+sfRMNU1TsSX3tS/uIH/Au1oos=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VpWF6okg;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 484FA42157;
	Wed, 18 Nov 2026 15:23:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C03411F000C5;
	Wed, 18 Nov 2026 15:23:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795015436;
	bh=/wWuoNoKhTnCurVf+R9Dm8cUyc6MlIAKk64n3z/RBEY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VpWF6okg+6brufuDUnD/0rcm3ikR/TGcAO2b+kf1nmmezjf+ioumZyaJ/hW1XAXHc
	 i8+zQr8ldIQD0EwrkfLPgRuItBcHyIZGOM9ZjDoPmyJ1lmnkSn4IWArch/xtz+If9D
	 DG3rxW6pXD2Lxv1OKCtUjy80q7COvdcFrxOToK+yGr980IxJ1Q+I/s65bGLw80Gp98
	 fgGv05L88j/j0lYcRWqAAwMUORJzu7XIZ7ttOGLTRaeCxIqA75DJOHItpxUN0JKiXG
	 ilTvBNtJXKBxAAwlwwkJ6flU0YBv1XT+qIIumi2wFcjWs/rqbqqj1cif+sSDD0fUkB
	 i1OiklgN/SJsg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>, Jens Axboe <axboe@kernel.dk>,
 Miguel Ojeda <ojeda@kernel.org>, Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Daniel
 Almeida <daniel.almeida@collabora.com>, Tamir
 Duberstein <tamird@kernel.org>, Alexandre Courbot <acourbot@nvidia.com>,
 Onur =?utf-8?Q?=C3=96zkan?= <work@onurozkan.dev>, Lorenzo Stoakes
 <ljs@kernel.org>, "Liam R
 . Howlett" <liam@infradead.org>, linux-block@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Igor B <igor.b@beldev.am>, Vitaly Wool
 <vitaly.wool@konsulko.se>
Subject: Re: [PATCH 1/3] rust: block: add bio segment iteration and request
 accessors
In-Reply-To: <20261117233211.3137168-2-vitaly.wool@konsulko.se>
References: <20261117233211.3137168-1-vitaly.wool@konsulko.se>
 <3wemO2s0BrkamlAGBfPqORofFz9yCXPMZUZ0-dUQxmJmEhmz2T2yaCjcaTVXEB_gwLj8SdBNjkOR8r6aERjk9Q==@protonmail.internalid>
 <20261117233211.3137168-2-vitaly.wool@konsulko.se>
Date: Wed, 18 Nov 2026 16:19:13 +0100
Message-ID: <87a4n6upzi.fsf@t14s.mail-host-address-is-not-set>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 1CE002000A
X-Rspam-User:
X-Stat-Signature: th6qk4b3zopd18a7t7unfjd51n3gut3n
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam12
X-HE-Tag: 1795015436-474642
X-HE-Meta: U2FsdGVkX19YbQx98Vf3Y2NIHTPxqRg2cus2k7qgN/wNc1AnSjpZ2sf+Sh+hFp4OmqrKzIU8suyWfkoFCTGV2RJjEBD/UEzHFczVHKjgvjkkMfzb4jAuDsA/rvsr4kL4Ok2pAKWI9DcvRhUYXY0lT/BXOHe8Fm2BAToad+a+x0WS5xlBIji+ycwOOZcRcsK6eN3Urn2h4hwKzSScwdneKTbmASjBYDql3o+d/VLoV95+gNTMtN0y36yYd4yfoGS7dXzY4huAxoO4pIt1efEL5KWax8mHAZNkK2+7ZEVng+s2E/CtH0mAQl8JBmoh+87UvyGvAI1bmL/EnAhbu+wvlaMiOv1du+8Nw7EttG2hv5WLgeLXBmjvNIfKA+VJy3cM6UM80oudOaPDXZ3LkzFtLzuFpTrZWTHKC2Xs9Nr0psGg1PQTi5yda9a4zE2UnJlrHUkbGfMrydDKTmatGAuEJAFLzhmr8bRGoFVyYcTT9+U2yMP1BTWZL0Xl3k/KzMwbxTrGrh4ONYnn7SNtPjb8z6ABS3h5ucVajp5nbXjfX99E4pBG3eaWSqmLIp+P86v+eN04ZSw01dX19at+7igO2GBk1LCqvyroN4cjEwLLwana2dVB6TpfJToTCxUafXHkZ4fjXjOuL9OSQ6j1h8bZOjvDxbVWAEdyPPwLF+JywS3gu8qgUUrC78TsChlHQ7IQOra/V0I6vDNdJBTCWeDuCA80AGPE0eQZvzcFzd4XeZ3X5tzVAxNNnen3LjsEMten5aqlzA+uOifBGAGwTjKGp/071uG0rXzRYCOIU58eceKAy4r55qlPhOaMPZBHXLhvzvbbMJond9g1TpdTkX0XSulAkMaiVvLfIHDAy/kC2/E7Q2yepRVk/tk01xed42A+J9PFw+0oS5USnUvFdA3Mdnjs5F2ONyQgkpNUkqQ/O1iGNk0PpKHtcthgEzgrt8moMlGyXC9jOHXJRmHfNeZ
 eQWySIAF
 VrIWMq3fVTsWrBX7NuDMAqgKbCRghGfgcO1SMR93ojQepVLMn6ztQ/O3As7ysNHq046U+fD4cNohrGzdLdIM/hyK8E3V+eig2lppgtolDYqmgkxgWQoWhbRGrdFZYE5NzJ6lt4ko1rJ5ZDcl36sh/NJ3v/wuOrQKN5l8cyOj6oxe0pUpJWV9l4n+QnHS1G2qpbbRHbhmcVAIvlhPZOANLynVxzUaqy+W+qFzvG4CuFxowDAZIet1PIQzveNtjnlNcehK2nFdM6Eq4FlIwh5n7kpbCydS2bTYOop0D1iZ56OYaTM1C0j2JI4hhabub8M5xM9dFswuqp2Gc51BID6SS23cbfzsSRYZUlAyhBpd9TQnlWUVhP5Z+4EBnxqy6Ok8Y2AeN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Vitaly,

"Vitaly Wool" <vitaly.wool@konsulko.se> writes:

> From: Igor B <igor.b@beldev.am>
>
> The Rust blk-mq abstractions only cover what the null block driver
> needs: requests can be started and ended, but a driver cannot find out
> what a request asks for or reach its data.
>
> For a driver that actually transfers data we need:
>
> - A `bio` module with a `Bio` wrapper, an iterator over the bios of a
>   request and an iterator over the single-page segments of a bio, the
>   equivalent of rq_for_each_segment(). Segments can be copied to and
>   from a `Page` and zeroed, with bounds checks. Iteration goes through
>   two new C helpers wrapping bio_iter_iovec() and
>   bio_advance_iter_single(), so the multi-page bvec handling stays in
>   C.
>
> - `Request::command()`, `Request::sector()`, `Request::bytes()` and
>   `Request::bio_iter()`, exposing the operation, start sector, length
>   and bios of a request. REQ_OP_MASK is added as a constant helper,
>   since bindgen cannot evaluate it.
>
> - `GenDiskBuilder::max_hw_discard_sectors()` and
>   `GenDiskBuilder::discard_granularity()`, so drivers can advertise
>   discard support.
>
> These are used by the rbrd driver added in forthcoming patch.
>
> Signed-off-by: Igor Belousov <igor.b@beldev.am>
> Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.se>

I already submitted this [1]. I have a version rebased on v7.4 if you are
interested.


Best regards,
Andreas Hindborg


[1] https://lore.kernel.org/all/20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org/


