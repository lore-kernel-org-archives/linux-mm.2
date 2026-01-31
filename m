Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF5ADD73EB5
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 19:10:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39CA46B0005; Sat, 31 Jan 2026 14:10:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34A8E6B0088; Sat, 31 Jan 2026 14:10:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 22B826B008A; Sat, 31 Jan 2026 14:10:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 134796B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 14:10:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A9608B95A9
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:10:35 +0000 (UTC)
X-FDA: 84393200430.13.C737192
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 11E86180010
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 19:10:33 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F9t642e2;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769886634;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qnUkiF8z1OkRyWv5A0exU/H6xrjIzHn/7h/Sk+Uz1r0=;
	b=LSJ4PW3Gvj2Qsewh6zG759KVdgIpyF/7kROYYUBM8RFNmNY6Vs20nwpp2QPayMNxDtfghk
	t/6BsFobA8om8CMnV1vSmLbvVnoifXribN99+gXtRNAi0fhPCrlCDgNHyy1JvTP3L0eda9
	Zi6Ofb+wN/HSVlCS7jlgXC+4+SFEuYo=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F9t642e2;
	spf=pass (imf24.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769886634; a=rsa-sha256;
	cv=none;
	b=Pxvcz5d5w4H2dQRgDHWP05VMqIYlOhaHaRrCsuYVNxaLULnuEf8WoBHUEr+wy90uVCr93/
	GadYREp5n4834ltDrBPhNLZI40YR1xUL5t+tehWIJ+hzRLmBT2KVnXnp05VUq4C53EB0gr
	gmCd6ynSizaF0b9pPIN9QRQwC/FzAH4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C7A8F40E21;
	Sat, 31 Jan 2026 19:10:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8F2CC4CEF1;
	Sat, 31 Jan 2026 19:10:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769886632;
	bh=GGsWzZCvO7JDVG/sUiBEb6ZMfj04oe5Kx7B5vtwqH8M=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=F9t642e2FWm0TcW3noTOKtWECPb42kH34miAwJu2QzuEQFkQiGjwIV8d96l1Y40mS
	 a/DEKfnr+blfZAuPEYYmvBaBlvcPlXs7yJUt2DQRKe/uXqEVqc5RGeVFFHNhWLzUZx
	 XmhROLl1Tn6eCVxmo9XxpFd/EQTwfiS30oTR+rspmbZExgCwESllrrCoaCcvV4TO0B
	 VmX4vB0oC2CGuY7O5Dcnw0GRHjYiyFeamLR2gG9y79QZf0s28p9Zr+uXGiYxCeKgnf
	 b/v53F6Ws/fkUio1yYuCijcL7Qu/QLodMKdNkuDzqU6NFd2wTwMhiVWPORbjUyyRtJ
	 xlamI8AAmEYhg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Boqun Feng <boqun@kernel.org>
Cc: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng
 <boqun.feng@gmail.com>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno
 Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>,
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
In-Reply-To: <aX4xNxsF5Qs0CTPW@tardis.local>
References: <874io3rwl3.fsf@t14s.mail-host-address-is-not-set>
 <iFJVkpTMbd-NR24OHYTJj8lr4dw7MwCQ9rJWiuRZFgK3JRDhIIAcpf5Z24viL5qHhkrPzpnKfvX7JS6X_VO2vg==@protonmail.internalid>
 <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net>
 <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
 <-9VZ2SJWMomnT82Xqo2u9cSlvCYkjqUqNxfwWMTxKmah9afzYQsZfNeCs24bgYBJVw2kTN2K3YSLYGr6naR_YA==@protonmail.internalid>
 <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
 <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
 <-5tKAwUVrj6fo337a8NWsHQBepB07jKIVI-VafwW1zp0vsGTCkBTuI5nCBniftYJePZy8kb7bhWptJ2Gc_B-kQ==@protonmail.internalid>
 <aX0lcVngRcRwqgd5@tardis.local>
 <87pl6prkc6.fsf@t14s.mail-host-address-is-not-set>
 <DceHeOJQ2ZdVoA8jlWqMpTO6bHsSLi-JNu4iXSpnMetXsYWKkLkv7vGSdHqqNIVV4XnkW5SfReAA9dDoUENEIw==@protonmail.internalid>
 <aX4xNxsF5Qs0CTPW@tardis.local>
Date: Sat, 31 Jan 2026 20:10:21 +0100
Message-ID: <87jywxr42q.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 11E86180010
X-Stat-Signature: qga8o856g1xowfcsh44cpamqdxxnki93
X-Rspam-User: 
X-HE-Tag: 1769886633-73984
X-HE-Meta: U2FsdGVkX19SllfSHDZu2W1GUOUa6rlJF2J63fvCzMapD5RmjYOsfT6wT4hrih2tEzXDTVrjJsp/8YCgP/2Jk+y+5aGGaMymgowQurJKlrAgGsRylOdAQXQn5KdMLeu/gdh7Fb0+c5lG3u2pnpY4mjn35PpMkPd5CAcL4vka1llM1Medrn/5DY4B+NZrPEhsDUfXnurhfP9Gj7kto8n16X9haO6E3Jc9hlAk6F1/aeYhiQcPn9jMd+imjGq2tNYYnS3H1/Ra1iYLBuT3496lZoGO+C5/1XSplxl7B+ig2e4VJuXKhIdYQQOzuKSctYDtdGMvYFASQMcgb/75nEOMHI9DQ7tQ2lAOtk+3t0d8QWK16zuKAj87KxdTCNeSq8YCt5NEY6PT3GTD2lRKk0Qhp7RL7mSzVJMvZR4ZGsTlbwopA79g8go8f8896nOh2H0Ckx9qcaTHI/R/yewfjU18A4cEfMhFML89DHhUQ6IHAhzRIou2gaBusjLi20f4SfdF8uVxXVyym1BIthimNpEWPf6bPHi92XrFrzOL4HG/nJ3fnwIGfUILpSonZP4WlnuoqU4UDuyoT5JTVxQgl/1hYKsgGp+h01eB+cx4PfS80thnckyDMtKIDmBVVF0fFleoBnEAIqDpjQFw4RGvuEuQHiq1Q0b0QBsgoPGBCt+ByoXpltKCFfMJrnXcpTRpwSVSxGX/S5caM5I1lIgeiDWIFUUOs+Hrm6wvg2inS9fja961QhxabfB6UYjuIen4O9WDkNrBpZod9AkIqPRCLBxdY8LthJ5gcr4u5iuvmMZr5pV+lgEbUl4PNhKjfqwuG5VxqHPYu6d5ntqxx5Y71FdZ8QPfwdIvPkr1sAZB9Rf1muOKdU9sOYykEymlclzBmTB6tFrGD/wEV+AkjmszvHrK3u2fhqBBhpPTzChiS3aSUvnBUY+7yJobhwPf5g6Yj1Yk3ljwV8YsXOadXcuLupf
 5iQmhpVr
 B/7uEy2dtdWzXl/+ubICNquGH/IRIDEhhoHV/N6cnvPQLITZum4HTKr6sqcL9wgLxg0JkVCXg1cZ8plrQX49pixdRgcCHvjtY/z9EcKn9JRApjxqUUGY9Kf6jQRpD2970zqRjshHwKLKOYEbL0UlI4YaEIexVjewXi6gCHQA/8XK/TrzlMpyzGkXGmQ7P2F1Ko5Pul/HEe6XBjvwqZ+AAfsmDn42DvwOYrS+zWgHqslUR0/vZSItRLzcofeErjRrDt32b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Boqun Feng" <boqun@kernel.org> writes:

> On Sat, Jan 31, 2026 at 02:19:05PM +0100, Andreas Hindborg wrote:
> [..]
>> >
>> > However, byte-wise atomic memcpy will be more defined without paying any
>> > extra penalty.
>>
>> Could you explain the additional penalty of `core::ptr::read_volatile`
>> vs `kernel::sync::atomic::Atomic::load` with  relaxed ordering?
>>
>
> I don't understand your question, so allow me to explain what I meant:
> for the sake of discussion, let's assume we have both
>
> 	fn volatile_copy_memory(src: *mut u8, dst: *mut u8, count: usize)
>
> and
>
> 	fn volatile_byte_wise_atomic_copy_memory(<same signature>, ordering: Ordering)
>
> implemented. What I meant was to the best of my knowledge, when ordering
> = Relaxed, these two would generate the exact same code because all the
> architectures that I'm aware of have byte wise atomicity in the
> load/store instructions. And compared to volatile_copy_memory(),
> volatile_byte_wise_atomic_copy_memory() can bear the race with another
> volatile_byte_wise_atomic_copy_memory() or any other atomic access
> (meaning that's not a UB). So I'd prefer using that if we have it.

Ok, thanks for clarifying. I assumed you were referring to the other
functions I mentioned, because they exist in `kernel` or `core`.
`volatile_copy_memory` is unstable in `core`, and as far as I know
`volatile_byte_wise_atomic_copy_memory` does not exist.

When you wrote `read_volatile`, I assumed you meant
`core::ptr::read_volatile`, and the atomics we have are
`kernel::sync::atomic::*`.

So now I am a bit confused as to what method you think is usable here.
Is it something we need to implement?

Best regards,
Andreas Hindborg




