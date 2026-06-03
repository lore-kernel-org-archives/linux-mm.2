Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3C63DCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 10:41:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BEB96B0088; Wed,  3 Jun 2026 06:41:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5709D6B008A; Wed,  3 Jun 2026 06:41:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 485356B008C; Wed,  3 Jun 2026 06:41:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 36E036B0088
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:41:06 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A06D81202CC
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:41:05 +0000 (UTC)
X-FDA: 84838258890.02.9A14139
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id EC844A000D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:41:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N+OYS/J/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780483264;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s7g+YgnU5mYzWEYBRa4inLWSLO7CCiRf4ByLQT5tfZY=;
	b=Sk7I79sPKvDCdae657G9IumGiTHqIC8ASxi6OWnlNmE8V+CHuFXgR7s+eZMny3Rv9KkpXg
	xVxdZyMtmgBjbGRN1OCcTkcBz3J/GF7nzpj7z88p5N1kTfRJHy/gn3tabx+xu3XC25jNmq
	1wVfqBrwKaPQCpzP1e0P1Tp/GCFTfxM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="N+OYS/J/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780483264;
	b=DYGiojyTE49jPy73a5cg4XzDd6oRsCkwBKJHnJG6ZTaw9QVd3nAX01M32fSEUhJ9hftPLL
	wzWAiat7XaD7Fk7+4htKgRRm21PDLc/O1bCKw8otCngvbqBsvQqp43r33Yet8k5Hml5a/x
	rCIGfwuSb2PzmFPzxMSRGPBQsMjaHGM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 23DD940ADB;
	Wed,  3 Jun 2026 10:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DFBA1F00893;
	Wed,  3 Jun 2026 10:40:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780483263;
	bh=s7g+YgnU5mYzWEYBRa4inLWSLO7CCiRf4ByLQT5tfZY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=N+OYS/J/t3VZ0KZzQP4YJ7w3BTT26YT5oyBCWmyE1q1r+8mnOg1ld4b6EeAhfEAQ2
	 pKOVfEsgvxq6CHYTuRNjM/aCl1g+UUDrtSfrbHLWWldfsVfpP6duEcC+68+gwaSCaI
	 dIWSw1rsnuiHIxJLVJjZZPYrEJEQlJ6hvQvjWb36uGwEVc2z6RbBWI9jTXnMlfQ8bX
	 l1JIrwYR1XFBQ7LMeGvPkMcPdaloKd08pATKIFQuRV/nEBIrZzv3zOwPBZ3jcWC0uT
	 e6ICzSlXKZIzciWouRQiDt7rn0cphZRUkkZTLc/j87zkvtA5z9+YVAO8lHYB5DuyDv
	 mtamVBdFFBoBg==
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
Subject: Re: [PATCH 06/79] block: rust: add `Request` private data support
In-Reply-To: <abfXIqlT9qRhXssT@google.com>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-6-de9a7af4b469@kernel.org>
 <abfXIqlT9qRhXssT@google.com>
