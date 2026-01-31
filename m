Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C97EE7C6E6
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 20:31:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 72DC96B0005; Sat, 31 Jan 2026 15:30:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B0FF6B0088; Sat, 31 Jan 2026 15:30:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BCB76B008A; Sat, 31 Jan 2026 15:30:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 486896B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 15:30:59 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 050931B1D6D
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:30:58 +0000 (UTC)
X-FDA: 84393403038.28.81B6E09
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf16.hostedemail.com (Postfix) with ESMTP id 6935F180008
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 20:30:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fYifUOel;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769891457;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WPzfXLiw+0WylfHXpZX+CPos8JHMNZqhmeoO4ET2zvE=;
	b=QWb/smgZo4g81xY4JMtF+zW7ZeHOdiOQ4MMsRuFJnLNYWYQ5deCf3PuxZgbz7cF4hPd4JT
	BkfLr/1MUG32cTcwaI7kR3ZXmKqxBYDFfqVF7jhDI8xgDdx3lw0Q1UKk0+/a+hpaTnzDKb
	DOt8oNSTpKv4w/T1Lo4L5HP3pCwuJy0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fYifUOel;
	spf=pass (imf16.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769891457; a=rsa-sha256;
	cv=none;
	b=JLbPhN2XGJ3SOgTZ6dYvT+ejzk5QusqWhP1HQTWzZ9tabtxPA2RZRdXaQakLnRbmwkucdG
	Ld6VDeju45bDpdd+74vOE7hXUrQabNo/7155ke3/slTX6HTOT6B2KRvEK/qvu61xwrYBmZ
	3BnOjpq5WID4uBLmdMeyXxPahJmk62A=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 71A0B405F8;
	Sat, 31 Jan 2026 20:30:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A715C4CEF1;
	Sat, 31 Jan 2026 20:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769891456;
	bh=WPzfXLiw+0WylfHXpZX+CPos8JHMNZqhmeoO4ET2zvE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=fYifUOelQyOosgKMVrK3MOBpzgqd54tRDlRzqLA39Xa2fklx4FPVfKZO2MO6Ufne2
	 WgcgZrZnfpKvZ9NMLVmdMDOaQyVUBVJGD0AFVMoO5VJ8ePcCMO12lJj1vhFwmwXkTk
	 fVavI+h1CbWPSLtfeTOK0CISh8WG3UC1ZZSnCxtpqsXvVVgGGF+qm3xsWptawd6B8K
	 TJuvocvXgM59P8EIyRZRNJW2DmwvVQcYm9rsNwj6gM0+l+eS5jVCq0Z/g7vORJ3KwL
	 QI70A8KtSk4sLqJwEuGUARiJtXsP+YesgtlYgvlibMaFvR3KeIlgJXG1S48iUv0oaB
	 bhft8ojOq2tkQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Boqun Feng <boqun@kernel.org>
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
In-Reply-To: <DG2WLWJD8V5W.2I24LZKS6JG6Q@garyguo.net>
References: <a8nHDdzac5l20akcxjjf9w7huObjn4eIHjUI-A17aKEwWl1N-4vvLBiVdqTQbBHwypMIA6gNkzm8YFXmMl44ew==@protonmail.internalid>
 <DG1ZJ1350EMS.1S1360PA496QG@garyguo.net>
 <874io3rwl3.fsf@t14s.mail-host-address-is-not-set>
 <iFJVkpTMbd-NR24OHYTJj8lr4dw7MwCQ9rJWiuRZFgK3JRDhIIAcpf5Z24viL5qHhkrPzpnKfvX7JS6X_VO2vg==@protonmail.internalid>
 <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net>
 <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
 <-9VZ2SJWMomnT82Xqo2u9cSlvCYkjqUqNxfwWMTxKmah9afzYQsZfNeCs24bgYBJVw2kTN2K3YSLYGr6naR_YA==@protonmail.internalid>
 <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
 <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
 <aX0lcVngRcRwqgd5@tardis.local>
 <SEV7bR_nyQNtvtgoO8X80HMkMTPLW_6roBSxJ-MpKHHNmkZQyVxSS9k1iFV7-bgAlHSLM566L8EqtRBnht65uA==@protonmail.internalid>
 <aX2tyn9nBUEKM-SN@tardis.local>
 <87ms1trjn9.fsf@t14s.mail-host-address-is-not-set>
 <gKLHFGuJqzRyjCupif-LFYn2ZY6OmhkyYj6idYTOnN4zMmNacFLBD1G9zzsYpTJn13GGvL0i-7JA-lIlBgakgQ==@protonmail.internalid>
 <DG2WLWJD8V5W.2I24LZKS6JG6Q@garyguo.net>
Date: Sat, 31 Jan 2026 21:30:46 +0100
Message-ID: <87bji9r0cp.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6935F180008
X-Stat-Signature: 7xerw9wuhbojbk8sdw9nsnwab1f1z1pc
X-Rspam-User: 
X-HE-Tag: 1769891457-654668
X-HE-Meta: U2FsdGVkX1+KBucdW8EzZhJCKBcCSQqdj2Qg34pCSjPA2KQGrK243a050hC8Wy/Iw1CkOM+aZi/37VPn9Vrt6eSOyeMvkYOa5RXkzIRrTR7jRQDkFP2L1icAMRr5uzwK4FUE4D4r48nwkBdoMWh4HHoghQhV95WQSqmpzDcnLxR85h2JgQ1PCZSwqQHh76Paj8YRr+pqatBir/AsUC8B4Tm2fKW/urwLbCFvVnNRwQr0fdWFwKIpPhBUaYgioxZ9swyFITAo1HDVS+KFsA4dQ0i8KmOM3Sn1NoMtyOSm36m5S79t8tAUjlyr05f0Agk2UH9dD0GcnfTolk8UfTi5fflg+WbFc/PBpzMxbrwbqgziqufHwwegP6n4i0CNusGO1TmjpKbQFHHwJlnVd4jSt6kvjElk96As5hQA7itjAcUbm84d2Xb7BMK5vBeEOIO9X1snT1FzSMggf/rB3B3wQtjAi3bg45XvEFVZeaSytESE0kLQQmLB6kxGDU94bW91cZhvqVTsP2/1PuQ0cVnBTPRnQt4HOf3CTb7BT8wCZoibLcibVnFnhaxrWUE0p4I7bhm4BfLUyRLwfYFWX3YomB2uLXAwjpPg7OSwB/Y6w+j6MoqCYKlb4rm0Ftv65n7qeaCa6o9BzdTZkXWs8ebbAIm+DHGh+c0vwvZzzpgyF0cC9CtL1ZN1C9Zh+upFH8mDKLxlGjaZ9Mp1L2k/d32qN5Y3JOJUuG8Cu4I+9xxgJ4XunjMFzuxWR80mrn0sn+iF2qnJBIEjq2kuYcxqwXBpjz6Qbmza1ySEscUgZup9PpR251tjpkx5CQbmcfZuryjz2wQwOg140aVI98bnXOEOpD3BAnRzG4JuylcvnqUsn8vDDjP5pXiZ3guywg86pgUminbwctjtf5Xdzy8a/BtnW2nP/Ulk92k8frQ67mtNqssWfPnjeSuJxoGc9Z2DviZmMhBzNE7fmLESD6JuNtT
 sdQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Gary Guo" <gary@garyguo.net> writes:

> On Sat Jan 31, 2026 at 1:34 PM GMT, Andreas Hindborg wrote:
>> "Boqun Feng" <boqun@kernel.org> writes:
>>
>>> On Fri, Jan 30, 2026 at 01:41:05PM -0800, Boqun Feng wrote:
>>>> On Fri, Jan 30, 2026 at 05:20:11PM +0100, Andreas Hindborg wrote:
>>>> [...]
>>>> > >> In the last discussions we had on this, the conclusion was to use
>>>> > >> `volatile_copy_memory` whenever that is available, or write a volatile
>>>> > >> copy function in assembly.
>>>> > >>
>>>> > >> Using memcpy_{from,to}io is the latter solution. These functions are
>>>> > >> simply volatile memcpy implemented in assembly.
>>>> > >>
>>>> > >> There is nothing special about MMIO. These functions are name as they
>>>> > >> are because they are useful for MMIO.
>>>> > >
>>>> > > No. MMIO are really special. A few architectures require them to be accessed
>>>> > > completely differently compared to normal memory. We also have things like
>>>> > > INDIRECT_IOMEM. memory_{from,to}io are special as they use MMIO accessor such as
>>>> > > readb to perform access on the __iomem pointer. They should not be mixed with
>>>> > > normal memory. They must be treated as if they're from a completely separate
>>>> > > address space.
>>>> > >
>>>> > > Normal memory vs DMA vs MMIO are all distinct, and this is demonstrated by the
>>>> > > different types of barriers needed to order things correctly for each type of
>>>> > > memory region.
>>>> > >
>>>> > > Userspace-mapped memory (that is also mapped in the kernel space, not __user) is
>>>> > > the least special one out of these. They could practically share all atomic infra
>>>> > > available for the kernel, hence the suggestion of using byte-wise atomic memcpy.
>>>> >
>>>> > I see. I did not consider this.
>>>> >
>>>> > At any rate, I still don't understand why I need an atomic copy function, or why I
>>>> > need a byte-wise copy function. A volatile copy function should be fine, no?
>>>> >
>>>>
>>>> but memcpy_{from,to}io() are not just volatile copy functions, they have
>>>> additional side effects for MMIO ;-)
>>>>
>>>
>>> For example, powerpc's memcpy_fromio() has eioio() in it, which we don't
>>> need for normal (user -> kernel) memory copy.
>>
>> Ok, I see. Thanks for explaining. I was only looking at the x86
>> implementation, which is of course not enough.
>>
>>>
>>>> > And what is the exact problem in using memcpy_{from,to}io. Looking at
>>>
>>> I think the main problem of using memcpy_{from,to}io here is not that
>>> they are not volatile memcpy (they might be), but it's because we
>>> wouldn't use them for the same thing in C, because they are designed for
>>> memory copying between MMIO and kernel memory (RAM).
>>>
>>> For MMIO, as Gary mentioned, because they are different than the normal
>>> memory, special instructions or extra barriers are needed.
>>
>> I see, I was not aware.
>>
>>>
>>> For DMA memory, it can be almost treated as external normal memory,
>>> however, different archictures/systems/platforms may have different
>>> requirement regarding cache coherent between CPU and devices, specially
>>> mapping or special instructions may be needed.
>>
>> Cache flushing and barriers, got it.
>>
>>>
>>> For __user memory, because kernel is only given a userspace address, and
>>> userspace can lie or unmap the address while kernel accessing it,
>>> copy_{from,to}_user() is needed to handle page faults.
>>
>> Just to clarify, for my use case, the page is already mapped to kernel
>> space, and it is guaranteed to be mapped for the duration of the call
>> where I do the copy. Also, it _may_ be a user page, but it might not
>> always be the case.
>
> In that case you should also assume there might be other kernel-space users.
> Byte-wise atomic memcpy would be best tool.

