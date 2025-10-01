Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68B5DCCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 09:04:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C01348E0016; Wed,  1 Oct 2025 05:04:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B89E28E0002; Wed,  1 Oct 2025 05:04:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7BC48E0016; Wed,  1 Oct 2025 05:04:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8EA528E0002
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 05:04:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3564687DFB
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:04:00 +0000 (UTC)
X-FDA: 83948958240.07.C7C02A4
Received: from mail-24418.protonmail.ch (mail-24418.protonmail.ch [109.224.244.18])
	by imf05.hostedemail.com (Postfix) with ESMTP id 493F710000D
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 09:03:58 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=L9sVTHvM;
	spf=pass (imf05.hostedemail.com: domain of oliver.mangold@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=oliver.mangold@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759309438;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YoI0D4NsBDAriHqvQCNsBFedVGBNu9amEcT5uTdvatQ=;
	b=XfUHvS5J+97YxcZ3h551A6TLx0ucwDX1RbALJjUp+fa4W+/7a50CDbAzs9tGZKAG76HRxi
	QHVWQ7LTRNyJVsSpjCfAROiYXLa2er/Em+RL8KUPHT9CFJvxuslUfB1dt5EP2onjFYmZoZ
	ysrbmf0Jmmppjmk8RjW15g/9im3Wsls=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759309438; a=rsa-sha256;
	cv=none;
	b=GmNh2o26xObz6zHyHgBr0X0mRuN2JFJhUHuwmLBC2ioNAoFz1bjc+fny4ypbOQGeLRufJO
	16nuS6bIHlLGuqVFEfcoxKw0hQ09KQTydRTnvgQmpfYYbGtcn6OlhZ9is76qHv5GFhQAfr
	0tqgVgRTEgJ6e07QP1uqLK7VjlU6epI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=L9sVTHvM;
	spf=pass (imf05.hostedemail.com: domain of oliver.mangold@pm.me designates 109.224.244.18 as permitted sender) smtp.mailfrom=oliver.mangold@pm.me;
	dmarc=pass (policy=quarantine) header.from=pm.me
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1759309434; x=1759568634;
	bh=YoI0D4NsBDAriHqvQCNsBFedVGBNu9amEcT5uTdvatQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=L9sVTHvMw4CrqyW+CsE9JaQwJVAo1oLei/965QD0Gyr/xDd3x3VmDqqRNN3EFvHIk
	 qGvW/IOiRXZVGs8Zr2Uq8BIN3mik48n48AVNcQP1l+nVzynsk4SMgmHLXQlJNoTdfe
	 Cm4n60ytoVcTxx7SSgp/RinH/mV59nr4yshFcbU2mereAc5tJw964pisXmwPgf/OpG
	 13YwgYGTYP713AHIAY+4JhTjT/Bd+AT3oizcLDvUnAzlaBa1Rvg+88iwzhw/wXdIH7
	 aZAZT/Qt8P6F01QOBu/dt2/yIl1UIICk7e6k2xtccYTWmxRcfKqmu+Abj9W8qHHTwA
	 WlYhCb22qDDQw==
Date: Wed, 01 Oct 2025 09:03:46 +0000
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar
	<vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, =?utf-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Asahi Lina <lina+kernel@asahilina.net>
From: Oliver Mangold <oliver.mangold@pm.me>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, Oliver Mangold <oliver.mangold@pm.me>
Subject: [PATCH v12 1/4] rust: types: Add Ownable/Owned types
Message-ID: <20251001-unique-ref-v12-1-fa5c31f0c0c4@pm.me>
In-Reply-To: <20251001-unique-ref-v12-0-fa5c31f0c0c4@pm.me>
References: <20251001-unique-ref-v12-0-fa5c31f0c0c4@pm.me>
Feedback-ID: 31808448:user:proton
X-Pm-Message-ID: 4c3d84e501b0f9cf1753def9896c6efd7ea89700
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: qki9uje8zcjpk44ir9gatpd5sjbdbf1f
X-Rspamd-Queue-Id: 493F710000D
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1759309438-849822
X-HE-Meta: U2FsdGVkX188yzDqR7ra8Lh3n22g3lBeO69XbDN+2Gyc70KJddxRxWVBt2FdPl4238RhstaySWGCXzRfIUQQ3CLleDIZWIffwd4Hlbxc1+bJBFHwWSTt4VvHBzB4HTy6SZxrlVYO1QFFtIzbqa6DCz3afVCc5uOzQ5LNtywi9X+gLUmeZqoO+gsGEH96c/FSy/Crzr/eveEsYiNaWTqJBs7CEzORdyHC9UhyoE3Tza15O70y+imWIzEGhI2RsexqpQanpKV8dWQhSlTMq4AKkgploDL6h9MhP6Qr/NSzz4DW1i4Mbf0d0Y77cBCtlYcCfyoiabw3qZ4rlT0NjDGaYRvPEp+lYRouhVY5YKDgg2w5K/9K/iCzpnZPSct+hI0RqhVdkVqfGHYBzI3FnggShI1ogVXJtQoHOS+1cRSeopJ5ayptSNYvGvRaM16OxKmkulICcbTaDD+1gisvnluRMZUIY7kuDslFFNrsXlHfgFjPiHzskOPXFyOCpJx9LWb2L/FFiucD11PotK+MHUR2gboM6vkaT2eSWJ3pIV1yGm1Ou+0zx55f1PNIVo3yywvyPUHxMWLZORqu0c+yyayUkDNOGdLiZvtxPYAKTZqqPXF0JoIFeOxDDpm56EaZ/x/dWuoBGZr5/lX2in1xt3K5E958kpE0CgCCkQtECwtGUSabTAZ5GI9nK1k3JYFfEPCyIBAtE1LXz8Gk/KCGBVYybL5CIsQEWJbYsantNc6iOFCuMbsGnFn3aAEYEo61+BWjXmCahc9nSmGgj/yv73BaWZAmv0SCAMGOw+/61wgtxadgxe/dj8acevDvbU7s0tH2K6uvvpztM/8U8bSGncseNkveEbKss6c8o69dVh0qJY4viE+VxhnbWlnFn2BztALxirWqcyJ1kvEmy5e6/jaYJSVQ4fJP5L6/KCg6fAQAil8m9CuXBeam0+sWd4vYonZ7DdnGaOKcx23QLGE6JR3
 qnfl0ivI
 3iaPmuXkuvAHuhma/+6CJIWZ+FkFCzKaupRoc0FAmtfmjA2YwIrvbO4gOWCFiniSOj5BqOTOevnI4O5ViM5yauGDfTdzcCBlr9LgPNjTZU0WHgqX3o9x0f4u1FlCC2+ICCghnuo3rP+X/ez0KutAz745yL01bZb9szzAxsK+/FLvfaiOaYpwgfbUlld227ItpLUprKEjoYNc1TpGcy3u5LHCvz5dlg1zyXptMpNDeh2J3Ql8YJDU5+9raiYUr8ripCmPH/zSePFq5cirEgjLayLZwHwVsuRSc1M0rOBDtZerBvMP+KMjigwhwYj/tJP+3OvCxb95O59GjwIiHlNc3HiEloun1zbIiOd4ElCyQZJA35Eh+JMjtQDppfWBj6fPrAwEjBt95bBbf4xk=
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

Link: https://lore.kernel.org/all/20250202-rust-page-v1-1-e3170d7fe55e@asah=
ilina.net/
Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
Co-developed-by: Oliver Mangold <oliver.mangold@pm.me>
Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
---
 rust/kernel/lib.rs       |   1 +
 rust/kernel/owned.rs     | 195 +++++++++++++++++++++++++++++++++++++++++++=
++++
 rust/kernel/sync/aref.rs |   5 ++
 rust/kernel/types.rs     |   2 +
 4 files changed, 203 insertions(+)

diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
index ed53169e795c0badf548025a57f946fa18bc73e3..3aea741f668b7d7a1a16e8e4537=
e5edba997259c 100644
--- a/rust/kernel/lib.rs
+++ b/rust/kernel/lib.rs
@@ -92,6 +92,7 @@
 pub mod init;
 pub mod io;
 pub mod ioctl;
+pub mod owned;
 pub mod jump_label;
 #[cfg(CONFIG_KUNIT)]
 pub mod kunit;
diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
new file mode 100644
index 0000000000000000000000000000000000000000..38f70a20fb965305d14836498a0=
e7ad73166c6c4
--- /dev/null
+++ b/rust/kernel/owned.rs
@@ -0,0 +1,195 @@
+// SPDX-License-Identifier: GPL-2.0
+
+//! Unique reference types for objects with custom destructors. They shoul=
d be used for C-allocated
+//! objects which by API-contract are owned by Rust, but need to be freed =
through the C API.
+
+use core::{
+    marker::PhantomData,
+    mem::ManuallyDrop,
+    ops::{Deref, DerefMut},
+    pin::Pin,
+    ptr::NonNull,
+};
+
+/// Type allocated and destroyed on the C side, but owned by Rust.
+///
+/// Implementing this trait allows types to be wrapped in an [`Owned<Self>=
`]. Such types can
+/// define their own custom destructor function to be called when the [`Ow=
ned<Self>`] is
+/// dropped.
+///
+/// Note: The underlying object is not required to provide internal refere=
nce counting, because it
+/// represents a unique, owned reference. If reference counting (on the Ru=
st side) is required,
+/// [`AlwaysRefCounted`](crate::types::AlwaysRefCounted) should be impleme=
nted.
+///
+/// # Safety
+///
+/// Implementers must ensure that the [`release()`](Self::release) functio=
n frees the underlying
+/// object in the correct way for a valid, owned object of this type.
+///
+/// # Examples
+///
+/// A minimal example implementation of [`Ownable`] and its usage with [`O=
wned`] looks like this:
+///
+/// ```
+/// # #![expect(clippy::disallowed_names)]
+/// use core::cell::Cell;
+/// use core::ptr::NonNull;
+/// use kernel::sync::global_lock;
+/// use kernel::alloc::{flags, kbox::KBox, AllocError};
+/// use kernel::types::{Owned, Ownable};
+///
+/// // Let's count the allocations to see if freeing works.
+/// kernel::sync::global_lock! {
+///     // SAFETY: we call `init()` right below, before doing anything els=
e.
+///     unsafe(uninit) static FOO_ALLOC_COUNT: Mutex<usize> =3D 0;
+/// }
+/// // SAFETY: We call `init()` only once, here.
+/// unsafe { FOO_ALLOC_COUNT.init() };
+///
+/// struct Foo {
+/// }
+///
+/// impl Foo {
+///     fn new() -> Result<Owned<Self>, AllocError> {
+///         // We are just using a `KBox` here to handle the actual alloca=
tion, as our `Foo` is
+///         // not actually a C-allocated object.
+///         let result =3D KBox::new(
+///             Foo {},
+///             flags::GFP_KERNEL,
+///         )?;
+///         let result =3D NonNull::new(KBox::into_raw(result))
+///             .expect("Raw pointer to newly allocation KBox is null, thi=
s should never happen.");
+///         // Count new allocation
+///         *FOO_ALLOC_COUNT.lock() +=3D 1;
+///         // SAFETY: We just allocated the `Self`, thus it is valid and =
there cannot be any other
+///         // Rust references. Calling `into_raw()` makes us responsible =
for ownership and we won't
+///         // use the raw pointer anymore. Thus we can transfer ownership=
 to the `Owned`.
+///         Ok(unsafe { Owned::from_raw(result) })
+///     }
+/// }
+///
+/// // SAFETY: What out `release()` function does is safe of any valid `Se=
lf`.
+/// unsafe impl Ownable for Foo {
+///     unsafe fn release(this: NonNull<Self>) {
+///         // The `Foo` will be dropped when `KBox` goes out of scope.
+///         // SAFETY: The [`KBox<Self>`] is still alive. We can pass owne=
rship to the [`KBox`], as
+///         // by requirement on calling this function, the `Self` will no=
 longer be used by the
+///         // caller.
+///         unsafe { KBox::from_raw(this.as_ptr()) };
+///         // Count released allocation
+///         *FOO_ALLOC_COUNT.lock() -=3D 1;
+///     }
+/// }
+///
+/// {
+///    let foo =3D Foo::new().expect("Failed to allocate a Foo. This shoul=
dn't happen");
+///    assert!(*FOO_ALLOC_COUNT.lock() =3D=3D 1);
+/// }
+/// // `foo` is out of scope now, so we expect no live allocations.
+/// assert!(*FOO_ALLOC_COUNT.lock() =3D=3D 0);
+/// ```
+pub unsafe trait Ownable {
+    /// Releases the object.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that:
+    /// - `this` points to a valid `Self`.
+    /// - `*this` is no longer referenced after this call.
+    unsafe fn release(this: NonNull<Self>);
+}
+
+/// An owned reference to an [`Ownable`] object.
+///
+/// The [`Ownable`] is automatically freed or released when an instance of=
 [`Owned`] is
+/// dropped.
+///
+/// # Invariants
+///
+/// - The [`Owned<T>`] has exclusive access to the instance of `T`.
+/// - The instance of `T` will stay alive at least as long as the [`Owned<=
T>`] is alive.
+pub struct Owned<T: Ownable> {
+    ptr: NonNull<T>,
+    _p: PhantomData<T>,
+}
+
+// SAFETY: It is safe to send an [`Owned<T>`] to another thread when the u=
nderlying `T` is [`Send`],
+// because of the ownership invariant. Sending an [`Owned<T>`] is equivale=
nt to sending the `T`.
+unsafe impl<T: Ownable + Send> Send for Owned<T> {}
+
+// SAFETY: It is safe to send [`&Owned<T>`] to another thread when the und=
erlying `T` is [`Sync`],
+// because of the ownership invariant. Sending an [`&Owned<T>`] is equival=
ent to sending the `&T`.
+unsafe impl<T: Ownable + Sync> Sync for Owned<T> {}
+
+impl<T: Ownable> Owned<T> {
+    /// Creates a new instance of [`Owned`].
+    ///
+    /// It takes over ownership of the underlying object.
+    ///
+    /// # Safety
+    ///
+    /// Callers must ensure that:
+    /// - `ptr` points to a valid instance of `T`.
+    /// - Ownership of the underlying `T` can be transferred to the `Self<=
T>` (i.e. operations
+    ///   which require ownership will be safe).
+    /// - No other Rust references to the underlying object exist. This im=
plies that the underlying
+    ///   object is not accessed through `ptr` anymore after the function =
call (at least until the
+    ///   the `Self<T>` is dropped.
+    /// - The C code follows the usual shared reference requirements. That=
 is, the kernel will never
+    ///   mutate or free the underlying object (excluding interior mutabil=
ity that follows the usual
+    ///   rules) while Rust owns it.
+    /// - In case `T` implements [`Unpin`] the previous requirement is ext=
ended from shared to
+    ///   mutable reference requirements. That is, the kernel will not mut=
ate or free the underlying
+    ///   object and is okay with it being modified by Rust code.
+    pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
+        Self {
+            ptr,
+            _p: PhantomData,
+        }
+    }
+
+    /// Consumes the [`Owned`], returning a raw pointer.
+    ///
+    /// This function does not actually relinquish ownership of the object=
. After calling this
+    /// function, the caller is responsible for ownership previously manag=
ed
+    /// by the [`Owned`].
+    pub fn into_raw(me: Self) -> NonNull<T> {
+        ManuallyDrop::new(me).ptr
+    }
+
+    /// Get a pinned mutable reference to the data owned by this `Owned<T>=
`.
+    pub fn get_pin_mut(&mut self) -> Pin<&mut T> {
+        // SAFETY: The type invariants guarantee that the object is valid,=
 and that we can safely
+        // return a mutable reference to it.
+        let unpinned =3D unsafe { self.ptr.as_mut() };
+
+        // SAFETY: We never hand out unpinned mutable references to the da=
ta in
+        // `Self`, unless the contained type is `Unpin`.
+        unsafe { Pin::new_unchecked(unpinned) }
+    }
+}
+
+impl<T: Ownable> Deref for Owned<T> {
+    type Target =3D T;
+
+    fn deref(&self) -> &Self::Target {
+        // SAFETY: The type invariants guarantee that the object is valid.
+        unsafe { self.ptr.as_ref() }
+    }
+}
+
+impl<T: Ownable + Unpin> DerefMut for Owned<T> {
+    fn deref_mut(&mut self) -> &mut Self::Target {
+        // SAFETY: The type invariants guarantee that the object is valid,=
 and that we can safely
+        // return a mutable reference to it.
+        unsafe { self.ptr.as_mut() }
+    }
+}
+
+impl<T: Ownable> Drop for Owned<T> {
+    fn drop(&mut self) {
+        // SAFETY: The type invariants guarantee that the `Owned` owns the=
 object we're about to
+        // release.
+        unsafe { T::release(self.ptr) };
+    }
+}
diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index dbd77bb68617cab786fe4a1168d697e30a6de299..f8085cfe50db0798c3cdadab35a=
c6e2826c315f9 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -14,6 +14,11 @@
 /// Rust code, the recommendation is to use [`Arc`](crate::sync::Arc) to c=
reate reference-counted
 /// instances of a type.
 ///
+/// Note: Implementing this trait allows types to be wrapped in an [`ARef<=
Self>`]. It requires an
+/// internal reference count and provides only shared references. If uniqu=
e references are required
+/// [`Ownable`](crate::types::Ownable) should be implemented which allows =
types to be wrapped in an
+/// [`Owned<Self>`](crate::types::Owned).
+///
 /// # Safety
 ///
 /// Implementers must ensure that increments to the reference count keep t=
he object alive in memory
diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index dc0a02f5c3cfc532d1fa5f209b40dd79cbe0fb37..7bc07c38cd6cb6abb59384e20a7=
93f28633a9eac 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -11,6 +11,8 @@
 };
 use pin_init::{PinInit, Wrapper, Zeroable};
=20
+pub use crate::owned::{Ownable, Owned};
+
 pub use crate::sync::aref::{ARef, AlwaysRefCounted};
=20
 /// Used to transfer ownership to and from foreign (non-Rust) languages.

--=20
2.51.0



