Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE9CCE9B24E
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 11:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A73B6B009B; Tue, 24 Feb 2026 06:20:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 17B5F6B009D; Tue, 24 Feb 2026 06:20:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 07D736B009E; Tue, 24 Feb 2026 06:20:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E7CA46B009B
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 06:20:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9F32BB9B89
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:20:17 +0000 (UTC)
X-FDA: 84479106474.20.41DA72C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D84FAA0011
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 11:20:15 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aNssuOP5;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771932015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nuhpsvxsaD8vFaiEqukePZTsnibS5yV05XtPVF7xcLo=;
	b=5NKd9pSSTJoVgxr6Skj8Tsf5agygz3YIXVlkYjpZMIDWy3lLIkiG7ZirMb83NAwz9G3G90
	Iz+PXV9PyH5YFclMifEGWvASLuhKq89FYopZkWNMyGhXAOlzqRmnFJQBBZFG1908AXHB6d
	j8xCobj02y8y4VkICOG1huiT8JmcqAI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771932015; a=rsa-sha256;
	cv=none;
	b=YTN8sPkpfAuqQCbv9VNRpqk/lnQkic1VbjsdFyEPrt7nBauuDRXtZ9dWZ90QT/cKo3xEpy
	8UdfJpoC91tc8+a4ziOKD1v6rAmOOTpeAI6R81Q0q0yZgM/jXpaJwJbUorqJO0kKmTtuQv
	38g5L+eGl7DnF5zAlaBogmgwgMSr2fQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=aNssuOP5;
	spf=pass (imf25.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 3EEDF61337;
	Tue, 24 Feb 2026 11:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFC6BC2BC86;
	Tue, 24 Feb 2026 11:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771932014;
	bh=JggglvJ6In5NjyG9cb3gNeXDKlzHHyenXMWlyo8o2lM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=aNssuOP5zEA5Q8YbZrc/LPKDE7zYlXSfAKQcFEZP7jlGhNdWD7K3vgb/8JuMCbSKj
	 sRYof202vY1EkJossiiTLzwKqb43Ir49CXTBhnIZ+mZ689yrDOVUKBOx01m8h5kyf8
	 8WY9g5pPBFR3Bbez8+MmnmldKx19r0m/0cgdfLUC2GGK6blea4l0jLzAdB+DCij9tW
	 1ekeqzQJMk96FLSkZxmda7vkwUUnJQYnlWnHHKJz97cGoQOM2RE/2796eBRCV4iidl
	 38jhPPfbXMHGeoeHEQHTtwkowEFHB7JZjBuBdcOIQlYZPe03kY/vA7ehejlT6FgXUg
	 G3dzR9wmcQU3Q==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Tue, 24 Feb 2026 12:18:01 +0100
Subject: [PATCH v16 06/10] rust: Add `OwnableRefCounted`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260224-unique-ref-v16-6-c21afcb118d3@kernel.org>
References: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
In-Reply-To: <20260224-unique-ref-v16-0-c21afcb118d3@kernel.org>
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
 Boqun Feng <boqun@kernel.org>, Vlastimil Babka <vbabka@suse.cz>, 
 Uladzislau Rezki <urezki@gmail.com>, Boqun Feng <boqun@kernel.org>
Cc: linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org, 
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org, 
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org, 
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, 
 Andreas Hindborg <a.hindborg@kernel.org>, 
 Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=9162; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=8N0h104IBF2e2+JRzyJ7DGf+5EXk4kuLv1rDkhMGOrs=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpnYj47tkh8OfRv4bSoX+RikRPhSLDzaVQfjSA+
 F4pqjb/IVOJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaZ2I+AAKCRDhuBo+eShj
 d3kvD/0Sjzth4qhacazePkc+c8VIM5Rt53V2JWQd/Wo276l6EKFwBgft7QUpggXWNtbOhURo/DP
 5/rmwLtzIKvmgA20HV4N2QwspETuB5+UL1OsOdkQ+JS4j3nXYxTf5tsP8nui1QuLpL6++0AfoU1
 6/tK76nPLNiJDVK7yDU/P1i5QB1miza3cNHl16gSzw4MJO+8eLbZvrQc7a/LjAqBwxHIUiUuWi1
 nCEKB7YrLShGr96rtoiFiseNIc60OJP+uI8v4iOQRx1UUdgAKfzTzumTLiYOdLRJDfgQAhrM+CC
 IpnQymSG23zXJM3zW4xlyFHPMINLvl6PJOvUsTRrPU6+z3XkkIubOiGvQrUa2RZdLxXewRZT7dn
 oASs3tbrM6NkgLK3i6bAgtWcmuHpTszuxQSuOyfrHZVPbbJyzSsKHI/3A9OVKi2V7Gr48ToL81v
 NzwRASwTv+ZZPOEYP4q1AxKsmuXuPP0yjI2jJo01wUYKiZehd3sL5mmrTBvGpwD5wp+OzLyBIcM
 fTjs6GafKZOSsjj6fV+oFwrMOyWYTM1dFZszE7xqjF3rUlFodg9fbMvTeRkfVhppD6H4LNHTASd
 QsE36vPMKcCEDT3GThzCjj9Acn5vPqL/9MSUTiJJ41HdkzaIha1WIR3NcDPC8g9PzptX2HMoh1P
 14KYbR50+Hg0uBg==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Stat-Signature: 9j4p4tt8wd58uxzue3eazc9m6w4aqa4z
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: D84FAA0011
X-HE-Tag: 1771932015-704147
X-HE-Meta: U2FsdGVkX1/qYwIdLzztSCPs67cFqcm0jiJcV1K5veg/yQsNFCK6TTWRy2L7EWsgJEi71nyP6y1sAOObGMT3+jb0F4gR/dM3F9uYyzc9ZQ2/5TZb4aRPslyFCxc4rLzLwC7H+3yIk/E1jXozwYf1NZiWMAYYcN5mgsi7dy7JDS+ZVOdKh1vyF/nPhQFteQMkdwAoA9tGULMoDKcEpkmH8S5exBc0S4BXGCFzsnS9tkhF7lW/kiIrfUc7qZl3obKXpJ6GtRGG7MqK7j5b1iw2BPl9r0aEH6VmjBNLLRUneMPqMeH7lthmTXQZ0e/N8O/7ywVG96YN31v+EdPBE82FdFjTlYFUDJmfR48nlg8DDJDIjcxDMXxALZ+g1mYr1SWEOxKt2uAnHIO81RsosBPitWsSGY6S9+PvhTL+NPIhwmr72S44a6RWYPqNxdMWOq8BcFXqX2HwN/A3HfjAvQte2y7/gWd9OyRUwee2A6EMccR7FF8KWG4PklWzsn9dO93xZghNkNlVvjbjNqPenuMgm+srtKklu0dSlHztq0brkQQrhJEPM644o67wjs9uXvTw82s5OkISKKeUnugLdxpqPla4c3jiaK9L1bWswvzm3m1GsCqQSYfhEzfP8PHbhlWiJwDp4IdjL6aaa8n1MaSHjwW+cDOVkJhhi/4UmN2AD8Zoj+84p6Eo1iS5/iq/wW0z4W4A0iwVtk1Kih7DfZXbD2EbKHGSBrSWMtTf8CSX/CH5WSrY7aA+h6F71i9FVHoMiDL9CEi/ebFk6SDHPxuFltXvNhWcC9/uTkY1WgpZGw76ldQwH8EBNc52M1yj6CafBbn4qr1C/VIg5qCSatEh5ioKrloWvRvQoL14SUO6rcQ3K9ykscS93qSvR3QX3SpqbyckCrZpNdsCK7MNXz+tx69dkYZVwFVFtX+z3nSC74P/MB1a1mXiFb6Gd7+5DiZcHy5MkUEthjDjfqUqw+Z
 y1A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Oliver Mangold <oliver.mangold@pm.me>

Types implementing one of these traits can safely convert between an
`ARef<T>` and an `Owned<T>`.

This is useful for types which generally are accessed through an `ARef`
but have methods which can only safely be called when the reference is
unique, like e.g. `block::mq::Request::end_ok()`.

Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
[ Andreas: Fix formatting, update documentation, fix error handling in
  examples. ]
Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/owned.rs     | 136 +++++++++++++++++++++++++++++++++++++++++++++--
 rust/kernel/sync/aref.rs |  15 +++++-
 rust/kernel/types.rs     |   1 +
 3 files changed, 146 insertions(+), 6 deletions(-)

diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
index 41451aa320cff..c81c2ea88124b 100644
--- a/rust/kernel/owned.rs
+++ b/rust/kernel/owned.rs
@@ -14,18 +14,24 @@
     pin::Pin,
     ptr::NonNull, //
 };
