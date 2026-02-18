Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8B6AFE9A03E
	for <linux-mm@archiver.kernel.org>; Wed, 18 Feb 2026 08:48:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BF8136B0088; Wed, 18 Feb 2026 03:48:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA5916B0089; Wed, 18 Feb 2026 03:48:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB1EC6B008A; Wed, 18 Feb 2026 03:48:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 975326B0088
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 03:48:08 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 39D13B6FA1
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:48:08 +0000 (UTC)
X-FDA: 84456950256.19.BDB4406
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 748FB2000A
	for <linux-mm@kvack.org>; Wed, 18 Feb 2026 08:48:06 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QLyKHTN/";
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771404486;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k9PqqN5H5le5fCu01Yp11wurKO3JlCjDqu0u+gfwrdc=;
	b=1bPY28EFv2Z4g/AYTLJZU9DYeZacJbX9k4/9Z65FsePTFpbHdNyWi8ig2PJ6TMJbGnFqbT
	1HbAmUiSFHHV8eqM2roZUCKrqr+knd6Q9yC4WdrGwM34/g93e3e+E8R9fLRy431oIrw1jt
	UjMMlydaYPgr2t3CGb43G/pewSw1WOQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="QLyKHTN/";
	spf=pass (imf13.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771404486; a=rsa-sha256;
	cv=none;
	b=GX7/Qef3r/3Nk8N3NMShkfYJHok2vLObqLc5E8Azdc67I2AwOSlbDUUYGfU8hh2kVTKgkN
	GTTTSn8xttV9ruQTkaNUNqbe7daIURUnozW9X6yDUFFteIReBvLU/Kzw76OKg78295DQU/
	nXd54PDYULP9xgkhscFxYIuvn5gn+0E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 67F12440FF;
	Wed, 18 Feb 2026 08:48:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18396C19421;
	Wed, 18 Feb 2026 08:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771404485;
	bh=k9PqqN5H5le5fCu01Yp11wurKO3JlCjDqu0u+gfwrdc=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=QLyKHTN/WcYxDps1vUTTG/pvRsmR1zHm4LrOU2+MVlj3Egjy7iUD0yuVIeKYgeGM1
	 2C10zi9i/kF4lUTnwl/KD2xWGYZd7vlZr1udS67y85oUeDIKVUnLQtbnqBV9nux8yR
	 yymvgmWkvtxUeK3Z7JYun6SHJEQfEdMjSwEgLZqF93thhCUPFjhaOIROefxEwYwaTu
	 QHSldpty3bvTX5G7R/QD52f/wb5KX1FlfHv+du+xqmU5wznk6Mi9AogVeANhQIXgGm
	 awjSU7ctNGxiA2gQGHIdkySgII/JpYJQ/wDtcP/dVlrVZdaQPiSznTVrrVA8D/ASoK
	 xRcxGJhRihHOw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>, Daniel Gomez
 <da.gomez@kernel.org>, linux-mm@kvack.org,
 lsf-pc@lists.linux-foundation.org, Alice Ryhl <aliceryhl@google.com>,
 Andrew Morton <akpm@linux-foundation.org>, Daniel Gomez
 <da.gomez@samsung.com>, gost.dev@samsung.com, Greg KH
 <gregkh@linuxfoundation.org>, Julia Lawall <julia.lawall@inria.fr>, Kairui
 Song <kasong@tencent.com>, Luis Chamberlain <mcgrof@kernel.org>, Miguel
 Ojeda <ojeda@kernel.org>, rust-for-linux@vger.kernel.org, Tamir
 Duberstein <tamird@gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Evaluating Rust for XArray
In-Reply-To: <CANiq72nTOpGw6JhrMLK47+7TCJjrLRdNebctrmj5xO6yqAqSuQ@mail.gmail.com>
References: <aZRncP-sKLLS2K1U@macos>
 <ix0mR76G9a_ieuQUUkkfHMJIviAsrFaO859172fuFx9Goj7QdIfz1jtnv3ptubGEC7uEFCvVfEoWxcisUnTi1g==@protonmail.internalid>
 <aZR-ItMBkiqyBdKd@casper.infradead.org> <87bjhncl7j.fsf@kernel.org>
 <-MAJTecRs9k_Y3XGSFfdzJ3acTO2nemK8gQMmbYlAc40NjtX0hr75PYmNqNA9rA8QmGOtvZw8oIsyQzpmPxf9g==@protonmail.internalid>
 <CANiq72nTOpGw6JhrMLK47+7TCJjrLRdNebctrmj5xO6yqAqSuQ@mail.gmail.com>
Date: Wed, 18 Feb 2026 09:47:26 +0100
Message-ID: <87y0kqbfq9.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 748FB2000A
X-Stat-Signature: 6mxst4mr9yxyztk4cz995jybox6ww6fa
X-HE-Tag: 1771404486-434467
X-HE-Meta: U2FsdGVkX18RE3mv9CmJMt4UxQb4qxRjW4GV1HsGCLj9et0IYYKZGZOVyl8kMGpt/gf5HaJgJD5HopV/HkDdXH728W+m555zhVnjWj9iNc8oEgKbH5roY/8riQ4HiV1im2TODE5f66g31cjFV0oyVMkitX/xL71RqXf5TRdEBkaRg++GkUTneOlzPhixl/uxWbUR6WV1dRL2/INLfX3v/PsJDr84fuM89/AFC4zCKPrSvS/dtAe/I6eH9Z5Y7eKENTlOHayGijGUsFXEUpEe/uraBzyb/0Iv6BMfbrNpPEARc6Jwt0U8enSlBW2UU9HMkglOCt7uJeqNekWV3tj8tYmp1jfkDPnRrQFdRXUvpjSgdLvOpq8hZXYFSg77BsQaI9nsd9SxoFtzGRMBHMxcpWM7Zh8+y1NS0h1pU6tMzY9wuowsDt72xc4BZX6mI8E//bQUdzGR45uk3Lflf5y0jdEd9qDq8EKN9+6Bx6M4T4Hsqe0/dGOY6RArjQwMJ2m+ji2pLxniVncFcD0rI5HznGKNcoOQBPGwhIJ6h6K57qxkzSagrFj8RZw/cfz0jDhyAuVefG/DY2oW0Vm6bAYCuYWIiilrwThCglBhuG032oB49HjDjus6734Czs4T4YMiuH3mcrTgFVABrFmBjVZGQG4S65kYmH4JntGoyUiQuTCRIE5jajfOCSi3GsoyRNohrVzL1ZlFaXHzfgIWYhzRCdmVb+/WW9RVW1DsclSztPD24SQ/FEeWGsSOb8UP3dHZ1l5fZfNWhF4UxF9Q+M0jfIY8SpGAIrCiOp/IcXz/4oXwdca92k+YzVRZvECOudCgDtiKrgj25t6kVMU9YjtpgJvyTxdjLuOrz/1mNOXXh2J9NBa7jqK+4kAWjGVgq7GPxb1ZpEDaRVSv3Uaa40+csrQJWExE2fWt65xJYbd8VXBL0bzGFw+8Pd4B+lPQhfrZpg5XcZfcs2HjpE2YqOL
 ocKITj4m
 aTvfb9KnxcrD9p52uZxPAWxECDdxpjpa7mGEmayiy5RybRwrbEZeaDFXh0WX79lL9olxmMYqDg3dQr2JOvoJz9IG7ODHRVcvmDRcn7VkDu5ZTOcH2li5skvt72FF//jHjx8b8J7ogqjuG3lvGELSnzcqBNoUiY9sJuP3a/yaMNFo0nUmLwIH6Zvbpgr/JhGqH1ZsfsNOb6pKJcFUEbTcNNRlvdY4oO5RMqtViZjYeyq5r5fMXIeewtJ/z6XCMt+DEmESVT6ux0oJBkdWrMTHoG6/v0VaIy6f8Gfr1BNOknY+Lumi4IuanDSQVMQtu3/3wt36/L2mKy0az6RnYC+MWqJg5G7GR09Q5IgBbh8c1ugGJn6dBWOvdPUvzbg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Miguel Ojeda" <miguel.ojeda.sandonis@gmail.com> writes:

> On Tue, Feb 17, 2026 at 6:51=E2=80=AFPM Andreas Hindborg <a.hindborg@kern=
el.org> wrote:
>>
>> We can, and should, start evaluating if we
>> can deploy Rust in this area now. We might find that we are lacking
>> something from the Rust language to do what we want. We can work with
>> the Rust developers to make sure that the Rust language gets all the
>> bells and whistles that it needs, to support the use cases we have for
>> the Linux kernel.
>
> To clarify for others that may not have the context...
>
> We are already working with upstream Rust (and have been for years
> now) on improving the Rust language for the Linux kernel. We have
> regular meetings with them every two weeks, and have a shared roadmap.
>
> To give a sense of the collaboration status, some major language
> features are getting developed with/for/by the Linux kernel and the
> kernel is even built in their pre-merge CI.
>
> In terms of discovering features needed, I don't think there will be
> big surprises there, given all the work done so far. But if the plan
> is to expose a C API, then we may actually find we want new things
> from the C language instead! :)

