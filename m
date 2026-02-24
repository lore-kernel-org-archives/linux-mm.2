Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B2EEFB812
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 07:37:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 17FB16B0088; Tue, 24 Feb 2026 02:37:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 103F36B0089; Tue, 24 Feb 2026 02:37:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26CE6B008A; Tue, 24 Feb 2026 02:37:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DA9376B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:37:43 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 89A818B994
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:37:43 +0000 (UTC)
X-FDA: 84478545606.17.BBA2584
Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	by imf14.hostedemail.com (Postfix) with ESMTP id B0175100003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 07:37:41 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1jLkFrgk;
	spf=pass (imf14.hostedemail.com: domain of 3Q1WdaQkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Q1WdaQkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771918661;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ccaw3Qp4EtXU0xb2rrWk95YgoDmXX+bj8GIv5SpCaTk=;
	b=vd0NKmhdiQg2Tg1tbeO1YDNvfJ9zOkVmOja1e8g5BerecbAyayC5I6vF6J1cicmRgI8DpB
	PsYtimvQD9HW26rtuQ6sFDA/mv1ZEAvtYgF1zgdp41I8nzkF9uhZ0OV1MBnX/YEp4rnck6
	3mG3QpTs/pblmsI4HgFPbAMr4rxJz7M=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=1jLkFrgk;
	spf=pass (imf14.hostedemail.com: domain of 3Q1WdaQkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com designates 209.85.128.73 as permitted sender) smtp.mailfrom=3Q1WdaQkKCLYWheYanudhckkcha.Ykihejqt-iigrWYg.knc@flex--aliceryhl.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771918661; a=rsa-sha256;
	cv=none;
	b=yo94xKnr/x9jKnBdT7o2snmN/76hZqkw90fzo9caMLmF8vQ/Xp/6+Xk7x3POLrcfr1Fa1d
	A5DlStDGlGXZY2ISCGWT85hxMFhgcQWFSwelH9ebGh6C5GS9BwLzp6RvisoySKZN5nZMXd
	ZFDWmTfXNdOFlDRg6tGECaN53Ud2gA4=
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-4836e35292cso42944275e9.1
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:37:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771918660; x=1772523460; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :f2079rom:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ccaw3Qp4EtXU0xb2rrWk95YgoDmXX+bj8GIv5SpCaTk=;
        b=1jLkFrgkMfDGtq0oexOecyr2mtvgT/OhN5Wji4khTLgFI520Bx9JOUNsUs2D0zRjLv
         DSDGIxLu4t3XYZfbpFtGN5As+mt38I7I3oJsOUzcDByLBU3DI7Tkdv/vs94wCLnr7MTp
         rO+26dMARQIFISg1BXjooiMgmwVvXVRgfgkXGVIWmPY38BGqsiAOFaid0QPbEpGDZ20X
         nK7IvvafFKO0nGvUAjPswAJQIWlDTvRiUI49IVx5NsvJoCZ0m+AzjCnLyyKlx0VoQJLl
         veQLPIEOeSpYEYrHbng21LzMnehSO8US0LhG134GbHCZjyoS/KYHuztwnflhelATmIvL
         kalg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771918660; x=1772523460;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :f2079rom:date:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Ccaw3Qp4EtXU0xb2rrWk95YgoDmXX+bj8GIv5SpCaTk=;
        b=wS/xR/0Jfs2NIdns4RyexWgEEx8DfKXtJ6G2iFLGnP9KwY/HUTdMyIpSI1za4vuNnA
         2qktCIz7GMHLqXTcWb20aBd87oxyonrSmu3rGBC+p98kQ+07ElAvZ9gsfSffMDYJ7U+3
         4lNk2atSTamwFrcgGMR7HILyhMNNvcFjEdXM1Ca1cpQFvker9vYiBDeJpWhZ1i6PPkdA
         mWIVNnJ7r2kK/jmVvS25DWlqoWEoDruO285W0bLNQhFvMt9Z75MZOLW19HRGFYsfCeSd
         jvQgkTS8uIypnAkBiXmvNiRyIbjRJvJNrunAKtU2CuZoP9IKBgXaqTb8oHFfq4SwCyAX
         +ENg==
X-Forwarded-Encrypted: i=1; AJvYcCVQXftlv+zGwtv5blTn1njeKbDRtQsk6rmc0cOXbCIauRxoPJNLeVlZI65UnrrcP0hGCSYC+7Cwmg==@kvack.org
X-Gm-Message-State: AOJu0YwWNAXzGO+i4+D/A2gEuNfm/smXF8t5NPkRYscGUiR4o2qlkn+C
	MR0ebQAjJWIDu9BalJGfpSOqm56JcDhwgFLHGkyJ+H9VgkRhz9C2YGA4WbJwqD+nm2DYsua4CGP
	5udhG/B5rraymt+iusg==
X-Received: from wmxb5-n2.prod.google.com ([2002:a05:600d:8445:20b0:483:43dc:999f])
 (user=aliceryhl job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:674f:b0:483:6ff1:18b with SMTP id 5b1f17b1804b1-483a9555bafmr189459985e9.0.1771918659820;
 Mon, 23 Feb 2026 23:37:39 -0800 (PST)
Date: Tue, 24 Feb 2026 07:37:38 +0000
F2079rom: Alice Ryhl <aliceryhl@google.com>
In-Reply-To: <87wm0333qt.fsf@t14s.mail-host-address-is-not-set>
Mime-Version: 1.0
References: <20260220-unique-ref-v15-0-893ed86b06cc@kernel.org>
 <20260220-unique-ref-v15-1-893ed86b06cc@kernel.org> <aZg44EmMWKK-z5KP@google.com>
 <87wm0333qt.fsf@t14s.mail-host-address-is-not-set>
Message-ID: <aZ1VQmtapuoerpVo@google.com>
Subject: Re: [PATCH v15 1/9] rust: types: Add Ownable/Owned types
From: <aliceryhl@google.com>
To: Andreas Hindborg <a.hindborg@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>, Gary Guo <gary@garyguo.net>, 
	"=?utf-8?B?QmrDtnJu?= Roy Baron" <bjorn3_gh@protonmail.com>, Benno Lossin <lossin@kernel.org>, 
	Trevor Gross <tmgross@umich.edu>, Danilo Krummrich <dakr@kernel.org>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dave Ertman <david.m.ertman@intel.com>, 
	Ira Weiny <ira.weiny@intel.com>, Leon Romanovsky <leon@kernel.org>, Paul Moore <paul@paul-moore.com>, 
	Serge Hallyn <sergeh@kernel.org>, "Rafael J. Wysocki" <rafael@kernel.org>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
	Igor Korotin <igor.korotin.linux@gmail.com>, 
	Daniel Almeida <daniel.almeida@collabora.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Viresh Kumar <vireshk@kernel.org>, Nishanth Menon <nm@ti.com>, 
	Stephen Boyd <sboyd@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	"Krzysztof =?utf-8?Q?Wilczy=C5=84ski?=" <kwilczynski@kernel.org>, Boqun Feng <boqun@kernel.org>, linux-kernel@vger.kernel.org, 
	rust-for-linux@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-security-module@vger.kernel.org, dri-devel@lists.freedesktop.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org, 
	linux-pci@vger.kernel.org, Asahi Lina <lina+kernel@asahilina.net>, 
	Oliver Mangold <oliver.mangold@pm.me>
Content-Type: text/plain; charset="utf-8"
X-Stat-Signature: 86b9tbjnmenjzy7smhugxqimouwjf8hf
X-Rspam-User: 
X-Rspamd-Queue-Id: B0175100003
X-Rspamd-Server: rspam01
X-HE-Tag: 1771918661-51350
X-HE-Meta: U2FsdGVkX195HDwYfB9YzuU9mcp73nG3617x6pT2Cd9i1uMnAJmEd2WAN8BB1rieK5NYBM6wvNkiDOdbCGI34vo8IaleTF+8oPqCC+fAwp3t88gkaGbBRrq+eKqNaKnnah4FQHx0bs199D8BfOtP6E6OFG+bX5LDED4AwUg6U2t0iCYBLqMeJYjiVqS96aza5W+VyNE1EYy2d/UaBdsmJbXbJEG2x87yZd9l1+WIwRwxn/m12lC2aekk+/NEMoBlMTMd0OA5RegLdbKsBzdKZ8v5zYSoZF7K3fZNPqpAbR8d48KK2a8mxYrD9wEQzMfgYOwetJa6D1jQH6Fp3QoFrZIVhadleNnLLzF6cp1a5VJ8Pixjd5PeBXz6FTFERa8K/W8QMAdilYo4n5sRdJNB+fDKrjwoj54RAt85lSzQxpN0bUGjE/KiRlSTeNt2g/Hx5z6980RTu8k3loi72078a9bU75wkI/VQ68u4Tgi0zDhUtEFa6Oo3p6IhismDAWyHdyCm2tDfstu2/uy/zn9EyEgxnH09z7soSnlxL8NAFhJpns1hnBuk3F/P8yqy1skXOOfAJf+fVMx9aCUQgOGu4+nAUqRFYj2TE88faILxDtUrh8uS/x2LA60/JLwE5J3VzdWqBGwjHeI8GzgVilEv2+zPcpLfvSNLy5AYsXJC8FuErk1/k9D7CXYbk970C33KJQIHMuOQyR3iDnyJhsQeMi+zlW54zQ/gCK65s7py566FkS1dVCWYehfRndi3Wzmvc3X8J714yxsbOrUwar824eD2gA1WozjWl7Xd83cAszU56uNMjxoHP3ucncO4d2m2N9sgzzuWl6vvai56tR0OrdJLvKaqltGOw4PtHUrXFK7yvFct6p467ERJHgPvXddTF0hbp0/z6CJ4rIUwsxaPEx9xH2LrjnZeZ128Nl97pwkoMixOF67FeHbLpEpVt5l2q4ceNenb4kIZdZn7gOP
 kwmDEmY8
 tXKsR0CPXseFIn19Bv08Bm2qks/Ma2NT1YbQzpvTG8JjMwjT/XawhiJ/IV7rDkNb3TdHTpfq2B3WEqTQZPOJLHKZfVm1kE5yTWGo+/2XPk5JfOeKSfcj9oyQXn5dF2VhN3NtZkw11a6DwfKwYzbcsdklY6LEZ8rhfu2jPxZr3OMDF3iJNrkOui/K8NEO3vRjkDt71gGDk+YS+7BX5R4kNMEIJ7W5K3lTcIBXVa7gFfTZEuOPM2KtmM4iPbo4xAPGGIeaiZEDcxRjarYZkZV5o3uYLQ/8AwxoIldQ0g34EQQnPa+716wapX9Uj54ADHsKRHfonrOrhFEigoxzTmGvX96HwSrvGJBld7JMHgoiPJTavCbSDqCwPjXOOB2HH3muHCpXepLkHsQs4P6BXJ6INbSpZjnURGntzW7QyPF/iqmrnkj/9Ms/+A42Fg0tKLvCewU3V7eFm8jWiOCOytsZACTP99jt0Z8cFdYN6sP4t8kt3s2n5iVuoshhngF3/xMDLyqj7aYNt12RQFLud+utVL4QteAl5YN2Ed0bj9P24uGkqDkxPYKw+fvOiZc3PhXE0WyNCnXSqVMZDVVN4vN9Vv0wKQMExtHSh72rtFYJ39t6aH410zua9CYQObpkLy8YbN0qf6Wl36GjqS68ojK/cnndfcMueNrl9N36MZZC7w3ysUmpauu1j5e1ERsI6YQ/HvTt0QSCynFrJc5z9cUpdYuuiwLTLnukqQLSh5lYjurlL9++R7zpKilDB63FAz57koCr2DNA+PeM9/nedPeHfdB2zc3SgDHaFzXzBYOzLadCkUQbYIWTe3kfJAsj3O309Whs1rW8YCzS2fck5cwoy0W5H3zANmIbj7JHI2elZbIO0SGY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 03:59:22PM +0100, Andreas Hindborg wrote:
> Alice Ryhl <aliceryhl@google.com> writes:
> 
> > On Fri, Feb 20, 2026 at 10:51:10AM +0100, Andreas Hindborg wrote:
> >> From: Asahi Lina <lina+kernel@asahilina.net>
> >> 
> >> By analogy to `AlwaysRefCounted` and `ARef`, an `Ownable` type is a
> >> (typically C FFI) type that *may* be owned by Rust, but need not be. Unlike
> >> `AlwaysRefCounted`, this mechanism expects the reference to be unique
> >> within Rust, and does not allow cloning.
> >> 
> >> Conceptually, this is similar to a `KBox<T>`, except that it delegates
> >> resource management to the `T` instead of using a generic allocator.
> >> 
> >> [ om:
> >>   - Split code into separate file and `pub use` it from types.rs.
> >>   - Make from_raw() and into_raw() public.
> >>   - Remove OwnableMut, and make DerefMut dependent on Unpin instead.
> >>   - Usage example/doctest for Ownable/Owned.
> >>   - Fixes to documentation and commit message.
> >> ]
> >> 
> >> Link: https://lore.kernel.org/all/20250202-rust-page-v1-1-e3170d7fe55e@asahilina.net/
> >> Signed-off-by: Asahi Lina <lina+kernel@asahilina.net>
> >> Co-developed-by: Oliver Mangold <oliver.mangold@pm.me>
> >> Signed-off-by: Oliver Mangold <oliver.mangold@pm.me>
> >> Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
> >> Reviewed-by: Daniel Almeida <daniel.almeida@collabora.com>
> >> [ Andreas: Updated documentation, examples, and formatting ]
> >> Reviewed-by: Gary Guo <gary@garyguo.net>
> >> Co-developed-by: Andreas Hindborg <a.hindborg@kernel.org>
> >> Signed-off-by: Andreas Hindborg <a.hindborg@kernel.org>
> >
> >> +///         let result = NonNull::new(KBox::into_raw(result))
> >> +///             .expect("Raw pointer to newly allocation KBox is null, this should never happen.");
> >
> > KBox should probably have an into_raw_nonnull().
> 
> I can add that.
> 
> >
> >> +///    let foo = Foo::new().expect("Failed to allocate a Foo. This shouldn't happen");
> >> +///    assert!(*FOO_ALLOC_COUNT.lock() == 1);
> >
> > Use ? here.
> 
> Ok.
> 
> >
> >> +/// }
> >> +/// // `foo` is out of scope now, so we expect no live allocations.
> >> +/// assert!(*FOO_ALLOC_COUNT.lock() == 0);
> >> +/// ```
> >> +pub unsafe trait Ownable {
> >> +    /// Releases the object.
> >> +    ///
> >> +    /// # Safety
> >> +    ///
> >> +    /// Callers must ensure that:
> >> +    /// - `this` points to a valid `Self`.
> >> +    /// - `*this` is no longer used after this call.
> >> +    unsafe fn release(this: NonNull<Self>);
> >
> > Honestly, not using it after this call may be too strong. I can imagine
> > wanting a value where I have both an ARef<_> and Owned<_> reference to
> > something similar to the existing Arc<_>/ListArc<_> pattern, and in that
> > case the value may in fact be accessed after this call if you still have
> > an ARef<_>.
> 
> I do not understand your use case.
> 
> You are not supposed to have both an `ARef` and an `Owned` at the same
> time. The `Owned` is to `ARef` what `UniqueArc` is to `Arc`. It is
> supposed to be unique and no `ARef` can be live while the `Owned` is
> live.
> 
> A `ListArc` is "at most one per list link" and it takes a refcount on
> the object by owning an `Arc`. As far as I recall, it does not provide
> mutable access to anything but the list link. To me, that is a very
> different situation.

I mean, even Page is kind of an example like that.

Pages are refcounted, but when you have a higher-order page, the
__free_pages() call does something special beyond what put_page(). For
example, if you have an order-2 page, which consists of 4 pages, then
the refcount only keeps the first page alive, and __free_pages() frees
the 3 extra pages right away even if refcount is still non-zero. The
first page then stays alive until the last put_page() is called.

> > If you modify Owned<_> invariants and Owned::from_raw() safety
> > requirements along the lines of what I say below, then this could just
> > say that the caller must have permission to call this function. The
> > concrete implementer can specify what that means more directly, but here
> > all it means is that a prior call to Owned::from_raw() promised to give
> > you permission to call it.
> 
> I don't think we need the "permission" wording. How about this:
> 
> 
> /// A mutable reference to an owned `T`.
> ///
> /// The [`Ownable`] is automatically freed or released when an instance of [`Owned`] is
> /// dropped.
> ///
> /// # Invariants
> ///
> /// - Until `T::release` is called, this `Owned<T>` exclusively owns the underlying `T`.
> /// - The `T` value is pinned.
> pub struct Owned<T: Ownable> {...}
> 
> 
> impl<T: Ownable> Owned<T> {
>     /// Creates a new instance of [`Owned`].
>     ///
>     /// This function takes over ownership of the underlying object.
>     ///
>     /// # Safety
>     ///
>     /// Callers must ensure that:
>     /// - `ptr` points to a valid instance of `T`.
>     /// - Until `T::release` is called, the returned `Owned<T>` exclusively owns the underlying `T`.
>     pub unsafe fn from_raw(ptr: NonNull<T>) -> Self {...}
> }
> 
> pub trait Ownable {
>     /// Tear down this `Ownable`.
>     ///
>     /// Implementers of `Ownable` can use this function to clean up the use of `Self`. This can
>     /// include freeing the underlying object.
>     ///
>     /// # Safety
>     ///
>     /// Callers must ensure that the caller has exclusive ownership of `T`, and this ownership can
>     /// be transferred to the `release` method.
>     unsafe fn release(&mut self);
> }
> 
> 
> Note `Ownable` not being an unsafe trait.

It looks ok but see my above reply.

> >> +/// A mutable reference to an owned `T`.
> >> +///
> >> +/// The [`Ownable`] is automatically freed or released when an instance of [`Owned`] is
> >> +/// dropped.
> >> +///
> >> +/// # Invariants
> >> +///
> >> +/// - The [`Owned<T>`] has exclusive access to the instance of `T`.
> >> +/// - The instance of `T` will stay alive at least as long as the [`Owned<T>`] is alive.
> >> +pub struct Owned<T: Ownable> {
> >> +    ptr: NonNull<T>,
> >> +}
> >
> > I think some more direct and less fuzzy invariants would be:
> >
> > - This `Owned<T>` holds permissions to call `T::release()` on the value once.
> > - Until `T::release()` is called, this `Owned<T>` may perform mutable access on the `T`.
> 
> I do not like the wording for mutable access. Formulating safety
> requirements for `from_raw` and safety comments for that function
> becomes convoluted like this. I'd rather formulate the
> access capability in terms of ownership;
> 
>  - Until `T::release()` is called, this `Owned<T>` exclusively owns the
>    underlying `T`.
> 
> How is that?
> 
> > - The `T` value is pinned.
> 
> I am unsure about the pinning terminology. If we say that `T` is pinned,
> does this mean that it will never move, even if `T: Unpin`? Or is it
> implied that `T` may move if it is `Unpin`?

Values that are `Unpin` can always move - pinning is a no-op for them.

Alice