+use kernel::{
+    sync::aref::ARef,
+    types::RefCounted, //
+};
 
 /// Types that specify their own way of performing allocation and destruction. Typically, this trait
 /// is implemented on types from the C side.
 ///
-/// Implementing this trait allows types to be referenced via the [`Owned<Self>`] pointer type. This
-/// is useful when it is desirable to tie the lifetime of the reference to an owned object, rather
-/// than pass around a bare reference. [`Ownable`] types can define custom drop logic that is
-/// executed when the owned reference [`Owned<Self>`] pointing to the object is dropped.
+/// Implementing this trait allows types to be referenced via the [`Owned<Self>`] pointer type.
+///  - This is useful when it is desirable to tie the lifetime of an object reference to an owned
+///    object, rather than pass around a bare reference.
+///  - [`Ownable`] types can define custom drop logic that is executed when the owned reference
+///    of type [`Owned<_>`] pointing to the object is dropped.
 ///
 /// Note: The underlying object is not required to provide internal reference counting, because it
 /// represents a unique, owned reference. If reference counting (on the Rust side) is required,
-/// [`RefCounted`](crate::types::RefCounted) should be implemented.
+/// [`RefCounted`] should be implemented. [`OwnableRefCounted`] should be implemented if conversion
+/// between unique and shared (reference counted) ownership is needed.
 ///
 /// # Examples
 ///
