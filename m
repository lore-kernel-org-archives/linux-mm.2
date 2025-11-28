Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F040D116EA
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 18:07:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B27EF6B008C; Fri, 28 Nov 2025 13:07:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B04E26B0092; Fri, 28 Nov 2025 13:07:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A15506B0093; Fri, 28 Nov 2025 13:07:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 910BB6B008C
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 13:07:30 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 37EB55AC41
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:07:30 +0000 (UTC)
X-FDA: 84160798260.06.D53A666
Received: from sender4-pp-f112.zoho.com (sender4-pp-f112.zoho.com [136.143.188.112])
	by imf25.hostedemail.com (Postfix) with ESMTP id 360BBA0015
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 18:07:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=cQMWT3gX;
	spf=pass (imf25.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764353248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7hCtVdIpYmvpIaG2Tepwl9t2OZhg+JztbnabjHdsDXw=;
	b=r28ZbaTmXSTuLZ2/i59EUnLqKMzQaW001cd+4c7iE151jZy5jslWjilBYL82odZgsiEF+X
	o2atH41rBvBl1yjL6YrQ+l8i3+efAGrqo1pN9zgz6fwhgJ8hqEw79W/nSDrGboEBn4gGP/
	hr4r03vQckK6uuCi8z+07GDo6umhUlU=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=collabora.com header.s=zohomail header.b=cQMWT3gX;
	spf=pass (imf25.hostedemail.com: domain of daniel.almeida@collabora.com designates 136.143.188.112 as permitted sender) smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass (policy=none) header.from=collabora.com;
	arc=pass ("zohomail.com:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1764353248; a=rsa-sha256;
	cv=pass;
	b=375aEqIRBYHZprxHogi+1IrLqB1w7WBiP3b1FBN3mVKR2CRrD4Ssi8THG+I9b0HB/4WgdU
	OtG9CrxwmEfeiGtkDMxAkq6/ws0H0SUlGRG4BAX1b+DQZPl9LO/r9Kq+2qqs7KrYoN42UI
	1OwxX73ZZ0oSX1VMYVc8idlbKOQYKJ0=
ARC-Seal: i=1; a=rsa-sha256; t=1764353224; cv=none; 
	d=zohomail.com; s=zohoarc; 
	b=RtG3ndtV6UjdVmNEugxfkY/hNqTZyTalZN9NIiBwE13LjiiQGrfVvqMIlCMsp2cR2P2V3BZjxj7axPKgJYr0fDdbSPxN1GTBWASZjGJdnONZS/yezjkw7I+//rihzgbrikAiSqC0HZUafMyQak5Jd2CE5YoCDUpLUmhT/Bwk/ls=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
	t=1764353224; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=7hCtVdIpYmvpIaG2Tepwl9t2OZhg+JztbnabjHdsDXw=; 
	b=j1uXW3P5csnn5xBO8uGG/CYg16oq3me8gSQnLQlVJw5JE02U+XwW4CcPu0JMcCgNqtIU2mo2h22ckClb0Jn1u9EElgTUDqT6AtpOVux93CVzTAVQxFiCCkw700f5K+85rR3/6OM9haHQvh01rQ+nxQr11SX9m5R4Brfuh/mGa0Q=
ARC-Authentication-Results: i=1; mx.zohomail.com;
	dkim=pass  header.i=collabora.com;
	spf=pass  smtp.mailfrom=daniel.almeida@collabora.com;
	dmarc=pass header.from=<daniel.almeida@collabora.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1764353224;
	s=zohomail; d=collabora.com; i=daniel.almeida@collabora.com;
	h=Content-Type:Mime-Version:Subject:Subject:From:From:In-Reply-To:Date:Date:Cc:Cc:Content-Transfer-Encoding:Message-Id:Message-Id:References:To:To:Reply-To;
	bh=7hCtVdIpYmvpIaG2Tepwl9t2OZhg+JztbnabjHdsDXw=;
	b=cQMWT3gX69SgMPgVmoZ3O2F61xD0U8uLT41OSthjMpSgkT6ymH/aampfZQsduSSJ
	Mnh+iUhoZu+90ceDRcdZMCKNINIP8yBhJvbThj8X8Y41Uz621+skz9GV68ZLyGGmayr
	QO5jhfvm8In7Rn6Yhul0L9K3CuiAYR5Tg8wuvLZg=
Received: by mx.zohomail.com with SMTPS id 1764353222335519.628984308173;
	Fri, 28 Nov 2025 10:07:02 -0800 (PST)
Content-Type: text/plain;
	charset=utf-8
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3826.700.81\))
Subject: Re: [PATCH v13 4/4] rust: Add `OwnableRefCounted`
From: Daniel Almeida <daniel.almeida@collabora.com>
In-Reply-To: <20251117-unique-ref-v13-4-b5b243df1250@pm.me>
Date: Fri, 28 Nov 2025 15:06:42 -0300
Cc: Miguel Ojeda <ojeda@kernel.org>,
 Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>,
 Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
 Andreas Hindborg <a.hindborg@kernel.org>,
 Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>,
 Benno Lossin <lossin@kernel.org>,
 Danilo Krummrich <dakr@kernel.org>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Dave Ertman <david.m.ertman@intel.com>,
 Ira Weiny <ira.weiny@intel.com>,
 Leon Romanovsky <leon@kernel.org>,
 "Rafael J. Wysocki" <rafael@kernel.org>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Viresh Kumar <vireshk@kernel.org>,
 Nishanth Menon <nm@ti.com>,
 Stephen Boyd <sboyd@kernel.org>,
 Bjorn Helgaas <bhelgaas@google.com>,
 =?utf-8?Q?Krzysztof_Wilczy=C5=84ski?= <kwilczynski@kernel.org>,
 Paul Moore <paul@paul-moore.com>,
 Serge Hallyn <sergeh@kernel.org>,
 Asahi Lina <lina+kernel@asahilina.net>,
 rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org,
 linux-block@vger.kernel.org,
 dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org,
 linux-pm@vger.kernel.org,
 linux-pci@vger.kernel.org,
 linux-security-module@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <A5A7C4C9-1504-439C-B4FF-C28482AF7444@collabora.com>
