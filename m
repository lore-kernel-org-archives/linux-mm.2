Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81579E7C6E5
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 20:14:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E7FBE6B0005; Sat, 31 Jan 2026 15:14:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2D0C6B0088; Sat, 31 Jan 2026 15:14:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D05466B008A; Sat, 31 Jan 2026 15:14:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE4876B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 15:14:24 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 704F5BB626
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:14:24 +0000 (UTC)
X-FDA: 84393361248.11.1468AC5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id C07CA1A0011
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:14:22 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bIFfvR2D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769890462;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DTCumRgyc8R+RzhO7lqI2NlUMLnsMy/AP3XZTPLTC8g=;
	b=EMx51a4KUphLvBUef/GbLxyzaO0ViLOPX1Q1hefrmNwXIMFH6Im4/9iZQoyX0qmzsyxlOK
	e9ecuswVKT00MkV9u1IGx3Q8zAEfNPw8dFG6VBMHoPFwk0LE/pk5kkYJCa89aVvllRKOw5
	LFkqPgp+3tR8gY1P5zzc459034Th6uM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769890462; a=rsa-sha256;
	cv=none;
	b=Sgme49AkGKKhel9KPSXkRgibdtZgMhWDFAJ4NWr7YafMcmaavdMyyJVbnqXoVp0PD7WRee
	MyqneE6RUOkiC17a2Ldj3PWQSOlGWDPuudPv3aJ3RQh0ktjbYJ6LKYgiLv+0lkY4rSRkTq
	v+qSaWf3gFJuCdbjZWbDIEKlvZIcEXA=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bIFfvR2D;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 84E2642DFC;
	Sat, 31 Jan 2026 20:14:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81CBBC4CEF1;
	Sat, 31 Jan 2026 20:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769890461;
	bh=DTCumRgyc8R+RzhO7lqI2NlUMLnsMy/AP3XZTPLTC8g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=bIFfvR2Djintd5gEOXAcP0/fCyWEZTqtfP05ytfx86MZ1fGGxyM9dX2X7S2zTK8Pj
	 RYdpctU0COuH8I/dcvS/8G5MBWl+EvASY+Et4GoBvMTH1q0F2dPKiQfYidVlXnhl2h
	 aOslpIHKhmf33KgFwY7Rn/FFKt1dj+bofATIsml3rt7GjkHrAJca8YCU2AuaoEmzzN
	 nXGPDjLStEDqT+z3E4Ypzm2YaS/UNcDO2qjOcatI8NsRu9WG78YmYa0ett/ZRNMwh5
	 h0I2rYtp/o/Zl1XIACXWIUAH0we5kb3BhzuG1DPZf35JBYHMmkGzyjghkIZGgti1eC
	 QgN3SpKjHPewQ==
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
In-Reply-To: <aX4tTMrMx1G7hXHf@tardis.local>
References: <iFJVkpTMbd-NR24OHYTJj8lr4dw7MwCQ9rJWiuRZFgK3JRDhIIAcpf5Z24viL5qHhkrPzpnKfvX7JS6X_VO2vg==@protonmail.internalid>
 <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net>
 <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
 <-9VZ2SJWMomnT82Xqo2u9cSlvCYkjqUqNxfwWMTxKmah9afzYQsZfNeCs24bgYBJVw2kTN2K3YSLYGr6naR_YA==@protonmail.internalid>
 <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
 <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
 <aX0lcVngRcRwqgd5@tardis.local>
 <SEV7bR_nyQNtvtgoO8X80HMkMTPLW_6roBSxJ-MpKHHNmkZQyVxSS9k1iFV7-bgAlHSLM566L8EqtRBnht65uA==@protonmail.internalid>
 <aX2tyn9nBUEKM-SN@tardis.local>
 <87ms1trjn9.fsf@t14s.mail-host-address-is-not-set>
 <2K11BlRP4dLJg30wg9iuWS-cPdgQvA3NuAu1jrQiq5E3u4eovN08u52BlW6dP2rQiG29mJl6f20X_zi-u85Mow==@protonmail.internalid>
 <aX4tTMrMx1G7hXHf@tardis.local>
