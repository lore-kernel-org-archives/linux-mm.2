Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA0A0E6BF0D
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 13:48:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0CEE66B0005; Fri, 30 Jan 2026 08:48:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 052FF6B0089; Fri, 30 Jan 2026 08:48:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EA0BA6B008A; Fri, 30 Jan 2026 08:48:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D4CEC6B0005
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 08:48:23 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 731F71403C0
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 13:48:23 +0000 (UTC)
X-FDA: 84388759686.14.66E21E9
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id D3F5F100010
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 13:48:21 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rcGWQZYo;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769780902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dnUIH+lEGXp86+c+cxCYSlh5IYJlzUsp36t03/udVNQ=;
	b=EqNC9ICsmi1m1zhJDniE0Yu8yHdHT29cgznt5BDX7rEuQLQ7JgUks3gWBJEiFbOs7EaotM
	pcokVgMWxmf4HZnM4o94GcDKPT4tKyu2OPIQT0GFkcW+IqgYLEhiu9flmqq/e8P5Y1XSHK
	pfYC/w2y0TsY8zhtkU525Opsv9i1V6s=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=rcGWQZYo;
	spf=pass (imf14.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769780902; a=rsa-sha256;
	cv=none;
	b=1uD1Z7w/m4TZwonAk4kUGHgKMJd+2pT88VOoOG6FGEZ9AyNI/cbqYfKnQmmq2qyy5gy8cg
	pyIFbzugT5X1eAMuIvBcngOcTGcF0wGvYLUV8FCMhORXsCWZbhFQr7OIEzaRZtmf9dkvNm
	IzobBJmurTd2fgeJ8kdEqEnSjPjNchs=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A78C2442E2;
	Fri, 30 Jan 2026 13:48:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D0BBC4CEF7;
	Fri, 30 Jan 2026 13:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769780900;
	bh=OxtEeF2uXGbFh8UZfqrHdfMGjlLIwPoFvUCXj9THMT8=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=rcGWQZYo0QJFsDswK+5HM5d7SaC+3kUD0iy7vbRey6xEilGHHz8eDUbWrIAOEbb28
	 PizmwZvky8ltxagclRoy/Of5DLI5+/FKMAjTOmcmETvsoRcdR8fx88+jlPGor+gMj+
	 WN4EeLY/eCNnoyWIlT80E9kwguqMqaMjv/uRVCzTPtS/VjUpAz0fegheZ/zSSBBOqy
	 /GGue8yLrxkBnYUl4qeGTaH/X9u35u8zzkGSet9klNKpb49jszC36wRdd61tbGUO6F
	 Ingk2oI2DM45kOZkytI9mcQOGFHvtwO8SrgUWCae+00dXDQ/zW5LRNdSby36bEhrBy
	 9KuXi7v6OCkyw==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Alice Ryhl <aliceryhl@google.com>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Miguel Ojeda <ojeda@kernel.org>, Boqun Feng
 <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn?=
 Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>
Cc: linux-mm@kvack.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] rust: page: add volatile memory copy methods
In-Reply-To: <DG1Y5V810II1.1HE2T0HDBLNXI@garyguo.net>
References: <20260130-page-volatile-io-v1-1-19f3d3e8f265@kernel.org>
 <eGcGSx_-fgeLHkPmdfbWgLGhzEcmXunLzIAvS1-X3GqwyFOny9Frz1xN29-fj99sHxxa5_1WrcPxuSSZKxCHhA==@protonmail.internalid>
 <DG1Y5V810II1.1HE2T0HDBLNXI@garyguo.net>
