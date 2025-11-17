Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30CDBCE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 10:08:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AA138E001A; Mon, 17 Nov 2025 05:08:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 859D18E0002; Mon, 17 Nov 2025 05:08:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 748F18E001A; Mon, 17 Nov 2025 05:08:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 598578E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 05:08:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 75E078A35A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:08:30 +0000 (UTC)
X-FDA: 84119674380.26.3D600A9
Received: from mail-43101.protonmail.ch (mail-43101.protonmail.ch [185.70.43.101])
	by imf07.hostedemail.com (Postfix) with ESMTP id 91C8C4000A
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 10:08:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=VBYi1Bjp;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf07.hostedemail.com: domain of oliver.mangold@pm.me designates 185.70.43.101 as permitted sender) smtp.mailfrom=oliver.mangold@pm.me
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763374108; a=rsa-sha256;
	cv=none;
	b=d9W9qQRE7c4q9OUWqujfC5E/Qxo7Lh+9/5mvUZaNxyYM9cmPu8mGXH/EpzsAR13Q1oQaeT
	KOHaNuCxWAWxwlgSx8OUOxfAh5INBw6YbRgy9YptDbkEc3LU+69xPmr9oD8+Q9Nrg+R6sU
	8pLdQNeKHZrBEn3lnwGAS6IxDbzyqK4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=pm.me header.s=protonmail3 header.b=VBYi1Bjp;
	dmarc=pass (policy=quarantine) header.from=pm.me;
	spf=pass (imf07.hostedemail.com: domain of oliver.mangold@pm.me designates 185.70.43.101 as permitted sender) smtp.mailfrom=oliver.mangold@pm.me
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763374108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F8QmXBD76J3qCzTETOCLiOcAviZpmYBfTlPSLSZilqQ=;
	b=UH8pbNE9kYF0qS+MSKgCaE1tsq8PbhJCJwfNm+f7WZrfyaT1hCh7pkZfS4tw28LSPaUB2L
	twtmL55V0peJKaHpSK7tQGV9kVuJgjrhUbMSlkbbcNhT52xLhZOJEOIlD1L+T0x+dFRl73
	lWLCAjBUxjQpnuYgh96hRstJ3kIVOR4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me;
	s=protonmail3; t=1763374104; x=1763633304;
	bh=F8QmXBD76J3qCzTETOCLiOcAviZpmYBfTlPSLSZilqQ=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=VBYi1BjpoQ7qld69aV0aXQzEnwVo9DaT1+BDKXncDZA7KpEWXfpgeyRwuSgTyKMg8
	 HDsWKEXh1bIxigACIwvmeT6sQEL44CKupLI+0NBo7laHP3n7vvFXmwymi5n4qrzWXW
	 IDYnfeCfU2g8PC/rPHAGon0TH1+CkUCQ75StfWjuW8r7jqHYMkpqqiK83ug4qWyoCL
	 Jn8Ok0LE24Oyojjag6WYzvfsPBUBCBFXk77lN+Kt9vMDU92CiZDl5aT9RpMjlsGggm
	 FTcr6ts48joDB4Vmw+qMnAFE8ylK0CJ+J3KEZoGpXGc7Dac4WRW/c3jp8szCe8xugc
	 rZZOd7lUFuY5g==
Date: Mon, 17 Nov 2025 10:08:18 +0000
To: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>, Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>, =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, Andreas Hindborg <a.hindborg@kernel.org>, Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, Maarten Lankhorst <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar
	<vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, =?utf-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Asahi Lina <lina+kernel@asahilina.net>
