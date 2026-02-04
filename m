Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ECB24E9538E
	for <linux-mm@archiver.kernel.org>; Wed,  4 Feb 2026 11:58:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5BE226B008A; Wed,  4 Feb 2026 06:58:26 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 586E46B00A3; Wed,  4 Feb 2026 06:58:26 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 494116B00A4; Wed,  4 Feb 2026 06:58:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 362616B008A
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 06:58:26 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id ECAA7C0110
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:58:25 +0000 (UTC)
X-FDA: 84406626570.24.BD0D175
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 13BA8140002
	for <linux-mm@kvack.org>; Wed,  4 Feb 2026 11:58:23 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mvzCyS15;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770206304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=df/Qj1B8jmb8ToAFJ/N4J0RAOAIqDgeRl442bcTxbdI=;
	b=DiWHKRwvzXtKjGWOhc8uEMWVcuQeJqfd/zct7OLp1VJ8s6f2nNdKXo5zlDNgQCxC2jVDgH
	x2kurT0AE1sp+W49wezFJuptNxcpBD0kI7wlx29Rpjguv4RfPl2j6ciGMcXS527pLWyFsv
	K5oNUGucaaUN5PJXMexABpXGTfFO1Ik=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770206304; a=rsa-sha256;
	cv=none;
	b=13q8N1skKY0wO23oKIU+tohRfSGAQTFrcMgXiRGK9JE1si/lU2du3ZIsWDuxAHjmmSVuJc
	FBj/pYp4+mZ8pQ/ng+haPKpQInIROd1XUxuegh5wRExrft5Co+rXAczrpNfiBuiO0lbs37
	va4IKFRQ0nM698auQFAEaJc1BmoQT6k=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mvzCyS15;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf09.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 22D3C4019C;
	Wed,  4 Feb 2026 11:58:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5DE4C2BCB0;
	Wed,  4 Feb 2026 11:58:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770206303;
	bh=fKS4YZSY0RE7JCEPKb4rqKXNkf+DXt21yknMy+vl0pg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=mvzCyS154RedCQN8/SGVZuYh9sVciWysAk2zrk31m3lB5R1gx/l+TD89eaZ+qBpbP
	 W11M1GKfi+ZR7gqB/Q3UOvm32dYxuIYF4iVfesimhWcEiUBKKpiKp4mIQvB+/LAwQR
	 /WkvvuiyGzH46HxQuA6ezMkfy6Lg55W4z2DSJP5pXLxroc31MDwsOVtlgLeOqiWwPy
	 LWXiYjsrIwuz7thDqaxk/4B16HfBuuoEQmDmpgrnpfaq4+osl0oUoNxNOmZre/lBCG
	 LbC3X27pDo1IYwfGSQfEZRIJ1zZlcyaO7cneXT6yrzOjUHhvsC3LjnXaZKt+0BIAsL
	 cg8t17ol0kouQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Wed, 04 Feb 2026 12:56:49 +0100
Subject: [PATCH v14 5/9] rust: Add `OwnableRefCounted`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260204-unique-ref-v14-5-17cb29ebacbb@kernel.org>
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
 Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=10273;
 i=a.hindborg@kernel.org; h=from:subject:message-id;
 bh=irZb8gNlDmHjHq+Vlh9NKYryETY3byAgy7rNfOhZPQ0=;
 b=owEBbQKS/ZANAwAKAeG4Gj55KGN3AcsmYgBpgzQDPshmf+aW8TSSuWq00tyL7xksj+RGayo8b
 0fcMj7XLoiJAjMEAAEKAB0WIQQSwflHVr98KhXWwBLhuBo+eShjdwUCaYM0AwAKCRDhuBo+eShj
 d86BD/9yJkdaK/bZVg5UkSb8EluC0lG0rBYczDQJV1qyNRbRKhjF1vUlvZytpJw2freFqwv0Syk
 tZEjx9KAzSx8umKzdyi7f9yNIpkB/oMO3wzhXIPMo2ymSKpDoomQn5UZgHvR5XpRk1rmeAXoBJM
 ehn+81L9iBy7jn48UauVoxT5eRHdjg6SxG/wLuH2ztZXzKbtskGHIEsUDc9nFhvcNoLEGUK3Ryx
 4U9oKKm6IVv93Ym9fJIVQ2YzJKE9UZVM2WaQcGzM4HYTORvGAB/00bakIxayq5/3rrjB4Y/0uI9
 KScgr/Bf7oB3qrZRYcMqjh/StdjMGkXxhzF0FU21uppcJkSm6EiGqxgVPsQowrc4tlNFwM08SM5
 g44N/v4BA3pOjI3da6V9UaprNBdpoOoscQyFd7S3TxXL5+CMdN6Dvumk4l8DC5j0fzhkf6AXbus
 ETMdyCZuPToQCU8gmzs9xPI/ZVzgbMxdbQf2CGddYZnX843h+8b3inkbXCJJu8z8csHZxbnWOYt
 pjxkyj/PkJOOI9uSMBcF/vNZPIhvv0HvtV1tRL5d/0DJmGRRX0ZKgtI4ftoc7J6VELDwR2aK9c/
 93PWR6CmIgvsvzVgaKLJVoepqoPqRCTFG/C0xo3PrYmcvkQf6Z+HAZFQyDEyqzuk+o8H4TX4102
 dAs3e8KQjj9m7kA==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspamd-Queue-Id: 13BA8140002
