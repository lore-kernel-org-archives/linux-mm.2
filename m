Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B47EBE9B250
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 10:42:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB9EF6B0088; Tue, 24 Feb 2026 05:42:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C39C76B0089; Tue, 24 Feb 2026 05:42:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B12A66B008A; Tue, 24 Feb 2026 05:42:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9F2EC6B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 05:42:23 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5014CB9B56
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:42:23 +0000 (UTC)
X-FDA: 84479010966.27.15CE047
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id BDF6140006
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 10:42:21 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GAU2pdQX;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771929741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l1lazE3GeLspSJ5klzlH6zh+sozmUgtioWY6hynkkqY=;
	b=3Xo4Ald29hR0vMryp4+xqe9GUVMudrA9qUVkP5xBFXLosVIx/uYmBjau91N590C8SFHTj5
	/XKUmwlBKBSkVb5PEGcPxSWnbI8Jg1TBh0keUJ11nffPCqUwvkQqWZ6ndg88Dm7mxZ3aBD
	9NgLJ8ZV4p12A8TclceGQoR2zRlmTN0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=GAU2pdQX;
	spf=pass (imf01.hostedemail.com: domain of a.hindborg@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=a.hindborg@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771929741; a=rsa-sha256;
	cv=none;
	b=5FEA7CBngbrZv7ULYnhKlaeEMgqjTHDn/IluvwOKORVjoY9EqJZIc6wjcBWacyyR9vP/83
	55zXMqcbljViFNxZQKvdD5aSVBoXvlLQW5KxdvxlIhHocMuXwUq1+a9OrfmLBDvOJj5hRm
	TJ1B1NhsqG3zJmxE8zVe/C+E3SPXEdM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 2E8F761335;
	Tue, 24 Feb 2026 10:42:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 158D2C116D0;
	Tue, 24 Feb 2026 10:42:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771929740;
	bh=EdYMSneYGYWOu2MY/gnpVM4ln8olb1RiXGDKI2avrXU=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=GAU2pdQXeucHDr93YOJlBQA+9WyQyiqX3XUv0GPdy5+63ewH++MkxyrNYQumwLA4W
	 YPvSJkU9bCvwg0PQISCbL7pQ53LDJwxCiV6mlupfv3XGnYbITTh1piGzZ+A4mlBMuk
	 4BLlREPZdKFZhle5va0yKY3MgMD1Ru8Hzm9tCf+z8+JaypVhehj82iMeu/g36i61cS
	 LOK6GF96u2rd6HmI4kigzcpkbtJ/Mu3uUKlP3KL6U4B3ccmjM1712HCHbTYCUdiqco
	 kxP5N90jQc3VZcobz2Hi+vK6uI3CzGRjwp0bzDuDcBOAuwMIDp5V4VWUl94VWRudG1
	 gdUVkzkXXqWYQ==
From: Andreas Hindborg <a.hindborg@kernel.org>
To: aliceryhl@google.com
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>,
 =?utf-8?Q?Bj=C3=B6rn?= Roy
 Baron <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, Trevor
 Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, Greg
 Kroah-Hartman <gregkh@linuxfoundation.org>, Dave
 Ertman <david.m.ertman@intel.com>, Ira Weiny <ira.weiny@intel.com>, Leon
 Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, Serge
 Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David
 Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>, Alexander
 Viro <viro@zeniv.linux.org.uk>, Christian
 Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, Igor Korotin
 <igor.korotin.linux@gmail.com>, Daniel Almeida
 <daniel.almeida@collabora.com>, Lorenzo Stoakes
 <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, Stephen
 Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, Krzysztof
 =?utf-8?Q?Wilczy=C5=84ski?= <kwilczynski@kernel.org>, Boqun
 Feng <boqun@kernel.org>, linux-kernel@vger.kernel.org,
 rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org,
 linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org,
 linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
 linux-pm@vger.kernel.org, linux-pci@vger.kernel.org, Asahi Lina
 <lina+kernel@asahilina.net>, Oliver Mangold <oliver.mangold@pm.me>
Subject: Re: [PATCH v15 1/9] rust: types: Add Ownable/Owned types
In-Reply-To: <aZ1VQmtapuoerpVo@google.com>
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
 <20260220-unique-ref-v15-1-893ed86b06cc@kernel.org>
 <aZg44EmMWKK-z5KP@google.com>
 <87wm0333qt.fsf@t14s.mail-host-address-is-not-set>
 <IFU05rWmgywK-tzaInc7eF2Kmy1zf-BDkCrQZfRI_2JN6E0-p3zFaUMu3V6T1YTeQG9xC1hHzXThLCORJqpoWA==@protonmail.internalid>
 <aZ1VQmtapuoerpVo@google.com>
Date: Tue, 24 Feb 2026 11:41:45 +0100
Message-ID: <87a4wy2zkm.fsf@t14s.mail-host-address-is-not-set>
MIME-Version: 1.0
Content-Type: text/plain
X-Stat-Signature: nik83dx8chstxd71rij66orqzr8i3doa
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: BDF6140006
X-HE-Tag: 1771929741-44912
X-HE-Meta: U2FsdGVkX1+32/WPVTq1X5cfEbT+E6HbcFKuevF1Klei7fGJronT92wueye1tpe2oOJ7ukAj66vZSVZxDdFLma31TzhkV7avsnXQFrsE6Lnfj+6xTlIhqk46yw5g/kR5eCoojp+dT0u21skdQJNzsCHR5hPsFzlPnnhnXdGM1spzdHRkKOpgh5bBOnmkx2MYwayw6GZQBWdHEK4MXOy5STdKVWx3/aNfTyEU2EIlxt3NotL56cK3Uv3Zatbc++dambX4AeIBWRors4CMorGU+OjHPBdEi8AnsWD7555I78/Al6KKXXqqtZ80uRBVMCC+OkgAQ0UP65jl/chhTnF0soxGprJSx+7BCpuyNiHYxDIf8CTtAxTHVEjkw52Z3jpaob21pmNSpn+vYKyiQ4UyS1DqPVXQCgWGvVFD3ICKV2grkE0JYcT/sYNxFUIZFOkCR2Kxh1MEiV92ywX4fBb/3AUQYBkc2Lg8ZVJRjfBv5rBlyqnLW2vemWDRBcEd6rYjUy/dhuy5Q5R8NY5nCZvy+oCbG/zBxMr4iMwrDZjzbQt/kvaaxOXkh/+EGVa6PodlwOsgoP6g66bGmvZvLWCC7S0KqMBcljWNQ1AFiMHIoeClB2oBLAGxeB42klmtKgu6OoCoysxxg2xZSwZJlPWnVkLR4CEe5uAF5IvZ2+tnFV1PJgHM5MEPotsdSG/5KYMASdTBiuXD6UknPvLlNT5KIIWNkAB1EbmVafS9keLNFW/s3SZi0OEF6SGm0LIvmcrGOY3Ipkb9p1Z25+Y9+PhngtFoNug38xyD9iYGOa6H/C4TIeYMq4eMCPbEHelso9Ynn/FcuyykBUsAh0nakibLnHJdsHWakVR/l0CG9qhJu26/t5xmRUPu9l9DeP8vFm92P4L44qEB6kAuZxfmHLyTUrzXZmY3fiFLjRqbDNyJ8AVvD5STNdrOxW78MNJn/C+4YhNxdJOBOSA9lV6qhMP
 TeP3W8Vw
 /dnFZSbI5mDtAyrQG3vMWQqq0BTIZCnJJARm+L3aPUwLykHjYsmAmzzb3mC+kqrxoDKkaxH4dqr4BzX1vfa6BssJKn+4rRP6Av0y6XJeGnrzftQtlwBB91kwiwtZ7/j4ouPd6vBcS0vmYKVVKjsJYkcG1euHsiolle/j6Y4c79ws9TcTygJdhorWZSOF2aWKwyGC4piMuMXLyFnvlo2ouCDKFqUfABIQ9b/yA/d3U+S9cupgdq93MV39KNAD3B+B4z3TQ33z7JFxA0hgm9+l6oCN6aHKJavMEh40M0kyyYGuH9lDsg3z3w/OvamvB8gkP6x1P1P0Nbi8zgegP3Ja5I/k8qMb2LDBJkGeulMb/MkVYBaQTbZq+Opa0K43rSR72kwZCRjLrKpm9eM86rgL9iSpJljIFOf4MgYIy10B6nLxhbJ8BqsyCnT3jWrF5GxqEh4auWaiQSYZ9d4rfueNRF92t/qZTvinR3q1SaN2HedCOAFY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

<aliceryhl@google.com> writes:

> On Mon, Feb 23, 2026 at 03:59:22PM +0100, Andreas Hindborg wrote:
>> Alice Ryhl <aliceryhl@google.com> writes:
>>
>> > On Fri, Feb 20, 2026 at 10:51:10AM +0100, Andreas Hindborg wrote:
>> >> From: Asahi Lina <lina+kernel@asahilina.net>
>> >>
>> >> By analogy to `AlwaysRefCounted` and `ARef`, an `Ownable` type is a
>> >> (typically C FFI) type that *may* be owned by Rust, but need not be. Unlike
>> >> `AlwaysRefCounted`, this mechanism expects the reference to be unique
>> >> within Rust, and does not allow cloning.
>> >>
>> >> Conceptually, this is similar to a `KBox<T>`, except that it delegates
>> >> resource management to the `T` instead of using a generic allocator.
>> >>
>> >> [ om:
>> >>   - Split code into separate file and `pub use` it from types.rs.
>> >>   - Make from_raw() and into_raw() public.
>> >>   - Remove OwnableMut, and make DerefMut dependent on Unpin instead.
>> >>   - Usage example/doctest for Ownable/Owned.
>> >>   - Fixes to documentation and commit message.
>> >> ]
>> >>
>> >> Link: https://lore.kernel.org/all/20250202-rust-page-v1-1-e3170d7fe55e@asahilina.net/
>> >> Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
>> >> Co-developed-by: Oliver Mangold <oliver.mangold@pm.me>
>> >> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
>> >> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
>> >> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
>> >> [ Andreas: Updated documentation, examples, and formatting ]
>> >> Reviewed-by: Gary Guo <gary@garyguo.net>
>> >> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
>> >> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
>> >
>> >> +///         let result = NonNull::new(KBox::into_raw(result))
>> >> +///             .expect("Raw pointer to newly allocation KBox is null, this should never happen.");
>> >
>> > KBox should probably have an into_raw_nonnull().
>>
>> I can add that.
>>
>> >
>> >> +///    let foo = Foo::new().expect("Failed to allocate a Foo. This shouldn't happen");
>> >> +///    assert!(*FOO_ALLOC_COUNT.lock() == 1);
>> >
>> > Use ? here.
>>
>> Ok.
>>
>> >
>> >> +/// }
>> >> +/// // `foo` is out of scope now, so we expect no live allocations.
>> >> +/// assert!(*FOO_ALLOC_COUNT.lock() == 0);
>> >> +/// ```
>> >> +pub unsafe trait Ownable {
>> >> +    /// Releases the object.
>> >> +    ///
>> >> +    /// # Safety
>> >> +    ///
>> >> +    /// Callers must ensure that:
>> >> +    /// - `this` points to a valid `Self`.
>> >> +    /// - `*this` is no longer used after this call.
>> >> +    unsafe fn release(this: NonNull<Self>);
>> >
>> > Honestly, not using it after this call may be too strong. I can imagine
>> > wanting a value where I have both an ARef<_> and Owned<_> reference to
>> > something similar to the existing Arc<_>/ListArc<_> pattern, and in that
>> > case the value may in fact be accessed after this call if you still have
>> > an ARef<_>.
>>
>> I do not understand your use case.
>>
>> You are not supposed to have both an `ARef` and an `Owned` at the same
>> time. The `Owned` is to `ARef` what `UniqueArc` is to `Arc`. It is
>> supposed to be unique and no `ARef` can be live while the `Owned` is
>> live.
>>
>> A `ListArc` is "at most one per list link" and it takes a refcount on
>> the object by owning an `Arc`. As far as I recall, it does not provide
>> mutable access to anything but the list link. To me, that is a very
>> different situation.
>
> I mean, even Page is kind of an example like that.
>
> Pages are refcounted, but when you have a higher-order page, the
> __free_pages() call does something special beyond what put_page(). For
> example, if you have an order-2 page, which consists of 4 pages, then
> the refcount only keeps the first page alive, and __free_pages() frees
> the 3 extra pages right away even if refcount is still non-zero. The
> first page then stays alive until the last put_page() is called.

I see. We currently only support order 0 pages. I think we can handle
this situation later, if we need to handle higher order pages.

In that case, we could hand out `Owned<Page>` for the head page and then
provide some way of getting a `&Page` for the tail pages. Obtaining
`Owned<Page>` for a tail page does not make sense.

More likely we will build an abstraction for `struct folio`. We can
still hand some kind of page reference for tail pages from an `Owned<Folio>`.

Best regards,
Andreas Hindborg