References: <20251117-unique-ref-v13-0-b5b243df1250@pm.me>
 <20251117-unique-ref-v13-4-b5b243df1250@pm.me>
To: Oliver Mangold <oliver.mangold@pm.me>
X-Mailer: Apple Mail (2.3826.700.81)
X-ZohoMailClient: External
X-Rspamd-Queue-Id: 360BBA0015
X-Rspamd-Server: rspam02
X-Stat-Signature: 79grnd41nx93suhg6tqm81mtkd4mbwhi
X-Rspam-User: 
X-HE-Tag: 1764353248-161629
X-HE-Meta: U2FsdGVkX184gru835AOoDksEbsysh2l9+z1CZ01H8pTxdSwQnSLEWf2GiY2jWVG+w95atNVSk6tvQBIf0tYbTZhUcdOauUKTC3Fz9UAPEQeqDvA+dP81YBEm8GdQ7mu/UrGjqCzRHzARy1648asvp4iGjF1zUlcc37xcmw42lfQkzVdA0ehWTF59a1Hk2caCrQu2Waod6pCL/NX1HNlKmu39RO20VXJV3qQaWMV7UnBpMNBKu3Pdn6IBlyD7ky6Kd9C5CoWkULQ8IznXGfPl7yvgD/RCPWeMEVU3lTXzKejLGV1O9FkJCrT+dT0fgAWrFhoG4ZwCVzFGLd89DVdgYhVqsas1ysaagvbWDTJCl1MaHfP7jWAdLm4t3OoQ8saPhr30uIhsj2QPr1V0BRKYglNEQtOdG45WcD5GQ26OYsE/Toj8Bz0gVRTKKYz+vqqbc0966qDnHj1igU6S4gfVeKLdOqrR09yuEj52V3/rEagfG+9qekqsrKeuBQ8WPnC6RQmEcdLTE4l2KObiINAuEf7bMkaBPKXikYK1YeRsC8KYjqCXfk9Uacl4bsoe06EWH02akTrWmOkHwBGVSnepSQl4vpKHWGvsCjUpxQkKI3eCGWWhL6/ebDJOdywsFG8XZydIetIPFSgxnmm+OiW7pn6fOffa5UntTP2VLumIi0OEfhRrKIjqjHTKwQvslLs+0fEIcTd8Y9V/epJys/Iw3qzO3czReTena/Nr7pIjvitUwnIZEc/WPjY9YVW0bCPC8zbElZHlixlW8+qgn6nyAYeFmiKwE9THzeH3hBQQCSX9Ymj/oD0DwqaCn0io+88e+VYD//09IWMun47jakreKkEwpsoCDjuFmwsnT1/kiW6oz6AJZw2YeQm+7wGP069RdDE1qcziuHjwZxifbyLd54MCScidwIOT891oqrmXNswisimReqsD4cdvzHulOd38Sjj3EbexYprr8JEufJ
 yyIEMndv
 N07R5OmCmmujxJS0DGpwb9ydVSkmM6QlgijmiImd/PguxAwoblJdf5VmJXEl6yrQMvR6iAtKCVwIKvg4d7SV5zh5Dq0brNTjMYczhTcdYgcKKTW2dJLQyupWQ1up5wNFhZNjaCDaXrw2J0WIT0QJh6fW+QXlva4hfIuI3LIFGGV8M/vUBQ1Inkbc4IIYJaXCoCilKlQaQKWPFTKxL2490Cg6PbIdXHLg1BBKBrupq+qRl39lLRHkczxUPz92mdJo1csm9KQoCxeQsgx8QZ+Qw+nM1Uc5vJM3TBUiYjTxWKYRESa69u0c3xL0PomXPFxWYiFKucT5z7ZWFtTIvUfBBrJPeF56f+XH0QfW3zk5DZEa9PHJhyoMO0ZYeEX7RuGQtQBgoEVGvz2/M+xe9QVi8ry6tDt5ZuNKY9eLnPXjWzfJwTsKXzE6NGREkpdLBnbm7YZGsiDswMQB1Y32HGwxQrxUJKe1sKgVemt1d
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Oliver,

