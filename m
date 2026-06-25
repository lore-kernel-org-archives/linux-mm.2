Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3E9ECDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:16:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BCB986B00C8; Thu, 25 Jun 2026 06:16:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA36F6B00CA; Thu, 25 Jun 2026 06:16:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB8F86B00CB; Thu, 25 Jun 2026 06:16:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7A1756B00C8
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:16:29 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F40D71C1698
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:16:28 +0000 (UTC)
X-FDA: 84918030456.23.E672FB7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 1FCD32000E
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:16:27 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d3aBXM0A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782382587;
	b=bb4D6pW7FWHfZff2/CMm8EBXdC0oZUIrP4ROyQcq87hbOuxPFmGFUqV0SToLU3mJROSH1G
	ZJ6g//16XzMAf20tfCn/WtQinx6pw0hl8homRRKXR4zVjZwWA/+TVWCptKzv72QrSYdCgr
	reE6xTrK+25mZd9vDaxW8hqGTi6ennU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782382587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nW0Gvd41fIKfum8lv47xbr88JVN0R0Y3bAVxdgTJ0C0=;
	b=ITPPLM6uKWF/pNuriOykoTjGzTIMeTK3uNgptqM8ONUzVcr9YD96+O7chT/IJAV1TS5mld
	upWv1DKsEomGJpRXuMY2GY8n1D+uNva2/dXB7Snd0/FMASncI4pufeZIGJIPLRNxq+PYpz
	Ci5H+U878CQbZbZ+lh/f5bCHVLe9dEs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=d3aBXM0A;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf03.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7F42D4052E;
	Thu, 25 Jun 2026 10:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0068F1F00A3E;
	Thu, 25 Jun 2026 10:16:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782382586;
	bh=nW0Gvd41fIKfum8lv47xbr88JVN0R0Y3bAVxdgTJ0C0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=d3aBXM0AxdQw41hMsab5NcgQtxpxRZA7bMwCCT9xFhVQqGBvgmHwwxnIGIDORJlwg
	 lwuKxqbNYN1I271Cl80BvoZNYpI+XOgvchXKgbm7buo6N4OH2WXTcMxZpGCacCLug2
	 aj9AvCEK/G4iKPcO5JBXlQvfydA7jI3ussU/JzGnG5nOf6WcFMDex59Zuu2UzWWvOi
	 VCrhjWccPhH3sM4FvknL78jP6kdbJ62uu8/lcpKk5MdNaU49+DANu2NWn/Sgmc7W80
	 x5n1o/cqReqvlU5bPbsV706GCHVaMa6nEyK0Qk78OPDYkbfqOWKY8QW2D9VbTzD0f1
	 AfEYmoIdDMoVw==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 25 Jun 2026 12:15:04 +0200
Subject: [PATCH v18 2/8] rust: types: Add Ownable/Owned types
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260625-unique-ref-v18-2-4e06b5896d47@kernel.org>
References: <20260625-unique-ref-v18-0-4e06b5896d47@kernel.org>
In-Reply-To: <20260625-unique-ref-v18-0-4e06b5896d47@kernel.org>
To: Danilo Krummrich <dakr@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 Uladzislau Rezki <urezki@gmail.com>, Miguel Ojeda <ojeda@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
 Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
 Lyude Paul <lyude@redhat.com>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 =?utf-8?q?Arve_Hj=C3=B8nnev=C3=A5g?= <arve@android.com>, 
 Todd Kjos <tkjos@android.com>, Christian Brauner <brauner@kernel.org>, 
 Carlos Llamas <cmllamas@google.com>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, 
 Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, 
 Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
 Serge Hallyn <sergeh@kernel.org>, David Airlie <airlied@gmail.com>, 
 Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, 
 Jan Kara <jack@suse.cz>, Igor Korotin <igor.korotin@linux.dev>, 
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
 Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
 =?utf-8?q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, 
 Pavel Tikhomirov <ptikhomirov@virtuozzo.com>, 
 Michal Wilczynski <m.wilczynski@samsung.com>