Date: Sat, 31 Jan 2026 21:14:09 +0100
Message-ID: <87h5s1r14e.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: C07CA1A0011
X-Stat-Signature: kd1otkqkaq5nms7n5481at65mekz65a9
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1769890462-874425
X-HE-Meta: U2FsdGVkX1+A8DG719y0S6kwUXQH8Px67gaqfZb9h0nhSz6vIxNerr1bHAp3Vb6ZOzGDolU2HF54v3v3XRJ+L69N+s+Cqw0nPNLi4iZCLnUftvaLnxhswsvEfPs69RoaNc7s+2vbnbwptH7j0hlMNq3JFewFigt3EJpik5hjxxNSxt7QFxRMu/Pd5rDYmgCfErWVyuNKeOJr+gQGUhUAgmvGkcApPi3Wa/tphTnjog0gA8uQeu427k8BieLJL1x+WCZyE9GXoO/iE/vfd49xT2EFNpdGjgYXymJbYf7hr4AX6s45TvhRWcximd40n1dUnMKDzlZ01+Kfli9WvIMj/OhfI7HxGSMqC9Zf/UzAQOBk5oBeQ+VK2ZE0aGAkgBoBDGkKzaYvNpKWrC4dsOSNgSz5RTtytT7+ipU5++GFnx8iLVY65eCu3364mmg0nq3REdUVssgP3ZSF/2Ko58clKg3mPsdAbuEd13Fc4c0n5UUsYbfnZQd2D0zImB1alHXbCWSOrPUXaklaLmqdiJIHuLCSL6xn1dtxELTbBm4diF0QnEBSF1QmaRrE511LsCJT97d8sqncKEU0IKBoN7V+hCkV834DoubttUpa8k6OcOSxf3r7wPOXHYT808T7B0AetQQASTluhBGODdblOaECDmzs/B3jFXaCJjQeCMWiHy6/wERp3+3zPjSAU6eu/BlHsmQ+DHEgJ9+dKEW58vbZlSswS/2YlkV+TAm2GL5QTsErgetRHs+SZd2YKosYWNeCF+MDmMBO4aKJG+E8eoSugg/+qjHJIQJ66OfYwXafAbVbU0vczPuMdKmbdZD7xfzxuVnEvePbn9Uny5M7DRihl59V4T4x2DDb8N7jjk6wywY70VkF9Vf5sfdhp8euANYDgwJ05g2kK/ZeDiiaHpOV16sNknoExXP8sxX5ZCBvCX1K5lCG/Visle/aSZcosvpdnJkgyZF7W/451MmVcnA
 1j7XgSmo
 AxXOuNVBuEBPV+a547NCwwQZF2P3N6BtDrLw5pH+BkPDgEDba8paMhoNFZORAc0FQlKolJy80wel5R5V5Qbfh8W4JyzmavEiALCxMcZCZRLsEEWxTLorMHS0a4vTwQgtJpKEoXvJaNDmVxv5mWxKhqOfXin+XBOD2OYmoz9gTgsM2nFsDC2wZGPYKOW3p7PNYnpJrwIJ4nG3WyF4wIbI7yt73cJ2gQoEXduQq/27axsppQct7OqZNVEzOf6NrVwCDVtBzUhMc2DBCzec=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Boqun Feng" <boqun@kernel.org> writes:

> On Sat, Jan 31, 2026 at 02:34:02PM +0100, Andreas Hindborg wrote:
> [..]
>> >
>> > For DMA memory, it can be almost treated as external normal memory,
>> > however, different archictures/systems/platforms may have different
>> > requirement regarding cache coherent between CPU and devices, specially
>> > mapping or special instructions may be needed.
>>
>> Cache flushing and barriers, got it.
>>
>
> For completeness, I think for some architectures/platforms, cache
> coherence between CPU and devices can be achieved by hardware, in that
> case, DMA memory access can be just a normal memory access.
>
>> >
>> > For __user memory, because kernel is only given a userspace address, and
>> > userspace can lie or unmap the address while kernel accessing it,
>> > copy_{from,to}_user() is needed to handle page faults.
>>
>> Just to clarify, for my use case, the page is already mapped to kernel
>> space, and it is guaranteed to be mapped for the duration of the call
>> where I do the copy. Also, it _may_ be a user page, but it might not
>> always be the case.
>>
>
> Ok, if it's not a page mapped to userspace, would there be any other
> access from kernel while copying the page? If there is other kernel
> thread or interrupt could write to source page, the write needs to be
> atomic in some level (byte-wise for example), so does the read part of
> the copy.

No matter if it is a page from user space or a page only mapped in the
kernel, there should be no concurrent access by kernel threads.

These pages are the IO buffers for block device IO. For direct user IO
they would be user space pages mapped to the kernel during IO. For
regular IO, they are managed by the page cache. I am pretty sure proper
locking is in place so that the pages are not mutated or read while an
IO request is outstanding from the page cache.

Maybe encryption could be a case where data is written by kernel threads
(in case of no hw acceleration) to IO buffers mapped in kernel space.
But again, these operations would not overlap with the IO request, and
proper synchronization should be in place.

>
>> >
>> > Your use case (copying between userspace-mapped memory and kernel
>> > memory) is, as Gary said, the least special here. So using
>> > memcpy_{from,to}io() would be overkill and probably misleading.
>>
>> Ok, I understand.
>>
>> > I
>> > suggest we use `{read,write}_volatile()` (unless I'm missing something
>> > subtle of course), however `{read,write}_volatile()` only works on Sized
>> > types,
>>
>> We can copy as u8? Or would it be more efficient to copy as a larger size?
>>
>
> Copying as a larger size is more efficient: less instructions for the
> same amount of data to copy.
>
>> You suggested atomic in the other email, did you abandon that idea?
>>
>
> No, if we have byte-wise atomic copy, I'd still use that, but that is
> not something already implemented in Rust. (my reply had a "if we want
> to avoid implementing something by ourselves" at last)

Got it.

>
>> > so we may have to use `bindings::memcpy()` or
>> > core::intrinsics::volatile_copy_memory() [1]
>>
>> I was looking at this one, but it is unstable behind `core_intrinsics`.
>> I was uncertain about pulling in additional unstable features. This is
>
> That's also why I said "(or suggest Rust to stabilize something).
>
>> why I was looking for something in the C kernel to use.
>>
>> I think `bindings::memcpy` is not guaranteed to be implemented as inline
>> assembly, so it may not have volatile semantics?
>>
>
> Well, it's used in C as if it's volatile, for example, it's used in the
> similar case in bio_copy_data_iter() (hopefully you can confirm that's
> indeed a similar case).

Yes, this is the exact same situation. It is used higher in the stack,
but same constraints.

> And I'm suggesting we use it forever, just use
> it while waiting for volatile_copy_memory() or something.

Ok, I'm fine with that. We can use this one and add a TODO note.


Best regards,
Andreas Hindborg



