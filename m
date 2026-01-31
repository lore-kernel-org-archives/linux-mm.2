Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 71B9AD79768
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 13:19:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B114A6B0005; Sat, 31 Jan 2026 08:19:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ABF546B0088; Sat, 31 Jan 2026 08:19:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CAEF6B008A; Sat, 31 Jan 2026 08:19:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 887726B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 08:19:55 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 240C38C466
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 13:19:55 +0000 (UTC)
X-FDA: 84392316750.30.D254366
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id A063FC0010
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 13:19:53 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=raFdNyNK;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769865593;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=42ZhvGn6Ldwsir1A/eISvM0nMj9AmxxF0WoqQk7o1t0=;
	b=IJ6iM2p7azBulzwe262RYCkaGTZpBKsDaLFDGlZJyW7hlB7gIj2GTzCNud/O8MKU0cAniB
	LXX5XVYvRRiLu5mH2AJDipsEazFiGTCbHixzyD3v7QNu1VvtwlsgkPqBWjvXU13Y16BT7+
	kvQ0A7kJ9Pvw709IIoOF++PAXb2hU0o=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=raFdNyNK;
	spf=pass (imf28.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769865593; a=rsa-sha256;
	cv=none;
	b=b2TcrkXtqfrZgzp0kxq4yGuBqMjyGtaVc2f1XAbIOie3y98FyZzL781WGwZYQhOEdoOexe
	hMLp60kG8/iyygXCrG/j3AnLGPH4a74H18m8pldxoqmZf3W4prpRcVrRoZmGZIM5Zx4a9B
	CjqH/MnZ4Kx/xO1GfJuEaQTHY9ZjCKI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D54BE60008;
	Sat, 31 Jan 2026 13:19:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DE5C4CEF1;
	Sat, 31 Jan 2026 13:19:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769865592;
	bh=hpLMprqmU96X1jlEjOAIBVjg0zmuYcko4wHzx0pcMwg=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=raFdNyNKMhvljTagI6mgSaAkzFUiAQdloKJFOxJbSez5j31aU8E/DTwo+EOOMZ6qC
	 Eia1kN7gmmD6hOSTNRd3z7H3i5915JdEvv83h+QiY42kHhcxBlyxu0kHOfnTsvFFGG
	 UH8PxeBfHsj/fWJu0+N8J5KAKKn8KYoFGlg2iC86w4Y6b57cEz9JdLKjqsE1F8M5Pu
	 0V1fLk3ArMKaZ3U1PA48j55HoRFoE9JH2wgF3WOaf5fUmx/0jP8/ipvPqn0ToW/m4t
	 9vqFDFEAdEC4gepMXUsjnjloH2HKMXWzOGSHiu4wAYn85hv2HqAInN5q+RBN19E8ON
	 s0Ui3TAK6Ku6A==
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
In-Reply-To: <aX0lcVngRcRwqgd5@tardis.local>
References: <877bszrz37.fsf@t14s.mail-host-address-is-not-set>
 <a8nHDdzac5l20akcxjjf9w7huObjn4eIHjUI-A17aKEwWl1N-4vvLBiVdqTQbBHwypMIA6gNkzm8YFXmMl44ew==@protonmail.internalid>
 <DG1ZJ1350EMS.1S1360PA496QG@garyguo.net>
 <874io3rwl3.fsf@t14s.mail-host-address-is-not-set>
 <iFJVkpTMbd-NR24OHYTJj8lr4dw7MwCQ9rJWiuRZFgK3JRDhIIAcpf5Z24viL5qHhkrPzpnKfvX7JS6X_VO2vg==@protonmail.internalid>
 <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net>
 <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
 <-9VZ2SJWMomnT82Xqo2u9cSlvCYkjqUqNxfwWMTxKmah9afzYQsZfNeCs24bgYBJVw2kTN2K3YSLYGr6naR_YA==@protonmail.internalid>
 <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
 <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
 <-5tKAwUVrj6fo337a8NWsHQBepB07jKIVI-VafwW1zp0vsGTCkBTuI5nCBniftYJePZy8kb7bhWptJ2Gc_B-kQ==@protonmail.internalid>
 <aX0lcVngRcRwqgd5@tardis.local>
Date: Sat, 31 Jan 2026 14:19:05 +0100
Message-ID: <87pl6prkc6.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A063FC0010
X-Stat-Signature: z31pdpkhb16ghyyggxx79kjxjfuma8et
X-Rspam-User: 
X-HE-Tag: 1769865593-10845
X-HE-Meta: U2FsdGVkX1/VGeuIW9eALmtGh2Vu4UcnUBzgvMfUK5yqyR/4hJXFAgZa1pBFu43hnObo16cFTy31mHO2gtgHlECQVeMKY6qZ0elGeO8A1R8bBig2tWZ7m9X4A8CZQqkNn3utYUYxl1hTEuf+VhQoDiQpeQkWLshygGpTzOUHyLuZ2y/vb95zn4Gh6spfiuXphH6StEe0gHiPSimowLeDAHQ6Krj3cdXAviNd17cJvoMOzrUI6TM8oF4rwlCP88tPtXwLXcYa2IBW6l71xKZ3Zn8Jp0JfxQVMdZ2ct05ZTyj+00YAnFNyYiNbUPLG39nAgPom12YQDLfa3sa+1RuSaPuY8QwmjkR7+igtouRZdlbS4itsO88qDgIq1rIDJJ02Qsl0tMcfl7PiiLWJZBDH7Np/zvypOt/3hfCXvXiDXmQADrvgayE2/PAB08P5qgJ3a44rWJp3BFiYHR71X/Yf4jrpwqr1GPKzIN86K+Unkxs9CGbR8qAuc7mCW/AwFmz1eXNRTwrvEYtWmOU2jH25Hx8e95prqTy933N8KftAr3KJe9/vgLIchs+mtUaHNaWcl4pcy0xHcVYwKBVYFyWpu0GXat78QWTey6V3AAU/4YIo7urHscaPNzbXwmzCmMrEKLu6YYamkkDe7O52ZBXd9NBipyfsMU+MgLZKXLVoGwxoo9lf3K1BpA8XiZ36tYpCN/9GbcEJRNVL2yq+PuIleSpEsn8ycbaPM7btHMySkz0NzzpmZ/9vHldbQku3dWLEsITubktRVK9U5Iza19MbJ/0i9848ICNOv+vkZnTVhynaAnHO7Rll08ggVtKTu18cXtKKPmlmLPe/0bNMrYymEwbd24fz6F3ipqVN/WYqymReoBiBXbk9ffQu8Ah12ju0geYVO1GX+WB2AbcXUDtXaMIlxLsY6Uq4k0uuZEdPebuSl3mtlcjrnT/Xog1wrT2zTitHTKIHcxsjoYSJkLu
 RHv0Uh6c
 7L92vmUJCRirehA232EFpUca40pS+WxRFF2ZQ60ey7wu8KE8LCxlWzY1oW8DzStfsyV/+ViDGSL7ViUvgZ/uyeREl5rItwiws1++dSymt5YwwpLx4ZB2cI0SICIgZGhRgKoFfYDrT+Mxnfrw/AFdsWC+rnXHSiKv5DTewezh+4rC2fy1CDnZZBImZlxgYwJq8U5MqVhPZjZKXBUPFJe2ulmmu6aW1SM9Kg836DzWb75YSzvdf2lP65LOAk0j9K7pg6evYbDraTf/V8UQEEH7m4m8mG1cg3gJaVco5C+K8LHNg0Vo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Boqun Feng" <boqun@kernel.org> writes:

> On Fri, Jan 30, 2026 at 05:20:11PM +0100, Andreas Hindborg wrote:
> [...]
>> >> In the last discussions we had on this, the conclusion was to use
>> >> `volatile_copy_memory` whenever that is available, or write a volatile
>> >> copy function in assembly.
>> >>
>> >> Using memcpy_{from,to}io is the latter solution. These functions are
>> >> simply volatile memcpy implemented in assembly.
>> >>
>> >> There is nothing special about MMIO. These functions are name as they
>> >> are because they are useful for MMIO.
>> >
>> > No. MMIO are really special. A few architectures require them to be accessed
>> > completely differently compared to normal memory. We also have things like
>> > INDIRECT_IOMEM. memory_{from,to}io are special as they use MMIO accessor such as
>> > readb to perform access on the __iomem pointer. They should not be mixed with
>> > normal memory. They must be treated as if they're from a completely separate
>> > address space.
>> >
>> > Normal memory vs DMA vs MMIO are all distinct, and this is demonstrated by the
>> > different types of barriers needed to order things correctly for each type of
>> > memory region.
>> >
>> > Userspace-mapped memory (that is also mapped in the kernel space, not __user) is
>> > the least special one out of these. They could practically share all atomic infra
>> > available for the kernel, hence the suggestion of using byte-wise atomic memcpy.
>>
>> I see. I did not consider this.
>>
>> At any rate, I still don't understand why I need an atomic copy function, or why I
>> need a byte-wise copy function. A volatile copy function should be fine, no?
>>
>
> but memcpy_{from,to}io() are not just volatile copy functions, they have
> additional side effects for MMIO ;-)

Alright. For the sake of my curiosity, could you explain these
additional side effects and the way thy are handled in the
implementation of these functions?

>
>> And what is the exact problem in using memcpy_{from,to}io. Looking at
>> it, I would end up writing something similar if I wrote a copy function
>> myself.
>>
>> If it is the wrong function to use, can you point at a fitting funciton?
>>
>
> I *think* for your use cases, a `user_page.read_volatile()` should
> suffice if the only potential concurrent writer is in the userspace
> (outside the Rust AM). The reason/rule I'm using is: a volatile
> operation may race with an access that compiler can know about (i.e.
> from Rust and C code), but it will not race with an external access.

That is my reasoning as well.

>
> However, byte-wise atomic memcpy will be more defined without paying any
> extra penalty.

Could you explain the additional penalty of `core::ptr::read_volatile`
vs `kernel::sync::atomic::Atomic::load` with  relaxed ordering?


Best regards,
Andreas Hindborg