Cc: Andreas Hindborg <a.hindborg@kernel.org>, 
 Philipp Stanner <phasta@kernel.org>, rust-for-linux@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 driver-core@lists.linux.dev, linux-block@vger.kernel.org, 
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 linux-fsdevel@vger.kernel.org, linux-pm@vger.kernel.org, 
 linux-pci@vger.kernel.org, linux-pwm@vger.kernel.org, 
 Asahi Lina <lina+kernel@asahilina.net>, 
 Oliver Mangold <oliver.mangold@pm.me>, Boqun Feng <boqun@kernel.org>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=10621;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=GO++Qeu4a7kF68yEw+Vn2C+P9gU67mXjb8+4Ea2xpsk=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqPP+/0fmgcSFjRSNwUKn7JTTqjgcfI1tNyLzoN
 3QnXRx5pSSJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCajz/vwAKCRD6UCkIqsW9
 0FZgD/sF1P1WOMfjtJ5QaSgZxTnirlk7uykNXVIp8tGPuvEOkMFSQ3MXPTJTmg9ce7YTeFHDUnP
 QbAckIs03ccgSfCBT1fyIMsGvj7/W+6vzBUJT8KMvCJb2V+Qjr+5UyxkzOSbehi/7h2+uVKhR0S
 szT9fMY9RTz0riW3TYKyZB9aSligkz1bU6ZVXAEHmt0FtZCobX+raZvnvuA9XGtwHYhllziuDJI
 3e7iMDnpVkHBb+XZzPHkwuDPsWsdXGZ6T5R2neJIQfteE6hncMd339UB/Q+kQ126jkncY6Iu+j2
 0lP5znU7H+I8NP+zQLhmQH+PqOnDt/PzFcby0Egl0vsIW+yQP7cmj7LQSW4VNq4TFXMLJDFBEiM
 roTRVO8LrTIjFTluE5skMfOFuUp6urFkAgeuQrM2bvO/8Vzy/+9IteZt4gsRExMJpoK3V6Ziuk8
 +delMllRrIhqsZefJX5w6r5ocYIZb+tA0ZcUIHHzMgkHmb32Pnqbr7Gq50f7+oG85CTh17PWpIT
 F74Zx5CKbRvD6EqpxxBxEwnq9qFoblfHLCnRqEGv7MraVkW67OIQEmqpfpMHx89+FQKHsosUZOM
 ARW0ChOy2j28ixl+PxIHH6YDuDZsYK+bVZVBmH/cPLwyOi4eRjkqGIqwsxpAPSgHyun6Ie32SiB
 ig0Zc2eJRLq66Dw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1FCD32000E
