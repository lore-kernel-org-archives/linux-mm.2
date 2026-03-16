Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7A3BF46455
	for <linux-mm@archiver.kernel.org>; Mon, 16 Mar 2026 11:55:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B1606B00BF; Mon, 16 Mar 2026 07:55:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35E396B01FA; Mon, 16 Mar 2026 07:55:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26B096B01FF; Mon, 16 Mar 2026 07:55:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 13B5E6B00BF
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 07:55:32 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B0FE41B6D1E
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:55:31 +0000 (UTC)
X-FDA: 84551771262.19.DAB11B0
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf12.hostedemail.com (Postfix) with ESMTP id DAA7940005
	for <linux-mm@kvack.org>; Mon, 16 Mar 2026 11:55:29 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DUOU0lmL;
	spf=pass (imf12.hostedemail.com: domain of 3r--3aQkKCMIitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3r--3aQkKCMIitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773662130;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ob9tzx0aj2zeHdgbk4mDLaOraCCBLId3s0T7A6CDOE4=;
	b=PJ/hYvmQsjTrHLxBoiRLfXeHoOleidrZech3+alF4AgaND8KKS1vwoVdpEhK4becvXzTi4
	I3zArCHOj5p3Xw0T13ZZpAWbbpQQIOxa9zns33QS2RBxPYU8zE3XiNj9U2jig+87Fo4Ahq
	H6mKAmcupdGAqqHurJ1dDiRXaTRN5hA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773662130; a=rsa-sha256;
	cv=none;
	b=e65EcDFlruCPPQxSdPRaznGQoqz62sxkoHsNC9TUgpI5e13ljCDMX+z+R9IQnA/d03Y64b
	Y79o2a8HLgca94tuDbgwd0TbMiuYHbe5g6POZyUaH+7YapXV/mRnomiN7LgC1TX9TND0HX
	WnQEdkVS/mLMensHgp2V2ZuXoKCdHyU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=DUOU0lmL;
	spf=pass (imf12.hostedemail.com: domain of 3r--3aQkKCMIitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3r--3aQkKCMIitqkmz6ptowwotm.kwutqv25-uus3iks.wzo@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-4853b0af42aso68318045e9.0
        for <linux-mm@kvack.org>; Mon, 16 Mar 2026 04:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773662128; x=1774266928; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ob9tzx0aj2zeHdgbk4mDLaOraCCBLId3s0T7A6CDOE4=;
        b=DUOU0lmLm9VBhLbX4VgpHoU/rM6d8Q/zHaEic4+DXyhg6lTPuzEgeqUcX3jab7YUgA
         MXBSDAUJoM7CTw1u3KjNTucAY8IqNrZsX+zANwu8Rw+Cdz7Aepq4XBVZugQDlsxYSm00
         2dP3lxabA9nO2v6CVndHBnM6pcxvLoScddSPL7cH9fkXYqg8k2iUGDVJ69edjybp5yB0
         f2RPe/WfRXEJ58EO8flm1qFeTDyjFdUACvlmZCqhwZDyCmfPBgI1p+88a9PA+cvV1bAL
         7IIbgDahA/n/CxrSbk+StyECcTBI5HvI6XMtTKfO2RmbKvc79Ot69QvXjEapki3rAucH
         1sdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773662128; x=1774266928;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Ob9tzx0aj2zeHdgbk4mDLaOraCCBLId3s0T7A6CDOE4=;
        b=Kpw2NYQ+BlkxfCKI629s0cumSb0KgfPt8dZ88KdhYSTYMLPRsNGz2ZSnvnoAolQ1RO
         x+rIsOuJON6QRY2lILBqM72fvCvDRUbKe+Z1sYqAjK0IF0IXS4STptNzn7q0K18Zleci
         Zi99zrZjfFDIxpk3FFVSDkBb2Hq4vJWLBmdTNOPRZHWItthv2ZR/kY8m8TDm7rFJvtGo
         q7hYtoD+rj5/oC9rVz5FL49owmaoK03DCQ/wy4bHz6naf2KCl4Fbp2EbAytYPwMnvqzP
         p7ncPqBoII4T5BWE4whfy3wZHoeol0/VrTIqONhJxr+2Vzr7jfi8s7fWYdcaaHZ06Ws0
         zZ6g==
X-Forwarded-Encrypted: i=1; AJvYcCW+J+BzqCz4GS0RSmXqhPwqgDZ5dPIlH3hrwPNYO9TzEVQAmi62+odHX/7lHt+1Ww/PkZgU6+WBmg==@kvack.org
X-Gm-Message-State: AOJu0YxEItgrfefNN53yFYeOU5LXsDZ1587NDpspant8kbGx7Y8hn4lK
	l5oBok4EqJ7R3G+KhfRcO7t6E7RyK9IlHbwNP5zjWxpn1MSe6KJgkwAw0QlSbSo88Hxt5sb030d
	Vw5AcqyMmWj5PwZXxLg==
X-Received: from wmbfc7.prod.google.com ([2002:a05:600c:5247:b0:485:3ddc:f27c])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3515:b0:47e:e57d:404 with SMTP id 5b1f17b1804b1-485567066a8mr212492925e9.16.1773662127851;
 Mon, 16 Mar 2026 04:55:27 -0700 (PDT)
Date: Mon, 16 Mar 2026 11:55:26 +0000
In-Reply-To: <20260216-rnull-v6-19-rc5-send-v1-24-de9a7af4b469@kernel.org>
Mime-Version: 1.0
References: <20260216-rnull-v6-19-rc5-send-v1-0-de9a7af4b469@kernel.org> <20260216-rnull-v6-19-rc5-send-v1-24-de9a7af4b469@kernel.org>
Message-ID: <abfvrh0ObKhtsR8I@google.com>
Subject: Re: [PATCH 24/79] block: rust: add `BadBlocks` for bad block tracking
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
X-Rspamd-Queue-Id: DAA7940005
X-Stat-Signature: 186g6miit4o4455g7zjucxwgjmsqs5ms
X-Rspam-User: 
X-HE-Tag: 1773662129-291747
X-HE-Meta: U2FsdGVkX18zgBcRW5xFOpT+monvNlDAoShAai5N/Xzwa/6vWSbZDN0Ly5UG0Rk9v/ksvtYtVcdx0n3YxehOwUppKmkWchTOkpu7I5EwLw4PKlP9jFkHtl4nWxLyo91EozVnj0Kneo9MxdNbuWIRZfTR3p1kVhvI3vr2vlu89ERxcV6W9UxF9jijVvsMUylFMrKWk1Ya7u20mUhGzhxwJ0ggyxpqPbErl5US27C4/FDQ/KLajU67dk5gpwE0LDulf38ykLhslm7+Po01LbyKMOdtX4d32UG2crNhoRxjACKHdptb71urjJ5wusl5RCcrL6uIuoMYYPP5CHktH5fygjS2MeEDI560x1uB9f6R/9O04ZV1cxYoK2jWTQQlzA7nijvQ4wTFYgYdlXthZTH6bmZAxM5At+9MS6AmIldWIJq3d5FZsOe+zPTpf8bQ60fkViTtX4StYEV3Zq94iAvfbCycTYylDN1wjR8U/ODih0qecL4YVAEr7cBzG56C9Fe+ZTeLk4I+/p3HfkOCkzQGk2/wqR/iZIhVV4hzzZekXkwH5qWT+N7onOF1MRbe7wZjCxXntEidlyz9JHZlSrAbLmqPuOctvBAjKyQJkya9KwFMnrH3F68DGwVxrhILrg5vH4q34s0pS8bqbN1s7vVtC0YPzkVRr6YEYAU4sETcwqUsolDR3sue6pFDvqXKeJFdF5qOS1tqRLyeWzF2GhxQr6YBIW2whOg65uSox8IgNIBPaD3oRoUk2UmwL2NvPdW/onGjgi6/V4LOPPnDblS3vIaKIK+XMHTsP8QEOUsCuRXnPBfLqokGbJQvCWYDjp7fT9bMyzTtioATnYvc6nsC9v1QqrYcU2Vt3EAniMf4jFe+z/hU9Kajr92suOgl/xbZ27Lg80BoRqbkqIXlNh9gGQEYR4JHdMxQtv7s2HANItm5AqXxoapsgr3o/hFUdMa8vQsPWhbfbrKw85+2B+q
 T22fZDMh
 siKedhG4CBXT42dQbxFgz+Y0cD81WDsNCO6KV0uWjq/sTqnukCmM0NO5WU9o0EIDcsCWm9Cs//BM2l5TXr9IUS+jco/v41+QOf/2s8MDMPCFBgbnnMzW+qfOkVLpSzi7HkA4MVtkgyR89/N2qdHvRl8cBFD6HfQBbIHIdYKkGHi8qAwwgJ+5EFJ7uhDw+dbVq3Myq5c1dsEBCzCegzlhCwVPW/wFGlS8ei0gFBLaurJQYa6oR3lbdqXQo00eX+xAxexVyrv/L3jXzHde3gYLhx9L8Dnld6N0VPV/MFL8izZoigxgLS1lxoHj/ucOFw66YJwNEru/o2eVTrddtJq5DvGVfoeGYWb2f0bHQ8dz1h8I1u8xghFoM1CL8lOVUhFKlV+D2nnH9piyjt8WQhmV2ZyMajbfKgIdZb0/9hGtM2XVMBnvEiY/Ip4t6wG/y+7xh8LBJXhLBOR15/FsHNpP8hJfUUho0EYLLkV0BuY+50qabpwtUdoXCGnyRSwq4C6kJ5B1pu0sPRED+JK4bg0nQCs62te8Vk6iJdEmwW9jsZhghSWg4QeXrRZLgkUkn4DFobriNnhhB5dbo0Mh6YvGKMNBTy8J68uo06S+uhlmxK1c7DFZT5ikms1oaFQWSbiVkZN7tPqM01z4jmRlLf9Pmr8VJSwu/ED/pOVpOExdv3rZre43A1FtRqqe3Xue914kFcUSrigESGreCDHvRzShIlX0v+QcVE03MFirB/3Td74Ghp6ipC4hrxP+Ilg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 16, 2026 at 12:35:11AM +0100, Andreas Hindborg wrote:
> Add a safe Rust wrapper around the Linux kernel's badblocks infrastructure
> to track and manage defective sectors on block devices. The BadBlocks type
> provides methods to:
> 
> - Mark sectors as bad or good (set_bad/set_good)
> - Check if sector ranges contain bad blocks (check)
> - Automatically handle memory management with PinnedDrop
> 
> The implementation includes comprehensive documentation with examples for
> block device drivers that need to avoid known bad sectors to maintain
> data integrity. Bad blocks information is used by device drivers,
> filesystem layers, and device management tools.
> 
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>

> diff --git a/rust/kernel/block/badblocks.rs b/rust/kernel/block/badblocks.rs
> new file mode 100644
> index 0000000000000..a5fe0fde2e755
> --- /dev/null
> +++ b/rust/kernel/block/badblocks.rs
> @@ -0,0 +1,721 @@
> +// SPDX-License-Identifier: GPL-2.0
> +
> +//! Bad blocks tracking for block devices.
> +//!
> +//! This module provides a safe Rust wrapper around the badblocks
> +//! infrastructure, which is used to track and manage bad sectors on block
> +//! devices. Bad blocks are sectors that cannot reliably store data and should
> +//! be avoided during I/O operations.

Could use a srctree link to badblocks.h here.

> +/// # Examples
> +///
> +/// Basic usage:
> +///
> +/// ```rust
> +/// # use kernel::block::badblocks::{BadBlocks, BlockStatus};
> +/// # use kernel::prelude::*;
> +///

Unhide the imports or remove this empty line.

> +/// // Create a new bad blocks tracker
> +/// let bad_blocks = KBox::pin_init(BadBlocks::new(true), GFP_KERNEL)?;
> +///
> +/// // Mark sectors 100-109 as bad (unacknowledged)
> +/// bad_blocks.set_bad(100..110, false)?;
> +///
> +/// // Check if sector range 95-104 contains bad blocks
> +/// match bad_blocks.check(95..105) {
> +///     BlockStatus::None => pr_info!("No bad blocks found"),
> +///     BlockStatus::Acknowledged(range) => pr_warn!("Acknowledged bad blocks: {:?}", range),
> +///     BlockStatus::Unacknowledged(range) => pr_err!("Unacknowledged bad blocks: {:?}", range),
> +/// }
> +/// # Ok::<(), kernel::error::Error>(())
> +/// ```
> +/// # Invariants
> +///
> +/// - `self.blocks` is a valid `bindings::badblocks` struct.
> +#[pin_data(PinnedDrop)]
> +pub struct BadBlocks {
> +    #[pin]
> +    blocks: Opaque<bindings::badblocks>,
> +}
> +
> +impl BadBlocks {
> +    /// Creates a new bad blocks tracker.
> +    ///
> +    /// Initializes an empty bad blocks tracker that can manage defective sectors
> +    /// on a block device. The tracker starts with no bad blocks recorded and
> +    /// allocates a single page for storing bad block entries.
> +    ///
> +    /// # Returns
> +    ///
> +    /// Returns a [`PinInit`] that can be used to initialize a [`BadBlocks`] instance.
> +    /// Initialization may fail with `ENOMEM` if memory allocation fails.
> +    ///
> +    /// # Examples
> +    ///
> +    /// ```rust
> +    /// # use kernel::block::badblocks::{BadBlocks, BlockStatus};
> +    /// # use kernel::prelude::*;
> +    ///

Ditto. (Many times throughout file.)

> +    /// // Create and initialize a bad blocks tracker
> +    /// let bad_blocks = KBox::pin_init(BadBlocks::new(true), GFP_KERNEL)?;
> +    ///
> +    /// // The tracker is ready to use with no bad blocks initially
> +    /// match bad_blocks.check(0..100) {
> +    ///     BlockStatus::None => pr_info!("No bad blocks found initially"),
> +    ///     _ => unreachable!(),
> +    /// }
> +    /// # Ok::<(), kernel::error::Error>(())
> +    /// ```
> +    pub fn new(enable: bool) -> impl PinInit<Self, Error> {
> +        // INVARIANT: We initialize `self.blocks` below. If initialization fails, an error is
> +        // returned.
> +        try_pin_init!(Self {
> +            blocks <- Opaque::try_ffi_init(|slot| {
> +                // SAFETY: `slot` is a valid pointer to uninitialized memory
> +                // allocated by the Opaque type. `badblocks_init` is safe to
> +                // call with uninitialized memory.
> +                to_result(unsafe {bindings::badblocks_init(slot, if enable {1} else {0})})

I think you can just cast the boolean to an integer.

Also, formatting here is off (but ignored by rustfmt due to macro.)

> +    /// Enables the bad blocks tracker if it was previously disabled.
> +    ///
> +    /// Attempts to enable bad block tracking by transitioning the tracker from
> +    /// a disabled state to an enabled state.
> +    ///
> +    /// # Behavior
> +    ///
> +    /// - If the tracker is disabled, it will be enabled.
> +    /// - If the tracker is already enabled, this operation has no effect.
> +    /// - The operation is atomic and thread-safe.
> +    ///
> +    /// # Usage
> +    ///
> +    /// Bad blocks trackers can be created in a disabled state and enabled later
> +    /// when needed. This is useful for conditional bad block tracking or for
> +    /// deferring activation until the device is fully initialized.
> +    ///
> +    /// # Examples
> +    ///
> +    /// ```rust
> +    /// # use kernel::block::badblocks::BadBlocks;
> +    /// # use kernel::prelude::*;
> +    ///
> +    /// // Create a disabled bad blocks tracker
> +    /// let bad_blocks = KBox::pin_init(BadBlocks::new(false), GFP_KERNEL)?;
> +    /// assert!(!bad_blocks.enabled());
> +    ///
> +    /// // Enable it when needed
> +    /// bad_blocks.enable();
> +    /// assert!(bad_blocks.enabled());
> +    ///
> +    /// // Subsequent enable calls have no effect
> +    /// bad_blocks.enable();
> +    /// assert!(bad_blocks.enabled());
> +    /// # Ok::<(), kernel::error::Error>(())
> +    /// ```
> +    pub fn enable(&self) {
> +        let _ = self.shift_ref().cmpxchg(-1, 0, ordering::Relaxed);

Is there not a C function you can call here? It would be simpler that
way. Surely drivers don't do this directly.

> +    }
> +
> +    /// Checks whether the bad blocks tracker is currently enabled.
> +    ///
> +    /// Returns `true` if bad block tracking is active, `false` if it is disabled.
> +    /// When disabled, the tracker will not perform bad block checks or operations.
> +    ///
> +    /// # Returns
> +    ///
> +    /// - `true` - Bad block tracking is enabled and operational
> +    /// - `false` - Bad block tracking is disabled

You explain the meaning of return values twice here. Just drop the
'Returns' section.

> +    /// # Thread Safety
> +    ///
> +    /// This method is thread-safe and uses atomic operations to check the
> +    /// tracker's state without requiring external synchronization.

This is implicit from the signature of the function.

> +    pub fn set_good(&self, range: impl RangeBounds<u64>) -> Result {
> +        let range = Self::range(range);
> +        // SAFETY: By type invariant `self.blocks` is valid. The C function
> +        // `badblocks_clear` handles synchronization internally.
> +        unsafe {
> +            bindings::badblocks_clear(self.blocks.get(), range.start, range.end - range.start)
> +        }
> +        .then_some(())
> +        .ok_or(EINVAL)

then_some() is quite obscure. I would recommend if/else here.

Alice

