Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56CE5C5516E
	for <linux-mm@archiver.kernel.org>; Fri, 20 Feb 2026 09:52:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B71F26B008C; Fri, 20 Feb 2026 04:52:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B297C6B0092; Fri, 20 Feb 2026 04:52:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D73D6B0093; Fri, 20 Feb 2026 04:52:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8809F6B008C
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 04:52:09 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 51B8D140BAE
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:52:09 +0000 (UTC)
X-FDA: 84464369178.29.7B1AD91
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 8CF99A000A
	for <linux-mm@kvack.org>; Fri, 20 Feb 2026 09:52:07 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ppi1/XPY";
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771581127;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p6QndhYYNDBhghKFBapt7NamILW5YcLxnxOX1REqM0w=;
	b=k9CvJO2xOn1cxjdLfToUknZEJb+WqbrofTuupP7SR/hfX4h6lJcDGQfeqzg93Ms2FtTByI
	SMozKGMZHEYGlLsRQtYdBwYOqKfCR4Ph1yt6tSrweq815N3SL1TN7y7FtvD12ewd8iK5dm
	C9OtVFolQMv9kiZWo4hHYz+mW+R3Wno=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="ppi1/XPY";
	spf=pass (imf15.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771581127; a=rsa-sha256;
	cv=none;
	b=BTqby9PBHhe2l2/HwvrJcQg9VgfCYDnwsMctAnXAwWSpi546PJEsWMuqztdjU+WOK4CdR0
	hFDKa9HFHMBJm5HAbLhF9iGlHL+tLphwu+oOt0TdSu1Y0P9E+lNeW8JAhNYUceTyvHp7+9
	ge6fPiJwzJjAFSVf10NTHIYyettWRYQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BC89761843;
	Fri, 20 Feb 2026 09:52:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB4AC116C6;
	Fri, 20 Feb 2026 09:51:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771581126;
	bh=+PodXl/wwBV+PA5BRedOUZgBWeTtGynnDCp6iX2CeiQ=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=ppi1/XPYegHcMDBduaR2AnqAkljs+pg+qcNju89css9+XCAA0jXc1xa5GCd6lccdF
	 sygwslGFM1sjSX+cc1WCOxc9MrsU8O9OAQSF7HWz6gzaDOzuDVDrgz/8jS0Yytcykm
	 S/5/P/ZBaJZao2Ot0T5DiNLPV06ob5YYtkVhg+dZAAkYIGTGaiUz9puarlTz1QpKBT
	 SihqUp4jb2y9DuxrgGlLS++EpC+3RSBEmYi2jPMC2kCINRotKFCfLxNHHS0P2WQ1Zz
	 +alFa0pKOZvRtmwZd7zpfG7S+Z764JzwodHRmUqWBd4wHZ8Ihj35r6ODrJtkFOKUvc
	 kXMjlj21r3OtQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Fri, 20 Feb 2026 10:51:10 +0100
Subject: [PATCH v15 1/9] rust: types: Add Ownable/Owned types
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260220-unique-ref-v15-1-893ed86b06cc@kernel.org>
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
In-Reply-To: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, 
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Igor Korotin <igor.korotin.linux@gmail.com>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Asahi Lina <lina+kernel@asahilina.net>, 
 Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=11400;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=ceazmDY9zMprkGKe4DZha/pUGe1Tz44cJElMoCN5Ww8=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpmC6eV2ZYvrOTK3GwhcNVSnYwa0jqhZycgxRw5
 QAdJb+eFTaJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZgungAKCRDhuBo+eShj
 d/e/EAC578jug50o8pjquFcaOzJNQRtvp4mbQZhiWMJ5iKm9oustdqkgktfqn0ktoOPq6qzDSAf
 nCit66IsOx8Y5QwgAwpn5vgRuyydcCmTf25MIVyMGUzAoVqwSFgGaKYgqUSXo0pyf5CNfPEp6LM
 KEWAtxej9ZRYs8lmvR9ioAPmKDqvmdTW/o3cbjkbhVg8ggJ4KardbP9cXSBrn4ZGotp4sFki8LP
 4IHRo85AS/Occfn1IJ3K+iIQqvj1JnyuzSj+ZOZiS9ubqNbq3240QVNCdQ6lBGxFJZb/gWJirx6
 0spbB8Rt+9F1zlcymRrZDeOHuoputD/1g6NkCwsHer8mOSW2kzZhnCYKaDBE2wVqguZ/g+HExDm
 D2VXlCtYClx/+6NFFdg2OOjJ4aOrw+JUFMgJSv8IHtiXgdgZ/tiEVggwcRCFCX0L4fXLR6IATd5
 nghyX8WSexXNIv9kp25GkSSTtJvBuMJQIU1gkGP+e4BZyb4hi50P2jTxyuFZ5zxfbcOXFRxz8GS
 68OhvCuxZCdAyb5E45zsp1a/wiwzEyVSa1JDadKJOaJ0xhqkvBUjWiuJ7R7SpSSFYsShWY1vo2m
 U7PewVmuduHLx6zTOAWTZfVI8lbOtLpSEmh+HK4Rd4CQ1/u51PHr7nnQRIzdUZRRA5dBUlH5ZOq
 z5YBURXQAJRbopg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Stat-Signature: 4u1biogn53ua6uokasjueh1at5mxxaiy
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: 8CF99A000A
X-HE-Tag: 1771581127-408439
X-HE-Meta: U2FsdGVkX1+QhLf8j91YWqcMBMxwqOCUm8Vq2HhkO1qJZYf342nXaRb1dEeoqMZC6+/4J3n8byrIuJz3DHgtn8B0i+kN5GzERtsm38F+9VvCC3BzKwBtUSCFwE4J+JwrKoj9ZEwDRedPDmKY5lSavlUsJhhkXeV7R95oOxVJkpG7mKNqz3gCLtjQzQlPuAeAVb5pxlA3wcPALGv5NMPhlgSAlQQz5QTsYsRiOdwUmsja+hNCcesX30z/yi09AmvMMTwSVh1+sqDyAmcD0DexvpdNaTRgwYsIajsyU6TBXD8cvH83DP9bQdBXvHCFfXpnQ/YiQL2iYiLzo9FwYIJJoaFbz0bJR8pNvdUj6rckJc7oLcmQ0QVZuqHPwW2jEvju3Sb46HBINYRJ/7UGJROMBnHobhimVu8dz2/4DI8EVAivi9jiMWm7bB/B2SWQNs8nyZA4kfCafp082kOR9BGxnUv+BRj0MT926GML6C3mDYEQlx0yW7wb+D6Ch/iRRQcjFRaY3s5c8Q9b7P+WnqvMd0KuNj3GoFQSCPPYlgASfTURU2wgkLR/mjognve4c+BHyWLOqJ8OVHmNipt4xgix9+ijh+1Ry7pJ2kxWrwQaUv2uyz3xsG32erc6GKiEoRiKo3QJ9R3BBQnxEWRIbyOTmzh5Lg1OE9D5kDgtAOkDQq/85qoN2RSJ//n8f9DNbyd6CBQa1PweYT15lAIdDIRlx8yCG0vQUjZaf1jVW/1XvlPoJo6SZbj0H/yZxAdslyWIamK5DxRMtZsKDLmM0z+N0uqDdNF+wr3zMFnu73iRq2sBNiSSEBd6zqyD9aXjaoDJ/Hpej4BkLEpp+eJLyg0Lie8e8MTgs3qlidYMwBKQt/f1mw3uGQOwzERwV2Nsc8sDtPt1Ehpp3dYmyU7Hdy7HUgddqEfZm0sd0gnzJVnnKFfSHg8vhVXTg6iOnaAxpcGnHXFhkmS0RY/rV3rAtlA
 SG67F2oG
 QDiBmq9Hi+zL0fU1aq7mXAw6OocF/3dvuGKvsaMr5qXRkf9xjxA7YPx264iNiZLdG40xeEZPB1FI/yRPSEqd8GCHs8gPnmpr9YMVkKfKjqdo02YnUpJOWqc16CGbiGT996B4mqkIuD03gZmOCGkhhZUaP5Fu5U/4eyPgGSK0Wtw+zinx5G9Xh6tPcVkPUK0TrVonyYSxVw/dJuTPWcTblXXcmY5kPmMhl5JLQMl7Tf5ZaHqvA7gIncmiAG9Bbfj6lPajCDLVLnO5TFcCRs0qvcLRjUF14CdtY4tLwUswUZpt+6tOD2qqppmqtTOCk040Up37lOLE+hVPu3RglD4dtd2bc+r/FZORHT5/jC43iDtg2w1nO58lOiIMxw/32Pgz+QdIHl82wiM8kIiqVJetvgWB2bQcce9GHo6tS8qoaR612pyf4TVu+9dDIbHie4jJw/RhPoAcotVKdey7+Fg/oNMxbPfxGy7jZOq6fzSGCAHVmlPFWxiboc3BQzhVR7qMPT+N/MrDhO+fkSYM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Asahi Lina <lina+kernel@asahilina.net>

By analogy to `AlwaysRefCounted` and `ARef`, an `Ownable` type is a
(typically C FFI) type that *may* be owned by Rust, but need not be. Unlike
`AlwaysRefCounted`, this mechanism expects the reference to be unique
within Rust, and does not allow cloning.

Conceptually, this is similar to a `KBox<T>`, except that it delegates
resource management to the `T` instead of using a generic allocator.

[ om:
  - Split code into separate file and `pub use` it from types.rs.
  - Make from_raw() and into_raw() public.
  - Remove OwnableMut, and make DerefMut dependent on Unpin instead.
  - Usage example/doctest for Ownable/Owned.
  - Fixes to documentation and commit message.
]

Link: https://lore.kernel.org/all/20250202-rust-page-v1-1-e3170d7fe55e@asahilina.net/
Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
Co-developed-by: Oliver Mangold <oliver.mangold@pm.me>
Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
[ Andreas: Updated documentation, examples, and formatting ]
Reviewed-by: Gary Guo <gary@garyguo.net>
Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/lib.rs       |   1 +
 rust/kernel/owned.rs     | 196 +++++++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/sync/aref.rs |   5 ++
 rust/kernel/types.rs     |  11 ++-
 4 files changed, 212 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 696f62f85eb5f..a2bec807f03f1 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -121,6 +121,7 @@
 pub mod of;
 #[cfg(CONFIG_PM_OPP)]
 pub mod opp;
+pub mod owned;
 pub mod page;
 #[cfg(CONFIG_PCI)]
 pub mod pci;
diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
new file mode 100644
index 0000000000000..d566ad0aa1c99
--- /dev/null
+++ b/rust/kernel/owned.rs
@@ -0,0 +1,196 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Unique owned pointer types for objects with custom drop logic.
+//!
+//! These pointer types are useful for C-allocated objects which by API-contract
+//! are owned by Rust, but need to be freed through the C API.
+
+use core::{
+    mem::ManuallyDrop,
+    ops::{
+        Deref,
+        DerefMut, //
+    },
+    pin::Pin,
+    ptr::NonNull, //
+};
+
+/// Types that specify their own way of performing allocation and destruction. Typically, this trait
+/// is implemented on types from the C side.
+///
+/// Implementing this trait allows types to be referenced via the [`Owned<Self>`] pointer type. This
+/// is useful when it is desirable to tie the lifetime of the reference to an owned object, rather
+/// than pass around a bare reference. [`Ownable`] types can define custom drop logic that is
+/// executed when the owned reference [`Owned<Self>`] pointing to the object is dropped.
+///
+/// Note: The underlying object is not required to provide internal reference counting, because it
+/// represents a unique, owned reference. If reference counting (on the Rust side) is required,
+/// [`AlwaysRefCounted`](crate::types::AlwaysRefCounted) should be implemented.
+///
+/// # Safety
+///
+/// Implementers must ensure that the [`release()`](Self::release) function frees the underlying
+/// object in the correct way for a valid, owned object of this type.
+///
+/// # Examples
+///
+/// A minimal example implementation of [`Ownable`] and its usage with [`Owned`] looks like
+/// this:
+///
+/// ```
+/// # #![expect(clippy::disallowed_names)]
+/// # use core::cell::Cell;
+/// # use core::ptr::NonNull;
+/// # use kernel::sync::global_lock;
+/// # use kernel::alloc::{flags, kbox::KBox, AllocError};
+/// # use kernel::types::{Owned, Ownable};
+///
+/// // Let's count the allocations to see if freeing works.
+/// kernel::sync::global_lock! {
+///     // SAFETY: we call `init()` right below, before doing anything else.
+///     unsafe(uninit) static FOO_ALLOC_COUNT: Mutex<usize> = 0;
+/// }
+/// // SAFETY: We call `init()` only once, here.
+/// unsafe { FOO_ALLOC_COUNT.init() };
+///
+/// struct Foo;
+///
+/// impl Foo {
+///     fn new() -> Result<Owned<Self>> {
+///         // We are just using a `KBox` here to handle the actual allocation, as our `Foo` is
+///         // not actually a C-allocated object.
+///         let result = KBox::new(
+///             Foo {},
+///             flags::GFP_KERNEL,
+///         )?;
+///         let result = NonNull::new(KBox::into_raw(result))
+///             .expect("Raw pointer to newly allocation KBox is null, this should never happen.");
+///         // Count new allocation
+///         *FOO_ALLOC_COUNT.lock() += 1;
+///         // SAFETY: We just allocated the `Self`, thus it is valid and there cannot be any other
+///         // Rust references. Calling `into_raw()` makes us responsible for ownership and we won't
+///         // use the raw pointer anymore. Thus we can transfer ownership to the `Owned`.
+///         Ok(unsafe { Owned::from_raw(result) })
+///     }
+/// }
+///
+/// // SAFETY: The implementation of `release` in this trait implementation correctly frees the
+/// // owned `Foo`.
+/// unsafe impl Ownable for Foo {
+///     unsafe fn release(this: NonNull<Self>) {
+///         // SAFETY: The [`KBox<Self>`] is still alive. We can pass ownership to the [`KBox`], as
+///         // by requirement on calling this function, the `Self` will no longer be used by the
+///         // caller.
+///         drop(unsafe { KBox::from_raw(this.as_ptr()) });
+///         // Count released allocation
+///         *FOO_ALLOC_COUNT.lock() -= 1;
+///     }
+/// }
+///
+/// {
+///    let foo = Foo::new().expect("Failed to allocate a Foo. This shouldn't happen");
+///    assert!(*FOO_ALLOC_COUNT.lock() == 1);
+/// }
+/// // `foo` is out of scope now, so we expect no live allocations.
+/// assert!(*FOO_ALLOC_COUNT.lock() == 0);
+/// ```
+pub unsafe trait Ownable {
+    /// Releases the object.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that:
+    /// - `this` points to a valid `Self`.
+    /// - `*this` is no longer used after this call.
+    unsafe fn release(this: NonNull<Self>);
+}
+
+/// A mutable reference to an owned `T`.
+///
+/// The [`Ownable`] is automatically freed or released when an instance of [`Owned`] is
+/// dropped.
+///
+/// # Invariants
+///
+/// - The [`Owned<T>`] has exclusive access to the instance of `T`.
+/// - The instance of `T` will stay alive at least as long as the [`Owned<T>`] is alive.
+pub struct Owned<T: Ownable> {
+    ptr: NonNull<T>,
+}
+
+impl<T: Ownable> Owned<T> {
+    /// Creates a new instance of [`Owned`].
+    ///
+    /// This function takes over ownership of the underlying object.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that:
+    /// - `ptr` points to a valid instance of `T`.
+    /// - Ownership of the underlying `T` can be transferred to the `Self<T>` (i.e. operations
+    ///   which require ownership will be safe).
+    /// - An `Owned<T>` is a mutable reference to the underlying object. As such,
+    ///   the object must not be accessed (read or mutated) through any pointer
+    ///   other than the created `Owned<T>`. Opt-out is still possible similar to
+    ///   a mutable reference (e.g. by using [`Opaque`]).
+    ///
+    /// [`Opaque`]: kernel::types::Opaque
+    pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
+        // INVARIANT: By function safety requirement:
+        // - The resulting object has exclusive access to the `T` pointed to by `ptr`.
+        // - The `T` object pointed to by `ptr` is alive at least as long as the returned `Self`.
+        Self { ptr }
+    }
+
+    /// Consumes the [`Owned`], returning a raw pointer.
+    ///
+    /// This function does not drop the underlying `T`. When this function returns, ownership of the
+    /// underlying `T` is with the caller.
+    pub fn into_raw(me: Self) -> NonNull<T> {
+        ManuallyDrop::new(me).ptr
+    }
+
+    /// Get a pinned mutable reference to the data owned by this `Owned<T>`.
+    pub fn as_pin_mut(&mut self) -> Pin<&mut T> {
+        // SAFETY: The type invariants guarantee that the object is valid, and that we can safely
+        // return a mutable reference to it.
+        let unpinned = unsafe { self.ptr.as_mut() };
+
+        // SAFETY: We never hand out unpinned mutable references to the data in
+        // `Self`, unless the contained type is `Unpin`.
+        unsafe { Pin::new_unchecked(unpinned) }
+    }
+}
+
+// SAFETY: It is safe to send an [`Owned<T>`] to another thread when the underlying `T` is [`Send`],
+// because of the ownership invariant. Sending an [`Owned<T>`] is equivalent to sending the `T`.
+unsafe impl<T: Ownable + Send> Send for Owned<T> {}
+
+// SAFETY: It is safe to send [`&Owned<T>`] to another thread when the underlying `T` is [`Sync`],
+// because of the ownership invariant. Sending an [`&Owned<T>`] is equivalent to sending the `&T`.
+unsafe impl<T: Ownable + Sync> Sync for Owned<T> {}
+
+impl<T: Ownable> Deref for Owned<T> {
+    type Target = T;
+
+    fn deref(&self) -> &Self::Target {
+        // SAFETY: The type invariants guarantee that the object is valid.
+        unsafe { self.ptr.as_ref() }
+    }
+}
+
+impl<T: Ownable + Unpin> DerefMut for Owned<T> {
+    fn deref_mut(&mut self) -> &mut Self::Target {
+        // SAFETY: The type invariants guarantee that the object is valid, and that we can safely
+        // return a mutable reference to it.
+        unsafe { self.ptr.as_mut() }
+    }
+}
+
+impl<T: Ownable> Drop for Owned<T> {
+    fn drop(&mut self) {
+        // SAFETY: The type invariants guarantee that the `Owned` owns the object we're about to
+        // release.
+        unsafe { T::release(self.ptr) };
+    }
+}
diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index 0d24a0432015d..e175aefe86151 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -29,6 +29,11 @@
 /// Rust code, the recommendation is to use [`Arc`](crate::sync::Arc) to create reference-counted
 /// instances of a type.
 ///
+/// Note: Implementing this trait allows types to be wrapped in an [`ARef<Self>`]. It requires an
+/// internal reference count and provides only shared references. If unique references are required
+/// [`Ownable`](crate::types::Ownable) should be implemented which allows types to be wrapped in an
+/// [`Owned<Self>`](crate::types::Owned).
+///
 /// # Safety
 ///
 /// Implementers must ensure that increments to the reference count keep the object alive in memory
diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index 9c5e7dbf16323..4aec7b699269a 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -11,7 +11,16 @@
 };
 use pin_init::{PinInit, Wrapper, Zeroable};
 
-pub use crate::sync::aref::{ARef, AlwaysRefCounted};
+pub use crate::{
+    owned::{
+        Ownable,
+        Owned, //
+    },
+    sync::aref::{
+        ARef,
+        AlwaysRefCounted, //
+    }, //
+};
 
 /// Used to transfer ownership to and from foreign (non-Rust) languages.
 ///

-- 
2.51.2