Other concurrent kernel readers/writers would be a kernel bug in my use
case. We could add this to the safety requirements.

>
>>
>>>
>>> Your use case (copying between userspace-mapped memory and kernel
>>> memory) is, as Gary said, the least special here. So using
>>> memcpy_{from,to}io() would be overkill and probably misleading.
>>
>> Ok, I understand.
>>
>>> I
>>> suggest we use `{read,write}_volatile()` (unless I'm missing something
>>> subtle of course), however `{read,write}_volatile()` only works on Sized
>>> types,
>>
>> We can copy as u8? Or would it be more efficient to copy as a larger size?
>
> Byte-wise atomic means that the atomicity is restricted to byte level (hence
> it's okay to say if you read a u32 with it and does not observe an atomic
> update). It does not mean that the access needs to be byte-wise, so it's
> perfectly fine to do a 32-bit load and it'll still be byte-wise atomic.

Ah.

>
>>
>> You suggested atomic in the other email, did you abandon that idea?
>
> The semantics we want is byte-wise atomic, although as a impl detail, using
> volatile for now is all that we need.
>
>>
>>> so we may have to use `bindings::memcpy()` or
>>> core::intrinsics::volatile_copy_memory() [1]
>>
>> I was looking at this one, but it is unstable behind `core_intrinsics`.
>> I was uncertain about pulling in additional unstable features. This is
>> why I was looking for something in the C kernel to use.
>>
>> I think `bindings::memcpy` is not guaranteed to be implemented as inline
>> assembly, so it may not have volatile semantics?
>
> In absence of full language LTO as we have today, it'll be fine (in practice).
> Unlike C, if you reference a symbol called "memcpy", it won't be treated as
> special and get turned into non-volatile memcpy.
>
> If the volatile memcpy intrinsics is stable, then we can switch to use that.

Got it, this aligns with what Boqun is writing. Let's go for that.

It also looks like memcpy is implemented in assembly for arm, arm32,
x86_64. Which would exempt it from LTO. Not sure about 32bit x86 though.
It defers to `__memcpy`. I could not figure out what that resolves to.
Is it from the compiler?


Best regards,
Andreas Hindborg



