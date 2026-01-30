Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 16DDFE6BF1E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:23:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 360206B0005; Fri, 30 Jan 2026 10:23:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E37F6B0089; Fri, 30 Jan 2026 10:23:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1EFAE6B008A; Fri, 30 Jan 2026 10:23:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 09E1A6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:23:39 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 2C7BE1404E9
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:23:38 +0000 (UTC)
X-FDA: 84388999716.06.B81666B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id BF99140003
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:23:36 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=efzWWnfp;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769786616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/nzdfpegwfeLD+KOCGb3BdCA+3tJfxh5lC+dRbj10Cs=;
	b=fQWTzH74F2zJgYXoLvLlUPJBiTu5rJfGfMuquW7dyCy9pNfdVW/Tz68x9BQxn/Y06BdIKD
	RKYo4vQr1lyanzSsp8uTvOY2+N5kyOATEwVi5+H5cyqIh7R+iA1MyQlryTg0ltOcUj2PWu
	eKV1GTrdW7WoRIohbnj3TjHf3qkbRfY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=efzWWnfp;
	spf=pass (imf12.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769786616; a=rsa-sha256;
	cv=none;
	b=ZhYhECGeJoKSlWx9V7awx2sky0EqChisck8Cawpn0ZX/yqBplYmQMbbWKy9oxCMpEt+s7Z
	AWjR+cCsGi/FnppJQobA9BiXWyWZcFGAkrVdui9Ye91yZPZGNsYVPFA4O0hbaXreAjBW47
	6F05dre6DEwvLYxBO94DcwCskxZ+bhc=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A33176013A;
	Fri, 30 Jan 2026 15:23:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C549C4CEF7;
	Fri, 30 Jan 2026 15:23:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769786615;
	bh=OfAxn43cAaKhhypDUQkzSI0HnPDRUKLR4w1dCB/YkXM=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=efzWWnfpB6hvpZ13uEX2LOjlyqmi9mUPIy9EUBRjwa7fJK+OB1TAAT96WQXBzmHde
	 vkIA8v++kEio9KB5TzGwGKalRuUEM56+5v9UUbmZt7ktk1xKVkq5UXnyz4z5mZi94q
	 OBhgxdtIVKfG2HHsR+YUbL/fO1W+k6kTQR74Hkn0rokbxjk2jE78GbdPAwJPQN6e3x
	 dRTbKM2ROSuhSFi0AGrgV7jwx7Lll1LWV+/jIPK7yZB5FgoWYFBOcNyo1qp3Q6Rifr
	 T5wh2SeEdGrhO78RgGpYIiodXEZ6A5dkw3B/kZryw/7ZbAXkjMMk9rY1A+aTDxayhg
	 f6eccGO1Ks+IA==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Gary Guo <gary@garyguo.net>, Alice Ryhl
 <aliceryhl@google.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Miguel Ojeda
 <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, =?utf-8?Q?Bj=C3=B6?=
 =?utf-8?Q?rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
In-Reply-To: <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net>
References: <20260130-page-volatile-io-v1-1-19f3d3e8f265@kernel.org>
 <eGcGSx_-fgeLHkPmdfbWgLGhzEcmXunLzIAvS1-X3GqwyFOny9Frz1xN29-fj99sHxxa5_1WrcPxuSSZKxCHhA==@protonmail.internalid>
 <DG1Y5V810II1.1HE2T0HDBLNXI@garyguo.net>
 <877bszrz37.fsf@t14s.mail-host-address-is-not-set>
 <a8nHDdzac5l20akcxjjf9w7huObjn4eIHjUI-A17aKEwWl1N-4vvLBiVdqTQbBHwypMIA6gNkzm8YFXmMl44ew==@protonmail.internalid>
 <DG1ZJ1350EMS.1S1360PA496QG@garyguo.net>
 <874io3rwl3.fsf@t14s.mail-host-address-is-not-set>
 <iFJVkpTMbd-NR24OHYTJj8lr4dw7MwCQ9rJWiuRZFgK3JRDhIIAcpf5Z24viL5qHhkrPzpnKfvX7JS6X_VO2vg==@protonmail.internalid>
 <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net>
Date: Fri, 30 Jan 2026 16:23:23 +0100
Message-ID: <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Queue-Id: BF99140003
X-Rspamd-Server: rspam07
X-Stat-Signature: ywqgda6wqhorqz4uhm4gxuebjy4qdg6n
X-HE-Tag: 1769786616-779024
X-HE-Meta: U2FsdGVkX1+tpStnrd7CEpJILrSFJdrYUyo1WSdIgNZlee24Z7X68ZYsUGiqTdNpbvGuztbQBKMxtdjiY1wqEreh5NIBLdwCcpIUL50N9TQKvOOHXfvTqvm3k3L2ZW0dU+z4GfWIAj1liBn4EAILfjv/TfMeHx/3TnTvCqycHWY2Ui04l8N315I4FifVpN33RXePQCY4aE+/s9mdByTEWWUmap42tLww9pGlBJwtW2cyfIG2Kq/znLdWeCrU6t31i0Xh67EYxl0KRlqXTzPiOrRKs8PgmkWGXg+IuDAiUK1dgEx7Q1nBnTMDCXVSo8KplppWwWV/yaMwQVBYz31ezYgElE743LvMdxVRCIrke3l/7ikBVEEkMjcWeTL+gOC33rkyoMdZmwEZINWr2dP0i24o7RMtagM5i/QEUlZmi8NEAEBjh+i0yvZ5DkxKqkjBaxhRtanCZwlIei6gol93Wzx50zpxsMh1PDVkvCLC1zVCk4+oH2wwOZgiHOC8Pnm80rEDtUWoxWaPokRhRXAFe/DQmKJzBv7W1SWxfnO2rBapWns62PLTjAKH2piEl7SAKPNIVE6Q3HwaxabS6urrYqgVaqjE841fq8nNFfiDZuPv5pZd19wAiTLFhWSObMrVZm/yWT8o35qvFOlUKT4hbCjtA8y7AOdIgImcfKCPbBWc9yxwJLmcJNdHzyfIVzI/ckLRvGdZ1uEfEsdEHO5X2rHWsOc2VcKCLRO+PiIodd/F8WQEZQ8sYYmomqtqHAqjBZNrj9Ymy5B/ocCSfyIZ8dto0lZJlu9Uzk4ZeWEOO4+L5657dLzv6rRAdP+c8JPoOhrNaNyV/PqkxjOWZ6RsGRdKs+PSOKBwMkMI8JgKpq4ytz8dKFiuU/C56o8nmSMVp1zNwYW0sdlMkpxrgXF4ZAVoJ5fTYZE+32Rc0FoCQbtLvTq9HLWlltdbJum6wjQcqNdFA8Of4us=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Gary Guo" <gary@garyguo.net> writes:

> On Fri Jan 30, 2026 at 2:42 PM GMT, Andreas Hindborg wrote:
>> "Gary Guo" <gary@garyguo.net> writes:
>>
>>> On Fri Jan 30, 2026 at 1:48 PM GMT, Andreas Hindborg wrote:
>>>> "Gary Guo" <gary@garyguo.net> writes:
>>>>
>>>>> On Fri Jan 30, 2026 at 12:33 PM GMT, Andreas Hindborg wrote:
>>>>>> When copying data from buffers that are mapped to user space, or from
>>>>>> buffers that are used for dma, it is impossible to guarantee absence of
>>>>>> concurrent memory operations on those buffers. Copying data to/from `Page`
>>>>>> from/to these buffers would be undefined behavior if regular memcpy
>>>>>> operations are used.
>>>>>>
>>>>>> The operation can be made well defined, if the buffers that potentially
>>>>>> observe racy operations can be said to exist outside of any Rust
>>>>>> allocation. For this to be true, the kernel must only interact with the
>>>>>> buffers using raw volatile reads and writes.
>>>>>>
>>>>>> Add methods on `Page` to read and write the contents using volatile
>>>>>> operations.
>>>>>>
>>>>>> Also improve clarity by specifying additional requirements on
>>>>>> `read_raw`/`write_raw` methods regarding concurrent operations on involved
>>>>>> buffers.
>>>>>>
>>>>>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>>>>>> ---
>>>>>>  rust/kernel/page.rs | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>  1 file changed, 53 insertions(+)
>>>>>>
>>>>>> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
>>>>>> index 432fc0297d4a8..6568a0d3b3baa 100644
>>>>>> --- a/rust/kernel/page.rs
>>>>>> +++ b/rust/kernel/page.rs
>>>>>> @@ -7,6 +7,7 @@
>>>>>>      bindings,
>>>>>>      error::code::*,
>>>>>>      error::Result,
>>>>>> +    ffi::c_void,
>>>>>>      uaccess::UserSliceReader,
>>>>>>  };
>>>>>>  use core::{
>>>>>> @@ -260,6 +261,8 @@ fn with_pointer_into_page<T>(
>>>>>>      /// # Safety
>>>>>>      ///
>>>>>>      /// * Callers must ensure that `dst` is valid for writing `len` bytes.
>>>>>> +    /// * Callers must ensure that there are no other concurrent reads or writes to/from the
>>>>>> +    ///   destination memory region.
>>>>>>      /// * Callers must ensure that this call does not race with a write to the same page that
>>>>>>      ///   overlaps with this read.
>>>>>>      pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
>>>>>> @@ -274,6 +277,30 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
>>>>>>          })
>>>>>>      }
>>>>>>
>>>>>> +    /// Maps the page and reads from it into the given IO memory region using volatile memory
>>>>>> +    /// operations.
>>>>>> +    ///
>>>>>> +    /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
>>>>>> +    /// outside of the page, then this call returns [`EINVAL`].
>>>>>> +    ///
>>>>>> +    /// # Safety
>>>>>> +    /// Callers must ensure that:
>>>>>> +    ///
>>>>>> +    /// * The destination memory region is outside of any Rust memory allocation.
>>>>>> +    /// * The destination memory region is writable.
>>>>>> +    /// * This call does not race with a write to the same source page that overlaps with this read.
>>>>>> +    pub unsafe fn read_raw_toio(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
>>>>>> +        self.with_pointer_into_page(offset, len, move |src| {
>>>>>> +            // SAFETY: If `with_pointer_into_page` calls into this closure, then
>>>>>> +            // it has performed a bounds check and guarantees that `src` is
>>>>>> +            // valid for `len` bytes.
>>>>>> +            //
>>>>>> +            // There caller guarantees that there is no data race at the source.
>>>>>> +            unsafe { bindings::memcpy_toio(dst.cast::<c_void>(), src.cast::<c_void>(), len) };
>>>>>
>>>>> I feel that this should be a generic utility that integrates with our IO infra
>>>>> that allows you to copy/from IO to a slice.
>>>>
>>>> While that might also be useful, for my particular use case I am copying
>>>> between two pages. One is mapped from user space, the other one is
>>>> allocated by a driver. No slices involved. Pasting for reference [1]:
>>>
>>> Then what you need is a byte-wise atomic memcpy, not memcpy_{from,to}io.
>>
>> Can you elaborate on how you get to this requirement?
>
> Memory that is possibly mapped into userspace is still normal memory, it is not
> I/O. I/O accessors (and IO memcpy) are specifically used for MMIO, and you
> should not be using them for userspace memory.
>
> For memory that can be mutated from userspace you can just treat them as a
> potentially concurrent accessor hence all accesses should be using atomic. When
> tearing is acceptable, byte-wise atomic is sufficient.

I would treat them the same as DMA regions and MMIO regions. As these
regions are outside of any Rust allocation, if we never make references
to them and if we only operate on them with volatile operations,
behavior of the copy operations like these are defined, as far as I
understand.

In the last discussions we had on this, the conclusion was to use
`volatile_copy_memory` whenever that is available, or write a volatile
copy function in assembly.

Using memcpy_{from,to}io is the latter solution. These functions are
simply volatile memcpy implemented in assembly.

There is nothing special about MMIO. These functions are name as they
are because they are useful for MMIO.


Best regards,
Andreas Hindborg