> On 17 Nov 2025, at 07:08, Oliver Mangold <oliver.mangold@pm.me> wrote:
>=20
> Types implementing one of these traits can safely convert between an
> `ARef<T>` and an `Owned<T>`.
>=20
> This is useful for types which generally are accessed through an =
`ARef`
> but have methods which can only safely be called when the reference is
> unique, like e.g. `block::mq::Request::end_ok()`.
>=20
> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
> ---
> rust/kernel/owned.rs     | 138 =
++++++++++++++++++++++++++++++++++++++++++++---
> rust/kernel/sync/aref.rs |  11 +++-
> rust/kernel/types.rs     |   2 +-
> 3 files changed, 141 insertions(+), 10 deletions(-)
>=20
> diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
> index a26747cbc13b..26ab2b00ada0 100644
> --- a/rust/kernel/owned.rs
> +++ b/rust/kernel/owned.rs
> @@ -5,6 +5,7 @@
> //! These pointer types are useful for C-allocated objects which by =
API-contract
> //! are owned by Rust, but need to be freed through the C API.
>=20
> +use crate::sync::aref::{ARef, RefCounted};
> use core::{
>     mem::ManuallyDrop,
>     ops::{Deref, DerefMut},
> @@ -14,14 +15,16 @@
>=20
> /// Type allocated and destroyed on the C side, but owned by Rust.
> ///
> -/// Implementing this trait allows types to be referenced via the =
[`Owned<Self>`] pointer type. This
> -/// is useful when it is desirable to tie the lifetime of the =
reference to an owned object, rather
> -/// than pass around a bare reference. [`Ownable`] types can define =
custom drop logic that is
> -/// executed when the owned reference [`Owned<Self>`] pointing to the =
object is dropped.
> +/// Implementing this trait allows types to be referenced via the =
[`Owned<Self>`] pointer type.
> +///  - This is useful when it is desirable to tie the lifetime of an =
object reference to an owned
> +///    object, rather than pass around a bare reference.
> +///  - [`Ownable`] types can define custom drop logic that is =
executed when the owned reference
> +///    of type [`Owned<_>`] pointing to the object is dropped.
> ///
> /// Note: The underlying object is not required to provide internal =
reference counting, because it
> /// represents a unique, owned reference. If reference counting (on =
the Rust side) is required,
> -/// [`RefCounted`](crate::types::RefCounted) should be implemented.
> +/// [`RefCounted`] should be implemented. [`OwnableRefCounted`] =
should be implemented if conversion
> +/// between unique and shared (reference counted) ownership is =
needed.
> ///
> /// # Safety
> ///
> @@ -143,9 +146,7 @@ impl<T: Ownable> Owned<T> {
>     ///   mutable reference requirements. That is, the kernel will not =
mutate or free the underlying
>     ///   object and is okay with it being modified by Rust code.
>     pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
> -        Self {
> -            ptr,
> -        }
> +        Self { ptr }
>     }

Unrelated change?

