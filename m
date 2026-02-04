Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBB3CE9538C
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:57:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A49A6B009F; Wed,  4 Feb 2026 06:57:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25B036B00A1; Wed,  4 Feb 2026 06:57:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 150F46B00A2; Wed,  4 Feb 2026 06:57:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0186F6B009F
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:57:58 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CDF6A1B012D
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:57:58 +0000 (UTC)
X-FDA: 84406625436.04.50C87A5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1A4FA100005
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:57:56 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C1lLA3Lm;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770206277;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ct2gu6egR+vVfNo6bo3fKJD8XoO4CyX0OMT7bpXAVXo=;
	b=SzC+cVOA9qfN1JbSdDPZIdmFwGjYisMPuR6USaqiENBCw2RXiWUiEsqAh+jkX7iRjsStiX
	o0LhAS6w+GjijT+yKEzlHpnN45idh1pCBwLsF9d5dN3jFb2GQPTJne9wWlANUht/gyKtkK
	Hl0Ap5MeDkYuQGGRopFK2wpa5fBeDVo=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=C1lLA3Lm;
	spf=pass (imf05.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770206277; a=rsa-sha256;
	cv=none;
	b=3IA7hR2n7gvB5jSgdbtiRYY/kVPtl9nIYzRKXj9ruPeoFRhqTebXxROM32Sw4l5PY70oCq
	Ed4QgUu62ijuDxUUR2R6QaG7N+DTcuSrFrpmJjdfDqK4UuXbU0ozjHrR7r2G8TEDre61UR
	GLsBz/LB04z4MJInvUNSPSFXaT+YQJA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 8CC86600C4;
	Wed,  4 Feb 2026 11:57:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CAC2FC2BC87;
	Wed,  4 Feb 2026 11:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770206276;
	bh=XqK2AU5eFCGeRR0nt9iohDDP3eAVnmA9EEkyP3XMANw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=C1lLA3LmDuUPd0m72r5co/ZLAdVk7Sd0onVoUgBTYTd/mqDgwC6Z1Hm7raDPEurr6
	 Io9FfUUo7hX+K0YZw1yzIUKxW6zGMJM1YGShyKwr9edlxBmkMIFgdgHbwQMpASNYGk
	 Bd04C7rjCDTSOyChFn5YhU0w2YH9cig6lHXcCBEf30NyvgGX/swCrOYLjbfFVX05LE
	 eVFuOWoeEMFF3xkDMEO9Rmw3Oz3Ph1KrUJ5ZltFHQv4VWx33/sgq47RbfNfAe1fpQ7
	 bsZ1Y9ThZJKy2v5g9irQ8Ks8gHShyssQzjQC+fWS7cYq3oCQ0r9l64gTZTs6cxMzyT
	 VezTrr5ptgmfw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 04 Feb 2026 12:56:45 +0100
Subject: [PATCH v14 1/9] rust: types: Add Ownable/Owned types
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260204-unique-ref-v14-1-17cb29ebacbb@kernel.org>
References: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
In-Reply-To: <20260204-unique-ref-v14-0-17cb29ebacbb@kernel.org>
To: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun.feng@gmail.com>, 
 Gary Guo <gary@garyguo.net>, 
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
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Asahi Lina <lina+kernel@asahilina.net>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=10830;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=etY8IyUpKdLzs3c+kHeWP5YrOkASXSZeyL30B0eYpjo=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpgzP/Pbmw53LhscIkOAmW8lDoJf1V0iUqN/jB5
 0FsVG9HvsaJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYMz/wAKCRDhuBo+eShj
 d57tEACM7pa7jQjrJbrAAOeLQ144bpJpa6pRZgeGO7B92XAChAaRB1lLNP9mAc9jf2ExYHBIDPj
 o9wO/G/Nr2qF+v3E8zAXR5ph6/x5qfoAvAp+q7hKoTgwm4IrU52Lfh7V8evR0l6py+k1UxIzjyf
 gQU/TG+/hLgtMm7FeQI1vGblgNVdRzzS/zrIFleM2STIzf8xv0MYZpk6EPtg+kBKWHi1QIk7y79
 7Nb3rP/rDZ3McFg2BNRRa4neaBtlO7gSIhFIRR50ssHgHiU6xxfzIlmjGDMrT4NQcyI11aXDsWD
 6cgI0YqjbMY7f7WSVqjyxHozoJjuuQCGXuQR85whd6QKGgauH5XsTpfGPwzaZaqIBjDhryNR7dj
 hMSnD9ncCHHvubELpdehr6bL1DzT3MlG3HOak89+b9rU2gLLlPrNf7RcLafgGPbHqcWHwAbfWSv
 5KcGFks24XXS4jgh3GlxfNk7jmhmiBUMbJSNv2pkFy62FqZoo8bLp7f/e8BGIwTf4O1oAbAVFEy
 s6tM/lrL1Q+xTBTgp2xGlNl9NEOtoI80EGDuZ96w2s13zu9sXFyDFDVB8/LwN0vO8R8m8SLXfKd
 I8Tq6drS4bvI2ELIxj+7Ae9E6Dh+NFYXg4qXR0fp/88lf1T1jYimU5e0/wCJAvc6U24egHC6jXD
 jYWftR0EJkV+VNw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Queue-Id: 1A4FA100005
X-Rspamd-Server: rspam07
X-Stat-Signature: zpgzpmhyynce1zdqxtkqxrkpnj3cxbsc
X-HE-Tag: 1770206276-291618
X-HE-Meta: U2FsdGVkX19vf724hvsPEInM8irxMsQXC+bhpazdhDWePquFasBOcO1+rq+Ae14BScfCyKty9f8fmsayBdcbf9QHrLCssYHQk92wkjg/pXAFOPyf2J4xpDz8sDuroHWr06vjhNZrfc0i9q9WA/QJDaEzB4yJ7eA5FElocYg1jM/vvZZGr1L3iskevO3ZqUu2Dxp5mApK1f6bf9f5tZbSQ5SnGU5yoxOSpP3UCZeh+KaHs5aO4UKGcdWxpngLbhiGtpxDTxOh8CeDMBGonJeTpI+4DfB16HD9vUlJ+piIxf4+X0v3QqLaDMIWk1oKf/TAObUSZ0jVJxkdJs8GC2GdKTd3CKo8gn6h+y9WBsbAUIMLjV72SmJNO96sblqdxSnLwUOf7XQhiMjyZSV0AZqh4JmZY2D7XhAsiyKinmFFK9oorCeIkqLL7A0An8FdNNJvkFnuvXnNqYLXCiNQQcaqrq2lSIVx2DTuwU6C5DtN12yiHdjzHCI6A8YIPIXS4XiyXLbC4zUG9/UqaxvDW+Wxqc1SuXqyejpzKweN7a+zlQWh2wnYzQ3R1EuJKFgqoWjRkW0eoAwUsGLpH98tfhxeAuqTE42ussBfbUQe+h9AbMmXqXEZbAIPGr1vEcMzwN7Unu62COSKuGMmekpuBTJOSds62r7wjXvBNr6cjiC1KYA/Zu6MxbV8TVIsw7WyNC+xfgBIfT3HHonOuGo/qlbK19FlSTcYb0F04BRKqpXl+YbeSips0RQczEJKUvukV3I/DSKXb8ENEIVRPkXqrzxnIq991tfH6NMuywrJgQB6EXcbPyye9UnYgT+nyQs91+nDhWqWdbAkgqZqYb6zvTjuMCWzW+rjE6CuzFFYCHGIvU22/8Rhg6/mniQqqz5JVQIEdrmlCvvjw7fJk2i43U3mDtOqGzu04cY8yizyxTF9kjyDTWFUyD/KbZBbCatPRxqt1UD7Ag1EgchjlroB23X
 1jhLNdeI
 b+MUy6HtfFGYD5PzhDdcYgshTvvm6s97mKEeSwiJtHWikoDYo0kZ5wwfEZRvl/EKNQlpZEERox+DD2dE9mxRK2jBNTC/PtJ5sgLohVs+jNfIAjqe5bjd3Fhfb2VfnnP9RQCsJthwYbkrPTb1WWXh7x1l3dKYxUO8hJ7myBdhZ+44dRrH+j8ppBDO+WGPWxwDVprG2rM/dD4uRfKJQTKH8YQxif5vJPDjY7w1q4eaIv6x7lFdjqkVRTCnbPscVwDrCPI0gNhx7CU4F3FKdswMVsNKkojpVgXbWwFe9tPpGAboSjccQED8/foD+JA+l5vPz9YgKqvVzMKMnnH3l3ABy99cbwCI13YTPFcSIM39f1HokeJu6DDi99idDB+uxVGYrfXzR
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

This change is a derived work based on work by Asahi Lina
<lina+kernel@asahilina.net> [1] and Oliver Mangold <oliver.mangold@pm.me>.

Link: https://lore.kernel.org/rust-for-linux/20250202-rust-page-v1-1-e3170d7fe55e@asahilina.net/ [1]
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/lib.rs       |   1 +
 rust/kernel/owned.rs     | 196 +++++++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/sync/aref.rs |   5 ++
 rust/kernel/types.rs     |  11 ++-
 4 files changed, 212 insertions(+), 1 deletion(-)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index f812cf1200428..96a3fadc3377a 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -119,6 +119,7 @@
 pub mod of;
 #[cfg(CONFIG_PM_OPP)]
 pub mod opp;
+pub mod owned;
 pub mod page;
 #[cfg(CONFIG_PCI)]
 pub mod pci;
diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
new file mode 100644
index 0000000000000..fe30580331df9
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
+    pub fn get_pin_mut(&mut self) -> Pin<&mut T> {
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



