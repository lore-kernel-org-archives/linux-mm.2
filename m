Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E31AE7C6E8
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 20:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AFC2B6B0005; Sat, 31 Jan 2026 15:20:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AA9776B0088; Sat, 31 Jan 2026 15:20:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D67E6B008A; Sat, 31 Jan 2026 15:20:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 8FA5E6B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 15:20:43 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 1CFAC585FC
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:20:43 +0000 (UTC)
X-FDA: 84393377166.12.AA99FD6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id 68D69100005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:20:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=njAGVM34;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769890841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tyk+QJjn2aJIqhkAIPGGE/uejIqH5QKuwSZ/8WZL4r8=;
	b=5dxqR6FgopgJ0Qz/ZhhKZZWDZH+HR2P0xTZCqgvj8l0Pn9PCtHJ6/W0Gh2yF43N+J2igFg
	eABbX0Y6MVPif8fcTbN1xSLXWGgeaw25vvV749ErT/CAnUFe2BHlW89NVX0FTWiI6LpAkF
	+adRbSRdTsSsPnr3MCWBpKk1BzbCHnU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=njAGVM34;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769890841; a=rsa-sha256;
	cv=none;
	b=e7EOVK5BHetGIsaw6n7hGucifP8qt5oAN6tpnv2Vb/faAzGkFw4UrzyPDUWaiPGo01uNTk
	Te220ExI/bh3zpSBYVH+/xLU2A6ZNndMlk0ehv71zFUsGacSEsI88G3E9Wk3GjmHyBDQki
	STjTYZgnixQZwUYi3iEOrHLF46z5vwk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 548F7438AA;
	Sat, 31 Jan 2026 20:20:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37329C4CEF1;
	Sat, 31 Jan 2026 20:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769890840;
	bh=E+FjPUDD2STzZ2F+mu5i9jIX+oL2Q7gCtZ2tAaA3UF8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=njAGVM34VN4KkdyLiFE680zZD4k/uvAXGOGINgsC6VgUuisU/n9ObPoRQRUDjphqv
	 HZGoaTt49tMV4uNX1HjqLI4DPvO1fvdjKc23EW/BrOULSEsDG3EsSztB9ijEY+jewy
	 81Gaq5X7LpLBZ7cE/QSymvGg0zxdIOVzAOwkBu5hFQcqXTyyhm9gw8S9AitSduTMPN
	 BmQpFmTIaXYmg1mgQycVwQ2NkNE2leuu8N9w1RVhfXep8wv4tIw4W9Qj3E6aqdFbgH
	 BucEFwIjiW4LiMhzMNAE9JuxP2kjNAIH/k46rRlHQijdKZWHvKdS9MB/RdMq1L1VIp
	 2vbhPtqTez0zg==
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
In-Reply-To: <aX5YWdBxPmPrTLDA@tardis.local>
References: <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
 <-9VZ2SJWMomnT82Xqo2u9cSlvCYkjqUqNxfwWMTxKmah9afzYQsZfNeCs24bgYBJVw2kTN2K3YSLYGr6naR_YA==@protonmail.internalid>
 <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
 <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
 <-5tKAwUVrj6fo337a8NWsHQBepB07jKIVI-VafwW1zp0vsGTCkBTuI5nCBniftYJePZy8kb7bhWptJ2Gc_B-kQ==@protonmail.internalid>
 <aX0lcVngRcRwqgd5@tardis.local>
 <87pl6prkc6.fsf@t14s.mail-host-address-is-not-set>
 <DceHeOJQ2ZdVoA8jlWqMpTO6bHsSLi-JNu4iXSpnMetXsYWKkLkv7vGSdHqqNIVV4XnkW5SfReAA9dDoUENEIw==@protonmail.internalid>
 <aX4xNxsF5Qs0CTPW@tardis.local>
 <87jywxr42q.fsf@t14s.mail-host-address-is-not-set>
 <TFt9ABV5Iu9YWftctEzCIUk8W7mK1fVRsvxtIZi1ex8Eq1fi-Xc3SrNODFWkm9nHMB7ySTmcXCJT5cL2PW9kHA==@protonmail.internalid>
 <aX5YWdBxPmPrTLDA@tardis.local>