X-Stat-Signature: 4i3djg31kxdpqybsu5zagchum3qs5ym3
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1770206303-927958
X-HE-Meta: U2FsdGVkX19UcarI/ZEIQEBg/jkeirF4fsdzypVJvNh81wLrxAkvmPAsyMosZDVhRA5FODcdePVKrfBP9hjNMNszp+nenvY4HOJIL3TN9SuHb4Q5v4+04Osv8qX5tiHxphpt/xZtkVrCfQLxLsqmlGBWx3qrm7M5LWwZz09FJpP+VMJHimbdJM8AeJeyVndBIKAvOp38ybM/HmGD19TjM7Rx6JKkMNM/86JxOyxuhMR1eehDe+Enqdsz4yX/tsmdotBgfmlrBrYNcQYcNOfiGCPZS0h+K89zDj5siAYihMH00VjRfQAUyaNN6vga39sKb1SYgmIsGWQDpPT4id3vgSZ4oS2cmvblv9oukLcDKGGAgwHIJJNWUMsi5/XCV03xcc76ylJmzRhu6mYyg4otZ/MScvyaE+KkVvMCOnGbgOIszzYre+3QgeSE/ps9Ge0PEDq1QeUCgpkQRHmMUNnWcWXBNn1KbAJZ6N0VYWnV7icKU/TkqnFiV5pApWy8xSQc8KmpaH54KXCRmyocogTq1tCJlq5/HqZ1ZK8RGd1ggbW4+ubxVf7iU1XHQumUFYxESxXUdfJ61tpWYZG0GStFSrucRgIewrX3oAqy5KHZ8BK/Vn6NAY5/aWk4KNGJMBnQXVGRyKYFWRhwmubiZFBVKHMfXcLslGnHr5Zhrbj7HmNpoKx/Kd1SGnUSUk6r4GULBopSgjfrDOVhpkqEg4N1WoCndjX8xCXh5/R5wDb3gtcxKmw33pYP6SYKUCHSqwRmSPFZm9aDeXlbPoaZ4SdBoGrbCnFoMqPZ1ivI/Cf5/+mQe4+c1xYzOodaDoDfBQaoEuLpSu35CQsSew3OX6hlP6301y+CP6ZNcAwfvSUNka6SO4bssut778mP79W5gScwLjSGdcv95wUJr4Q96a93xKseSTbkE2K1Kz6NC6C6ckyoEYTPOfKz7Jy5L9SWTmk3dZCTuDvw4tt6vtiK2HT
 U2ekEgtg
 kz2Clhw9qTW9nxcq6IosB3A6oaE2dzjt2mQRllYdZQFL+SfkMAfWp3pNIbZV707af/C1gPI3GJewmgyyHo1JupGrOf3N878lW4lqQvSsorwyf2hVnd5KXdAD8yZKzOx5mtkBfNVmF1+VjolyKpiE6Sw3Kxh/G3ZKbWBnO+EQW8h9ZHuKDzCqX1OmGGYD9AKQ8rQZUioTdmwzYXgrfRPMMrlmVx5Lknya6RdNfoP5GShll2u3TQtL/uRam11cPFcN9PppIWfa0bzDWoA06LU1qvbD/KVbtTijy89lxjqS2uUGYplpy5S7L/fq0uAuQbcFyJmBd
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

Original patch by Oliver Mangold <oliver.mangold@pm.me> [1].

Link: https://lore.kernel.org/r/20251117-unique-ref-v13-4-b5b243df1250@pm.me [1]
Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
---
 rust/kernel/owned.rs     | 143 ++++++++++++++++++++++++++++++++++++++++++++---
 rust/kernel/sync/aref.rs |  15 ++++-
 rust/kernel/types.rs     |   1 +
 3 files changed, 150 insertions(+), 9 deletions(-)

diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
index b02edda11fcf6..85251c57f86c6 100644
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
 /// # Safety
 ///
@@ -63,8 +69,7 @@
 ///             Foo {},
 ///             flags::GFP_KERNEL,
 ///         )?;
-///         let result = NonNull::new(KBox::into_raw(result))
-///             .expect("Raw pointer to newly allocation KBox is null, this should never happen.");
+///         let result = NonNull::new(KBox::into_raw(result)).ok_or(ENOMEM)?;
 ///         // Count new allocation
 ///         *FOO_ALLOC_COUNT.lock() += 1;
 ///         // SAFETY: We just allocated the `Self`, thus it is valid and there cannot be any other
@@ -88,11 +93,12 @@
 /// }
 ///
 /// {
-///    let foo = Foo::new().expect("Failed to allocate a Foo. This shouldn't happen");
+///    let foo = Foo::new()?;
 ///    assert!(*FOO_ALLOC_COUNT.lock() == 1);
 /// }
 /// // `foo` is out of scope now, so we expect no live allocations.
 /// assert!(*FOO_ALLOC_COUNT.lock() == 0);
+/// # Ok::<(), Error>(())
 /// ```
 pub unsafe trait Ownable {
     /// Releases the object.
@@ -194,3 +200,124 @@ fn drop(&mut self) {
         unsafe { T::release(self.ptr) };
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
+///         let result = NonNull::new(KBox::into_raw(result)).ok_or(ENOMEM)?;
+///         // SAFETY: We just allocated the `Self`, thus it is valid and there cannot be any other
+///         // Rust references. Calling `into_raw()` makes us responsible for ownership and
+///         // we won't use the raw pointer anymore, thus we can transfer ownership to the `Owned`.
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
+/// // SAFETY: This implementation of `release()` is safe for any valid `Self`.
+/// unsafe impl Ownable for Foo {
+///     unsafe fn release(this: NonNull<Self>) {
+///         // SAFETY: Using `dec_ref()` from [`RefCounted`] to release is okay, as the refcount is
+///         // always 1 for an [`Owned<Foo>`].
+///         unsafe{ Foo::dec_ref(this) };
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
index 3c63c9a5fb9be..77f6c8dc411eb 100644
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



