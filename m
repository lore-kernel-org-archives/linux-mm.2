Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE0B0E6BF11
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 14:42:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B63696B0005; Fri, 30 Jan 2026 09:42:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B10DF6B0089; Fri, 30 Jan 2026 09:42:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F2BD6B008A; Fri, 30 Jan 2026 09:42:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F3166B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 09:42:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5D2505909A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:42:37 +0000 (UTC)
X-FDA: 84388896354.21.7305696
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id A6D4440013
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 14:42:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KrC9r4HM;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769784155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1V5tkWqceW7iuWY4rIVEPEaRO5kWUEPFXCRY+2vlZbc=;
	b=eBtwPydDahEOqHMY690lubi4DcMiH3M2YHcNQYU+KJumSV2chx8XlnF9kCOGFhA5UNgNMA
	uHexPzXj5GCZ1AdsDZaUH6PlnlmsMw22iXqyl5B1f7UnYYZfw9ZEr/M5ad86awrzomDWTq
	gKktdPnnh9VRIogFNmoVyMZaks0M1IA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=KrC9r4HM;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769784155; a=rsa-sha256;
	cv=none;
	b=trPlUIstTkRgZljUEWHKrD8kHv+rrqsEII0vsrvp6UOSkW7y+IKSaFTBsnAYgJjbrjPV5L
	f5gXeXr9N72U2chBufD6A9D9DTMy3BKlkT9Q81a+XEZj/MQT6OHUGmUQ/4dz/nSchVeBIV
	BnUiOSM2vnpLx557SCNG06qLmVIYv1M=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 94E1743C69;
	Fri, 30 Jan 2026 14:42:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 365C0C4CEF7;
	Fri, 30 Jan 2026 14:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769784154;
	bh=JPzOLHG40jPLavhTwN68d9iWIrexHiP3vBrSv5OwBgw=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=KrC9r4HMnWBD5NWXRF1Rcd+cMLpLxZWGDYIl/rGJH733cpkH+1a+mCQfZUhv8Zkmu
	 EiV7BRpFpg5VZmrhHsy1BS6bElq9gs+WO4Fd6NITl99Bk+L66JZWK7rUZGr/ntCJ4K
	 WtxlSHwgF0Pdgw+sfOk3hhcCG1ThvxQPOJQd7Dv1Mrqi+zBgrkYft/Tm5C1LGpgqtI
	 2hfNwVrETY/LHUW9pIJ8Y9w/DRcQNwK/RlC5znRe0jR6XPWwxJ/O51iNOqc3z4xMb9
	 5AZlwe4U/Lp9s8YegmCFGQ+HtfbqPMuAoMZ5xUOMEPYp9gp9NE9m+rRPxQtfkl/jF7
	 KnrcipdYUfM4w==
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
In-Reply-To: <DG1ZJ1350EMS.1S1360PA496QG@garyguo.net>
References: <20260130-page-volatile-io-v1-1-19f3d3e8f265@kernel.org>
 <eGcGSx_-fgeLHkPmdfbWgLGhzEcmXunLzIAvS1-X3GqwyFOny9Frz1xN29-fj99sHxxa5_1WrcPxuSSZKxCHhA==@protonmail.internalid>
 <DG1Y5V810II1.1HE2T0HDBLNXI@garyguo.net>
 <877bszrz37.fsf@t14s.mail-host-address-is-not-set>
 <a8nHDdzac5l20akcxjjf9w7huObjn4eIHjUI-A17aKEwWl1N-4vvLBiVdqTQbBHwypMIA6gNkzm8YFXmMl44ew==@protonmail.internalid>
 <DG1ZJ1350EMS.1S1360PA496QG@garyguo.net>
Date: Fri, 30 Jan 2026 15:42:16 +0100
Message-ID: <874io3rwl3.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: A6D4440013
X-Stat-Signature: zhioowmjju99tqrgjgsdutma9jtagxqe
X-Rspam-User: 
X-HE-Tag: 1769784155-442511
X-HE-Meta: U2FsdGVkX18xKXeuCpRxdOhD98N47Ah8RcOtfgwFQLMZ05rDwVmhDDXGVeitlPRDNx3CpaImj3T/nNj7B5FbTvYmI7XEgNG9XfAbk1QqZAlKTbBvp7+XmCcBbuBZses5sNJH8gZEkQapOk8vSATn3ljdgCfeGrYBYmrK18KVHaH0+dFAvm17JPWUezmOzjnoVJUBFcEWhR7ge9vZITBAFk7LQiqx1hTOetoPQ9UcOT/NVrqq8sjvRRmIvdfzDWngwbsQ4t2jfEUlH8xzpLfFMMTH1v1Zi1CDiLbu+nk8c5W+mH9sjbAx1Swr+Nz8KuxrvWK62FiDPBKQbb/VtxEpLPzOsfoKo9ArRTRsOifj/tLD0ZBKpe3+OM6ys7Z91uPtJZw86Z2mkHOIm4I+GECvjK70y+ysJmAddWMeSfhmXEy3408v1DaSptw6Uu05p2QJH/RkdjPDeJ1U8faUGnmbRqsrakh6Ejcw/6n3MwVspYT7l/2WYYnND9pibbHW9mb7pTdTzGg+ZxpFN/F1lUIaCUaZyNMJ/YgEMLGPyQn2AgY4QSrLebO/bzzHcuGsSTJrvcH3dswaaGNabChyxDZ9/WoW1utB554sgpmutkL4WHtdESies09l2TRQgf5Bj3arV2Xt8YihkR9YrbfDurJ9xe43RVbOpSKrQ6UYX9spD69aQ7UbwYJOQ8mS3aRneRZ0PgVzPEUE4qnlpcYCSYDcu2zlxrB+r12pqMY9MbPKEsU4hY8Mw0o1Lak0TzfoeW1Y5vlQEbCsNmvHFPwaas4TQmPLnbQEBI4pOZKA6xQHvfv+V7TGEABTv6Qv/qdThmC7WjiqB7GEwc60/bqVt7gGB7Kh/vmGuDThmC19lCrqRqpvzhBmCN6vciUw312KJOpdYjZeLXXEbZAes4VG8WcUs9HuY79NgkgHASIXdRuTY3MRFKdENYMDXOZ+y1IBc31fvirEaKJBLaeNI1cC2s9
 Wn1xdjZ9
 irryhTFITeIOZ0z1vqgnAOi7qV0ebLrU+zl35pmM0m2R9IkE3+KRj22OnauMToCpY11uZO2VJDnXbgyB+/TRzwoPmC/ZRZxkRyCk6Ygp1NM78Ff5qf05mVka+ZTp8aOWJECXuXIJCqMvgTYhpEob03oQLg+NU6uxwq2x1Qkr3mnsQSDqd57GszBYkz/2ms2ULt+V7grGeaRIXadIby98h848Mboc0RNofWGnnMJXsGD8S+grBpx8uyeAEIUMfnaut4nGC4p3lkS+Mnw/J6m1r3CfW8LbKIrROpS9m+8nlWAW2HPF2m142NXcgj4d5VpcPBxZn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Gary Guo" <gary@garyguo.net> writes:

