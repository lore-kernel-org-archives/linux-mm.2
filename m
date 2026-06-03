Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8FFDCD6E4A
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 11:29:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4A7E96B008C; Wed,  3 Jun 2026 07:29:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 47F6C6B0092; Wed,  3 Jun 2026 07:29:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BCB76B0096; Wed,  3 Jun 2026 07:29:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 29F4D6B008C
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 07:29:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D5F011A0335
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:29:29 +0000 (UTC)
X-FDA: 84838380858.19.24F3859
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 259B6C000E
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 11:29:27 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VWnVJ5Jf;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780486168;
	b=LXDludJx44W3SDcTxNEyqVissegHcTVD9qRos6Va1P07+ceWeOWhFfRJzIsdKmJNxAYH06
	RkrvBOtII8g0HsQsFR6pmnMz9v4AYw/edZhbZ1WK0t9OlJnV9mWriDXIAXrKSKMAMWmLWN
	6oKo2KbEbyy7OAEkiDWRShNkp+PJCKQ=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=VWnVJ5Jf;
	spf=pass (imf10.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780486168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a30nVMM4YrCO+YydqXD4huUxG3Uq7bEk8pXDh6HkJuY=;
	b=metshqajqZ+cAkJXlv6laMHz8qAvcL6CzNXhtTgzreIfwQ/cRNDbz1MUWdz7EuckN+3lok
	nVlcvz8w6r5k66i3m9YXlrMq/O6LgHuGDg98j5gUDncr29gMO2jFB5Ax9uBC0l/SLGYAJf
	MF4rmlWtcZPi8XoDifzgj4ReTXE5qvA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1FD004402A;
	Wed,  3 Jun 2026 11:29:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E1E21F00893;
	Wed,  3 Jun 2026 11:29:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780486167;
	bh=a30nVMM4YrCO+YydqXD4huUxG3Uq7bEk8pXDh6HkJuY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=VWnVJ5Jf1vfW+v2SYn+vKHM75sFCZz8QodOgMT/ts/k7JKe+KTDblFjnu0VzETEuY
	 SsQKnK71hX3mhMcIdNXydnB0wiwpAgv/kTPvNFxUNEJv+SWIewc4QeWhyTBlhOfLEA
	 BEkQ/TQO/LGalDFb8Kmoquk6FS7Fphv67MAoz5sXFdMUAPEppFvElU4zmGX+2s2HSo
	 6T0Ir+vPHnm+2q/bCa3Hck6mZWBCwFleb8nN+fCALkXn8sA7Dm2syVsJTHYLmXoAM6
	 puhDyX80bioQEUwa3KutNbx3lpuIhlEODupjVLgkVlyUaXY1ZRgCTP1b0NdeMpTZ2r
	 a1me9POeRnoyQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, Miguel
 Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6?=
 =?utf-8?Q?rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor Gross
 <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, FUJITA Tomonori
 <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>,
 Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>,
 Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz
 <jstultz@google.com>, Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 linux-block@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 09/79] block: rust: introduce `kernel::block::bio` module
In-Reply-To: <abfbfV6-FXnVT9Ud@google.com>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-9-de9a7af4b469@kernel.org>
 <abfbfV6-FXnVT9Ud@google.com>
