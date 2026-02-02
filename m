Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 72226E7314A
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 10:06:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C438C6B0089; Mon,  2 Feb 2026 05:06:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0DD06B008A; Mon,  2 Feb 2026 05:06:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEF7C6B008C; Mon,  2 Feb 2026 05:06:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 994516B0089
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 05:06:49 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 425271B22F9
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:06:49 +0000 (UTC)
X-FDA: 84399087738.24.7A3A209
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id AC818C0007
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 10:06:47 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dgZfY3Xo;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770026807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g1B24eIMjsjwNtRYsAFFMwjffrbVvaCltyvtxTd0JV0=;
	b=cY2+IlSTlOZR75L71PASAWedSCUEMqAGtZpYs4pNLAv3KOAhF9c9uVrL8qVRtx71LBaK/B
	yyxK6dfDpCpyB//Iws3NT+US42fvJ0AjYjoYOXJcLu8/ZiZfTRTUKImrmMqbKTG62R4PFt
	enzcRk1PdCcAzL4c5wUPpG2zBK1bh/4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dgZfY3Xo;
	spf=pass (imf22.hostedemail.com: domain of a.hindborg@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770026807; a=rsa-sha256;
	cv=none;
	b=taEN0W4wJV+PIjqyg9g5kia8xTPxy3pslnObslzzaidkXfrRUiqvYFVH70rxEC9ZESmhp1
	6RIVwZhPdNJPvyGkXNIQUVjTq75L2kfQhXvUY6U7/bPYoZFDdArVGsO1HpKPP0yVBkMDmo
	i43zMy/hlARxpUaopE2MQ2UxhVYCFpA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D48B3429EF;
	Mon,  2 Feb 2026 10:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63F14C116C6;
	Mon,  2 Feb 2026 10:06:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770026806;
	bh=w3FSTDzx7E8mraZaaDGyuP+0xN6GQpY+/GPOVYPPtfQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=dgZfY3XoeXPfAlHYEFs2WdJH02wkLpOU1HKLIukQyXEEdGbPAdTtJNfOwFnpCb2jW
	 8zNtZArjMtIikbuiITY22wYZkNa3GjvOQB2eLX52+HjVBRcBv2KbjGxaWmBJJRds00
	 3Pdtavxjnj31/iZPiS8lkO8/7wHECWw7fSTee6ht+WWhC1jthkeMxWNdMOcADPE1F3
	 ctiM49lKA4RbPh0boINSS9Wa5Fy7RWX4TuBBMuHEgTDDFw7RSgRsmNtVL+axBZIdRc
	 KtSh02iXMz4dIwQqDWPOdFauOXFivQKx6vbJWiiyFPwzgWdMEWrOIK/cgiDe9OzoKi
	 DJvNbLzeSLZNg==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Gary Guo <gary@garyguo.net>, Oliver Mangold <oliver.mangold@pm.me>
Cc: Miguel Ojeda <ojeda@kernel.org>, Alex Gaynor <alex.gaynor@gmail.com>,
 Boqun Feng <boqun.feng@gmail.com>, =?utf-8?Q?Bj=C3=B6rn?= Roy Baron
 <bjorn3_gh@protonmail.com>, Alice
 Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>, Benno Lossin
 <lossin@kernel.org>, Danilo Krummrich <dakr@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira
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
Subject: Re: [PATCH v13 1/4] rust: types: Add Ownable/Owned types
In-Reply-To: <20251201155135.2b9c4084.gary@garyguo.net>
References: <20251117-unique-ref-v13-0-b5b243df1250@pm.me>
 <20251117-unique-ref-v13-1-b5b243df1250@pm.me>
 <20251201155135.2b9c4084.gary@garyguo.net>
Date: Mon, 02 Feb 2026 10:37:55 +0100
Message-ID: <87343jqydo.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: j45sbzst94owsnkuxnw4xowse7xsguku
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: AC818C0007
X-HE-Tag: 1770026807-182039
X-HE-Meta: U2FsdGVkX19x2jnz85slil2ISWyMmAaeq3na9iMCBV24U9CzAfM+nBf+budinoI9x+EfTQcwONaHpDPKlpbrO7YYc0XWwZg8gsBmAJHorbl4wvHIdVFZu5aK4nQ9o1S5gMVNcDEhcfzfSCGD8X3Qgv2fzDVO24GkdWxUvzjjCi00JV1k9qK8v4HxDhzs+aEtr/VPvyKdo+29qI2LNGNSdeK0ntZ8Gli5nHCaWNckix9/HZNvlAZuX7fSefKpQW9IIxw5YQ73qEAAjDHdt3bAE2pfmCS65tP8+Sf9cJutkYVoIqvm1qKkWPtO9KSpgDg3x15F/Y6KHUgwQnYh0+COCJIXkc1ZaVKYLSKwPIZ5YI3SfFVbjhV59Grb3kizrOZ7WT6E4s5T6M7vgzoWqE28cuxyPdrjmWp8Ipw2trljyHv4ksNSzDLbRDNBJU+cIaldbQoI3exXgKsjOFuJY4hbfCBaC52/cxUBvInLr1NwzTFjKae8OKOgf66SBhhpTAfecc6F/boaYq7+0dRU0obj3wlza27ny1DZhYaFG3PvcXXKAu3MugvLLeftMbqOeg6gsgckjm+ewugICRLQcCVWk9rpfh10yfCv9F0RQSYd2f8y5TaVeKZ5c3NqgjcS/xPBG7Yk+LysSFDqU/9N8nCbM0CqDFbZxQyDXQ5ioDjY5uELM4+2/kRP0Qn7Df5Hc+ycV7Gf566Zbk5l4NahQhr2ko7ZleLk6rH3gWV9NSlYJX9iu3OSrvGVgexyfO0h7u3HP7hb5FroglVQ3uOqDeDuH3EgIbI8Zix64tGp8UPq782oGyr7z20COlr9pwIyBepykuXRAoGV4yDZJvXQ2eEIpTLGcPt+/wNFH9urf5Q2CKweVeHKXmQN/qBW2sF/XcSpgGXB8//ergBGSydJMxm4pBS24yahVj38N9EncI4BRbnXuDXHNWeH1Tzd7kGw7NWtRYZA1VDuWWNC55oSSbP
 Rsg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Gary Guo <gary@garyguo.net> writes:

> On Mon, 17 Nov 2025 10:07:40 +0000
> Oliver Mangold <oliver.mangold@pm.me> wrote:
>
>> From: Asahi Lina <lina+kernel@asahilina.net>
>> 
>> By analogy to `AlwaysRefCounted` and `ARef`, an `Ownable` type is a
>> (typically C FFI) type that *may* be owned by Rust, but need not be. Unlike
>> `AlwaysRefCounted`, this mechanism expects the reference to be unique
>> within Rust, and does not allow cloning.
>> 
>> Conceptually, this is similar to a `KBox<T>`, except that it delegates
>> resource management to the `T` instead of using a generic allocator.
>> 
>> [ om:
>>   - Split code into separate file and `pub use` it from types.rs.
>>   - Make from_raw() and into_raw() public.
>>   - Remove OwnableMut, and make DerefMut dependent on Unpin instead.
>>   - Usage example/doctest for Ownable/Owned.
>>   - Fixes to documentation and commit message.
>> ]
>> 
>> Link: https://lore.kernel.org/all/20250202-rust-page-v1-1-e3170d7fe55e@asahilina.net/
>> Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
>> Co-developed-by: Oliver Mangold <oliver.mangold@pm.me>
>> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
>> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
>> ---
>>  rust/kernel/lib.rs       |   1 +
>>  rust/kernel/owned.rs     | 195 +++++++++++++++++++++++++++++++++++++++++++++++
>>  rust/kernel/sync/aref.rs |   5 ++
>>  rust/kernel/types.rs     |   2 +
>>  4 files changed, 203 insertions(+)
>> 
>> diff --git a/rust/kernel/lib.rs b/rust/kernel/lib.rs
>> index 3dd7bebe7888..e0ee04330dd0 100644
>> --- a/rust/kernel/lib.rs
>> +++ b/rust/kernel/lib.rs
>> @@ -112,6 +112,7 @@
>>  pub mod of;
>>  #[cfg(CONFIG_PM_OPP)]
>>  pub mod opp;
>> +pub mod owned;
>>  pub mod page;
>>  #[cfg(CONFIG_PCI)]
>>  pub mod pci;
>> diff --git a/rust/kernel/owned.rs b/rust/kernel/owned.rs
>> new file mode 100644
>> index 000000000000..a2cdd2cb8a10
>> --- /dev/null
>> +++ b/rust/kernel/owned.rs
>> @@ -0,0 +1,195 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +
>> +//! Unique owned pointer types for objects with custom drop logic.
>> +//!
>> +//! These pointer types are useful for C-allocated objects which by API-contract
>> +//! are owned by Rust, but need to be freed through the C API.
>> +
>> +use core::{
>> +    mem::ManuallyDrop,
>> +    ops::{Deref, DerefMut},
>> +    pin::Pin,
>> +    ptr::NonNull,
>> +};
>> +
>> +/// Type allocated and destroyed on the C side, but owned by Rust.
>
> The example given in the documentation below shows a valid way of
> defining a type that's handled on the Rust side, so I think this
> message is somewhat inaccurate.
>
> Perhaps something like
>
> 	Types that specify their own way of performing allocation and
> 	destruction. Typically, this trait is implemented on types from
> 	the C side.

Thanks, I'll use this.

>
> ?
>
>> +///
>> +/// Implementing this trait allows types to be referenced via the [`Owned<Self>`] pointer type. This
>> +/// is useful when it is desirable to tie the lifetime of the reference to an owned object, rather
>> +/// than pass around a bare reference. [`Ownable`] types can define custom drop logic that is
>> +/// executed when the owned reference [`Owned<Self>`] pointing to the object is dropped.
>> +///
>> +/// Note: The underlying object is not required to provide internal reference counting, because it
>> +/// represents a unique, owned reference. If reference counting (on the Rust side) is required,
>> +/// [`AlwaysRefCounted`](crate::types::AlwaysRefCounted) should be implemented.
>> +///
>> +/// # Safety
>> +///
>> +/// Implementers must ensure that the [`release()`](Self::release) function frees the underlying
>> +/// object in the correct way for a valid, owned object of this type.
>> +///
>> +/// # Examples
>> +///
>> +/// A minimal example implementation of [`Ownable`] and its usage with [`Owned`] looks like this:
>> +///
>> +/// ```
>> +/// # #![expect(clippy::disallowed_names)]
>> +/// # use core::cell::Cell;
>> +/// # use core::ptr::NonNull;
>> +/// # use kernel::sync::global_lock;
>> +/// # use kernel::alloc::{flags, kbox::KBox, AllocError};
>> +/// # use kernel::types::{Owned, Ownable};
>> +///
>> +/// // Let's count the allocations to see if freeing works.
>> +/// kernel::sync::global_lock! {
>> +///     // SAFETY: we call `init()` right below, before doing anything else.
>> +///     unsafe(uninit) static FOO_ALLOC_COUNT: Mutex<usize> = 0;
>> +/// }
>> +/// // SAFETY: We call `init()` only once, here.
>> +/// unsafe { FOO_ALLOC_COUNT.init() };
>> +///
>> +/// struct Foo {
>> +/// }
>> +///
>> +/// impl Foo {
>> +///     fn new() -> Result<Owned<Self>, AllocError> {
>> +///         // We are just using a `KBox` here to handle the actual allocation, as our `Foo` is
>> +///         // not actually a C-allocated object.
>> +///         let result = KBox::new(
>> +///             Foo {},
>> +///             flags::GFP_KERNEL,
>> +///         )?;
>> +///         let result = NonNull::new(KBox::into_raw(result))
>> +///             .expect("Raw pointer to newly allocation KBox is null, this should never happen.");
>> +///         // Count new allocation
>> +///         *FOO_ALLOC_COUNT.lock() += 1;
>> +///         // SAFETY: We just allocated the `Self`, thus it is valid and there cannot be any other
>> +///         // Rust references. Calling `into_raw()` makes us responsible for ownership and we won't
>> +///         // use the raw pointer anymore. Thus we can transfer ownership to the `Owned`.
>> +///         Ok(unsafe { Owned::from_raw(result) })
>> +///     }
>> +/// }
>> +///
>> +/// // SAFETY: What out `release()` function does is safe of any valid `Self`.
>
> I can't parse this sentence. Is "out" supposed to be a different word?

I think it should be "our".

>
>> +/// unsafe impl Ownable for Foo {
>> +///     unsafe fn release(this: NonNull<Self>) {
>> +///         // The `Foo` will be dropped when `KBox` goes out of scope.
>
> I would just write `drop(unsafe { ... })` to make drop explicit instead
> of commenting about the implicit drop.

Agree, that is easier to read.

>
>> +///         // SAFETY: The [`KBox<Self>`] is still alive. We can pass ownership to the [`KBox`], as
>> +///         // by requirement on calling this function, the `Self` will no longer be used by the
>> +///         // caller.
>> +///         unsafe { KBox::from_raw(this.as_ptr()) };
>> +///         // Count released allocation
>> +///         *FOO_ALLOC_COUNT.lock() -= 1;
>> +///     }
>> +/// }
>> +///
>> +/// {
>> +///    let foo = Foo::new().expect("Failed to allocate a Foo. This shouldn't happen");
>> +///    assert!(*FOO_ALLOC_COUNT.lock() == 1);
>> +/// }
>> +/// // `foo` is out of scope now, so we expect no live allocations.
>> +/// assert!(*FOO_ALLOC_COUNT.lock() == 0);
>> +/// ```
>> +pub unsafe trait Ownable {
>> +    /// Releases the object.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// Callers must ensure that:
>> +    /// - `this` points to a valid `Self`.
>> +    /// - `*this` is no longer used after this call.
>> +    unsafe fn release(this: NonNull<Self>);
>> +}
>> +
>> +/// An owned reference to an owned `T`.
>> +///
>> +/// The [`Ownable`] is automatically freed or released when an instance of [`Owned`] is
>> +/// dropped.
>> +///
>> +/// # Invariants
>> +///
>> +/// - The [`Owned<T>`] has exclusive access to the instance of `T`.
>> +/// - The instance of `T` will stay alive at least as long as the [`Owned<T>`] is alive.
>> +pub struct Owned<T: Ownable> {
>> +    ptr: NonNull<T>,
>> +}
>> +
>> +// SAFETY: It is safe to send an [`Owned<T>`] to another thread when the underlying `T` is [`Send`],
>> +// because of the ownership invariant. Sending an [`Owned<T>`] is equivalent to sending the `T`.
>> +unsafe impl<T: Ownable + Send> Send for Owned<T> {}
>> +
>> +// SAFETY: It is safe to send [`&Owned<T>`] to another thread when the underlying `T` is [`Sync`],
>> +// because of the ownership invariant. Sending an [`&Owned<T>`] is equivalent to sending the `&T`.
>> +unsafe impl<T: Ownable + Sync> Sync for Owned<T> {}
>> +
>> +impl<T: Ownable> Owned<T> {
>> +    /// Creates a new instance of [`Owned`].
>> +    ///
>> +    /// It takes over ownership of the underlying object.
>> +    ///
>> +    /// # Safety
>> +    ///
>> +    /// Callers must ensure that:
>> +    /// - `ptr` points to a valid instance of `T`.
>> +    /// - Ownership of the underlying `T` can be transferred to the `Self<T>` (i.e. operations
>> +    ///   which require ownership will be safe).
>> +    /// - No other Rust references to the underlying object exist. This implies that the underlying
>> +    ///   object is not accessed through `ptr` anymore after the function call (at least until the
>> +    ///   the `Self<T>` is dropped.
>
> Is this correct? If `Self<T>` is dropped then `T::release` is called so
> the pointer should also not be accessed further?

I can't follow you point here. Are you saying that the requirement is
wrong because `T::release` will access the object by reference? If so,
that is part of `Owned<_>::drop`, which is explicitly mentioned in the
comment (until .. dropped).

>
>> +    /// - The C code follows the usual shared reference requirements. That is, the kernel will never
>> +    ///   mutate or free the underlying object (excluding interior mutability that follows the usual
>> +    ///   rules) while Rust owns it.
>
> The concept "interior mutability" doesn't really exist on the C side.
> Also, use of interior mutability (by UnsafeCell) would be incorrect if
> the type is implemented in the rust side (as this requires a
> UnsafePinned).
>
> Interior mutability means things can be mutated behind a shared
> reference -- however in this case, we have a mutable reference (either
> `Pin<&mut Self>` or `&mut Self`)!
>
> Perhaps together with the next line, they could be just phrased like
> this?
>
> - The underlying object must not be accessed (read or mutated) through
>   any pointer other than the created `Owned<T>`.
>   Opt-out is still possbile similar to a mutable reference (e.g. by
>   using p`Opaque`]). 
>
> I think we should just tell the user "this is just a unique reference
> similar to &mut". They should be able to deduce that all the `!Unpin`
> that opts out from uniqueness of mutable reference applies here too.

I agree. I would suggest updating the struct documentation:

    @@ -108,7 +108,7 @@ pub unsafe trait Ownable {
        unsafe fn release(this: NonNull<Self>);
    }

    -/// An owned reference to an owned `T`.
    +/// An mutable reference to an owned `T`.
    ///
    /// The [`Ownable`] is automatically freed or released when an instance of [`Owned`] is
    /// dropped.

And then the safety requirement as

 An `Owned<T>` is a mutable reference to the underlying object. As such,
 the object must not be accessed (read or mutated) through any pointer
 other than the created `Owned<T>`. Opt-out is still possbile similar to
 a mutable reference (e.g. by using [`Opaque`]).


>> +    /// - In case `T` implements [`Unpin`] the previous requirement is extended from shared to
>> +    ///   mutable reference requirements. That is, the kernel will not mutate or free the underlying
>> +    ///   object and is okay with it being modified by Rust code.
>
> - If `T` implements [`Unpin`], the structure must not be mutated for
>   the entire lifetime of `Owned<T>`.

Would it be OK to just write "If `T: Unpin`, the ..."?

Again, opt out is possible, right?

>
>> +    pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {
>
> This needs a (rather trivial) INVARIANT comment.

OK.

>
>> +        Self {
>> +            ptr,
>> +        }
>> +    }
>> +
>> +    /// Consumes the [`Owned`], returning a raw pointer.
>> +    ///
>> +    /// This function does not actually relinquish ownership of the object. After calling this
>
> Perhaps "relinquish" isn't the best word here? In my mental model
> this function is pretty much relinquishing ownership as `Owned<T>` no
> longer exists. It just doesn't release the object.

How about this:


    /// Consumes the [`Owned`], returning a raw pointer.
    ///
    /// This function does not drop the underlying `T`. When this function returns, ownership of the
    /// underlying `T` is with the caller.


Thanks for the comments!


Best regards,
Andreas Hindborg