Date: Sat, 31 Jan 2026 21:20:29 +0100
Message-ID: <87ecn5r0tu.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 6ydyi9eyhxwfittddg3178s9xbxjd36i
X-Rspamd-Queue-Id: 68D69100005
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769890841-185263
X-HE-Meta: U2FsdGVkX1/9xnQNwLcKSQ2+EIAEHaMNPAvhmd8oEYTEJJH3fr2zs5ybkgxlPGkLGasm160Cukgiw1JNr8B6Ozz7rGOLuye9OHXgV4vuXWfgdPFBrhXgfodV0KxfDynEY/Nf85ES5S4L3+GHkttfpySLufxVp8MU5f6q7UL2h+2ziYPnJL+1uGL1MzKybkAVPVdgTEJSU8CckI9/TeZghzaFWFP9u74DJPGzL/0ZoeVGpBSb4OFvpr395EV07MWWPqCrw0lrz0lpplp6hrEBZxzsl0ZGHNNQsNElw4nXGN/CfRvc+k9SK6IAUX2FVhcmow5hOW6FIpk/y8nqvp6kxCEWQdcXrZkwEBQEb2grJgjlIp1SmkAgZJQsgkq7CqYu+Ttc2lTMte9hRGXJuTIpV7fSPzbIMVDpPD6kHLyFH45y3iXg26jQ8JZyRIr0lkgZEa+1+Vl0gN9CQ1GG8PSctuxoiMzt2TaUkga1WPBgqG6RH60xjvZ659q7+E0iUaOSNnbcTcVgN+OGXEuTHgchpNSIsb/fpB1m0ikW1s4KFRprmq1xXK/MY6F6wO3/9s/KYWAGdoTW5heAaUjHpyaxizKd/qBVM0NMcwd4q/7Q19th6GjSQdJfEbz/g3/lms+aJtRouxGOzZOJfAuqYVMR8Z9mYawZeCPygRYk0x5y/0iOG1S908m3NBHWx0wwZ8MQQJ1A34PcJFFdIH9B2MsNvF2wgfg6skWemxdD9C1pF1IGNkNinPHNiZCUZVmh7r2cgX7VRRHkyYh/TLylcu6W47ruwS43Cyh2kdWFoj47/x1x+7As9Ryqs8fRAxhyc//s/t7cUusNWzrJCKMxMYG/woUN8GrKOHWy/lEHXbvVTwk/ZCRlTTx7E23WjE0vLj9DH93HNrHwzJNE2PfsScboX6tvGvtQJtszEfMKpyrn19WKCXIMQUYpRLR2iQSO3zJfGtDlT6LjkoaSf5FU7DC
 KiGEnKDp
 SvC7UmhDnLLN18ExW3Ut0tozB1TlMQZCYHy/U4f47Ma6OqnsO+7ogbv81PPyT4W97pU3O6ffPRZ3uIO4McouD6n+H+Zi/ID+kVX7+eHUFwo/IAlFIKvIsE1TL8PQYOXSGoSXeDNqXO4Dg2vsDO7F4cxWtf2rbf78hYBwSU37+ogbyJ1GR6vKOMHmornV/wi4JNZjJtvd0Ngs1NXN0FQjDoeEHLyK0VL/yODC22jhih3xlgxvgu+9p/ixgZHSPMFIB3KJnQjrsyCrDlghzkgSYUqCHu7JTHxx3rY6M7WLrkn2CQtNPzePNKvTZoYvYAz+DK5APf7Xms788B0f41H58TObCxplhnYFHdv1QRCxf9RsVwyMPHeZpE65cVg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Boqun Feng" <boqun@kernel.org> writes:

> On Sat, Jan 31, 2026 at 08:10:21PM +0100, Andreas Hindborg wrote:
>> "Boqun Feng" <boqun@kernel.org> writes:
>>
>> > On Sat, Jan 31, 2026 at 02:19:05PM +0100, Andreas Hindborg wrote:
>> > [..]
>> >> >
>> >> > However, byte-wise atomic memcpy will be more defined without paying any
>> >> > extra penalty.
>> >>
>> >> Could you explain the additional penalty of `core::ptr::read_volatile`
>> >> vs `kernel::sync::atomic::Atomic::load` with  relaxed ordering?
>> >>
>> >
>> > I don't understand your question, so allow me to explain what I meant:
>> > for the sake of discussion, let's assume we have both
>> >
>> > 	fn volatile_copy_memory(src: *mut u8, dst: *mut u8, count: usize)
>> >
>> > and
>> >
>> > 	fn volatile_byte_wise_atomic_copy_memory(<same signature>, ordering: Ordering)
>> >
>> > implemented. What I meant was to the best of my knowledge, when ordering
>> > = Relaxed, these two would generate the exact same code because all the
>> > architectures that I'm aware of have byte wise atomicity in the
>> > load/store instructions. And compared to volatile_copy_memory(),
>> > volatile_byte_wise_atomic_copy_memory() can bear the race with another
>> > volatile_byte_wise_atomic_copy_memory() or any other atomic access
>> > (meaning that's not a UB). So I'd prefer using that if we have it.
>>
>> Ok, thanks for clarifying. I assumed you were referring to the other
>> functions I mentioned, because they exist in `kernel` or `core`.
>> `volatile_copy_memory` is unstable in `core`, and as far as I know
>> `volatile_byte_wise_atomic_copy_memory` does not exist.
>
> I was using volatile_byte_wise_atomic_copy_memory() to represent the
> concept that we have a volatile byte-wise atomic memcpy. I was trying to
> discuss the performance difference (which is 0) between a "volatile
> memory copy" and "a volatile byte-wise atomic memory copy" based on
> these concepts to answer your question about the "penalty" part of my
> previous reply.
>
>>
>> When you wrote `read_volatile`, I assumed you meant
>> `core::ptr::read_volatile`, and the atomics we have are
>> `kernel::sync::atomic::*`.
>
> It was the curse of knowledge, when I referred to "byte-wise atomic
> memcpy", I meant the concept of this [1], i.e. a memcpy that provides
> atomicity of each byte.
>
> [1]: https://www.open-std.org/jtc1/sc22/wg21/docs/papers/2022/p1478r7.html
>
>>
>> So now I am a bit confused as to what method you think is usable here.
>> Is it something we need to implement?
>>
>
> First, since the length of the copy is not fixed, we will need something
> like `volatile_copy_memcpy()` to handle that. So I need to take back my
> previous suggestion about using `read_volatile()`, not because it would
> cause UB, but because it doesn't handle variable lengths.

We could call it in a loop? Would that be inefficient?

>
> But if there could be a concurrent writer to the page we are copying
> from, we need a `volatile_byte_wise_atomic_copy_memory()` that we need
> either implement on our own or ask Rust to provide one.
>
> Does this help?

Yes, this is all super helpful and much appreciated. Thanks!


Best regards,
Andreas Hindborg