Date: Wed, 03 Jun 2026 13:29:13 +0200
Message-ID: <87pl27kgl2.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Queue-Id: 259B6C000E
X-Stat-Signature: z1t6gyfj8j6o7jfx165frnoypxkyiewr
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1780486167-62017
X-HE-Meta: U2FsdGVkX1+pvYhf4Sw/ujPaBRIRuF8puJhy5r47l2KQztH/hl/leIErae4VljesBIgQRaOaTQCtHDx5pNZAo79PR3ghZF9TcBHSsBKROxKtXSz+XNLTeYGrWwl8C9yWlmZ3EjOt/rgXmAO+vqw0UXp8KodOyj/4VrW4CQ1MLs3leJ+TMzF2yIv+b77m48Y/lRVJDTZsRBeHQnPRVbj8QAWSehrVlqnNW9r5ljCbrXa4dIaw0EnJk73yLjA7urlRYTHCndkvv16wIapKdEXKVMS9YJFOcNw5FW91+fF7WDTefFsoXN2vPssU7b4vOPjqHnRRrWn4Ft42LGGna2Rf9hPEtVxN4PVwycl/JrZjOeIM/HqCEH4DzIk1wXM8Q0psGpotM72HN0ie6+INE18N6ZVU8CVfk3QxC/OxHmzwY3BORf6/s9SeJN/+LZTreWGDJOKc66Y2/WeSW64Vlbyc7gc7VmZ+aoBjGXlOksOOMHlFAPlJiBxcAGoviNDR0hOi1GQ+gXtx/EBdJ7tzD+K3oe4vLJ0vTbCmnrfk3Lx7+oURFDrn+0BR7qBkz2NynzTZtMuMOJ9PbWHHmxv7uvHkuTIL7LmhfADaBobYsSequAxKaF3RFhVx2rNfuGnfDlJYUZ7jziLI3nee1g3WqOYt1FOOqr+7UPk7258eOzu6wZssoXfmDtKHfX5QTvfl3x81XfUCpT5M9dypfvwsr3LLSezUdHdwhYDPm/0jMZWK8n2YbsdFZonF9EVoBaMD10CsjO5vSxajweSWUTvWq7Fj6sZmapZSgzYinJezVZK5xAvcTaFbpbNe21RJZMuZxRF3BcXQm0eHNPR5cnEu7gtBb3AqGfDw+uct2tmzG/vmoQGF0ppNukBM8lsXQSd6woR9bIpPqoxdd0Rg7ELX6+gbIGry+OaFGOfn7F8rHsNtIRCJN3UsXYw0LzflwV6la4K6c1QTFzHh7xUoUW1K+xR
 2AICnjMB
 z51ya1rvpCH6HRdhASOkkbX6ZsyIyaHIQp/EV47LMjS9VcPbr0wWkkbcCmYgUYbxbg/Q7OBPVvJtezmS3hGwAqwZcTPn7egqC/bUo7jH12gxQdUpJ2sdMx/ua10wgDi9/MEOFcNBZOZbLaYatzQD7JLqHbFySYk1UBc3wtWr+8v/5x7OL7apRq/57Mwm8Sq3/FeUjosqe/lvGUlxfLBCOmA6wAHrK/AhPp/8de/FAKdWfrNRfL8Wo9RxXXnfXOBlZrmBTLbZorED8Jx90J0N+gVBLRQ7wENqgp6q11+73tPSl4plueLyjff1h8oPClpugk0LZ9TFqxpNM4Po=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Mon, Feb 16, 2026 at 12:34:56AM +0100, Andreas Hindborg wrote:
>> Add Rust abstractions for working with `struct bio`, the core IO command
>> descriptor for the block layer.
>> 
>> The `Bio` type wraps `struct bio` and provides safe access to the IO
>> vector describing the data buffers associated with the IO command. The
>> data buffers are represented as a vector of `Segment`s, where each
>> segment is a contiguous region of physical memory backed by `Page`.
>> 
>> The `BioSegmentIterator` provides iteration over segments in a single
>> bio, while `BioIterator` allows traversing a chain of bios. The
>> `Segment` type offers methods for copying data to and from pages, as
>> well as zeroing page contents, which are the fundamental operations
>> needed by block device drivers to process IO requests.
>> 
>> The `Request` type is extended with methods to access the bio chain
>> associated with a request, allowing drivers to iterate over all data
>> buffers that need to be processed.
>> 
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>>  rust/helpers/blk.c              |   8 +
>>  rust/kernel/block.rs            |   1 +
>>  rust/kernel/block/bio.rs        | 143 +++++++++++++++
>>  rust/kernel/block/bio/vec.rs    | 389 ++++++++++++++++++++++++++++++++++++++++
>>  rust/kernel/block/mq/request.rs |  46 +++++
>>  rust/kernel/lib.rs              |   2 +
>>  rust/kernel/page.rs             |   2 +-
>>  7 files changed, 590 insertions(+), 1 deletion(-)
>> 
>> diff --git a/rust/helpers/blk.c b/rust/helpers/blk.c
>> index cc9f4e6a2d234..53beba8c7782d 100644
>> --- a/rust/helpers/blk.c
>> +++ b/rust/helpers/blk.c
>> @@ -1,5 +1,6 @@
>>  // SPDX-License-Identifier: GPL-2.0
>>  
>> +#include <linux/bio.h>
>>  #include <linux/blk-mq.h>
>>  #include <linux/blkdev.h>
>>  
>> @@ -12,3 +13,10 @@ struct request *rust_helper_blk_mq_rq_from_pdu(void *pdu)
>>  {
>>  	return blk_mq_rq_from_pdu(pdu);
>>  }
>> +
>> +void rust_helper_bio_advance_iter_single(const struct bio *bio,
>> +					 struct bvec_iter *iter,
>> +					 unsigned int bytes)
>> +{
>> +	bio_advance_iter_single(bio, iter, bytes);
>> +}
>
> __rust_helper

