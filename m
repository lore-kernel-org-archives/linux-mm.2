Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA1DDCD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 10:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068B26B008A; Wed,  3 Jun 2026 06:15:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 019DD6B008C; Wed,  3 Jun 2026 06:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4A8E6B0092; Wed,  3 Jun 2026 06:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D214B6B008A
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 06:15:57 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B76740309
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:15:57 +0000 (UTC)
X-FDA: 84838195554.01.757951B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id CDB1240011
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 10:15:55 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtSSZsou;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780481755;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/1qAgvTTvf0xlsZiADLfe2fg7WDkq6Xjj3OBNJ3gL8s=;
	b=5AgrhyHxG1WGQkoGhtlPT2Sa2TR9+CW09Cxy+qQZVn7g1nEugNigH1KYLbyKjaxjN5/Qco
	EuzbAoueCQgq3dSooDemQpW8CU7qpK2HNJVyf/DeL4QA2cYPwe81poWpWsUybRczRJG/C8
	9ent+7Fettx6Kc7/g9pDEZ/5MSkXXWM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gtSSZsou;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780481755;
	b=npWT6wtLhOHEL1rf8aEG7T9Drg0bZqPFKlfUTdX62wYHH7LH8aflktVj0HNh4TK9WZ9ZEW
	QmZ7osgjCtzcEme2k51NAag39FG3SG12teuege+CevFvUDGHShlPnyKGPWcYO6WoumdzAB
	I8BT+Z4PyrUbrJ+BMgJRbIOpDsYObbA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DBE6743490;
	Wed,  3 Jun 2026 10:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8191F00893;
	Wed,  3 Jun 2026 10:15:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780481754;
	bh=/1qAgvTTvf0xlsZiADLfe2fg7WDkq6Xjj3OBNJ3gL8s=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date;
	b=gtSSZsouD8cpySavp5/KCA2H4xsJ0k33u5QsI54YwWdTBvVrwh1EQJoZKLTUcRYDi
	 nMKVQ25m+DVsx7fnEUljFRRXcSps9Wa9xplTuvBA5+rr1nNS3aWK8UBwzAydajFHxf
	 HtFrhyeERBNXQ08tv3rlbDHPQ4gXWnGgHTEbcq/9rfB6r8DVzepSZohFqaZ/SNpYym
	 4UQSfaBL0iflTvEzNtyqsATxsoImbcfFZU+5b3Nb/jW8Uhl1hxHeDtJsFffRvBG22n
	 wQBNPD6ldeFmVIinRjFx9C81t9ZjoHXZJSwCafXds57TqF+Yf4PP/248p/pEympUZF
	 kZ9QODUrn7mSA==
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
Subject: Re: [PATCH 24/79] block: rust: add `BadBlocks` for bad block tracking
In-Reply-To: <abfvrh0ObKhtsR8I@google.com>
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org>
 <20260216-rnull-v6-19-rc5-send-v1-24-de9a7af4b469@kernel.org>
 <abfvrh0ObKhtsR8I@google.com>
Date: Wed, 03 Jun 2026 12:15:41 +0200
Message-ID: <87wlwgj5f6.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: p8ggfwxuq7ehgw8jwaddibu5pi97okuu
X-Rspamd-Queue-Id: CDB1240011
X-HE-Tag: 1780481755-404606
X-HE-Meta: U2FsdGVkX1/l637VXhvJl2DsFQemkQj6cAYJEFqnBwSD7J6UvFUD6ohq+Jz4oedSV1HazMasQZPes+1/4l+iyXXsHw6+gMMRfWTt8yNagxIVLYwxSgKu+uMxtEgEEAFkQFJbNDw4jY04HWF3K4c9vGlnpt2ktrjbng85cNhS2cVQ1ciaE+pR0lHBH7T9+0DSc37MIvuELDTN+Ti2IBDNPIV4uj8XZCNJu/mGVYv8ktY4QBU1heA3XRWFwIN/89LEfZOr0itdpZyyfyMBYr5hpW5pVtdq4JB4wRMXJTTny2WiepuZELVEeHApJuosGXNygtaIDj8F74K5amC0cH1ZHLoJHdFFPteVYC4S93E8VIaSLGYq5ISVWHdAprp7zG5XPpb0693RIrFqf0T3xKTqZcwVw4aFjipFbKQrG6XtBP2frvtc+0XGdUA4sVkcrXj9h5X6lElNQTAnI3fZNnzsqLvQTA7/ZulyM33Iv1JGbwGYBJ8nLdFNkUuJDgpLlB8CaCPTOCMr0VWZcIhjZ5ScTY0IuqteoDAqsvw5eXtUs1Y12IZPGMtoOp2XKrtLtr1c3BRzqn/ojFF+M4YVcJYchl2AU8mWE4P1r6AZYLUjGgH0IeDcTHz4dSv+lORODEVLrsCSWf9OWX764V8FqfVIZjTn0FfSJ/ZrAWKw42+K3mhPfBGYUfPiEQMAjDK7L5OK9rCS4dAYGddcCIave3bmNLN5uTCE7pDu4klk0N0OqvdUedhp+qcZjRnuDqjpxfXf2jQaglLtYghFnqjjJeU4AqAxmZUPzz14QR7ZkBefIJb6DaC5SKtns+OOHHwCy2TPDkvscp0gKOt7R3BRZ75AFzC64zQqe9GmW4zYRppTTXgWTgL3Ny83JAQgWIvr5f3bRvkwIau2i3qlGbmibxxuj/JVoCjIb5/uZdIXEmK5nKFusZXa8adCzMO/Ja2cX1a8sr6JKCQJdQAriRrW1Q1
 2LqZPVTS
 OsywN9eTM1Sy7oDw+9tgDYpP7+b7bwEZ2pFnQ99ZEhtUScrxMgGcfqyb6Txs8QrLa1BKm7BfmGd9n4DAOcnZwdzmNXQm7NA0nL7sZKGkLKRFbPZxbLEpIESjHcWhUm8ZmNdbEBQ4gfQr3H+8/D+OjskvTr/tW30455HNmZac/Gku0l5V71nPlW5TYYfOiqXLNQyCYwqcIGms7ti68PuKkUG00d6iyZhTWgql11oP/B9UsbvoJcMWgyjQPkiFG7T4QIqRUdNeTBUQMdV/ErZ8ayixQJwNgamWwz8asVxN/ZWGGXiSzrT4EYaVOJULC7wv5px3gcTsj4rNbiNKc2FQjySv1K73zsaDirKTBF0uS/69ot86rnVIXnTB31JAYTXV05S5D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Mon, Feb 16, 2026 at 12:35:11AM +0100, Andreas Hindborg wrote:
>> Add a safe Rust wrapper around the Linux kernel's badblocks infrastructure
>> to track and manage defective sectors on block devices. The BadBlocks type
>> provides methods to:
>> 
>> - Mark sectors as bad or good (set_bad/set_good)
>> - Check if sector ranges contain bad blocks (check)
>> - Automatically handle memory management with PinnedDrop
>> 
>> The implementation includes comprehensive documentation with examples for
>> block device drivers that need to avoid known bad sectors to maintain
>> data integrity. Bad blocks information is used by device drivers,
>> filesystem layers, and device management tools.
>> 
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
>> diff --git a/rust/kernel/block/badblocks.rs b/rust/kernel/block/badblocks.rs
>> new file mode 100644
>> index 0000000000000..a5fe0fde2e755
>> --- /dev/null
>> +++ b/rust/kernel/block/badblocks.rs
>> @@ -0,0 +1,721 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +//! Bad blocks tracking for block devices.
>> +//!
>> +//! This module provides a safe Rust wrapper around the badblocks
>> +//! infrastructure, which is used to track and manage bad sectors on block
>> +//! devices. Bad blocks are sectors that cannot reliably store data and should
>> +//! be avoided during I/O operations.
>
> Could use a srctree link to badblocks.h here.

Will add.

>
>> +/// # Examples
>> +///
>> +/// Basic usage:
>> +///
>> +/// ```rust
>> +/// # use kernel::block::badblocks::{BadBlocks, BlockStatus};
>> +/// # use kernel::prelude::*;
>> +///
>
> Unhide the imports or remove this empty line.

Ok.