From: Oliver Mangold <oliver.mangold@pm.me>
Cc: rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, linux-security-module@vger.kernel.org, Oliver Mangold <oliver.mangold@pm.me>
Subject: [PATCH v13 4/4] rust: Add `OwnableRefCounted`
Message-ID: <20251117-unique-ref-v13-4-b5b243df1250@pm.me>
In-Reply-To: <20251117-unique-ref-v13-0-b5b243df1250@pm.me>
References: <20251117-unique-ref-v13-0-b5b243df1250@pm.me>
Feedback-ID: 31808448:user:proton
X-Pm-Message-ID: 2b170fe14f88c3e5d5156d2bc7b77a7cfff96e6f
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 91C8C4000A
X-Stat-Signature: j9tatwzr97o1dbzrhyd155btgkewcd4q
X-HE-Tag: 1763374108-119297
X-HE-Meta: U2FsdGVkX18iUoBAYccwZaREan55UyScMaBGgvdng6x/Q/nAX+fZ/5sG8UWz5NucSQZiv2jLNee2rAQt68B7INJ+uX4De+vaqga+oQle1Q53BkkcdXlJ4oWCXe4PTlGcRpDU/nCFLqPlb0Skrq+s5bh/pgfYWaogqsyECKCJCRhUhQ9+Ma0PVMWZ1bsUSibHclJ2LXQ2HHvcp901fMf7pbk129fP6CVbndVAZDmjUr/JbQQ46sDwzO+kv9Ov7dN15pmvuFSH/jhiudPSCrBrwvKNIG6V0AAGHXnhh2zNRG+AUx0RghyGnhkkaZCqB3QDVnQzOjnu5CisfOIdq4HkMCQ6yuFu6FDo5F17uF8HqxdUVIWB6c298Ja5Y4LeKfs/bKIqEWoorf/SVZcpwtZxaL+Bz41IP9HcQgv+o808HHqMKzKasX/feMUQksa/9swmQKQ8ttYMo8nHSUspIi+j5SgYgFg711kbxN5HJ8G/pCaD8g0w0xactN/Lygk1hqmCc8gRASSYQtFpPVlTBfzSEC2Zb41ZGrw4/nn2OYsawrpU+yOW2RPtLVedUp7jlD5td2SXpu7+KgRNWr8nVm1Icr9eyGmd8AA+e7y7Q+c1bwA5LFh4NCistenVLadl2TAFLBADTNShoPrgRvmpENdm1ko6O0dvorKm4e+TIvKFrpqbKTfvJFluotooK+xLDIEPQqWJ9hfkDVY3NIz2N+mI9F8/VP3Za1p0q/CBhRj+/bERKsc59y8sc5sUF52EpgYw2977F82auP0+OvftZ2z8MKCC6/lMJs4BvdStPust1+GGfwm8yXBalDZl9CnMKRleW+gb/DJcpOvYaBHTR334Bb9kF849Mpu1KY+s0Np+vswLjypVmh/ihA+rsAH4BGM6PDH5OwE9p8apByDsIvFa5+eDfxwrbO26/i+0k9j3OYGtMoaT/CQct1RblYaWrHTiwsvYQIcR62hnxCQ1bCd
 b19YJ2W7
 LGWEZj150kc0cK8EfcI1ahM/D6fe7ogA35Ow/y3oQXwxqZ1iTAO8cXpbyQ+ssVT2pK3H6M97oVJg3FbO0Fj0UnLt3Ar4Co8f6ICZDhC5fSui5T0QYr+Tonfg2BP2hwYTR5QneM0DTeZ6M5UcB/Zz0LckBIz9Mq0owd1KigW9AktsZdfh9CG9a0L3FpS47k/oYpzkMe6T5qA27uY7aRwGkFMDfQ/WzG9vrfvzwpwUBWDIXqIpyAoivEt/YmS/GJOOBIWHwEEeRuEJl3Uf2wkZqTdKEbu5qUIw09ghvtQaapUsEankZdNpDZzsRiZ2Un021EsdA
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Types implementing one of these traits can safely convert between an
`ARef<T>` and an `Owned<T>`.

This is useful for types which generally are accessed through an `ARef`
but have methods which can only safely be called when the reference is
unique, like e.g. `block::mq::Request::end_ok()`.

Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/owned.rs     | 138 +++++++++++++++++++++++++++++++++++++++++++=
+---
 rust/kernel/sync/aref.rs |  11 +++-
 rust/kernel/types.rs     |   2 +-
 3 files changed, 141 insertions(+), 10 deletions(-)

diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
index a26747cbc13b..26ab2b00ada0 100644
--- a/rust/kernel/owned.rs
+++ b/rust/kernel/owned.rs
@@ -5,6 +5,7 @@
 //! These pointer types are useful for C-allocated objects which by API-co=
ntract
 //! are owned by Rust, but need to be freed through the C API.
