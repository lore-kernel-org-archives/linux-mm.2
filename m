Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6890CDB479
	for <linux-mm@archiver.kernel.org>; Thu, 25 Jun 2026 10:15:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AE03A6B00C3; Thu, 25 Jun 2026 06:15:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6F16B00C4; Thu, 25 Jun 2026 06:15:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9CD626B00C5; Thu, 25 Jun 2026 06:15:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 67D106B00C3
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 06:15:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E092416773B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:15:56 +0000 (UTC)
X-FDA: 84918029112.15.FA974C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1228F8000B
	for <linux-mm@kvack.org>; Thu, 25 Jun 2026 10:15:54 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FZ9E4325;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782382555;
	b=1vDwY8husDJtGcqe640dijMeHTRxhMNrO7K9j7JlHSrlIoPLMERSG2HZZNESzIl2xH5Rqi
	HWgrJIw9eSHobkoGDYkT4C5uzQQ3Y2Gj8zPwyMk3tAMT7Bgmgrs6kzMqBf2RN8amUsYBd3
	TKWMsCoRwB18q65RloI877c/hyyRGPA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782382555;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZToO+NQD3LW0EAmo0Z2TAVZkC45YHlFo8YdIzTw1Q2A=;
	b=chUPV0w8TytyCD3GK9Phn5krzk4VZyoVzw816IeRMbSyzrg+URBEGG7q4NOihL0gneHWaI
	ER/CnOOBqowaQ3U4GbxgPybcbJV+ghFth6zC85N1CBW+nPsl4YDiXn+XrZzuDywEGEX59U
	sJPjyf9YvXHy4sTU3nwieFvD8lT3OxU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FZ9E4325;
	spf=pass (imf30.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 32F4F40BBB;
	Thu, 25 Jun 2026 10:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 093711F000E9;
	Thu, 25 Jun 2026 10:15:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782382554;
	bh=ZToO+NQD3LW0EAmo0Z2TAVZkC45YHlFo8YdIzTw1Q2A=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FZ9E4325NuPDynK8zLdwbNfS+lbrGpPD6GpiFQY9yM+ZvbhO1TFzNBkRBA5AHz7us
	 gg/U00xWrsz1s/i8RCxBwnI9xmiiVdfZYF9JmoEpc5yGosCDjf/Y/BI6RKtv4NFK8+
	 aJOJUZ37Hes4cAXKVRCiazykWCkSVhDptaO91vQBvl3gpQ9KPtfURJy+eLQhlPhtlu
	 GjebExOR/ZHbbNPr3ZSySn3nPzQ2jy9/QyIiFKtYqo0o6CUiHfuFoMAzsLodoX+icv
	 RbGPKHldyC093xSpf3gnl5pADqKYapZP/BICOcqdgKbbYp0EaqZyQ1t7QC/6z6Ifhi
	 6c3/XEXORjwWA==
From: Andreas Hindborg <a.hindborg@kernel.org>
Date: Thu, 25 Jun 2026 12:15:09 +0200
Subject: [PATCH v18 7/8] rust: Add `OwnableRefCounted`
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260625-unique-ref-v18-7-4e06b5896d47@kernel.org>
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
 Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: b4 0.16-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=9473; i=a.hindborg@kernel.org;
 h=from:subject:message-id; bh=cWJqdUJZGXrcHaKbHpYDZftK3zE/sexxuAi+S26aqlw=;
 b=owEBbQKS/ZANAwAKAfpQKQiqxb3QAcsmYgBqPP/Du39o/7gxB53usiQFtTa8MFJbFxK5czvjr
 83YAteFVpiJAjMEAAEKAB0WIQRXitnI2WZ2JirAaob6UCkIqsW90AUCajz/wwAKCRD6UCkIqsW9
 0Af9D/9w10G3io//DOmUeHH9FD6KsXpwAK/zpVsZ/QT6kNTFOGFn6S+fnXjMpb2m56aKPaCYGlE
 eVcKwRT9xacubbqlID9d1mFW6lIrwuR01kff3cVlzFNlF05UScRgidldx8PoLSdGMlVktTUgT1n
 oaTYDcojM+IWpqK0aUU8nGFhwKFCScnaBaNJSpYNSRxtb4A++eweLs15r0bBglVqsuaZR6GTbqY
 Oig66z+jCWVptLSXAjJVj+jVn/fz4kHX3I9UwnMkdzFrWh8YMAt6EGO/1wN4sVr8IvW1vcg+TCg
 GNeePvc+YEwh6SfmxhuTrIhDbxPwLFZ0xs+GDXvdzryDurPfB7dHh10Vb59WJeSTMy3/Uwm6sD7
 JjPYO3a2RYqzccURIrqcFZR/hZqGLFT1p9er66xsxT3ODZJakt0wP+hLIiSZQ4o1B69RbJ8yRG9
 8RVMuGZ0/tGttIzpYXfPlojokwgWvCcwAJpdtYMlM3pWg6jzMS+2m0eJ7DjlGwGoFnnmKWHb3Xh
 IFWxGg+FN9pqhAlQ3NiR40jYCKL2QUKjtqREWqVlMuqsIBvvwTsCDOjBMkxBydMAGmmcs6m4YtT
 BUqvXMqrl0TQS0IzFpbuREHR/s0O2Gp+97s2oCAxGeS5YQKQ+o09DRnOOcmj8peXME0ZNv5hc5V
 cpyJprpdU6ZxEaw==
X-Developer-Key: i=a.hindborg@kernel.org; a=openpgp;
 fpr=3108C10F46872E248D1FB221376EB100563EF7A7
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 1228F8000B
X-Stat-Signature: m9w938f7akbiduyjocnq77a6jboju588
X-HE-Tag: 1782382554-179806
X-HE-Meta: U2FsdGVkX19oDEgUNJHJgiR2Q83PCH3d1pFmRc1hHPnhIDAuD3oT5wq638J+7+Ax0laBQ5FHrNuEmywPJSaYagkl9AByouoTnOs1e/4uqAOzDRPNadUb2QujKpDmKyG/S9NbFxxlcz+rnMT3i0ZhggRRPQ2osbRBndpRVY5FfY1i//z+Yxi0JxDn+pL5o+QnETXdDMx9TZtijYDKrYowMhB00GAUTBPLiiiQ7EeJvhh7R3hV1BhRhvHwmNcnEs8EPJxZVMSQ2B5w0OO/bW5Uiu7+REDjCLqeBPlGE3PtO4sdlHX3M+msHQMud8ZgGKw8Fz57D2E/xx8TGc8E+Gm1H8XohyixH5Fl+OdSbqf6KX7Ztw9D9eLEDbqmGt9n3qCksfZzI+a86cYqNnXgBDrgmk/r33IyTDdiPjjaF+y/PPKhMfWK6eSZOLSNjzFXma1tMBrkqXy9wQYjRQ4+0BiSY2v9zd+3u3Dd/kHSH6cr1kSzzTiQyIJvgIN4ZvM6j04S6MrRJlApsEzL+xWUnpbSKvoTyHDdAQTMcsUzQgS7NRUWSlcrgRD6xPpksYUYVJ8uaOsmv68Sspk7xp7iEuy84/dw1EARuolG/ibb3HNSQ2G+fBBSjuL+mwCl8YQOOLM8enMVr80VtWNEoGaGVx0xuglqWVGY5c7B3WcXkrg01aZ1fbOfCofNAJI/NqBlGF+XQcWMf1nWfbePw0Z7AEzPoTOz4nfu0HtpaIhqrfSYindNsWyEv+i3iSHRF7NseU3XdKK7ns1xfqbB3jjEIgR31VNa5RNvJFarpG6FFg0nGE/2H9PX/nlKrAn4vYZpM/IKet52vdFtg7xaSFBXJZ6wQWHJq7xTRTyLch+0nGKBwAyTQKA1G5Z6jRr+yemxawF1PBnhejYd69AMQjXorqbDaz4MnENWsuiF5XpVtH9guTf/p9N9smgFZm/pWOvTCtdRibH1zV7WuaWBTG/cr5h
 S1vyiARm
 B11UXnlZSrSHQ+7sYMjdpava2ME2skaOQHwypLYuxQhoBZs0fe2DSgDUloMXXfii6UkHj/UpHpg37SrWQVmlW8EaiJ4zlGuXDd5iTl4eZDAoSXnziRE22OcLXx0aKTo/iJtl1Sq9CmsNb6av31CFkQUN6A5Zu2Z4gnRqEvNKbNBf7d3Vren1EICU39Fx8lNW+Y4bEj0VCGont/xLbuEH6+2/Jpw1Yc1R16gzqWPCtidj74q3nxwXH/0xbRA==
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
 rust/kernel/owned.rs     | 140 +++++++++++++++++++++++++++++++++++++++++++++--
 rust/kernel/sync/aref.rs |  16 +++++-
 rust/kernel/types.rs     |   1 +
 3 files changed, 151 insertions(+), 6 deletions(-)

diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
index e79936c00002c..bb4223c0f725a 100644
--- a/rust/kernel/owned.rs
+++ b/rust/kernel/owned.rs
@@ -14,20 +14,26 @@
     pin::Pin,
     ptr::NonNull, //
 };