Date: Wed, 03 Jun 2026 12:40:49 +0200
Message-ID: <87se73kitq.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EC844A000D
X-Stat-Signature: prc3akkikeutjyuhdqht13dd8oksudwx
X-HE-Tag: 1780483263-600492
X-HE-Meta: U2FsdGVkX1/n92PHYe3EK0r33AB1DV/b41d/P4iPU2GX+vfRUMvtTl/tegUjB2a/A1iMJYaas4iPjxBHWKwUjSh0t3A5+b91aoJyAQer86l0ZO25vQe/Qz4GmZujuBJ6RqPQKTC7UUYDZZfX5r9w4aJm0wkE4/POj7zppQUGgq95KGq4U5r0RdNBLWT5thMMkuGncr/cV++Nb38c54YYSBTm5LvhF+l3vx5vvBnhipXj5MYhOTrRLwRgBDzkuipaGpYHwANweZbBmxsYZSn+rf39lU5WyQ/WVJEtTMZ31LUlWUU5i+Mpw4TZ5YoLjYepJ6UNOxuOhdfNeSykXVAM1oLa4jOXnz0S19prLk0nzSnY5BKJvNzZ5aE8oyfHfyeAGqP2mX5IRSLvGPp1ImMkQ71iOw5DlFcV5ouFeIELG2xderf5HpDwCrJu6aBiZtccNLEmVV2bAqlkXaL8p34VsQTkSQRHX8QrrtHXzRcdmDim1lvtBlngTTyrqw7pOxmbpjImBSF3iAdoQNv4+YaS7OjMHzaGCJacp3CoYnrZqtaX2p/ncmNIRlEJ/m1il2zyBXZFmRLsG29R+mD9krd02Rb1+DxjTtuui/GDWXerneV7D2nL7RtMnag46t8Aio0DMVlHbESolKFEWQroDh7aqH+nS4U9hgtv0VK+xPOC0GMKSYB7juAXDthrXzq9C6pmqgBlkd1YT/SpuV9xZMnaDsRUYFeDyogGeJD3WETmMDgHgnxmd9aev3PG6+F64Zk8NB5fCoOf5mrCgzC9GwxCzDg+HpFmzLLnuVaY7jyStuR8PRX5/m0EamqofoV3PGOKDjiSFA+C03P8yQN2HFDH+KGBfN4QT8rZyug3Vyr8E+D7s8E6pPG365sSj31lPx0n6P6qOsnFyFjELKRvheYwr4Wv0Uz4fDUFodCLhugOXP2E4teRyq8PYEo+4hby8nDCPasVoUaDuUKfTH+wfFe
 1NqfcrV+
 /o/JHzux01NB7CXhjcDZ72xCWgfRUsL6myt9giuhnB6JFQSrf0Tj4VNbs+JSI/BNuSfRLO0wAk51Nn2WlGb+g4Ok7aKD0Y45aJvUjr+ZUw7c0eV0mKvayRzqYBMAM+5hmb1eK6IPiP9yepRZ3yoLy6i+7Yokq5z92Fs7Rj4ivALdt+kFjcPZjR+oBm8/fLuRSmpRVYyrkCKX1pL/xOJIZXMZPWedRR912hj+Ph/sRtenXyjjXgmd5TuOEmqlra1UBUytgDt45hCsQNPC60ZDSN1z39xusiHwGO9huWYvS7iEW61RWEk1CjDjpQ13SClVbwIZs/e+cu11BdcE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Mon, Feb 16, 2026 at 12:34:53AM +0100, Andreas Hindborg wrote:
