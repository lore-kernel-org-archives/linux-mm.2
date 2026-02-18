Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DD82E9A02C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 14:42:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0A96B008A; Wed, 18 Feb 2026 09:42:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E63976B0089; Wed, 18 Feb 2026 09:42:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D608D6B008A; Wed, 18 Feb 2026 09:42:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C15506B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 09:42:31 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 6BCD7885B8
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 14:42:31 +0000 (UTC)
X-FDA: 84457843302.27.A0E1689
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id A24AB1C000F
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 14:42:29 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOuraL88;
	spf=pass (imf21.hostedemail.com: domain of lossin@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=lossin@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771425749;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PZoN6rgqXFANwvlFQuV5YKsznFFpjqxGG6yysl7W1Mg=;
	b=4zTHJ0adU3eBvvodZJXr13GKFCW/KHiMGdFqKwK5O39efHNAEoxB5265MF0xoHYNv45VNh
	EE+NUOqI5vZsdruuopzQW9KmWKXz7lBx9wie1u0YU2U+xIK5oiUOqSuwD1p2noDr4m9rii
	AkHrjQjCCFN+CjHZkdFwz/E7/ydi0/A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=WOuraL88;
	spf=pass (imf21.hostedemail.com: domain of lossin@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=lossin@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771425749; a=rsa-sha256;
	cv=none;
	b=y2Gl3SwVMd3Sd2Uq2fw3b7FNFUk7Vmqj3dVg/Iy8gQGBjCwBAaeSrNJ4iUnXUqVbXjQanE
	nbFiNas/u2/sogfZRZ/RkHch2x1duDRrSApSjc4m/KXz0JANYBR+RZXFNpHxdm80RRVu1b
	1DDVtLbmebS0JbxUhUtV31hLXYkxNV4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E697C600AE;
	Wed, 18 Feb 2026 14:42:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 538D6C116D0;
	Wed, 18 Feb 2026 14:42:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771425748;
	bh=6GPMVdt+2peIzfNOCgaGLfLM2Thd6H8NgtP6G0RDwEg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=WOuraL88EbRfrvLI1WBAyqV6X1XC3KTqovM1+IdLWw5Rcd/bInss17hx4iZLH8YzR
	 PdtMHLan4I9P7JhvOvEhDqv4mVBgfhaKg7Ceh2KaQMs7BSfXxt8Z2FRvdznrzwDxA2
	 nVoZSFzVtHd7J82khdVqpnmsHzKxOMM7z0g70b2hAhRwuUTvd3ej5omsZ3zXcphzSQ
	 o1Au9Ip8mxgLVlblTAo647x7SRcp6PtkoGiEcT4HysQW2j53ecV4CBhVWivu8KMv5+
	 Z8BE+o/9fHcQVjyBT1C8n9li8Oyl4qZhAQQT8ukbxUuY9qbcOlx+TfH2VvJL3LXh+Z
	 EqqCOHsOty3bA==
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Wed, 18 Feb 2026 15:42:23 +0100
Message-Id: <DGI60O54OUA2.3ULIYWOL6YO5Q@kernel.org>
From: "Benno Lossin" <lossin@kernel.org>
To: "Alice Ryhl" <aliceryhl@google.com>, "Miguel Ojeda"
 <miguel.ojeda.sandonis@gmail.com>
Cc: "Andreas Hindborg" <a.hindborg@kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 "Miguel Ojeda" <ojeda@kernel.org>, "Boqun Feng" <boqun.feng@gmail.com>,
 "Gary Guo" <gary@garyguo.net>, =?utf-8?q?Bj=C3=B6rn_Roy_Baron?=
 <bjorn3_gh@protonmail.com>, "Trevor Gross" <tmgross@umich.edu>, "Danilo
 Krummrich" <dakr@kernel.org>, "Will Deacon" <will@kernel.org>, "Peter
 Zijlstra" <peterz@infradead.org>, "Mark Rutland" <mark.rutland@arm.com>,
 <linux-mm@kvack.org>, <rust-for-linux@vger.kernel.org>,
 <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v3] rust: page: add byte-wise atomic memory copy methods
X-Mailer: aerc 0.21.0
References: <20260213-page-volatile-io-v3-1-d60487b04d40@kernel.org>
 <CANiq72=5r2miRm6GWszb2gDNi4k5-RZUzvdOdFQ3yyndvmHbAA@mail.gmail.com>
 <CAH5fLgi6NVagOPA_=r7Dmk9MFXrvZVuq85D9bsJfUqLNOZjCaA@mail.gmail.com>
In-Reply-To: <CAH5fLgi6NVagOPA_=r7Dmk9MFXrvZVuq85D9bsJfUqLNOZjCaA@mail.gmail.com>
X-Stat-Signature: c4brqadadgbhd41xq13qic1z53upq176
X-Rspam-User: 
X-Rspamd-Queue-Id: A24AB1C000F
X-Rspamd-Server: rspam01
X-HE-Tag: 1771425749-499481
X-HE-Meta: U2FsdGVkX1+yZvD5bZmTy9Ae5Bk7huX7ahCW8ITYQlay9dF50eOL3ItCoOFExgiUrQtMMzsGVTmpkNGnaw20utHZyWIdBV7V3D3YUSvBcMQFLHzKTjQxMEzzDv777a9Ev6kRbh5VDzia0/aaAQsHoPCFBiNiXJAhpJy1basbHkbtFk1FWA1KBnY3V9Yb4JJ65U9Z2/3xyJ+Ftm96VwQwpSlqOyku7/26XMYejG8d8n6DwCWu8j585prTO76yIMseIoAQ8dOA0lgilxqP2g7oKkBr2H4K9eC9bq6Er+L0tutaOXPO8GwVWw+1GLB0bSjo54iRiOWc2QBzfERtn4lDbRK912e3RbmPAhZTO+mE2T1Cog2QLKCvGCE6y9wV5eLoG1Z6Jq21BpJMzxr+1rZYnbIFOnWXkapvhEcGmiNIADeh5Z6YFXNMxLeXPZiBbA4jsbck3pBklEnyOjhXVYrLkTQfXkAZcAsRfrbpluaC/3ed0LSSV65U3Svpvje57kYlVZ+EzWXzOhPADvSXTm0aQYL6OF56QFfp+iXfkYVjq3hKEgz5C9bWvULrLQq2AkowArpcl5D/vX6z996fbdji0SluJi+P/07bdo3jBWznjmcU3OFPgpfTKF5N4ShzJiwcLhOr85UbLRSyJE6gwZIVkk/9ThI+UddszCPSFJ/lRmIFrSKryZnDvLmZDsYpXOowivcspF3UD1e78BVvFqUzxLnyuzOzDX7iMdK3Pg8DZJoum0iIKRwYtfU8mrx8Ugoq9QzMKQLHEwwArL4tDq5aPZ9H+RoGRzAjtrC1smtIVWCwINkz6BsGkj6w+1Gh7Eh7+OiQBuNkxkAgvfkuuMs0tUB7y+glGmJaNnDc3tZ9+j27pnX1zuI1npFOQuJozykBWFOg8oO4wgE1wY0us0MR8oA4GFT1vqvwZ87pUZIA/aKkPYMMBLaHXtQ85Nfw/Pn0WpaiMVegsyK0HMs5Cv+
 bFNmj1H9
 X5zWhf70MtZmLIhUbvWSh8VB4p2oZxmXEWkh9SFU7+zAXuZLqDodX7mG95bwy0OIE4zmiZe87u1oTSi7gzrN7M+UZU6kuAR9TRk6Iij6JLhB/IGprXL+lt1ILKaguh+WgNaH+EkfikVZbTVaNkPJ3mBTt1JdjVOaDTdALMII2aEKB6rXCI5A4vT+j1miJDh+3Qcx4023qM1L/XmPnfFRrXfl7RDpCUWElBeG6dM5sqQJElkiQZZt4sBYvmbG5Q7GzheTvFV6uGqfcNBJpA+QxHvrIZaEBnPhxqV647OsV+Q8mkCPlZtnc75M07wwQnE56MyidWMd3PP31IZj95luYKdpLvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed Feb 18, 2026 at 1:00 PM CET, Alice Ryhl wrote:
> On Wed, Feb 18, 2026 at 12:57=E2=80=AFPM Miguel Ojeda
> <miguel.ojeda.sandonis@gmail.com> wrote:
>> > +    /// - For the duration of the call, other accesses to the areas d=
escribed by `src` and `len`,
>> > +    ///   must not cause data races (defined by [`LKMM`]) against ato=
mic operations executed by this
>> > +    ///   function. Note that if all other accesses are atomic, then =
this safety requirement is
>> > +    ///   trivially fulfilled.
>>
>> And, for this one, Benno said perhaps we should introduce a shorthand.
>
> valid for atomic reads?

Yes, in particular it should be folded in with the "valid for reads"
above, since that would otherwise be conflicting.

Cheers,
Benno

