Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E496FE6BF25
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 16:20:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0B0D26B0005; Fri, 30 Jan 2026 11:20:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 034916B0089; Fri, 30 Jan 2026 11:20:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E82A16B008A; Fri, 30 Jan 2026 11:20:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D974B6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 11:20:28 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 78B99B8788
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:20:28 +0000 (UTC)
X-FDA: 84389142936.28.F7FD56A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id D74A8120003
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 16:20:26 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qFvAoLrE;
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769790026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kKFfO/cajjyvgKi+/84bcQRNcsqj6qTseOulOIdchzM=;
	b=mUuMl3PzWmDveFuYarOIfB0BzZT8SaHrygSM7aWNj/HO03Fl5SruNEaNk7Vlche9/lQuAC
	a2csES40pxWSsU2wCVjW6rdmr344TYCmg8OWRMrUcoM5jVKkVLkvzIMwzj2ugywI9Z9EwY
	88sc7wi1ehIbKQhxrDNt3zM1+V7PB7U=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=qFvAoLrE;
	spf=pass (imf29.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769790026; a=rsa-sha256;
	cv=none;
	b=mmrXwN34JsmVMGl46dWNqvOa5sIO9I20E9Cn1ctwIvoIQFI1tWgsDIWv4roP9PXQJ81VEP
	r/YrJwMSgiBCd+kBl+FbC7Nr8tPere9XUIq338+8MCx2quDxtBA0a2mgKUIvtb1PF3Jrng
	YkbjVNbtRQ1IsQAMfhZcq4B6DWOH7eA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3B94960146;
	Fri, 30 Jan 2026 16:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328CAC116C6;
	Fri, 30 Jan 2026 16:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769790025;
	bh=5xly92bMzMLkHZHjcbUH0bBICud3S1llkxSwO5zFSQ4=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=qFvAoLrEzX3VFixqSdBDcxKh+/2NIaHvXgp6QXJ/XVe75zpRgJgXFh0wm9MYkpJG3
	 exncHf0mRDjc5o86zn8NuKcy8dGqpdC8jiriSLXsN8T94SMrYxlkjiAXC65Tk0rqcQ
	 Umuk6SbPqU9oHiTOFv9ixSpmkXXKg/7OKKfC/8CeP5Bz0D4ons6ChlSlFUu0YgZPpX
	 TLtLs4CmYN/VbzigeXhN9mTa/+ARJMXy0sDxLKwGzhzrTl1XNKi0h72UQSMjXKe/PZ
	 Cta+H9PIDwNcZHOsLQm+e04NVOuswttseFYkwso870MJ75DEVGZXpfkaJViZbkRECx
	 gS+b3kYySBrYA==
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
In-Reply-To: <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
References: <20260130-page-volatile-io-v1-1-19f3d3e8f265@kernel.org>
 <eGcGSx_-fgeLHkPmdfbWgLGhzEcmXunLzIAvS1-X3GqwyFOny9Frz1xN29-fj99sHxxa5_1WrcPxuSSZKxCHhA==@protonmail.internalid>
 <DG1Y5V810II1.1HE2T0HDBLNXI@garyguo.net>
 <877bszrz37.fsf@t14s.mail-host-address-is-not-set>
 <a8nHDdzac5l20akcxjjf9w7huObjn4eIHjUI-A17aKEwWl1N-4vvLBiVdqTQbBHwypMIA6gNkzm8YFXmMl44ew==@protonmail.internalid>
 <DG1ZJ1350EMS.1S1360PA496QG@garyguo.net>
 <874io3rwl3.fsf@t14s.mail-host-address-is-not-set>
 <iFJVkpTMbd-NR24OHYTJj8lr4dw7MwCQ9rJWiuRZFgK3JRDhIIAcpf5Z24viL5qHhkrPzpnKfvX7JS6X_VO2vg==@protonmail.internalid>
 <DG20LKAHMXMZ.262Y7NAC1A1Z9@garyguo.net>
 <871pj7ruok.fsf@t14s.mail-host-address-is-not-set>
 <-9VZ2SJWMomnT82Xqo2u9cSlvCYkjqUqNxfwWMTxKmah9afzYQsZfNeCs24bgYBJVw2kTN2K3YSLYGr6naR_YA==@protonmail.internalid>
 <DG21IW5HZV2F.PXTH9P2IO8O7@garyguo.net>
Date: Fri, 30 Jan 2026 17:20:11 +0100
Message-ID: <87sebnqdhg.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: 7sge75uw65iobq7qhz74qdcc4fe1bbpx
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: D74A8120003
X-HE-Tag: 1769790026-843820
X-HE-Meta: U2FsdGVkX197tVrnxUB3QuJuf13xZ+uJiwtuJb9CmuyqhOK40ygxbz03zm+W3uBiOsXa7h3xB7xqrJwPdGPcFiYSxIYkHbhuDYpql6oXxgBWhQp81oOPxfCtID28Yjp1hqWUHlaeXBUzkzb4wG+En6Q/IGltv1SlBiN4gA5RpAAIn2Hp+VButqu/kjjhFK/HtiB+msSypB1HtCwP8RpciduzAefNeOakhzWS7XjUiR6i87pQ3JMWKu+bTtcT+MTFnf1SVf8fahAsaxXNU6S09aGICzR44ewBojMQ4c2SecTEZJWQz186jyzcs84Yu3gGSJ0vbys0LnuRDtDIv45e9xJDDKy9+5ETBE1YgWmfDqWhpWMPag3akOIHbzyXYbmAnFiY/o3FFdfxFUkN6uVLSRKGLD5Fjf07DJ+KxqmdjQFfauM59WmACQ9prh/unZKAqF801R0h8Ez/pEyaxgFntz/8Ly6fNARqKERHAopdf8iAAxd25EIBOJpMiHrZUwTstPiwZBNcvNDdfHd1HYJuwryZz5VBwnFD6/4rPDoJiugan+S9jvqpm+fWph8+l2VRaF9G9g5LO9eq+kvUv65zNjM4czmjJ4/5/dFfyaQgmCYmHEIYPzxGDgxRDl1v9GgWcH/rCbQ14T+S4xz3IUNj3USjbKAPGCitu6uU2O0h9aF9TuIEoGVFxIPqLuUV2+xbKzgYiooqmWLIYqFrN24DUvMvNP4xALXmMJKpp+BBs0MZvndoCNBbYDFAW0hRTXJIwA5/MS2iukoDbDc+HbL01LsunZmU6PG6KxMcfgSn1WDiqCgqiHBNg4nMPYc8lwYzf77BFF8+RjzRC8aR6JO2+MOPOk30e5f98cgbrzI4huWkuzprn522nLKWSn3UM84KRhv4iMJwv6oGaSfsztK0xVdCXk+NKgQwIrQ255tCdZQ5oeC+hEoBARUrwnFXt6cxtQVLORKa+xfetK1s1xO
 MU5a5ePs
 q5PsoaxSvYZMYEsDAwzYDgDQSh49TqitkWjO+lsUy8gWTw49wsLGNSnMYBHVaZfRKLr8IiZX0DmjalyWpUvyfCdMv1fCjnjT6xkM5dEuD/bQDRQ3yeJdWypemS5KOcMdiR+bkOe37FWomQNeZEZ8phbcovJ+fQDF2iGDUzCWxnQIlwecdmioBvYw7BqCTmBnxsVxpyUav8RvDt0NLMVJtLzt09Sl0iBlUTK8zPf/i6vvEakaOQRaW+gJEN6LsHebpCfSVHkcgpV22a7mjFfVz1yKgWxopd1llvPTwtN458sJDwHBugunAjnDZ49srv+xmRXwj
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Gary Guo" <gary@garyguo.net> writes:

> On Fri Jan 30, 2026 at 3:23 PM GMT, Andreas Hindborg wrote:
>> "Gary Guo" <gary@garyguo.net> writes:
>>
>>> On Fri Jan 30, 2026 at 2:42 PM GMT, Andreas Hindborg wrote:
>>>> "Gary Guo" <gary@garyguo.net> writes:
>>>>
>>>>> On Fri Jan 30, 2026 at 1:48 PM GMT, Andreas Hindborg wrote:
>>>>>> "Gary Guo" <gary@garyguo.net> writes:
>>>>>>
>>>>>>> On Fri Jan 30, 2026 at 12:33 PM GMT, Andreas Hindborg wrote:
>>>>>>>> When copying data from buffers that are mapped to user space, or from
>>>>>>>> buffers that are used for dma, it is impossible to guarantee absence of
>>>>>>>> concurrent memory operations on those buffers. Copying data to/from `Page`
>>>>>>>> from/to these buffers would be undefined behavior if regular memcpy
>>>>>>>> operations are used.
>>>>>>>>
>>>>>>>> The operation can be made well defined, if the buffers that potentially
>>>>>>>> observe racy operations can be said to exist outside of any Rust
>>>>>>>> allocation. For this to be true, the kernel must only interact with the
>>>>>>>> buffers using raw volatile reads and writes.
>>>>>>>>
>>>>>>>> Add methods on `Page` to read and write the contents using volatile
>>>>>>>> operations.
>>>>>>>>
>>>>>>>> Also improve clarity by specifying additional requirements on
>>>>>>>> `read_raw`/`write_raw` methods regarding concurrent operations on involved
>>>>>>>> buffers.
>>>>>>>>
>>>>>>>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>>>>>>>> ---
>>>>>>>>  rust/kernel/page.rs | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>>>>>  1 file changed, 53 insertions(+)
>>>>>>>>
>>>>>>>> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
>>>>>>>> index 432fc0297d4a8..6568a0d3b3baa 100644
>>>>>>>> --- a/rust/kernel/page.rs
>>>>>>>> +++ b/rust/kernel/page.rs
>>>>>>>> @@ -7,6 +7,7 @@
>>>>>>>>      bindings,
>>>>>>>>      error::code::*,
>>>>>>>>      error::Result,
>>>>>>>> +    ffi::c_void,
>>>>>>>>      uaccess::UserSliceReader,
>>>>>>>>  };
>>>>>>>>  use core::{
>>>>>>>> @@ -260,6 +261,8 @@ fn with_pointer_into_page<T>(
>>>>>>>>      /// # Safety
>>>>>>>>      ///
>>>>>>>>      /// * Callers must ensure that `dst` is valid for writing `len` bytes.
>>>>>>>> +    /// * Callers must ensure that there are no other concurrent reads or writes to/from the
>>>>>>>> +    ///   destination memory region.
>>>>>>>>      /// * Callers must ensure that this call does not race with a write to the same page that
>>>>>>>>      ///   overlaps with this read.
>>>>>>>>      pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
>>>>>>>> @@ -274,6 +277,30 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
>>>>>>>>          })
>>>>>>>>      }
>>>>>>>>
>>>>>>>> +    /// Maps the page and reads from it into the given IO memory region using volatile memory
>>>>>>>> +    /// operations.
>>>>>>>> +    ///
>>>>>>>> +    /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
>>>>>>>> +    /// outside of the page, then this call returns [`EINVAL`].
>>>>>>>> +    ///
>>>>>>>> +    /// # Safety
>>>>>>>> +    /// Callers must ensure that:
>>>>>>>> +    ///
>>>>>>>> +    /// * The destination memory region is outside of any Rust memory allocation.
>>>>>>>> +    /// * The destination memory region is writable.
>>>>>>>> +    /// * This call does not race with a write to the same source page that overlaps with this read.
>>>>>>>> +    pub unsafe fn read_raw_toio(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
>>>>>>>> +        self.with_pointer_into_page(offset, len, move |src| {
>>>>>>>> +            // SAFETY: If `with_pointer_into_page` calls into this closure, then
>>>>>>>> +            // it has performed a bounds check and guarantees that `src` is
>>>>>>>> +            // valid for `len` bytes.
>>>>>>>> +            //
>>>>>>>> +            // There caller guarantees that there is no data race at the source.
>>>>>>>> +            unsafe { bindings::memcpy_toio(dst.cast::<c_void>(), src.cast::<c_void>(), len) };
>>>>>>>
>>>>>>> I feel that this should be a generic utility that integrates with our IO infra
>>>>>>> that allows you to copy/from IO to a slice.
>>>>>>
>>>>>> While that might also be useful, for my particular use case I am copying
>>>>>> between two pages. One is mapped from user space, the other one is
>>>>>> allocated by a driver. No slices involved. Pasting for reference [1]:
>>>>>
>>>>> Then what you need is a byte-wise atomic memcpy, not memcpy_{from,to}io.
>>>>
>>>> Can you elaborate on how you get to this requirement?
>>>
>>> Memory that is possibly mapped into userspace is still normal memory, it is not
>>> I/O. I/O accessors (and IO memcpy) are specifically used for MMIO, and you
>>> should not be using them for userspace memory.
>>>
>>> For memory that can be mutated from userspace you can just treat them as a
>>> potentially concurrent accessor hence all accesses should be using atomic. When
>>> tearing is acceptable, byte-wise atomic is sufficient.
>>
>> I would treat them the same as DMA regions and MMIO regions. As these
>> regions are outside of any Rust allocation, if we never make references
>> to them and if we only operate on them with volatile operations,
>> behavior of the copy operations like these are defined, as far as I
>> understand.
>
> I don't find the argument about these being outside Rust allocation very useful.
> Apart from MMIO, I view all other types of memory still within purview of the
> abstract machine.

From the discussions we had on reading memory that may incur racy
writes, what I picked up is that these are OK under the conditions that
the regions are outside of any Rust allocation (whatever that means),
and they are only ever accessed by volatile operations. That is why I
think it is useful to consider these allocations outside of any Rust
allocation.

A similar argument to the one I am trying to make here was made in
`UserSliceReader::read_raw`, which delegates to a C function that (after
mapping and setup) ends up in an assembly implemented memcpy.

>
>>
>> In the last discussions we had on this, the conclusion was to use
>> `volatile_copy_memory` whenever that is available, or write a volatile
>> copy function in assembly.
>>
>> Using memcpy_{from,to}io is the latter solution. These functions are
>> simply volatile memcpy implemented in assembly.
>>
>> There is nothing special about MMIO. These functions are name as they
>> are because they are useful for MMIO.
>
> No. MMIO are really special. A few architectures require them to be accessed
> completely differently compared to normal memory. We also have things like
> INDIRECT_IOMEM. memory_{from,to}io are special as they use MMIO accessor such as
> readb to perform access on the __iomem pointer. They should not be mixed with
> normal memory. They must be treated as if they're from a completely separate
> address space.
>
> Normal memory vs DMA vs MMIO are all distinct, and this is demonstrated by the
> different types of barriers needed to order things correctly for each type of
> memory region.
>
> Userspace-mapped memory (that is also mapped in the kernel space, not __user) is
> the least special one out of these. They could practically share all atomic infra
> available for the kernel, hence the suggestion of using byte-wise atomic memcpy.

I see. I did not consider this.

At any rate, I still don't understand why I need an atomic copy function, or why I
need a byte-wise copy function. A volatile copy function should be fine, no?

And what is the exact problem in using memcpy_{from,to}io. Looking at
it, I would end up writing something similar if I wrote a copy function
myself.

If it is the wrong function to use, can you point at a fitting funciton?


Best regards,
Andreas Hindborg



