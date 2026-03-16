Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59AD1F46444
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 10:10:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A293C6B0175; Mon, 16 Mar 2026 06:10:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D6B46B0176; Mon, 16 Mar 2026 06:10:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B7E86B0177; Mon, 16 Mar 2026 06:10:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 790B56B0175
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 06:10:47 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 471371A018E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:10:47 +0000 (UTC)
X-FDA: 84551507334.09.137A233
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf24.hostedemail.com (Postfix) with ESMTP id 7685418000A
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 10:10:45 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V9fis+On;
	spf=pass (imf24.hostedemail.com: domain of 3I9e3aQkKCAYgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3I9e3aQkKCAYgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773655845;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R3ZhqgEQpEubXh2g+cxD+FKnnV49bXXiNz3andESbr8=;
	b=QgjM2N1EJs/NKkqTKyzkipuA9//KzIoeW5Q/E5KKu8nrl2lbbrfCgyNuBjFUBzt9p/OFRl
	W7qN9gj6GecFrbUeWLqyOjjTl6v6BGvxlCv+L9Q5hiyEGHh8wI49UyIgFTQqN2nBt4jpb2
	nEJo8om5ImR6OT5kgJUQWmaVlwTABZY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773655845; a=rsa-sha256;
	cv=none;
	b=32FuyHFOH9PE/ci4LHIkAcmdtFga4b4X2Zq0l0UNWJuk5oUOq8dERyQPTFvQ2onCmbOmMQ
	Gg557kriqgDVBiodvGdzWGxKkGBEtucuFaSKDxd6q5KGLqJKihpuGcSruUrErWh1z3Nypn
	vbnaoMV2qJztBDJdqySmnrqPIc/Gn5U=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V9fis+On;
	spf=pass (imf24.hostedemail.com: domain of 3I9e3aQkKCAYgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3I9e3aQkKCAYgroikx4nrmuumrk.iusrot03-ssq1giq.uxm@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4839fc4cef6so51154235e9.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 03:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773655844; x=1774260644; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=R3ZhqgEQpEubXh2g+cxD+FKnnV49bXXiNz3andESbr8=;
        b=V9fis+OniXoscDWSrrmyMKDB4Y0xQwxt744aYrV6nHbgQSQ3blULma0fgqZSgij7rP
         wUWpmRIneGoIwLtBT+XvZ2gII9ptDumXnqqBBEy56zMLOMBOqRu+8aKIZhSFWMrOOqIH
         0LADypcPFFUNqkvLMFyMACuJMM3SjCKWmNYkY5XIwr0gphv6zmRgSPl8M/G9pIB3ttPG
         tZz1dTH1+1FgmfXhJ+dA1XyFvAbJnwucjEtANEjaTW9LZngJXdRP4JsNAH3eGBY/yjM1
         Bhjds8+/sdqnsBLqUjIVDbfx72olwiohHPhfLJwRSoI4N4afvXZtZTfDbDFxNKgpvsUt
         qSgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773655844; x=1774260644;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R3ZhqgEQpEubXh2g+cxD+FKnnV49bXXiNz3andESbr8=;
        b=Uc3JvvL4hoj8wkLOIG9RwHqPRg8wvNHd8446152G6b4e2FmIOrKKepzDcTiTQPuhlG
         1ICct6F5pynN/7vs3VoYMDoyNXHarChmMNEP1bEDrrZ/ViuPtOncoZIRIVQSez8T2ULJ
         caeg9Q6iAarEVQDw5629Xb+wRos1Eq/hwjooIMj4SRRvxbepkh/Qw7xViYSNc7DDP/OE
         8ixD7lFF04HmemXeG7TZOvjsVj/WD8nR3pwXcHjN0UfjLh2rpy0qsRBC9ltAMtoBcqVz
         H9LLEHUYVpAwJtHL9RW7Nem9KFqlBWGGhi1U+uUTggJG+QIW4fKviKmZ0yRegir6lZl0
         0hYQ==
X-Forwarded-Encrypted: i=1; AJvYcCWROBX4qms8YPZqfT3IOunkKZ/mAPhlf+Nb5kTBlffF1epkRqGfNEOLC5ABN6+KGAB2sUymf6reeg==@kvack.org
X-Gm-Message-State: AOJu0YwzWQ+1FWGRUD7ulSOG+ehm/9i+q6ddiZsz7SpKoR/CXuXFi7q6
	ZyRuyyza2OPyaOI86lwcQEh39qjXOLwCOkhJ3E20td4CdFLnQcpjGfjFm8yShS2I/qjPSw5w+Ga
	WZsWnrFImOo+LbhnWQA==
X-Received: from wmbd13.prod.google.com ([2002:a05:600c:58cd:b0:485:3b8d:c995])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3b07:b0:485:3989:b3e4 with SMTP id 5b1f17b1804b1-48555ac5e34mr195198785e9.6.1773655843552;
 Mon, 16 Mar 2026 03:10:43 -0700 (PDT)
Date: Mon, 16 Mar 2026 10:10:42 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-6-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-6-de9a7af4b469@kernel.org>
Message-ID: <abfXIqlT9qRhXssT@google.com>
Subject: Re: [PATCH 06/79] block: rust: add `Request` private data support
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
X-Rspamd-Queue-Id: 7685418000A
X-Stat-Signature: zgymq774iozjm7mxcdkz3suact3ppn8n
X-Rspam-User: 
X-HE-Tag: 1773655845-598041
X-HE-Meta: U2FsdGVkX1+4gVnu4THJXRjNsAjTXR/ST6KafUco+ueFw0hrsWSOy+47Z6sWAsxYNH4N9oV9H7SlirdOIAheM+JFhVQCzc1HXWcM+hA+apl7sULbS7YMmDifmw/gpyvI4E20QDV41ZbXIrIAUWRCDiR5YX0YrKm1Vu8k28ahhPY9232wdsOkE7ETgEEGA5BcZNps0nG8IEgABdolr/LBEpkjKhhW6olGUbvJQmDtAElg1JRUTwyLHiauOUdTe/Oa2h+N4UFe385R17LKnUbs24TZMm4tuQYbxsDLJEZNJAAEls3Os1OEvIZEcMSfJhJOOzwyXh4ctr3JLL7kJCbdV9Kxh2uzm/mren6355TQp7Jg4iM7dLurhQIltb+RlCdotsPW1pEaNMA7DMbbaeIvpGLLOLdYIeugXkj+Ezt1GHK8KkSl0ompJVc/OZjZkKEzbaC/3iAeGJ40SF6CsYbhJkst034u4j9RcM2AosxICPMaedHfb8FdC0Gans7auOP9e7SKhwNHCNekdmNxVw8g4yuTthAHAV4BIDi9k6WqJTtmSv0hHNMtQAoFKkYzskD4WHW+Y7FNDvmMhNIYjzhvqNKSxQ4G10pYKSIopQLZWz4USgZ5GOYjhN7zWFCsRVzT19ICuuAVwLZWvowUwaYqMFbWbTpXiHUdNq019mFqg6P3sDEBEcGRAxWltPw4hAzoO12wUng6am0WInvgjpmMWnkXDlhTW4pCr5DcDTPWP+cjRyolcFf5WLNZwq0kk9NSZqvS67/G5GB3HQg25GO6TqXPuVbSEj2BqRQvmZk5QpEx42zoelrdoW9fZtToFAevjRot+bDQK5W3gALpReEswRgrEE9e4N8tDqkqc2Sl5qtY15Fzsji2amL6R721QJ0QCTGb515taLmvxaNOW57YKXN8P3nZsvZgwTMD4SclMpYS4zcjEcj6tn3EtLcQdX0q060z6ANFy58pUBJeHvj
 TpVYm4Ti
 hE9B+kqiTGWbj4+x9NMFFfy8vpxCjEAFDbT0/pERU8LK0u2V0blgjrcpnpBHotDnsUtBlzgIE4V14IsHxJR+lF32Xi89ZHs/E5m9rsG4yYX3m/cPj+dyD9MJTDPKWDzF/WqiGOLb3n7kYk0E/zxXpXx4BcYfG5mVzsJfuA8VDTRrz1Bn9xsmVHfnyZZ6kPTx2NC04WCPry3FL6s4lAwO8ymiV9K/TQWWZOcUVebWsPZ+uD6tgAdgH3H/lvNm/lL4UdWqxvyCt7TDKWnxRCrx2uLhF7/d0v7cPhj1e5xQV1jc42LggorBo01KHFyRFNH9GoyuJMqC8J3ppaADyp8pdOzLLd4sBm0Ugv8Li/FGdaVOiV69Lkjz9lvQV883C7eN5OmMDXmxYpZ3i9NmdZap8Q4CaLWkdo4LjUCsPB4qWZTqn06tzW4lHAeZa+NfL8anQqnwHGkgmjBoQY2hZNB2Sd56MRfI8OhM/yUvnb5u3doWeazoSAozNgaDRrDcjgA4zKCIK2CsA3fW90s90kDmK/tW51qaqQ+6ccTV5OeuZuYuM7PfiL/PfN/HQdyZ1OwF/RCeT8ismf1vW2M09qkSyUO/35yUlv6Rn9jYgSoTT/HoA9gxHIwsoNWjkzwl5bia2O26U5DQ3k73tSr2CAWdoIwPV0RmeO07n/r9MOTJu2yJ8R+AzzgTho9rE9G4ir3+fVJkwEnSreT0X/ErleRydjI6QAR4qRtX0Ts0kCzuj71FA3qQwFWkst+uUzPF4ilK2bMIn/aMZvf+lDHOlYOPKc2a8JiVa7UUOkvTG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:34:53AM +0100, Andreas Hindborg wrote:
> C block device drivers can attach private data to a `struct request`. This
> data is stored next to the request structure and is part of the request
> allocation set up during driver initialization.
> 
> Expose this private request data area to Rust block device drivers.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

Overall looks ok. A few nits below:

> ---
>  drivers/block/rnull/rnull.rs       |  5 +++++
>  rust/kernel/block/mq.rs            |  6 ++++++
>  rust/kernel/block/mq/operations.rs | 24 +++++++++++++++++++++++-
>  rust/kernel/block/mq/request.rs    | 24 +++++++++++++++++++-----
>  rust/kernel/block/mq/tag_set.rs    |  2 +-
>  5 files changed, 54 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
> index 6a7f660d31998..065639fc4f941 100644
> --- a/drivers/block/rnull/rnull.rs
> +++ b/drivers/block/rnull/rnull.rs
> @@ -134,6 +134,11 @@ struct QueueData {
>  #[vtable]
>  impl Operations for NullBlkDevice {
>      type QueueData = KBox<QueueData>;
> +    type RequestData = ();
> +
> +    fn new_request_data() -> impl PinInit<Self::RequestData> {
> +        pin_init::zeroed::<Self::RequestData>()

Simpler to just return Ok(()) here.

> +    }
>  
>      #[inline(always)]
>      fn queue_rq(queue_data: &QueueData, rq: Owned<mq::Request<Self>>, _is_last: bool) -> Result {
> diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
> index b8ecd69abe980..a285b753ada88 100644
> --- a/rust/kernel/block/mq.rs
> +++ b/rust/kernel/block/mq.rs
> @@ -69,8 +69,14 @@
>  //!
>  //! #[vtable]
>  //! impl Operations for MyBlkDevice {
> +//!     type RequestData = ();
>  //!     type QueueData = ();
>  //!
> +//!     fn new_request_data(
> +//!     ) -> impl PinInit<()> {
> +//!         pin_init::zeroed::<()>()

Simpler to just return Ok(()) here.

> +//!     }
> +//!
>  //!     fn queue_rq(_queue_data: (), rq: Owned<Request<Self>>, _is_last: bool) -> Result {
>  //!         rq.end_ok();
>  //!         Ok(())
> diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
> index 3dea79d647ff7..cd37b939bbf30 100644
> --- a/rust/kernel/block/mq/operations.rs
> +++ b/rust/kernel/block/mq/operations.rs
> @@ -13,6 +13,7 @@
>      types::{ForeignOwnable, Owned},
>  };
>  use core::{marker::PhantomData, ptr::NonNull};
> +use pin_init::PinInit;
>  
>  type ForeignBorrowed<'a, T> = <T as ForeignOwnable>::Borrowed<'a>;
>  
> @@ -28,10 +29,24 @@
>  /// [module level documentation]: kernel::block::mq
>  #[macros::vtable]
>  pub trait Operations: Sized {
> +    /// Data associated with a request. This data is located next to the request
> +    /// structure.
> +    ///
> +    /// To be able to handle accessing this data from interrupt context, this
> +    /// data must be `Sync`.
> +    ///
> +    /// The `RequestData` object is initialized when the requests are allocated
> +    /// during queue initialization, and it is are dropped when the requests are
> +    /// dropped during queue teardown.
> +    type RequestData: Sized + Sync;

It was surprising to me that `request` is reused over many requests. I
think it could be a bit more obvious in the wording.

>      /// Data associated with the `struct request_queue` that is allocated for
>      /// the `GenDisk` associated with this `Operations` implementation.
>      type QueueData: ForeignOwnable;
>  
> +    /// Called by the kernel to get an initializer for a `Pin<&mut RequestData>`.
> +    fn new_request_data() -> impl PinInit<Self::RequestData>;
> +
>      /// Called by the kernel to queue a request with the driver. If `is_last` is
>      /// `false`, the driver is allowed to defer committing the request.
>      fn queue_rq(
> @@ -236,6 +251,13 @@ impl<T: Operations> OperationsVTable<T> {
>              // it is valid for writes.
>              unsafe { RequestDataWrapper::refcount_ptr(pdu.as_ptr()).write(Refcount::new(0)) };
>  
> +            let initializer = T::new_request_data();
> +
> +            // SAFETY: `pdu` is a valid pointer as established above. We do not
> +            // touch `pdu` if `__pinned_init` returns an error. We promise ot to

typo


> diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
> index c3cf56d52beec..46481754b1335 100644
> --- a/rust/kernel/block/mq/tag_set.rs
> +++ b/rust/kernel/block/mq/tag_set.rs
> @@ -41,7 +41,7 @@ pub fn new(
>          // SAFETY: `blk_mq_tag_set` only contains integers and pointers, which
>          // all are allowed to be 0.
>          let tag_set: bindings::blk_mq_tag_set = unsafe { core::mem::zeroed() };
> -        let tag_set: Result<_> = core::mem::size_of::<RequestDataWrapper>()
> +        let tag_set: Result<_> = core::mem::size_of::<RequestDataWrapper<T>>()

size_of in prelude.

Alice