I can lead with an example of what I mean.

The C xarray uses a few different node types internally. Pointers to
these nodes encode information about how to decode the pointee, in the
lower two bits of the pointer. This is possible because of alignment
guarantees of the pointee. It's a neat trick, basically implementing the
pointer as a tagged union, without requiring extra memory for the tag.

In Rust, enums are tagged unions implemented by the compiler. This is
necessary to provide memory safety and avoid type confusion bugs. The
compiler will usually implement the discriminant as an extra word.
Sometimes it is able to optimize the encoding of the discriminant to
avoid this extra word. This is the case for the `Option<NonNull<_>>`
type for instance. The compiler knows that `NonNull` never uses the bit
pattern of all zeroes, and it assigns that bit pattern to be the `None`
variant of the `Option<_>` type. All bit patterns that are not all zero
will be the `Some(NonNull)` variant.

But the rust compiler is not currently able to utilize knowledge about
alignment to encode tagged union discriminant in the lower order bits of
a pointer. So when we implement xarray internal node pointers in Rust
today, we do so the same way the C code does it; by manipulating a
pointer value and injecting metadata into the lower order bits. This is
of course an unsafe operation, because dereferencing a pointer that has
been manipulated in this way can lead to loads or stores to arbitrary
places, if done wrong.

We talked to our contact points with upstream Rust about this, and they
believe the compiler and language could be made able to do this in a
safe way.

We will try to push for this optimization to be available in the
compiler, because it gives everyone a safe way to access this trick. And
it would allow us to cut a big chunk of unsafe code from our Rust XArray
implementation. Memory safety is one of the reasons for looking into
this work, after all.

Not having this optimization does not mean that Rust is not ready. But
if we can get it, it would be great.

I can't tell if we will run into more situations like this one when we
try to apply Rust in various places in the kernel. And this is one of
the reasons that we should do this work.


Best regards,
Andreas Hindborg