Thanks.

>
>> diff --git a/rust/kernel/block/bio.rs b/rust/kernel/block/bio.rs
>> new file mode 100644
>> index 0000000000000..94062ea5281e6
>> --- /dev/null
>> +++ b/rust/kernel/block/bio.rs
>> @@ -0,0 +1,143 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +//! Types for working with the bio layer.
>> +//!
>> +//! C header: [`include/linux/blk_types.h`](../../include/linux/blk_types.h)
>
> srctree/

Ok.

>
>> +/// A block device IO descriptor (`struct bio`).
>> +///
>> +/// A `Bio` is the main unit of IO for the block layer. It describes an IO command and associated
>> +/// data buffers.
>> +///
>> +/// The data buffers associated with a `Bio` are represented by a vector of [`Segment`]s. These
>> +/// segments represent physically contiguous regions of memory. The memory is represented by
>> +/// [`Page`] descriptors internally.
>> +///
>> +/// The vector of [`Segment`]s can be iterated by obtaining a [`SegmentIterator`].
>> +///
>> +/// # Invariants
>> +///
>> +/// Instances of this type is always reference counted. A call to
>> +/// `bindings::bio_get()` ensures that the instance is valid for read at least
>> +/// until a matching call to `bindings :bio_put()`.
>
> Refcounted? None of these methods are called anywhere, and you do not
> implement AlwaysRefcounted.

This is stale info, I will remove it.