>=20
>     /// Consumes the [`Owned`], returning a raw pointer.
> @@ -193,3 +194,124 @@ fn drop(&mut self) {
>         unsafe { T::release(self.ptr) };
>     }
> }
> +
> +/// A trait for objects that can be wrapped in either one of the =
reference types [`Owned`] and
> +/// [`ARef`].
> +///
> +/// # Examples
> +///
> +/// A minimal example implementation of [`OwnableRefCounted`], =
[`Ownable`] and its usage with
> +/// [`ARef`] and [`Owned`] looks like this:
> +///
> +/// ```
> +/// # #![expect(clippy::disallowed_names)]
> +/// # use core::cell::Cell;
> +/// # use core::ptr::NonNull;
> +/// # use kernel::alloc::{flags, kbox::KBox, AllocError};
> +/// # use kernel::sync::aref::{ARef, RefCounted};
> +/// # use kernel::types::{Owned, Ownable, OwnableRefCounted};
> +///
> +/// // Example internally refcounted struct.

nit: IMHO the wording could improve ^

> +/// //
> +/// // # Invariants
> +/// //
> +/// // - `refcount` is always non-zero for a valid object.
> +/// // - `refcount` is >1 if there are more than 1 Rust reference to =
it.
> +/// //
> +/// struct Foo {
> +///     refcount: Cell<usize>,
> +/// }
> +///
> +/// impl Foo {
> +///     fn new() -> Result<Owned<Self>, AllocError> {
> +///         // We are just using a `KBox` here to handle the actual =
allocation, as our `Foo` is
> +///         // not actually a C-allocated object.
> +///         let result =3D KBox::new(
> +///             Foo {
> +///                 refcount: Cell::new(1),
> +///             },
> +///             flags::GFP_KERNEL,
> +///         )?;
> +///         let result =3D NonNull::new(KBox::into_raw(result))
> +///             .expect("Raw pointer to newly allocation KBox is =
null, this should never happen.");
> +///         // SAFETY: We just allocated the `Self`, thus it is valid =
and there cannot be any other
> +///         // Rust references. Calling `into_raw()` makes us =
responsible for ownership and
> +///         // we won't use the raw pointer anymore, thus we can =
transfer ownership to the `Owned`.
> +///         Ok(unsafe { Owned::from_raw(result) })
> +///     }
> +/// }
> +///
> +/// // SAFETY: We increment and decrement each time the respective =
function is called and only free
> +/// // the `Foo` when the refcount reaches zero.
> +/// unsafe impl RefCounted for Foo {
> +///     fn inc_ref(&self) {
> +///         self.refcount.replace(self.refcount.get() + 1);
> +///     }
> +///
> +///     unsafe fn dec_ref(this: NonNull<Self>) {
> +///         // SAFETY: By requirement on calling this function, the =
refcount is non-zero,
> +///         // implying the underlying object is valid.
> +///         let refcount =3D unsafe { &this.as_ref().refcount };
> +///         let new_refcount =3D refcount.get() - 1;
> +///         if new_refcount =3D=3D 0 {
> +///             // The `Foo` will be dropped when `KBox` goes out of =
scope.
> +///             // SAFETY: The [`KBox<Foo>`] is still alive as the =
old refcount is 1. We can pass
> +///             // ownership to the [`KBox`] as by requirement on =
calling this function,
> +///             // the `Self` will no longer be used by the caller.
> +///             unsafe { KBox::from_raw(this.as_ptr()) };
> +///         } else {
> +///             refcount.replace(new_refcount);
> +///         }
> +///     }
> +/// }
> +///
> +/// impl OwnableRefCounted for Foo {
> +///     fn try_from_shared(this: ARef<Self>) -> Result<Owned<Self>, =
ARef<Self>> {
> +///         if this.refcount.get() =3D=3D 1 {
> +///             // SAFETY: The `Foo` is still alive and has no other =
Rust references as the refcount
> +///             // is 1.
> +///             Ok(unsafe { Owned::from_raw(ARef::into_raw(this)) })
> +///         } else {
> +///             Err(this)
> +///         }
> +///     }
> +/// }
> +///

We wouldn=E2=80=99t need this implementation if we added a =
=E2=80=9Crefcount()=E2=80=9D
member to this trait. This lets you abstract away this logic for all
implementors, which has the massive upside of making sure we hardcode =
(and thus
enforce) the refcount =3D=3D 1 check.


> +/// // SAFETY: This implementation of `release()` is safe for any =
valid `Self`.
> +/// unsafe impl Ownable for Foo {
> +///     unsafe fn release(this: NonNull<Self>) {
> +///         // SAFETY: Using `dec_ref()` from [`RefCounted`] to =
release is okay, as the refcount is
> +///         // always 1 for an [`Owned<Foo>`].
> +///         unsafe{ Foo::dec_ref(this) };
> +///     }
> +/// }
> +///
> +/// let foo =3D Foo::new().expect("Failed to allocate a Foo. This =
shouldn't happen");

All these =E2=80=9Cexpects()=E2=80=9D and custom error strings would go =
away if you
place this behind a fictional function that returns Result.

> +/// let mut foo =3D ARef::from(foo);
> +/// {
> +///     let bar =3D foo.clone();
> +///     assert!(Owned::try_from(bar).is_err());
> +/// }
> +/// assert!(Owned::try_from(foo).is_ok());
> +/// ```
> +pub trait OwnableRefCounted: RefCounted + Ownable + Sized {
> +    /// Checks if the [`ARef`] is unique and convert it to an =
[`Owned`] it that is that case.
> +    /// Otherwise it returns again an [`ARef`] to the same underlying =
object.
> +    fn try_from_shared(this: ARef<Self>) -> Result<Owned<Self>, =
ARef<Self>>;

Again, this method can go way if we add a method to expose the refcount.

> +
> +    /// Converts the [`Owned`] into an [`ARef`].
> +    fn into_shared(this: Owned<Self>) -> ARef<Self> {
> +        // SAFETY: Safe by the requirements on implementing the =
trait.
> +        unsafe { ARef::from_raw(Owned::into_raw(this)) }
> +    }
> +}
> +
> +impl<T: OwnableRefCounted> TryFrom<ARef<T>> for Owned<T> {
> +    type Error =3D ARef<T>;
> +    /// Tries to convert the [`ARef`] to an [`Owned`] by calling
> +    /// [`try_from_shared()`](OwnableRefCounted::try_from_shared). In =
case the [`ARef`] is not
> +    /// unique, it returns again an [`ARef`] to the same underlying =
object.
> +    fn try_from(b: ARef<T>) -> Result<Owned<T>, Self::Error> {
> +        T::try_from_shared(b)
> +    }
> +}
> diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
> index 937dcf6ed5de..2dbffe2ed1b8 100644
> --- a/rust/kernel/sync/aref.rs
> +++ b/rust/kernel/sync/aref.rs
> @@ -30,7 +30,10 @@
> /// Note: Implementing this trait allows types to be wrapped in an =
[`ARef<Self>`]. It requires an
> /// internal reference count and provides only shared references. If =
unique references are required
> /// [`Ownable`](crate::types::Ownable) should be implemented which =
allows types to be wrapped in an
> -/// [`Owned<Self>`](crate::types::Owned).
> +/// [`Owned<Self>`](crate::types::Owned). Implementing the trait
> +/// [`OwnableRefCounted`](crate::types::OwnableRefCounted) allows to =
convert between unique and
> +/// shared references (i.e. [`Owned<Self>`](crate::types::Owned) and
> +/// [`ARef<Self>`](crate::types::Owned)).
> ///
> /// # Safety
> ///
> @@ -180,6 +183,12 @@ fn from(b: &T) -> Self {
>     }
> }
>=20
> +impl<T: crate::types::OwnableRefCounted> From<crate::types::Owned<T>> =
for ARef<T> {
> +    fn from(b: crate::types::Owned<T>) -> Self {
> +        T::into_shared(b)
> +    }
> +}
> +

Not sure why we=E2=80=99re using fully-qualified names here if we can =
import them, but your call.

> impl<T: RefCounted> Drop for ARef<T> {
>     fn drop(&mut self) {
>         // SAFETY: The type invariants guarantee that the `ARef` owns =
the reference we're about to
> diff --git a/rust/kernel/types.rs b/rust/kernel/types.rs
> index 8ef01393352b..a9b72709d0d3 100644
> --- a/rust/kernel/types.rs
> +++ b/rust/kernel/types.rs
> @@ -11,7 +11,7 @@
> };
> use pin_init::{PinInit, Wrapper, Zeroable};
>=20
> -pub use crate::owned::{Ownable, Owned};
> +pub use crate::owned::{Ownable, OwnableRefCounted, Owned};
>=20
> pub use crate::sync::aref::{ARef, AlwaysRefCounted, RefCounted};
>=20
>=20
> --=20
> 2.51.2
>=20
>=20
>=20

=E2=80=94 Daniel=