Date: Fri, 30 Jan 2026 14:48:12 +0100
Message-ID: <877bszrz37.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam11
X-Stat-Signature: w4fzf9hkia4o985d9gpkahhcmn9safy8
X-Rspam-User: 
X-Rspamd-Queue-Id: D3F5F100010
X-HE-Tag: 1769780901-436653
X-HE-Meta: U2FsdGVkX1/s6oTgoUsnBonC1lCDBdCMjAPMxgGdP3cnFKFlJYvPCkKCayWEvNKuv4wTYZfEqeyaPfDr5OnWqUz8RVqU27NiTVWcfM/tJI25IpRJCEWccjyYX8jq2YwvLn19ZZVwWWcz7+temXjuJ4woQaZkW9BQh7HwYKm1/uXBiQb+hqG1QV9gSFAwv4w85xYHgEC6KDs0mk7673sVPOrHAx84jo/8XJXKb7rDd1S+7lT7i3Pm4TSsab5adTfTSrkh1NjC/C8iAQXinstjfU9YQoPZuQoGJXGL5X2j0MWi5QK9Z16EcHq1AovyfMW97L4ZwWgTkLG0Zlqo/vn7DeK5mZj6NPGY5Mb+m9qTOxGiRQiPrYUrHmJgT86RuWu2hHN3l97NiRg8JxAuER3DXfIKc+BXfJKsr3tE4FDTKit9zwpIUL+QArKh2dz3ow3X+Y6mdtfN5aTGtfwupIgKhzY7wSlyKnEVy5wleb31bCG1bE0OL0DD9aF+hj3Il38HWow4FFeGYB60ETj1GJRKx/RsrYTB3jPRwQR/8plBsW7aPq1eOh2Cx3fBKkqLWhVuJ3UCqYEL+W9Uu+6gbOJHxsBqo/oiIq35+Viumbcilay4U+V40KHcofFW09uA6+GJRKyXIYtoGSsgZXzImL+na+G3bUgTyftL0dHhL0izVV3zuPpVEcTBJkLSFGfEVIjH+yLclBKwA1T5mkTFvgWMKMXnl/aoYj9EXr6NioyobJyabnAQ+pINu3KvbZImt5EfZ5DD+6r5dBBdL2vaj8Ey2n0gCd06X5fB3Q4AIatSy89hK9cgbNVLvgDQzZJCGCu4c1QZ1l+PEW5FZVH9o2QnlJYu2vIGDYyp+J29DFAxLxdhGEggDm7FAnNM0AcS+hcz7FWeyhhrhGj7poMjHbuCUG/fN0VKeJ3nRH1rn3w+FYIWAx70H53fvk/FshLJbI/UXHNvLvk01dgi/HV8Day
 D8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Gary Guo" <gary@garyguo.net> writes:

> On Fri Jan 30, 2026 at 12:33 PM GMT, Andreas Hindborg wrote:
>> When copying data from buffers that are mapped to user space, or from
>> buffers that are used for dma, it is impossible to guarantee absence of
>> concurrent memory operations on those buffers. Copying data to/from `Page`
>> from/to these buffers would be undefined behavior if regular memcpy
>> operations are used.
>>
>> The operation can be made well defined, if the buffers that potentially
>> observe racy operations can be said to exist outside of any Rust
>> allocation. For this to be true, the kernel must only interact with the
>> buffers using raw volatile reads and writes.
>>
>> Add methods on `Page` to read and write the contents using volatile
>> operations.
>>
>> Also improve clarity by specifying additional requirements on
>> `read_raw`/`write_raw` methods regarding concurrent operations on involved
>> buffers.
>>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>  rust/kernel/page.rs | 53 +++++++++++++++++++++++++++++++++++++++++++++++++++++
>>  1 file changed, 53 insertions(+)
>>
>> diff --git a/rust/kernel/page.rs b/rust/kernel/page.rs
>> index 432fc0297d4a8..6568a0d3b3baa 100644
>> --- a/rust/kernel/page.rs
>> +++ b/rust/kernel/page.rs
>> @@ -7,6 +7,7 @@
>>      bindings,
>>      error::code::*,
>>      error::Result,
>> +    ffi::c_void,
>>      uaccess::UserSliceReader,
>>  };
>>  use core::{
>> @@ -260,6 +261,8 @@ fn with_pointer_into_page<T>(
>>      /// # Safety
>>      ///
>>      /// * Callers must ensure that `dst` is valid for writing `len` bytes.
>> +    /// * Callers must ensure that there are no other concurrent reads or writes to/from the
>> +    ///   destination memory region.
>>      /// * Callers must ensure that this call does not race with a write to the same page that
>>      ///   overlaps with this read.
>>      pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
>> @@ -274,6 +277,30 @@ pub unsafe fn read_raw(&self, dst: *mut u8, offset: usize, len: usize) -> Result
>>          })
>>      }
>>
>> +    /// Maps the page and reads from it into the given IO memory region using volatile memory
>> +    /// operations.
>> +    ///
>> +    /// This method will perform bounds checks on the page offset. If `offset .. offset+len` goes
>> +    /// outside of the page, then this call returns [`EINVAL`].
>> +    ///
>> +    /// # Safety
>> +    /// Callers must ensure that:
>> +    ///
>> +    /// * The destination memory region is outside of any Rust memory allocation.
>> +    /// * The destination memory region is writable.
>> +    /// * This call does not race with a write to the same source page that overlaps with this read.
>> +    pub unsafe fn read_raw_toio(&self, dst: *mut u8, offset: usize, len: usize) -> Result {
>> +        self.with_pointer_into_page(offset, len, move |src| {
>> +            // SAFETY: If `with_pointer_into_page` calls into this closure, then
>> +            // it has performed a bounds check and guarantees that `src` is
>> +            // valid for `len` bytes.
>> +            //
>> +            // There caller guarantees that there is no data race at the source.
>> +            unsafe { bindings::memcpy_toio(dst.cast::<c_void>(), src.cast::<c_void>(), len) };
>
> I feel that this should be a generic utility that integrates with our IO infra
> that allows you to copy/from IO to a slice.

While that might also be useful, for my particular use case I am copying
between two pages. One is mapped from user space, the other one is
allocated by a driver. No slices involved. Pasting for reference [1]:


    /// Copy data to the current page of this segment from `src_page`.
    ///
    /// Copies  `PAGE_SIZE - (self.offset() % PAGE_SIZE` bytes of data from `src_page` to this
    /// segment starting at `self.offset()` from offset `self.offset() % PAGE_SIZE`. This call
    /// will advance offset and reduce length of `self`.
    ///
    /// Returns the number of bytes copied.
    pub fn copy_from_page(&mut self, src_page: &Page, src_offset: usize) -> usize {
        let dst_offset = self.offset() % PAGE_SIZE;
        debug_assert!(src_offset <= PAGE_SIZE);
        let length = (PAGE_SIZE - dst_offset)
            .min(self.len() as usize)
            .min(PAGE_SIZE - src_offset);
        let page_idx = self.offset() / PAGE_SIZE;

        // SAFETY: self.bio_vec is valid and thus bv_page must be a valid
        // pointer to a `struct page`.
        let dst_page = unsafe { Page::from_raw(self.bio_vec.bv_page.add(page_idx)) };

        dst_page
            .with_pointer_into_page(dst_offset, length, |dst| {
                // SAFETY:
                // - If `with_pointer_into_page` calls this closure, then it has performed bounds
                //   checks and guarantees that `dst` is valid for `length` bytes.
                // - Since we have a shared reference to `src_page`, the read cannot race with any
                //   writes to `src_page`.
                unsafe { src_page.read_raw_toio(dst, src_offset, length) }
            })
            .expect("Assertion failure, bounds check failed.");

        self.advance(length as u32)
            .expect("Assertion failure, bounds check failed.");

        length



Best regards,
Andreas Hindborg

[1] https://github.com/metaspace/linux/blob/3e46e95f0707fa71259b1d241f689144ad61cc62/rust/kernel/block/bio/vec.rs#L142