>> C block device drivers can attach private data to a `struct request`. This
>> data is stored next to the request structure and is part of the request
>> allocation set up during driver initialization.
>> 
>> Expose this private request data area to Rust block device drivers.
>> 
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
> Overall looks ok. A few nits below:
>
>> ---
>>  drivers/block/rnull/rnull.rs       |  5 +++++
>>  rust/kernel/block/mq.rs            |  6 ++++++
>>  rust/kernel/block/mq/operations.rs | 24 +++++++++++++++++++++++-
>>  rust/kernel/block/mq/request.rs    | 24 +++++++++++++++++++-----
>>  rust/kernel/block/mq/tag_set.rs    |  2 +-
>>  5 files changed, 54 insertions(+), 7 deletions(-)
>> 
>> diff --git a/drivers/block/rnull/rnull.rs b/drivers/block/rnull/rnull.rs
>> index 6a7f660d31998..065639fc4f941 100644
>> --- a/drivers/block/rnull/rnull.rs
>> +++ b/drivers/block/rnull/rnull.rs
>> @@ -134,6 +134,11 @@ struct QueueData {
>>  #[vtable]
>>  impl Operations for NullBlkDevice {
>>      type QueueData = KBox<QueueData>;
>> +    type RequestData = ();
>> +
>> +    fn new_request_data() -> impl PinInit<Self::RequestData> {
>> +        pin_init::zeroed::<Self::RequestData>()
>
> Simpler to just return Ok(()) here.

Not sure why I picked zeroed. Will change.

>
>> +    }
>>  
>>      #[inline(always)]
>>      fn queue_rq(queue_data: &QueueData, rq: Owned<mq::Request<Self>>, _is_last: bool) -> Result {
>> diff --git a/rust/kernel/block/mq.rs b/rust/kernel/block/mq.rs
>> index b8ecd69abe980..a285b753ada88 100644
>> --- a/rust/kernel/block/mq.rs
>> +++ b/rust/kernel/block/mq.rs
>> @@ -69,8 +69,14 @@
>>  //!
>>  //! #[vtable]
>>  //! impl Operations for MyBlkDevice {
>> +//!     type RequestData = ();
>>  //!     type QueueData = ();
>>  //!
>> +//!     fn new_request_data(
>> +//!     ) -> impl PinInit<()> {
>> +//!         pin_init::zeroed::<()>()
>
> Simpler to just return Ok(()) here.

Will change.

>
>> +//!     }
>> +//!
>>  //!     fn queue_rq(_queue_data: (), rq: Owned<Request<Self>>, _is_last: bool) -> Result {
>>  //!         rq.end_ok();
>>  //!         Ok(())
>> diff --git a/rust/kernel/block/mq/operations.rs b/rust/kernel/block/mq/operations.rs
>> index 3dea79d647ff7..cd37b939bbf30 100644
>> --- a/rust/kernel/block/mq/operations.rs
>> +++ b/rust/kernel/block/mq/operations.rs
>> @@ -13,6 +13,7 @@
>>      types::{ForeignOwnable, Owned},
>>  };
>>  use core::{marker::PhantomData, ptr::NonNull};
>> +use pin_init::PinInit;
>>  
>>  type ForeignBorrowed<'a, T> = <T as ForeignOwnable>::Borrowed<'a>;
>>  
>> @@ -28,10 +29,24 @@
>>  /// [module level documentation]: kernel::block::mq
>>  #[macros::vtable]
>>  pub trait Operations: Sized {
>> +    /// Data associated with a request. This data is located next to the request
>> +    /// structure.
>> +    ///
>> +    /// To be able to handle accessing this data from interrupt context, this
>> +    /// data must be `Sync`.
>> +    ///
>> +    /// The `RequestData` object is initialized when the requests are allocated
>> +    /// during queue initialization, and it is are dropped when the requests are
>> +    /// dropped during queue teardown.
>> +    type RequestData: Sized + Sync;
>
> It was surprising to me that `request` is reused over many requests. I
> think it could be a bit more obvious in the wording.

I will add a bit of info in the `Request` type docs.

>
>>      /// Data associated with the `struct request_queue` that is allocated for
>>      /// the `GenDisk` associated with this `Operations` implementation.
>>      type QueueData: ForeignOwnable;
>>  
>> +    /// Called by the kernel to get an initializer for a `Pin<&mut RequestData>`.
>> +    fn new_request_data() -> impl PinInit<Self::RequestData>;
>> +
>>      /// Called by the kernel to queue a request with the driver. If `is_last` is
>>      /// `false`, the driver is allowed to defer committing the request.
>>      fn queue_rq(
>> @@ -236,6 +251,13 @@ impl<T: Operations> OperationsVTable<T> {
>>              // it is valid for writes.
>>              unsafe { RequestDataWrapper::refcount_ptr(pdu.as_ptr()).write(Refcount::new(0)) };
>>  
>> +            let initializer = T::new_request_data();
>> +
>> +            // SAFETY: `pdu` is a valid pointer as established above. We do not
>> +            // touch `pdu` if `__pinned_init` returns an error. We promise ot to
>
> typo
>
>
>> diff --git a/rust/kernel/block/mq/tag_set.rs b/rust/kernel/block/mq/tag_set.rs
>> index c3cf56d52beec..46481754b1335 100644
>> --- a/rust/kernel/block/mq/tag_set.rs
>> +++ b/rust/kernel/block/mq/tag_set.rs
>> @@ -41,7 +41,7 @@ pub fn new(
>>          // SAFETY: `blk_mq_tag_set` only contains integers and pointers, which
>>          // all are allowed to be 0.
>>          let tag_set: bindings::blk_mq_tag_set = unsafe { core::mem::zeroed() };
>> -        let tag_set: Result<_> = core::mem::size_of::<RequestDataWrapper>()
>> +        let tag_set: Result<_> = core::mem::size_of::<RequestDataWrapper<T>>()
>
> size_of in prelude.

Fixed.

Thanks,
Andreas


