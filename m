Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B924DEA4FCF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 15:01:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2775D6B008C; Mon, 23 Feb 2026 10:01:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 245196B0092; Mon, 23 Feb 2026 10:01:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 147ED6B0093; Mon, 23 Feb 2026 10:01:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 009E56B008C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 10:01:16 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 89EED1601DF
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:01:16 +0000 (UTC)
X-FDA: 84476034552.08.69CCAF9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8087B40006
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:01:14 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jG74L8zp;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771858874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yb3XjZN9k6iD1cT1ZLYAwHV8VQuVPAgyZFf29K+maSY=;
	b=LQT5guZihN2wwBi0EI9t57uasE5hNaTv78cYdM3JD+AOeUsrPZYz2Jp3rAHRv93qp+R1nd
	NxGsi3bpGGapTKFPZDaGmcmijWVZvwvFhOB+BL5DY+pOal5aFJFhTZKLLxraw0RCXDHTyx
	IBPyO2ShJ8c7fSwdHIxYoP0WEZH6Ryw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771858874; a=rsa-sha256;
	cv=none;
	b=pO/iyMKNTSCTyPBhrYmEdtYdzWuXEDCrsRoo+ANV20DdKLJc9P4L4HB4xXWiqn+YiFauoo
	nPRkDAcHEqyLkF3yMfk8kubu8D5J5pgLD2G4uPE3EzH6XbFj/URGoeDK19iK6mNqRCu0jx
	dls6ds1duVcrPaSr+wxmJjDFpFMj+xI=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jG74L8zp;
	spf=pass (imf17.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id DD35960054;
	Mon, 23 Feb 2026 15:01:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F9F1C4AF09;
	Mon, 23 Feb 2026 15:01:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771858873;
	bh=+OkF4cSWCJNdiF5CsX7iTxYUaQeVg6kTwnJIj8pgz8g=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=jG74L8zp/FnnR1Lf0m+mAJDrbPcsT++9hRX0XGunvt9GvdsjJh+bfbNJOa+uIit1K
	 X0KhxukpE06IrB9eKeOnjxrVHQTVmftx9RNS7STt7RshsqdiKRtVOuf4G9NEV4tJz3
	 PujNQxbv93TPYnYYhE3n1F5oqJKG4vmMXRC1nRD04BI1KV1s6uJhcB6AJ0TkBKkxbW
	 ePQEkUdkwobo8EKqTuxmEu4Ww3QF9zongUPIdlG+oEg4S44x4LDuj5TM7LPEb1psux
	 kirnfscubPKNmJaYqynAdub+KM2YIhojSYzldFuc8o/bqHXb+CbNo2U6bkgKwFuMKN
	 AecqPLLUaWu3A==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman
 <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>,
 Jan Kara <jack@suse.cz>, Igor Korotin <igor.korotin.linux@gmail.com>,
 Daniel Almeida <daniel.almeida@collabora.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen
 Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Boqun Feng
 <boqun@kernel.org>,
 linux-kernel@vger.kernel.org, rust-for-linux@vger.kernel.org,
 linux-block@vger.kernel.org, linux-security-module@vger.kernel.org,
 dri-devel@lists.freedesktop.org, linux-fsdevel@vger.kernel.org,
 linux-mm@kvack.org, linux-pm@vger.kernel.org, linux-pci@vger.kernel.org,
 Asahi Lina <lina+kernel@asahilina.net>, Oliver Mangold
 <oliver.mangold@pm.me>
Subject: Re: [PATCH v15 1/9] rust: types: Add Ownable/Owned types
In-Reply-To: <aZg44EmMWKK-z5KP@google.com>
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
 <20260220-unique-ref-v15-1-893ed86b06cc@kernel.org>
 <aZg44EmMWKK-z5KP@google.com>
Date: Mon, 23 Feb 2026 15:59:22 +0100
Message-ID: <87wm0333qt.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Rspam-User: 
X-Stat-Signature: j53631mro5qoske8whcnnhzjz1x6bdc5
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8087B40006
X-HE-Tag: 1771858874-706253
X-HE-Meta: U2FsdGVkX19bcoqoj4E9AfLZwgKyEVQzfj9MCtXutDpcq5aZtMBups80A/r9T+cD8VgZBjp9ol81QCzclAG8NeFBZOiQlkBkp/08zvcPRDkVSuRjiMSXtXQptZ+nnden1mknpyIFvmXUMQABEz2hYJXznrDcNutKyYtUQvLoJ5s3XgKo+3sxMDh8sryioyacRp1WQUJKw/ZMbNim/v+FSQrUmUVnkqvcF8Wp7cSDT2UqIO+Hu/lEQfUGrjVAgouz7zmZzXDhICIx5C27MRecy3oCZawkVUnj1JG6f592Zy5gKmHeKNtl4hxXboE+qavDThli+MBdQNjITR6Eu02aNRhYhcE7oYlm9VueOiyI8ZhKLSuYA6yIHarIonvGQvvkNdnB6nEwA3xpDWjshHWN0J9SUQciyMEAz1GgFcs/PepvuEpLPXh008KdTD2jCMG24ejyiiqOGwBv/AX6w+MnJUB2YqyrjboM/K+wO2stE1UmRwuroltOm9buauy6BCvKcNgan0RZFgWhx+qjB1bS8A4eLwJBarxw0BfZleuzefTbk/wh1bElAgP16n1q6ArBbYXp9cnQuHk1/KSwROEPZOx6ZLMulZmvhvYwGzco1MJPvMUGBTPHWTlnlFas+CitxbOTBIlGNt/+eFpad0GxYVROAH3tpPWxBQNAZ83H3QZ5FKZM7KBzFD2/N/HtBMNj7ghTtRn1gPkz5xUwduwKQaIZTYJl3W0Eks3TP+nTAhB2A52AH4WvgmkfzLMS5H+vqslS6AZKn2ob2aKJEzu3e8jqk1lZS7zPfTX3Y7C6ikoY9JTEak8XAkeBHRIGfI4QPJdIhxxebw8YgGOsuIUyFDLfOlmrV44CbkYTn68GMqjZulBo6sk2tqaGCXrpTGihFJ4M8hJXsGi2Nzvmh64laEYiJEFeU4NxfxAHqlNqWYdvlIyIxrnslg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Alice Ryhl <aliceryhl@google.com> writes:

> On Fri, Feb 20, 2026 at 10:51:10AM +0100, Andreas Hindborg wrote:
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
>> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
>> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
>> [ Andreas: Updated documentation, examples, and formatting ]
>> Reviewed-by: Gary Guo <gary@garyguo.net>
>> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
>> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>
>> +///         let result = NonNull::new(KBox::into_raw(result))
>> +///             .expect("Raw pointer to newly allocation KBox is null, this should never happen.");
>
> KBox should probably have an into_raw_nonnull().

I can add that.

>
>> +///    let foo = Foo::new().expect("Failed to allocate a Foo. This shouldn't happen");
>> +///    assert!(*FOO_ALLOC_COUNT.lock() == 1);
>
> Use ? here.

Ok.

>
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
>
> Honestly, not using it after this call may be too strong. I can imagine
> wanting a value where I have both an ARef<_> and Owned<_> reference to
> something similar to the existing Arc<_>/ListArc<_> pattern, and in that
> case the value may in fact be accessed after this call if you still have
> an ARef<_>.

I do not understand your use case.

You are not supposed to have both an `ARef` and an `Owned` at the same
time. The `Owned` is to `ARef` what `UniqueArc` is to `Arc`. It is
supposed to be unique and no `ARef` can be live while the `Owned` is
live.

A `ListArc` is "at most one per list link" and it takes a refcount on
the object by owning an `Arc`. As far as I recall, it does not provide
mutable access to anything but the list link. To me, that is a very
different situation.

>
> If you modify Owned<_> invariants and Owned::from_raw() safety
> requirements along the lines of what I say below, then this could just
> say that the caller must have permission to call this function. The
> concrete implementer can specify what that means more directly, but here
> all it means is that a prior call to Owned::from_raw() promised to give
> you permission to call it.

I don't think we need the "permission" wording. How about this:


/// A mutable reference to an owned `T`.
///
/// The [`Ownable`] is automatically freed or released when an instance of [`Owned`] is
/// dropped.
///
/// # Invariants
///
/// - Until `T::release` is called, this `Owned<T>` exclusively owns the underlying `T`.
/// - The `T` value is pinned.
pub struct Owned<T: Ownable> {...}


impl<T: Ownable> Owned<T> {
    /// Creates a new instance of [`Owned`].
    ///
    /// This function takes over ownership of the underlying object.
    ///
    /// # Safety
    ///
    /// Callers must ensure that:
    /// - `ptr` points to a valid instance of `T`.
    /// - Until `T::release` is called, the returned `Owned<T>` exclusively owns the underlying `T`.
    pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {...}
}

pub trait Ownable {
    /// Tear down this `Ownable`.
    ///
    /// Implementers of `Ownable` can use this function to clean up the use of `Self`. This can
    /// include freeing the underlying object.
    ///
    /// # Safety
    ///
    /// Callers must ensure that the caller has exclusive ownership of `T`, and this ownership can
    /// be transferred to the `release` method.
    unsafe fn release(&mut self);
}


Note `Ownable` not being an unsafe trait.

>
>> +/// A mutable reference to an owned `T`.
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
>
> I think some more direct and less fuzzy invariants would be:
>
> - This `Owned<T>` holds permissions to call `T::release()` on the value once.
> - Until `T::release()` is called, this `Owned<T>` may perform mutable access on the `T`.

I do not like the wording for mutable access. Formulating safety
requirements for `from_raw` and safety comments for that function
becomes convoluted like this. I'd rather formulate the
access capability in terms of ownership;

 - Until `T::release()` is called, this `Owned<T>` exclusively owns the
   underlying `T`.

How is that?

> - The `T` value is pinned.

I am unsure about the pinning terminology. If we say that `T` is pinned,
does this mean that it will never move, even if `T: Unpin`? Or is it
implied that `T` may move if it is `Unpin`?

>
>> +    /// Get a pinned mutable reference to the data owned by this `Owned<T>`.
>> +    pub fn as_pin_mut(&mut self) -> Pin<&mut T> {
>> +        // SAFETY: The type invariants guarantee that the object is valid, and that we can safely
>> +        // return a mutable reference to it.
>> +        let unpinned = unsafe { self.ptr.as_mut() };
>> +
>> +        // SAFETY: We never hand out unpinned mutable references to the data in
>> +        // `Self`, unless the contained type is `Unpin`.
>> +        unsafe { Pin::new_unchecked(unpinned) }
>
> I'd prefer if "pinned" was a type invariant, rather than make an
> argument about what kind of APIs exist.

Ok.

>
>> +impl<T: Ownable + Unpin> DerefMut for Owned<T> {
>> +    fn deref_mut(&mut self) -> &mut Self::Target {
>> +        // SAFETY: The type invariants guarantee that the object is valid, and that we can safely
>> +        // return a mutable reference to it.
>> +        unsafe { self.ptr.as_mut() }
>
> Surely this safety comment should say something about pinning.

Yes.


Best regards,
Andreas Hindborg