>
>> +#[repr(transparent)]
>> +pub struct Bio(Opaque<bindings::bio>);
>> +
>> +impl Bio {
>> +    /// Returns an iterator over segments in this `Bio`. Does not consider
>> +    /// segments of other bios in this bio chain.
>> +    #[inline(always)]
>> +    pub fn segment_iter(&mut self) -> BioSegmentIterator<'_> {
>
> Not `self: Pin<&mut Self>` here?

It definitely must be pinned, thanks.

>
>> +    /// Create an instance of `Bio` from a raw pointer.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// Caller must ensure that the `ptr` is valid for use as a reference to
>> +    /// `Bio` for the duration of `'a`.
>> +    #[inline(always)]
>> +    pub(crate) unsafe fn from_raw<'a>(ptr: *mut bindings::bio) -> Option<&'a Self> {
>> +        Some(
>> +            // SAFETY: by the safety requirement of this funciton, `ptr` is
>> +            // valid for read for the duration of the returned lifetime
>> +            unsafe { &*NonNull::new(ptr)?.as_ptr().cast::<Bio>() },
>> +        )
>> +    }
>> +
>> +    /// Create an instance of `Bio` from a raw pointer.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// Caller must ensure that the `ptr` is valid for use as a unique reference
>> +    /// to `Bio` for the duration of `'a`.
>> +    #[inline(always)]
>> +    pub(crate) unsafe fn from_raw_mut<'a>(ptr: *mut bindings::bio) -> Option<&'a mut Self> {
>> +        Some(
>> +            // SAFETY: by the safety requirement of this funciton, `ptr` is
>> +            // valid for read for the duration of the returned lifetime
>> +            unsafe { &mut *NonNull::new(ptr)?.as_ptr().cast::<Bio>() },
>
> Why the Option? I imagine every caller has a non-null pointert

It felt more streamlined to have the check here than at the call site:

    /// Get a mutable reference to the first [`Bio`] in this request.
    #[inline(always)]
    pub fn bio_mut(&mut self) -> Option<&mut Bio> {
        // SAFETY: By type invariant of `Self`, `self.0` is valid and the deref
        // is safe.
        let ptr = unsafe { (*self.0 .0.get()).bio };
        // SAFETY: By C API contract, if `bio` is not null it will have a
        // positive refcount at least for the duration of the lifetime of
        // `&self`.
        unsafe { Bio::from_raw_mut(ptr) }
    }


Yes, this also needs to take Pin<&mut Self>.

>
>> +        )
>> +    }
>> +}
>> +
>> +impl core::fmt::Display for Bio {
>
> We have our own fmt trait now, right?

Will switch to the kernel one.

>
>> +    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
>> +        write!(
>> +            f,
>> +            "Bio({:?}, vcnt: {}, idx: {}, size: 0x{:x}, completed: 0x{:x})",
>> +            self.0.get(),
>> +            self.io_vec_count(),
>> +            self.raw_iter().bi_idx,
>> +            self.raw_iter().bi_size,
>> +            self.raw_iter().bi_bvec_done
>
> This reads the entire `bi_iter` field three separate times. A local
> variable may be a good idea.

Ok.

>
>> +/// An iterator over `Segment`
>> +///
>> +/// # Invariants
>> +///
>> +/// If `iter.bi_size` > 0, `iter` must always index a valid `bio_vec` in `bio.io_vec()`.
>> +pub struct BioSegmentIterator<'a> {
>> +    bio: &'a mut Bio,
>> +    iter: bindings::bvec_iter,
>> +}
>> +
>> +impl<'a> BioSegmentIterator<'a> {
>> +    /// Creeate a new segemnt iterator for iterating the segments of `bio`. The
>
> typo

Thanks.

>
>> +impl<'a> core::iter::Iterator for BioSegmentIterator<'a> {
>> +    type Item = Segment<'a>;
>> +
>> +    #[inline(always)]
>> +    fn next(&mut self) -> Option<Self::Item> {
>> +        if self.iter.bi_size == 0 {
>> +            return None;
>> +        }
>> +
>> +        // SAFETY: We checked that `self.iter.bi_size` > 0 above.
>> +        let bio_vec_ret = unsafe { self.io_vec() };
>> +
>> +        // SAFETY: By existence of reference `&bio`, `bio.0` contains a valid
>> +        // `struct bio`. By type invariant of `BioSegmentItarator` `self.iter`
>> +        // indexes into a valid `bio_vec` entry. By C API contracit, `bv_len`
>> +        // does not exceed the size of the bio.
>> +        unsafe {
>> +            bindings::bio_advance_iter_single(
>> +                self.bio.0.get(),
>> +                core::ptr::from_mut(&mut self.iter),
>
> Creating this BioSegmentItarator copies the bvec_iter from the Bio, and
> then here you modify the copy. Is that the intent? Is the C type such
> that copying it is always okay?

Yes. I can see if I can document this better.

> Also, is the C type such that moves are ok? It's playsible that the
> answer is yes - the same applies in rust/kernel/iov.rs but it could be
> clearer in e.g. "Invariants" that this is the case.

Yes, it is so. I'll update docs.

> Nit: core::ptr::from_mut(&mut self.iter) -> &raw mut self.iter

Ok.

>
>> +    /// Get a mutable reference to the first [`Bio`] in this request.
>> +    #[inline(always)]
>> +    pub fn bio_mut(&mut self) -> Option<&mut Bio> {
>> +        // SAFETY: By type invariant of `Self`, `self.0` is valid and the deref
>> +        // is safe.
>> +        let ptr = unsafe { (*self.0.get()).bio };
>> +        // SAFETY: By C API contract, if `bio` is not null it will have a
>> +        // positive refcount at least for the duration of the lifetime of
>> +        // `&self`.
>> +        unsafe { Bio::from_raw_mut(ptr) }
>
> Surely &mut requires refcount == 1, not just positive refcount?

No, that is not how the C refcount works. Upper layers of the IO stack
will hold refcounts on the bio, even though lower layers are allowed to
mutate the data buffers of the bio.

Best regards,
Andreas Hindborg



