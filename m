Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C0916E7314E
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 10:06:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FE646B008A; Mon,  2 Feb 2026 05:06:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A8086B008C; Mon,  2 Feb 2026 05:06:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D5D56B0092; Mon,  2 Feb 2026 05:06:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0D07C6B008A
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 05:06:59 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D036114089F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:06:58 +0000 (UTC)
X-FDA: 84399088116.01.8C34888
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id 477CF1C000F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:06:57 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z7SYgy4v;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770026817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Au54eBXOxWGJgaSmbKKwnC21u5DVGFnzCTsQV9BNyhQ=;
	b=i6OZqQC8p3gAVb+PJFy5kqfsARJVcdrZ9pWSxGfc4S8Zm+mf5P/HiwPcHOKSWBqxjJIJuO
	r76NTyGMnawNySIJ1YMHZPAgqDfZkK5ctOnoZ9WDwypQF0cx27wDCNuFo8aa9af4AyHjaO
	sLzyrCtP62KYYPZhVso7r98tw8fdF2A=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Z7SYgy4v;
	spf=pass (imf21.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770026817; a=rsa-sha256;
	cv=none;
	b=M3jAzUY7CU1K4NNiGwLqaM1GyJ39ZpM/BiPMFKNyEpghA9dTl/MYLZhe3okZADqQxt00bF
	0zCcYdGV2qxJptUNjbub7xHp68ZI/jzCVcLooVWt+xwITTyglqbQdUzQ3AminZbSYOpdKD
	ac97eMqT3xsVPjUgW+0eis9zTdhEp44=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6448160008;
	Mon,  2 Feb 2026 10:06:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 611DFC116D0;
	Mon,  2 Feb 2026 10:06:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770026816;
	bh=DlHoOTLxIxjAjwF5rSYvlt5G94iLnc2c4QiF0If3+SU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=Z7SYgy4v07w1AugBQ5PySBoJ5Ew8y2VILV4q+TXbJbgSA0KpfHpLuNExlQ1DT56bW
	 TpinW8kxfX+Y9FWOzp1Ipg4NMzWUgxmVikG1asAF3MP4u2VTxqYM0SxoWxFaksQb0f
	 5pwYNOWOq5rkrRx3UenvjAm7+bLAysTDYv53RV/Xksnwv4Ns4uNumHpoV8Ml2F1/RC
	 Xv1PTuTZn1wgrxLtSIuJo8eIAmzPFcKcRRDrcccfDXjFjbMZcOQchhPQe8ofUspMvX
	 lmUh0Ejhus8nx+FbJeHrXB+GRK2jPzA7e+jFf2+I5aAdfF9bGc1ZwzWxMdKMYB0v+9
	 /jrdOL/XLZz+A==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Daniel Almeida <daniel.almeida@collabora.com>, Oliver Mangold
 <oliver.mangold@pm.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Alice Ryhl <aliceryhl@google.com>,
 Trevor Gross <tmgross@umich.edu>, Benno Lossin <lossin@kernel.org>, Danilo
 Krummrich <dakr@kernel.org>, Greg Kroah-Hartman
 <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, Ira
 Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, "Rafael J.
 Wysocki" <rafael@kernel.org>, Maarten Lankhorst
 <maarten.lankhorst@linux.intel.com>, Maxime Ripard <mripard@kernel.org>,
 Thomas Zimmermann <tzimmermann@suse.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Lorenzo
 Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Viresh Kumar <vireshk@kernel.org>, Nishanth
 Menon <nm@ti.com>, Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas
 <bhelgaas@google.com>, Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=
 <kwilczynski@kernel.org>, Paul
 Moore <paul@paul-moore.com>, Serge Hallyn <sergeh@kernel.org>, Asahi Lina
 <lina+kernel@asahilina.net>, rust-for-linux@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 linux-security-module@vger.kernel.org
Subject: Re: [PATCH v13 4/4] rust: Add `OwnableRefCounted`
In-Reply-To: <A5A7C4C9-1504-439C-B4FF-C28482AF7444@collabora.com>
References: <20251117-unique-ref-v13-0-b5b243df1250@pm.me>
 <20251117-unique-ref-v13-4-b5b243df1250@pm.me>
 <A5A7C4C9-1504-439C-B4FF-C28482AF7444@collabora.com>
Date: Mon, 02 Feb 2026 11:06:02 +0100
Message-ID: <87qzr3piid.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 477CF1C000F
X-Stat-Signature: 19fhiy79bwahw54c3nsejsya4ye3jzg7
X-Rspam-User: 
X-HE-Tag: 1770026817-484546
X-HE-Meta: U2FsdGVkX1/GmCZdSs+RTGtt465uaitz0O03hZ1EXTsTvs83aWyK3ynaMs0+bd6QROH3gu54nyMAgyBNTIPxMfyOP2jAfT1IBzfH69/DDcavX6qkqQj6iKHvJryVc39ksMbNKrdgGlUurWN0vLlMTv8w8vBj6IfK2Q42OrWJteQdp1gyhKdku+5w5AfkmX8gHHj4mp+3Tf3Nhb7pI1g9NadStGeqi5sOJnp+I/HCmU0FNdvhVYuCkHEnXbogQiQaqbpFt+1/HdB27u45TSFY0YK78tj3sIsSud8M39FEIPV+Jd0k3WytOxI5D8p6oVmgHXbP1VfPprtXye38F+g4A0hq58JzWHjys54DBtOVYNp6VH3rkz4VGXvJl7aqCGyd/lszlbvGOKUafWDDUeo/mGcccaHa6Y+USc9eiqcI8OwvjsQU8RehjLvQpzJa5QJ8zRU1mYSWWOjbHpDZxeWSfEC2ieAwodWAi4Zj5f8xXc9RkDKbgTg1PihI2thtup9Gu4jmIZzw3wbjEBwVYpBc7nBQM7mowp7OWiNG0ejKsJILX3X9VOCoXpdywigOtiTzoNt+f1p9mG9KejNuVH9A1AZPSrh9vnfdSt/FenhRcizPXyodHWSRLqJpliWRlwhVo80mmhssW40Yl7Frq88rgcf02/lfJrKxS9anHMKvzD69oEUKc5qkFw5GqMRbK6jb4vWmulV+7E4Lul/Ow4PtZ1+3BP6rBjLMuaEp4VZpOeUtc1f33y4VyGVxT8+LekaWq8mdO2R77/gb/DIfQiU8M01hYlI61J+V5azcwr0iE1TsXif64oq1Ivfn27cXXnl8ZDB69MCwNFmaw8kMZ8KIEM3GN930L+/LJ+0IIGhQKnfZAJQ0EMNcH2S3dS7DvytQXytCeVCaYHC8ol1O042fXMDvdI07vGZTyeWg9TSgql4BtpoxYqpQXsLbuAfo4tvNsZzXjY0+L59xqCglpQb
 LyqVMmg6
 6DumVb60gK+SV+PM4E3t2Ou6Hvwfkd9lK2WClA1tcXNpPJswonN09hKFWZAdCN1eRKVMMYhoCepn5AMf9OqU0X05KBJK7yVsFRtx19znze66IpFoDF9yTesSmXmlWcpvRDuxOXbVKNZrsKOWyT1cx/zHWakHFejY0h3SXt9WdCTwiF8vzSgO4vLmtLKB2Rd9zTfcFu8ennhs4s/wADb/AezLdOvMIewDMF0UtL2Uf3gWZkjaTSkOAVyzxeH4IJ3p9SoWXJo3ahHCTY3X+tpqaMD4aHPFiJjLAikJ+iyOnAsnhg1zkyFuwdIf3jwr5opuqJBl7q4TE7kvBwlnI282PlqAsYVHwCwAGFMdT6Ll3Ap5ecje+0LadxT8BF5fA8liJBddj+RB/LWyFmyfBzORTy87xX57IUwpzoiqiQz6imkSStJe8SVjDpNBT6g==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Daniel Almeida <daniel.almeida@collabora.com> writes:

> Hi Oliver,
>
>> On 17 Nov 2025, at 07:08, Oliver Mangold <oliver.mangold@pm.me> wrote:
>>=20
>> Types implementing one of these traits can safely convert between an
>> `ARef<T>` and an `Owned<T>`.
>>=20
>> This is useful for types which generally are accessed through an `ARef`
>> but have methods which can only safely be called when the reference is
>> unique, like e.g. `block::mq::Request::end_ok()`.
>>=20
>> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
>> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> Reviewed-by: Andreas Hindborg <a.hindborg@kernel.org>
>> ---
>> rust/kernel/owned.rs     | 138 +++++++++++++++++++++++++++++++++++++++++=
+++---
>> rust/kernel/sync/aref.rs |  11 +++-
>> rust/kernel/types.rs     |   2 +-
>> 3 files changed, 141 insertions(+), 10 deletions(-)
>>=20
>> diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
>> index a26747cbc13b..26ab2b00ada0 100644
>> --- a/rust/kernel/owned.rs
>> +++ b/rust/kernel/owned.rs
>> @@ -5,6 +5,7 @@
>> //! These pointer types are useful for C-allocated objects which by API-=
contract
>> //! are owned by Rust, but need to be freed through the C API.
>>=20
>> +use crate::sync::aref::{ARef, RefCounted};
>> use core::{
>>     mem::ManuallyDrop,
>>     ops::{Deref, DerefMut},
>> @@ -14,14 +15,16 @@
>>=20
>> /// Type allocated and destroyed on the C side, but owned by Rust.
>> ///
>> -/// Implementing this trait allows types to be referenced via the [`Own=
ed<Self>`] pointer type. This
>> -/// is useful when it is desirable to tie the lifetime of the reference=
 to an owned object, rather
>> -/// than pass around a bare reference. [`Ownable`] types can define cus=
tom drop logic that is
>> -/// executed when the owned reference [`Owned<Self>`] pointing to the o=
bject is dropped.
>> +/// Implementing this trait allows types to be referenced via the [`Own=
ed<Self>`] pointer type.
>> +///  - This is useful when it is desirable to tie the lifetime of an ob=
ject reference to an owned
>> +///    object, rather than pass around a bare reference.
>> +///  - [`Ownable`] types can define custom drop logic that is executed =
when the owned reference
>> +///    of type [`Owned<_>`] pointing to the object is dropped.
>> ///
>> /// Note: The underlying object is not required to provide internal refe=
rence counting, because it
>> /// represents a unique, owned reference. If reference counting (on the =
Rust side) is required,
>> -/// [`RefCounted`](crate::types::RefCounted) should be implemented.
>> +/// [`RefCounted`] should be implemented. [`OwnableRefCounted`] should =
be implemented if conversion
>> +/// between unique and shared (reference counted) ownership is needed.
>> ///
>> /// # Safety
>> ///
>> @@ -143,9 +146,7 @@ impl<T: Ownable> Owned<T> {
>>     ///   mutable reference requirements. That is, the kernel will not m=
utate or free the underlying
>>     ///   object and is okay with it being modified by Rust code.
>>     pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
>> -        Self {
>> -            ptr,
>> -        }
>> +        Self { ptr }
>>     }
>
> Unrelated change?

Looks like a rustfmt thing. I'll split it out or remove it.

>
>>=20
>>     /// Consumes the [`Owned`], returning a raw pointer.
>> @@ -193,3 +194,124 @@ fn drop(&mut self) {
>>         unsafe { T::release(self.ptr) };
>>     }
>> }
>> +
>> +/// A trait for objects that can be wrapped in either one of the refere=
nce types [`Owned`] and
>> +/// [`ARef`].
>> +///
>> +/// # Examples
>> +///
>> +/// A minimal example implementation of [`OwnableRefCounted`], [`Ownabl=
e`] and its usage with
>> +/// [`ARef`] and [`Owned`] looks like this:
>> +///
>> +/// ```
>> +/// # #![expect(clippy::disallowed_names)]
>> +/// # use core::cell::Cell;
>> +/// # use core::ptr::NonNull;
>> +/// # use kernel::alloc::{flags, kbox::KBox, AllocError};
>> +/// # use kernel::sync::aref::{ARef, RefCounted};
>> +/// # use kernel::types::{Owned, Ownable, OwnableRefCounted};
>> +///
>> +/// // Example internally refcounted struct.
>
> nit: IMHO the wording could improve ^

/// // An internally refcounted struct for demonstration purposes.

>
>> +/// //
>> +/// // # Invariants
>> +/// //
>> +/// // - `refcount` is always non-zero for a valid object.
>> +/// // - `refcount` is >1 if there are more than 1 Rust reference to it.
>> +/// //
>> +/// struct Foo {
>> +///     refcount: Cell<usize>,
>> +/// }
>> +///
>> +/// impl Foo {
>> +///     fn new() -> Result<Owned<Self>, AllocError> {
>> +///         // We are just using a `KBox` here to handle the actual all=
ocation, as our `Foo` is
>> +///         // not actually a C-allocated object.
>> +///         let result =3D KBox::new(
>> +///             Foo {
>> +///                 refcount: Cell::new(1),
>> +///             },
>> +///             flags::GFP_KERNEL,
>> +///         )?;
>> +///         let result =3D NonNull::new(KBox::into_raw(result))
>> +///             .expect("Raw pointer to newly allocation KBox is null, =
this should never happen.");
>> +///         // SAFETY: We just allocated the `Self`, thus it is valid a=
nd there cannot be any other
>> +///         // Rust references. Calling `into_raw()` makes us responsib=
le for ownership and
>> +///         // we won't use the raw pointer anymore, thus we can transf=
er ownership to the `Owned`.
>> +///         Ok(unsafe { Owned::from_raw(result) })
>> +///     }
>> +/// }
>> +///
>> +/// // SAFETY: We increment and decrement each time the respective func=
tion is called and only free
>> +/// // the `Foo` when the refcount reaches zero.
>> +/// unsafe impl RefCounted for Foo {
>> +///     fn inc_ref(&self) {
>> +///         self.refcount.replace(self.refcount.get() + 1);
>> +///     }
>> +///
>> +///     unsafe fn dec_ref(this: NonNull<Self>) {
>> +///         // SAFETY: By requirement on calling this function, the ref=
count is non-zero,
>> +///         // implying the underlying object is valid.
>> +///         let refcount =3D unsafe { &this.as_ref().refcount };
>> +///         let new_refcount =3D refcount.get() - 1;
>> +///         if new_refcount =3D=3D 0 {
>> +///             // The `Foo` will be dropped when `KBox` goes out of sc=
ope.
>> +///             // SAFETY: The [`KBox<Foo>`] is still alive as the old =
refcount is 1. We can pass
>> +///             // ownership to the [`KBox`] as by requirement on calli=
ng this function,
>> +///             // the `Self` will no longer be used by the caller.
>> +///             unsafe { KBox::from_raw(this.as_ptr()) };
>> +///         } else {
>> +///             refcount.replace(new_refcount);
>> +///         }
>> +///     }
>> +/// }
>> +///
>> +/// impl OwnableRefCounted for Foo {
>> +///     fn try_from_shared(this: ARef<Self>) -> Result<Owned<Self>, ARe=
f<Self>> {
>> +///         if this.refcount.get() =3D=3D 1 {
>> +///             // SAFETY: The `Foo` is still alive and has no other Ru=
st references as the refcount
>> +///             // is 1.
>> +///             Ok(unsafe { Owned::from_raw(ARef::into_raw(this)) })
>> +///         } else {
>> +///             Err(this)
>> +///         }
>> +///     }
>> +/// }
>> +///
>
> We wouldn=E2=80=99t need this implementation if we added a =E2=80=9Crefco=
unt()=E2=80=9D
> member to this trait. This lets you abstract away this logic for all
> implementors, which has the massive upside of making sure we hardcode (an=
d thus
> enforce) the refcount =3D=3D 1 check.

This exist to allow reference counting schemes that are different from
the general implementation. See [1] for an example.

[1] https://github.com/metaspace/linux/blob/3e46e95f0707fa71259b1d241f68914=
4ad61cc62/rust/kernel/block/mq/request.rs#L478

>
>
>> +/// // SAFETY: This implementation of `release()` is safe for any valid=
 `Self`.
>> +/// unsafe impl Ownable for Foo {
>> +///     unsafe fn release(this: NonNull<Self>) {
>> +///         // SAFETY: Using `dec_ref()` from [`RefCounted`] to release=
 is okay, as the refcount is
>> +///         // always 1 for an [`Owned<Foo>`].
>> +///         unsafe{ Foo::dec_ref(this) };
>> +///     }
>> +/// }
>> +///
>> +/// let foo =3D Foo::new().expect("Failed to allocate a Foo. This shoul=
dn't happen");
>
> All these =E2=80=9Cexpects()=E2=80=9D and custom error strings would go a=
way if you
> place this behind a fictional function that returns Result.

I'll do that.

>
>> +/// let mut foo =3D ARef::from(foo);
>> +/// {
>> +///     let bar =3D foo.clone();
>> +///     assert!(Owned::try_from(bar).is_err());
>> +/// }
>> +/// assert!(Owned::try_from(foo).is_ok());
>> +/// ```
>> +pub trait OwnableRefCounted: RefCounted + Ownable + Sized {
>> +    /// Checks if the [`ARef`] is unique and convert it to an [`Owned`]=
 it that is that case.
>> +    /// Otherwise it returns again an [`ARef`] to the same underlying o=
bject.
>> +    fn try_from_shared(this: ARef<Self>) -> Result<Owned<Self>, ARef<Se=
lf>>;
>
> Again, this method can go way if we add a method to expose the refcount.
>
>> +
>> +    /// Converts the [`Owned`] into an [`ARef`].
>> +    fn into_shared(this: Owned<Self>) -> ARef<Self> {
>> +        // SAFETY: Safe by the requirements on implementing the trait.
>> +        unsafe { ARef::from_raw(Owned::into_raw(this)) }
>> +    }
>> +}
>> +
>> +impl<T: OwnableRefCounted> TryFrom<ARef<T>> for Owned<T> {
>> +    type Error =3D ARef<T>;
>> +    /// Tries to convert the [`ARef`] to an [`Owned`] by calling
>> +    /// [`try_from_shared()`](OwnableRefCounted::try_from_shared). In c=
ase the [`ARef`] is not
>> +    /// unique, it returns again an [`ARef`] to the same underlying obj=
ect.
>> +    fn try_from(b: ARef<T>) -> Result<Owned<T>, Self::Error> {
>> +        T::try_from_shared(b)
>> +    }
>> +}
>> diff --git a/rust/kernel/sync/aref.rs b/rust/kernel/sync/aref.rs
>> index 937dcf6ed5de..2dbffe2ed1b8 100644
>> --- a/rust/kernel/sync/aref.rs
>> +++ b/rust/kernel/sync/aref.rs
>> @@ -30,7 +30,10 @@
>> /// Note: Implementing this trait allows types to be wrapped in an [`ARe=
f<Self>`]. It requires an
>> /// internal reference count and provides only shared references. If uni=
que references are required
>> /// [`Ownable`](crate::types::Ownable) should be implemented which allow=
s types to be wrapped in an
>> -/// [`Owned<Self>`](crate::types::Owned).
>> +/// [`Owned<Self>`](crate::types::Owned). Implementing the trait
>> +/// [`OwnableRefCounted`](crate::types::OwnableRefCounted) allows to co=
nvert between unique and
>> +/// shared references (i.e. [`Owned<Self>`](crate::types::Owned) and
>> +/// [`ARef<Self>`](crate::types::Owned)).
>> ///
>> /// # Safety
>> ///
>> @@ -180,6 +183,12 @@ fn from(b: &T) -> Self {
>>     }
>> }
>>=20
>> +impl<T: crate::types::OwnableRefCounted> From<crate::types::Owned<T>> f=
or ARef<T> {
>> +    fn from(b: crate::types::Owned<T>) -> Self {
>> +        T::into_shared(b)
>> +    }
>> +}
>> +
>
> Not sure why we=E2=80=99re using fully-qualified names here if we can imp=
ort them, but your call.

I'll import them.


Best regards,
Andreas Hindborg