X-Rspam-User: 
X-Stat-Signature: fjusots3m414fwwnqw8ujawn5epyoqef
X-HE-Tag: 1782382587-779678
X-HE-Meta: U2FsdGVkX1/4TT0VW3eLJg8hf8tIuKqHwXV83ZetZ12ME/7jjiY2B+ZArSVhrS+FQSuqgZPb7dHUF2CLqfcWc6DVtq/DGTmQTwl0XYALU1Ntg5ekm0SaiK8TcQ5Nbs2/c60+LXtvZqN7OnlVsVS9fL74FGbKE+4wh45rH0lHRUryabEm7cHdotkg9mhN3o5Ff2xO7Jt2Q5BRG2tp/4VWvTACsPgavetqNZZm5OszL+HevgBt2/tbFXFdtL58Pqmj0z7yyOR+Pd2L8QwpTaTrIpbBL4NayZ2cgNF8Vo/K8RuX3ILEAYgLzdmpq55lAWawAzRL1McdUonpzMsqFQdkFT37KozNj5il2ioWDabYjXUEMyR6WHLH/5zkK83RIw0jSzusgutT9q90Q1XsOLZAc334rgNZVZPaqJ7KJZOmnzprJASUrwBsbdeDs0YRzszIwWntVabPxXKBQHl0kF31AlcXqtBMqQrktHc53ar+rpacTufKVexHxUHgN4wUDjHcdIJDuAGpN7Z+pCNyvgA81pcfJjRb1SDMmbXD9uOhavvLu93Q9Hs+W+0IX/8qWV2D+OuMjWjFX0dVkDAGxJNBXhe7rJkeqz6CYsHKabIvRbLN/zF5abDefGyim3xRku3nBm6RfvcGvMXSCUMyr1qy24P6d/eF7ZufMTOSBQf3s8hoVa7lMVG9y46ijIzv/XBcO3Lfb0zdJjQVpMxkxXNtWBIPO1jrFvJ1Gg89+BK0Zlfa27/+hd8/oRyKAfQXSXnopsjLppaQ4Pj8PFv+5IoO8QsNkM3YWXPX92j84mhbReEWmPRwrCqjej/UwrIVzVE3saMNZdCi6PiJJvINJaw0UTs88p7QDss24Ny7ThAODFL700qppVcpG29fqW/oISSk43AN+Tfk/K/e/G2GVMSzHx029xbdumckVyEPuVWyHJm4uT0bvjFEJqNh2+pTlFj1e5MeVTttATgLIijac2s
 DtQMKq7v
 XNuFdNduor3vV/GAIT9KmhSvEQ4388C16JiPTldpblKjkF5Ra6fYIMDBpQpFb4ql+EVUBFSohcsWv8vqHqznfDNQ2IFUS7a1E18d086gmuluvFmPMuwXfJ0eYBaIv67oFSSqoH8hTd3+k7j6ch5bLsE0WhOubWfSugLj4q2zwcXWPEFIBxcJHWT/jrkXWb8NWvUt0IwmAl+ROVi/ssE16GgJ2U1uGX1fK9vbaR+wtn4T/iHFRA90lXeOw81Ftxf3TPKaBvOEpIJX6EDrJlDv/5QRINqhAO5heFdnayoLS/w/gycQOVE3WxqmY/reBUd8d7FtNS/P//pSWm4W7w8/LKcb7IoX+GE9jjYkS2AsJ1D/AYFLFX+ia5jVxjRkYS/8Lg44k1Df5ZRUgQGl8bMIxS2og0pyVNDk4WF+YZCMkOKfK1BxeZis3dDSUWWbYj0liLHVz9cOL2u877Q5xiEmPAn2HJKVYS+evWosPhAy0n8vM02ELXfn4Rjta3n8iE88SumVJ6EEdA1QSIByMdWpMRXl3ilwfZx+sgZuDK9j1F57wjggBR8kw+eW5nPMFWygDMCoPqtXgEpFFJds=
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
Reviewed-by: Gary Guo <gary@garyguo.net>
Reviewed-by: Alice Ryhl <aliceryhl@google.com>
[ Andreas: Updated documentation, examples, and formatting. Change safety
  requirements, safety comments. ]
Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/lib.rs       |   1 +
 rust/kernel/owned.rs     | 188 +++++++++++++++++++++++++++++++++++++++++++++++
 rust/kernel/sync/aref.rs |   5 ++
 rust/kernel/types.rs     |   5 ++
 4 files changed, 199 insertions(+)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index 9512af7156df2..eb5256204a174 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -101,6 +101,7 @@
 pub mod of;
 #[cfg(CONFIG_PM_OPP)]
 pub mod opp;
+pub mod owned;
 pub mod page;
 #[cfg(CONFIG_PCI)]
 pub mod pci;
diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
new file mode 100644
index 0000000000000..7fe9ec3e55126
--- /dev/null
+++ b/rust/kernel/owned.rs
@@ -0,0 +1,188 @@
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
+/// [`AlwaysRefCounted`](crate::sync::aref::AlwaysRefCounted) should be implemented.
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
+///         let result = KBox::into_non_null(result);
+///         // Count new allocation
+///         *FOO_ALLOC_COUNT.lock() += 1;
+///         // SAFETY:
+///         //  - We just allocated the `Self`, thus it is valid and we own it.
+///         //  - We can transfer this ownership to the `from_raw` method.
+///         Ok(unsafe { Owned::from_raw(result) })
+///     }
+/// }
+///
+/// impl Ownable for Foo {
+///     unsafe fn release(this: NonNull<Self>) {
+///         // SAFETY: The [`KBox<Self>`] is still alive. We can pass ownership to the [`KBox`], as
+///         // by requirement on calling this function.
+///         drop(unsafe { KBox::from_raw(this.as_ptr()) });
+///         // Count released allocation
+///         *FOO_ALLOC_COUNT.lock() -= 1;
+///     }
+/// }
+///
+/// {
+///    let foo = Foo::new()?;
+///    assert!(*FOO_ALLOC_COUNT.lock() == 1);
+/// }
+/// // `foo` is out of scope now, so we expect no live allocations.
+/// assert!(*FOO_ALLOC_COUNT.lock() == 0);
+/// # Ok::<(), Error>(())
+/// ```
+pub trait Ownable {
+    /// Tear down this `Ownable`.
+    ///
+    /// Implementers of `Ownable` can use this function to clean up the use of `Self`. This can
+    /// include freeing the underlying object.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that they have exclusive ownership of the `Self` pointed to by `this`,
+    /// and that this ownership is transferred to the `release` method. `this` must not be used
+    /// after calling this method, as the underlying object may have been freed.
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
+/// - Until `T::release` is called, this `Owned<T>` exclusively owns the underlying `T`.
+/// - The `T` value is pinned.
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
+    /// - Until `T::release` is called, the returned `Owned<T>` exclusively owns the underlying `T`.
+    #[inline]
+    pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
+        // INVARIANT: By function safety requirement we satisfy the first invariant of `Self`.
+        // We treat `T` as pinned from now on.
+        Self { ptr }
+    }
+
+    /// Consumes the [`Owned`], returning a raw pointer.
+    ///
+    /// This function does not drop the underlying `T`. When this function returns, ownership of the
+    /// underlying `T` is with the caller.
+    #[inline]
+    pub fn into_raw(me: Self) -> NonNull<T> {
+        ManuallyDrop::new(me).ptr
+    }
+
+    /// Get a pinned mutable reference to the data owned by this `Owned<T>`.
+    #[inline]
+    pub fn as_pin_mut(&mut self) -> Pin<&mut T> {
+        // SAFETY: The type invariants guarantee that the object is valid, and that we can safely
+        // return a mutable reference to it.
+        let unpinned = unsafe { self.ptr.as_mut() };
+
+        // SAFETY: By type invariant `T` is pinned.
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
+    #[inline]
+    fn deref(&self) -> &Self::Target {
+        // SAFETY: The type invariants guarantee that the object is valid.
+        unsafe { self.ptr.as_ref() }
+    }
+}
+
+impl<T: Ownable + Unpin> DerefMut for Owned<T> {
+    #[inline]
+    fn deref_mut(&mut self) -> &mut Self::Target {
+        // SAFETY: The type invariants guarantee that the object is valid, and that we can safely
+        // return a mutable reference to it.
+        unsafe { self.ptr.as_mut() }
+    }
+}
+
+impl<T: Ownable> Drop for Owned<T> {
+    #[inline]
+    fn drop(&mut self) {
+        // SAFETY: By existence of `&mut self` we exclusively own `self` and the underlying `T`. As
+        // we are dropping `self`, we can transfer ownership of the `T` to the `release` method.
+        unsafe { T::release(self.ptr) };
+    }
+}
diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index b721b2e00b986..3bd5eb8a1a526 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -34,6 +34,11 @@
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
index ac316fd7b538f..c41eab0ec983c 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -15,6 +15,11 @@
 pub mod for_lt;
 pub use for_lt::ForLt;
 
+pub use crate::owned::{
+    Ownable,
+    Owned, //
+};
+
 /// Used to transfer ownership to and from foreign (non-Rust) languages.
 ///
 /// Ownership is transferred from Rust to a foreign language by calling [`Self::into_foreign`] and

-- 
2.51.2