+use kernel::{
+    sync::aref::ARef,
+    types::RefCounted, //
+};
 
 use kernel::types::ForeignOwnable;
 
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
@@ -239,3 +245,127 @@ unsafe fn borrow_mut<'a>(ptr: *mut kernel::ffi::c_void) -> Self::BorrowedMut<'a>
         unsafe { Pin::new_unchecked(inner) }
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
+///         // INVARIANT: We initialize `refcount` to 1, satisfying the invariants.
+///         let result = KBox::new(
+///             Foo {
+///                 refcount: Cell::new(1),
+///             },
+///             flags::GFP_KERNEL,
+///         )?;
+///         let result = KBox::into_non_null(result);
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
+///     unsafe fn release(this: NonNull<Self>) {
+///         // SAFETY: Using `dec_ref()` from [`RefCounted`] to release is okay, as the refcount is
+///         // always 1 for an [`Owned<Foo>`].
+///         unsafe { Foo::dec_ref(this) };
+///     }
+/// }
+///
+/// let foo = Foo::new()?;
+/// let foo = ARef::from(foo);
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
+    #[inline]
+    fn into_shared(this: Owned<Self>) -> ARef<Self> {
+        // SAFETY: `Owned::into_raw` returns a pointer to a valid `Self`, and the `Owned` owned the
+        // reference count that we now transfer to the new `ARef`.
+        unsafe { ARef::from_raw(Owned::into_raw(this)) }
+    }
+}
+
+impl<T: OwnableRefCounted> TryFrom<ARef<T>> for Owned<T> {
+    type Error = ARef<T>;
+    /// Tries to convert the [`ARef`] to an [`Owned`] by calling
+    /// [`try_from_shared()`](OwnableRefCounted::try_from_shared). In case the [`ARef`] is not
+    /// unique, it returns again an [`ARef`] to the same underlying object.
+    #[inline]
+    fn try_from(b: ARef<T>) -> Result<Owned<T>, Self::Error> {
+        T::try_from_shared(b)
+    }
+}
diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
index d0865aeb9371b..77eb390139079 100644
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
@@ -188,6 +195,13 @@ fn from(b: &T) -> Self {
     }
 }
 
+impl<T: OwnableRefCounted> From<Owned<T>> for ARef<T> {
+    #[inline]
+    fn from(b: Owned<T>) -> Self {
+        T::into_shared(b)
+    }
+}
+
 impl<T: RefCounted> Drop for ARef<T> {
     fn drop(&mut self) {
         // SAFETY: The type invariants guarantee that the `ARef` owns the reference we're about to
diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
index 5ef763717e59a..6aa760952cb63 100644
--- a/rust/kernel/types.rs
+++ b/rust/kernel/types.rs
@@ -18,6 +18,7 @@
 pub use crate::{
     owned::{
         Ownable,
+        OwnableRefCounted,
         Owned, //
     },
     sync::aref::{

-- 
2.51.2