@@ -179,3 +185,123 @@ fn drop(&mut self) {
         unsafe { T::release(self.ptr.as_mut()) };
     }
 }
+
+/// A trait for objects that can be wrapped in either one of the reference types [`Owned`] and
+/// [`ARef`].
+///
+/// # Examples
+///
+/// A minimal example implementation of [`OwnableRefCounted`], [`Ownable`] and its usage with
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
+/// // An internally refcounted struct for demonstration purposes.
+/// //
+/// // # Invariants
+/// //
+/// // - `refcount` is always non-zero for a valid object.
+/// // - `refcount` is >1 if there is more than one Rust reference to it.
+/// //
+/// struct Foo {
+///     refcount: Cell<usize>,
+/// }
+///
+/// impl Foo {
+///     fn new() -> Result<Owned<Self>> {
+///         // We are just using a `KBox` here to handle the actual allocation, as our `Foo` is
+///         // not actually a C-allocated object.
+///         let result = KBox::new(
+///             Foo {
+///                 refcount: Cell::new(1),
+///             },
+///             flags::GFP_KERNEL,
+///         )?;
+///         let result = KBox::into_nonnull(result);
+///         // SAFETY:
+///         //  - We just allocated the `Self`, thus it is valid and we own it.
+///         //  - We can transfer this ownership to the `from_raw` method.
+///         Ok(unsafe { Owned::from_raw(result) })
+///     }
+/// }
+///
+/// // SAFETY: We increment and decrement each time the respective function is called and only free
+/// // the `Foo` when the refcount reaches zero.
+/// unsafe impl RefCounted for Foo {
+///     fn inc_ref(&self) {
+///         self.refcount.replace(self.refcount.get() + 1);
+///     }
+///
+///     unsafe fn dec_ref(this: NonNull<Self>) {
+///         // SAFETY: By requirement on calling this function, the refcount is non-zero,
+///         // implying the underlying object is valid.
+///         let refcount = unsafe { &this.as_ref().refcount };
+///         let new_refcount = refcount.get() - 1;
+///         if new_refcount == 0 {
+///             // The `Foo` will be dropped when `KBox` goes out of scope.
+///             // SAFETY: The [`KBox<Foo>`] is still alive as the old refcount is 1. We can pass
+///             // ownership to the [`KBox`] as by requirement on calling this function,
+///             // the `Self` will no longer be used by the caller.
+///             unsafe { KBox::from_raw(this.as_ptr()) };
+///         } else {
+///             refcount.replace(new_refcount);
+///         }
+///     }
+/// }
+///
+/// impl OwnableRefCounted for Foo {
+///     fn try_from_shared(this: ARef<Self>) -> Result<Owned<Self>, ARef<Self>> {
+///         if this.refcount.get() == 1 {
+///             // SAFETY: The `Foo` is still alive and has no other Rust references as the refcount
+///             // is 1.
+///             Ok(unsafe { Owned::from_raw(ARef::into_raw(this)) })
+///         } else {
+///             Err(this)
+///         }
+///     }
+/// }
+///
+/// impl Ownable for Foo {
+///     unsafe fn release(&mut self) {
+///         // SAFETY: Using `dec_ref()` from [`RefCounted`] to release is okay, as the refcount is
+///         // always 1 for an [`Owned<Foo>`].
+///         unsafe{ Foo::dec_ref(NonNull::new_unchecked(self)) };
+///     }
+/// }
+///
+/// let foo = Foo::new()?;
+/// let mut foo = ARef::from(foo);
+/// {
+///     let bar = foo.clone();
+///     assert!(Owned::try_from(bar).is_err());
+/// }
+/// assert!(Owned::try_from(foo).is_ok());
+/// # Ok::<(), Error>(())
+/// ```
+pub trait OwnableRefCounted: RefCounted + Ownable + Sized {
+    /// Checks if the [`ARef`] is unique and converts it to an [`Owned`] if that is the case.
+    /// Otherwise it returns again an [`ARef`] to the same underlying object.
+    fn try_from_shared(this: ARef<Self>) -> Result<Owned<Self>, ARef<Self>>;
+
+    /// Converts the [`Owned`] into an [`ARef`].
+    fn into_shared(this: Owned<Self>) -> ARef<Self> {
+        // SAFETY: Safe by the requirements on implementing the trait.
+        unsafe { ARef::from_raw(Owned::into_raw(this)) }
+    }
+}
+
+impl<T: OwnableRefCounted> TryFrom<ARef<T>> for Owned<T> {
+    type Error = ARef<T>;
+    /// Tries to convert the [`ARef`] to an [`Owned`] by calling
+    /// [`try_from_shared()`](OwnableRefCounted::try_from_shared). In case the [`ARef`] is not
+    /// unique, it returns again an [`ARef`] to the same underlying object.
+    fn try_from(b: ARef<T>) -> Result<Owned<T>, Self::Error> {
+        T::try_from_shared(b)
+    }
+}
diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index 8c23662a7e6a1..a849ebae4313b 100644
--- a/rust/kernel/sync/aref.rs
+++ b/rust/kernel/sync/aref.rs
@@ -23,6 +23,10 @@
     ops::Deref,
     ptr::NonNull, //
 };