>
>> +/// // Create a new bad blocks tracker
>> +/// let bad_blocks = KBox::pin_init(BadBlocks::new(true), GFP_KERNEL)?;
>> +///
>> +/// // Mark sectors 100-109 as bad (unacknowledged)
>> +/// bad_blocks.set_bad(100..110, false)?;
>> +///
>> +/// // Check if sector range 95-104 contains bad blocks
>> +/// match bad_blocks.check(95..105) {
>> +///     BlockStatus::None => pr_info!("No bad blocks found"),
>> +///     BlockStatus::Acknowledged(range) => pr_warn!("Acknowledged bad blocks: {:?}", range),
>> +///     BlockStatus::Unacknowledged(range) => pr_err!("Unacknowledged bad blocks: {:?}", range),
>> +/// }
>> +/// # Ok::<(), kernel::error::Error>(())
>> +/// ```
>> +/// # Invariants
>> +///
>> +/// - `self.blocks` is a valid `bindings::badblocks` struct.
>> +#[pin_data(PinnedDrop)]
>> +pub struct BadBlocks {
>> +    #[pin]
>> +    blocks: Opaque<bindings::badblocks>,
>> +}
>> +
>> +impl BadBlocks {
>> +    /// Creates a new bad blocks tracker.
>> +    ///
>> +    /// Initializes an empty bad blocks tracker that can manage defective sectors
>> +    /// on a block device. The tracker starts with no bad blocks recorded and
>> +    /// allocates a single page for storing bad block entries.
>> +    ///
>> +    /// # Returns
>> +    ///
>> +    /// Returns a [`PinInit`] that can be used to initialize a [`BadBlocks`] instance.
>> +    /// Initialization may fail with `ENOMEM` if memory allocation fails.
>> +    ///
>> +    /// # Examples
>> +    ///
>> +    /// ```rust
>> +    /// # use kernel::block::badblocks::{BadBlocks, BlockStatus};
>> +    /// # use kernel::prelude::*;
>> +    ///
>
> Ditto. (Many times throughout file.)
>
>> +    /// // Create and initialize a bad blocks tracker
>> +    /// let bad_blocks = KBox::pin_init(BadBlocks::new(true), GFP_KERNEL)?;
>> +    ///
>> +    /// // The tracker is ready to use with no bad blocks initially
>> +    /// match bad_blocks.check(0..100) {
>> +    ///     BlockStatus::None => pr_info!("No bad blocks found initially"),
>> +    ///     _ => unreachable!(),
>> +    /// }
>> +    /// # Ok::<(), kernel::error::Error>(())
>> +    /// ```
>> +    pub fn new(enable: bool) -> impl PinInit<Self, Error> {
>> +        // INVARIANT: We initialize `self.blocks` below. If initialization fails, an error is
>> +        // returned.
>> +        try_pin_init!(Self {
>> +            blocks <- Opaque::try_ffi_init(|slot| {
>> +                // SAFETY: `slot` is a valid pointer to uninitialized memory
>> +                // allocated by the Opaque type. `badblocks_init` is safe to
>> +                // call with uninitialized memory.
>> +                to_result(unsafe {bindings::badblocks_init(slot, if enable {1} else {0})})
>
> I think you can just cast the boolean to an integer.

Ok.

>
> Also, formatting here is off (but ignored by rustfmt due to macro.)

Will try to fix.

>
>> +    /// Enables the bad blocks tracker if it was previously disabled.
>> +    ///
>> +    /// Attempts to enable bad block tracking by transitioning the tracker from
>> +    /// a disabled state to an enabled state.
>> +    ///
>> +    /// # Behavior
>> +    ///
>> +    /// - If the tracker is disabled, it will be enabled.
>> +    /// - If the tracker is already enabled, this operation has no effect.
>> +    /// - The operation is atomic and thread-safe.
>> +    ///
>> +    /// # Usage
>> +    ///
>> +    /// Bad blocks trackers can be created in a disabled state and enabled later
>> +    /// when needed. This is useful for conditional bad block tracking or for
>> +    /// deferring activation until the device is fully initialized.
>> +    ///
>> +    /// # Examples
>> +    ///
>> +    /// ```rust
>> +    /// # use kernel::block::badblocks::BadBlocks;
>> +    /// # use kernel::prelude::*;
>> +    ///
>> +    /// // Create a disabled bad blocks tracker
>> +    /// let bad_blocks = KBox::pin_init(BadBlocks::new(false), GFP_KERNEL)?;
>> +    /// assert!(!bad_blocks.enabled());
>> +    ///
>> +    /// // Enable it when needed
>> +    /// bad_blocks.enable();
>> +    /// assert!(bad_blocks.enabled());
>> +    ///
>> +    /// // Subsequent enable calls have no effect
>> +    /// bad_blocks.enable();
>> +    /// assert!(bad_blocks.enabled());
>> +    /// # Ok::<(), kernel::error::Error>(())
>> +    /// ```
>> +    pub fn enable(&self) {
>> +        let _ = self.shift_ref().cmpxchg(-1, 0, ordering::Relaxed);
>
> Is there not a C function you can call here? It would be simpler that
> way. Surely drivers don't do this directly.

No, this is the canonical way [1].

[1] https://github.com/torvalds/linux/blob/ba3e43a9e601636f5edb54e259a74f96ca3b8fd8/drivers/block/null_blk/main.c#L563

>
>> +    }
>> +
>> +    /// Checks whether the bad blocks tracker is currently enabled.
>> +    ///
>> +    /// Returns `true` if bad block tracking is active, `false` if it is disabled.
>> +    /// When disabled, the tracker will not perform bad block checks or operations.
>> +    ///
>> +    /// # Returns
>> +    ///
>> +    /// - `true` - Bad block tracking is enabled and operational
>> +    /// - `false` - Bad block tracking is disabled
>
> You explain the meaning of return values twice here. Just drop the
> 'Returns' section.

Ok.

>
>> +    /// # Thread Safety
>> +    ///
>> +    /// This method is thread-safe and uses atomic operations to check the
>> +    /// tracker's state without requiring external synchronization.
>
> This is implicit from the signature of the function.

Will remove.

>
>> +    pub fn set_good(&self, range: impl RangeBounds<u64>) -> Result {
>> +        let range = Self::range(range);
>> +        // SAFETY: By type invariant `self.blocks` is valid. The C function
>> +        // `badblocks_clear` handles synchronization internally.
>> +        unsafe {
>> +            bindings::badblocks_clear(self.blocks.get(), range.start, range.end - range.start)
>> +        }
>> +        .then_some(())
>> +        .ok_or(EINVAL)
>
> then_some() is quite obscure. I would recommend if/else here.

Ok.

Thanks,
Andreas


