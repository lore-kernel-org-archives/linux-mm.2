Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6C6D3F4644A
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:29:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7B856B0181; Mon, 16 Mar 2026 06:29:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A29086B0182; Mon, 16 Mar 2026 06:29:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927AE6B0183; Mon, 16 Mar 2026 06:29:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 7C6056B0181
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:29:22 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F86F16013D
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:29:22 +0000 (UTC)
X-FDA: 84551554164.22.D1CD3AE
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3B33512000C
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:29:19 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pXQ3TWZK;
	spf=pass (imf29.hostedemail.com: domain of 3ftu3aQkKCGkHSPJLYfOSNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3ftu3aQkKCGkHSPJLYfOSNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773656960;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qgj71Xi0TqNeZ1561j+9Q4P6kO5QDeyHGgeliIn9S4M=;
	b=tThnkEURmepXrMsC8PQ26/EOyHUegSHI/hw3s2ENRUYQXawICK6SVoh1FTTJ41JppVonNJ
	T47sheRETnEMzzOiIdNvT5aqY0DK5u2lImwYtNqyylQvlKTek3Lw1y+4Dym2Vf82lCkpv1
	LoKQPMTR5gQANJP/cFqCfjk0NUlJVa0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773656960; a=rsa-sha256;
	cv=none;
	b=k4Kxbd0E/awWvcZ2hlrBjOQCR/ze/QaZ842QGJ/+4cY9mpctwkOfwL+nr8MMHNGboaRTfA
	UCF2MZolpp2YNVVxtpnX6gqCP+9tARgZI3QCCFtChgVKhb6D6+j8OvCh+84GVkCdksrQxW
	6b3qs0OlGzYuxSpEWcEkeHNz+lnach0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=pXQ3TWZK;
	spf=pass (imf29.hostedemail.com: domain of 3ftu3aQkKCGkHSPJLYfOSNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3ftu3aQkKCGkHSPJLYfOSNVVNSL.JVTSPUbe-TTRcHJR.VYN@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853b474594so36716275e9.1
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:29:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773656959; x=1774261759; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=qgj71Xi0TqNeZ1561j+9Q4P6kO5QDeyHGgeliIn9S4M=;
        b=pXQ3TWZKSoTXaDGcp0TfpAnLM/3EY3XlUZI0bNF1n13D8/+Wf3gJZfCKLZ6mXmpoj9
         5zYx/GKP7/m+k5jhw5Ib0JjnIC9sLER5NYgTWsWy5J4BoZcDmZHAA3H4B5w0ZmLoNXZm
         obWTXLfEtGc1fitpxsIQOPPWe4N6JpDKzDy8YZhUeGx/AFrUSpvQzaCGWhxj9U3qonBs
         wTh6cryyvm8X1WDoPxghCy+fyg8qcCx32Pg9Bad2BvmtvZtoPRVxZxqMPRt/7H7lGwU6
         eJWjBz46fokqkv2efwE3EhjE/ddI4+ruCnOCZ6DMNEsJDfunyjtUJuWdyX4OMI6SWI7C
         yGLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773656959; x=1774261759;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qgj71Xi0TqNeZ1561j+9Q4P6kO5QDeyHGgeliIn9S4M=;
        b=bJ32idyNUEHArWY/AfIuW/yjys8xe07YZgYP5rq41YcQnxCUV8/HvOwlvPZRUoo7j3
         deGr+j8EfBCFN+nJbW8DND/HYb5TGIFj8GqqYk7UeorI8+8cODtSnHrUHNOeHQ/peV+Z
         wwJM4REjEtUs3p29ED9JmayVIwJ7t/JWeKiNThWRbrRGcT4gDbJV6mKCbgHp2An9aDWH
         34ui3moT+BmqFj9lxylv4PUuB53pSB0gSyU5vkmGR20BsiyNHe3UAJwH734hz3+UoQ6f
         4Zcdhknj60qY4994F0G7ETNClgu1xSEw6rB5pM3J47reNpudqZtMa6Y30cfTBPnRXDN+
         5/Pw==
X-Forwarded-Encrypted: i=1; AJvYcCWmLCVa3DCMBgOJaY5+rVbS5hhabw+uPsz27BcxYPWjluVVwglywsZHogvKFLAvfrbb97RWO4Bc2g==@kvack.org
X-Gm-Message-State: AOJu0YxXKt5hND/wLzed1eUw3tkQ+gp2HadyBaIHx2RVfUYXuaG67z2q
	mikIj1WKgimAdX7fyCxO/trCe6IfBKnBDytuGoK9hzUcKzzAkHdFWKWurIdZeI9/YddIIVM63aQ
	LlcyI2yDzuCYRcGwZig==
X-Received: from wmco7.prod.google.com ([2002:a05:600c:a307:b0:485:3a48:d6c5])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:4fd5:b0:46e:59bd:f7e2 with SMTP id 5b1f17b1804b1-48555b2c8fbmr205265065e9.11.1773656958664;
 Mon, 16 Mar 2026 03:29:18 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:29:17 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-9-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-9-de9a7af4b469@kernel.org>
Message-ID: <abfbfV6-FXnVT9Ud@google.com>
Subject: Re: [PATCH 09/79] block: rust: introduce `kernel::block::bio` module
From: Alice Ryhl <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Boqun Feng <boqun.feng@gmail.com>, Jens Axboe <axboe@kernel.dk>, 
	Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	FUJITA Tomonori <fujita.tomonori@gmail.com>, Frederic Weisbecker <frederic@kernel.org>, 
	Lyude Paul <lyude@redhat.com>, Thomas Gleixner <tglx@kernel.org>, 
	Anna-Maria Behnsen <anna-maria@linutronix.de>, John Stultz <jstultz@google.com>, 
	Stephen Boyd <sboyd@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, linux-block@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 3B33512000C
X-Stat-Signature: agjcyw5dqh93g5ps4opnsxfyo4o4n3hh
X-Rspam-User: 
X-HE-Tag: 1773656959-277327
X-HE-Meta: U2FsdGVkX1+be2RDDgb5s/ES4brfrFnFvYtLFzRTWVFnt3kcQpz9ZnGLxPABj+vCsPtZ+LcuXTiHGGJ2haQFd28E8Zcma9UDyaM+WyxQwXY22oq+ZcE9ar57Nv/G+enHODQWr8Ka7BGmje0MU4msEWyiVRvi6UQ2N/ReL1yYBhPwkUNf+PJ7vAZqf1GflPE8Il7agnQDT2blNw2Lp5fPXAiuLETEx7lzgbaJnqd63oERxqlauC9ZLpwjZ8Y3gAbryfp2b1X33utO02Y1LszpecbtxYk0SwqtBHZB/iAYd+ewNMt6qDxhSm/maBC6JoYZPTt1huLBvuSTom9SdP9llq9ZscvgRE7l46dXalYedAtafjmNLEXsdssTPNjnXJ4EA42iTNXGQsrY4trGnr8WvFMBm0ZC9C+uHcAQOFRmB73avr9+sDtVeF7tHnnJwhxcJ6QMmWQizIWaKbGFMG/Nvhns8+yK2I3iJwkQoLGC8N6JkBFodbA5g1PS1m/kmRMrqQyWyg90JMQ2uAvoyxkXdlgvPMT4qGQoE2yXj4ZbmcpVdho5TO2IUfRBnHcusS6VwzgMAXf60p5UII9ONZrukiHJK7eBJzc6IGNh7UnEEMQU8Q2FbKvMF6AZcg7fuf2XTLBMvd+BYul8buASXsL9IK69iz2ghhoiEVI+EZhPZx3iD9GK0SBe8zKeNi8efLbS7KHeLNhnOgJEoC6hdu+BS1zIquc/NEnr3kn/LhNYZEO8slvd7NjZNxeub/QcG84HyViWvcrlz3ml7+6MiJMLXBjLLAzhedmijyvz7d7/9OlZeXU9NLSuWYoqSq1bYAVXzQta3TXlJwjitbxy4gunXqF41WKF4e0N/2dZozqIrS7ZyW9BqKIuv517KHoQcfwTR8o71iuY0PJdrpZGeFCDWr1rr6E7zPEZ2wyUshXQljQRfGyKITI/mS4P2pgqPukcDSJU4TEBNLwecRZETAq
 tGQ9CIP/
 tgmYmzzK1cfQVYKqwBbfz4ncWdgTeSd1IgZf184aopCjIvySD4X5SbHESjkW42C4SKD77if2OBOqYE0JadvZ7Dy1/mUUv2xW2CoM5WYwZPkDxxviZTzmJ0UrLZl9QEXxdfxfdgV0189y6RRCzROySez2Q2bqWjJnRu4A861X0SzwQwZdvhB+4JDiyyNPlqRAmEOl+9djxx9R3NTraiLfrB9kmtLRVMC3oTkQtZi3/CzTj1fvDwyN9T96SNayDXBX+UwDCtNy6jy5ymvF4WWU64tnal84L+dZkDM546SaPtp/NSP/6xAJ+Zi8wZd3ffzjjvUhB+bmYI4/cdTuEd5KoxABWrd+4Ti/4bpqyH0xmUYBVa4nvOPD7WoeC0sJuoxER8r7nUsixJQGx8zlYy7SKeewdEwcZtSHQIxpcxjT8sCIgHanPXixWthrnzvN4AAEuz8Q/+1v/BXOk3oRGBWShVdw0dfevBjNdbQpFAfzJUowBwYRMNhYjFREJ94uUi8ktXWv3gfdM7mMJ61IRwrZRpXKTeXLu5++YLRD3oefK3QXdv3cmrJaW5Y1k77/ZBJ79zhUPHUP/Cp+n/XYJ4HBCZagJ7Ir0kT1A39Q9aiFofDifubYPagtNNjtcQjK92CPqlMpaC0uCF1BBH/03/Hyd+4ewOKJfvIETonDhIotURhFUqn7I++z15a0Go40tQEcHl9f8+IGA77DQWsbH8UIsUOTM5neovgvRx0fxessTw5KPO+k7U/yh4oR2wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:34:56AM +0100, Andreas Hindborg wrote:
> Add Rust abstractions for working with `struct bio`, the core IO command
> descriptor for the block layer.
> 
> The `Bio` type wraps `struct bio` and provides safe access to the IO
> vector describing the data buffers associated with the IO command. The
> data buffers are represented as a vector of `Segment`s, where each
> segment is a contiguous region of physical memory backed by `Page`.
> 
> The `BioSegmentIterator` provides iteration over segments in a single
> bio, while `BioIterator` allows traversing a chain of bios. The
> `Segment` type offers methods for copying data to and from pages, as
> well as zeroing page contents, which are the fundamental operations
> needed by block device drivers to process IO requests.
> 
> The `Request` type is extended with methods to access the bio chain
> associated with a request, allowing drivers to iterate over all data
> buffers that need to be processed.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
>  rust/helpers/blk.c              |   8 +
>  rust/kernel/block.rs            |   1 +
>  rust/kernel/block/bio.rs        | 143 +++++++++++++++
>  rust/kernel/block/bio/vec.rs    | 389 ++++++++++++++++++++++++++++++++++++++++
>  rust/kernel/block/mq/request.rs |  46 +++++
>  rust/kernel/lib.rs              |   2 +
>  rust/kernel/page.rs             |   2 +-
>  7 files changed, 590 insertions(+), 1 deletion(-)
> 
> diff --git a/rust/helpers/blk.c b/rust/helpers/blk.c
> index cc9f4e6a2d234..53beba8c7782d 100644
> --- a/rust/helpers/blk.c
> +++ b/rust/helpers/blk.c
> @@ -1,5 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0
>  
> +#include <linux/bio.h>
>  #include <linux/blk-mq.h>
>  #include <linux/blkdev.h>
>  
> @@ -12,3 +13,10 @@ struct request *rust_helper_blk_mq_rq_from_pdu(void *pdu)
>  {
>  	return blk_mq_rq_from_pdu(pdu);
>  }
> +
> +void rust_helper_bio_advance_iter_single(const struct bio *bio,
> +					 struct bvec_iter *iter,
> +					 unsigned int bytes)
> +{
> +	bio_advance_iter_single(bio, iter, bytes);
> +}

__rust_helper

> diff --git a/rust/kernel/block/bio.rs b/rust/kernel/block/bio.rs
> new file mode 100644
> index 0000000000000..94062ea5281e6
> --- /dev/null
> +++ b/rust/kernel/block/bio.rs
> @@ -0,0 +1,143 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Types for working with the bio layer.
> +//!
> +//! C header: [`include/linux/blk_types.h`](../../include/linux/blk_types.h)

srctree/

> +/// A block device IO descriptor (`struct bio`).
> +///
> +/// A `Bio` is the main unit of IO for the block layer. It describes an IO command and associated
> +/// data buffers.
> +///
> +/// The data buffers associated with a `Bio` are represented by a vector of [`Segment`]s. These
> +/// segments represent physically contiguous regions of memory. The memory is represented by
> +/// [`Page`] descriptors internally.
> +///
> +/// The vector of [`Segment`]s can be iterated by obtaining a [`SegmentIterator`].
> +///
> +/// # Invariants
> +///
> +/// Instances of this type is always reference counted. A call to
> +/// `bindings::bio_get()` ensures that the instance is valid for read at least
> +/// until a matching call to `bindings :bio_put()`.

Refcounted? None of these methods are called anywhere, and you do not
implement AlwaysRefcounted.

> +#[repr(transparent)]
> +pub struct Bio(Opaque<bindings::bio>);
> +
> +impl Bio {
> +    /// Returns an iterator over segments in this `Bio`. Does not consider
> +    /// segments of other bios in this bio chain.
> +    #[inline(always)]
> +    pub fn segment_iter(&mut self) -> BioSegmentIterator<'_> {

Not `self: Pin<&mut Self>` here?

> +    /// Create an instance of `Bio` from a raw pointer.
> +    ///
> +    /// # Safety
> +    ///
> +    /// Caller must ensure that the `ptr` is valid for use as a reference to
> +    /// `Bio` for the duration of `'a`.
> +    #[inline(always)]
> +    pub(crate) unsafe fn from_raw<'a>(ptr: *mut bindings::bio) -> Option<&'a Self> {
> +        Some(
> +            // SAFETY: by the safety requirement of this funciton, `ptr` is
> +            // valid for read for the duration of the returned lifetime
> +            unsafe { &*NonNull::new(ptr)?.as_ptr().cast::<Bio>() },
> +        )
> +    }
> +
> +    /// Create an instance of `Bio` from a raw pointer.
> +    ///
> +    /// # Safety
> +    ///
> +    /// Caller must ensure that the `ptr` is valid for use as a unique reference
> +    /// to `Bio` for the duration of `'a`.
> +    #[inline(always)]
> +    pub(crate) unsafe fn from_raw_mut<'a>(ptr: *mut bindings::bio) -> Option<&'a mut Self> {
> +        Some(
> +            // SAFETY: by the safety requirement of this funciton, `ptr` is
> +            // valid for read for the duration of the returned lifetime
> +            unsafe { &mut *NonNull::new(ptr)?.as_ptr().cast::<Bio>() },

Why the Option? I imagine every caller has a non-null pointer?

> +        )
> +    }
> +}
> +
> +impl core::fmt::Display for Bio {

We have our own fmt trait now, right?

> +    fn fmt(&self, f: &mut fmt::Formatter<'_>) -> fmt::Result {
> +        write!(
> +            f,
> +            "Bio({:?}, vcnt: {}, idx: {}, size: 0x{:x}, completed: 0x{:x})",
> +            self.0.get(),
> +            self.io_vec_count(),
> +            self.raw_iter().bi_idx,
> +            self.raw_iter().bi_size,
> +            self.raw_iter().bi_bvec_done

This reads the entire `bi_iter` field three separate times. A local
variable may be a good idea.

> +/// An iterator over `Segment`
> +///
> +/// # Invariants
> +///
> +/// If `iter.bi_size` > 0, `iter` must always index a valid `bio_vec` in `bio.io_vec()`.
> +pub struct BioSegmentIterator<'a> {
> +    bio: &'a mut Bio,
> +    iter: bindings::bvec_iter,
> +}
> +
> +impl<'a> BioSegmentIterator<'a> {
> +    /// Creeate a new segemnt iterator for iterating the segments of `bio`. The

typo

> +impl<'a> core::iter::Iterator for BioSegmentIterator<'a> {
> +    type Item = Segment<'a>;
> +
> +    #[inline(always)]
> +    fn next(&mut self) -> Option<Self::Item> {
> +        if self.iter.bi_size == 0 {
> +            return None;
> +        }
> +
> +        // SAFETY: We checked that `self.iter.bi_size` > 0 above.
> +        let bio_vec_ret = unsafe { self.io_vec() };
> +
> +        // SAFETY: By existence of reference `&bio`, `bio.0` contains a valid
> +        // `struct bio`. By type invariant of `BioSegmentItarator` `self.iter`
> +        // indexes into a valid `bio_vec` entry. By C API contracit, `bv_len`
> +        // does not exceed the size of the bio.
> +        unsafe {
> +            bindings::bio_advance_iter_single(
> +                self.bio.0.get(),
> +                core::ptr::from_mut(&mut self.iter),

Creating this BioSegmentItarator copies the bvec_iter from the Bio, and
then here you modify the copy. Is that the intent? Is the C type such
that copying it is always okay?

Also, is the C type such that moves are ok? It's playsible that the
answer is yes - the same applies in rust/kernel/iov.rs but it could be
clearer in e.g. "Invariants" that this is the case.

Nit: core::ptr::from_mut(&mut self.iter) -> &raw mut self.iter

> +    /// Get a mutable reference to the first [`Bio`] in this request.
> +    #[inline(always)]
> +    pub fn bio_mut(&mut self) -> Option<&mut Bio> {
> +        // SAFETY: By type invariant of `Self`, `self.0` is valid and the deref
> +        // is safe.
> +        let ptr = unsafe { (*self.0.get()).bio };
> +        // SAFETY: By C API contract, if `bio` is not null it will have a
> +        // positive refcount at least for the duration of the lifetime of
> +        // `&self`.
> +        unsafe { Bio::from_raw_mut(ptr) }

Surely &mut requires refcount == 1, not just positive refcount?

Alice