> On Fri Jan 30, 2026 at 1:48 PM GMT, Andreas Hindborg wrote:
>> "Gary Guo" <gary@garyguo.net> writes:
>>
>>> On Fri Jan 30, 2026 at 12:33 PM GMT, Andreas Hindborg wrote:
>>>> When copying data from buffers that are mapped to user space, or from
>>>> buffers that are used for dma, it is impossible to guarantee absence of
>>>> concurrent memory operations on those buffers. Copying data to/from `Page`
>>>> from/to these buffers would be undefined behavior if regular memcpy
>>>> operations are used.
>>>>
>>>> The operation can be made well defined, if the buffers that potentially
>>>> observe racy operations can be said to exist outside of any Rust
>>>> allocation. For this to be true, the kernel must only interact with the
>>>> buffers using raw volatile reads and writes.
>>>>
>>>> Add methods on `Page` to read and write the contents using volatile
>>>> operations.
>>>>
>>>> Also improve clarity by specifying additional requirements on
>>>> `read_raw`/`write_raw` methods regarding concurrent operations on involved
>>>> buffers.
>>>>
>>>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>>>> ---
>>>>  rust/kernel/page.rs | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>>>  1 file changed, 53 insertions(+)
>>>>
>>>> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
>>>> index 432fc0297d4a8..6568a0d3b3baa 100644
>>>> --- a/rust/kernel/page.rs
>>>> +++ b/rust/kernel/page.rs
>>>> @@ -7,6 +7,7 @@
>>>>      bindings,
>>>>      error::code::*,
>>>>      error::Result,
>>>> +    ffi::c_void,
>>>>      uaccess::UserSliceReader,
>>>>  };
>>>>  use core::{
>>>> @@ -260,6 +261,8 @@ fn with_pointer_into_page<T>(
>>>>      /// # Safety
>>>>      ///
>>>>      /// * Callers must ensure that `dst` is valid for writing `len` bytes.
>>>> +    /// * Callers must ensure that there are no other concurrent reads or writes to/from the
>>>> +    ///   destination memory region.
>>>>      /// * Callers must ensure that this call does not race with a write to the same page that
>>>>      ///   overlaps with this read.
>>>>      pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
>>>> @@ -274,6 +277,30 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
>>>>          })
>>>>      }
>>>>
>>>> +    /// Maps the page and reads from it into the given IO memory region using volatile memory
>>>> +    /// operations.
>>>> +    ///
>>>> +    /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
>>>> +    /// outside of the page, then this call returns [`EINVAL`].
>>>> +    ///
>>>> +    /// # Safety
>>>> +    /// Callers must ensure that:
>>>> +    ///
>>>> +    /// * The destination memory region is outside of any Rust memory allocation.
>>>> +    /// * The destination memory region is writable.
>>>> +    /// * This call does not race with a write to the same source page that overlaps with this read.
>>>> +    pub unsafe fn read_raw_toio(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
>>>> +        self.with_pointer_into_page(offset, len, move |src| {
>>>> +            // SAFETY: If `with_pointer_into_page` calls into this closure, then
>>>> +            // it has performed a bounds check and guarantees that `src` is
>>>> +            // valid for `len` bytes.
>>>> +            //
>>>> +            // There caller guarantees that there is no data race at the source.
>>>> +            unsafe { bindings::memcpy_toio(dst.cast::<c_void>(), src.cast::<c_void>(), len) };
>>>
>>> I feel that this should be a generic utility that integrates with our IO infra
>>> that allows you to copy/from IO to a slice.
>>
>> While that might also be useful, for my particular use case I am copying
>> between two pages. One is mapped from user space, the other one is
>> allocated by a driver. No slices involved. Pasting for reference [1]:
>
> Then what you need is a byte-wise atomic memcpy, not memcpy_{from,to}io.

Can you elaborate on how you get to this requirement?


Best regards,
Andreas Hindborg