=20
+use crate::sync::aref::{ARef, RefCounted};
 use core::{
     mem::ManuallyDrop,
     ops::{Deref, DerefMut},
@@ -14,14 +15,16 @@
=20
 /// Type allocated and destroyed on the C side, but owned by Rust.
 ///
-/// Implementing this trait allows types to be referenced via the [`Owned<=
Self>`] pointer type. This
-/// is useful when it is desirable to tie the lifetime of the reference to=
 an owned object, rather
-/// than pass around a bare reference. [`Ownable`] types can define custom=
 drop logic that is
-/// executed when the owned reference [`Owned<Self>`] pointing to the obje=
ct is dropped.
+/// Implementing this trait allows types to be referenced via the [`Owned<=
Self>`] pointer type.
+///  - This is useful when it is desirable to tie the lifetime of an objec=
t reference to an owned
+///    object, rather than pass around a bare reference.
+///  - [`Ownable`] types can define custom drop logic that is executed whe=
n the owned reference
+///    of type [`Owned<_>`] pointing to the object is dropped.
 ///
 /// Note: The underlying object is not required to provide internal refere=
nce counting, because it
 /// represents a unique, owned reference. If reference counting (on the Ru=
st side) is required,
-/// [`RefCounted`](crate::types::RefCounted) should be implemented.
+/// [`RefCounted`] should be implemented. [`OwnableRefCounted`] should be =
implemented if conversion
+/// between unique and shared (reference counted) ownership is needed.
 ///
 /// # Safety
 ///
@@ -143,9 +146,7 @@ impl<T: Ownable> Owned<T> {
     ///   mutable reference requirements. That is, the kernel will not mut=
ate or free the underlying
     ///   object and is okay with it being modified by Rust code.
     pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
-        Self {
-            ptr,
-        }
+        Self { ptr }
     }
=20
     /// Consumes the [`Owned`], returning a raw pointer.
@@ -193,3 +194,124 @@ fn drop(&mut self) {
         unsafe { T::release(self.ptr) };
     }
 }
+
+/// A trait for objects that can be wrapped in either one of the reference=
 types [`Owned`] and
+/// [`ARef`].
+///
+/// # Examples
+///
+/// A minimal example implementation of [`OwnableRefCounted`], [`Ownable`]=
 and its usage with
+/// [`ARef`] and [`Owned`] looks like this:
+///
+/// ```
+/// # #![expect(clippy::disallowed_names)]
+/// # use core::cell::Cell;
+/// # use core::ptr::NonNull;
+/// # use kernel::alloc::{flags, kbox::KBox, AllocError};
+/// # use kernel::sync::aref::{ARef, RefCounted};
+/// # use kernel::types::{Owned, Ownable, OwnableRefCounted};
+///
+/// // Example internally refcounted struct.
+/// //
+/// // # Invariants
+/// //
+/// // - `refcount` is always non-zero for a valid object.
+/// // - `refcount` is >1 if there are more than 1 Rust reference to it.
+/// //
+/// struct Foo {
+///     refcount: Cell<usize>,
+/// }
+///
+/// impl Foo {
+///     fn new() -> Result<Owned<Self>, AllocError> {
+///         // We are just using a `KBox` here to handle the actual alloca=
tion, as our `Foo` is
+///         // not actually a C-allocated object.
+///         let result =3D KBox::new(
+///             Foo {
+///                 refcount: Cell::new(1),
+///             },
+///             flags::GFP_KERNEL,
+///         )?;
+///         let result =3D NonNull::new(KBox::into_raw(result))
+///             .expect("Raw pointer to newly allocation KBox is null, thi=
s should never happen.");
+///         // SAFETY: We just allocated the `Self`, thus it is valid and =
there cannot be any other
+///         // Rust references. Calling `into_raw()` makes us responsible =
for ownership and
+///         // we won't use the raw pointer anymore, thus we can transfer =
ownership to the `Owned`.
+///         Ok(unsafe { Owned::from_raw(result) })
+///     }
+/// }
+///
+/// // SAFETY: We increment and decrement each time the respective functio=
n is called and only free
+/// // the `Foo` when the refcount reaches zero.
+/// unsafe impl RefCounted for Foo {
+///     fn inc_ref(&self) {
+///         self.refcount.replace(self.refcount.get() + 1);
+///     }
+///
+///     unsafe fn dec_ref(this: NonNull<Self>) {
+///         // SAFETY: By requirement on calling this function, the refcou=
nt is non-zero,
+///         // implying the underlying object is valid.
+///         let refcount =3D unsafe { &this.as_ref().refcount };
+///         let new_refcount =3D refcount.get() - 1;
+///         if new_refcount =3D=3D 0 {
+///             // The `Foo` will be dropped when `KBox` goes out of scope=
.
+///             // SAFETY: The [`KBox<Foo>`] is still alive as the old ref=
count is 1. We can pass
+///             // ownership to the [`KBox`] as by requirement on calling =
this function,
+///             // the `Self` will no longer be used by the caller.
+///             unsafe { KBox::from_raw(this.as_ptr()) };
+///         } else {
+///             refcount.replace(new_refcount);
+///         }
+///     }
+/// }
+///
+/// impl OwnableRefCounted for Foo {
+///     fn try_from_shared(this: ARef<Self>) -> Result<Owned<Self>, ARef<S=
elf>> {
+///         if this.refcount.get() =3D=3D 1 {
+///             // SAFETY: The `Foo` is still alive and has no other Rust =
references as the refcount
+///             // is 1.
+///             Ok(unsafe { Owned::from_raw(ARef::into_raw(this)) })
+///         } else {
+///             Err(this)
+///         }
+///     }
+/// }
+///
+/// // SAFETY: This implementation of `release()` is safe for any valid `S=
elf`.
+/// unsafe impl Ownable for Foo {
+///     unsafe fn release(this: NonNull<Self>) {
+///         // SAFETY: Using `dec_ref()` from [`RefCounted`] to release is=
 okay, as the refcount is
+///         // always 1 for an [`Owned<Foo>`].
+///         unsafe{ Foo::dec_ref(this) };
+///     }
+/// }
+///
+/// let foo =3D Foo::new().expect("Failed to allocate a Foo. This shouldn'=
t happen");
+/// let mut foo =3D ARef::from(foo);
+/// {
+///     let bar =3D foo.clone();
+///     assert!(Owned::try_from(bar).is_err());
+/// }
+/// assert!(Owned::try_from(foo).is_ok());
+/// ```
+pub trait OwnableRefCounted: RefCounted + Ownable + Sized {
+    /// Checks if the [`ARef`] is unique and convert it to an [`Owned`] it=
 that is that case.
+    /// Otherwise it returns again an [`ARef`] to the same underlying obje=
ct.
+    fn try_from_shared(this: ARef<Self>) -> Result<Owned<Self>, ARef<Self>=
>;
+
+    /// Converts the [`Owned`] into an [`ARef`].
+    fn into_shared(this: Owned<Self>) -> ARef<Self> {
+        // SAFETY: Safe by the requirements on implementing the trait.
+        unsafe { ARef::from_raw(Owned::into_raw(this)) }
+    }
+}
+
+impl<T: OwnableRefCounted> TryFrom<ARef<T>> for Owned<T> {
+    type Error =3D ARef<T>;
+    /// Tries to convert the [`ARef`] to an [`Owned`] by calling
+    /// [`try_from_shared()`](OwnableRefCounted::try_from_shared). In case=
 the [`ARef`] is not
+    /// unique, it returns again an [`ARef`] to the same underlying object=
.
+    fn try_from(b: ARef<T>) -> Result<Owned<T>, Self::Error> {
+        T::try_from_shared(b)
+    }
+}
diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index 937dcf6ed5de..2dbffe2ed1b8 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -30,7 +30,10 @@
 /// Note: Implementing this trait allows types to be wrapped in an [`ARef<=
Self>`]. It requires an
 /// internal reference count and provides only shared references. If uniqu=
e references are required
 /// [`Ownable`](crate::types::Ownable) should be implemented which allows =
types to be wrapped in an
-/// [`Owned<Self>`](crate::types::Owned).
+/// [`Owned<Self>`](crate::types::Owned). Implementing the trait
+/// [`OwnableRefCounted`](crate::types::OwnableRefCounted) allows to conve=
rt between unique and
+/// shared references (i.e. [`Owned<Self>`](crate::types::Owned) and
+/// [`ARef<Self>`](crate::types::Owned)).
 ///
 /// # Safety
 ///
@@ -180,6 +183,12 @@ fn from(b: &T) -> Self {
     }
 }
=20
+impl<T: crate::types::OwnableRefCounted> From<crate::types::Owned<T>> for =
ARef<T> {
+    fn from(b: crate::types::Owned<T>) -> Self {
+        T::into_shared(b)
+    }
+}
+
 impl<T: RefCounted> Drop for ARef<T> {
     fn drop(&mut self) {
         // SAFETY: The type invariants guarantee that the `ARef` owns the =
reference we're about to
diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index 8ef01393352b..a9b72709d0d3 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -11,7 +11,7 @@
 };
 use pin_init::{PinInit, Wrapper, Zeroable};
=20
-pub use crate::owned::{Ownable, Owned};
+pub use crate::owned::{Ownable, OwnableRefCounted, Owned};
=20
 pub use crate::sync::aref::{ARef, AlwaysRefCounted, RefCounted};
=20

--=20
2.51.2