+use kernel::types::{
+    OwnableRefCounted,
+    Owned, //
+};
 
 /// Types that are internally reference counted.
 ///
@@ -35,7 +39,10 @@
 /// Note: Implementing this trait allows types to be wrapped in an [`ARef<Self>`]. It requires an
 /// internal reference count and provides only shared references. If unique references are required
 /// [`Ownable`](crate::types::Ownable) should be implemented which allows types to be wrapped in an
-/// [`Owned<Self>`](crate::types::Owned).
+/// [`Owned<Self>`](crate::types::Owned). Implementing the trait
+/// [`OwnableRefCounted`] allows to convert between unique and
+/// shared references (i.e. [`Owned<Self>`](crate::types::Owned) and
+/// [`ARef<Self>`](crate::types::Owned)).
 ///
 /// # Safety
 ///
@@ -185,6 +192,12 @@ fn from(b: &T) -> Self {
     }
 }
 
+impl<T: OwnableRefCounted> From<Owned<T>> for ARef<T> {
+    fn from(b: Owned<T>) -> Self {
+        T::into_shared(b)
+    }
+}
+
 impl<T: RefCounted> Drop for ARef<T> {
     fn drop(&mut self) {
         // SAFETY: The type invariants guarantee that the `ARef` owns the reference we're about to
diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index 9b96aa2ebdb7e..f43c091eeb8b7 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -14,6 +14,7 @@
 pub use crate::{
     owned::{
         Ownable,
+        OwnableRefCounted,
         Owned, //
     },
     sync::aref::{

-- 
2.51.2



